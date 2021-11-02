local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:CreateRangeCheck(self)
    self.RangeCheck = {
        enabled = C.DB.Unitframe.RangeCheck,
        insideAlpha = 1,
        outsideAlpha = C.DB.Unitframe.OutRangeAlpha,
    }
end
