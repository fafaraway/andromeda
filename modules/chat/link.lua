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
    'CHAT_MSG_LOOT',
    'CHAT_MSG_CURRENCY'
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
local function GetHyperlink(hyperlink, texture)
    if (not texture) then
        return hyperlink
    else
        return ' |T' .. texture .. ':14|t ' .. hyperlink
    end
end

local cache = {}
local function AddChatIcon(link, linkType, id)
    if not link then
        return
    end

    if cache[link] then
        return cache[link]
    end

    local texture
    if linkType == 'spell' or linkType == 'enchant' then
        texture = GetSpellTexture(id)
    elseif linkType == 'item' or linkType == 'keystone' then
        texture = GetItemIcon(id)
    elseif linkType == 'talent' then
        texture = select(3, GetTalentInfoByID(id))
    elseif linkType == 'pvptal' then
        texture = select(3, GetPvpTalentInfoByID(id))
    elseif linkType == 'achievement' then
        texture = select(10, GetAchievementInfo(id))
    elseif linkType == 'currency' then
        local info = C_CurrencyInfo.GetCurrencyInfo(id)
        texture = info and info.iconFileID
    elseif linkType == 'battlepet' then
        texture = select(2, C_PetJournal.GetPetInfoBySpeciesID(id))
    elseif linkType == 'battlePetAbil' then
        texture = select(3, C_PetBattles.GetAbilityInfoByID(id))
    elseif linkType == 'azessence' then
        local info = C_AzeriteEssence.GetEssenceInfo(id)
        texture = info and info.icon
    elseif linkType == 'conduit' then
        local spell = C_Soulbinds.GetConduitSpellID(id, 1)
        texture = spell and GetSpellTexture(spell)
    elseif linkType == 'transmogappearance' then
        texture = select(4, C_TransmogCollection.GetAppearanceSourceInfo(id))
    elseif linkType == 'transmogillusion' then
        local info = C_TransmogCollection.GetIllusionInfo(id)
        texture = info and info.icon
    end

    cache[link] = GetHyperlink(link, texture)

    return cache[link]
end

local function AddTradeIcon(link, id)
    if not link then
        return
    end

    if not cache[link] then
        cache[link] = GetHyperlink(link, GetSpellTexture(id))
    end

    return cache[link]
end

function CHAT:UpdateLinkIcon(_, msg, ...)
    msg = string.gsub(msg, '(|c%x%x%x%x%x%x%x%x.-|H(%a+):(%d+).-|h.-|h.-|r)', AddChatIcon)
    msg = string.gsub(msg, '(|c%x%x%x%x%x%x%x%x.-|Htrade:[^:]-:(%d+).-|h.-|h.-|r)', AddTradeIcon)

    return false, msg, ...
end

function CHAT:AddLinkIcon()
    for _, event in pairs(events) do
        _G.ChatFrame_AddMessageEventFilter(event, CHAT.UpdateLinkIcon)
    end
end

function CHAT:ExtendLink()
    if not C.DB.Chat.ExtendLink then
        return
    end

    GetDungeonScoreInColor = TOOLTIP.GetDungeonScore

    CHAT:AddItemLevel()
    CHAT:AddLinkIcon()
end
