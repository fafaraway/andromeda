local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

--[[ Range check ]]

function UNITFRAME:AddRangeCheck(self)
    if not C.DB.Unitframe.RangeCheck then
        return
    end

    if not self.RangeCheck then
        self.RangeCheck = {}
    end

    self.RangeCheck.enabled = true
    self.RangeCheck.insideAlpha = 1
    self.RangeCheck.RangeCheckAlpha = .4
end
