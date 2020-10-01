local F, C = unpack(select(2, ...))
local COLORS = F.COLORS
local oUF = F.oUF


local function SetDebuffTypeColors()
	oUF.colors.debuff = {
		['Curse']   = {0.8, 0, 1},
		['Disease'] = {0.8, 0.6, 0},
		['Magic']   = {0, 0.8, 1},
		['Poison']  = {0, 0.8, 0},
		['none']    = {0, 0, 0}
	}
end

local function SetClassColors()
	local colors = FreeADB.colors.class

	for class, value in pairs(colors) do
		oUF.colors.class[class] = {value.r, value.g, value.b}
	end
end

local function SetPowerColors()
	local colors = FreeADB.colors.power

	for type, value in pairs(colors) do
		oUF.colors.power[type] = {value.r, value.g, value.b}
	end
end

local function SetClassPowerColors()
	local colors = FreeADB.colors.class_power

	for type, value in pairs(colors) do
		oUF.colors.power[type] = {value.r, value.g, value.b}
	end
end

local function SetRuneColors()
	local colors = FreeADB.colors.dk_rune

	oUF.colors.runes = {
		{colors.blood.r, colors.blood.g, colors.blood.b},
		{colors.frost.r, colors.frost.g, colors.frost.b},
		{colors.unholy.r, colors.unholy.g, colors.unholy.b},
	}
end

local function SetReactionColors()
	local color = FreeADB.colors.reaction

	oUF.colors.reaction = {
		[1] = {color.hostile.r, color.hostile.g, color.hostile.b},
		[2] = {color.hostile.r, color.hostile.g, color.hostile.b},
		[3] = {color.hostile.r, color.hostile.g, color.hostile.b},
		[4] = {color.neutral.r, color.neutral.g, color.neutral.b},
		[5] = {color.friendly.r, color.friendly.g, color.friendly.b},
		[6] = {color.friendly.r, color.friendly.g, color.friendly.b},
		[7] = {color.friendly.r, color.friendly.g, color.friendly.b},
		[8] = {color.friendly.r, color.friendly.g, color.friendly.b},
	}
end

function COLORS:UpdateColors()
	SetClassColors()
	SetPowerColors()
	SetClassPowerColors()
	SetRuneColors()
	SetReactionColors()
end


function COLORS:OnLogin()
	SetDebuffTypeColors()
	SetClassColors()
	SetPowerColors()
	SetClassPowerColors()
	SetRuneColors()
	SetReactionColors()
end
