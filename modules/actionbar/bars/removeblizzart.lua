local F = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

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
    _G.MainMenuBar,
    _G.OverrideActionBar
}

local framesToDisable = {
    _G.MainMenuBar,
    _G.MicroButtonAndBagsBar,
    _G.MainMenuBarArtFrame,
    _G.StatusTrackingBarManager,
    _G.ActionBarDownButton,
    _G.ActionBarUpButton,
    _G.MainMenuBarVehicleLeaveButton,
    _G.OverrideActionBar,
    _G.OverrideActionBarExpBar,
    _G.OverrideActionBarHealthBar,
    _G.OverrideActionBarPowerBar,
    _G.OverrideActionBarPitchFrame
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
            button:ShowGrid(_G.ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
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
    _G.TokenFrame_LoadUI()
    _G.TokenFrame_Update()
    _G.BackpackTokenFrame_Update()
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

    -- Fix maw block anchor
    _G.MainMenuBarVehicleLeaveButton:RegisterEvent('PLAYER_ENTERING_WORLD')

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
