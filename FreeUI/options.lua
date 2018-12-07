local F, C, L = unpack(select(2, ...))

-- All exceptions and special rules for these options are in profiles.lua!

-- [[ Constants ]]

C.media = {
	['arrowUp']    = 'Interface\\AddOns\\FreeUI\\assets\\arrow-up-active',
	['arrowDown']  = 'Interface\\AddOns\\FreeUI\\assets\\arrow-down-active',
	['arrowLeft']  = 'Interface\\AddOns\\FreeUI\\assets\\arrow-left-active',
	['arrowRight'] = 'Interface\\AddOns\\FreeUI\\assets\\arrow-right-active',
	['backdrop']   = 'Interface\\AddOns\\FreeUI\\assets\\blank',
	['checked']    = 'Interface\\AddOns\\FreeUI\\assets\\CheckButtonHilight',
	['glowTex']    = 'Interface\\AddOns\\FreeUI\\assets\\glowTex',
	['gradient']   = 'Interface\\AddOns\\FreeUI\\assets\\gradient',
	['roleIcons']  = 'Interface\\Addons\\FreeUI\\assets\\UI-LFG-ICON-ROLES',
	['sbTex']      = 'Interface\\AddOns\\FreeUI\\assets\\statusbar',
	['bgTex']	   = 'Interface\\AddOns\\FreeUI\\assets\\bgTex',
	['sparkTex']   = 'Interface\\AddOns\\FreeUI\\assets\\spark',
	['pixel']      = 'Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf',
}

if GetLocale() == 'zhCN' then
	C.font = {
		['normal'] 		= 'Fonts\\ARKai_T.ttf',
		['damage'] 		= 'Fonts\\ARKai_C.ttf',
		['header']		= 'Fonts\\ARKai_T.ttf',
		['chat']		= 'Fonts\\ARKai_T.ttf',
		['pixel']		= {'Fonts\\pixfontCN.ttf', 10, 'OUTLINEMONOCHROME'}, -- pixel font for Chinese client, personal use
	}
elseif GetLocale() == 'zhTW' then
	C.font = {
		['normal'] 		= 'Fonts\\blei00d.ttf',
		['damage'] 		= 'Fonts\\bKAI00M.ttf',
		['header']		= 'Fonts\\blei00d.ttf',
		['chat']		= 'Fonts\\blei00d.ttf',
	}
elseif GetLocale() == 'koKR' then
	C.font = {
		['normal'] 		= 'Fonts\\2002.ttf',
		['damage'] 		= 'Fonts\\K_Damage.ttf',
		['header']		= 'Fonts\\2002.ttf',
		['chat']		= 'Fonts\\2002.ttf',
	}
elseif GetLocale() == 'ruRU' then
	C.font = {
		['normal'] 		= 'Fonts\\FRIZQT___CYR.ttf',
		['damage'] 		= 'Fonts\\FRIZQT___CYR.ttf',
		['header']		= 'Fonts\\FRIZQT___CYR.ttf',
		['chat']		= 'Fonts\\FRIZQT___CYR.ttf',
	}
else
	C.font = {
		['normal'] 		= 'Interface\\AddOns\\FreeUI\\assets\\font\\expresswaysb.ttf',
		['damage'] 		= 'Interface\\AddOns\\FreeUI\\assets\\font\\PEPSI_pl.ttf',
		['header']		= 'Interface\\AddOns\\FreeUI\\assets\\font\\ExocetBlizzardMedium.ttf',
		['chat']		= 'Interface\\AddOns\\FreeUI\\assets\\font\\expresswaysb.ttf',
	}
end



-- [[ Global config ]]

C['appearance'] = {
	['backdropcolor'] = {.05, .05, .05},
	['alpha'] = .4,
	['shadow'] = true,
	['buttonGradientColour'] = {.3, .3, .3, .3},
	['buttonSolidColour'] = {.2, .2, .2, .6},
	['useButtonGradientColour'] = true,

	['useCustomColour'] = false,
		['customColour'] = {r = 1, g = 1, b = 1},

	['vignette'] = true,
		['vignetteAlpha'] = .35,

	['fontStyle'] = true,

	['usePixelFont'] = false, -- Chinese pixel font for personal use
}

C['actionbars'] = {
	['buttonSizeNormal'] = 30,
	['buttonSizeSmall'] = 24,
	['buttonSizeBig'] = 34,
	['buttonSizeHuge'] = 40,
	['padding'] = 2,
	['margin'] = 4,

	['bar3Fade'] = false,

	['sideBarEnable'] = true,
		['sideBarFade'] = false,

	['petBarFade'] = false,
	['stanceBarEnable'] = true,

	['extraButtonPos'] = {'CENTER', UIParent, 'CENTER', 0, 200},
	['zoneAbilityPos'] = {'CENTER', UIParent, 'CENTER', 0, 300},

	['hotKey'] = true, 					-- show hot keys on buttons
	['macroName'] = true,				-- show macro name on buttons
	['count'] = false,					-- show itme count on buttons		
	['classColor'] = false,				-- button border colored by class color

	['layoutSimple'] = false,			-- only show bar1/bar2 when shift key is down
}


C['auras'] = {
	['position'] = {'TOPRIGHT', UIParent, 'TOPRIGHT', -290, -36},
	['buffSize'] = 42,
	['debuffSize'] = 50,
	['paddingX'] = 5,
	['paddingY'] = 8,
	['buffPerRow'] = 10,
}


C['maps'] = {
	['worldMapScale'] = 1,
	['miniMapScale'] = 1,
	['miniMapPosition'] = { 'TOPRIGHT', UIParent, 'TOPRIGHT', -22, 0 },
	['miniMapSize'] = 256,
	['whoPings'] = true,
	['mapReveal'] = true,
}


C['blizzard'] = {
	['hideBossBanner'] = true,
	['hideTalkingHead'] = true,
	['cooldownCount'] = true,
		['decimalCD'] = false,
		['CDFont'] = {'Interface\\AddOns\\FreeUI\\assets\\font\\supereffective.ttf', 16, 'OUTLINEMONOCHROME'},
	['alertPos'] = {'CENTER', UIParent, 'CENTER', 0, 200},
}


C['misc'] = {
	['uiScale'] = 1,
	['uiScaleAuto'] = true,
	['flashCursor'] = true,
	['mailButton'] = true, 
	['undressButton'] = true, 
	['autoScreenShot'] = true,			-- auto screenshot when achieved
	['autoActionCam'] = true,
	['autoSetRole'] = true,				-- automatically set role and hide dialog where possible
		['autoSetRole_useSpec'] = true,		-- attempt to set role based on your current spec
		['autoSetRole_verbose'] = true, 	-- tells you what happens when setting role
	['autoRepair'] = true,				-- automatically repair items
	['autoSellJunk'] = true,
	['autoSetRole'] = true,
	['cooldownpulse'] = true,
	['missingStats'] = true,
	['PVPSound'] = true,
	['clickCast'] = true,
	['fasterLoot'] = true,
	['alreadyKnown'] = true,
	['cameraIncrement'] = 5,
	['cameraDistance'] = 50,
	['objectiveTracker_height'] = 800,
	['objectiveTracker_width'] = 250,
}


C['reminder'] = {
	['enable'] = true,				-- enable reminder module
		['interrupt'] = true,			-- interrupt alert
		['dispel'] = true,				-- dispel alert
		['rare'] = true,				-- rare mob/event alert
		['spell'] = true,				-- special spell alert
		['resurrect'] = true,			-- resurrect alert
		['sapped'] = true,				-- sapped alert
}


C['bags'] = {
	['enable'] = true,
		['bagScale'] = 1,
		['itemSlotSize'] = 36,
		['bagColumns'] = 12,
		['bankColumns'] = 12,
		['reverseSort'] = true,
		['itemLevel'] = true,
		['itemFilter'] = true,
			['itemSetFilter'] = false,
			['tradeGoodsFilter'] = true,
			['questItemFilter'] = true,
}

C['infoBar'] = {
	['enable'] = true,
		['height'] = 20,
		['enableButtons'] = true,			-- show buttons for quick access on the menu bar
			['buttons_mouseover'] = true,			-- only on mouseover

		['maxAddOns'] = 10,
}


C['tooltip'] = {
	['enable'] = true,		-- enable tooltip and modules
		['anchorCursor'] = false,		-- tooltip at mouse
		['tipPosition'] = {'BOTTOMRIGHT', -30, 30},	-- tooltip position
		
		['hidePVP'] = false,
		['hideFaction'] = true,
		['hideTitle'] = true,
		['hideRealm'] = true,
		['hideGuildRank'] = true,

		['fadeOnUnit'] = false,
		['combatHide'] = false,

		['ilvlspec'] = true,
		['extraInfo'] = true,
		['azeriteTrait'] = true,
		['borderColor'] = true,		-- item tooltip border colored by item quality

		['clearTip'] = true,
}


C['chat'] = {
	['position'] = {'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 50, 50},  -- default position for chat frame
	['lockPosition'] = true,	-- lock chat frame on default position
	['itemLinkLevel'] = true,	-- expand item links in chat frame
	['spamageMeters'] = true,	-- suppresses messages from damage meters like Skada
	['whisperSound'] = true,	-- play a sound when you received a whisper or BN whisper message
	['minimizeButton'] = true,	-- a clickable button for hide entire chat frame
	['fontOutline'] = false,	-- add outline for chat frame texts
	['timeStamp'] = true,		-- add customized time stamp for chat frame messages
	['voiceButtons'] = false,	-- show voice buttons
	['channelSticky'] = true,	-- chat sticky
	['lineFading'] = true,		-- fading texts from chat frame
		['timeVisible'] = 20,
		['fadeDuration'] = 6,

	['enableFilter'] = true,	-- simple chat filter for keywords, repeat lines, addon alerts
		['keyWordMatch'] = 1,
		['symbols'] = {'`', '～', '＠', '＃', '^', '＊', '！', '？', '。', '|', ' ', '—', '——', '￥', '’', '‘', '“', '”', '【', '】', '『', '』', '《', '》', '〈', '〉', '（', '）', '〔', '〕', '、', '，', '：', ',', '_', '/', '~', '-'},
		['filterList'] = '',	-- blacklist keywords, use profiles.lua to create your own list
		['blockAddonAlert'] = true,
			['addonBlockList'] = {	-- filter annoying alerts from idiot addons
				'任务进度提示%s?[:：]', '%[接受任务%]', '%(任务完成%)', '<大脚组队提示>', '<大脚团队提示>', '【爱不易】', 'EUI:', 'EUI_RaidCD', '打断:.+|Hspell', 'PS 死亡: .+>', '%*%*.+%*%*',
				'<iLvl>', ('%-'):rep(30), '<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', 'blizzard.+验证码', '助我轻松提高DPS', '=>'
				},
}


C['unitframes'] = {
	['enable'] = true, 						-- enable the unit frames and their included modules

		['transMode'] = true,
			['transModeAlpha'] = .1,
			['healthClassColor'] = true,
			['powerTypeColor'] = true,

		['gradient'] = true,					-- gradient mode

		['portrait'] = true,					-- enable portrait on player/target frame
			['portraitAlpha'] = .1,

		['spellRange'] = true,					-- spell range support for target/focus/boss
			['spellRangeAlpha'] = .4,

		['classPower'] = true,					-- player's class resources (like Chi Orbs or Holy Power) and combo points
			['classPower_height'] = 2,

		['classMod_havoc'] = true,	 			-- set power bar to red if power below 40(chaos strike)

		['threat'] = true,						-- threat indicator for party/raid frames
		['prediction'] = true, 					-- health prediction
		['dispellable'] = true,					-- Highlights debuffs that are dispelable by the player
		
		['castbar'] = true,						-- enable cast bar
			['cbSeparate'] = false,				-- true for a separate player cast bar
			['cbCastingColor'] = {77/255, 183/255, 219/255},
			['cbChannelingColor'] = {77/255, 183/255, 219/255},
			['cbnotInterruptibleColor'] = {160/255, 159/255, 161/255},
			['cbCompleteColor'] = {63/255, 161/255, 124/255},
			['cbFailColor'] = {187/255, 99/255, 110/255},
			['cbHeight'] = 14,
			['cbName'] = false,
			['cbTimer'] = false,

		['enableGroup'] = true,					-- enable party/raid frames
			['showRaidFrames'] = true, 				-- show the raid frames
			['limitRaidSize'] = false, 				-- show a maximum of 25 players in a raid
			['partyNameAlways'] = false,			-- show name on party/raid frames
			['partyMissingHealth'] = false,			-- show missing health on party/raid frames
		['enableBoss'] = true,					-- enable boss frames
		['enableArena'] = true,					-- enable arena/flag carrier frames

		['debuffbyPlayer'] = true,				-- only show target debuffs casted by player

		['focuser'] = true,						-- shift + left click on unitframes/models/nameplates to set focus

		['player_pos'] = {'CENTER', UIParent, 'CENTER', 0, -380},						-- player unitframe position
		['player_pos_healer'] = {'CENTER', UIParent, 'CENTER', 0, -380},				-- player unitframe position for healer layout(WIP)
		['player_width'] = 200,
		['player_height'] = 14,

		['pet_pos'] = {'RIGHT', 'oUF_FreePlayer', 'LEFT', -5, 0},						-- pet unitframe position
		['pet_width'] = 68,
		['pet_height'] = 14,

		['useFrameVisibility'] = false,													-- hide palyer/pet unitframes for defualt

		['target_pos'] = {'LEFT', 'oUF_FreePlayer', 'RIGHT', 100, 60},					-- target unitframe position
		['target_width'] = 220,
		['target_height'] = 16,

		['targettarget_pos'] = {'LEFT', 'oUF_FreeTarget', 'RIGHT', 6, 0},					-- target target unitframe position
		['targettarget_width'] = 80,
		['targettarget_height'] = 16,

		['focus_pos'] = {'LEFT', 'oUF_FreePlayer', 'RIGHT', 100, -60},					-- focus unitframe position
		['focus_width'] = 106,
		['focus_height'] = 16,

		['focustarget_pos'] = {'LEFT', 'oUF_FreeFocus', 'RIGHT', 6, 0},					-- focus target unitframe position
		['focustarget_width'] = 106,
		['focustarget_height'] = 16,

		['party_pos'] = {'BOTTOMRIGHT', 'oUF_FreePlayer', 'BOTTOMLEFT', -100, 60},		-- party unitframe position
		['party_width'] = 90,
		['party_height'] = 38,

		['raid_pos'] = {'TOPRIGHT', 'oUF_FreePlayer', 'TOPLEFT', -100, 140},			-- raid unitframe position
		['raid_width'] = 58,
		['raid_height'] = 32,

		['boss_pos'] = {'LEFT', 'oUF_FreeTarget', 'RIGHT', 120, 160},					-- boss unitframe position
		['boss_width'] = 166,
		['boss_height'] = 20,

		['arena_pos'] = {'RIGHT', 'oUF_FreePlayer', 'LEFT', -400, 249},					-- arena unitframe position
		['arena_width'] = 166,
		['arena_height'] = 16,
		
		['power_height'] = 2,
		['altpower_height'] = 2,
}



