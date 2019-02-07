local F, C, L = unpack(select(2, ...))
if not C.unitframe.enable then return end

local module = F:RegisterModule('Unitframe')
local oUF, cast = FreeUI.oUF, FreeUI.cast
local cfg = C.unitframe
local min, max = math.min, math.max

function module:CreateBackDrop(self)
	local bd = CreateFrame('Frame', nil, self)
	bd:SetFrameStrata('BACKGROUND')
	bd:SetPoint('TOPLEFT', -C.Mult, C.Mult)
	bd:SetPoint('BOTTOMRIGHT', C.Mult, -C.Mult)
	bd:SetBackdrop({bgFile = C.media.backdrop, edgeFile = C.media.backdrop, edgeSize = C.Mult})
	bd:SetBackdropBorderColor(0, 0, 0, 1)
	if C.unitframe.transMode then
		bd:SetBackdropColor(.05, .05, .05, .25)
	else
		bd:SetBackdropColor(0, 0, 0, .45)
	end
	F.CreateTex(bd)
	self.bd = bd

	if C.appearance.addShadowBorder then
		local sd = CreateFrame('Frame', nil, bd)
		sd:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = 4})
		sd:SetPoint('TOPLEFT', -4*C.Mult, 4*C.Mult)
		sd:SetPoint('BOTTOMRIGHT', 4*C.Mult, -4*C.Mult)
		sd:SetBackdropBorderColor(0, 0, 0, .35)
		self.sd = sd
	end
end

function module:CreateHeader(self)
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


-- Sound stuff
function module:PLAYER_FOCUS_CHANGED()
	if UnitExists('focus') then
		if UnitIsEnemy('focus', 'player') then
			PlaySound('873')
		elseif UnitIsFriend('player', 'focus') then
			PlaySound('867')
		else
			PlaySound('871')
		end
	else
		PlaySound('684')
	end
end

function module:PLAYER_TARGET_CHANGED()
	if UnitExists('target') then
		if UnitIsEnemy('target', 'player') then
			PlaySound('873')
		elseif UnitIsFriend('player', 'target') then
			PlaySound('867')
		else
			PlaySound('871')
		end
	else
		PlaySound('684')
	end
end

local announcedPVP
function module:UNIT_FACTION(unit, ...)
	if unit ~= 'player' then return end

	if UnitIsPVPFreeForAll('player') or UnitIsPVP('player') then
		if not announcedPVP then
			announcedPVP = true
			PlaySound('4574')
		end
	else
		announcedPVP = nil
	end
end

function module:CreateSound()
	local f = CreateFrame('Frame')
	f:RegisterEvent('PLAYER_FOCUS_CHANGED')
	f:RegisterEvent('PLAYER_TARGET_CHANGED')
	f:RegisterEvent('UNIT_FACTION')
	f:SetScript('OnEvent', function(self, event, ...)
		module[event](module, ...)
	end)
end


-- Border colour
local function UpdateBorderColour(self)
	local frame = self:GetParent()
	if frame.unit then
		if UnitExists('target') and UnitIsUnit('target', frame.unit) then
			frame.bd:SetBackdropBorderColor(1, 1, 1)
		else
			frame.bd:SetBackdropBorderColor(0, 0, 0)
		end
	else
		frame.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

function module:CreateBorderColour(self)
	local f = CreateFrame('Frame', nil, self)
	f:RegisterEvent('PLAYER_TARGET_CHANGED')
	f:SetScript('OnEvent', UpdateBorderColour)
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

	if C.unitframe.transMode then
		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			self.Healthdef:Hide()
		else
			self.Healthdef:SetMinMaxValues(0, max)
			self.Healthdef:SetValue(max-min)

			if C.unitframe.healthClassColor then
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
			if C.unitframe.gradient then
				self.gradient:SetGradientAlpha('VERTICAL', .6, .6, .6, .6, .4, .4, .4, .6)
			else
				self.gradient:SetGradientAlpha('VERTICAL', .6, .6, .6, .6, .6, .6, .6, .6)
			end
		elseif UnitIsDead(unit) or UnitIsGhost(unit) then
			if C.unitframe.gradient then
				self.gradient:SetGradientAlpha('VERTICAL', .1, .1, .1, 1, .1, .1, .1, 1)
			end
		else
			if C.unitframe.gradient then
				self.gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .1, .1, .1, .6)
			else
				self.gradient:SetGradientAlpha('VERTICAL', .1, .1, .1, .6, .1, .1, .1, .6)
			end
		end
	else
		if UnitIsDead(unit) or UnitIsGhost(unit) then
			Health:SetValue(0)
		end

		if C.unitframe.gradient then
			Health:GetStatusBarTexture():SetGradient('VERTICAL', r, g, b, r/2, g/2, b/2)
		else
			Health:GetStatusBarTexture():SetGradient('VERTICAL', r, g, b, r, g, b)
		end
	end
end

function module:CreateHealthBar(self)
	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetFrameStrata('LOW')
	Health:SetStatusBarTexture(C.media.sbTex)
	Health:SetStatusBarColor(0, 0, 0, 0)

	Health.frequentUpdates = true
	F.SmoothBar(Health)

	Health:SetPoint('TOP')
	Health:SetPoint('LEFT')
	Health:SetPoint('RIGHT')
	Health:SetPoint('BOTTOM', 0, 1*C.Mult + C.unitframe.power_height)
	Health:SetHeight(self:GetHeight() - C.unitframe.power_height - 1*C.Mult)

	self.Health = Health
	Health.PostUpdate = PostUpdateHealth

	if C.unitframe.transMode then
		local gradient = Health:CreateTexture(nil, 'BACKGROUND')
		gradient:SetPoint('TOPLEFT')
		gradient:SetPoint('BOTTOMRIGHT')
		gradient:SetTexture(C.media.backdrop)

		if C.unitframe.gradient then
			gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .1, .1, .1, .6)
		else
			gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .3, .3, .3, .6)
		end

		self.gradient = gradient
	end

	if C.unitframe.transMode then
		local Healthdef = CreateFrame('StatusBar', nil, self)
		Healthdef:SetFrameStrata('LOW')
		--Healthdef:SetFrameLevel(self.Health:GetFrameLevel())
		Healthdef:SetAllPoints(self.Health)
		Healthdef:SetStatusBarTexture(C.media.sbTex)
		Healthdef:GetStatusBarTexture():SetBlendMode('BLEND')
		Healthdef:SetStatusBarColor(1, 1, 1)

		Healthdef:SetReverseFill(true)
		F.SmoothBar(Healthdef)

		self.Healthdef = Healthdef
	end
end

function module:CreateHealthPrediction(self)
	if not C.unitframe.prediction then return end

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
	absorbBar:SetStatusBarColor(.8, .8, .8, .8)
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

	if C.Class == 'DEMONHUNTER' and C.classmod.havocFury and self.unitStyle == 'player' then
		local spec, cp = GetSpecialization() or 0, UnitPower(unit)
		if spec == 1 and cp < 15 then
			Power:SetStatusBarColor(.5, .5, .5)
		elseif spec == 1 and cp < 40 then
			Power:SetStatusBarColor(1, 0, 0)
		end
	end

	Power.bg:SetVertexColor(0, 0, 0, .5)
end

function module:CreatePowerBar(self)
	local Power = CreateFrame('StatusBar', nil, self)
	Power:SetStatusBarTexture(C.media.sbTex)

	Power.frequentUpdates = true
	F.SmoothBar(Power)

	Power:SetHeight(C.unitframe.power_height)

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
	Power.bg:SetHeight(C.unitframe.power_height)
	Power.bg:SetPoint('LEFT')
	Power.bg:SetPoint('RIGHT')
	Power.bg:SetTexture(C.media.backdrop)
	Power.bg:SetVertexColor(0, 0, 0, .1)

	Power.colorReaction = true

	if C.unitframe.transMode then
		if self.unitStyle == 'player' and C.unitframe.powerTypeColor then
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

function module:CreateAltPower(self)
	local bar = CreateFrame('StatusBar', nil, self)
	bar:SetStatusBarTexture(C.media.sbTex)
	bar:SetPoint('BOTTOM', self, 0, -C.unitframe.altpower_height - 3)
	bar:SetSize(self:GetWidth(), C.unitframe.altpower_height)

	local abd = CreateFrame('Frame', nil, bar)
	abd:SetPoint('TOPLEFT', -1, 1)
	abd:SetPoint('BOTTOMRIGHT', 1, -1)
	abd:SetFrameLevel(bar:GetFrameLevel()-1)
	F.CreateBD(abd, .5)

	local text = F.CreateFS(bar, 'pixel', nil, '', 'CENTER', nil, true)
	text:SetPoint('BOTTOM', self, 'TOP', 0, 3)

	self:Tag(text, '[altpower]')

	F.SmoothBar(bar)

	bar:EnableMouse(true)

	self.AlternativePower = bar		
	self.AlternativePower.PostUpdate = PostUpdateAltPower
end


-- Health/Power/Classification text
function module:CreateHealthText(self)
	local HealthPoints = F.CreateFS(self.Health, 'pixel', nil, '', 'LEFT', nil, true)
	HealthPoints:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 3)
	
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

function module:CreatePowerText(self)
	local PowerText = F.CreateFS(self.Power, 'pixel', nil, '', 'RIGHT', nil, true)
	PowerText:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', 0, 3)

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

function module:ClassificationText(self)
	local Classification = F.CreateFS(self, 'pixel', nil, '', nil, nil, true)
	Classification:SetPoint('BOTTOMLEFT', self.Power.Text, 'BOTTOMRIGHT', 3, 0)
	self:Tag(Classification, '[free:classification]')

	self.Classification = Classification
end


-- Cast bar
function module:CreateCastBar(self)
	if not C.unitframe.castbar then return end

	local Castbar = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	Castbar:SetAllPoints(self)
	Castbar:SetStatusBarTexture(C.media.sbTex)
	Castbar:GetStatusBarTexture():SetBlendMode('BLEND')
	Castbar:SetStatusBarColor(0, 0, 0, 0)
	Castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
	self.Castbar = Castbar

	local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
	Spark:SetBlendMode('ADD')
	Spark:SetAlpha(.7)
	Spark:SetHeight(Castbar:GetHeight()*2)
	Castbar.Spark = Spark

	local Text
	if C.Client == 'zhCN' or C.Client == 'zhTW' then
		Text = F.CreateFS(Castbar, 11, nil, '', nil, nil, '2')
	else
		Text = F.CreateFS(Castbar, 'pixel', nil, '', nil, nil, true)
	end
	Text:SetPoint('CENTER', Castbar)
	Text:Hide()
	Castbar.Text = Text

	local Time = F.CreateFS(Castbar, 'pixel', nil, '', nil, nil, true)
	Time:SetPoint('BOTTOMRIGHT', Castbar, 'TOPRIGHT', 0, 6)
	Time:Hide()
	Castbar.Time = Time

	local iconFrame = CreateFrame('Frame', nil, Castbar)
	iconFrame:SetSize(self:GetHeight()+6, self:GetHeight()+6)
	if self.unitStyle == 'targettarget' or self.unitStyle == 'focus' then
		iconFrame:SetPoint('LEFT', self, 'RIGHT', 4, 0)
	else
		iconFrame:SetPoint('RIGHT', self, 'LEFT', -4, 0)
	end

	local Icon = iconFrame:CreateTexture(nil, 'OVERLAY')
	Icon:SetAllPoints(iconFrame)
	Icon:SetTexCoord(unpack(C.TexCoord))
	Castbar.Icon = Icon

	local iconBG = iconFrame:CreateTexture(nil, 'BACKGROUND')
	iconBG:SetPoint('TOPLEFT', -C.Mult , C.Mult)
	iconBG:SetPoint('BOTTOMRIGHT', C.Mult, -C.Mult)
	iconBG:SetTexture(C.media.backdrop)
	iconBG:SetVertexColor(0, 0, 0)
	Castbar.iconBG = iconBG

	local iconSD = CreateFrame('Frame', nil, iconFrame)
	iconSD:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = 4})
	iconSD:SetPoint('TOPLEFT', -4*C.Mult, 4*C.Mult)
	iconSD:SetPoint('BOTTOMRIGHT', 4*C.Mult, -4*C.Mult)
	iconSD:SetBackdropBorderColor(0, 0, 0, .35)
	Castbar.iconSD = iconSD

	if self.unitStyle == 'player' then
		local SafeZone = Castbar:CreateTexture(nil,'OVERLAY')
		SafeZone:SetTexture(C.media.backdrop)
		SafeZone:SetVertexColor(223/255, 63/255, 107/255, .6)
		SafeZone:SetPoint('TOPRIGHT')
		SafeZone:SetPoint('BOTTOMRIGHT')
		Castbar.SafeZone = SafeZone
	end

	if (self.unitStyle == 'player' and cfg.cbSeparate) or self.unitStyle == 'target' then
		if cfg.cbName then
			Text:Show()
		end
		if cfg.cbTimer then
			Time:Show()
		end

		local bg = CreateFrame('Frame', nil, Castbar)
		bg:SetPoint('TOPLEFT', -C.Mult, C.Mult)
		bg:SetPoint('BOTTOMRIGHT', C.Mult, -C.Mult)
		bg:SetFrameLevel(Castbar:GetFrameLevel()-1)

		F.CreateBD(bg)
		F.CreateTex(bg)
		F.CreateSD(bg)
	end

	if self.unitStyle == 'target' then
		Castbar:SetSize(cfg.target_cb_width*C.Mult, cfg.target_cb_height*C.Mult)
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', Castbar, 'LEFT', -4, 0)
		Spark:SetHeight(Castbar:GetHeight()*2)
		Time:SetPoint('TOPRIGHT', Castbar, 'BOTTOMRIGHT', 0, -6)
		Castbar:ClearAllPoints()
		F.Mover(Castbar, L['MOVER_UNITFRAME_TARGET_CASTBAR'], "TargetCastbar", cfg.target_cb_pos, cfg.target_cb_width, cfg.target_cb_height)
	end

	if self.unitStyle == 'player' and cfg.cbSeparate then
		Castbar:SetSize(cfg.player_cb_width*C.Mult, cfg.player_cb_height*C.Mult)
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', Castbar, 'LEFT', -4, 0)
		Spark:SetHeight(Castbar:GetHeight()*2)
		Castbar:ClearAllPoints()
		F.Mover(Castbar, L['MOVER_UNITFRAME_PLAYER_CASTBAR'], "PlayerCastbar", cfg.player_cb_pos, cfg.player_cb_width, cfg.player_cb_height)
	end

	Castbar.CastingColor = cfg.cbCastingColor
	Castbar.ChannelingColor = cfg.cbChannelingColor
	Castbar.notInterruptibleColor = cfg.cbnotInterruptibleColor
	Castbar.CompleteColor = cfg.cbCompleteColor
	Castbar.FailColor = cfg.cbFailColor

	Castbar.OnUpdate = cast.OnCastbarUpdate
	Castbar.PostCastStart = cast.PostCastStart
	Castbar.PostChannelStart = cast.PostCastStart
	Castbar.PostCastStop = cast.PostCastStop
	Castbar.PostChannelStop = cast.PostChannelStop
	Castbar.PostCastFailed = cast.PostCastFailed
	Castbar.PostCastInterrupted = cast.PostCastFailed
	Castbar.PostCastInterruptible = cast.PostUpdateInterruptible
	Castbar.PostCastNotInterruptible = cast.PostUpdateInterruptible
end


-- Aura stuff
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
	Duration:SetFont(C.font.pixel, 8, 'OUTLINEMONOCHROME')
	
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

	if canStealOrPurge and (element.__owner.unitStyle ~= 'party' or element.__owner.unitStyle ~= 'raid') then
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
		if (C.unitframe.debuffbyPlayer and button.isDebuff and not button.isPlayer) then
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

function module:CreateAuras(self, num, perrow)
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

function module:CreateBuffs(self)
	local Buffs = CreateFrame('Frame', nil, self)
	Buffs.initialAnchor = 'CENTER'
	Buffs:SetPoint('TOP', 0, -2)
	Buffs['growth-x'] = 'RIGHT'
	Buffs.spacing = 3
	Buffs.num = 3
	
	if self.unitStyle == 'party' then
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

function module:CreateDebuffs(self)
	local Debuffs = CreateFrame('Frame', nil, self)
	
	if self.unitStyle == 'party' then
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
		Debuffs:SetPoint('BOTTOM', 0, C.unitframe.power_height - 1)
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

function module:CreatePortrait(self)
	if not C.unitframe.portrait then return end

	local Portrait = CreateFrame('PlayerModel', nil, self)
	Portrait:SetAllPoints(self)
	Portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	Portrait:SetAlpha(C.unitframe.portraitAlpha)
	Portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = Portrait
end


-- Class power
local function PostUpdateClassPower(element, cur, max, diff, powerType)
	if(diff) then
		for index = 1, max do
			local Bar = element[index]
			local maxWidth, gap = C.unitframe.player_width, 3

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

function module:CreateClassPower(self)
	if not C.unitframe.classPower then return end

	local ClassPower = {}
	ClassPower.UpdateColor = UpdateClassPowerColor
	ClassPower.PostUpdate = PostUpdateClassPower

	for index = 1, 6 do 
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(C.unitframe.classPower_height)
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
		local maxWidth, gap = C.unitframe.player_width, 3
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

function module:CreateRunesBar(self)
	local Runes = {}
	local MaxRunes = 6

	for index = 1, MaxRunes do
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(C.unitframe.classPower_height)
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


-- Summon
local function UpdateSummon(self, event)
	local element = self.SummonIndicator
	local icon = element.Icon

	local status = C_IncomingSummon.IncomingSummonStatus(self.unit)
	if(status == Enum.SummonStatus.None) then
		element:Hide()
	else
		element:Show()

		if(status == Enum.SummonStatus.Pending) then
			icon:SetVertexColor(1, 1, 1)
			icon:SetDesaturated(false)
			element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_PENDING
		elseif(status == Enum.SummonStatus.Accepted) then
			icon:SetVertexColor(0, 1, 0)
			icon:SetDesaturated(true)
			element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_ACCEPTED
		elseif(status == Enum.SummonStatus.Declined) then
			icon:SetVertexColor(1, 0.3, 0.3)
			icon:SetDesaturated(true)
			element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_DECLINED
		end
	end
end

local function OnSummonEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
	GameTooltip:SetText(self.tooltip)
	GameTooltip:Show()
end


-- Indicator
function module:CreateIndicator(self)
	if self.unitStyle == 'player' then
		local PvPIndicator = F.CreateFS(self, 'pixel', nil, '', nil, nil, true)
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
		local statusText = F.CreateFS(self.Health, 'pixel', nil, '', nil, nil, true)
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
		local QuestIndicator = F.CreateFS(self, 'pixel', nil, '!', nil, 'yellow', true)
		QuestIndicator:SetPoint('BOTTOMLEFT', self.Classification, 'BOTTOMRIGHT', 3, 0)

		self.QuestIndicator = QuestIndicator
	end

	local RaidTargetIndicator = self.Health:CreateTexture()
	RaidTargetIndicator:SetTexture('Interface\\AddOns\\FreeUI\\assets\\UI-RaidTargetingIcons')
	RaidTargetIndicator:SetSize(16, 16)

	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		RaidTargetIndicator:SetPoint('CENTER', self, 'CENTER')
	elseif self.unitStyle == 'targettarget' then
		RaidTargetIndicator:SetPoint('LEFT', self, 'RIGHT', 3, 0)
	elseif self.unitStyle == 'focus' then
		RaidTargetIndicator:SetPoint('LEFT', self, 'RIGHT', 3, 0)
	elseif self.unitStyle == 'focustarget' then
		RaidTargetIndicator:SetPoint('RIGHT', self, 'LEFT', -3, 0)
	else
		RaidTargetIndicator:SetPoint('CENTER', self, 'CENTER', 0, 20)
	end

	self.RaidTargetIndicator = RaidTargetIndicator

	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		local ResurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
		ResurrectIndicator:SetSize(16, 16)
		ResurrectIndicator:SetPoint('CENTER')
		self.ResurrectIndicator = ResurrectIndicator

		local LeaderIndicator = F.CreateFS(self.Health, 'pixel', nil, 'L', 'LEFT', nil, true)
		LeaderIndicator:SetPoint('TOPLEFT', self.Health, 2, -2)
		self.LeaderIndicator = LeaderIndicator

		local ReadyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
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

		local GroupRoleIndicator = F.CreateFS(self.Health, 'pixel', nil, '', 'CENTER', nil, true)
		GroupRoleIndicator:SetPoint('BOTTOM', self.Health, 1, 1)
		GroupRoleIndicator.Override = UpdateLFD
		self.GroupRoleIndicator = GroupRoleIndicator

		local PhaseIndicator = F.CreateFS(self.Health, 'pixel', nil, '?', 'RIGHT', nil, true)
		PhaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -2)
		self.PhaseIndicator = PhaseIndicator

		local Summon = CreateFrame('Frame', nil, self.Health)
		Summon:SetPoint('CENTER', self.Health, 'CENTER')
		Summon:SetSize(32, 32)
		Summon:SetScript('OnLeave', GameTooltip_Hide)
		Summon:SetScript('OnEnter', OnSummonEnter)
		Summon.Override = UpdateSummon
		self.SummonIndicator = Summon

		local SummonIcon = Summon:CreateTexture(nil, 'OVERLAY')
		SummonIcon:SetAllPoints()
		SummonIcon:SetAtlas('Raid-Icon-SummonPending')
		Summon.Icon = SummonIcon
	end
end


-- Name
function module:CreateName(self)
	local Name
	local f = CreateFrame('Frame', nil, self)
	f:RegisterEvent('UNIT_TARGET')
	f:RegisterEvent('PLAYER_TARGET_CHANGED')
	f:RegisterEvent('PLAYER_FOCUS_CHANGED')

	if C.Client == 'zhCN' or C.Client == 'zhTW' then
		Name = F.CreateFS(self.Health, 11, nil, '', nil, nil, '2')
	else
		Name = F.CreateFS(self.Health, 'pixel', nil, '', nil, nil, true)
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

	f:SetScript('OnEvent', function()
		if self.unitStyle == 'targettarget' then
			if(UnitName('targettarget') == UnitName('player')) then
				Name:SetText('|cffff0000> YOU <|r')
			else
				Name:SetText(UnitName'targettarget')
			end
		elseif self.unitStyle == 'focustarget' then
			if(UnitName('focustarget') == UnitName('player')) then
				Name:SetText('|cffff0000> YOU <|r')
			else
				Name:SetText(UnitName'focustarget')
			end
		else
			self:Tag(Name, '[name]')
		end
	end)

	self.Name = Name

	if self.unitStyle == 'arena' then
		local ArenaSpec
		if C.Client == 'zhCN' or C.Client == 'zhTW' then
			ArenaSpec = F.CreateFS(self.Health, 11, nil, '', nil, nil, '2')
		else
			ArenaSpec = F.CreateFS(self.Health, 'pixel', nil, '', nil, nil, true)
		end

		ArenaSpec:SetPoint('BOTTOM', self, 'TOP', 0, 3)
		ArenaSpec:SetJustifyH('CENTER')
		ArenaSpec:SetWidth(80)

		self:Tag(ArenaSpec, '[arenaspec]')
	end
end

function module:CreatePartyName(self)
	local Text

	if C.unitframe.partyNameAlways then
		if C.Client == 'zhCN' or C.Client == 'zhTW' then
			Text = F.CreateFS(self.Health, 11, nil, '', nil, nil, true, 'CENTER', 1, 0)
		else
			Text = F.CreateFS(self.Health, 'pixel', nil, '', nil, nil, true, 'CENTER', 1, 0)
		end
		self:Tag(Text, '[free:partyname]')
	else
		Text = F.CreateFS(self.Health, 'pixel', nil, '', nil, nil, true, 'CENTER', 1, 0)
		self:Tag(Text, '[free:partytext]')
	end

	
	Text:SetJustifyH('CENTER')
	self.Text = Text
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

function module:CreateThreatIndicator(self)
	if (not C.unitframe.threat) then return end

	local threat = {}
	threat.IsObjectType = function() end
	threat.Override = UpdateThreat
	self.ThreatIndicator = threat
end


-- Dispellable highlight
function module:CreateDispellable(self, unit)
	if (not C.unitframe.dispellable) then return end

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
function module:CreateSpellRange(self)
	if not C.unitframe.spellRange then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = C.unitframe.spellRangeAlpha
	}
end

-- Hide Blizz frames
function module:HideBlizzRaidFrame()
	if IsAddOnLoaded('Blizzard_CompactRaidFrames') then
		CompactRaidFrameManager:SetParent(FreeUIHider)
		CompactUnitFrameProfiles:UnregisterAllEvents()
	end
end