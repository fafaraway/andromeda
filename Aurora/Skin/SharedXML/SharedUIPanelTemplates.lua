local _, private = ...

-- [[ Lua Globals ]]
local next, tinsert = _G.next, _G.tinsert

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do -- BlizzWTF: These are not templates, but they should be
    -- ExpandOrCollapse
    local function Hook_SetNormalTexture(self, texture)
        if self.settingTexture then return end
        self.settingTexture = true
        self:SetNormalTexture("")

        if texture and texture ~= "" then
            if texture:find("Plus") then
                self._auroraBG.plus:Show()
            elseif texture:find("Minus") then
                self._auroraBG.plus:Hide()
            end
            self._auroraBG:Show()
        else
            self._auroraBG:Hide()
        end
        self.settingTexture = nil
    end
    function Skin.ExpandOrCollapse(button)
        button:SetHighlightTexture("")
        button:SetPushedTexture("")

        local bg = _G.CreateFrame("Frame", nil, button)
        bg:SetSize(13, 13)
        bg:SetPoint("TOPLEFT", button:GetNormalTexture(), 0, -2)
        Base.SetBackdrop(bg, Aurora.buttonColor:GetRGBA())
        button._auroraBG = bg

        button._auroraHighlight = {}
        bg.minus = bg:CreateTexture(nil, "OVERLAY")
        bg.minus:SetSize(7, 1)
        bg.minus:SetPoint("CENTER")
        bg.minus:SetColorTexture(1, 1, 1)
        _G.tinsert(button._auroraHighlight, bg.minus)

        bg.plus = bg:CreateTexture(nil, "OVERLAY")
        bg.plus:SetSize(1, 7)
        bg.plus:SetPoint("CENTER")
        bg.plus:SetColorTexture(1, 1, 1)
        _G.tinsert(button._auroraHighlight, bg.plus)

        Base.SetHighlight(button, "color")
        _G.hooksecurefunc(button, "SetNormalTexture", Hook_SetNormalTexture)
    end

    -- Nav buttons
    local function NavButton(button)
        button:SetSize(18, 18)
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetHighlightTexture("")

        local disabled = button:GetDisabledTexture()
        disabled:SetColorTexture(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
    end
    function Skin.NavButtonPrevious(button)
        NavButton(button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 6, -4)
        arrow:SetPoint("BOTTOMRIGHT", -7, 5)
        Base.SetTexture(arrow, "arrowLeft")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")
    end
    function Skin.NavButtonNext(button)
        NavButton(button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 7, -5)
        arrow:SetPoint("BOTTOMRIGHT", -6, 4)
        Base.SetTexture(arrow, "arrowRight")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.lua ]]
    function Hook.PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
        if not tab._auroraTabResize then return end
        local sideWidths = 14
        local tabText = tab.Text or _G[tab:GetName().."Text"]

        local width, tabWidth
        local textWidth
        if absoluteTextSize then
            textWidth = absoluteTextSize
        else
            tabText:SetWidth(0)
            textWidth = tabText:GetStringWidth()
        end
        -- If there's an absolute size specified then use it
        if absoluteSize then
            if absoluteSize < sideWidths then
                width = 1;
                tabWidth = sideWidths
            else
                width = absoluteSize - sideWidths
                tabWidth = absoluteSize
            end
            tabText:SetWidth(width)
        else
            -- Otherwise try to use padding
            if padding then
                width = textWidth + padding
            else
                width = textWidth + 24
            end
            -- If greater than the maxWidth then cap it
            if maxWidth and width > maxWidth then
                if ( padding ) then
                    width = maxWidth + padding
                else
                    width = maxWidth + 24
                end
                tabText:SetWidth(width)
            else
                tabText:SetWidth(0)
            end
            if (minWidth and width < minWidth) then
                width = minWidth
            end
            tabWidth = width + sideWidths
        end

        tab:SetWidth(tabWidth)
    end
    function Hook.PanelTemplates_DeselectTab(tab)
        local text = tab.Text or _G[tab:GetName().."Text"]
        text:SetPoint("CENTER", tab, "CENTER")
    end
    function Hook.PanelTemplates_SelectTab(tab)
        local text = tab.Text or _G[tab:GetName().."Text"]
        text:SetPoint("CENTER", tab, "CENTER")
    end
end

do --[[ SharedXML\SharedUIPanelTemplates.xml ]]
    function Skin.UIPanelCloseButton(button)
        button:SetSize(17, 17)
        button:SetNormalTexture("")
        button:SetHighlightTexture("")
        button:SetPushedTexture("")

        local dis = button:GetDisabledTexture()
        if dis then
            dis:SetColorTexture(0, 0, 0, .4)
            dis:SetDrawLayer("OVERLAY")
            dis:SetAllPoints()
        end

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())

        local cross = button:CreateTexture(nil, "ARTWORK")
        cross:SetPoint("TOPLEFT", 4, -4)
        cross:SetPoint("BOTTOMRIGHT", -4, 4)
        Base.SetTexture(cross, "lineCross")

        button._auroraHighlight = {cross}
        Base.SetHighlight(button, "texture")
    end
    function Skin.UIPanelButtonTemplate(button)
        button.Left:SetAlpha(0)
        button.Right:SetAlpha(0)
        button.Middle:SetAlpha(0)
        button:SetHighlightTexture("")

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
        Base.SetHighlight(button, "backdrop")

        --[[ Scale ]]--
        button:SetSize(button:GetSize())
    end

    function Skin.UICheckButtonTemplate(checkbutton)
        local bd = _G.CreateFrame("Frame", nil, checkbutton)
        bd:SetPoint("TOPLEFT", 6, -6)
        bd:SetPoint("BOTTOMRIGHT", -6, 6)
        bd:SetFrameLevel(checkbutton:GetFrameLevel())
        Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())

        checkbutton:SetNormalTexture("")
        checkbutton:SetPushedTexture("")
        checkbutton:SetHighlightTexture("")

        local check = checkbutton:GetCheckedTexture()
        check:ClearAllPoints()
        check:SetPoint("TOPLEFT", bd, -7, 7)
        check:SetPoint("BOTTOMRIGHT", bd, 7, -7)
        check:SetDesaturated(true)
        check:SetVertexColor(Aurora.highlightColor:GetRGB())

        local disabled = checkbutton:GetDisabledCheckedTexture()
        disabled:ClearAllPoints()
        disabled:SetPoint("TOPLEFT", -7, 7)
        disabled:SetPoint("BOTTOMRIGHT", 7, -7)

        checkbutton._auroraBDFrame = bd
        Base.SetHighlight(checkbutton, "backdrop")

        --[[ Scale ]]--
        checkbutton:SetSize(checkbutton:GetSize())
    end

    function Skin.PortraitFrameTemplate(frame, noCloseButton)
        local name = frame:GetName()

        frame.Bg:Hide()
        _G[name.."TitleBg"]:Hide()
        frame.portrait:SetAlpha(0)
        if private.isPatch then
            frame.PortraitFrame:SetTexture("")
            frame.TopRightCorner:Hide()
            frame.TopLeftCorner:Hide()
            frame.TopBorder:SetTexture("")
        else
            frame.portraitFrame:SetTexture("")
            _G[name.."TopRightCorner"]:Hide()
            frame.topLeftCorner:Hide()
            frame.topBorderBar:SetTexture("")
        end

        local titleText = frame.TitleText
        titleText:ClearAllPoints()
        titleText:SetPoint("TOPLEFT")
        titleText:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)

        frame.TopTileStreaks:SetTexture("")
        if private.isPatch then
            frame.BotLeftCorner:Hide()
            frame.BotRightCorner:Hide()
            frame.BottomBorder:Hide()
            frame.LeftBorder:Hide()
            frame.RightBorder:Hide()
        else
            _G[name.."BotLeftCorner"]:Hide()
            _G[name.."BotRightCorner"]:Hide()
            _G[name.."BottomBorder"]:Hide()
            frame.leftBorderBar:Hide()
            _G[name.."RightBorder"]:Hide()
        end

        Base.SetBackdrop(frame)
        if not noCloseButton then
            Skin.UIPanelCloseButton(frame.CloseButton)
            frame.CloseButton:SetPoint("TOPRIGHT", -3, -3)
        end
    end
    function Skin.InsetFrameTemplate(frame)
        frame.Bg:Hide()

        frame.InsetBorderTopLeft:Hide()
        frame.InsetBorderTopRight:Hide()

        frame.InsetBorderBottomLeft:Hide()
        frame.InsetBorderBottomRight:Hide()

        frame.InsetBorderTop:Hide()
        frame.InsetBorderBottom:Hide()
        frame.InsetBorderLeft:Hide()
        frame.InsetBorderRight:Hide()
    end
    function Skin.ButtonFrameTemplate(frame)
        Skin.PortraitFrameTemplate(frame)
        local name = frame:GetName()

        _G[name.."BtnCornerLeft"]:SetTexture("")
        _G[name.."BtnCornerRight"]:SetTexture("")
        _G[name.."ButtonBottomBorder"]:SetTexture("")
        Skin.InsetFrameTemplate(frame.Inset)
    end

    function Skin.TooltipBorderedFrameTemplate(frame)
        frame.BorderTopLeft:Hide()
        frame.BorderTopRight:Hide()

        frame.BorderBottomLeft:Hide()
        frame.BorderBottomRight:Hide()

        frame.BorderTop:Hide()
        frame.BorderBottom:Hide()
        frame.BorderLeft:Hide()
        frame.BorderRight:Hide()

        frame.Background:Hide()
        Base.SetBackdrop(frame)
    end

    function Skin.UIMenuButtonStretchTemplate(button)
        button:SetSize(button:GetSize())

        button.TopLeft:Hide()
        button.TopRight:Hide()
        button.BottomLeft:Hide()
        button.BottomRight:Hide()
        button.TopMiddle:Hide()
        button.MiddleLeft:Hide()
        button.MiddleRight:Hide()
        button.BottomMiddle:Hide()
        button.MiddleMiddle:Hide()
        button:SetHighlightTexture("")

        local bd = _G.CreateFrame("Frame", nil, button)
        bd:SetPoint("TOPLEFT", 1, -1)
        bd:SetPoint("BOTTOMRIGHT", -1, 1)
        bd:SetFrameLevel(button:GetFrameLevel())
        Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())

        button._auroraBDFrame = bd
        Base.SetHighlight(button, "backdrop")
    end

    function Skin.HorizontalSliderTemplate(slider)
        slider:SetBackdrop(nil)

        local bg = _G.CreateFrame("Frame", nil, slider)
        bg:SetPoint("TOPLEFT", slider, 5, -5)
        bg:SetPoint("BOTTOMRIGHT", slider, -5, 5)
        bg:SetFrameLevel(slider:GetFrameLevel())
        Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())

        local thumbTexture = slider:GetThumbTexture()
        thumbTexture:SetAlpha(0)
        thumbTexture:SetSize(8, 16)

        local thumb = _G.CreateFrame("Frame", nil, bg)
        thumb:SetPoint("TOPLEFT", thumbTexture, 0, 0)
        thumb:SetPoint("BOTTOMRIGHT", thumbTexture, 0, 0)
        Base.SetBackdrop(thumb, Aurora.buttonColor:GetRGBA())
        slider._auroraThumb = thumb
    end

    function Skin.UIPanelScrollBarButton(button)
        button:SetSize(17, 17)
        button:SetNormalTexture("")
        button:SetPushedTexture("")
        button:SetHighlightTexture("")

        local disabled = button:GetDisabledTexture()
        disabled:SetVertexColor(0, 0, 0, .3)
        disabled:SetDrawLayer("OVERLAY")
        disabled:SetAllPoints()

        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
    end
    function Skin.UIPanelScrollUpButtonTemplate(button)
        Skin.UIPanelScrollBarButton(button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -6)
        arrow:SetPoint("BOTTOMRIGHT", -5, 7)
        Base.SetTexture(arrow, "arrowUp")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")
    end
    function Skin.UIPanelScrollDownButtonTemplate(button)
        Skin.UIPanelScrollBarButton(button)

        local arrow = button:CreateTexture(nil, "ARTWORK")
        arrow:SetPoint("TOPLEFT", 4, -7)
        arrow:SetPoint("BOTTOMRIGHT", -5, 6)
        Base.SetTexture(arrow, "arrowDown")

        button._auroraHighlight = {arrow}
        Base.SetHighlight(button, "texture")
    end
    function Skin.UIPanelScrollBarTemplate(slider)
        Skin.UIPanelScrollUpButtonTemplate(slider.ScrollUpButton)
        Skin.UIPanelScrollDownButtonTemplate(slider.ScrollDownButton)

        slider.ThumbTexture:SetAlpha(0)
        slider.ThumbTexture:SetWidth(17)

        local thumb = _G.CreateFrame("Frame", nil, slider)
        thumb:SetPoint("TOPLEFT", slider.ThumbTexture, 0, -2)
        thumb:SetPoint("BOTTOMRIGHT", slider.ThumbTexture, 0, 2)
        Base.SetBackdrop(thumb, Aurora.buttonColor:GetRGBA())
        slider._auroraThumb = thumb
    end
    function Skin.UIPanelStretchableArtScrollBarTemplate(slider)
        Skin.UIPanelScrollBarTemplate(slider)

        slider.Top:Hide()
        slider.Bottom:Hide()
        slider.Middle:Hide()

        slider.Background:Hide()
    end
    function Skin.UIPanelScrollFrameTemplate(scrollframe)
        Skin.UIPanelScrollBarTemplate(scrollframe.ScrollBar)
        scrollframe.ScrollBar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 2, -17)
        scrollframe.ScrollBar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", 2, 17)
    end
    function Skin.FauxScrollFrameTemplate(scrollframe)
        Skin.UIPanelScrollFrameTemplate(scrollframe)
    end
    function Skin.ListScrollFrameTemplate(scrollframe)
        Skin.FauxScrollFrameTemplate(scrollframe)
        local name = scrollframe:GetName()
        _G[name.."Top"]:Hide()
        _G[name.."Bottom"]:Hide()
        _G[name.."Middle"]:Hide()
    end
    function Skin.InputBoxTemplate(editbox)
        editbox.Left:Hide()
        editbox.Right:Hide()
        editbox.Middle:Hide()

        local bg = _G.CreateFrame("Frame", nil, editbox)
        bg:SetPoint("TOPLEFT", editbox.Left)
        bg:SetPoint("BOTTOMRIGHT", editbox.Right)
        bg:SetFrameLevel(editbox:GetFrameLevel() - 1)
        Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())
    end
    function Skin.InputBoxInstructionsTemplate(editbox)
        Skin.InputBoxTemplate(editbox)
    end

    function Skin.MaximizeMinimizeButtonFrameTemplate(frame)
        frame:SetSize(17, 17)
        for _, name in next, {"MaximizeButton", "MinimizeButton"} do
            local button = frame[name]
            button:SetSize(17, 17)
            button:SetNormalTexture("")
            button:SetPushedTexture("")
            button:SetHighlightTexture("")

            Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())

            button:ClearAllPoints()
            button:SetPoint("CENTER")

            button._auroraHighlight = {}

            local lineOfs = 4
            local line = button:CreateLine()
            line:SetColorTexture(1, 1, 1)
            line:SetThickness(0.5)
            line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
            line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
            tinsert(button._auroraHighlight, line)

            local hline = button:CreateTexture()
            hline:SetColorTexture(1, 1, 1)
            hline:SetSize(7, 1)
            tinsert(button._auroraHighlight, hline)

            local vline = button:CreateTexture()
            vline:SetColorTexture(1, 1, 1)
            vline:SetSize(1, 7)
            tinsert(button._auroraHighlight, vline)

            if name == "MaximizeButton" then
                hline:SetPoint("TOP", 1, -4)
                vline:SetPoint("RIGHT", -4, 1)
            else
                hline:SetPoint("BOTTOM", -1, 4)
                vline:SetPoint("LEFT", 4, -1)
            end

            Base.SetHighlight(button, "color")
        end
    end
end

function private.SharedXML.SharedUIPanelTemplates()
    _G.hooksecurefunc("PanelTemplates_TabResize", Hook.PanelTemplates_TabResize)
    _G.hooksecurefunc("PanelTemplates_DeselectTab", Hook.PanelTemplates_DeselectTab)
    _G.hooksecurefunc("PanelTemplates_SelectTab", Hook.PanelTemplates_SelectTab)
end
