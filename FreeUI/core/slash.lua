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

SlashCmdList['RESETINSTANCES'] = function()
	ResetInstances();
end
SLASH_RESETINSTANCES1 = '/rs'





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



