local F, C, L = unpack(select(2, ...))
local module = F:GetModule("unitframe")

local ufsounds = select(2, ...)

-- Focus sounds
function ufsounds:PLAYER_FOCUS_CHANGED()
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
function ufsounds:PLAYER_TARGET_CHANGED()
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
function ufsounds:UNIT_FACTION(unit, ...)
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

function module:ufsounds()
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_FOCUS_CHANGED")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("UNIT_FACTION")
	f:SetScript("OnEvent", function(self, event, ...)
		ufsounds[event](ufsounds, ...)
	end)
end