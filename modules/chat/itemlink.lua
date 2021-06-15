local _G = _G
local unpack = unpack
local select = select
local strmatch = strmatch
local strrep = strrep
local gsub = gsub
local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats

local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local function isItemHasLevel(link)
    local name, _, rarity, level, _, _, _, _, _, _, _, classID = GetItemInfo(link)
    if name and level and rarity > 1 and (classID == _G.LE_ITEM_CLASS_WEAPON or classID == _G.LE_ITEM_CLASS_ARMOR) then
        local itemLevel = F:GetItemLevel(link)
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

local function isItemHasGem(link)
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
    local slotType
    local type = select(6, GetItemInfo(link))

    if type == _G.WEAPON then
        local equipLoc = select(9, GetItemInfo(link))
        if equipLoc ~= '' then
            local weaponType = select(7, GetItemInfo(link))
            slotType = weaponType or _G[equipLoc]
        end
    elseif type == _G.ARMOR then
        local equipLoc = select(9, GetItemInfo(link))
        if equipLoc ~= '' then
            if armorType[equipLoc] then
                local armorType = select(7, GetItemInfo(link))
                slotType = armorType .. ' ' .. (_G[equipLoc])
            else
                slotType = _G[equipLoc]
            end
        end
    end

    return slotType
end

local itemCache = {}
local function convertItemLevel(link)
    if itemCache[link] then
        return itemCache[link]
    end

    local itemLink = strmatch(link, '|Hitem:.-|h')
    if itemLink then
        local slotType = GetSlotType(itemLink)
        local name, itemLevel = isItemHasLevel(itemLink)
        if name and itemLevel then
            if slotType then
                link = gsub(link, '|h%[(.-)%]|h', '|h[' .. name .. ' (' .. slotType .. ' ' .. itemLevel .. ')]|h' .. isItemHasGem(itemLink))
            else
                link = gsub(link, '|h%[(.-)%]|h', '|h[' .. name .. ' (' .. itemLevel .. ')]|h' .. isItemHasGem(itemLink))
            end
            itemCache[link] = link
        end
    end
    return link
end

function CHAT:UpdateChatItemLevel(_, msg, ...)
    msg = gsub(msg, '(|Hitem:%d+:.-|h.-|h)', convertItemLevel)
    return false, msg, ...
end



function CHAT:ExtendItemLink()
    if not C.DB.Chat.ExtendItemLink then
        return
    end

    ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_GUILD', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BATTLEGROUND', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', self.UpdateChatItemLevel)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', self.UpdateChatItemLevel)
end
