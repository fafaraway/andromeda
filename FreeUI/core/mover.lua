local F, C, L = unpack(select(2, ...))



local toggle = 0

local shadeFrame = CreateFrame('Frame')
local shadeTexture = shadeFrame:CreateTexture(nil, 'BACKGROUND', nil, -8)

shadeFrame:SetFrameStrata('BACKGROUND')
shadeFrame:SetWidth(GetScreenWidth() * UIParent:GetEffectiveScale())
shadeFrame:SetHeight(GetScreenHeight() * UIParent:GetEffectiveScale())
shadeTexture:SetAllPoints(shadeFrame)
shadeFrame:SetPoint('CENTER', 0, 0)

local crosshairFrameNS = CreateFrame('Frame')
local crosshairTextureNS = crosshairFrameNS:CreateTexture(nil, 'TOOLTIP')

crosshairFrameNS:SetFrameStrata('TOOLTIP')
crosshairFrameNS:SetWidth(1)
crosshairFrameNS:SetHeight(GetScreenHeight() * UIParent:GetEffectiveScale())
crosshairTextureNS:SetAllPoints(crosshairFrameNS)
crosshairTextureNS:SetColorTexture(0, 0, 0, 1)

local crosshairFrameEW = CreateFrame('Frame')
local crosshairTextureEW = crosshairFrameEW:CreateTexture(nil, 'TOOLTIP')

crosshairFrameEW:SetFrameStrata('TOOLTIP')
crosshairFrameEW:SetWidth(GetScreenWidth() * UIParent:GetEffectiveScale())
crosshairFrameEW:SetHeight(1)
crosshairTextureEW:SetAllPoints(crosshairFrameEW)
crosshairTextureEW:SetColorTexture(0, 0, 0, 1)

local function clear()
  shadeFrame:Hide()
  crosshairFrameNS:Hide()
  crosshairFrameEW:Hide()
end

local function shade(r, g, b, a)
  shadeTexture:SetColorTexture(r, g, b, a)
  shadeFrame:Show()
end

local function follow()
  local mouseX, mouseY = GetCursorPosition()
  crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
  crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
end

local function crosshair(arg)
  local mouseX, mouseY = GetCursorPosition()
  crosshairFrameNS:SetPoint('TOPLEFT', mouseX, 0)
  crosshairFrameEW:SetPoint('BOTTOMLEFT', 0, mouseY)
  crosshairFrameNS:Show()
  crosshairFrameEW:Show()
  if arg == 'follow' then
	crosshairFrameNS:SetScript('OnUpdate', follow)
  else
	crosshairFrameNS:SetScript('OnUpdate', nil)
  end
end

local function SlashCmdList_AddSlashCommand(name, func, ...)
	SlashCmdList[name] = func
	local command = ''
	for i = 1, select('#', ...) do
		command = select(i, ...)
		if strsub(command, 1, 1) ~= '/' then
			command = '/' .. command
		end
		_G['SLASH_'..name..i] = command
	end
end

SlashCmdList_AddSlashCommand('UISETUPHELPER_SLASHCMD', function(arg)
	if arg == 'dark' then
	  shade(0, 0, 0, 0.85)
	  crosshairTextureNS:SetColorTexture(1, 1, 1, 1)
	  crosshairTextureEW:SetColorTexture(1, 1, 1, 1)
	elseif arg == 'light' then
	  shade(1, 1, 1, 0.85)
	  crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
	  crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
	elseif arg == 'clear' then
	  clear()
	  toggle = 0
	elseif arg == 'align' or arg == 'follow' then
	  crosshair(arg)
	else
	  if toggle == 0 then
		shade(1, 1, 1, 0.85)
		crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
		crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
		crosshair('follow')
		toggle = 1
	  else
		clear()
	  end
	end
end, 'uisetuphelper', 'ush')





-- Frame Mover
local MoverList, BackupTable, f = {}, {}

function F:Mover(text, value, anchor, width, height)
	local key = 'mover'
	if not FreeUIConfig[key] then FreeUIConfig[key] = {} end

	local mover = CreateFrame('Frame', nil, UIParent)
	mover:SetWidth(width or self:GetWidth())
	mover:SetHeight(height or self:GetHeight())
	F.CreateBD(mover)
	F.CreateSD(mover)
	F.CreateFS(mover, 'pixel', nil, text, nil, 'yellow', true)

	tinsert(MoverList, mover)

	if not FreeUIConfig[key][value] then 
		mover:SetPoint(unpack(anchor))
	else
		mover:SetPoint(unpack(FreeUIConfig[key][value]))
	end
	mover:EnableMouse(true)
	mover:SetMovable(true)
	mover:SetClampedToScreen(true)
	mover:SetFrameStrata('HIGH')
	mover:RegisterForDrag('LeftButton')
	mover:SetScript('OnDragStart', function() mover:StartMoving() end)
	mover:SetScript('OnDragStop', function()
		mover:StopMovingOrSizing()
		local orig, _, tar, x, y = mover:GetPoint()
		FreeUIConfig[key][value] = {orig, 'UIParent', tar, x, y}
	end)
	mover:Hide()
	self:SetPoint('TOPLEFT', mover)

	return mover
end

local function UnlockElements()
	for i = 1, #MoverList do
		local mover = MoverList[i]
		if not mover:IsShown() then
			mover:Show()
		end
	end
	F.CopyTable(FreeUIConfig['mover'], BackupTable)
	f:Show()
end

local function LockElements()
	for i = 1, #MoverList do
		local mover = MoverList[i]
		mover:Hide()
	end
	f:Hide()
	--SlashCmdList['TOGGLEGRID']('1')
	toggle = 0
	clear()
end

StaticPopupDialogs['FREEUI_MOVER_RESET'] = {
	text = L['MOVER_RESET_CONFIRM'],
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function()
		wipe(FreeUIConfig['mover'])
		ReloadUI()
	end,
}

StaticPopupDialogs['FREEUI_MOVER_CANCEL'] = {
	text = L['MOVER_CANCEL_CONFIRM'],
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function()
		F.CopyTable(BackupTable, FreeUIConfig['mover'])
		ReloadUI()
	end,
}

-- Mover Console
local function CreateConsole()
	if f then return end

	f = CreateFrame('Frame', nil, UIParent)
	f:SetPoint('TOP', 0, -150)
	f:SetSize(296, 65)
	F.CreateBD(f)
	F.CreateSD(f)
	F.CreateMF(f)
	F.CreateFS(f, 14, nil, L['MOVER_PANEL'], nil, 'yellow', true, 'TOP', 0, -10)
	local bu, text = {}, {LOCK, CANCEL, L['MOVER_GRID'], RESET}
	for i = 1, 4 do
		bu[i] = F.CreateButton(f, 70, 28, text[i])
		F.Reskin(bu[i])
		if i == 1 then
			bu[i]:SetPoint('BOTTOMLEFT', 5, 5)
		else
			bu[i]:SetPoint('LEFT', bu[i-1], 'RIGHT', 2, 0)
		end
	end

	-- Lock
	bu[1]:SetScript('OnClick', LockElements)
	-- Cancel
	bu[2]:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_MOVER_CANCEL')
	end)
	-- Grids
	bu[3]:SetScript('OnClick', function()
		--SlashCmdList['TOGGLEGRID']('64')
		if toggle == 0 then
		shade(1, 1, 1, 0.85)
		crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
		crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
		crosshair('follow')
		toggle = 1
	  else
	  	toggle = 0
		clear()
	  end
	end)
	-- Reset
	bu[4]:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_MOVER_RESET')
	end)


	local function showLater(event)
		if event == 'PLAYER_REGEN_DISABLED' then
			if f:IsShown() then
				LockElements()
				F:RegisterEvent('PLAYER_REGEN_ENABLED', showLater)
			end
		else
			UnlockElements()
			F:UnregisterEvent(event, showLater)
		end
	end
	F:RegisterEvent('PLAYER_REGEN_DISABLED', showLater)
end


--[[SlashCmdList['FREEUI_MOVER'] = function()
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT)
		return
	end
	CreateConsole()
	UnlockElements()
end
SLASH_FREEUI_MOVER1 = '/mover']]



StaticPopupDialogs['RELOAD_FREEUI'] = {
	text = L['RELOADUI_REQUIRED'],
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function()
		ReloadUI()
	end,
}

--[[StaticPopupDialogs['RESET_FREEUI'] = {
	text = L['RESET_CHECK'],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FreeUIGlobalConfig = {}
		FreeUIConfig = {}
		FreeUIOptions = {}
		FreeUIOptionsPerChar = {}
		FreeUIOptionsGlobal[C.Realm][C.Name] = false
		C.options = FreeUIOptions
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
}]]


SlashCmdList.FREEUI = function(cmd)
	local cmd, args = strsplit(' ', cmd:lower(), 2)
	if cmd == 'reset' then
		StaticPopup_Show('FREEUI_RESET')
	elseif cmd == 'install' then
		F:HelloWorld()
	elseif cmd == 'unlock' then
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT)
			return
		end
		CreateConsole()
		UnlockElements()
	else
		if FreeUIOptionsPanel then
			FreeUIOptionsPanel:Show()
			HideUIPanel(GameMenuFrame)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		end
	end
end
SLASH_FREEUI1 = '/freeui'