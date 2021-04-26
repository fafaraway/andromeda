local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local rad = rad
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local GetActionTexture = GetActionTexture
local GetOverrideBarSkin = GetOverrideBarSkin
local HasVehicleActionBar = HasVehicleActionBar
local UnitVehicleSkin = UnitVehicleSkin
local HasOverrideActionBar = HasOverrideActionBar

local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR

local margin, padding = 3, 3

local function UpdateActionbarScale(bar)
    local frame = _G['FreeUI_Action' .. bar]
    if not frame then
        return
    end

    local size = frame.buttonSize * C.DB.Actionbar.Scale
    frame:SetFrameSize(size)
    for _, button in pairs(frame.buttonList) do
        button:SetSize(size, size)
        button.Name:SetScale(C.DB.Actionbar.Scale)
        button.Count:SetScale(C.DB.Actionbar.Scale)
        button.HotKey:SetScale(C.DB.Actionbar.Scale)
    end
end

function ACTIONBAR:UpdateAllScale()
    if not C.DB.Actionbar.Enable then
        return
    end

    UpdateActionbarScale('Bar1')
    UpdateActionbarScale('Bar2')
    UpdateActionbarScale('Bar3')
    UpdateActionbarScale('Bar4')
    UpdateActionbarScale('Bar5')

    UpdateActionbarScale('BarExit')
    UpdateActionbarScale('BarPet')
    UpdateActionbarScale('BarStance')
end

local function SetFrameSize(frame, size, num)
    size = size or frame.buttonSize
    num = num or frame.numButtons

    frame:SetWidth(num * size + (num - 1) * margin + 2 * padding)
    frame:SetHeight(size + 2 * padding)

    if not frame.mover then
        frame.mover = F.Mover(frame, L.MOVER.MAIN_BAR, 'Bar1', frame.Pos)
    else
        frame.mover:SetSize(frame:GetSize())
    end

    if not frame.SetFrameSize then
        frame.buttonSize = size
        frame.numButtons = num
        frame.SetFrameSize = SetFrameSize
    end
end

local function UpdateBarShadow()
    if ((HasVehicleActionBar() and UnitVehicleSkin('player') and UnitVehicleSkin('player') ~= '') or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= '')) then
        ACTIONBAR.bTex:Hide()
        ACTIONBAR.tTex:Hide()
    else
        ACTIONBAR.bTex:Show()
        ACTIONBAR.tTex:Show()
    end
end

function ACTIONBAR:CreateBarShadow()
    if ACTIONBAR.BarShadow then return end

    local bar1 = _G.FreeUI_ActionBar1
    local bar2 = _G.FreeUI_ActionBar2
    local bar3 = _G.FreeUI_ActionBar3
    local layout = C.DB.Actionbar.Layout
    local size = C.DB.Actionbar.ButtonSize
    local width = (layout == 4 and 18 * size + 17 * margin + 2 * padding) or 12 * size + 11 * margin + 2 * padding
    local height = 20
    local anchor = (layout == 1 and bar1) or (layout == 2 and bar2) or (layout == 3 and bar3) or (layout == 4 and bar2)

    local bTex = bar1:CreateTexture(nil, 'OVERLAY')
    bTex:SetPoint('TOP', bar1, 'BOTTOM', 0, padding)
    bTex:SetSize(width, height)
    bTex:SetTexture(C.Assets.glow_tex)
    bTex:SetRotation(rad(180))
    bTex:SetVertexColor(0, 0, 0, .5)

    local tTex = bar1:CreateTexture(nil, 'OVERLAY')
    tTex:SetPoint('BOTTOM', anchor, 'TOP', 0, -padding)
    tTex:SetSize(width, height)
    tTex:SetTexture(C.Assets.glow_tex)
    tTex:SetVertexColor(0, 0, 0, .5)

    ACTIONBAR.bTex = bTex
    ACTIONBAR.tTex = tTex

    F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateBarShadow)
    F:RegisterEvent('UPDATE_BONUS_ACTIONBAR', UpdateBarShadow)
    F:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', UpdateBarShadow)
    F:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR', UpdateBarShadow)
    F:RegisterEvent('ACTIONBAR_PAGE_CHANGED', UpdateBarShadow)

    ACTIONBAR.BarShadow = true
end

function ACTIONBAR:CreateBar1()
    local num = NUM_ACTIONBAR_BUTTONS
    local size = C.DB.Actionbar.ButtonSize
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar1', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.Pos = {'BOTTOM', _G.UIParent, 'BOTTOM', 0, C.UIGap}

    for i = 1, num do
        local button = _G['ActionButton' .. i]
        tinsert(buttonList, button)
        tinsert(ACTIONBAR.buttons, button)
        button:SetParent(frame)
        button:ClearAllPoints()

        if i == 1 then
            button:SetPoint('BOTTOMLEFT', frame, padding, padding)
        else
            local previous = _G['ActionButton' .. i - 1]
            button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
        end
    end

    frame.buttonList = buttonList
    SetFrameSize(frame, size, num)

    -- frame.frameVisibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'

    frame.frameVisibility = '[petbattle] hide; show'
    RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    local actionPage = '[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1'
    local buttonName = 'ActionButton'
    for i, button in next, buttonList do
        frame:SetFrameRef(buttonName .. i, button)
    end

    frame:Execute(([[
        buttons = table.new()
        for i = 1, %d do
            tinsert(buttons, self:GetFrameRef('%s'..i))
        end
    ]]):format(num, buttonName))

    frame:SetAttribute('_onstate-page', [[
        for _, button in next, buttons do
            button:SetAttribute('actionpage', newstate)
        end
    ]])
    RegisterStateDriver(frame, 'page', actionPage)

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
            ACTIONBAR.UpdateButtonStatus(button)
        end
    end

    F:RegisterEvent('SPELL_UPDATE_ICON', FixActionBarTexture)
    F:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', FixActionBarTexture)
    F:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR', FixActionBarTexture)
end

function ACTIONBAR:OnLogin()
    if not C.DB.Actionbar.Enable then
        return
    end

    ACTIONBAR.buttons = {}



    ACTIONBAR:CreateBar1()
    ACTIONBAR:CreateBar2()
    ACTIONBAR:CreateBar3()
    ACTIONBAR:CreateBar4()
    ACTIONBAR:CreateBar5()
    ACTIONBAR:CreatePetbar()
    ACTIONBAR:CreateStancebar()
    ACTIONBAR:CreateExtrabar()
    ACTIONBAR:CreateLeaveVehicleBar()
    ACTIONBAR:CreateCustomBar()
    ACTIONBAR:RemoveBlizzArt()
    ACTIONBAR:RestyleButtons()
    ACTIONBAR:UpdateAllScale()
    ACTIONBAR:UpdateActionBarFade()
    ACTIONBAR:CooldownNotify()
    ACTIONBAR:CooldownFlash()
    ACTIONBAR:CreateBarShadow()
end
