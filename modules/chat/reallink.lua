--[[
    Colors links in Battle.net whispers
    RealLinks by p3lim
 ]]

local _G = _G
local unpack = unpack
local select = select
local insert = insert
local split = split
local gsub = gsub
local gmatch = gmatch
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetCurrencyLink = GetCurrencyLink
local ConvertRGBtoColorString = ConvertRGBtoColorString
local ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local F = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local queuedMessages = {}

local function GetLinkColor(data)
    local type, arg1, arg2, arg3 = split(':', data)
    if type == 'item' then
        local _, _, quality = GetItemInfo(arg1)
        if quality then
            local _, _, _, color = GetItemQualityColor(quality)
            return '|c' .. color
        else
            return nil, true
        end
    elseif type == 'quest' then
        if arg2 then
            return ConvertRGBtoColorString(GetQuestDifficultyColor(arg2))
        else
            return '|cffffd100'
        end
    elseif type == 'currency' then
        local link = GetCurrencyLink(arg1)
        if link then
            return gsub(link, 0, 10)
        else
            return '|cffffffff'
        end
    elseif type == 'battlepet' then
        if arg3 ~= -1 then
            local _, _, _, color = GetItemQualityColor(arg3)
            return '|c' .. color
        else
            return '|cffffd200'
        end
    elseif type == 'garrfollower' then
        local _, _, _, color = GetItemQualityColor(arg2)
        return '|c' .. color
    elseif type == 'spell' then
        return '|cff71d5ff'
    elseif type == 'achievement' or type == 'garrmission' then
        return '|cffffff00'
    elseif type == 'trade' or type == 'enchant' then
        return '|cffffd000'
    elseif type == 'instancelock' then
        return '|cffff8000'
    elseif type == 'glyph' or type == 'journal' then
        return '|cff66bbff'
    elseif type == 'talent' or type == 'battlePetAbil' or type == 'garrfollowerability' then
        return '|cff4e96f7'
    elseif type == 'levelup' then
        return '|cffff4e00'
    else
        return '|cffffff00'
    end
end

function CHAT:LinkFilter(event, message, ...)
    for link, data in gmatch(message, '(|H(.-)|h.-|h)') do
        local color, queue = GetLinkColor(data)
        if queue then
            insert(queuedMessages, {self, event, message, ...})
            return true
        elseif color then
            local matchLink = '|H' .. data .. '|h.-|h'
            message = gsub(message, matchLink, color .. link .. '|r', 1)
        end
    end

    return false, message, ...
end

function CHAT:Link_OnEvent()
    if #queuedMessages > 0 then
        for index, data in next, queuedMessages do
            ChatFrame_MessageEventHandler(unpack(data))
            queuedMessages[index] = nil
        end
    end
end

function CHAT:RealLink()
    F:RegisterEvent('GET_ITEM_INFO_RECEIVED', CHAT.Link_OnEvent)

    ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', CHAT.LinkFilter)
    ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER_INFORM', CHAT.LinkFilter)
end
