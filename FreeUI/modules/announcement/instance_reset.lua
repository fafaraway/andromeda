local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


local msgList = {
	INSTANCE_RESET_SUCCESS = L['ANNOUNCEMENT_INSTANCE_RESET_SUCCESS'],
	INSTANCE_RESET_FAILED = L['ANNOUNCEMENT_INSTANCE_RESET_FAILED'],
	INSTANCE_RESET_FAILED_ZONING = L['ANNOUNCEMENT_INSTANCE_RESET_FAILED_ZONING'],
	INSTANCE_RESET_FAILED_OFFLINE = L['ANNOUNCEMENT_INSTANCE_RESET_FAILED_OFFLINE']
}

local function InstanceReset(text)
	for systemMessage, friendlyMessage in pairs(msgList) do
		systemMessage = _G[systemMessage]
		if (strmatch(text, gsub(systemMessage, '%%s', '.+'))) then
			local instance = strmatch(text, gsub(systemMessage, '%%s', '(.+)'))

			ANNOUNCEMENT:SendMessage(format(friendlyMessage, instance), ANNOUNCEMENT:GetChannel())

			F:CreateNotification(L['NOTIFICATION_INSTANCE'], format(friendlyMessage, C.BlueColor..instance), nil, 'Interface\\ICONS\\Achievement_Dungeon_AtalDazar')

			return
		end
	end
end

function ANNOUNCEMENT:InstanceReset()
	F:RegisterEvent('CHAT_MSG_SYSTEM', function(event, text)
		InstanceReset(text)
	end)
end

