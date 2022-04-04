local F, C = unpack(select(2, ...))
local ECP = F:RegisterModule('EnhancedColorPicker')

local function ConvertColor(r)
    if not r then
        r = 'ff'
    end
    return tonumber(r, 16) / 255
end

function ECP:EnhancedPicker_UpdateColor()
    local r, g, b = string.match(self.colorStr, '(%x%x)(%x%x)(%x%x)$')
    r = ConvertColor(r)
    g = ConvertColor(g)
    b = ConvertColor(b)
    _G.ColorPickerFrame:SetColorRGB(r, g, b)
end

local function GetBoxColor(box)
    local r = box:GetText()
    r = tonumber(r)
    if not r or r < 0 or r > 255 then
        r = 255
    end
    return r
end

local function UpdateColorRGB(self)
    local r = GetBoxColor(_G.ColorPickerFrame.__boxR)
    local g = GetBoxColor(_G.ColorPickerFrame.__boxG)
    local b = GetBoxColor(_G.ColorPickerFrame.__boxB)
    self.colorStr = string.format('%02x%02x%02x', r, g, b)
    ECP.EnhancedPicker_UpdateColor(self)
end

local function UpdateColorStr(self)
    self.colorStr = self:GetText()
    ECP.EnhancedPicker_UpdateColor(self)
end

local function CreateCodeBox(width, index, text)
    local box = F.CreateEditBox(_G.ColorPickerFrame, width, 22)
    box:SetMaxLetters(index == 4 and 6 or 3)
    box:SetTextInsets(0, 0, 0, 0)
    box:SetPoint('TOPLEFT', _G.ColorSwatch, 'BOTTOMLEFT', 0, -index * 24 + 2)
    box:SetJustifyH('CENTER')
    F.CreateFS(box, C.Assets.Font.Bold, 12, true, text, 'YELLOW', true, 'LEFT', -15, 0)
    if index == 4 then
        box:HookScript('OnEnterPressed', UpdateColorStr)
    else
        box:HookScript('OnEnterPressed', UpdateColorRGB)
    end
    return box
end

function ECP:OnLogin()
    local pickerFrame = _G.ColorPickerFrame
    pickerFrame:SetHeight(250)
    F.CreateMF(pickerFrame.Header, pickerFrame) -- movable by header
    _G.OpacitySliderFrame:SetPoint('TOPLEFT', _G.ColorSwatch, 'TOPRIGHT', 50, 0)

    local colorBar = CreateFrame('Frame', nil, pickerFrame)
    colorBar:SetSize(1, 22)
    colorBar:SetPoint('BOTTOM', 0, 38)

    local count = 0
    for name, class in pairs(C.ClassList) do
        local value = C.ClassColors[class]
        if value then
            local bu = F.CreateButton(colorBar, 22, 22, true)
            bu.Icon:SetColorTexture(value.r, value.g, value.b)
            bu:SetPoint('LEFT', count * 25 , 0)
            bu.colorStr = value.colorStr
            bu:SetScript('OnClick', ECP.EnhancedPicker_UpdateColor)
            F.AddTooltip(bu, 'ANCHOR_TOP', '|c' .. value.colorStr .. name)

            count = count + 1
        end
    end
    colorBar:SetWidth(count * 25)

    pickerFrame.__boxR = CreateCodeBox(45, 1, '|cffff0000R')
    pickerFrame.__boxG = CreateCodeBox(45, 2, '|cff00ff00G')
    pickerFrame.__boxB = CreateCodeBox(45, 3, '|cff0000ffB')
    pickerFrame.__boxH = CreateCodeBox(70, 4, '#')

    pickerFrame:HookScript(
        'OnColorSelect',
        function(self)
            local r, g, b = self:GetColorRGB()
            r = F:Round(r * 255)
            g = F:Round(g * 255)
            b = F:Round(b * 255)

            self.__boxR:SetText(r)
            self.__boxG:SetText(g)
            self.__boxB:SetText(b)
            self.__boxH:SetText(string.format('%02x%02x%02x', r, g, b))
        end
    )
end
