local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

function ACTIONBAR:UpdateVehicleBar()
    local frame = _G[C.ADDON_TITLE .. 'ActionBarExit']
    if not frame then
        return
    end

    local padding = C.DB['Actionbar']['BarPadding']
    local size = C.DB['Actionbar']['BarVehicleButtonSize']
    local framSize = size + 2 * padding
    frame.buttons[1]:SetSize(size, size)
    frame:SetSize(framSize, framSize)
    frame.mover:SetSize(framSize, framSize)
end

function ACTIONBAR:CreateVehicleBar()
    if not C.DB['Actionbar']['BarVehicle'] then
        return
    end

    local padding = C.DB['Actionbar']['BarPadding']
    local buttonList = {}

    local frame = CreateFrame('Frame', C.ADDON_TITLE .. 'ActionBarExit', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['LeaveVehicleButton'], 'LeaveVehicleButton', { 'CENTER', _G.UIParent, 'CENTER', 0, 300 })

    local button = CreateFrame('CheckButton', C.ADDON_TITLE .. 'LeaveVehicleButton', frame, 'ActionButtonTemplate, SecureHandlerClickTemplate')
    tinsert(buttonList, button)
    button:SetPoint('BOTTOMLEFT', frame, padding, padding)
    button:RegisterForClicks('AnyUp')
    button.icon:SetTexture('INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up')
    button.icon:SetTexCoord(0.216, 0.784, 0.216, 0.784)
    button.icon:SetDrawLayer('ARTWORK')
    button.icon.__lockdown = true

    button:SetScript('OnEnter', _G.MainMenuBarVehicleLeaveButton.OnEnter)
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
    RegisterStateDriver(frame, 'exit', frame.frameVisibility)

    frame:SetAttribute('_onstate-exit', [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
    if not CanExitVehicle() then
        frame:Hide()
    end
end
