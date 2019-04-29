local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe


function module:AddFCT(self)
	if not C.unitframe.fct then return end

	local parentFrame = CreateFrame('Frame', nil, UIParent)
	local fct = CreateFrame('Frame', 'oUF_CombatTextFrame', parentFrame)

	fct:SetSize(32, 32)

	if self.unitStyle == 'player' then
		F.Mover(fct, 'PlayerCombatText', 'PlayerCombatText', {'BOTTOM', self, 'TOPLEFT', 0, 120})
	else
		F.Mover(fct, 'TargetCombatText', 'TargetCombatText', {'BOTTOM', self, 'TOPRIGHT', 0, 120})
	end

	for i = 1, 36 do
		fct[i] = parentFrame:CreateFontString('$parentText', 'OVERLAY')
		fct[i]:SetShadowColor(0, 0, 0)
		fct[i]:SetShadowOffset(2, -2)
	end

	fct.font = C.font.normal
	fct.fontFlags = nil
	fct.showPets = cfg.fct_Pet
	fct.showHots = cfg.fct_HotsandDots
	fct.showAutoAttack = cfg.fct_AutoAttack
	fct.showOverHealing = cfg.fct_OverHealing
	fct.abbreviateNumbers = cfg.fct_AbbreviateNumbers

	self.FloatingCombatFeedback = fct

	SetCVar('enableFloatingCombatText', 0)
	F.HideOption(InterfaceOptionsCombatPanelEnableFloatingCombatText)
end