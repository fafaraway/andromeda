local F = unpack(select(2, ...))
local ECP = F:RegisterModule('EnhancedColorPicker')

local colorBuffer = {}
local editingText

local function UpdateAlphaText()
    local a = _G.OpacitySliderFrame:GetValue()
    a = (1 - a) * 100
    a = math.floor(a + 0.05)
    _G.ColorPPBoxA:SetText(string.format('%d', a))
end

local function UpdateAlpha(tbox)
    local a = tbox:GetNumber()
    if a > 100 then
        a = 100
        _G.ColorPPBoxA:SetText(string.format('%d', a))
    end
    a = 1 - (a / 100)
    editingText = true
    _G.OpacitySliderFrame:SetValue(a)
    editingText = nil
end

local function UpdateColorTexts(r, g, b)
    if not r then
        r, g, b = _G.ColorPickerFrame:GetColorRGB()
    end
    r = math.floor(r * 255 + 0.5)
    g = math.floor(g * 255 + 0.5)
    b = math.floor(b * 255 + 0.5)
    _G.ColorPPBoxR:SetText(string.format('%d', r))
    _G.ColorPPBoxG:SetText(string.format('%d', g))
    _G.ColorPPBoxB:SetText(string.format('%d', b))
    _G.ColorPPBoxH:SetText(string.format('%.2x', r) .. string.format('%.2x', g) .. string.format('%.2x', b))
end

local function UpdateColor(tbox)
    local r, g, b = _G.ColorPickerFrame:GetColorRGB()
    local id = tbox:GetID()

    if id == 1 then
        r = string.format('%d', tbox:GetNumber())
        if not r then
            r = 0
        end
        r = r / 255
    elseif id == 2 then
        g = string.format('%d', tbox:GetNumber())
        if not g then
            g = 0
        end
        g = g / 255
    elseif id == 3 then
        b = string.format('%d', tbox:GetNumber())
        if not b then
            b = 0
        end
        b = b / 255
    elseif id == 4 then
        -- hex values
        if tbox:GetNumLetters() == 6 then
            local rgb = tbox:GetText()
            r, g, b = tonumber('0x' .. string.sub(rgb, 0, 2)), tonumber('0x' .. string.sub(rgb, 3, 4)), tonumber('0x' .. string.sub(rgb, 5, 6))
            if not r then
                r = 0
            else
                r = r / 255
            end
            if not g then
                g = 0
            else
                g = g / 255
            end
            if not b then
                b = 0
            else
                b = b / 255
            end
        else
            return
        end
    end

    -- This takes care of updating the hex entry when changing rgb fields and vice versa
    UpdateColorTexts(r, g, b)

    editingText = true
    _G.ColorPickerFrame:SetColorRGB(r, g, b)
    _G.ColorSwatch:SetColorTexture(r, g, b)
    editingText = nil
end

function ECP:SetupColorPicker()
    _G.ColorPickerFrame:HookScript(
        'OnShow',
        function()
            -- Get color that will be replaced
            local r, g, b = _G.ColorPickerFrame:GetColorRGB()
            _G.ColorPPOldColorSwatch:SetColorTexture(r, g, b)

            -- Show/hide the alpha box
            if _G.ColorPickerFrame.hasOpacity then
                _G.ColorPPBoxA:Show()
                _G.ColorPPBoxLabelA:Show()
                _G.ColorPPBoxH:SetScript(
                    'OnTabPressed',
                    function()
                        _G.ColorPPBoxA:SetFocus()
                    end
                )
                UpdateAlphaText()
            else
                _G.ColorPPBoxA:Hide()
                _G.ColorPPBoxLabelA:Hide()
                _G.ColorPPBoxH:SetScript(
                    'OnTabPressed',
                    function()
                        _G.ColorPPBoxR:SetFocus()
                    end
                )
            end
        end
    )

    _G.ColorPickerFrame:HookScript(
        'OnColorSelect',
        function(_, r, g, b)
            _G.ColorSwatch:SetColorTexture(r, g, b)
            if not editingText then
                UpdateColorTexts(r, g, b)
            end
        end
    )

    _G.OpacitySliderFrame:HookScript(
        'OnValueChanged',
        function()
            if not editingText then
                UpdateAlphaText()
            end
        end
    )

    -- Make the Color Picker dialog a bit taller, to make room for edit boxes
    _G.ColorPickerFrame:SetHeight(_G.ColorPickerFrame:GetHeight() + 40)

    -- Move the Color Swatch
    _G.ColorSwatch:ClearAllPoints()
    _G.ColorSwatch:SetPoint('TOPLEFT', _G.ColorPickerFrame, 'TOPLEFT', 230, -45)

    -- Add Color Swatch for original color
    local t = _G.ColorPickerFrame:CreateTexture('ColorPPOldColorSwatch')
    local w, h = _G.ColorSwatch:GetSize()
    t:SetSize(w * 0.75, h * 0.75)
    t:SetColorTexture(0, 0, 0)

    -- OldColorSwatch to appear beneath ColorSwatch
    t:SetDrawLayer('BORDER')
    t:SetPoint('BOTTOMLEFT', 'ColorSwatch', 'TOPRIGHT', -(w / 2), -(h / 3))

    -- Add Color Swatch for the copied color
    t = _G.ColorPickerFrame:CreateTexture('ColorPPCopyColorSwatch')
    t:SetSize(w, h)
    t:SetColorTexture(0, 0, 0)
    t:Hide()

    -- Add copy button to the ColorPickerFrame
    local b = CreateFrame('Button', 'ColorPPCopy', _G.ColorPickerFrame, 'UIPanelButtonTemplate')
    b:SetText(_G.CALENDAR_COPY_EVENT)
    b:SetWidth(80)
    b:SetHeight(20)
    b:SetPoint('TOPLEFT', 'ColorSwatch', 'BOTTOMLEFT', -15, -5)
    F.Reskin(b)

    -- Copy color into buffer on button click
    b:SetScript(
        'OnClick',
        function()
            -- Copy current dialog colors into buffer
            colorBuffer.r, colorBuffer.g, colorBuffer.b = _G.ColorPickerFrame:GetColorRGB()

            -- Enable Paste button and display copied color into swatch
            _G.ColorPPPaste:Enable()
            _G.ColorPPCopyColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
            _G.ColorPPCopyColorSwatch:Show()

            if _G.ColorPickerFrame.hasOpacity then
                colorBuffer.a = _G.OpacitySliderFrame:GetValue()
            else
                colorBuffer.a = nil
            end
        end
    )

    -- Paste button
    b = CreateFrame('Button', 'ColorPPPaste', _G.ColorPickerFrame, 'UIPanelButtonTemplate')
    b:SetText(_G.CALENDAR_PASTE_EVENT)
    b:SetWidth(80)
    b:SetHeight(20)
    b:SetPoint('TOPLEFT', 'ColorPPCopy', 'BOTTOMLEFT', 0, -7)
    b:Disable()
    F.Reskin(b)

    -- Paste color on button click, updating frame components
    b:SetScript(
        'OnClick',
        function()
            _G.ColorPickerFrame:SetColorRGB(colorBuffer.r, colorBuffer.g, colorBuffer.b)
            _G.ColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
            if _G.ColorPickerFrame.hasOpacity then
                if colorBuffer.a then -- Color copied had an alpha value
                    _G.OpacitySliderFrame:SetValue(colorBuffer.a)
                end
            end
        end
    )

    -- Locate Color Swatch for copy color
    _G.ColorPPCopyColorSwatch:SetPoint('LEFT', 'ColorSwatch', 'LEFT')
    _G.ColorPPCopyColorSwatch:SetPoint('TOP', 'ColorPPPaste', 'BOTTOM', 0, -5)

    -- Move the Opacity Slider Frame to align with bottom of Copy ColorSwatch
    _G.OpacitySliderFrame:ClearAllPoints()
    _G.OpacitySliderFrame:SetPoint('BOTTOM', 'ColorPPCopyColorSwatch', 'BOTTOM', 0, 23)
    _G.OpacitySliderFrame:SetPoint('RIGHT', 'ColorPickerFrame', 'RIGHT', -35, 18)

    -- Set up edit box frames and interior label and text areas
    local boxes = {'R', 'G', 'B', 'H', 'A'}
    for i = 1, #(boxes) do
        local rgb = boxes[i]
        local box = CreateFrame('EditBox', 'ColorPPBox' .. rgb, _G.ColorPickerFrame, 'InputBoxTemplate')
        box:SetID(i)
        box:SetFrameStrata('DIALOG')
        box:SetAutoFocus(false)
        -- box:SetTextInsets(0, 7, 1, 0)
        box:SetJustifyH('CENTER')
        box:SetHeight(20)
        F.ReskinEditBox(box)

        if i == 4 then
            -- Hex entry box
            box:SetMaxLetters(6)
            box:SetWidth(60)
            box:SetNumeric(false)
        else
            box:SetMaxLetters(3)
            box:SetWidth(40)
            box:SetNumeric(true)
        end

        -- Label
        local label = box:CreateFontString('ColorPPBoxLabel' .. rgb, 'ARTWORK', 'GameFontNormalSmall')
        label:SetTextColor(1, 1, 1)
        label:SetPoint('RIGHT', 'ColorPPBox' .. rgb, 'LEFT', -5, 0)
        if i == 4 then
            label:SetText('#')
        else
            label:SetText(rgb)
        end

        -- Set up scripts to handle event appropriately
        if i == 5 then
            box:SetScript(
                'OnEscapePressed',
                function(self)
                    self:ClearFocus()
                    UpdateAlphaText()
                end
            )
            box:SetScript(
                'OnEnterPressed',
                function(self)
                    self:ClearFocus()
                    UpdateAlphaText()
                end
            )
            box:SetScript(
                'OnTextChanged',
                function(self)
                    UpdateAlpha(self)
                end
            )
        else
            box:SetScript(
                'OnEscapePressed',
                function(self)
                    self:ClearFocus()
                    UpdateColorTexts()
                end
            )
            box:SetScript(
                'OnEnterPressed',
                function(self)
                    self:ClearFocus()
                    UpdateColorTexts()
                end
            )
            box:SetScript(
                'OnTextChanged',
                function(self)
                    UpdateColor(self)
                end
            )
        end

        box:SetScript(
            'OnEditFocusGained',
            function(self)
                self:SetCursorPosition(0)
                self:HighlightText()
            end
        )
        box:SetScript(
            'OnEditFocusLost',
            function(self)
                self:HighlightText(0, 0)
            end
        )
        box:SetScript(
            'OnTextSet',
            function(self)
                self:ClearFocus()
            end
        )
        box:Show()
    end

    -- Finish up with placement
    _G.ColorPPBoxR:SetPoint('BOTTOMLEFT', 30, 40)
    _G.ColorPPBoxG:SetPoint('LEFT', 'ColorPPBoxR', 'RIGHT', 18, 0)
    _G.ColorPPBoxB:SetPoint('LEFT', 'ColorPPBoxG', 'RIGHT', 18, 0)
    _G.ColorPPBoxH:SetPoint('LEFT', 'ColorPPBoxB', 'RIGHT', 18, 0)
    _G.ColorPPBoxA:SetPoint('LEFT', 'ColorPPBoxH', 'RIGHT', 18, 0)

    -- Define the order of tab cursor movement
    _G.ColorPPBoxR:SetScript(
        'OnTabPressed',
        function()
            _G.ColorPPBoxG:SetFocus()
        end
    )
    _G.ColorPPBoxG:SetScript(
        'OnTabPressed',
        function()
            _G.ColorPPBoxB:SetFocus()
        end
    )
    _G.ColorPPBoxB:SetScript(
        'OnTabPressed',
        function()
            _G.ColorPPBoxH:SetFocus()
        end
    )
    _G.ColorPPBoxA:SetScript(
        'OnTabPressed',
        function()
            _G.ColorPPBoxR:SetFocus()
        end
    )

    -- Make the color picker movable
    local mover = CreateFrame('Frame', nil, _G.ColorPickerFrame)
    mover:SetPoint('TOPLEFT', _G.ColorPickerFrame, 'TOPLEFT', 0, 0)
    mover:SetPoint('BOTTOMRIGHT', _G.ColorPickerFrame, 'TOPRIGHT', 0, -15)
    mover:EnableMouse(true)
    mover:SetScript(
        'OnMouseDown',
        function()
            _G.ColorPickerFrame:StartMoving()
        end
    )
    mover:SetScript(
        'OnMouseUp',
        function()
            _G.ColorPickerFrame:StopMovingOrSizing()
        end
    )
    _G.ColorPickerFrame:SetUserPlaced(true)
    _G.ColorPickerFrame:EnableKeyboard(false)
end

function ECP:OnLogin()
    ECP:SetupColorPicker()
end
