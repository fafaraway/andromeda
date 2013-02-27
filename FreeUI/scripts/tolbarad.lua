local F, C, L = unpack(select(2, ...))

if not C.general.tolbarad then return end

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetSize(100, 10)
frame:SetPoint("TOP", Minimap, "BOTTOM", 0, -39)

local text = F.CreateFS(frame, 8)
text:SetPoint("CENTER")
text:SetTextColor(unpack(C.class))

local function timer()
	local _, _, IsActive, canQueue, startTime = GetWorldPVPAreaInfo(2)
	local hour = tonumber(format("%01.f", floor(startTime/3600)))
	local min = format(hour>0 and "%02.f" or "%01.f", floor(startTime/60 - (hour*60)))
	if startTime ~= 0 then
		if IsActive then
			text:SetText("In Progress")
		else
			text:SetText("TB|cffffffff:|r "..(hour>0 and "|cffffffff"..hour.."|r".." Hr " or "")..("|cffffffff"..min.."|r".." Min"))
		end
	else
		text:SetText("")
	end
end

local last = 0
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