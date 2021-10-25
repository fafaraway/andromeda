local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local margin, padding = 3, 3

local function SetFrameSize(frame, size, num)
    size = size or frame.buttonSize
    num = num or frame.numButtons

    frame:SetWidth(num * size + (num - 1) * margin + 2 * padding)
    frame:SetHeight(size + 2 * padding)

    local layout = C.DB.Actionbar.Layout
    if not frame.mover then
        if layout ~= 1 then
            frame.mover = F.Mover(frame, _G.SHOW_MULTIBAR1_TEXT, 'Bar2', frame.Pos)
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

function ACTIONBAR:CreateBar2()
    local num = _G.NUM_ACTIONBAR_BUTTONS
    local size = C.DB.Actionbar.ButtonSize
    local layout = C.DB.Actionbar.Layout
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar2', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.Pos = {'BOTTOM', _G.FreeUI_ActionBar1, 'TOP', 0, -margin}

    _G.MultiBarBottomLeft:SetParent(frame)
    _G.MultiBarBottomLeft:EnableMouse(false)
    _G.MultiBarBottomLeft.QuickKeybindGlow:SetTexture('')

    for i = 1, num do
        local button = _G['MultiBarBottomLeftButton' .. i]
        table.insert(buttonList, button)
        table.insert(ACTIONBAR.buttons, button)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint('BOTTOMLEFT', frame, padding, padding)
        else
            local previous = _G['MultiBarBottomLeftButton' .. i - 1]
            button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
        end
    end

    frame.buttonList = buttonList
    SetFrameSize(frame, size, num)

    if layout ~= 1 then
        frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
    else
        frame.frameVisibility = 'hide'
    end
    _G.RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end
