local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT

local msgList = {
	INSTANCE_RESET_SUCCESS = L.ANNOUNCEMENT.RESET_SUCCESS,
	INSTANCE_RESET_FAILED = L.ANNOUNCEMENT.RESET_FAILED,
	INSTANCE_RESET_FAILED_ZONING = L.ANNOUNCEMENT.RESET_FAILED_ZONING,
	INSTANCE_RESET_FAILED_OFFLINE = L.ANNOUNCEMENT.RESET_FAILED_OFFLINE
}

local function announceReset(text)
	for systemMessage, friendlyMessage in pairs(msgList) do
		systemMessage = _G[systemMessage]
		if (strmatch(text, gsub(systemMessage, '%%s', '.+'))) then
			local instance = strmatch(text, gsub(systemMessage, '%%s', '(.+)'))

			ANNOUNCEMENT:SendMessage(format(friendlyMessage, instance), ANNOUNCEMENT:GetChannel())

			return
		end
	end
end

function ANNOUNCEMENT:InstanceReset()
	if not C.DB.Announcement.Reset then
		return
	end

	F:RegisterEvent(
		'CHAT_MSG_SYSTEM',
		function(event, text)
			announceReset(text)
		end
	)
end
