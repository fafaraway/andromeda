local F, C = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local Picker = _G.ColorPickerFrame

local colorBuffer = {}
local function AlphaValue(num)
    return num and floor(((1 - num) * 100) + 0.05) or 0
end

local function UpdateAlphaText(alpha)
    -- if not alpha then
    --     alpha = AlphaValue(_G.OpacitySliderFrame:GetValue())
    -- end

    _G.ColorPPBoxA:SetText(alpha)
end

local function UpdateAlpha(tbox)
    local num = tbox:GetNumber()
    if num > 100 then
        tbox:SetText(100)
        num = 100
    end

    _G.OpacitySliderFrame:SetValue(1 - (num / 100))
end

local function ExpandFromThree(r, g, b)
    return strjoin('', r, r, g, g, b, b)
end

local function ExtendToSix(str)
    for _ = 1, 6 - strlen(str) do
        str = str .. 0
    end
    return str
end

local function GetHexColor(box)
    local rgb, rgbSize = box:GetText(), box:GetNumLetters()
    if rgbSize == 3 then
        rgb = gsub(rgb, '(%x)(%x)(%x)$', ExpandFromThree)
    elseif rgbSize < 6 then
        rgb = gsub(rgb, '(.+)$', ExtendToSix)
    end

    local r, g, b = tonumber(strsub(rgb, 0, 2), 16) or 0, tonumber(strsub(rgb, 3, 4), 16) or 0, tonumber(strsub(rgb, 5, 6), 16) or 0

    return r / 255, g / 255, b / 255
end

local function UpdateColorTexts(r, g, b, box)
    if not (r and g and b) then
        r, g, b = _G.ColorPickerFrame:GetColorRGB()

        if box then
            if box == _G.ColorPPBoxH then
                r, g, b = GetHexColor(box)
            else
                local num = box:GetNumber()
                if num > 255 then
                    num = 255
                end
                local c = num / 255
                if box == _G.ColorPPBoxR then
                    r = c
                elseif box == _G.ColorPPBoxG then
                    g = c
                elseif box == _G.ColorPPBoxB then
                    b = c
                end
            end
        end
    end

    if C.IS_DEVELOPER then
        _G.ColorPPBoxR:SetText(format('%.3f', r))
        _G.ColorPPBoxG:SetText(format('%.3f', g))
        _G.ColorPPBoxB:SetText(format('%.3f', b))
    end

    -- we want those /255 values
    r, g, b = r * 255, g * 255, b * 255
    _G.ColorPPBoxH:SetText(('%.2x%.2x%.2x'):format(r, g, b))
    if not C.IS_DEVELOPER then
        _G.ColorPPBoxR:SetText(r)
        _G.ColorPPBoxG:SetText(g)
        _G.ColorPPBoxB:SetText(b)
    end
end

local function UpdateColor()
    local r, g, b = GetHexColor(_G.ColorPPBoxH)
    _G.ColorPickerFrame:SetColorRGB(r, g, b)
    _G.ColorSwatch:SetColorTexture(r, g, b)
end

local function ColorPPBoxA_SetFocus()
    _G.ColorPPBoxA:SetFocus()
end

local function ColorPPBoxR_SetFocus()
    _G.ColorPPBoxR:SetFocus()
end

local delayWait, delayFunc = 0.15
local function DelayCall()
    if delayFunc then
        delayFunc()
        delayFunc = nil
    end
end
local function OnColorSelect(frame, r, g, b)
    if frame.noColorCallback then
        return
    end

    _G.ColorSwatch:SetColorTexture(r, g, b)
    UpdateColorTexts(r, g, b)

    if r == 0 and g == 0 and b == 0 then
        return
    end

    if not frame:IsVisible() then
        DelayCall()
    elseif not delayFunc then
        delayFunc = _G.ColorPickerFrame.func
        F:Delay(delayWait, DelayCall)
    end
end

local function OnValueChanged(frame, value)
    local alpha = AlphaValue(value)
    if frame.lastAlpha ~= alpha then
        frame.lastAlpha = alpha

        -- UpdateAlphaText(alpha)

        if not _G.ColorPickerFrame:IsVisible() then
            DelayCall()
        else
            local opacityFunc = _G.ColorPickerFrame.opacityFunc
            if delayFunc and (delayFunc ~= opacityFunc) then
                delayFunc = opacityFunc
            elseif not delayFunc then
                delayFunc = opacityFunc
                F:Delay(delayWait, DelayCall)
            end
        end
    end
end

local function ConvertColor(r)
    if not r then
        r = 'ff'
    end
    return tonumber(r, 16) / 255
end

local function UpdateClassColor(self)
    local r, g, b = strmatch(self.colorStr, '(%x%x)(%x%x)(%x%x)$')
    r = ConvertColor(r)
    g = ConvertColor(g)
    b = ConvertColor(b)
    _G.ColorPickerFrame.Content.ColorPicker:SetColorRGB(r, g, b)
end

local function CreateClassColorButton()
    local colorBar = CreateFrame('Frame', nil, Picker)
    colorBar:SetSize(1, 22)
    colorBar:SetPoint('BOTTOM', 0, 50)

    local count = 0
    for name, class in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
        local value = C.ClassColors[class]
        if value then
            local bu = F.CreateButton(colorBar, 22, 18, true)
            bu.Icon:SetColorTexture(value.r, value.g, value.b)
            bu:SetPoint('LEFT', count * 26, 0)
            bu.colorStr = value.colorStr
            bu:SetScript('OnClick', UpdateClassColor)
            F.AddTooltip(bu, 'ANCHOR_TOP', '|c' .. value.colorStr .. name)

            count = count + 1
        end
    end
    colorBar:SetWidth(count * 26 - 4)
end

function BLIZZARD:EnhancedColorPicker()
    if IsAddOnLoaded('ColorPickerPlus') then
        return
    end

    local Header = Picker.Header or _G.ColorPickerFrameHeader
    Header:StripTextures()
    Header:ClearAllPoints()
    Header:SetPoint('TOP', Picker, 0, 5)

    _G.ColorPickerFrame.Footer.CancelButton:ClearAllPoints()
    _G.ColorPickerFrame.Footer.OkayButton:ClearAllPoints()
    _G.ColorPickerFrame.Footer.CancelButton:SetPoint('BOTTOMRIGHT', Picker, 'BOTTOMRIGHT', -6, 6)
    _G.ColorPickerFrame.Footer.CancelButton:SetPoint('BOTTOMLEFT', Picker, 'BOTTOM', 0, 6)
    _G.ColorPickerFrame.Footer.OkayButton:SetPoint('BOTTOMLEFT', Picker, 'BOTTOMLEFT', 6, 6)
    _G.ColorPickerFrame.Footer.OkayButton:SetPoint('RIGHT', _G.ColorPickerFrame.Footer.CancelButton, 'LEFT', -4, 0)

    Picker:HookScript('OnShow', function(frame)
        -- get color that will be replaced
        local r, g, b = frame:GetColorRGB()
        -- _G.ColorPPOldColorSwatch:SetColorTexture(r, g, b)
        frame.Content.ColorSwatchOriginal:SetColorTexture(r, g, b)

        -- show/hide the alpha box
        if frame.hasOpacity then
            _G.ColorPPBoxA:Show()
            _G.ColorPPBoxLabelA:Show()
            frame.Content.HexBox:SetScript('OnTabPressed', ColorPPBoxA_SetFocus)
            -- UpdateAlphaText()
            UpdateColorTexts()
            frame:SetWidth(405)
        else
            _G.ColorPPBoxA:Hide()
            _G.ColorPPBoxLabelA:Hide()
            frame.Content.HexBox:SetScript('OnTabPressed', ColorPPBoxR_SetFocus)
            UpdateColorTexts()
            frame:SetWidth(345)
        end

        -- Memory Fix, Colorpicker will call the self.func() 100x per second, causing fps/memory issues,
        -- We overwrite these two scripts and set a limit on how often we allow a call their update functions
        -- _G.OpacitySliderFrame:SetScript('OnValueChanged', OnValueChanged)
        -- frame:SetScript('OnColorSelect', OnColorSelect)
        UpdateColorTexts(nil, nil, nil, _G.ColorPickerFrame.Content.HexBox)
    end)

    -- move the Color Swatch
    _G.ColorPickerFrame.Content.ColorSwatchCurrent:ClearAllPoints()
    _G.ColorPickerFrame.Content.ColorSwatchCurrent:SetPoint('TOPLEFT', Picker, 'TOPLEFT', 215, -45)
    local swatchWidth, swatchHeight = _G.ColorPickerFrame.Content.ColorSwatchCurrent:GetSize()

    -- add Color Swatch for original color
    -- local originalColor = Picker:CreateTexture('ColorPPOldColorSwatch')
    -- originalColor:SetSize(swatchWidth * 0.75, swatchHeight * 0.75)
    -- originalColor:SetColorTexture(0, 0, 0)
    -- -- OldColorSwatch to appear beneath ColorSwatch
    -- originalColor:SetDrawLayer('BORDER')
    -- originalColor:SetPoint('BOTTOMLEFT', 'ColorSwatch', 'TOPRIGHT', -(swatchWidth / 2), -(swatchHeight / 3))

    -- add Color Swatch for the copied color
    local copiedColor = Picker:CreateTexture('ColorPPCopyColorSwatch')
    copiedColor:SetColorTexture(0, 0, 0)
    copiedColor:SetSize(swatchWidth, swatchHeight)
    copiedColor:Hide()

    -- add copy button to the ColorPickerFrame
    local copyButton = CreateFrame('Button', 'ColorPPCopy', Picker, 'UIPanelButtonTemplate')
    copyButton:SetText(_G.CALENDAR_COPY_EVENT)
    copyButton:SetSize(52, 22)
    -- copyButton:SetPoint('TOPLEFT', 'ColorSwatch', 'BOTTOMLEFT', 0, -20)
    F.ReskinButton(copyButton)

    -- copy color into buffer on button click
    copyButton:SetScript('OnClick', function()
        -- copy current dialog colors into buffer
        colorBuffer.r, colorBuffer.g, colorBuffer.b = Picker:GetColorRGB()

        -- enable Paste button and display copied color into swatch
        _G.ColorPPPaste:Enable()
        _G.ColorPPCopyColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
        _G.ColorPPCopyColorSwatch:Show()

        colorBuffer.a = (Picker.hasOpacity and _G.OpacitySliderFrame:GetValue()) or nil
    end)

    -- add paste button to the ColorPickerFrame
    local pasteButton = CreateFrame('Button', 'ColorPPPaste', Picker, 'UIPanelButtonTemplate')
    pasteButton:SetText(_G.CALENDAR_PASTE_EVENT)
    pasteButton:SetSize(52, 22)
    pasteButton:SetPoint('TOPLEFT', 'ColorPPCopy', 'TOPRIGHT', 12, 0)
    pasteButton:Disable() -- enable when something has been copied
    F.ReskinButton(pasteButton)

    -- paste color on button click, updating frame components
    pasteButton:SetScript('OnClick', function()
        Picker:SetColorRGB(colorBuffer.r, colorBuffer.g, colorBuffer.b)
        _G.ColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
        if Picker.hasOpacity then
            if colorBuffer.a then -- color copied had an alpha value
                _G.OpacitySliderFrame:SetValue(colorBuffer.a)
            end
        end
    end)

    -- add defaults button to the ColorPickerFrame
    local defaultButton = CreateFrame('Button', 'ColorPPDefault', Picker, 'UIPanelButtonTemplate')
    defaultButton:SetText(_G.DEFAULT)
    defaultButton:SetSize(116, 22)
    defaultButton:SetPoint('TOPLEFT', 'ColorPPCopy', 'BOTTOMLEFT', 0, -10)
    defaultButton:Disable() -- enable when something has been copied
    defaultButton:SetScript('OnHide', function(btn)
        if btn.colors then
            wipe(btn.colors)
        end
    end)
    defaultButton:SetScript('OnShow', function(btn)
        btn:SetEnabled(btn.colors)
    end)
    F.ReskinButton(defaultButton)

    -- paste color on button click, updating frame components
    defaultButton:SetScript('OnClick', function(btn)
        local colors = btn.colors
        Picker:SetColorRGB(colors.r, colors.g, colors.b)
        _G.ColorSwatch:SetColorTexture(colors.r, colors.g, colors.b)
        if Picker.hasOpacity then
            if colors.a then
                _G.OpacitySliderFrame:SetValue(colors.a)
            end
        end
    end)

    -- position Color Swatch for copy color
    _G.ColorPPCopyColorSwatch:SetPoint('BOTTOM', 'ColorPPPaste', 'TOP', 0, 10)

    -- move the Opacity Slider to align with bottom of Copy ColorSwatch
    -- _G.OpacitySliderFrame:ClearAllPoints()
    -- _G.OpacitySliderFrame:SetPoint('BOTTOM', 'ColorPPDefault', 'BOTTOM', 0, 0)
    -- _G.OpacitySliderFrame:SetPoint('RIGHT', 'ColorPickerFrame', 'RIGHT', -35, 18)

    -- set up edit box frames and interior label and text areas
    for i, rgb in next, { 'R', 'G', 'B', 'H', 'A' } do
        local box = CreateFrame('EditBox', 'ColorPPBox' .. rgb, Picker, 'InputBoxTemplate')
        box:SetPoint('TOP', Picker.Content.ColorSwatchOriginal, 'BOTTOM', 0, -15)
        box:SetFrameStrata('DIALOG')
        box:SetAutoFocus(false)
        box:SetTextInsets(0, 0, 0, 0)
        box:SetJustifyH('CENTER')
        box:SetHeight(24)
        box:SetID(i)
        box:SetFont(C.Assets.Fonts.Condensed, 11, '')
        F.ReskinEditbox(box)

        -- hex entry box
        if i == 4 then
            box:SetMaxLetters(6)
            box:SetWidth(64)
            box:SetNumeric(false)
        else
            box:SetMaxLetters(C.IS_DEVELOPER and 4 or 3)
            box:SetWidth(44)
            box:SetNumeric(not C.IS_DEVELOPER)
        end

        -- label
        local label = box:CreateFontString('ColorPPBoxLabel' .. rgb, 'ARTWORK', 'GameFontNormalSmall')
        label:SetPoint('RIGHT', 'ColorPPBox' .. rgb, 'LEFT', -6, 0)
        label:SetText(i == 4 and '#' or rgb)
        label:SetTextColor(1, 1, 1)

        -- set up scripts to handle event appropriately
        if i == 5 then
            box:SetScript('OnKeyUp', function(eb, key)
                local copyPaste = IsControlKeyDown() and key == 'V'
                if key == 'BACKSPACE' or copyPaste or (strlen(key) == 1 and not IsModifierKeyDown()) then
                    UpdateAlpha(eb)
                elseif key == 'ENTER' or key == 'ESCAPE' then
                    eb:ClearFocus()
                    UpdateAlpha(eb)
                end
            end)
        else
            box:SetScript('OnKeyUp', function(eb, key)
                local copyPaste = IsControlKeyDown() and key == 'V'
                if key == 'BACKSPACE' or copyPaste or (strlen(key) == 1 and not IsModifierKeyDown()) then
                    if i ~= 4 then
                        UpdateColorTexts(nil, nil, nil, eb)
                    end
                    if i == 4 and eb:GetNumLetters() ~= 6 then
                        return
                    end
                    UpdateColor()
                elseif key == 'ENTER' or key == 'ESCAPE' then
                    eb:ClearFocus()
                    UpdateColorTexts(nil, nil, nil, eb)
                    UpdateColor()
                end
            end)
        end

        box:SetScript('OnEditFocusGained', function(eb)
            eb:SetCursorPosition(0)
            eb:HighlightText()
        end)
        box:SetScript('OnEditFocusLost', function(eb)
            eb:HighlightText(0, 0)
        end)
        box:Show()
    end

    -- finish up with placement
    _G.ColorPPBoxA:ClearAllPoints()
    _G.ColorPPBoxA:SetPoint('TOPRIGHT', Picker, 'TOPRIGHT', -20, -180)
    _G.ColorPPBoxR:ClearAllPoints()
    _G.ColorPPBoxR:SetPoint('TOPLEFT', Picker, 'TOPLEFT', 24, -180)
    _G.ColorPPBoxG:ClearAllPoints()
    _G.ColorPPBoxG:SetPoint('LEFT', 'ColorPPBoxR', 'RIGHT', 20, 0)
    _G.ColorPPBoxB:ClearAllPoints()
    _G.ColorPPBoxB:SetPoint('LEFT', 'ColorPPBoxG', 'RIGHT', 20, 0)
    _G.ColorPPBoxH:ClearAllPoints()
    _G.ColorPPBoxH:SetPoint('LEFT', 'ColorPPBoxB', 'RIGHT', 20, 0)

    -- define the order of tab cursor movement
    _G.ColorPPBoxR:SetScript('OnTabPressed', function()
        _G.ColorPPBoxG:SetFocus()
    end)
    _G.ColorPPBoxG:SetScript('OnTabPressed', function()
        _G.ColorPPBoxB:SetFocus()
    end)
    _G.ColorPPBoxB:SetScript('OnTabPressed', function()
        _G.ColorPPBoxH:SetFocus()
    end)
    _G.ColorPPBoxA:SetScript('OnTabPressed', function()
        _G.ColorPPBoxR:SetFocus()
    end)

    CreateClassColorButton()

    -- make the color picker movable.
    local mover = CreateFrame('Frame', nil, Picker)
    mover:SetPoint('TOPLEFT', Picker, 'TOP', -60, 0)
    mover:SetPoint('BOTTOMRIGHT', Picker, 'TOP', 60, -15)
    mover:SetScript('OnMouseDown', function()
        Picker:StartMoving()
    end)
    mover:SetScript('OnMouseUp', function()
        Picker:StopMovingOrSizing()
    end)
    mover:EnableMouse(true)

    -- make the frame a bit taller, to make room for edit boxes
    Picker:SetHeight(Picker:GetHeight() + 100)

    Picker:SetClampedToScreen(true)
    Picker:SetUserPlaced(true)
    Picker:EnableKeyboard(false)
end
