local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local function UpdateThreat(self, _, unit)
    if not self.shadow or self.unit ~= unit then
        return
    end

    local status = UnitThreatSituation(unit)
    if status and status > 0 then
        local r, g, b = GetThreatStatusColor(status)
        self.shadow:SetBackdropBorderColor(r, g, b, 0.6)
    else
        self.shadow:SetBackdropBorderColor(0, 0, 0, 0.35)
    end
end

function UNITFRAME:CreateThreatIndicator(self)
    if not C.DB.Unitframe.ThreatIndicator then
        return
    end

    self.ThreatIndicator = {
        IsObjectType = function() end,
        Override = UpdateThreat,
    }
end
