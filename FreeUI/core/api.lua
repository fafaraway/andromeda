local F, C = unpack(select(2, ...))

-- [[ Constants ]]

C.media = {
	["arrowUp"] = "Interface\\AddOns\\FreeUI\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\FreeUI\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\FreeUI\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\FreeUI\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground", -- default backdrop
	["checked"] = "Interface\\AddOns\\FreeUI\\media\\CheckButtonHilight", -- replace default checked texture
	["font"] = "Interface\\AddOns\\FreeUI\\media\\PFRondaSeven.ttf", -- default pixel font
	["font2"] = "Interface\\AddOns\\FreeUI\\media\\font.ttf", -- default font
	["glow"] = "Interface\\AddOns\\FreeUI\\media\\glowTex", -- glow/shadow texture
	["gradient"] = "Interface\\AddOns\\FreeUI\\media\\gradient",
	["roleIcons"] = "Interface\\Addons\\FreeUI\\media\\UI-LFG-ICON-ROLES",
	["texture"] = "Interface\\AddOns\\FreeUI\\media\\statusbar", -- statusbar texture
}

local mainFont

if C.appearance.fontUseAlternativeFont then
	mainFont = C.media.font2
elseif GetLocale() == "ruRU" then
	mainFont = "Interface\\AddOns\\FreeUI\\media\\iFlash705.ttf"
else
	mainFont = C.media.font
end

F.AddOptionsCallback("appearance", "fontUseAlternativeFont", function()
	if C.appearance.fontUseAlternativeFont then
		mainFont = C.media.font2
	elseif GetLocale() == "ruRU" then
		mainFont = "Interface\\AddOns\\FreeUI\\media\\iFlash705.ttf"
	else
		mainFont = C.media.font
	end
end)

C.classcolours = {
	["DEATHKNIGHT"] = {r = 0.77, g = 0.12, b = 0.23},
	["DEMONHUNTER"] = {r = 0.64, g = 0.19, b = 0.79},
	["DRUID"] = {r = 1, g = 0.49, b = 0.04},
	["HUNTER"] = {r = 0.58, g = 0.86, b = 0.49},
	["MAGE"] = {r = 0, g = 0.76, b = 1},
	["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
	["PALADIN"] = {r = 1, g = 0.22, b = 0.52},
	["PRIEST"] = {r = 0.8, g = 0.87, b = .9},
	["ROGUE"] = {r = 1, g = 0.91, b = 0.2},
	["SHAMAN"] = {r = 0, g = 0.6, b = 0.6},
	["WARLOCK"] = {r = 0.6, g = 0.47, b = 0.85},
	["WARRIOR"] = {r = 0.9, g = 0.65, b = 0.45},
}

local _, class = UnitClass("player")
if C.appearance.colourScheme == 2 then
	C.class = {C.appearance.customColour.r, C.appearance.customColour.g, C.appearance.customColour.b}
else
	C.class = {C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b}
end

C.r, C.g, C.b = unpack(C.class)

C.reactioncolours = {
	[1] = {1, .12, .24},
	[2] = {1, .12, .24},
	[3] = {1, .12, .24},
	[4] = {1, 1, 0.3},
	[5] = {0.26, 1, 0.22},
	[6] = {0.26, 1, 0.22},
	[7] = {0.26, 1, 0.22},
	[8] = {0.26, 1, 0.22},
}

C.myClass = class
C.myName = UnitName("player")
C.myRealm = GetRealmName()

C.FONT_SIZE_NORMAL = 1
C.FONT_SIZE_LARGE = 2

-- [[ Functions ]]

F.dummy = function() end

-- compatibility with Aurora plugins that are compatible with Aurora's custom style system
F.AddPlugin = function(func)
	func()
end

local CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	f:SetBackdropColor(0, 0, 0, a or .5)
	f:SetBackdropBorderColor(0, 0, 0)
end

F.CreateBD = CreateBD

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
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = C.media.glow,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

F.CreateFS = function(parent, fontSize, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
    F.SetFS(f, fontSize)

    if justify then f:SetJustifyH(justify) end

    return f
end

F.SetFS = function(fontObject, fontSize)
	local size

	if(not fontSize or fontSize == C.FONT_SIZE_NORMAL) then
		size = C.appearance.fontSizeNormal
	elseif fontSize == C.FONT_SIZE_LARGE then
		size = C.appearance.fontSizeLarge
	elseif fontSize > 4 then -- actual size
		size = fontSize
	end

	local outline = nil
	if C.appearance.fontOutline then
		outline = C.appearance.fontOutlineStyle == 2 and "OUTLINEMONOCHROME" or "OUTLINE"
	end

	fontObject:SetFont(mainFont, size, outline)

	if C.appearance.fontShadow then
		fontObject:SetShadowColor(0, 0, 0)
		fontObject:SetShadowOffset(1, -1)
	else
		fontObject:SetShadowOffset(0, 0)
	end
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

local r, g, b = unpack(C.class)
local buttonR, buttonG, buttonB, buttonA = .3, .3, .3, .3

local CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(C.media.gradient)
	tex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)

	return tex
end

F.CreateGradient = CreateGradient

local function colourButton(f)
	if not f:IsEnabled() then return end

	f:SetBackdropColor(r, g, b, buttonA)
	f:SetBackdropBorderColor(r, g, b)
end

local function clearButton(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
end

F.Reskin = function(f, noHighlight)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	F.CreateBD(f, 0)

	f.tex = CreateGradient(f)

	if not noHighlight then
		f:HookScript("OnEnter", colourButton)
 		f:HookScript("OnLeave", clearButton)
	end
end

F.ReskinTab = function(f)
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg)

	f:SetHighlightTexture(C.media.texture)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 9, -4)
	hl:SetPoint("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function colourScroll(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearScroll(f)
	f.tex:SetVertexColor(1, 1, 1)
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

	local bu = f.ThumbTexture or f.thumbTexture or _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = CreateGradient(f)
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)

	local up = f.ScrollUpButton or f.UpButton or _G[(frame or parent).."ScrollUpButton"]
	local down = f.ScrollDownButton or f.DownButton or _G[(frame or parent).."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)

	F.Reskin(up, true)
	F.Reskin(down, true)

	up:SetDisabledTexture(C.media.backdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(C.media.backdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(C.media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.tex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.tex = downtex

	up:HookScript("OnEnter", colourScroll)
	up:HookScript("OnLeave", clearScroll)
	down:HookScript("OnEnter", colourScroll)
	down:HookScript("OnLeave", clearScroll)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.tex:SetVertexColor(1, 1, 1)
end

F.colourArrow = colourArrow
F.clearArrow = clearArrow

F.ReskinDropDown = function(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 10, -4)
	bg:SetPoint("BOTTOMRIGHT", -12, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg, 0)

	local gradient = CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bg, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bg, -1, 1)

	local down = _G[frame.."Button"]
	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("TOPRIGHT", bg)
	F.Reskin(down, true)

	down:SetDisabledTexture(C.media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = down:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	down.tex = tex

	down:HookScript("OnEnter", colourArrow)
	down:HookScript("OnLeave", clearArrow)
end

local function colourClose(f)
	if f:IsEnabled() then
		for _, pixel in pairs(f.pixels) do
			pixel:SetVertexColor(r, g, b)
		end
	end
end

local function clearClose(f)
	for _, pixel in pairs(f.pixels) do
		pixel:SetVertexColor(1, 1, 1)
	end
end

F.ReskinClose = function(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if a1 then
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	else
		f:SetPoint("TOPRIGHT", -6, -6)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	F.CreateBD(f, 0)

	CreateGradient(f)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	local lineOfs = 2.5
	for i = 1, 2 do
		local line = f:CreateLine()
		line:SetColorTexture(1, 1, 1)
		line:SetThickness(0.5)
		if i == 1 then
			line:SetStartPoint("TOPLEFT", lineOfs, -lineOfs)
			line:SetEndPoint("BOTTOMRIGHT", -lineOfs, lineOfs)
		else
			line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
			line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
		end
		tinsert(f.pixels, line)
	end

	f:HookScript("OnEnter", colourClose)
 	f:HookScript("OnLeave", clearClose)
end

F.ReskinInput = function(f, height, width)
	local frame = f:GetName()

	local left = f.Left or _G[frame.."Left"]
	local middle = f.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
	local right = f.Right or _G[frame.."Right"]

	left:Hide()
	middle:Hide()
	right:Hide()

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local gradient = CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

F.ReskinArrow = function(f, direction)
	f:SetSize(18, 18)
	F.Reskin(f, true)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:SetTexture("Interface\\AddOns\\FreeUI\\media\\arrow-"..direction.."-active")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	f.tex = tex

	f:HookScript("OnEnter", colourArrow)
	f:HookScript("OnLeave", clearArrow)
end

F.ReskinCheck = function(f, isTriState)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(C.media.texture)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local tex = CreateGradient(f)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)

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
					ch:SetVertexColor(r, g, b)
				else
					-- 1 is a dark check
					ch:SetVertexColor(r * 0.5, g * 0.5, b * 0.5)
				end
			end
		end
	end
end

local function colourRadio(f)
	f.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(f)
	f.bd:SetBackdropBorderColor(0, 0, 0)
end

F.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetCheckedTexture(C.media.texture)

	local ch = f:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)
	f.bd = bd

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

F.ReskinSlider = function(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = F.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	CreateGradient(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

local function colourExpandOrCollapse(f)
	if f:IsEnabled() then
		f.plus:SetVertexColor(r, g, b)
		f.minus:SetVertexColor(r, g, b)
	end
end

local function clearExpandOrCollapse(f)
	f.plus:SetVertexColor(1, 1, 1)
	f.minus:SetVertexColor(1, 1, 1)
end

F.colourExpandOrCollapse = colourExpandOrCollapse
F.clearExpandOrCollapse = clearExpandOrCollapse

F.ReskinExpandOrCollapse = function(f)
	f:SetSize(13, 13)

	F.Reskin(f, true)
	f.SetNormalTexture = F.dummy

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:SetSize(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(C.media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:SetSize(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(C.media.backdrop)
	f.plus:SetVertexColor(1, 1, 1)

	f:HookScript("OnEnter", colourExpandOrCollapse)
	f:HookScript("OnLeave", clearExpandOrCollapse)
end

F.SetBD = function(f, x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg)
end

F.ReskinPortraitFrame = function(f, isButtonFrame)
	local name = f:GetName()

	f.Bg:Hide()
	_G[name.."TitleBg"]:Hide()
	f.portrait:Hide()
	f.portraitFrame:Hide()
	_G[name.."TopRightCorner"]:Hide()
	f.topLeftCorner:Hide()
	f.topBorderBar:Hide()
	f.TopTileStreaks:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	f.leftBorderBar:Hide()
	_G[name.."RightBorder"]:Hide()

	F.ReskinClose(f.CloseButton)
	f.portrait.Show = F.dummy

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		f.Inset.Bg:Hide()
		f.Inset:DisableDrawLayer("BORDER")
	end

	F.CreateBD(f)
end

F.CreateBDFrame = function(f, a)
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", f, 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	CreateBD(bg, a or .5)

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

F.ReskinFilterButton = function(f)
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
	f.Icon:SetTexture(C.media.arrowRight)

	f.Text:SetPoint("CENTER")
	f.Icon:SetPoint("RIGHT", f, "RIGHT", -5, 0)
	f.Icon:SetSize(8, 8)
end

F.ReskinNavBar = function(f)
	local overflowButton = f.overflowButton

	f:GetRegions():Hide()
	f:DisableDrawLayer("BORDER")
	f.overlay:Hide()
	f.homeButton:GetRegions():Hide()

	F.Reskin(f.homeButton)
	F.Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.tex = tex

	overflowButton:HookScript("OnEnter", colourArrow)
	overflowButton:HookScript("OnLeave", clearArrow)
end

F.ReskinGarrisonPortrait = function(portrait, isTroop)
	portrait:SetSize(portrait.Portrait:GetSize())
	F.CreateBD(portrait, 1)

	portrait.Portrait:ClearAllPoints()
	portrait.Portrait:SetPoint("TOPLEFT")

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
	return F.CreateBG(icon)
end
