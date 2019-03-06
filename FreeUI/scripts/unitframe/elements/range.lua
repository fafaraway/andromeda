local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe


function module:AddRangeCheck(self)
	if not cfg.spellRange then return end

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = cfg.spellRangeAlpha
	}
end