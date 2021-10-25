local F, C, L = unpack(select(2, ...))
local AURA = F:GetModule('Aura')
local oUF = F.Libs.oUF

local triggers = {
    SetUnitAura = UnitAura,
    SetUnitBuff = UnitBuff,
    SetUnitDebuff = UnitDebuff
}

local function AuraSource(self, func, unit, index, filter)
    local srcUnit = select(7, func(unit, index, filter))
    if srcUnit then
        local src = GetUnitName(srcUnit, true)
        if srcUnit == 'pet' or srcUnit == 'vehicle' then
            src = string.format('%s (|cff%02x%02x%02x%s|r)', src, C.r * 255, C.g * 255, C.b * 255, GetUnitName('player', true))
        else
            local partypet = srcUnit:match('^partypet(%d+)$')
            local raidpet = srcUnit:match('^raidpet(%d+)$')
            if partypet then
                src = string.format('%s (%s)', src, GetUnitName('party' .. partypet, true))
            elseif raidpet then
                src = string.format('%s (%s)', src, GetUnitName('raid' .. raidpet, true))
            end
        end
        if UnitIsPlayer(srcUnit) then
            local class = select(2, UnitClass(srcUnit))
            local r, g, b = F:ClassColor(class)
            if r then
                src = string.format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, src)
            end
        else
            local color = oUF.colors.reaction[UnitReaction(srcUnit, 'player')]
            if color then
                src = string.format('|cff%02x%02x%02x%s|r', color[1] * 255, color[2] * 255, color[3] * 255, src)
            end
        end
        self:AddDoubleLine(L['CastBy'] .. ': ', src)
        self:Show()
    end
end

function AURA:AddAuraSource()
    for k, v in pairs(triggers) do
        hooksecurefunc(
            _G.GameTooltip,
            k,
            function(self, unit, index, filter)
                AuraSource(self, v, unit, index, filter)
            end
        )
    end
end
