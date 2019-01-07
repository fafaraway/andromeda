local F, C, L = unpack(select(2, ...))
if not C.auras.enable then return end
local module = F:GetModule("auras")

local function SetCaster(self, unit, index, filter)
	local unitCaster = select(7, UnitAura(unit, index, filter))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F.HexRGB(F.UnitColor(unitCaster))
		self:AddDoubleLine(L["Castby"]..":", hexColor..name)
		self:Show()
	end
end

if C.auras.auraSource then
	hooksecurefunc(GameTooltip, "SetUnitAura", SetCaster)
end