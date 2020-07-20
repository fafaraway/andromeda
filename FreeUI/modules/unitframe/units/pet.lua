local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function CreatePetStyle(self)
	self.unitStyle = 'pet'
	self:SetSize(cfg.pet_width, cfg.pet_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddFader(self)
end

function UNITFRAME:SpawnPet()
	F.oUF:RegisterStyle('Pet', CreatePetStyle)
	F.oUF:SetActiveStyle('Pet')

	local pet = F.oUF:Spawn('pet', 'oUF_Pet')

	F.Mover(pet, L['MOVER_UNITFRAME_PET'], 'PetFrame', {'RIGHT', 'oUF_Player', 'LEFT', -6, 0}, pet:GetWidth(), pet:GetHeight())
end