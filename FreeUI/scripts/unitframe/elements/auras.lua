local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module = F:GetModule('Unitframe')

local cfg, oUF, myClass = C.unitframe, ns.oUF, C.Class
local FormatAuraTime = module.FormatAuraTime

local format, min, max, floor, mod, pairs = string.format, math.min, math.max, math.floor, mod, pairs


local ignoredDebuffs = {
	[  6788] = myClass ~= 'PRIEST',		-- Weakened Soul
	[ 25771] = myClass ~= 'PALADIN',	-- Forbearance

	[ 57724] = true, 	-- Sated
	[ 57723] = true,  	-- Exhaustion
	[ 80354] = true,  	-- Temporal Displacement
	[ 41425] = true,  	-- Hypothermia
	[ 95809] = true,  	-- Insanity
	[ 36032] = true,  	-- Arcane Blast
	[ 26013] = true,  	-- Deserter
	[ 95223] = true,  	-- Recently Mass Resurrected
	[ 97821] = true,  	-- Void-Touched (death knight resurrect)
	[ 36893] = true,  	-- Transporter Malfunction
	[ 36895] = true,  	-- Transporter Malfunction
	[ 36897] = true,  	-- Transporter Malfunction
	[ 36899] = true,  	-- Transporter Malfunction
	[ 36900] = true,  	-- Soul Split: Evil!
	[ 36901] = true,  	-- Soul Split: Good
	[ 25163] = true,  	-- Disgusting Oozeling Aura
	[ 85178] = true,  	-- Shrink (Deviate Fish)
	[  8064] = true,   	-- Sleepy (Deviate Fish)
	[  8067] = true,   	-- Party Time! (Deviate Fish)
	[ 24755] = true,  	-- Tricked or Treated (Hallow's End)
	[ 42966] = true, 	-- Upset Tummy (Hallow's End)
	[ 89798] = true, 	-- Master Adventurer Award (Maloriak kill title)
	[  6788] = true,   	-- Weakened Soul
	[ 92331] = true, 	-- Blind Spot (Jar of Ancient Remedies)
	[ 71041] = true, 	-- Dungeon Deserter
	[ 26218] = true,  	-- Mistletoe
	[117870] = true,	-- Touch of the Titans
	[173658] = true, 	-- Delvar Ironfist defeated
	[173659] = true, 	-- Talonpriest Ishaal defeated
	[173661] = true, 	-- Vivianne defeated
	[173679] = true, 	-- Leorajh defeated
	[173649] = true, 	-- Tormmok defeated
	[173660] = true, 	-- Aeda Brightdawn defeated
	[173657] = true, 	-- Defender Illona defeated
	[206151] = true, 	-- 挑战者的负担
	[260738] = true, 	-- 艾泽里特残渣
	[279737] = true,	-- 准备作战 (海岛)
	[264689] = true,	-- 疲倦
	[289423] = true,	-- 死亡的重担
	[283430] = true,	-- 工程学专精
}

local importantBuffs = {
	-- Defensive buffs
	-- Warrior
	[199038] = true, 	-- 扶危助困
	[   871] = true, 	-- 盾墙
	[213871] = true, 	-- 护卫
	[223658] = true, 	-- 捍卫
	[184364] = true, 	-- 狂怒回复
	[ 12975] = true, 	-- 破腹沉舟

	-- Death Knight
	[ 48707] = true, 	-- 反魔法护罩
	[123981] = true, 	-- 永劫不复	
	[145629] = true, 	-- 反魔法领域
	[ 48792] = true, 	-- 冰封之韧
	[ 48265] = true, 	-- 死亡脚步
	[212552] = true, 	-- 幻影步
	[ 81256] = true, 	-- 符文刃舞
	[194844] = true, 	-- 白骨风暴

	-- Paladin
	[228050] = true, 	-- 被遗忘的女王护卫
	[   642] = true, 	-- 圣盾术
	[199448] = true, 	-- 无尽牺牲
	[  1022] = true, 	-- 保护祝福
	[204018] = true, 	-- 破咒祝福
	[210256] = true, 	-- 庇护祝福
	[  6940] = true, 	-- 牺牲祝福		
	[ 86659] = true, 	-- 远古列王守卫	
	[ 31850] = true, 	-- 炽热防御者
	[204150] = true, 	-- 圣光护盾		
	[ 31821] = true, 	-- 光环掌握
	[   498] = true, 	-- 圣佑术	
	[205191] = true, 	-- 以眼还眼	
	[184662] = true, 	-- 复仇之盾
	[  1044] = true, 	-- 自由祝福
	[199545] = true, 	-- 荣耀战马

	-- Shaman
	[  8178] = true, 	-- 根基图腾
	[210918] = true, 	-- 灵体形态
	[207498] = true, 	-- 先祖护佑图腾
	[ 98007] = true, 	-- 灵魂链接图腾
	[204293] = true, 	-- 灵魂链接
	[108271] = true, 	-- 星界转移
    [201633] = true, 	-- 大地之墙图腾
    [260881] = true, 	-- 大地之墙图腾

    -- Hunter
    [186265] = true, 	-- 灵龟守护
	[202748] = true, 	-- 生存战术
	[248519] = true, 	-- 干涉
	[ 53480] = true, 	-- 牺牲咆哮
	[264735] = true, 	-- 优胜略汰
	[281195] = true, 	-- 优胜略汰孤狼技能
	[212704] = true, 	-- 野兽之心	
	[ 54216] = true, 	-- 主人的召唤

	-- Demon Hunter
	[196555] = true, 	-- 虚空行走
	[187827] = true, 	-- 恶魔变形 复仇
	[209426] = true, 	-- 幻影打击
	[212800] = true, 	-- 疾影
	[207771] = true, 	-- 烈火烙印
	[205629] = true, 	-- 恶魔践踏
	[208796] = true, 	-- 锯齿尖刺
	[162264] = true, 	-- 恶魔变形 浩劫
	[206649] = true, 	-- 莱欧瑟拉斯之眼

	-- Druid
	[209753] = true, 	-- 旋风
	[ 61336] = true, 	-- 生存本能
	[102342] = true, 	-- 铁木树皮
	[ 22812] = true, 	-- 树皮术
	[201940] = true, 	-- 盟友守护
	[236696] = true, 	-- 荆棘
	[200947] = true, 	-- 侵蚀藤曼
	[201664] = true, 	-- 挫志咆哮
	[234084] = true, 	-- 明月繁星

	-- Rogue
	[ 11327] = true, 	-- 消失
	[199754] = true, 	-- 还击
	[  1966] = true, 	-- 佯攻
	[197003] = true, 	-- 动若脱兔

	-- Monk
	[122470] = true, 	-- 业报之触（敌方）
	[125174] = true, 	-- 业报之触（自己）	
	[116849] = true, 	-- 作茧缚命
	[115176] = true, 	-- 禅悟冥想
	[122278] = true, 	-- 躯不坏
	[122783] = true, 	-- 散魔功
	[120954] = true, 	-- 壮胆酒 酒仙
	[201318] = true, 	-- 壮胆酒 风行
	[243435] = true, 	-- 壮胆酒 织物
	[202162] = true, 	-- 斗转星移

	-- Mage
	[ 45438] = true, 	-- 寒冰屏障
	[198111] = true, 	-- 时光护盾
	[113862] = true, 	-- 强化隐形术
	[198065] = true, 	-- 陵彩屏障
	[198158] = true, 	-- 群体隐形

	-- Priest
	[213602] = true, 	-- 强化渐隐术
	[ 47585] = true, 	-- 消散
	[ 33206] = true, 	-- 痛苦压制
	[ 81782] = true, 	-- 真言术障
	[ 47788] = true, 	-- 守护之魂
	[232707] = true, 	-- 希望之光 
	[199412] = true, 	-- 狂乱边缘

	-- Warlock
	[212295] = true, 	-- 虚空守卫
	[104773] = true, 	-- 不灭决心
	[108416] = true, 	-- 黑暗契约
	[111400] = true, 	-- 爆燃冲刺	
}

local classBuffs = {
	['PRIEST'] = {
		[194384] = true,	-- 救赎
		[214206] = true,	-- 救赎(PvP)
		[ 41635] = true,	-- 愈合导言
		[193065] = true,	-- 忍辱负重
		[   139] = true,	-- 恢复
		[    17] = true,	-- 真言术盾
		[ 47788] = true,	-- 守护之魂
		[ 33206] = true,	-- 痛苦压制
	},
	['DRUID'] = {
		[   774] = true,	-- 回春
		[155777] = true,	-- 萌芽
		[  8936] = true,	-- 愈合
		[ 33763] = true,	-- 生命绽放
		[ 48438] = true,	-- 野性成长
		[207386] = true,	-- 春暖花开
		[102351] = true,	-- 结界
		[102352] = true,	-- 结界(HoT)
		[200389] = true,	-- 栽培
	},
	['PALADIN'] = {
		[ 53563] = true,	-- 道标
		[156910] = true,	-- 信仰道标
		[200025] = true,	-- 美德道标
		[  1022] = true,	-- 保护
		[  1044] = true,	-- 自由
		[  6940] = true,	-- 牺牲
		[223306] = true,	-- 赋予信仰
	},
	['SHAMAN'] = {
		[ 61295] = true,	-- 激流
		[   974] = true,	-- 大地之盾
		[207400] = true,	-- 先祖活力
	},
	['MONK'] = {
		[119611] = true,	-- 复苏之雾
		[116849] = true,	-- 作茧缚命
		[124682] = true,	-- 氤氲之雾
		[191840] = true,	-- 精华之泉
	},
	['ROGUE'] = {
		[ 57934] = true,	-- 嫁祸
	},
	['WARRIOR'] = {
		[114030] = true,	-- 警戒
	},
	['HUNTER'] = {
		[ 34477] = true,	-- 误导
		[ 90361] = true,	-- 灵魂治愈
	},
	['WARLOCK'] = {
		[ 20707] = true,	-- 灵魂石
	},
	['DEMONHUNTER'] = {},
	['MAGE'] = {},
	['DEATHKNIGHT'] = {},
}







local function UpdateAuraTime(self, elapsed)
	if(self.expiration) then
		self.expiration = math.max(self.expiration - elapsed, 0)

		if(self.expiration > 0 and self.expiration < 30) then
			self.timer:SetText(FormatAuraTime(self.expiration))
			self.timer:SetTextColor(1, 0, 0)
		elseif(self.expiration > 30 and self.expiration < 60) then
			self.timer:SetText(FormatAuraTime(self.expiration))
			self.timer:SetTextColor(1, 1, 0)
		elseif(self.expiration > 60 and self.expiration < 300) then
			self.timer:SetText(FormatAuraTime(self.expiration))
			self.timer:SetTextColor(1, 1, 1)
		else
			self.timer:SetText()
		end
	end
end

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
	button.bg = F.CreateBG(button)
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
	F.SetFS(button.count)

	button.timer = button:CreateFontString(nil, 'OVERLAY')
	button.timer:ClearAllPoints()
	button.timer:SetPoint('BOTTOMLEFT', button, 2, -4)
	F.SetFS(button.timer)

	button:HookScript('OnUpdate', UpdateAuraTime)

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

	if(duration and duration > 0) then
		button.expiration = expiration - GetTime()
	else
		button.expiration = math.huge
	end

	if (style == 'party' and not button.isDebuff) or style == 'raid' or style == 'pet' then
		button.timer:Hide()
	end

	if canStealOrPurge and (style ~= 'party' or style ~= 'raid') then
		button.bg:SetVertexColor(1, 1, 1)

		if button.glow then
			button.glow:SetBackdropBorderColor(1, 1, 1, .5)
		end
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.bg:SetVertexColor(color[1], color[2], color[3])

		if button.glow then
			button.glow:SetBackdropBorderColor(color[1], color[2], color[3], .5)
		end
	elseif (style == 'party' or style == 'raid') and not button.isDebuff then
		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, 0)
		end
	else
		button.bg:SetVertexColor(0, 0, 0)

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
	elseif style == 'target' then
		if (cfg.debuffbyPlayer and button.isDebuff and not button.isPlayer) then
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
		if (button.isDebuff and not ignoredDebuffs[spellID]) then
			return true
		elseif (button.isPlayer and classBuffs[myClass][spellID]) or (importantBuffs[spellID]) then
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
module.CustomFilter = CustomFilter

local function PostUpdateGapIcon(self, unit, icon, visibleBuffs)
	icon:Hide()
end

local function AuraIconSize(w, n, s)
	return (w-(n-1)*s)/n
end

function module:AddAuras(self)
	local num, perrow = 0, 0
	local Auras = CreateFrame('Frame', nil, self)

	if self.unitStyle == 'target' then
		Auras.initialAnchor = 'BOTTOMLEFT'
		Auras:SetPoint('BOTTOM', self, 'TOP', 0, 24)
		Auras['growth-y'] = 'UP'
		Auras['spacing-x'] = 5
		num = cfg.target_auraTotal
		perrow = cfg.target_auraPerRow
	elseif self.unitStyle == 'pet' or self.unitStyle == 'focus' or self.unitStyle == 'boss' or self.unitStyle == 'arena' then
		Auras.initialAnchor = 'TOPLEFT'
		Auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		Auras['growth-y'] = 'DOWN'
		Auras['spacing-x'] = 5
	elseif self.unitStyle == 'pet' then
		num = cfg.pet_auraTotal
		perrow = cfg.pet_auraPerRow
	elseif self.unitStyle == 'focus' then
		num = cfg.focus_auraTotal
		perrow = cfg.focus_auraPerRow
	elseif self.unitStyle == 'boss' then
		num = cfg.boss_auraTotal
		perrow = cfg.boss_auraPerRow
	elseif self.unitStyle == 'arena' then
		num = cfg.arena_auraTotal
		perrow = cfg.arena_auraPerRow
	end

	Auras.numTotal = num
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

function module:AddBuffs(self)
	local buffs = CreateFrame('Frame', nil, self)
	buffs.initialAnchor = 'CENTER'
	--buffs:SetPoint('TOP', 0, -2)
	buffs['growth-x'] = 'RIGHT'
	buffs.spacing = 3
	buffs.num = 3
	
	if self.unitStyle == 'party' then
		buffs.size = 18
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -20, -2)
			elseif icons.visibleBuffs == 2 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -10, -2)
			else
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	else
		buffs.size = 12
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -14, -2)
			elseif icons.visibleBuffs == 2 then
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', -7, -2)
			else
				buffs:ClearAllPoints()
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	end

	buffs:SetSize((buffs.size*buffs.num)+(buffs.num-1)*buffs.spacing, buffs.size)

	buffs.disableCooldown = true
	buffs.disableMouse = true
	buffs.PostCreateIcon = PostCreateIcon
	buffs.PostUpdateIcon = PostUpdateIcon
	buffs.CustomFilter = CustomFilter

	self.Buffs = buffs
end

function module:AddDebuffs(self)
	local debuffs = CreateFrame('Frame', nil, self)
	
	if self.unitStyle == 'party' and not cfg.healer_layout then
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
		debuffs:SetPoint('BOTTOM', 0, cfg.power_height - 1)
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
	debuffs:SetSize((debuffs.size*debuffs.num)+(debuffs.num-1)*debuffs.spacing, debuffs.size)
	debuffs.showDebuffType = true
	debuffs.PostCreateIcon = PostCreateIcon
	debuffs.PostUpdateIcon = PostUpdateIcon
	debuffs.CustomFilter = CustomFilter

	self.Debuffs = debuffs
end