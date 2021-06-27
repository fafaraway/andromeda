local _G = _G
local unpack = unpack
local select = select
local ipairs = ipairs
local pairs = pairs
local tremove = tremove
local min = min
local max = max
local gsub = gsub
local strfind = strfind
local strrep = strrep
local Ambiguate = Ambiguate
local IsGuildMember = IsGuildMember
local IsGUIDInGroup = IsGUIDInGroup
local GetTime = GetTime
local SetCVar = SetCVar
local GetCVarBool = GetCVarBool
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local GetRealmName = GetRealmName
local GetItemInfo = GetItemInfo
local hooksecurefunc = hooksecurefunc
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local C_FriendList_IsFriend = C_FriendList.IsFriend
local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local BN_TOAST_TYPE_CLUB_INVITATION = BN_TOAST_TYPE_CLUB_INVITATION or 6

local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

-- Filter Chat symbols
local msgSymbols = {'`', '～', '＠', '＃', '^', '＊', '！', '？', '。', '|', ' ', '—', '——', '￥', '’', '‘', '“', '”', '【', '】', '『', '』', '《', '》', '〈', '〉', '（', '）', '〔', '〕', '、', '，', '：', ',', '_', '/', '~'}

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
            this[j + 1] = (sA[i] == sB[j]) and last[j] or (min(last[j + 1], this[j], last[j]) + 1)
        end
        for j = 0, len_b do
            last[j + 1] = this[j + 1]
        end
    end
    return this[len_b + 1] / max(len_a, len_b)
end

C.BadBoys = {} -- debug
local chatLines, prevLineID, filterResult = {}, 0, false

function CHAT:GetFilterResult(event, msg, name, flag, guid)
    if name == C.MyName or (event == 'CHAT_MSG_WHISPER' and flag == 'GM') or flag == 'DEV' then
        return
    elseif guid and (IsGuildMember(guid) or C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or IsGUIDInGroup(guid)) then
        return
    end

    -- Block strangers
    if C.DB.Chat.BlockStrangerWhisper and event == 'CHAT_MSG_WHISPER' then
        CHAT.MuteThisTime = true
        return true
    end

    if C.DB.Chat.BlockSpammer and C.BadBoys[name] and C.BadBoys[name] >= 5 then
        return true
    end

    local filterMsg = gsub(msg, '|H.-|h(.-)|h', '%1')
    filterMsg = gsub(filterMsg, '|c%x%x%x%x%x%x%x%x', '')
    filterMsg = gsub(filterMsg, '|r', '')

    -- Trash Filter
    for _, symbol in ipairs(msgSymbols) do
        filterMsg = gsub(filterMsg, symbol, '')
    end

    if event == 'CHAT_MSG_CHANNEL' then
        local matches = 0
        local found
        for keyword in pairs(WhiteFilterList) do
            if keyword ~= '' then
                found = true
                local _, count = gsub(filterMsg, keyword, '')
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
            local _, count = gsub(filterMsg, keyword, '')
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
            tremove(chatLines, i)
            return true
        end
    end
    if chatLinesSize >= 30 then
        tremove(chatLines, 1)
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

    ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateChatFilter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateChatFilter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.UpdateChatFilter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateChatFilter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.UpdateChatFilter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_TEXT_EMOTE', self.UpdateChatFilter)
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
    strrep('%-', 20),
    '<小队物品等级:.+>',
    '<LFG>',
    '进度:',
    '属性通报',
    '汐寒',
    'wow.+兑换码',
    'wow.+验证码',
    '【有爱插件】',
    '：.+>',
    '|Hspell.+=>'
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
        if strfind(msg, word) then
            if event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' then
                CHAT:ToggleChatBubble()
            elseif event == 'CHAT_MSG_PARTY' or event == 'CHAT_MSG_PARTY_LEADER' then
                CHAT:ToggleChatBubble(true)
            elseif event == 'CHAT_MSG_WHISPER' then
                CHAT.MuteThisTime = true
            end
            return true
        end
    end
end

function CHAT:BlockAddonSpam()
    if not C.DB.Chat.BlockAddonSpam then
        return
    end

    ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', CHAT.UpdateAddOnBlocker)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', CHAT.UpdateAddOnBlocker)
end

-- Block trash clubs
local trashClubs = {'站桩', '致敬我们', '我们一起玩游戏', '部落大杂烩', '小号提升'}
function CHAT:CheckClubName()
    if self.toastType == BN_TOAST_TYPE_CLUB_INVITATION then
        local text = self.DoubleLine:GetText() or ''
        for _, name in pairs(trashClubs) do
            if strfind(text, name) then
                self:Hide()
                return
            end
        end
    end
end

function CHAT:BlockTrashClub()
    hooksecurefunc(_G.BNToastFrame, 'ShowToast', CHAT.CheckClubName)
end

--[[
    '0', 'None',
    '1', 'Common',
    '2', 'Uncommon',
    '3', 'Rare',
    '4', 'Epic',
    '5', 'Legendary',
    '6', 'Artifact',
    '7', 'Heirloom',
    '8', 'All'
]]

local activeplayer = (tostring(UnitName('player')) .. '-' .. tostring(GetRealmName()))

function CHAT:CheckLoot(event, msg, looter)
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

    ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', self.CheckLoot)
end

function CHAT:ChatFilter()
    CHAT:SpamFilter()
    CHAT:BlockAddonSpam()
    CHAT:BlockTrashClub()
    CHAT:ExtendItemLink()
    CHAT:GroupLootFilter()
    CHAT:DamageMeterFilter()
end
