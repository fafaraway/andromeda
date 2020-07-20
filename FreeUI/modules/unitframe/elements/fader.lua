local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddFader(self)
	if not cfg.fader then return end

	self.Fader = {
		[1] = {Combat = 1, Arena = 1, Instance = 1},
		[2] = {PlayerTarget = 1, PlayerFocus = 1, PlayerNotMaxHealth = 1, PlayerNotMaxMana = 1, PlayerCasting = 1},
		[3] = {Stealth = 0.5},
		[4] = {notCombat = 0, PlayerTaxi = 0},
	}

	self.NormalAlpha = 1
end