local F, C, L = unpack(select(2, ...))

if not C.unitframes.enable then return end

local parent, ns = ...
local oUF = ns.oUF
local cast = ns.cast

oUF.colors.power.MANA = {100/255, 149/255, 237/255}
oUF.colors.power.ENERGY = {1, 222/255, 80/255}
oUF.colors.power.FURY = { 54/255, 199/255, 63/255 }
oUF.colors.power.PAIN = { 255/255, 156/255, 0 }


local ufFont
if C.appearance.usePixelFont then -- Miss Lin really likes pixel font ;)
	ufFont = C.fontPixel
else
	ufFont = C.fontNormal
end


-- Short values
local siValue = function(val)
	if(val >= 1e6) then
		return format("%.2fm", val * 0.000001)
	elseif(val >= 1e4) then
		return format("%.1fk", val * 0.001)
	else
		return val
	end
end

local function hex(r, g, b)
	if not r then return '|cffFFFFFF' end
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end


-- Update resurrection/selection name colour
local updateNameColour = function(self, unit)
	if UnitIsUnit(unit, "target") then
		self.Text:SetTextColor(.1, .7, 1)
	elseif UnitIsDead(unit) then
		self.Text:SetTextColor(.7, .2, .1)
	else
		self.Text:SetTextColor(1, 1, 1)
	end
end

-- to use on child frame
local updateNameColourAlt = function(self)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, "target") then
			frame.Text:SetTextColor(.1, .7, 1)
			--frame.bd.Shadow:SetBackdropBorderColor(1, 0, 0, .85)
			frame.bd:SetBackdropBorderColor(1, 0, 0)
		elseif UnitIsDead(frame.unit) then
			frame.Text:SetTextColor(.7, .2, .1)
			--frame.bd.Shadow:SetBackdropBorderColor(0, 0, 0, .5)
			frame.bd:SetBackdropBorderColor(0, 0, 0)
		else
			frame.Text:SetTextColor(1, 1, 1)
			--frame.bd.Shadow:SetBackdropBorderColor(0, 0, 0, .5)
			frame.bd:SetBackdropBorderColor(0, 0, 0)
		end
	else
		frame.Text:SetTextColor(1, 1, 1)
		--frame.bd.Shadow:SetBackdropBorderColor(0, 0, 0, .5)
		frame.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

-- update selected boss frame border
local updateBorderColourAlt = function(self, unit)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, "target") then
			frame.Name:SetTextColor(.1, .7, 1)
			frame.sd:SetBackdropBorderColor(1, 1, 1, .5)
		elseif UnitIsDead(frame.unit) then
			frame.Name:SetTextColor(.7, .2, .1)
			frame.sd:SetBackdropBorderColor(0, 0, 0, .35)
		else
			frame.Name:SetTextColor(1, 1, 1)
			frame.sd:SetBackdropBorderColor(0, 0, 0, .35)
		end
	else
		frame.Name:SetTextColor(1, 1, 1)
		frame.sd:SetBackdropBorderColor(0, 0, 0, .35)
	end
end

-- Tags
oUF.Tags.Methods['free:playerHealth'] = function(unit)
	if UnitIsDead(unit) or UnitIsGhost(unit) then return end
	return siValue(UnitHealth(unit))
end
oUF.Tags.Events['free:playerHealth'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['free:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	return format("|cffffffff%s|r %.0f", siValue(min), (min/max)*100)
end
oUF.Tags.Events['free:health'] = oUF.Tags.Events.missinghp

-- classification
oUF.Tags.Methods["free:classification"] = function(unit)
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	if(c == 'worldboss' or l == -1) then
		return '|cff9D2933{B}|r '
	elseif(c == 'rare') then
		return '|cffFF99FF{R}|r '
	elseif(c == 'rareelite') then
		return '|cffFF0099{R+}|r '
	elseif(c == 'elite') then
		return '|cffCC3300{E}|r '
	end
end
oUF.Tags.Events["free:classification"] = "UNIT_CLASSIFICATION_CHANGED"

-- boss health requires frequent updates to work
oUF.Tags.Methods['free:bosshealth'] = function(unit)
	local val = oUF.Tags.Methods['free:health'](unit)
	return val or ""
end
oUF.Tags.Events['free:bosshealth'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_TARGETABLE_CHANGED"

-- utf8 short string
local function usub(str, len)
	local i = 1
	local n = 0
	while true do
		local b,e = string.find(str, "([%z\1-\127\194-\244][\128-\191]*)", i)
		if(b == nil) then
			return str
		end
		i = e + 1
		n = n + 1
		if(n > len) then
			local r = string.sub(str, 1, b-1)
			return r
		end
	end
end

local function getSummary(str)
	local t = string.gsub(str, "<.->", "")
	return usub(t, 100, "...")
end

local function shortName(unit)
	local name = UnitName(unit)
	if name and name:len() > 4 then name = usub(name, 4) end

	return name
end

oUF.Tags.Methods['free:name'] = function(unit)
	if not UnitIsConnected(unit) then
		return "Off"
	elseif UnitIsDead(unit) then
		return "Dead"
	elseif UnitIsGhost(unit) then
		return "Ghost"
	else
		return shortName(unit)
	end
end
oUF.Tags.Events['free:name'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['free:missinghealth'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)

	if not UnitIsConnected(unit) then
		return "Off"
	elseif UnitIsDead(unit) then
		return "Dead"
	elseif UnitIsGhost(unit) then
		return "Ghost"
	elseif min ~= max then
		return siValue(max-min)
	end
end
oUF.Tags.Events['free:missinghealth'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['free:power'] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if(min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	return siValue(min)
end
oUF.Tags.Events['free:power'] = oUF.Tags.Events.missingpp


-- Alt Power value tag
oUF.Tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return ("%s%%"):format(math.floor(cur/max*100 + .5))
	end
end
oUF.Tags.Events["altpower"] = "UNIT_POWER_UPDATE"


-- [[ Smooth ]]

local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local smoother, min, max = CreateFrame('Frame'), math.min, math.max
smoother:SetScript('OnUpdate', function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)


-- health
local PostUpdateHealth = function(Health, unit, min, max)
	local self = Health:GetParent()
	local r, g, b
	local reaction = C.reactioncolours[UnitReaction(unit, "player") or 5]

	local offline = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)

	if tapped or offline then
		r, g, b = .6, .6, .6
	elseif unit == "pet" then
		local _, class = UnitClass("player")
		r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b
	elseif UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b else r, g, b = 1, 1, 1 end
	else
		r, g, b = unpack(reaction)
	end

	if unit == "target" or unit:find("arena") then
		Health.value:SetTextColor(unpack(reaction))
	end

	if C.unitframes.transMode then
		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			self.Healthdef:Hide()
		else
			self.Healthdef:SetMinMaxValues(0, max)
			self.Healthdef:SetValue(max-min)

			if UnitIsPlayer(unit) then
				if C.unitframes.healthClassColor then
					self.Healthdef:GetStatusBarTexture():SetVertexColor(r, g, b)
				else
					self.Healthdef:GetStatusBarTexture():SetVertexColor(149/255, 0, 39/255)
				end
			else
				self.Healthdef:GetStatusBarTexture():SetVertexColor(unpack(reaction))
			end

			self.Healthdef:Show()
		end

		if tapped or offline then
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha("VERTICAL", .6, .6, .6, .6, .4, .4, .4, .6)
			else
				self.gradient:SetGradientAlpha("VERTICAL", .6, .6, .6, .6, .6, .6, .6, .6)
			end
		else
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
			else
				self.gradient:SetGradientAlpha("VERTICAL", .1, .1, .1, .6, .1, .1, .1, .6)
			end
		end

		if self.Text then
			updateNameColour(self, unit)
		end
	else
		if UnitIsDead(unit) or UnitIsGhost(unit) then
			Health:SetValue(0)
		end
		Health:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/2, g/2, b/2)
	end
end


-- Power
local PostUpdatePower = function(Power, unit, cur, max, min)
	local Health = Power:GetParent().Health
	local self = Power:GetParent()
	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		Power:SetValue(0)
	end

	if Power.Text then
		Power.Text:SetTextColor(Power:GetStatusBarColor())
	end
end


-- Alternative power
local function postUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local perc = math.floor((cur/max)*100)
		if perc < 35 then
			element:SetStatusBarColor(0, 1, 0)
		elseif perc < 70 then
			element:SetStatusBarColor(1, 1, 0)
		else
			element:SetStatusBarColor(1, 0, 0)
		end
	end
end

local function CreateAltPower(self)
	local bar = CreateFrame("StatusBar", nil, self)
	bar:SetStatusBarTexture(C.media.texture)
	bar:SetPoint("BOTTOM", self, 0, -C.unitframes.altpower_height - 3)
	bar:SetSize(self:GetWidth(), C.unitframes.altpower_height)

	local abd = CreateFrame("Frame", nil, bar)
	abd:SetPoint("TOPLEFT", -1, 1)
	abd:SetPoint("BOTTOMRIGHT", 1, -1)
	abd:SetFrameLevel(bar:GetFrameLevel()-1)
	F.CreateBD(abd, .5)

	local text = F.CreateFS(bar, "CENTER")
	text:SetPoint("BOTTOM", self, "TOP", 0, 3)

	self:Tag(text, "[altpower]")

	SmoothBar(bar)

	bar:EnableMouse(true)

	self.AlternativePower = bar		
	self.AlternativePower.PostUpdate = postUpdateAltPower
end


-- Cast bar
local function CreateCastBar(self)
	local cb = CreateFrame("StatusBar", "oUF_Castbar"..self.unitStyle, self)
	cb:SetHeight(C.unitframes.cbHeight)
	cb:SetWidth(self:GetWidth())
	cb:SetAllPoints(self)
	cb:SetStatusBarTexture(C.media.texture)
	cb:SetStatusBarColor(0, 0, 0, 0)
	cb:SetFrameLevel(self.Health:GetFrameLevel() + 3)

	cb.CastingColor = C.unitframes.cbCastingColor
	cb.ChannelingColor = C.unitframes.cbChannelingColor
	cb.notInterruptibleColor = C.unitframes.cbnotInterruptibleColor
	cb.CompleteColor = C.unitframes.cbCompleteColor
	cb.FailColor = C.unitframes.cbFailColor

	local spark = cb:CreateTexture(nil, "OVERLAY")
	spark:SetBlendMode("ADD")
	spark:SetAlpha(.7)
	spark:SetHeight(cb:GetHeight()*2.5)
	cb.Spark = spark

	local name = F.CreateFS(cb)
	if C.client == 'zhCN' or C.client == 'zhTW' then
		name:SetFont(unpack(ufFont))
	else
		F.SetFS(name)
	end

	name:SetPoint("CENTER", self.Health)
	cb.Text = name
	name:SetAlpha(.5)

	local timer = F.CreateFS(cb)
	timer:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", 0, 6)
	cb.Time = timer
	timer:Hide()

	local iconFrame = CreateFrame("Frame", nil, cb)
	iconFrame:SetPoint("RIGHT", self, "LEFT", -4, 0)
	iconFrame:SetSize(self:GetHeight() + 6, self:GetHeight() + 6)

	F.CreateSD(iconFrame)

	local icon = iconFrame:CreateTexture(nil, "OVERLAY")
	icon:SetAllPoints(iconFrame)
	icon:SetTexCoord(unpack(C.texCoord))

	cb.Icon = icon

	local iconBG = iconFrame:CreateTexture(nil, "BACKGROUND")
	iconBG:SetPoint("TOPLEFT", -1 , 1)
	iconBG:SetPoint("BOTTOMRIGHT", 1, -1)
	iconBG:SetTexture(C.media.backdrop)
	iconBG:SetVertexColor(0, 0, 0)

	cb.iconBG = iconBG

	self.Castbar = cb

	if self.unitStyle == "player" then
		local safe = cb:CreateTexture(nil,"OVERLAY")
		safe:SetTexture(C.media.backdrop)
		safe:SetVertexColor(223/255, 63/255, 107/255, .6)
		safe:SetPoint("TOPRIGHT")
		safe:SetPoint("BOTTOMRIGHT")
		cb.SafeZone = safe
	end

	if self.unitStyle == "target" or self.unitStyle == "focus"
		or (C.unitframes.castbarSeparate and self.unitStyle == "player") then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint("RIGHT", cb, "LEFT", -4, 0)
		cb:ClearAllPoints()
		cb:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -30)

		name:ClearAllPoints()
		name:SetPoint("BOTTOM", cb, "TOP", 0, 4)
		name:SetAlpha(1)

		timer:Show()

		local bg = CreateFrame("Frame", nil, cb)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(cb:GetFrameLevel()-1)

		F.CreateBD(bg)
		F.CreateSD(bg)
		F.CreateTex(bg)
	end

	if self.unitStyle == "focus" then
		cb:SetWidth(self:GetWidth() * 2 + 5)
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint("RIGHT", cb, "LEFT", -4, 0)
		cb:ClearAllPoints()
		cb:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 30)
	end

	if self.unitStyle == "focustarget" then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint("LEFT", self, "RIGHT", 4, 0)
	elseif self.unitStyle == "target" or (self.unitStyle == "player" and not C.unitframes.castbarSeparate) then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint("LEFT", cb, "RIGHT", 4, 0)
	end

	if self.unitStyle == "focus" or self.unitStyle == "focustarget" or self.unitStyle == "targettarget" or self.unitStyle == "player" then
		name:Hide()
		timer:Hide()
	end

	cb.OnUpdate = cast.OnCastbarUpdate
	cb.PostCastStart = cast.PostCastStart
	cb.PostChannelStart = cast.PostCastStart
	cb.PostCastStop = cast.PostCastStop
	cb.PostChannelStop = cast.PostChannelStop
	cb.PostCastFailed = cast.PostCastFailed
	cb.PostCastInterrupted = cast.PostCastFailed
	cb.PostCastInterruptible = cast.PostUpdateInterruptible
	cb.PostCastNotInterruptible = cast.PostUpdateInterruptible
end


-- Auras
local function formatAuraTime(s)
	local day, hour, minute = 86400, 3600, 60

	if s >= day then
		return format('%d', floor(s/day + 0.5))
	elseif s >= hour then
		return format('%d', floor(s/hour + 0.5))
	elseif s >= minute then
		return format('%d', floor(s/minute + 0.5))
	end
	return format('%d', mod(s, minute))
end

local function UpdateAura(self, elapsed)
	if(self.expiration) then
		self.expiration = math.max(self.expiration - elapsed, 0)

		if(self.expiration > 0 and self.expiration < 30) then
			self.Duration:SetText(formatAuraTime(self.expiration))
			self.Duration:SetTextColor(1, 0, 0)
		elseif(self.expiration > 30 and self.expiration < 60) then
			self.Duration:SetText(formatAuraTime(self.expiration))
			self.Duration:SetTextColor(1, 1, 0)
		elseif(self.expiration > 60 and self.expiration < 300) then
			self.Duration:SetText(formatAuraTime(self.expiration))
			self.Duration:SetTextColor(1, 1, 1)
		else
			self.Duration:SetText()
		end
	end
end

local function OnAuraEnter(self)
	if(not self:IsVisible()) then
		return
	end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
	self:UpdateTooltip()
end

local function PostCreateIcon(element, button)
	local bg = button:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	local sd = CreateFrame("Frame", nil, button)
	sd:SetBackdrop({edgeFile = C.media.glowtex, edgeSize = 4})
	sd:SetPoint("TOPLEFT", -4, 4)
	sd:SetPoint("BOTTOMRIGHT", 4, -4)
	sd:SetBackdropBorderColor(0, 0, 0, .65)

	button.sd = sd
	button.bg = bg
	
	button.overlay:SetTexture(nil)
	button.stealable:SetTexture(nil)
	button.cd:SetReverse(true)
	button.icon:SetDrawLayer('ARTWORK')
	button:SetFrameLevel(element:GetFrameLevel() + 4)

	element.disableCooldown = true

	button.HL = button:CreateTexture(nil, "HIGHLIGHT")
	button.HL:SetColorTexture(1, 1, 1, .25)
	button.HL:SetAllPoints()

	button:SetScript('OnEnter', OnAuraEnter)

	local StringParent = CreateFrame('Frame', nil, button)
	StringParent:SetFrameLevel(button.cd:GetFrameLevel() + 1)

	button.count:SetParent(StringParent)
	button.count:ClearAllPoints()
	button.count:SetPoint('TOPRIGHT', button, 2, -2)
	F.SetFS(button.count)

	local Duration = StringParent:CreateFontString(nil, 'OVERLAY')
	Duration:SetParent(StringParent)
	Duration:ClearAllPoints()
	Duration:SetPoint('BOTTOM', button, 2, -6)
	Duration:SetFont("Interface\\AddOns\\FreeUI\\assets\\font\\supereffective.ttf", 16, "OUTLINEMONOCHROME")
	
	button.Duration = Duration

	if element.__owner.unitStyle == "group" or element.__owner.unitStyle == "pet" then
		Duration:Hide()
	end

	button:HookScript('OnUpdate', UpdateAura)
end

local function PostUpdateIcon(element, unit, button, index, _, duration, _, debuffType)
	local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)

	--button:SetSize(element.size, element.size*.75)
	--button.icon:SetTexCoord(.08, .92, .25, .85)

	if(duration and duration > 0) then
		button.expiration = expiration - GetTime()
	else
		button.expiration = math.huge
	end

	if canStealOrPurge then
		button.bg:SetVertexColor(1, 1, 1)
		button.sd:SetBackdropBorderColor(1, 1, 1, .65)
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.bg:SetVertexColor(color[1], color[2], color[3])
		button.sd:SetBackdropBorderColor(color[1], color[2], color[3], .65)
	else
		button.bg:SetVertexColor(0, 0, 0)
		button.sd:SetBackdropBorderColor(0, 0, 0, .65)
	end

	if duration then 
		button.sd:Show()
		button.bg:Show()
	end
end

local function FilterTargetDebuffs(_, unit, button, _, _, _, _, _, _, _, caster, _, _, spellID)
	if(button.isDebuff and not button.isPlayer) then
		return false
	end
	return true
end

local function groupDebuffFilter(_, _, _, _, _, _, _, _, _, caster, _, _, spellID)
	if C.hideDebuffs[spellID] then
		return false
	end
	return true
end

local function groupBuffFilter(_, unit, button, _, _, _, _, _, _, caster, _, _, spellID)
	if (button.isPlayer and C.myBuffs[spellID]) or C.allBuffs[spellID] then
		return true
	end
	return false
end

local function PostUpdateGapIcon(self, unit, icon, visibleBuffs)
	icon:Hide()
end

local function CreateAuras(self)
	local Auras = CreateFrame("Frame", nil, self)
	Auras["growth-x"] = "RIGHT"
	Auras['spacing-x'] = 4
	Auras['spacing-y'] = 0

	Auras:SetSize(self:GetWidth(), 100)

	Auras.gap = true
	Auras.showDebuffType = true
	Auras.showStealableBuffs = true

	if self.unitStyle == "pet" then
		Auras.initialAnchor = "TOPLEFT"
		Auras:SetPoint("TOP", self, "BOTTOM", 0, -4)
		Auras["growth-y"] = "DOWN"
		Auras.size = 20
		--Auras.disableCooldown = true
	elseif self.unitStyle == "target" then
		Auras.initialAnchor = "BOTTOMLEFT"
		Auras:SetPoint("BOTTOM", self, "TOP", 0, 24)
		Auras["growth-y"] = "UP"
		Auras.size = 32
		Auras:SetSize(self:GetWidth()-14, 100)

		if C.unitframes.castbyPlayer then
			Auras.CustomFilter = FilterTargetDebuffs
		end
	elseif self.unitStyle == "boss" then
		Auras.initialAnchor = "TOPLEFT"
		Auras:SetPoint("TOP", self, "BOTTOM", 0, -6)
		Auras["growth-y"] = "DOWN"
		Auras.size = 24

		Auras.CustomFilter = FilterTargetDebuffs
	end
	self.Auras = Auras

	Auras.PostCreateIcon = PostCreateIcon
	Auras.PostUpdateIcon = PostUpdateIcon
	Auras.PostUpdateGapIcon = PostUpdateGapIcon
end

local function CreateBuffs(self)
	local Buffs = CreateFrame("Frame", nil, self)
	Buffs.initialAnchor = "TOPLEFT"
	Buffs:SetPoint("TOP", self, "BOTTOM", 0, -4)
	Buffs["growth-x"] = "RIGHT"
	Buffs["growth-y"] = "DOWN"
	Buffs["spacing-x"] = 4
	Buffs["spacing-y"] = 0

	Buffs:SetSize(self:GetWidth()-10, 100)
	Buffs.size = 28

	Buffs.showStealableBuffs = true

	self.Buffs = Buffs
	Buffs.PostCreateIcon = PostCreateIcon
	Buffs.PostUpdateIcon = PostUpdateIcon
end

local function CreateDebuffs(self)
	local Debuffs = CreateFrame("Frame", nil, self)
	Debuffs.initialAnchor = "TOPLEFT"
	Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 0)
	Debuffs["growth-x"] = "RIGHT"
	Debuffs["growth-y"] = "DOWN"
	Debuffs["spacing-x"] = 4
	Debuffs["spacing-y"] = 0

	Debuffs:SetSize(124, 100)
	Debuffs.size = 28

	Debuffs.showStealableBuffs = true
	Debuffs.showDebuffType = true

	self.Debuffs = Debuffs
	Debuffs.PostCreateIcon = PostCreateIcon
	Debuffs.PostUpdateIcon = PostUpdateIcon
end


-- Portrait
local function PostUpdatePortrait(element, unit)
	element:SetDesaturation(1)
end


-- Class power
local function PostUpdateClassPower(element, cur, max, diff, powerType)
	if(diff) then
		for index = 1, max do
			local Bar = element[index]
			local maxWidth, gap = C.unitframes.player_width, 3
			if(max == 3) then
				Bar:SetWidth(((maxWidth / 3) - ((2 * gap) / 3)))
			elseif(max == 4) then
				Bar:SetWidth(((maxWidth /4) - ((3 * gap) / 4)))
			elseif(max == 5 or max == 10) then
				Bar:SetWidth(((maxWidth / 5) - ((4 * gap) / 5)))
			elseif(max == 6) then
				Bar:SetWidth(((maxWidth / 6) - ((5 * gap) / 6)))
			end

			if(index > 1) then
				Bar:ClearAllPoints()
				Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
			end

		end
	end
end

local function UpdateClassPowerColor(element)
	local _, playerClass = UnitClass('player')
	local r, g, b = 1, 1, 2/5
	if(not UnitHasVehicleUI('player')) then
		if(playerClass == 'MONK') then
			r, g, b = 0, 4/5, 3/5
		elseif(playerClass == 'WARLOCK') then
			r, g, b = 2/3, 1/3, 2/3
		elseif(playerClass == 'PALADIN') then
			r, g, b = 238/255, 220/255, 127/255
		elseif(playerClass == 'MAGE') then
			r, g, b = 5/6, 1/2, 5/6
		elseif(playerClass == 'ROGUE') then
			r, g, b = 221/255, 0, 55/255
		end
	end

	for index = 1, #element do
		local Bar = element[index]
		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetColorTexture(r * 1/3, g * 1/3, b * 1/3)
	end
end

local function CreateClassPower(self)
	if not C.unitframes.classPower then return end

	local ClassPower = {}
	ClassPower.UpdateColor = UpdateClassPowerColor
	ClassPower.PostUpdate = PostUpdateClassPower

	for index = 1, 11 do -- have to create an extra to force __max to be different from UnitPowerMax
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(C.unitframes.classPower_height)
		Bar:SetStatusBarTexture(C.media.texture)
		Bar:SetBackdropColor(0, 0, 0)

		F.CreateBDFrame(Bar)

		local function moveCPBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -C.unitframes.power_height - 4 -C.unitframes.altpower_height)
				else
					Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -C.unitframes.power_height - 2)
				end
			end
		end
		self.AlternativePower:HookScript("OnShow", moveCPBar)
		self.AlternativePower:HookScript("OnHide", moveCPBar)
		moveCPBar()

		local Background = Bar:CreateTexture(nil, 'BORDER')
		Background:SetAllPoints()
		Bar.bg = Background

		ClassPower[index] = Bar	
	end

	self.ClassPower = ClassPower
end


-- Runes bars
local function postUpdateRunes(element, runemap)
	for index, runeID in next, runemap do
		local spec = GetSpecialization() or 0
		local rune = element[index]
		local runeReady = select(3, GetRuneCooldown(runeID))
		if rune:IsShown() and not runeReady then
			rune:SetAlpha(.6)
		else
			rune:SetAlpha(1)
		end
		local color
		if spec == 1 then
			color = {151/255, 25/255, 0}
		elseif spec == 2 then
			color = {65/255, 133/255, 215/255}
		elseif spec == 3 then
			color = {98/255, 153/255, 51/255}
		end
		rune:SetStatusBarColor(color[1], color[2], color[3])
	end
end

local function CreateRunesBar(self)
	local Runes = CreateFrame("Frame", nil, self)
	Runes:SetWidth(C.unitframes.player_width)
	Runes:SetHeight(C.unitframes.classPower_height)

	local function moveCPBar()
		if self.AlternativePower:IsShown() then
			Runes:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -C.unitframes.classPower_height - 4 -C.unitframes.altpower_height - C.unitframes.classPower_height)
		else
			Runes:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -C.unitframes.classPower_height - 2 - C.unitframes.altpower_height)
		end
	end
	self.AlternativePower:HookScript("OnShow", moveCPBar)
	self.AlternativePower:HookScript("OnHide", moveCPBar)
	moveCPBar()

	for index = 1, 6 do
		local Rune = CreateFrame('StatusBar', nil, self)
		Rune:SetHeight(C.unitframes.classPower_height)
		Rune:SetStatusBarTexture(C.media.texture)

		F.CreateBDFrame(Rune)

		if(index == 1) then
			Rune:SetPoint("LEFT", Runes)
			Rune:SetWidth(C.unitframes.player_width/6)
		else
			Rune:SetPoint('LEFT', Runes[index - 1], 'RIGHT', 3, 0)
			Rune:SetWidth((C.unitframes.player_width/6)-3)
		end

		Runes[index] = Rune
	end
	--Runes.colorSpec = true -- use my own color palette
	Runes.sortOrder = "asc"

	self.Runes = Runes
	Runes.PostUpdate = postUpdateRunes
end


-- indicator
local function CreateIndicator(self)
	if self.unitStyle == "player" then
		local PvPIndicator = F.CreateFS(self)
		PvPIndicator:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", -50, 3)
		PvPIndicator:SetText("P")

		local UpdatePvPIndicator = function(self, event, unit)
			if(unit ~= self.unit) then return end

			local PvPIndicator = self.PvPIndicator

			local factionGroup = UnitFactionGroup(unit)
			--C_PvP.IsWarModeActive()
			if(UnitIsPVPFreeForAll(unit) or (factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit))) then
				if factionGroup == "Alliance" then
					PvPIndicator:SetTextColor(0, 0.68, 0.94)
				else
					PvPIndicator:SetTextColor(1, 0, 0)
				end

				PvPIndicator:Show()
			else
				PvPIndicator:Hide()
			end
		end

		self.PvPIndicator = PvPIndicator
		PvPIndicator.Override = UpdatePvPIndicator


		local statusIndicator = CreateFrame("Frame")
		local statusText = F.CreateFS(self.Health)
		statusText:SetPoint("LEFT", self.Health.value, "RIGHT", 10, 0)

		local function updateStatus()
			if UnitAffectingCombat("player") then
				statusText:SetText("!")
				statusText:SetTextColor(1, 0, 0)
			elseif IsResting() then
				statusText:SetText("Zzz")
				statusText:SetTextColor(.8, .8, .8)
			else
				statusText:SetText("")
			end
		end

		local function checkEvents()
			statusText:Show()
			statusIndicator:RegisterEvent("PLAYER_ENTERING_WORLD")
			statusIndicator:RegisterEvent("PLAYER_UPDATE_RESTING")
			statusIndicator:RegisterEvent("PLAYER_REGEN_ENABLED")
			statusIndicator:RegisterEvent("PLAYER_REGEN_DISABLED")

			updateStatus()
		end
		checkEvents()
		statusIndicator:SetScript("OnEvent", updateStatus)
	end

	if self.unitStyle == "target" then
		local QuestIndicator = F.CreateFS(self)
		QuestIndicator:SetText("!")
		QuestIndicator:SetTextColor(228/255, 225/255, 16/255)
		QuestIndicator:SetPoint("RIGHT", self.Name, "LEFT", -3, 0)

		self.QuestIndicator = QuestIndicator
	end

	local RaidTargetIndicator = self:CreateTexture()

	if self.unitStyle == "group" then
		RaidTargetIndicator:SetPoint("CENTER", self, "CENTER")
	elseif self.unitStyle == "targettarget" then
		RaidTargetIndicator:SetPoint("RIGHT", self, "LEFT", -3, 0)
	elseif self.unitStyle == "focus" then
		RaidTargetIndicator:SetPoint("RIGHT", self, "LEFT", -3, 0)
	elseif self.unitStyle == "focustarget" then
		RaidTargetIndicator:SetPoint("LEFT", self, "RIGHT", 3, 0)
	else
		RaidTargetIndicator:SetPoint("CENTER", self, "CENTER", 0, 20)
	end

	RaidTargetIndicator:SetSize(16, 16)
	self.RaidTargetIndicator = RaidTargetIndicator

	if self.unitStyle == "group" then
		local ResurrectIndicator = self:CreateTexture(nil, 'OVERLAY')
		ResurrectIndicator:SetSize(16, 16)
		ResurrectIndicator:SetPoint('CENTER')
		self.ResurrectIndicator = ResurrectIndicator

		local LeaderIndicator = F.CreateFS(self, "LEFT")
		LeaderIndicator:SetText("l")
		LeaderIndicator:SetPoint("TOPLEFT", self.Health, 2, -1)
		self.LeaderIndicator = LeaderIndicator

		local ReadyCheckIndicator = self:CreateTexture(nil, "OVERLAY")
		ReadyCheckIndicator:SetPoint("TOPLEFT", self.Health)
		ReadyCheckIndicator:SetSize(16, 16)
		self.ReadyCheckIndicator = ReadyCheckIndicator

		local UpdateLFD = function(self, event)
			local lfdrole = self.GroupRoleIndicator
			local role = UnitGroupRolesAssigned(self.unit)

			if role == "DAMAGER" then
				lfdrole:SetTextColor(1, .1, .1, 1)
				lfdrole:SetText(".")
			elseif role == "TANK" then
				lfdrole:SetTextColor(.3, .4, 1, 1)
				lfdrole:SetText("x")
			elseif role == "HEALER" then
				lfdrole:SetTextColor(0, 1, 0, 1)
				lfdrole:SetText("+")
			else
				lfdrole:SetTextColor(0, 0, 0, 0)
			end
		end

		local GroupRoleIndicator = F.CreateFS(self, "CENTER")
		GroupRoleIndicator:SetPoint("BOTTOM", self.Health, 1, 1)
		GroupRoleIndicator.Override = UpdateLFD

		self.GroupRoleIndicator = GroupRoleIndicator

		-- phase indicator
		local PhaseIndicator = F.CreateFS(self)
		PhaseIndicator:SetText("p")
		PhaseIndicator:SetTextColor(1, 1, 1, 1)
		PhaseIndicator:SetPoint('TOPRIGHT', self.Health, -2, -1)

		self.PhaseIndicator = PhaseIndicator
	end
end

-- name
local function CreateName(self)
	local Name = F.CreateFS(self)
	Name:SetPoint("BOTTOM", self, "TOP", 0, 3)
	Name:SetWordWrap(false)
	Name:SetJustifyH("CENTER")
	Name:SetFont(unpack(ufFont))
	Name:SetShadowColor(0, 0, 0, 1)
	Name:SetShadowOffset(2, -2)
	Name:SetTextColor(1, 1, 1)
	Name:SetWidth(self:GetWidth())
	self:Tag(Name, '[name]')
	self.Name = Name

	if self.unitStyle == "target" then
		Name:ClearAllPoints()
		Name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		Name:SetJustifyH("RIGHT")
		Name:SetWidth(100)
	elseif self.unitStyle == "boss" then
		Name:ClearAllPoints()
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
		Name:SetJustifyH("LEFT")
	elseif self.unitStyle == "arena" then
		Name:ClearAllPoints()
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		Name:SetJustifyH("LEFT")
		Name:SetWidth(100)
	end
end

local function UpdateTOTName(self)
	local f = CreateFrame("Frame", nil, self)

	local tt = F.CreateFS(f)
	tt:SetPoint("BOTTOM", self, "TOP", 0, 3)
	tt:SetJustifyH("CENTER")
	tt:SetFont(unpack(ufFont))
	tt:SetWordWrap(false)
	tt:SetWidth(C.unitframes.targettarget_width)

	f:RegisterEvent("UNIT_TARGET")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")

	f:SetScript("OnEvent", function()
		if(UnitName("targettarget")==UnitName("player")) then
			tt:SetText("> YOU <")
			tt:SetTextColor(1, 0, 0)
		else
			tt:SetText(UnitName"targettarget")
			tt:SetTextColor(1, 1, 1)
		end
	end)
end

local function UpdateTOFName(self)
	local f = CreateFrame("Frame", nil, self)

	local ft = F.CreateFS(f)
	ft:SetPoint("BOTTOM", self, "TOP", 0, 3)
	ft:SetFont(unpack(ufFont))
	ft:SetJustifyH"CENTER"
	ft:SetWordWrap(false)
	ft:SetWidth(C.unitframes.focustarget_width)

	f:RegisterEvent("UNIT_TARGET")
	f:RegisterEvent("PLAYER_FOCUS_CHANGED")

	f:SetScript("OnEvent", function()
		if(UnitName("focustarget")==UnitName("player")) then
			ft:SetText("> YOU <")
			ft:SetTextColor(1, 0, 0)
		else
			ft:SetText(UnitName"focustarget")
			ft:SetTextColor(1, 1, 1)
		end
	end)
end


-- Hide Blizz frames
F.HideObject(CompactRaidFrameContainer)
F.HideObject(CompactRaidFrameManager)
RaidOptionsFrame_UpdatePartyFrames = F.dummy

-- Global
local Shared = function(self, unit, isSingle)
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameStrata("BACKGROUND")
	self.bd = bd

	local sd = CreateFrame("Frame", nil, bd)
	sd:SetBackdrop({edgeFile = C.media.glowtex, edgeSize = 4})
	sd:SetPoint("TOPLEFT", -4, 4)
	sd:SetPoint("BOTTOMRIGHT", 4, -4)
	sd:SetBackdropBorderColor(0, 0, 0, .35)
	self.sd = sd


	--[[ Health ]]

	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetFrameStrata("LOW")
	Health:SetStatusBarTexture(C.media.backdrop)
	Health:SetStatusBarColor(0, 0, 0, 0)

	Health.frequentUpdates = true
	SmoothBar(Health)

	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")
	Health:SetPoint("BOTTOM", 0, 1 + C.unitframes.power_height)

	self.Health = Health
	Health.PostUpdate = PostUpdateHealth

	--[[ Gradient ]]

	if C.unitframes.transMode then
		local gradient = Health:CreateTexture(nil, "BACKGROUND")
		gradient:SetPoint("TOPLEFT")
		gradient:SetPoint("BOTTOMRIGHT")
		gradient:SetTexture(C.media.backdrop)

		if C.unitframes.gradient then
			gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
		else
			gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .3, .3, .3, .6)
		end

		self.gradient = gradient

		F.CreateBD(bd, C.unitframes.transModeAlpha)
	else
		F.CreateBD(bd)
	end

	--[[ Health deficit colour ]]

	if C.unitframes.transMode then
		local Healthdef = CreateFrame("StatusBar", nil, self)
		--Healthdef:SetFrameStrata("LOW")
		Healthdef:SetFrameLevel(Health:GetFrameLevel())
		Healthdef:SetAllPoints(Health)
		Healthdef:SetStatusBarTexture(C.media.texture)
		Healthdef:SetStatusBarColor(1, 1, 1)
		--Healthdef:SetAlpha(.6)

		Healthdef:SetReverseFill(true)
		SmoothBar(Healthdef)

		self.Healthdef = Healthdef
	end


	--[[ Power ]]

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(C.media.texture)

	Power.frequentUpdates = true
	SmoothBar(Power)

	Power:SetHeight(C.unitframes.power_height)

	Power:SetPoint("LEFT")
	Power:SetPoint("RIGHT")
	Power:SetPoint("TOP", Health, "BOTTOM", 0, -1)

	self.Power = Power

	local Powertex = Power:CreateTexture(nil, "OVERLAY")
	Powertex:SetHeight(1)
	Powertex:SetPoint("TOPLEFT", 0, 1)
	Powertex:SetPoint("TOPRIGHT", 0, 1)
	Powertex:SetTexture(C.media.backdrop)
	Powertex:SetVertexColor(0, 0, 0)

	Power.bg = Power:CreateTexture(nil, "BACKGROUND")
	Power.bg:SetHeight(C.unitframes.power_height)
	Power.bg:SetPoint("LEFT")
	Power.bg:SetPoint("RIGHT")
	Power.bg:SetTexture(C.media.backdrop)
	Power.bg:SetVertexColor(0, 0, 0, .1)

	Power.colorReaction = true

	if C.unitframes.transMode then
		if unit == "player" and C.unitframes.powerTypeColor then
			Power.colorPower = true
		else
			Power.colorClass = true
		end
	else
		Power.colorPower = true
	end

	Power.PostUpdate = PostUpdatePower

	--[[ Portrait ]]

	if C.unitframes.portrait and (unit == 'player' or unit == 'pet' or unit == 'target' or unit == 'vehicle' or unit:find("boss%d")) then
		local Portrait = CreateFrame('PlayerModel', nil, self)
		Portrait:SetAllPoints(Health)
		Portrait:SetFrameLevel(Health:GetFrameLevel() + 2)
		Portrait:SetAlpha(C.unitframes.portraitAlpha)
		Portrait.PostUpdate = PostUpdatePortrait
		self.Portrait = Portrait
	end
	
	-- [[ Heal prediction ]]

	local mhpb = self:CreateTexture()
	mhpb:SetTexture(C.media.texture)
	mhpb:SetVertexColor(0, .5, 1)

	local ohpb = self:CreateTexture()
	ohpb:SetTexture(C.media.texture)
	ohpb:SetVertexColor(.5, 0, 1)

	self.HealPrediction = {
		-- status bar to show my incoming heals
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
		frequentUpdates = true,
	}

	if C.unitframes.absorb then
		local absorbBar = self:CreateTexture()
		absorbBar:SetTexture(C.media.texture)
		absorbBar:SetVertexColor(.8, .34, .8)

		local overAbsorbGlow = self:CreateTexture(nil, "OVERLAY")
		overAbsorbGlow:SetWidth(16)
		overAbsorbGlow:SetBlendMode("ADD")
		overAbsorbGlow:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -7, 0)
		overAbsorbGlow:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -7, 0)

		self.HealPrediction["absorbBar"] = absorbBar
		self.HealPrediction["overAbsorbGlow"] = overAbsorbGlow
	end

	-- [[ Counter bar ]]

	if unit == "player" or unit == "pet" then
		local CounterBar = CreateFrame("StatusBar", nil, self)
		CounterBar:SetWidth(200)
		CounterBar:SetHeight(16)
		CounterBar:SetStatusBarTexture(C.media.texture)
		CounterBar:SetPoint("TOP", UIParent, "TOP", 0, -100)

		local cbd = CreateFrame("Frame", nil, CounterBar)
		cbd:SetPoint("TOPLEFT", -1, 1)
		cbd:SetPoint("BOTTOMRIGHT", 1, -1)
		cbd:SetFrameLevel(CounterBar:GetFrameLevel()-1)
		F.CreateBD(cbd, .4)
		F.CreateSD(cbd)

		CounterBar.Text = F.CreateFS(CounterBar)
		CounterBar.Text:SetPoint("CENTER")

		local r, g, b
		local max

		CounterBar:SetScript("OnValueChanged", function(_, value)
			_, max = CounterBar:GetMinMaxValues()
			r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))
			CounterBar:SetStatusBarColor(r, g, b)

			CounterBar.Text:SetText(floor(value))
		end)

		self.CounterBar = CounterBar
	end


	-- [[ Spell Range ]]

	if unit == "target" or unit == "targettarget"
		or unit == "foucs" or unit == "foucstarget"
		or unit:find("boss%d") or unit:find("arena%d") then
		self.SpellRange = {
			insideAlpha = 1,
			outsideAlpha = C.unitframes.outRangeAlpha
		}
	end


	--[[ Set up the layout ]]

	self.colors = colors

	self.disallowVehicleSwap = true

	if(isSingle) then
		if unit == "player" then
			self:SetSize(C.unitframes.player_width, C.unitframes.player_height)
		elseif unit == "target" then
			self:SetSize(C.unitframes.target_width, C.unitframes.target_height)
		elseif unit == "targettarget" then
			self:SetSize(C.unitframes.targettarget_width, C.unitframes.targettarget_height)
		elseif unit:find("arena%d") then
			self:SetSize(C.unitframes.arena_width, C.unitframes.arena_height)
		elseif unit == "focus" then
			self:SetSize(C.unitframes.focus_width, C.unitframes.focus_height)
		elseif unit == "focustarget" then
			self:SetSize(C.unitframes.focus_width, C.unitframes.focus_height)
		elseif unit == "pet" then
			self:SetSize(C.unitframes.pet_width, C.unitframes.pet_height)
		elseif unit and unit:find("boss%d") then
			self:SetSize(C.unitframes.boss_width, C.unitframes.boss_height)
		end
	end

end


-- Unit specific functions
local UnitSpecific = {
	pet = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "pet"

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.pet_height - C.unitframes.power_height - 1)

		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self)
	end,

	player = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "player"

		--self.bd.Shadow:SetBackdropBorderColor(1, 0, 0, .65)

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.player_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, "LEFT")
		HealthPoints:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 3)
		self:Tag(HealthPoints, '[dead][offline][free:playerHealth]')
		Health.value = HealthPoints

		local PowerText = F.CreateFS(Power, "RIGHT")
		PowerText:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", 0, 3)
		self:Tag(PowerText, '[free:power]')
		Power.Text = PowerText

		CreateAltPower(self)
		CreateIndicator(self)
		
		if C.myClass == "DEATHKNIGHT" then
			CreateRunesBar(self)
		else
			CreateClassPower(self)
		end

		CreateCastBar(self)

		FreeUI_LeaveVehicleButton:SetPoint("LEFT", self, "RIGHT", 5, 0)
	end,

	target = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "target"

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.target_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, "LEFT")
		HealthPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		self:Tag(HealthPoints, '[dead][offline][free:health]')
		Health.value = HealthPoints

		local PowerText = F.CreateFS(Power)
		PowerText:SetPoint("BOTTOMLEFT", HealthPoints, "BOTTOMRIGHT", 3, 0)
		if powerType ~= 0 then PowerText.frequentUpdates = .1 end
		self:Tag(PowerText, '[free:power]')

		local Classification = F.CreateFS(self)
		Classification:SetPoint("BOTTOMLEFT", PowerText, "BOTTOMRIGHT", 3, 0)
		self:Tag(Classification, '[free:classification]')

		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self)
	end,

	targettarget = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "targettarget"

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.targettarget_height - C.unitframes.power_height - 1)

		UpdateTOTName(self)
		CreateIndicator(self)
		CreateCastBar(self)
	end,

	focus = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "focus"

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.focus_height - C.unitframes.power_height - 1)

		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
	end,

	focustarget = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "focustarget"

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.focustarget_height - C.unitframes.power_height - 1)

		UpdateTOFName(self)
		CreateIndicator(self)
		CreateCastBar(self)
	end,


	boss = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "boss"

		local Health = self.Health
		local Power = self.Power

		self:SetAttribute('initial-height', bossHeight)
		self:SetAttribute('initial-width', bossWidth)

		Health:SetHeight(C.unitframes.boss_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, "RIGHT")
		HealthPoints:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 4)
		self:Tag(HealthPoints, '[dead][free:bosshealth]')

		Health.value = HealthPoints

		CreateName(self)
		CreateAltPower(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self)

		local select = CreateFrame("Frame", nil, self)
		select:RegisterEvent("PLAYER_TARGET_CHANGED")
		select:SetScript("OnEvent", updateBorderColourAlt)
	end,

	arena = function(self, ...)
		if not C.unitframes.enableArena then return end

		Shared(self, ...)
		self.unitStyle = "arena"

		local Health = self.Health
		local Power = self.Power

		self:SetAttribute('initial-height', arenaHeight)
		self:SetAttribute('initial-width', arenaWidth)

		Health:SetHeight(C.unitframes.arena_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, "RIGHT")
		HealthPoints:SetPoint("RIGHT", self, "TOPRIGHT", 0, 6)
		self:Tag(HealthPoints, '[dead][offline][free:health]')

		Health.value = HealthPoints

		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateBuffs(self)
		CreateDebuffs(self)
	end,
}

do
	UnitSpecific.party = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "group"

		self.disallowVehicleSwap = false

		local Health, Power = self.Health, self.Power

		local Text = F.CreateFS(Health, "CENTER")
		Text:SetPoint("CENTER", 1, 0)

		self.Text = Text

		self:Tag(Text, '[dead][offline]')

		Health:SetHeight(C.unitframes.party_height - C.unitframes.power_height - 1)
		if C.unitframes.partyNameAlways then
			Text:SetFont(unpack(ufFont))
			self:Tag(Text, '[free:name]')
		elseif C.unitframes.partyMissingHealth then
			self:Tag(Text, '[free:missinghealth]')
		else
			self:Tag(Text, '[dead][offline]')
		end

		CreateIndicator(self)


		local Debuffs = CreateFrame("Frame", nil, self)
		Debuffs.initialAnchor = "CENTER"
		Debuffs:SetPoint("BOTTOM", 0, C.unitframes.power_height - 1)
		Debuffs["growth-x"] = "RIGHT"
		Debuffs["spacing-x"] = 4

		Debuffs:SetHeight(16)
		Debuffs:SetWidth(37)
		Debuffs.num = 2
		Debuffs.size = 16

		Debuffs.showDebuffType = true
		Debuffs.showStealableBuffs = true
		Debuffs.disableCooldown = true
		Debuffs.disableMouse = true

		self.Debuffs = Debuffs

		

		Debuffs.PostUpdate = function(icons)
			local vb = icons.visibleDebuffs

			if vb == 2 then
				Debuffs:SetPoint("BOTTOM", -9, 0)
			else
				Debuffs:SetPoint("BOTTOM")
			end
		end

		Debuffs.PostCreateIcon = PostCreateIcon
		Debuffs.PostUpdateIcon = PostUpdateIcon
		Debuffs.CustomFilter = groupDebuffFilter


		local Buffs = CreateFrame("Frame", nil, self)
		Buffs.initialAnchor = "CENTER"
		Buffs:SetPoint("TOP", 0, -2)
		Buffs["growth-x"] = "RIGHT"
		Buffs["spacing-x"] = 3

		Buffs:SetSize(43, 12)
		Buffs.num = 3
		Buffs.size = 12

		Buffs.showStealableBuffs = true
		Buffs.disableCooldown = true
		Buffs.disableMouse = true

		self.Buffs = Buffs



		Buffs.PostUpdate = function(icons)
			local vb = icons.visibleBuffs

			if vb == 3 then
				Buffs:SetPoint("TOP", -15, -2)
			elseif vb == 2 then
				Buffs:SetPoint("TOP", -7, -2)
			else
				Buffs:SetPoint("TOP", 0, -2)
			end
		end

		Buffs.PostCreateIcon = PostCreateIcon
		Buffs.PostUpdateIcon = PostUpdateIcon
		Buffs.CustomFilter = groupBuffFilter


		local select = CreateFrame("Frame", nil, self)
		select:RegisterEvent("PLAYER_TARGET_CHANGED")
		select:SetScript("OnEvent", updateNameColourAlt)

		self.Range = {
			insideAlpha = 1, outsideAlpha = C.unitframes.outRangeAlpha,
		}
	end
end


-- Register and activate style
oUF:RegisterStyle("Free", Shared)
for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle('Free - ' .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Free - ' .. unit:gsub("^%l", string.upper))
	elseif(UnitSpecific[unit:match('[^%d]+')]) then -- boss1 -> boss
		self:SetActiveStyle('Free - ' .. unit:match('[^%d]+'):gsub("^%l", string.upper))
	else
		self:SetActiveStyle'Free'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end

local function round(x)
	return floor(x + .5)
end

oUF:Factory(function(self)
	local partyPos, raidPos
	local player, target, focus, targettarget, focustarget, pet

	player = spawnHelper(self, 'player', unpack(C.unitframes.player))

	pet = spawnHelper(self, 'pet', unpack(C.unitframes.pet))

	if C.unitframes.frameVisibility then
		player:Disable()
		player.frameVisibility = C.unitframes.frameVisibility_player
		RegisterStateDriver(player, "visibility", C.unitframes.frameVisibility_player)

		pet:Disable()
		pet.frameVisibility = C.unitframes.frameVisibility_pet
		RegisterStateDriver(pet, "visibility", C.unitframes.frameVisibility_pet)
	end

	target = spawnHelper(self, 'target', unpack(C.unitframes.target))
	targettarget = spawnHelper(self, 'targettarget', unpack(C.unitframes.targettarget))
	focus = spawnHelper(self, 'focus', unpack(C.unitframes.focus))
	focustarget = spawnHelper(self, 'focustarget', unpack(C.unitframes.focustarget))

	for n = 1, MAX_BOSS_FRAMES do
		spawnHelper(self, 'boss' .. n, C.unitframes.boss.a, C.unitframes.boss.b, C.unitframes.boss.c, C.unitframes.boss.x, C.unitframes.boss.y + (80 * n))
	end

	if C.unitframes.enableArena then
		for n = 1, 5 do
			spawnHelper(self, 'arena' .. n, C.unitframes.arena.a, C.unitframes.arena.b, C.unitframes.arena.c, C.unitframes.arena.x, C.unitframes.arena.y + (100 * n))
		end
	end

	if not C.unitframes.enableGroup then return end

	self:SetActiveStyle'Free - Party'

	local party = self:SpawnHeader(nil, nil, "party",
		'showParty', true,
		'showPlayer', true,
		'showSolo', false,
		'xoffset', -3,
		'yoffset', 5,
		'maxColumns', 1,
		'unitsperColumn', 5,
		'columnSpacing', 3,
		'point', "RIGHT", -- party initial position
		'columnAnchorPoint', "LEFT",
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(C.unitframes.party_height, C.unitframes.party_width)
	)

	party:SetPoint(unpack(C.unitframes.party))

	local raid = self:SpawnHeader(nil, nil, "raid",
		'showParty', false,
		'showRaid', true,
		'xoffset', -3,
		'yOffset', -3,
		'point', "RIGHT",
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 3,
		'columnAnchorPoint', "TOP",
		"sortMethod", "INDEX",
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(C.unitframes.raid_height, C.unitframes.raid_width)
	)

	raid:SetPoint(unpack(C.unitframes.raid))

	-- 限制团队框体只显示4个队伍20名成员
	if C.unitframes.limitRaidSize then
		raid:SetAttribute("groupFilter", "1,2,3,4")
	end
	--[[F.AddOptionsCallback("unitframes", "limitRaidSize", function()
		if C.unitframes.limitRaidSize then
			raid:SetAttribute("groupFilter", "1,2,3,4")
		else
			raid:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
		end
	end)



	local mapList = {
		[30] = true,

	}
	local instID = select(8, GetInstanceInfo())
	if mapList[instID] then
		--raid:SetAttribute("groupFilter", "1,2,3,4")
		raid:SetAttribute("showRaid", false)
	end]]

	--[[local raidToParty = CreateFrame("Frame")

	local function togglePartyAndRaid(event)
		if InCombatLockdown() then
			raidToParty:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		elseif (event and event == "PLAYER_REGEN_ENABLED") then
			raidToParty:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end

		local numGroup = GetNumGroupMembers()

		if numGroup > 5 then
			party:SetAttribute("showParty", false)
			party:SetAttribute("showRaid", false)
			raid:SetAttribute("showRaid", true)
		else
			raid:SetAttribute("showRaid", false)
			-- if in a party, or in a raid where everyone is in one party (subgroup), show party
			-- if in a raid where people are spread across subgroups, show raid
			if GetNumSubgroupMembers() + 1 < numGroup then
				party:SetAttribute("showParty", false)
				party:SetAttribute("showRaid", true)
			else
				party:SetAttribute("showParty", true)
				party:SetAttribute("showRaid", false)
			end
		end
	end

	raidToParty:SetScript("OnEvent", togglePartyAndRaid)

	local function checkShowRaidFrames()
		if C.unitframes.showRaidFrames then
			raidToParty:RegisterEvent("PLAYER_ENTERING_WORLD")
			raidToParty:RegisterEvent("GROUP_ROSTER_UPDATE")

			togglePartyAndRaid()
		else
			raidToParty:UnregisterEvent("PLAYER_ENTERING_WORLD")
			raidToParty:UnregisterEvent("GROUP_ROSTER_UPDATE")

			party:SetAttribute("showParty", false)
			party:SetAttribute("showRaid", false)
			raid:SetAttribute("showRaid", false)
		end
	end

	checkShowRaidFrames()
	F.AddOptionsCallback("unitframes", "showRaidFrames", checkShowRaidFrames)]]
end)
