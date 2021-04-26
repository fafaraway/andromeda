local _G = _G
local unpack = unpack
local select = select
local strmatch = strmatch
local gsub = gsub
local format = format

local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT
local debugMode = false

local msgList = {
    INSTANCE_RESET_SUCCESS = L['%s has been reset.'],
    INSTANCE_RESET_FAILED = L['Can not reset %s, there are players still inside the instance.'],
    INSTANCE_RESET_FAILED_ZONING = L['Can not reset %s, there are players in your party attempting to zone into an instance.'],
    INSTANCE_RESET_FAILED_OFFLINE = L['Can not reset %s, there are players offline in your party.'],
}

local function SendMessage(msg)
    if debugMode and C.IsDeveloper then
        print(msg)
    elseif IsPartyLFG() then
        SendChatMessage(msg, 'INSTANCE_CHAT')
    elseif IsInRaid() then
        SendChatMessage(msg, 'RAID')
    elseif IsInGroup() then
        SendChatMessage(msg, 'PARTY')
    end
end

local function AnnounceReset(text)
    for systemMessage, friendlyMessage in pairs(msgList) do
        systemMessage = _G[systemMessage]
        if (strmatch(text, gsub(systemMessage, '%%s', '.+'))) then
            local instance = strmatch(text, gsub(systemMessage, '%%s', '(.+)'))

            --ANNOUNCEMENT:SendMessage(format(friendlyMessage, instance), ANNOUNCEMENT:GetChannel())

            SendMessage(format(friendlyMessage, instance))
            return
        end
    end
end

function ANNOUNCEMENT:InstanceReset()
    if not C.DB.Announcement.Reset then
        return
    end

    F:RegisterEvent('CHAT_MSG_SYSTEM', function(event, text)
        AnnounceReset(text)
    end)
end
