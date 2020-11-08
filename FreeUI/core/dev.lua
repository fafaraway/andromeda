local F, C, L = unpack(select(2, ...))




SlashCmdList.FREE_ONLY = function()
	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if name ~= 'FreeUI' and name ~= '!BaudErrorFrame' and GetAddOnEnableState(C.MyName, name) == 2 then
			DisableAddOn(name, C.MyName)
		end
	end
	ReloadUI()
end
SLASH_FREE_ONLY1 = '/freeonly'





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
			F.Print(frame:GetName() or string.format(UNKNOWN..': [%s]', tostring(frame)))
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
	F.Print('uiScale '..FREE_ADB.ui_scale)
	F.Print('UIParentScale '..UIParent:GetScale())
	print(C.LineString)
end
SLASH_UISCALECHECK1 = '/getuiscale'

SlashCmdList['ITEMINFO'] = function(id)
	if id == '' then
		F.Print(C.RedColor..'Please enter a item ID.|r')
	else
		local name, link, rarity, level, minLevel, type, subType, stackCount, equipLoc, icon, sellPrice, classID, subClassID, bindType  = GetItemInfo(id)

		print(C.LineString)
		F.Print('Name: '.. name)
		F.Print('Link: '.. link)
		F.Print('Rarity: '.. rarity)
		F.Print('Level: '.. level)
		F.Print('MinLevel: '.. minLevel)
		F.Print('Type: '.. type)
		F.Print('SubType: '.. subType)
		F.Print('ClassID: '.. classID)
		F.Print('SubClassID: '.. subClassID)
		F.Print('BindType: '.. bindType)
		print(C.LineString)
	end
end
SLASH_ITEMINFO1 = '/getiteminfo'




