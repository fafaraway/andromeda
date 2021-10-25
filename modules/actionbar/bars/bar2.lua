local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local SHOW_MULTIBAR1_TEXT = SHOW_MULTIBAR1_TEXT
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local MultiBarBottomLeft = MultiBarBottomLeft

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
            frame.mover = F.Mover(frame, SHOW_MULTIBAR1_TEXT, 'Bar2', frame.Pos)
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
    local num = NUM_ACTIONBAR_BUTTONS
    local size = C.DB.Actionbar.ButtonSize
    local layout = C.DB.Actionbar.Layout
    local buttonList = {}

    local frame = CreateFrame('Frame', 'FreeUI_ActionBar2', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.Pos = {'BOTTOM', _G.FreeUI_ActionBar1, 'TOP', 0, -margin}

    MultiBarBottomLeft:SetParent(frame)
    MultiBarBottomLeft:EnableMouse(false)
    MultiBarBottomLeft.QuickKeybindGlow:SetTexture('')

    for i = 1, num do
        local button = _G['MultiBarBottomLeftButton' .. i]
        tinsert(buttonList, button)
        tinsert(ACTIONBAR.buttons, button)
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
    RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end
