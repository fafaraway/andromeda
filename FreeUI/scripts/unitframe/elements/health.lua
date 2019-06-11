local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe



local function PostUpdateHealth(health, unit, min, max)
	local self = health:GetParent()
	local r, g, b
	local reaction = self.colors.reaction[UnitReaction(unit, 'player') or 5]
	local offline = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	local style = health.__owner.unitStyle

	if tapped or offline then
		r, g, b = .6, .6, .6
	elseif UnitIsPlayer(unit) or style == 'pet' then
		local _, class = UnitClass(unit)
		if class then r, g, b = C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b else r, g, b = 1, 1, 1 end
	else
		r, g, b = unpack(reaction)
		--r, g, b = UnitSelectionColor(unit)
	end

	if cfg.transMode and self.Deficit then
		self.Deficit:SetMinMaxValues(0, max)
		self.Deficit:SetValue(max-min)

		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			--self.Deficit:Hide()
			self.Deficit:SetValue(0)
		else
			if cfg.colourSmooth or (cfg.colourSmooth_Boss and style == 'boss') or (cfg.colourSmooth_Raid and style == 'raid') then
				self.Deficit:GetStatusBarTexture():SetVertexColor(self:ColorGradient(min, max, unpack(self.colors.smooth)))
			else
				self.Deficit:GetStatusBarTexture():SetVertexColor(r, g, b)
			end

			--self.Deficit:Show()
		end
	end

	if tapped or offline then
		self.Gradient:SetGradientAlpha('VERTICAL', .6, .6, .6, .6, .4, .4, .4, .6)
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		self.Gradient:SetGradientAlpha('VERTICAL', .1, .1, .1, .6, 0, 0, 0, .6)
	else
		self.Gradient:SetGradientAlpha('VERTICAL', .3, .3, .3, .6, .2, .2, .2, .6)
	end
end

function module:AddHealthBar(self)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameStrata('LOW')
	health:SetStatusBarTexture(C.media.sbTex)
	health:GetStatusBarTexture():SetHorizTile(true)
	health:SetStatusBarColor(0, 0, 0, 0)
	health:SetPoint('TOP')
	health:SetPoint('LEFT')
	health:SetPoint('RIGHT')
	health:SetPoint('BOTTOM', 0, C.Mult + cfg.power_height)
	health:SetHeight(self:GetHeight() - cfg.power_height - C.Mult)
	F.SmoothBar(health)
	health.frequentUpdates = true

	self.Health = health

	local gradient = health:CreateTexture(nil, 'BACKGROUND')
	gradient:SetPoint('TOPLEFT')
	gradient:SetPoint('BOTTOMRIGHT')
	gradient:SetTexture(C.media.sbTex)

	self.Gradient = gradient


	if cfg.transMode then
		local deficit = CreateFrame('StatusBar', nil, self)
		deficit:SetFrameStrata('LOW')
		deficit:SetAllPoints(health)
		deficit:SetStatusBarTexture(C.media.sbTex)
		deficit:SetReverseFill(true)
		F.SmoothBar(deficit)

		self.Deficit = deficit
	else
		health.colorTapping = true
		health.colorDisconnected = true

		if cfg.colourSmooth or (cfg.colourSmooth_Boss and self.unitStyle == 'boss') or (cfg.colourSmooth_Raid and self.unitStyle == 'raid') then
			health.colorSmooth = true
		else
			health.colorClass = true
			health.colorReaction = true
			--health.colorSelection = true
		end
	end

	self.Health.PostUpdate = PostUpdateHealth
end