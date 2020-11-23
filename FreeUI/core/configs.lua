local F, C = unpack(select(2, ...))
local GUI = F.GUI


C.Fonts = { -- #TODO
	['infobar'] = {},
}

C['ReminderBuffsList'] = {
	MAGE = {
		{	spells = {	-- 奥术魔宠
				[210126] = true,
			},
			depend = 205022,
			spec = 1,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 奥术智慧
				[1459] = true,
			},
			depend = 1459,
			instance = true,
		},
	},
	PRIEST = {
		{	spells = {	-- 真言术耐
				[21562] = true,
			},
			depend = 21562,
			instance = true,
		},
	},
	WARRIOR = {
		{	spells = {	-- 战斗怒吼
				[6673] = true,
			},
			depend = 6673,
			instance = true,
		},
	},
	SHAMAN = {
		{	spells = {
				[192106] = true,	-- 闪电之盾
				[974] = true,		-- 大地之盾
				[52127] = true,		-- 水之护盾
			},
			depend = 192106,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {
				[33757] = true,		-- 风怒武器
			},
			depend = 33757,
			combat = true,
			instance = true,
			pvp = true,
			weaponIndex = 1,
			spec = 2,
		},
		{	spells = {
				[318038] = true,	-- 火舌武器
			},
			depend = 318038,
			combat = true,
			instance = true,
			pvp = true,
			weaponIndex = 2,
			spec = 2,
		},
	},
	ROGUE = {
		{	spells = {	-- 伤害类毒药
				[2823] = true,		-- 致命药膏
				[8679] = true,		-- 致伤药膏
				[315584] = true,	-- 速效药膏
			},
			texture = 132273,
			depend = 315584,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 效果类毒药
				[3408] = true,		-- 减速药膏
				[5761] = true,		-- 迟钝药膏
			},
			depend = 3408,
			pvp = true,
		},
	},
}


C['CornerBuffsList'] = {
	['PRIEST'] = {
		[194384] = {'TOPRIGHT', {1, 1, .66}},			-- 救赎
		[214206] = {'TOPRIGHT', {1, 1, .66}},			-- 救赎(PvP)
		[41635]  = {'BOTTOMRIGHT', {.2, .7, .2}},		-- 愈合导言
		[193065] = {'BOTTOMRIGHT', {.54, .21, .78}},	-- 忍辱负重
		[139]    = {'TOPLEFT', {.4, .7, .2}},			-- 恢复
		[17]     = {'TOPLEFT', {.7, .7, .7}},			-- 真言术盾
		[47788]  = {'LEFT', {.86, .45, 0}, true},		-- 守护之魂
		[33206]  = {'LEFT', {.47, .35, .74}, true},		-- 痛苦压制
		[6788]  = {'TOP', {.86, .11, .11}, true},		-- 虚弱灵魂
	},
	['DRUID'] = {
		[774]    = {'TOPRIGHT', {.8, .4, .8}},			-- 回春
		[155777] = {'RIGHT', {.8, .4, .8}},				-- 萌芽
		[8936]   = {'BOTTOMLEFT', {.2, .8, .2}},		-- 愈合
		[33763]  = {'TOPLEFT', {.4, .8, .2}},			-- 生命绽放
		[48438]  = {'BOTTOMRIGHT', {.8, .4, 0}},		-- 野性成长
		[207386] = {'TOP', {.4, .2, .8}},				-- 春暖花开
		[102351] = {'LEFT', {.2, .8, .8}},				-- 结界
		[102352] = {'LEFT', {.2, .8, .8}},				-- 结界(HoT)
		[200389] = {'BOTTOM', {1, 1, .4}},				-- 栽培
	},
	['PALADIN'] = {
		[287280]  = {'TOPLEFT', {1, .8, 0}},			-- 圣光闪烁
		[53563]  = {'TOPRIGHT', {.7, .3, .7}},			-- 道标
		[156910] = {'TOPRIGHT', {.7, .3, .7}},			-- 信仰道标
		[200025] = {'TOPRIGHT', {.7, .3, .7}},			-- 美德道标
		[1022]   = {'BOTTOMRIGHT', {.2, .2, 1}, true},	-- 保护
		[1044]   = {'BOTTOMRIGHT', {.89, .45, 0}, true},-- 自由
		[6940]   = {'BOTTOMRIGHT', {.89, .1, .1}, true},-- 牺牲
		[223306] = {'BOTTOMLEFT', {.7, .7, .3}},		-- 赋予信仰
		[25771]  = {'TOP', {.86, .11, .11}, true},		-- 自律
	},
	['SHAMAN'] = {
		[61295]  = {'TOPRIGHT', {.2, .8, .8}},			-- 激流
		[974]    = {'BOTTOMRIGHT', {1, .8, 0}},			-- 大地之盾
		[207400] = {'BOTTOMLEFT', {.6, .8, 1}},			-- 先祖活力
	},
	['MONK'] = {
		[119611] = {'TOPLEFT', {.3, .8, .6}},			-- 复苏之雾
		[116849] = {'TOPRIGHT', {.2, .8, .2}, true},	-- 作茧缚命
		[124682] = {'BOTTOMLEFT', {.8, .8, .25}},		-- 氤氲之雾
		[191840] = {'BOTTOMRIGHT', {.27, .62, .7}},		-- 精华之泉
	},
	['ROGUE'] = {
		[57934]  = {'BOTTOMRIGHT', {.9, .1, .1}},		-- 嫁祸
	},
	['WARRIOR'] = {
		[114030] = {'TOPLEFT', {.2, .2, 1}},			-- 警戒
	},
	['HUNTER'] = {
		[34477]  = {'BOTTOMLEFT', {.9, .1, .1}},		-- 误导
		[90361]  = {'TOPLEFT', {.4, .8, .2}},			-- 灵魂治愈
	},
	['WARLOCK'] = {
		[20707]  = {'BOTTOMRIGHT', {.8, .4, .8}, true},	-- 灵魂石
	},
	['DEMONHUNTER'] = {},
	['MAGE'] = {},
	['DEATHKNIGHT'] = {},
}

-- # TODO
-- this filter is for player
C['ClassBuffsList'] = {
	['ALL'] = {},

	['MAGE'] = {
		[205473] = true,
		[116267] = true,
		[ 44544] = true,
		[190446] = true,
	},

	['PRIEST'] = {},
	['DRUID'] = {},
	['PALADIN'] = {},
	['SHAMAN'] = {},
	['MONK'] = {},
	['ROGUE'] = {},
	['WARRIOR'] = {},
	['WARLOCK'] = {},
	['HUNTER'] = {},
	['DEMONHUNTER'] = {},
	['DEATHKNIGHT'] = {},
}




-- Raidbuff Checklist
C.RaidBuffsList = {
	[1] = {		-- 合剂
		298836,	-- 敏捷360
		298837,	-- 智力360
		298839,	-- 耐力360
		298841,	-- 力量360

		307166,	-- 大锅
		307185,	-- 通用合剂
		307187,	-- 耐力合剂
	},
	[2] = {     -- 进食充分
		104273, -- 250敏捷，BUFF名一致
	},
	[3] = {     -- 10%智力
		1459,
		264760,
	},
	[4] = {     -- 10%耐力
		21562,
		264764,
	},
	[5] = {     -- 10%攻强
		6673,
		264761,
	},
	[6] = {     -- 符文
		270058,
	},
}


C['PartySpellsList'] = {
	[57994]  = 12,	-- 风剪
	[1766]   = 15,	-- 脚踢
	[6552]   = 15,	-- 拳击
	[47528]  = 15,	-- 心灵冰冻
	[96231]  = 15,	-- 责难
	[106839] = 15,	-- 迎头痛击
	[116705] = 15,	-- 切喉手
	[183752] = 15,	-- 瓦解
	[187707] = 15,	-- 压制
	[2139]   = 24,	-- 法术反制
	[147362] = 24,	-- 反制射击
	[15487]  = 45,	-- 沉默
	[109248] = 45,	-- 束缚射击
	[78675]  = 60,	-- 日光术

	[8143]	 = 60,	-- 战栗图腾
	[102793] = 60,	-- 乌索尔旋风
	[119381] = 60,	-- 扫堂腿
	[179057] = 60,	-- 混乱新星
	[205636] = 60,	-- 树人
	[102342] = 90,	-- 铁木树皮
	[31224]  = 120,	-- 暗影斗篷
	[190319] = 120,	-- 燃烧
	[25046]  = 120,	-- 奥术洪流
	[28730]  = 120,
	[50613]  = 120,
	[69179]  = 120,
	[80483]  = 120,
	[129597] = 120,
	[155145] = 120,
	[202719] = 120,
	[232633] = 120,
	[186265] = 180,	-- 灵龟守护
}

C['TalentCDFixList'] = {
	[740]	 = 120,	-- 宁静
	[2094]   = 90,	-- 致盲
	[15286]  = 75,	-- 吸血鬼的拥抱
	[15487]  = 30,	-- 沉默
	[22812]  = 40,	-- 树皮术
	[30283]  = 30,	-- 暗怒
	[48792]  = 165,	-- 冰封之韧
	[79206]  = 60,	-- 灵魂行者的恩赐
	[102342] = 45,	-- 铁木树皮
	[108199] = 90,	-- 血魔之握
	[109304] = 105,	-- 意气风发
	[116849] = 100,	-- 作茧缚命
	[119381] = 40,	-- 扫堂腿
	[179057] = 40,	-- 混乱新星
}


C['AuraWhiteList'] = {
	-- Buffs
	[642]		= true,		-- 圣盾术
	[1022]		= true,		-- 保护之手
	[23920]		= true,		-- 法术反射
	[45438]		= true,		-- 寒冰屏障
	[186265]	= true,		-- 灵龟守护
	-- Debuffs
	[2094]		= true,		-- 致盲
	[117405]	= true,		-- 束缚射击
	[127797]	= true,		-- 乌索尔旋风
	[20549] 	= true,		-- 战争践踏
	[107079] 	= true,		-- 震山掌
	[272295] 	= true,		-- 悬赏
	-- Dungeons
	[283640]	= true,		-- 仁慈侏儒短路，麦卡贡
	[293724]	= true,		-- 护盾发生器
	[298602]	= true,		-- 烟云

	[258317]	= true,		-- 防爆盾，托尔达戈
	[257899]	= true,		-- 痛苦激励，自由镇
	[268008]	= true,		-- 毒蛇诱惑，神庙
	[260792]	= true,		-- 尘土云，神庙
	[260416]	= true,		-- 蜕变，孢林
	[267981]	= true,		-- 防护光环，风暴神殿
	[274631]	= true,		-- 次级铁墙祝福，风暴神殿
	[267901]	= true,		-- 铁墙祝福，风暴神殿
	[276767]	= true,		-- 吞噬虚空，风暴神殿
	[268212]	= true,		-- 小型强化结界，风暴神殿
	[268186]	= true,		-- 强化结界，风暴神殿
	[263246]	= true,		-- 闪电之盾，风暴神殿
	[263276]	= true,		-- 掩护，矿区
	[257597]	= true,		-- 艾泽里特的灌注，矿区
	[269302]	= true,		-- 淬毒之刃，矿区
	[260805]	= true,		-- 聚焦之虹，庄园
	[264027]	= true,		-- 结界蜡烛，庄园
	[258653]	= true,		-- 魂能壁垒，阿塔达萨
	[255960]	= true,		-- 强效巫毒，阿塔达萨
	[255967]	= true,
	[255968]	= true,
	[255970]	= true,
	[255972]	= true,
	[228318]	= true,		-- 激怒
	[226510]	= true,		-- 血池
	[277242]	= true,		-- 共生
	[290026]	= true,		-- 女王法令：反冲
	[290027]	= true,
	[302418]	= true,		-- 女王法令：势不可挡
	[302419]	= true,		-- 虚空视界
	[302421]	= true,		-- 女王法令：隐藏
	-- Raids
	[312266]	= true,		-- 烟幕，拉希奥
	[313175]	= true,		-- 硬化核心
	[305675]	= true,		-- 黑暗屏障，玛乌特
	[312154]	= true,		-- 禁忌转生
	[313208]	= true,		-- 无形幻象，先知斯基特拉
	[307637]	= true,		-- 突变进化，主脑
	[307213]	= true,		-- 虚空灌注
	[307583]	= true,		-- 不稳定的喷发
	[312595]	= true,		-- 易爆腐蚀，德雷阿佳丝
	[317672]	= true,		-- 血性狂乱，伊格诺斯
	[307729]	= true,		-- 狂热晋升，维克修娜
	[312750]	= true,		-- 召唤梦魇，虚无者莱登
	[306990]	= true,		-- 适化外膜，恩佐斯外壳
	[310134]	= true,		-- 疯狂聚现，恩佐斯

	[296389]	= true,		-- 上旋气流，艾萨拉之辉
	[296650]	= true,		-- 硬化甲壳，艾什凡女勋爵
	[296914]	= true,		-- 混乱生长，奥戈佐亚
	[282209]	= true,		-- 掠食印记
	[296704]	= true,		-- 权力制衡，女王法庭
	[295099]	= true,		-- 穿透黑暗，扎库尔
	[300428]	= true,		-- 激怒，艾萨拉
	[297912]	= true,		-- 饱受煎熬
	[300551]	= true,		-- 力量结界

	[287693]	= true,		-- 隐性联结，乌纳特
	[282741]	= true,		-- 暗影之壳
	[285333]	= true,		-- 非自然再生
	[285642]	= true,		-- 恩佐斯之赐：癔乱

	[283619]	= true,		-- 圣光之潮，圣光勇士
	[284468]	= true,		-- 惩戒光环
	[283933]	= true,		-- 正义审判
	[284593]	= true,		-- 苦修
	[283583]	= true,		-- 奉献
	[288294]	= true,		-- 圣佑术
	[288298]	= true,		-- 自律
	[287469]	= true,		-- 殒落祷告
	[287439]	= true,		-- 神圣之锤
	[286436]	= true,		-- 翡翠风暴，玉火大师
	[286425]	= true,		-- 火焰护盾
	[287652]	= true,		-- 过载，丰灵
	[282098]	= true,		-- 风之恩赐，神选者教团
	[287650]	= true,		-- 沸腾之怒
	[282736]	= true,		-- 神灵的愤怒
	[285945]	= true,		-- 急速之风
	[286007]	= true,		-- 龙群猎手
	[289162]	= true,		-- 无情不朽，拉斯卡哈大王
	[288117]	= true,		-- 灌魔之灵
	[287297]	= true,		-- 上满发条，大工匠
	[286558]	= true,		-- 潮汐遮罩，风暴之墙
	[287995]	= true,		-- 电流护罩
	[284997]	= true,		-- 覆藻之拳
	[287322]	= true,		-- 寒冰屏障，吉安娜

	[276093]	= true,		-- 血色镜像，祖尔
	[276299]	= true,		-- 充血爆发，祖尔
	[276434]	= true,		-- 腐烂血肉，祖尔
	[276900]	= true,		-- 临界炽焰，拆解者米斯拉克斯
	[263482]	= true,		-- 重组冲击，戈霍恩
	[263284]	= true,		-- 鲜血之力，戈霍恩
	[268074]	= true,		-- 黑暗意图，戈霍恩
	[275204]	= true,		-- 不可阻挡的腐化，戈霍恩

	[207327]	= true,		-- 净化毁灭，崔利艾克斯
	[236513]	= true,		-- 骨牢护甲，聚合体小怪
	[240315]	= true,		-- 硬化之壳，哈亚坦蛋盾
	[241521]	= true,		-- 折磨碎片，M审判庭小怪
	[250074]	= true,		-- 净化，艾欧娜尔
	[250555]	= true,		-- 邪能护盾，艾欧娜尔
	[246504]	= true,		-- 程式启动，金加洛斯
	[249863]	= true,		-- 泰坦的面容，破坏魔女巫会
	[244903]	= true,		-- 催化作用，阿格拉玛
	[247091]	= true,		-- 催化，阿格拉玛
	[253021]	= true,		-- 宿命，寂灭者阿古斯
	[255496]	= true,		-- 宇宙之剑，寂灭者阿古斯
	[255478]	= true,		-- 永恒之刃，寂灭者阿古斯
	[255418]	= true,		-- 物理易伤，寂灭者阿古斯
	[255425]	= true,		-- 冰霜易伤，寂灭者阿古斯
	[255430]	= true,		-- 暗影易伤，寂灭者阿古斯
	[255429]	= true,		-- 火焰易伤，寂灭者阿古斯
	[255419]	= true,		-- 神圣易伤，寂灭者阿古斯
	[255422]	= true,		-- 自然易伤，寂灭者阿古斯
	[255433]	= true,		-- 奥术易伤，寂灭者阿古斯
}

C['AuraBlackList'] = {
	[15407]		= true,		-- 精神鞭笞
	--[1490]	= true,		-- 混乱烙印
	--[113746]	= true,		-- 玄秘掌
	[51714]		= true,		-- 锋锐之霜
	[199721]	= true,		-- 腐烂光环
	[214968]	= true,		-- 死灵光环
	[214975]	= true,		-- 抑心光环
	[273977]	= true,		-- 亡者之握
	[276919]	= true,		-- 承受压力
	[206930]	= true,		-- 心脏打击
}


-- 取自地城手册的段落ID
-- 纯数字则为GUID，选择目标后输入/getnpc获取
local function GetSectionInfo(id)
	return C_EncounterJournal.GetSectionInfo(id).title
end

-- 特殊单位的染色列表
C['NPSpecialUnitsList'] = {
	[120651] = true, -- 爆炸物
	[141851] = true, -- 戈霍恩之嗣
	[153377] = true, -- 粘液，麦卡贡
	[155432] = true, -- 魔力使者
	[155433] = true, -- 虚触使者
	[155434] = true, -- 潮汐使者
	[161895] = true, -- 彼岸之物
	[153527] = true, -- 亚基虫群领袖
	[153401] = true, -- 克熙尔支配者
	[157610] = true, -- 克熙尔支配者
	[156795] = true, -- 军情七处线人

	[GetSectionInfo(14544)] = true,	-- 海拉加尔观雾者
	[GetSectionInfo(14595)] = true,	-- 深渊追猎者
	[GetSectionInfo(16588)] = true,	-- 尖啸反舌鸟
	[GetSectionInfo(16350)] = true,	-- 瓦里玛萨斯之影

	[GetSectionInfo(18540)] = true,	-- 纳兹曼尼鲜血妖术师
	[GetSectionInfo(18104)] = true,	-- 散疫触须
	[GetSectionInfo(18232)] = true,	-- 艾什凡炮手
	[GetSectionInfo(18499)] = true,	-- 凝结之血
	[GetSectionInfo(18078)] = true,	-- 蛛魔编织者
	[GetSectionInfo(18007)] = true,	-- 瘟疫聚合体
	[GetSectionInfo(18053)] = true,	-- 灵魂荆棘
	[GetSectionInfo(18312)] = true,	-- 血面兽
	[GetSectionInfo(18890)] = true,	-- 夏尔扎克斯
	[GetSectionInfo(18321)] = true,	-- 缠绕的蛇群
	[GetSectionInfo(18271)] = true,	-- 爆裂图腾
	[GetSectionInfo(17026)] = true,	-- 眩晕酒桶
	[GetSectionInfo(19656)] = true,	-- 僵尸尘图腾
	[GetSectionInfo(19393)] = true,	-- 雪怒之魂
	[GetSectionInfo(19279)] = true,	-- 谄媚海妖
	[GetSectionInfo(19019)] = true,	-- 贪婪的追猎者
	['爆裂工虫'] = true,
	[GetSectionInfo(21209)] = true,	-- 亚基掠夺者
	[GetSectionInfo(20561)] = true,	-- 惊魂淤血
	[GetSectionInfo(21329)] = true,	-- 聚合增生
}

-- 显示能量值的单位
C['NPShowPowerUnitsList'] = {
	[155432] = true, -- 魔力使者
	[152703] = true, -- 步行震击者X1型，麦卡贡
	[163746] = true, -- 步行震击者X1型
	[GetSectionInfo(13015)] = true,	-- 清扫器
	[GetSectionInfo(15903)] = true,	-- 泰沙拉克的余烬
	[GetSectionInfo(18540)] = true,	-- 纳兹曼尼鲜血妖术师
	[GetSectionInfo(18539)] = true,	-- 碾压者
}


C.CharacterSettings = {
	['BFA'] = false,
	['classic'] = false,
	['installation'] = {
		['complete'] = false,
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
		['queue_timer'] = true,
		['easy_delete'] = true,
		['pet_filter'] = true,
		['instant_loot'] = false,
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
			['easy_mark'] = true,
			['fct'] = true,
				['fct_pet'] = true,
				['fct_periodic'] = true,
				['fct_merge'] = true,
				['fct_in'] = true,
				['fct_out'] = false,
	},

	['announcement'] = {
		['enable'] = true,
			['interrupt'] = true,
			['dispel'] = true,
			['stolen'] = true,
			['combat_resurrection'] = true,
			['utility'] = true,
			['quest'] = false,
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
			['reminder'] = true,
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
				['item_filter_mount_pet'] = true,
				['item_filter_favourite'] = true,
			['auto_sell_junk'] = false,
			['auto_repair'] = false,
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

			['enable_castbar'] = true,
				['casting_color'] = {r=.31, g=.48, b=.85},
				['casting_uninterruptible_color'] = {r=.66, g=.65, b=.65},
				['casting_complete_color'] = {r=.25, g=.63, b=.49},
				['casting_fail_color'] = {r=.73, g=.39, b=.43},

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
				['pet_auras'] = true,
				['pet_auras_per_row'] = 3,

			['enable_target'] = true,
				['target_width'] = 160,
				['target_height'] = 8,
				['target_auras'] = true,
				['target_auras_per_row'] = 6,

				['target_target_width'] = 60,
				['target_target_height'] = 8,

			['enable_focus'] = true,
				['focus_width'] = 60,
				['focus_height'] = 8,
				['focus_auras'] = false,
				['focus_auras_per_row'] = 4,

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
				['group_corner_buffs'] = true,
				['raid_debuffs'] = true,
				['auras_click_through'] = false,
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
				['arena_auras'] = true,
				['arena_auras_per_row'] = 6,
	},

	['nameplate'] = {
		['enable'] = true,
			['plate_width'] = 76,
			['plate_height'] = 8,
			['friendly_class_color'] = false,
			['friendly_color'] = {r=.3, g=.3, b=1},
			['hostile_class_color'] = true,

			['tank_mode'] = false,
			['secure_color'] = {r=1, g=0, b=1},
			['trans_color'] = {r=1, g=.8, b=0},
			['insecure_color'] = {r=1, g=0, b=0},
			['off_tank_color'] = {r=.2, g=.7, b=.5},
			['dps_revert_threat'] = false,

			['custom_unit_color'] = true,
			['custom_color'] = {r=.8, g=.42, b=.31},
			['custom_unit_list'] = '',
			['show_power_list'] = '',
			['target_indicator'] = true,
				['target_color'] = {r=.73, g=.92, b=.99},
			['threat_indicator'] = true,
			['classify_indicator'] = true,
			['interrupt_name'] = true,
			['explosive_scale'] = false,

			['plate_auras'] = true,
				['aura_size'] = 22,
				['aura_number'] = 6,

			['inside_view'] = true,
			['min_scale'] = 0.7,
			['target_scale'] = 1,
			['min_alpha'] = 0.6,
			['occluded_alpha'] = 0.2,
			['vertical_spacing'] = 0.7,
			['horizontal_spacing'] = 0.3,
	},

	['tooltip'] = {
		['enable'] = true,
			['follow_cursor'] = false,
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
	},

	['map'] = {
		['enable'] = true,
			['worldmap_scale'] = 1,
			['max_worldmap_scale'] = 1,
			['remove_fog'] = true,
			['coords'] = true,
			['minimap_scale'] = 1,
			['new_mail'] = true,
			['calendar'] = true,
			['instance_type'] = true,
			['who_pings'] = true,
			['micro_menu'] = true,
			['progress_bar'] = true,
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
	},

	['notification'] = {
		['enable'] = true,
			['bag_full'] = true,
			['new_mail'] = true,
			['version_check'] = false,
			['rare_found'] = true,
	},

	['misc'] = {
		['blow_my_whistle'] = true,
		['group_tool'] = true,
			['rune_check'] = false,
			['countdown'] = '10',
		['buy_stack'] = true,
		['auto_screenshot'] = true,
			['screenshot_achievement'] = true,
			['screenshot_challenge'] = true,
			['screenshot_levelup'] = false,
			['screenshot_dead'] = false,


		['reward_highlight'] = true,
		['quick_quest'] = false,
		['quest_completed_sound'] = true,
		['quest_tracker_buttons'] = true,
		['faster_camera'] = true,

		['item_level'] = true,
			['gem_enchant'] = true,
			['azerite_traits'] = true,

		['screen_saver'] = true,
	},

	['chat'] = {
		['enable'] = true,
			['lock_position'] = true,
				['window_width'] = 300,
				['window_height'] = 100,
			['font_outline'] = false,
			['fade_out'] = true,
				['fading_visible'] = 120,
				['fading_duration'] = 6,
			['abbr_channel_names'] = true,
			['copy_button'] = true,
			['voice_button'] = true,
			['tab_cycle'] = true,
			['smart_bubble'] = false,
			['whisper_invite'] = false,
				['invite_keyword'] = 'inv',
				['guild_only'] = true,
			['whisper_sticky'] = true,
			['whisper_sound'] = true,
				['sound_timer'] = 30,
			['item_links'] = true,
			['spamage_meter'] = true,
			['use_filter'] = true,
			['matche_number'] = 1,
			['allow_friends_spam'] = true,
			['block_stranger_whisper'] = false,
			['block_addon_spam'] = true,
	},

	['actionbar'] = {
		['enable'] = true,
			['scale'] = 1,
			['button_size_small'] = 22,
			['button_size_normal'] = 26,
			['button_size_big'] = 30,
			['button_hotkey'] = false,
			['button_macro_name'] = false,
			['button_count'] = true,
			['button_class_color'] = false,
			['button_range'] = true,

			['fade'] = true,
			['fade_out_alpha'] = 0,
			['fade_in_alpha'] = 1,
			['fade_out_duration'] = .3,
			['fade_in_duration'] = .3,
			['condition_combating'] = true,
			['condition_targeting'] = false,
			['condition_dungeon'] = true,
			['condition_pvp'] = true,
			['condition_vehicle'] = true,

			['custom_bar'] = false,
				['custom_bar_margin'] = 3,
				['custom_bar_padding'] = 3,
				['custom_bar_button_size'] = 30,
				['custom_bar_button_number'] = 12,
				['custom_bar_button_per_row'] = 6,

			['bar1'] = true,
			['bar2'] = true,
			['bar3'] = true,
				['bar3_divide'] = true,
			['bar4'] = false,
			['bar5'] = false,
			['pet_bar'] = true,
			['stance_bar'] = false,
			['leave_vehicle_bar'] = true,

			['bind_type'] = 1,
	},

	['cooldown'] = {
		['enable_cooldown'] = true,
			['use_decimal'] = true,
				['decimal_countdown'] = 3,
			['override_weakauras'] = true,
			['pulse'] = true,
				['sound'] = false,
				['icon_size'] = 32,
				['sound_file'] = '',
				['ignored_spells'] = {
					--GetSpellInfo(6807),	-- Maul
					--GetSpellInfo(35395),	-- Crusader Strike
				},
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
	['reskin_blizz'] = true,
	['border_color'] = {r=.05, g=.05, b=.05},
	['backdrop_color'] = {r=.1, g=.1, b=.1},
	['backdrop_alpha'] = .75,
	['shadow_border'] = true,
	['reskin_dbm'] = true,
	['reskin_pgf'] = true,
	['chat_filter_black_list'] = '',
	['chat_filter_white_list'] = '',
	['custom_junk_list'] = {},
	['nameplate_aura_filter_list'] = {[1]={}, [2]={}},
	['raid_debuffs_list'] = {},
	['raid_aura_watch'] = {},
	['corner_buffs'] = {},
	['party_spells_list'] = {},
	['profile_index'] = {},
	['profile_names'] = {},

	['health_color'] = {r=.81, g=.81, b=.81},
	['custom_class_color'] = false,
	['class_colors_list'] = {
		['HUNTER'] = {
			['r'] = 0.2,
			['g'] = 0.71,
			['b'] = 0.25,
			['colorStr'] = 'ff33b541',
		},
		['WARRIOR'] = {
			['r'] = 0.78,
			['g'] = 0.61,
			['b'] = 0.39,
			['colorStr'] = 'ffc79b64',
		},
		['PALADIN'] = {
			['r'] = 0.93,
			['g'] = 0.33,
			['b'] = 0.42,
			['colorStr'] = 'ffee556c',
		},
		['MAGE'] = {
			['r'] = 0.49,
			['g'] = 0.66,
			['b'] = 0.89,
			['colorStr'] = 'ff7ea8e3',
		},
		['PRIEST'] = {
			['r'] = 0.83,
			['g'] = 0.83,
			['b'] = 0.83,
			['colorStr'] = 'ffd3d3d3',
		},
		['DEATHKNIGHT'] = {
			['r'] = 0.77,
			['g'] = 0.16,
			['b'] = 0.22,
			['colorStr'] = 'ffc32838',
		},
		['WARLOCK'] = {
			['r'] = 0.65,
			['g'] = 0.64,
			['b'] = 0.88,
			['colorStr'] = 'ffa5a3e0',
		},
		['DEMONHUNTER'] = {
			['r'] = 0.82,
			['g'] = 0.35,
			['b'] = 0.89,
			['colorStr'] = 'ffd259e3',
		},
		['ROGUE'] = {
			['r'] = 0.91,
			['g'] = 0.81,
			['b'] = 0.51,
			['colorStr'] = 'ffe9cb7f',
		},
		['DRUID'] = {
			['r'] = 0.95,
			['g'] = 0.48,
			['b'] = 0.27,
			['colorStr'] = 'fff27944',
		},
		['MONK'] = {
			['r'] = 0.28,
			['g'] = 0.84,
			['b'] = 0.6,
			['colorStr'] = 'ff48d599',
		},
		['SHAMAN'] = {
			['r'] = 0.29,
			['g'] = 0.29,
			['b'] = 0.82,
			['colorStr'] = 'ff4949d0',
		},

	},

}






local function initSettings(source, target, fullClean)
	for i, j in pairs(source) do
		if type(j) == 'table' then
			if target[i] == nil then target[i] = {} end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then target[i] = j end
		end
	end

	for i, j in pairs(target) do
		if source[i] == nil then target[i] = nil end
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
f:SetScript('OnEvent', function(self, _, addon)
	if addon ~= 'FreeUI' then return end

	initSettings(C.AccountSettings, FREE_ADB)
	if not next(FREE_PDB) then
		for i = 1, 5 do FREE_PDB[i] = {} end
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
end)
