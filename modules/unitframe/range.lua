local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

function UNITFRAME:CreateRangeCheck(self)
    if not C.DB.Unitframe.RangeCheck then
        return
    end

    if not self.RangeCheck then
        self.RangeCheck = {}
    end

    self.RangeCheck.enabled = true
    self.RangeCheck.insideAlpha = 1
    self.RangeCheck.RangeCheckAlpha = .3
end
