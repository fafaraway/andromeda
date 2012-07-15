local F, C, L = unpack(select(2, ...))

-- [[ Constants ]]

C.media = {
	["arrowUp"] = "Interface\\AddOns\\Aurora\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\Aurora\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\Aurora\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\Aurora\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground", -- default backdrop
	["checked"] = "Interface\\AddOns\\FreeUI\\media\\CheckButtonHilight", -- replace default checked texture
	["font"] = "Interface\\AddOns\\FreeUI\\media\\Hooge0655.ttf", -- default pixel font
	["font2"] = "Interface\\AddOns\\FreeUI\\media\\font.ttf", -- default font
	["glow"] = "Interface\\AddOns\\FreeUI\\media\\glowTex", -- glow/shadow texture
	["texture"] = "Interface\\AddOns\\FreeUI\\media\\statusbar", -- statusbar texture
}

C.classcolours = {
	["DEATHKNIGHT"] = {r = 0.77, g = 0.12, b = 0.23},
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
C.class = {C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b}

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

-- [[ Functions ]]

F.dummy = function() end

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

F.CreateFS = function(parent, size, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont(C.media.font, size, "OUTLINEMONOCHROME")
    f:SetShadowColor(0, 0, 0, 0)
    if(justify) then f:SetJustifyH(justify) end
    return f
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

local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b

local CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
end

F.CreateGradient = CreateGradient

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropColor(r, g, b, .1)
	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	F.CreatePulse(f.glow)
end

local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
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

	F.CreateBD(f, 0)

	CreateGradient(f)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = C.media.glow,
			edgeSize = 5,
		})
		f.glow:SetPoint("TOPLEFT", -6, 6)
		f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
 		f:HookScript("OnLeave", StopGlow)
	end
end

F.CreateTab = function(f)
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

F.ReskinScroll = function(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
	if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", bu.bg)
	tex:SetPoint("BOTTOMRIGHT", bu.bg)
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)
	
	F.Reskin(up)
	F.Reskin(down)
	
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

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.downtex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.downtex:SetVertexColor(1, 1, 1)
end

F.ReskinDropDown = function(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	F.Reskin(down, true)
	
	down:SetDisabledTexture(C.media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.downtex = downtex
	
	down:HookScript("OnEnter", colourArrow)
	down:HookScript("OnLeave", clearArrow)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg, 0)

	CreateGradient(bg)
end

local function colourClose(f)
	f.text:SetTextColor(1, .1, .1)
end

local function clearClose(f)
	f.text:SetTextColor(1, 1, 1)
end

F.ReskinClose = function(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if a1 then
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	else
		f:SetPoint("TOPRIGHT", -4, -4)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	F.CreateBD(f, 0)

	CreateGradient(f)

	local text = f:CreateFontString(nil, "OVERLAY")
	text:SetFont(C.media.font2, 14, "THINOUTLINE")
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")
	f.text = text

	f:HookScript("OnEnter", colourClose)
 	f:HookScript("OnLeave", clearClose)
end

F.ReskinInput = function(f, height, width)
	local frame = f:GetName()
	_G[frame.."Left"]:Hide()
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
	_G[frame.."Right"]:Hide()
	
	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	CreateGradient(bd)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

F.ReskinArrow = function(f, direction)
	f:SetSize(18, 18)
	F.Reskin(f)
	
	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	
	tex:SetTexture("Interface\\AddOns\\FreeUI\\media\\arrow-"..direction.."-active")
end

F.ReskinCheck = function(f)
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

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
	
	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

F.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture(C.media.texture)
	f:SetCheckedTexture(C.media.texture)
	
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 4, -4)
	hl:SetPoint("BOTTOMRIGHT", -4, 4)
	hl:SetVertexColor(r, g, b, .3)
	
	local ch = f:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)
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

F.ReskinExpandOrCollapse = function(f)
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
	bg:SetFrameLevel(0)
	F.CreateBD(bg)
	F.CreateSD(bg)
end

F.ReskinPortraitFrame = function(f, isButtonFrame)
	local name = f:GetName()
	
	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()
	
	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")
		
		f.Inset.Bg:Hide()
		f.Inset:DisableDrawLayer("BORDER")
	end

	F.CreateBD(f)
	F.CreateSD(f)
	F.ReskinClose(_G[name.."CloseButton"])
end

F.CreateBDFrame = function(f)
	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	CreateBD(bg, .25)
end