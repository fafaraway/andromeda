local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local margin, padding = 3, 3

local function SetFrameSize(frame, size, num)
    size = size or frame.buttonSize
    num = num or frame.numButtons

    frame:SetWidth(size + 2 * padding)
    frame:SetHeight(num * size + (num - 1) * margin + 2 * padding)

    if not frame.mover then
        if C.DB.Actionbar.Bar4 then
            frame.mover = F.Mover(frame, _G.SHOW_MULTIBAR3_TEXT, 'Bar4', frame.Pos)
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

local function updateVisibility(event)
    if InCombatLockdown() then
        F:RegisterEvent('PLAYER_REGEN_ENABLED', updateVisibility)
    else
        _G.InterfaceOptions_UpdateMultiActionBars()
        F:UnregisterEvent(event, updateVisibility)
    end
end

function ACTIONBAR:FixSizebarVisibility()
    F:RegisterEvent('PET_BATTLE_OVER', updateVisibility)
    F:RegisterEvent('PET_BATTLE_CLOSE', updateVisibility)
    F:RegisterEvent('UNIT_EXITED_VEHICLE', updateVisibility)
    F:RegisterEvent('UNIT_EXITING_VEHICLE', updateVisibility)
end

function ACTIONBAR:CreateBar4()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local buttonList = {}
    local size = C.DB.Actionbar.ButtonSize

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar4', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.Pos = {'RIGHT', _G.UIParent, 'RIGHT', -2, 0}

    _G.MultiBarRight:SetParent(frame)
    _G.MultiBarRight:EnableMouse(false)
    _G.MultiBarRight.QuickKeybindGlow:SetTexture('')

    for i = 1, num do
        local button = _G['MultiBarRightButton' .. i]
        table.insert(buttonList, button)
        table.insert(ACTIONBAR.buttons, button)
        button:ClearAllPoints()

        if i == 1 then
            button:SetPoint('TOPRIGHT', frame, -padding, -padding)
        else
            local previous = _G['MultiBarRightButton' .. i - 1]
            button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
        end
    end

    frame.buttonList = buttonList
    SetFrameSize(frame, size, num)

    if C.DB.Actionbar.Bar4 then
        frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    else
        frame.frameVisibility = 'hide'
    end
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    -- Fix visibility when leaving vehicle or petbattle
    ACTIONBAR:FixSizebarVisibility()
end
