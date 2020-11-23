local F, C, L = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local oUF = F.oUF

local format, wipe, tinsert = string.format, table.wipe, table.insert
local pairs, next, tonumber, unpack = pairs, next, tonumber, unpack
local UnitAura = UnitAura
local InCombatLockdown = InCombatLockdown
local GetTime, GetSpellCooldown, IsInRaid, IsInGroup, IsPartyLFG = GetTime, GetSpellCooldown, IsInRaid, IsInGroup, IsPartyLFG
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage

--[[ Colors ]]
local function ReplaceHealthColor()
	local colors = FREE_ADB.health_color
	oUF.colors.health = {
		colors.r,
		colors.g,
		colors.b
	}
end

local function ReplacePowerColors(name, index, color)
	oUF.colors.power[name] = color
	oUF.colors.power[index] = oUF.colors.power[name]
end

ReplacePowerColors(
	'MANA',
	0,
	{
		87 / 255,
		165 / 255,
		208 / 255
	}
)
ReplacePowerColors(
	'ENERGY',
	3,
	{
		174 / 255,
		34 / 255,
		45 / 255
	}
)
ReplacePowerColors(
	'COMBO_POINTS',
	4,
	{
		199 / 255,
		171 / 255,
		90 / 255
	}
)
ReplacePowerColors(
	'RUNIC_POWER',
	6,
	{
		135 / 255,
		214 / 255,
		194 / 255
	}
)
ReplacePowerColors(
	'SOUL_SHARDS',
	7,
	{
		151 / 255,
		101 / 255,
		221 / 255
	}
)
ReplacePowerColors(
	'HOLY_POWER',
	9,
	{
		208 / 255,
		178 / 255,
		107 / 255
	}
)
ReplacePowerColors(
	'INSANITY',
	13,
	{
		179 / 255,
		96 / 255,
		244 / 255
	}
)
function UNITFRAME:UpdateColors()
	ReplaceHealthColor()

	local classColors = C.ClassColors
	for class, value in pairs(classColors) do
		oUF.colors.class[class] = {
			value.r,
			value.g,
			value.b
		}
	end
end

local lastBarColors = {
	DRUID = {
		161 / 255,
		92 / 255,
		255 / 255
	},
	MAGE = {
		5 / 255,
		96 / 255,
		250 / 255
	},
	MONK = {
		0 / 255,
		143 / 255,
		247 / 255
	},
	PALADIN = {
		221 / 255,
		36 / 255,
		62 / 255
	},
	ROGUE = {
		161 / 255,
		92 / 255,
		255 / 255
	},
	WARLOCK = {
		221 / 255,
		36 / 255,
		62 / 255
	}
}

--[[ Backdrop ]]
function UNITFRAME:AddBackDrop(self)
	self:RegisterForClicks('AnyUp')

	self:HookScript(
		'OnEnter',
		function()
			UnitFrame_OnEnter(self)
		end
	)
	self:HookScript(
		'OnLeave',
		function()
			UnitFrame_OnLeave(self)
		end
	)
	F.CreateTex(self)

	local bg = F.CreateBDFrame(self)
	bg:SetBackdropBorderColor(0, 0, 0, 1)
	bg:SetBackdropColor(0, 0, 0, 0)
	self.Bg = bg

	local glow = F.CreateSD(self.Bg)
	self.Glow = glow

	if not self.unitStyle == 'player' then
		return
	end

	local width = C.DB.unitframe.player_width
	local height = C.DB.unitframe.class_power_bar_height

	local classPowerBarHolder = CreateFrame('Frame', nil, self)
	classPowerBarHolder:SetSize(width, height)
	classPowerBarHolder:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
	self.ClassPowerBarHolder = classPowerBarHolder
end

--[[ Mouseover highlight ]]
function UNITFRAME:AddHighlight(self)
	local highlight = self:CreateTexture(nil, 'OVERLAY')
	highlight:SetAllPoints()
	highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	highlight:SetTexCoord(0, 1, .5, 1)
	highlight:SetVertexColor(.6, .6, .6)
	highlight:SetBlendMode('BLEND')
	highlight:Hide()

	self.Highlight = highlight

	self:HookScript(
		'OnEnter',
		function()
			highlight:Show()
		end
	)
	self:HookScript(
		'OnLeave',
		function()
			highlight:Hide()
		end
	)
end

--[[ Selected border ]]
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
	border:SetFrameLevel(self:GetFrameLevel() + 5)
	border:Hide()

	self.Border = border
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end

--[[ Health ]]
local function OverrideHealth(self, event, unit)
	if not C.DB.unitframe.transparent_mode then
		return
	end
	if (not unit or self.unit ~= unit) then
		return
	end

	local health = self.Health
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local isOffline = not UnitIsConnected(unit)
	local isDead = UnitIsDead(unit)
	local isGhost = UnitIsGhost(unit)

	health:SetMinMaxValues(0, max)

	if isDead or isGhost or isOffline then
		self:SetValue(0)
	else
		if max == cur then
			health:SetValue(0)
		else
			health:SetValue(max - cur)
		end
	end
end

local function PostUpdateHealth(self, unit, min, max)
	local parent = self:GetParent()
	local isOffline = not UnitIsConnected(unit)
	local isDead = UnitIsDead(unit)
	local isGhost = UnitIsGhost(unit)
	local isTapped = UnitIsTapDenied(unit)

	if not C.DB.unitframe.transparent_mode then
		return
	end
	if isDead or isGhost or isOffline then
		self:SetValue(0)
	else
		if max == min then
			self:SetValue(0)
		else
			self:SetValue(max - min)
		end
	end

	if isDead or isGhost then
		parent.Bg:SetBackdropColor(0, 0, 0, .8)
	elseif isOffline or isTapped then
		parent.Bg:SetBackdropColor(.5, .5, .5, .6)
	else
		parent.Bg:SetBackdropColor(.1, .1, .1, .6)
	end
end

function UNITFRAME:UpdateRaidHealthMethod()
	for _, frame in pairs(oUF.objects) do
		if frame.unitStyle == 'raid' then
			frame:SetHealthUpdateMethod(C.DB.unitframe.group_health_frequen)
			frame:SetHealthUpdateSpeed(C.DB.unitframe.group_health_frequency)
			frame.Health:ForceUpdate()
		end
	end
end

function UNITFRAME:AddHealthBar(self)
	local style = self.unitStyle
	local isParty = (style == 'party')
	local isRaid = (style == 'raid')
	local isBoss = (style == 'boss')
	local isBaseUnits = F.MultiCheck(style, 'player', 'pet', 'target', 'targettarget', 'focus', 'focustarget')

	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameStrata('LOW')
	health:SetStatusBarTexture(C.Assets.statusbar_tex)
	health:SetReverseFill(C.DB.unitframe.transparent_mode)
	health:SetStatusBarColor(.1, .1, .1, 1)
	health:SetPoint('TOP')
	health:SetPoint('LEFT')
	health:SetPoint('RIGHT')
	health:SetPoint('BOTTOM', 0, C.Mult + C.DB.unitframe.power_bar_height)
	health:SetHeight(self:GetHeight() - C.DB.unitframe.power_bar_height - C.Mult)
	F:SmoothBar(health)

	if not C.DB.unitframe.transparent_mode then
		local bg = health:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(health)
		bg:SetTexture(C.Assets.bd_tex)
		bg:SetVertexColor(.6, .6, .6)
		bg.multiplier = .1
		health.bg = bg
	end

	health.colorTapping = true
	health.colorDisconnected = true

	if ((isParty or isRaid or isBoss) and C.DB.unitframe.group_color_style == 2) or (isBaseUnits and C.DB.unitframe.color_style == 2) then
		health.colorClass = true
		health.colorReaction = true
	elseif ((isParty or isRaid or isBoss) and C.DB.unitframe.group_color_style == 3) or (isBaseUnits and C.DB.unitframe.color_style == 3) then
		health.colorSmooth = true
	else
		health.colorHealth = true
	end

	self.Health = health
	self.Health.frequentUpdates = true
	self.Health.PreUpdate = OverrideHealth
	self.Health.PostUpdate = PostUpdateHealth
end

--[[ Health prediction ]]
function UNITFRAME:AddHealthPrediction(self)
	if C.DB.unitframe.heal_prediction then
		local myBar = CreateFrame('StatusBar', nil, self.Health)
		myBar:SetPoint('TOP')
		myBar:SetPoint('BOTTOM')
		myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), C.DB.unitframe.transparent_mode and 'LEFT' or 'RIGHT')
		myBar:SetStatusBarTexture(C.Assets.statusbar_tex)
		myBar:GetStatusBarTexture():SetBlendMode('BLEND')
		myBar:SetStatusBarColor(0, .8, .8, .6)
		myBar:SetWidth(self:GetWidth())

		local otherBar = CreateFrame('StatusBar', nil, self.Health)
		otherBar:SetPoint('TOP')
		otherBar:SetPoint('BOTTOM')
		otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), C.DB.unitframe.transparent_mode and 'LEFT' or 'RIGHT')
		otherBar:SetStatusBarTexture(C.Assets.statusbar_tex)
		otherBar:GetStatusBarTexture():SetBlendMode('BLEND')
		otherBar:SetStatusBarColor(0, .6, .6, .6)
		otherBar:SetWidth(self:GetWidth())

		local absorbBar = CreateFrame('StatusBar', nil, self.Health)
		absorbBar:SetPoint('TOP')
		absorbBar:SetPoint('BOTTOM')
		absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), C.DB.unitframe.transparent_mode and 'LEFT' or 'RIGHT')
		absorbBar:SetStatusBarTexture(C.Assets.stripe_tex)
		absorbBar:GetStatusBarTexture():SetBlendMode('BLEND')
		absorbBar:SetStatusBarColor(.8, .8, .8, .8)
		absorbBar:SetWidth(self:GetWidth())

		local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
		overAbsorb:SetPoint('TOP', self.Health, 'TOPRIGHT', -1, 4)
		overAbsorb:SetPoint('BOTTOM', self.Health, 'BOTTOMRIGHT', -1, -4)
		overAbsorb:SetWidth(12)
		overAbsorb:SetTexture(C.Assets.spark_tex)

		self.HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			absorbBar = absorbBar,
			overAbsorb = overAbsorb,
			maxOverflow = 1,
			frequentUpdates = true
		}
	end
end

--[[ Power ]]
local function PostUpdatePower(power, unit, cur, min, max)
	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end
end

local function UpdatePowerColor(power, unit)
	local style = power.__owner.unitStyle
	if style ~= 'player' then
		return
	end

	local cur = UnitPower(unit)
	if C.MyClass == 'DEMONHUNTER' and unit == 'player' then
		local spec = GetSpecialization() or 0
		if spec ~= 1 then
			return
		end
		if cur < 15 then
			power:SetStatusBarColor(.5, .5, .5)
		elseif cur < 40 then
			power:SetStatusBarColor(1, .8, 0)
		else
			power:SetStatusBarColor(197 / 255, 56 / 255, 48 / 255)
		end
	end
end

function UNITFRAME:AddPowerBar(self)
	local style = self.unitStyle

	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('LEFT')
	power:SetPoint('RIGHT')
	power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
	power:SetStatusBarTexture(C.Assets.statusbar_tex)
	power:SetHeight(C.DB.unitframe.power_bar_height)

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
	bg.multiplier = .1
	power.bg = bg

	power.colorTapping = true
	power.colorDisconnected = true
	power.colorReaction = true
	-- power.colorSelection = true
	if style == 'pet' or style == 'player' then
		power.colorPower = true
	elseif style == 'party' or style == 'raid' then
		power.colorPower = not C.DB.unitframe.transparent_mode
		power.colorClass = C.DB.unitframe.transparent_mode
	else
		power.colorClass = true
	end

	self.Power.PostUpdate = PostUpdatePower
	self.Power.PostUpdateColor = UpdatePowerColor
end

--[[ Alternative power ]]
local function AltPowerOnEnter(self)
	if (not self:IsVisible()) then
		return
	end

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	self:UpdateTooltip()
end

local function AltPowerUpdateTooltip(self)
	local value = self:GetValue()
	local min, max = self:GetMinMaxValues()
	local name, tooltip = GetUnitPowerBarStringsByID(self.__barID)
	GameTooltip:SetText(name or '', 1, 1, 1)
	GameTooltip:AddLine(tooltip or '', nil, nil, nil, true)
	GameTooltip:AddLine(format('%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
	GameTooltip:Show()
end

local function PostUpdateAltPower(self, unit, cur, min, max)
	local parent = self.__owner

	if cur and max then
		local value = parent.AlternativePowerValue
		local r, g, b = F.ColorGradient(cur / max, unpack(oUF.colors.smooth))

		self:SetStatusBarColor(r, g, b)
		value:SetTextColor(r, g, b)
	end

	if self:IsShown() then
		parent.ClassPowerBarHolder:ClearAllPoints()
		parent.ClassPowerBarHolder:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
	else
		parent.ClassPowerBarHolder:ClearAllPoints()
		parent.ClassPowerBarHolder:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -3)
	end
end

function UNITFRAME:AddAlternativePowerBar(self)
	if not C.DB.unitframe.alt_power then
		return
	end

	local altPower = CreateFrame('StatusBar', nil, self)
	altPower:SetStatusBarTexture(C.Assets.statusbar_tex)
	altPower:SetPoint('TOP', self.Power, 'BOTTOM', 0, -2)
	altPower:Size(self:GetWidth(), C.DB.unitframe.alt_power_height)
	altPower:EnableMouse(true)
	F:SmoothBar(altPower)
	altPower.bg = F.SetBD(altPower)

	altPower.UpdateTooltip = AltPowerUpdateTooltip
	altPower:SetScript('OnEnter', AltPowerOnEnter)

	self.AlternativePower = altPower
	self.AlternativePower.PostUpdate = PostUpdateAltPower
end

--[[ Auras ]]
oUF.colors.debuff = {
	['Curse'] = {
		.8,
		0,
		1
	},
	['Disease'] = {
		.8,
		.6,
		0
	},
	['Magic'] = {
		0,
		.8,
		1
	},
	['Poison'] = {
		0,
		.8,
		0
	},
	['none'] = {
		0,
		0,
		0
	}
}

local function AuraOnEnter(self)
	if not self:IsVisible() then
		return
	end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
	self:UpdateTooltip()
end

local function AuraOnLeave()
	GameTooltip:Hide()
end

local function UpdateAuraTooltip(aura)
	GameTooltip:SetUnitAura(aura:GetParent().__owner.unit, aura:GetID(), aura.filter)
end

function UNITFRAME.PostCreateIcon(element, button)
	button.bg = F.CreateBDFrame(button)
	button.glow = F.CreateSD(button.bg, .25, 3, 3)

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

	button.count = F.CreateFS(button, C.Assets.Fonts.Roadway, 12, 'OUTLINE', nil, nil, true)
	button.count:ClearAllPoints()
	button.count:SetPoint('TOPRIGHT', button, 2, 4)

	button.timer = F.CreateFS(button, C.Assets.Fonts.Roadway, 12, 'OUTLINE', nil, nil, true)
	button.timer:ClearAllPoints()
	button.timer:SetPoint('BOTTOMLEFT', button, 2, -4)

	button.UpdateTooltip = UpdateAuraTooltip
	button:SetScript('OnEnter', AuraOnEnter)
	button:SetScript('OnLeave', AuraOnLeave)
	button:SetScript(
		'OnClick',
		function(self, button)
			if not InCombatLockdown() and button == 'RightButton' then
				CancelUnitBuff('player', self:GetID(), self.filter)
			end
		end
	)
end

function UNITFRAME.PostUpdateIcon(element, unit, button, index, _, duration, expiration, debuffType)
	if duration then
		button.bg:Show()

		if button.glow then
			button.glow:Show()
		end
	end

	local style = element.__owner.unitStyle
	local _, _, _, _, _, _, _, canStealOrPurge = UnitAura(unit, index, button.filter)

	button:SetSize(element.size, element.size * .75)

	if button.isDebuff and F.MultiCheck(style, 'target', 'boss', 'arena') and not button.isPlayer then
		button.icon:SetDesaturated(true)
	else
		button.icon:SetDesaturated(false)
	end

	if element.disableCooldown then
		if duration and duration > 0 then
			button.expiration = expiration
			button:SetScript('OnUpdate', F.CooldownOnUpdate)
			button.timer:Show()
		else
			button:SetScript('OnUpdate', nil)
			button.timer:Hide()
		end
	end

	if canStealOrPurge and element.showStealableBuffs then
		button.bg:SetBackdropBorderColor(1, 1, 1)

		if button.glow then
			button.glow:SetBackdropBorderColor(1, 1, 1, .25)
		end
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none

		button.bg:SetBackdropBorderColor(color[1], color[2], color[3])

		if button.glow then
			button.glow:SetBackdropBorderColor(color[1], color[2], color[3], .25)
		end
	else
		button.bg:SetBackdropBorderColor(0, 0, 0)

		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, .25)
		end
	end
end

local function BolsterPreUpdate(element)
	element.bolster = 0
	element.bolsterIndex = nil
end

local function BolsterPostUpdate(element)
	if not element.bolsterIndex then
		return
	end

	for _, button in pairs(element) do
		if button == element.bolsterIndex then
			button.count:SetText(element.bolster)

			return
		end
	end
end

function UNITFRAME.CustomFilter(element, unit, button, name, _, _, _, _, _, caster, isStealable, _, spellID, _, _, _, nameplateShowAll)
	local style = element.__owner.unitStyle
	local isMine = F.MultiCheck(caster, 'player', 'pet', 'vehicle')

	if name and spellID == 209859 then
		element.bolster = element.bolster + 1
		if not element.bolsterIndex then
			element.bolsterIndex = button
			return true
		end
	elseif style == 'party' or style == 'raid' then
	elseif style == 'target' and C.DB.unitframe.target_auras then
		if element.onlyShowPlayer and button.isDebuff then
			return isMine
		else
			return true
		end
	elseif style == 'boss' and C.DB.unitframe.boss_auras then
		if element.onlyShowPlayer and button.isDebuff then
			return isMine
		else
			return true
		end
	elseif style == 'focus' and C.DB.unitframe.focus_auras then
		if button.isDebuff and button.isPlayer then
			return true
		else
			return false
		end
	elseif style == 'arena' and C.DB.unitframe.arena_auras then
		if element.onlyShowPlayer and button.isDebuff then
			return isMine
		else
			return true
		end
	elseif style == 'pet' and C.DB.unitframe.pet_auras then
		return true
	elseif style == 'nameplate' and C.DB.nameplate.plate_auras then
		if FREE_ADB['nameplate_aura_filter_list'][2][spellID] or C.AuraBlackList[spellID] then
			return false
		elseif element.showStealableBuffs and isStealable and not UnitIsPlayer(unit) then
			return true
		elseif FREE_ADB['nameplate_aura_filter_list'][1][spellID] or C.AuraWhiteList[spellID] then
			return true
		else
			return nameplateShowAll or isMine
		end
	end
end

function UNITFRAME.PostUpdateGapIcon(_, _, icon)
	icon:Hide()
end

local function getIconSize(w, n, s)
	return (w - (n - 1) * s) / n
end

function UNITFRAME:AddAuras(self)
	local style = self.unitStyle
	local auras = CreateFrame('Frame', nil, self)
	auras.gap = true
	auras.spacing = 4
	auras.numTotal = 32

	if style == 'target' then
		auras.initialAnchor = 'BOTTOMLEFT'
		auras:SetPoint('BOTTOM', self, 'TOP', 0, 24)
		auras['growth-y'] = 'UP'
		auras.iconsPerRow = C.DB.unitframe.target_auras_per_row
	elseif style == 'pet' or style == 'focus' or style == 'boss' or style == 'arena' then
		auras.initialAnchor = 'TOPLEFT'
		auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		auras['growth-y'] = 'DOWN'

		if style == 'pet' then
			auras.iconsPerRow = C.DB.unitframe.pet_auras_per_row
		elseif style == 'focus' then
			auras.iconsPerRow = C.DB.unitframe.focus_auras_per_row
		elseif style == 'boss' then
			auras.iconsPerRow = C.DB.unitframe.boss_auras_per_row
		elseif style == 'arena' then
			auras.iconsPerRow = C.DB.unitframe.arena_auras_per_row
		end
	elseif style == 'nameplate' then
		auras.initialAnchor = 'BOTTOMLEFT'
		auras:SetPoint('BOTTOM', self, 'TOP', 0, 8)
		auras['growth-y'] = 'UP'
		auras.size = C.DB.nameplate.aura_size
		auras.numTotal = C.DB.nameplate.aura_number
		auras.gap = false
		auras.disableMouse = true
	end

	local width = self:GetWidth()
	local maxAuras = auras.numTotal or auras.numBuffs + auras.numDebuffs
	local maxLines = auras.iconsPerRow and floor(maxAuras / auras.iconsPerRow + .5) or 2

	auras.size = auras.iconsPerRow and getIconSize(width, auras.iconsPerRow, auras.spacing) or auras.size
	auras:SetWidth(width)
	auras:SetHeight((auras.size + auras.spacing) * maxLines)

	auras.onlyShowPlayer = C.DB.unitframe.debuffs_by_player
	auras.showDebuffType = C.DB.unitframe.debuff_type
	auras.showStealableBuffs = C.DB.unitframe.stealable_buffs
	auras.CustomFilter = UNITFRAME.CustomFilter
	auras.PostCreateIcon = UNITFRAME.PostCreateIcon
	auras.PostUpdateIcon = UNITFRAME.PostUpdateIcon
	auras.PostUpdateGapIcon = UNITFRAME.PostUpdateGapIcon
	auras.PreUpdate = BolsterPreUpdate
	auras.PostUpdate = BolsterPostUpdate

	self.Auras = auras
end

--[[ Corner aura indicator ]]
local found = {}
local auraFilter = {
	'HELPFUL',
	'HARMFUL'
}

function UNITFRAME:UpdateCornerBuffs(event, unit)
	if event == 'UNIT_AURA' and self.unit ~= unit then
		return
	end

	local spellList = C.CornerBuffsList[C.MyClass]
	local buttons = self.BuffIndicator
	unit = self.unit

	wipe(found)
	for _, filter in next, auraFilter do
		for i = 1, 32 do
			local name, _, _, _, duration, expiration, caster, _, _, spellID = UnitAura(unit, i, filter)
			if not name then
				break
			end
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
	if not C.DB.unitframe.group_corner_buffs then
		return
	end

	local parent = CreateFrame('Frame', nil, self.Health)
	parent:SetPoint('TOPLEFT', 4, -4)
	parent:SetPoint('BOTTOMRIGHT', -4, 4)

	local anchors = {
		'TOPLEFT',
		'TOP',
		'TOPRIGHT',
		'LEFT',
		'RIGHT',
		'BOTTOMLEFT',
		'BOTTOM',
		'BOTTOMRIGHT'
	}
	local buttons = {}
	for _, anchor in pairs(anchors) do
		local bu = CreateFrame('Frame', nil, parent)
		bu:SetFrameLevel(self.Health:GetFrameLevel() + 2)
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

--[[ Debuff highlight ]]
function UNITFRAME:AddDebuffHighlight(self)
	if not C.DB.unitframe.group_debuff_highlight then
		return
	end

	self.DebuffHighlight = self:CreateTexture(nil, 'OVERLAY')
	self.DebuffHighlight:SetAllPoints(self)
	self.DebuffHighlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	self.DebuffHighlight:SetTexCoord(0, 1, .5, 1)
	self.DebuffHighlight:SetVertexColor(.6, .6, .6, 0)
	self.DebuffHighlight:SetBlendMode('ADD')
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightFilter = true
end

--[[ Group debuffs ]]
local debuffList = {}
function UNITFRAME:UpdateGroupDebuffs()
	wipe(debuffList)
	for instName, value in pairs(C.RaidDebuffsList) do
		for spell, priority in pairs(value) do
			if not (FREE_ADB['raid_debuffs_list'][instName] and FREE_ADB['raid_debuffs_list'][instName][spell]) then
				if not debuffList[instName] then
					debuffList[instName] = {}
				end
				debuffList[instName][spell] = priority
			end
		end
	end
	for instName, value in pairs(FREE_ADB['raid_debuffs_list']) do
		for spell, priority in pairs(value) do
			if priority > 0 then
				if not debuffList[instName] then
					debuffList[instName] = {}
				end
				debuffList[instName][spell] = priority
			end
		end
	end
end

local function buttonOnEnter(self)
	if not self.index then
		return
	end
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:ClearLines()
	GameTooltip:SetUnitAura(self.__owner.unit, self.index, self.filter)
	GameTooltip:Show()
end

function UNITFRAME:AddRaidDebuffs(self)
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

	bu.count = F.CreateFS(bu, C.Assets.Fonts.Square, 11, nil, '', nil, true, 'TOPRIGHT', 2, 4)
	bu.timer = F.CreateFS(bu, C.Assets.Fonts.Square, 11, nil, '', nil, true, 'BOTTOMLEFT', 2, -4)

	if not C.DB.unitframe.auras_click_through then
		bu:SetScript('OnEnter', buttonOnEnter)
		bu:SetScript('OnLeave', F.HideTooltip)
	end

	bu.ShowDispellableDebuff = true
	bu.ShowDebuffBorder = true
	bu.FilterDispellableDebuff = true

	if C.DB.unitframe.raid_debuffs then
		if not next(debuffList) then
			UNITFRAME:UpdateGroupDebuffs()
		end

		bu.Debuffs = debuffList
	end

	self.RaidDebuffs = bu
end

--[[ Castbar ]]
local channelingTicks = {
	[740] = 4, -- 宁静
	[755] = 5, -- 生命通道
	[5143] = 4, -- 奥术飞弹
	[12051] = 6, -- 唤醒
	[15407] = 6, -- 精神鞭笞
	[47757] = 3, -- 苦修
	[47758] = 3, -- 苦修
	[48045] = 6, -- 精神灼烧
	[64843] = 4, -- 神圣赞美诗
	[120360] = 15, -- 弹幕射击
	[198013] = 10, -- 眼棱
	[198590] = 5, -- 吸取灵魂
	[205021] = 5, -- 冰霜射线
	[205065] = 6, -- 虚空洪流
	[206931] = 3, -- 饮血者
	[212084] = 10, -- 邪能毁灭
	[234153] = 5, -- 吸取生命
	[257044] = 7, -- 急速射击
	[291944] = 6, -- 再生，赞达拉巨魔
	[314791] = 4, -- 变易幻能
	[324631] = 8 -- 血肉铸造，盟约
}

if C.MyClass == 'PRIEST' then
	local function updateTicks()
		local numTicks = 3
		if IsPlayerSpell(193134) then
			numTicks = 4
		end
		channelingTicks[47757] = numTicks
		channelingTicks[47758] = numTicks
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
				ticks[i]:SetTexture(C.Assets.bd_tex)
				ticks[i]:SetVertexColor(0, 0, 0, .85)
				ticks[i]:SetWidth(C.Mult)
				ticks[i]:SetHeight(bar:GetHeight())
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint('CENTER', bar, 'LEFT', delta * i, 0)
			ticks[i]:Show()
		end
	else
		for _, tick in pairs(ticks) do
			tick:Hide()
		end
	end
end

function UNITFRAME:OnCastbarUpdate(elapsed)
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
		if (not C.DB.unitframe.castbar_focus_separate and self.__owner.unit == 'focus') then
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

function UNITFRAME:PostCastStart(unit)
	local castingColor = C.DB.unitframe.casting_color
	local notInterruptibleColor = C.DB.unitframe.casting_uninterruptible_color

	self:SetAlpha(1)
	self.Spark:Show()

	self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b)

	if unit == 'vehicle' or UnitInVehicle('player') then
		if self.SafeZone then
			self.SafeZone:Hide()
		end
		if self.Lag then
			self.Lag:Hide()
		end
	elseif unit == 'player' then
		local safeZone = self.SafeZone
		if not safeZone then
			return
		end

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
			numTicks = channelingTicks[self.spellID] or 0
		end
		updateCastBarTicks(self, numTicks)
	elseif not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b)
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

	if self.Glow and not (C.DB.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		if self.notInterruptible then
			self.Glow:SetBackdropBorderColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, .35)
		else
			self.Glow:SetBackdropBorderColor(castingColor.r, castingColor.g, castingColor.b, .35)
		end
	end

	if C.DB.unitframe.castbar_focus_separate and self.__owner.unit == 'focus' then
		if self.notInterruptible then
			self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, 1)
		else
			self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b, 1)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .6)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 1)
	else
		if self.notInterruptible then
			self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b, .5)
		else
			self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b, .5)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .2)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 0)
	end

	self.Text:SetText('')
 -- disable casting spell name, we only need interrupt info
end

function UNITFRAME:PostUpdateInterruptible(unit)
	local castingColor = C.DB.unitframe.casting_color
	local notInterruptibleColor = C.DB.unitframe.casting_uninterruptible_color

	if not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(notInterruptibleColor.r, notInterruptibleColor.g, notInterruptibleColor.b)
	else
		self:SetStatusBarColor(castingColor.r, castingColor.g, castingColor.b)
	end
end

function UNITFRAME:PostCastStop()
	local completeColor = C.DB.unitframe.casting_complete_color

	if not self.fadeOut then
		self:SetStatusBarColor(completeColor.r, completeColor.g, completeColor.b)
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

function UNITFRAME:PostCastFailed()
	local failColor = C.DB.unitframe.casting_fail_color

	self:SetStatusBarColor(failColor.r, failColor.g, failColor.b)
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
end

function UNITFRAME:AddCastBar(self)
	if not C.DB.unitframe.enable_castbar then
		return
	end

	local castbar = CreateFrame('StatusBar', 'oUF_Castbar' .. self.unitStyle, self)
	castbar:SetStatusBarTexture(C.Assets.statusbar_tex)
	castbar:SetStatusBarColor(0, 0, 0, 0)
	castbar.Bg = F.CreateBDFrame(castbar)
	castbar.Glow = F.CreateSD(castbar.Bg, .35, 4, 4)

	if (not C.DB.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
		castbar:SetFillStyle('REVERSE')
	end

	if self.unitStyle == 'focus' and C.DB.unitframe.castbar_focus_separate then
		castbar:SetSize(C.DB.unitframe.castbar_focus_width, C.DB.unitframe.castbar_focus_height)
		castbar:ClearAllPoints()

		F.Mover(
			castbar,
			L['UNITFRAME_MOVER_CASTBAR'],
			'FocusCastbar',
			{
				'CENTER',
				UIParent,
				'CENTER',
				0,
				200
			},
			C.DB.unitframe.castbar_focus_width,
			C.DB.unitframe.castbar_focus_height
		)
	else
		castbar:SetAllPoints(self)
		castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
		castbar:SetSize(self:GetWidth(), self:GetHeight())
	end

	self.Castbar = castbar

	local spark = castbar:CreateTexture(nil, 'OVERLAY')
	spark:SetTexture(C.Assets.spark_tex)
	spark:SetBlendMode('ADD')
	spark:SetAlpha(.7)
	spark:SetSize(12, castbar:GetHeight() * 2)
	castbar.Spark = spark

	if C.DB.unitframe.castbar_timer then
		local timer = F.CreateFS(castbar, C.Assets.Fonts.Regular, 11, 'OUTLINE')
		timer:SetPoint('CENTER', castbar)
		castbar.Time = timer
	end

	local text = F.CreateFS(castbar, C.Assets.Fonts.Regular, 9, 'OUTLINE')
	text:SetPoint('TOP', castbar, 'BOTTOM', 0, -2)
	text:Hide()
	castbar.Text = text

	local iconFrame = CreateFrame('Frame', nil, castbar)
	if C.DB.unitframe.castbar_focus_separate and self.unitStyle == 'focus' then
		iconFrame:SetSize(castbar:GetHeight() + 4, castbar:GetHeight() + 4)
	else
		iconFrame:SetSize(castbar:GetHeight() + 6, castbar:GetHeight() + 6)
	end

	if (not C.DB.unitframe.castbar_focus_separate and self.unitStyle == 'focus') then
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
		local safeZone = castbar:CreateTexture(nil, 'OVERLAY')
		safeZone:SetTexture(C.Assets.bd_tex)
		safeZone:SetVertexColor(223 / 255, 63 / 255, 107 / 255, .6)
		safeZone:SetPoint('TOPRIGHT')
		safeZone:SetPoint('BOTTOMRIGHT')
		castbar.SafeZone = safeZone
	end

	castbar.decimal = '%.1f'

	castbar.OnUpdate = UNITFRAME.OnCastbarUpdate
	castbar.PostCastStart = UNITFRAME.PostCastStart
	castbar.PostCastStop = UNITFRAME.PostCastStop
	castbar.PostCastFail = UNITFRAME.PostCastFailed
	castbar.PostCastInterruptible = UNITFRAME.PostUpdateInterruptible
end

--[[ Class power ]]
local function PostUpdateClassPower(element, cur, max, diff, powerType)
	local maxWidth, gap = C.DB.unitframe.player_width, 3

	if diff then
		for i = 1, max do
			element[i]:SetWidth((maxWidth - (max - 1) * gap) / max)
		end
	end

	if max then
		local lastBar = element[max]
		local r, g, b = unpack(lastBarColors[C.MyClass])
		lastBar:SetStatusBarColor(r, g, b)
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

local function PostUpdateRunes(element, runemap)
	for index, runeID in next, runemap do
		local rune = element[index]
		local start, duration, runeReady = GetRuneCooldown(runeID)
		if rune:IsShown() then
			if runeReady then
				rune:SetAlpha(1)
				rune:SetScript('OnUpdate', nil)
				if rune.timer then
					rune.timer:SetText(nil)
				end
			elseif start then
				rune:SetAlpha(.3)
				rune.runeDuration = duration
				rune:SetScript('OnUpdate', UNITFRAME.OnUpdateRunes)
			end
		end
	end
end

local function UpdateRunesColor(element)
	local spec = GetSpecialization() or 0

	for index = 1, #element do
		if spec == 1 then -- blood
			element[index]:SetStatusBarColor(177 / 255, 40 / 255, 45 / 255)
		elseif spec == 2 then -- frost
			element[index]:SetStatusBarColor(42 / 255, 138 / 255, 186 / 255)
		elseif spec == 3 then
			element[index]:SetStatusBarColor(101 / 255, 186 / 255, 112 / 255)
		else
			element[index]:SetStatusBarColor(1, 1, 1)
		end
	end
end

function UNITFRAME:AddClassPowerBar(self)
	local gap = 3
	local barWidth = C.DB.unitframe.player_width
	local barHeight = C.DB.unitframe.class_power_bar_height

	local bars = {}
	for i = 1, 6 do
		bars[i] = CreateFrame('StatusBar', nil, self.ClassPowerBarHolder)
		bars[i]:SetHeight(barHeight)
		bars[i]:SetWidth((barWidth - 5 * gap) / 6)
		bars[i]:SetStatusBarTexture(C.Assets.statusbar_tex)
		bars[i]:SetFrameLevel(self:GetFrameLevel() + 5)

		F.SetBD(bars[i])

		if i == 1 then
			bars[i]:SetPoint('BOTTOMLEFT')
		else
			bars[i]:SetPoint('LEFT', bars[i - 1], 'RIGHT', gap, 0)
		end

		if C.MyClass == 'DEATHKNIGHT' and C.DB.unitframe.runes_timer then
			bars[i].timer = F.CreateFS(bars[i], C.Assets.Fonts.Regular, 11, nil, '')
		end
	end

	if C.MyClass == 'DEATHKNIGHT' then
		bars.colorSpec = true
		bars.sortOrder = 'asc'
		bars.PostUpdate = PostUpdateRunes
		bars.PostUpdateColor = UpdateRunesColor
		self.Runes = bars
	else
		bars.PostUpdate = PostUpdateClassPower
		self.ClassPower = bars
	end
end

--[[ Stagger ]]
function UNITFRAME:AddStagger(self)
	if C.MyClass ~= 'MONK' then
		return
	end
	if not C.DB.unitframe.stagger_bar then
		return
	end

	local stagger = CreateFrame('StatusBar', nil, self.ClassPowerBarHolder)
	stagger:SetAllPoints(self.ClassPowerBarHolder)
	stagger:SetStatusBarTexture(C.Assets.statusbar_tex)

	F.SetBD(stagger)

	local text = F.CreateFS(stagger, C.Assets.Fonts.Regular, 11, nil, '', nil, 'THICK')
	text:SetPoint('TOP', stagger, 'BOTTOM', 0, -4)
	self:Tag(text, '[free:stagger]')

	self.Stagger = stagger
end

--[[ Totems ]]
local totemsColor = {
	{
		0.71,
		0.29,
		0.13
	}, -- red    181 /  73 /  33
	{
		0.26,
		0.71,
		0.13
	}, -- green   67 / 181 /  33
	{
		0.13,
		0.55,
		0.71
	}, -- blue    33 / 141 / 181
	{
		0.58,
		0.13,
		0.71
	}, -- violet 147 /  33 / 181
	{
		0.71,
		0.58,
		0.13
	}
 -- yellow 181 / 147 /  33
}

function UNITFRAME:AddTotems(self)
	if C.MyClass ~= 'SHAMAN' then
		return
	end
	if not C.DB.unitframe.totems_bar then
		return
	end

	local totems = {}
	local maxTotems = 5

	local width, spacing = self:GetWidth(), 3

	width = (self:GetWidth() - (maxTotems + 1) * spacing) / maxTotems
	spacing = width + spacing

	for slot = 1, maxTotems do
		local totem = CreateFrame('StatusBar', nil, self.ClassPowerBarHolder)
		local color = totemsColor[slot]
		local r, g, b = color[1], color[2], color[3]
		totem:SetStatusBarTexture(C.Assets.statusbar_tex)
		totem:SetStatusBarColor(r, g, b)
		totem:SetSize(width, C.DB.unitframe.class_power_bar_height)
		F.SetBD(totem)

		totem:SetPoint('TOPLEFT', self.ClassPowerBarHolder, 'TOPLEFT', (slot - 1) * spacing + 1, 0)

		totems[slot] = totem
	end

	self.CustomTotems = totems
end

--[[ Combat fader ]]
function UNITFRAME:AddCombatFader(self)
	if not C.DB.unitframe.fade then
		return
	end

	if not self.Fader then
		self.Fader = {}
	end

	self.Fader.maxAlhpa = C.DB.unitframe.fade_in_alpha
	self.Fader.minAlpha = C.DB.unitframe.fade_out_alpha
	self.Fader.outDuration = C.DB.unitframe.fade_out_duration
	self.Fader.inDuration = C.DB.unitframe.fade_in_duration
	self.Fader.hover = C.DB.unitframe.condition_hover
	self.Fader.arena = C.DB.unitframe.condition_arena
	self.Fader.instance = C.DB.unitframe.condition_instance
	self.Fader.combat = C.DB.unitframe.condition_combat
	self.Fader.target = C.DB.unitframe.condition_target
	self.Fader.casting = C.DB.unitframe.condition_casting
	self.Fader.injured = C.DB.unitframe.condition_injured
	self.Fader.mana = C.DB.unitframe.condition_mana
	self.Fader.power = C.DB.unitframe.condition_power
end

--[[ Range check ]]
function UNITFRAME:AddRangeCheck(self)
	if not C.DB.unitframe.range_check then
		return
	end

	if not self.RangeCheck then
		self.RangeCheck = {}
	end

	self.RangeCheck.enabled = true
	self.RangeCheck.insideAlpha = 1
	self.RangeCheck.outsideAlpha = 0.4
end

--[[ GCD ]]
function UNITFRAME:AddGCDSpark(self)
	if not C.DB.unitframe.gcd_spark then
		return
	end

	self.GCD = CreateFrame('Frame', nil, self)
	self.GCD:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)
	self.GCD:SetFrameLevel(self.Health:GetFrameLevel() + 4)
	self.GCD:SetWidth(self:GetWidth())
	self.GCD:SetHeight(6)

	self.GCD.Color = {
		1,
		1,
		1
	}
	self.GCD.Height = 6
	self.GCD.Width = 6
end

--[[ Indicatiors ]]
function UNITFRAME:AddPvPIndicator(self)
	if not C.DB.unitframe.player_pvp_indicator then
		return
	end

	local pvpIndicator =
		F.CreateFS(
		self,
		{
			C.Assets.Fonts.Regular,
			11,
			nil
		},
		nil,
		nil,
		'P',
		'RED',
		'THICK'
	)
	pvpIndicator:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 5, 0)

	pvpIndicator.SetTexture = F.Dummy
	pvpIndicator.SetTexCoord = F.Dummy

	self.PvPIndicator = pvpIndicator
end

local function CombatIndicatorPostUpdate(self, inCombat)
	local isResting = IsResting()
	if inCombat then
		self.__owner.RestingIndicator:Hide()
	elseif isResting then
		self.__owner.RestingIndicator:Show()
	end
end

function UNITFRAME:AddCombatIndicator(self)
	if not C.DB.unitframe.player_combat_indicator then
		return
	end

	local combatIndicator = self:CreateTexture(nil, 'OVERLAY')
	combatIndicator:SetPoint('BOTTOMLEFT', self, 'TOPLEFT')
	combatIndicator:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT')
	combatIndicator:SetHeight(6)
	combatIndicator:SetTexture(C.Assets.glow_tex)
	combatIndicator:SetVertexColor(1, 0, 0, .25)

	self.CombatIndicator = combatIndicator
	self.CombatIndicator.PostUpdate = CombatIndicatorPostUpdate
end

function UNITFRAME:AddRestingIndicator(self)
	if not C.DB.unitframe.player_resting_indicator then
		return
	end

	local restingIndicator = self:CreateTexture(nil, 'OVERLAY')
	restingIndicator:SetPoint('BOTTOMLEFT', self, 'TOPLEFT')
	restingIndicator:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT')
	restingIndicator:SetHeight(6)
	restingIndicator:SetTexture(C.Assets.glow_tex)
	restingIndicator:SetVertexColor(0, 1, 0, .25)

	self.RestingIndicator = restingIndicator
end

function UNITFRAME:AddRaidTargetIndicator(self)
	if not C.DB.unitframe.target_icon_indicator then
		return
	end

	local raidTargetIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	raidTargetIndicator:SetTexture(C.Assets.target_icon)
	raidTargetIndicator:SetAlpha(C.DB.unitframe.target_icon_indicator_alpha)
	raidTargetIndicator:SetSize(C.DB.unitframe.target_icon_indicator_size, C.DB.unitframe.target_icon_indicator_size)
	raidTargetIndicator:SetPoint('CENTER', self)

	self.RaidTargetIndicator = raidTargetIndicator
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
			lfdrole:SetTextColor(.8, .2, .1, 1)
			lfdrole:SetText('*')
		elseif role == 'TANK' then
			lfdrole:SetTextColor(.9, .8, .2, 1)
			lfdrole:SetText('#')
		elseif role == 'HEALER' then
			lfdrole:SetTextColor(0, 1, 0, 1)
			lfdrole:SetText('+')
		else
			lfdrole:SetTextColor(0, 0, 0, 0)
		end
	end

	local groupRoleIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', '', nil, false, 'BOTTOM', 1, 1)
	groupRoleIndicator.Override = UpdateLFD
	self.GroupRoleIndicator = groupRoleIndicator
end

function UNITFRAME:AddLeaderIndicator(self)
	local leaderIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', '!', nil, false, 'TOPLEFT', 2, -2)

	self.LeaderIndicator = leaderIndicator
end

function UNITFRAME:AddPhaseIndicator(self)
	local phase = CreateFrame('Frame', nil, self)
	phase:SetSize(16, 16)
	phase:SetPoint('CENTER', self)
	phase:SetFrameLevel(5)
	phase:EnableMouse(true)
	local icon = phase:CreateTexture(nil, 'OVERLAY')
	icon:SetAllPoints()
	phase.Icon = icon
	self.PhaseIndicator = phase
end

function UNITFRAME:AddSummonIndicator(self)
	local summonIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	summonIndicator:SetSize(self:GetHeight() * .8, self:GetHeight() * .8)
	summonIndicator:SetPoint('CENTER')

	self.SummonIndicator = summonIndicator
end

function UNITFRAME:AddResurrectIndicator(self)
	local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	resurrectIndicator:SetSize(self:GetHeight() * .8, self:GetHeight() * .8)
	resurrectIndicator:SetPoint('CENTER')

	self.ResurrectIndicator = resurrectIndicator
end

--[[ Threat ]]
local function UpdateThreat(self, event, unit)
	if not self.Glow or self.unit ~= unit then
		return
	end

	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		local r, g, b = GetThreatStatusColor(status)
		self.Glow:SetBackdropBorderColor(r, g, b, .6)
	else
		self.Glow:SetBackdropBorderColor(0, 0, 0, .35)
	end
end

function UNITFRAME:AddThreatIndicator(self)
	if not C.DB.unitframe.group_threat_indicator then
		return
	end

	self.ThreatIndicator = {
		IsObjectType = function()
		end,
		Override = UpdateThreat
	}
end

--[[ Portrait ]]
local function PostUpdatePortrait(element, unit)
	if C.DB.unitframe.portrait_saturation then
		return
	end
	element:SetDesaturation(1)
end

function UNITFRAME:AddPortrait(self)
	if not C.DB.unitframe.portrait then
		return
	end

	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetAllPoints(self)
	portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	portrait:SetAlpha(.1)
	portrait.PostUpdate = PostUpdatePortrait
	self.Portrait = portrait
end

--[[ Party spells ]]
function UNITFRAME:UpdatePartySpells()
	if not next(FREE_ADB['party_spells_list']) then
		for spellID, duration in pairs(C.PartySpells) do
			local name = GetSpellInfo(spellID)
			if name then
				FREE_ADB['party_spells_list'][spellID] = duration
			end
		end
	end
end

local watchingList = {}
function UNITFRAME:PartyWatcherPostUpdate(button, unit, spellID)
	local guid = UnitGUID(unit)
	if not watchingList[guid] then
		watchingList[guid] = {}
	end
	watchingList[guid][spellID] = button
end

function UNITFRAME:HandleCDMessage(...)
	local prefix, msg = ...
	if prefix ~= 'ZenTracker' then
		return
	end

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
					if remaining < 0 then
						remaining = 0
					end
					C_ChatInfo_SendAddonMessage('ZenTracker', format('3:U:%s:%d:%.2f:%.2f:%s', UNITFRAME.myGUID, spellID, duration, remaining, '-'), IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY')
				 -- sync to others
				end
			end
		end
		lastUpdate = thisTime
	end
end

local lastSyncTime = 0
function UNITFRAME:UpdateSyncStatus()
	if IsInGroup() and not IsInRaid() and C.DB.unitframe.party_spell_sync then
		local thisTime = GetTime()
		if thisTime - lastSyncTime > 5 then
			C_ChatInfo_SendAddonMessage('ZenTracker', format('3:H:%s:0::0:1', UNITFRAME.myGUID), IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY')
			 -- handshake to ZenTracker
			lastSyncTime = thisTime
		end
		F:RegisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCDMessage)
	else
		F:UnregisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCDMessage)
	end
end

function UNITFRAME:SyncWithZenTracker()
	if not C.DB.unitframe.party_spell_sync then
		return
	end

	UNITFRAME.myGUID = UnitGUID('player')
	C_ChatInfo.RegisterAddonMessagePrefix('ZenTracker')
	F:RegisterEvent('CHAT_MSG_ADDON', UNITFRAME.HandleCDMessage)

	UNITFRAME:UpdateSyncStatus()
	F:RegisterEvent('GROUP_ROSTER_UPDATE', UNITFRAME.UpdateSyncStatus)
end

function UNITFRAME:AddPartySpells(self)
	if not C.DB.unitframe.party_spell_watcher then
		return
	end

	local horizon = false
	local otherSide = false
	local relF = horizon and 'BOTTOMLEFT' or 'RIGHT'
	local relT = horizon and 'TOPLEFT' or 'LEFT'
	local xOffset = horizon and 0 or -5
	local yOffset = horizon and 5 or 0
	local margin = horizon and 4 or -4
	if otherSide then
		relF = horizon and 'TOPLEFT' or 'LEFT'
		relT = horizon and 'BOTTOMLEFT' or 'RIGHT'
		xOffset = horizon and 0 or 5
		yOffset = horizon and -(self.Power:GetHeight() + 8) or 0
		margin = 2
	end
	local rel1 = not horizon and not otherSide and 'RIGHT' or 'LEFT'
	local rel2 = not horizon and not otherSide and 'LEFT' or 'RIGHT'
	local buttons = {}
	local maxIcons = 6
	local iconSize = horizon and (self:GetWidth() - 2 * abs(margin)) / 3 or (self:GetHeight() * .8)
	if iconSize > 34 then
		iconSize = 34
	end

	for i = 1, maxIcons do
		local bu = CreateFrame('Frame', nil, self)
		bu:SetSize(iconSize, iconSize)
		F.AuraIcon(bu)
		bu.CD:SetReverse(false)
		if i == 1 then
			bu:SetPoint(relF, self, relT, xOffset, yOffset)
		elseif i == 4 and horizon then
			bu:SetPoint(relF, buttons[i - 3], relT, 0, margin)
		else
			bu:SetPoint(rel1, buttons[i - 1], rel2, margin, 0)
		end
		bu:Hide()

		buttons[i] = bu
	end

	buttons.__max = maxIcons
	buttons.PartySpells = C.PartySpellsList
	buttons.TalentCDFix = C.TalentCDFixList
	self.PartyWatcher = buttons
	if C.DB.unitframe.party_spell_sync then
		self.PartyWatcher.PostUpdate = UNITFRAME.PartyWatcherPostUpdate
	end
end

--[[ Tags ]]
function UNITFRAME:AddGroupNameText(self)
	local groupName = F.CreateFS(self.Health, C.Assets.Fonts.Condensed, 10, nil, nil, nil, 'THICK')

	self:Tag(groupName, '[free:groupname][free:offline][free:dead]')
	self.GroupName = groupName
end

function UNITFRAME:AddNameText(self)
	local name = F.CreateFS(self.Health, C.Assets.Fonts.Condensed, 11, nil, nil, nil, 'THICK')

	if self.unitStyle == 'target' then
		name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
	elseif self.unitStyle == 'arena' or self.unitStyle == 'boss' then
		name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
	elseif self.unitStyle == 'nameplate' then
		name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	else
		name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	end

	self:Tag(name, '[free:name] [arenaspec]')
	self.Name = name
end

function UNITFRAME:AddHealthValueText(self)
	local healthValue = F.CreateFS(self.Health, C.Assets.Fonts.Condensed, 11, nil, nil, nil, 'THICK')
	healthValue:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

	if self.unitStyle == 'player' then
		self:Tag(healthValue, '[free:health]')
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
	local powerValue =
		F.CreateFS(
		self.Health,
		{
			C.Assets.Fonts.Regular,
			11,
			nil
		},
		nil,
		nil,
		nil,
		nil,
		'THICK'
	)
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
	local altPowerValue =
		F.CreateFS(
		self.Health,
		{
			C.Assets.Fonts.Regular,
			11,
			nil
		},
		nil,
		nil,
		nil,
		nil,
		'THICK'
	)
	if self.unitStyle == 'boss' then
		altPowerValue:SetPoint('LEFT', self, 'RIGHT', 2, 0)
	else
		altPowerValue:SetPoint('BOTTOM', self.Health, 'TOP', 0, 3)
	end

	self:Tag(altPowerValue, '[free:altpower]')

	self.AlternativePowerValue = altPowerValue
end
