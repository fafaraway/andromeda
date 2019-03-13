local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe


function module:AddRangeCheck(self)
	if not cfg.spellRange then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = cfg.spellRangeAlpha
	}
end