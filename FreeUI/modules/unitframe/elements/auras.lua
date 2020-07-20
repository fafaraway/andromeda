local F, C = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


local format, min, max, floor, mod, pairs = string.format, math.min, math.max, math.floor, mod, pairs

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
	elseif style == 'player' and cfg.player_auras then
		if C.ClassBuffs['ALL'][spellID] or C.ClassBuffs[C.MyClass][spellID] then
			return true
		else
			return false
		end
	elseif style == 'target' and cfg.target_auras then
		if cfg.only_show_debuffs_by_player and button.isDebuff and not button.isPlayer then
			return false
		else
			return true
		end
	elseif style == 'boss' and cfg.bossShowAuras then
		if cfg.only_show_debuffs_by_player and button.isDebuff and not button.isPlayer then
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
	elseif style == 'focus' and cfg.focus_auras then
		if button.isDebuff and button.isPlayer then
			return true
		else
			return false
		end
	elseif style == 'arena' and cfg.arenaShowAuras then
		return true
	elseif style == 'pet' and cfg.pet_auras then
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

		auras.numTotal = (style == 'player' and cfg.player_auras_number) or cfg.target_auras_number
		auras.iconsPerRow = (style == 'player' and cfg.player_auras_number_per_row) or cfg.target_auras_number_per_row
	elseif style == 'pet' or style == 'focus' or style == 'boss' or style == 'arena' then
		auras.initialAnchor = 'TOPLEFT'
		auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		auras['growth-y'] = 'DOWN'
		auras['spacing-x'] = 5

		if style == 'pet' then
			auras.numTotal = cfg.pet_auras_number
			auras.iconsPerRow = cfg.pet_auras_number_per_row
		elseif style == 'focus' then
			auras.numTotal = cfg.focus_auras_number
			auras.iconsPerRow = cfg.focus_auras_number_per_row
		elseif style == 'boss' then
			auras.numTotal = cfg.bossAuraTotal
			auras.iconsPerRow = cfg.bossAuraPerRow
		elseif style == 'arena' then
			auras.numTotal = cfg.arenaAuraTotal
			auras.iconsPerRow = cfg.arenaAuraPerRow
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
	
	if style == 'party' and not cfg.symmetry then
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
		debuffs:SetPoint('BOTTOM', 0, cfg.power_bar_height - 1)
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