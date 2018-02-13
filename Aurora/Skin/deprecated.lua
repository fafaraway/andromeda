local ADDON_NAME, private = ...

local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

local F, C = {}, {}
Aurora[1] = F
Aurora[2] = C

C.backdrop = private.backdrop
C.media = {
    ["arrowUp"] = [[Interface\AddOns\Aurora\media\arrow-up-active]],
    ["arrowDown"] = [[Interface\AddOns\Aurora\media\arrow-down-active]],
    ["arrowLeft"] = [[Interface\AddOns\Aurora\media\arrow-left-active]],
    ["arrowRight"] = [[Interface\AddOns\Aurora\media\arrow-right-active]],
    ["backdrop"] = [[Interface\ChatFrame\ChatFrameBackground]],
    ["checked"] = [[Interface\AddOns\Aurora\media\CheckButtonHilight]],
    ["gradient"] = [[Interface\AddOns\Aurora\media\gradient]],
    ["roleIcons"] = [[Interface\AddOns\Aurora\media\UI-LFG-ICON-ROLES]],
    ["font"] = private.font.normal,
    ["glow"] = [[Interface\AddOns\Aurora\media\glowTex]],
    ["bgtex"] = [[Interface\AddOns\Aurora\media\StripesThin]],
    ["texture"] = [[Interface\AddOns\Aurora\media\statusbar]],
}


C.themes = {}
C.themes[ADDON_NAME] = {}

-- use of this function ensures that Aurora and custom style (if used) are properly initialised
-- prior to loading third party plugins
F.AddPlugin = function(func)
    if private.isLoaded then
        func()
    else
        _G.tinsert(C.themes[ADDON_NAME], func)
    end
end

F.dummy = function() end

F.CreateBD = function(frame, alpha)
    local r, g, b, a
    if alpha then
        r, g, b = Aurora.frameColor:GetRGB()
        a = alpha
    end

    if not a then
        _G.tinsert(C.frames, frame)

        frame.tex = frame.tex or frame:CreateTexture(nil, "BACKGROUND", nil, 1)
        frame.tex:SetTexture(C.media.bgtex, true, true)
        frame.tex:SetAlpha(.7)
        frame.tex:SetAllPoints()
        frame.tex:SetHorizTile(true)
        frame.tex:SetVertTile(true)
        frame.tex:SetBlendMode("ADD")
    else
        frame:SetBackdropColor(0, 0, 0, a)
    end
    Base.SetBackdrop(frame, r, g, b, a)
end

F.CreateBG = function(frame)
    local f = frame
    if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

    local bg = f:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("TOPLEFT", frame, -1, 1)
    bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
    bg:SetTexture(C.media.backdrop)
    bg:SetVertexColor(0, 0, 0)

    return bg
end

F.CreateSD = function(parent, size, r, g, b, alpha, offset)
    local sd = CreateFrame("Frame", nil, parent)
    sd.size = size or 4
    sd.offset = offset or -1
    sd:SetBackdrop({
        edgeFile = C.media.glow,
        edgeSize = sd.size,
    })
    sd:SetPoint("TOPLEFT", parent, -sd.size - 0 - sd.offset, sd.size + 0 + sd.offset)
    sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 0 + sd.offset, -sd.size - 0 - sd.offset)
    sd:SetBackdropBorderColor(r or .03, g or .03, b or .03)
    sd:SetAlpha(alpha or .6)
end

F.CreateGradient = function(f)
    local tex
    if f.GetBackdropTexture then
        if C.buttonsHaveGradient then
            tex = f:GetBackdropTexture("bg")
            Aurora.Base.SetTexture(tex, "gradientUp")
            f:SetBackdropColor(Aurora.buttonColor:GetRGBA())
        end
    else
        tex = f:CreateTexture(nil, "BORDER")
        tex:SetPoint("TOPLEFT", 1, -1)
        tex:SetPoint("BOTTOMRIGHT", -1, 1)
        if C.buttonsHaveGradient then
            Aurora.Base.SetTexture(tex, "gradientUp")
        else
            tex:SetTexture(C.media.backdrop)
        end
        tex:SetVertexColor(Aurora.buttonColor:GetRGBA())
    end
    return tex
end

F.CreatePulse = function(frame) -- pulse function originally by nightcracker
    local speed = .05
    local mult = 1
    local alpha = 1
    local last = 0
    frame:SetScript("OnUpdate", function(self, elapsed)
        last = last + elapsed
        if last > speed then
            last = 0
            self:SetAlpha(alpha)
        end
        alpha = alpha - elapsed*mult
        if alpha < 0 and mult > 0 then
            mult = mult*-1
            alpha = 0
        elseif alpha > 1 and mult < 0 then
            mult = mult*-1
        end
    end)
end

local function StartGlow(f)
    if not f:IsEnabled() then return end
    -- f:SetBackdropColor(r, g, b, .1)
    Base.SetBackdrop(f, Aurora.buttonColor:GetRGBA())
    f:SetBackdropBorderColor(Aurora.highlightColor:GetRGB())
    f.glow:SetAlpha(1)
    F.CreatePulse(f.glow)
end

local function StopGlow(f)
    -- f:SetBackdropColor(0, 0, 0, 0)
    -- f:SetBackdropBorderColor(0, 0, 0)
    Base.SetBackdrop(f, Aurora.buttonColor:GetRGBA())
    f.glow:SetScript("OnUpdate", nil)
    f.glow:SetAlpha(0)
end

F.Reskin = function(f, noGlow)
    f:SetNormalTexture("")
    f:SetHighlightTexture("")
    f:SetPushedTexture("")
    f:SetDisabledTexture("")

    if f.Left then f.Left:SetAlpha(0) end
    if f.Middle then f.Middle:SetAlpha(0) end
    if f.Right then f.Right:SetAlpha(0) end
    if f.LeftSeparator then f.LeftSeparator:Hide() end
    if f.RightSeparator then f.RightSeparator:Hide() end

    -- F.CreateBD(f, 0)
    -- F.CreateGradient(f)
    Base.SetBackdrop(f, Aurora.buttonColor:GetRGBA())

    if not noGlow then
        f.glow = CreateFrame("Frame", nil, f)
        f.glow:SetBackdrop({
            edgeFile = C.media.glow,
            edgeSize = 5,
        })
        f.glow:SetPoint("TOPLEFT", -6, 6)
        f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
        f.glow:SetBackdropBorderColor(Aurora.highlightColor:GetRGB())
        f.glow:SetAlpha(0)

        f:HookScript("OnEnter", StartGlow)
        f:HookScript("OnLeave", StopGlow)
    end
end

-- F.Reskin = function(f, noHighlight)
--     f:SetNormalTexture("")
--     f:SetHighlightTexture("")
--     f:SetPushedTexture("")
--     f:SetDisabledTexture("")

--     if f.Left then f.Left:SetAlpha(0) end
--     if f.Middle then f.Middle:SetAlpha(0) end
--     if f.Right then f.Right:SetAlpha(0) end
--     if f.LeftSeparator then f.LeftSeparator:Hide() end
--     if f.RightSeparator then f.RightSeparator:Hide() end

--     Base.SetBackdrop(f, Aurora.buttonColor:GetRGBA())
--     if not noHighlight then
--         Base.SetHighlight(f, "backdrop")
--     end
-- end

F.ReskinClose = function(f, a1, p, a2, x, y)
    f:SetDisabledTexture(C.media.backdrop) -- some frames that use this don't have a disabled texture
    Skin.UIPanelCloseButton(f)

    if not a1 then
        f:SetPoint("TOPRIGHT", -6, -6)
    else
        f:ClearAllPoints()
        f:SetPoint(a1, p, a2, x, y)
    end
end

F.ReskinTab = function(f, numTabs)
    if numTabs then
        for i = 1, numTabs do
            for j = 1, 6 do
                _G.select(j, _G[f..i]:GetRegions()):Hide()
                _G.select(j, _G[f..i]:GetRegions()).Show = F.dummy
            end
        end
    else
        f:DisableDrawLayer("BACKGROUND")

        local bg = _G.CreateFrame("Frame", nil, f)
        bg:SetPoint("TOPLEFT", 8, -3)
        bg:SetPoint("BOTTOMRIGHT", -8, 0)
        bg:SetFrameLevel(f:GetFrameLevel()-1)
        Base.SetBackdrop(bg)

        local red, green, blue = Aurora.highlightColor:GetRGB()
        f:SetHighlightTexture(C.media.backdrop)
        local hl = f:GetHighlightTexture()
        hl:SetPoint("TOPLEFT", 9, -4)
        hl:SetPoint("BOTTOMRIGHT", -9, 1)
        hl:SetVertexColor(red, green, blue, .25)
    end
end

F.ReskinScroll = function(f, parent)
    local frame = f:GetName()

    local track = (f.trackBG or f.Background) or (_G[frame.."Track"] or _G[frame.."BG"])
    if track then track:Hide() end
    local top = (f.ScrollBarTop or f.Top) or _G[frame.."Top"]
    if top then top:Hide() end
    local middle = (f.ScrollBarMiddle or f.Middle) or _G[frame.."Middle"]
    if middle then middle:Hide() end
    local bottom = (f.ScrollBarBottom or f.Bottom) or _G[frame.."Bottom"]
    if bottom then bottom:Hide() end

    local bu = (f.ThumbTexture or f.thumbTexture) or _G[frame.."ThumbTexture"]
    bu:SetAlpha(0)
    bu:SetWidth(17)

    bu.bg = _G.CreateFrame("Frame", nil, f)
    bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
    bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
    Base.SetBackdrop(bu.bg, Aurora.buttonColor:GetRGBA())

    local up = (f.ScrollUpButton or f.UpButton) or _G[(frame or parent).."ScrollUpButton"]
    local down = (f.ScrollDownButton or f.DownButton) or _G[(frame or parent).."ScrollDownButton"]

    Skin.UIPanelScrollUpButtonTemplate(up)
    Skin.UIPanelScrollDownButtonTemplate(down)
end

F.ReskinDropDown = function(f, borderless)
    local frame = f:GetName()

    local button = f.Button or _G[frame.."Button"]
    F.ReskinArrow(button, "Down")
    button:ClearAllPoints()

    local bg = _G.CreateFrame("Frame", nil, f)
    bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", 1, 0)
    bg:SetFrameLevel(f:GetFrameLevel()-1)
    Base.SetBackdrop(bg, Aurora.buttonColor:GetRGBA())

    if borderless then
        button:SetPoint("TOPRIGHT", 0, -6)
        bg:SetPoint("TOPLEFT", 0, -6)
    else
        local left = _G[frame.."Left"]
        local middle = _G[frame.."Middle"]
        local right = _G[frame.."Right"]

        left:SetAlpha(0)
        middle:SetAlpha(0)
        right:SetAlpha(0)

        button:SetPoint("TOPRIGHT", right, -19, -21)
        bg:SetPoint("TOPLEFT", 20, -4)
    end
end

F.ReskinInput = function(f, height, width)
    local frame = f:GetName()

    local left = f.Left or _G[frame.."Left"]
    local middle = f.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
    local right = f.Right or _G[frame.."Right"]

    left:Hide()
    middle:Hide()
    right:Hide()

    local bd = _G.CreateFrame("Frame", nil, f)
    bd:SetPoint("TOPLEFT", -2, 0)
    bd:SetPoint("BOTTOMRIGHT")
    bd:SetFrameLevel(f:GetFrameLevel()-1)
    Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())

    if height then f:SetHeight(height) end
    if width then f:SetWidth(width) end
end

F.ReskinMoneyInput = function(f)
    Skin.MoneyInputFrameTemplate(f)
end

F.CreateArrow = function(f, direction)
    local arrow = f:CreateTexture(nil, "ARTWORK")
    if direction == "Up" or direction == "Down" then
        arrow:SetSize(8, 4)
    else
        arrow:SetSize(4, 8)
    end
    arrow:SetPoint("CENTER")
    Base.SetTexture(arrow, "arrow"..direction)

    f._auroraArrow = arrow
    f._auroraHighlight = {arrow}
    Base.SetHighlight(f, "texture")
end
F.ReskinArrow = function(f, direction)
    f:SetSize(18, 18)
    F.Reskin(f, true)

    f:SetDisabledTexture(C.media.backdrop)
    local dis = f:GetDisabledTexture()
    dis:SetVertexColor(0, 0, 0, .3)
    dis:SetDrawLayer("OVERLAY")

    F.CreateArrow(f, direction)
end

F.ReskinCheck = function(f, isTriState)
    local red, green, blue = Aurora.highlightColor:GetRGB()

    f:SetNormalTexture("")
    f:SetPushedTexture("")
    f:SetHighlightTexture(C.media.backdrop)
    local hl = f:GetHighlightTexture()
    hl:SetPoint("TOPLEFT", 5, -5)
    hl:SetPoint("BOTTOMRIGHT", -5, 5)
    hl:SetVertexColor(red, green, blue, .2)

    local bd = _G.CreateFrame("Frame", nil, f)
    bd:SetPoint("TOPLEFT", 4, -4)
    bd:SetPoint("BOTTOMRIGHT", -4, 4)
    bd:SetFrameLevel(f:GetFrameLevel()-1)
    Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())

    local ch = f:GetCheckedTexture()
    ch:SetDesaturated(true)
    ch:SetVertexColor(red, green, blue)

    if isTriState then
        function f:SetTriState(state)
            if ( not state or state == 0 ) then
                -- nil or 0 means not checked
                self:SetChecked(false)
            else
                ch:SetDesaturated(true)
                self:SetChecked(true)
                if ( state == 2 ) then
                    -- 2 is a normal check
                    ch:SetVertexColor(red, green, blue)
                else
                    -- 1 is a dark check
                    ch:SetVertexColor(red * 0.5, green * 0.5, blue * 0.5)
                end
            end
        end
    end
end

F.ReskinRadio = function(f)
    local red, green, blue = Aurora.highlightColor:GetRGB()

    f:SetNormalTexture("")
    f:SetHighlightTexture("")
    f:SetCheckedTexture(C.media.backdrop)

    local ch = f:GetCheckedTexture()
    ch:SetPoint("TOPLEFT", 4, -4)
    ch:SetPoint("BOTTOMRIGHT", -4, 4)
    ch:SetVertexColor(red, green, blue, .6)

    local bd = _G.CreateFrame("Frame", nil, f)
    bd:SetPoint("TOPLEFT", 3, -3)
    bd:SetPoint("BOTTOMRIGHT", -3, 3)
    bd:SetFrameLevel(f:GetFrameLevel()-1)

    Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())
    Base.SetHighlight(bd, "backdrop")
end

F.ReskinSlider = function(f, isVert)
    f:SetBackdrop(nil)
    f.SetBackdrop = F.dummy

    local bd = _G.CreateFrame("Frame", nil, f)
    bd:SetPoint("TOPLEFT", 14, -2)
    bd:SetPoint("BOTTOMRIGHT", -15, 3)
    bd:SetFrameStrata("BACKGROUND")
    bd:SetFrameLevel(f:GetFrameLevel()-1)
    Base.SetBackdrop(bd, Aurora.frameColor:GetRGBA())

    local slider = _G.select(4, f:GetRegions())
    slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
    if isVert then
        slider:SetTexCoord(1,0, 0,0, 1,1, 0,1)
    end
    slider:SetBlendMode("ADD")
end

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
F.ReskinExpandOrCollapse = function(f)
    f:SetHighlightTexture("")
    f:SetPushedTexture("")

    local bg = _G.CreateFrame("Frame", nil, f)
    bg:SetSize(13, 13)
    bg:SetPoint("TOPLEFT", f:GetNormalTexture(), 0, -2)
    Base.SetBackdrop(bg, Aurora.buttonColor:GetRGBA())
    f._auroraBG = bg

    f._auroraHighlight = {}
    bg.minus = bg:CreateTexture(nil, "OVERLAY")
    bg.minus:SetSize(7, 1)
    bg.minus:SetPoint("CENTER")
    bg.minus:SetColorTexture(1, 1, 1)
    _G.tinsert(f._auroraHighlight, bg.minus)

    bg.plus = bg:CreateTexture(nil, "OVERLAY")
    bg.plus:SetSize(1, 7)
    bg.plus:SetPoint("CENTER")
    bg.plus:SetColorTexture(1, 1, 1)
    _G.tinsert(f._auroraHighlight, bg.plus)

    Base.SetHighlight(f, "color")
    _G.hooksecurefunc(f, "SetNormalTexture", Hook_SetNormalTexture)
end

F.SetBD = function(f, x, y, x2, y2)
    local bg = _G.CreateFrame("Frame", nil, f)
    if not x then
        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT")
    else
        bg:SetPoint("TOPLEFT", x, y)
        bg:SetPoint("BOTTOMRIGHT", x2, y2)
    end
    bg:SetFrameLevel(f:GetFrameLevel()-1)
    F.CreateBD(bg)
    F.CreateSD(bg)
end

F.ReskinPortraitFrame = function(f, isButtonFrame)
    if isButtonFrame then
        f.CloseButton:SetDisabledTexture(C.media.backdrop) -- some frames that use this don't have a disabled texture
        Skin.ButtonFrameTemplate(f)
    else
        Skin.PortraitFrameTemplate(f, not f.CloseButton)
    end
end

F.CreateBDFrame = function(f, a, left, right, top, bottom)
    local frame
    if f:GetObjectType() == "Texture" then
        frame = f:GetParent()
    else
        frame = f
    end

    local lvl = frame:GetFrameLevel()

    local bg = _G.CreateFrame("Frame", nil, frame)
    bg:SetPoint("TOPLEFT", f, left or -1, top or 1)
    bg:SetPoint("BOTTOMRIGHT", f, right or 1, bottom or -1)
    bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

    F.CreateBD(bg, a or .5)

    return bg
end

F.ReskinColourSwatch = function(f)
    local name = f:GetName()

    local bg = _G[name.."SwatchBg"]

    f:SetNormalTexture(C.media.backdrop)
    local nt = f:GetNormalTexture()

    nt:SetPoint("TOPLEFT", 3, -3)
    nt:SetPoint("BOTTOMRIGHT", -3, 3)

    bg:SetColorTexture(0, 0, 0)
    bg:SetPoint("TOPLEFT", 2, -2)
    bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

F.ReskinStretchButton = function(f)
    f.TopLeft:Hide()
    f.TopRight:Hide()
    f.BottomLeft:Hide()
    f.BottomRight:Hide()
    f.TopMiddle:Hide()
    f.MiddleLeft:Hide()
    f.MiddleRight:Hide()
    f.BottomMiddle:Hide()
    f.MiddleMiddle:Hide()

    F.Reskin(f)
end

F.ReskinFilterButton = function(f, direction)
    F.ReskinStretchButton(f)

    f.Icon:SetPoint("RIGHT", -7, 0)
    f.Icon:SetSize(4, 8)

    direction = direction or "Right"
    Base.SetTexture(f.Icon, "arrow"..direction)
end

F.ReskinNavBar = function(f)
    local overflowButton = f.overflowButton

    f:GetRegions():Hide()
    f:DisableDrawLayer("BORDER")
    f.overlay:Hide()
    f.homeButton:GetRegions():Hide()

    F.Reskin(f.homeButton)
    F.Reskin(overflowButton, true)
    F.CreateArrow(overflowButton, "Left")
end

F.ReskinGarrisonPortrait = function(portrait, isTroop)
    local size = portrait.Portrait:GetSize() + 2
    portrait:SetSize(size, size)
    F.CreateBD(portrait, 1)

    portrait.Portrait:ClearAllPoints()
    portrait.Portrait:SetPoint("TOPLEFT", 1, -1)

    portrait.PortraitRing:Hide()
    portrait.PortraitRingQuality:SetTexture("")
    portrait.PortraitRingCover:SetTexture("")
    portrait.LevelBorder:SetAlpha(0)

    if not isTroop then
        local lvlBG = portrait:CreateTexture(nil, "BORDER")
        lvlBG:SetColorTexture(0, 0, 0, 0.5)
        lvlBG:SetPoint("TOPLEFT", portrait, "BOTTOMLEFT", 1, 12)
        lvlBG:SetPoint("BOTTOMRIGHT", portrait, -1, 1)

        local level = portrait.Level
        level:ClearAllPoints()
        level:SetPoint("CENTER", lvlBG)
    end
end

F.ReskinIcon = function(icon)
    icon:SetTexCoord(.08, .92, .08, .92)
    return F.CreateBDFrame(icon)
end

F.ReskinTooltip = function(f)
    f:SetBackdrop(nil)

    local bg
    if f.BackdropFrame then
        bg = f.BackdropFrame
    else
        bg = _G.CreateFrame("Frame", nil, f)
        bg:SetFrameLevel(f:GetFrameLevel()-1)
    end
    bg:SetPoint("TOPLEFT")
    bg:SetPoint("BOTTOMRIGHT")

    Base.SetBackdrop(bg)
end

F.ReskinItemFrame = function(frame)
    local icon = frame.Icon
    frame._auroraIconBorder = F.ReskinIcon(icon)

    local nameFrame = frame.NameFrame
    nameFrame:SetAlpha(0)

    local bg = _G.CreateFrame("Frame", nil, frame)
    bg:SetPoint("TOP", icon, 0, 1)
    bg:SetPoint("BOTTOM", icon, 0, -1)
    bg:SetPoint("LEFT", icon, "RIGHT", 2, 0)
    bg:SetPoint("RIGHT", nameFrame, -4, 0)
    F.CreateBD(bg, .2)
    frame._auroraNameBG = bg
end
