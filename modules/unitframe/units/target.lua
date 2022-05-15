local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigureTargetStyle(self)
    self.unitStyle = 'target'
    self:SetWidth(C.DB.Unitframe.TargetWidth)
    self:SetHeight(C.DB.Unitframe.TargetHealthHeight + C.DB.Unitframe.TargetPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateNameTag(self)
    UNITFRAME:CreateHealthTag(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnTarget()
    oUF:RegisterStyle('Target', ConfigureTargetStyle)
    oUF:SetActiveStyle('Target')

    local target = oUF:Spawn('target', 'oUF_Target')
    F.Mover(target, L['Target Frame'], 'TargetFrame', UNITFRAME.Positions.target, target:GetWidth(), target:GetHeight())
end
