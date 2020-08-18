local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local oUF = F.oUF


-- Health
local function PostUpdateHealth(health, unit, min, max)
	local self = health:GetParent()
	local r, g, b
	local reaction = oUF.colors.reaction[UnitReaction(unit, 'player') or 5]
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

	if FreeUIConfigs.unitframe.transparency and self.Deficit then
		self.Deficit:SetMinMaxValues(0, max)
		self.Deficit:SetValue(max-min)

		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			--self.Deficit:Hide()
			self.Deficit:SetValue(0)
		else
			if FreeUIConfigs.unitframe.color_smooth or (FreeUIConfigs.unitframe.boss_color_smooth and style == 'boss') or (FreeUIConfigs.unitframe.group_color_smooth and style == 'raid') then
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
	health:SetStatusBarTexture(C.Assets.norm_tex)
	health:GetStatusBarTexture():SetHorizTile(true)
	health:SetStatusBarColor(0, 0, 0, 0)
	health:SetPoint('TOP')
	health:SetPoint('LEFT')
	health:SetPoint('RIGHT')
	health:SetPoint('BOTTOM', 0, C.Mult + FreeUIConfigs.unitframe.power_bar_height)
	health:SetHeight(self:GetHeight() - FreeUIConfigs.unitframe.power_bar_height - C.Mult)
	F:SmoothBar(health)
	health.frequentUpdates = true

	self.Health = health

	if FreeUIConfigs.unitframe.transparency then
		local deficit = CreateFrame('StatusBar', nil, self)
		deficit:SetFrameStrata('LOW')
		deficit:SetAllPoints(health)
		deficit:SetStatusBarTexture(C.Assets.norm_tex)
		deficit:SetReverseFill(true)
		F:SmoothBar(deficit)

		self.Deficit = deficit
	else
		health.colorTapping = true
		health.colorDisconnected = true

		if FreeUIConfigs.unitframe.color_smooth or (FreeUIConfigs.unitframe.boss_color_smooth and self.unitStyle == 'boss') or (FreeUIConfigs.unitframe.group_color_smooth and self.unitStyle == 'raid') then
			health.colorSmooth = true
		else
			health.colorClass = true
			health.colorReaction = true
			--health.colorSelection = true
		end
	end

	self.Health.PostUpdate = PostUpdateHealth
end

-- Health prediction
function UNITFRAME:AddHealthPrediction(self)
	if FreeUIConfigs.unitframe.heal_prediction then
		local myBar = CreateFrame('StatusBar', nil, self.Health)
		myBar:SetPoint('TOP')
		myBar:SetPoint('BOTTOM')
		myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		myBar:SetStatusBarTexture(C.Assets.norm_tex)
		myBar:GetStatusBarTexture():SetBlendMode('BLEND')
		myBar:SetStatusBarColor(0, .8, .8, .6)
		myBar:SetWidth(self:GetWidth())

		local otherBar = CreateFrame('StatusBar', nil, self.Health)
		otherBar:SetPoint('TOP')
		otherBar:SetPoint('BOTTOM')
		otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), 'RIGHT')
		otherBar:SetStatusBarTexture(C.Assets.norm_tex)
		otherBar:GetStatusBarTexture():SetBlendMode('BLEND')
		otherBar:SetStatusBarColor(0, .6, .6, .6)
		otherBar:SetWidth(self:GetWidth())

		local absorbBar = CreateFrame('StatusBar', nil, self.Health)
		absorbBar:SetPoint('TOP')
		absorbBar:SetPoint('BOTTOM')
		absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), 'RIGHT')
		absorbBar:SetStatusBarTexture(C.Assets.stripe_tex)
		absorbBar:GetStatusBarTexture():SetBlendMode('BLEND')
		absorbBar:SetStatusBarColor(.8, .8, .8, .8)
		absorbBar:SetWidth(self:GetWidth())

		self.HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			absorbBar = absorbBar,
			maxOverflow = 1,
			frequentUpdates = true,
		}
	end

	if FreeUIConfigs.unitframe.over_absorb then
		local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
		overAbsorb:SetPoint('TOP', 0, 2)
		overAbsorb:SetPoint('BOTTOM', 0, -2)
		overAbsorb:SetPoint('LEFT', self.Health, 'RIGHT', -4, 0)
		if self.unitStyle == 'party' or self.unitStyle == 'raid' then
			overAbsorb:SetWidth(8)
		else
			overAbsorb:SetWidth(14)
		end
		self.HealthPrediction['overAbsorb'] = overAbsorb
	end
end

-- Power
local function PostUpdatePower(power, unit, cur, max, min)
	local self = power:GetParent()
	local style = self.unitStyle

	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end

	if C.MyClass == 'DEMONHUNTER' and C.classmod.havocFury and style == 'player' then
		local spec, cp = GetSpecialization() or 0, UnitPower(unit)
		if spec == 1 and cp < 15 then
			power:SetStatusBarColor(.5, .5, .5)
		elseif spec == 1 and cp < 40 then
			power:SetStatusBarColor(1, 0, 0)
		end
	end
end

function UNITFRAME:AddPowerBar(self)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('LEFT')
	power:SetPoint('RIGHT')
	power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
	power:SetStatusBarTexture(C.Assets.norm_tex)
	power:SetHeight(FreeUIConfigs.unitframe.power_bar_height)
	F:SmoothBar(power)
	power.frequentUpdates = true

	self.Power = power

	local line = power:CreateTexture(nil, 'OVERLAY')
	line:SetHeight(C.Mult)
	line:SetPoint('TOPLEFT', 0, C.Mult)
	line:SetPoint('TOPRIGHT', 0, C.Mult)
	line:SetTexture(C.Assets.bd_tex)
	line:SetVertexColor(0, 0, 0)

	local bg = power:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints()
	bg:SetTexture(C.Assets.bd_tex)
	bg.multiplier = .2
	power.bg = bg

	power.colorTapping = true
	power.colorDisconnected = true
	power.colorReaction = true
	--power.colorSelection = true

	if self.unitStyle == 'pet' then
		power.colorPower = true
	elseif FreeUIConfigs.unitframe.transparency then
		if self.unitStyle == 'player' then
			power.colorPower = true
		else
			power.colorClass = true
		end
	else
		power.colorPower = true
	end

	self.Power.PostUpdate = PostUpdatePower
end

-- Alternative power
local function altPowerOnEnter(altPower)
	if (not altPower:IsVisible()) then return end

	GameTooltip:SetOwner(altPower, 'ANCHOR_BOTTOMRIGHT')
	altPower:UpdateTooltip()
end

local function UpdateTooltip(altPower)
	local value = altPower:GetValue()
	local min, max = altPower:GetMinMaxValues()
	GameTooltip:SetText(altPower.powerName, 1, 1, 1)
	GameTooltip:AddLine(altPower.powerTooltip, nil, nil, nil, true)
	GameTooltip:AddLine(format('\n%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
	GameTooltip:Show()
end

local function PostUpdateAltPower(element, _, cur, _, max)
	if cur and max then
		local self = element.__owner
		local value = self.AlternativePowerValue
		local r, g, b = ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)

		element:SetStatusBarColor(r, g, b)
		value:SetTextColor(r, g, b)

		--[[ local perc = math.floor((cur/max)*100)
		if perc < 35 then
			element:SetStatusBarColor(0, 1, 0)
			value:SetTextColor(0, 1, 0)
		elseif perc < 70 then
			element:SetStatusBarColor(1, 1, 0)
			value:SetTextColor(1, 1, 0)
		else
			element:SetStatusBarColor(1, 0, 0)
			value:SetTextColor(1, 0, 0)
		end ]]
	end
end

function UNITFRAME:AddAlternativePowerBar(self)
	local altPower = CreateFrame('StatusBar', nil, self)
	altPower:SetStatusBarTexture(C.Assets.norm_tex)
	altPower:Point('TOP', self.Power, 'BOTTOM', 0, -2)
	altPower:Size(self:GetWidth(), FreeUIConfigs.unitframe.alternative_power_height)
	altPower:EnableMouse(true)
	F:SmoothBar(altPower)
	altPower.bg = F.CreateBDFrame(altPower)

	altPower.UpdateTooltip = UpdateTooltip
	altPower:SetScript('OnEnter', altPowerOnEnter)

	self.AlternativePower = altPower
	self.AlternativePower.PostUpdate = PostUpdateAltPower
end

-- Auras
local function AuraOnEnter(self)
	if not self:IsVisible() then return end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
	self:UpdateTooltip()
end

local function AuraOnLeave()
	GameTooltip:Hide()
end

local function UpdateAuraTooltip(aura)
	GameTooltip:SetUnitAura(aura:GetParent().__owner.unit, aura:GetID(), aura.filter)
end

local function PostCreateIcon(element, button)
	button.bg = F.CreateBDFrame(button)
	button.glow = F.CreateSD(button.bg, .35, 2, 2)

	element.disableCooldown = true
	button:SetFrameLevel(element:GetFrameLevel() + 4)

	button.overlay:SetTexture(nil)
	button.stealable:SetTexture(nil)
	button.cd:SetReverse(true)
	button.icon:SetDrawLayer('ARTWORK')
	button.icon:SetTexCoord(.08, .92, .25, .85)

	button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
	button.HL:SetColorTexture(1, 1, 1, .25)
	button.HL:SetAllPoints()

	button.count = button:CreateFontString(nil, 'OVERLAY')
	button.count:ClearAllPoints()
	button.count:SetPoint('TOPRIGHT', button, 2, 4)
	F.SetFS(button.count, C.Assets.Fonts.Number, 11, 'OUTLINE')

	button.timer = button:CreateFontString(nil, 'OVERLAY')
	button.timer:ClearAllPoints()
	button.timer:SetPoint('BOTTOMLEFT', button, 2, -4)
	F.SetFS(button.timer, C.Assets.Fonts.Number, 11, 'OUTLINE')

	button.UpdateTooltip = UpdateAuraTooltip
	button:SetScript('OnEnter', AuraOnEnter)
	button:SetScript('OnLeave', AuraOnLeave)
	button:SetScript('OnClick', function(self, button)
		if not InCombatLockdown() and button == 'RightButton' then
			CancelUnitBuff('player', self:GetID(), self.filter)
		end
	end)
end

local function PostUpdateIcon(element, unit, button, index, _, duration, _, debuffType)
	local style = element.__owner.unitStyle
	local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)

	if not (style == 'party' and button.isDebuff) then
		button:SetSize(element.size, element.size*.75)
	end

	if duration and duration > 0 then
		button.expiration = expiration
		button:SetScript('OnUpdate', F.CooldownOnUpdate)
		button.timer:Show()
	else
		button:SetScript('OnUpdate', nil)
		button.timer:Hide()
	end

	if (style == 'party' and not button.isDebuff) or style == 'raid' or style == 'pet' then
		button.timer:Hide()
	end

	if canStealOrPurge and (style ~= 'party' or style ~= 'raid') then
		button.bg:SetBackdropColor(1, 1, 1)

		if button.glow then
			button.glow:SetBackdropBorderColor(1, 1, 1, .5)
		end
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuffType[debuffType] or oUF.colors.debuffType.none
		button.bg:SetBackdropColor(color[1], color[2], color[3])

		if button.glow then
			button.glow:SetBackdropBorderColor(color[1], color[2], color[3], .5)
		end
	elseif (style == 'party' or style == 'raid') and not button.isDebuff then
		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, 0)
		end
	else
		button.bg:SetBackdropColor(0, 0, 0)

		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, .35)
		end
	end

	if (button.isDebuff and not button.isPlayer) and (style == 'target' or style == 'boss' or style == 'arena') then
		button.icon:SetDesaturated(true)
	else
		button.icon:SetDesaturated(false)
	end

	if duration then
		button.bg:Show()

		if button.glow then
			button.glow:Show()
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
	elseif style == 'player' and FreeUIConfigs.unitframe.player_auras then
		if C.ClassBuffs['ALL'][spellID] or C.ClassBuffs[C.MyClass][spellID] then
			return true
		else
			return false
		end
	elseif style == 'target' and FreeUIConfigs.unitframe.target_auras then
		if FreeUIConfigs.unitframe.debuff_by_player and button.isDebuff and not button.isPlayer then
			return false
		else
			return true
		end
	elseif style == 'boss' and FreeUIConfigs.unitframe.bossShowAuras then
		if FreeUIConfigs.unitframe.debuff_by_player and button.isDebuff and not button.isPlayer then
			return false
		else
			return true
		end
	elseif style == 'party' or style == 'raid' then
		if button.isDebuff and not C.IgnoredDebuffs[spellID] then
			return true
		elseif C.GroupBuffs[spellID] then
			return true
		else
			return false
		end
	elseif style == 'focus' and FreeUIConfigs.unitframe.focus_auras then
		if button.isDebuff and button.isPlayer then
			return true
		else
			return false
		end
	elseif style == 'arena' and FreeUIConfigs.unitframe.arenaShowAuras then
		return true
	elseif style == 'pet' and FreeUIConfigs.unitframe.pet_auras then
		return true
	end
end

local function PostUpdateGapIcon(self, unit, icon, visibleBuffs)
	icon:Hide()
end

local function AuraIconSize(width, num, spacing)
	return (width - (num - 1) * spacing) / num
end

function UNITFRAME:AddAuras(self)
	local style = self.unitStyle
	local auras = CreateFrame('Frame', nil, self)

	if style == 'player' or style == 'target' then
		auras.initialAnchor = 'BOTTOMLEFT'
		auras:SetPoint('BOTTOM', self, 'TOP', 0, 24)
		auras['growth-y'] = 'UP'
		auras['spacing-x'] = 5

		auras.numTotal = (style == 'player' and FreeUIConfigs.unitframe.player_auras_number) or FreeUIConfigs.unitframe.target_auras_number
		auras.iconsPerRow = (style == 'player' and FreeUIConfigs.unitframe.player_auras_number_per_row) or FreeUIConfigs.unitframe.target_auras_number_per_row
	elseif style == 'pet' or style == 'focus' or style == 'boss' or style == 'arena' then
		auras.initialAnchor = 'TOPLEFT'
		auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		auras['growth-y'] = 'DOWN'
		auras['spacing-x'] = 5

		if style == 'pet' then
			auras.numTotal = FreeUIConfigs.unitframe.pet_auras_number
			auras.iconsPerRow = FreeUIConfigs.unitframe.pet_auras_number_per_row
		elseif style == 'focus' then
			auras.numTotal = FreeUIConfigs.unitframe.focus_auras_number
			auras.iconsPerRow = FreeUIConfigs.unitframe.focus_auras_number_per_row
		elseif style == 'boss' then
			auras.numTotal = FreeUIConfigs.unitframe.bossAuraTotal
			auras.iconsPerRow = FreeUIConfigs.unitframe.bossAuraPerRow
		elseif style == 'arena' then
			auras.numTotal = FreeUIConfigs.unitframe.arenaAuraTotal
			auras.iconsPerRow = FreeUIConfigs.unitframe.arenaAuraPerRow
		end
	end

	auras.size = AuraIconSize(self:GetWidth(), auras.iconsPerRow, auras['spacing-x'])
	auras:SetWidth(self:GetWidth())
	auras:SetHeight((auras.size) * F:Round(auras.numTotal / auras.iconsPerRow))

	auras.gap = true
	auras.showDebuffType = true
	auras.showStealableBuffs = true
	auras.CustomFilter = CustomFilter
	auras.PostCreateIcon = PostCreateIcon
	auras.PostUpdateIcon = PostUpdateIcon
	auras.PostUpdateGapIcon = PostUpdateGapIcon
	auras.PreUpdate = BolsterPreUpdate
	auras.PostUpdate = BolsterPostUpdate

	self.Auras = auras
end

function UNITFRAME:AddBuffs(self)
	local style = self.unitStyle
	local buffs = CreateFrame('Frame', nil, self)

	buffs.initialAnchor = 'CENTER'
	buffs['growth-x'] = 'RIGHT'
	buffs.spacing = 3
	buffs.num = 2

	if style == 'party' then
		buffs.size = 18
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 2 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -((buffs.size + buffs.spacing)/2), -2)
			else
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	else
		buffs.size = 12
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 2 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -((buffs.size + buffs.spacing)/2), -2)
			else
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	end

	buffs:SetSize((buffs.size * buffs.num) + (buffs.num - 1) * buffs.spacing, buffs.size)

	buffs.disableCooldown = true
	buffs.disableMouse = true
	buffs.PostCreateIcon = PostCreateIcon
	buffs.PostUpdateIcon = PostUpdateIcon
	buffs.CustomFilter = CustomFilter

	self.Buffs = buffs
end

function UNITFRAME:AddDebuffs(self)
	local style = self.unitStyle
	local debuffs = CreateFrame('Frame', nil, self)

	if style == 'party' and not FreeUIConfigs.unitframe.symmetry then
		debuffs.initialAnchor = 'LEFT'
		debuffs['growth-x'] = 'RIGHT'
		debuffs:SetPoint('LEFT', self, 'RIGHT', 6, 0)
		debuffs.size = 24
		debuffs.num = 4
		debuffs.disableCooldown = false
		debuffs.disableMouse = false
	else
		debuffs.initialAnchor = 'CENTER'
		debuffs['growth-x'] = 'RIGHT'
		debuffs:SetPoint('BOTTOM', 0, FreeUIConfigs.unitframe.power_bar_height - 1)
		debuffs.size = 16
		debuffs.num = 2
		debuffs.disableCooldown = true
		debuffs.disableMouse = true

		debuffs.PostUpdate = function(icons)
			if icons.visibleDebuffs == 2 then
				debuffs:ClearAllPoints()
				debuffs:SetPoint('BOTTOM', -9, 0)
			else
				debuffs:ClearAllPoints()
				debuffs:SetPoint('BOTTOM')
			end
		end
	end

	debuffs.spacing = 5
	debuffs:SetSize((debuffs.size * debuffs.num) + (debuffs.num -1 ) * debuffs.spacing, debuffs.size)
	debuffs.showDebuffType = true
	debuffs.PostCreateIcon = PostCreateIcon
	debuffs.PostUpdateIcon = PostUpdateIcon
	debuffs.CustomFilter = CustomFilter

	self.Debuffs = debuffs
end

-- Aura watch
local CornerBuffsAnchor = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

function UNITFRAME:CreateCornerBuffIcon(icon)
	F.CreateBDFrame(icon)
	icon.icon:Point('TOPLEFT', 1, -1)
	icon.icon:Point('BOTTOMRIGHT', -1, 1)
	icon.icon:SetTexCoord(unpack(C.TexCoord))
	icon.icon:SetDrawLayer('ARTWORK')

	if (icon.cd) then
		icon.cd:SetHideCountdownNumbers(true)
		icon.cd:SetReverse(true)
	end

	icon.overlay:SetTexture()
end

function UNITFRAME:AddCornerBuff(self)
	if not FreeUIConfigs.unitframe.corner_buffs then return end

	local Auras = CreateFrame('Frame', nil, self)
	Auras:SetPoint('TOPLEFT', self.Health, 2, -2)
	Auras:SetPoint('BOTTOMRIGHT', self.Health, -2, 2)
	Auras:SetFrameLevel(self.Health:GetFrameLevel() + 5)
	Auras.presentAlpha = 1
	Auras.missingAlpha = 0
	Auras.icons = {}
	Auras.PostCreateIcon = UNITFRAME.CreateCornerBuffIcon
	Auras.strictMatching = true
	Auras.hideCooldown = true

	local buffs = {}

	if (C.CornerBuffs['ALL']) then
		for key, value in pairs(C.CornerBuffs['ALL']) do
			tinsert(buffs, value)
		end
	end

	if (C.CornerBuffs[C.MyClass]) then
		for key, value in pairs(C.CornerBuffs[C.MyClass]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for key, spell in pairs(buffs) do
			local Icon = CreateFrame('Frame', nil, Auras)
			Icon.spellID = spell[1]
			Icon.anyUnit = spell[4]
			Icon:Size(6)
			Icon:SetPoint(spell[2], 0, 0)

			local Texture = Icon:CreateTexture(nil, 'OVERLAY')
			Texture:SetAllPoints(Icon)
			Texture:SetTexture(C.Assets.bd_tex)

			if (spell[3]) then
				Texture:SetVertexColor(unpack(spell[3]))
			else
				Texture:SetVertexColor(0.8, 0.8, 0.8)
			end

			local Count = F.CreateFS(Icon, C.Assets.Fonts.Number, 11, 'OUTLINE')
			Count:SetPoint('CENTER', unpack(CornerBuffsAnchor[spell[2]]))
			Icon.count = Count

			Auras.icons[spell[1]] = Icon
		end
	end

	self.AuraWatch = Auras
end

-- Debuff highlight
function UNITFRAME:AddDebuffHighlight(self)
	if not FreeUIConfigs.unitframe.debuff_highlight then return end

	self.DebuffHighlight = self:CreateTexture(nil, 'OVERLAY')
    self.DebuffHighlight:SetAllPoints(self)
    self.DebuffHighlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
    self.DebuffHighlight:SetTexCoord(0, 1, .5, 1)
    self.DebuffHighlight:SetVertexColor(.6, .6, .6, 0)
    self.DebuffHighlight:SetBlendMode('ADD')
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = true
end

-- Raid debuffs
function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then print('Invalid instance ID: '..instID) return end

	if not C.RaidDebuffs[instName] then C.RaidDebuffs[instName] = {} end
	if not level then level = 2 end
	if level > 6 then level = 6 end

	C.RaidDebuffs[instName][spellID] = level
end

local function buttonOnEnter(self)
	if not self.index then return end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:ClearLines()
	GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
	GameTooltip:Show()
end

function UNITFRAME:AddRaidDebuffs(self)
	if not FreeUIConfigs.unitframe.raid_debuffs then return end

	local bu = CreateFrame('Frame', nil, self)
	bu:Size(self:GetHeight() * .6)
	bu:SetPoint('CENTER')
	bu:SetFrameLevel(self.Health:GetFrameLevel() + 6)
	bu.bg = F.CreateBDFrame(bu)
	bu.glow = F.CreateSD(bu.bg, .35)
	bu:Hide()

	bu.icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.icon:SetAllPoints()
	bu.icon:SetTexCoord(unpack(C.TexCoord))
	bu.count = F.CreateFS(bu, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, nil, 'TOPRIGHT', 2, 4)
	bu.timer = F.CreateFS(bu, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, nil, 'BOTTOMLEFT', 2, -4)

	if not FreeUIConfigs.unitframe.raid_debuffs_click_through then
		bu:SetScript('OnEnter', buttonOnEnter)
		bu:SetScript('OnLeave', F.HideTooltip)
	end

	bu.ShowDispellableDebuff = true
	bu.ShowDebuffBorder = true
	bu.FilterDispellableDebuff = true

	bu.Debuffs = C.RaidDebuffs

	self.RaidDebuffs = bu
end

-- Castbar
local function GetSpellName(spellID)
	local name = GetSpellInfo(spellID)
	if not name then
		print('oUF-Plugins-Castbar: '.. spellID..' not found.')
		return 0
	end
	return name
end

local channelingTicks = {
	[GetSpellName(740)] = 4,		-- 宁静
	[GetSpellName(755)] = 3,		-- 生命通道
	[GetSpellName(5143)] = 5, 		-- 奥术飞弹
	[GetSpellName(12051)] = 3, 		-- 唤醒
	[GetSpellName(15407)] = 4,		-- 精神鞭笞
	[GetSpellName(47540)] = 3,		-- 苦修
	[GetSpellName(64843)] = 4,		-- 神圣赞美诗
	[GetSpellName(198590)] = 5,		-- 吸取灵魂
	[GetSpellName(205021)] = 5,		-- 冰霜射线
	[GetSpellName(205065)] = 6,		-- 虚空洪流
	[GetSpellName(234153)] = 5,		-- 吸取生命
	[GetSpellName(291944)] = 6,		-- 再生
}

if C.MyClass == 'PRIEST' then
	local penance = GetSpellName(47540)
	local function updateTicks()
		local numTicks = 3
		if IsPlayerSpell(193134) then numTicks = 4 end	-- Enhanced Mind Flay
		channelingTicks[penance] = numTicks
	end
	F:RegisterEvent('PLAYER_LOGIN', updateTicks)
	F:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', updateTicks)
end

local ticks = {}
local function updateCastBarTicks(bar, numTicks)
	if numTicks and numTicks > 0 then
		local delta = bar:GetWidth() / numTicks
		for i = 1, numTicks do
			if not ticks[i] then
				ticks[i] = bar:CreateTexture(nil, 'OVERLAY')
				ticks[i]:SetTexture(C.Assets.norm_tex)
				ticks[i]:SetVertexColor(0, 0, 0, .7)
				ticks[i]:SetWidth(C.Mult)
				ticks[i]:SetHeight(bar:GetHeight())
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint('CENTER', bar, 'LEFT', delta * i, 0 )
			ticks[i]:Show()
		end
	else
		for _, tick in pairs(ticks) do
			tick:Hide()
		end
	end
end

local function OnCastbarUpdate(self, elapsed)
	if self.casting or self.channeling then
		local decimal = self.decimal

		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end

		if self.__owner.unit == 'player' and self.Time then
			if self.delay ~= 0 then
				self.Time:SetFormattedText(decimal, (self.casting and self.max + self.delay or self.max - self.delay) - duration)
			else
				self.Time:SetFormattedText(decimal, self.max - duration)
				if self.Lag and self.SafeZone and self.SafeZone.timeDiff and self.SafeZone.timeDiff ~= 0 then
					self.Lag:SetFormattedText('%d ms', self.SafeZone.timeDiff * 1000)
				end
			end
		-- else
		-- 	if duration > 1e4 then
		-- 		self.Time:SetText('∞')
		-- 	else
		-- 		self.Time:SetFormattedText(decimal, (self.casting and self.max + self.delay or self.max - self.delay) - duration)
		-- 	end
		end
		self.duration = duration
		self:SetValue(duration)
		if (not FreeUIConfigs.unitframe.castbar_focus_separate and self.__owner.unit == 'focus') then
			self.Spark:SetPoint('CENTER', self, 'RIGHT', -((duration / self.max) * self:GetWidth()), 0)
		else
			self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
		end
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - .02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

local function OnCastSent(self)
	local element = self.Castbar
	if not element.SafeZone then return end
	element.SafeZone.sendTime = GetTime()
	element.SafeZone.castSent = true
end

local function PostCastStart(self, unit)
	self:SetAlpha(1)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))

	if unit == 'vehicle' or UnitInVehicle('player') then
		if self.SafeZone then self.SafeZone:Hide() end
		if self.Lag then self.Lag:Hide() end
	elseif unit == 'player' then
		local safeZone = self.SafeZone
		if not safeZone then return end

		safeZone.timeDiff = 0
		if safeZone.castSent then
			safeZone.timeDiff = GetTime() - safeZone.sendTime
			safeZone.timeDiff = safeZone.timeDiff > self.max and self.max or safeZone.timeDiff
			safeZone:SetWidth(self:GetWidth() * (safeZone.timeDiff + .001) / self.max)
			safeZone:Show()
			safeZone.castSent = false
		end

		local numTicks = 0
		if self.channeling then
			local spellID = UnitChannelInfo(unit)
			numTicks = channelingTicks[spellID] or 0
		end
		updateCastBarTicks(self, numTicks)
	elseif not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	end

	if self.Icon and not self.Icon:GetTexture() then
		self.Icon:SetTexture(136243)
	end

	if self.iconBg then
		if self.notInterruptible then
			self.iconBg:SetBackdropColor(unpack(self.notInterruptibleColor))
		else
			self.iconBg:SetBackdropColor(unpack(self.CastingColor))
		end
	end

	if self.iconGlow then
		if self.notInterruptible then
			self.iconGlow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .5)
		else
			self.iconGlow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .35)
		end
	end

	if self.Glow and not (FreeUIConfigs.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		if self.notInterruptible then
			self.Glow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .35)
		else
			self.Glow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .35)
		end
	end

	if FreeUIConfigs.unitframe.castbar_focus_separate and self.__owner.unit == 'focus' then
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], 1)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], 1)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .6)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 1)
	else
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .4)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .4)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .2)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

local function PostUpdateInterruptible(self, unit)
	if not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	else
		self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	end
end

local function PostCastStop(self)
	if not self.fadeOut then
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

local function PostChannelStop(self)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

local function PostCastFailed(self)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
end

function UNITFRAME:AddCastBar(self)
	if not FreeUIConfigs.unitframe.enable_castbar then return end

	local castbar = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	castbar:SetStatusBarTexture(C.Assets.norm_tex)
	castbar:SetStatusBarColor(0, 0, 0, 0)
	castbar.Bg = F.CreateBDFrame(castbar)
	castbar.Glow = F.CreateSD(castbar.Bg, .35, 4, 4)

	if (not FreeUIConfigs.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		castbar:SetFillStyle('REVERSE')
	end

	if self.unitStyle == 'focus' and FreeUIConfigs.unitframe.castbar_focus_separate then
		castbar:SetSize(FreeUIConfigs.unitframe.castbar_focus_width, FreeUIConfigs.unitframe.castbar_focus_height)
		castbar:ClearAllPoints()

		F.Mover(castbar, L['MOVER_UNITFRAME_FOCUS_CASTBAR'], 'FocusCastbar', {'CENTER', UIParent, 'CENTER', 0, 200}, FreeUIConfigs.unitframe.castbar_focus_width, FreeUIConfigs.unitframe.castbar_focus_height)
	else
		castbar:SetAllPoints(self)
		castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
		castbar:SetSize(self:GetWidth(), self:GetHeight())
	end

	self.Castbar = castbar

	local spark = castbar:CreateTexture(nil, 'OVERLAY')
	spark:SetBlendMode('ADD')
	spark:SetAlpha(.7)
	spark:SetSize(20, castbar:GetHeight() * 2)
	castbar.Spark = spark


	if FreeUIConfigs.unitframe.castbar_timer then
		local timer = F.CreateFS(castbar, C.Assets.Fonts.Number, 11, 'OUTLINE')
		timer:SetPoint('CENTER', castbar)
		castbar.Time = timer
	end

	local iconFrame = CreateFrame('Frame', nil, castbar)
	if FreeUIConfigs.unitframe.castbar_focus_separate and self.unitStyle == 'focus' then
		iconFrame:SetSize(castbar:GetHeight() + 4, castbar:GetHeight() + 4)
	else
		iconFrame:SetSize(castbar:GetHeight() + 6, castbar:GetHeight() + 6)
	end

	if (not FreeUIConfigs.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', castbar, 'RIGHT', 4, 0)
	else
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
	end

	local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
	icon:SetAllPoints(iconFrame)
	icon:SetTexCoord(unpack(C.TexCoord))
	castbar.Icon = icon
	castbar.iconBg = F.CreateBDFrame(iconFrame)
	castbar.iconGlow = F.CreateSD(iconFrame, .35, 4, 4)

	if self.unitStyle == 'player' then
		local safeZone = castbar:CreateTexture(nil,'OVERLAY')
		safeZone:SetTexture(C.Assets.bd_tex)
		safeZone:SetVertexColor(223/255, 63/255, 107/255, .6)
		safeZone:SetPoint('TOPRIGHT')
		safeZone:SetPoint('BOTTOMRIGHT')
		castbar.SafeZone = safeZone
	end

	castbar.decimal = '%.1f'

	castbar.CastingColor = {110/255, 176/255, 216/255}
	castbar.ChannelingColor = {92/255, 193/255, 216/255}
	castbar.notInterruptibleColor = {190/255, 10/255, 18/255}
	castbar.CompleteColor = {63/255, 161/255, 124/255}
	castbar.FailColor = {187/255, 99/255, 110/255}

	castbar.OnUpdate = OnCastbarUpdate
	castbar.PostCastStart = PostCastStart
	castbar.PostChannelStart = PostCastStart
	castbar.PostCastStop = PostCastStop
	castbar.PostChannelStop = PostChannelStop
	castbar.PostCastFailed = PostCastFailed
	castbar.PostCastInterrupted = PostCastFailed
	castbar.PostCastInterruptible = PostUpdateInterruptible
	castbar.PostCastNotInterruptible = PostUpdateInterruptible
end

-- Class power
local function PostUpdateClassPower(element, power, maxPower, diff, powerType)
	if(diff) then
		for index = 1, maxPower do
			local Bar = element[index]
			local maxWidth, gap = FreeUIConfigs.unitframe.player_width, 3

			Bar:SetWidth((maxWidth - (maxPower - 1) * gap) / maxPower)

			if(index > 1) then
				Bar:ClearAllPoints()
				Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
			end
		end
	end
end

local function UpdateClassPowerColor(element)
	local r, g, b = 1, 1, 2/5
	if not UnitHasVehicleUI('player') then
		if C.MyClass == 'MONK' then
			r, g, b = 0, 4/5, 3/5
		elseif C.MyClass == 'WARLOCK' then
			r, g, b = 2/3, 1/3, 2/3
		elseif C.MyClass == 'PALADIN' then
			r, g, b = 238/255, 220/255, 127/255
		elseif C.MyClass == 'MAGE' then
			r, g, b = 5/6, 1/2, 5/6
		elseif C.MyClass == 'ROGUE' then
			r, g, b = 179/255, 54/255, 16/255
		end
	end

	for index = 1, #element do
		local Bar = element[index]
		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetBackdropColor(r * 1/3, g * 1/3, b * 1/3)
	end
end

function UNITFRAME:AddClassPower(self)
	if not FreeUIConfigs.unitframe.class_power_bar then return end

	local classPower = {}
	classPower.UpdateColor = UpdateClassPowerColor
	classPower.PostUpdate = PostUpdateClassPower

	for index = 1, 6 do
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(FreeUIConfigs.unitframe.class_power_bar_height)
		Bar:SetStatusBarTexture(C.Assets.norm_tex)
		Bar:SetBackdropColor(0, 0, 0)

		Bar.bg = F.CreateBDFrame(Bar)

		if(index == 1) then
			Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end

		local function MoveClassPowerBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0, -3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveClassPowerBar)
		self.AlternativePower:HookScript('OnHide', MoveClassPowerBar)
		MoveClassPowerBar()

		classPower[index] = Bar
	end

	self.ClassPower = classPower
end

-- Runes
local function PostUpdateRune(element, runemap)
	local maxRunes = 6
	for index, runeID in next, runemap do
		local Bar = element[index]
		local runeReady = select(3, GetRuneCooldown(runeID))
		local maxWidth, gap = FreeUIConfigs.unitframe.player_width, 3
		if Bar:IsShown() and not runeReady then
			Bar:SetAlpha(.45)
		else
			Bar:SetAlpha(1)
		end

		Bar:SetWidth((maxWidth - (maxRunes - 1) * gap) / maxRunes)

		if(index > 1) then
			Bar:ClearAllPoints()
			Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
		end
	end
end

function UNITFRAME:AddRunes(self)
	if not FreeUIConfigs.unitframe.runes_bar then return end

	local runes = {}
	local maxRunes = 6

	for index = 1, maxRunes do
		local Bar = CreateFrame('StatusBar', nil, self)
		Bar:SetHeight(FreeUIConfigs.unitframe.runes_bar_height)
		Bar:SetStatusBarTexture(C.Assets.norm_tex)

		F.CreateBDFrame(Bar)

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

		runes[index] = Bar
	end

	runes.colorSpec = true
	runes.sortOrder = 'asc'
	runes.PostUpdate = PostUpdateRune
	self.Runes = runes
end

-- Stagger
function UNITFRAME:AddStagger(self)
	if not FreeUIConfigs.unitframe.stagger_bar then return end

	local stagger = CreateFrame('StatusBar', nil, self)
	stagger:SetSize(self:GetWidth(), FreeUIConfigs.unitframe.stagger_bar_height)
	stagger:SetStatusBarTexture(C.Assets.norm_tex)

	local bg = F.CreateBDFrame(stagger)

	local function MoveStaggerBar()
		if self.AlternativePower:IsShown() then
			stagger:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0, -3)
		else
			stagger:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
		end
	end
	self.AlternativePower:HookScript('OnShow', MoveStaggerBar)
	self.AlternativePower:HookScript('OnHide', MoveStaggerBar)
	MoveStaggerBar()

	local text = F.CreateFS(stagger, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, true)
	text:SetPoint('TOP', stagger, 'BOTTOM', 0, -4)
	self:Tag(text, '[free:stagger]')

	self.Stagger = stagger
end

-- Totems
local TotemsColor = {
	{ 0.71, 0.29, 0.13 }, -- red    181 /  73 /  33
	{ 0.26, 0.71, 0.13 }, -- green   67 / 181 /  33
	{ 0.13, 0.55, 0.71 }, -- blue    33 / 141 / 181
	{ 0.58, 0.13, 0.71 }, -- violet 147 /  33 / 181
	{ 0.71, 0.58, 0.13 }, -- yellow 181 / 147 /  33
}

function UNITFRAME:AddTotems(self)
	if not FreeUIConfigs.unitframe.totems_bar then return end

	local totems = {}
	local maxTotems = 5

	local width, spacing = self:GetWidth(), 3

	width = (self:GetWidth() - (maxTotems + 1) * spacing) / maxTotems
	spacing = width + spacing

	for slot = 1, maxTotems do
		local totem = CreateFrame('StatusBar', nil, self)
		local color = TotemsColor[slot]
		local r, g, b = color[1], color[2], color[3]
		totem:SetStatusBarTexture(C.Assets.norm_tex)
		totem:SetStatusBarColor(r, g, b)
		totem:SetSize(width, FreeUIConfigs.unitframe.totems_bar_height)

		F.CreateBDFrame(totem)

		local function MoveTotemsBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					Bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)
				else
					Bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveTotemsBar)
		self.AlternativePower:HookScript('OnHide', MoveTotemsBar)
		MoveTotemsBar()

		totems[slot] = totem
	end

	self.CustomTotems = totems
end

-- Fader
function UNITFRAME:AddFader(self)
	if not FreeUIConfigs.unitframe.fader then return end

	self.Fader = {
		[1] = {Combat = 1, Arena = 1, Instance = 1},
		[2] = {PlayerTarget = 1, PlayerFocus = 1, PlayerNotMaxHealth = 1, PlayerNotMaxMana = 1, PlayerCasting = 1},
		[3] = {Stealth = 0.5},
		[4] = {notCombat = 0, PlayerTaxi = 0},
	}

	self.NormalAlpha = 1
end

-- GCD
function UNITFRAME:AddGCDSpark(self)
	if not FreeUIConfigs.unitframe.gcd_spark then return end

	self.GCD = CreateFrame('Frame', nil, self)
	self.GCD:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)
	self.GCD:SetFrameLevel(self.Health:GetFrameLevel() + 4)
	self.GCD:SetWidth(self:GetWidth())
	self.GCD:SetHeight(6)

	self.GCD.Color = {1, 1, 1}
	self.GCD.Height = 6
	self.GCD.Width = 6
end

-- Indicatiors
function UNITFRAME:AddPvPIndicator(self)
	local pvpIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, 'P', 'RED', 'THICK')
	pvpIndicator:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 5, 0)

	pvpIndicator.SetTexture = F.Dummy
	pvpIndicator.SetTexCoord = F.Dummy

	self.PvPIndicator = pvpIndicator
end

function UNITFRAME:AddCombatIndicator(self)
	local combatIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, '!', 'RED', 'THICK')
	combatIndicator:SetPoint('BOTTOMLEFT', self.PvPIndicator, 'BOTTOMRIGHT', 5, 0)

	self.CombatIndicator = combatIndicator
end

function UNITFRAME:AddRestingIndicator(self)
	local restingIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, 'Zzz', 'GREEN', 'THICK')
	restingIndicator:SetPoint('BOTTOMRIGHT', self.PowerValue, 'BOTTOMLEFT', -5, 0)

	self.RestingIndicator = restingIndicator
end

function UNITFRAME:AddQuestIndicator(self)
	local questIndicator = F.CreateFS(self, C.Assets.Fonts.Number, 11, nil, '*', 'YELLOW', 'THICK')
	questIndicator:SetPoint('BOTTOMRIGHT', self.Name, 'BOTTOMLEFT', -3, 0)

	self.QuestIndicator = questIndicator
end

function UNITFRAME:AddRaidTargetIndicator(self)
	local raidTargetIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	raidTargetIndicator:SetTexture(C.Assets.target_icon)
	raidTargetIndicator:SetAlpha(.5)
	raidTargetIndicator:SetSize(16, 16)
	raidTargetIndicator:SetPoint('CENTER', self)

	self.RaidTargetIndicator = raidTargetIndicator
end

function UNITFRAME:AddResurrectIndicator(self)
	local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	resurrectIndicator:SetSize(16, 16)
	resurrectIndicator:SetPoint('CENTER')

	self.ResurrectIndicator = resurrectIndicator
end

function UNITFRAME:AddReadyCheckIndicator(self)
	local readyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	readyCheckIndicator:SetPoint('CENTER', self.Health)
	readyCheckIndicator:SetSize(16, 16)
	self.ReadyCheckIndicator = readyCheckIndicator
end

function UNITFRAME:AddGroupRoleIndicator(self)
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

	local groupRoleIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', '', nil, true, 'BOTTOM', 1, 1)
	groupRoleIndicator.Override = UpdateLFD
	self.GroupRoleIndicator = groupRoleIndicator
end

function UNITFRAME:AddLeaderIndicator(self)
    local leaderIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', 'L', nil, true, 'TOPLEFT', 2, -2)

    self.LeaderIndicator = leaderIndicator
end

function UNITFRAME:AddPhaseIndicator(self)
	local phaseIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Number, 11, nil, '?', nil, 'THICK', 'RIGHT', nil, true)
	phaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -2)
	self.PhaseIndicator = phaseIndicator
end

function UNITFRAME:AddSummonIndicator(self)
	local summonIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	summonIndicator:SetSize(36, 36)
	summonIndicator:SetPoint('CENTER')

	self.SummonIndicator = summonIndicator
end

local function UpdateThreat(self, event, unit)
	if not self.Glow or self.unit ~= unit then return end

	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		local r, g, b = GetThreatStatusColor(status)
		self.Glow:SetBackdropBorderColor(r, g, b, .6)
	else
		self.Glow:SetBackdropBorderColor(0, 0, 0, .35)
	end
end

function UNITFRAME:AddThreatIndicator(self)
	if not FreeUIConfigs.unitframe.group_threat then return end

	self.ThreatIndicator = {
		IsObjectType = function() end,
		Override = UpdateThreat,
	}
end

-- Portrait
local function PostUpdatePortrait(element, unit)
	element:SetDesaturation(1)
end

function UNITFRAME:AddPortrait(self)
	if not FreeUIConfigs.unitframe.portrait then return end

	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetAllPoints(self)
	portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	portrait:SetAlpha(.1)
	portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = portrait
end

-- Spell range
function UNITFRAME:AddRangeCheck(self)
	if not FreeUIConfigs.unitframe.range_check then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = 0.5
	}
end

-- Floating combat feedback
function UNITFRAME:AddFCF(self)
	local parentFrame = CreateFrame('Frame', nil, UIParent)
	local fcf = CreateFrame('Frame', 'oUF_CombatTextFrame', parentFrame)
	fcf:SetSize(32, 32)
	if self.unitStyle == 'player' then
		F.Mover(fcf, L['MOVER_COMBATTEXT_INCOMING'], 'PlayerCombatText', {'CENTER', -300, 0})
	else
		F.Mover(fcf, L['MOVER_COMBATTEXT_OUTGOING'], 'TargetCombatText', {'CENTER', 300, 0})
	end

	for i = 1, 36 do
		fcf[i] = parentFrame:CreateFontString('$parentText', 'OVERLAY')
	end

	fcf.font = C.Assets.Fonts.Number
	fcf.fontFlags = nil
	fcf.showPets = true
	fcf.showHots = true
	fcf.showAutoAttack = true
	fcf.showOverHealing = true
	fcf.abbreviateNumbers = true
	self.FloatingCombatFeedback = fcf
end
