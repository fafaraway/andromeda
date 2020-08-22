local F, C, L = unpack(select(2, ...))
local INSTALL = F:GetModule('Install')


StaticPopupDialogs['THEME_CONFLICTION_WARNING'] = {
	text = L['THEME_CONFLICTION_WARNING'],
	button1 = DISABLE,
	OnAccept = function()
		DisableAddOn('Aurora', true)
		DisableAddOn('AuroraClassic', true)
		DisableAddOn('Skinner', true)
		ReloadUI()
	end,
	hideOnEscape = false,
	whileDead = 1,
	timeout = 0,
}

StaticPopupDialogs['FREEUI_RELOAD'] = {
	text = L['GUI_RELOAD_WARNING'],
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs['FREEUI_RESET'] = {
	text = L['GUI_RESET_WARNING'],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FreeUIConfigsGlobal = {}
		FreeUIConfigs = {}

		FreeUIOptionsGlobal[C.MyRealm][C.MyName] = false
		FreeUIOptions = {}
		FreeUIOptionsPerChar = {}

		C.Options = FreeUIOptions

		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

StaticPopupDialogs['FREEUI_PROFILE'] = {
	text = L['GUI_PROFILE_WARNING'],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function()
		if FreeUIOptionsFrame.profile:GetChecked() then
			FreeUIOptionsGlobal[C.MyRealm][C.MyName] = true
		else
			FreeUIOptionsGlobal[C.MyRealm][C.MyName] = false
		end
		changeProfile()
		ReloadUI()
	end,
	OnCancel = function()
		if FreeUIOptionsFrame.profile:GetChecked() then
			FreeUIOptionsFrame.profile:SetChecked(false)
		else
			FreeUIOptionsFrame.profile:SetChecked(true)
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

local function printCommandsList()
	for _, v in ipairs(L['COMMANDS_LIST']) do
		local command, desc = strsplit('-', tostring(v))
		print(C.YellowColor..command..'|r'..C.GreyColor..' -|r '..desc)
	end
end

SlashCmdList.FREEUI = function(cmd)
	local cmd, args = strsplit(' ', cmd:lower(), 2)
	if cmd == 'reset' then
		StaticPopup_Show('FREEUI_RESET')
	elseif cmd == 'install' then
		INSTALL:HelloWorld()
	elseif cmd == 'unlock' then
		F:MoverConsole()
	elseif cmd == 'config' then
		if FreeUI_GUI then
			FreeUI_GUI:Show()
			HideUIPanel(GameMenuFrame)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		else
			UIErrorsFrame:AddMessage(C.RedColor..ERR_NOT_IN_COMBAT)
		end


	elseif cmd == 'help' then
		printCommandsList()
	else
		printCommandsList()
	end
end
SLASH_FREEUI1 = '/freeui'
SLASH_FREEUI2 = '/free'


--[[ dev tools ]]

SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = '/rl'

SlashCmdList['FSTACK'] = function()
	UIParentLoadAddOn('Blizzard_DebugTools')
	FrameStackTooltip_Toggle()
end
SLASH_FSTACK1 = '/fs'

SlashCmdList['FRAMENAME'] = function()
	local frame = EnumerateFrames()
	while frame do
		if (frame:IsVisible() and MouseIsOver(frame)) then
			print(frame:GetName() or string.format(UNKNOWN..': [%s]', tostring(frame)))
		end
		frame = EnumerateFrames(frame)
	end
end
SLASH_FRAMENAME1 = '/fsn'

SlashCmdList['EVENTTRACE'] = function(msg)
	UIParentLoadAddOn('Blizzard_DebugTools')
	EventTraceFrame_HandleSlashCmd(msg)
end
SLASH_EVENTTRACE1 = '/et'

SlashCmdList.DEV = function()
	UIParentLoadAddOn('Blizzard_Console')
	DeveloperConsole:Toggle()
end
SLASH_DEV1 = '/dev'


SlashCmdList['INSTANCEID'] = function()
	local name, instanceType, difficultyID, difficultyName, _, _, _, instanceMapID = GetInstanceInfo()
	print(C.LineString)
	F.Print(C.InfoColor..'Name '..C.RedColor..name)
	F.Print(C.InfoColor..'instanceType '..C.RedColor..instanceType)
	F.Print(C.InfoColor..'difficultyID '..C.RedColor..difficultyID)
	F.Print(C.InfoColor..'difficultyName '..C.RedColor..difficultyName)
	F.Print(C.InfoColor..'instanceMapID '..C.RedColor..instanceMapID)
	print(C.LineString)
end
SLASH_INSTANCEID1 = '/getinstid'

SlashCmdList['QUESTCHECK'] = function(id)
	if id == '' then
		F.Print(C.RedColor..'Please enter a Quest ID.|r')
	else
		local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(id)
		F.Print(C.BlueColor..'Quest ID |r |Hquest:'..id..'|h['..id..']|h')

		if isCompleted == true then
			F.Print(C.InfoColor..'Complete|r (YES)')
		else
			F.Print(C.InfoColor..'Complete|r (NO)')
		end
	end
end
SLASH_QUESTCHECK1 = '/qc'

SlashCmdList['UISCALECHECK'] = function()
	print(C.LineString)
	F.Print('C.ScreenWidth '..C.ScreenWidth)
	F.Print('C.ScreenHeight '..C.ScreenHeight)
	F.Print('C.Mult '..C.Mult)
	F.Print('uiScale '..FreeUIConfigsGlobal['ui_scale'])
	F.Print('UIParentScale '..UIParent:GetScale())
	print(C.LineString)
end
SLASH_UISCALECHECK1 = '/getuiscale'


--[[ dungeon ]]

SlashCmdList['DGR'] = function(msg)
	ResetInstances()
end
SLASH_DGR1 = '/dgr'

SlashCmdList['DGT'] = function(msg)
	local inInstance, _ = IsInInstance()
	if inInstance then
		LFGTeleport(true)
	else
		LFGTeleport()
	end
end
SLASH_DGT1 = '/dgt'

SlashCmdList['DGFIVE'] = function(msg)
	SetDungeonDifficultyID(1)
end
SLASH_DGFIVE1 = '/5n'

SlashCmdList['DGHERO'] = function(msg)
	SetDungeonDifficultyID(2)
end
SLASH_DGHERO1 = '/5h'

SlashCmdList['DGMYTH'] = function(msg)
	SetDungeonDifficultyID(23)
end
SLASH_DGMYTH1 = '/5m'

SlashCmdList['RAIDTENMAN'] = function(msg)
	SetRaidDifficultyID(3)
end
SLASH_RAIDTENMAN1 = '/10n'

SlashCmdList['RAIDTENHERO'] = function(msg)
	SetRaidDifficultyID(5)
end
SLASH_RAIDTENHERO1 = '/10h'

SlashCmdList['RAIDTFMAN'] = function(msg)
	SetRaidDifficultyID(4)
end
SLASH_RAIDTFMAN1 = '/25n'

SlashCmdList['RAIDTFHERO'] = function(msg)
	SetRaidDifficultyID(6)
end
SLASH_RAIDTFHERO1 = '/25h'

SlashCmdList['FLEXNORMAL'] = function(msg)
	SetRaidDifficultyID(14)
end
SLASH_FLEXNORMAL1 = '/nm'

SlashCmdList['FLEXHERO'] = function(msg)
	SetRaidDifficultyID(15)
end
SLASH_FLEXHERO1 = '/hm'

SlashCmdList['MYTH'] = function(msg)
	SetRaidDifficultyID(16)
end
SLASH_MYTH1 = '/mm'

StaticPopupDialogs['LeaveBattleField'] = {
	text = LEAVE_BATTLEGROUND,
	button1 = YES,
	button2 = NO,
	timeout = 20,
	whileDead = true,
	hideOnEscape = true,
	OnAccept = function() LeaveBattlefield() end,
	OnCancel = function() end,
	preferredIndex = 5,
}

SlashCmdList['LEAVEBATTLEFIELD'] = function(msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'arena' or instanceType == 'pvp' then
		if instanceType == 'pvp' then
			instanceType = 'battleground'
		elseif instanceType == 'arena' then
			if select(2, IsActiveBattlefieldArena()) then
				instanceType = 'rated arena match'
			else
				instanceType = 'arena skirmish'
			end
		end

		StaticPopup_Show('LeaveBattleField')
	end
end
SLASH_LEAVEBATTLEFIELD1 = '/lbg'


-- [[ group ]] --

SlashCmdList['READYCHECK'] = function()
	DoReadyCheck()
end
SLASH_READYCHECK1 = '/rdc'

SlashCmdList['ROLECHECK'] = function()
	InitiateRolePoll()
end
SLASH_ROLECHECK1 = '/rpc'

SlashCmdList['LEAVEGROUP'] = function()
	LeaveParty()
end
SLASH_LEAVEGROUP1 = '/lg'

SlashCmdList['SETEVERYONEISASSISTANT'] = function()
	SetEveryoneIsAssistant(true)
end
SLASH_SETEVERYONEISASSISTANT1 = '/seia'

SlashCmdList['RAIDTOPARTY'] = function()
	if IsInRaid() then
		if (GetNumGroupMembers() <= MEMBERS_PER_RAID_GROUP) then
			if UnitIsGroupLeader('player') then
				ConvertToParty()
				print(CONVERT_TO_PARTY)
			else
				print(ERR_GUILD_PERMISSIONS)
			end
		else
			print(ERR_READY_CHECK_THROTTLED)
		end
	elseif (IsInGroup() and not IsInRaid()) then
		print(ERR_NOT_IN_RAID)
	else
		print(ERR_NOT_IN_GROUP)
	end
end
SLASH_RAIDTOPARTY1 = '/rtp'

SlashCmdList['PARTYTORAID'] = function(msg)
	if IsInRaid() then
		print(ERR_PARTY_CONVERTED_TO_RAID)
	elseif (IsInGroup() and UnitIsGroupLeader('player')) and not IsInRaid() then
		ConvertToRaid()
		print(CONVERT_TO_RAID)
	elseif (IsInGroup() and not UnitIsGroupLeader('player')) and not IsInRaid() then
		print(LFG_LIST_NOT_LEADER)
	else
		print(ERR_NOT_IN_GROUP)
	end
end
SLASH_PARTYTORAID1 = '/ptr'

SlashCmdList.GROUPCONVERT = function()
	if GetNumGroupMembers() > 0 then
		if UnitInRaid('player') and (UnitIsGroupLeader('player')) then
			ConvertToParty()
		elseif UnitInParty('player') and (UnitIsGroupLeader('player')) then
			ConvertToRaid()
		end
	else
		print(ERR_NOT_IN_GROUP)
	end
end
SLASH_GROUPCONVERT1 = '/gc'

local GroupDisband = function()
	local pName = UnitName('player')
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= pName then
				UninviteUnit(name)
				SendChatMessage('Disbanding group.', 'RAID')
			end
		end
	else
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if (UnitExists('party'..i)) then
				UninviteUnit(UnitName('party'..i))
				SendChatMessage('Disbanding group.', 'PARTY')
			end
		end
	end
	LeaveParty()
end

StaticPopupDialogs['DISBAND_RAID'] = {
	text = TEAM_DISBAND,
	button1 = YES,
	button2 = NO,
	OnAccept = GroupDisband,
	timeout = 20,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 5,
}

SlashCmdList['GROUPDISBAND'] = function(msg)
	if  IsInRaid() then
		StaticPopup_Show('DISBAND_RAID')
	end
end
SLASH_GROUPDISBAND1 = '/gd'


--[[ misc ]]

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

SlashCmdList['MOUNTSPECIAL'] = function()
	if GetUnitSpeed('player') == 0 then
		DoEmote('MOUNTSPECIAL')
	end
end
SLASH_MOUNTSPECIAL1 = '/ms'

SlashCmdList['BNBROADCAST'] = function(msg, editbox)
	BNSetCustomMessage(msg)
end
SLASH_BNBROADCAST1 = '/bn'

SlashCmdList.SPEC = function(spec)
	if C.MyLevel >= SHOW_SPEC_LEVEL then
		if GetSpecialization() ~= tonumber(spec) then
			SetSpecialization(spec)
		end
	else
		print('|cffffff00'..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_SPEC_LEVEL)..'|r')
	end
end
SLASH_SPEC1 = '/spec'











