local F, C, L = unpack(select(2, ...))
local BAR = F:GetModule('ActionBar')

BAR.margin = 3
BAR.padding = 3

function BAR:UpdateAllScale()
    if not C.DB['Actionbar']['Enable'] then
        return
    end
    BAR:UpdateActionBarSize('Bar1')
    BAR:UpdateActionBarSize('Bar2')
    BAR:UpdateActionBarSize('Bar3')
    BAR:UpdateActionBarSize('Bar4')
    BAR:UpdateActionBarSize('Bar5')
    BAR:UpdateActionBarSize('BarPet')
    BAR:UpdateStanceBar()
    BAR:UpdateExtraBar()
    BAR:UpdateVehicleButton()
end

function BAR:UpdateFontSize(button, fontSize)
    local font = C.Assets.Font.Condensed

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

function BAR:UpdateActionBarSize(name)
    local frame = _G['FreeUI_Action' .. name]
    if not frame then
        return
    end

    local size = C.DB['Actionbar'][name .. 'Size']
    local num = C.DB['Actionbar'][name .. 'Num']
    local perRow = C.DB['Actionbar'][name .. 'PerRow']
    local fontSize = math.floor(size / 30 * 10 + .5)

    if num == 0 then
        local column = 3
        local rows = 2
        frame:SetWidth(3 * size + (column - 1) * BAR.margin + 2 * BAR.padding)
        frame:SetHeight(size * rows + (rows - 1) * BAR.margin + 2 * BAR.padding)
        frame.mover:SetSize(frame:GetSize())
        frame.child:SetSize(frame:GetSize())
        frame.child.mover:SetSize(frame:GetSize())
        frame.child.mover.isDisable = false
        for i = 1, 12 do
            local button = frame.buttons[i]
            button:SetSize(size, size)
            button:ClearAllPoints()
            if i == 1 then
                button:SetPoint('TOPLEFT', frame, BAR.padding, -BAR.padding)
            elseif i == 7 then
                button:SetPoint('TOPLEFT', frame.child, BAR.padding, -BAR.padding)
            elseif math.fmod(i - 1, 3) == 0 then
                button:SetPoint('TOP', frame.buttons[i - 3], 'BOTTOM', 0, -BAR.margin)
            else
                button:SetPoint('LEFT', frame.buttons[i - 1], 'RIGHT', BAR.margin, 0)
            end
            button:SetAttribute('statehidden', false)
            button:Show()
            BAR:UpdateFontSize(button, fontSize)
        end
    else
        for i = 1, num do
            local button = frame.buttons[i]
            button:SetSize(size, size)
            button:ClearAllPoints()
            if i == 1 then
                button:SetPoint('TOPLEFT', frame, BAR.padding, -BAR.padding)
            elseif math.fmod(i - 1, perRow) == 0 then
                button:SetPoint('TOP', frame.buttons[i - perRow], 'BOTTOM', 0, -BAR.margin)
            else
                button:SetPoint('LEFT', frame.buttons[i - 1], 'RIGHT', BAR.margin, 0)
            end
            button:SetAttribute('statehidden', false)
            button:Show()
            BAR:UpdateFontSize(button, fontSize)
        end

        for i = num + 1, 12 do
            local button = frame.buttons[i]
            if not button then
                break
            end
            button:SetAttribute('statehidden', true)
            button:Hide()
        end

        local column = math.min(num, perRow)
        local rows = math.ceil(num / perRow)
        frame:SetWidth(column * size + (column - 1) * BAR.margin + 2 * BAR.padding)
        frame:SetHeight(size * rows + (rows - 1) * BAR.margin + 2 * BAR.padding)
        frame.mover:SetSize(frame:GetSize())
        if frame.child then
            frame.child.mover.isDisable = true
        end
    end
end

function BAR:ToggleBarFader(name)
    local frame = _G['FreeUI_Action' .. name]
    if not frame then
        return
    end

    frame.isDisable = not C.DB['Actionbar'][name .. 'Fader']
    if frame.isDisable then
        BAR:StartFadeIn(frame)
    else
        BAR:StartFadeOut(frame)
    end
end

function BAR:CreateBar1()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar1', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['Actionbar'] .. '1', 'Bar1', {'BOTTOM', _G.UIParent, 'BOTTOM', 0, C.UI_GAP})
    BAR.movers[1] = frame.mover

    for i = 1, num do
        local button = _G['ActionButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)

        button:SetParent(frame)
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle] hide; show'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    local actionPage = '[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[possessbar]12;[overridebar]14;[shapeshift]13;[vehicleui]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1'
    local buttonName = 'ActionButton'
    for i, button in next, buttonList do
        frame:SetFrameRef(buttonName .. i, button)
    end

    frame:Execute(([[
        buttons = table.new()
        for i = 1, %d do
            tinsert(buttons, self:GetFrameRef("%s"..i))
        end
    ]]):format(num, buttonName))

    frame:SetAttribute('_onstate-page', [[
        for _, button in next, buttons do
            button:SetAttribute("actionpage", newstate)
        end
    ]])
    _G.RegisterStateDriver(frame, 'page', actionPage)

    -- Fix button texture, need reviewed
    local function FixActionBarTexture()
        for _, button in next, buttonList do
            local action = button.action
            if action < 120 then
                break
            end

            local icon = button.icon
            local texture = GetActionTexture(action)
            if texture then
                icon:SetTexture(texture)
                icon:Show()
            else
                icon:Hide()
            end
            BAR.UpdateButtonStatus(button)
        end
    end
    F:RegisterEvent('SPELL_UPDATE_ICON', FixActionBarTexture)
    F:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', FixActionBarTexture)
    F:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR', FixActionBarTexture)
end

function BAR:CreateBar2()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar2', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['Actionbar'] .. '2', 'Bar2', {'BOTTOM', _G.FreeUI_ActionBar1, 'TOP', 0, -BAR.margin})
    BAR.movers[2] = frame.mover

    _G.MultiBarBottomLeft:SetParent(frame)
    _G.MultiBarBottomLeft:EnableMouse(false)
    _G.MultiBarBottomLeft.QuickKeybindGlow:SetTexture('')

    for i = 1, num do
        local button = _G['MultiBarBottomLeftButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function BAR:CreateBar3()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar3', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['Actionbar'] .. '3L', 'Bar3L', {'RIGHT', _G.FreeUI_ActionBar1, 'TOPLEFT', BAR.margin, -BAR.padding / 2})
    local child = CreateFrame('Frame', nil, frame)
    child:SetSize(1, 1)
    child.mover = F.Mover(child, L['Actionbar'] .. '3R', 'Bar3R', {'LEFT', _G.FreeUI_ActionBar1, 'TOPRIGHT', -BAR.margin, -BAR.padding / 2})
    frame.child = child

    BAR.movers[3] = frame.mover
    BAR.movers[4] = child.mover

    _G.MultiBarBottomRight:SetParent(frame)
    _G.MultiBarBottomRight:EnableMouse(false)
    _G.MultiBarBottomRight.QuickKeybindGlow:SetTexture('')

    for i = 1, num do
        local button = _G['MultiBarBottomRightButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

local function UpdateVisibility(event)
    if InCombatLockdown() then
        F:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateVisibility)
    else
        _G.InterfaceOptions_UpdateMultiActionBars()
        F:UnregisterEvent(event, UpdateVisibility)
    end
end

function BAR:FixSideBarVisibility()
    F:RegisterEvent('PET_BATTLE_OVER', UpdateVisibility)
    F:RegisterEvent('PET_BATTLE_CLOSE', UpdateVisibility)
    F:RegisterEvent('UNIT_EXITED_VEHICLE', UpdateVisibility)
    F:RegisterEvent('UNIT_EXITING_VEHICLE', UpdateVisibility)
end

function BAR:UpdateFrameClickThru()
    local showBar4, showBar5

    local function updateClickThru()
        _G.FreeUI_ActionBar4:EnableMouse(showBar4)
        _G.FreeUI_ActionBar5:EnableMouse((not showBar4 and showBar4) or (showBar4 and showBar5))
    end

    hooksecurefunc('SetActionBarToggles', function(_, _, bar3, bar4)
        showBar4 = not (not bar3)
        showBar5 = not (not bar4)
        if InCombatLockdown() then
            F:RegisterEvent('PLAYER_REGEN_ENABLED', updateClickThru)
        else
            updateClickThru()
        end
    end)
end

function BAR:CreateBar4()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar4', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['Actionbar'] .. '4', 'Bar4', {'RIGHT', _G.UIParent, 'RIGHT', -2, 0})
    BAR.movers[5] = frame.mover

    _G.MultiBarRight:SetParent(frame)
    _G.MultiBarRight:EnableMouse(false)
    _G.MultiBarRight.QuickKeybindGlow:SetTexture('')

    hooksecurefunc(_G.MultiBarRight, 'SetScale', function(self, scale, force)
        if not force and scale ~= 1 then
            self:SetScale(1, true)
        end
    end)

    for i = 1, num do
        local button = _G['MultiBarRightButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    -- Fix visibility when leaving vehicle or petbattle
    BAR:FixSideBarVisibility()
    BAR:UpdateFrameClickThru()
end

function BAR:CreateBar5()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar5', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['Actionbar'] .. '5', 'Bar5', {'RIGHT', _G.FreeUI_ActionBar4, 'LEFT', BAR.margin, 0})
    BAR.movers[6] = frame.mover

    _G.MultiBarLeft:SetParent(frame)
    _G.MultiBarLeft:EnableMouse(false)
    _G.MultiBarLeft.QuickKeybindGlow:SetTexture('')

    hooksecurefunc(_G.MultiBarLeft, 'SetScale', function(self, scale, force)
        if not force and scale ~= 1 then
            self:SetScale(1, true)
        end
    end)

    for i = 1, num do
        local button = _G['MultiBarLeftButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function BAR:CreatePetBar()
    local num = _G.NUM_PET_ACTION_SLOTS
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBarPet', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['Pet Actionbar'], 'PetBar', {'BOTTOM', _G.FreeUI_ActionBar2, 'TOP', 0, BAR.margin})
    BAR.movers[7] = frame.mover

    _G.PetActionBarFrame:SetParent(frame)
    _G.PetActionBarFrame:EnableMouse(false)
    _G.SlidingActionBarTexture0:SetTexture(nil)
    _G.SlidingActionBarTexture1:SetTexture(nil)

    for i = 1, num do
        local button = _G['PetActionButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function BAR:UpdateStanceBar()
    local num = _G.NUM_STANCE_SLOTS
    local frame = _G['FreeUI_ActionBarStance']
    if not frame then
        return
    end

    local size = C.DB['Actionbar']['BarStanceSize']
    local perRow = C.DB['Actionbar']['BarStancePerRow']
    local fontSize = math.floor(size / 30 * 10 + .5)

    for i = 1, 12 do
        local button = frame.buttons[i]
        button:SetSize(size, size)
        if i < 11 then
            button:ClearAllPoints()
            if i == 1 then
                button:SetPoint('TOPLEFT', frame, BAR.padding, -BAR.padding)
            elseif math.fmod(i - 1, perRow) == 0 then
                button:SetPoint('TOP', frame.buttons[i - perRow], 'BOTTOM', 0, -BAR.margin)
            else
                button:SetPoint('LEFT', frame.buttons[i - 1], 'RIGHT', BAR.margin, 0)
            end
        end
        BAR:UpdateFontSize(button, fontSize)
    end

    local column = math.min(num, perRow)
    local rows = math.ceil(num / perRow)
    frame:SetWidth(column * size + (column - 1) * BAR.margin + 2 * BAR.padding)
    frame:SetHeight(size * rows + (rows - 1) * BAR.margin + 2 * BAR.padding)
    frame.mover:SetSize(size, size)
end

function BAR:CreateStanceBar()
    if not C.DB['Actionbar']['EnableStanceBar'] then
        return
    end

    local num = _G.NUM_STANCE_SLOTS
    local buttonList = {}
    local frame = CreateFrame('Frame', 'FreeUI_ActionBarStance', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['StanceBar'], 'StanceBar', {'BOTTOMLEFT', _G.FreeUI_ActionBar2, 'TOPLEFT', 0, BAR.margin})
    BAR.movers[8] = frame.mover

    -- StanceBar
    _G.StanceBarFrame:SetParent(frame)
    _G.StanceBarFrame:EnableMouse(false)
    _G.StanceBarLeft:SetTexture(nil)
    _G.StanceBarMiddle:SetTexture(nil)
    _G.StanceBarRight:SetTexture(nil)

    for i = 1, num do
        local button = _G['StanceButton' .. i]
        table.insert(buttonList, button)
        table.insert(BAR.buttons, button)
    end

    -- PossessBar
    _G.PossessBarFrame:SetParent(frame)
    _G.PossessBarFrame:EnableMouse(false)
    _G.PossessBackground1:SetTexture(nil)
    _G.PossessBackground2:SetTexture(nil)

    for i = 1, _G.NUM_POSSESS_SLOTS do
        local button = _G['PossessButton' .. i]
        table.insert(buttonList, button)
        button:ClearAllPoints()
        button:SetPoint('CENTER', buttonList[i])
    end

    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end

function BAR:UpdateExtraBar()
    local frame = _G['FreeUI_ActionBarExtra']
    if not frame then
        return
    end

    local size = C.DB['Actionbar']['BarExtraSize']
    local fontSize = math.floor(size / 30 * 10 + .5)

    local button = _G.ExtraActionButton1
    button:SetSize(size, size)

    BAR:UpdateFontSize(button, fontSize)
end

function BAR:CreateExtraBar()
    local buttonList = {}
    local size = C.DB.Actionbar.BarExtraSize

    -- ExtraActionButton
    local frame = CreateFrame('Frame', 'FreeUI_ActionBarExtra', _G.UIParent, 'SecureHandlerStateTemplate')
    frame:SetWidth(size + 2 * BAR.padding)
    frame:SetHeight(size + 2 * BAR.padding)
    frame.mover = F.Mover(frame, L['Extrabar'], 'Extrabar', {'CENTER', _G.UIParent, 'CENTER', 0, 300})

    _G.ExtraActionBarFrame:EnableMouse(false)
    _G.ExtraAbilityContainer:SetParent(frame)
    _G.ExtraAbilityContainer:ClearAllPoints()
    _G.ExtraAbilityContainer:SetPoint('CENTER', frame, 0, 2 * BAR.padding)
    _G.ExtraAbilityContainer.ignoreFramePositionManager = true

    local button = _G.ExtraActionButton1
    table.insert(buttonList, button)
    table.insert(BAR.buttons, button)
    button:SetSize(size, size)

    frame.frameVisibility = '[extrabar] show; hide'
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    -- ZoneAbility
    local zoneFrame = CreateFrame('Frame', 'FreeUI_ActionBarZone', _G.UIParent)
    zoneFrame:SetWidth(size + 2 * BAR.padding)
    zoneFrame:SetHeight(size + 2 * BAR.padding)
    zoneFrame.mover = F.Mover(zoneFrame, L['Zone Ability'], 'ZoneAbility', {'CENTER', _G.UIParent, 'CENTER', 0, 250})

    _G.ZoneAbilityFrame:SetParent(zoneFrame)
    _G.ZoneAbilityFrame:ClearAllPoints()
    _G.ZoneAbilityFrame:SetPoint('CENTER', zoneFrame)
    _G.ZoneAbilityFrame.ignoreFramePositionManager = true
    _G.ZoneAbilityFrame.Style:SetAlpha(0)

    hooksecurefunc(_G.ZoneAbilityFrame, 'UpdateDisplayedZoneAbilities', function(self)
        for spellButton in self.SpellButtonContainer:EnumerateActive() do
            if spellButton and not spellButton.styled then
                spellButton.NormalTexture:SetAlpha(0)
                spellButton:SetPushedTexture(C.Assets.Button.Pushed) -- force it to gain a texture
                spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
                spellButton:GetHighlightTexture():SetInside()
                spellButton.Icon:SetInside()
                F.ReskinIcon(spellButton.Icon, true)
                spellButton.styled = true
            end
        end
    end)

    -- Fix button visibility
    hooksecurefunc(_G.ZoneAbilityFrame, 'SetParent', function(self, parent)
        if parent == _G.ExtraAbilityContainer then
            self:SetParent(zoneFrame)
        end
    end)
end

function BAR:UpdateVehicleButton()
    local frame = _G['FreeUI_ActionBarExit']
    if not frame then
        return
    end

    local size = C.DB['Actionbar']['VehicleButtonSize']
    local framSize = size + 2 * BAR.padding
    frame.buttons[1]:SetSize(size, size)
    frame:SetSize(framSize, framSize)
    frame.mover:SetSize(framSize, framSize)
end

function BAR:CreateLeaveVehicleBar()
    if not C.DB['Actionbar']['EnableVehicleBar'] then
        return
    end

    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBarExit', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['LeaveVehicle'], 'LeaveVehicle', {'CENTER', _G.UIParent, 'CENTER', 0, 200})

    local button = CreateFrame('CheckButton', 'FreeUI_LeaveVehicleButton', frame, 'ActionButtonTemplate, SecureHandlerClickTemplate')
    table.insert(buttonList, button)
    button:SetPoint('BOTTOMLEFT', frame, BAR.padding, BAR.padding)
    button:RegisterForClicks('AnyUp')
    button.icon:SetTexture('INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up')
    button.icon:SetTexCoord(.216, .784, .216, .784)
    button.icon:SetDrawLayer('ARTWORK')
    button.icon.__lockdown = true

    button:SetScript('OnEnter', _G.MainMenuBarVehicleLeaveButton_OnEnter)
    button:SetScript('OnLeave', F.HideTooltip)
    button:SetScript('OnClick', function(self)
        if UnitOnTaxi('player') then
            TaxiRequestEarlyLanding()
        else
            VehicleExit()
        end
        self:SetChecked(true)
    end)
    button:SetScript('OnShow', function(self)
        self:SetChecked(false)
    end)

    frame.buttons = buttonList

    frame.frameVisibility = '[canexitvehicle]c;[mounted]m;n'
    _G.RegisterStateDriver(frame, 'exit', frame.frameVisibility)

    frame:SetAttribute('_onstate-exit', [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
    if not CanExitVehicle() then
        frame:Hide()
    end
end

function BAR:OnLogin()
    BAR.buttons = {}

    if not C.DB.Actionbar.Enable then
        return
    end

    BAR.movers = {}

    BAR:CreateBar1()
    BAR:CreateBar2()
    BAR:CreateBar3()
    BAR:CreateBar4()
    BAR:CreateBar5()
    BAR:CreatePetBar()
    BAR:CreateStanceBar()
    BAR:CreateExtraBar()
    BAR:CreateLeaveVehicleBar()

    BAR:RemoveBlizzArt()
    BAR:RestyleButtons()
    BAR:UpdateAllScale()
    BAR:BarFade()
    BAR:CooldownNotify()
    BAR:CooldownDesaturate()
    BAR:ButtonFlash()
end
