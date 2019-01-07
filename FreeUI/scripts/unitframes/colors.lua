local F, C, L = unpack(select(2, ...))
if not C.unitframes.enable then return end
local module = F:GetModule("unitframe")
local oUF = FreeUI.oUF

oUF.colors.power.MANA = {100/255, 149/255, 237/255}
oUF.colors.power.ENERGY = {1, 222/255, 80/255}
oUF.colors.power.FURY = { 54/255, 199/255, 63/255 }
oUF.colors.power.PAIN = { 255/255, 156/255, 0 }

oUF.colors.debuffType = {
	Curse = {.8, 0, 1},
	Disease = {.8, .6, 0},
	Magic = {0, .8, 1},
	Poison = {0, .8, 0},
	none = {0, 0, 0}
}