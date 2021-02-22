local _G = _G
local format = format
local select = select
local floor = floor
local unpack = unpack
local select = select
local strfind = strfind
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitClass = UnitClass
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPVP = UnitIsPVP
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitReaction = UnitReaction
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitStagger = UnitStagger
local UnitIsUnit = UnitIsUnit
local UnitInRaid = UnitInRaid
local UnitExists = UnitExists
local UnitClassification = UnitClassification
local UnitSelectionColor = UnitSelectionColor
local IsResting = IsResting
local GetCVarBool = GetCVarBool
local ALTERNATE_POWER_INDEX = Enum.PowerType.Alternate
local YOU = YOU
local BOSS = BOSS
local RARE = RARE
local RAREELITE = RAREELITE
local ELITE = ELITE
local LEVEL = LEVEL

local F, C = unpack(select(2, ...))
local OUF = F.OUF

local tags = OUF.Tags.Methods
local tagEvents = OUF.Tags.Events

local function usub(str, len)
    local i = 1
    local n = 0
    while true do
        local b, e = string.find(str, '([%z\1-\127\194-\244][\128-\191]*)', i)
        if (b == nil) then
            return str
        end
        i = e + 1
        n = n + 1
        if (n > len) then
            local r = string.sub(str, 1, b - 1)
            return r
        end
    end
end

local function shortenName(unit, len)
    if not UnitIsConnected(unit) then
        return
    end

    local name = UnitName(unit)
    if name and name:len() > len then
        name = usub(name, len)
    end

    return name
end

local function AbbrName(str)
    if not C.DB.unitframe.abbr_name then
        return
    end

    return str:sub(1, 1) .. '.'
end

tags['free:health'] = function(unit)
    if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        return
    end

    local cur = UnitHealth(unit)
    local r, g, b = unpack(OUF.colors.reaction[UnitReaction(unit, 'player') or 5])

    return format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, F.Numb(cur))
end
tagEvents['free:health'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'

tags['free:healthpercentage'] = function(unit)
    if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        return
    end

    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    local r, g, b = F.ColorGradient(cur / max, unpack(OUF.colors.smooth))
    r, g, b = r * 255, g * 255, b * 255

    if cur ~= max then
        return format('|cff%02x%02x%02x%d%%|r', r, g, b, floor(cur / max * 100 + 0.5))
    end
end
tagEvents['free:healthpercentage'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'

tags['free:power'] = function(unit)
    local cur, max = UnitPower(unit), UnitPowerMax(unit)
    if (cur == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then
        return
    end

    return F.Numb(cur)
end
tagEvents['free:power'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'

tags['free:stagger'] = function(unit)
    if unit ~= 'player' then
        return
    end

    local cur = UnitStagger(unit) or 0
    local perc = cur / UnitHealthMax(unit)

    if cur == 0 then
        return
    end

    return F.Numb(cur) .. ' / ' .. C.MyColor .. floor(perc * 100 + .5) .. '%'
end
tagEvents['free:stagger'] = 'UNIT_MAXHEALTH UNIT_AURA'

tags['free:dead'] = function(unit)
    if UnitIsDead(unit) then
        return '|cffd84343' .. 'Dead'
    elseif UnitIsGhost(unit) then
        return '|cffbd69be' .. 'Ghost'
    end
end
tagEvents['free:dead'] = 'UNIT_HEALTH'

tags['free:offline'] = function(unit)
    if not UnitIsConnected(unit) then
        return '|cffcccccc' .. 'Off'
    end
end
tagEvents['free:offline'] = 'UNIT_HEALTH UNIT_CONNECTION'

tags['free:title'] = function(unit)
    if UnitIsPlayer(unit) then
        return
    end

    F.ScanTip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
    F.ScanTip:SetUnit(unit)

    local title =
        _G[format('FreeUI_ScanTooltipTextLeft%d', GetCVarBool('colorblindmode') and 3 or 2)]:GetText()
    if title and not strfind(title, '^' .. LEVEL) then
        return title
    end
end
tagEvents['free:title'] = 'UNIT_NAME_UPDATE'

tags['free:color'] = function(unit)
    local class = select(2, UnitClass(unit))
    local r, g, b = UnitSelectionColor(unit, true)

    if UnitIsTapDenied(unit) then
        return F.RGBToHex(OUF.colors.tapped)
    elseif UnitIsPlayer(unit) then
        return F.RGBToHex(OUF.colors.class[class])
    elseif r then
        return F.RGBToHex(r, g, b)
    else
        return F.RGBToHex(1, 1, 1)
    end
end
tagEvents['free:color'] =
    'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED'

tags['free:name'] = function(unit)
    local name = UnitName(unit)

    if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or
        (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
        return C.RedColor .. '<' .. YOU .. '>'
    else
        if name then -- 名字里有中文字符但没有对应中文字体的情况下会返回nil
            return (name:gsub('(%S+) ', AbbrName))
        end
    end
end
tagEvents['free:name'] = 'UNIT_NAME_UPDATE UNIT_TARGET PLAYER_TARGET_CHANGED PLAYER_FOCUS_CHANGED'

tags['free:groupname'] = function(unit)
    if C.DB.unitframe.group_names then
        if UnitInRaid('player') then
            return shortenName(unit, C.isCNPortal and 2 or 4)
        else
            return shortenName(unit, 4)
        end
    else
        return ''
    end
end
tagEvents['free:groupname'] = 'UNIT_HEALTH GROUP_ROSTER_UPDATE UNIT_CONNECTION'

tags['free:resting'] = function(unit)
    if (unit == 'player' and IsResting()) then
        return '|cff2C8D51Zzz|r'
    end
end
tagEvents['free:resting'] = 'PLAYER_UPDATE_RESTING'

tags['free:classification'] = function(unit)
    local class, level = UnitClassification(unit), UnitLevel(unit)
    if (class == 'worldboss' or level == -1) then
        return '|cff9D2933' .. BOSS .. '|r'
    elseif (class == 'rare') then
        return '|cffFF99FF' .. RARE .. '|r'
    elseif (class == 'rareelite') then
        return '|cffFF0099' .. RAREELITE .. '|r'
    elseif (class == 'elite') then
        return '|cffCC3300' .. ELITE .. '|r'
    else
        return ''
    end
end
tagEvents['free:classification'] = 'UNIT_CLASSIFICATION_CHANGED'

tags['free:pvp'] = function(unit)
    if UnitIsPVP(unit) then
        return '|cffCC3300P|r'
    end
end
tagEvents['free:pvp'] = 'UNIT_FACTION'

tags['free:altpower'] = function(unit)
    local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
    if max > 0 and not UnitIsDeadOrGhost(unit) then
        return ('%s%%'):format(floor(cur / max * 100 + .5))
    end
end
tagEvents['free:altpower'] = 'UNIT_POWER_UPDATE'

tags['free:tarname'] = function(unit)
    local tarUnit = unit .. 'target'
    if UnitExists(tarUnit) then
        local tarClass = select(2, UnitClass(tarUnit))
        return F.RGBToHex(OUF.colors.class[tarClass]) .. UnitName(tarUnit)
    end
end
tagEvents['free:tarname'] = 'UNIT_NAME_UPDATE UNIT_THREAT_SITUATION_UPDATE UNIT_HEALTH'
