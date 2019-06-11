local F, C = unpack(select(2, ...))
local Bar = F:GetModule('Actionbar')

local _G = _G
local next, tonumber = next, tonumber
local ACTION_BUTTON_SHOW_GRID_REASON_CVAR = ACTION_BUTTON_SHOW_GRID_REASON_CVAR

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

function Bar:HideBlizz()
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


do -- Prevents spells from being automatically added to your action bar
	IconIntroTracker.RegisterEvent = function() end
	IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

	local iit = CreateFrame('frame')
	iit:SetScript('OnEvent', function(self, event, spellID, slotIndex, slotPos)
		if not InCombatLockdown() then
			ClearCursor()
			PickupAction(slotIndex)
			ClearCursor()
		end
	end)
	iit:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
end

-- remove talent alert
function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
	return false
end
function TalentMicroButtonAlert:Show()
	TalentMicroButtonAlert:Hide();
end