local _, ns = ...
local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe

local tags = ns.oUF.Tags.Methods
local tagEvents = ns.oUF.Tags.Events
local tagSharedEvents = ns.oUF.Tags.SharedEvents

local floor = math.floor
local format = string.format


local function ShortenValue(value)
	if(value >= 1e9) then
		return format('%.1fb', value / 1e9)
	elseif(value >= 1e6) then
		return format('%.1fm', value / 1e6)
	elseif(value >= 1e4) then
		return format('%.1fk', value / 1e3)
	else
		return value
	end
end

local function usub(str, len)
	local i = 1
	local n = 0
	while true do
		local b,e = string.find(str, '([%z\1-\127\194-\244][\128-\191]*)', i)
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

local function ShortenName(unit, len)
	local name = UnitName(unit)
	if name and name:len() > len then name = usub(name, len) end

	return name
end



tags['free:dead'] = function(unit)
	if UnitIsDead(unit) then
		return '|cffd84343Dead|r'
	elseif UnitIsGhost(unit) then
		return '|cffbd69beGhost|r'
	end
end
tagEvents['free:dead'] = 'UNIT_HEALTH'

tags['free:offline'] = function(unit)
	if not UnitIsConnected(unit) then
		return '|cffccccccOff|r'
	end
end
tagEvents['free:offline'] = 'UNIT_HEALTH UNIT_CONNECTION'

tags['free:name'] = function(unit)
	if (unit == 'targettarget' and UnitIsUnit("targettarget", "player")) or (unit == 'focustarget' and UnitIsUnit("focustarget", "player")) then
		return '|cffff0000> YOU <|r'
	else
		return ShortenName(unit, 6)
	end

end
tagEvents['free:name'] = 'UNIT_NAME_UPDATE UNIT_TARGET PLAYER_TARGET_CHANGED PLAYER_FOCUS_CHANGED'

tags['free:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
	
	local cur = UnitHealth(unit)
	local r, g, b = unpack(ns.oUF.colors.reaction[UnitReaction(unit, 'player') or 5])

	return format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, ShortenValue(cur))
end
tagEvents['free:health'] = 'UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

tags['free:percentage'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	local r, g, b = ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
	r, g, b = r * 255, g * 255, b * 255

	if cur ~= max then
		return format('|cff%02x%02x%02x%d%%|r', r, g, b, floor(cur / max * 100 + 0.5))
	end
end
tagEvents['free:percentage'] = 'UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

tags['free:classification'] = function(unit)
	local class, level = UnitClassification(unit), UnitLevel(unit)
	if(class == 'worldboss' or level == -1) then
		return '|cff9D2933(B)|r'
	elseif(class == 'rare') then
		return '|cffFF99FF(R)|r'
	elseif(class == 'rareelite') then
		return '|cffFF0099(R+)|r'
	elseif(class == 'elite') then
		return '|cffCC3300(E)|r'
	end
end
tagEvents['free:classification'] = 'UNIT_CLASSIFICATION_CHANGED'

tags['free:power'] = function(unit)
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	if(cur == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	return ShortenValue(cur)
end
tagEvents['free:power'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'

tags['free:altpower'] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return ('%s%%'):format(floor(cur / max * 100 + .5))
	end
end
tagEvents['free:altpower'] = 'UNIT_POWER_UPDATE'

tags['free:groupname'] = function(unit)
	if cfg.showGroupName then
		if UnitInRaid('player') then
			return ShortenName(unit, 2)
		else
			return ShortenName(unit, 4)
		end
	else
		if not UnitIsConnected(unit) then
			return 'Off'
		elseif UnitIsDead(unit) then
			return 'Dead'
		elseif UnitIsGhost(unit) then
			return 'Ghost'
		else
			return ''
		end
	end
end
tagEvents['free:groupname'] = 'UNIT_HEALTH GROUP_ROSTER_UPDATE PLAYER_ENTERING_WORLD'


function module:AddNameText(self)
	local name

	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		if (C.Client == 'zhCN' or C.Client == 'zhTW') and cfg.showGroupName then
			if C.general.isDeveloper then
				name = F.CreateFS(self.Health, 'pixelhybrid', '', nil, nil, true)
			else
				name = F.CreateFS(self.Health, {C.font.normal, 11, 'OUTLINE'}, '', nil, nil, true)
			end
		else
			name = F.CreateFS(self.Health, 'pixel', '', nil, nil, true, 'CENTER', 1, 0)
		end

		self:Tag(name, '[free:groupname]')
	else
		if (C.Client == 'zhCN' or C.Client == 'zhTW') then
			if C.general.isDeveloper then
				name = F.CreateFS(self.Health, 'pixelhybrid', '', nil, nil, true)
			else
				name = F.CreateFS(self.Health, {C.font.normal, 11, 'OUTLINE'}, '', nil, nil, true)
			end
		else
			name = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
		end

		if self.unitStyle == 'target' or self.unitStyle == 'arena' then
			name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		elseif self.unitStyle == 'boss' then
			name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
		else
			name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
		end

		self:Tag(name, '[free:name]')
	end

	self.Name = name
end

function module:AddHealthValue(self)
	local healthValue = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	healthValue:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

	if self.unitStyle == 'player' then
		self:Tag(healthValue, '[free:dead][free:health]')
	elseif self.unitStyle == 'target' then
		self:Tag(healthValue, '[free:dead][free:offline][free:health] [free:percentage]')
	elseif self.unitStyle == 'boss' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:health] [free:percentage]')
	elseif self.unitStyle == 'arena' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:offline][free:health]')
	end

	self.HealthValue = healthValue
end

function module:AddPowerValue(self)
	local powerValue = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	powerValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

	if self.unitStyle == 'target' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 4, 0)
	elseif self.unitStyle == 'boss' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	end

	self:Tag(powerValue, '[powercolor][free:power]')
	powerValue.frequentUpdates = true

	self.PowerValue = powerValue
end

function module:AddClassificationText(self)
	local classificationText = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	classificationText:SetPoint('BOTTOMLEFT', self.PowerValue, 'BOTTOMRIGHT', 4, 0)

	self:Tag(classificationText, '[free:classification]')

	self.ClassificationText = classificationText
end

function module:AddArenaSpec(self)
	local arenaSpec

	if (C.Client == 'zhCN' or C.Client == 'zhTW') then
		if C.general.isDeveloper then
			arenaSpec = F.CreateFS(self.Health, 'pixelhybrid', '', nil, nil, true)
		else
			arenaSpec = F.CreateFS(self.Health, {C.font.normal, 11, 'OUTLINE'}, '', nil, nil, true)
		end
	else
		arenaSpec = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	end

	arenaSpec:SetPoint('BOTTOMLEFT', self.Name, 'BOTTOMRIGHT', 4, 0)

	self:Tag(arenaSpec, '[arenaspec]')
end