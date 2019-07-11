local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local format, floor = string.format, math.floor

local cfg = C.unitframe
local tags = FreeUI.oUF.Tags.Methods
local tagEvents = FreeUI.oUF.Tags.Events
local tagSharedEvents = FreeUI.oUF.Tags.SharedEvents






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
	if not UnitIsConnected(unit) then return end

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
	if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
		return '|cffff0000> YOU <|r'
	else
		return ShortenName(unit, 6)
	end

end
tagEvents['free:name'] = 'UNIT_NAME_UPDATE UNIT_TARGET PLAYER_TARGET_CHANGED PLAYER_FOCUS_CHANGED'

tags['free:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
	
	local cur = UnitHealth(unit)
	local r, g, b = unpack(FreeUI.oUF.colors.reaction[UnitReaction(unit, 'player') or 5])

	return format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, F.Numb(cur))
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

	return F.Numb(cur)
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
	if not UnitIsConnected(unit) then
		return 'Off'
	elseif cfg.showGroupName then
		if UnitInRaid('player') then
			return ShortenName(unit, 2)
		else
			return ShortenName(unit, 4)
		end
	else
		if UnitIsDead(unit) then
			return 'Dead'
		elseif UnitIsGhost(unit) then
			return 'Ghost'
		else
			return ''
		end
	end
end
tagEvents['free:groupname'] = 'UNIT_HEALTH GROUP_ROSTER_UPDATE UNIT_CONNECTION'

tags['free:stagger'] = function(unit)
	if unit ~= 'player' then return end

	local cur = UnitStagger(unit) or 0
	local perc = cur / UnitHealthMax(unit)

	if cur == 0 then return end
	
	return F.Numb(cur)..' / '..C.MyColor..floor(perc*100 + .5)..'%'
end
tagEvents['free:stagger'] = 'UNIT_MAXHEALTH UNIT_AURA'


local function UpdateUnitNameColour(self)
	if self.unitStyle == 'party' or self.unitStyle == 'raid' or self.unitStyle == 'boss' then
		if (UnitIsUnit(self.unit, 'target')) then
			self.Name:SetTextColor(95/255, 222/255, 215/255)
		elseif UnitIsDead(self.unit) then
			self.Name:SetTextColor(216/255, 67/255, 67/255)
		elseif UnitIsGhost(self.unit) then
			self.Name:SetTextColor(189/255, 105/255, 190/255)
		elseif not UnitIsConnected(self.unit) then
			self.Name:SetTextColor(204/255, 204/255, 204/255)
		else
			self.Name:SetTextColor(1, 1, 1)
		end
	end
end

function UNITFRAME:AddNameText(self)
	local name

	if self.unitStyle == 'party' or self.unitStyle == 'raid' then
		name = F.CreateFS(self.Health, (C.isCNClient and cfg.showGroupName and C.NormalFont) or 'pixel', '', nil, nil, not C.isCNClient)

		self:Tag(name, '[free:groupname]')
	else
		name = F.CreateFS(self.Health, (C.isCNClient and C.NormalFont) or 'pixel', '', nil, nil, not C.isCNClient)

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

	if self.unitStyle == 'party' or self.unitStyle == 'raid' or self.unitStyle == 'boss' then
		self:RegisterEvent('UNIT_HEALTH_FREQUENT', UpdateUnitNameColour, true)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateUnitNameColour, true)
		self:RegisterEvent('UNIT_CONNECTION', UpdateUnitNameColour, true)
	end
end

function UNITFRAME:AddHealthValue(self)
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
		self:Tag(healthValue, '[free:dead][free:health]')
	elseif self.unitStyle == 'arena' then
		healthValue:ClearAllPoints()
		healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
		healthValue:SetJustifyH('RIGHT')
		self:Tag(healthValue, '[free:dead][free:offline][free:health]')
	end

	self.HealthValue = healthValue
end

function UNITFRAME:AddHealthPercentage(self)
	local healthPercentage = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	healthPercentage:SetPoint('LEFT', self, 'RIGHT', 4, 0)

	self:Tag(healthPercentage, '[free:percentage]')
	self.HealthPercentage = healthPercentage
end

function UNITFRAME:AddPowerValue(self)
	local powerValue = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	powerValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

	if self.unitStyle == 'target' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 4, 0)
	elseif self.unitStyle == 'boss' then
		powerValue:ClearAllPoints()
		powerValue:SetPoint('BOTTOMRIGHT', self.HealthValue, 'BOTTOMLEFT', -4, 0)
	end

	self:Tag(powerValue, '[powercolor][free:power]')
	powerValue.frequentUpdates = true

	self.PowerValue = powerValue
end

function UNITFRAME:AddClassificationText(self)
	local classificationText = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	classificationText:SetPoint('BOTTOMLEFT', self.PowerValue, 'BOTTOMRIGHT', 4, 0)

	self:Tag(classificationText, '[free:classification]')

	self.ClassificationText = classificationText
end

function UNITFRAME:AddArenaSpec(self)
	local arenaSpec

	arenaSpec = F.CreateFS(self.Health, (C.isCNClient and C.NormalFont) or 'pixel', '', nil, nil, not C.isCNClient)
	arenaSpec:SetPoint('BOTTOMLEFT', self.Name, 'BOTTOMRIGHT', 4, 0)

	self:Tag(arenaSpec, '[arenaspec]')
end