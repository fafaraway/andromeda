local _G = _G
local unpack = unpack
local select = select
local UnitThreatSituation = UnitThreatSituation
local GetThreatStatusColor = GetThreatStatusColor

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local function UpdateThreat(self, event, unit)
    if not self.Glow or self.unit ~= unit then
        return
    end

    local status = UnitThreatSituation(unit)
    if status and status > 0 then
        local r, g, b = GetThreatStatusColor(status)
        self.Glow:SetBackdropBorderColor(r, g, b, .6)
    else
        self.Glow:SetBackdropBorderColor(0, 0, 0, .35)
    end
end

function UNITFRAME:CreateThreatIndicator(self)
    if not C.DB.Unitframe.ThreatIndicator then
        return
    end

    self.ThreatIndicator = {
        IsObjectType = function()
        end,
        Override = UpdateThreat,
    }
end
