local F, C, L = unpack(select(2, ...))
local ACTIONBAR, cfg = F:GetModule('Actionbar'), C.Actionbar


local next, tonumber, unpack, select = next, tonumber, unpack, select
local ACTION_BUTTON_SHOW_GRID_REASON_CVAR = ACTION_BUTTON_SHOW_GRID_REASON_CVAR
local margin, padding, buttonSizeSmall, buttonSizeNormal, buttonSizeBig
local numNormal = NUM_ACTIONBAR_BUTTONS
local numPet = NUM_PET_ACTION_SLOTS
local numStance = NUM_STANCE_SLOTS
local numExtra = 1
local buttonList = {}
local gap = C.General.ui_gap


function ACTIONBAR:CreateBar1()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar1', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
	frame:Height(buttonSizeNormal + 2*padding)

	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, gap}

	for i = 1, numNormal do
		local button = _G['ActionButton'..i]
		table.insert(buttonList, button)
		button:SetParent(frame)
		button:Size(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()

		if i == 1 then
			button:Point('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['ActionButton'..i-1]
			button:Point('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if cfg.bar1 then
		frame.frameVisibility = cfg.bar1_visibility

		if cfg.bar1_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end

		frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_BAR1'], 'Bar1', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	local actionPage = '[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1'
	local buttonName = 'ActionButton'
	for i, button in next, buttonList do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
		buttons = table.new()
		for i = 1, %d do
			table.insert(buttons, self:GetFrameRef('%s'..i))
		end
	]]):format(numNormal, buttonName))

	frame:SetAttribute('_onstate-page', [[
		for _, button in next, buttons do
			button:SetAttribute('actionpage', newstate)
		end
	]])
	RegisterStateDriver(frame, 'page', actionPage)
end

function ACTIONBAR:CreateBar2()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar2', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
	frame:Height(buttonSizeNormal + 2*padding)

	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, gap+buttonSizeNormal+padding}

	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)

	for i = 1, numNormal do
		local button = _G['MultiBarBottomLeftButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:Point('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['MultiBarBottomLeftButton'..i-1]
			button:Point('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if cfg.bar2 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	
		if cfg.bar2_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end

		frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_BAR2'], 'Bar2', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateBar3()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar3', UIParent, 'SecureHandlerStateTemplate')

	if cfg.bar3_divide then
		frame:Width(18*buttonSizeNormal + 17*margin + 2*padding)
		frame:Height(2*buttonSizeNormal + margin + 2*padding)
	else
		frame:Width(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
		frame:Height(buttonSizeNormal + 2*padding)
	end

	if cfg.bar3_divide then
		frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, gap}
	else
		frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, gap+2*(buttonSizeNormal+2*padding)}
	end

	MultiBarBottomRight:SetParent(frame)
	MultiBarBottomRight:EnableMouse(false)

	for i = 1, numNormal do
		local button = _G['MultiBarBottomRightButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:Point('TOPLEFT', frame, padding, -padding)
		elseif (i == 4 and cfg.bar3_divide) then
			local previous = _G['MultiBarBottomRightButton1']
			button:Point('TOP', previous, 'BOTTOM', 0, -padding)
		elseif (i == 7 and cfg.bar3_divide) then
			local previous = _G['MultiBarBottomRightButton3']
			button:Point('TOPLEFT', previous, 'TOPRIGHT', 12*buttonSizeNormal+13*margin, 0)
		elseif (i == 10 and cfg.bar3_divide) then
			local previous = _G['MultiBarBottomRightButton7']
			button:Point('TOP', previous, 'BOTTOM', 0, -padding)
		else
			local previous = _G['MultiBarBottomRightButton'..i-1]
			button:Point('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if cfg.bar3 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
		
		if cfg.bar3_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end

		frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_BAR3'], 'Bar3', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateBar4()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar4', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(buttonSizeSmall + 2*padding)
	frame:Height(numNormal*buttonSizeSmall + (numNormal-1)*margin + 2*padding)

	frame.Pos = {'RIGHT', UIParent, 'RIGHT', -4, 0}

	MultiBarRight:SetParent(frame)
	MultiBarRight:EnableMouse(false)
	hooksecurefunc(MultiBarRight, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, numNormal do
		local button = _G['MultiBarRightButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()

		if i == 1 then
			button:Point('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarRightButton'..i-1]
			button:Point('TOP', previous, 'BOTTOM', 0, -margin)
		end

	end

	if cfg.bar4 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
		
		if cfg.bar4_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end

		frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_BAR4'], 'Bar4', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateBar5()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar5', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(buttonSizeSmall + 2*padding)
	frame:Height(numNormal*buttonSizeSmall + (numNormal-1)*margin + 2*padding)

	frame.Pos = {'RIGHT', 'FreeUI_ActionBar4', 'LEFT', 0, 0}

	MultiBarLeft:SetParent(frame)
	MultiBarLeft:EnableMouse(false)
	hooksecurefunc(MultiBarLeft, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, numNormal do
		local button = _G['MultiBarLeftButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:Point('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarLeftButton'..i-1]
			button:Point('TOP', previous, 'BOTTOM', 0, -margin)
		end
	end

	if cfg.bar5 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
		
		if cfg.bar5_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end

		frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_BAR5'], 'Bar5', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreatePetbar()
	local frame = CreateFrame('Frame', 'FreeUI_PetActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numPet*buttonSizeSmall + (numPet-1)*(margin+2) + 2*padding)
	frame:Height(buttonSizeSmall + 2*padding)

	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, gap+2*(buttonSizeNormal+2*padding)}

	PetActionBarFrame:SetParent(frame)
	PetActionBarFrame:EnableMouse(false)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)

	for i = 1, numPet do
		local button = _G['PetActionButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:Point('LEFT', frame, padding, 0)
		else
			local previous = _G['PetActionButton'..i-1]
			button:Point('LEFT', previous, 'RIGHT', margin+2, 0)
		end
		--cooldown fix
		local cd = _G['PetActionButton'..i..'Cooldown']
		cd:SetAllPoints(button)
	end

	if cfg.pet_bar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide'
	
		if cfg.pet_bar_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end

		frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_PET'], 'Petbar', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateStancebar()
	local frame = CreateFrame('Frame', 'FreeUI_StanceBar', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numStance*buttonSizeBig + (numStance-1)*margin + 2*padding)
	frame:Height(buttonSizeBig + 2*padding)

	local function positionBars()
		if InCombatLockdown() then return end
		local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
		if leftShown and rightShown then
			frame:Point('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif leftShown and not rightShown then
			frame:Point('BOTTOM', 'FreeUI_ActionBar2', 'TOP', 0, 0)
		elseif rightShown and not leftShown then
			frame:Point('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif not rightShown and not leftShown then
			frame:Point('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
		end
	end
	hooksecurefunc('MultiActionBar_Update', positionBars)

	-- STANCE BAR
	StanceBarFrame:SetParent(frame)
	StanceBarFrame:EnableMouse(false)
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)

	for i = 1, numStance do
		local button = _G['StanceButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeBig, buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:Point('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['StanceButton'..i-1]
			button:Point('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	-- POSSESS BAR
	PossessBarFrame:SetParent(frame)
	PossessBarFrame:EnableMouse(false)
	PossessBackground1:SetTexture(nil)
	PossessBackground2:SetTexture(nil)

	for i = 1, NUM_POSSESS_SLOTS do
		local button = _G['PossessButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeBig, buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:Point('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['PossessButton'..i-1]
			button:Point('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	--[[ if cfg.stance_bar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	
		if cfg.stance_bar_fade then
			ACTIONBAR.CreateButtonFrameFader(frame, buttonList, ACTIONBAR.fader)
		end
	else
		frame.frameVisibility = 'hide'
	end ]]
	frame.frameVisibility = 'hide'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateExtrabar()
	local frame = CreateFrame('Frame', 'FreeUI_ExtraActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numExtra*buttonSizeBig + (numExtra-1)*margin + 2*padding)
	frame:Height(buttonSizeBig + 2*padding)
	frame.Pos = {'CENTER', UIParent, 'CENTER', 0, 200}
	frame:SetScale(1)

	ExtraActionBarFrame:SetParent(frame)
	ExtraActionBarFrame:EnableMouse(false)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:Point('CENTER', 0, 0)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	local button = ExtraActionButton1
	table.insert(buttonList, button)
	
	button:Size(buttonSizeBig, buttonSizeBig)

	frame.frameVisibility = '[extrabar] show; hide'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	frame.mover = F.Mover(frame, L['MOVER_ACTIONBAR_EXTRA'], 'Extrabar', frame.Pos)

	--zone ability
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame.ignoreFramePositionManager = true
	ZoneAbilityFrameNormalTexture:SetAlpha(0)
	ZoneAbilityFrame:Point('CENTER', UIParent, 'CENTER', 0, 300)

	local spellButton = ZoneAbilityFrame.SpellButton
	spellButton:Size(buttonSizeBig, buttonSizeBig)
	spellButton.Style:SetAlpha(0)
	spellButton.Icon:SetTexCoord(unpack(C.TexCoord))
	spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	F.CreateBDFrame(spellButton.Icon, nil, true)
end

function ACTIONBAR:CreateLeaveVehicleBar()
	local frame = CreateFrame('Frame', 'FreeUI_LeaveVehicleBar', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numExtra*buttonSizeBig + (numExtra-1)*margin + 2*padding)
	frame:Height(buttonSizeBig + 2*padding)
	frame.Pos = {'CENTER', UIParent, 'CENTER', 0, 100}

	local button = CreateFrame('CheckButton', 'FreeUI_LeaveVehicleButton', frame, 'ActionButtonTemplate, SecureHandlerClickTemplate')
	table.insert(buttonList, button)
	button:Point('BOTTOMLEFT', frame, padding, padding)
	button:Size(buttonSizeBig, buttonSizeBig)
	button:RegisterForClicks('AnyUp')

	--[[ button.icon:SetTexture('INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up')
	button.icon:SetTexCoord(.216, .784, .216, .784)
	button:SetNormalTexture(nil)
	button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	button:GetPushedTexture():SetTexture(C.Assets.button_pushed)
	F.CreateBDFrame(button, nil, true)
	frame.mover = F.Mover(frame, L['ACTIONBAR_LEAVE_VEHICLE'], 'LeaveVehicleButton', frame.Pos) ]]

	local function onClick(self)
		if UnitOnTaxi('player') then TaxiRequestEarlyLanding() else VehicleExit() end
		self:SetChecked(false)
	end

	button:SetScript('OnClick', onClick)
	button:HookScript('OnEnter', MainMenuBarVehicleLeaveButton_OnEnter)
	button:HookScript('OnLeave', F.HideTooltip)

	frame.frameVisibility = '[canexitvehicle]c;[mounted]m;n'
	RegisterStateDriver(frame, 'exit', frame.frameVisibility)

	frame:SetAttribute('_onstate-exit', [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
	if not CanExitVehicle() then frame:Hide() end
end

local scripts = {
	'OnShow', 'OnHide', 'OnEvent', 'OnEnter', 'OnLeave', 'OnUpdate', 'OnValueChanged', 'OnClick', 'OnMouseDown', 'OnMouseUp',
}

local framesToHide = {
	MainMenuBar, OverrideActionBar,
}

local framesToDisable = {
	MainMenuBar,
	MicroButtonAndBagsBar, MainMenuBarArtFrame, StatusTrackingBarManager,
	ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton,
	OverrideActionBar,
	OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

function ACTIONBAR:RemoveBlizzArt()
	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(true)
	MainMenuBar.ignoreFramePositionManager = true
	MainMenuBar:SetAttribute('ignoreFramePositionManager', true)

	for _, frame in next, framesToHide do
		frame:SetParent(F.HiddenFrame)
	end

	for _, frame in next, framesToDisable do
		frame:UnregisterAllEvents()
		DisableAllScripts(frame)
	end

	-- Update button grid
	local function buttonShowGrid(name, showgrid)
		for i = 1, 12 do
			local button = _G[name..i]
			button:SetAttribute('showgrid', showgrid)
			ActionButton_ShowGrid(button, ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		end
	end

	local updateAfterCombat
	local function ToggleButtonGrid()
		if InCombatLockdown() then
			updateAfterCombat = true
			F:RegisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
		else
			local showgrid = tonumber(GetCVar('alwaysShowActionBars'))
			buttonShowGrid('ActionButton', showgrid)
			buttonShowGrid('MultiBarBottomRightButton', showgrid)
			if updateAfterCombat then
				F:UnregisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
				updateAfterCombat = false
			end
		end
	end
	hooksecurefunc('MultiActionBar_UpdateGridVisibility', ToggleButtonGrid)

	-- Update token panel
	local function updateToken()
		TokenFrame_LoadUI()
		TokenFrame_Update()
		BackpackTokenFrame_Update()
	end
	F:RegisterEvent('CURRENCY_DISPLAY_UPDATE', updateToken)
end


function ACTIONBAR:OnLogin()
	if not cfg.enable then return end

	padding = F:Scale(cfg.bar_padding)
	margin = F:Scale(cfg.bar_margin)
	buttonSizeNormal = F:Scale(cfg.button_size_normal)
	buttonSizeSmall = F:Scale(cfg.button_size_small)
	buttonSizeBig = F:Scale(cfg.button_size_big)

	self:CreateBar1()
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreatePetbar()
	self:CreateStancebar()
	self:CreateExtrabar()
	self:CreateLeaveVehicleBar()
	self:RemoveBlizzArt()
	self:RestyleButtons()
	self:ButtonRange()

	F.HideOption(InterfaceOptionsActionBarsPanelBottomLeft)
	F.HideOption(InterfaceOptionsActionBarsPanelBottomRight)
	F.HideOption(InterfaceOptionsActionBarsPanelRight)
	F.HideOption(InterfaceOptionsActionBarsPanelRightTwo)
	F.HideOption(InterfaceOptionsActionBarsPanelStackRightBars)
	F.HideOption(InterfaceOptionsActionBarsPanelAlwaysShowActionBars)

	--vehicle fix
	--[[ local function getActionTexture(button)
		return GetActionTexture(button.action)
	end

	F:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', function()
		for _, button in next, buttonList do
			local icon = button.icon
			local texture = getActionTexture(button)
			if texture then
				icon:SetTexture(texture)
				icon:Show()
			else
				icon:Hide()
			end
		end
	end) ]]
end