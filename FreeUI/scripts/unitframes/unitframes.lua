local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("unitframe")
if not C.unitframes.enable then return end

local _, ns = ...
local oUF = ns.oUF
local cast = ns.cast

oUF.colors.power.MANA = {100/255, 149/255, 237/255}
oUF.colors.power.ENERGY = {1, 222/255, 80/255}
oUF.colors.power.FURY = { 54/255, 199/255, 63/255 }
oUF.colors.power.PAIN = { 255/255, 156/255, 0 }

oUF.colors.debuffType = {
	Curse = {.8, 0, 1},
	Disease = {.8, .6, 0},
	Magic = {0, .8, 1},
	Poison = {0, .8, 0},
	none = {0, 0, 0}
}

local function CreateHeader(self)
	local hl = self:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints()
	hl:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	hl:SetTexCoord(0, 1, .5, 1)
	hl:SetVertexColor(.6, .6, .6)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl

	self:RegisterForClicks("AnyUp")
	self:HookScript("OnEnter", function()
		UnitFrame_OnEnter(self)
		self.Highlight:Show()
	end)
	self:HookScript("OnLeave", function()
		UnitFrame_OnLeave(self)
		self.Highlight:Hide()
	end)
end

-- Update selected name colour
local updateNameColour = function(self, unit)
	if UnitIsUnit(unit, "target") then
		self.Name:SetTextColor(.1, .7, 1)
	elseif UnitIsDead(unit) then
		self.Name:SetTextColor(.7, .2, .1)
	else
		self.Name:SetTextColor(1, 1, 1)
	end
end

-- to use on child frame
local updateSelectedBorder = function(self, unit)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, "target") then
			frame.Name:SetTextColor(.1, .7, 1)

			if frame.unitStyle == "boss" then
				frame.bd:SetBackdropBorderColor(1, 1, 1)

				if frame.sd then
					frame.sd:SetBackdropBorderColor(1, 1, 1, .45)
				end
			else
				frame.bd:SetBackdropBorderColor(1, 1, 1)

				--if frame.sd then
				--	frame.sd:SetBackdropBorderColor(1, 1, 1, .45)
				--end
			end
		elseif UnitIsDead(frame.unit) then
			frame.Name:SetTextColor(.7, .2, .1)
			frame.bd:SetBackdropBorderColor(0, 0, 0)

			if frame.sd then
				frame.sd:SetBackdropBorderColor(0, 0, 0, .35)
			end
		else
			frame.Name:SetTextColor(1, 1, 1)
			frame.bd:SetBackdropBorderColor(0, 0, 0)

			--if frame.sd then
			--	frame.sd:SetBackdropBorderColor(0, 0, 0, .35)
			--end
		end
	else
		frame.bd:SetBackdropBorderColor(0, 0, 0)

		if frame.sd then
			frame.sd:SetBackdropBorderColor(0, 0, 0, .35)
		end
	end
end

local function CreateSelectedBorder(self)
	local select = CreateFrame("Frame", nil, self)
	select:RegisterEvent("PLAYER_TARGET_CHANGED")
	select:SetScript("OnEvent", updateSelectedBorder)
end


-- Update health
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

			if C.unitframes.healthClassColor then
				if UnitIsPlayer(unit) then
					self.Healthdef:GetStatusBarTexture():SetVertexColor(r, g, b)
				else
					self.Healthdef:GetStatusBarTexture():SetVertexColor(unpack(reaction))
				end
			else
				self.Healthdef:GetStatusBarTexture():SetVertexColor(self.ColorGradient(min, max, unpack(self.colors.smooth)))
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

		--if self.Name then
		--	updateNameColour(self, unit)
		--end
	else
		if UnitIsDead(unit) or UnitIsGhost(unit) then
			Health:SetValue(0)
		end

		if C.unitframes.gradient then
			Health:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/2, g/2, b/2)
		else
			Health:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r, g, b)
		end
	end
end


-- Update power
local PostUpdatePower = function(Power, unit, cur, max, min)
	local Health = Power:GetParent().Health
	local self = Power:GetParent()
	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		Power:SetValue(0)
	end

	if Power.Text then
		Power.Text:SetTextColor(Power:GetStatusBarColor())
	end

	if C.myClass == 'DEMONHUNTER' and C.unitframes.classMod_havoc and self.unitStyle == 'player' then
		local spec = GetSpecialization() or 0
		local cp = UnitPower(unit)
		if spec == 1 then
			if cp < 40 then
				Power:SetStatusBarColor(1, 0, 0)
			end
		end
	end
end


-- Update alternative power
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

	local text = F.CreateFS(bar, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	text:SetJustifyH('CENTER')
	text:SetPoint("BOTTOM", self, "TOP", 0, 3)

	self:Tag(text, "[altpower]")

	F.SmoothBar(bar)

	bar:EnableMouse(true)

	self.AlternativePower = bar		
	self.AlternativePower.PostUpdate = postUpdateAltPower
end


-- Create cast bar
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

	local name

	if C.appearance.usePixelFont then
		name = F.CreateFS(cb, C.font.pixel[1], C.font.pixel[2], C.font.pixel[3], {1, 1, 1}, {0, 0, 0}, 1, -1)
	elseif C.client == 'zhCN' or C.client == 'zhTW' then
		name = F.CreateFS(cb, C.font.normal, 12, nil, {1, 1, 1}, {0, 0, 0}, 2, -2)
	else
		name = F.CreateFS(cb, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1, 1, 1}, {0, 0, 0}, 1, -1)
	end

	name:SetPoint("CENTER", self.Health)
	cb.Text = name
	name:Hide()

	local timer = F.CreateFS(cb, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	timer:SetPoint("BOTTOMRIGHT", cb, "TOPRIGHT", 0, 6)
	cb.Time = timer
	timer:Hide()

	local iconFrame = CreateFrame("Frame", nil, cb)
	iconFrame:SetPoint('LEFT', self, 'RIGHT', 4, 0)
	iconFrame:SetSize(self:GetHeight() + 4, self:GetHeight() + 4)

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

		name:ClearAllPoints()
		name:SetPoint("BOTTOM", cb, "TOP", 0, 4)

		if C.unitframes.cbName then
			name:Show()
		end
		if C.unitframes.cbTimer then
			timer:Show()
		end

		local bg = CreateFrame("Frame", nil, cb)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(cb:GetFrameLevel()-1)

		F.CreateBD(bg)
		F.CreateSD(bg)
		F.CreateTex(bg)
	end

	if (self.unitStyle == "player" and C.unitframes.castbarSeparate) then
		cb:ClearAllPoints()
		cb:SetPoint('TOP', self, 'BOTTOM', 0, -40)
	elseif self.unitStyle == "player" then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', self, 'RIGHT', 4, 0)
	elseif self.unitStyle == "target" then
		cb:ClearAllPoints()
		cb:SetPoint('TOP', self, 'BOTTOM', 0, -40)
	elseif self.unitStyle == "focus" then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint("RIGHT", cb, "LEFT", -4, 0)
		cb:SetWidth(self:GetWidth() * 2 + 5)
		cb:ClearAllPoints()
		cb:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -80)
	elseif self.unitStyle == "targettarget" or self.unitStyle == "focustarget" then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint("LEFT", self, "RIGHT", 4, 0)
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
	button.bg = bg

	if C.appearance.shadow then
		local sd = CreateFrame("Frame", nil, button)
		sd:SetBackdrop({edgeFile = C.media.glowtex, edgeSize = 4})
		sd:SetPoint("TOPLEFT", -4, 4)
		sd:SetPoint("BOTTOMRIGHT", 4, -4)
		sd:SetBackdropBorderColor(0, 0, 0, .65)
		button.sd = sd
	end
	
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
	button.count:SetPoint('TOPRIGHT', button, 2, 4)
	F.SetFS(button.count)

	local Duration = StringParent:CreateFontString(nil, 'OVERLAY')
	Duration:SetParent(StringParent)
	Duration:ClearAllPoints()
	Duration:SetPoint('BOTTOMLEFT', button, 2, -4)
	Duration:SetFont(C.media.pixel, 8, 'OUTLINEMONOCHROME')
	
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

		if button.sd then
			button.sd:SetBackdropBorderColor(1, 1, 1, .65)
		end
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.bg:SetVertexColor(color[1], color[2], color[3])

		if button.sd then
			button.sd:SetBackdropBorderColor(color[1], color[2], color[3], .65)
		end
	else
		button.bg:SetVertexColor(0, 0, 0)

		if button.sd then
			button.sd:SetBackdropBorderColor(0, 0, 0, .65)
		end
	end

	if duration then
		button.bg:Show()

		if button.sd then
			button.sd:Show()
		end
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
		Auras.size = 28
		Auras:SetSize(self:GetWidth(), 100)

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
	Buffs:SetPoint("TOP", self, "BOTTOM", 0, -6)
	Buffs["growth-x"] = "RIGHT"
	Buffs["growth-y"] = "DOWN"
	Buffs["spacing-x"] = 4
	Buffs["spacing-y"] = 0

	Buffs:SetSize(self:GetWidth(), 100)
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

	Debuffs:SetSize(self:GetWidth(), 100)
	Debuffs.size = 28

	Debuffs.showStealableBuffs = true
	Debuffs.showDebuffType = true

	if self.unitStyle == "targettarget" or self.unitStyle == "focus" or self.unitStyle == "focustarget" then
		Debuffs:ClearAllPoints()
		Debuffs:SetPoint("TOP", self, "BOTTOM", 0, -6)
		Debuffs.size = 22
		Debuffs.num = 4
	end

	Debuffs.PostCreateIcon = PostCreateIcon
	Debuffs.PostUpdateIcon = PostUpdateIcon

	self.Debuffs = Debuffs
end


-- Portrait
local function PostUpdatePortrait(element, unit)
	element:SetDesaturation(1)
end

local function CreatePortrait(self)
	if not C.unitframes.portrait then return end

	local Portrait = CreateFrame('PlayerModel', nil, self)
	Portrait:SetAllPoints(self.Health)
	Portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	Portrait:SetAlpha(C.unitframes.portraitAlpha)
	Portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = Portrait
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
		local PvPIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0,0,0}, 1, -1)
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
		local statusText = F.CreateFS(self.Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
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
		local QuestIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		QuestIndicator:SetText("!")
		QuestIndicator:SetTextColor(228/255, 225/255, 16/255)
		QuestIndicator:SetPoint("RIGHT", self.Name, "LEFT", -3, 0)

		self.QuestIndicator = QuestIndicator
	end

	local RaidTargetIndicator = self:CreateTexture()

	if self.unitStyle == "group" then
		RaidTargetIndicator:SetPoint("CENTER", self, "CENTER")
	elseif self.unitStyle == "targettarget" then
		RaidTargetIndicator:SetPoint("LEFT", self, "RIGHT", 3, 0)
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

		local LeaderIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		LeaderIndicator:SetText("L")
		LeaderIndicator:SetJustifyH('LEFT')
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

		local GroupRoleIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		GroupRoleIndicator:SetJustifyH('CENTER')
		GroupRoleIndicator:SetPoint("BOTTOM", self.Health, 1, 1)
		GroupRoleIndicator.Override = UpdateLFD

		self.GroupRoleIndicator = GroupRoleIndicator

		-- phase indicator
		local PhaseIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		PhaseIndicator:SetText("?")
		PhaseIndicator:SetJustifyH('RIGHT')
		PhaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -1)

		self.PhaseIndicator = PhaseIndicator
	end
end

-- name
local function CreateName(self)
	local Name

	if C.appearance.usePixelFont then
		Name = F.CreateFS(self.Health, C.font.pixel[1], C.font.pixel[2], C.font.pixel[3], {1, 1, 1}, {0, 0, 0}, 1, -1)
	elseif C.client == 'zhCN' or C.client == 'zhTW' then
		Name = F.CreateFS(self.Health, C.font.normal, 11, nil, {1, 1, 1}, {0, 0, 0}, 2, -2)
	else
		Name = F.CreateFS(self.Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1, 1, 1}, {0, 0, 0}, 1, -1)
	end

	Name:SetPoint("BOTTOM", self, "TOP", 0, 3)
	Name:SetWordWrap(false)
	Name:SetJustifyH("CENTER")
	Name:SetWidth(self:GetWidth())
	
	self:Tag(Name, '[name]')
	self.Name = Name

	if self.unitStyle == "target" then
		Name:ClearAllPoints()
		Name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		Name:SetJustifyH("RIGHT")
		Name:SetWidth(80)
	elseif self.unitStyle == "boss" then
		Name:ClearAllPoints()
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
		Name:SetJustifyH("LEFT")
	elseif self.unitStyle == "arena" then
		Name:ClearAllPoints()
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		Name:SetJustifyH("LEFT")
		Name:SetWidth(80)
	elseif self.unitStyle == "group" then
		Name:ClearAllPoints()
		Name:SetPoint("CENTER", 1, 0)
		Name:SetJustifyH('CENTER')

		self:Tag(Name, '[dead][offline]')

		if C.unitframes.partyNameAlways then
			if C.appearance.usePixelFont then
				Name:SetFont(unpack(C.font.pixel))
				Name:SetShadowOffset(1, -1)
			elseif C.client == 'zhCN' or C.client == 'zhTW' then
				Name:SetFont(C.font.normal, 11)
				Name:SetShadowOffset(2, -2)
			else
				F.SetFS(Name)
				Name:SetShadowOffset(1, -1)
			end

			self:Tag(Name, '[free:name]')
		elseif C.unitframes.partyMissingHealth then
			self:Tag(Name, '[free:missinghealth]')
			F.SetFS(Name)
		else
			self:Tag(Name, '[dead][offline]')
			F.SetFS(Name)
		end
	end
end

local function UpdateTOTName(self)
	local f = CreateFrame("Frame", nil, self)

	local tt

	if C.appearance.usePixelFont then
		tt = F.CreateFS(self, C.font.pixel[1], C.font.pixel[2], C.font.pixel[3], {1, 1, 1}, {0, 0, 0}, 1, -1)
	elseif C.client == 'zhCN' or C.client == 'zhTW' then
		tt = F.CreateFS(self, C.font.normal, 11, nil, {1, 1, 1}, {0, 0, 0}, 2, -2)
	else
		tt = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1, 1, 1}, {0, 0, 0}, 1, -1)
	end

	tt:SetPoint("BOTTOM", self, "TOP", 0, 3)
	tt:SetJustifyH("CENTER")
	tt:SetWordWrap(false)
	tt:SetWidth(C.unitframes.targettarget_width)

	f:RegisterEvent("UNIT_TARGET")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")

	f:SetScript("OnEvent", function()
		if(UnitName("targettarget") == UnitName("player")) then
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

	local ft

	if C.appearance.usePixelFont then
		ft = F.CreateFS(self, C.font.pixel[1], C.font.pixel[2], C.font.pixel[3], {1, 1, 1}, {0, 0, 0}, 1, -1)
	elseif C.client == 'zhCN' or C.client == 'zhTW' then
		ft = F.CreateFS(self, C.font.normal, 11, nil, {1, 1, 1}, {0, 0, 0}, 2, -2)
	else
		ft = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1, 1, 1}, {0, 0, 0}, 1, -1)
	end

	ft:SetPoint("BOTTOM", self, "TOP", 0, 3)
	ft:SetJustifyH('CENTER')
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
	--self:SetScript("OnEnter", UnitFrame_OnEnter)
	--self:SetScript("OnLeave", UnitFrame_OnLeave)

	--self:RegisterForClicks("AnyUp")

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameStrata("BACKGROUND")
	F.CreateTex(bd)
	self.bd = bd

	if C.appearance.shadow then
		local sd = CreateFrame("Frame", nil, bd)
		sd:SetBackdrop({edgeFile = C.media.glowtex, edgeSize = 4})
		sd:SetPoint("TOPLEFT", -4, 4)
		sd:SetPoint("BOTTOMRIGHT", 4, -4)
		sd:SetBackdropBorderColor(0, 0, 0, .35)
		self.sd = sd
	end


	--[[ Health ]]

	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetFrameStrata("LOW")
	Health:SetStatusBarTexture(C.media.backdrop)
	Health:SetStatusBarColor(0, 0, 0, 0)

	Health.frequentUpdates = true
	F.SmoothBar(Health)

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
		Healthdef:SetFrameLevel(self.Health:GetFrameLevel())
		Healthdef:SetAllPoints(self.Health)
		Healthdef:SetStatusBarTexture(C.media.texture)
		-- Healthdef:GetStatusBarTexture():SetBlendMode("BLEND")
		Healthdef:SetStatusBarColor(1, 1, 1)

		Healthdef:SetReverseFill(true)
		F.SmoothBar(Healthdef)

		self.Healthdef = Healthdef
	end


	--[[ Power ]]

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(C.media.texture)

	Power.frequentUpdates = true
	F.SmoothBar(Power)

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

		CounterBar.Text = F.CreateFS(CounterBar, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
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
			self:SetSize(C.unitframes.focustarget_width, C.unitframes.focustarget_height)
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

		CreateHeader(self)
		CreatePortrait(self)

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

		CreateHeader(self)

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.player_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		HealthPoints:SetJustifyH('LEFT')
		HealthPoints:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 3)
		self:Tag(HealthPoints, '[dead][offline][free:playerHealth]')
		Health.value = HealthPoints

		local PowerText = F.CreateFS(Power, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		PowerText:SetJustifyH('RIGHT')
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

		CreatePortrait(self)

		FreeUI_LeaveVehicleButton:SetPoint("LEFT", self, "RIGHT", 5, 0)
	end,

	target = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "target"

		CreateHeader(self)
		CreatePortrait(self)

		local Health = self.Health
		local Power = self.Power

		Health:SetHeight(C.unitframes.target_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		HealthPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		self:Tag(HealthPoints, '[dead][offline][free:health]')
		Health.value = HealthPoints

		local PowerText = F.CreateFS(Power, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		PowerText:SetPoint("BOTTOMLEFT", HealthPoints, "BOTTOMRIGHT", 3, 0)
		if powerType ~= 0 then PowerText.frequentUpdates = .1 end
		self:Tag(PowerText, '[free:power]')

		local Classification = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
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

		CreateHeader(self)

		UpdateTOTName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateDebuffs(self)
	end,

	focus = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "focus"

		CreateHeader(self)

		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateDebuffs(self)
	end,

	focustarget = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "focustarget"

		CreateHeader(self)

		UpdateTOFName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateDebuffs(self)
	end,


	boss = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "boss"

		CreateHeader(self)
		CreatePortrait(self)

		local Health = self.Health
		local Power = self.Power

		self:SetAttribute('initial-height', bossHeight)
		self:SetAttribute('initial-width', bossWidth)

		Health:SetHeight(C.unitframes.boss_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		HealthPoints:SetJustifyH('RIGHT')
		HealthPoints:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 4)
		self:Tag(HealthPoints, '[dead][free:bosshealth]')

		Health.value = HealthPoints

		CreateName(self)
		CreateAltPower(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self)
		CreateSelectedBorder(self)
		
	end,

	arena = function(self, ...)
		if not C.unitframes.enableArena then return end

		Shared(self, ...)
		self.unitStyle = "arena"

		CreateHeader(self)

		local Health = self.Health
		local Power = self.Power

		self:SetAttribute('initial-height', arenaHeight)
		self:SetAttribute('initial-width', arenaWidth)

		Health:SetHeight(C.unitframes.arena_height - C.unitframes.power_height - 1)

		local HealthPoints = F.CreateFS(Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		HealthPoints:SetJustifyH('RIGHT')
		HealthPoints:SetPoint("RIGHT", self, "TOPRIGHT", 0, 6)
		self:Tag(HealthPoints, '[dead][offline][free:health]')

		Health.value = HealthPoints

		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateBuffs(self)
		CreateDebuffs(self)
	end,

	party = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "group"

		CreateHeader(self)
		CreatePortrait(self)

		self.disallowVehicleSwap = false

		local Health, Power = self.Health, self.Power

		CreateName(self)

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


		CreateSelectedBorder(self)


		self.Range = {
			insideAlpha = 1, outsideAlpha = C.unitframes.outRangeAlpha,
		}
	end,

	raid = function(self, ...)
		Shared(self, ...)
		self.unitStyle = "group"

		CreateHeader(self)

		self.disallowVehicleSwap = false

		local Health, Power = self.Health, self.Power

		CreateName(self)

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


		CreateSelectedBorder(self)



		self.Range = {
			insideAlpha = 1, outsideAlpha = C.unitframes.outRangeAlpha,
		}
	end,
}


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
		'xoffset', -4,
		'yoffset', 6,
		'maxColumns', 1,
		'unitsperColumn', 5,
		'columnSpacing', 4,
		'point', "BOTTOM", -- party initial position
		'columnAnchorPoint', "LEFT",
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(C.unitframes.party_height, C.unitframes.party_width)
	):SetPoint(unpack(C.unitframes.party))

	self:SetActiveStyle'Free - Raid'

	local raid = self:SpawnHeader(nil, nil, "raid",
		'showParty', false,
		'showRaid', true,
		'xoffset', -4,
		'yOffset', -4,
		'point', "RIGHT",
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 4,
		'columnAnchorPoint', "TOP",
		"sortMethod", "INDEX",
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(C.unitframes.raid_height, C.unitframes.raid_width)
	):SetPoint(unpack(C.unitframes.raid))



	-- 限制团队框体只显示4个队伍20名成员
	if C.unitframes.limitRaidSize then
		raid:SetAttribute("groupFilter", "1,2,3,4")
	end

end)

function module:OnLogin()
	self:Focuser()
end