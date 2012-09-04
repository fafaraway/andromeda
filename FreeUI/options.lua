local F, C, L = unpack(select(2, ...))

--[[ Global config ]]

C["general"] = {
	["auto_accept"] = true,			-- auto accept invites from friends and guildies
	["autorepair"] = true,			-- automatically repair items
		["autorepair_guild"] = false,		-- use guild funds for auto repairs
	["autoroll"] = true, 			-- automatically DE or greed on BoE greens (DE priority)
	["autosell"] = true,			-- automatically sell greys
	["bags_size"] = 37,				-- change the size of the bags/bank, default = 37
	["buffreminder"] = true, 		-- reminder for selfbuffs
	["helmcloakbuttons"] = true, 		-- show buttons to toggle helm/cloak on character frame
	["interrupt"] = true,			-- announce your interrupts
	["tolbarad"] = true,			-- Tol barad timer on the minimap at level 85
		["tolbarad_always"] = false,		-- show timer on characters lower or higher than 85 as well
	["tooltip_cursor"] = false,		-- anchor the tooltip to the cursor
	["tooltip_guildranks"] = true, 	-- show guild ranks in tooltips
	["uiScaleAuto"] = true,				-- force the correct UI scale
	["undressButton"] = true, 		-- undress button on dressup frame
}

C["actionbars"] = {
	["hotkey"] = false, 			-- show hot keys on buttons
	["rightbars_mouseover"] = false,	-- show right bars on mouseover (show/hide: use blizz option)
	["stancebar"] = true,			-- enable stance bar
}

C["unitframes"] = {
	["cast"] = {"BOTTOM", UIParent, "CENTER", 0, -105}, 	-- only applies with 'castbar' set to 2
	["castbar"] = 1, 					-- 1 = dps/tank cast bar, 2 = caster/healer cast bar
	["healer_classcolours"] = false,			-- colour unitframes by class in healer layout
	["party_name_always"] = false,				-- show name on party/raid frames in dps/tank layout
	["pvp"] = true, 					-- show pvp icon on player frame
	["targettarget"] = false, 			-- show target of target frame

	["auto"] = true,				-- adjust unitframe position based on screen height, ignores user settings

	["player"] = {"BOTTOM", UIParent, "CENTER", -275, -105}, -- only applies when 'auto' is false
	["target"] = {"TOP", UIParent, "CENTER", 0, -225}, -- only applies when 'auto' is false
	["target_heal"] = {"BOTTOM", UIParent, "CENTER", 275, -105},
	["party"] = {"TOP", UIParent, "CENTER", 0, -225}, 	-- only applies with healer layout enabled and when 'auto' is false
	["raid"] = {"TOP", UIParent, "CENTER", 0, -190}, 	-- only applies with healer layout enabled and when 'auto' is false

	["altpower_height"] = 1,
	["power_height"] = 1,

	["player_width"] = 229,
	["player_height"] = 14,
	["target_width"] = 229,
	["target_height"] = 14,
	["targettarget_width"] = 229,
	["targettarget_height"] = 8,
	["focus_width"] = 113,
	["focus_height"] = 8,
	["pet_width"] = 113,
	["pet_height"] = 8,
	["boss_width"] = 170,
	["boss_height"] = 14,
	["arena_width"] = 229,
	["arena_height"] = 14,
	["party_width"] = 38,
	["party_height"] = 22,
	["party_width_healer"] = 56,
	["party_height_healer"] = 42,

	["num_player_debuffs"] = 8,
	["num_target_debuffs"] = 16,
	["num_target_buffs"] = 16,
	["num_boss_buffs"] = 5,
	["num_arena_buffs"] = 8,
	["num_focus_debuffs"] = 4,

}

C["classmod"] = {
	["deathknight"] = true, 	-- runes
	["druid"] = true, 		-- eclipse bar
	["monk"] = true, 		-- harmony bar
	["paladin"] = true, 		-- holy power
	["priest"] = true,		-- shadow orbs
	["shaman"] = true, 		-- maelstrom weapon tracker
	["warlock"] = true, 		-- spec bar
	["warrior"] = true, -- thunderstruck tracker
}

-- lower = smoother = more CPU usage
C["performance"] = {
	["bubbles"] = .1, 	-- update interval for chat bubbles in seconds (always)
	["mapcoords"] = .1, 	-- update interval for map coords in seconds (only with map open)
	["nameplates"] = .1, 	-- update interval for nameplates in seconds (always)
	["namethreat"] = .2, 	-- update interval for nameplates threat in seconds (only with nameplates shown)
	["tolbarad"] = 10, 	-- update interval for TB timer in seconds (always)
}

-- Selfbuff reminder
-- put all possible buffs with the same effect in the same list, even when you can't cast them yourself
-- outer tables are for buffs that you want together (e.g. an outer table with inner fire and an outer table with PW:F)
-- tables within those tables are for buffs that are exclusive to each other (e.g. blessing of might and blessing of kings)
C["selfbuffs"] = {
	DEATHKNIGHT = {
		{
			{
				57330, -- Horn of Winter
				6673, -- Battle Shout
				19506, -- Trueshot Aura
			},
		},
	},
	DRUID = {
		{
			{
				1126, -- Mark of the Wild
				20217, -- Blessing of Kings
				115921, -- Legacy of the Emperor
			},
		},
	},
	HUNTER = {
		{
			{
				13165, -- Aspect of the Hawk
				109260, -- Aspect of the Iron Hawk
				5118, -- Aspect of the Cheetah
				13159, -- Aspect of the Pack
				82661, -- Aspect of the Fox
				85683, -- Aspect of the Beast
			},
		},
	},
	MAGE = {
		{
			{
				1459, -- Arcane Brilliance
				77747, -- Burning Wrath
				109773, -- Dark Intent
			},
		},
		{
			{
				7302, -- Frost Armor
				6117, -- Mage Armor
				30482, -- Molten Armor
			},
		},
	},
	MONK = {
		{
			{
				115921, -- Legacy of the Emperor
				1126, -- Mark of the Wild
				20217, -- Blessing of Kings
			},
			{
				116781, -- Legacy of the White Tiger
				19740, -- Blessing of Might
				116956, -- Grace of Air
			},
		},
	},
	PALADIN = {
		{
			{
				20217, -- Blessing of Kings
				1126, -- Mark of the Wild
				115921, -- Legacy of the Emperor
			},
			{
				19740, -- Blessing of Might
				116781, -- Legacy of the White Tiger
				116956, -- Grace of Air
			},
		}
	},
	PRIEST = {
		{
			{
				588, -- Inner Fire
				73413, -- Inner Will
			},
		},
		{
			{
				21562, -- Power Word: Fortitude
				469, -- Commanding Shout
				103127, -- Imp: Blood Pact
			},
		},
	},
	ROGUE = {
		{
			{
				2823, -- Deadly Poison
				8679, -- Wound Poison
			},
		},
	},
	SHAMAN = {
		{
			{
				52127, -- Water shield
				324, -- Lightning shield
				974, -- Earth shield
			},
		},
	},
	WARLOCK = {
		{
			{
				109773, -- Dark Intent
				1459, -- Arcane Brilliance
				77747, -- Burning Wrath
			},
		},
	},
	WARRIOR = {
		{
			{
				6673, -- Battle Shout
				19506, -- Trueshot Aura
				57330, -- Horn of Winter
			},
			{
				469, -- Commanding Shout
				21562, -- Power Word: Fortitude
				103127, -- Imp: Blood Pact
			},
		},
	}
}

-- buff tracker: slot 1 is left, slot 2 is middle, slot 3 is right
-- spellID 1-5, size, unitId, isMine, filter, slot (1-3: left, middle, right), customPoint (table, overrides slot), spec (1-3)
-- if you use multiple spellIDs, first available gets displayed
C["buffTracker"] = {
	["PALADIN"] = {
	-- Sacred Shield
	{spellId = 20925, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3},
	-- Divine Shield, Hand of Protection, Divine Protection, Avenging Wrath
	{spellId = 642, spellId2 = 1022, spellId3 = 498, spellId4 = 31884, unitId = "player", isMine = "all", filter = "HELPFUL", slot = 2},
	-- Inquisition, Bastion of Glory, Divine Plea
	{spellId = 84963, spellId2 = 114637, spellId3 = 54428, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 1},
	},
	["ROGUE"] = {
	-- Bandit's Guile, Recuperate
	{spellId = 84745, spellId2 = 84746, spellId3 = 84747, spellId4 = 73651, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3},
	-- Adrenaline Rush
	{spellId = 13750, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 2},
	-- Slice and dice
	{spellId = 5171, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 1},
	},
	["WARRIOR"] = {
	-- Last Stand, Shield Wall
	{spellId = 12975, spellId2 = 871, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 2},
	-- Shield Block
	{spellId = 2565, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3},
	}
}

-- [[ Filters ]]

-- Debuffs by other players or NPCs you want to show on enemy target

C["debuffFilter"] = {
	-- Weakened Armor
	[113746] = true,

	-- Physical Vulnerability
	[81326] = true,

	-- Weakened Blows
	[115798] = true,
	[109466] = true, -- Curse of Enfeeblement

	-- Mortal Wounds
	[115804] = true,
	[82654] = true, -- Widow Venom
	[8680] = true, -- Wound Poison

	-- Magic Vulnerability
	[93068] = true, -- Master Poisoner
	[1490] = true, -- Curse of the Elements

	-- Slow Casting
	[73975] = true, -- Necrotic Strike
	[5760] = true, -- Mind-numbing Poison
	[109466] = true, -- Curse of Enfeeblement

	-- Stuns
	[408] = true, -- Kidney Shot
	[1833] = true, -- Cheap Shot
	[5211] = true, -- Mighty Bash
	[853] = true, -- Hammer of Justice
	[105593] = true, -- Fist of Justice
	[119381] = true, -- Leg Sweep

	-- Silence
	[47476] = true, -- Strangulate
	[15487] = true, -- Silence

	-- Taunt
	[355] = true, -- Taunt
	[1161] = true, -- Challenging Shout
	[21008] = true, -- Mocking Blow
	[62124] = true, -- Reckoning
	[49576] = true, -- Death Grip
	[56222] = true, -- Dark Command
	[6795] = true, -- Growl
	[2649] = true, -- Growl (pet)
	[116189] = true, -- Provoke

	-- Disarm
	[676] = true, -- Disarm
	[124539] = true, -- Disarm (Voidwalker)
	[51722] = true, -- Dismantle
	[117368] = true, -- Grapple Weapon

	-- Crowd control
	[118] = true, -- Polymorph (sheep)
	[61305] = true, -- Polymorph (black cat)
	[28272] = true, -- Polymorph (pig)
	[61721] = true, -- Polymorph (rabbit)
	[28271] = true, -- Polymorph (turtle)
	[61780] = true, -- Polymorph (turkey)
	[2094] = true, -- Blind
	[6770] = true, -- Sap
	[20066] = true, -- Repentance
	[9484] = true, -- Shackle Undead
	[339] = true, -- Entangling Roots
	[2637] = true, -- Hibernate
	[710] = true, -- Banish
	[19386] = true, -- Wyvern Sting
	[51514] = true, -- Hex
	[76780] = true, -- Bind Elemental
	[5782] = true, -- Fear
	[1499] = true, -- Freezing Trap (1?)
	[3355] = true, -- Freezing Trap (2?)
	[6358] = true, -- Seduction
	[10326] = true, -- Turn Evil
	[33786] = true, -- Cyclone
	[115078] = true, -- Paralysis

	-- NPC debuffs
	[90932] = true, -- Ragezone
	[97170] = true, -- Deadzone (1)
	[97600] = true, -- Deadzone (2)
	[103527] = true, -- Void Diffusion (test)
}

-- Buffs to show on enemy players

C["dangerousBuffs"] = {
	[13750] = true, -- Adrenaline Rush
	[23335] = true, -- Alliance Flag
	[90355] = true, -- Ancient Hysteria
	[48707] = true, -- Anti-Magic Shell
	[31850] = true, -- Ardent Defender
	[31821] = true, -- Aura Mastery
	[31884] = true, -- Avenging Wrath
	[46924] = true, -- Bladestorm
	[2825] = true, -- Bloodlust
	[51753] = true, -- Camouflage
	[31224] = true, -- Cloak of Shadows
	[74001] = true, -- Combat Readiness
	[49028] = true, -- Dancing Rune Weapon (?)
	[19263] = true, -- Deterrence
	[47585] = true, -- Dispersion
	[498] = true, -- Divine Protection
	[642] = true, -- Divine Shield
	[5277] = true, -- Evasion
	[86669] = true, -- Guardian of Ancient Kings (holy)
	[86659] = true, -- Guardian of Ancient Kings (protection)
	[86698] = true, -- Guardian of Ancient Kings (retribution)
	[47788] = true, -- Guardian Spirit
	[1022] = true, -- Hand of Protection
	[32182] = true, -- Heroism
	[105809] = true, -- Holy Avenger
	[23333] = true, -- Horde Flag
	[11426] = true, -- Ice Barrier
	[45438] = true, -- Ice Block
	[48792] = true, -- Icebound Fortitude
	[29166] = true, -- Innervate
	[66] = true, -- Invisibility
	[12975] = true, -- Last Stand
	[1463] = true, -- Mana Shield
	[103958] = true, -- Metamorphosis
	[33206] = true, -- Pain Suppression
	[10060] = true, -- Power Infusion
	[17] = true, -- Power Word: Shield
	[15473] = true, -- Shadowform
	[871] = true, -- Shield Wall
	[23920] = true, -- Spell Reflection
	[2983] = true, -- Sprint
	[80353] = true, -- Time Warp
	[49016] = true, -- Unholy Frenzy
}

-- Debuffs healers don't want to see on raid frames

C["hideDebuffs"] = {
	[25771] = true, -- Forbearance
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
}

if select(2, UnitClass("player")) == "PRIEST" then C.hideDebuffs[6788] = false end

-- Buffs cast by the player that healers want to see on raid frames

C["myBuffs"] = {
	[774] = true, -- Rejuvenation
	[8936] = true, -- Regrowth
	[33763] = true, -- Lifebloom

	[33110] = true, -- Prayer of Mending
	[33076] = true, -- Prayer of Mending
	[41635] = true, -- Prayer of Mending
	[41637] = true, -- Prayer of Mending
	[139] = true, -- Renew
	[17] = true, -- Power Word: Shield

	[61295] = true, -- Riptide
	[974] = true, -- Earth Shield

	[53563] = true, -- Beacon of Light
	[114163] = true, -- Eternal Flame

	[119611] = true, -- Renewing Mist
	[116849] = true, -- Life Cocoon
	[124682] = true, -- Enveloping Mist
	[124081] = true, -- Zen Sphere
}

-- Buffs cast by anyone that healers want to see on raid frames

C["allBuffs"] = {
	[86657] = true, -- Ancient Guardian
	[47788] = true, -- Guardian Spirit
	[33206] = true, -- Pain Suppression
	[31850] = true, -- Ardent Defender
	[61336] = true, -- Survival Instincts
	[48792] = true, -- Icebound Fortitude
	[871] = true, -- Shield Wall

	[1022] = true, -- Hand of Protection
	[1038] = true, -- Hand of Salvation
	[6940] = true, -- Hand of Sacrifice
}