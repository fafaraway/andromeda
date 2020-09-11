local F, C = unpack(select(2, ...))







--[[ C['General'] = {

	['number_format'] = 1,

	['blizz_mover'] = true,
	['already_known'] = true,
	['hide_boss_banner'] = true,
	['hide_talking_head'] = true,
	['item_level'] = true,
		['merchant_ilvl'] = true,
		['gem_enchant'] = true,
		['azerite_traits'] = true,
	['tidy_errors'] =true,
	['mail_button'] = true,
	['undress_button'] = true,
	['trade_target_info'] = true,
	['trade_tabs'] = true,
	['missing_stats'] = true,
	['pet_filter'] = true,
	['account_keystone'] = true,
	['queue_timer'] = true,
	['color_picker'] = true,
	['whistle'] = true,

	['group_tool'] = true,
	['action_camera'] = true,
	['faster_camera'] = true,

	['block_stranger_invite'] = false,
	['instant_loot'] = true,
	['easy_mark'] = true,
	['easy_delete'] = true,
	['easy_naked'] = true,
	['easy_focus'] = true,
		['easy_focus_on_unitframes'] = false,
} ]]








C['classmod'] = {
	['havocFury'] = true,
}


C['ReminderBuffs'] = {
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
		{	spells = {	-- 闪电之盾
				[192106] = true,
			},
			depend = 192106,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	ROGUE = {
		{	spells = {	-- 伤害类毒药
				[2823] = true,		-- 致命药膏
				[8679] = true,		-- 致伤药膏
			},
			spec = 1,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 效果类毒药
				[3408] = true,		-- 减速药膏
			},
			spec = 1,
			pvp = true,
		},
	},
}


C['CornerBuffs'] = {
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
		[34477]  = {'BOTTOMRIGHT', {.9, .1, .1}},		-- 误导
		[90361]  = {'TOPLEFT', {.4, .8, .2}},			-- 灵魂治愈
	},
	['WARLOCK'] = {
		[20707]  = {'BOTTOMRIGHT', {.8, .4, .8}, true},	-- 灵魂石
	},
	['DEMONHUNTER'] = {},
	['MAGE'] = {},
	['DEATHKNIGHT'] = {},
}

C['ClassBuffs'] = {
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

C['IgnoredDebuffs'] = {
	[  6788] = C.MyClass ~= 'PRIEST',	-- Weakened Soul
	[ 25771] = C.MyClass ~= 'PALADIN',	-- Forbearance

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

C['GroupBuffs'] = {
	-- Immunities
	[196555] = true,	-- Netherwalk (Demon Hunter)
	[186265] = true,	-- Aspect of the Turtle (Hunter)
	[ 45438] = true,	-- Ice Block (Mage)
	[125174] = true,	-- Touch of Karma (Monk)
	[228050] = true,	-- Divine Shield (Prot Paladin PVP)
	[   642] = true,	-- Divine Shield (Paladin)
	[199448] = true,	-- Blessing of Ultimate Sacrifice (Paladin)
	[  1022] = true,	-- Blessing of Protection (Paladin)
	[ 47788] = true,	-- Guardian Spirit (Priest)
	[ 31224] = true,	-- Cloak of Shadows (Rogue)
	[210918] = true,	-- Ethereal Form (Shaman)

	-- Defensive buffs
	-- Warrior
	[190456] = true,	-- Ignore Pain
	[118038] = true,	-- Die by the Sword
	[   871] = true,	-- Shield Wall
	[213915] = true,	-- Mass Spell Reflection
	[ 23920] = true,	-- Spell Reflection (Prot)
	[216890] = true,	-- Spell Reflection (Arms/Fury)
	[184364] = true,	-- Enraged Regeneration
	[ 97463] = true,	-- Rallying Cry
	[ 12975] = true,	-- Last Stand

	-- Death Knight
	[ 48707] = true,	-- Anti-Magic Shell
	[ 48792] = true,	-- Icebound Fortitude
	[287081] = true,	-- Lichborne
	[ 55233] = true,	-- Vampiric Blood
	[194679] = true,	-- Rune Tap
	[145629] = true,	-- Anti-Magic Zone
	[ 81256] = true,	-- Dancing Rune Weapon

	-- Paladin
	[204018] = true,	-- Blessing of Spellwarding
	[  6940] = true,	-- Blessing of Sacrifice
	[   498] = true,	-- Divine Protection
	[ 31850] = true,	-- Ardent Defender
	[ 86659] = true,	-- Guardian of Ancient Kings
	[205191] = true,	-- Eye for an Eye

	-- Shaman
	[108271] = true,	-- Astral Shift
	[118337] = true,	-- Harden Skin

    -- Hunter
	[ 53480] = true,	-- Roar of Sacrifice
	[264735] = true,	-- Survival of the Fittest (Pet Ability)
	[281195] = true,	-- Survival of the Fittest (Lone Wolf)

	-- Demon Hunter
	[206804] = true,	-- Rain from Above
	[187827] = true,	-- Metamorphosis (Vengeance)
	[212800] = true,	-- Blur
	[263648] = true,	-- Soul Barrier

	-- Druid
	[102342] = true,	-- Ironbark
	[ 22812] = true,	-- Barkskin
	[ 61336] = true,	-- Survival Instincts

	-- Rogue
	[ 45182] = true,	-- Cheating Death
	[  5277] = true,	-- Evasion
	[199754] = true,	-- Riposte
	[  1966] = true,	-- Feint

	-- Monk
	[120954] = true,	-- Fortifying Brew (Brewmaster)
	[243435] = true,	-- Fortifying Brew (Mistweaver)
	[201318] = true,	-- Fortifying Brew (Windwalker)
	[115176] = true,	-- Zen Meditation
	[116849] = true,	-- Life Cocoon
	[122278] = true,	-- Dampen Harm
	[122783] = true,	-- Diffuse Magic

	-- Mage
	[198111] = true,	-- Temporal Shield
	[113862] = true,	-- Greater Invisibility

	-- Priest
	[ 47585] = true,	-- Dispersion
	[ 33206] = true,	-- Pain Suppression
	[213602] = true,	-- Greater Fade
	[ 81782] = true,	-- Power Word: Barrier
	[271466] = true,	-- Luminous Barrier

	-- Warlock
	[104773] = true, 	-- Unending Resolve
	[108416] = true, 	-- Dark Pact
	[212195] = true,	-- Nether Ward
}

C['RaidDebuffs'] = {}




C['PartySpells'] = {
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
	[102342] = 60,	-- 铁木树皮
	[102793] = 60,	-- 乌索尔旋风
	[119381] = 60,	-- 扫堂腿
	[179057] = 60,	-- 混乱新星
	[205636] = 60,	-- 树人
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

C['TalentCDFix'] = {
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


-- 取自地城手册的段落ID
-- 纯数字则为GUID，选择目标后输入/getnpc获取
local function GetSectionInfo(id)
	return C_EncounterJournal.GetSectionInfo(id).title
end

-- 特殊单位的染色列表
C['CustomUnits'] = {
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
	["爆裂工虫"] = true,
	[GetSectionInfo(21209)] = true,	-- 亚基掠夺者
	[GetSectionInfo(20561)] = true,	-- 惊魂淤血
	[GetSectionInfo(21329)] = true,	-- 聚合增生
}

-- 显示能量值的单位
C['ShowPowerList'] = {
	[155432] = true, -- 魔力使者
	[152703] = true, -- 步行震击者X1型，麦卡贡
	[163746] = true, -- 步行震击者X1型
	[GetSectionInfo(13015)] = true,	-- 清扫器
	[GetSectionInfo(15903)] = true,	-- 泰沙拉克的余烬
	[GetSectionInfo(18540)] = true,	-- 纳兹曼尼鲜血妖术师
	[GetSectionInfo(18539)] = true,	-- 碾压者
}


C.CharacterSettings = {
	['BfA'] = false,
	['classic'] = false,
	['installation_complete'] = false,
	['ui_anchor'] = {},
	['ui_anchor_temp'] = {},






	['item_level'] = true,
		['merchant_ilvl'] = true,
		['gem_enchant'] = true,
		['azerite_traits'] = true,

	['blow_my_whistle'] = true,

	['group_tool'] = true,
	['action_camera'] = true,
	['faster_camera'] = true,

	['block_stranger_invite'] = false,
	['instant_loot'] = true,


	['announcement'] = {
		['enable_announcement'] = true,
			['my_interrupt'] = true,
			['my_dispel'] = true,
			['get_sapped'] = true,
			['combat_rez'] = true,
			['feast_cauldron'] = true,
			['bot_codex'] = true,
			['mage_portal'] = true,
			['create_soulwell'] = true,
			['mail_service'] = true,
			['conjure_refreshment'] = true,
			['special_toy'] = true,
	},


	['blizzard'] = {
		['hide_talkinghead'] = true,
		['hide_boss_banner'] = true,
		['hide_boss_emote'] = true,
		['missing_stats'] = true,
		['mail_button'] = true,
		['orderhall_icon'] = true,
		['tradeskill_tabs'] = true,
		['undress_button'] = true,
		['trade_target_info'] = true,
		['tidy_errors'] = true,
		['naked_button'] = true,
		['queue_timer'] = true,
		['easy_delete'] = true,
		['pet_filter'] = true,
	},

	['combat'] = {
		['enable_combat'] = true,
			['combat_alert'] = true,
			['health_alert'] = true,
				['health_alert_threshold'] = 0.3,
			['spell_alert'] = true,
			['pvp_sound'] = true,
			['easy_tab'] = true,
			['easy_focus'] = true,
				['easy_focus_on_unitframes'] = false,
			['easy_mark'] = true,
	},



	['quest'] = {
		['enable_quest'] = true,
			['quest_level'] = true,
			['reward_highlight'] = true,
			['extra_button'] = true,
			['quest_progress'] = true,
			['complete_ring'] = true,
			['quick_quest'] = false,
	},

	['aura'] = {
		['enable_aura'] = true,
			['margin'] = 6,
			['offset'] = 12,
			['buff_size'] = 40,
			['buffs_per_row'] = 12,
			['reverse_buffs'] = true,
			['debuff_size'] = 50,
			['debuffs_per_row'] = 12,
			['reverse_debuffs'] = true,
			['buff_reminder'] = true,
	},

	['inventory'] = {
		['enable_inventory'] = true,
			['scale'] = 1,
			['offset'] = 26,
			['spacing'] = 3,
			['slot_size'] = 44,
			['bag_columns'] = 10,
			['bank_columns'] = 10,
			['reverse_sort'] = true,
			['item_level'] = true,
				['item_level_to_show'] = 1,
			['new_item_flash'] = true,
			['combine_free_slots'] = true,
			['split_count'] = 1,
			['special_color'] = true,
			['favourite_items'] = {},
			['item_filter'] = true,
				['item_filter_gear_set'] = false,
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
		['enable_unitframe'] = true,
			['transparency'] = true,
			['texture_style'] = 1,
			['combat_fader'] = true,
			['color_smooth'] = false,
			['portrait'] = true,
			['class_color'] = true,

			['heal_prediction'] = true,
			['over_absorb'] = true,
			['gcd_spark'] = true,
			['combat_text'] = true,
				['ct_pet'] = true,
				['ct_hot'] = true,
				['ct_over_healing'] = false,
				['ct_auto_attack'] = true,
				['ct_abbr_number'] = true,

			['target_icon_indicator'] = true,

			['power_bar'] = true,
			['power_bar_height'] = 1,
			['alt_power'] = true,
			['alt_power_height'] = 2,

			['class_power_bar'] = true,
				['class_power_bar_height'] = 2,
			['runes_timer'] = true,
			['stagger_bar'] = true,
			['totems_bar'] = true,



			['enable_castbar'] = true,
				['castingColor'] = {r=.43, g=.69, b=.85},
				['notInterruptibleColor'] = {r=.75, g=.04, b=.07},
				['completeColor'] = {r=.25, g=.63, b=.49},
				['failColor'] = {r=.73, g=.39, b=.43},

				['castbar_focus_separate'] = false,
				['castbar_focus_width'] = 200,
				['castbar_focus_height'] = 16,
				['castbar_timer'] = false,

			['enable_player'] = true,
				['player_width'] = 140,
				['player_height'] = 8,
				['player_auras'] = false,
				['player_auras_number'] = 18,
				['player_auras_number_per_row'] = 6,

				['player_pvp_indicator'] = true,
				['player_combat_indicator'] = true,
				['player_resting_indicator'] = true,

				['player_hide_tags'] = true,



			['enable_pet'] = true,
				['pet_width'] = 50,
				['pet_height'] = 8,
				['pet_auras'] = true,
				['pet_auras_number_per_row'] = 3,
				['pet_auras_number'] = 12,

			['enable_target'] = true,
				['target_width'] = 240,
				['target_height'] = 8,
				['target_auras'] = true,
				['target_auras_number_per_row'] = 7,
				['target_auras_number'] = 35,
				['target_debuffs_by_player'] = true,

				['target_target_width'] = 80,
				['target_target_height'] = 8,

			['enable_focus'] = true,
				['focus_width'] = 60,
				['focus_height'] = 8,
				['focus_auras'] = false,
				['focus_auras_number_per_row'] = 4,
				['focus_auras_number'] = 16,

				['focus_target_width'] = 60,
				['focus_target_height'] = 8,

			['enable_group'] = true,
				['group_names'] = false,
				['group_color_smooth'] = false,
				['group_filter'] = 6,

				['group_by_role'] = true,
				['group_reverse'] = false,
				['range_check'] = true,
					['range_check_alpha'] = 0.4,
				['group_click_cast'] = true,
				['group_click_cast_filter'] = false,
				['group_click_cast_config'] = {},
				['group_debuff_highlight'] = true,
				['group_corner_buffs'] = true,
				['group_debuffs'] = true,
				['party_spell_watcher'] = true,
				['party_spell_sync'] = true,

				['group_threat_indicator'] = true,
				['group_leader_indicator'] = true,
				['group_role_indicator'] = true,
				['group_summon_indicator'] = true,
				['group_phase_indicator'] = true,
				['group_ready_check_indicator'] = true,
				['group_resurrect_indicator'] = true,

				['party_width'] = 60,
				['party_height'] = 34,
				['party_gap'] = 6,

				['raid_width'] = 44,
				['raid_height'] = 32,
				['raid_gap'] = 5,



			['enable_boss'] = true,
				['boss_color_smooth'] = true,
				['boss_width'] = 166,
				['boss_height'] = 20,
				['boss_gap'] = 60,
				['boss_auras'] = true,
				['boss_auras_number_per_row'] = 5,
				['boss_auras_number'] = 15,
				['boss_debuffs_by_player'] = true,

			['enable_arena'] = true,
				['arena_width'] = 166,
				['arena_height'] = 16,
				['arena_gap'] = 80,
				['arenaShowAuras'] = true,
				['arenaAuraPerRow'] = 6,
				['arenaAuraTotal'] = 18,
	},

	['nameplate'] = {
		['enable_nameplate'] = true,
			['plate_width'] = 50,
			['plate_height'] = 5,
			['friendly_class_color'] = false,
			['hostile_class_color'] = true,
			['tank_mode'] = false,
			['secure_color'] = {r=1, g=0, b=1},
			['trans_color'] = {r=1, g=.8, b=0},
			['insecure_color'] = {r=1, g=0, b=0},
			['off_tank_color'] = {r=.2, g=.7, b=.5},
			['dps_revert_threat'] = false,
			['custom_unit_color'] = true,
			['custom_color'] = {r=0, g=.8, b=.3},
			['custom_unit_list'] = '',
			['show_power_list'] = '',
			['selected_indicator'] = true,
			['selected_color'] = {r=.73, g=.92, b=.99},
			['interrupt_name'] = true,
	},

	['tooltip'] = {
		['enable_tooltip'] = true,
			['header_font_size'] = 16,
			['normal_font_size'] = 14,
			['follow_cursor'] = false,
			['hide_title'] = true,
			['hide_realm'] = true,
			['hide_rank'] = true,
			['hide_in_combat'] = false,
			['border_color'] = true,
			['spec_ilvl'] = true,
			['azerite_armor'] = true,
			['link_hover'] = true,
			['tip_icon'] = true,
			['target_by'] = true,
			['pvp_rating'] = false,
			['various_ids'] = true,
			['item_count'] = true,
			['item_price'] = true,
			['aura_source'] = true,
			['mount_source'] = false,
	},

	['map'] = {
		['enable_map'] = true,
			['map_scale'] = 1,
			['map_reveal'] = false,
			['coords'] = true,
			['minimap_scale'] = 1,
			['new_mail'] = true,
			['calendar'] = true,
			['instance_type'] = true,
			['who_pings'] = true,
			['world_marker'] = true,
			['micro_menu'] = true,
			['progress_bar'] = true,
	},

	['infobar'] = {
		['enable_infobar'] = true,
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
		['enable_notification'] = true,
			['bag_full'] = true,
			['new_mail'] = true,
			['version_check'] = true,
			['rare_found'] = true,
	},

	['misc'] = {
		['accept_acquaintance_invite'] = false,
		['block_stranger_invite'] = false,
		['invite_keyword'] = 'inv',
		['invite_whisper'] = true,
		['invite_only_guild'] = true,
	},

	['chat'] = {
		['enable'] = true,
			['lock_position'] = true,
				['window_width'] = 300,
				['window_height'] = 100,
			['font_outline'] = false,
			['fade_out'] = true,
				['fading_visible'] = 60,
				['fading_duration'] = 6,

			['abbr_channel_names'] = true,
			['copy_button'] = true,
			['voice_button'] = true,
			['tab_cycle'] = true,
			['smart_bubble'] = false,
			['whisper_sticky'] = true,
			['whisper_sound'] = true,
				['sound_timer'] = 30,

			['item_links'] = true,
			['spamage_meter'] = true,
			['filters'] = true,
			['matche_number'] = 1,
			['keywords_list'] = '%*',
			['allow_friends_spam'] = false,
			['block_stranger_whisper'] = false,
			['block_addon_spam'] = true,
			['addon_keywords_list'] = {
				'任务进度提示', '%[接受任务%]', '%(任务完成%)', '<大脚', '【爱不易】', 'EUI[:_]', '打断:.+|Hspell', 'PS 死亡: .+>', '%*%*.+%*%*', '<iLvl>', string.rep('%-', 20),
				'<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', '汐寒', 'wow.+兑换码', 'wow.+验证码', '【有爱插件】', '：.+>', '|Hspell.+=>'
			},
			['trash_clubs'] = {'站桩', '致敬我们', '我们一起玩游戏', '部落大杂烩'}
	},

	['actionbar'] = {
		['enable_actionbar'] = true,
			['bar_padding'] = 3,
			['button_margin'] = 3,
			['button_size_small'] = 22,
			['button_size_normal'] = 28,
			['button_size_big'] = 38,

			['button_hotkey'] = false,
			['button_macro_name'] = false,
			['button_count'] = false,
			['button_class_color'] = false,
			['button_range'] = true,

			['bar1'] = true,
				['bar1_fade'] = true,
				['bar1_minimal'] = false,
			['bar2'] = true,
				['bar2_fade'] = true,
			['bar3'] = true,
				['bar3_divide'] = true,
				['bar3_fade'] = true,
			['bar4'] = false,
				['bar4_fade'] = false,
			['bar5'] = false,
				['bar5_fade'] = false,
			['pet_bar'] = false,
				['pet_bar_fade'] = false,
			['enable_stance_bar'] = false,
				['stance_bar_fade'] = false,

			['bind_type'] = 1,

			['enable_cooldown'] = true,
				['use_decimal'] = true,
					['decimal_countdown'] = 3,
				['override_weakauras'] = true,
				['cd_pulse'] = true,
					['pulse_sound'] = false,
					['pulse_sound_file'] = '',
					['ignored_spells'] = {
						--GetSpellInfo(6807),	-- Maul
						--GetSpellInfo(35395),	-- Crusader Strike
					},
	}
}


C.AccountSettings = {
	['ui_scale'] = 1,
	['ui_gap'] = 33,
	['gold_count'] = {},

	['custom_junk_list'] = {},
	['number_format'] = 1,
	['keystone_info'] = {},

	['appearance'] = {
		['cursor_trail'] = true,
		['vignetting'] = true,
			['vignetting_alpha'] = .8,
		['adjust_font'] = true,

		['backdrop_alpha'] = .7,

		['reskin_blizz'] = true,
		['shadow_border'] = true,

		['reskin_dbm'] = true,
		['reskin_weakauras'] = true,
		['reskin_pgf'] = true,
		['reskin_skada'] = true,
		['reskin_wowlua'] = true,
		['reskin_toasts'] = true,
		['reskin_meetingstone'] = true,
	},

	['reaction_colors'] = {
	},

	['power_colors'] = {
		['PAIN'] = {
			['b'] = 0,
			['g'] = 0.611764705882353,
			['r'] = 1,
		},
		['FURY'] = {
			['b'] = 0.992,
			['g'] = 0.259,
			['r'] = 0.788,
		},
		['FOCUS'] = {
			['b'] = 0.1529411764705883,
			['colorStr'] = 'fff06327',
			['g'] = 0.3882352941176471,
			['r'] = 0.9411764705882353,
		},
		['LUNAR_POWER'] = {
			['b'] = 0.9,
			['g'] = 0.52,
			['r'] = 0.3,
		},
		['RAGE'] = {
			['b'] = 0.196078431372549,
			['colorStr'] = 'ffdc3c32',
			['g'] = 0.2352941176470588,
			['r'] = 0.8627450980392157,
		},
		['MAELSTROM'] = {
			['b'] = 1,
			['g'] = 0.5,
			['r'] = 0,
		},
		['MANA'] = {
			['b'] = 0.93,
			['g'] = 0.82,
			['r'] = 0.46,
		},
		['RUNIC_POWER'] = {
			['b'] = 1,
			['g'] = 0.82,
			['r'] = 0,
		},
		['INSANITY'] = {
			['b'] = 0.8,
			['g'] = 0,
			['r'] = 0.4,
		},
		['ENERGY'] = {
			['b'] = 0.4549019607843137,
			['colorStr'] = 'ffe9c374',
			['g'] = 0.7647058823529411,
			['r'] = 0.9137254901960784,
		},
	},

	['class_colors'] = {
		['HUNTER'] = {
			['r'] = 0.1529411764705883,
			['colorStr'] = 'ff27b61f',
			['g'] = 0.7137254901960784,
			['b'] = 0.1215686274509804,
		},
		['WARRIOR'] = {
			['r'] = 0.7764705882352941,
			['colorStr'] = 'ffc6925f',
			['g'] = 0.5725490196078431,
			['b'] = 0.3725490196078432,
		},
		['PALADIN'] = {
			['r'] = 0.9568627450980391,
			['colorStr'] = 'fff3547d',
			['g'] = 0.3294117647058824,
			['b'] = 0.4901960784313725,
		},
		['MAGE'] = {
			['r'] = 0.4313725490196079,
			['colorStr'] = 'ff6eb2e2',
			['g'] = 0.6980392156862745,
			['b'] = 0.8862745098039215,
		},
		['PRIEST'] = {
			['r'] = 0.8941176470588235,
			['colorStr'] = 'ffe3e3e3',
			['g'] = 0.8941176470588235,
			['b'] = 0.8941176470588235,
		},
		['SHAMAN'] = {
			['r'] = 0.2745098039215687,
			['colorStr'] = 'ff4646c3',
			['g'] = 0.2745098039215687,
			['b'] = 0.7647058823529411,
		},
		['WARLOCK'] = {
			['r'] = 0.7137254901960784,
			['colorStr'] = 'ffb6aae0',
			['g'] = 0.6666666666666666,
			['b'] = 0.8784313725490196,
		},
		['DEMONHUNTER'] = {
			['r'] = 0.8862745098039215,
			['colorStr'] = 'ffe23bdf',
			['g'] = 0.2313725490196079,
			['b'] = 0.8745098039215686,
		},
		['ROGUE'] = {
			['r'] = 0.9411764705882353,
			['colorStr'] = 'fff0de79',
			['g'] = 0.8705882352941177,
			['b'] = 0.4784313725490196,
		},
		['DRUID'] = {
			['r'] = 0.9529411764705882,
			['colorStr'] = 'fff38e3f',
			['g'] = 0.5568627450980392,
			['b'] = 0.2470588235294118,
		},
		['MONK'] = {
			['r'] = 0.2392156862745098,
			['colorStr'] = 'ff3cd9a6',
			['g'] = 0.8509803921568627,
			['b'] = 0.6509803921568628,
		},
		['DEATHKNIGHT'] = {
			['r'] = 0.7686274509803921,
			['colorStr'] = 'ffc31d36',
			['g'] = 0.1137254901960784,
			['b'] = 0.2117647058823529,
		},
	},

	['class_power_colors'] = {
		['soul_shards'] = {
			['b'] = 0.8,
			['colorStr'] = 'ffde3ecc',
			['g'] = 0.2431372549019608,
			['r'] = 0.8705882352941177,
		},
		['chi_orbs'] = {
			['b'] = 0.7647058823529411,
			['colorStr'] = 'ff7fe3c3',
			['g'] = 0.8941176470588235,
			['r'] = 0.4980392156862745,
		},
		['arcane_charges'] = {
			['b'] = 0.9058823529411765,
			['colorStr'] = 'ff4e86e7',
			['g'] = 0.5254901960784314,
			['r'] = 0.3058823529411765,
		},
		['holy_power'] = {
			['b'] = 0.5333333333333333,
			['colorStr'] = 'fff2d388',
			['g'] = 0.8313725490196078,
			['r'] = 0.9490196078431372,
		},
		['combo_points'] = {
			['b'] = 0.2235294117647059,
			['colorStr'] = 'ffee4838',
			['g'] = 0.2823529411764706,
			['r'] = 0.9333333333333333,
		},
	},

}

local textureList = {
	[1] = 'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex',
	[2] = 'Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex',
	[3] = 'Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex',
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

	if not FreeDB['BfA'] then
		FreeDB = {}
		FreeDB['BfA'] = true
	end

	initSettings(C.CharacterSettings, FreeDB, true)
	initSettings(C.AccountSettings, FreeADB)

	F:SetupUIScale(true)

	C.Assets.norm_tex = textureList[FreeDB.unitframe.texture_style]

	C.r = FreeADB.class_colors[C.MyClass].r
	C.g = FreeADB.class_colors[C.MyClass].g
	C.b = FreeADB.class_colors[C.MyClass].b

	C.MyColor = format('|cff%02x%02x%02x', C.r*255, C.g*255, C.b*255)
	C.Title = '|cffe6e6e6Free|r'..C.MyColor..'UI|r'

	self:UnregisterAllEvents()
end)
