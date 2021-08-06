local _G = _G
local unpack = unpack
local select = select
local next = next
local tonumber = tonumber
local TokenFrame_LoadUI = TokenFrame_LoadUI
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

local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('Actionbar')

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

local function ButtonShowGrid(name, showgrid)
    for i = 1, 12 do
        local button = _G[name .. i]
        if button then
            button:SetAttribute('showgrid', showgrid)
            button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
        end
    end
end

local updateAfterCombat
local function ToggleButtonGrid()
    if InCombatLockdown() then
        updateAfterCombat = true
        F:RegisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
    else
        local showgrid = tonumber(GetCVar('alwaysShowActionBars'))
        ButtonShowGrid('ActionButton', showgrid)
        ButtonShowGrid('MultiBarBottomRightButton', showgrid)
        ButtonShowGrid('FreeUI_CustomBarButton', showgrid)
        if updateAfterCombat then
            F:UnregisterEvent('PLAYER_REGEN_ENABLED', ToggleButtonGrid)
            updateAfterCombat = false
        end
    end
end

local function UpdateTokenVisibility()
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

    -- Fix maw block anchor
    MainMenuBarVehicleLeaveButton:RegisterEvent('PLAYER_ENTERING_WORLD')

    -- Update button grid
    ToggleButtonGrid()
    hooksecurefunc('MultiActionBar_UpdateGridVisibility', ToggleButtonGrid)

    -- Update token panel
    F:RegisterEvent('CURRENCY_DISPLAY_UPDATE', UpdateTokenVisibility)

    F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomLeft)
    F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomRight)
    F.HideOption(_G.InterfaceOptionsActionBarsPanelRight)
    F.HideOption(_G.InterfaceOptionsActionBarsPanelRightTwo)
    F.HideOption(_G.InterfaceOptionsActionBarsPanelStackRightBars)
end
