local F, C, L = unpack(select(2, ...))
local AURA = F:GetModule('Aura')


function AURA:UpdateAuraSource(...)
	local unitCaster = select(7, UnitAura(...))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F.HexRGB(F.UnitColor(unitCaster))

		if name then self:AddDoubleLine(L['AURA_CASTBY'], hexColor..name) end
		self:Show()
	end
end

function AURA:AddAuraSource()
	if not FreeUIConfigs['aura']['enable_aura'] then return end

	hooksecurefunc(GameTooltip, 'SetUnitAura', AURA.UpdateAuraSource)
end
