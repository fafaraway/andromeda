local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local mod = mod
local min = min
local ceil = ceil
local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver

local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR

function ACTIONBAR:CustomBar(anchor)
    local padding = C.DB.Actionbar.CBPadding
    local margin = C.DB.Actionbar.CBMargin
    local size = C.DB.Actionbar.CBButtonSize
    local num = 12
    local name = 'FreeUI_CustomBar'
    local page = 8

    local frame = CreateFrame('Frame', name, _G.UIParent, 'SecureHandlerStateTemplate')
    frame:SetWidth(num * size + (num - 1) * margin + 2 * padding)
    frame:SetHeight(size + 2 * padding)
    frame:SetPoint(unpack(anchor))

    if C.DB.Actionbar.CustomBar then
        frame.mover = F.Mover(frame, L.MOVER.CUSTOM_BAR, 'CustomBar', anchor)
    end

    frame.buttons = {}

    RegisterStateDriver(frame, 'visibility', '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show')
    RegisterStateDriver(frame, 'page', page)

    local buttonList = {}
    for i = 1, num do
        local button = CreateFrame('CheckButton', '$parentButton' .. i, frame, 'ActionBarButtonTemplate')
        button:SetSize(size, size)
        button.id = (page - 1) * 12 + i
        button.isCustomButton = true
        button.commandName = L.ACTIONBAR.CUSTOM_BAR .. i
        button:SetAttribute('action', button.id)
        frame.buttons[i] = button
        tinsert(buttonList, button)
        tinsert(ACTIONBAR.buttons, button)
    end

    ACTIONBAR:UpdateCustomBar()
end

function ACTIONBAR:UpdateCustomBar()
    local frame = _G.FreeUI_CustomBar
    if not frame then
        return
    end

    local padding = C.DB.Actionbar.CBPadding
    local margin = C.DB.Actionbar.CBMargin
    local size = C.DB.Actionbar.CBButtonSize
    local scale = 1
    local num = C.DB.Actionbar.CBButtonNumber
    local perRow = C.DB.Actionbar.CBButtonPerRow
    for i = 1, num do
        local button = frame.buttons[i]
        button:SetSize(size, size)
        button.Name:SetScale(scale)
        button.Count:SetScale(scale)
        button.HotKey:SetScale(scale)
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint('TOPLEFT', frame, padding, -padding)
        elseif mod(i - 1, perRow) == 0 then
            button:SetPoint('TOP', frame.buttons[i - perRow], 'BOTTOM', 0, -margin)
        else
            button:SetPoint('LEFT', frame.buttons[i - 1], 'RIGHT', margin, 0)
        end
        button:SetAttribute('statehidden', false)
        button:Show()
    end

    for i = num + 1, 12 do
        local button = frame.buttons[i]
        button:SetAttribute('statehidden', true)
        button:Hide()
    end

    local column = min(num, perRow)
    local rows = ceil(num / perRow)
    frame:SetWidth(column * size + (column - 1) * margin + 2 * padding)
    frame:SetHeight(size * rows + (rows - 1) * margin + 2 * padding)
    frame.mover:SetSize(frame:GetSize())
end

function ACTIONBAR:CreateCustomBar()
    if C.DB.Actionbar.CustomBar then
        ACTIONBAR:CustomBar({'BOTTOM', _G.UIParent, 'BOTTOM', 0, 140})
    end
end
