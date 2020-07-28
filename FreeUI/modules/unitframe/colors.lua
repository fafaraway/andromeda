local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local colors = F.oUF.colors


colors.disconnected = {
	0.5, 0.5, 0.5
}

colors.reaction = {
	[1] = {1.00, 0.32, 0.29}, 	-- Hated
	[2] = {1.00, 0.32, 0.29}, 	-- Hostile
	[3] = {1.00, 0.32, 0.29}, 	-- Unfriendly
	[4] = {1.00, 0.93, 0.47}, 	-- Neutral
	[5] = {0.34, 1.00, 0.36}, 	-- Friendly
	[6] = {0.34, 1.00, 0.36}, 	-- Honored
	[7] = {0.34, 1.00, 0.36}, 	-- Revered
	[8] = {0.34, 1.00, 0.36}, 	-- Exalted
}

colors.debuffType = {
	['Curse']   = {0.8, 0, 1},
	['Disease'] = {0.8, 0.6, 0},
	['Magic']   = {0, 0.8, 1},
	['Poison']  = {0, 0.8, 0},
	['none']    = {0, 0, 0}
}

colors.power = {
	['MANA']              = {111/255, 185/255, 237/255},
	['INSANITY']          = {0.40, 0.00, 0.80},
	['MAELSTROM']         = {0.00, 0.50, 1.00},
	['LUNAR_POWER']       = {0.93, 0.51, 0.93},
	['HOLY_POWER']        = {0.95, 0.90, 0.60},
	['RAGE']              = {186/255, 20/255, 53/255},
	['FOCUS']             = {0.71, 0.43, 0.27},
	['ENERGY']            = {1, 222/255, 80/255},
	['CHI']               = {0.71, 1.00, 0.92},
	['RUNES']             = {0.55, 0.57, 0.61},
	['SOUL_SHARDS']       = {0.50, 0.32, 0.55},
	['FURY']              = {54/255, 199/255, 63/255},
	['PAIN']              = {255/255, 156/255, 0},
	['RUNIC_POWER']       = {0.00, 0.82, 1.00},
	['AMMOSLOT']          = {0.80, 0.60, 0.00},
	['FUEL']              = {0.00, 0.55, 0.50},
	['POWER_TYPE_STEAM']  = {0.55, 0.57, 0.61},
	['POWER_TYPE_PYRITE'] = {0.60, 0.09, 0.17},
	['ALTPOWER']          = {0.00, 1.00, 1.00},
}

colors.runes = {
	[1] = {151/255, 25/255, 0}, -- Blood
	[2] = {193/255, 219/255, 233/255}, -- Frost
	[3] = {98/255, 153/255, 51/255}, -- Unholy
}

--[[ colors.class = {
	ROGUE = {},
	DRUID = {},
	HUNTER = {},
	MAGE = {},
	PALADIN = {},
	PRIEST = {},
	SHAMAN = {},
	WARLOCK = {},
	WARRIOR = {},
	DEATHKNIGHT = {},
	DEMONHUNTER = {},
	MONK = {},
} ]]

