local F, C, L = unpack(select(2, ...))
local _, ns = ...
if not C.unitframe.enable then return end
local tags = ns.oUF.Tags
local cfg = C.unitframe
local module = F:GetModule("Unitframe")

-- Short values
local siValue = function(val)
	if(val >= 1e6) then
		return format("%.2fm", val * 0.000001)
	elseif(val >= 1e4) then
		return format("%.1fk", val * 0.001)
	else
		return val
	end
end

local function hex(r, g, b)
	if not r then return '|cffFFFFFF' end
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

-- Tags
tags.Methods['free:playerHealth'] = function(unit)
	if UnitIsDead(unit) or UnitIsGhost(unit) then return end
	return siValue(UnitHealth(unit))
end
tags.Events['free:playerHealth'] = tags.Events.missinghp

tags.Methods['free:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	return format("|cffffffff%s|r %.0f", siValue(min), (min/max)*100)
end
tags.Events['free:health'] = tags.Events.missinghp

-- classification
tags.Methods["free:classification"] = function(unit)
	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	if(c == 'worldboss' or l == -1) then
		return '|cff9D2933{B}|r '
	elseif(c == 'rare') then
		return '|cffFF99FF{R}|r '
	elseif(c == 'rareelite') then
		return '|cffFF0099{R+}|r '
	elseif(c == 'elite') then
		return '|cffCC3300{E}|r '
	end
end
tags.Events["free:classification"] = "UNIT_CLASSIFICATION_CHANGED"

-- boss health requires frequent updates to work
tags.Methods['free:bosshealth'] = function(unit)
	local val = tags.Methods['free:health'](unit)
	return val or ""
end
tags.Events['free:bosshealth'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_TARGETABLE_CHANGED"

-- utf8 short string
local function usub(str, len)
	local i = 1
	local n = 0
	while true do
		local b,e = string.find(str, "([%z\1-\127\194-\244][\128-\191]*)", i)
		if(b == nil) then
			return str
		end
		i = e + 1
		n = n + 1
		if(n > len) then
			local r = string.sub(str, 1, b-1)
			return r
		end
	end
end

local function getSummary(str)
	local t = string.gsub(str, "<.->", "")
	return usub(t, 100, "...")
end

local function shortName(unit, len)
	local name = UnitName(unit)
	if name and name:len() > len then name = usub(name, len) end

	return name
end

tags.Methods['free:partytext'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	if not UnitIsConnected(unit) then
		return "|cffdbdbdbOff|r"
	elseif UnitIsDead(unit) then
		return "|cffd52732Dead|r"
	elseif UnitIsGhost(unit) then
		return "|cff8850d5Ghost|r"
	elseif cfg.partyMissingHealth and min ~= max then
		return siValue(max-min)
	end
end
tags.Events['free:partytext'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_POWER_UPDATE UNIT_CONNECTION'


tags.Methods['free:partyname'] = function(unit)
	if UnitInRaid('player') then
		return shortName(unit, 2)
	else
		return shortName(unit, 4)
	end
end
tags.Events['free:partyname'] = 'UNIT_NAME_UPDATE GROUP_ROSTER_UPDATE PLAYER_ENTERING_WORLD'


tags.Methods['free:power'] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if(min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	return siValue(min)
end
tags.Events['free:power'] = tags.Events.missingpp


-- Alt Power value tag
tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return ("%s%%"):format(math.floor(cur/max*100 + .5))
	end
end
tags.Events["altpower"] = "UNIT_POWER_UPDATE"