local F, C, L = unpack(select(2, ...))

if C.general.tolbarad == false or (UnitLevel("player") ~= 85 and C.general.tolbarad_always ~= true) then return end

local frame = CreateFrame("Frame", nil, Minimap)
frame:SetSize(100, 10)
frame:SetPoint("TOP", Minimap, "BOTTOM", 0, -44)
local text = F.CreateFS(frame, 8 / .9)
text:SetPoint("CENTER")
text:SetTextColor(unpack(C.class))

local last = 0
local hour, min
local _, IsActive, canQueue, startTime

local function timer()
	_, _, IsActive, canQueue, startTime = GetWorldPVPAreaInfo(2)
	hour = tonumber(format("%01.f", floor(startTime/3600)))
	min = format(hour>0 and "%02.f" or "%01.f", floor(startTime/60 - (hour*60)))
	timeleft = (hour>0 and "|cffffffff"..hour.."|r".." Hr " or "")..("|cffffffff"..min.."|r".." Min")
	if startTime~=0 then
		if IsActive then
			text:SetText("In Progress")
		else
			text:SetText("TB|cffffffff:|r "..timeleft)
		end
	else
		text:SetText("")
	end
end

local freq = C.performance.tolbarad

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", timer)
frame:SetScript("OnUpdate", function(self, elapsed)
	last = last + elapsed
	if last >= freq then
		timer()
		last = 0
	end
end)