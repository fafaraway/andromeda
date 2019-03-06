local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module = F:GetModule("Unitframe")
local oUF = ns.oUF

oUF.colors.power.MANA = {100/255, 149/255, 237/255}
oUF.colors.power.ENERGY = {1, 222/255, 80/255}
oUF.colors.power.FURY = { 54/255, 199/255, 63/255 }
oUF.colors.power.PAIN = { 255/255, 156/255, 0 }

oUF.colors.runes = {
	{151/255, 25/255, 0}, 			-- Blood
	{193/255, 219/255, 233/255}, 	-- Frost
	{98/255, 153/255, 51/255}, 		-- Unholy
}

oUF.colors.debuffType = {
	Curse = {.8, 0, 1},
	Disease = {.8, .6, 0},
	Magic = {0, .8, 1},
	Poison = {0, .8, 0},
	none = {0, 0, 0}
}

oUF.colors.reaction = {
	[1] = {139/255, 39/255, 60/255}, 	-- Exceptionally hostile
	[2] = {217/255, 51/255, 22/255}, 	-- Very Hostile
	[3] = {231/255, 87/255, 83/255}, 	-- Hostile
	[4] = {213/255, 201/255, 128/255}, 	-- Neutral
	[5] = {184/255, 243/255, 147/255}, 	-- Friendly
	[6] = {115/255, 231/255, 62/255}, 	-- Very Friendly
	[7] = {107/255, 231/255, 157/255}, 	-- Exceptionally friendly
	[8] = {44/255, 153/255, 111/255}, 	-- Exalted
}