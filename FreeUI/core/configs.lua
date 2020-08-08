local F, C = unpack(select(2, ...))


local myClass = select(2, UnitClass('player'))




C['General'] = {

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
}

--[[ C['Theme'] = {
	['cursor_trail'] = true,
	['vignetting'] = true,
		['vignetting_alpha'] = .8,
	['backdrop_color'] = {.05, .05, .05},
	['backdrop_alpha'] = .6,
	['backdrop_border_color'] = {0, 0, 0},
	['backdrop_border_alpha'] = 1,
	['flat_style'] = false,
		['flat_color'] = {.06, .06, .06},
		['flat_alpha'] = .65,
	['gradient_color_primary'] = {.02, .02, .02},
	['gradient_color_primary_alpha'] = .5,
	['gradient_color_secondary'] = {.08, .08, .08},
	['gradient_color_secondary_alpha'] = .5,
	['reskin_blizz'] = true,
	['shadow_border'] = true,

	['reskin_dbm'] = true,
	['reskin_weakauras'] = true,
	['reskin_pgf'] = true,
	['reskin_skada'] = true,
} ]]

C['Notification'] = {
	['enable'] = true,
		['bag_full'] = true,
		['new_mail'] = true,
		['version_check'] = true,
		['rare_alert'] = true,
}

C['Automation'] = {
	['enable'] = true,




		['buy_stack'] = true,
		['screenshot'] = true,


		['auto_accept_invite'] = false,
		['auto_invite_whisper'] = false,
		['invite_keyword'] = 'inv'

}

C['Announcement'] = {
	['enable'] = true,
		['my_interrupt'] = true,
		['my_dispel'] = true,
		['get_sapped'] = true,
		['combat_rez'] = true,
		['feast_cauldron'] = true,
		['bot_codex'] = true,
		['mage_portal'] = true,
		['ritual_of_summoning'] = true,
		['create_soulwell'] = true,
		['mail_service'] = true,
		['conjure_refreshment'] = true,
		['special_toy'] = true,
}

C['Infobar'] = {
	['enable'] = true,
		['fontSize'] = 11,
		['top'] = true,
		['height'] = 14,
		['mouseover'] = true,
		['stats'] = true,
		['spec'] = true,
		['durability'] = true,
		['guild'] = true,
		['friends'] = true,
		['report'] = true,
}

C['Chat'] = {
	['enable'] = true,
		['lock_position'] = true,
			['chat_size_width'] = 300,
			['chat_size_height'] = 100,
		['font_outline'] = false,

		['fading'] = true,
			['fadingVisible'] = 60,
			['fadingDuration'] = 6,

		['abbreviate'] = true,
		['itemLinks'] = true,
		['spamageMeter'] = true,
		['chatCopy'] = true,
		['urlCopy'] = true,
		['voiceIcon'] = true,
		['sticky'] = true,
		['cycles'] = true,
		['profanity'] = false,

		['auto_toggle_chat_bubble'] = false,

		['allowFriendsSpam'] = false,
		['blockStranger'] = false,
		['matches'] = 1,

		['whisperColor'] = true,
		['whisperTarget'] = true,
		['whisperAlert'] = true,
			['lastAlertTimer'] = 30,

		['filters'] = true,
		['keywordsList'] = '%*',
		['blockAddonSpam'] = true,
		['addonBlockList'] = {
			'任务进度提示', '%[接受任务%]', '%(任务完成%)', '<大脚', '【爱不易】', 'EUI[:_]', '打断:.+|Hspell', 'PS 死亡: .+>', '%*%*.+%*%*', '<iLvl>', string.rep('%-', 20),
			'<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', '汐寒', 'wow.+兑换码', 'wow.+验证码', '【有爱插件】', '：.+>', '|Hspell.+=>'
		},
		['trashClubs'] = {'站桩', '致敬我们', '我们一起玩游戏', '部落大杂烩'}
}

--[[ C['Aura'] = {
	['enable_aura'] = true,
		['margin'] = 6,
		['offset'] = 12,
		['buffSize'] = 40,
		['buffsPerRow'] = 12,
		['reverseBuffs'] = true,
		['debuffSize'] = 50,
		['debuffsPerRow'] = 12,
		['reverseDebuffs'] = true,
		['reminder'] = true,
} ]]

C['Actionbar'] = {
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
			['bar1_visibility'] = '[petbattle] hide; show',
			['bar1_fade'] = false,
		['bar2'] = true,
			['bar2_fade'] = false,
		['bar3'] = true,
			['bar3_divide'] = true,
			['bar3_fade'] = false,
		['bar4'] = false,
			['bar4_fade'] = false,
		['bar5'] = false,
			['bar5_fade'] = false,
		['pet_bar'] = false,
			['pet_bar_fade'] = false,
		['enable_stance_bar'] = false,
			['stance_bar_fade'] = false,

		['enable_cooldown'] = true,
			['use_decimal'] = false,
				['decimal_countdown'] = 3,
			['ignore_weakauras'] = false,
			['cd_pulse'] = true,
				['ignored_spells'] = {
					--GetSpellInfo(6807),	-- Maul
					--GetSpellInfo(35395),	-- Crusader Strike
				},
}

C['Combat'] = {
	['enable'] = true,
		['fct_incoming'] = true,
		['fct_outgoing'] = true,
		['fct_pet'] = true,
		['fct_merge'] = true,
		['fct_periodic'] = true,

		['combat_alert'] = true,
		['health_alert'] = true,
			['health_alert_threshold'] = 0.3,
		['spell_alert'] = true,

		['pvp_sound'] = true,
		['auto_tab'] = true,
}

C['Inventory'] = {
	['enable_module'] = true,
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
}

C['Map'] = {
	['enable'] = true,
		['coords'] = true,
		['minimapScale'] = 1,
		['whoPings'] = true,
		['worldMarker'] = true,
		['microMenu'] = true,
		['expBar'] = true,
}

C['Quest'] = {
	['enable'] = true,
		['questLevel'] = true,
		['rewardHightlight'] = true,
		['extraQuestButton'] = true,
		['completeRing'] = true,
		['questNotifier'] = false,
}

C['Tooltip'] = {
	['enable'] = true,
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
		['pvp_rating'] = true,

		['tip_backdrop_alpha'] = .6,
		['header_font_size'] = 16,
		['normal_font_size'] = 14,

		['extra_info'] = true,
			['various_id'] = true,
			['item_count'] = true,
			['item_price'] = true,
			['aura_source'] = true,
			['mount_source'] = true,
}

C['Unitframe'] = {
	['enable_module'] = true,
		['transparency'] = true,
		['texture'] = 'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex',
		['fader'] = false,
		['color_smooth'] = false,
		['portrait'] = true,
		['only_show_debuffs_by_player'] = true,
		['click_cast'] = true,
			['click_cast_filter'] = false,
		['threat'] = true,
		['range_check'] = true,
		['heal_prediction'] = true,
			['heal_prediction_over_absorb'] = true,
		['gcd_spark'] = true,
		['swing_spark'] = false,
		['debuff_highlight'] = true,
		['corner_buffs'] = true,
		['raid_debuffs'] = true,
			['raid_debuffs_click_through'] = false,

		['power_bar_height'] = 2,
		['alternative_power_height'] = 2,
		['class_power_bar'] = true,
			['class_power_bar_height'] = 2,
		['stagger_bar'] = true,
			['stagger_bar_height'] = 2,
		['totems_bar'] = true,
			['totems_bar_height'] = 2,
		['runes_bar'] = true,
			['runes_bar_height'] = 2,

		['enable_castbar'] = true,
			['castbar_focus_separate'] = false,
			['castbar_focus_width'] = 200,
			['castbar_focus_height'] = 16,
			['castbar_timer'] = true,

		['enable_player'] = true,
			['player_width'] = 140,
			['player_height'] = 14,
			['player_auras'] = false,
			['player_auras_number'] = 18,
			['player_auras_number_per_row'] = 6,
			['player_hide_tags'] = false,

		['enable_pet'] = true,
			['pet_width'] = 50,
			['pet_height'] = 14,
			['pet_auras'] = true,
			['pet_auras_number_per_row'] = 3,
			['pet_auras_number'] = 12,

		['enable_target'] = true,
			['target_width'] = 240,
			['target_height'] = 14,
			['target_auras'] = true,
			['target_auras_number_per_row'] = 7,
			['target_auras_number'] = 35,

			['target_target_width'] = 80,
			['target_target_height'] = 12,

		['enable_focus'] = true,
			['focus_width'] = 97,
			['focus_height'] = 14,
			['focus_auras'] = false,
			['focus_auras_number_per_row'] = 4,
			['focus_auras_number'] = 16,

			['focus_target_width'] = 97,
			['focus_target_height'] = 12,

		['enable_group'] = true,
			['group_names'] = false,
			['group_color_smooth'] = false,
			['groupFilter'] = 6,
			['groupShowSolo'] = false,
			['groupShowPlayer'] = true,
			['groupByRole'] = true,
			['groupReverse'] = false,

			['party_width'] = 90,
			['party_height'] = 38,
			['party_gap'] = 6,
			['partyShowAuras'] = true,

			['raid_width'] = 44,
			['raid_height'] = 32,
			['raid_gap'] = 5,
			['raidShowAuras'] = true,

		['enable_boss'] = true,
			['boss_color_smooth'] = true,
			['boss_width'] = 166,
			['boss_height'] = 20,
			['boss_gap'] = 60,
			['bossShowAuras'] = true,
			['bossAuraPerRow'] = 5,
			['bossAuraTotal'] = 15,

		['enable_arena'] = true,
			['arena_width'] = 166,
			['arena_height'] = 16,
			['arena_gap'] = 80,
			['arenaShowAuras'] = true,
			['arenaAuraPerRow'] = 6,
			['arenaAuraTotal'] = 18,
}


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
	ALL = {},

	PRIEST = {
		{194384, 'TOPRIGHT',    {1, 1, 0.66}},              -- Atonement
		{214206, 'TOPRIGHT',    {1, 1, 0.66}},              -- Atonement (PvP)
		{ 41635, 'BOTTOMRIGHT', {0.2, 0.7, 0.2}},           -- Prayer of Mending
		{193065, 'BOTTOMRIGHT', {0.54, 0.21, 0.78}},        -- Masochism
		{   139, 'BOTTOMLEFT',  {0.4, 0.7, 0.2}},           -- Renew
		{    17, 'TOPLEFT',     {0.7, 0.7, 0.7}, true},     -- Power Word: Shield
		{ 47788, 'LEFT',        {0.86, 0.45, 0}, true},     -- Guardian Spirit
		{ 33206, 'LEFT',        {0.47, 0.35, 0.74}, true},  -- Pain Suppression
	},

	DRUID = {
		{   774, 'TOPRIGHT',    {0.8, 0.4, 0.8}},   		-- Rejuvenation
		{155777, 'RIGHT',       {0.8, 0.4, 0.8}},   		-- Germination
		{  8936, 'BOTTOMLEFT',  {0.2, 0.8, 0.2}},		    -- Regrowth
		{ 33763, 'TOPLEFT',     {0.4, 0.8, 0.2}},  		    -- Lifebloom
		{ 48438, 'BOTTOMRIGHT', {0.8, 0.4, 0}},		        -- Wild Growth
		{207386, 'TOP',         {0.4, 0.2, 0.8}},     		-- Spring Blossoms
		{102351, 'LEFT',        {0.2, 0.8, 0.8}},    		-- Cenarion Ward (Initial Buff)
		{102352, 'LEFT',        {0.2, 0.8, 0.8}},    		-- Cenarion Ward (HoT)
		{200389, 'BOTTOM',      {1, 1, 0.4}},      		    -- Cultivation
	},

	PALADIN = {
		{ 53563, 'TOPRIGHT',    {0.7, 0.3, 0.7}},           -- Beacon of Light
		{156910, 'TOPRIGHT',    {0.7, 0.3, 0.7}},           -- Beacon of Faith
		{200025, 'TOPRIGHT',    {0.7, 0.3, 0.7}},           -- Beacon of Virtue
		{  1022, 'BOTTOMRIGHT', {0.2, 0.2, 1}, true},       -- Hand of Protection
		{  1044, 'BOTTOMRIGHT', {0.89, 0.45, 0}, true},     -- Hand of Freedom
		{  6940, 'BOTTOMRIGHT', {0.89, 0.1, 0.1}, true},    -- Hand of Sacrifice
		{223306, 'BOTTOMLEFT',  {0.7, 0.7, 0.3}},           -- Bestow Faith
	},

	SHAMAN = {
		{ 61295, 'TOPRIGHT',    {0.7, 0.3, 0.7}},   	    -- Riptide
		{   974, 'BOTTOMRIGHT', {0.2, 0.2, 1}}, 	        -- Earth Shield
		{207400, 'BOTTOMLEFT',  {0.6, 0.8, 1}}, 	        -- 先祖活力
	},

	MONK = {
		{119611, 'TOPLEFT',     {0.3, 0.8, 0.6}},           -- Renewing Mist
		{116849, 'TOPRIGHT',    {0.2, 0.8, 0.2}, true},     -- Life Cocoon
		{124682, 'BOTTOMLEFT',  {0.8, 0.8, 0.25}},          -- Enveloping Mist
		{191840, 'BOTTOMRIGHT', {0.27, 0.62, 0.7}},         -- Essence Font
	},

	ROGUE = {
		{ 57934, 'TOPRIGHT',    {0.89, 0.09, 0.05}},        -- Tricks of the Trade
	},

	WARRIOR = {
		{114030, 'TOPLEFT',    	{0.2, 0.2, 1}},     	    -- Vigilance
		{122506, 'TOPRIGHT',   	{0.89, 0.09, 0.05}}, 	    -- Intervene
	},

	WARLOCK = {
		{ 20707, 'BOTTOMRIGHT',	{0.8, 0.4, 0.8}},     	    -- Soul Stone
	},

	HUNTER = {
		{ 34477, 'BOTTOMRIGHT', {.9, .1, .1}},		        -- 误导
		{ 90361, 'TOPLEFT',     {.4, .8, .2}},			    -- 灵魂治愈
	},

	DEMONHUNTER = {},
	MAGE = {},
	DEATHKNIGHT = {},
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





C.CharacterSettings = {
	['BfA'] = false,
	['classic'] = false,
	['installation_complete'] = false,
	['ui_anchor'] = {},
	['ui_anchor_temp'] = {},
	['map_reveal'] = false,
	['quick_quest'] = false,
	['bind_type'] = 1,
	['favourite_items'] = {},
	['click_cast'] = {},


	['theme'] = {
		['cursor_trail'] = true,
		['vignetting'] = true,
			['vignetting_alpha'] = .8,
		['backdrop_color'] = {.05, .05, .05},
		['backdrop_alpha'] = .6,
		['backdrop_border_color'] = {0, 0, 0},
		['backdrop_border_alpha'] = 1,
		['flat_style'] = false,
			['flat_color'] = {.06, .06, .06},
			['flat_alpha'] = .65,
		['gradient_color_primary'] = {.02, .02, .02},
		['gradient_color_primary_alpha'] = .5,
		['gradient_color_secondary'] = {.08, .08, .08},
		['gradient_color_secondary_alpha'] = .5,
		['reskin_blizz'] = true,
		['shadow_border'] = true,

		['reskin_dbm'] = true,
		['reskin_weakauras'] = true,
		['reskin_pgf'] = true,
		['reskin_skada'] = true,
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
			['aura_source']	= true,
	},
}

C.AccountSettings = {
	['ui_scale'] = 1,
	['ui_gap'] = 33,
	['total_gold'] = {},
	['auto_sell_junk'] = false,
	['auto_repair'] = false,
	['custom_junk_list'] = {},
	['number_format'] = 1,
	['keystone_info'] = {},
}

local function initSettings(source, target, fullClean)
	for i, j in pairs(source) do
		if type(j) == "table" then
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
		if fullClean and type(j) == "table" then
			for k, v in pairs(j) do
				if type(v) ~= "table" and source[i] and source[i][k] == nil then
					target[i][k] = nil
				end
			end
		end
	end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, addon)
	if addon ~= 'FreeUI' then return end

	if not FreeUIConfigs['BfA'] then
		FreeUIConfigs = {}
		FreeUIConfigs['BfA'] = true
	end

	initSettings(C.CharacterSettings, FreeUIConfigs, true)
	initSettings(C.AccountSettings, FreeUIConfigsGlobal)

	F:SetupUIScale(true)

	self:UnregisterAllEvents()
end)
