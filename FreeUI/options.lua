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

	['combatText'] = true,
		['combatText_info'] = true,
		['combatText_incoming'] = true,
		['combatText_outgoing'] = true,
	
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
	['numberFormatCN'] = false,
	
	['isDeveloper'] = false,
}




C['appearance'] = {
	['enableTheme'] = true,
		['backdropColour'] = {0, 0, 0, .5},
		['addShadowBorder'] = true,
		['buttonGradientColour'] = {.15, .15, .15, .5},
		['buttonSolidColour'] = {.05, .05, .05, .5},
		['useButtonGradientColour'] = true,

	['vignette'] = true,
		['vignetteAlpha'] = .35,

	['reskinQuestTracker'] = true,
	['reskinPetBattle'] = true,

	['reskinFonts'] = true,

	['reskinDBM'] = true,
	['reskinBW'] = true,
	['reskinWA'] = true,
	['reskinPGF'] = true,
	['reskinSkada'] = true,
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

		['bar3'] = true,
			['bar3Mouseover'] = true,
		['stanceBar'] = true,
			['stanceBarMouseover'] = false,
		['petBar'] = true,
			['petBarMouseover'] = false,
		['sideBar'] = true,
			['sideBarMouseover'] = true,

		['bar1Pos'] = {'BOTTOM', UIParent, 'BOTTOM', 0, 50},
		['extraButtonPos'] = {'CENTER', UIParent, 'CENTER', 0, 200},
		['zoneAbilityPos'] = {'CENTER', UIParent, 'CENTER', 0, 300},

		['hoverBind'] = true,
}


C['aura'] = {
	['enable'] = true,
		['position'] = {'TOPRIGHT', UIParent, 'TOPRIGHT', -50, -50},
		['buffSize'] = 42,
		['debuffSize'] = 50,
		['paddingX'] = 6,
		['paddingY'] = 8,
		['buffPerRow'] = 10,
}


C['map'] = {
	['worldMap'] = true,
		['worldMapScale'] = 1,
		['coords'] = true,
		['mapReveal'] = true,
	['miniMap'] = true,
		['miniMapScale'] = 1,
		['miniMapPosition'] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -50, 50},
		['miniMapSize'] = 240,
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
	['autoActionCam'] = false,
		['autoActionCam_full'] = false,
	['autoQuest'] = true,
	['autoBuyStack'] = true,
	['autoTabBinder'] = true,
	['autoAcceptInvite'] = false,
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
		['deleteButton'] = true,
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
		['skadaHelper'] = true,
		['specTalent'] = true,
		['friends'] = true,
		['currencies'] = true,
		['report'] = true,
		['durability'] = true,
}


C['tooltip'] = {
	['enable'] = true,
		['cursor'] = false,
		['position'] = {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -50, 300},
		['hidePVP'] = true,
		['hideFaction'] = true,
		['hideTitle'] = true,
		['hideRealm'] = true,
		['hideRank'] = true,
		['hideJunkGuild'] = true,
		['combatHide'] = false,
		['ilvlSpec'] = true,
			['ilvlSpecByShift'] = false,
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
		['itemLink'] = true,
		['spamageMeter'] = true,
		['whisperAlert'] = true,
		['chatButton'] = true,
		['abbreviate'] = true,
		['nameCopy'] = true,
		['urlCopy'] = true,
		['realLink'] = true,
		['tab'] = true,
		['channelSticky'] = true,
		['useOutline'] = false,
		['timeStamp'] = true,
		['autoBubble'] = false,
		['lineFading'] = true,
			['timeVisible'] = 20,
			['fadeDuration'] = 6,

		['useFilter'] = true,
			['filterList'] = '',
			['blockAddonAlert'] = true,
				['addonBlockList'] = {
					'任务进度提示', '%[接受任务%]', '%(任务完成%)', '<大脚', '【爱不易】', 'EUI[:_]', '打断:.+|Hspell', 'PS 死亡: .+>', '%*%*.+%*%*', '<iLvl>', ('%-'):rep(20),
					'<小队物品等级:.+>', '<LFG>', '进度:', '属性通报', 'wow.+兑换码', 'wow.+验证码', '=>', '【有爱插件】'
					},
}





C['unitframe'] = {
	['enable'] = true,
		['transMode'] = true,
		['colourSmooth'] = false,
		['healer_layout'] = false,
		['portrait'] = true,
		['threat'] = true,
		['healPrediction'] = true,
		['overAbsorb'] = true,
		['dispellable'] = true,
		['debuffbyPlayer'] = true,
		['rangeCheck'] = true,

		['quakeTimer'] = true,
			['quakeTimer_width'] = 200,
			['quakeTimer_height'] = 20,

		['classPower'] = true,
			['classPower_height'] = 2,

		['power_height'] = 2,
		['altpower_height'] = 2,
		
		['enableCastbar'] = true,
			['castbar_separatePlayer'] = false,
			['castbar_separateTarget'] = false,
			['castbar_CastingColor'] = {110/255, 176/255, 216/255},
			['castbar_ChannelingColor'] = {92/255, 193/255, 216/255},
			['castbar_notInterruptibleColor'] = {190/255, 10/255, 18/255},
			['castbar_CompleteColor'] = {63/255, 161/255, 124/255},
			['castbar_FailColor'] = {187/255, 99/255, 110/255},
			['castbar_showSpellName'] = false,
			['castbar_showSpellTimer'] = false,

		['enableGroup'] = true,
			['showGroupName'] = false,
			['colourSmooth_Raid'] = true,

		['enableBoss'] = true,
			['colourSmooth_Boss'] = true,

		['enableArena'] = true,

		['player_pos'] = {'TOP', UIParent, 'CENTER', 0, -100},
		['player_pos_healer'] = {'RIGHT', UIParent, 'CENTER', -100, -100},
		['player_width'] = 200,
		['player_height'] = 16,
		['player_cb_width'] = 196,
		['player_cb_height'] = 16,
		['player_frameVisibility'] = '[combat][mod:shift][@target,exists][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide',
		['frameVisibility'] = false,

		['pet_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -6, 0},
		['pet_pos_healer'] = {'RIGHT', 'oUF_Player', 'LEFT', -6, 0},
		['pet_width'] = 68,
		['pet_height'] = 16,
		['pet_frameVisibility'] = '[nocombat,nomod,@target,noexists][@pet,noexists] hide; show',
		['pet_auraPerRow'] = 3,
		['pet_auraTotal'] = 9,

		['target_pos'] = {'LEFT', 'oUF_Player', 'RIGHT', 80, 60},
		['target_pos_healer'] = {'LEFT', UIParent, 'CENTER', 100, -100},
		['target_width'] = 200,
		['target_height'] = 16,
		['target_cb_width'] = 196,
		['target_cb_height'] = 10,
		['target_auraPerRow'] = 6,
		['target_auraTotal'] = 36,

		['targettarget_pos'] = {'LEFT', 'oUF_Target', 'RIGHT', 6, 0},
		['targettarget_pos_healer'] = {'CENTER', UIParent, 'CENTER', 0, -100},
		['targettarget_width'] = 80,
		['targettarget_width_healer'] = 120,
		['targettarget_height'] = 16,

		['focus_pos'] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -60},
		['focus_pos_healer'] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -60},
		['focus_width'] = 97,
		['focus_width_healer'] = 97,
		['focus_height'] = 16,
		['focus_auraPerRow'] = 3,
		['focus_auraTotal'] = 9,

		['focustarget_pos'] = {'TOPRIGHT', 'oUF_Target', 'BOTTOMRIGHT', 0, -60},
		['focustarget_pos_healer'] = {'TOPRIGHT', 'oUF_Target', 'BOTTOMRIGHT', 0, -60},
		['focustarget_width'] = 97,
		['focustarget_width_healer'] = 97,
		['focustarget_height'] = 16,

		['party_pos'] = {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60},
		['party_pos_healer'] = {'TOP', UIParent, 'CENTER', 0, -250},
		['party_width'] = 90,
		['party_height'] = 38,
		['party_width_healer'] = 70,
		['party_height_healer'] = 34,
		['party_padding'] = 6,

		['raid_pos'] = {'RIGHT', Minimap, 'LEFT', -8, 0},
		['raid_pos_healer'] = {'TOP', UIParent, 'CENTER', 0, -250},
		['raid_width'] = 48,
		['raid_height'] = 32,
		['raid_padding'] = 5,
		['raid_numGroups'] = '8',

		['boss_pos'] = {'LEFT', 'oUF_Target', 'RIGHT', 120, 160},
		['boss_pos_healer'] = {'LEFT', 'oUF_Target', 'RIGHT', 120, 160},
		['boss_width'] = 166,
		['boss_height'] = 20,
		['boss_padding'] = 60,
		['boss_auraPerRow'] = 5,
		['boss_auraTotal'] = 15,

		['arena_pos'] = {'RIGHT', 'oUF_Player', 'LEFT', -300, 300},
		['arena_pos_healer'] = {'RIGHT', 'oUF_Player', 'LEFT', -300, 300},
		['arena_width'] = 166,
		['arena_height'] = 16,
		['arena_padding'] = 80,
		['arena_auraPerRow'] = 6,
		['arena_auraTotal'] = 18,
}


C['classmod'] = {
	['havocFury'] = false,
}



