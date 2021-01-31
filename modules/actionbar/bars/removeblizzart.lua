local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR

local _G = _G
local next = next
local tonumber = tonumber
local TokenFrame_LoadUI= TokenFrame_LoadUI
local TokenFrame_Update = TokenFrame_Update
local BackpackTokenFrame_Update = BackpackTokenFrame_Update
local InCombatLockdown = InCombatLockdown
local GetCVar = GetCVar
local hooksecurefunc = hooksecurefunc
local ACTION_BUTTON_SHOW_GRID_REASON_CVAR = ACTION_BUTTON_SHOW_GRID_REASON_CVAR
local MainMenuBar = MainMenuBar
local OverrideActionBar = OverrideActionBar
local MicroButtonAndBagsBar = MicroButtonAndBagsBar
local MainMenuBarArtFrame = MainMenuBarArtFrame
local StatusTrackingBarManager = StatusTrackingBarManager
local ActionBarDownButton = ActionBarDownButton
local ActionBarUpButton = ActionBarUpButton
local MainMenuBarVehicleLeaveButton = MainMenuBarVehicleLeaveButton
local OverrideActionBarExpBar = OverrideActionBarExpBar
local OverrideActionBarHealthBar = OverrideActionBarHealthBar
local OverrideActionBarPowerBar = OverrideActionBarPowerBar
local OverrideActionBarPitchFrame = OverrideActionBarPitchFrame

local scripts = {
	'OnShow',
	'OnHide',
	'OnEvent',
	'OnEnter',
	'OnLeave',
	'OnUpdate',
	'OnValueChanged',
	'OnClick',
	'OnMouseDown',
	'OnMouseUp'
}

local framesToHide = {
	MainMenuBar,
	OverrideActionBar
}

local framesToDisable = {
	MainMenuBar,
	MicroButtonAndBagsBar,
	MainMenuBarArtFrame,
	StatusTrackingBarManager,
	ActionBarDownButton,
	ActionBarUpButton,
	MainMenuBarVehicleLeaveButton,
	OverrideActionBar,
	OverrideActionBarExpBar,
	OverrideActionBarHealthBar,
	OverrideActionBarPowerBar,
	OverrideActionBarPitchFrame
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

local function buttonShowGrid(name, showgrid)
	for i = 1, 12 do
		local button = _G[name .. i]
		if button then
			button:SetAttribute('showgrid', showgrid)
			button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
		end
	end
end

local updateAfterCombat
local function toggleButtonGrid()
	if InCombatLockdown() then
		updateAfterCombat = true
		F:RegisterEvent('PLAYER_REGEN_ENABLED', toggleButtonGrid)
	else
		local showgrid = tonumber(GetCVar('alwaysShowActionBars'))
		buttonShowGrid('ActionButton', showgrid)
		buttonShowGrid('MultiBarBottomRightButton', showgrid)
		buttonShowGrid('NDui_CustomBarButton', showgrid)
		if updateAfterCombat then
			F:UnregisterEvent('PLAYER_REGEN_ENABLED', toggleButtonGrid)
			updateAfterCombat = false
		end
	end
end

local function hideFakeExtraBar(event, addon)
	if addon == 'Blizzard_BindingUI' then
		F.HideObject(_G.QuickKeybindFrame.phantomExtraActionButton)
		F:UnregisterEvent(event, hideFakeExtraBar)
	end
end

local function updateTokenVisibility()
	TokenFrame_LoadUI()
	TokenFrame_Update()
	BackpackTokenFrame_Update()
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
	hooksecurefunc('MultiActionBar_UpdateGridVisibility', toggleButtonGrid)
	-- Update token panel
	F:RegisterEvent('CURRENCY_DISPLAY_UPDATE', updateTokenVisibility)
	-- Fake ExtraActionButton
	F:RegisterEvent('ADDON_LOADED', hideFakeExtraBar)

	F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomLeft)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomRight)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelRight)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelRightTwo)
	F.HideOption(_G.InterfaceOptionsActionBarsPanelStackRightBars)
end
