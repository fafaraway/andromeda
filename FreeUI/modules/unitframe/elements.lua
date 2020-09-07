local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UNITFRAME')
local oUF = F.oUF


local strmatch, format, wipe, tinsert = string.match, string.format, table.wipe, table.insert
local pairs, ipairs, next, tonumber, unpack, gsub = pairs, ipairs, next, tonumber, unpack, gsub
local UnitAura, GetSpellInfo = UnitAura, GetSpellInfo
local InCombatLockdown = InCombatLockdown
local GetTime, GetSpellCooldown, IsInRaid, IsInGroup, IsPartyLFG = GetTime, GetSpellCooldown, IsInRaid, IsInGroup, IsPartyLFG
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage


-- Frame backdrop
function UNITFRAME:AddBackDrop(self)
	--[[ local highlight = self:CreateTexture(nil, 'BORDER')
	highlight:SetAllPoints()
	highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	highlight:SetTexCoord(0, 1, .5, 1)
	highlight:SetVertexColor(.6, .6, .6)
	highlight:SetBlendMode('ADD')
	highlight:Hide()

	self:RegisterForClicks('AnyUp')
	self:HookScript('OnEnter', function()
		UnitFrame_OnEnter(self)
		highlight:Show()
	end)
	self:HookScript('OnLeave', function()
		UnitFrame_OnLeave(self)
		highlight:Hide()
	end)

	self.Highlight = highlight ]]

	self:RegisterForClicks('AnyUp')

	F.CreateTex(self)

	local bg = F.CreateBDFrame(self)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	bg:SetBackdropColor(0, 0, 0, 0)
	self.Bg = bg

	local glow = F.CreateSD(self.Bg)
	self.Glow = glow
end

-- Health
local function PostUpdateHealth(health, unit, min, max)
	local self = health:GetParent()
	local r, g, b
	local reactionColor = oUF.colors.reaction[UnitReaction(unit, 'player') or 5]
	local isOffline = not UnitIsConnected(unit)
	local isDead = UnitIsDead(unit)
	local isGhost = UnitIsGhost(unit)
	local isTapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
	local style = health.__owner.unitStyle

	if isOffline then
		r, g, b = unpack(oUF.colors.disconnected)
	elseif isTapped then
		r, g, b = unpack(oUF.colors.tapped)
	elseif UnitIsPlayer(unit) or style == 'pet' then
		local _, class = UnitClass(unit)
		local color = FreeADB.class_colors[class]

		if class then
			r, g, b = color.r, color.g, color.b
		else
			r, g, b = 1, 1, 1
		end
	else
		r, g, b = unpack(reactionColor)
	end

	if FreeDB.unitframe.transparency and self.Deficit then
		self.Deficit:SetMinMaxValues(0, max)
		self.Deficit:SetValue(max-min)

		if offline or dead or ghost then
			self.Deficit:SetValue(0)
		else
			if FreeDB.unitframe.color_smooth or (FreeDB.unitframe.boss_color_smooth and style == 'boss') or (FreeDB.unitframe.group_color_smooth and (style == 'raid' or style == 'party')) then
				self.Deficit:GetStatusBarTexture():SetVertexColor(F.ColorGradient(min / max, unpack(oUF.colors.smooth)))
			else
				self.Deficit:GetStatusBarTexture():SetVertexColor(r, g, b)
			end
		end
	end

	if isOffline then
		self.Bg:SetBackdropColor(.4, .4, .4, .6)
	elseif isTapped then
		self.Bg:SetBackdropColor(.4, .4, .4, .6)
	elseif isDead or isGhost then
		self.Bg:SetBackdropColor(0, 0, 0, .8)
	else
		self.Bg:SetBackdropColor(.02, .02, .02, .5)
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
	health:SetPoint('BOTTOM', 0, C.Mult + FreeDB.unitframe.power_bar_height)
	health:SetHeight(self:GetHeight() - FreeDB.unitframe.power_bar_height - C.Mult)
	F:SmoothBar(health)
	health.frequentUpdates = true

	self.Health = health

	if FreeDB.unitframe.transparency then
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

		if FreeDB.unitframe.color_smooth or (FreeDB.unitframe.boss_color_smooth and self.unitStyle == 'boss') or (FreeDB.unitframe.group_color_smooth and self.unitStyle == 'raid') then
			health.colorSmooth = true
		else
			health.colorClass = true
			health.colorReaction = true
			health.colorClassPet = true
			--health.colorSelection = true
		end
	end

	self.Health.PostUpdate = PostUpdateHealth
end

-- Health prediction
function UNITFRAME:AddHealthPrediction(self)
	if FreeDB.unitframe.heal_prediction then
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

	if FreeDB.unitframe.over_absorb then
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
	local _, powerToken = UnitPowerType(unit)
	-- local color = FreeADB['power_colors'][powerToken] or {1, 1, 1}
	-- local r, g, b = color.r, color.g, color.b

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
	-- else
	-- 	power:SetStatusBarColor(r, g, b)
	end
end

function UNITFRAME:AddPowerBar(self)
	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('LEFT')
	power:SetPoint('RIGHT')
	power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
	power:SetStatusBarTexture(C.Assets.norm_tex)
	power:SetHeight(FreeDB.unitframe.power_bar_height)

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
	elseif FreeDB.unitframe.transparency then
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
		local r, g, b = F.ColorGradient(cur / max, unpack(oUF.colors.smooth))

		element:SetStatusBarColor(r, g, b)
		value:SetTextColor(r, g, b)
	end
end

function UNITFRAME:AddAlternativePowerBar(self)
	if not FreeDB.unitframe.alt_power then return end

	local altPower = CreateFrame('StatusBar', nil, self)
	altPower:SetStatusBarTexture(C.Assets.norm_tex)
	altPower:SetPoint('TOP', self.Power, 'BOTTOM', 0, -2)
	altPower:Size(self:GetWidth(), FreeDB.unitframe.alt_power_height)
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
	elseif style == 'player' and FreeDB.unitframe.player_auras then
		if C.ClassBuffs['ALL'][spellID] or C.ClassBuffs[C.MyClass][spellID] then
			return true
		else
			return false
		end
	elseif style == 'target' and FreeDB.unitframe.target_auras then
		if FreeDB.unitframe.target_debuffs_by_player and button.isDebuff and not button.isPlayer then
			return false
		else
			return true
		end
	elseif style == 'boss' and FreeDB.unitframe.boss_auras then
		if FreeDB.unitframe.boss_debuffs_by_player and button.isDebuff and not button.isPlayer then
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
	elseif style == 'focus' and FreeDB.unitframe.focus_auras then
		if button.isDebuff and button.isPlayer then
			return true
		else
			return false
		end
	elseif style == 'arena' and FreeDB.unitframe.arenaShowAuras then
		return true
	elseif style == 'pet' and FreeDB.unitframe.pet_auras then
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

		auras.numTotal = (style == 'player' and FreeDB.unitframe.player_auras_number) or FreeDB.unitframe.target_auras_number
		auras.iconsPerRow = (style == 'player' and FreeDB.unitframe.player_auras_number_per_row) or FreeDB.unitframe.target_auras_number_per_row
	elseif style == 'pet' or style == 'focus' or style == 'boss' or style == 'arena' then
		auras.initialAnchor = 'TOPLEFT'
		auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		auras['growth-y'] = 'DOWN'
		auras['spacing-x'] = 5

		if style == 'pet' then
			auras.numTotal = FreeDB.unitframe.pet_auras_number
			auras.iconsPerRow = FreeDB.unitframe.pet_auras_number_per_row
		elseif style == 'focus' then
			auras.numTotal = FreeDB.unitframe.focus_auras_number
			auras.iconsPerRow = FreeDB.unitframe.focus_auras_number_per_row
		elseif style == 'boss' then
			auras.numTotal = FreeDB.unitframe.boss_auras_number
			auras.iconsPerRow = FreeDB.unitframe.boss_auras_number_per_row
		elseif style == 'arena' then
			auras.numTotal = FreeDB.unitframe.arenaAuraTotal
			auras.iconsPerRow = FreeDB.unitframe.arenaAuraPerRow
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

-- Corner buffs
local found = {}
local auraFilter = {'HELPFUL', 'HARMFUL'}

function UNITFRAME:UpdateCornerBuffs(event, unit)
	if event == 'UNIT_AURA' and self.unit ~= unit then return end

	local spellList = C.CornerBuffs[C.MyClass]
	local buttons = self.BuffIndicator
	unit = self.unit

	wipe(found)
	for _, filter in next, auraFilter do
		for i = 1, 32 do
			local name, texture, count, _, duration, expiration, caster, _, _, spellID = UnitAura(unit, i, filter)
			if not name then break end
			local value = spellList[spellID]
			if value and (value[3] or caster == 'player' or caster == 'pet') then
				for _, bu in pairs(buttons) do
					if bu.anchor == value[1] then

						if duration and duration > 0 then
							bu.cd:SetCooldown(expiration - duration, duration)
							bu.cd:Show()
						else
							bu.cd:Hide()
						end

						bu.icon:SetVertexColor(unpack(value[2]))

						bu:Show()
						found[bu.anchor] = true

						break
					end
				end
			end
		end
	end

	for _, bu in pairs(buttons) do
		if not found[bu.anchor] then
			bu:Hide()
		end
	end
end

function UNITFRAME:RefreshCornerBuffs(bu)
	bu:SetScript('OnUpdate', nil)
	bu.icon:SetTexture(C.Assets.bd_tex)

	bu.icon:Show()
	bu.cd:Show()
	bu.bg:Show()
end

function UNITFRAME:AddCornerBuffs(self)
	if not FreeDB.unitframe.group_corner_buffs then return end

	local parent = CreateFrame('Frame', nil, self.Health)
	parent:SetPoint('TOPLEFT', 4, -4)
	parent:SetPoint('BOTTOMRIGHT', -4, 4)

	local anchors = {'TOPLEFT', 'TOP', 'TOPRIGHT', 'LEFT', 'RIGHT', 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'}
	local buttons = {}
	for _, anchor in pairs(anchors) do
		local bu = CreateFrame('Frame', nil, parent)
		bu:SetFrameLevel(self.Health:GetFrameLevel()+2)
		bu:SetSize(5, 5)
		bu:SetScale(1)
		bu:SetPoint(anchor)
		bu:Hide()

		bu.bg = F.CreateBDFrame(bu)
		bu.icon = bu:CreateTexture(nil, 'BORDER')
		bu.icon:SetInside(bu.bg)
		bu.icon:SetTexCoord(unpack(C.TexCoord))

		bu.cd = CreateFrame('Cooldown', nil, bu, 'CooldownFrameTemplate')
		bu.cd:SetInside(bu.bg)
		bu.cd:SetReverse(true)
		bu.cd:SetHideCountdownNumbers(true)

		bu.anchor = anchor
		tinsert(buttons, bu)

		UNITFRAME:RefreshCornerBuffs(bu)
	end

	self.BuffIndicator = buttons
	self:RegisterEvent('UNIT_AURA', UNITFRAME.UpdateCornerBuffs)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', UNITFRAME.UpdateCornerBuffs, true)
end

-- Debuff highlight
function UNITFRAME:AddDebuffHighlight(self)
	if not FreeDB.unitframe.group_debuff_highlight then return end

	self.DebuffHighlight = self:CreateTexture(nil, 'OVERLAY')
	self.DebuffHighlight:SetAllPoints(self)
	self.DebuffHighlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	self.DebuffHighlight:SetTexCoord(0, 1, .5, 1)
	self.DebuffHighlight:SetVertexColor(.6, .6, .6, 0)
	self.DebuffHighlight:SetBlendMode('ADD')
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightFilter = true
end

-- Group debuffs
function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then print('Invalid instance ID: '..instID) return end

	if not C.RaidDebuffs[instName] then C.RaidDebuffs[instName] = {} end
	if not level then level = 2 end
	if level > 6 then level = 6 end

	C.RaidDebuffs[instName][spellID] = level
end

function UNITFRAME:AddRaidDebuffs(self)
	if not FreeDB.unitframe.group_debuffs then return end

	local bu = CreateFrame('Frame', nil, self)
	bu:Size(self:GetHeight() * .5)
	bu:SetPoint('CENTER')
	bu:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	bu.bg = F.CreateBDFrame(bu)
	bu.glow = F.CreateSD(bu.bg)
	if bu.glow then
		bu.glow:SetFrameLevel(bu:GetFrameLevel() - 1)
	end
	bu:Hide()

	bu.icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.icon:SetAllPoints()
	bu.icon:SetTexCoord(unpack(C.TexCoord))

	bu.count = F.CreateFS(bu, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, nil, 'TOPRIGHT', 2, 4)
	bu.timer = F.CreateFS(bu, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, nil, 'BOTTOMLEFT', 2, -4)

	bu.ShowDispellableDebuff = true
	bu.ShowDebuffBorder = true
	bu.FilterDispellableDebuff = false

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
		if (not FreeDB.unitframe.castbar_focus_separate and self.__owner.unit == 'focus') then
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
	local castingColor = FreeDB.unitframe.castingColor
	local notInterruptibleColor = FreeDB.unitframe.notInterruptibleColor

	self:SetAlpha(1)
	self.Spark:Show()

	self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b)



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
		self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b)
	end

	if self.Icon and not self.Icon:GetTexture() then
		self.Icon:SetTexture(136243)
	end

	if self.iconBg then
		if self.notInterruptible then
			self.iconBg:SetBackdropColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b)
		else
			self.iconBg:SetBackdropColor(castingColor.r, castingColor.g, castingColor.b)
		end
	end

	if self.iconGlow then
		if self.notInterruptible then
			self.iconGlow:SetBackdropBorderColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, .5)
		else
			self.iconGlow:SetBackdropBorderColor(castingColor.r, castingColor.g, castingColor.b, .35)
		end
	end

	if self.Glow and not (FreeDB.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		if self.notInterruptible then
			self.Glow:SetBackdropBorderColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, .35)
		else
			self.Glow:SetBackdropBorderColor(castingColor.r, castingColor.g, castingColor.b, .35)
		end
	end

	if FreeDB.unitframe.castbar_focus_separate and self.__owner.unit == 'focus' then
		if self.notInterruptible then
			self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, 1)
		else
			self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b, 1)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .6)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 1)
	else
		if self.notInterruptible then
			self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, .4)
		else
			self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b, .4)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .2)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

local function PostUpdateInterruptible(self, unit)
	local castingColor = FreeDB.unitframe.castingColor
	local notInterruptibleColor = FreeDB.unitframe.notInterruptibleColor

	if not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b)
	else
		self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b)
	end
end

local function PostCastStop(self)
	local completeColor = FreeDB.unitframe.completeColor

	if not self.fadeOut then
		self:SetStatusBarColor(completeColor.r, completeColor.g, completeColor.b)
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
	local failColor = FreeDB.unitframe.failColor

	self:SetStatusBarColor(failColor.r, failColor.g, failColor.b)
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
end

function UNITFRAME:AddCastBar(self)
	if not FreeDB.unitframe.enable_castbar then return end

	local castbar = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	castbar:SetStatusBarTexture(C.Assets.norm_tex)
	castbar:SetStatusBarColor(0, 0, 0, 0)
	castbar.Bg = F.CreateBDFrame(castbar)
	castbar.Glow = F.CreateSD(castbar.Bg, .35, 4, 4)

	if (not FreeDB.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		castbar:SetFillStyle('REVERSE')
	end

	if self.unitStyle == 'focus' and FreeDB.unitframe.castbar_focus_separate then
		castbar:SetSize(FreeDB.unitframe.castbar_focus_width, FreeDB.unitframe.castbar_focus_height)
		castbar:ClearAllPoints()

		F.Mover(castbar, L['UNITFRAME_MOVER_CASTBAR'], 'FocusCastbar', {'CENTER', UIParent, 'CENTER', 0, 200}, FreeDB.unitframe.castbar_focus_width, FreeDB.unitframe.castbar_focus_height)
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


	if FreeDB.unitframe.castbar_timer then
		local timer = F.CreateFS(castbar, C.Assets.Fonts.Number, 11, 'OUTLINE')
		timer:SetPoint('CENTER', castbar)
		castbar.Time = timer
	end

	local iconFrame = CreateFrame('Frame', nil, castbar)
	if FreeDB.unitframe.castbar_focus_separate and self.unitStyle == 'focus' then
		iconFrame:SetSize(castbar:GetHeight() + 4, castbar:GetHeight() + 4)
	else
		iconFrame:SetSize(castbar:GetHeight() + 6, castbar:GetHeight() + 6)
	end

	if (not FreeDB.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
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
function UNITFRAME.PostUpdateClassPower(element, cur, max, diff, powerType)
	local maxWidth, gap = FreeDB.unitframe.player_width, 3

	if not cur or cur == 0 then
		for i = 1, 6 do
			element[i].bg:Hide()
		end
	else
		for i = 1, max do
			element[i].bg:Show()
		end
	end

	if diff then
		for i = 1, max do
			element[i]:SetWidth((maxWidth - (max-1)*gap)/max)
		end

		for i = max + 1, 6 do
			element[i].bg:Hide()
		end
	end
end

function UNITFRAME.UpdateClassPowerColor(element)
	if UnitHasVehicleUI('player') then return end

	local colors = FreeADB.class_power_colors
	local r, g, b

	if C.MyClass == 'MONK' then -- Chi Orbs
		r, g, b = colors.chi_orbs.r, colors.chi_orbs.g, colors.chi_orbs.b
	elseif C.MyClass == 'WARLOCK' then -- Soul Shards
		r, g, b = colors.soul_shards.r, colors.soul_shards.g, colors.soul_shards.b
	elseif C.MyClass == 'PALADIN' then -- Holy Power
		r, g, b = colors.holy_power.r, colors.holy_power.g, colors.holy_power.b
	elseif C.MyClass == 'MAGE' then -- Arcane Charges
		r, g, b = colors.arcane_charges.r, colors.arcane_charges.g, colors.arcane_charges.b
	elseif C.MyClass == 'ROGUE' or C.MyClass == 'DRUID' then -- Combo Points
		r, g, b = colors.combo_points.r, colors.combo_points.g, colors.combo_points.b
	else
		r, g, b = 1, 1, 1
	end

	for index = 1, #element do
		local Bar = element[index]
		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetVertexColor(r * 1/3, g * 1/3, b * 1/3, 0)
	end
end

function UNITFRAME:OnUpdateRunes(elapsed)
	local duration = self.duration + elapsed
	self.duration = duration
	self:SetValue(duration)

	if self.timer then
		local remain = self.runeDuration - duration
		if remain > 0 then
			self.timer:SetText(F.FormatTime(remain))
		else
			self.timer:SetText(nil)
		end
	end
end

function UNITFRAME.PostUpdateRunes(element, runemap)
	for index, runeID in next, runemap do
		local rune = element[index]
		local start, duration, runeReady = GetRuneCooldown(runeID)
		if rune:IsShown() then
			if runeReady then
				rune:SetAlpha(1)
				rune:SetScript('OnUpdate', nil)
				if rune.timer then rune.timer:SetText(nil) end
			elseif start then
				rune:SetAlpha(.6)
				rune.runeDuration = duration
				rune:SetScript('OnUpdate', UNITFRAME.OnUpdateRunes)
			end
		end
	end
end

function UNITFRAME:AddClassPowerBar(self)
	local gap = 3
	local barWidth = FreeDB.unitframe.player_width
	local barHeight = FreeDB.unitframe.class_power_bar_height

	local bar = CreateFrame('Frame', 'oUF_ClassPowerBar', self)
	bar:SetSize(barWidth, barHeight)

	if self.AlternativePower:IsShown() then
		bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0, -3)
	else
		bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
	end

	self.AlternativePower:HookScript('OnShow', function()
		bar:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', 0, -3)
	end)

	self.AlternativePower:HookScript('OnHide', function()
		bar:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
	end)

	local bars = {}
	for i = 1, 6 do
		bars[i] = CreateFrame('StatusBar', nil, bar)
		bars[i]:SetHeight(barHeight)
		bars[i]:SetWidth((barWidth - 5*gap) / 6)
		bars[i]:SetStatusBarTexture(C.Assets.norm_tex)
		bars[i]:SetFrameLevel(self:GetFrameLevel() + 5)

		F.CreateBDFrame(bars[i], 0, true)

		if i == 1 then
			bars[i]:SetPoint('BOTTOMLEFT')
		else
			bars[i]:SetPoint('LEFT', bars[i-1], 'RIGHT', gap, 0)
		end

		bars[i].bg = bar:CreateTexture(nil, 'BACKGROUND')
		bars[i].bg:SetAllPoints(bars[i])
		bars[i].bg:SetTexture(C.Assets.bd_tex)
		bars[i].bg.multiplier = .25

		if C.MyClass == 'DEATHKNIGHT' and FreeDB.unitframe.runes_timer then
			bars[i].timer = F.CreateFS(bars[i], C.Assets.Fonts.Number, 11, nil, '')
		end
	end

	if C.MyClass == 'DEATHKNIGHT' then
		bars.colorSpec = true
		bars.sortOrder = 'asc'
		bars.PostUpdate = UNITFRAME.PostUpdateRunes
		self.Runes = bars
	else
		bars.PostUpdate = UNITFRAME.PostUpdateClassPower
		bars.UpdateColor = UNITFRAME.UpdateClassPowerColor
		self.ClassPower = bars
	end
end

-- Stagger
function UNITFRAME:AddStagger(self)
	if C.MyClass ~= 'MONK' then return end
	if not FreeDB.unitframe.stagger_bar then return end

	local stagger = CreateFrame('StatusBar', nil, self)
	stagger:SetSize(self:GetWidth(), FreeDB.unitframe.class_power_bar_height)
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
local totemsColor = {
	{ 0.71, 0.29, 0.13 }, -- red    181 /  73 /  33
	{ 0.26, 0.71, 0.13 }, -- green   67 / 181 /  33
	{ 0.13, 0.55, 0.71 }, -- blue    33 / 141 / 181
	{ 0.58, 0.13, 0.71 }, -- violet 147 /  33 / 181
	{ 0.71, 0.58, 0.13 }, -- yellow 181 / 147 /  33
}

function UNITFRAME:AddTotems(self)
	if C.MyClass ~= 'SHAMAN' then return end
	if not FreeDB.unitframe.totems_bar then return end

	local totems = {}
	local maxTotems = 5

	local width, spacing = self:GetWidth(), 3

	width = (self:GetWidth() - (maxTotems + 1) * spacing) / maxTotems
	spacing = width + spacing

	for slot = 1, maxTotems do
		local totem = CreateFrame('StatusBar', nil, self)
		local color = totemsColor[slot]
		local r, g, b = color[1], color[2], color[3]
		totem:SetStatusBarTexture(C.Assets.norm_tex)
		totem:SetStatusBarColor(r, g, b)
		totem:SetSize(width, FreeDB.unitframe.class_power_bar_height)
		F.CreateBDFrame(totem)

		totem:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)

		--[[ local function MoveTotemsBar()
			if(index == 1) then
				if self.AlternativePower:IsShown() then
					totem:SetPoint('TOPLEFT', self.AlternativePower, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)
				else
					totem:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', (slot - 1) * spacing + 1, -3)
				end
			end
		end
		self.AlternativePower:HookScript('OnShow', MoveTotemsBar)
		self.AlternativePower:HookScript('OnHide', MoveTotemsBar)
		MoveTotemsBar() ]]

		totems[slot] = totem
	end

	self.CustomTotems = totems
end

-- Fader
function UNITFRAME:AddFader(self)
	if not FreeDB.unitframe.combat_fader then return end

	self.Fader = {
		[1] = {Combat = 1},
		[2] = {PlayerTarget = 1, PlayerFocus, PlayerNotMaxHealth = 1, PlayerCasting = 1},
		[3] = {notCombat = 0},
	}

	self.NormalAlpha = 1
end

-- Range check
function UNITFRAME:AddRangeCheck(self)
	if not FreeDB.unitframe.range_check then return end

	--[[ self.Range = {
		insideAlpha = 1,
		outsideAlpha = FreeDB.unitframe.range_check_alpha,
	} ]]


	if not self.RangeCheck then
		self.RangeCheck = {}
	end
	self.RangeCheck.enabled = true
	self.RangeCheck.insideAlpha = 1
	self.RangeCheck.outsideAlpha = 0.4

	-- self.RangeCheck.PostUpdate = UNITFRAME.RangeCheckPostUpdate
	-- self.RangeCheck.Override = UNITFRAME.RangeCheckUpdate

	-- self.Alpha = {}
	-- self.Alpha.current = 1
end

-- GCD
function UNITFRAME:AddGCDSpark(self)
	if not FreeDB.unitframe.gcd_spark then return end

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
	if not FreeDB.unitframe.player_pvp_indicator then return end
	if FreeDB.unitframe.player_hide_tags then return end

	local pvpIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, 'P', 'RED', 'THICK')
	pvpIndicator:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 5, 0)

	pvpIndicator.SetTexture = F.Dummy
	pvpIndicator.SetTexCoord = F.Dummy

	self.PvPIndicator = pvpIndicator
end

function UNITFRAME:AddCombatIndicator(self)
	if not FreeDB.unitframe.player_combat_indicator then return end
	if FreeDB.unitframe.player_hide_tags then return end

	local combatIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, '!', 'RED', 'THICK')
	combatIndicator:SetPoint('BOTTOMLEFT', self.PvPIndicator, 'BOTTOMRIGHT', 5, 0)

	self.CombatIndicator = combatIndicator
end

function UNITFRAME:AddRestingIndicator(self)
	if not FreeDB.unitframe.player_resting_indicator then return end
	if FreeDB.unitframe.player_hide_tags then return end

	local restingIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, 'Zzz', 'GREEN', 'THICK')
	restingIndicator:SetPoint('BOTTOMRIGHT', self.PowerValue, 'BOTTOMLEFT', -5, 0)

	self.RestingIndicator = restingIndicator
end

function UNITFRAME:AddRaidTargetIndicator(self)
	if not FreeDB.unitframe.target_icon_indicator then return end

	local raidTargetIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	raidTargetIndicator:SetTexture(C.Assets.target_icon)
	raidTargetIndicator:SetAlpha(.5)
	raidTargetIndicator:SetSize(16, 16)
	raidTargetIndicator:SetPoint('CENTER', self)

	self.RaidTargetIndicator = raidTargetIndicator
end

function UNITFRAME:AddResurrectIndicator(self)
	if not FreeDB.unitframe.group_resurrect_indicator then return end

	local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	resurrectIndicator:SetSize(16, 16)
	resurrectIndicator:SetPoint('CENTER')

	self.ResurrectIndicator = resurrectIndicator
end

function UNITFRAME:AddReadyCheckIndicator(self)
	if not FreeDB.unitframe.group_ready_check_indicator then return end

	local readyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	readyCheckIndicator:SetPoint('CENTER', self.Health)
	readyCheckIndicator:SetSize(16, 16)
	self.ReadyCheckIndicator = readyCheckIndicator
end

function UNITFRAME:AddGroupRoleIndicator(self)
	if not FreeDB.unitframe.group_role_indicator then return end

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
	if not FreeDB.unitframe.group_leader_indicator then return end

	local leaderIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', 'L', nil, true, 'TOPLEFT', 2, -2)

	self.LeaderIndicator = leaderIndicator
end

function UNITFRAME:AddPhaseIndicator(self)
	if not FreeDB.unitframe.group_phase_indicator then return end

	local phaseIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Number, 11, nil, '?', nil, 'THICK', 'RIGHT', nil, true)
	phaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -2)
	self.PhaseIndicator = phaseIndicator
end

function UNITFRAME:AddSummonIndicator(self)
	if not FreeDB.unitframe.group_summon_indicator then return end

	local summonIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	summonIndicator:SetSize(36, 36)
	summonIndicator:SetPoint('CENTER')

	self.SummonIndicator = summonIndicator
end

-- Threat
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
	if not FreeDB.unitframe.group_threat_indicator then return end

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
	if not FreeDB.unitframe.portrait then return end

	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetAllPoints(self)
	portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	portrait:SetAlpha(.1)
	portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = portrait
end

-- Floating combat feedback
function UNITFRAME:AddFCF(self)
	if not FreeDB.unitframe.combat_text then return end

	local parentFrame = CreateFrame('Frame', nil, UIParent)
	local fcf = CreateFrame('Frame', 'oUF_CombatTextFrame', parentFrame)
	fcf:SetSize(32, 32)
	if self.unitStyle == 'player' then
		F.Mover(fcf, L['UNITFRAME_MOVER_INCOMING'], 'PlayerCombatText', {'CENTER', -300, 0})
	else
		F.Mover(fcf, L['UNITFRAME_MOVER_OUTGOING'], 'TargetCombatText', {'CENTER', 300, 0})
	end

	for i = 1, 36 do
		fcf[i] = parentFrame:CreateFontString('$parentText', 'OVERLAY')
	end

	fcf.font = C.Assets.Fonts.Number
	fcf.fontFlags = nil
	fcf.showPets = FreeDB.unitframe.ct_pet
	fcf.showHots = FreeDB.unitframe.ct_hot
	fcf.showAutoAttack = FreeDB.unitframe.ct_auto_attack
	fcf.showOverHealing = FreeDB.unitframe.ct_over_healing
	fcf.abbreviateNumbers = FreeDB.unitframe.ct_abbr_number
	self.FloatingCombatFeedback = fcf
end

-- Party spells
local watchingList = {}
function UNITFRAME:PartyWatcherPostUpdate(button, unit, spellID)
	local guid = UnitGUID(unit)
	if not watchingList[guid] then watchingList[guid] = {} end
	watchingList[guid][spellID] = button
end

function UNITFRAME:HandleCDMessage(...)
	local prefix, msg = ...
	if prefix ~= 'ZenTracker' then return end

	local _, msgType, guid, spellID, duration, remaining = strsplit(':', msg)
	if msgType == 'U' then
		spellID = tonumber(spellID)
		duration = tonumber(duration)
		remaining = tonumber(remaining)
		local button = watchingList[guid] and watchingList[guid][spellID]
		if button then
			local start = GetTime() + remaining - duration
			if start > 0 and duration > 1.5 then
				button.CD:SetCooldown(start, duration)
			end
		end
	end
end

local lastUpdate = 0
function UNITFRAME:SendCDMessage()
	local thisTime = GetTime()
	if thisTime - lastUpdate >= 5 then
		local value = watchingList[UNITFRAME.myGUID]
		if value then
			for spellID in pairs(value) do
				local start, duration, enabled = GetSpellCooldown(spellID)
				if enabled ~= 0 and start ~= 0 then
					local remaining = start + duration - thisTime
					if remaining < 0 then remaining = 0 end
					C_ChatInfo_SendAddonMessage('ZenTracker', format('3:U:%s:%d:%.2f:%.2f:%s', UNITFRAME.myGUID, spellID, duration, remaining, '-'), IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY') -- sync to others
				end
			end
		end
		lastUpdate = thisTime
	end
end

local lastSyncTime = 0
function UNITFRAME:UpdateSyncStatus()
	if IsInGroup() and not IsInRaid() and FreeDB.unitframe.party_spell_sync then
		local thisTime = GetTime()
		if thisTime - lastSyncTime > 5 then
			C_ChatInfo_SendAddonMessage('ZenTracker', format('3:H:%s:0::0:1', UNITFRAME.myGUID), IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY') -- handshake to ZenTracker
			lastSyncTime = thisTime
		end
		F:RegisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCDMessage)
	else
		F:UnregisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCDMessage)
	end
end

function UNITFRAME:SyncWithZenTracker()
	if not FreeDB.unitframe.party_spell_sync then return end

	UNITFRAME.myGUID = UnitGUID('player')
	C_ChatInfo.RegisterAddonMessagePrefix('ZenTracker')
	F:RegisterEvent('CHAT_MSG_ADDON', UNITFRAME.HandleCDMessage)

	UNITFRAME:UpdateSyncStatus()
	F:RegisterEvent('GROUP_ROSTER_UPDATE', UNITFRAME.UpdateSyncStatus)
end

function UNITFRAME:AddPartySpells(self)
	if not FreeDB.unitframe.party_spell_watcher then return end

	local horizon = false
	local otherSide = false
	local relF = horizon and 'BOTTOMLEFT' or 'RIGHT'
	local relT = horizon and 'TOPLEFT' or 'LEFT'
	local xOffset = horizon and 0 or -5
	local yOffset = horizon and 5 or 0
	local margin = horizon and 2 or -2
	if otherSide then
		relF = horizon and 'TOPLEFT' or 'LEFT'
		relT = horizon and 'BOTTOMLEFT' or 'RIGHT'
		xOffset = horizon and 0 or 5
		yOffset = horizon and -(self.Power:GetHeight()+8) or 0
		margin = 2
	end
	local rel1 = not horizon and not otherSide and 'RIGHT' or 'LEFT'
	local rel2 = not horizon and not otherSide and 'LEFT' or 'RIGHT'
	local buttons = {}
	local maxIcons = 6
	local iconSize = horizon and (self:GetWidth()-2*abs(margin))/3 or (self:GetHeight()*.7)
	if iconSize > 34 then iconSize = 34 end

	for i = 1, maxIcons do
		local bu = CreateFrame('Frame', nil, self)
		bu:SetSize(iconSize, iconSize)
		F.AuraIcon(bu)
		bu.CD:SetReverse(false)
		if i == 1 then
			bu:SetPoint(relF, self, relT, xOffset, yOffset)
		elseif i == 4 and horizon then
			bu:SetPoint(relF, buttons[i-3], relT, 0, margin)
		else
			bu:SetPoint(rel1, buttons[i-1], rel2, margin, 0)
		end
		bu:Hide()

		buttons[i] = bu
	end

	buttons.__max = maxIcons
	buttons.PartySpells = C.PartySpells
	buttons.TalentCDFix = C.TalentCDFix
	self.PartyWatcher = buttons
	if FreeDB.unitframe.party_spell_sync then
		self.PartyWatcher.PostUpdate = UNITFRAME.PartyWatcherPostUpdate
	end
end

-- Group frame border
local function UpdateSelectedBorder(self)
	if UnitIsUnit('target', self.unit) then
		self.Border:Show()
	else
		self.Border:Hide()
	end
end

function UNITFRAME:AddSelectedBorder(self)
	local border = F.CreateBDFrame(self.Bg)
	border:SetBackdropBorderColor(1, 1, 1, 1)
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetFrameLevel(self:GetFrameLevel()+5)
	border:Hide()

	self.Border = border
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end

-- Tags
function UNITFRAME:AddGroupNameText(self)
	local groupName = F.CreateFS(self.Health, C.Assets.Fonts.Normal, 11, nil, nil, nil, 'THICK')

	self:Tag(groupName, '[free:groupname][free:offline][free:dead]')
	self.GroupName = groupName
end

function UNITFRAME:AddNameText(self)
	local name = F.CreateFS(self.Health, C.Assets.Fonts.Normal, 11, nil, nil, nil, 'THICK')

	if self.unitStyle == 'target' then
		name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
	elseif self.unitStyle == 'arena' or self.unitStyle == 'boss' then
		name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
	else
		name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	end

	self:Tag(name, '[free:name] [arenaspec]')
	self.Name = name
end

function UNITFRAME:AddHealthValueText(self)
	local healthValue = F.CreateFS(self.Health, C.Assets.Fonts.Number, 11, nil, nil, nil, 'THICK')
	healthValue:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

	if self.unitStyle == 'player' then
		self:Tag(healthValue, '[free:dead][free:health]')
	elseif self.unitStyle == 'target' then
		self:Tag(healthValue, '[free:dead][free:offline][free:health] [free:healthpercentage]')
	elseif self.unitStyle == 'boss' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:health] [free:healthpercentage]')
	elseif self.unitStyle == 'arena' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:offline][free:health]')
	end

	self.HealthValue = healthValue
end

function UNITFRAME:AddPowerValueText(self)
	local powerValue = F.CreateFS(self.Health, {C.Assets.Fonts.Number, 11, nil}, nil, nil, nil, nil, 'THICK')
	powerValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

	if self.unitStyle == 'target' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 4, 0)
	elseif self.unitStyle == 'boss' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMRIGHT', self.HealthValue, 'BOTTOMLEFT', -4, 0)
	end

	self:Tag(powerValue, '[powercolor][free:power]')
	powerValue.frequentUpdates = true

	self.PowerValue = powerValue
end

function UNITFRAME:AddAlternativePowerValueText(self)
	local altPowerValue = F.CreateFS(self.Health, {C.Assets.Fonts.Number, 11, nil}, nil, nil, nil, nil, 'THICK')

	if self.unitStyle == 'boss' then
		altPowerValue:SetPoint('LEFT', self, 'RIGHT', 2, 0)
	else
		altPowerValue:SetPoint('BOTTOM', self.Health, 'TOP', 0, 3)
	end

	self:Tag(altPowerValue, '[free:altpower]')

	self.AlternativePowerValue = altPowerValue
end


-- Text string all in one #TODO
function UNITFRAME:AddTextString()
	local style = self.unitStyle
	local name, groupName, health, power, altPower, pvp, combat, resting, quest


	name = F.CreateFS(self.Health, C.Assets.Fonts.Normal, 11, nil, nil, nil, 'THICK')

	if style == 'target' then
		name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
	elseif style == 'arena' or style == 'boss' then
		name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
	else
		name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	end

	self:Tag(name, '[free:name] [arenaspec]')
	self.Name = name


	groupName = F.CreateFS(self.Health, C.Assets.Fonts.Normal, 11, nil, nil, nil, 'THICK')

	self:Tag(groupName, '[free:groupname][free:offline][free:dead]')
	self.GroupName = groupName


	health = F.CreateFS(self.Health, C.Assets.Fonts.Number, 11, nil, nil, nil, 'THICK')
	health:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

	if style == 'player' then
		self:Tag(health, '[free:dead][free:health]')
	elseif style == 'target' then
		self:Tag(health, '[free:dead][free:offline][free:health] [free:healthpercentage]')
	elseif style == 'boss' then
		health:ClearAllPoints()
		health:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		health:SetJustifyH('RIGHT')
		self:Tag(health, '[free:dead][free:health] [free:healthpercentage]')
	elseif style == 'arena' then
		health:ClearAllPoints()
		health:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		health:SetJustifyH('RIGHT')
		self:Tag(health, '[free:dead][free:offline][free:health]')
	end

	self.HealthValue = health


	power = F.CreateFS(self.Health, C.Assets.Fonts.Number, 11, nil, nil, nil, 'THICK')
	power:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

	if style == 'target' then
		power:ClearAllPoints()
		power:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 4, 0)
	elseif style == 'boss' then
		power:ClearAllPoints()
		power:SetPoint('BOTTOMRIGHT', self.HealthValue, 'BOTTOMLEFT', -4, 0)
	end

	self:Tag(power, '[powercolor][free:power]')
	power.frequentUpdates = true

	self.PowerValue = power


	altPower = F.CreateFS(self.Health, {C.Assets.Fonts.Number, 11, nil}, nil, nil, nil, nil, 'THICK')

	if style == 'boss' then
		altPower:SetPoint('LEFT', self, 'RIGHT', 2, 0)
	else
		altPower:SetPoint('BOTTOM', self.Health, 'TOP', 4, 0)
	end

	self:Tag(altPower, '[free:altpower]')

	self.AlternativePowerValue = altPower
end



-- Range check stuff
--[[ function UNITFRAME:RangeCheckPostUpdate(self, unit)

	if InCombatLockdown() then
		self:SetAlpha(self.Alpha.range)
		return
	end

	if not self.Animator then
		self:SetAlpha(self.Alpha.range)
		return
	end

	if self.Animator:IsPlaying() then
		if self.Alpha.inRange == false then
			self.Animator:Stop()
			self:SetAlpha(self.Alpha.range)
			self.Alpha.current = self.Alpha.range
		end
	else
		self:SetAlpha(self.Alpha.range)
	end
end

function UNITFRAME.RangeCheckUpdate(self, isInRange, event)
	local element = self.RangeCheck
	local unit = self.unit

	if not self.Alpha then
		self.Alpha = {}
	end

	local currentAlpha = self.Alpha.target or 1 -- Work with combat fader
	local insideAlpha = currentAlpha * element.insideAlpha
	local outsideAlpha = currentAlpha * element.outsideAlpha

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		if isInRange then
			--self:SetAlpha(insideAlpha)
			self.Alpha.range = insideAlpha
			self.Alpha.inRange = true
		else
			--self:SetAlpha(outsideAlpha)
			self.Alpha.range = outsideAlpha
			self.Alpha.inRange = false
		end
		if(element.PostUpdate) then
			return element:PostUpdate(self, unit)
		end
	else
		--self:SetAlpha(1)
		self.Alpha.range = 1
		self.Alpha.inRange = true
		self:DisableElement('RangeCheck')
	end
end ]]








