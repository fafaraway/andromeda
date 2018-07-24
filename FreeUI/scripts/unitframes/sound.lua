--[[
	Shadow, Mal'Ganis (US)
]]

local Sounds = select(2, ...)

-- Focus sounds
function Sounds:PLAYER_FOCUS_CHANGED()
	if( UnitExists("focus") ) then
		if( UnitIsEnemy("focus", "player") ) then
			PlaySound("873")
		elseif( UnitIsFriend("player", "focus") ) then
			PlaySound("867")
		else
			PlaySound("871")
		end
	else
		PlaySound("684")
	end
end

-- Target sounds
function Sounds:PLAYER_TARGET_CHANGED()
	if( UnitExists("target") ) then
		if( UnitIsEnemy("target", "player") ) then
			PlaySound("873")
		elseif( UnitIsFriend("player", "target") ) then
			PlaySound("867")
		else
			PlaySound("871")
		end
	else
		PlaySound("684")
	end
end

-- PVP flag sounds
local announcedPVP
function Sounds:UNIT_FACTION(unit, ...)
	if( unit ~= "player" ) then return end

	if( UnitIsPVPFreeForAll("player") or UnitIsPVP("player") ) then
		if( not announcedPVP ) then
			announcedPVP = true
			PlaySound("4574")
		end
	else
		announcedPVP = nil
	end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UNIT_FACTION")
frame:SetScript("OnEvent", function(self, event, ...)
	Sounds[event](Sounds, ...)
end)