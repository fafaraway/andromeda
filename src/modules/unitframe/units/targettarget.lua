local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigureTargetTargetStyle(self)
    self.unitStyle = 'targettarget'
    self:SetWidth(C.DB.Unitframe.TargetTargetWidth)
    self:SetHeight(C.DB.Unitframe.TargetTargetHealthHeight + C.DB.Unitframe.TargetTargetPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameTag(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnTargetTarget()
    oUF:RegisterStyle('TargetTarget', ConfigureTargetTargetStyle)
    oUF:SetActiveStyle('TargetTarget')

    local targettarget = oUF:Spawn('targettarget', 'oUF_TargetTarget')
    F.Mover(
        targettarget,
        L['ToTFrame'],
        'ToTFrame',
        UNITFRAME.Positions.tot,
        targettarget:GetWidth(),
        targettarget:GetHeight()
    )
end
