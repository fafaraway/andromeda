local F, C, L = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local oUF = F.oUF


function UNITFRAME:UpdateColor()

end

function UNITFRAME:PostUpdatePlates(event, unit)

end

local platesList = {}
local function CreateNameplateStyle(self)
	self.unitStyle = 'nameplate'
	--self:SetSize(FreeDB.unitframe.nameplate_width, FreeDB.unitframe.nameplate_height)
	self:SetSize(50, 4)
	self:SetPoint("CENTER")
	--self:SetScale(FreeADB['ui_scale'])

	local health = CreateFrame("StatusBar", nil, self)
	health:SetAllPoints()
	health:SetStatusBarTexture(C.Assets.norm_tex)
	health.backdrop = F.CreateBDFrame(health, nil, true)
	F:SmoothBar(health)

	self.Health = health
	self.Health.UpdateColor = UNITFRAME.UpdateColor


	platesList[self] = self:GetName()
end

function UNITFRAME:SpawnNameplate()


	oUF:RegisterStyle("Nameplate", CreateNameplateStyle)
	oUF:SetActiveStyle("Nameplate")
	oUF:SpawnNamePlates("oUF_Nameplate", UNITFRAME.PostUpdatePlates)

end


