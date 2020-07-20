local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddRangeCheck(self)
	if not cfg.range_check then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = 0.5
	}
end
