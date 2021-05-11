local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

--[[ Debuff highlight ]]

function UNITFRAME:CreateDebuffHighlight(self)
    if not C.DB.Unitframe.DebuffHighlight then
        return
    end

    self.DebuffHighlight = self:CreateTexture(nil, 'OVERLAY')
    self.DebuffHighlight:SetAllPoints(self)
    self.DebuffHighlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
    self.DebuffHighlight:SetTexCoord(0, 1, .5, 1)
    self.DebuffHighlight:SetVertexColor(.6, .6, .6, 0)
    self.DebuffHighlight:SetBlendMode('ADD')
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = true
end
