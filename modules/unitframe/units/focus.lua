local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigureFocusStyle(self)
    self.unitStyle = 'focus'
    self:SetWidth(C.DB.Unitframe.FocusWidth)
    self:SetHeight(C.DB.Unitframe.FocusHealthHeight + C.DB.Unitframe.FocusPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameTag(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnFocus()
    oUF:RegisterStyle('Focus', ConfigureFocusStyle)
    oUF:SetActiveStyle('Focus')

    local focus = oUF:Spawn('focus', 'oUF_Focus')
    F.Mover(focus, L['Focus Frame'], 'FocusFrame', UNITFRAME.Positions.focus, focus:GetWidth(), focus:GetHeight())
end
