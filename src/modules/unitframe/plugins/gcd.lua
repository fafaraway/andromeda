local F = unpack(select(2, ...))
local oUF = F.Libs.oUF

local function Update(self)
    local spark = self.spark
    local start, duration = GetSpellCooldown(61304)
    if start > 0 and duration > 0 then
        if self.duration ~= duration then
            self:SetMinMaxValues(0, duration)
            self.duration = duration
        end
        self:SetValue(GetTime() - start)

        if spark then
            self.spark:Show()
        end
    else
        if spark then
            self.spark:Hide()
        end
    end
end

local function Path(self, ...)
    return (self.GCD.Override or Update)(self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
    local element = self.GCD
    if element and UnitIsUnit(unit, 'player') then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        element:SetScript('OnUpdate', Update)

        if element:IsObjectType('StatusBar') and not element:GetStatusBarTexture() then
            element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
        end

        local spark = element.spark
        if spark and spark:IsObjectType('Texture') and not spark:GetTexture() then
            spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
        end

        element:Show()

        return true
    end
end

local function Disable(self)
    local element = self.GCD
    if element then
        element:Hide()
    end
end

oUF:AddElement('GCD', Path, Enable, Disable)
