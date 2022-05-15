local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigureFocusTargetStyle(self)
    self.unitStyle = 'focustarget'
    self:SetWidth(C.DB.Unitframe.FocusTargetWidth)
    self:SetHeight(C.DB.Unitframe.FocusTargetHealthHeight + C.DB.Unitframe.FocusTargetPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameTag(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateAuras(self)
end

function UNITFRAME:SpawnFocusTarget()
    oUF:RegisterStyle('FocusTarget', ConfigureFocusTargetStyle)
    oUF:SetActiveStyle('FocusTarget')

    local focustarget = oUF:Spawn('focustarget', 'oUF_FocusTarget')
    F.Mover(
        focustarget,
        L['Target of Focus Frame'],
        'FocusTargetFrame',
        UNITFRAME.Positions.tof,
        focustarget:GetWidth(),
        focustarget:GetHeight()
    )
end
