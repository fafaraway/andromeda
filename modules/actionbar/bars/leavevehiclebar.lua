local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local MainMenuBarVehicleLeaveButton_OnEnter = MainMenuBarVehicleLeaveButton_OnEnter
local UnitOnTaxi = UnitOnTaxi
local VehicleExit = VehicleExit
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding
local CanExitVehicle = CanExitVehicle

local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('Actionbar')

local margin, padding = 4, 4

local function SetFrameSize(frame, size, num)
    size = size or frame.buttonSize
    num = num or frame.numButtons

    frame:SetWidth(num * size + (num - 1) * margin + 2 * padding)
    frame:SetHeight(size + 2 * padding)

    if not frame.mover then
        if C.DB.Actionbar.VehicleBar then
            frame.mover = F.Mover(frame, L['Leave Vehicle Button'], 'LeaveVehicle', frame.Pos)
        end
    else
        frame.mover:SetSize(frame:GetSize())
    end

    if not frame.SetFrameSize then
        frame.buttonSize = size
        frame.numButtons = num
        frame.SetFrameSize = SetFrameSize
    end
end

function ACTIONBAR:CreateLeaveVehicleBar()
    if not C.DB.Actionbar.VehicleBar then
        return
    end

    local num = 1
    local buttonList = {}
    local size = C.DB.Actionbar.ButtonSize + 2

    local frame = CreateFrame('Frame', 'FreeUI_ActionBarExit', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.Pos = {'CENTER', _G.UIParent, 'CENTER', 0, 200}

    local button = CreateFrame('CheckButton', 'FreeUI_LeaveVehicleButton', frame, 'ActionButtonTemplate, SecureHandlerClickTemplate')
    tinsert(buttonList, button)
    button:SetPoint('BOTTOMLEFT', frame, padding, padding)
    button:RegisterForClicks('AnyUp')
    button.icon:SetTexture('INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up')
    button.icon:SetTexCoord(.216, .784, .216, .784)
    button.icon:SetDrawLayer('ARTWORK')
    button.icon.__lockdown = true

    button:SetScript('OnEnter', MainMenuBarVehicleLeaveButton_OnEnter)
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

    frame.buttonList = buttonList
    SetFrameSize(frame, size, num)

    frame.frameVisibility = '[canexitvehicle]c;[mounted]m;n'
    RegisterStateDriver(frame, 'exit', frame.frameVisibility)

    frame:SetAttribute('_onstate-exit', [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
    if not CanExitVehicle() then
        frame:Hide()
    end
end
