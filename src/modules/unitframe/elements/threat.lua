local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local function UpdateThreatBorder(self, _, unit)
    if not self.__sd or self.unit ~= unit then
        return
    end

    local status = UnitThreatSituation(unit)
    if status and status > 0 then
        local r, g, b = GetThreatStatusColor(status)
        self.__sd:SetBackdropBorderColor(r, g, b, 0.6)
    else
        self.__sd:SetBackdropBorderColor(0, 0, 0, 0.35)
    end
end

function UNITFRAME:CreateThreatBorder(self)
    if not C.DB.Unitframe.ThreatIndicator then
        return
    end

    self.ThreatIndicator = {
        IsObjectType = function() end,
        Override = UpdateThreatBorder,
    }
end
