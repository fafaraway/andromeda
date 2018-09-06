local F, C, L = unpack(select(2, ...))

-- All exceptions and special rules for these options are in profiles.lua!
-- Consider using the in-game options instead, accessed through the game menu or by typing /freeui.

-- [[ Constants ]]

C.media = {
	["arrowUp"]    = "Interface\\AddOns\\FreeUI\\assets\\arrow-up-active",
	["arrowDown"]  = "Interface\\AddOns\\FreeUI\\assets\\arrow-down-active",
	["arrowLeft"]  = "Interface\\AddOns\\FreeUI\\assets\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\FreeUI\\assets\\arrow-right-active",
	["backdrop"]   = "Interface\\AddOns\\FreeUI\\assets\\blank",
	["checked"]    = "Interface\\AddOns\\FreeUI\\assets\\CheckButtonHilight",
	["glowtex"]    = "Interface\\AddOns\\FreeUI\\assets\\glowTex",
	["gradient"]   = "Interface\\AddOns\\FreeUI\\assets\\gradient",
	["roleIcons"]  = "Interface\\Addons\\FreeUI\\assets\\UI-LFG-ICON-ROLES",
	["texture"]    = "Interface\\AddOns\\FreeUI\\assets\\statusbar",
	["bgtex"]	   = "Interface\\AddOns\\FreeUI\\assets\\bgTex",
	["sparktex"]   = "Interface\\CastingBar\\UI-CastingBar-Spark",
}

if GetLocale() == "zhCN" then
	C.font = {
		["normal"] 		= "Fonts\\ARKai_T.ttf",	-- main font
		["unitname"] 	= "Fonts\\ARKai_T.ttf",	-- big font for names over player/monster/NPC head
		["damage"] 		= "Fonts\\ARKai_C.ttf",	-- damage font
		["header"]		= "Fonts\\ARKai_T.ttf",	-- big font for some panel
		["chat"]		= "Fonts\\ARKai_T.ttf",	-- chat font
		["pixel"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf",	-- pixel font
	}
elseif GetLocale() == "zhTW" then
	C.font = {
		["normal"] 		= "Fonts\\blei00d.ttf",
		["unitname"] 	= "Fonts\\blei00d.ttf",
		["damage"] 		= "Fonts\\bKAI00M.ttf",
		["header"]		= "Fonts\\blei00d.ttf",
		["chat"]		= "Fonts\\blei00d.ttf",
		["pixel"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf",
	}
elseif GetLocale() == "koKR" then
	C.font = {
		["normal"] 		= "Fonts\\2002.ttf",
		["unitname"] 	= "Fonts\\2002B.ttf",
		["damage"] 		= "Fonts\\K_Damage.ttf",
		["header"]		= "Fonts\\2002.ttf",
		["chat"]		= "Fonts\\2002.ttf",
		["pixel"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf",
	}
elseif GetLocale() == "ruRU" then
	C.font = {
		["normal"] 		= "Fonts\\FRIZQT___CYR.ttf",
		["unitname"] 	= "Fonts\\FRIZQT___CYR.ttf",
		["damage"] 		= "Fonts\\FRIZQT___CYR.ttf",
		["header"]		= "Fonts\\FRIZQT___CYR.ttf",
		["chat"]		= "Fonts\\FRIZQT___CYR.ttf",
		["pixel"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf",
	}
else
	C.font = {
		["normal"] 		= "Interface\\AddOns\\FreeUI\\assets\\font\\ExpresswayRg.ttf",
		["unitname"] 	= "Interface\\AddOns\\FreeUI\\assets\\font\\ExocetBlizzardMedium.ttf",
		["damage"] 		= "Interface\\AddOns\\FreeUI\\assets\\font\\PEPSI_pl.ttf",
		["header"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\ExocetBlizzardMedium.ttf",
		["chat"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\ExpresswayRg.ttf",
		["pixel"]		= "Interface\\AddOns\\FreeUI\\assets\\font\\pixel.ttf",
	}
end


C.reactioncolours = {
	[1] = {149/255, 0, 39/255}, -- Exceptionally hostile
	[2] = {179/255, 50/255, 58/255}, -- Very Hostile
	[3] = {243/255, 91/255, 98/255}, -- Hostile
	[4] = {215/255, 195/255, 108/255}, -- Neutral
	[5] = {81/255, 207/255, 115/255}, -- Friendly
	[6] = {81/255, 207/255, 115/255}, -- Very Friendly
	[7] = {81/255, 207/255, 115/255}, -- Exceptionally friendly
	[8] = {81/255, 207/255, 115/255}, -- Exalted
}


-- [[ Global config ]]

C["appearance"] = {
	["backdropcolor"] = {.05, .05, .05},
	["alpha"] = .6,
	["buttonGradientColour"] = {.3, .3, .3, .3},
	["buttonSolidColour"] = {.2, .2, .2, .6},
	["useButtonGradientColour"] = true,

	--["enableFont"] = false,

	["useCustomColour"] = false,
	["customColour"] = {r = 1, g = 1, b = 1},
	["tooltips"] = false,
	["shadow"] = true,
	["vignette"] = true,
	["vignetteAlpha"] = .5,
}

C["actionbars"] = {
	["hotKey"] = true, 					-- show hot keys on buttons
	["macroName"] = true,				-- show macro name on buttons
	["count"] = true,					
	["classColor"] = false,				-- button border colored by class color

	["bar3Fade"] = false,
	["sideBarEnable"] = true,
	["sideBarFade"] = false,
	["petBarFade"] = false,
	["stanceBarEnable"] = true,

	["layoutSimple"] = false,			-- hide bar1 bar2 for default

	["buttonSizeNormal"] = 30,
	["buttonSizeSmall"] = 24,
	["buttonSizeBig"] = 34,
	["buttonSizeHuge"] = 40,
	["padding"] = 2,
	["margin"] = 4,

	["fader"] = {
		fadeInAlpha = 1,
		fadeInDuration = 0.3,
		fadeInSmooth = "OUT",
		fadeOutAlpha = 0,
		fadeOutDuration = 0.9,
		fadeOutSmooth = "OUT",
		fadeOutDelay = 0,
	},
	["faderOnShow"] = {
		fadeInAlpha = 1,
		fadeInDuration = 0.3,
		fadeInSmooth = "OUT",
		fadeOutAlpha = 0,
		fadeOutDuration = 0.9,
		fadeOutSmooth = "OUT",
		fadeOutDelay = 0,
		trigger = "OnShow",
	},
}


C["auras"] = {
	["buffSize"] = 42,
	["debuffSize"] = 50,
	["paddingX"] = 5,
	["paddingY"] = 8,
	["buffPerRow"] = 10,
	["position"] = {"TOPRIGHT", UIParent, "TOPRIGHT", -290, -36},
	["aurasSource"] = true,
}


C["maps"] = {
	["worldMapScale"] = 1,
	["miniMapScale"] = 1,
	["miniMapPosition"] = { "TOPRIGHT", UIParent, "TOPRIGHT", -22, 0 },
	["miniMapSize"] = 256,
	["whoPings"] = true,
	["mapReveal"] = true,
}


C["misc"] = {
	["uiScale"] = 1,
	["uiScaleAuto"] = true,	

	["cooldownpulse"] = true,
	["flashCursor"] = true,

	["mailButton"] = true, 
	["undressButton"] = true, 


	["alreadyKnown"] = true,

	["bossBanner"] = false,
	["talkingHead"] = false,

	["hideRaidNames"] = true,
	["saySapped"] = true,

	["autoActionCam"] = true,

	["cooldown"] = true,
	["decimalCD"] = false,

	["rareAlert"] = true,
	["rareAlertNotify"] = true,
	["interruptAlert"] = true,
		["interruptSound"] = true,
		["interruptNotify"] = true,
		["dispelSound"] = true,
		["dispelNotify"] = true,

	["autoSetRole"] = true,			-- automatically set role and hide dialog where possible
		["autoSetRole_useSpec"] = true,		-- attempt to set role based on your current spec
		["autoSetRole_verbose"] = true, -- tells you what happens when setting role

	["autoScreenShot"] = true,		-- auto screenshot when achieved

	["autoSell"] = true, -- automatically sell greys
	["autoRepair"] = true,			-- automatically repair items
		["autoRepair_guild"] = true, -- use guild funds for auto repairs

	["autoAccept"] = false, -- auto accept invites from friends and guildies

	["focuser"] = true,
	["missingStats"] = true,
	["DOTA"] = true,

	["clickCast"] = true,
}


C["camera"] = {
	["speed"] = 50,
	["increment"] = 3,
	["distance"] = 50,
}


C["bags"] = {

	["itemSlotSize"] = 38,

	["sizes"] = {
		bags = {
			columnsSmall = 8,
			columnsLarge = 10,
			largeItemCount = 64,
		},
		bank = {
			columnsSmall = 10,
			columnsLarge = 12,
			largeItemCount = 96,
		},
	},
	["colors"] = {
		background = {.05, .05, .05, .8},
	},

}

C["infoBar"] = {
	["enable"] = true,

	["enableButtons"] = true,			-- show buttons for quick access on the menu bar
		["buttons_mouseover"] = true,			-- only on mouseover
}


C["tooltip"] = {
	["enable"] = true,		-- enable tooltip and modules
	["anchorCursor"] = false,		-- tooltip at mouse
	["tipPosition"] = {"BOTTOMRIGHT", -30, 30},	-- tooltip position
	
	["hidePVP"] = false,
	["hideFaction"] = true,
	["hideTitle"] = true,
	["hideRealm"] = true,
	["hideGuildRank"] = true,

	["fadeOnUnit"] = false,
	["combatHide"] = false,

	["ilvlspec"] = true,
	["spellID"] = true,
	["azeriteTrait"] = true,
	["borderColor"] = true,
}


C["chat"] = {
	["position"] = {"BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 50},
	["lockPosition"] = true,
	["sticky"] = true,
	["match"] = 1,
	["itemLinkLevel"] = true,
	["spamageMeters"] = true,
	["whisperAlert"] = true,
	["minimize"] = true,
	["outline"] = false,

	["filterList"] = "艾尔文森林美食协会 黄金梅利 新公会 豪门夜宴 猎户星座 星空之下 小号的天堂 守護之魂 爱与家庭 曙乂光 迪奥布斯 星辉 孤城 荣丶耀 众神之颠 招人 招收 收人 主收",
}


C["unitframes"] = {
	["enable"] = true, 						-- enable the unit frames and their included modules

	["transMode"] = true,
		["transModeAlpha"] = .2,
		["healthClassColor"] = true,
		["powerTypeColor"] = true,

	["gradient"] = false,					-- gradient mode
	["portrait"] = true,

	["classPower"] = true,

	["absorb"] = true, 							-- absorb bar/over absorb glow
	["castbar"] = true,
	["castbarSeparate"] = true,
	["pvp"] = true, 							-- show pvp icon on player frame
	["statusIndicator"] = true,					-- show combat/resting status on player frame
		["statusIndicatorCombat"] = true,				-- show combat status (else: only resting)

	["enableGroup"] = true,					-- enable party/raid frames
		["limitRaidSize"] = false, 					-- show a maximum of 25 players in a raid
		["showRaidFrames"] = true, 					-- show the raid frames
		["partyNameAlways"] = false,				-- show name on party/raid frames
		["partyMissingHealth"] = false,				-- show missing health
	["enableArena"] = true,					-- enable arena/flag carrier frames

	["castbyPlayer"] = true,

	["player"] = {"BOTTOM", UIParent, "BOTTOM", 0, 320},						-- player unitframe position
	["player_width"] = 200,
	["player_height"] = 14,
	["player_castbar"] = {"CENTER", 'oUF_FreePlayer', "CENTER", 0, -50},		-- player castbar position
	["player_castbar_width"] = 200,

	["pet"] = {"RIGHT", "oUF_FreePlayer", "LEFT", -5, 0},									-- pet unitframe position
	["pet_width"] = 68,
	["pet_height"] = 14,

	["frameVisibility"] = false,
	["frameVisibility_player"] = "[combat][mod][@target,exists,nodead][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide",
	["frameVisibility_pet"] = "[nocombat,nomod,@target,noexists][@pet,noexists] hide; show",


	["target"] = {"RIGHT", 'oUF_FreePlayer', "LEFT", -100, 200},					-- target unitframe position
	["target_width"] = 262,
	["target_height"] = 14,
	["target_castbar"] = {"TOP", 'oUF_FreeTarget', "BOTTOM", 0, -8},			-- target castbar position
	["target_castbar_width"] = 262,

	["targettarget"] = {"RIGHT", 'oUF_FreeTarget', "LEFT", -5, 0},							-- target target unitframe position
	["targettarget_width"] = 80,
	["targettarget_height"] = 14,

	["focus"] = {"LEFT", 'oUF_FreePlayer', "RIGHT", 80, 60},					-- focus unitframe position
	["focus_width"] = 92,
	["focus_height"] = 14,
	["focus_castbar"] = {"LEFT", 'oUF_FreeFocus', "LEFT", 0, 40},				-- focus castbar position
	["focus_castbar_width"] = 189,

	["focustarget"] = {"LEFT", 'oUF_FreeFocus', "RIGHT", 5, 0},							-- focus target unitframe position
	["focustarget_width"] = 92,
	["focustarget_height"] = 14,

	["party"] = {"BOTTOMRIGHT", 'oUF_FreeTarget', "TOPLEFT", -100, 100},			-- party unitframe position
	["party_width"] = 100,
	["party_height"] = 34,

	["raid"] = {"TOPRIGHT", 'oUF_FreeTarget', "BOTTOMRIGHT", 0, -60},			-- raid unitframe position
	["raid_width"] = 50,
	["raid_height"] = 30,

	["boss"] = {a='LEFT', b='oUF_FreePlayer', c="RIGHT", x=400, y=400},			-- boss unitframe position
	["boss_width"] = 166,
	["boss_height"] = 16,

	["arena"] = {a='RIGHT', b='oUF_FreeTarget', c="LEFT", x=-100, y=180},				-- arena unitframe position
	["arena_width"] = 166,
	["arena_height"] = 16,
	
	["cbCastingColor"] = {77/255, 183/255, 219/255},
	["cbChannelingColor"] = {77/255, 183/255, 219/255},
	["cbnotInterruptibleColor"] = {160/255, 159/255, 161/255},
	["cbCompleteColor"] = {63/255, 161/255, 124/255},
	["cbFailColor"] = {187/255, 99/255, 110/255},
	["cbHeight"] = 12,

	["power_height"] = 2,
	["altpower_height"] = 2,
	["classPower_height"] = 2,

	["pixelFontName"] = false,
}



-- [[ Filters ]]
-- buff/debuff过滤规则
-- 需要更新
-- WA更方便

-- Debuffs by other players or NPCs you want to show on enemy target
-- 目标框体的debuff过滤表
-- 由其他玩家或NPC施放的控制性技能
-- 以下debuff将显示

C["debuffFilter"] = {
	-- CC
	[33786]  = true, -- Cyclone
	[605]    = true, -- Dominate Mind (Mind Control)
	[20549]  = true, -- War Stomp
	[107079] = true, -- Quaking Palm
	[129597] = true, -- Arcane Torrent
		[28730]  = true, -- Arcane Torrent
		[25046]  = true, -- Arcane Torrent
		[50613]  = true, -- Arcane Torrent
		[69179]  = true, -- Arcane Torrent
		[155145] = true, -- Arcane Torrent
		[80483]  = true, -- Arcane Torrent
	[155335] = true, -- Touched by Ice
	[5246]   = true, -- Intimidating Shout
	[24394]  = true, -- Intimidation
	[132168] = true, -- Shockwave
	[132169] = true, -- Storm Bolt
	[853]    = true, -- Hammer of Justice
	[10326]  = true, -- Turn Evil
	[20066]  = true, -- Repentance
	[31935]  = true, -- Avengers Shield
	[105421] = true, -- Blinding Light
	[105593] = true, -- Fist of Justice
	[119072] = true, -- Holy Wrath
	[3355]   = true, -- Freezing Trap
	[19386]  = true, -- Wyvern Sting
	[117526] = true, -- Binding Shot
	[408]    = true, -- Kidney Shot
	[1330]   = true, -- Garrote - Silence
	[1776]   = true, -- Gouge
	[1833]   = true, -- Cheap Shot
	[2094]   = true, -- Blind
	[6770]   = true, -- Sap
	[88611]  = true, -- Smoke Bomb
	[8122]   = true, -- Psychic Scream
	[9484]   = true, -- Shackle Undead
	[15487]  = true, -- Silence
	[64044]  = true, -- Psychic Horror
	[87204]  = true, -- Sin and Punishment
	[88625]  = true, -- Holy Word: Chastise
	[47476] = true, -- Strangulate
		[115502] = true, -- Strangulate (Asphyxiate)
	[91797]  = true, -- Monstrous Blow
	[91800]  = true, -- Gnaw
	[108194] = true, -- Asphyxiate
	[115001] = true, -- Remorseless Winter
	[51514]  = true, -- Hex
	[77505]  = true, -- Earthquake
	[118345] = true, -- Pulverize
	[118905] = true, -- Static Charge (Capacitor Totem)
	[118]    = true, -- Polymorph
		[61305]  = true, -- Polymorph Black Cat
		[28272]  = true, -- Polymorph Pig
		[61721]  = true, -- Polymorph Rabbit
		[61780]  = true, -- Polymorph Turkey
		[28271]  = true, -- Polymorph Turtle
	[31661]  = true, -- Dragon's Breath
	[44572]  = true, -- Deep Freeze
	[82691]  = true, -- Ring of Frost
	[102051] = true, -- Frostjaw
	[710]    = true, -- Banish
	[5484]   = true, -- Howl of Terror
	[6358]   = true, -- Seduction
	[6789]   = true, -- Mortal Coil
	[22703]  = true, -- Infernal Awakening
	[30283]  = true, -- Shadowfury
	[31117]  = true, -- Unstable Affliction (Silence)
	[89766]  = true, -- Axe Toss
	[115268] = true, -- Mesmerize
	[118699] = true, -- Fear
		[130616] = true, -- Fear (Glyph of Fear)
	[137143] = true, -- Blood Horror
	[115078] = true, -- Paralysis
	[119381] = true, -- Leg Sweep
	[119392] = true, -- Charging Ox Wave
	[120086] = true, -- Fists of Fury
	[123393] = true, -- Breath of Fire
	[137460] = true, -- Incapacitated
	[99]     = true, -- Incapacitating Roar
	[5211]   = true, -- Mighty Bash
	[22570]  = true, -- Maim
	[81261]  = true, -- Solar Beam
	[114238] = true, -- Fae Silence
	[163505] = true, -- Rake

	-- Roots
	[122]    = true, -- Frost Nova
		[33395] = true, -- Freeze
	[339]    = true, -- Entangling Roots
		[113770] = true, -- Entangling Roots
		[170855] = true, -- Entangling Roots (Nature's Grasp)
	[53148]  = true, -- Charge (Hunter)
	[105771] = true, -- Charge (Warrior)
	[63685]  = true, -- Frozen Power
	[64695]  = true, -- Earthgrab Totem
	[87194]  = true, -- Glyph of Mind Blast
	[96294]  = true, -- Chains of Ice
	[102359] = true, -- Mass Entanglement
	[111340] = true, -- Ice Ward
	[114404] = true, -- Void Tendrils
	[116706] = true, -- Disable
	[135373] = true, -- Entrapment
	[136634] = true, -- Narrow Escape
	[55536]  = true, -- Frostweave Net
	[157997] = true, -- Ice Nova
	[45334]  = true, -- Wild Charge

}

-- Buffs to show on enemy players
-- 目标框体的buff过滤表
-- 防守/爆发性技能
-- 以下buff将显示

C["dangerousBuffs"] = {
	-- Immunities
	[46924]  = true, -- Bladestorm
	[642]    = true, -- Divine Shield
	[19263]  = true, -- Deterrence
		[148467] = true, -- Deterrence (Glyph of Mirrored Blades)
	[51690]  = true, -- Killing Spree
	[115018] = true, -- Desecrated Ground
	[45438]  = true, -- Ice Block
	[115760] = true, -- Glyph of Ice Block
	[157913] = true, -- Evanesce

	-- Spell Immunities
	[23920]  = true, -- Spell Reflection
		[114028] = true, -- Mass Spell Reflection
	[31821]  = true, -- Devotion Aura
	[31224]  = true, -- Cloak of Shadows
	[159630] = true, -- Shadow Magic
	[8178]   = true, -- Grounding Totem
		[89523]  = true, -- Grounding Totem (Glyph of Grounding Totem)
	[159652] = true, -- Glyph of Spiritwalker's Aegis
	[48707]  = true, -- Anti-Magic Shell
	[104773] = true, -- Unending Resolve
	[159546] = true, -- Glyph of Zen Focus
	[159438] = true, -- Glyph of Enchanted Bark

	-- Defensive Buffs
	[871]    = true, -- Shield Wall
	[108271] = true, -- Astral Shift
	[157128] = true, -- Saved by the Light
	[33206]  = true, -- Pain Suppression
	[116849] = true, -- Life Cocoon
	[47788]  = true, -- Guardian Spirit
	[47585]  = true, -- Dispersion
	[122783] = true, -- Diffuse Magic
	[178858] = true, -- Contender
	[61336]  = true, -- Survival Instincts
	[98007]  = true, -- Spirit Link
	[118038] = true, -- Die by the Sword
	[74001]  = true, -- Combat Readiness
	[30823]  = true, -- Shamanistic Rage
	[114917] = true, -- Stay of Execution
	[114029] = true, -- Safeguard
	[5277]   = true, -- Evasion
	[49039]  = true, -- Lichborne
	[117679] = true, -- Incarnation: Tree of Life
	[137562] = true, -- Nimble Brew
	[102342] = true, -- Ironbark
	[22812]  = true, -- Barkskin
	[110913] = true, -- Dark Bargain
	[122278] = true, -- Dampen Harm
	[53480]  = true, -- Roar of Sacrifice
	[55694]  = true, -- Enraged Regeneration
	[12975]  = true, -- Last Stand
	[1966]   = true, -- Feint
	[6940]   = true, -- Hand of Sacrifice
	[97463]  = true, -- Rallying Cry
	[115176] = true, -- Zen Meditation
	[120954] = true, -- Fortifying Brew
	[118347] = true, -- Reinforce
	[81782]  = true, -- Power Word: Barrier
	[30884]  = true, -- Nature's Guardian
	[155835] = true, -- Bristling Fur
	[62606]  = true, -- Savage Defense
	[1022]   = true, -- Hand of Protection
	[48743]  = true, -- Death Pact
	[31850]  = true, -- Ardent Defender
	[114030] = true, -- Vigilance
	[498]    = true, -- Divine Protection
	[122470] = true, -- Touch of Karma
	[48792]  = true, -- Icebound Fortitude
	[55233]  = true, -- Vampiric Blood
	[114039] = true, -- Hand of Purity
	[86659]  = true, -- Guardian of Ancient Kings
	[108416] = true, -- Sacrificial Pact

	-- Offensive Buffs
	[19574]  = true, -- Bestial Wrath
	[84747]  = true, -- Deep Insight
	[131894] = true, -- A Murder of Crows
	[152151] = true, -- Shadow Reflection
	[31842]  = true, -- Avenging Wrath
	[114916] = true, -- Execution Sentence
	[83853]  = true, -- Combustion
	[51690]  = true, -- Killing Spree
	[79140]  = true, -- Vendetta
	[102560] = true, -- Incarnation: Chosen of Elune
	[102543] = true, -- Incarnation: King of the Jungle
	[123737] = true, -- Heart of the Wild
		[108291] = true, -- Heart of the Wild (Balance)
		[108292] = true, -- Heart of the Wild (Feral)
		[108293] = true, -- Heart of the Wild (Guardian)
		[108294] = true, -- Heart of the Wild (Restoration)
	[124974] = true, -- Nature's Vigil
	[12472]  = true, -- Icy Veins
	[77801]  = true, -- Dark Soul
		[113860] = true, -- Dark Soul (Misery)
		[113861] = true, -- Dark Soul (Knowledge)
		[113858] = true, -- Dark Soul (Instability)
	[16166]  = true, -- Elemental Mastery
	[114049] = true, -- Ascendance
		[114052] = true, -- Ascendance (Restoration)
		[114050] = true, -- Ascendance (Elemental)
		[114051] = true, -- Ascendance (Enhancement)
	[107574] = true, -- Avatar
	[51713]  = true, -- Shadow Dance
	[13750]  = true, -- Adrenaline Rush
	[1719]   = true, -- Recklessness
	[84746]  = true, -- Moderate Insight
	[112071] = true, -- Celestial Alignment
	[106951] = true, -- Berserk
	[12042]  = true, -- Arcane Power
	[51271]  = true, -- Pillar of Frost
	[152279] = true, -- Breath of Sindragosa

	[41425]  = true, -- Hypothermia
	[130736] = true, -- Soul Reaper (Blood)
		[114866] = true, -- Soul Reaper (Unholy)
		[130735] = true, -- Soul Reaper (Frost)
	[12043]  = true, -- Presence of Mind
	[16188]  = true, -- Ancestral Swiftness
	[132158] = true, -- Nature's Swiftness
	[6346]   = true, -- Fear Ward
	[77606]  = true, -- Dark Simulacrum
	[172786] = true, -- Drink
		[167152] = true, -- Refreshment
	[114239] = true, -- Phantasm
	[119032] = true, -- Spectral Guise
	[1044]   = true, -- Hand of Freedom
	[10060]  = true, -- Power Infusion
	[5384]   = true, -- Feign Death
	[108978] = true, -- Alter Time
	[170856] = true, -- Nature's Grasp
	[110959] = true, -- Greater Invisibility
	[18499]  = true, -- Berserker Rage
	[111397] = true, -- Blood Horror (Buff)
	[114896] = true, -- Windwalk Totem
}

-- Debuffs healers don't want to see on raid frames
-- 小队/团队框体的debuff过滤表
-- 无意义的垃圾技能
-- 比如密境的挑战者负担之类
-- 以下技能将隐藏

C["hideDebuffs"] = {
	[57724] = true, -- Sated
	[57723] = true, -- Exhaustion
	[80354] = true, -- Temporal Displacement
	[41425] = true, -- Hypothermia
	[95809] = true, -- Insanity
	[36032] = true, -- Arcane Blast
	[26013] = true, -- Deserter
	[95223] = true, -- Recently Mass Resurrected
	[97821] = true, -- Void-Touched (death knight resurrect)
	[36893] = true, -- Transporter Malfunction
	[36895] = true, -- Transporter Malfunction
	[36897] = true, -- Transporter Malfunction
	[36899] = true, -- Transporter Malfunction
	[36900] = true, -- Soul Split: Evil!
	[36901] = true, -- Soul Split: Good
	[25163] = true, -- Disgusting Oozeling Aura
	[85178] = true, -- Shrink (Deviate Fish)
	[8064] = true, -- Sleepy (Deviate Fish)
	[8067] = true, -- Party Time! (Deviate Fish)
	[24755] = true, -- Tricked or Treated (Hallow's End)
	[42966] = true, -- Upset Tummy (Hallow's End)
	[89798] = true, -- Master Adventurer Award (Maloriak kill title)
	[6788] = true, -- Weakened Soul
	[92331] = true, -- Blind Spot (Jar of Ancient Remedies)
	[71041] = true, -- Dungeon Deserter
	[26218] = true, -- Mistletoe
	[117870] = true, -- Touch of the Titans
	[173658] = true, -- Delvar Ironfist defeated
	[173659] = true, -- Talonpriest Ishaal defeated
	[173661] = true, -- Vivianne defeated
	[173679] = true, -- Leorajh defeated
	[173649] = true, -- Tormmok defeated
	[173660] = true, -- Aeda Brightdawn defeated
	[173657] = true, -- Defender Illona defeated
	[206151] = true, -- 挑战者的负担
	[260738] = true, -- 艾泽里特残渣
}

if select(2, UnitClass("player")) == "PRIEST" then C.hideDebuffs[6788] = false end

-- Buffs cast by the player that healers want to see on raid frames
-- 小队/团队框体的buff过滤表
-- 玩家自己施放的技能
-- 比如奶德的恢复牧师的盾之类
-- 以下技能将显示

C["myBuffs"] = {

	[774] = true,		-- 回春
	[8936] = true,		-- 愈合
	[33763] = true,		-- 生命绽放
	[48438] = true,		-- 野性成长
	[155777] = true,	-- 萌芽
	[102352] = true,	-- 塞纳里奥结界
	[200389] = true, -- 栽培

	[34477] = true, -- 误导

	[57934] = true, -- 嫁祸

	[12975] = true,		-- 援护
	[114030] = true, -- 警戒

	[61295] = true, -- 激流

	[1044] = true,		-- 自由祝福
	[6940] = true,		-- 牺牲祝福
	[25771] = true,		-- 自律
	[53563] = true,		-- 圣光道标
	[156910] = true,	-- 信仰道标
	[223306] = true,	-- 赋予信仰
	[200025] = true,	-- 美德道标
	[200654] = true,	-- 提尔的拯救
	[243174] = true, -- 神圣黎明

	[17] = true,		-- 真言术盾
	[139] = true,		-- 恢复
	[41635] = true,		-- 愈合祷言
	[47788] = true,		-- 守护之魂
	[194384] = true,	-- 救赎
	[152118] = true,	-- 意志洞悉
	[208065] = true, -- 图雷之光

	[119611] = true,	-- 复苏之雾
	[116849] = true,	-- 作茧缚命
	[124682] = true,	-- 氤氲之雾
	[124081] = true,	-- 禅意波
	[191840] = true,	-- 精华之泉
	[115175] = true, -- 抚慰之雾
}

-- Buffs cast by anyone that healers want to see on raid frames
-- 小队/团队框体的buff过滤表
-- 治疗专精希望看到的由其他队友施放的技能
-- 比如坦克的减伤技能
-- 以下技能将显示

C["allBuffs"] = {
	[642] = true,		-- 圣盾术
	[1022] = true,		-- 保护祝福
	[27827] = true,		-- 救赎之魂
	[98008] = true,		-- 灵魂链接
	[31821] = true,		-- 光环掌握
	[97463] = true,		-- 命令怒吼
	[81782] = true,		-- 真言术障
	[33206] = true,		-- 痛苦压制
	[45438] = true,		-- 冰箱
	[204018] = true,	-- 破咒祝福
	[204150] = true,	-- 圣光护盾
	[102342] = true,	-- 铁木树皮
	[209426] = true,	-- 黑暗
	[186265] = true, -- 灵龟守护
}
