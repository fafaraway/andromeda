local F, C = unpack(select(2, ...))
local module = F:GetModule('chat')

local LibItemGem = LibStub:GetLibrary('LibItemGem.7000')

-- @Author:M

local Caches = {}

local function GetHyperlink(Hyperlink, texture)
    if (not texture) then
        return Hyperlink
    else
        return '|T'..texture..':0|t' .. Hyperlink
    end
end


local function SetChatLinkIcon(Hyperlink)
    local schema, id = string.match(Hyperlink, '|H(%w+):(%d+):')
    local texture
    if (schema == 'item') then
        texture = select(10, GetItemInfo(tonumber(id)))
    elseif (schema == 'spell') then
        texture = select(3, GetSpellInfo(tonumber(id)))
    elseif (schema == 'achievement') then
        texture = select(10, GetAchievementInfo(tonumber(id)))
    end
    return GetHyperlink(Hyperlink, texture)
end


local function ChatItemLevel(Hyperlink)
    if (Caches[Hyperlink]) then
        return Caches[Hyperlink]
    end
    local link = string.match(Hyperlink, '|H(.-)|h')
    local name, _, _, _, _, class, subclass, _, equipSlot = GetItemInfo(link)
    local level = GetDetailedItemLevelInfo(link)
    local yes = true
    if (level) then
        if (equipSlot and string.find(equipSlot, 'INVTYPE_')) then
            level = format('%s(%s)', level, _G[equipSlot] or equipSlot)
        elseif (class == ARMOR) then
            level = format('%s(%s)', level, class)
        elseif (subclass and string.find(subclass, RELICSLOT)) then
            level = format('%s(%s)', level, RELICSLOT)
        else
            yes = false
        end
        if (yes) then
            local gem = ''
            local num, info = LibItemGem:GetItemGemInfo(link)
            for i = 1, num do
                gem = gem .. '|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t'
            end
            if (gem ~= '') then gem = gem..' ' end
            Hyperlink = Hyperlink:gsub('|h%[(.-)%]|h', '|h['..level..':'..name..']|h'..gem)
        end
        Caches[Hyperlink] = Hyperlink
    end
    return Hyperlink
end


local function filter(self, event, msg, ...)
    msg = msg:gsub('(|Hitem:%d+:.-|h.-|h)', ChatItemLevel)
    msg = msg:gsub('(|H%w+:%d+:.-|h.-|h)', SetChatLinkIcon)
    return false, msg, ...
end

function module:ItemLinkLevel()
    if not C.chat.itemLinkLevel then return end
    ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER_INFORM', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_GUILD', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BATTLEGROUND', filter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_LOOT', filter)
end



