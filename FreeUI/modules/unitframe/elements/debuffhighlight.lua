local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddDebuffHighlight(self)
	if not cfg.debuff_highlight then return end

	self.DebuffHighlight = self:CreateTexture(nil, "OVERLAY")
    self.DebuffHighlight:SetAllPoints(self)
    self.DebuffHighlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
    self.DebuffHighlight:SetTexCoord(0, 1, .5, 1)
    self.DebuffHighlight:SetVertexColor(.6, .6, .6, 0)
    self.DebuffHighlight:SetBlendMode("ADD")
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = true
end