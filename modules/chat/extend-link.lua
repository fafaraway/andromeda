local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')
local TOOLTIP = F:GetModule('Tooltip')

local events = {
    'CHAT_MSG_BATTLEGROUND',
    'CHAT_MSG_BATTLEGROUND_LEADER',
    'CHAT_MSG_BN_WHISPER',
    'CHAT_MSG_BN_WHISPER_INFORM',
    'CHAT_MSG_CHANNEL',
    'CHAT_MSG_GUILD',
    'CHAT_MSG_INSTANCE_CHAT',
    'CHAT_MSG_INSTANCE_CHAT_LEADER',
    'CHAT_MSG_OFFICER',
    'CHAT_MSG_PARTY',
    'CHAT_MSG_PARTY_LEADER',
    'CHAT_MSG_RAID',
    'CHAT_MSG_RAID_LEADER',
    'CHAT_MSG_RAID_WARNING',
    'CHAT_MSG_SAY',
    'CHAT_MSG_WHISPER',
    'CHAT_MSG_WHISPER_INFORM',
    'CHAT_MSG_YELL',
    'CHAT_MSG_LOOT'
}

-- item level and gem
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
    return string.rep('|TInterface\\ItemSocketingFrame\\UI-EmptySocket-' .. socket .. ':0|t', count)
end

local function IsItemHasGem(link)
    local text = ''
    local stats = GetItemStats(link)
    for stat, count in pairs(stats) do
        local socket = string.match(stat, 'EMPTY_SOCKET_(%S+)')
        if socket and socketWatchList[socket] then
            text = text .. GetSocketTexture(socket, count)
        end
    end
    return text
end

local itemCache, GetDungeonScoreInColor = {}

function CHAT.ReplaceChatHyperlink(link, linkType, value)
    if not link then
        return
    end

    if linkType == 'item' then
        if itemCache[link] then
            return itemCache[link]
        end
        local name, itemLevel = IsItemHasLevel(link)
        if name and itemLevel then
            link = string.gsub(link, '|h%[(.-)%]|h', '|h[' .. name .. '(' .. itemLevel .. ')]|h' .. IsItemHasGem(link))
            itemCache[link] = link
        end
        return link
    elseif linkType == 'dungeonScore' then
        return value and string.gsub(link, '|h%[(.-)%]|h', '|h[' .. string.format(L['MythicScore'], GetDungeonScoreInColor(value)) .. ']|h')
    end
end

function CHAT:UpdateItemLevel(_, msg, ...)
    msg = string.gsub(msg, '(|H([^:]+):(%d+):.-|h.-|h)', CHAT.ReplaceChatHyperlink)
    return false, msg, ...
end

function CHAT:AddItemLevel()
    for _, event in pairs(events) do
        _G.ChatFrame_AddMessageEventFilter(event, CHAT.UpdateItemLevel)
    end
end

-- icon for item/spell/achievement
local function GetHyperlink(Hyperlink, texture)
    if (not texture) then
        return Hyperlink
    else
        return ' |T' .. texture .. ':12:14:0:0:64:64:5:59:5:59|t ' .. Hyperlink
    end
end

local function AddChatIcon(Hyperlink)
    local schema, id = string.match(Hyperlink, '|H(%w+):(%d+):')
    if not id then
        return
    end

    local texture
    if schema == 'item' then
        texture = select(10, GetItemInfo(tonumber(id)))
    elseif schema == 'spell' then
        texture = select(3, GetSpellInfo(tonumber(id)))
    elseif schema == 'achievement' then
        texture = select(10, GetAchievementInfo(tonumber(id)))
    end

    return GetHyperlink(Hyperlink, texture)
end

local function AddEnchantIcon(Hyperlink)
    local id = string.match(Hyperlink, 'Henchant:(%d-)|')
    if not id then
        return
    end

    return GetHyperlink(Hyperlink, GetSpellTexture(tonumber(id)))
end

local function AddTalentIcon(Hyperlink)
    local schema, id = string.match(Hyperlink, 'H(%w+):(%d-)|')
    if not id then
        return
    end

    local texture
    if schema == 'talent' then
        texture = select(3, GetTalentInfoByID(tonumber(id)))
    elseif schema == 'pvptal' then
        texture = select(3, GetPvpTalentInfoByID(tonumber(id)))
    end

    return GetHyperlink(Hyperlink, texture)
end

local function AddTradeIcon(Hyperlink)
    local id = string.match(Hyperlink, 'Htrade:[^:]-:(%d+)')
    if not id then
        return
    end

    return GetHyperlink(Hyperlink, GetSpellTexture(tonumber(id)))
end

function CHAT:UpdateLinkIcon(_, msg, ...)
    msg = string.gsub(msg, '(|H%w+:%d+:.-|h.-|h)', AddChatIcon)
    msg = string.gsub(msg, '(|Henchant:%d+|h.-|h)', AddEnchantIcon)
    msg = string.gsub(msg, '(|H%w+:%d+|h.-|h)', AddTalentIcon)
    msg = string.gsub(msg, '(|Htrade:.+:%d+|h.-|h)', AddTradeIcon)

    return false, msg, ...
end

function CHAT:AddLinkIcon()
    for _, event in pairs(events) do
        _G.ChatFrame_AddMessageEventFilter(event, CHAT.UpdateLinkIcon)
    end

    -- fix send message
    hooksecurefunc(
        'ChatEdit_OnTextChanged',
        function(self, userInput)
            local text = self:GetText()
            if userInput then
                local newText, count = string.gsub(text, '|T.+|t', '')
                if count > 0 then
                    self:SetText(newText)
                end
            end
        end
    )
end

function CHAT:ExtendLink()
    if not C.DB.Chat.ExtendLink then
        return
    end

    GetDungeonScoreInColor = TOOLTIP.GetDungeonScore

    CHAT:AddItemLevel()
    CHAT:AddLinkIcon()
end
