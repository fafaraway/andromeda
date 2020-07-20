local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function PostUpdateHealth(health, unit, min, max)
	local self = health:GetParent()
	local r, g, b
	local reaction = F.oUF.colors.reaction[UnitReaction(unit, 'player') or 5]
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

	if cfg.transparency and self.Deficit then
		self.Deficit:SetMinMaxValues(0, max)
		self.Deficit:SetValue(max-min)

		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			--self.Deficit:Hide()
			self.Deficit:SetValue(0)
		else
			if cfg.color_smooth or (cfg.boss_color_smooth and style == 'boss') or (cfg.group_color_smooth and style == 'raid') then
				self.Deficit:GetStatusBarTexture():SetVertexColor(self:ColorGradient(min, max, unpack(self.colors.smooth)))
			else
				self.Deficit:GetStatusBarTexture():SetVertexColor(r, g, b)
			end

			--self.Deficit:Show()
		end
	end

	if tapped or offline then
		self.Bg:SetBackdropColor(.4, .4, .4, .6)
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		self.Bg:SetBackdropColor(0, 0, 0, .6)
	else
		self.Bg:SetBackdropColor(.2, .2, .2, .6)
	end
end

function UNITFRAME:AddHealthBar(self)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameStrata('LOW')
	health:SetStatusBarTexture(C.Assets.Textures.statusbar)
	health:GetStatusBarTexture():SetHorizTile(true)
	health:SetStatusBarColor(0, 0, 0, 0)
	health:SetPoint('TOP')
	health:SetPoint('LEFT')
	health:SetPoint('RIGHT')
	health:SetPoint('BOTTOM', 0, C.Mult + cfg.power_bar_height)
	health:SetHeight(self:GetHeight() - cfg.power_bar_height - C.Mult)
	F:SmoothBar(health)
	health.frequentUpdates = true

	self.Health = health

	if cfg.transparency then
		local deficit = CreateFrame('StatusBar', nil, self)
		deficit:SetFrameStrata('LOW')
		deficit:SetAllPoints(health)
		deficit:SetStatusBarTexture(C.Assets.Textures.statusbar)
		deficit:SetReverseFill(true)
		F:SmoothBar(deficit)

		self.Deficit = deficit
	else
		health.colorTapping = true
		health.colorDisconnected = true

		if cfg.color_smooth or (cfg.boss_color_smooth and self.unitStyle == 'boss') or (cfg.group_color_smooth and self.unitStyle == 'raid') then
			health.colorSmooth = true
		else
			health.colorClass = true
			health.colorReaction = true
			--health.colorSelection = true
		end
	end

	self.Health.PostUpdate = PostUpdateHealth
end