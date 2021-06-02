local _G = _G
local unpack = unpack
local select = select
local strmatch = strmatch
local gsub = gsub
local format = format
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage

local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F:GetModule('Announcement')

local debugMode = false

local msgList = {
    INSTANCE_RESET_SUCCESS = L['%s has been reset.'],
    INSTANCE_RESET_FAILED = L['Can not reset %s, there are players still inside the instance.'],
    INSTANCE_RESET_FAILED_ZONING = L['Can not reset %s, there are players in your party attempting to zone into an instance.'],
    INSTANCE_RESET_FAILED_OFFLINE = L['Can not reset %s, there are players offline in your party.'],
}

local function SendMessage(msg)
    if debugMode and C.IsDeveloper then
        F:Debug(msg)
    elseif IsPartyLFG() then
        SendChatMessage(msg, 'INSTANCE_CHAT')
    elseif IsInRaid() then
        SendChatMessage(msg, 'RAID')
    elseif IsInGroup() then
        SendChatMessage(msg, 'PARTY')
    end
end

local function InstanceReset(text)
    for systemMessage, friendlyMessage in pairs(msgList) do
        systemMessage = _G[systemMessage]
        if (strmatch(text, gsub(systemMessage, '%%s', '.+'))) then
            local instance = strmatch(text, gsub(systemMessage, '%%s', '(.+)'))

            SendMessage(format(friendlyMessage, instance))

            return
        end
    end
end

local function OnEvent(event, text)
    InstanceReset(text)
end

function ANNOUNCEMENT:AnnounceReset()
    if not C.DB.Announcement.Reset then
        return
    end

    F:RegisterEvent('CHAT_MSG_SYSTEM', OnEvent)
end
