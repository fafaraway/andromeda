local F, C, L = unpack(select(2, ...))

-- All exceptions and special rules for these options are in profiles.lua!


C['general'] = {
	['uiScale'] = 1,
	['uiScaleAuto'] = true,
	['hideBossBanner'] = true,
	['hideTalkingHead'] = true,
	['flashCursor'] = true,
	['mailButton'] = true, 				
	['alreadyKnown'] = true,
	['missingStats'] = true,
	['missingBuffs'] = true,
	['fasterLoot'] = true,
	['PVPSound'] = true,

	['progressBar'] = true,
	['paragonRep'] = true,
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
		['count'] = true,
		['classColor'] = false,

		['lockPosition'] = false,

		['layoutStyle'] = 1,

		['bar3Mouseover'] = false,
		['stanceBar'] = true,
			['stanceBarMouseover'] = false,
		['petBar'] = true,
			['petBarMouseover'] = false,
		['sideBar'] = true,
			['sideBarMouseover'] = false,

		['extraButtonPos'] = {'CENTER', UIParent, 'CENTER', 0, 200},
		['zoneAbilityPos'] = {'CENTER', UIParent, 'CENTER', 0, 300},

		['hoverBind'] = true,		
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
	['worldMap'] = true,
		['worldMapScale'] = 1,
		['coords'] = true,
		['mapReveal'] = true,
	['miniMap'] = true,
		['miniMapScale'] = 1,
		['miniMapPosition'] = {'TOPRIGHT', UIParent, 'TOPRIGHT', -22, 0},
		['miniMapSize'] = 256,
		['whoPings'] = true,
		
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
		['autoActionCam_full'] = false,
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
			['ilvlSpecByShift'] = true,
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
					'<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', 'wow.+兑换码', 'wow.+验证码', '=>'
					},
}





C['unitframe'] = {
	['enable'] = true,

		['transMode'] = true,
			['transModeAlpha'] = .1,
			['healthClassColor'] = true,
			['powerTypeColor'] = true,

		['gradient'] = false,

		['portrait'] = false,
			['portraitAlpha'] = .1,

		['spellRange'] = true,
			['spellRangeAlpha'] = .4,

		['classPower'] = true,
			['classPower_height'] = 2,

		['threat'] = true,
		['prediction'] = true, 
		['dispellable'] = true,

		['debuffbyPlayer'] = true,
		
		['castbar'] = true,
			['cbSeparate'] = false,
			['cbCastingColor'] = {110/255, 176/255, 216/255},
			['cbChannelingColor'] = {92/255, 193/255, 216/255},
			['cbnotInterruptibleColor'] = {162/255, 18/255, 24/255},
			['cbCompleteColor'] = {63/255, 161/255, 124/255},
			['cbFailColor'] = {187/255, 99/255, 110/255},
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

		['player_pos'] = {'TOP', UIParent, 'CENTER', 0, -360},
		['player_width'] = 220,
		['player_height'] = 16,
		['player_cb_width'] = 220,
		['player_cb_height'] = 20,
		['player_cb_pos'] = {'TOPRIGHT', 'oUF_Player', 'BOTTOMRIGHT', -1, -60},
		['player_frameVisibility'] = '[combat][mod:shift][@target,exists][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide',
		['enableFrameVisibility'] = false,

		['pet_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -6, 0},
		['pet_width'] = 68,
		['pet_height'] = 16,
		['pet_frameVisibility'] = '[nocombat,nomod,@target,noexists][@pet,noexists] hide; show',

		['target_pos'] = {'LEFT', 'oUF_Player', 'RIGHT', 40, 60},
		['target_width'] = 266,
		['target_height'] = 16,
		['target_cb_pos'] = {'TOPRIGHT', 'oUF_Target', 'BOTTOMRIGHT', -1, -10},
		['target_cb_width'] = 266,
		['target_cb_height'] = 10,

		['targettarget_pos'] = {'LEFT', 'oUF_Target', 'RIGHT', 6, 0},
		['targettarget_width'] = 80,
		['targettarget_height'] = 16,

		['focus_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -100, -60},
		['focus_width'] = 80,
		['focus_height'] = 16,

		['focustarget_pos'] = {'RIGHT', 'oUF_Focus', 'LEFT', -6, 0},
		['focustarget_width'] = 80,
		['focustarget_height'] = 16,

		['party_pos'] = {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60},
		['party_width'] = 90,
		['party_height'] = 38,
		['party_padding'] = 6,
		['party_horizon'] = false,
		['party_reverse'] = true,

		['raid_pos'] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -40},
		['raid_width'] = 48,
		['raid_height'] = 32,
		['raid_padding'] = 5,
		['raid_numGroups'] = '8',
		['raid_horizon'] = true,
		['raid_reverse'] = false,

		['boss_pos'] = {'LEFT', 'oUF_Target', 'RIGHT', 120, 160},
		['boss_width'] = 166,
		['boss_height'] = 20,
		['boss_padding'] = 60,

		['arena_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -300, 300},
		['arena_width'] = 166,
		['arena_height'] = 16,
		['arena_padding'] = 80,
		
		
}


C['classmod'] = {
	['havocFury'] = true,
}



