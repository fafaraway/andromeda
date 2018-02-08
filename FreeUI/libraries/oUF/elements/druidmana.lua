local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

local _, ns = ...
local oUF = ns.oUF

local playerClass = select(2, UnitClass('player'))
local isBetaClient = select(4, GetBuildInfo()) >= 70000

local ADDITIONAL_POWER_BAR_NAME = ADDITIONAL_POWER_BAR_NAME
local ADDITIONAL_POWER_BAR_INDEX = ADDITIONAL_POWER_BAR_INDEX

local function Update(self, event, unit, powertype)
	if(unit ~= 'player' or (powertype and powertype ~= ADDITIONAL_POWER_BAR_NAME)) then return end

	local druidmana = self.DruidMana
	if(druidmana.PreUpdate) then druidmana:PreUpdate(unit) end

	local cur = UnitPower('player', ADDITIONAL_POWER_BAR_INDEX)
	local max = UnitPowerMax('player', ADDITIONAL_POWER_BAR_INDEX)
	druidmana:SetMinMaxValues(0, max)
	druidmana:SetValue(cur)

	local r, g, b, t
	if(druidmana.colorClass) then
		t = self.colors.class[playerClass]
	elseif(druidmana.colorSmooth) then
		r, g, b = self.ColorGradient(cur, max, unpack(druidmana.smoothGradient or self.colors.smooth))
	elseif(druidmana.colorPower) then
		t = self.colors.power[ADDITIONAL_POWER_BAR_NAME]
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		druidmana:SetStatusBarColor(r, g, b)

		local bg = druidmana.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(druidmana.PostUpdate) then
		return druidmana:PostUpdate(unit, cur, max)
	end
end

local function Path(self, ...)
	return (self.DruidMana.Override or Update) (self, ...)
end

local function ElementEnable(self)
	self:RegisterEvent('UNIT_POWER_FREQUENT', Path)
	self:RegisterEvent('UNIT_DISPLAYPOWER', Path)
	self:RegisterEvent('UNIT_MAXPOWER', Path)

	self.DruidMana:Show()

	Path(self, 'ElementEnable', 'player', ADDITIONAL_POWER_BAR_NAME)
end

local function ElementDisable(self)
	self:UnregisterEvent('UNIT_POWER_FREQUENT', Path)
	self:UnregisterEvent('UNIT_DISPLAYPOWER', Path)
	self:UnregisterEvent('UNIT_MAXPOWER', Path)

	self.DruidMana:Hide()

	Path(self, 'ElementDisable', 'player', ADDITIONAL_POWER_BAR_NAME)
end

local function Visibility(self, event, unit)
	local druidmana = self.DruidMana
	local shouldEnable

	if(not UnitHasVehicleUI('player')) then
		if(UnitPowerMax(unit, ADDITIONAL_POWER_BAR_INDEX) ~= 0) then
			if(isBetaClient) then
				if(druidmana.displayPairs[playerClass]) then
					local powerType = UnitPowerType(unit)
					shouldEnable = druidmana.displayPairs[playerClass][powerType]
				end
			else
				if(playerClass == 'DRUID' and UnitPowerType(unit) == ADDITIONAL_POWER_BAR_INDEX) then
					shouldEnable = true
				end
			end
		end
	end

	if(shouldEnable) then
		ElementEnable(self)
	else
		ElementDisable(self)
	end
end

local VisibilityPath = function(self, ...)
	return (self.DruidMana.OverrideVisibility or Visibility) (self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self, unit)
	local druidmana = self.DruidMana
	if(druidmana and unit == 'player') then
		druidmana.displayPairs = druidmana.displayPairs or ALT_MANA_BAR_PAIR_DISPLAY_INFO
		druidmana.__owner = self
		druidmana.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)

		if(druidmana:IsObjectType'StatusBar' and not druidmana:GetStatusBarTexture()) then
			druidmana:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end

		return true
	end
end

local Disable = function(self)
	local druidmana = self.DruidMana
	if(druidmana) then
		ElementDisable(self)

		self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
	end
end

oUF:AddElement('DruidMana', VisibilityPath, Enable, Disable)