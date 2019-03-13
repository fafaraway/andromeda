local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe

function module:AddDispel(self)
	if not cfg.dispellable then return end

	local dispellable = {}

	local texture = self.Health:CreateTexture(nil, 'OVERLAY')
	texture:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	texture:SetBlendMode('ADD')
	texture:SetVertexColor(1, 1, 1, 0)
	texture:SetTexCoord(0, 1, .5, 1)
	texture:SetAllPoints()
	dispellable.dispelTexture = texture

	self.Dispellable = dispellable
end