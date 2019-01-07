local F, C, L = unpack(select(2, ...))


SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = '/rl'

SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = '/rc'

SlashCmdList.ROLECHECK = InitiateRolePoll
SLASH_ROLECHECK1 = '/rolecheck'
SLASH_ROLECHECK2 = '/rolepoll'

SlashCmdList.TICKET = ToggleHelpFrame
SLASH_TICKET1 = '/gm'

SlashCmdList['LEAVEPARTY'] = function()
	LeaveParty();
end
SLASH_LEAVEPARTY1 = '/lg'




SlashCmdList['INSTANCEID'] = function()
	local name, instanceType, difficultyID, difficultyName, _, _, _, instanceMapID = GetInstanceInfo()
	print(C.LineString)
	print(C.InfoColor..'Name: '..C.RedColor..name)
	print(C.InfoColor..'instanceType: '..C.RedColor..instanceType)
	print(C.InfoColor..'difficultyID: '..C.RedColor..difficultyID)
	print(C.InfoColor..'difficultyName: '..C.RedColor..difficultyName)
	print(C.InfoColor..'instanceMapID: '..C.RedColor..instanceMapID)
	print(C.LineString)
end
SLASH_INSTANCEID1 = '/getinstid'






SlashCmdList.FREEUI = function(cmd)
	local cmd, args = strsplit(' ', cmd:lower(), 2)
	if C.unitframes.enable then
		if cmd == 'dps' then
			FreeUIConfig.layout = 1
			ReloadUI()
		elseif cmd == 'healer' then
			FreeUIConfig.layout = 2
			ReloadUI()
		elseif cmd == 'reset' then
			FreeUIGlobalConfig = {}
			FreeUIConfig = {}
			ReloadUI()
		end
	end
end
SLASH_FREEUI1 = '/freeui'