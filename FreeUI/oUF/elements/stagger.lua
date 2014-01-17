local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

if(select(2, UnitClass('player')) ~= "MONK") then return end

local parent, ns = ...
local oUF = ns.oUF

-- percentages at which the bar should change color
local STAGGER_YELLOW_TRANSITION = STAGGER_YELLOW_TRANSITION
local STAGGER_RED_TRANSITION = STAGGER_RED_TRANSITION

-- table indices of bar colors
local GREEN_INDEX = 1;
local YELLOW_INDEX = 2;
local RED_INDEX = 3;

local STANCE_OF_THE_STURY_OX_ID = 23

local UnitHealthMax = UnitHealthMax
local UnitStagger = UnitStagger

local _, playerClass = UnitClass("player")

-- TODO: fix color in the power element
oUF.colors.power[BREWMASTER_POWER_BAR_NAME] = {
	{0.52, 1.0, 0.52},
	{1.0, 0.98, 0.72},
	{1.0, 0.42, 0.42},
}
local color

local Update = function(self, event, unit)
	if unit and unit ~= self.unit then return end
	local element = self.Stagger

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local maxHealth = UnitHealthMax("player")
	local stagger = UnitStagger("player")
	local staggerPercent = stagger / maxHealth

	element:SetMinMaxValues(0, maxHealth)
	element:SetValue(stagger)

	local rgb
	if(staggerPercent >= STAGGER_RED_TRANSITION) then
		rgb = color[RED_INDEX]
	elseif(staggerPercent > STAGGER_YELLOW_TRANSITION) then
		rgb = color[YELLOW_INDEX]
	else
		rgb = color[GREEN_INDEX]
	end

	local r, g, b = rgb[1], rgb[2], rgb[3]
	element:SetStatusBarColor(r, g, b)

	local bg = element.bg
	if(bg) then
		local mu = bg.multiplier or 1
		bg:SetVertexColor(r * mu, g * mu, b * mu)
	end

	if(element.PostUpdate) then
		element:PostUpdate(maxHealth, stagger, staggerPercent, r, g, b)
	end
end

local Path = function(self, ...)
	return (self.Stagger.Override or Update)(self, ...)
end

local Visibility = function(self, event, unit)
	if(STANCE_OF_THE_STURY_OX_ID ~= GetShapeshiftFormID() or UnitHasVehiclePlayerFrameUI("player")) then
		if self.Stagger:IsShown() then
			self.Stagger:Hide()
			self:UnregisterEvent('UNIT_AURA', Path)
		end
	elseif not self.Stagger:IsShown() then
		self.Stagger:Show()
		self:RegisterEvent('UNIT_AURA', Path)
		return Path(self, event, unit)
	end
end

local VisibilityPath = function(self, ...)
	return (self.Stagger.OverrideVisibility or Visibility)(self, ...)
end

local ForceUpdate = function(element)
	return VisibilityPath(element.__owner, "ForceUpdate", element.__owner.unit)
end

local Enable = function(self, unit)
	if(playerClass ~= "MONK") then return end

	local element = self.Stagger
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		color = self.colors.power[BREWMASTER_POWER_BAR_NAME]

		self:RegisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', VisibilityPath)

		if(element:IsObjectType'StatusBar' and not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end

		MonkStaggerBar.Show = MonkStaggerBar.Hide
		MonkStaggerBar:UnregisterEvent'PLAYER_ENTERING_WORLD'
		MonkStaggerBar:UnregisterEvent'PLAYER_SPECIALIZATION_CHANGED'
		MonkStaggerBar:UnregisterEvent'UNIT_DISPLAYPOWER'
		MonkStaggerBar:UnregisterEvent'UPDATE_VEHICLE_ACTION_BAR'

		return true
	end
end

local Disable = function(self)
	local element = self.Stagger
	if(element) then
		element:Hide()
		self:UnregisterEvent('UNIT_AURA', Path)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', VisibilityPath)
		self:UnregisterEvent('UPDATE_SHAPESHIFT_FORM', VisibilityPath)

		MonkStaggerBar.Show = nil
		MonkStaggerBar:Show()
		MonkStaggerBar:UnregisterEvent'PLAYER_ENTERING_WORLD'
		MonkStaggerBar:UnregisterEvent'PLAYER_SPECIALIZATION_CHANGED'
		MonkStaggerBar:UnregisterEvent'UNIT_DISPLAYPOWER'
		MonkStaggerBar:UnregisterEvent'UPDATE_VEHICLE_ACTION_BAR'
	end
end

oUF:AddElement("Stagger", VisibilityPath, Enable, Disable)