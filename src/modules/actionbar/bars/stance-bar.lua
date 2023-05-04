local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local num = _G.NUM_STANCE_SLOTS or 10

function ACTIONBAR:UpdateStanceBar()
    if InCombatLockdown() then
        return
    end

    local frame = _G[C.ADDON_TITLE .. 'ActionBarStance']
    if not frame then
        return
    end

    local size = C.DB['Actionbar']['BarStanceButtonSize']
    local fontSize = C.DB['Actionbar']['BarStanceFontSize']
    local perRow = C.DB['Actionbar']['BarStanceButtonPerRow']
    local margin = C.DB['Actionbar']['ButtonMargin']
    local padding = C.DB['Actionbar']['BarPadding']

    for i = 1, num do
        local button = frame.buttons[i]
        button:SetSize(size, size)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint('TOPLEFT', frame, padding, -padding)
        elseif mod(i - 1, perRow) == 0 then
            button:SetPoint('TOP', frame.buttons[i - perRow], 'BOTTOM', 0, -margin)
        else
            button:SetPoint('LEFT', frame.buttons[i - 1], 'RIGHT', margin, 0)
        end
        ACTIONBAR:UpdateButtonFont(button, fontSize)
    end

    local column = min(num, perRow)
    local rows = ceil(num / perRow)
    frame:SetWidth(column * size + (column - 1) * margin + 2 * padding)
    frame:SetHeight(size * rows + (rows - 1) * margin + 2 * padding)
    frame.mover:SetSize(size, size)
end

function ACTIONBAR:UpdateStance()
    local inCombat = InCombatLockdown()
    local numForms = GetNumShapeshiftForms()
    local texture, isActive, isCastable
    local icon, cooldown
    local start, duration, enable

    for i, button in pairs(self.actionButtons) do
        if not inCombat then
            button:Hide()
        end

        icon = button.icon
        if i <= numForms then
            texture, isActive, isCastable = GetShapeshiftFormInfo(i)
            icon:SetTexture(texture)

            --Cooldown stuffs
            cooldown = button.cooldown
            if texture then
                if not inCombat then
                    button:Show()
                end
                cooldown:Show()
            else
                cooldown:Hide()
            end
            start, duration, enable = GetShapeshiftFormCooldown(i)
            CooldownFrame_Set(cooldown, start, duration, enable)

            if isActive then
                button:SetChecked(true)
            else
                button:SetChecked(false)
            end

            if isCastable then
                icon:SetVertexColor(1.0, 1.0, 1.0)
            else
                icon:SetVertexColor(0.4, 0.4, 0.4)
            end
        end
    end
end

function ACTIONBAR:StanceBarOnEvent()
    ACTIONBAR:UpdateStanceBar()
    ACTIONBAR.UpdateStance(_G.StanceBar)
end

function ACTIONBAR:CreateStanceBar()
    if not C.DB['Actionbar']['BarStance'] then
        return
    end

    local margin = C.DB['Actionbar']['ButtonMargin']
    local buttonList = {}
    local frame = CreateFrame('Frame', C.ADDON_TITLE .. 'ActionBarStance', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['StanceBar'], 'StanceBar', { 'BOTTOMLEFT', _G[C.ADDON_TITLE .. 'ActionBar2'], 'TOPLEFT', 0, margin })
    ACTIONBAR.movers[11] = frame.mover

    -- StanceBar
    _G.StanceBar:SetParent(frame)
    _G.StanceBar:EnableMouse(false)
    _G.StanceBar:UnregisterAllEvents()

    for i = 1, num do
        local button = _G['StanceButton' .. i]
        button:SetParent(frame)
        tinsert(buttonList, button)
        tinsert(ACTIONBAR.buttons, button)
    end
    frame.buttons = buttonList

    -- Fix stance bar updating
    ACTIONBAR:StanceBarOnEvent()
    F:RegisterEvent('UPDATE_SHAPESHIFT_FORM', ACTIONBAR.StanceBarOnEvent)
    F:RegisterEvent('UPDATE_SHAPESHIFT_FORMS', ACTIONBAR.StanceBarOnEvent)
    F:RegisterEvent('UPDATE_SHAPESHIFT_USABLE', ACTIONBAR.StanceBarOnEvent)
    F:RegisterEvent('UPDATE_SHAPESHIFT_COOLDOWN', ACTIONBAR.StanceBarOnEvent)

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end
