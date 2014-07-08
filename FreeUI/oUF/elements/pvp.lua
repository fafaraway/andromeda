local F, C = unpack(select(2, ...))

if not C.unitframes.enable or not C.unitframes.pvp then return end

local parent, ns = ...
local oUF = ns.oUF

local Path = function(self, ...)
	return (self.PvP.Override) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local pvp = self.PvP
	if(pvp) then
		pvp.__owner = self
		pvp.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_FACTION", Path)

		return true
	end
end

local Disable = function(self)
	local pvp = self.PvP
	if(pvp) then
		self:UnregisterEvent("UNIT_FACTION", Path)
	end
end

oUF:AddElement('PvP', Path, Enable, Disable)