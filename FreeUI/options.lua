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
	['sparkTex']   = 'Interface\\CastingBar\\UI-CastingBar-Spark',
	['flashTex']   = "Interface\\Cooldown\\star4",
	['gearTex']    = "Interface\\WorldMap\\Gear_64",
	['creditTex']  = "Interface\\HelpFrame\\HelpIcon-KnowledgeBase",
	['pixel']      = 'Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf',
}

if GetLocale() == 'zhCN' then
	C.font = {
		['normal'] 		= 'Fonts\\ARKai_T.ttf',
		['damage'] 		= 'Fonts\\ARKai_C.ttf',
		['header']		= 'Fonts\\ARKai_T.ttf',
		['chat']		= 'Fonts\\ARKai_T.ttf',
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

C['general'] = {
	['uiScale'] = 1,
	['uiScaleAuto'] = true,
	['hideBossBanner'] = true,
	['hideTalkingHead'] = true,
	['flashCursor'] = true,
	['mailButton'] = true, 				
	['alreadyKnown'] = true,
	['missingStats'] = true,
	['fasterLoot'] = true,
	['PVPSound'] = true,
	
	['clickCast'] = true,
		['clickCast_filter'] = true,
	['cooldownCount'] = true,
		['cooldownCount_decimal'] = true,
		['cooldownCount_font'] = {'Interface\\AddOns\\FreeUI\\assets\\font\\supereffective.ttf', 16, 'OUTLINEMONOCHROME'},
	['cooldownPulse'] = true,
		['cooldownPulse_ignoredSpells'] = {
			--GetSpellInfo(6807),	-- Maul
			--GetSpellInfo(35395),	-- Crusader Strike
		},

	['alert'] = true,
		['alert_Position'] = {'CENTER', UIParent, 'CENTER', 0, 200},
	['raidManager'] = true,
		['raidManager_Position'] = {'LEFT'},

	['cameraIncrement'] = 5,
	
	['isDeveloper'] = false,
}




C['appearance'] = {
	['enable'] = true,
		['backdropColour'] = {.05, .05, .05, .75},
		['addShadowBorder'] = true,
		['buttonGradientColour'] = {.15, .15, .15, .5},
		['buttonSolidColour'] = {.05, .05, .05, .5},
		['useButtonGradientColour'] = true,

		["colourScheme"] = 1,
			["customColour"] = {r = 1, g = 1, b = 1},

	['vignette'] = true,
		['vignetteAlpha'] = .35,

	['fontStyle'] = true,


}


C['actionbars'] = {
	['enable'] = true,
		['buttonSizeSmall'] = 24,
		['buttonSizeNormal'] = 30,
		['buttonSizeBig'] = 34,
		['buttonSizeHuge'] = 40,
		['padding'] = 2,
		['margin'] = 4,

		['hotKey'] = true,
		['macroName'] = true,
		['count'] = false,
		['classColor'] = false,

		['bar3Fade'] = false,

		['sideBarEnable'] = true,
			['sideBarFade'] = false,

		['petBarFade'] = false,
		['stanceBarEnable'] = true,

		['extraButtonPos'] = {'CENTER', UIParent, 'CENTER', 0, 200},
		['zoneAbilityPos'] = {'CENTER', UIParent, 'CENTER', 0, 300},

		['hoverBind'] = true,

		['layoutSimple'] = false,

		
}


C['auras'] = {
	['enable'] = true,
		['position'] = {'TOPRIGHT', UIParent, 'TOPRIGHT', -290, -36},
		['buffSize'] = 42,
		['debuffSize'] = 50,
		['paddingX'] = 5,
		['paddingY'] = 8,
		['buffPerRow'] = 10,
		['auraSource'] = true,
}


C['maps'] = {
	['worldMapScale'] = 1,
	['miniMapScale'] = 1,
	['miniMapPosition'] = { 'TOPRIGHT', UIParent, 'TOPRIGHT', -22, 0 },
	['miniMapSize'] = 256,
	['whoPings'] = true,
	['mapReveal'] = true,
}





C['reminder'] = {
	['enable'] = true,
		['interrupt'] = true,
			['interruptSoundAlert'] = true,
		['dispel'] = true,
			['dispelSoundAlert'] = true,
		['rare'] = true,
			['rareSoundAlert'] = true,
		['spell'] = true,
		['resurrect'] = true,
		['sapped'] = true,
}


C['automation'] = {
	['autoSetRole'] = true,
		['autoSetRole_useSpec'] = true,
		['autoSetRole_verbose'] = true,
	['autoSellJunk'] = true,
	['autoRepair'] = true,
	['autoScreenShot'] = true,
	['autoActionCam'] = true,
	['autoQuest'] = true,
	['autoBuyStack'] = true,
	['autoTabBinder'] = true,
	['autoAcceptInvite'] = true,
	['autoInvite'] = true,
		['autoInvite_keyword'] = 'invite',
}


C['bags'] = {
	['enable'] = true,
		['bagScale'] = 1,
		['itemSlotSize'] = 36,
		['bagColumns'] = 10,
		['bankColumns'] = 10,
		['reverseSort'] = true,
		['itemLevel'] = true,
		['useCategory'] = true,
			['gearSetFilter'] = false,
			['tradeGoodsFilter'] = true,
			['questItemFilter'] = true,
}


C['infobar'] = {
	['enable'] = true,
		['height'] = 20,
		['mouseover'] = true,
		['stats'] = true,
		['microMenu'] = true,
		['skadaTool'] = true,
		['specTalent'] = true,
		['friends'] = true,
		['currencies'] = true,
		['report'] = true,
}


C['tooltip'] = {
	['enable'] = true,
		['cursor'] = false,
		['position'] = {'BOTTOMRIGHT', -50, 50},
		['hidePVP'] = true,
		['hideFaction'] = true,
		['hideTitle'] = true,
		['hideRealm'] = true,
		['hideRank'] = true,
		['combatHide'] = false,
		['ilvlSpec'] = true,
		['extraInfo'] = true,
		['azeriteTrait'] = true,
		['linkHover'] = true,
		['borderColor'] = true,
		['tipIcon'] = true,
		['tipClear'] = true,
}


C['chat'] = {
	['enable'] = true,
		['position'] = {'BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 50, 50},
		['lockPosition'] = true,
		['itemLinkLevel'] = true,
		['spamageMeters'] = true,
		['whisperSound'] = true,
		['minimizeButton'] = true,
		['useOutline'] = false,
		['timeStamp'] = true,
		['voiceButtons'] = false,
		['channelSticky'] = true,
		['lineFading'] = true,
			['timeVisible'] = 20,
			['fadeDuration'] = 6,

		['useFilter'] = true,
			['keyWordMatch'] = 1,
			['symbols'] = {'`', '～', '＠', '＃', '^', '＊', '！', '？', '。', '|', ' ', '—', '——', '￥', '’', '‘', '“', '”', '【', '】', '『', '』', '《', '》', '〈', '〉', '（', '）', '〔', '〕', '、', '，', '：', ',', '_', '/', '~', '-'},
			['filterList'] = '',
			['blockAddonAlert'] = true,
				['addonBlockList'] = {
					'任务进度提示%s?[:：]', '%[接受任务%]', '%(任务完成%)', '<大脚组队提示>', '<大脚团队提示>', '【爱不易】', 'EUI:', 'EUI_RaidCD', '打断:.+|Hspell', 'PS 死亡: .+>', '%*%*.+%*%*',
					'<iLvl>', ('%-'):rep(30), '<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', 'blizzard.+验证码', '=>'
					},
}


C["notifications"] = {
	["enable"] = true,

		["playSounds"] = true,
		["animations"] = true,
		["timeShown"] = 5,

		["checkBagsFull"] = true,
		["checkEvents"] = true,
		["checkGuildEvents"] = true,
		["checkMail"] = true,
}


C['unitframes'] = {
	['enable'] = true,

		['transMode'] = true,
			['transModeAlpha'] = .1,
			['healthClassColor'] = true,
			['powerTypeColor'] = true,

		['gradient'] = true,

		['portrait'] = true,
			['portraitAlpha'] = .1,

		['spellRange'] = true,
			['spellRangeAlpha'] = .4,

		['classPower'] = true,
			['classPower_height'] = 2,

		['threat'] = true,
		['prediction'] = true, 
		['dispellable'] = true,
		
		['castbar'] = true,
			['cbSeparate'] = false,
			['cbCastingColor'] = {77/255, 183/255, 219/255},
			['cbChannelingColor'] = {77/255, 183/255, 219/255},
			['cbnotInterruptibleColor'] = {160/255, 159/255, 161/255},
			['cbCompleteColor'] = {63/255, 161/255, 124/255},
			['cbFailColor'] = {187/255, 99/255, 110/255},
			['cbHeight'] = 14,
			['cbName'] = false,
			['cbTimer'] = false,

		['enableGroup'] = true,
			['limitRaidSize'] = {1, 2, 3, 4},
			['partyNameAlways'] = false,
			['partyMissingHealth'] = false,
		['enableBoss'] = true,
		['enableArena'] = true,

		['debuffbyPlayer'] = true,

		['focuser'] = true,

		['player_pos'] = {'CENTER', UIParent, 'CENTER', 0, -380},
		['player_pos_healer'] = {'RIGHT', UIParent, 'CENTER', -100, -200},
		['player_width'] = 220,
		['player_height'] = 16,
		['player_frameVisibility'] = '[combat][mod:shift][@target,exists][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide',
		['enableFrameVisibility'] = false,

		['pet_pos'] = {'RIGHT', 'oUF_FreePlayer', 'LEFT', -5, 0},
		['pet_width'] = 68,
		['pet_height'] = 16,
		['pet_frameVisibility'] = '[nocombat,nomod,@target,noexists][@pet,noexists] hide; show',

		['target_pos'] = {'LEFT', 'oUF_FreePlayer', 'RIGHT', 100, 60},
		['target_pos_healer'] = {'LEFT', UIParent, 'CENTER', 100, -200},
		['target_width'] = 220,
		['target_height'] = 16,

		['targettarget_pos'] = {'LEFT', 'oUF_FreeTarget', 'RIGHT', 6, 0},
		['targettarget_width'] = 80,
		['targettarget_height'] = 16,

		['focus_pos'] = {'LEFT', 'oUF_FreePlayer', 'RIGHT', 100, -60},
		['focus_pos_healer'] = {'LEFT', 'oUF_FreeTarget', 'RIGHT', 6, -100},
		['focus_width'] = 106,
		['focus_height'] = 16,

		['focustarget_pos'] = {'LEFT', 'oUF_FreeFocus', 'RIGHT', 6, 0},
		['focustarget_width'] = 106,
		['focustarget_height'] = 16,

		['party_pos'] = {'BOTTOMRIGHT', 'oUF_FreePlayer', 'BOTTOMLEFT', -100, 60},
		['party_pos_healer'] = {'TOP', UIParent, 'CENTER', 0, -300},
		['party_width'] = 90,
		['party_height'] = 38,
		['party_width_healer'] = 58,
		['party_height_healer'] = 32,
		['party_xoffset'] = 0,
		['party_yoffset'] = 6,
		['party_xoffset_healer'] = 4,
		['party_yoffset_healer'] = 0,
		['party_point'] = 'BOTTOM',
		['party_point_healer'] = 'LEFT',
		['party_columnAnchorPoint'] = 'LEFT',
		['party_columnAnchorPoint_healer'] = 'RIGHT',

		['raid_pos'] = {'TOPRIGHT', 'oUF_FreePlayer', 'TOPLEFT', -100, 140},
		['raid_pos_healer'] = {'TOP', UIParent, 'CENTER', 0, -300},
		['raid_width'] = 58,
		['raid_height'] = 32,
		['raid_xoffset'] = -4,
		['raid_yoffset'] = 6,
		['raid_xoffset_healer'] = 4,
		['raid_yoffset_healer'] = 6,
		['raid_point'] = 'RIGHT',
		['raid_point_healer'] = 'LEFT',
		['raid_groupFilter'] = '1,2,3,4,5,6,7,8',

		['boss_pos'] = {'LEFT', 'oUF_FreeTarget', 'RIGHT', 120, 160},
		['boss_width'] = 166,
		['boss_height'] = 20,

		['arena_pos'] = {'RIGHT', 'oUF_FreePlayer', 'LEFT', -400, 249},
		['arena_width'] = 166,
		['arena_height'] = 16,
		
		['power_height'] = 2,
		['altpower_height'] = 2,
}


C['classmod'] = {
	['havocFury'] = true,
}