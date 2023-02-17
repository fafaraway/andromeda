local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')
local LAB = F.Libs.LibActionButton

function ACTIONBAR:UpdateAllSize()
    if not C.DB['Actionbar']['Enable'] then
        return
    end

    ACTIONBAR:UpdateSize('Bar1')
    ACTIONBAR:UpdateSize('Bar2')
    ACTIONBAR:UpdateSize('Bar3')
    ACTIONBAR:UpdateSize('Bar4')
    ACTIONBAR:UpdateSize('Bar5')
    ACTIONBAR:UpdateSize('Bar6')
    ACTIONBAR:UpdateSize('Bar7')
    ACTIONBAR:UpdateSize('Bar8')
    ACTIONBAR:UpdateSize('BarPet')
    ACTIONBAR:UpdateStanceBar()
    ACTIONBAR:UpdateVehicleBar()
end

function ACTIONBAR:UpdateButtonFont(button, fontSize)
    local font = C.Assets.Fonts.Condensed

    if button.Name then
        button.Name:SetFont(font, fontSize, 'OUTLINE')
    end
    if button.Count then
        button.Count:SetFont(font, fontSize, 'OUTLINE')
    end
    if button.HotKey then
        button.HotKey:SetFont(font, fontSize, 'OUTLINE')
    end
end

function ACTIONBAR:UpdateSize(name)
    local frame = _G[C.ADDON_TITLE .. 'Action' .. name]

    if not frame then
        return
    end

    local size = C.DB['Actionbar'][name .. 'ButtonSize']
    local num = name == 'BarPet' and 10 or C.DB['Actionbar'][name .. 'ButtonNum']
    local perRow = C.DB['Actionbar'][name .. 'ButtonPerRow']
    local fontSize = C.DB['Actionbar'][name .. 'FontSize']
    local margin = C.DB['Actionbar']['ButtonMargin']
    local padding = C.DB['Actionbar']['BarPadding']

    if num == 0 then
        local column = 3
        local rows = 2
        frame:SetWidth(3 * size + (column - 1) * margin + 2 * padding)
        frame:SetHeight(size * rows + (rows - 1) * margin + 2 * padding)
        frame.mover:SetSize(frame:GetSize())
        frame.child:SetSize(frame:GetSize())
        frame.child.mover:SetSize(frame:GetSize())
        frame.child.mover.isDisable = false

        for i = 1, 12 do
            local button = frame.buttons[i]
            button:SetSize(size, size)
            button:ClearAllPoints()
            if i == 1 then
                button:SetPoint('TOPLEFT', frame, padding, -padding)
            elseif i == 7 then
                button:SetPoint('TOPLEFT', frame.child, padding, -padding)
            elseif mod(i - 1, 3) == 0 then
                button:SetPoint('TOP', frame.buttons[i - 3], 'BOTTOM', 0, -margin)
            else
                button:SetPoint('LEFT', frame.buttons[i - 1], 'RIGHT', margin, 0)
            end

            button:Show()
            ACTIONBAR:UpdateButtonFont(button, fontSize)
        end
    else
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

            button:Show()
            ACTIONBAR:UpdateButtonFont(button, fontSize)
        end

        for i = num + 1, 12 do
            local button = frame.buttons[i]
            if not button then
                break
            end
            button:Hide()
        end

        local column = min(num, perRow)
        local rows = ceil(num / perRow)
        frame:SetWidth(column * size + (column - 1) * margin + 2 * padding)
        frame:SetHeight(size * rows + (rows - 1) * margin + 2 * padding)
        frame.mover:SetSize(frame:GetSize())
        if frame.child then
            frame.child.mover.isDisable = true
        end
    end
end

local directions = { 'UP', 'DOWN', 'LEFT', 'RIGHT' }
function ACTIONBAR:UpdateButtonConfig(i)
    if not self.buttonConfig then
        self.buttonConfig = {
            hideElements = {},
            text = {
                hotkey = { font = {}, position = {} },
                count = { font = {}, position = {} },
                macro = { font = {}, position = {} },
            },
        }
    end
    self.buttonConfig.clickOnDown = true
    self.buttonConfig.showGrid = C.DB['Actionbar']['Grid']
    self.buttonConfig.flyoutDirection = directions[C.DB['Actionbar']['Bar' .. i .. 'Flyout']]

    local hotkey = self.buttonConfig.text.hotkey
    hotkey.font.font = C.Assets.Fonts.Condensed
    hotkey.font.size = C.DB['Actionbar']['Bar' .. i .. 'FontSize']
    hotkey.font.flags = 'OUTLINE'
    hotkey.position.anchor = 'TOPLEFT'
    hotkey.position.relAnchor = false
    hotkey.position.offsetX = 2
    hotkey.position.offsetY = -2
    hotkey.justifyH = 'LEFT'

    local count = self.buttonConfig.text.count
    count.font.font = C.Assets.Fonts.Condensed
    count.font.size = C.DB['Actionbar']['Bar' .. i .. 'FontSize']
    count.font.flags = 'OUTLINE'
    count.position.anchor = 'BOTTOMRIGHT'
    count.position.relAnchor = false
    count.position.offsetX = -2
    count.position.offsetY = 2
    count.justifyH = 'RIGHT'

    local macro = self.buttonConfig.text.macro
    macro.font.font = C.Assets.Fonts.Condensed
    macro.font.size = C.DB['Actionbar']['Bar' .. i .. 'FontSize']
    macro.font.flags = 'OUTLINE'
    macro.position.anchor = 'BOTTOM'
    macro.position.relAnchor = false
    macro.position.offsetX = 0
    macro.position.offsetY = 2
    macro.justifyH = 'CENTER'

    local hideElements = self.buttonConfig.hideElements
    hideElements.hotkey = not C.DB['Actionbar']['ShowHotkey']
    hideElements.macro = not C.DB['Actionbar']['ShowMacroName']
    hideElements.equipped = not C.DB['Actionbar']['EquipColor']

    local lockBars = GetCVarBool('lockActionBars')
    for _, button in next, self.buttons do
        self.buttonConfig.keyBoundTarget = button.bindName
        button.keyBoundTarget = self.buttonConfig.keyBoundTarget

        button:SetAttribute('buttonlock', lockBars)

        button:SetAttribute('unlockedpreventdrag', not lockBars) -- make sure button can drag without being click
        button:SetAttribute('checkmouseovercast', true)
        button:SetAttribute('checkfocuscast', true)
        -- button:SetAttribute('checkselfcast', true)
        -- button:SetAttribute('*unit2', 'player')
        button:UpdateConfig(self.buttonConfig)

        if C.DB['Actionbar']['ClassColor'] then
            button.__bg:SetBackdropColor(C.r, C.g, C.b, 0.25)
        else
            button.__bg:SetBackdropColor(0.2, 0.2, 0.2, 0.25)
        end
    end
end

local fullPage = '[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[possessbar]16;[overridebar]18;[shapeshift]17;[vehicleui]16;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1'

function ACTIONBAR:UpdateVisibility()
    for i = 1, 8 do
        local frame = _G[C.ADDON_TITLE .. 'ActionBar' .. i]
        if frame then
            if C.DB['Actionbar']['Bar' .. i] then
                frame:Show()
                frame.mover.isDisable = false
                RegisterStateDriver(frame, 'visibility', frame.visibility)
            else
                frame:Hide()
                frame.mover.isDisable = true
                UnregisterStateDriver(frame, 'visibility')
            end
        end
    end
end

function ACTIONBAR:UpdateBarConfig()
    for i = 1, 8 do
        local frame = _G[C.ADDON_TITLE .. 'ActionBar' .. i]
        if frame then
            ACTIONBAR.UpdateButtonConfig(frame, i)
        end
    end
end

function ACTIONBAR:ReassignBindings()
    if InCombatLockdown() then
        return
    end

    for index = 1, 8 do
        local frame = ACTIONBAR.headers[index]
        for _, button in next, frame.buttons do
            for _, key in next, { GetBindingKey(button.keyBoundTarget) } do
                if key and key ~= '' then
                    SetOverrideBindingClick(frame, false, key, button:GetName(), 'Keybind')
                end
            end
        end
    end
end

function ACTIONBAR:ClearBindings()
    if InCombatLockdown() then
        return
    end

    for index = 1, 8 do
        local frame = ACTIONBAR.headers[index]
        ClearOverrideBindings(frame)
    end
end

function ACTIONBAR:CreateBars()
    ACTIONBAR.headers = {}

    for index = 1, 8 do
        ACTIONBAR.headers[index] = CreateFrame('Frame', C.ADDON_TITLE .. 'ActionBar' .. index, _G.UIParent, 'SecureHandlerStateTemplate')
    end

    local margin = C.DB['Actionbar']['ButtonMargin']
    local padding = C.DB['Actionbar']['BarPadding']

    local barData = {
        [1] = { page = 1, bindName = 'ACTIONBUTTON', anchor = { 'BOTTOM', _G.UIParent, 'BOTTOM', 0, 33 } },
        [2] = { page = 6, bindName = 'MULTIACTIONBAR1BUTTON', anchor = { 'BOTTOM', _G[C.ADDON_TITLE .. 'ActionBar1'], 'TOP', 0, -margin } },
        [3] = { page = 5, bindName = 'MULTIACTIONBAR2BUTTON', anchor = { 'RIGHT', _G[C.ADDON_TITLE .. 'ActionBar1'], 'TOPLEFT', -margin, -padding / 2 } },
        [4] = { page = 3, bindName = 'MULTIACTIONBAR3BUTTON', anchor = { 'RIGHT', _G.UIParent, 'RIGHT', -1, 0 } },
        [5] = { page = 4, bindName = 'MULTIACTIONBAR4BUTTON', anchor = { 'RIGHT', _G[C.ADDON_TITLE .. 'ActionBar4'], 'LEFT', margin, 0 } },
        [6] = { page = 13, bindName = 'MULTIACTIONBAR5BUTTON', anchor = { 'CENTER', _G.UIParent, 'CENTER', 0, 0 } },
        [7] = { page = 14, bindName = 'MULTIACTIONBAR6BUTTON', anchor = { 'CENTER', _G.UIParent, 'CENTER', 0, 40 } },
        [8] = { page = 15, bindName = 'MULTIACTIONBAR7BUTTON', anchor = { 'CENTER', _G.UIParent, 'CENTER', 0, 80 } },
    }

    local mIndex = 1
    for index = 1, 8 do
        local data = barData[index]
        local frame = ACTIONBAR.headers[index]

        if index == 3 then
            frame.mover = F.Mover(frame, L['Actionbar'] .. '3L', 'Bar3L', { 'RIGHT', _G[C.ADDON_TITLE .. 'ActionBar1'], 'TOPLEFT', -margin, -padding / 2 })
            local child = CreateFrame('Frame', nil, frame)
            child:SetSize(1, 1)
            child.mover = F.Mover(child, L['Actionbar'] .. '3R', 'Bar3R', { 'LEFT', _G[C.ADDON_TITLE .. 'ActionBar1'], 'TOPRIGHT', margin, -padding / 2 })
            frame.child = child

            ACTIONBAR.movers[mIndex] = frame.mover
            ACTIONBAR.movers[mIndex + 1] = child.mover
            mIndex = mIndex + 2
        else
            frame.mover = F.Mover(frame, L['Actionbar'] .. index, 'Bar' .. index, data.anchor)
            ACTIONBAR.movers[mIndex] = frame.mover
            mIndex = mIndex + 1
        end

        frame.buttons = {}

        for i = 1, 12 do
            local button = LAB:CreateButton(i, '$parentButton' .. i, frame)
            button:SetState(0, 'action', i)
            for k = 1, 18 do
                button:SetState(k, 'action', (k - 1) * 12 + i)
            end

            if i == 12 then
                button:SetState(GetVehicleBarIndex(), 'custom', {
                    func = function()
                        if UnitExists('vehicle') then
                            VehicleExit()
                        else
                            PetDismiss()
                        end
                    end,

                    texture = 136190, -- Spell_Shadow_SacrificialShield
                    tooltip = _G.LEAVE_VEHICLE,
                })
            end

            button.MasqueSkinned = true
            button.bindName = data.bindName .. i

            tinsert(frame.buttons, button)
            tinsert(ACTIONBAR.buttons, button)
        end

        frame.visibility = index == 1 and '[petbattle] hide; show' or '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'

        frame:SetAttribute(
            '_onstate-page',
            [[
            self:SetAttribute("state", newstate)
            control:ChildUpdate("state", newstate)
        ]]
        )
        RegisterStateDriver(frame, 'page', index == 1 and fullPage or data.page)
    end

    LAB.RegisterCallback(ACTIONBAR, 'OnButtonUpdate', ACTIONBAR.UpdateEquipedBorder)

    if LAB.flyoutHandler then
        LAB.flyoutHandler.Background:Hide()

        for _, button in next, LAB.FlyoutButtons do
            ACTIONBAR:HandleButton(button)
        end
    end

    local function delayUpdate()
        ACTIONBAR:UpdateBarConfig()
        F:UnregisterEvent('PLAYER_REGEN_ENABLED', delayUpdate)
    end

    F:RegisterEvent('CVAR_UPDATE', function(_, var)
        if var == 'lockActionBars' then
            if InCombatLockdown() then
                F:RegisterEvent('PLAYER_REGEN_ENABLED', delayUpdate)
                return
            end

            ACTIONBAR:UpdateBarConfig()
        end
    end)
end
