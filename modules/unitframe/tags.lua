local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UNITFRAME')
local oUF = F.oUF

local tags = oUF.Tags.Methods
local tagEvents = oUF.Tags.Events

local function usub(str, len)
	local i = 1
	local n = 0
	while true do
		local b, e = string.find(str, '([%z\1-\127\194-\244][\128-\191]*)', i)
		if (b == nil) then return str end
		i = e + 1
		n = n + 1
		if (n > len) then
			local r = string.sub(str, 1, b - 1)
			return r
		end
	end
end

local function shortenName(unit, len)
	if not UnitIsConnected(unit) then return end

	local name = UnitName(unit)
	if name and name:len() > len then name = usub(name, len) end

	return name
end

local function AbbrName(str) return str:sub(1, 1) .. '.' end

tags['free:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		return
	end

	local cur = UnitHealth(unit)
	local r, g, b = unpack(
						oUF.colors.reaction[UnitReaction(unit, 'player') or 5])

	return
		format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, F.Numb(cur))
end
tagEvents['free:health'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'

tags['free:healthpercentage'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		return
	end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = F.ColorGradient(cur / max, unpack(oUF.colors.smooth))
	r, g, b = r * 255, g * 255, b * 255

	if cur ~= max then
		return format('|cff%02x%02x%02x%d%%|r', r, g, b,
					  floor(cur / max * 100 + 0.5))
	end
end
tagEvents['free:healthpercentage'] =
	'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'

tags['free:power'] = function(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	if (cur == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or
		UnitIsGhost(unit)) then return end

	return F.Numb(cur)
end
tagEvents['free:power'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'

tags['free:stagger'] = function(unit)
	if unit ~= 'player' then return end

	local cur = UnitStagger(unit) or 0
	local perc = cur / UnitHealthMax(unit)

	if cur == 0 then return end

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
	if not UnitIsConnected(unit) then return '|cffcccccc' .. 'Off' end
end
tagEvents['free:offline'] = 'UNIT_HEALTH UNIT_CONNECTION'

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
tagEvents['free:name'] =
	'UNIT_NAME_UPDATE UNIT_TARGET PLAYER_TARGET_CHANGED PLAYER_FOCUS_CHANGED'

tags['free:groupname'] = function(unit)
	if C.DB.unitframe.group_names then
		if UnitInRaid('player') then
			return shortenName(unit, 2)
		else
			return shortenName(unit, 4)
		end
	else
		return ''
	end
end
tagEvents['free:groupname'] = 'UNIT_HEALTH GROUP_ROSTER_UPDATE UNIT_CONNECTION'

tags['free:resting'] = function(unit)
	if (unit == 'player' and IsResting()) then return '|cff2C8D51Zzz|r' end
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
	else
		return ''
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

