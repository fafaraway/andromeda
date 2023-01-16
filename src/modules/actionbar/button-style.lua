local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

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
    { 'CAPSLOCK', 'CL' },
    { 'Capslock', 'CL' },
    { 'BUTTON', 'M' },
    { 'NUMPAD', 'N' },
    { '(ALT%-)', 'a' },
    { '(CTRL%-)', 'c' },
    { '(SHIFT%-)', 's' },
    { 'MOUSEWHEELUP', 'MU' },
    { 'MOUSEWHEELDOWN', 'MD' },
    { 'SPACE', 'Sp' },
}

function ACTIONBAR:UpdateHotkey()
    local text = self:GetText()
    if not text then
        return
    end

    if text == _G.RANGE_INDICATOR then
        text = ''
    else
        for _, value in pairs(replaces) do
            text = gsub(text, value[1], value[2])
        end
    end

    self:SetFormattedText('|cffffffff%s|r', text)
end

function ACTIONBAR:UpdateEquipedBorder(button)
    if not button.__bg then
        return
    end

    if button.Border:IsShown() then
        button.__bg:SetBackdropBorderColor(0, 0.7, 0.1)
    else
        button.__bg:SetBackdropBorderColor(0, 0, 0)
    end
end

function ACTIONBAR:HandleButton(btn)
    if not btn then
        return
    end

    if btn.__styled then
        return
    end

    local btnName = btn:GetName()
    local icon = btn.icon
    local cooldown = btn.cooldown
    local hotkey = btn.HotKey
    local flash = btn.Flash
    local border = btn.Border
    local normal = btn.NormalTexture
    local normal2 = btn:GetNormalTexture()
    local slotbg = btn.SlotBackground
    local pushed = btn.PushedTexture
    local checked = btn.CheckedTexture
    local highlight = btn.HighlightTexture
    local newActionTexture = btn.NewActionTexture
    local spellHighlight = btn.SpellHighlightTexture
    local iconMask = btn.IconMask
    local petShine = _G[btnName .. 'Shine']
    local autoCastable = btn.AutoCastable

    if normal then
        normal:SetAlpha(0)
    end
    if normal2 then
        normal2:SetAlpha(0)
    end
    if flash then
        flash:SetTexture(nil)
    end
    if newActionTexture then
        newActionTexture:SetTexture(nil)
    end
    if border then
        border:SetTexture(nil)
    end
    if slotbg then
        slotbg:Hide()
    end
    if iconMask then
        iconMask:Hide()
    end
    if btn.style then
        btn.style:SetAlpha(0)
    end
    if petShine then
        petShine:SetInside()
    end
    if autoCastable then
        autoCastable:SetTexCoord(0.217, 0.765, 0.217, 0.765)
        autoCastable:SetInside()
    end

    if icon then
        icon:SetInside()
        if not icon.__lockdown then
            icon:SetTexCoord(unpack(C.TEX_COORD))
        end
        btn.__bg = F.SetBD(icon, 0.25)
    end

    if cooldown then
        cooldown:SetAllPoints()
    end

    if pushed then
        pushed:SetInside()
        pushed:SetTexture(C.Assets.Textures.ButtonPushed)
    end

    if checked then
        checked:SetInside()
        checked:SetColorTexture(1, 0.8, 0, 0.35)
    end

    if highlight then
        highlight:SetInside()
        highlight:SetColorTexture(1, 1, 1, 0.25)
    end

    if spellHighlight then
        spellHighlight:SetOutside()
    end

    if hotkey then
        ACTIONBAR.UpdateHotkey(hotkey)
        hooksecurefunc(hotkey, 'SetText', ACTIONBAR.UpdateHotkey)
    end

    btn.__styled = true
end

function ACTIONBAR:RestyleButtons()
    for i = 1, 8 do
        for j = 1, 12 do
            ACTIONBAR:HandleButton(_G[C.ADDON_TITLE .. 'ActionBar' .. i .. 'Button' .. j])
        end
    end

    -- petbar buttons
    for i = 1, _G.NUM_PET_ACTION_SLOTS do
        ACTIONBAR:HandleButton(_G['PetActionButton' .. i])
    end

    -- stancebar buttons
    for i = 1, 10 do
        ACTIONBAR:HandleButton(_G['StanceButton' .. i])
    end

    -- leave vehicle
    ACTIONBAR:HandleButton(_G[C.ADDON_TITLE .. 'LeaveVehicleButton'])

    -- extra action button
    ACTIONBAR:HandleButton(_G.ExtraActionButton1)

    --spell flyout
    _G.SpellFlyout.Background:SetAlpha(0)
    local numFlyouts = 1
    local function checkForFlyoutButtons()
        local button = _G['SpellFlyoutButton' .. numFlyouts]
        while button do
            ACTIONBAR:HandleButton(button)
            numFlyouts = numFlyouts + 1
            button = _G['SpellFlyoutButton' .. numFlyouts]
        end
    end

    _G.SpellFlyout:HookScript('OnShow', checkForFlyoutButtons)
    _G.SpellFlyout:HookScript('OnHide', checkForFlyoutButtons)
end
