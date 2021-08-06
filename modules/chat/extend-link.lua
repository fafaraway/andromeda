local _G = _G
local unpack = unpack
local select = select
local format = format
local strmatch = strmatch
local strrep = strrep
local gsub = gsub
local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats
local GetItemIcon = GetItemIcon
local GetSpellTexture = GetSpellTexture
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetTalentInfoByID = GetTalentInfoByID
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local iconStr = ' |T%s:14:16:0:0:64:64:4:60:7:57'

local function IsItemHasLevel(link)
    local name, _, rarity, level, _, _, _, _, _, _, _, classID = GetItemInfo(link)
    if name and level and rarity > 1 and (classID == _G.LE_ITEM_CLASS_WEAPON or classID == _G.LE_ITEM_CLASS_ARMOR) then
        local itemLevel = F.GetItemLevel(link)
        return name, itemLevel
    end
end

local socketWatchList = {
    ['BLUE'] = true,
    ['RED'] = true,
    ['YELLOW'] = true,
    ['COGWHEEL'] = true,
    ['HYDRAULIC'] = true,
    ['META'] = true,
    ['PRISMATIC'] = true,
    ['PUNCHCARDBLUE'] = true,
    ['PUNCHCARDRED'] = true,
    ['PUNCHCARDYELLOW'] = true,
    ['DOMINATION'] = true
}

local function GetSocketTexture(socket, count)
    return strrep('|TInterface\\ItemSocketingFrame\\UI-EmptySocket-' .. socket .. ':0|t', count)
end

local function IsItemHasGem(link)
    local text = ''
    local stats = GetItemStats(link)
    for stat, count in pairs(stats) do
        local socket = strmatch(stat, 'EMPTY_SOCKET_(%S+)')
        if socket and socketWatchList[socket] then
            text = text .. GetSocketTexture(socket, count)
        end
    end
    return text
end

local armorType = {
    INVTYPE_HEAD = true,
    INVTYPE_SHOULDER = true,
    INVTYPE_CHEST = true,
    INVTYPE_WRIST = true,
    INVTYPE_HAND = true,
    INVTYPE_WAIST = true,
    INVTYPE_LEGS = true,
    INVTYPE_FEET = true
}

local function GetSlotType(link)
    local id = strmatch(link, 'Hitem:(%d-):')
    if not id then
        return
    end
    id = tonumber(id)

    local slotType
    local type = select(6, GetItemInfo(id))

    if type == _G.WEAPON then
        local equipLoc = select(9, GetItemInfo(id))
        if equipLoc ~= '' then
            local weaponType = select(7, GetItemInfo(id))
            slotType = weaponType or _G[equipLoc]
        end
    elseif type == _G.ARMOR then
        local equipLoc = select(9, GetItemInfo(id))
        if equipLoc ~= '' then
            if armorType[equipLoc] then
                local armorType = select(7, GetItemInfo(id))
                slotType = armorType .. ' ' .. (_G[equipLoc])
            else
                slotType = _G[equipLoc]
            end
        end
    end

    return slotType
end

local itemCache = {}
local function AddItemInfo(link)
    if itemCache[link] then
        return itemCache[link]
    end

    local itemLink = strmatch(link, '|Hitem:.-|h')
    if not itemLink then
        return
    end

    local slotType = GetSlotType(itemLink)
    local name, itemLevel = IsItemHasLevel(itemLink)
    if name and itemLevel then
        if slotType then
            link = gsub(link, '|h%[(.-)%]|h', '|h[' .. name .. ' (' .. slotType .. ' ' .. itemLevel .. ')]|h' .. IsItemHasGem(itemLink))
        else
            link = gsub(link, '|h%[(.-)%]|h', '|h[' .. name .. ' (' .. itemLevel .. ')]|h' .. IsItemHasGem(itemLink))
        end
        itemCache[link] = link
    end

    local texture = GetItemIcon(itemLink)
    local icon = format(iconStr .. ':255:255:255|t', texture)
    link = icon .. ' ' .. link

    return link
end

local function AddSpellInfo(Hyperlink)
    local id = strmatch(Hyperlink, 'Hspell:(%d-):')
    if not id then
        return
    end

    local texture = GetSpellTexture(tonumber(id))
    local icon = format(iconStr .. ':255:255:255|t', texture)
    Hyperlink = icon .. ' |cff71d5ff' .. Hyperlink .. '|r'

    return Hyperlink
end

local function AddEnchantInfo(Hyperlink)
    local id = strmatch(Hyperlink, 'Henchant:(%d-)\124')
    if not id then
        return
    end

    local texture = GetSpellTexture(tonumber(id))
    local icon = format(iconStr .. ':255:255:255|t', texture)
    Hyperlink = icon .. ' ' .. Hyperlink

    return Hyperlink
end

local function AddPvPTalentInfo(Hyperlink)
    local id = strmatch(Hyperlink, 'Hpvptal:(%d-)|')
    if not id then
        return
    end

    local texture = select(3, GetPvpTalentInfoByID(tonumber(id)))
    local icon = format(iconStr .. ':255:255:255|t', texture)
    Hyperlink = icon .. ' ' .. Hyperlink

    return Hyperlink
end

local function AddTalentInfo(Hyperlink)
    local id = strmatch(Hyperlink, 'Htalent:(%d-)|')
    if not id then
        return
    end

    local texture = select(3, GetTalentInfoByID(tonumber(id)))
    local icon = format(iconStr .. ':255:255:255|t', texture)
    Hyperlink = icon .. ' ' .. Hyperlink

    return Hyperlink
end

function CHAT:ReplaceLinks(event, msg, ...)
    msg = gsub(msg, '(|Hitem:%d+:.-|h.-|h)', AddItemInfo)
    msg = gsub(msg, '(|Hspell:%d+:%d+|h.-|h)', AddSpellInfo)
    msg = gsub(msg, '(|Henchant:%d+|h.-|h)', AddEnchantInfo)
    msg = gsub(msg, '(|Htalent:%d+|h.-|h)', AddTalentInfo)
    msg = gsub(msg, '(|Hpvptal:%d+|h.-|h)', AddPvPTalentInfo)

    return false, msg, ...
end

function CHAT:ExtendLink()
    if not C.DB.Chat.ExtendLink then
        return
    end

    ChatFrame_AddMessageEventFilter('CHAT_MSG_ACHIEVEMENT', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BATTLEGROUND', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_COMMUNITIES_CHANNEL', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_GUILD', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_OFFICER', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_TRADESKILLS', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', self.ReplaceLinks)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.ReplaceLinks)
end
