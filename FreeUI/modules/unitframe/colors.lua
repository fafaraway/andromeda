local F, C = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local colors = F.oUF.colors


colors.health = {.02, .02, .02}
colors.disconnected = {.4, .4, .4}
colors.tapped = {.4, .4, .4}

colors.smooth = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
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

colors.runes = {
	[1] = {151/255, 25/255, 0}, -- Blood
	[2] = {193/255, 219/255, 233/255}, -- Frost
	[3] = {98/255, 153/255, 51/255}, -- Unholy
}


function UNITFRAME:SetColors()
	local classColor = FreeADB.class_colors
	local powerColor = FreeADB.power_colors

	colors.class = {
		['ROGUE'] = {
			classColor.ROGUE.r,
			classColor.ROGUE.g,
			classColor.ROGUE.b,
		},
		['DRUID'] = {
			classColor.DRUID.r,
			classColor.DRUID.g,
			classColor.DRUID.b,
		},
		['HUNTER'] = {
			classColor.HUNTER.r,
			classColor.HUNTER.g,
			classColor.HUNTER.b,
		},
		['MAGE'] = {
			classColor.MAGE.r,
			classColor.MAGE.g,
			classColor.MAGE.b,
		},
		['PALADIN'] = {
			classColor.PALADIN.r,
			classColor.PALADIN.g,
			classColor.PALADIN.b,
		},
		['PRIEST'] = {
			classColor.PRIEST.r,
			classColor.PRIEST.g,
			classColor.PRIEST.b,
		},
		['SHAMAN'] = {
			classColor.SHAMAN.r,
			classColor.SHAMAN.g,
			classColor.SHAMAN.b,
		},
		['WARLOCK'] = {
			classColor.WARLOCK.r,
			classColor.WARLOCK.g,
			classColor.WARLOCK.b,
		},
		['WARRIOR'] = {
			classColor.WARRIOR.r,
			classColor.WARRIOR.g,
			classColor.WARRIOR.b,
		},
		['DEATHKNIGHT'] = {
			classColor.DEATHKNIGHT.r,
			classColor.DEATHKNIGHT.g,
			classColor.DEATHKNIGHT.b,
		},
		['DEMONHUNTER'] = {
			classColor.DEMONHUNTER.r,
			classColor.DEMONHUNTER.g,
			classColor.DEMONHUNTER.b,
		},
		['MONK'] = {
			classColor.MONK.r,
			classColor.MONK.g,
			classColor.MONK.b,
		},
	}

	colors.power.MANA = {
		powerColor.MANA.r,
		powerColor.MANA.g,
		powerColor.MANA.b
	}

	colors.power.RAGE = {
		powerColor.RAGE.r,
		powerColor.RAGE.g,
		powerColor.RAGE.b
	}

	colors.power.FOCUS = {
		powerColor.FOCUS.r,
		powerColor.FOCUS.g,
		powerColor.FOCUS.b
	}

	colors.power.ENERGY = {
		powerColor.ENERGY.r,
		powerColor.ENERGY.g,
		powerColor.ENERGY.b
	}

	colors.power.RUNIC_POWER = {
		powerColor.RUNIC_POWER.r,
		powerColor.RUNIC_POWER.g,
		powerColor.RUNIC_POWER.b
	}

	colors.power.LUNAR_POWER = {
		powerColor.LUNAR_POWER.r,
		powerColor.LUNAR_POWER.g,
		powerColor.LUNAR_POWER.b
	}

	colors.power.MAELSTROM = {
		powerColor.MAELSTROM.r,
		powerColor.MAELSTROM.g,
		powerColor.MAELSTROM.b
	}

	colors.power.INSANITY = {
		powerColor.INSANITY.r,
		powerColor.INSANITY.g,
		powerColor.INSANITY.b
	}

	colors.power.FURY = {
		powerColor.FURY.r,
		powerColor.FURY.g,
		powerColor.FURY.b
	}

	colors.power.PAIN = {
		powerColor.PAIN.r,
		powerColor.PAIN.g,
		powerColor.PAIN.b
	}
end

