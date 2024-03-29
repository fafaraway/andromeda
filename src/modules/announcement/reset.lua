local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F:GetModule('Announcement')

local msgList = {
    INSTANCE_RESET_SUCCESS = L['%s has been reset.'],
    INSTANCE_RESET_FAILED = L['Can not reset %s, there are players still inside the instance.'],
    INSTANCE_RESET_FAILED_ZONING = L['Can not reset %s, there are players in your party attempting to zone into an instance.'],
    INSTANCE_RESET_FAILED_OFFLINE = L['Can not reset %s, there are players offline in your party.'],
}

local function SendMessage(msg)
    if IsPartyLFG() then
        SendChatMessage(msg, 'INSTANCE_CHAT')
    elseif IsInRaid() then
        SendChatMessage(msg, 'RAID')
    elseif IsInGroup() then
        SendChatMessage(msg, 'PARTY')
    end
end

local function InstanceReset(_, text)
    for systemMessage, friendlyMessage in pairs(msgList) do
        systemMessage = _G[systemMessage]
        if strmatch(text, gsub(systemMessage, '%%s', '.+')) then
            local instance = strmatch(text, gsub(systemMessage, '%%s', '(.+)'))

            SendMessage(format(friendlyMessage, instance))

            return
        end
    end
end

function ANNOUNCEMENT:AnnounceReset()
    if not C.DB.Announcement.Reset then
        return
    end

    F:RegisterEvent('CHAT_MSG_SYSTEM', InstanceReset)
end
