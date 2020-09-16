local F, C = unpack(select(2, ...))
local COLORS = F.COLORS
local oUF = F.oUF


oUF.colors.health = {.02, .02, .02}
oUF.colors.disconnected = {.4, .4, .4}
oUF.colors.tapped = {.6, .6, .6}

oUF.colors.smooth = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}

oUF.colors.debuffType = {
	['Curse']   = {0.8, 0, 1},
	['Disease'] = {0.8, 0.6, 0},
	['Magic']   = {0, 0.8, 1},
	['Poison']  = {0, 0.8, 0},
	['none']    = {0, 0, 0}
}

oUF.colors.runes = {
	[1] = {151/255, 25/255, 0}, -- Blood
	[2] = {193/255, 219/255, 233/255}, -- Frost
	[3] = {98/255, 153/255, 51/255}, -- Unholy
}


function COLORS:UpdateColors()
	local classColor = FreeADB.colors.class
	local powerColor = FreeADB.colors.power
	local reactionColor = FreeADB.colors.reaction

	oUF.colors.class = {
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

	oUF.colors.power.MANA = {
		powerColor.MANA.r,
		powerColor.MANA.g,
		powerColor.MANA.b
	}

	oUF.colors.power.RAGE = {
		powerColor.RAGE.r,
		powerColor.RAGE.g,
		powerColor.RAGE.b
	}

	oUF.colors.power.FOCUS = {
		powerColor.FOCUS.r,
		powerColor.FOCUS.g,
		powerColor.FOCUS.b
	}

	oUF.colors.power.ENERGY = {
		powerColor.ENERGY.r,
		powerColor.ENERGY.g,
		powerColor.ENERGY.b
	}

	oUF.colors.power.RUNIC_POWER = {
		powerColor.RUNIC_POWER.r,
		powerColor.RUNIC_POWER.g,
		powerColor.RUNIC_POWER.b
	}

	oUF.colors.power.LUNAR_POWER = {
		powerColor.LUNAR_POWER.r,
		powerColor.LUNAR_POWER.g,
		powerColor.LUNAR_POWER.b
	}

	oUF.colors.power.MAELSTROM = {
		powerColor.MAELSTROM.r,
		powerColor.MAELSTROM.g,
		powerColor.MAELSTROM.b
	}

	oUF.colors.power.INSANITY = {
		powerColor.INSANITY.r,
		powerColor.INSANITY.g,
		powerColor.INSANITY.b
	}

	oUF.colors.power.FURY = {
		powerColor.FURY.r,
		powerColor.FURY.g,
		powerColor.FURY.b
	}

	oUF.colors.power.PAIN = {
		powerColor.PAIN.r,
		powerColor.PAIN.g,
		powerColor.PAIN.b
	}

	oUF.colors.reaction = {
		[1] = {reactionColor.hostile.r, reactionColor.hostile.g, reactionColor.hostile.b},
		[2] = {reactionColor.hostile.r, reactionColor.hostile.g, reactionColor.hostile.b},
		[3] = {reactionColor.hostile.r, reactionColor.hostile.g, reactionColor.hostile.b},
		[4] = {reactionColor.neutral.r, reactionColor.neutral.g, reactionColor.neutral.b},
		[5] = {reactionColor.friendly.r, reactionColor.friendly.g, reactionColor.friendly.b},
		[6] = {reactionColor.friendly.r, reactionColor.friendly.g, reactionColor.friendly.b},
		[7] = {reactionColor.friendly.r, reactionColor.friendly.g, reactionColor.friendly.b},
		[8] = {reactionColor.friendly.r, reactionColor.friendly.g, reactionColor.friendly.b},
	}
end


function COLORS:OnLogin()
	COLORS:UpdateColors()
end
