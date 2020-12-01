local F, C, L = unpack(select(2, ...))
local INSTALL = F.INSTALL
local GUI = F.GUI
local ACTIONBAR = F.ACTIONBAR


StaticPopupDialogs['FREEUI_RELOAD'] = {
	text = L.GUI.RELOAD,
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs['FREEUI_RESET_OPTIONS'] = {
	text = L.GUI.RESET_OPTIONS,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FREE_ADB = {}
		C.DB = {}

		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}



StaticPopupDialogs['FREEUI_RESET_ANCHOR'] = {
	text = L.GUI.MOVER.RESET,
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function()
		wipe(C.DB.ui_anchor)
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
	crossRealms = {[1]=C.MyRealm}
end

StaticPopupDialogs['FREEUI_RESET_GOLD'] = {
	text = L.GUI.RESET_GOLD,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		for _, realm in pairs(crossRealms) do
			if FREE_GOLDCOUNT[realm] then
				wipe(FREE_GOLDCOUNT[realm])
			end
		end

		FREE_GOLDCOUNT[C.MyRealm][C.MyName] = {GetMoney(), C.MyClass}
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs['FREEUI_RESET_JUNK_LIST'] = {
	text = L.GUI.RESET_JUNK_LIST,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		wipe(FREE_ADB.custom_junk_list)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs['FREEUI_GUILD_INVITE'] = {
	-- 'Do you want to invite %s to your guild?'
	text = format(ERR_GUILD_INVITE_S, '%s'),
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self, data)
		GuildInvite(data)
	end,
	OnCancel = function()
		return
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}


local function printCommandsList()
	for _, v in ipairs(L['COMMANDS_LIST']) do
		local command, desc = strsplit('-', tostring(v))
		print(C.YellowColor..command..'|r'..C.GreyColor..' -|r '..desc)
	end
end

SlashCmdList.FREEUI = function(str)
	local cmd, _ = strsplit(' ', str:lower(), 2)
	if cmd == 'reset' then
		StaticPopup_Show('FREEUI_RESET')
	elseif cmd == 'install' then
		INSTALL:HelloWorld()
	elseif cmd == 'unlock' then
		F:MoverConsole()
	elseif cmd == 'config' then
		F.ToggleGUI()
	elseif cmd == 'bind' then
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(C.RedColor..ERR_NOT_IN_COMBAT)
			return
		end
		ACTIONBAR:Bind_Create()
		ACTIONBAR:Bind_Activate()
		ACTIONBAR:Bind_CreateDialog()
	elseif cmd == 'help' then
		printCommandsList()
	elseif cmd == 'ver' or cmd == 'version' then
		F.Print(C.AddonVersion)
	else
		printCommandsList()
	end
end
SLASH_FREEUI1 = '/freeui'
SLASH_FREEUI2 = '/free'




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
	C_PartyInfo.LeaveParty()
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


hooksecurefunc('ChatEdit_OnSpacePressed', function(self)
	if(string.sub(self:GetText(), 1, 3) == '/tt' and (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target'))) then
		self:SetText(SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
		ChatEdit_ParseText(self, 0)
	end
end)

SLASH_WHISPERTARGET1 = '/tt'
SlashCmdList.WHISPERTARGET = function(str)
	if(UnitCanCooperate('player', 'target')) then
		SendChatMessage(str, 'WHISPER', GetDefaultLanguage('player'), GetUnitName('target', true):gsub(' ', ''))
	end
end








