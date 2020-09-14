local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


local _G = getfenv(0)
local next, tonumber, unpack, select = next, tonumber, unpack, select
local margin, padding, buttonSizeSmall, buttonSizeNormal, buttonSizeBig
local numNormal = _G.NUM_ACTIONBAR_BUTTONS
local numPet = _G.NUM_PET_ACTION_SLOTS
local numStance = _G.NUM_STANCE_SLOTS
local numExtra = 1
local buttonList = {}


function ACTIONBAR:CreateBar1()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar1', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
	frame:Height(buttonSizeNormal + 2*padding)

	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, FreeADB['ui_gap']}

	for i = 1, numNormal do
		local button = _G['ActionButton'..i]
		table.insert(buttonList, button)
		button:SetParent(frame)
		button:Size(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['ActionButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if FreeDB.actionbar.bar1 then
		-- if C.isDeveloper then
		-- 	frame.frameVisibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'
		-- else
			frame.frameVisibility = '[petbattle] hide; show'
		-- end

		frame.fader = {
			enable = FreeDB.actionbar.bar1_fade,
			fadeInAlpha = FreeDB.actionbar.bar1_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.bar1_fade_out_alpha,
			combat = FreeDB.actionbar.bar1_fade_combat,
			target = FreeDB.actionbar.bar1_fade_target,
			hover = FreeDB.actionbar.bar1_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)

		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_BAR1'], 'Bar1', frame.Pos)
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

	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, FreeADB['ui_gap']+buttonSizeNormal+padding}

	_G.MultiBarBottomLeft:SetParent(frame)
	_G.MultiBarBottomLeft:EnableMouse(false)

	for i = 1, numNormal do
		local button = _G['MultiBarBottomLeftButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['MultiBarBottomLeftButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if FreeDB.actionbar.bar2 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'

		frame.fader = {
			enable = FreeDB.actionbar.bar2_fade,
			fadeInAlpha = FreeDB.actionbar.bar2_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.bar2_fade_out_alpha,
			combat = FreeDB.actionbar.bar2_fade_combat,
			target = FreeDB.actionbar.bar2_fade_target,
			hover = FreeDB.actionbar.bar2_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)

		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_BAR2'], 'Bar2', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateBar3()
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar3', UIParent, 'SecureHandlerStateTemplate')

	if FreeDB.actionbar.bar3_divide then
		frame:Width(18*buttonSizeNormal + 17*margin + 2*padding)
		frame:Height(2*buttonSizeNormal + margin + 2*padding)
	else
		frame:Width(numNormal*buttonSizeNormal + (numNormal-1)*margin + 2*padding)
		frame:Height(buttonSizeNormal + 2*padding)
	end

	if FreeDB.actionbar.bar3_divide then
		frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, FreeADB['ui_gap']}
	else
		frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, FreeADB['ui_gap']+2*(buttonSizeNormal+2*padding)}
	end

	_G.MultiBarBottomRight:SetParent(frame)
	_G.MultiBarBottomRight:EnableMouse(false)

	for i = 1, numNormal do
		local button = _G['MultiBarBottomRightButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeNormal, buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', frame, padding, -padding)
		elseif (i == 4 and FreeDB.actionbar.bar3_divide) then
			local previous = _G['MultiBarBottomRightButton1']
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -padding)
		elseif (i == 7 and FreeDB.actionbar.bar3_divide) then
			local previous = _G['MultiBarBottomRightButton3']
			button:SetPoint('TOPLEFT', previous, 'TOPRIGHT', 12*buttonSizeNormal+13*margin, 0)
		elseif (i == 10 and FreeDB.actionbar.bar3_divide) then
			local previous = _G['MultiBarBottomRightButton7']
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -padding)
		else
			local previous = _G['MultiBarBottomRightButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if FreeDB.actionbar.bar3 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'

		frame.fader = {
			enable = FreeDB.actionbar.bar3_fade,
			fadeInAlpha = FreeDB.actionbar.bar3_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.bar3_fade_out_alpha,
			combat = FreeDB.actionbar.bar3_fade_combat,
			target = FreeDB.actionbar.bar3_fade_target,
			hover = FreeDB.actionbar.bar3_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)

		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_BAR3'], 'Bar3', frame.Pos)
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

	_G.MultiBarRight:SetParent(frame)
	_G.MultiBarRight:EnableMouse(false)
	hooksecurefunc(_G.MultiBarRight, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, numNormal do
		local button = _G['MultiBarRightButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarRightButton'..i-1]
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		end

	end

	if FreeDB.actionbar.bar4 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'

		frame.fader = {
			enable = FreeDB.actionbar.bar4_fade,
			fadeInAlpha = FreeDB.actionbar.bar4_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.bar4_fade_out_alpha,
			combat = FreeDB.actionbar.bar4_fade_combat,
			target = FreeDB.actionbar.bar4_fade_target,
			hover = FreeDB.actionbar.bar4_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)


		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_BAR4'], 'Bar4', frame.Pos)
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

	_G.MultiBarLeft:SetParent(frame)
	_G.MultiBarLeft:EnableMouse(false)
	hooksecurefunc(_G.MultiBarLeft, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, numNormal do
		local button = _G['MultiBarLeftButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarLeftButton'..i-1]
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		end
	end

	if FreeDB.actionbar.bar5 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'

		frame.fader = {
			enable = FreeDB.actionbar.bar5_fade,
			fadeInAlpha = FreeDB.actionbar.bar5_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.bar5_fade_out_alpha,
			combat = FreeDB.actionbar.bar5_fade_combat,
			target = FreeDB.actionbar.bar5_fade_target,
			hover = FreeDB.actionbar.bar5_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)


		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_BAR5'], 'Bar5', frame.Pos)
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreatePetbar()
	local frame = CreateFrame('Frame', 'FreeUI_PetActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numPet*buttonSizeSmall + (numPet-1)*(margin+2) + 2*padding)
	frame:Height(buttonSizeSmall + 2*padding)

	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, FreeADB['ui_gap']+2*(buttonSizeNormal+2*padding)}

	_G.PetActionBarFrame:SetParent(frame)
	_G.PetActionBarFrame:EnableMouse(false)
	_G.SlidingActionBarTexture0:SetTexture(nil)
	_G.SlidingActionBarTexture1:SetTexture(nil)

	for i = 1, numPet do
		local button = _G['PetActionButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeSmall, buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('LEFT', frame, padding, 0)
		else
			local previous = _G['PetActionButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin+2, 0)
		end
		--cooldown fix
		local cd = _G['PetActionButton'..i..'Cooldown']
		cd:SetAllPoints(button)
	end

	if FreeDB.actionbar.pet_bar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide'

		frame.fader = {
			enable = FreeDB.actionbar.pet_bar_fade,
			fadeInAlpha = FreeDB.actionbar.pet_bar_fade_in_alpha,
			fadeOutAlpha = FreeDB.actionbar.pet_bar_fade_out_alpha,
			combat = FreeDB.actionbar.pet_bar_fade_combat,
			target = FreeDB.actionbar.pet_bar_fade_target,
			hover = FreeDB.actionbar.pet_bar_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)

		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_PET'], 'Petbar', frame.Pos)
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
		local leftShown, rightShown = _G.MultiBarBottomLeft:IsShown(), _G.MultiBarBottomRight:IsShown()
		if leftShown and rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif leftShown and not rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar2', 'TOP', 0, 0)
		elseif rightShown and not leftShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif not rightShown and not leftShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
		end
	end
	hooksecurefunc('MultiActionBar_Update', positionBars)

	-- STANCE BAR
	_G.StanceBarFrame:SetParent(frame)
	_G.StanceBarFrame:EnableMouse(false)
	_G.StanceBarLeft:SetTexture(nil)
	_G.StanceBarMiddle:SetTexture(nil)
	_G.StanceBarRight:SetTexture(nil)

	for i = 1, numStance do
		local button = _G['StanceButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeBig, buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['StanceButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	-- POSSESS BAR
	_G.PossessBarFrame:SetParent(frame)
	_G.PossessBarFrame:EnableMouse(false)
	_G.PossessBackground1:SetTexture(nil)
	_G.PossessBackground2:SetTexture(nil)

	for i = 1, _G.NUM_POSSESS_SLOTS do
		local button = _G['PossessButton'..i]
		table.insert(buttonList, button)
		button:Size(buttonSizeBig, buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['PossessButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	if FreeDB.actionbar.stance_bar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	else
		frame.frameVisibility = 'hide'
	end

	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function ACTIONBAR:CreateExtrabar()
	local frame = CreateFrame('Frame', 'FreeUI_ExtraActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:Width(numExtra*buttonSizeBig + (numExtra-1)*margin + 2*padding)
	frame:Height(buttonSizeBig + 2*padding)
	frame.Pos = {'CENTER', UIParent, 'CENTER', 0, 300}
	frame:SetScale(1)

	_G.ExtraActionBarFrame:SetParent(frame)
	_G.ExtraActionBarFrame:EnableMouse(false)
	_G.ExtraActionBarFrame:ClearAllPoints()
	_G.ExtraActionBarFrame:SetPoint('CENTER', 0, 0)
	_G.ExtraActionBarFrame.ignoreFramePositionManager = true

	local button = _G.ExtraActionButton1
	table.insert(buttonList, button)

	button:Size(buttonSizeBig, buttonSizeBig)

	frame.frameVisibility = '[extrabar] show; hide'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_EXTRA'], 'Extrabar', frame.Pos)

	--zone ability
	_G.ZoneAbilityFrame:ClearAllPoints()
	_G.ZoneAbilityFrame.ignoreFramePositionManager = true
	_G.ZoneAbilityFrameNormalTexture:SetAlpha(0)
	_G.ZoneAbilityFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 300)

	local spellButton = _G.ZoneAbilityFrame.SpellButton
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
	frame.Pos = {'CENTER', UIParent, 'CENTER', 0, 200}

	local button = CreateFrame('CheckButton', 'FreeUI_LeaveVehicleButton', frame, 'ActionButtonTemplate, SecureHandlerClickTemplate')
	table.insert(buttonList, button)

	button:RegisterForClicks('AnyUp')

	button.icon.__lockdown = true


	if FreeDB.unitframe.enable_unitframe and FreeDB.unitframe.combat_fader then
		button:SetSize(buttonSizeNormal, buttonSizeNormal)
		button:SetPoint('BOTTOMLEFT', frame, padding, padding)

		button.icon:SetTexture('INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up')
		button.icon:SetTexCoord(.216, .784, .216, .784)
		button.icon:SetDrawLayer('ARTWORK')

		frame.mover = F.Mover(frame, L['ACTIONBAR_MOVER_VEHICLE'], 'LeaveVehicleButton', frame.Pos)
	end


	button:HookScript('OnEnter', _G.MainMenuBarVehicleLeaveButton_OnEnter)
	button:HookScript('OnLeave', F.HideTooltip)
	button:SetScript('OnClick', function(self)
		if UnitOnTaxi('player') then TaxiRequestEarlyLanding() else VehicleExit() end
		self:SetChecked(true)
	end)
	button:SetScript('OnShow', function(self)
		self:SetChecked(false)
	end)

	frame.frameVisibility = '[canexitvehicle]c;[mounted]m;n'
	RegisterStateDriver(frame, 'exit', frame.frameVisibility)

	frame:SetAttribute('_onstate-exit', [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
	if not CanExitVehicle() then frame:Hide() end
end

local scripts = {
	'OnShow', 'OnHide', 'OnEvent', 'OnEnter', 'OnLeave', 'OnUpdate', 'OnValueChanged', 'OnClick', 'OnMouseDown', 'OnMouseUp',
}

local framesToHide = {
	_G.MainMenuBar, _G.OverrideActionBar,
}

local framesToDisable = {
	_G.MainMenuBar,
	_G.MicroButtonAndBagsBar, _G.MainMenuBarArtFrame, _G.StatusTrackingBarManager,
	_G.ActionBarDownButton, _G.ActionBarUpButton, _G.MainMenuBarVehicleLeaveButton,
	_G.OverrideActionBar,
	_G.OverrideActionBarExpBar, _G.OverrideActionBarHealthBar, _G.OverrideActionBarPowerBar, _G.OverrideActionBarPitchFrame,
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

function ACTIONBAR:RemoveBlizzArt()
	_G.MainMenuBar:SetMovable(true)
	_G.MainMenuBar:SetUserPlaced(true)
	_G.MainMenuBar.ignoreFramePositionManager = true
	_G.MainMenuBar:SetAttribute('ignoreFramePositionManager', true)

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
			_G.ActionButton_ShowGrid(button, _G.ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
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
		_G.TokenFrame_LoadUI()
		_G.TokenFrame_Update()
		_G.BackpackTokenFrame_Update()
	end
	F:RegisterEvent('CURRENCY_DISPLAY_UPDATE', updateToken)
end


function ACTIONBAR:OnLogin()
	if not FreeDB.actionbar.enable_actionbar then return end

	padding = F:Scale(FreeDB.actionbar.bar_padding)
	margin = F:Scale(FreeDB.actionbar.button_margin)
	buttonSizeNormal = F:Scale(FreeDB.actionbar.button_size_normal)
	buttonSizeSmall = F:Scale(FreeDB.actionbar.button_size_small)
	buttonSizeBig = F:Scale(FreeDB.actionbar.button_size_big)

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

	F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomLeft)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomRight)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelRight)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelRightTwo)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelStackRightBars)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelAlwaysShowActionBars)

	if _G.PlayerTalentFrame then
		_G.PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			_G.PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end

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
