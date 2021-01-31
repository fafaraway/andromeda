local F, C = unpack(select(2, ...))
local GUI = F.GUI

--[[
	自身缺失的增益
 ]]
C.ReminderBuffsList = {
	ITEMS = {
		{
			itemID = 178742, -- 瓶装毒素饰品
			spells = {
				[345545] = true
			},
			instance = true,
			combat = true
		},
		{
			itemID = 174906, -- 属性符文
			spells = {
				[317065] = true,
				[270058] = true
			},
			equip = true,
			instance = true,
			disable = true
		}
	},
	MAGE = {
		{
			spells = {
				-- 奥术魔宠
				[210126] = true
			},
			depend = 205022,
			spec = 1,
			combat = true,
			instance = true,
			pvp = true
		},
		{
			spells = {
				-- 奥术智慧
				[1459] = true
			},
			depend = 1459,
			instance = true
		}
	},
	PRIEST = {
		{
			spells = {
				-- 真言术耐
				[21562] = true
			},
			depend = 21562,
			instance = true
		}
	},
	WARRIOR = {
		{
			spells = {
				-- 战斗怒吼
				[6673] = true
			},
			depend = 6673,
			instance = true
		}
	},
	SHAMAN = {
		{
			spells = {
				[192106] = true, -- 闪电之盾
				[974] = true, -- 大地之盾
				[52127] = true -- 水之护盾
			},
			depend = 192106,
			combat = true,
			instance = true,
			pvp = true
		},
		{
			spells = {
				[33757] = true -- 风怒武器
			},
			depend = 33757,
			combat = true,
			instance = true,
			pvp = true,
			weaponIndex = 1,
			spec = 2
		},
		{
			spells = {
				[318038] = true -- 火舌武器
			},
			depend = 318038,
			combat = true,
			instance = true,
			pvp = true,
			weaponIndex = 2,
			spec = 2
		}
	},
	ROGUE = {
		{
			spells = {
				-- 伤害类毒药
				[2823] = true, -- 致命药膏
				[8679] = true, -- 致伤药膏
				[315584] = true -- 速效药膏
			},
			texture = 132273,
			depend = 315584,
			combat = true,
			instance = true,
			pvp = true
		},
		{
			spells = {
				-- 效果类毒药
				[3408] = true, -- 减速药膏
				[5761] = true -- 迟钝药膏
			},
			depend = 3408,
			pvp = true
		}
	}
}

--[[
	嗜血类增益
]]
C.BloodlustList = {57723,57724, 80354, 264689}

--[[
	边角增益指示器
 ]]
C.CornerSpellsList = {
	['PRIEST'] = {
		[194384] = {'TOPRIGHT', {1, 1, .66}}, -- 救赎
		[214206] = {'TOPRIGHT', {1, 1, .66}}, -- 救赎(PvP)
		[41635] = {'BOTTOMRIGHT', {.2, .7, .2}}, -- 愈合导言
		[193065] = {'BOTTOMRIGHT', {.54, .21, .78}}, -- 忍辱负重
		[139] = {'TOPLEFT', {.4, .7, .2}}, -- 恢复
		[17] = {'TOPLEFT', {.7, .7, .7}}, -- 真言术盾
		[47788] = {'LEFT', {.86, .45, 0}, true}, -- 守护之魂
		[33206] = {'LEFT', {.47, .35, .74}, true}, -- 痛苦压制
		[6788] = {'TOP', {.86, .11, .11}, true} -- 虚弱灵魂
	},
	['DRUID'] = {
		[774] = {'TOPRIGHT', {.8, .4, .8}}, -- 回春
		[155777] = {'RIGHT', {.8, .4, .8}}, -- 萌芽
		[8936] = {'BOTTOMLEFT', {.2, .8, .2}}, -- 愈合
		[33763] = {'TOPLEFT', {.4, .8, .2}}, -- 生命绽放
		[188550] = {'TOPLEFT', {.4, .8, .2}}, -- 生命绽放，橙装
		[48438] = {'BOTTOMRIGHT', {.8, .4, 0}}, -- 野性成长
		[207386] = {'TOP', {.4, .2, .8}}, -- 春暖花开
		[102351] = {'LEFT', {.2, .8, .8}}, -- 结界
		[102352] = {'LEFT', {.2, .8, .8}}, -- 结界(HoT)
		[200389] = {'BOTTOM', {1, 1, .4}} -- 栽培
	},
	['PALADIN'] = {
		[287280] = {'TOPLEFT', {1, .8, 0}}, -- 圣光闪烁
		[53563] = {'TOPRIGHT', {.7, .3, .7}}, -- 道标
		[156910] = {'TOPRIGHT', {.7, .3, .7}}, -- 信仰道标
		[200025] = {'TOPRIGHT', {.7, .3, .7}}, -- 美德道标
		[1022] = {'BOTTOMRIGHT', {.2, .2, 1}, true}, -- 保护
		[1044] = {'BOTTOMRIGHT', {.89, .45, 0}, true},
		-- 自由
		[6940] = {'BOTTOMRIGHT', {.89, .1, .1}, true},
		-- 牺牲
		[223306] = {'BOTTOMLEFT', {.7, .7, .3}}, -- 赋予信仰
		[25771] = {'TOP', {.86, .11, .11}, true} -- 自律
	},
	['SHAMAN'] = {
		[61295] = {'TOPRIGHT', {.2, .8, .8}}, -- 激流
		[974] = {'BOTTOMRIGHT', {1, .8, 0}}, -- 大地之盾
		[207400] = {'BOTTOMLEFT', {.6, .8, 1}} -- 先祖活力
	},
	['MONK'] = {
		[119611] = {'TOPLEFT', {.3, .8, .6}}, -- 复苏之雾
		[116849] = {'TOPRIGHT', {.2, .8, .2}, true}, -- 作茧缚命
		[124682] = {'BOTTOMLEFT', {.8, .8, .25}}, -- 氤氲之雾
		[191840] = {'BOTTOMRIGHT', {.27, .62, .7}} -- 精华之泉
	},
	['ROGUE'] = {
		[57934] = {'BOTTOMRIGHT', {.9, .1, .1}} -- 嫁祸
	},
	['WARRIOR'] = {
		[114030] = {'TOPLEFT', {.2, .2, 1}} -- 警戒
	},
	['HUNTER'] = {
		[34477] = {'BOTTOMRIGHT', {.9, .1, .1}}, -- 误导
		[90361] = {'TOPLEFT', {.4, .8, .2}} -- 灵魂治愈
	},
	['WARLOCK'] = {
		[20707] = {'BOTTOMRIGHT', {.8, .4, .8}, true} -- 灵魂石
	},
	['DEMONHUNTER'] = {},
	['MAGE'] = {},
	['DEATHKNIGHT'] = {}
}

--[[
	小队重要增益
 ]]
C.RaidBuffsList = {
	-- Paladin
	[642] = true, -- 圣盾术
	[204018] = true, -- 破咒祝福
	[1022] = true, -- 保护祝福
	[1044] = true, -- 自由祝福
	[6940] = true, -- Blessing of Sacrifice
	[31884] = true, -- 复仇之怒
	[231895] = true, -- 征伐
	[105809] = true, -- 神圣复仇者
	[31850] = true, -- 炽热防御者
	[205191] = true, -- 以眼还眼
	[184662] = true, -- 复仇之盾
	[86659] = true, -- 远古列王守卫
	[212641] = true, -- Guardian of Ancient Kings (Glyph)
	[228049] = true, -- 被遗忘的女王护卫
	[216331] = true, -- 复仇十字军
	[210294] = true, -- 神恩术
	[498] = true, -- 圣佑术
	[215652] = true, -- 美德之盾
	-- Warrior
	[871] = true, -- 盾墙
	[118038] = true, -- 剑在人在
	[184364] = true, -- 狂怒回复
	[18499] = true, -- 狂暴之怒
	[1719] = true, -- Recklessness (Fury)
	[262228] = true, -- Deadly Calm (Arms)
	[107574] = true, -- Avatar
	[197690] = true, -- 防御姿态
	[23920] = true, -- SpellReflection
	[330279] = true, -- Overwatch PvP talent
	[236273] = true, -- 决斗
	[260708] = true, -- Sweeping Strikes
	[202147] = true, -- Second Wind
	[12975] = true, -- 破釜沉舟
	[223658] = true, -- 捍卫
	-- Priest
	[27827] = true, -- 救赎之魂
	[33206] = true, -- 痛苦压制
	[47585] = true, -- 消散
	[47788] = true, -- 守护之魂
	[10060] = true, -- 能量灌注
	[197862] = true, -- 天使长
	[197871] = true, -- 黑暗天使长
	[200183] = true, -- 神圣化身
	[213610] = true, -- 神圣守卫
	[197268] = true, -- 希望之光
	[193223] = true, -- 疯入膏肓
	[319952] = true, -- 疯入膏肓
	[47536] = true, -- 全神贯注
	[109964] = true, -- 灵魂护壳
	[194249] = true, -- 虚空形态
	[218413] = true, -- 虚空形态
	[15286] = true, -- 吸血鬼的拥抱
	[213602] = true, -- 强化渐隐术
	-- Druid
	[102342] = true, -- 铁木树皮
	[102560] = true, -- 化身：艾露恩之眷
	[102543] = true, -- 化身：丛林之王
	[102558] = true, -- 化身：乌索克的守护者
	[33891] = true, -- 化身：生命之树
	[61336] = true, -- 生存本能
	[22812] = true, -- 树皮术
	[106951] = true, -- 狂暴
	[69369] = true, -- 掠食者的迅捷
	[194223] = true, -- 超凡之盟
	[102351] = true, -- 塞纳里奥结界
	[155835] = true, -- 鬃毛倒竖
	[29166] = true, -- 激活
	[236696] = true, -- 荆棘术
	[305497] = true, -- 荆棘术
	[108291] = true, -- 野性之心
	[108292] = true, -- 野性之心
	[108293] = true, -- 野性之心
	[108294] = true, -- 野性之心
	[323546] = true, -- 饕餮狂乱
	-- Warlock
	[104773] = true, -- 不灭决心
	[108416] = true, -- DarkPact
	[196098] = true, -- Soul Harvest (Legion's Version)
	[113860] = true, -- Dark Soul: Misery (Affliction)
	[113858] = true, -- Dark Soul: Instability (Destruction)
	[212295] = true, -- NetherWard
	-- Shaman
	[108271] = true, -- 星界转移
	[204288] = true, -- 大地之盾
	[79206] = true, -- 灵魂行者的恩赐
	[114050] = true, -- 升腾
	[114051] = true, -- 升腾
	[114052] = true, -- 升腾
	[210918] = true, -- 灵体形态
	[204293] = true, -- 灵魂链接
	[20608] = true, -- Reincarnation
	[207654] = true, -- Servant of the Queen
	-- Monk
	[122278] = true, -- 躯不坏
	[122783] = true, -- 散魔功
	[115203] = true, -- 壮胆酒
	[201318] = true, -- 壮胆酒
	[243435] = true, -- 壮胆酒
	[115176] = true, -- 禅悟冥想
	[116849] = true, -- 作茧缚命
	[152173] = true, -- 屏气凝神
	[197908] = true, -- 法力茶
	[209584] = true, -- 禅意聚神茶
	[202335] = true, -- 醉上加醉
	[310454] = true, -- 精序兵戈
	-- Hunter
	[186265] = true, -- 灵龟守护
	[19263] = true, -- 威慑
	[53271] = true, -- 主人的召唤
	[53480] = true, -- 牺牲咆哮
	[186257] = true, -- 猎豹守护
	[212640] = true, -- 治疗绷带
	[193530] = true, -- 野性守护
	[266779] = true, -- 协同进攻
	[186289] = true, -- 雄鹰守护
	[202748] = true, -- 生存战术
	[212704] = true, -- 野兽之心
	[264735] = true, -- 优胜劣汰
	-- Mage
	[45438] = true, -- 冰箱
	[113862] = true, -- Greater Invisibility
	[87023] = true, -- 灸灼
	[86949] = true, -- Cauterize
	[87024] = true, -- Cauterize
	[12042] = true, -- ArcanePower
	[12472] = true, -- IcyVeins
	[198111] = true, -- TemporalShield
	[198144] = true, -- IceForm
	[190319] = true, -- Combustion
	[110909] = true, -- AlterTime
	[342246] = true, -- AlterTime
	[108978] = true, -- AlterTime
	[324220] = true, -- Necrolord
	-- Rogue
	[2983] = true, -- Sprint
	[31224] = true, -- Cloak
	[5277] = true, -- Evasion
	[121471] = true, -- 暗影之刃
	[199754] = true, -- 还击
	[31230] = true, --CheatDeath
	[45182] = true, --CheatDeath
	[343142] = true, -- 恐惧之刃
	[207736] = true, -- 暗影决斗
	[1966] = true, -- Feint
	[114018] = true, -- Shroud of Concealment
	[115834] = true, -- Shroud of Concealment
	-- DK
	[123981] = true, -- 永劫不复
	[48792] = true, -- 冰封之韧
	[55233] = true, -- 吸血鬼之血
	[51271] = true, -- 冰霜之柱
	[48707] = true, -- 反魔法护罩
	[145629] = true, -- Anti-Magic Zone
	[219809] = true, -- 墓石
	[194679] = true, -- 符文分流
	[194844] = true, -- 白骨风暴
	[207319] = true, -- 血肉之盾
	[116888] = true, -- 炼狱蔽体
	[49039] = true, -- 巫妖之躯
	[288977] = true, -- 鲜血灌注
	[315443] = true, -- 憎恶附肢
	[311648] = true, -- 云集之雾
	-- DH
	[209261] = true, -- 未被污染的邪能
	[196555] = true, -- 虚空行走
	[198589] = true, -- Blur
	[212800] = true, -- Blur
	[162264] = true, -- Metamorphosis
	[187827] = true, -- Metamorphosis (Vengeance)
	[207811] = true, -- Nether Bond (DH)
	[207810] = true, -- Nether Bond (Target)
	[263648] = true, -- Soul Barrier
	[209426] = true, -- Darkness
	[196718] = true, -- Darkness
	[203819] = true, -- Demon Spikes
	-- Covenant
	[319217] = true, -- 灵茧守护者
	[320224] = true, -- 灵茧守护者
	-- MISC
	[160029] = true, -- 正在复活
	-- Potion
	[307159] = true, -- 幽魂敏捷药水
	[307162] = true, -- 幽魂智力药水
	[307163] = true, -- 幽魂耐力药水
	[307164] = true, -- 幽魂力量药水
	[307494] = true, -- 强化驱魔药水
	[307495] = true, -- 幻影火焰药水
	[307496] = true, -- 神圣觉醒药水
	[307497] = true, -- 死亡偏执药水
	[344314] = true, -- 心华之速药水
	-- Bloodlust
	[2825] = true, -- 嗜血
	[32182] = true, -- 英勇
	[80353] = true, -- 时间扭曲
	[264667] = true, -- 原始狂怒
	[178207] = true, -- 狂怒战鼓
	[230935] = true, -- 高山战鼓
	[256740] = true, -- 漩涡战鼓
	[309658] = true, -- 死亡凶蛮战鼓
	[102364] = true, -- 青铜龙的祝福
	[292686] = true -- 制皮鼓
}

--[[
	团队增益检查
 ]]
C.GroupBuffsCheckList = {
	[1] = {
		-- 合剂
		307166, -- 大锅
		307185, -- 通用合剂
		307187 -- 耐力合剂
	},
	[2] = {
		-- 进食充分
		104273 -- 250敏捷，BUFF名一致
	},
	[3] = {
		-- 10%智力
		1459,
		264760
	},
	[4] = {
		-- 10%耐力
		21562,
		264764
	},
	[5] = {
		-- 10%攻强
		6673,
		264761
	},
	[6] = {
		-- 符文
		270058
	}
}

--[[
	小队技能冷却
 ]]
C.PartySpellsList = {
	[57994] = 12, -- 风剪
	[1766] = 15, -- 脚踢
	[6552] = 15, -- 拳击
	[47528] = 15, -- 心灵冰冻
	[96231] = 15, -- 责难
	[106839] = 15, -- 迎头痛击
	[116705] = 15, -- 切喉手
	[183752] = 15, -- 瓦解
	[187707] = 15, -- 压制
	[2139] = 24, -- 法术反制
	[147362] = 24, -- 反制射击
	[15487] = 45, -- 沉默
	[109248] = 45, -- 束缚射击
	[78675] = 60, -- 日光术
	[30283] = 45, -- 暗影之怒
	[8143] = 60, -- 战栗图腾
	[19577] = 60, -- 胁迫
	[102793] = 60, -- 乌索尔旋风
	[119381] = 60, -- 扫堂腿
	[179057] = 60, -- 混乱新星
	[205636] = 60, -- 树人
	[102342] = 90, -- 铁木树皮
	[288613] = 120, -- 百发百中
	[31224] = 120, -- 暗影斗篷
	[190319] = 120, -- 燃烧
	[31884] = 120, -- 复仇之怒
	[231895] = 120, -- 征罚
	[186265] = 180, -- 灵龟守护
	[102560] = 180, -- 鸟德化身
	[194223] = 180, -- 超凡之盟
	[204018] = 180, -- 破咒祝福
	[1022] = 300, -- 保护祝福
	[25046] = 120, -- 奥术洪流
	[28730] = 120,
	[50613] = 120,
	[69179] = 120,
	[80483] = 120,
	[129597] = 120,
	[155145] = 120,
	[202719] = 120,
	[232633] = 120
}

C.TalentCDFixList = {
	[740] = 120, -- 宁静
	[2094] = 90, -- 致盲
	[15286] = 75, -- 吸血鬼的拥抱
	[15487] = 30, -- 沉默
	[22812] = 40, -- 树皮术
	[30283] = 30, -- 暗影之怒
	[48792] = 165, -- 冰封之韧
	[79206] = 60, -- 灵魂行者的恩赐
	[102342] = 45, -- 铁木树皮
	[108199] = 90, -- 血魔之握
	[109304] = 105, -- 意气风发
	[116849] = 100, -- 作茧缚命
	[119381] = 40, -- 扫堂腿
	[179057] = 40 -- 混乱新星
}

C.PartySpellsDB = {
	['DEATHKNIGHT'] = {
		[42650] = 480, -- 大军
		[47528] = 15, -- 心灵冰冻
		[47568] = 105, -- 符文武器增效
		[48707] = 60, -- 反魔法护罩
		[48792] = 180, -- 冰封之韧
		[49028] = 60, -- 符文刃舞
		[51052] = 120, -- 反魔法领域
		[55233] = 90, -- 吸血鬼之血
		[108199] = 120, -- 血魔之握
		[114556] = 240, -- 炼狱
		[194844] = 60, -- 白骨风暴
		[221562] = 45, -- 窒息
		[275699] = 75, -- 天启
		[279302] = 120, -- 冰霜巨龙之怒
		[327574] = 120, -- 牺牲契约
		[315443] = 120, -- 憎恶附肢，通灵
		[324631] = 120, -- 血肉铸造，通灵
		[312202] = 60, -- 失格者之梏，格里恩
		[311648] = 60 -- 云集之雾，温西尔
	},
	['DEMONHUNTER'] = {
		[179057] = 60, -- 混乱新星
		[183752] = 15, -- 瓦解
		[188501] = 15, -- 幽灵视觉
		[196555] = 180, -- 虚空行走
		[196718] = 180, -- 黑暗
		[198589] = 60, -- 疾影
		[202137] = 60, -- 沉默咒符
		[204021] = 60, -- 烈火烙印
		[207684] = 90, -- 悲苦咒符
		[278326] = 10, -- 吞噬魔法
		[306830] = 60, -- 极乐赦令，格里恩
		[329554] = 120, -- 燃焰饲魂，通灵
		[317009] = 60, -- 罪孽烙印，温西尔
		[323639] = 90 -- 恶魔追击，法夜
	},
	['DRUID'] = {
		[99] = 30, -- 夺魂咆哮
		[740] = 180, -- 宁静
		[2782] = 8, -- 清除腐蚀
		[5211] = 60, -- 蛮力猛击
		[22812] = 60, -- 树皮术
		[78675] = 60, -- 日光术
		[88423] = 8, -- 自然之愈
		[61336] = 180, -- 生存本能
		[77761] = 120, -- 豹奔
		[33891] = 180, -- 大树化身
		[194223] = 180, -- 超凡之盟
		[102560] = 180, -- 鸟德化身
		[102558] = 180, -- 熊化身
		[102543] = 180, -- 猫化身
		[102359] = 30, -- 群缠
		[106839] = 15, -- 迎头痛击
		[132469] = 30, -- 台风
		[102793] = 60, -- 乌索尔旋风
		[201664] = 30, -- 挫志怒吼
		[102342] = 90, -- 铁木树皮
		[108238] = 90, -- 甘霖
		[29166] = 180, -- 激活
		[202246] = 25, -- 蛮力冲锋
		[205636] = 60, -- 树人
		[325727] = 25, -- 畸变蜂群，通灵
		[323764] = 120, -- 万灵之召，法夜
		[338142] = 60, -- 自省强化，格里恩
		[323546] = 180 -- 饕餮狂乱，温西尔
	},
	['HUNTER'] = {
		[5384] = 30, -- 假死
		[19574] = 90, -- 狂野怒火
		[19801] = 10, -- 宁神射击
		[19577] = 60, -- 胁迫
		[34477] = 30, -- 误导
		[147362] = 24, -- 反制射击
		[187707] = 15, -- 压制
		[187650] = 25, -- 冰冻陷阱
		[187698] = 25, -- 焦油陷阱
		[186387] = 30, -- 爆裂射击
		[162488] = 30, -- 精钢陷阱
		[186265] = 180, -- 龟壳
		[109304] = 120, -- 意气风发
		[186289] = 90, -- 雄鹰守护
		[193530] = 120, -- 野性守护
		[266779] = 120, -- 协同进攻
		[260402] = 60, -- 二连发
		[201430] = 120, -- 群兽奔腾
		[288613] = 120, -- 百发百中
		[186257] = 180, -- 猎豹守护
		[109248] = 45, -- 束缚射击
		[199483] = 60, -- 伪装
		[325028] = 45, -- 死亡飞轮，通灵
		[324149] = 30, -- 劫掠射击，温西尔
		[308491] = 60, -- 共鸣箭，格里恩
		[328231] = 120 -- 野性之魂，法夜
	},
	['MAGE'] = {
		[66] = 300, -- 隐形术
		[475] = 8, -- 驱诅咒
		[2139] = 24, -- 法术反制
		[12042] = 120, -- 奥术强化
		[12472] = 180, -- 冰冷血脉
		[31661] = 18, -- 龙息术
		[45438] = 240, -- 冰箱
		[86949] = 300, -- 春哥
		[55342] = 120, -- 镜像
		[113724] = 18, -- 冰霜之环
		[110960] = 120, -- 强隐
		[198111] = 45, -- 时光护盾
		[190319] = 120, -- 燃烧
		[198100] = 30, -- 偷
		[198144] = 60, -- 寒冰形态
		[108978] = 60, -- 操控时间
		[342245] = 60, -- 操控时间
		[324220] = 180, -- 死亡飞轮，通灵
		[314793] = 90, -- 劫掠射击，温西尔
		[307443] = 30, -- 共鸣箭，格里恩
		[314791] = 60 -- 野性之魂，法夜
	},
	['MONK'] = {
		[116705] = 15, -- 切喉手
		[115450] = 8, -- 清创生血
		[218164] = 8, -- 清创生血
		[202335] = 45, -- 醉上加醉
		[119381] = 60, -- 扫堂腿
		[115078] = 30, -- 分筋错骨
		[198898] = 30, -- 赤精之歌
		[116844] = 45, -- 平心之环
		[116849] = 120, -- 作茧缚命
		[122470] = 90, -- 业报之触
		[202162] = 45, -- 斗转星移
		[115399] = 120, -- 玄牛酒
		[122278] = 120, -- 躯不坏
		[122783] = 90, -- 散魔攻
		[325153] = 60, -- 爆炸酒桶
		[115203] = 360, -- 壮胆酒
		[243435] = 180, -- 壮胆酒
		[132578] = 180, -- 玄牛下凡
		[119996] = 45, -- 魂体双分
		[115176] = 300, -- 禅悟冥想
		[115310] = 180, -- 还魂术
		[115288] = 60, -- 豪能酒
		[123904] = 120, -- 白虎下凡
		[322118] = 180, -- 青龙下凡
		[325197] = 180, -- 朱鹤下凡
		[137639] = 90, -- 风火雷电
		[152173] = 90, -- 屏气凝神
		[322109] = 180, -- 轮回之触
		[209584] = 45, -- 禅意聚神茶
		[197908] = 90, -- 法力茶
		[115546] = 8, -- 嚎镇八方
		[116841] = 30, -- 迅如猛虎
		[325216] = 60, -- 骨尘酒，通灵
		[327104] = 30, -- 妖魂踏，法夜
		[326860] = 180, -- 陨落僧众，温西尔
		[310454] = 120 -- 精序兵戈，格里恩
	},
	['PALADIN'] = {
		[498] = 60, -- 圣佑术
		[633] = 600, -- 圣疗术
		[642] = 300, -- 圣盾术
		[853] = 60, -- 制裁之锤
		[1022] = 300, -- 保护祝福
		[1044] = 25, -- 自由祝福
		[4987] = 8, -- 清洁术
		[6940] = 120, -- 牺牲祝福
		[10326] = 15, -- 超度邪恶
		[20066] = 15, -- 忏悔
		[31821] = 180, -- 光环掌握
		[31850] = 120, -- 炽热防御者
		[31884] = 120, -- 复仇之怒
		[31935] = 15, -- 复仇者之盾
		[62124] = 8, -- 清算之手
		[86659] = 300, -- 远古列王守卫
		[96231] = 15, -- 责难
		[184662] = 120, -- 复仇之盾
		[216331] = 120, -- 复仇十字军
		[231895] = 120, -- 征伐
		[105809] = 180, -- 神圣复仇者
		[114158] = 60, -- 圣光之锤
		[152262] = 45, -- 炽天使
		[255937] = 45, -- 灰烬觉醒
		[327193] = 90, -- 光荣时刻
		[210256] = 45, -- 庇护祝福
		[190784] = 45, -- 神圣马驹
		[183218] = 30, -- 妨害之手
		[213644] = 8, -- 清毒术
		[115750] = 90, -- 盲目之光
		[199452] = 120, -- 无尽牺牲
		[204018] = 180, -- 破咒祝福
		[205191] = 60, -- 以眼还眼
		[215652] = 45, -- 美德之盾
		[228049] = 180, -- 被遗忘的女王护卫
		[343527] = 60, -- 处决宣判
		[343721] = 60, -- 最终清算
		[316958] = 240, -- 红烬圣土，温西尔
		[328278] = 45, -- 四级祝福，法夜
		[304971] = 60, -- 圣洁鸣钟，格里恩
		[328204] = 30 -- 征服者之锤，通灵
	},
	['PRIEST'] = {
		[527] = 8, -- 纯净术
		[586] = 30, -- 渐隐术
		[2050] = 60, -- 圣言术：静
		[8122] = 60, -- 心灵尖啸
		[10060] = 120, -- 能量灌注
		[15286] = 120, -- 吸血鬼拥抱
		[15487] = 45, -- 沉默
		[19236] = 90, -- 绝望祷言
		[20711] = 600, -- 救赎之魂
		[32375] = 45, -- 群体驱散
		[33206] = 180, -- 痛苦压制
		[47536] = 90, -- 全神贯注
		[47585] = 120, -- 消散
		[47788] = 180, -- 守护之魂
		[62618] = 180, -- 真言术：障
		[64044] = 45, -- 心灵惊骇
		[64843] = 180, -- 神圣赞美诗
		[64901] = 300, -- 希望象征
		[73325] = 90, -- 信仰飞跃
		[88625] = 60, -- 圣言术：罚
		[316262] = 90, -- 思维窃取
		[109964] = 60, -- 灵魂护壳
		[319952] = 90, -- 疯入膏肓
		[228260] = 90, -- 虚空爆发
		[213610] = 30, -- 神圣守卫
		[289657] = 45, -- 圣言术：聚
		[200183] = 120, -- 神圣化身
		[246287] = 90, -- 福音
		[265202] = 720, -- 圣言术：赎
		[215982] = 180, -- 救赎者之魂
		[108968] = 300, -- 虚空转移
		[328530] = 60, -- 神圣晋升
		[205369] = 30, -- 心灵炸弹
		[204263] = 45, -- 闪光立场
		[213602] = 45, -- 强化渐隐术
		[197268] = 60, -- 希望之光
		[213634] = 8, -- 净化疾病
		[327661] = 90, -- 法夜守护者，法夜
		[323673] = 45, -- 控心术，温西尔
		[324724] = 60, -- 邪恶新星，通灵
		[325013] = 180 -- 晋升者之赐，格里恩
	},
	['ROGUE'] = {
		[408] = 20, -- 肾击
		[1766] = 15, -- 脚踢
		[1856] = 120, -- 消失
		[1966] = 15, -- 佯攻
		[2094] = 120, -- 致盲
		[2983] = 60, -- 疾跑
		[5277] = 120, -- 闪避
		[13750] = 180, -- 冲动
		[13877] = 30, -- 剑刃乱舞
		[31224] = 120, -- 暗影斗篷
		[31230] = 360, -- 装死
		[36554] = 30, -- 暗影步
		[51690] = 120, -- 影舞步
		[57934] = 30, -- 嫁祸
		[79140] = 120, -- 宿敌
		[114018] = 360, -- 潜伏帷幕
		[185311] = 30, -- 猩红之瓶
		[198529] = 120, -- 掠夺护甲
		[315508] = 45, -- 命运骨骰
		[121471] = 180, -- 暗影之刃
		[277925] = 60, -- 袖剑旋风
		[212182] = 180, -- 烟雾弹
		[207777] = 45, -- 卸除武装
		[323547] = 45, -- 申斥回响，格里恩
		[323654] = 25, -- 狂热鞭笞，温西尔
		[328305] = 90, -- 败血刃伤，法夜
		[328547] = 30 -- 锯齿骨刺，通灵
	},
	['SHAMAN'] = {
		[16191] = 180, -- 法力之潮
		[51514] = 20, -- 妖术
		[51533] = 120, -- 野性狼魂
		[58875] = 60, -- 幽魂步
		[79206] = 120, -- 灵魂行者恩赐
		[98008] = 180, -- 灵魂链接
		[108271] = 150, -- 星界转移
		[108280] = 180, -- 治疗之潮
		[191634] = 60, -- 风暴守护者
		[192058] = 50, -- 电能
		[198067] = 150, -- 火元素
		[198103] = 300, -- 土元素
		[320674] = 90, -- 收割链，温西尔
		[328923] = 120, -- 法夜输灵，法夜
		[326059] = 45, -- 始源之潮，通灵
		[324386] = 60 -- 暮钟图腾，格里恩
	},
	['WARLOCK'] = {
		[1122] = 180, -- 召唤地狱火
		[5484] = 40, -- 恐惧嚎叫
		[6789] = 45, -- 死亡缠绕
		[30283] = 45, -- 暗影之怒
		[48020] = 30, -- 法阵
		[108416] = 60, -- 黑暗契约
		[113942] = 90, -- 恶魔传送门
		[104773] = 180, -- 不灭决心
		[201996] = 90, -- 召唤眼魔
		[212459] = 90, -- 召唤邪能领主
		[152108] = 30, -- 大灾变
		[113858] = 120, -- 黑暗灵魂：动荡
		[113860] = 120, -- 黑暗灵魂：哀难
		[267171] = 60, -- 恶魔力量
		[267217] = 180, -- 虚空传送门
		[205180] = 180, -- 召唤黑眼
		[265187] = 90, -- 召唤恶魔暴君
		[221703] = 60, -- 施法之环
		[212295] = 45, -- 虚空守卫
		[200546] = 45, -- 浩劫灾祸
		[119898] = 24, -- 恶魔掌控
		[212623] = 15, -- 烧灼驱魔
		[111898] = 120, -- 魔典：恶魔卫士
		[325289] = 45, -- 屠戮箭，通灵
		[321792] = 60, -- 灾祸降临，温西尔
		[312321] = 40, -- 碎魂奉纳，格里恩
		[325640] = 60 -- 灵魂腐化，法夜
	},
	['WARRIOR'] = {
		[355] = 8, -- 嘲讽
		[871] = 240, -- 盾墙
		[1160] = 45, -- 挫志怒吼
		[1161] = 240, -- 挑战怒吼
		[1719] = 90, -- 鲁莽
		[3411] = 30, -- 援护
		[5246] = 90, -- 破胆怒吼
		[6544] = 45, -- 英勇飞跃
		[6552] = 15, -- 拳击
		[12323] = 30, -- 刺耳怒吼
		[12975] = 180, -- 破釜沉舟
		[18499] = 60, -- 狂暴之怒
		[23920] = 25, -- 法术反射
		[46924] = 60, -- 剑刃风暴
		[46968] = 40, -- 震荡波
		[64382] = 180, -- 碎裂投掷
		[97462] = 180, -- 集结呐喊
		[107570] = 30, -- 风暴之锤
		[213871] = 15, -- 护卫
		[118038] = 120, -- 剑在人在
		[184364] = 120, -- 狂怒回复
		[107574] = 90, -- 天神下凡
		[227847] = 90, -- 剑刃风暴
		[152277] = 45, -- 破坏者
		[228920] = 45, -- 破坏者
		[262228] = 60, -- 致命平静
		[118000] = 30, -- 巨龙怒吼
		[236320] = 90, -- 战旗
		[317320] = 6, -- 判罪，温西尔
		[325886] = 90, -- 上古余震，法夜
		[307865] = 60, -- 晋升堡垒之矛，格里恩
		[324143] = 180 -- 征服者战旗，通灵
	}
}

--[[
	姓名板光环过滤
]]
C.AuraWhiteList = {
	-- Buffs
	[642] = true, -- 圣盾术
	[1022] = true, -- 保护之手
	[23920] = true, -- 法术反射
	[45438] = true, -- 寒冰屏障
	[186265] = true, -- 灵龟守护
	-- Debuffs
	[2094] = true, -- 致盲
	[10326] = true, -- 超度邪恶
	[20549] = true, -- 战争践踏
	[107079] = true, -- 震山掌
	[117405] = true, -- 束缚射击
	[127797] = true, -- 乌索尔旋风
	[272295] = true, -- 悬赏
	-- Mythic+
	[228318] = true, -- 激怒
	[226510] = true, -- 血池
	[343553] = true, -- 万噬之怨
	[343502] = true, -- 鼓舞光环
	-- Dungeons
	[320293] = true, -- 伤逝剧场，融入死亡
	[331510] = true, -- 伤逝剧场，死亡之愿
	[333241] = true, -- 伤逝剧场，暴脾气
	[336449] = true, -- 凋魂之殇，玛卓克萨斯之墓
	[336451] = true, -- 凋魂之殇，玛卓克萨斯之壁
	[333737] = true, -- 凋魂之殇，凝结之疾
	[328175] = true, -- 凋魂之殇，凝结之疾
	[340357] = true, -- 凋魂之殇，急速感染
	[228626] = true, -- 彼界，怨灵之瓮
	[344739] = true, -- 彼界，幽灵
	[333227] = true, -- 彼界，不死之怒
	[326450] = true, -- 赎罪大厅，忠心的野兽
	[343558] = true, -- 通灵战潮，病态凝视
	[343470] = true, -- 通灵战潮，碎骨之盾
	[322433] = true, -- 赤红深渊，石肤术
	[321402] = true, -- 赤红深渊，饱餐
	[327416] = true, -- 晋升高塔，心能回灌
	[317936] = true, -- 晋升高塔，弃誓信条
	[327812] = true, -- 晋升高塔，振奋英气
	[339917] = true, -- 晋升高塔，命运之矛
	[323149] = true, -- 仙林，黑暗之拥
	-- Raids
	[334695] = true, -- 动荡能量，猎手
	[345902] = true, -- 破裂的联结，猎手
	[346792] = true -- 罪触之刃，猩红议会
}

C.AuraBlackList = {
	[15407] = true, -- 精神鞭笞
	[51714] = true, -- 锋锐之霜
	[199721] = true, -- 腐烂光环
	[214968] = true, -- 死灵光环
	[214975] = true, -- 抑心光环
	[273977] = true, -- 亡者之握
	[276919] = true, -- 承受压力
	[206930] = true -- 心脏打击
}

-- 取自地城手册的段落ID
-- 纯数字则为GUID，选择目标后输入/getnpc获取
local function GetSectionInfo(id)
	return C_EncounterJournal.GetSectionInfo(id).title
end

-- 特殊单位的染色列表
C.NPSpecialUnitsList = {
	-- Nzoth vision
	[153401] = true, -- 克熙尔支配者
	[157610] = true, -- 克熙尔支配者
	[156795] = true, -- 军情七处线人
	-- Dungeons
	[120651] = true, -- 大米，爆炸物
	[174773] = true, -- 大米，怨毒影魔
	[GetSectionInfo(22161)] = true, -- 凋魂之殇，魔药炸弹
	[170851] = true, -- 凋魂之殇，易爆魔药炸弹
	[165556] = true, -- 赤红深渊，瞬息具象
	[170234] = true, -- 伤逝剧场，压制战旗
	[164464] = true, -- 伤逝剧场，卑劣的席拉
	[165251] = true, -- 仙林，幻影仙狐
	-- Raids
	[GetSectionInfo(21953)] = true, -- 凯子，灵能灌注者
	[175992] = true -- 猩红议会，忠实的侍从
}

-- 显示能量值的单位
C.NPShowPowerUnitsList = {
	[165556] = true, -- 赤红深渊，瞬息具象
	[GetSectionInfo(22339)] = true -- 猎手阿尔迪莫，巴加斯特之影
}

--[[
	默认设置
]]
C.CharacterSettings = {
	['BFA'] = false,
	['classic'] = false,
	['installation'] = {
		['complete'] = false
	},
	['ui_anchor'] = {},
	['ui_anchor_temp'] = {},
	['blizzard'] = {
		['hide_talkinghead'] = true,
		['hide_boss_banner'] = false,
		['hide_boss_emote'] = true,
		['missing_stats'] = true,
		['mail_button'] = true,
		['orderhall_icon'] = true,
		['tradeskill_tabs'] = true,
		['undress_button'] = true,
		['trade_target_info'] = true,
		['concise_errors'] = true,
		['naked_button'] = true,
		['easy_delete'] = true,
		['pet_filter'] = true,
		['instant_loot'] = false,
		['friends_list'] = true,
		['maw_threat_bar'] = true
	},
	['combat'] = {
		['enable'] = true,
		['combat_alert'] = true,
		['alert_animation'] = true,
		['alert_scale'] = .4,
		['alert_speed'] = 1,
		['spell_sound'] = true,
		['pvp_sound'] = true,
		['easy_tab'] = true,
		['easy_focus'] = true,
		['easy_focus_on_unitframe'] = false,
		['easy_mark'] = true,
		['fct'] = true,
		['fct_pet'] = true,
		['fct_periodic'] = true,
		['fct_merge'] = true,
		['fct_in'] = true,
		['fct_out'] = false
	},
	['Announcement'] = {
		['Enable'] = true,
		['Interrupt'] = true,
		['Dispel'] = true,
		['BattleRez'] = true,
		['Utility'] = true,
		['Quest'] = false,
		['Reset'] = true,
		['Solo'] = false,
	},
	['aura'] = {
		['enable'] = true,
		['margin'] = 6,
		['offset'] = 12,
		['buff_size'] = 40,
		['buffs_per_row'] = 12,
		['reverse_buffs'] = true,
		['debuff_size'] = 50,
		['debuffs_per_row'] = 12,
		['reverse_debuffs'] = true,
		['reminder'] = true
	},
	['inventory'] = {
		['enable'] = true,
		['scale'] = 1,
		['offset'] = 26,
		['spacing'] = 3,
		['slot_size'] = 44,
		['bag_columns'] = 10,
		['bank_columns'] = 10,
		['sort_mode'] = 1,
		['item_level'] = true,
		['item_level_to_show'] = 1,
		['new_item_flash'] = true,
		['bind_type'] = true,
		['combine_free_slots'] = true,
		['split_count'] = 1,
		['auto_deposit'] = false,
		['special_color'] = true,
		['favourite_items'] = {},
		['item_filter'] = true,
		['item_filter_gear_set'] = true,
		['item_filter_trade'] = true,
		['item_filter_quest'] = true,
		['item_filter_junk'] = true,
		['item_filter_azerite'] = true,
		['item_filter_equipment'] = true,
		['item_filter_consumable'] = true,
		['item_filter_legendary'] = true,
		['item_filter_collection'] = true,
		['item_filter_favourite'] = true,
		['auto_sell_junk'] = false,
		['auto_repair'] = false
	},
	['unitframe'] = {
		['enable'] = true,
		['color_style'] = 2,
		['transparent_mode'] = true,
		['fade'] = true,
		['fade_out_alpha'] = 0,
		['fade_in_alpha'] = 1,
		['fade_out_duration'] = .3,
		['fade_in_duration'] = .3,
		['condition_arena'] = true,
		['condition_instance'] = true,
		['condition_hover'] = false,
		['condition_combat'] = true,
		['condition_target'] = true,
		['condition_casting'] = true,
		['condition_injured'] = true,
		['condition_mana'] = false,
		['condition_power'] = false,
		['range_check'] = true,
		['range_check_alpha'] = 0.4,
		['portrait'] = true,
		['portrait_saturation'] = true,
		['heal_prediction'] = true,
		['gcd_spark'] = true,
		['target_icon_indicator'] = true,
		['target_icon_indicator_alpha'] = 0.5,
		['target_icon_indicator_size'] = 16,
		['power_bar'] = true,
		['power_bar_height'] = 1,
		['alt_power'] = true,
		['alt_power_height'] = 2,
		['class_power_bar'] = true,
		['class_power_bar_height'] = 2,
		['runes_timer'] = false,
		['stagger_bar'] = true,
		['totems_bar'] = true,
		['debuff_type'] = true,
		['stealable_buffs'] = true,
		['debuffs_by_player'] = true,
		['abbr_name'] = false,
		['enable_castbar'] = true,
		['casting_color'] = {r = .31, g = .48, b = .85},
		['casting_uninterruptible_color'] = {r = .66, g = .65, b = .65},
		['casting_complete_color'] = {r = .25, g = .63, b = .49},
		['casting_fail_color'] = {r = .73, g = .39, b = .43},
		['castbar_focus_separate'] = false,
		['castbar_focus_width'] = 200,
		['castbar_focus_height'] = 16,
		['castbar_timer'] = false,
		['enable_player'] = true,
		['player_width'] = 120,
		['player_height'] = 8,
		['player_auras'] = false,
		['player_combat_indicator'] = true,
		['player_resting_indicator'] = true,
		['player_hide_tags'] = true,
		['enable_pet'] = true,
		['pet_width'] = 50,
		['pet_height'] = 8,
		['pet_auras_per_row'] = 3,
		['enable_target'] = true,
		['target_width'] = 160,
		['target_height'] = 8,
		['target_auras_per_row'] = 6,
		['target_target_width'] = 60,
		['target_target_height'] = 8,
		['enable_focus'] = true,
		['focus_width'] = 60,
		['focus_height'] = 8,
		['focus_auras_per_row'] = 3,
		['focus_target_width'] = 60,
		['focus_target_height'] = 8,
		['enable_group'] = true,
		['group_names'] = false,
		['group_color_style'] = 2,
		['group_filter'] = 6,
		['show_solo'] = false,
		['spec_position'] = false,
		['group_by_role'] = true,
		['group_reverse'] = false,
		['group_health_frequen'] = false,
		['group_health_frequency'] = .2,
		['group_click_cast'] = true,
		['group_debuff_highlight'] = true,
		['corner_indicator'] = true,
		['corner_indicator_scale'] = 1,
		['instance_auras'] = true,
		['raid_debuffs_scale'] = 1,
		['auras_click_through'] = true,
		['party_spell_watcher'] = true,
		['party_spell_sync'] = false,
		['group_threat_indicator'] = true,
		['group_leader_indicator'] = true,
		['party_width'] = 62,
		['party_height'] = 28,
		['party_gap'] = 6,
		['party_horizon'] = false,
		['party_reverse'] = false,
		['raid_width'] = 28,
		['raid_height'] = 20,
		['raid_gap'] = 5,
		['raid_horizon'] = true,
		['raid_reverse'] = false,
		['enable_boss'] = true,
		['boss_color_style'] = 3,
		['boss_width'] = 120,
		['boss_height'] = 20,
		['boss_gap'] = 60,
		['boss_auras'] = true,
		['boss_auras_per_row'] = 6,
		['enable_arena'] = true,
		['arena_width'] = 120,
		['arena_height'] = 16,
		['arena_gap'] = 80,
		['arena_auras_per_row'] = 6
	},
	['nameplate'] = {
		['enable'] = true,
		['plate_width'] = 100,
		['plate_height'] = 8,
		['friendly_class_color'] = false,
		['hostile_class_color'] = true,
		['tank_mode'] = false,
		['secure_color'] = {r = 1, g = 0, b = 1},
		['trans_color'] = {r = 1, g = .8, b = 0},
		['insecure_color'] = {r = 1, g = 0, b = 0},
		['off_tank_color'] = {r = .2, g = .7, b = .5},
		['colored_target'] = false,
		['target_color'] = {r = 0, g = .6, b = 1},
		['dps_revert_threat'] = false,
		['colored_custom_unit'] = true,
		['custom_color'] = {r = .8, g = .42, b = .31},
		['custom_unit_list'] = '',
		['show_power_list'] = '',
		['target_indicator'] = true,
		['target_indicator_color'] = {r = .73, g = .92, b = .99},
		['threat_indicator'] = true,
		['classify_indicator'] = true,
		['interrupt_name'] = true,
		['explosive_scale'] = false,
		['widget_container'] = true,
		['aura_filter_mode'] = 3,
		['aura_size'] = 22,
		['aura_number'] = 6,
		['inside_view'] = true,
		['min_scale'] = 0.7,
		['target_scale'] = 1,
		['min_alpha'] = 0.6,
		['occluded_alpha'] = 0.2,
		['vertical_spacing'] = 0.7,
		['horizontal_spacing'] = 0.3,
		['name_only'] = false,
		['player_plate'] = false,
		['pp_width'] = 160,
		['pp_height'] = 6,
		['pp_fadeout'] = true,
		['pp_fadeout_alpha'] = .3
	},
	['tooltip'] = {
		['enable'] = true,
		['follow_cursor'] = false,
		['disable_fading'] = true,
		['hide_title'] = true,
		['hide_realm'] = true,
		['hide_rank'] = true,
		['hide_in_combat'] = false,
		['border_color'] = false,
		['spec_ilvl'] = true,
		['azerite_armor'] = true,
		['link_hover'] = true,
		['tip_icon'] = true,
		['target_by'] = true,
		['extra_info'] = true,
		['aura_source'] = true,
		['conduit_info'] = true,
		['health_value'] = false
	},
	['map'] = {
		['enable'] = true,
		['worldmap_scale'] = 1,
		['max_worldmap_scale'] = 1,
		['remove_fog'] = true,
		['coords'] = true,
		['minimap_scale'] = 1,
		['who_pings'] = true,
		['progress_bar'] = true
	},
	['infobar'] = {
		['enable'] = true,
		['anchor_top'] = true,
		['bar_height'] = 14,
		['mouseover'] = true,
		['stats'] = true,
		['spec'] = true,
		['durability'] = true,
		['guild'] = true,
		['friends'] = true,
		['report'] = true,
		['currency'] = true
	},
	['notification'] = {
		['enable'] = true,
		['bag_full'] = true,
		['new_mail'] = true,
		['version_check'] = false,
		['rare_found'] = true,
		['paragon_reputation'] = true
	},
	['misc'] = {
		['group_tool'] = true,
		['rune_check'] = false,
		['countdown'] = '10',
		['auto_screenshot'] = true,
		['auto_screenshot_achievement'] = true,
		['auto_screenshot_challenge'] = true,
		['auto_screenshot_levelup'] = false,
		['auto_screenshot_dead'] = false,
		['reward_highlight'] = true,
		['quick_quest'] = false,
		['quest_completed_sound'] = true,
		['quest_tracker_buttons'] = true,
		['faster_camera'] = true,
		['item_level'] = true,
		['gem_enchant'] = true,
		['azerite_traits'] = true,
		['screen_saver'] = true,
		['proposal_timer'] = true
	},
	['chat'] = {
		['enable'] = true,
		['lock_position'] = true,
		['window_width'] = 300,
		['window_height'] = 100,
		['fade_out'] = true,
		['fading_visible'] = 120,
		['fading_duration'] = 6,
		['abbr_channel_names'] = true,
		['copy_button'] = true,
		['voice_button'] = true,
		['tab_cycle'] = true,
		['smart_bubble'] = false,
		['channel_bar'] = true,
		['whisper_invite'] = false,
		['invite_keyword'] = 'inv',
		['guild_only'] = true,
		['whisper_sticky'] = true,
		['whisper_sound'] = true,
		['sound_timer'] = 30,
		['item_links'] = true,
		['damage_meter_filter'] = true,
		['use_filter'] = true,
		['matche_number'] = 1,
		['allow_friends_spam'] = true,
		['block_stranger_whisper'] = false,
		['block_addon_spam'] = true,
		['group_loot_filter'] = true,
		['group_loot_threshold'] = 2
	},
	['Actionbar'] = {
		['Enable'] = true,
			['BarScale'] = 1,
			['ButtonSize'] = 26,

			['Hotkey'] = true,
			['MacroName'] = true,
			['CountNumber'] = true,
			['ClassColor'] = false,

			['Bar1'] = true,
			['Bar2'] = true,
			['Bar3'] = true,
			['Bar3Divide'] = true,
			['Bar4'] = false,
			['Bar5'] = false,
			['Pet_Bar'] = true,
			['Stance_Bar'] = false,
			['Vehicle_Bar'] = true,

			['Fader'] = true,
				['FadeOutAlpha'] = 0,
				['FadeInAlpha'] = 1,
				['FadeOutDuration'] = 1,
				['FadeInDuration'] = .3,
				['ConditionCombat'] = true,
				['ConditionTarget'] = false,
				['ConditionDungeon'] = true,
				['ConditionPvP'] = true,
				['ConditionVehicle'] = true,

			['CustomBar'] = false,
				['CBMargin'] = 3,
				['CBPadding'] = 3,
				['CBButtonSize'] = 34,
				['CBButtonNumber'] = 12,
				['CBButtonPerRow'] = 6,

			['CDNotify'] = true,
			['CDFlash'] = true,

			['CooldownCount'] = true,
				['DecimalCD'] = true,
				['OverrideWA'] = true,

			['BindType'] = 1,
	},
	['Quest'] = {
		['Enable'] = true,
	}
}

C.AccountSettings = {
	['detect_version'] = C.AddonVersion,
	['ui_scale'] = 1,
	['texture_style'] = 1,
	['number_format'] = 1,
	['cursor_trail'] = true,
	['vignetting'] = true,
	['vignetting_alpha'] = .5,
	['font_outline'] = false,
	['reskin_blizz'] = true,
	['backdrop_alpha'] = .75,
	['shadow_border'] = true,
	['reskin_dbm'] = true,
	['reskin_bw'] = true,
	['reskin_pgf'] = true,
	['reskin_wa'] = true,
	['reskin_abp'] = true,
	['chat_filter_black_list'] = '',
	['chat_filter_white_list'] = '',
	['custom_junk_list'] = {},
	['NPAuraFilter'] = {[1] = {}, [2] = {}},
	['RaidDebuffsList'] = {},
	['RaidAuraWatch'] = {},
	['CornerSpellsList'] = {},
	['PartySpellsList'] = {},
	['profile_index'] = {},
	['profile_names'] = {},
	['health_color'] = {r = .81, g = .81, b = .81},
	['custom_class_color'] = false,
	['class_colors_list'] = {
		['HUNTER'] = {
			['r'] = 0.2,
			['g'] = 0.71,
			['b'] = 0.25,
			['colorStr'] = 'ff33b541'
		},
		['WARRIOR'] = {
			['r'] = 0.78,
			['g'] = 0.61,
			['b'] = 0.39,
			['colorStr'] = 'ffc79b64'
		},
		['PALADIN'] = {
			['r'] = 0.93,
			['g'] = 0.33,
			['b'] = 0.42,
			['colorStr'] = 'ffee556c'
		},
		['MAGE'] = {
			['r'] = 0.49,
			['g'] = 0.66,
			['b'] = 0.89,
			['colorStr'] = 'ff7ea8e3'
		},
		['PRIEST'] = {
			['r'] = 0.83,
			['g'] = 0.83,
			['b'] = 0.83,
			['colorStr'] = 'ffd3d3d3'
		},
		['DEATHKNIGHT'] = {
			['r'] = 0.77,
			['g'] = 0.16,
			['b'] = 0.22,
			['colorStr'] = 'ffc32838'
		},
		['WARLOCK'] = {
			['r'] = 0.65,
			['g'] = 0.64,
			['b'] = 0.88,
			['colorStr'] = 'ffa5a3e0'
		},
		['DEMONHUNTER'] = {
			['r'] = 0.82,
			['g'] = 0.35,
			['b'] = 0.89,
			['colorStr'] = 'ffd259e3'
		},
		['ROGUE'] = {
			['r'] = 0.91,
			['g'] = 0.81,
			['b'] = 0.51,
			['colorStr'] = 'ffe9cb7f'
		},
		['DRUID'] = {
			['r'] = 0.95,
			['g'] = 0.48,
			['b'] = 0.27,
			['colorStr'] = 'fff27944'
		},
		['MONK'] = {
			['r'] = 0.28,
			['g'] = 0.84,
			['b'] = 0.6,
			['colorStr'] = 'ff48d599'
		},
		['SHAMAN'] = {
			['r'] = 0.29,
			['g'] = 0.29,
			['b'] = 0.82,
			['colorStr'] = 'ff4949d0'
		}
	}
}

--[[
	初始化
 ]]
local function initSettings(source, target, fullClean)
	for i, j in pairs(source) do
		if type(j) == 'table' then
			if target[i] == nil then
				target[i] = {}
			end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then
				target[i] = j
			end
		end
	end

	for i, j in pairs(target) do
		if source[i] == nil then
			target[i] = nil
		end
		if fullClean and type(j) == 'table' then
			for k, v in pairs(j) do
				if type(v) ~= 'table' and source[i] and source[i][k] == nil then
					target[i][k] = nil
				end
			end
		end
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript(
	'OnEvent',
	function(self, _, addon)
		if addon ~= 'FreeUI' then
			return
		end

		initSettings(C.AccountSettings, FREE_ADB)
		if not next(FREE_PDB) then
			for i = 1, 5 do
				FREE_PDB[i] = {}
			end
		end

		if not FREE_ADB['profile_index'][C.MyFullName] then
			FREE_ADB['profile_index'][C.MyFullName] = 1
		end

		if FREE_ADB['profile_index'][C.MyFullName] == 1 then
			C.DB = FREE_DB
			if not C.DB['BFA'] then
				wipe(C.DB)
				C.DB['BFA'] = true
			end
		else
			C.DB = FREE_PDB[FREE_ADB['profile_index'][C.MyFullName] - 1]
		end
		initSettings(C.CharacterSettings, C.DB, true)

		F:SetupUIScale(true)

		if not GUI.TexturesList[FREE_ADB.texture_style] then
			FREE_ADB.texture_style = 1 -- reset value if not exists
		end
		C.Assets.statusbar_tex = GUI.TexturesList[FREE_ADB.texture_style].texture

		self:UnregisterAllEvents()
	end
)
