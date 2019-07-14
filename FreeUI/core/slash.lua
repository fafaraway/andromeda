local F, C, L = unpack(select(2, ...))
local INSTALL = F:GetModule('Install')


StaticPopupDialogs['FREEUI_MOVER_RESET'] = {
	text = L['MOVER_RESET_CONFIRM'],
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function()
		wipe(FreeUIConfig['mover'])
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
}

StaticPopupDialogs['FREEUI_MOVER_CANCEL'] = {
	text = L['MOVER_CANCEL_CONFIRM'],
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function()
		F.CopyTable(BackupTable, FreeUIConfig['mover'])
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
}

StaticPopupDialogs['FREEUI_RELOAD'] = {
	text = L['RELOAD_CHECK'],
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function()
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
}



SlashCmdList.UIHELP = function()
	for i, v in ipairs(L['SLASHCMD_HELP']) do print('|cff55c782'..('%s'):format(tostring(v))..'|r') end
end
SLASH_UIHELP1 = '/uihelp'

SlashCmdList.FREEUI = function(cmd)
	local cmd, args = strsplit(' ', cmd:lower(), 2)
	if cmd == 'reset' then
		StaticPopup_Show('FREEUI_RESET')
	elseif cmd == 'install' then
		INSTALL:HelloWorld()
	elseif cmd == 'unlock' then
		F:MoverConsole()
	elseif cmd == 'config' then
		if FreeUIOptionsPanel then
			FreeUIOptionsPanel:Show()
			HideUIPanel(GameMenuFrame)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		end
	elseif cmd == 'clickcast' then
		ToggleSpellBook(BOOKTYPE_SPELL)
		SpellBinder:Show()
		SpellBinder.sbOpen = true
		SpellBinder:ToggleButtons()
	else
		for i, v in ipairs(L['SLASHCMD_HELP']) do
			--print('|cff55c782'..('%s'):format(tostring(v))..'|r')
			print(strsplit('-', tostring(v), 2))
		end
	end
end
SLASH_FREEUI1 = '/freeui'


SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = '/rl'

SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = '/rc'

SlashCmdList.ROLEPOLL = InitiateRolePoll
SLASH_ROLEPOLL1 = '/rp'

SlashCmdList.TICKET = ToggleHelpFrame
SLASH_TICKET1 = '/gm'

SlashCmdList.JOURNAL = ToggleEncounterJournal
SLASH_JOURNAL1 = '/ej'

SlashCmdList.LEAVEPARTY = function()
	LeaveParty();
end
SLASH_LEAVEPARTY1 = '/lg'

SlashCmdList.RESETINSTANCES = function()
	ResetInstances();
end
SLASH_RESETINSTANCES1 = '/rs'

SlashCmdList.SCREENSHOT = function()
	Screenshot();
end
SLASH_SCREENSHOT1 = '/ss'

SlashCmdList.CLEARCHAT = function()
	for i = 1, NUM_CHAT_WINDOWS do
		_G[format('ChatFrame%d', i)]:Clear()
	end
end
SLASH_CLEARCHAT1 = '/clear'

SlashCmdList.DEV = function() 
	UIParentLoadAddOn('Blizzard_Console') 
	DeveloperConsole:Toggle()
end 
SLASH_DEV1 = '/dev'

SlashCmdList.SPEC = function(spec)
	local spec, args = strsplit(' ', spec:lower(), 2)

	if UnitLevel('player') >= SHOW_SPEC_LEVEL then
		if GetSpecialization() ~= tonumber(spec) then
			SetSpecialization(spec)
		end
	else
		print('|cffffff00'..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_SPEC_LEVEL)..'|r')
	end
end
SLASH_SPEC1 = '/spec'

SlashCmdList.INSTTELEPORT = function()
	local inInstance = IsInInstance()
	if inInstance then
		LFGTeleport(true)
	else
		LFGTeleport()
	end
end
SLASH_INSTTELEPORT1 = '/tp'

SlashCmdList.GROUPCONVERT = function()
	if GetNumGroupMembers() > 0 then
		if UnitInRaid('player') and (UnitIsGroupLeader('player')) then
			ConvertToParty()
		elseif UnitInParty('player') and (UnitIsGroupLeader('player')) then
			ConvertToRaid()
		end
	else
		print('|cffffff00'..ERR_NOT_IN_GROUP..'|r')
	end
end
SLASH_GROUPCONVERT1 = '/gc'



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






