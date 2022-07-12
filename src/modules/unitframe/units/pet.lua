local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigurePetStyle(self)
    self.unitStyle = 'pet'
    self:SetWidth(C.DB.Unitframe.PetWidth)
    self:SetHeight(C.DB.Unitframe.PetHealthHeight + C.DB.Unitframe.PetPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
end

function UNITFRAME:SpawnPet()
    oUF:RegisterStyle('Pet', ConfigurePetStyle)
    oUF:SetActiveStyle('Pet')

    local pet = oUF:Spawn('pet', 'oUF_Pet')
    F.Mover(pet, L['PetFrame'], 'PetFrame', UNITFRAME.Positions.pet, pet:GetWidth(), pet:GetHeight())
end
