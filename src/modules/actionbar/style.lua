local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

-- Remove blizzard stuffs

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
    'OnMouseUp',
}

local framesToHide = {
    _G.MainMenuBar,
    _G.OverrideActionBar,
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
    _G.OverrideActionBarPitchFrame,
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

    -- F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomLeft)
    -- F.HideOption(_G.InterfaceOptionsActionBarsPanelBottomRight)
    -- F.HideOption(_G.InterfaceOptionsActionBarsPanelRight)
    -- F.HideOption(_G.InterfaceOptionsActionBarsPanelRightTwo)
    -- F.HideOption(_G.InterfaceOptionsActionBarsPanelStackRightBars)
end

-- Restyle actionbar buttons

local function CallButtonFunctionByName(button, func, ...)
    if button and func and button[func] then
        button[func](button, ...)
    end
end

local function ResetNormalTexture(self, file)
    if not self.__normalTextureFile then
        return
    end
    if file == self.__normalTextureFile then
        return
    end
    self:SetNormalTexture(self.__normalTextureFile)
end

local function ResetTexture(self, file)
    if not self.__textureFile then
        return
    end
    if file == self.__textureFile then
        return
    end
    self:SetTexture(self.__textureFile)
end

local function ResetVertexColor(self, r, g, b, a)
    if not self.__vertexColor then
        return
    end
    local r2, g2, b2, a2 = unpack(self.__vertexColor)
    if not a2 then
        a2 = 1
    end
    if r ~= r2 or g ~= g2 or b ~= b2 or a ~= a2 then
        self:SetVertexColor(r2, g2, b2, a2)
    end
end

local function ApplyPoints(self, points)
    if not points then
        return
    end
    self:ClearAllPoints()
    for _, point in next, points do
        self:SetPoint(unpack(point))
    end
end

local function ApplyTexCoord(texture, texCoord)
    if texture.__lockdown or not texCoord then
        return
    end
    texture:SetTexCoord(unpack(texCoord))
end

local function ApplyVertexColor(texture, color)
    if not color then
        return
    end
    texture.__vertexColor = color
    texture:SetVertexColor(unpack(color))
    hooksecurefunc(texture, 'SetVertexColor', ResetVertexColor)
end

local function ApplyAlpha(region, alpha)
    if not alpha then
        return
    end
    region:SetAlpha(alpha)
end

local function ApplyFont(fontString, font)
    if not font then
        return
    end
    fontString:SetFont(unpack(font))
end

local function ApplyFontColor(fontString, color)
    if not color then
        return
    end
    fontString:SetTextColor(color[1], color[2], color[3])
end

local function ApplyFontShadow(fontString, shadow)
    if not shadow then
        return
    end
    fontString:SetShadowColor(shadow[1], shadow[2], shadow[3], shadow[4])
    fontString:SetShadowOffset(shadow[5], shadow[6])
end

local function ApplyHorizontalAlign(fontString, align)
    if not align then
        return
    end
    fontString:SetJustifyH(align)
end

local function ApplyVerticalAlign(fontString, align)
    if not align then
        return
    end
    fontString:SetJustifyV(align)
end

local function ApplyTexture(texture, file)
    if not file then
        return
    end
    texture.__textureFile = file
    texture:SetTexture(file)
    hooksecurefunc(texture, 'SetTexture', ResetTexture)
end

local function ApplyNormalTexture(button, file)
    if not file then
        return
    end
    button.__normalTextureFile = file
    button:SetNormalTexture(file)
    hooksecurefunc(button, 'SetNormalTexture', ResetNormalTexture)
end

local function SetupTexture(texture, cfg, func, button)
    if not texture or not cfg then
        return
    end
    ApplyTexCoord(texture, cfg.texCoord)
    ApplyPoints(texture, cfg.points)
    ApplyVertexColor(texture, cfg.color)
    ApplyAlpha(texture, cfg.alpha)
    if func == 'SetTexture' then
        ApplyTexture(texture, cfg.file)
    elseif func == 'SetNormalTexture' then
        ApplyNormalTexture(button, cfg.file)
    elseif cfg.file then
        CallButtonFunctionByName(button, func, cfg.file)
    end
end

local function SetupFontString(fontString, cfg)
    if not fontString or not cfg then
        return
    end
    ApplyPoints(fontString, cfg.points)
    ApplyFont(fontString, cfg.font)
    ApplyFontColor(fontString, cfg.color)
    ApplyFontShadow(fontString, cfg.shadow)
    ApplyAlpha(fontString, cfg.alpha)
    ApplyHorizontalAlign(fontString, cfg.halign)
    ApplyVerticalAlign(fontString, cfg.valign)
end

local function SetupCooldown(cooldown, cfg)
    if not cooldown or not cfg then
        return
    end
    ApplyPoints(cooldown, cfg.points)
end

local function SetupBackdrop(icon)
    local bg = F.SetBD(icon, 0.25)
    if C.DB.Actionbar.ClassColor then
        bg:SetBackdropColor(C.r, C.g, C.b, 0.25)
    else
        bg:SetBackdropColor(0.1, 0.1, 0.1, 0.25)
    end

    icon:GetParent().__bg = bg
end

local keyButton = gsub(_G.KEY_BUTTON4, '%d', '')
local keyNumpad = gsub(_G.KEY_NUMPAD1, '%d', '')

local replaces = {
    { '(' .. keyButton .. ')', 'M' },
    { '(' .. keyNumpad .. ')', 'N' },
    { '(a%-)', 'a' },
    { '(c%-)', 'c' },
    { '(s%-)', 's' },
    { _G.KEY_BUTTON3, 'M3' },
    { _G.KEY_MOUSEWHEELUP, 'MU' },
    { _G.KEY_MOUSEWHEELDOWN, 'MD' },
    { _G.KEY_SPACE, 'Sp' },
    { _G.CAPSLOCK_KEY_TEXT, 'CL' },
    { 'BUTTON', 'M' },
    { 'NUMPAD', 'N' },
    { '(ALT%-)', 'a' },
    { '(CTRL%-)', 'c' },
    { '(SHIFT%-)', 's' },
    { 'MOUSEWHEELUP', 'MU' },
    { 'MOUSEWHEELDOWN', 'MD' },
    { 'SPACE', 'Sp' },
}

function ACTIONBAR:UpdateHotKey()
    local hotkey = _G[self:GetName() .. 'HotKey']
    if hotkey and hotkey:IsShown() and not C.DB.Actionbar.Hotkey then
        hotkey:Hide()
        return
    end

    local text = hotkey:GetText()
    if not text then
        return
    end

    for _, value in pairs(replaces) do
        text = gsub(text, value[1], value[2])
    end

    if text == _G.RANGE_INDICATOR then
        hotkey:SetText('')
    else
        hotkey:SetText('|cffffffff' .. text)
    end
end

function ACTIONBAR:HookHotKey(button)
    ACTIONBAR.UpdateHotKey(button)
    if button.UpdateHotkeys then
        hooksecurefunc(button, 'UpdateHotkeys', ACTIONBAR.UpdateHotKey)
    end
end

function ACTIONBAR:UpdateEquipItemColor()
    if not self.__bg then
        return
    end

    if C.DB.Actionbar.EquipColor and IsEquippedAction(self.action) then
        self.__bg:SetBackdropBorderColor(0, 0.7, 0.1)
    else
        self.__bg:SetBackdropBorderColor(0, 0, 0)
    end
end

function ACTIONBAR:EquipItemColor(button)
    if not button.Update then
        return
    end
    hooksecurefunc(button, 'Update', ACTIONBAR.UpdateEquipItemColor)
end

function ACTIONBAR:StyleActionButton(button, cfg)
    if not button then
        return
    end
    if button.__styled then
        return
    end

    local buttonName = button:GetName()
    local icon = _G[buttonName .. 'Icon']
    local flash = _G[buttonName .. 'Flash']
    local flyoutBorder = _G[buttonName .. 'FlyoutBorder']
    local flyoutBorderShadow = _G[buttonName .. 'FlyoutBorderShadow']
    local hotkey = _G[buttonName .. 'HotKey']
    local count = _G[buttonName .. 'Count']
    local name = _G[buttonName .. 'Name']
    local border = _G[buttonName .. 'Border']
    local autoCastable = _G[buttonName .. 'AutoCastable']
    local NewActionTexture = button.NewActionTexture
    local cooldown = _G[buttonName .. 'Cooldown']
    local normalTexture = button:GetNormalTexture()
    local pushedTexture = button:GetPushedTexture()
    local highlightTexture = button:GetHighlightTexture()

    -- normal buttons do not have a checked texture
    -- but checkbuttons do and normal actionbuttons are checkbuttons
    local checkedTexture
    if button.GetCheckedTexture then
        checkedTexture = button:GetCheckedTexture()
    end
    -- checkedTexture:SetVertexColor(C.r, C.g, C.b, 1)
    local floatingBG = _G[buttonName .. 'FloatingBG']

    -- pet stuff
    local petShine = _G[buttonName .. 'Shine']
    if petShine then
        petShine:SetInside()
    end

    -- hide stuff
    if floatingBG then
        floatingBG:Hide()
    end
    if NewActionTexture then
        NewActionTexture:SetTexture(nil)
    end

    -- backdrop
    SetupBackdrop(icon)
    ACTIONBAR:EquipItemColor(button)

    -- textures
    SetupTexture(icon, cfg.icon, 'SetTexture', icon)
    SetupTexture(flash, cfg.flash, 'SetTexture', flash)
    SetupTexture(flyoutBorder, cfg.flyoutBorder, 'SetTexture', flyoutBorder)
    SetupTexture(flyoutBorderShadow, cfg.flyoutBorderShadow, 'SetTexture', flyoutBorderShadow)
    SetupTexture(border, cfg.border, 'SetTexture', border)
    SetupTexture(normalTexture, cfg.normalTexture, 'SetNormalTexture', button)
    SetupTexture(pushedTexture, cfg.pushedTexture, 'SetPushedTexture', button)
    SetupTexture(highlightTexture, cfg.highlightTexture, 'SetHighlightTexture', button)
    -- SetupTexture(checkedTexture, cfg.checkedTexture, 'SetCheckedTexture', button)

    -- checkedTexture:SetColorTexture(1, .8, 0, .35)
    -- highlightTexture:SetColorTexture(1, 1, 1, .25)

    if checkedTexture then
        SetupTexture(checkedTexture, cfg.checkedTexture, 'SetCheckedTexture', button)
        checkedTexture:SetColorTexture(1, 0.8, 0, 0.35)
    end

    -- cooldown
    SetupCooldown(cooldown, cfg.cooldown)

    -- no clue why but blizzard created count and duration on background layer, need to fix that
    local overlay = CreateFrame('Frame', nil, button)
    overlay:SetAllPoints()
    if count then
        if C.DB.Actionbar.CountNumber then
            count:SetParent(overlay)
            SetupFontString(count, cfg.count)
        else
            count:Hide()
        end
    end
    if hotkey then
        hotkey:SetParent(overlay)
        ACTIONBAR:HookHotKey(button)
        SetupFontString(hotkey, cfg.hotkey)
    end
    if name then
        if C.DB.Actionbar.MacroName then
            name:SetParent(overlay)
            SetupFontString(name, cfg.name)
        else
            name:Hide()
        end
    end

    if autoCastable then
        autoCastable:SetTexCoord(0.217, 0.765, 0.217, 0.765)
        autoCastable:SetInside()
    end

    ACTIONBAR:RegisterButtonRange(button)

    button.__styled = true
end

function ACTIONBAR:StyleExtraActionButton(cfg)
    local button = _G.ExtraActionButton1
    if button.__styled then
        return
    end

    local buttonName = button:GetName()
    local icon = _G[buttonName .. 'Icon']
    -- local flash = _G[buttonName..'Flash'] --wierd the template has two textures of the same name
    local hotkey = _G[buttonName .. 'HotKey']
    local count = _G[buttonName .. 'Count']
    local buttonstyle = button.style -- artwork around the button
    local cooldown = _G[buttonName .. 'Cooldown']

    button:SetPushedTexture(C.Assets.Button.Pushed) -- force it to gain a texture
    local normalTexture = button:GetNormalTexture()
    local pushedTexture = button:GetPushedTexture()
    local highlightTexture = button:GetHighlightTexture()
    local checkedTexture = button:GetCheckedTexture()

    -- backdrop
    SetupBackdrop(icon)

    -- textures
    SetupTexture(icon, cfg.icon, 'SetTexture', icon)
    SetupTexture(buttonstyle, cfg.buttonstyle, 'SetTexture', buttonstyle)
    SetupTexture(normalTexture, cfg.normalTexture, 'SetNormalTexture', button)
    SetupTexture(pushedTexture, cfg.pushedTexture, 'SetPushedTexture', button)
    SetupTexture(highlightTexture, cfg.highlightTexture, 'SetHighlightTexture', button)
    SetupTexture(checkedTexture, cfg.checkedTexture, 'SetCheckedTexture', button)
    -- highlightTexture:SetColorTexture(1, 1, 1, .25)

    -- cooldown
    SetupCooldown(cooldown, cfg.cooldown)

    -- hotkey, count
    local overlay = CreateFrame('Frame', nil, button)
    overlay:SetAllPoints()

    hotkey:SetParent(overlay)
    ACTIONBAR:HookHotKey(button)
    -- cfg.hotkey.font = {C.Assets.Font.Pixel, 8, 'OUTLINE, MONOCHROME'}
    SetupFontString(hotkey, cfg.hotkey)

    if C.DB.Actionbar.CountNumber then
        count:SetParent(overlay)
        SetupFontString(count, cfg.count)
    else
        count:Hide()
    end

    ACTIONBAR:RegisterButtonRange(button)

    button.__styled = true
end

function ACTIONBAR:UpdateStanceHotKey()
    for i = 1, _G.NUM_STANCE_SLOTS do
        _G['StanceButton' .. i .. 'HotKey']:SetText(GetBindingKey('SHAPESHIFTBUTTON' .. i))
        ACTIONBAR:HookHotKey(_G['StanceButton' .. i])
    end
end

function ACTIONBAR:StyleAllActionButtons(cfg)
    for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
        ACTIONBAR:StyleActionButton(_G['ActionButton' .. i], cfg)
        ACTIONBAR:StyleActionButton(_G['MultiBarBottomLeftButton' .. i], cfg)
        ACTIONBAR:StyleActionButton(_G['MultiBarBottomRightButton' .. i], cfg)
        ACTIONBAR:StyleActionButton(_G['MultiBarRightButton' .. i], cfg)
        ACTIONBAR:StyleActionButton(_G['MultiBarLeftButton' .. i], cfg)
    end

    for i = 1, 6 do
        ACTIONBAR:StyleActionButton(_G['OverrideActionBarButton' .. i], cfg)
    end

    -- petbar buttons
    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        ACTIONBAR:StyleActionButton(_G['PetActionButton' .. i], cfg)
    end

    -- stancebar buttons
    for i = 1, _G.NUM_STANCE_SLOTS do
        ACTIONBAR:StyleActionButton(_G['StanceButton' .. i], cfg)
    end

    -- possess buttons
    for i = 1, _G.NUM_POSSESS_SLOTS do
        ACTIONBAR:StyleActionButton(_G['PossessButton' .. i], cfg)
    end

    -- leave vehicle
    ACTIONBAR:StyleActionButton(_G[C.ADDON_TITLE .. 'LeaveVehicleButton'], cfg)

    -- extra action button
    ACTIONBAR:StyleExtraActionButton(cfg)

    -- spell flyout
    _G.SpellFlyoutBackgroundEnd:SetTexture(nil)
    _G.SpellFlyoutHorizontalBackground:SetTexture(nil)
    _G.SpellFlyoutVerticalBackground:SetTexture(nil)
    local function checkForFlyoutButtons()
        local i = 1
        local button = _G['SpellFlyoutButton' .. i]
        while button and button:IsShown() do
            ACTIONBAR:StyleActionButton(button, cfg)
            i = i + 1
            button = _G['SpellFlyoutButton' .. i]
        end
    end
    _G.SpellFlyout:HookScript('OnShow', checkForFlyoutButtons)
end

function ACTIONBAR:RestyleButtons()
    local cfg = {
        icon = { texCoord = C.TEX_COORD, points = { { 'TOPLEFT', C.MULT, -C.MULT }, { 'BOTTOMRIGHT', -C.MULT, C.MULT } } },
        flyoutBorder = { file = '' },
        flyoutBorderShadow = { file = '' },
        border = { file = '' },
        normalTexture = {
            file = C.Assets.Button.Normal,
            color = { 0.3, 0.3, 0.3 },
            points = { { 'TOPLEFT', C.MULT, -C.MULT }, { 'BOTTOMRIGHT', -C.MULT, C.MULT } },
        },
        flash = { file = C.Assets.Button.Flash },
        pushedTexture = {
            file = C.Assets.Button.Pushed,
            color = { C.r, C.g, C.b },
            points = { { 'TOPLEFT', C.MULT, -C.MULT }, { 'BOTTOMRIGHT', -C.MULT, C.MULT } },
        },
        checkedTexture = {
            file = C.Assets.Button.Checked,
            color = { 0.2, 1, 0.2 },
            points = { { 'TOPLEFT', C.MULT, -C.MULT }, { 'BOTTOMRIGHT', -C.MULT, C.MULT } },
        },
        highlightTexture = {
            file = C.Assets.Button.Highlight,
            points = { { 'TOPLEFT', C.MULT, -C.MULT }, { 'BOTTOMRIGHT', -C.MULT, C.MULT } },
        },
        cooldown = { points = { { 'TOPLEFT', 0, 0 }, { 'BOTTOMRIGHT', 0, 0 } } },
        name = {
            font = { C.Assets.Font.Condensed, 10, 'OUTLINE' },
            points = { { 'BOTTOMLEFT', 0, 2 } },
            color = { 0.5, 0.5, 0.5 },
            shadow = { 0, 0, 0, 1, 1, -1 },
        },
        hotkey = {
            font = { C.Assets.Font.Condensed, 10, 'OUTLINE' },
            points = { { 'TOPRIGHT', -2, -2 } },
            color = { 1, 1, 1 },
            shadow = { 0, 0, 0, 1, 1, -1 },
        },
        count = {
            font = { C.Assets.Font.Condensed, 10, 'OUTLINE' },
            points = { { 'BOTTOMLEFT', 2, 2 } },
            color = { 0.19, 0.75, 1 },
            shadow = { 0, 0, 0, 1, 1, -1 },
        },
        buttonstyle = { file = '' },
    }

    ACTIONBAR:StyleAllActionButtons(cfg)

    -- Update hotkeys
    hooksecurefunc('PetActionButton_SetHotkeys', ACTIONBAR.UpdateHotKey)
    ACTIONBAR:UpdateStanceHotKey()
    F:RegisterEvent('UPDATE_BINDINGS', ACTIONBAR.UpdateStanceHotKey)
end
