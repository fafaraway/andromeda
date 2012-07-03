if select(2, UnitClass("player")) ~= "WARLOCK" then return end
local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_WarlockSpecBars was unable to locate oUF install")

local MAX_POWER_PER_EMBER = 10
local SPELL_POWER_DEMONIC_FURY = SPELL_POWER_DEMONIC_FURY
local SPELL_POWER_BURNING_EMBERS = SPELL_POWER_BURNING_EMBERS
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS
local SPEC_WARLOCK_DESTRUCTION = SPEC_WARLOCK_DESTRUCTION
local SPEC_WARLOCK_AFFLICTION = SPEC_WARLOCK_AFFLICTION
local SPEC_WARLOCK_DEMONOLOGY = SPEC_WARLOCK_DEMONOLOGY

local Colors = { 
	[1] = {109/255, 51/255, 188/255, 1},
	[2] = {139/255, 51/255, 188/255, 1},
	[3] = {179/255, 51/255, 188/255, 1},
	[4] = {209/255, 51/255, 188/255, 1},
}

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "BURNING_EMBERS" and powerType ~= "SOUL_SHARDS" and powerType ~= "DEMONIC_FURY")) then return end

	local wsb = self.WarlockSpecBars
	if(wsb.PreUpdate) then wsb:PreUpdate(unit) end
	
	local spec = GetSpecialization()
	
	if spec then
		if not wsb:IsShown() then 
			wsb:Show()
		end
		
		if spec == SPEC_WARLOCK_DESTRUCTION or spec == SPEC_WARLOCK_AFFLICTION then
			if wsb[1]:GetWidth() ~= wsb[1].W then
				wsb.number = 4
				wsb[1]:SetWidth(wsb[1].W) 
				wsb[1]:SetValue(UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)) 
				wsb[2]:Show()
				wsb[3]:Show() 
				wsb[4]:Show() 
			end
		end
		
		if (spec == SPEC_WARLOCK_DESTRUCTION) then	
			local maxPower = UnitPowerMax("player", SPELL_POWER_BURNING_EMBERS, true)
			local power = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
			local numEmbers = power / MAX_POWER_PER_EMBER
			local numBars = floor(maxPower / MAX_POWER_PER_EMBER)

			-- bar unavailable
			if wsb.number ~= numBars and numBars == 3 then
				local spacing = select(4, wsb[4]:GetPoint())
				wsb[4]:Hide()
				wsb[3]:SetWidth(wsb[3].W + wsb[4].W + spacing)
			else
				wsb[4]:Show()
				wsb[3]:SetWidth(wsb[3].W)		
			end
			
			for i = 1, numBars do
				wsb[i]:SetMinMaxValues((MAX_POWER_PER_EMBER * i) - MAX_POWER_PER_EMBER, MAX_POWER_PER_EMBER * i)
				wsb[i]:SetValue(power)
			end
		elseif ( spec == SPEC_WARLOCK_AFFLICTION ) then
			local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
			local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)
			
			-- bar unavailable
			if wsb.number ~= maxShards and maxShards == 3 then
				local spacing = select(4, wsb[4]:GetPoint())
				wsb[4]:Hide()
				wsb[3]:SetWidth(wsb[3].W + wsb[4].W + spacing)
			else
				wsb[4]:Show()
				wsb[3]:SetWidth(wsb[3].W)		
			end
			
			for i = 1, maxShards do
				if i <= numShards then
					wsb[i]:SetAlpha(1)
				else
					wsb[i]:SetAlpha(.2)
				end
			end
		elseif spec == SPEC_WARLOCK_DEMONOLOGY then
			local power = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
			local maxPower = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)
			
			if wsb.number ~= 1 then
				wsb.number = 1
				wsb[2]:Hide()
				wsb[3]:Hide()
				wsb[4]:Hide()
				wsb[1]:SetWidth(wsb:GetWidth())
				wsb[1]:SetAlpha(1)
			end
			
			wsb[1]:SetMinMaxValues(0, maxPower)
			wsb[1]:SetValue(power)
		end
	else
		if wsb:IsShown() then 
			wsb:Hide()
		end
	end

	if(wsb.PostUpdate) then
		return wsb:PostUpdate(spec)
	end
end

local Path = function(self, ...)
	return (self.WarlockSpecBars.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit, "SOUL_SHARDS")
end

local function Enable(self)
	local wsb = self.WarlockSpecBars
	if(wsb) then
		wsb.__owner = self
		wsb.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		
		for i = 1, 4 do
			local Point = wsb[i]
			if not Point:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end
			
			Point:SetStatusBarColor(unpack(Colors[i]))
			Point:SetFrameLevel(wsb:GetFrameLevel() + 1)
			Point:GetStatusBarTexture():SetHorizTile(false)
			Point.W = Point:GetWidth()
		end
		
		wsb.number = 4

		return true
	end
end

local function Disable(self)
	local wsb = self.WarlockSpecBars
	if(wsb) then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
	end
end

oUF:AddElement("WarlockSpecBars", Path, Enable, Disable)