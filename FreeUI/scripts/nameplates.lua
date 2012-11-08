-- caelNamePlates by Caellian, modified.

local F, C, L = unpack(select(2, ...))

if not C.general.nameplates then return end

local caelNamePlates = CreateFrame("Frame", nil, UIParent)
caelNamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local select = select

local freq = C.performance.nameplates
local tfreq = C.performance.namethreat

local CreateBD = function(parent, offset)
	local left = parent:CreateTexture(nil, "BACKGROUND")
	left:SetWidth(offset)
	left:SetTexture(0, 0, 0)
	left:SetPoint("TOPLEFT", -offset, offset)
	left:SetPoint("BOTTOMLEFT", -offset, -offset)

	local right = parent:CreateTexture(nil, "BACKGROUND")
	right:SetWidth(offset)
	right:SetTexture(0, 0, 0)
	right:SetPoint("TOPRIGHT", offset, offset)
	right:SetPoint("BOTTOMRIGHT", offset, -offset)

	local top = parent:CreateTexture(nil, "BACKGROUND")
	top:SetHeight(offset)
	top:SetTexture(0, 0, 0)
	top:SetPoint("TOPLEFT", -offset, offset)
	top:SetPoint("TOPRIGHT", offset, offset)

	local bottom = parent:CreateTexture(nil, "BACKGROUND")
	bottom:SetHeight(offset)
	bottom:SetTexture(0, 0, 0)
	bottom:SetPoint("BOTTOMLEFT", -offset, -offset)
	bottom:SetPoint("BOTTOMRIGHT", offset, -offset)

	local bg = parent:CreateTexture(nil, "BACKGROUND")
	bg:SetTexture(0, 0, 0, .5)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
end

local CreateBG = function(parent, offset)
	local bg = parent:CreateTexture(nil, "BACKGROUND")
	bg:SetTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", offset, -offset)
	return bg
end

local ThreatUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed >= tfreq then
		if self.oldglow:IsShown() then
			local _, green = self.oldglow:GetVertexColor()
			if(green > .7) then
				self.healthBar:SetStatusBarColor(1, 1, .3) -- medium threat
			elseif(green > .1) then
				self.healthBar:SetStatusBarColor(1, .5, 0) -- losing aggro
			else
				self.healthBar:SetStatusBarColor(.3, 1, .3) -- tanking
			end
		else
			self.healthBar:SetStatusBarColor(self.r, self.g, self.b) -- normal colours e.g. not tanking/not NPC
		end
		self.elapsed = 0
	end
end

local function Round(x)
	return floor(x * (10 ^ 2) + .5) / 10 ^ 2
end

local oldClassColours = RAID_CLASS_COLORS
local newClassColours = C.classcolours

local function updateClassColour(r, g, b)
	local nR, nG, nB = Round(r), Round(g), Round(b)

	for class in pairs(oldClassColours) do
		if nR == oldClassColours[class].r and nG == oldClassColours[class].g and nB == oldClassColours[class].b then
			return newClassColours[class].r, newClassColours[class].g, newClassColours[class].b
		end
	end
	return r, g, b
end

local UpdateFrame = function(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		newr, newg, newb = 255/255, 30/255, 60/255
		self.healthBar:SetStatusBarColor(255/255, 30/255, 60/255)
	elseif r + b == 0 then
		newr, newg, newb = 0.33, 0.59, 0.33
		self.healthBar:SetStatusBarColor(0.33, 0.59, 0.33)
	elseif r + g == 0 then
		newr, newg, newb = 0.31, 0.45, 0.63
		self.healthBar:SetStatusBarColor(0.31, 0.45, 0.63)
	elseif 2 - (r + g) < 0.05 and b == 0 then
		newr, newg, newb = 1, 1, .3
		self.healthBar:SetStatusBarColor(1, 1, .3)
	else
		local cR, cG, cB = updateClassColour(r, g, b)
		if cR then
			newr, newg, newb = cR, cG, cB
			self.healthBar:SetStatusBarColor(newr, newg, newb)
		else
			newr, newg, newb = r, g, b
		end
	end

	self.r, self.g, self.b = newr, newg, newb

	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent())
	self.healthBar:SetHeight(5)
	self.healthBar:SetWidth(80)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -2)
	self.castBar:SetHeight(5)
	self.castBar:SetWidth(80)

	self.highlight:SetTexture(nil)

	self.name:SetText(self.oldname:GetText())

	local level, elite, mylevel = tonumber(self.level:GetText()), self.elite:IsShown(), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT", -2, 0)
	self.level:SetFont(C.media.font, 8 * UIParent:GetScale(), "OUTLINEMONOCHROME")
	self.level:SetShadowColor(0, 0, 0, 0)
	if self.boss:IsShown() then
		self.level:SetText("B")
		self.level:SetTextColor(0.8, 0.05, 0)
		self.level:Show()
	elseif not elite and level == mylevel then
		self.level:Hide()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local FixCastbar = function(self)
	self.castbarOverlay:Hide()

	self:SetHeight(5)
	-- self:SetWidth(80)
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -2)
end

local ColorCastBar = function(self, shielded)
	if shielded then
		self.iconbg:SetTexture(1, 0, 0)
	else
		self.iconbg:SetTexture(0, 0, 0)
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

local OnValueChanged = function(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local OnShow = function(self)
	self.channeling  = UnitChannelInfo("target")
	FixCastbar(self)
	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local OnEvent = function(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

local StyleFrame = function(frame)
	frame.done = true

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
	local _, castbarOverlay, shieldedRegion, spellIconRegion = castBar:GetRegions()

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	local newNameRegion = F.CreateFS(healthBar, 8 * UIParent:GetScale(), "CENTER")
	newNameRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 2)
	newNameRegion:SetWidth(80)
	newNameRegion:SetHeight(7)
	frame.name = newNameRegion

	frame.level = levelTextRegion

	healthBar:SetStatusBarTexture(C.media.texture)

	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(C.media.texture)

	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	castBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 10)
	raidIconRegion:SetHeight(14)
	raidIconRegion:SetWidth(14)

	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion

	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	UpdateFrame(frame)
	frame:SetScript("OnShow", UpdateFrame)
	frame:SetScript("OnHide", OnHide)

	frame.elapsed = 0
	frame:SetScript("OnUpdate", ThreatUpdate)

	local offset = UIParent:GetScale()
	CreateBD(healthBar, offset)
	CreateBD(castBar, offset)

	local iconFrame = CreateFrame("Frame", nil, castBar)
	iconFrame:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", 2, 2)
	iconFrame:SetHeight(16)
	iconFrame:SetWidth(16)
	iconFrame:SetFrameLevel(0)

	castBar.iconbg = CreateBG(iconFrame, offset)

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetAllPoints(iconFrame)
	spellIconRegion:SetTexCoord(.1, .9, .1, .9)
end

local numKids = 0
local last = 0
local index = 1
local OnUpdate = function(self, elapsed)
	last = last + elapsed

	if last > freq then
		last = 0

		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			numKids = WorldFrame:GetNumChildren()
			for i = index, numKids do
				local frame = select(i, WorldFrame:GetChildren())
				local name = frame:GetName()

				if name and name:find("NamePlate") and not frame.done then
					StyleFrame(frame)
					index = i
				end
			end
		end
	end
end

caelNamePlates:SetScript("OnUpdate", OnUpdate)