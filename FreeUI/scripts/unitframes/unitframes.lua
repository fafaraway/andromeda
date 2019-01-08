local F, C, L = unpack(select(2, ...))
if not C.unitframes.enable then return end

local module = F:RegisterModule('unitframe')
local oUF, cast = FreeUI.oUF, FreeUI.cast




local function CreateBackDrop(self)
	local bd = CreateFrame('Frame', nil, self)
	bd:SetPoint('TOPLEFT', -1, 1)
	bd:SetPoint('BOTTOMRIGHT', 1, -1)
	bd:SetFrameStrata('BACKGROUND')
	self.bd = bd

	if C.unitframes.transMode then
		F.CreateBD(bd, C.unitframes.transModeAlpha)
	else
		F.CreateBD(bd)
	end

	if C.appearance.addShadowBorder then
		F.CreateSD(bd)
		self.Shadow = sd
	end
end

local function CreateHeader(self)
	local hl = self:CreateTexture(nil, 'OVERLAY')
	hl:SetAllPoints()
	hl:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	hl:SetTexCoord(0, 1, .5, 1)
	hl:SetVertexColor(.6, .6, .6)
	hl:SetBlendMode('ADD')
	hl:Hide()
	self.Highlight = hl

	self:RegisterForClicks('AnyUp')
	self:HookScript('OnEnter', function()
		UnitFrame_OnEnter(self)
		self.Highlight:Show()
	end)
	self:HookScript('OnLeave', function()
		UnitFrame_OnLeave(self)
		self.Highlight:Hide()
	end)
end


-- Selected frames name/border colour
local function UpdateNameColour(self, unit)
	if UnitIsUnit(unit, 'target') then
		self.Text:SetTextColor(.1, .7, 1)
	elseif UnitIsDead(unit) then
		self.Text:SetTextColor(.7, .2, .1)
	elseif UnitIsGhost(unit) then
		self.Text:SetTextColor(.7, .6, .8)
	else
		self.Text:SetTextColor(1, 1, 1)
	end
end

local function UpdateNameColourAlt(self)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, 'target') then
			frame.Text:SetTextColor(.1, .7, 1)
		elseif UnitIsDead(frame.unit) then
			frame.Text:SetTextColor(.7, .2, .1)
		elseif UnitIsGhost(frame.unit) then
			frame.Text:SetTextColor(.7, .6, .8)
		else
			frame.Text:SetTextColor(1, 1, 1)
		end
	else
		frame.Text:SetTextColor(1, 1, 1)
	end
end

local function NameColour(self)
	local nc = CreateFrame('Frame', nil, self)
	nc:RegisterEvent('PLAYER_TARGET_CHANGED')
	nc:SetScript('OnEvent', UpdateNameColourAlt)
end

local function UpdateBorderColour(self)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, 'target') then
			frame.bd:SetBackdropBorderColor(1, 1, 1)
		elseif UnitIsDead(frame.unit) then
			frame.bd:SetBackdropBorderColor(0, 0, 0)
		else
			frame.bd:SetBackdropBorderColor(0, 0, 0)
		end
	else
		frame.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

local function BorderColour(self)
	local bc = CreateFrame('Frame', nil, self)
	bc:RegisterEvent('PLAYER_TARGET_CHANGED')
	bc:SetScript('OnEvent', UpdateBorderColour)
end


-- Health
local function PostUpdateHealth(Health, unit, min, max)
	local self = Health:GetParent()
	local r, g, b
	local reaction = C.reactioncolours[UnitReaction(unit, 'player') or 5]

	local offline = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)

	if tapped or offline then
		r, g, b = .6, .6, .6
	elseif UnitIsDead(unit) then
		r, g, b = 1, 0, 0
	elseif unit == 'pet' then
		local _, class = UnitClass('player')
		r, g, b = C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b
	elseif UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then r, g, b = C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b else r, g, b = 1, 1, 1 end
	else
		r, g, b = unpack(reaction)
	end

	if unit == 'target' or unit:find('arena') then
		if Health.value then
			Health.value:SetTextColor(unpack(reaction))
		end
	end

	if C.unitframes.transMode then
		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			--self.Healthdef:Hide()
			self.Healthdef:SetAlpha(0)
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

			--self.Healthdef:Show()
			self.Healthdef:SetAlpha(1)
		end

		if tapped or offline then
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha('VERTICAL', .6, .6, .6, .6, .4, .4, .4, .6)
			else
				self.gradient:SetGradientAlpha('VERTICAL', .6, .6, .6, .6, .6, .6, .6, .6)
			end
		elseif UnitIsDead(unit) or UnitIsGhost(unit) then
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha('VERTICAL', .1, .1, .1, 1, .1, .1, .1, 1)
			end
		else
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .1, .1, .1, .6)
			else
				self.gradient:SetGradientAlpha('VERTICAL', .1, .1, .1, .6, .1, .1, .1, .6)
			end
		end

		if self.Text then
			UpdateNameColour(self, unit)
		end
	else
		if UnitIsDead(unit) or UnitIsGhost(unit) then
			Health:SetValue(0)
		end

		if C.unitframes.gradient then
			Health:GetStatusBarTexture():SetGradient('VERTICAL', r, g, b, r/2, g/2, b/2)
		else
			Health:GetStatusBarTexture():SetGradient('VERTICAL', r, g, b, r, g, b)
		end
	end
end

local function CreateHealthBar(self)
	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetFrameStrata('LOW')
	Health:SetStatusBarTexture(C.media.sbTex)
	Health:SetStatusBarColor(0, 0, 0, 0)

	Health.frequentUpdates = true
	F.SmoothBar(Health)

	Health:SetPoint('TOP')
	Health:SetPoint('LEFT')
	Health:SetPoint('RIGHT')
	Health:SetPoint('BOTTOM', 0, 1 + C.unitframes.power_height)
	Health:SetHeight(self:GetHeight() - C.unitframes.power_height - 1)

	self.Health = Health
	Health.PostUpdate = PostUpdateHealth

	if C.unitframes.transMode then
		local gradient = Health:CreateTexture(nil, 'BACKGROUND')
		gradient:SetPoint('TOPLEFT')
		gradient:SetPoint('BOTTOMRIGHT')
		gradient:SetTexture(C.media.backdrop)

		if C.unitframes.gradient then
			gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .1, .1, .1, .6)
		else
			gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .3, .3, .3, .6)
		end

		self.gradient = gradient
	end

	if C.unitframes.transMode then
		local Healthdef = CreateFrame('StatusBar', nil, self)
		--Healthdef:SetFrameStrata('LOW')
		Healthdef:SetFrameLevel(self.Health:GetFrameLevel())
		Healthdef:SetAllPoints(self.Health)
		Healthdef:SetStatusBarTexture(C.media.sbTex)
		Healthdef:GetStatusBarTexture():SetBlendMode('BLEND')
		Healthdef:SetStatusBarColor(1, 1, 1)

		Healthdef:SetReverseFill(true)
		F.SmoothBar(Healthdef)

		self.Healthdef = Healthdef
	end
end

local function CreateHealthPrediction(self)
	if not C.unitframes.prediction then return end

	local myBar = CreateFrame('StatusBar', nil, self.Health)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	myBar:SetStatusBarTexture(C.media.sbTex)
	myBar:GetStatusBarTexture():SetBlendMode('BLEND')
	myBar:SetStatusBarColor(0, .8, .8, .6)
	myBar:SetWidth(self:GetWidth())

	local otherBar = CreateFrame('StatusBar', nil, self.Health)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), 'RIGHT')
	otherBar:SetStatusBarTexture(C.media.sbTex)
	otherBar:GetStatusBarTexture():SetBlendMode('BLEND')
	otherBar:SetStatusBarColor(0, .6, .6, .6)
	otherBar:SetWidth(self:GetWidth())

	local absorbBar = CreateFrame('StatusBar', nil, self.Health)
	absorbBar:SetPoint('TOP')
	absorbBar:SetPoint('BOTTOM')
	absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), 'RIGHT')
	absorbBar:SetStatusBarTexture('Interface\\AddOns\\FreeUI\\assets\\statusbar_striped')
	absorbBar:GetStatusBarTexture():SetBlendMode('BLEND')
	absorbBar:SetStatusBarColor(.8, .8, .8, .6)
	absorbBar:SetWidth(self:GetWidth())

	local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
	overAbsorb:SetPoint('TOP', 0, 2)
	overAbsorb:SetPoint('BOTTOM', 0, -2)
	overAbsorb:SetPoint('LEFT', self.Health, 'RIGHT', -4, 0)
	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		overAbsorb:SetWidth(8)
	else
		overAbsorb:SetWidth(14)
	end

	self.HealthPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		overAbsorb = overAbsorb,
		maxOverflow = 1,
		frequentUpdates = true,
	}
end


-- Power
local function PostUpdatePower(Power, unit, cur, max, min)
	local Health = Power:GetParent().Health
	local self = Power:GetParent()
	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		Power:SetValue(0)
	end

	if Power.Text then
		Power.Text:SetTextColor(Power:GetStatusBarColor())
	end

	if C.PlayerClass == 'DEMONHUNTER' and C.unitframes.classMod_havoc and self.unitStyle == 'player' then
		local spec, cp = GetSpecialization() or 0, UnitPower(unit)
		if spec == 1 and cp < 15 then
			Power:SetStatusBarColor(.7, .8, .4)
		elseif spec == 1 and cp < 40 then
			Power:SetStatusBarColor(1, 0, 0)
		end
	end

	Power.bg:SetVertexColor(0, 0, 0, .5)
end

local function CreatePowerBar(self)
	local Power = CreateFrame('StatusBar', nil, self)
	Power:SetStatusBarTexture(C.media.sbTex)

	Power.frequentUpdates = true
	F.SmoothBar(Power)

	Power:SetHeight(C.unitframes.power_height)

	Power:SetPoint('LEFT')
	Power:SetPoint('RIGHT')
	Power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)

	self.Power = Power

	local Powertex = Power:CreateTexture(nil, 'OVERLAY')
	Powertex:SetHeight(1)
	Powertex:SetPoint('TOPLEFT', 0, 1)
	Powertex:SetPoint('TOPRIGHT', 0, 1)
	Powertex:SetTexture(C.media.backdrop)
	Powertex:SetVertexColor(0, 0, 0)

	Power.bg = Power:CreateTexture(nil, 'BACKGROUND')
	Power.bg:SetHeight(C.unitframes.power_height)
	Power.bg:SetPoint('LEFT')
	Power.bg:SetPoint('RIGHT')
	Power.bg:SetTexture(C.media.backdrop)
	Power.bg:SetVertexColor(0, 0, 0, .1)

	Power.colorReaction = true

	if C.unitframes.transMode then
		if self.unitStyle == 'player' and C.unitframes.powerTypeColor then
			Power.colorPower = true
		else
			Power.colorClass = true
		end
	else
		Power.colorPower = true
	end

	Power.PostUpdate = PostUpdatePower
end


-- Alternative power
local function PostUpdateAltPower(element, _, cur, _, max)
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
	local bar = CreateFrame('StatusBar', nil, self)
	bar:SetStatusBarTexture(C.media.sbTex)
	bar:SetPoint('BOTTOM', self, 0, -C.unitframes.altpower_height - 3)
	bar:SetSize(self:GetWidth(), C.unitframes.altpower_height)

	local abd = CreateFrame('Frame', nil, bar)
	abd:SetPoint('TOPLEFT', -1, 1)
	abd:SetPoint('BOTTOMRIGHT', 1, -1)
	abd:SetFrameLevel(bar:GetFrameLevel()-1)
	F.CreateBD(abd, .5)

	local text = F.CreateFS(bar, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	text:SetJustifyH('CENTER')
	text:SetPoint('BOTTOM', self, 'TOP', 0, 3)

	self:Tag(text, '[altpower]')

	F.SmoothBar(bar)

	bar:EnableMouse(true)

	self.AlternativePower = bar		
	self.AlternativePower.PostUpdate = PostUpdateAltPower
end


-- Health/Power/Classification text
local function CreateHealthText(self)
	local HealthPoints = F.CreateFS(self.Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	HealthPoints:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 3)
	HealthPoints:SetJustifyH('LEFT')
	
	if self.unitStyle == 'player' then
		self:Tag(HealthPoints, '[dead][offline][free:playerHealth]')
	elseif self.unitStyle == 'target' then
		self:Tag(HealthPoints, '[dead][offline][free:health]')
	elseif self.unitStyle == 'boss' then
		HealthPoints:ClearAllPoints()
		HealthPoints:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		HealthPoints:SetJustifyH('RIGHT')
		self:Tag(HealthPoints, '[dead][free:bosshealth]')
	elseif self.unitStyle == 'arena' then
		HealthPoints:ClearAllPoints()
		HealthPoints:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		HealthPoints:SetJustifyH('RIGHT')
		self:Tag(HealthPoints, '[dead][offline][free:health]')
	end

	self.Health.value = HealthPoints
end

local function CreatePowerText(self)
	local PowerText = F.CreateFS(self.Power, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	PowerText:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', 0, 3)
	PowerText:SetJustifyH('RIGHT')

	if self.unitStyle == 'target' then
		PowerText:ClearAllPoints()
		PowerText:SetPoint('BOTTOMLEFT', self.Health.value, 'BOTTOMRIGHT', 3, 0)
	end

	if powerType ~= 0 then
		PowerText.frequentUpdates = .1
	end

	self:Tag(PowerText, '[free:power]')

	self.Power.Text = PowerText
end

local function ClassificationText(self)
	local Classification = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	Classification:SetPoint('BOTTOMLEFT', self.Power.Text, 'BOTTOMRIGHT', 3, 0)
	self:Tag(Classification, '[free:classification]')
end


-- Cast bar
local function CreateCastBar(self)
	if (not C.unitframes.castbar) then return end

	if FreeUIConfig.layout == 2 then
		C.unitframes.cbSeparate = true
	end

	local cb = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	cb:SetHeight(C.unitframes.cbHeight)
	cb:SetWidth(self:GetWidth())
	cb:SetAllPoints(self)
	cb:SetStatusBarTexture(C.media.sbTex)
	cb:GetStatusBarTexture():SetBlendMode('BLEND')
	cb:SetStatusBarColor(0, 0, 0, 0)
	cb:SetFrameLevel(self.Health:GetFrameLevel() + 3)

	cb.CastingColor = C.unitframes.cbCastingColor
	cb.ChannelingColor = C.unitframes.cbChannelingColor
	cb.notInterruptibleColor = C.unitframes.cbnotInterruptibleColor
	cb.CompleteColor = C.unitframes.cbCompleteColor
	cb.FailColor = C.unitframes.cbFailColor

	local spark = cb:CreateTexture(nil, 'OVERLAY')
	spark:SetBlendMode('ADD')
	spark:SetAlpha(.7)
	spark:SetHeight(cb:GetHeight()*2.5)
	cb.Spark = spark

	local name

	if C.GameClient == 'zhCN' or C.GameClient == 'zhTW' then
		name = F.CreateFS(cb, C.font.normal, 12, nil, {1, 1, 1}, {0, 0, 0}, 2, -2)
	else
		name = F.CreateFS(cb, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1, 1, 1}, {0, 0, 0}, 1, -1)
	end

	name:SetPoint('CENTER', self.Health)
	cb.Text = name
	name:Hide()

	local timer = F.CreateFS(cb, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
	timer:SetPoint('BOTTOMRIGHT', cb, 'TOPRIGHT', 0, 6)
	cb.Time = timer
	timer:Hide()

	local iconFrame = CreateFrame('Frame', nil, cb)
	iconFrame:SetPoint('LEFT', self, 'RIGHT', 4, 0)
	iconFrame:SetSize(self:GetHeight() + 4, self:GetHeight() + 4)

	F.CreateSD(iconFrame)

	local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
	icon:SetAllPoints(iconFrame)
	icon:SetTexCoord(unpack(C.TexCoord))

	cb.Icon = icon

	local iconBG = iconFrame:CreateTexture(nil, 'BACKGROUND')
	iconBG:SetPoint('TOPLEFT', -1 , 1)
	iconBG:SetPoint('BOTTOMRIGHT', 1, -1)
	iconBG:SetTexture(C.media.backdrop)
	iconBG:SetVertexColor(0, 0, 0)

	cb.iconBG = iconBG

	self.Castbar = cb

	if self.unitStyle == 'player' then
		local safe = cb:CreateTexture(nil,'OVERLAY')
		safe:SetTexture(C.media.backdrop)
		safe:SetVertexColor(223/255, 63/255, 107/255, .6)
		safe:SetPoint('TOPRIGHT')
		safe:SetPoint('BOTTOMRIGHT')
		cb.SafeZone = safe
	end

	if self.unitStyle == 'target' or self.unitStyle == 'focus'
		or (C.unitframes.cbSeparate and self.unitStyle == 'player') then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', cb, 'LEFT', -4, 0)

		name:ClearAllPoints()
		name:SetPoint('BOTTOM', cb, 'TOP', 0, 4)

		if C.unitframes.cbName then
			name:Show()
		end
		if C.unitframes.cbTimer then
			timer:Show()
		end

		local bg = CreateFrame('Frame', nil, cb)
		bg:SetPoint('TOPLEFT', -1, 1)
		bg:SetPoint('BOTTOMRIGHT', 1, -1)
		bg:SetFrameLevel(cb:GetFrameLevel()-1)

		F.CreateBD(bg)
		F.CreateSD(bg)
	end

	if (self.unitStyle == 'player' and C.unitframes.cbSeparate) then
		cb:ClearAllPoints()
		cb:SetPoint('TOP', self, 'BOTTOM', 0, -40)
	elseif self.unitStyle == 'player' then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', self, 'RIGHT', 4, 0)
	elseif self.unitStyle == 'pet' or self.unitStyle == 'arena' then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', self, 'LEFT', -4, 0)
	elseif self.unitStyle == 'target' then
		cb:ClearAllPoints()
		cb:SetPoint('TOP', self, 'BOTTOM', 0, -40)
	elseif self.unitStyle == 'focus' then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', cb, 'LEFT', -4, 0)
		cb:SetWidth(self:GetWidth() * 2 + 5)
		cb:ClearAllPoints()
		cb:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -80)
	elseif self.unitStyle == 'targettarget' or self.unitStyle == 'focustarget' then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', self, 'RIGHT', 4, 0)
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
local function FormatAuraTime(s)
	local day, hour, minute = 86400, 3600, 60

	if s >= day then
		return format('%d', F.Round(s/day))
	elseif s >= hour then
		return format('%d', F.Round(s/hour))
	elseif s >= minute then
		return format('%d', F.Round(s/minute))
	end
	return format('%d', mod(s, minute))
end

local function UpdateAura(self, elapsed)
	if(self.expiration) then
		self.expiration = math.max(self.expiration - elapsed, 0)

		if(self.expiration > 0 and self.expiration < 30) then
			self.Duration:SetText(FormatAuraTime(self.expiration))
			self.Duration:SetTextColor(1, 0, 0)
		elseif(self.expiration > 30 and self.expiration < 60) then
			self.Duration:SetText(FormatAuraTime(self.expiration))
			self.Duration:SetTextColor(1, 1, 0)
		elseif(self.expiration > 60 and self.expiration < 300) then
			self.Duration:SetText(FormatAuraTime(self.expiration))
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
	local bg = button:CreateTexture(nil, 'BACKGROUND')
	bg:SetPoint('TOPLEFT', -1, 1)
	bg:SetPoint('BOTTOMRIGHT', 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)
	button.bg = bg

	if C.appearance.addShadowBorder then
		local sd = CreateFrame('Frame', nil, button)
		sd:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = 4})
		sd:SetPoint('TOPLEFT', -4, 4)
		sd:SetPoint('BOTTOMRIGHT', 4, -4)
		sd:SetBackdropBorderColor(0, 0, 0, .65)
		button.sd = sd
	end
	
	button.overlay:SetTexture(nil)
	button.stealable:SetTexture(nil)
	button.cd:SetReverse(true)
	button.icon:SetDrawLayer('ARTWORK')
	button:SetFrameLevel(element:GetFrameLevel() + 4)
	button.icon:SetTexCoord(.08, .92, .25, .85)

	element.disableCooldown = true

	button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
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

	button:HookScript('OnUpdate', UpdateAura)
	button:SetScript('OnClick', function(self, button)
		if not InCombatLockdown() and button == 'RightButton' then
			CancelUnitBuff('player', self:GetID(), self.filter)
		end
	end)
end

local function PostUpdateIcon(element, unit, button, index, _, duration, _, debuffType)
	local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)

	if not (element.__owner.unitStyle == 'party' and button.isDebuff) then
		button:SetSize(element.size, element.size*.75)
	end

	if(duration and duration > 0) then
		button.expiration = expiration - GetTime()
	else
		button.expiration = math.huge
	end

	if (element.__owner.unitStyle == 'party' and not button.isDebuff) or element.__owner.unitStyle == 'raid' or element.__owner.unitStyle == 'pet' then
		button.Duration:Hide()
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
	elseif (element.__owner.unitStyle == 'party' or element.__owner.unitStyle == 'raid') and not button.isDebuff then
		if button.sd then
			button.sd:SetBackdropBorderColor(0, 0, 0, 0)
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

local function BolsterPreUpdate(element)
	element.bolster = 0
	element.bolsterIndex = nil
end

local function BolsterPostUpdate(element)
	if not element.bolsterIndex then return end
	for _, button in pairs(element) do
		if button == element.bolsterIndex then
			button.count:SetText(element.bolster)
			return
		end
	end
end

local function CustomFilter(element, unit, button, name, _, _, _, _, _, caster, isStealable, _, spellID)
	local style = element.__owner.unitStyle

	if name and spellID == 209859 then
		element.bolster = element.bolster + 1
		if not element.bolsterIndex then
			element.bolsterIndex = button
			return true
		end
	elseif style == 'target' then
		if (C.unitframes.debuffbyPlayer and button.isDebuff and not button.isPlayer) then
			return false
		else
			return true
		end
	elseif style == 'boss' then
		if (button.isDebuff and not button.isPlayer) then
			return false
		else
			return true
		end
	elseif style == 'party' or style == 'raid' then
		if (button.isDebuff and not module.ignoredDebuffs[spellID]) then
			return true
		elseif (button.isPlayer and module.myBuffs[spellID]) or (module.allBuffs[spellID]) then
			return true
		else
			return false
		end
	elseif style == 'focus' then
		if (button.isDebuff and button.isPlayer) then
			return true
		else
			return false
		end
	elseif style == 'arena' then
		return true
	elseif style == 'pet' then
		return true
	end
end

local function PostUpdateGapIcon(self, unit, icon, visibleBuffs)
	icon:Hide()
end

local function AuraIconSize(w, n, s)
	return (w-(n-1)*s)/n
end

local function CreateAuras(self, num, perrow)
	local Auras = CreateFrame('Frame', nil, self)

	if self.unitStyle == 'target' then
		Auras.initialAnchor = 'BOTTOMLEFT'
		Auras:SetPoint('BOTTOM', self, 'TOP', 0, 24)
		Auras['growth-y'] = 'UP'
		Auras['spacing-x'] = 5
	elseif self.unitStyle == 'pet' or self.unitStyle == 'focus' or self.unitStyle == 'boss' or self.unitStyle == 'arena' then
		Auras.initialAnchor = 'TOPLEFT'
		Auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		Auras['growth-y'] = 'DOWN'
		Auras['spacing-x'] = 5
	end

	Auras.numTotal  = num
	Auras.iconsPerRow = perrow
	Auras.gap = true
	Auras.showDebuffType = true
	Auras.showStealableBuffs = true

	Auras.size = AuraIconSize(self:GetWidth(), Auras.iconsPerRow, 5)
	Auras:SetWidth(self:GetWidth())
	Auras:SetHeight((Auras.size) * F.Round(Auras.numTotal/Auras.iconsPerRow))

	Auras.CustomFilter = CustomFilter
	Auras.PostCreateIcon = PostCreateIcon
	Auras.PostUpdateIcon = PostUpdateIcon
	Auras.PostUpdateGapIcon = PostUpdateGapIcon
	Auras.PreUpdate = BolsterPreUpdate
	Auras.PostUpdate = BolsterPostUpdate

	self.Auras = Auras
end

local function CreateBuffs(self)
	local Buffs = CreateFrame('Frame', nil, self)
	Buffs.initialAnchor = 'CENTER'
	Buffs:SetPoint('TOP', 0, -2)
	Buffs['growth-x'] = 'RIGHT'
	Buffs.spacing = 3
	Buffs.num = 3
	
	if (self.unitStyle == 'party' and FreeUIConfig.layout ~= 2) then
		Buffs.size = 18
		Buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				Buffs:SetPoint('TOP', -20, -2)
			elseif icons.visibleBuffs == 2 then
				Buffs:SetPoint('TOP', -10, -2)
			else
				Buffs:SetPoint('TOP', 0, -2)
			end
		end
	else
		Buffs.size = 12
		Buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				Buffs:SetPoint('TOP', -14, -2)
			elseif icons.visibleBuffs == 2 then
				Buffs:SetPoint('TOP', -7, -2)
			else
				Buffs:SetPoint('TOP', 0, -2)
			end
		end
	end

	Buffs:SetSize((Buffs.size*Buffs.num)+(Buffs.num-1)*Buffs.spacing, Buffs.size)

	Buffs.disableCooldown = true
	Buffs.disableMouse = true
	Buffs.PostCreateIcon = PostCreateIcon
	Buffs.PostUpdateIcon = PostUpdateIcon
	Buffs.CustomFilter = CustomFilter

	self.Buffs = Buffs
end

local function CreateDebuffs(self)
	local Debuffs = CreateFrame('Frame', nil, self)
	
	if self.unitStyle == 'party' and FreeUIConfig.layout ~= 2 then
		Debuffs.initialAnchor = 'LEFT'
		Debuffs['growth-x'] = 'RIGHT'
		Debuffs:SetPoint('LEFT', self, 'RIGHT', 6, 0)
		Debuffs.size = 24
		Debuffs.num = 3
		Debuffs.disableCooldown = false
		Debuffs.disableMouse = false
	else
		Debuffs.initialAnchor = 'CENTER'
		Debuffs['growth-x'] = 'RIGHT'
		Debuffs:SetPoint('BOTTOM', 0, C.unitframes.power_height - 1)
		Debuffs.size = 16
		Debuffs.num = 2
		Debuffs.disableCooldown = true
		Debuffs.disableMouse = true

		Debuffs.PostUpdate = function(icons)
			if icons.visibleDebuffs == 2 then
				Debuffs:SetPoint('BOTTOM', -9, 0)
			else
				Debuffs:SetPoint('BOTTOM')
			end
		end
	end

	Debuffs.spacing = 5
	Debuffs:SetSize((Debuffs.size*Debuffs.num)+(Debuffs.num-1)*Debuffs.spacing, Debuffs.size)
	Debuffs.showDebuffType = true
	Debuffs.PostCreateIcon = PostCreateIcon
	Debuffs.PostUpdateIcon = PostUpdateIcon
	Debuffs.CustomFilter = CustomFilter

	self.Debuffs = Debuffs
end


-- Portrait
local function PostUpdatePortrait(element, unit)
	element:SetDesaturation(1)
end

local function CreatePortrait(self)
	if not C.unitframes.portrait then return end

	local Portrait = CreateFrame('PlayerModel', nil, self)
	Portrait:SetAllPoints(self)
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

			Bar:SetWidth((maxWidth - (max - 1) * gap) / max)

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

	for index = 1, 6 do 
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(C.unitframes.classPower_height)
		Bar:SetStatusBarTexture(C.media.sbTex)
		Bar:SetBackdropColor(0, 0, 0)

		F.CreateBDFrame(Bar)

		if(index == 1) then
			Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end

		local function MoveClassPowerBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0,-3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveClassPowerBar)
		self.AlternativePower:HookScript('OnHide', MoveClassPowerBar)
		MoveClassPowerBar()

		local Background = Bar:CreateTexture(nil, 'BORDER')
		Background:SetAllPoints()
		Bar.bg = Background

		ClassPower[index] = Bar	
	end

	self.ClassPower = ClassPower
end


-- Runes bar
local function PostUpdateRune(element, runemap)
	local MaxRunes = 6
	for index, runeID in next, runemap do
		local Bar = element[index]
		local runeReady = select(3, GetRuneCooldown(runeID))
		local maxWidth, gap = C.unitframes.player_width, 3
		if Bar:IsShown() and not runeReady then
			Bar:SetAlpha(.45)
		else
			Bar:SetAlpha(1)
		end

		Bar:SetWidth((maxWidth - (MaxRunes - 1) * gap) / MaxRunes)

		if(index > 1) then
			Bar:ClearAllPoints()
			Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
		end

		local spec = GetSpecialization() or 0
		local color
		if spec == 1 then
			color = {151/255, 25/255, 0}
		elseif spec == 2 then
			color = {193/255, 219/255, 233/255}
		elseif spec == 3 then
			color = {98/255, 153/255, 51/255}
		end
		Bar:SetStatusBarColor(color[1], color[2], color[3])
	end
end

local function CreateRunesBar(self)
	local Runes = {}
	local MaxRunes = 6

	for index = 1, MaxRunes do
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(C.unitframes.classPower_height)
		Bar:SetStatusBarTexture(C.media.sbTex)

		F.CreateBDFrame(Bar)

		if(index == 1) then
			Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end

		local function MoveRunesBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0,-3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveRunesBar)
		self.AlternativePower:HookScript('OnHide', MoveRunesBar)
		MoveRunesBar()

		local Background = Bar:CreateTexture(nil, 'BORDER')
		Background:SetAllPoints()
		Bar.bg = Background

		Runes[index] = Bar
	end

	Runes.sortOrder = 'asc'
	Runes.PostUpdate = PostUpdateRune
	self.Runes = Runes
end


-- indicator
local function CreateIndicator(self)
	if self.unitStyle == 'player' then
		local PvPIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0,0,0}, 1, -1)
		PvPIndicator:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', -50, 3)
		PvPIndicator:SetText('P')

		local UpdatePvPIndicator = function(self, event, unit)
			if(unit ~= self.unit) then return end

			local PvPIndicator = self.PvPIndicator

			local factionGroup = UnitFactionGroup(unit)
			--C_PvP.IsWarModeActive()
			if(UnitIsPVPFreeForAll(unit) or (factionGroup and factionGroup ~= 'Neutral' and UnitIsPVP(unit))) then
				if factionGroup == 'Alliance' then
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


		local statusIndicator = CreateFrame('Frame')
		local statusText = F.CreateFS(self.Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		statusText:SetPoint('LEFT', self.Health.value, 'RIGHT', 10, 0)

		local function updateStatus()
			if UnitAffectingCombat('player') then
				statusText:SetText('!')
				statusText:SetTextColor(1, 0, 0)
			elseif IsResting() then
				statusText:SetText('Zzz')
				statusText:SetTextColor(44/255, 141/255, 81/255)
			else
				statusText:SetText('')
			end
		end

		local function checkEvents()
			statusText:Show()
			statusIndicator:RegisterEvent('PLAYER_ENTERING_WORLD')
			statusIndicator:RegisterEvent('PLAYER_UPDATE_RESTING')
			statusIndicator:RegisterEvent('PLAYER_REGEN_ENABLED')
			statusIndicator:RegisterEvent('PLAYER_REGEN_DISABLED')

			updateStatus()
		end
		checkEvents()
		statusIndicator:SetScript('OnEvent', updateStatus)
	end

	if self.unitStyle == 'target' then
		local QuestIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		QuestIndicator:SetText('!')
		QuestIndicator:SetTextColor(228/255, 225/255, 16/255)
		QuestIndicator:SetPoint('RIGHT', self.Name, 'LEFT', -3, 0)

		self.QuestIndicator = QuestIndicator
	end

	local RaidTargetIndicator = self:CreateTexture()
	RaidTargetIndicator:SetTexture('Interface\\AddOns\\FreeUI\\assets\\UI-RaidTargetingIcons')
	RaidTargetIndicator:SetSize(16, 16)

	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		RaidTargetIndicator:SetPoint('CENTER', self, 'CENTER')
	elseif self.unitStyle == 'targettarget' then
		RaidTargetIndicator:SetPoint('LEFT', self, 'RIGHT', 3, 0)
	elseif self.unitStyle == 'focus' then
		RaidTargetIndicator:SetPoint('RIGHT', self, 'LEFT', -3, 0)
	elseif self.unitStyle == 'focustarget' then
		RaidTargetIndicator:SetPoint('LEFT', self, 'RIGHT', 3, 0)
	else
		RaidTargetIndicator:SetPoint('CENTER', self, 'CENTER', 0, 20)
	end

	self.RaidTargetIndicator = RaidTargetIndicator

	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		local ResurrectIndicator = self:CreateTexture(nil, 'OVERLAY')
		ResurrectIndicator:SetSize(16, 16)
		ResurrectIndicator:SetPoint('CENTER')
		self.ResurrectIndicator = ResurrectIndicator

		local LeaderIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		LeaderIndicator:SetText('L')
		LeaderIndicator:SetJustifyH('LEFT')
		LeaderIndicator:SetPoint('TOPLEFT', self.Health, 2, -1)
		self.LeaderIndicator = LeaderIndicator

		local ReadyCheckIndicator = self:CreateTexture(nil, 'OVERLAY')
		ReadyCheckIndicator:SetPoint('TOPLEFT', self.Health)
		ReadyCheckIndicator:SetSize(16, 16)
		self.ReadyCheckIndicator = ReadyCheckIndicator

		local UpdateLFD = function(self, event)
			local lfdrole = self.GroupRoleIndicator
			local role = UnitGroupRolesAssigned(self.unit)

			if role == 'DAMAGER' then
				lfdrole:SetTextColor(1, .1, .1, 1)
				lfdrole:SetText('.')
			elseif role == 'TANK' then
				lfdrole:SetTextColor(.3, .4, 1, 1)
				lfdrole:SetText('x')
			elseif role == 'HEALER' then
				lfdrole:SetTextColor(0, 1, 0, 1)
				lfdrole:SetText('+')
			else
				lfdrole:SetTextColor(0, 0, 0, 0)
			end
		end

		local GroupRoleIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		GroupRoleIndicator:SetJustifyH('CENTER')
		GroupRoleIndicator:SetPoint('BOTTOM', self.Health, 1, 1)
		GroupRoleIndicator.Override = UpdateLFD
		self.GroupRoleIndicator = GroupRoleIndicator

		-- phase indicator
		local PhaseIndicator = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1,1,1}, {0,0,0}, 1, -1)
		PhaseIndicator:SetText('?')
		PhaseIndicator:SetJustifyH('RIGHT')
		PhaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -1)
		self.PhaseIndicator = PhaseIndicator

		-- summon indicator
		local summon = self:CreateTexture(nil, "OVERLAY")
		summon:SetSize(16, 16)
		summon:SetPoint("CENTER", 0, 0)
		self.SummonIndicator = summon
	end
end


-- Names
local function CreateName(self)
	local Name

	if C.GameClient == 'zhCN' or C.GameClient == 'zhTW' then
		Name = F.CreateFS(self.Health, C.font.normal, 11, nil, nil, {0, 0, 0}, 2, -2)
	else
		Name = F.CreateFS(self.Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
	end

	Name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	Name:SetWordWrap(false)
	Name:SetJustifyH('CENTER')
	Name:SetWidth(self:GetWidth())

	if self.unitStyle == 'target' then
		Name:ClearAllPoints()
		Name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		Name:SetJustifyH('RIGHT')
		Name:SetWidth(80)
	elseif self.unitStyle == 'boss' then
		Name:ClearAllPoints()
		Name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
		Name:SetJustifyH('LEFT')
		Name:SetWidth(100)
	elseif self.unitStyle == 'arena' then
		Name:ClearAllPoints()
		Name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
		Name:SetJustifyH('LEFT')
		Name:SetWidth(80)	
	end

	if self.unitStyle == 'arena' then
		self:Tag(Name, '[arenaspec] [name]')
	else
		self:Tag(Name, '[name]')
	end

	--self.Name = Name
end

local function CreatePartyName(self)
	local Text = F.CreateFS(self.Health, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
	Text:SetPoint('CENTER', 1, 0)
	Text:SetJustifyH('CENTER')
	self.Text = Text

	if C.unitframes.partyNameAlways then
		if C.GameClient == 'zhCN' or C.GameClient == 'zhTW' then
			Text:SetFont(C.font.normal, 11)
			Text:SetShadowOffset(2, -2)
		else
			F.SetFS(Name)
			Text:SetShadowOffset(1, -1)
		end

		self:Tag(Text, '[free:partyname]')
	elseif C.unitframes.partyMissingHealth then
		self:Tag(Text, '[free:missinghealth]')
		F.SetFS(Text)
	else
		self:Tag(Text, '[dead][offline]')
		F.SetFS(Text)
	end
end

local function UpdateName(self)
	local f = CreateFrame('Frame', nil, self)

	local tt

	if C.GameClient == 'zhCN' or C.GameClient == 'zhTW' then
		tt = F.CreateFS(self, C.font.normal, 11, nil, {1, 1, 1}, {0, 0, 0}, 2, -2)
	else
		tt = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', {1, 1, 1}, {0, 0, 0}, 1, -1)
	end

	tt:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	tt:SetJustifyH('CENTER')
	tt:SetWordWrap(false)
	tt:SetWidth(80)

	f:RegisterEvent('UNIT_TARGET')
	f:RegisterEvent('PLAYER_TARGET_CHANGED')
	f:RegisterEvent('PLAYER_FOCUS_CHANGED')

	f:SetScript('OnEvent', function()
		if self.unitStyle == 'targettarget' then
			if(UnitName('targettarget') == UnitName('player')) then
				tt:SetText('> YOU <')
				tt:SetTextColor(1, 0, 0)
			else
				tt:SetText(UnitName'targettarget')
				tt:SetTextColor(1, 1, 1)
			end
		elseif self.unitStyle == 'focustarget' then
			if(UnitName('focustarget')==UnitName('player')) then
				tt:SetText('> YOU <')
				tt:SetTextColor(1, 0, 0)
			else
				tt:SetText(UnitName'focustarget')
				tt:SetTextColor(1, 1, 1)
			end
		end
	end)
end


-- Threat
local function UpdateThreat(self, event, unit)
	if(self.unit ~= unit) then return end
	local status = UnitThreatSituation(unit)
	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		if self.sd then
			self.sd:SetBackdropBorderColor(r, g, b, .6)
		end
	else
		if self.sd then
			self.sd:SetBackdropBorderColor(0, 0, 0, .35)
		end
	end
end

function CreateThreatIndicator(self)
	if (not C.unitframes.threat) then return end

	local threat = {}
	threat.IsObjectType = function() end
	threat.Override = UpdateThreat
	self.ThreatIndicator = threat
end


-- Dispellable highlight
local function CreateDispellable(self, unit)
	if (not C.unitframes.dispellable) then return end

	local dispellable = {}

	local texture = self.Health:CreateTexture(nil, 'OVERLAY')
	texture:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	texture:SetBlendMode('ADD')
	texture:SetVertexColor(1, 1, 1, 0)
	texture:SetTexCoord(0, 1, .5, 1)
	texture:SetAllPoints()
	dispellable.dispelTexture = texture

	self.Dispellable = dispellable
end


-- Spell range
local function spellRange(self)
	if not C.unitframes.spellRange then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = C.unitframes.spellRangeAlpha
	}
end


-- Hide Blizz frames
if IsAddOnLoaded('Blizzard_CompactRaidFrames') then
	CompactRaidFrameManager:SetParent(FreeUIHider)
	CompactUnitFrameProfiles:UnregisterAllEvents()
end


-- Unit specific functions
local UnitSpecific = {
	pet = function(self, ...)
		self.unitStyle = 'pet'
		self:SetSize(C.unitframes.pet_width, C.unitframes.pet_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePortrait(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 6, 3)
		spellRange(self)
	end,

	player = function(self, ...)
		self.unitStyle = 'player'
		self:SetSize(C.unitframes.player_width, C.unitframes.player_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePowerText(self)
		CreatePortrait(self)
		CreateAltPower(self)
		CreateIndicator(self)
		CreateCastBar(self)
		spellRange(self)
		CreateDispellable(self, unit)
		if (C.PlayerClass == 'DEATHKNIGHT') then
			CreateRunesBar(self)
		else
			CreateClassPower(self)
		end

		FreeUI_LeaveVehicleButton:SetPoint('LEFT', self, 'RIGHT', 5, 0)
	end,

	target = function(self, ...)
		self.unitStyle = 'target'
		self:SetSize(C.unitframes.target_width, C.unitframes.target_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePowerText(self)
		ClassificationText(self)
		CreatePortrait(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 28, 7)
		spellRange(self)
	end,

	targettarget = function(self, ...)
		self.unitStyle = 'targettarget'
		self:SetSize(C.unitframes.targettarget_width, C.unitframes.targettarget_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		UpdateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		spellRange(self)
	end,

	focus = function(self, ...)
		self.unitStyle = 'focus'
		self:SetSize(C.unitframes.focus_width, C.unitframes.focus_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 8, 4)
		spellRange(self)
	end,

	focustarget = function(self, ...)
		self.unitStyle = 'focustarget'
		self:SetSize(C.unitframes.focustarget_width, C.unitframes.focustarget_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		UpdateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		spellRange(self)
	end,


	boss = function(self, ...)
		self.unitStyle = 'boss'
		self:SetSize(C.unitframes.boss_width, C.unitframes.boss_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreatePortrait(self)
		CreateName(self)
		CreateAltPower(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 15, 5)
		BorderColour(self)
	end,

	arena = function(self, ...)
		if not C.unitframes.enableArena then return end
		self.unitStyle = 'arena'
		self:SetSize(C.unitframes.arena_width, C.unitframes.arena_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 18, 6)
		spellRange(self)
	end,

	party = function(self, ...)
		self.unitStyle = 'party'

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePortrait(self)
		CreatePartyName(self)
		CreateIndicator(self)
		CreateThreatIndicator(self)
		CreateBuffs(self)
		CreateDebuffs(self)
		NameColour(self)
		BorderColour(self)
		CreateDispellable(self, unit)
		spellRange(self)
	end,

	raid = function(self, ...)
		self.unitStyle = 'raid'

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePartyName(self)
		CreateIndicator(self)
		CreateThreatIndicator(self)
		CreateBuffs(self)
		CreateDebuffs(self)
		NameColour(self)
		BorderColour(self)
		spellRange(self)
	end,
}


-- Register and activate style
for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle('Free - ' .. unit:gsub('^%l', string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Free - ' .. unit:gsub('^%l', string.upper))
	elseif(UnitSpecific[unit:match('[^%d]+')]) then -- boss1 -> boss
		self:SetActiveStyle('Free - ' .. unit:match('[^%d]+'):gsub('^%l', string.upper))
	else
		self:SetActiveStyle'Free'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end


oUF:Factory(function(self)
	if FreeUIConfig.layout == 2 then
		player = spawnHelper(self, 'player', unpack(C.unitframes.player_pos_healer))
		target = spawnHelper(self, 'target', unpack(C.unitframes.target_pos_healer))
		focus = spawnHelper(self, 'focus', unpack(C.unitframes.focus_pos_healer))
	else
		player = spawnHelper(self, 'player', unpack(C.unitframes.player_pos))
		target = spawnHelper(self, 'target', unpack(C.unitframes.target_pos))
		focus = spawnHelper(self, 'focus', unpack(C.unitframes.focus_pos))
	end

	pet = spawnHelper(self, 'pet', unpack(C.unitframes.pet_pos))
	targettarget = spawnHelper(self, 'targettarget', unpack(C.unitframes.targettarget_pos))
	focustarget = spawnHelper(self, 'focustarget', unpack(C.unitframes.focustarget_pos))

	if C.unitframes.enableFrameVisibility then
		player:Disable()
		RegisterStateDriver(player, 'visibility', C.unitframes.player_frameVisibility)
		pet:Disable()
		RegisterStateDriver(pet, 'visibility', C.unitframes.pet_frameVisibility)
	end

	if C.unitframes.enableBoss then
		local boss = {}
		for n = 1, MAX_BOSS_FRAMES do
			spawnHelper(self, 'boss' .. n, C.unitframes.boss_pos[1], C.unitframes.boss_pos[2], C.unitframes.boss_pos[3], C.unitframes.boss_pos[4], C.unitframes.boss_pos[5] + (80 * n))
		end
	end

	if C.unitframes.enableArena then
		local arena = {}
		for n = 1, 5 do
			spawnHelper(self, 'arena' .. n, C.unitframes.arena_pos[1], C.unitframes.arena_pos[2], C.unitframes.arena_pos[3], C.unitframes.arena_pos[4], C.unitframes.arena_pos[5] + (100 * n))
		end
	end


	if not C.unitframes.enableGroup then return end

	local party_xoffset, party_yoffset, party_point, party_columnAnchorPoint, party_height, party_width, party_pos, 
	raid_xoffset, raid_yoffset, raid_point, raid_pos

	if FreeUIConfig.layout == 2 then
		party_xoffset = C.unitframes.party_xoffset_healer
		party_yoffset = C.unitframes.party_yoffset_healer
		party_point = C.unitframes.party_point_healer
		party_columnAnchorPoint = C.unitframes.party_columnAnchorPoint_healer
		party_height = C.unitframes.party_height_healer
		party_width = C.unitframes.party_width_healer
		party_pos = C.unitframes.party_pos_healer
		raid_xoffset = C.unitframes.raid_xoffset_healer
		raid_yoffset = C.unitframes.raid_yoffset_healer
		raid_point = C.unitframes.raid_point_healer
		raid_pos = C.unitframes.raid_pos_healer
	else
		party_xoffset = C.unitframes.party_xoffset
		party_yoffset = C.unitframes.party_yoffset
		party_point = C.unitframes.party_point
		party_columnAnchorPoint = C.unitframes.party_columnAnchorPoint
		party_height = C.unitframes.party_height
		party_width = C.unitframes.party_width
		party_pos = C.unitframes.party_pos
		raid_xoffset = C.unitframes.raid_xoffset
		raid_yoffset = C.unitframes.raid_yoffset
		raid_point = C.unitframes.raid_point
		raid_pos = C.unitframes.raid_pos
	end

	self:SetActiveStyle'Free - Party'

	local party = self:SpawnHeader(nil, nil, 'solo,party',
		'showParty', true,
		'showPlayer', true,
		'showSolo', false,
		'xoffset', party_xoffset,
		'yoffset', party_yoffset,
		'maxColumns', 1,
		'unitsperColumn', 5,
		'columnSpacing', 0,
		'point', party_point,
		'columnAnchorPoint', party_columnAnchorPoint,
		--'groupBy', 'ASSIGNEDROLE',
		--'groupingOrder', 'TANK,HEALER,DAMAGER',
		--'sortDir', 'DESC',
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(party_height, party_width)
	):SetPoint(unpack(party_pos))


	self:SetActiveStyle'Free - Raid'

	local raid = self:SpawnHeader(nil, nil, 'raid',
		'showParty', false,
		'showRaid', true,
		'xoffset', raid_xoffset,
		'yOffset', raid_yoffset,
		'point', raid_point,
		'groupFilter', C.unitframes.raid_groupFilter,
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 4,
		'columnAnchorPoint', 'TOP',
		'sortMethod', 'INDEX',
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(C.unitframes.raid_height, C.unitframes.raid_width)
	):SetPoint(unpack(raid_pos))
end)

function module:OnLogin()
	local addonLoaded
	addonLoaded = function(_, addon)
		if addon ~= "FreeUI" then return end
		if FreeUIConfig.layout == nil then FreeUIConfig.layout = 1 end
		F:UnregisterEvent("ADDON_LOADED", addonLoaded)
		addonLoaded = nil
	end
	F:RegisterEvent("ADDON_LOADED", addonLoaded)

	self:Focuser()
	self:TargetSound()
end