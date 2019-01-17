local F, C, L = unpack(select(2, ...))

-- All exceptions and special rules for these options are in profiles.lua!

-- [[ Constants ]]

--[[C.media = {
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
	['flashTex']   = 'Interface\\Cooldown\\star4',
	['gearTex']    = 'Interface\\WorldMap\\Gear_64',
	['creditTex']  = 'Interface\\HelpFrame\\HelpIcon-KnowledgeBase',
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
end]]







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

	['progressBar'] = true,
	['quickMarking'] = true,
	['quickFocusing'] = true,

	
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
	['enableTheme'] = true,
		['backdropColour'] = {.05, .05, .05, .75},
		['addShadowBorder'] = true,
		['buttonGradientColour'] = {.15, .15, .15, .5},
		['buttonSolidColour'] = {.05, .05, .05, .5},
		['useButtonGradientColour'] = true,

		['colourScheme'] = 1,
			['customColour'] = {r = 1, g = 1, b = 1},

	['vignette'] = true,
		['vignetteAlpha'] = .35,

	['objectiveTracker'] = true,
	['petBattle'] = true,

	['fontStyle'] = true,

	['DBM'] = true,
	['BW'] = true,
	['WA'] = true,
	['PGF'] = true,
	['SKADA'] = true,


}


C['actionbar'] = {
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


C['aura'] = {
	['enable'] = true,
		['position'] = {'TOPRIGHT', Minimap, 'TOPLEFT', -10, -36},
		['buffSize'] = 42,
		['debuffSize'] = 50,
		['paddingX'] = 5,
		['paddingY'] = 8,
		['buffPerRow'] = 10,
		['auraSource'] = true,
}


C['map'] = {
	['worldMapScale'] = 1,
	['miniMapScale'] = 1,
	['miniMapPosition'] = {'TOPRIGHT', UIParent, 'TOPRIGHT', -22, 0},
	['miniMapSize'] = 256,
	['whoPings'] = true,
	['mapReveal'] = true,
}


C['notification'] = {
	['enableNotification'] = true,

		['playSounds'] = true,
		['animations'] = true,
		['timeShown'] = 5,

		['checkBagsFull'] = true,
		['checkMail'] = true,

	['interrupt'] = true,
		['interruptSound'] = true,
	['dispel'] = true,
		['dispelSound'] = true,
	['rare'] = true,
		['rareSound'] = true,
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


C['inventory'] = {
	['enable'] = true,
		['bagScale'] = 1,
		['itemSlotSize'] = 36,
		['bagColumns'] = 10,
		['bankColumns'] = 10,
		['reverseSort'] = true,
		['itemLevel'] = true,
		['newitemFlash'] = true,
		['useCategory'] = false,
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
		['position'] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -100, 100},
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
					'任务进度提示', '%[接受任务%]', '%(任务完成%)', '<大脚', '【爱不易】', 'EUI[:_]', '打断:.+|Hspell', 'PS 死亡: .+>', '%*%*.+%*%*', '<iLvl>', ('%-'):rep(20),
					'<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', 'blizzard.+验证码'
					},
}





C['unitframe'] = {
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

		['power_height'] = 2,
		['altpower_height'] = 2,

		['debuffbyPlayer'] = true,

		['focuser'] = true,

		['player_pos'] = {'TOP', UIParent, 'CENTER', 0, -360},
		['player_cb_pos'] = {'TOPRIGHT', 'oUF_Player', 'BOTTOMRIGHT', 0, -60},
		['player_width'] = 220,
		['player_height'] = 16,
		['player_frameVisibility'] = '[combat][mod:shift][@target,exists][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide',
		['enableFrameVisibility'] = false,

		['pet_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -6, 0},
		['pet_width'] = 68,
		['pet_height'] = 16,
		['pet_frameVisibility'] = '[nocombat,nomod,@target,noexists][@pet,noexists] hide; show',

		['target_pos'] = {'LEFT', 'oUF_Player', 'RIGHT', 40, 60},
		['target_cb_pos'] = {'TOPRIGHT', 'oUF_Target', 'BOTTOMRIGHT', 0, -12},
		['target_width'] = 266,
		['target_height'] = 16,

		['targettarget_pos'] = {'LEFT', 'oUF_Target', 'RIGHT', 6, 0},
		['targettarget_width'] = 80,
		['targettarget_height'] = 16,

		['focus_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -100, -60},
		['focus_cb_pos'] = {'TOPRIGHT', 'oUF_Focus', 'BOTTOMRIGHT', 0, -40},
		['focus_width'] = 80,
		['focus_height'] = 16,

		['focustarget_pos'] = {'RIGHT', 'oUF_Focus', 'LEFT', -6, 0},
		['focustarget_width'] = 80,
		['focustarget_height'] = 16,

		['party_pos'] = {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60},
		['party_width'] = 90,
		['party_height'] = 38,

		['raid_pos'] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -40},
		['raid_width'] = 50,
		['raid_height'] = 32,
		['raid_numGroups'] = '8',
		['raid_horizon'] = true,
		['raid_reverse'] = false,

		['boss_pos'] = {'LEFT', 'oUF_Target', 'RIGHT', 120, 160},
		['boss_width'] = 166,
		['boss_height'] = 20,

		['arena_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -400, 249},
		['arena_width'] = 166,
		['arena_height'] = 16,
		
		
}


C['classmod'] = {
	['havocFury'] = true,
}



