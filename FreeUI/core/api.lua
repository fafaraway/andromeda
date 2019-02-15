local F, C, L = unpack(select(2, ...))

local type, pairs, tonumber, wipe = type, pairs, tonumber, table.wipe
local strmatch, gmatch, strfind, format = string.match, string.gmatch, string.find, string.format
local min, max, abs, floor = math.min, math.max, math.abs, math.floor


local r, g, b
if C.appearance.colourScheme == 2 then
	r, g, b = C.appearance.customColour.r, C.appearance.customColour.g, C.appearance.customColour.b
else
	r, g, b = C.ClassColors[C.Class].r, C.ClassColors[C.Class].g, C.ClassColors[C.Class].b
end




-- [[ Functions ]]

function F:CreateFS(size, flag, text, justify, colour, shadow, anchor, x, y)
	local fs = self:CreateFontString(nil, "OVERLAY")
	fs:SetWordWrap(false)

	if size == 'pixel' then
		fs:SetFont(C.font.pixel, 8, 'OUTLINEMONOCHROME')
	elseif size == 'pixelbig' then
		fs:SetFont(C.font.pixel, 16, 'OUTLINEMONOCHROME')
	else
		fs:SetFont(C.font.normal, size, flag)
	end

	if text then
		fs:SetText(text)
	end
	
	if justify then
		fs:SetJustifyH(justify)
	end

	if colour and colour == "class" then
		fs:SetTextColor(C.r, C.g, C.b)
	elseif colour and colour == "yellow" then
		fs:SetTextColor(.9, .82, .62)
	elseif colour and colour == "red" then
		fs:SetTextColor(1, .15, .21)
	elseif colour and colour == "green" then
		fs:SetTextColor(.23, .62, .21)
	elseif colour and colour == "grey" then
		fs:SetTextColor(.5, .5, .5)
	else
		fs:SetTextColor(1, 1, 1)
	end

	if shadow and type(shadow) == "boolean" then
		fs:SetShadowColor(0, 0, 0, 1)
		fs:SetShadowOffset(1, -1)
	elseif shadow and shadow == '2' then
		fs:SetShadowColor(0, 0, 0, 1)
		fs:SetShadowOffset(2, -2)
	else
		fs:SetShadowColor(0, 0, 0, 0)
	end

	if anchor and x and y then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end

	return fs
end

function F.SetFS(fontObject, fontSize)
	fontObject:SetFont(C.font.pixel, 8, "OUTLINEMONOCHROME")
	fontObject:SetShadowColor(0, 0, 0)
	fontObject:SetShadowOffset(1, -1)
end

function F:CreateTex()
	if self.Tex then return end

	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	self.Tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	self.Tex:SetAllPoints(self)
	self.Tex:SetTexture(C.media.bgTex, true, true)
	self.Tex:SetHorizTile(true)
	self.Tex:SetVertTile(true)
	self.Tex:SetBlendMode("BLEND")
end

function F:CreateSD(a)
	if not C.appearance.addShadowBorder then return end
	if self.Shadow then return end

	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	local lvl = frame:GetFrameLevel()

	self.Shadow = CreateFrame("Frame", nil, frame)
	self.Shadow:SetPoint("TOPLEFT", self, -3, 3)
	self.Shadow:SetPoint("BOTTOMRIGHT", self, 3, -3)
	self.Shadow:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = 4})
	self.Shadow:SetBackdropBorderColor(0, 0, 0, a or .5)
	self.Shadow:SetFrameLevel(lvl == 0 and 0 or lvl - 1)

	return self.Shadow
end

function F:CreateBD(a)
	self:SetBackdrop({
		bgFile = C.media.backdrop, edgeFile = C.media.backdrop, edgeSize = C.Mult,
	})
	self:SetBackdropColor(C.appearance.backdropColour[1], C.appearance.backdropColour[2], C.appearance.backdropColour[3], a or C.appearance.backdropColour[4])
	self:SetBackdropBorderColor(0, 0, 0)

	F.CreateTex(self)
end

function F:CreateBG(offset)
	local f = self
	if self:GetObjectType() == "Texture" then f = self:GetParent() end
	offset = offset or C.Mult

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", self, -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", self, offset, -offset)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0, 1)

	return bg
end

function F:CreateBGAlt(offset)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	offset = offset or C.Mult
	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", self, -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", self, offset, -offset)
	bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
	return bg
end

function F:CreateBDFrame(a)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", self, -C.Mult, C.Mult)
	bg:SetPoint("BOTTOMRIGHT", self, C.Mult, -C.Mult)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateBD(bg, a)

	return bg
end

local buttonR, buttonG, buttonB, buttonA

if C.appearance.useButtonGradientColour then
	buttonR, buttonG, buttonB, buttonA = unpack(C.appearance.buttonGradientColour)
else
	buttonR, buttonG, buttonB, buttonA = unpack(C.appearance.buttonSolidColour)
end

function F:CreateGradient()
	local tex = self:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", C.Mult, -C.Mult)
	tex:SetPoint("BOTTOMRIGHT", -C.Mult, C.Mult)
	tex:SetTexture(C.appearance.useButtonGradientColour and C.media.gradient or C.media.backdrop)
	tex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)

	return tex
end

local function CreatePulse(frame)
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
	--f:SetBackdropColor(.2, .2, .2, .7)

	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	CreatePulse(f.glow)
end

local function StopGlow(f)
	--f:SetBackdropColor(.2, .2, .2, .7)
	f:SetBackdropBorderColor(0, 0, 0)

	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

function F.Reskin(f, noGlow)
	if f.SetNormalTexture then f:SetNormalTexture("") end
	if f.SetHighlightTexture then f:SetHighlightTexture("") end
	if f.SetPushedTexture then f:SetPushedTexture("") end
	if f.SetDisabledTexture then f:SetDisabledTexture("") end

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:SetAlpha(0) end
	if f.RightSeparator then f.RightSeparator:SetAlpha(0) end
	if f.TopLeft then f.TopLeft:SetAlpha(0) end
	if f.TopMiddle then f.TopMiddle:SetAlpha(0) end
	if f.TopRight then f.TopRight:SetAlpha(0) end
	if f.MiddleLeft then f.MiddleLeft:SetAlpha(0) end
	if f.MiddleMiddle then f.MiddleMiddle:SetAlpha(0) end
	if f.MiddleRight then f.MiddleRight:SetAlpha(0) end
	if f.BottomLeft then f.BottomLeft:SetAlpha(0) end
	if f.BottomMiddle then f.BottomMiddle:SetAlpha(0) end
	if f.BottomRight then f.BottomRight:SetAlpha(0) end

	--f:SetBackdropColor(.2, .2, .2, .7)

	F.CreateBD(f, .0)

	f.bgTex = F.CreateGradient(f)
	
	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = C.media.glowTex,
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

function F:ReskinTab()
	self:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, self)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(self:GetFrameLevel()-1)
	F.CreateBD(bg)

	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 9, -4)
	hl:SetPoint("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function textureOnEnter(self)
	if self:IsEnabled() then
		if self.pixels then
			for _, pixel in pairs(self.pixels) do
				pixel:SetVertexColor(r, g, b)
			end
		else
			--self.bgTex:SetVertexColor(C.r, C.g, C.b)
		end
	end
end
F.colourArrow = textureOnEnter

local function textureOnLeave(self)
	if self.pixels then
		for _, pixel in pairs(self.pixels) do
			pixel:SetVertexColor(1, 1, 1)
		end
	else
		--self.bgTex:SetVertexColor(0, 0, 0)
	end
end
F.clearArrow = textureOnLeave

local function scrollOnEnter(self)
	local bu = (self.ThumbTexture or self.thumbTexture) or _G[self:GetName().."ThumbTexture"]
	if not bu then return end
	bu.bg:SetBackdropColor(r, g, b, .25)
	bu.bg:SetBackdropBorderColor(r, g, b)
end
local function scrollOnLeave(self)
	local bu = (self.ThumbTexture or self.thumbTexture) or _G[self:GetName().."ThumbTexture"]
	if not bu then return end
	bu.bg:SetBackdropColor(0, 0, 0, 0)
	bu.bg:SetBackdropBorderColor(0, 0, 0)
end

function F:ReskinScroll()
	local frame = self:GetName()
	F.StripTextures(self:GetParent())

	local track = (self.trackBG or self.Background or self.Track) or (_G[frame.."Track"] or _G[frame.."BG"])
	if track then track:Hide() end
	local top = (self.ScrollBarTop or self.Top or self.ScrollUpBorder) or _G[frame.."Top"]
	if top then top:Hide() end
	local middle = (self.ScrollBarMiddle or self.Middle or self.Border) or _G[frame.."Middle"]
	if middle then middle:Hide() end
	local bottom = (self.ScrollBarBottom or self.Bottom or self.ScrollDownBorder) or _G[frame.."Bottom"]
	if bottom then bottom:Hide() end

	local bu = (self.ThumbTexture or self.thumbTexture) or _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, self)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = F.CreateGradient(self)
	tex:SetPoint("TOPLEFT", bu.bg, C.Mult, -C.Mult)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -C.Mult, C.Mult)

	local up, down = self:GetChildren()
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
	up.bgTex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.bgTex = downtex

	up:HookScript("OnEnter", textureOnEnter)
	up:HookScript("OnLeave", textureOnLeave)
	down:HookScript("OnEnter", textureOnEnter)
	down:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinDropDown()
	local frame = self:GetName()

	local left = self.Left or _G[frame.."Left"]
	local middle = self.Middle or _G[frame.."Middle"]
	local right = self.Right or _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = self.Button or _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

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
	down.bgtex = tex

	down:HookScript("OnEnter", textureOnEnter)
	down:HookScript("OnLeave", textureOnLeave)

	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)

	local gradient = F.CreateGradient(self)
	gradient:SetPoint("TOPLEFT", bg, C.Mult, -C.Mult)
	gradient:SetPoint("BOTTOMRIGHT", bg, -C.Mult, C.Mult)
end

function F:ReskinClose(a1, p, a2, x, y)
	self:SetSize(17*C.Mult, 17*C.Mult)

	if not a1 then
		self:SetPoint("TOPRIGHT", -6, -6)
	else
		self:ClearAllPoints()
		self:SetPoint(a1, p, a2, x, y)
	end

	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetDisabledTexture("")
	F.CreateBD(self, 0)
	F.CreateGradient(self)

	self:SetDisabledTexture(C.media.backdrop)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	self.pixels = {}
	for i = 1, 2 do
		local tex = self:CreateTexture()
		tex:SetColorTexture(1, 1, 1)
		tex:SetSize(11, 2)
		tex:SetPoint("CENTER")
		tex:SetRotation(math.rad((i-1/2)*90))
		tinsert(self.pixels, tex)
	end

	self:HookScript("OnEnter", textureOnEnter)
	self:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinInput(height, width)
	local frame = self:GetName()

	local left = self.Left or _G[frame.."Left"]
	local middle = self.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
	local right = self.Right or _G[frame.."Right"]

	left:Hide()
	middle:Hide()
	right:Hide()

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(self)
	gradient:SetPoint("TOPLEFT", bd, C.Mult, -C.Mult)
	gradient:SetPoint("BOTTOMRIGHT", bd, -C.Mult, C.Mult)

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end
end

function F:ReskinArrow(direction)
	self:SetSize(18, 18)
	F.Reskin(self, true)

	self:SetDisabledTexture(C.media.backdrop)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = self:CreateTexture(nil, "ARTWORK")
	local themeMediaPath = "Interface\\AddOns\\FreeUI\\assets\\"
	tex:SetTexture(themeMediaPath.."arrow-"..direction.."-active")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	self.bgtex = tex

	self:HookScript("OnEnter", textureOnEnter)
	self:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinCheck()
	self:SetNormalTexture("")
	self:SetPushedTexture("")
	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)

	local tex = F.CreateGradient(self)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

local function colourRadio(self)
	self.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(self)
	self.bd:SetBackdropBorderColor(0, 0, 0)
end

function F:ReskinRadio()
	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetCheckedTexture(C.media.backdrop)

	local ch = self:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)
	self.bd = bd

	local tex = F.CreateGradient(self)
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)

	self:HookScript("OnEnter", colourRadio)
	self:HookScript("OnLeave", clearRadio)
end

function F:ReskinSlider(verticle)
	self:SetBackdrop(nil)
	self.SetBackdrop = F.Dummy

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bd, 0)

	F.CreateGradient(bd)

	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			region:SetBlendMode("ADD")

			if verticle then region:SetRotation(math.rad(90)) end
			return
		end
	end
end

local function expandOnEnter(self)
	if self:IsEnabled() then
		self.bg:SetBackdropColor(r, g, b, .3)
	end
end

local function expandOnLeave(self)
	self.bg:SetBackdropColor(0, 0, 0, .3)
end

local function SetupTexture(self, texture)
	if self.settingTexture then return end
	self.settingTexture = true
	self:SetNormalTexture("")

	if texture and texture ~= "" then
		if texture:find("Plus") then
			self.expTex:SetTexCoord(0, 0.4375, 0, 0.4375)
		elseif texture:find("Minus") then
			self.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
		end
		self.bg:Show()
	else
		self.bg:Hide()
	end
	self.settingTexture = nil
end

function F:ReskinExpandOrCollapse()
	self:SetHighlightTexture("")
	self:SetPushedTexture("")

	local bg = F.CreateBDFrame(self, .3)
	bg:ClearAllPoints()
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", self:GetNormalTexture())
	F.CreateGradient(bg)
	self.bg = bg

	self.expTex = bg:CreateTexture(nil, "OVERLAY")
	self.expTex:SetSize(7, 7)
	self.expTex:SetPoint("CENTER")
	self.expTex:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")

	self:HookScript("OnEnter", expandOnEnter)
	self:HookScript("OnLeave", expandOnLeave)
	hooksecurefunc(self, "SetNormalTexture", SetupTexture)
end

function F:SetBD(x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, self)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(self:GetFrameLevel() - 1)
	F.CreateBD(bg)
	F.CreateSD(bg)
end

function F:ReskinPortraitFrame()
	F.StripTextures(self)
	F.SetBD(self)
	local frameName = self.GetName and self:GetName()
	local portrait = self.portrait or _G[frameName.."Portrait"]
	portrait:SetAlpha(0)
	local closeButton = self.CloseButton or _G[frameName.."CloseButton"]
	F.ReskinClose(closeButton)
end

function F:ReskinColourSwatch()
	local name = self:GetName()

	self:SetNormalTexture(C.media.backdrop)
	local nt = self:GetNormalTexture()
	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	local bg = _G[name.."SwatchBg"]
	bg:SetColorTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

function F:ReskinFilterButton()
	self.TopLeft:Hide()
	self.TopRight:Hide()
	self.BottomLeft:Hide()
	self.BottomRight:Hide()
	self.TopMiddle:Hide()
	self.MiddleLeft:Hide()
	self.MiddleRight:Hide()
	self.BottomMiddle:Hide()
	self.MiddleMiddle:Hide()

	F.Reskin(self)
	self.Text:SetPoint("CENTER")
	self.Icon:SetTexture(C.media.arrowRight)
	self.Icon:SetPoint("RIGHT", self, "RIGHT", -5, 0)
	self.Icon:SetSize(8, 8)
end

function F:ReskinNavBar()
	if self.navBarStyled then return end

	local homeButton = self.homeButton
	local overflowButton = self.overflowButton

	self:GetRegions():Hide()
	self:DisableDrawLayer("BORDER")
	self.overlay:Hide()
	homeButton:GetRegions():Hide()
	F.Reskin(homeButton)
	F.Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.bgTex = tex

	overflowButton:HookScript("OnEnter", textureOnEnter)
	overflowButton:HookScript("OnLeave", textureOnLeave)

	self.navBarStyled = true
end

function F:ReskinGarrisonPortrait()
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	self.squareBG = F.CreateBDFrame(self, 1)
	self.squareBG:SetFrameLevel(self:GetFrameLevel())
	self.squareBG:SetPoint("TOPLEFT", 3, -3)
	self.squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
	
	if self.PortraitRingCover then
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
end

function F:ReskinIcon()
	self:SetTexCoord(.08, .92, .08, .92)
	return F.CreateBG(self)
end

function F:ReskinMinMax()
	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = self[name]
		if button then
			button:SetSize(17, 17)
			button:ClearAllPoints()
			button:SetPoint("CENTER", -3, 0)
			F.Reskin(button)

			button.pixels = {}

			local tex = button:CreateTexture()
			tex:SetColorTexture(1, 1, 1)
			tex:SetSize(11, 2)
			tex:SetPoint("CENTER")
			tex:SetRotation(math.rad(45))
			tinsert(button.pixels, tex)

			local hline = button:CreateTexture()
			hline:SetColorTexture(1, 1, 1)
			hline:SetSize(7, 2)
			tinsert(button.pixels, hline)
			local vline = button:CreateTexture()
			vline:SetColorTexture(1, 1, 1)
			vline:SetSize(2, 7)
			tinsert(button.pixels, vline)

			if name == "MaximizeButton" then
				hline:SetPoint("TOPRIGHT", -4, -4)
				vline:SetPoint("TOPRIGHT", -4, -4)
			else
				hline:SetPoint("BOTTOMLEFT", 4, 4)
				vline:SetPoint("BOTTOMLEFT", 4, 4)
			end

			button:SetScript("OnEnter", textureOnEnter)
			button:SetScript("OnLeave", textureOnLeave)
		end
	end
end

-- GameTooltip
function F:HideTooltip()
	GameTooltip:Hide()
end

local function tooltipOnEnter(self)
	GameTooltip:SetOwner(self, self.anchor)
	GameTooltip:ClearLines()
	if tonumber(self.text) then
		GameTooltip:SetSpellByID(self.text)
	else
		local r, g, b = 1, 1, 1
		if self.color == "class" then
			r, g, b = C.r, C.g, C.b
		elseif self.color == "system" then
			r, g, b = 1, .8, 0
		end
		GameTooltip:AddLine(self.text, r, g, b)
	end
	GameTooltip:Show()
end

function F:AddTooltip(anchor, text, color)
	self.anchor = anchor
	self.text = text
	self.color = color
	self:SetScript("OnEnter", tooltipOnEnter)
	self:SetScript("OnLeave", F.HideTooltip)
end

-- Button Color
function F:CreateBC(a)
	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetDisabledTexture("")

	if self.Left then self.Left:SetAlpha(0) end
	if self.Middle then self.Middle:SetAlpha(0) end
	if self.Right then self.Right:SetAlpha(0) end
	if self.LeftSeparator then self.LeftSeparator:Hide() end
	if self.RightSeparator then self.RightSeparator:Hide() end

	self:SetScript("OnEnter", function()
		self:SetBackdropBorderColor(r, g, b, 1)
	end)
	self:SetScript("OnLeave", function()
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	self:SetScript("OnMouseDown", function()
		self:SetBackdropColor(r, g, b, a or .3)
	end)
	self:SetScript("OnMouseUp", function()
		self:SetBackdropColor(0, 0, 0, a or .3)
	end)
end

-- Checkbox
function F:CreateCB(a)
	self:SetNormalTexture("")
	self:SetPushedTexture("")
	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .25)

	local bd = F.CreateBGAlt(self, -4)
	F.CreateBD(bd, a)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

-- Movable Frame
function F:CreateMF(parent, saved)
	local frame = parent or self
	frame:SetMovable(true)
	frame:SetUserPlaced(true)
	frame:SetClampedToScreen(true)

	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", function() frame:StartMoving() end)
	self:SetScript("OnDragStop", function()
		frame:StopMovingOrSizing()
		if not saved then return end
		local orig, _, tar, x, y = frame:GetPoint()
		FreeUIConfig["tempAnchor"][frame:GetName()] = {orig, "UIParent", tar, x, y}
	end)
end

function F:RestoreMF()
	local name = self:GetName()
	if name and FreeUIConfig["tempAnchor"][name] then
		self:ClearAllPoints()
		self:SetPoint(unpack(FreeUIConfig["tempAnchor"][name]))
	end
end

-- Icon Style
function F:PixelIcon(texture, highlight)
	F.CreateBD(self)
	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:SetPoint("TOPLEFT", C.Mult, -C.Mult)
	self.Icon:SetPoint("BOTTOMRIGHT", -C.Mult, C.Mult)
	self.Icon:SetTexCoord(unpack(C.TexCoord))
	if texture then
		local atlas = strmatch(texture, "Atlas:(.+)$")
		if atlas then
			self.Icon:SetAtlas(atlas)
		else
			self.Icon:SetTexture(texture)
		end
	end
	if highlight and type(highlight) == "boolean" then
		self:EnableMouse(true)
		self.HL = self:CreateTexture(nil, "HIGHLIGHT")
		self.HL:SetColorTexture(1, 1, 1, .25)
		self.HL:SetAllPoints(self.Icon)
	end
end

function F:AuraIcon(highlight)
	self.CD = CreateFrame("Cooldown", nil, self, "CooldownFrameTemplate")
	self.CD:SetAllPoints()
	self.CD:SetReverse(true)
	F.PixelIcon(self, nil, highlight)
	F.CreateSD(self)
end

function F:CreateGear(name)
	local bu = CreateFrame("Button", name, self)
	bu:SetSize(22, 22)
	bu.Icon = bu:CreateTexture(nil, "ARTWORK")
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(C.media.gearTex)
	bu.Icon:SetTexCoord(0, .5, 0, .5)
	bu:SetHighlightTexture(C.media.gearTex)
	bu:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)

	return bu
end

-- Statusbar
function F:CreateSB(spark, r, g, b)
	self:SetStatusBarTexture(C.media.sbTex)
	if r and g and b then
		self:SetStatusBarColor(r, g, b)
	else
		self:SetStatusBarColor(C.r, C.g, C.b)
	end
	F.CreateSD(self)
	self.BG = self:CreateTexture(nil, "BACKGROUND")
	self.BG:SetAllPoints()
	self.BG:SetTexture(C.media.backdrop)
	self.BG:SetVertexColor(0, 0, 0, .5)
	F.CreateTex(self.BG)
	if spark then
		self.Spark = self:CreateTexture(nil, "OVERLAY")
		self.Spark:SetTexture(C.media.sparkTex)
		self.Spark:SetBlendMode("ADD")
		self.Spark:SetAlpha(.8)
		self.Spark:SetPoint("TOPLEFT", self:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
		self.Spark:SetPoint("BOTTOMRIGHT", self:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
	end
end

-- Gradient Frame
function F:CreateGF(w, h, o, r, g, b, a1, a2)
	self:SetSize(w, h)
	self:SetFrameStrata("BACKGROUND")
	local gf = self:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(C.media.sbTex)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

-- Numberize
function F.Numb(n)
	if n >= 1e12 then
		return ("%.2ft"):format(n / 1e12)
	elseif n >= 1e9 then
		return ("%.2fb"):format(n / 1e9)
	elseif n >= 1e6 then
		return ("%.2fm"):format(n / 1e6)
	elseif n >= 1e3 then
		return ("%.1fk"):format(n / 1e3)
	else
		return ("%.0f"):format(n)
	end
end

function F.Round(x)
	return floor(x + .5)
end

-- Color code
function F.HexRGB(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
	end
end

function F.ClassColor(class)
	local color = C.ClassColors[class]
	if not color then return 1, 1, 1 end
	return color.r, color.g, color.b
end

function F.UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then
			r, g, b = F.ClassColor(class)
		end
	elseif UnitIsTapDenied(unit) then
		r, g, b = .6, .6, .6
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			local color = FACTION_BAR_COLORS[reaction]
			r, g, b = color.r, color.g, color.b
		end
	end
	return r, g, b
end

-- Disable function
F.HiddenFrame = CreateFrame("Frame")
F.HiddenFrame:Hide()

function F:HideObject()
	if self.UnregisterAllEvents then
		self:UnregisterAllEvents()
		self:SetParent(F.HiddenFrame)
	else
		self.Show = self.Hide
	end
	self:Hide()
end

local BlizzTextures = {
	"Inset",
	"inset",
	"InsetFrame",
	"LeftInset",
	"RightInset",
	"NineSlice",
	"BorderFrame",
	"bottomInset",
	"BottomInset",
	"bgLeft",
	"bgRight",
	"FilligreeOverlay",
}

function F:StripTextures(kill)
	local frameName = self.GetName and self:GetName()
	for _, texture in pairs(BlizzTextures) do
		local blizzFrame = self[texture] or frameName and _G[frameName..texture]
		if blizzFrame then
			F.StripTextures(blizzFrame, kill)
		end
	end

	if self.GetNumRegions then
		for i = 1, self:GetNumRegions() do
			local region = select(i, self:GetRegions())
			if region and region.IsObjectType and region:IsObjectType("Texture") then
				if kill and type(kill) == "boolean" then
					F.HideObject(region)
				elseif kill == 0 then
					region:SetAlpha(0)
				else
					region:SetTexture("")
				end
			end
		end
	end
end

function F:Dummy()
	return
end

function F:HideOption()
	self:SetAlpha(0)
	self:SetScale(.0001)
end

-- Smoothy
local smoothing = {}
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + math.min((value-cur)/8, math.max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if cur == value or math.abs(new - value) < 1 then
			smoothing[bar] = nil
			bar:SetValue_(value)
		end
	end
end)

local function SetSmoothValue(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end

function F:SmoothBar()
	if not self.SetValue_ then
		self.SetValue_ = self.SetValue
		self.SetValue = SetSmoothValue
	end
end

-- Timer Format
function F.FormatTime(s)
	local day, hour, minute = 86400, 3600, 60

	if s >= day then
		return format("|cffbebfb3%d|r", s/day), s % day -- grey
	elseif s >= hour then
		return format("|cffffffff%d|r", s/hour), s % hour -- white
	elseif s >= minute then
		return format("|cff67acdb%d|r", s/minute), s % minute -- blue
	elseif s < 5 then
		if C.general.cooldownCount_decimal then
			return format("|cffc50046%.1f|r", s), s - format("%.1f", s)
		else
			return format("|cffc50046%d|r", s + .5), s - floor(s)
		end
	elseif s < 60 then
		return format("|cffc5b879%d|r", s), s - floor(s) -- yellow
	else
		return format("|cff996ec3%d|r", s), s - floor(s)
	end
end

function F.FormatTimeRaw(s)
	if s >= day then
		return format("%dd", s/day)
	elseif s >= hour then
		return format("%dh", s/hour)
	elseif s >= minute then
		return format("%dm", s/minute)
	elseif s >= 3 then
		return floor(s)
	else
		return format("%d", s)
	end
end

function F:CooldownOnUpdate(elapsed, raw)
	local formatTime = raw and F.FormatTimeRaw or F.FormatTime
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= .1 then
		local timeLeft = self.expiration - GetTime()
		if timeLeft > 0 then
			local text = formatTime(timeLeft)
			self.timer:SetText(text)
		else
			self:SetScript("OnUpdate", nil)
			self.timer:SetText(nil)
		end
		self.elapsed = 0
	end
end

-- Table
function F.CopyTable(source, target)
	for key, value in pairs(source) do
		if type(value) == "table" then
			if not target[key] then target[key] = {} end
			for k in pairs(value) do
				target[key][k] = value[k]
			end
		else
			target[key] = value
		end
	end
end

function F.SplitList(list, variable, cleanup)
	if cleanup then wipe(list) end

	for word in variable:gmatch("%S+") do
		list[word] = true
	end
end

-- Itemlevel
local iLvlDB = {}
local itemLevelString = _G["ITEM_LEVEL"]:gsub("%%d", "")
local tip = CreateFrame("GameTooltip", "FreeUI_iLvlTooltip", nil, "GameTooltipTemplate")

function F.GetItemLevel(link, arg1, arg2)
	if iLvlDB[link] then return iLvlDB[link] end

	tip:SetOwner(UIParent, "ANCHOR_NONE")
	if arg1 and type(arg1) == "string" then
		tip:SetInventoryItem(arg1, arg2)
	elseif arg1 and type(arg1) == "number" then
		tip:SetBagItem(arg1, arg2)
	else
		tip:SetHyperlink(link)
	end

	for i = 2, 5 do
		local text = _G[tip:GetName().."TextLeft"..i]:GetText() or ""
		local found = text:find(itemLevelString)
		if found then
			local level = text:match("(%d+)%)?$")
			iLvlDB[link] = tonumber(level)
			break
		end
	end
	return iLvlDB[link]
end

function F.GetNPCID(guid)
	local id = tonumber((guid or ""):match("%-(%d-)%-%x-$"))
	return id
end

-- GUI APIs
function F:CreateButton(width, height, text, textColor, fontSize)
	local bu = CreateFrame("Button", nil, self)
	bu:SetSize(width, height)
	F.CreateBD(bu, .3)
	if type(text) == "boolean" then
		F.PixelIcon(bu, fontSize, true)
	else
		F.CreateBC(bu)
		bu.text = F.CreateFS(bu, fontSize or 12, nil, text, nil, textColor, true)
	end

	return bu
end

function F:CreateCheckBox()
	local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	F.CreateCB(cb)

	cb.Type = "CheckBox"
	return cb
end

function F:CreateEditBox(width, height)
	local eb = CreateFrame("EditBox", nil, self)
	eb:SetSize(width, height)
	eb:SetAutoFocus(false)
	eb:SetTextInsets(5, 5, 0, 0)
	eb:SetFontObject(GameFontHighlight)
	F.CreateBD(eb, .3)
	eb:SetScript("OnEscapePressed", function()
		eb:ClearFocus()
	end)
	eb:SetScript("OnEnterPressed", function()
		eb:ClearFocus()
	end)

	eb.Type = "EditBox"
	return eb
end

function F:CreateDropDown(width, height, data)
	local dd = CreateFrame("Frame", nil, self)
	dd:SetSize(width, height)
	F.CreateBD(dd)
	dd:SetBackdropBorderColor(1, 1, 1, .2)
	dd.Text = F.CreateFS(dd, 12, nil, "", nil, nil, true, "LEFT", 5, 0)
	dd.Text:SetPoint("RIGHT", -5, 0)
	dd.options = {}

	local bu = F.CreateGear(dd)
	bu:SetPoint("LEFT", dd, "RIGHT", -2, 0)
	local list = CreateFrame("Frame", nil, dd)
	list:SetPoint("TOP", dd, "BOTTOM")
	F.CreateBD(list, 1)
	list:Hide()
	bu:SetScript("OnShow", function() list:Hide() end)
	bu:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		ToggleFrame(list)
	end)
	dd.button = bu

	local opt, index = {}, 0
	local function optOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		for i = 1, #opt do
			if self == opt[i] then
				opt[i]:SetBackdropColor(1, .8, 0, .3)
				opt[i].selected = true
			else
				opt[i]:SetBackdropColor(0, 0, 0, .3)
				opt[i].selected = false
			end
		end
		dd.Text:SetText(self.text)
		list:Hide()
	end
	local function optOnEnter(self)
		if self.selected then return end
		self:SetBackdropColor(1, 1, 1, .25)
	end
	local function optOnLeave(self)
		if self.selected then return end
		self:SetBackdropColor(0, 0, 0, .3)
	end

	for i, j in pairs(data) do
		opt[i] = CreateFrame("Button", nil, list)
		opt[i]:SetPoint("TOPLEFT", 4, -4 - (i-1)*(height+2))
		opt[i]:SetSize(width - 8, height)
		F.CreateBD(opt[i], .3)
		opt[i]:SetBackdropBorderColor(1, 1, 1, .2)
		local text = F.CreateFS(opt[i], 12, nil, j, nil, nil, true, "LEFT", 5, 0)
		text:SetPoint("RIGHT", -5, 0)
		opt[i].text = j
		opt[i]:SetScript("OnClick", optOnClick)
		opt[i]:SetScript("OnEnter", optOnEnter)
		opt[i]:SetScript("OnLeave", optOnLeave)

		dd.options[i] = opt[i]
		index = index + 1
	end
	list:SetSize(width, index*(height+2) + 6)

	dd.Type = "DropDown"
	return dd
end

function F:CreateColorSwatch()
	local swatch = CreateFrame("Button", nil, self)
	swatch:SetSize(18, 18)
	F.CreateBD(swatch, 1)
	local tex = swatch:CreateTexture()
	tex:SetPoint("TOPLEFT", 2, -2)
	tex:SetPoint("BOTTOMRIGHT", -2, 2)
	tex:SetTexture(C.media.backdrop)
	swatch.tex = tex

	return swatch
end

function F:StyleSearchButton()
	F.StripTextures(self)
	if self.icon then
		F.ReskinIcon(self.icon)
	end
	F.CreateBD(self, .25)

	self:SetHighlightTexture(C.media.backdrop)
	local hl = self:GetHighlightTexture()
	hl:SetVertexColor(C.r, C.g, C.b, .25)
	hl:SetPoint("TOPLEFT", C.Mult, -C.Mult)
	hl:SetPoint("BOTTOMRIGHT", -C.Mult, C.Mult)
end


-- mythic affixes
function F:AffixesSetup()
	for _, frame in ipairs(self.Affixes) do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.bg then
			frame.bg = F.ReskinIcon(frame.Portrait)
		end
		if frame.info then
			frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		elseif frame.affixID then
			local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
			frame.Portrait:SetTexture(filedataid)
		end
	end
end


-- role updater
local function CheckRole()
	local tree = GetSpecialization()
	if not tree then return end
	local _, _, _, _, role, stat = GetSpecializationInfo(tree)
	if role == "TANK" then
		C.PlayerRole = "Tank"
	elseif role == "HEALER" then
		C.PlayerRole = "Healer"
	elseif role == "DAMAGER" then
		if stat == 4 then	--1力量，2敏捷，4智力
			C.PlayerRole = "Caster"
		else
			C.PlayerRole = "Melee"
		end
	end
end
F:RegisterEvent("PLAYER_LOGIN", CheckRole)
F:RegisterEvent("PLAYER_TALENT_UPDATE", CheckRole)