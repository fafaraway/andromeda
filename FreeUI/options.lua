local F, C, L = unpack(select(2, ...))

local n = UnitName("player")
local lvl = UnitLevel("player")
local class = select(2, UnitClass("player"))
local realm = GetRealmName()

--[[ Global config ]]

C["general"] = {
	["auto_accept"] = true,			-- auto accept invites from friends and guildies
	["auto_loot_switch"] = true, 		-- auto toggle detailed loot rolls when entering/leaving LFR
	["autorepair"] = true,			-- automatically repair items
		["autorepair_guild"] = false,		-- use guild funds for auto repairs
	["autoroll"] = true, 			-- automatically DE or greed on BoE greens (DE priority)
	["autosell"] = true,			-- automatically sell greys
	["buffreminder"] = true, 		-- reminder for selfbuffs
	["helmcloakbuttons"] = true, 		-- show buttons to toggle helm/cloak on character frame
	["hotkey"] = false, 			-- show hot keys on buttons
	["interrupt"] = true,			-- announce your interrupts
	["rightbars_mouseover"] = false,	-- show right bars on mouseover (show/hide: use blizz option)
	["shapeshift"] = false,			-- enable shapeshift/stance bar
	["tolbarad"] = true,			-- Tol barad timer on the minimap
		["tolbarad_always"] = false,		-- show timer on non 85 characters as well
	["tooltip_cursor"] = false,		-- anchor the tooltip to the cursor
}

C["unitframes"] = {
	["arena_trinkets"] = true,				-- show enemy trinket usage on arena frames
	["cast"] = {"BOTTOM", UIParent, "CENTER", 0, -105}, 	-- only applies with 'castbar' set to 2
	["castbar"] = 1, 					-- 1 = dps/tank cast bar, 2 = caster/healer cast bar
	["healer_classcolours"] = false,			-- colour unitframes by class in healer layout
	["party_name_always"] = false,				-- show name on party/raid frames in dps/tank layout
	["pvp"] = true, 					-- show pvp icon on player frame

	["player"] = {"BOTTOM", UIParent, "CENTER", -275, -105},
	["target"] = {"TOP", UIParent, "CENTER", 0, -225},
	["target_heal"] = {"BOTTOM", UIParent, "CENTER", 280, -105}, 
	["party"] = {"TOP", UIParent, "CENTER", 0, -225}, 	-- only applies with healer layout enabled
	["raid"] = {"TOP", UIParent, "CENTER", 0, -190}, 	-- only applies with healer layout enabled

	["altpower_height"] = 1,
	["power_height"] = 1,

	["player_width"] = 229,
	["player_height"] = 14,
	["target_width"] = 229,
	["target_height"] = 14,
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
	["paladin"] = true, 		-- holy power
	["rogue"] = true,		-- poison reminder
	["rogue_checkthrown"] = false,	-- check thrown weapon for poison
	["shaman"] = true, 		-- totem bars and maelstrom weapon tracker
	["warlock"] = true, 		-- soul shards
}

-- lower = smoother = more CPU usage

C["performance"] = {
	["bubbles"] = .1, 	-- update interval for chat bubbles in seconds (always)
	["mapcoords"] = .1, 	-- update interval for map coords in seconds (only with map open)
	["nameplates"] = .1, 	-- update interval for nameplates in seconds (always)
	["namethreat"] = .2, 	-- update interval for nameplates threat in seconds (only with nameplates shown)
	["tolbarad"] = 10, 	-- update interval for TB timer in seconds (always)
}

-- [[ Profiles ]]

if lvl ~= 85 then
	C.general.autoroll = false
end

if realm == "Steamwheedle Cartel" then
	C.general.tolbarad_always = true
	C.general.autorepair_guild = true
end

if class == "MAGE" or class == "PRIEST" or class == "WARLOCK" then
	C.unitframes.castbar = 2
end

-- Selfbuff reminder
C["selfbuffs"] = {
	HUNTER = {
		13165, -- hawk
		5118, -- cheetah
		13159, -- pack
		20043, -- wild
		82661, -- fox
	},
	PALADIN = {
		31801, -- seal of truth
		20154, -- seal of righteousness
		20165, -- seal of insight
		20164, -- seal of justice
	},
	PRIEST = {
		588, -- inner fire
		73413, -- inner will
	},
	MAGE = {
		7302, -- frost armor
		6117, -- mage armor
		30482, -- molten armor
	},
	WARLOCK = {
		28176, -- fel armor
		687, -- demon armor
	},
	SHAMAN = {
		52127, -- water shield
		324, -- lightning shield
		974, -- earth shield
	},
	DEATHKNIGHT = {
		57330, -- horn of winter
		31634, -- strength of earth
		6673, -- battle shout
		93435, -- roar of courage
	},
}

-- sFilter buff tracker
C["sfilter"] = {
	["PALADIN"] = {
	-- Divine Plea
	{spellId = 54428, size = 39, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 95, -163}},
	-- Divine Shield, Hand of Protection, Divine Protection, Avenging Wrath, Zealotry
	{spellId = 642, spellId2 = 1022, spellId3 = 498, spellId4 = 31884, spellId5 = 85696, size = 39, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 0, -163}},
	-- Inquisition
	{spellId = 84963, size = 39, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -95, -163}},
	-- Judgements of the Pure
	{spellId = 53657, size = 39, unitId = "player", isMine = 1, filter = "HELPFUL", spec = 1, setPoint = {"CENTER", UIParent, "CENTER", -95, -163}},
	},
	["ROGUE"] = {
	-- Bandit's Guile
	{spellId = 84745, spellId2 = 84746, spellId3 = 84747, size = 39, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 95, -163}},
	-- Recuperate
	{spellId = 73651, size = 39, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 95, -163}},
	-- Slice and dice
	{spellId = 5171, size = 39, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -95, -163}},
	},
}

-- [[ Filters ]]

-- Debuffs by other players you want to show on the target frame

C["debuffFilter"] = {
	[58567] = true, -- Sunder Armor
	[8647] = true, -- Expose Armor
	[91565] = true, -- Faerie Fire
	[95466] = true, -- Corrosive Spit
	[95467] = true, -- Tear Armor
	
	[6343] = true, -- Thunder Clap
	[54404] = true, -- Dust Cloud
	[90315] = true, -- Tailspin
	[8042] = true, -- Earth Shock
	[58179] = true, -- Infected Wounds 1
	[58180] = true, -- Infected Wounds 2
	[53696] = true, -- Judgements of the Just
	[51693] = true, -- Waylay
	[55095] = true, -- Frost Fever
	
	[702] = true, -- Curse of Weakness
	[1160] = true, -- Demoralizing Shout
	[99] = true, -- Demoralizing Roar
	[50256] = true, -- Demoralizing Roar (pet)
	[24423] = true, -- Demoralizing Screech
	[81132] = true, -- Scarlet Fever
	[26017] = true, -- Vindication
	
	[118] = true, -- Polymorph (sheep)
	[61305] = true, -- Polymorph (black cat)
	[28272] = true, -- Polymorph (pig)
	[61721] = true, -- Polymorph (rabbit)
	[28271] = true, -- Polymorph (turtle)
	[2094] = true, -- Blind
	[6770] = true, -- Sap
	[408] = true, -- Kidney Shot
	[1833] = true, -- Cheap Shot
	[5211] = true, -- Bash
	[853] = true, -- Hammer of Justice
	[20066] = true, -- Repentance
	[47476] = true, -- Strangulate
	[9484] = true, -- Shackle Undead
	[339] = true, -- Entangling Roots
	[33786] = true, -- Cyclone
	[2637] = true, -- Hibernate
	[710] = true, -- Banish
	[19386] = true, -- Wyvern Sting
	[51514] = true, -- Hex
	[355] = true, -- Taunt
	[1161] = true, -- Challenging Shout
	[21008] = true, -- Mocking Blow
	[62124] = true, -- Hand of Reckoning
	[49576] = true, -- Death Grip
	[56222] = true, -- Dark Command
	[6795] = true, -- Growl
	[5209] = true, -- Challenging Roar
	[76780] = true, -- Bind Elemental
	[5782] = true, -- Fear
	[1499] = true, -- Freezing Trap (1?)
	[3355] = true, -- Freezing Trap (2?)
	[6358] = true, -- Seduction
	[10326] = true, -- Turn Evil
	[90933] = true, -- Ragezone
	[97170] = true, -- Deadzone (1)
	[97600] = true, -- Deadzone (2)
	[103527] = true, -- Void Diffusion (test)
}

-- Buffs to show on enemy players

C["dangerousBuffs"] = {
	[13750] = true, -- Adrenaline Rush
	[23335] = true, -- Alliance Flag
	[86150] = true, -- Guardian of Ancient Kings
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
	[70940] = true, -- Divine Guardian
	[498] = true, -- Divine Protection
	[642] = true, -- Divine Shield
	[5277] = true, -- Evasion
	[47788] = true, -- Guardian Spirit
	[1022] = true, -- Hand of Protection
	[32182] = true, -- Heroism
	[23333] = true, -- Horde Flag
	[11426] = true, -- Ice Barrier
	[45438] = true, -- Ice Block
	[48792] = true, -- Icebound Fortitude
	[29166] = true, -- Innervate
	[66] = true, -- Invisibility
	[12975] = true, -- Last Stand
	[543] = true, -- Mage Ward
	[1463] = true, -- Mana Shield
	[59672] = true, -- Metamorphosis
	[33206] = true, -- Pain Suppression
	[10060] = true, -- Power Infusion
	[17] = true, -- Power Word: Shield
	[15473] = true, -- Shadowform
	[871] = true, -- Shield Wall
	[23920] = true, -- Spell Reflection
	[2983] = true, -- Sprint
	[80353] = true, -- Time Warp
	[49016] = true, -- Unholy Frenzy
	[85696] = true, -- Zealotry
	[96266] = true, -- Strength of Soul
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

if class == "PRIEST" then C.hideDebuffs[6788] = false end

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
	[16236] = true, -- Ancestral Fortitude
	[974] = true, -- Earth Shield

	[53563] = true, -- Beacon of Light
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