local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local BN_TOAST_TYPE_CLUB_INVITATION = _G.BN_TOAST_TYPE_CLUB_INVITATION or 6

-- Filter Chat symbols
local msgSymbols = {
    '`',
    '～',
    '＠',
    '＃',
    '^',
    '＊',
    '！',
    '？',
    '。',
    '|',
    ' ',
    '—',
    '——',
    '￥',
    '’',
    '‘',
    '“',
    '”',
    '【',
    '】',
    '『',
    '』',
    '《',
    '》',
    '〈',
    '〉',
    '（',
    '）',
    '〔',
    '〕',
    '、',
    '，',
    '：',
    ',',
    '_',
    '/',
    '~'
}

local FilterList = {}
function CHAT:UpdateFilterList()
    F:SplitList(FilterList, _G.FREE_ADB.ChatFilterBlackList, true)
end

local WhiteFilterList = {}
function CHAT:UpdateFilterWhiteList()
    F:SplitList(WhiteFilterList, _G.FREE_ADB.ChatFilterWhiteList, true)
end

-- ECF strings compare
local last, this = {}, {}
function CHAT:CompareStrDiff(sA, sB) -- arrays of bytes
    local len_a, len_b = #sA, #sB
    for j = 0, len_b do
        last[j + 1] = j
    end
    for i = 1, len_a do
        this[1] = i
        for j = 1, len_b do
            this[j + 1] = (sA[i] == sB[j]) and last[j] or (math.min(last[j + 1], this[j], last[j]) + 1)
        end
        for j = 0, len_b do
            last[j + 1] = this[j + 1]
        end
    end
    return this[len_b + 1] / math.max(len_a, len_b)
end

C.BadBoys = {} -- debug
local chatLines, prevLineID, filterResult = {}, 0, false

function CHAT:GetFilterResult(event, msg, name, flag, guid)
    if name == C.NAME or (event == 'CHAT_MSG_WHISPER' and flag == 'GM') or flag == 'DEV' then
        return
    elseif guid and (IsGuildMember(guid) or C_BattleNet.GetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) or IsGUIDInGroup(guid)) then
        return
    end

    -- Block strangers
    if C.DB.Chat.BlockStrangerWhisper and event == 'CHAT_MSG_WHISPER' then
        CHAT.MuteCache[name] = GetTime()
        return true
    end

    if C.DB.Chat.BlockSpammer and C.BadBoys[name] and C.BadBoys[name] >= 5 then
        return true
    end

    local filterMsg = string.gsub(msg, '|H.-|h(.-)|h', '%1')
    filterMsg = string.gsub(filterMsg, '|c%x%x%x%x%x%x%x%x', '')
    filterMsg = string.gsub(filterMsg, '|r', '')

    -- Trash Filter
    for _, symbol in ipairs(msgSymbols) do
        filterMsg = string.gsub(filterMsg, symbol, '')
    end

    if event == 'CHAT_MSG_CHANNEL' then
        local matches = 0
        local found
        for keyword in pairs(WhiteFilterList) do
            if keyword ~= '' then
                found = true
                local _, count = string.gsub(filterMsg, keyword, '')
                if count > 0 then
                    matches = matches + 1
                end
            end
        end
        if matches == 0 and found then
            return 0
        end
    end

    local matches = 0
    for keyword in pairs(FilterList) do
        if keyword ~= '' then
            local _, count = string.gsub(filterMsg, keyword, '')
            if count > 0 then
                matches = matches + 1
            end
        end
    end

    if matches >= C.DB.Chat.Matches then
        return true
    end

    -- ECF Repeat Filter
    local msgTable = {name, {}, GetTime()}
    if filterMsg == '' then
        filterMsg = msg
    end
    for i = 1, #filterMsg do
        msgTable[2][i] = filterMsg:byte(i)
    end
    local chatLinesSize = #chatLines
    chatLines[chatLinesSize + 1] = msgTable
    for i = 1, chatLinesSize do
        local line = chatLines[i]
        if line[1] == msgTable[1] and ((event == 'CHAT_MSG_CHANNEL' and msgTable[3] - line[3] < .6) or CHAT:CompareStrDiff(line[2], msgTable[2]) <= .1) then
            table.remove(chatLines, i)
            return true
        end
    end
    if chatLinesSize >= 30 then
        table.remove(chatLines, 1)
    end
end

function CHAT:UpdateChatFilter(event, msg, author, _, _, _, flag, _, _, _, _, lineID, guid)
    if lineID ~= prevLineID then
        prevLineID = lineID

        local name = Ambiguate(author, 'none')
        filterResult = CHAT:GetFilterResult(event, msg, name, flag, guid)
        if filterResult and filterResult ~= 0 then
            C.BadBoys[name] = (C.BadBoys[name] or 0) + 1
        end
        if filterResult == 0 then
            filterResult = true
        end
    end

    return filterResult
end

function CHAT:SpamFilter()
    if not C.DB.Chat.SpamFilter then
        return
    end

    CHAT:UpdateFilterList()
    CHAT:UpdateFilterWhiteList()

    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateChatFilter)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateChatFilter)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.UpdateChatFilter)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateChatFilter)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.UpdateChatFilter)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_TEXT_EMOTE', self.UpdateChatFilter)
end

-- Block addon msg
local addonBlockList = {
    '任务进度提示',
    '%[接受任务%]',
    '%(任务完成%)',
    '<大脚',
    '【爱不易】',
    'EUI[:_]',
    '打断:.+|Hspell',
    'PS 死亡: .+>',
    '%*%*.+%*%*',
    '<iLvl>',
    string.rep('%-', 20),
    '<小队物品等级:.+>',
    '<LFG>',
    '进度:',
    '属性通报',
    '汐寒',
    'wow.+兑换码',
    'wow.+验证码',
    '【有爱插件】',
    '：.+>',
    '|Hspell.+=>',
    '<EH>'
}

local cvar
local function toggleCVar(value)
    value = tonumber(value) or 1
    SetCVar(cvar, value)
end

function CHAT:ToggleChatBubble(party)
    cvar = 'chatBubbles' .. (party and 'Party' or '')
    if not GetCVarBool(cvar) then
        return
    end
    toggleCVar(0)
    F:Delay(.01, toggleCVar)
end

function CHAT:UpdateAddOnBlocker(event, msg, author)
    local name = Ambiguate(author, 'none')
    if UnitIsUnit(name, 'player') then
        return
    end

    for _, word in ipairs(addonBlockList) do
        if string.find(msg, word) then
            if event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' then
                CHAT:ToggleChatBubble()
            elseif event == 'CHAT_MSG_PARTY' or event == 'CHAT_MSG_PARTY_LEADER' then
                CHAT:ToggleChatBubble(true)
            elseif event == 'CHAT_MSG_WHISPER' then
                CHAT.MuteCache[name] = GetTime()
            end
            return true
        end
    end
end

function CHAT:BlockAddonSpam()
    if not C.DB.Chat.BlockAddonSpam then
        return
    end

    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', CHAT.UpdateAddOnBlocker)
    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', CHAT.UpdateAddOnBlocker)
end

-- Block trash clubs
local trashClubs = {'站桩', '致敬我们', '我们一起玩游戏', '部落大杂烩', '小号提升'}
function CHAT:CheckClubName()
    if self.toastType == BN_TOAST_TYPE_CLUB_INVITATION then
        local text = self.DoubleLine:GetText() or ''
        for _, name in pairs(trashClubs) do
            if string.find(text, name) then
                self:Hide()
                return
            end
        end
    end
end

function CHAT:BlockTrashClub()
    hooksecurefunc(_G.BNToastFrame, 'ShowToast', CHAT.CheckClubName)
end

-- Filter loot info from group members
-- '0', 'None',
-- '1', 'Common',
-- '2', 'Uncommon',
-- '3', 'Rare',
-- '4', 'Epic',
-- '5', 'Legendary',
-- '6', 'Artifact',
-- '7', 'Heirloom',
-- '8', 'All'
local activeplayer = (tostring(UnitName('player')) .. '-' .. tostring(GetRealmName()))
function CHAT:CheckLoot(_, msg, looter)
    local itemID, itemRarity
    itemID = msg:match('item:(%d+):')

    if itemID and GetItemInfo(itemID) then
        itemRarity = select(3, GetItemInfo(itemID))
        if itemRarity and (itemRarity < C.DB.Chat.GroupLootThreshold) and (looter ~= activeplayer) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function CHAT:GroupLootFilter()
    if not C.DB.Chat.GroupLootFilter then
        return
    end

    _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', self.CheckLoot)
end

-- Filter azerite message on island expeditions
local AZERITE_STR = _G.ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub('%%d/%%d ', '')
local function filterAzeriteGain(_, _, msg)
    if string.find(msg, AZERITE_STR) then
        return true
    end
end

local function IsPlayerOnIslands()
    local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
    if instanceType == 'scenario' and (maxPlayers == 3 or maxPlayers == 6) then
        _G.ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
    else
        _G.ChatFrame_RemoveMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
    end
end

function CHAT:AzeriteMessageFilter()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', IsPlayerOnIslands)
end

function CHAT:ChatFilter()
    CHAT:SpamFilter()
    CHAT:BlockAddonSpam()
    CHAT:BlockTrashClub()
    CHAT:ExtendLink()
    CHAT:GroupLootFilter()
    CHAT:AzeriteMessageFilter()
    CHAT:DamageMeterFilter()
end
