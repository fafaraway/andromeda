if select(2, UnitClass('player')) ~= "PRIEST" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF_ShadowOrbsBar was unable to locate oUF install')

local SHADOW_ORBS_SHOW_LEVEL = SHADOW_ORBS_SHOW_LEVEL
local PRIEST_BAR_NUM_ORBS = PRIEST_BAR_NUM_ORBS
local SPELL_POWER_SHADOW_ORBS = SPELL_POWER_SHADOW_ORBS

local Colors = { 
	[1] = {109/255, 51/255, 188/255, 1},
	[2] = {139/255, 51/255, 188/255, 1},
	[3] = {179/255, 51/255, 188/255, 1},
}

local function Update(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SHADOW_ORBS')) then return end

	local pb = self.ShadowOrbsBar
	
	if(pb.PreUpdate) then
		pb:PreUpdate(unit)
	end

	local numOrbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS)
	
	if(pb.PostUpdate) then
		return pb:PostUpdate(numOrbs)
	end
end

local Path = function(self, ...)
	return (self.ShadowOrbsBar.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'SHADOW_ORBS')
end

local function Visibility(self, event, unit)
	local pb = self.ShadowOrbsBar
	local spec = GetSpecialization()

	if spec == SPEC_PRIEST_SHADOW then
		pb:Show()
	else
		pb:Hide()
	end
end

local function Enable(self, unit)
	local pb = self.ShadowOrbsBar
	if pb and unit == "player" then
		pb.__owner = self
		pb.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Visibility, true)
		
		return true
	end
end

local function Disable(self)
	if self.ShadowOrbsBar then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Visibility)
	end
end

oUF:AddElement('ShadowOrbsBar', Path, Enable, Disable)