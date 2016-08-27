local F, C, L = unpack(select(2, ...))

local a1, p, a2, x, y = unpack(C.unitframes.target)

local combo = CreateFrame("Frame", nil, UIParent)
combo:SetSize(50, 50)
combo:SetPoint(a1, p, a2, x, y+180)
combo:SetFrameLevel(3)

local count = F.CreateFS(combo, 32, "CENTER")
count:SetAllPoints(combo)

local function UpdatePoints()
	if UnitIsDead("target") then return end

	local points = GetComboPoints(UnitHasVehicleUI("player") and "vehicle" or "player", "target")
	count:SetText(points > 0 and points or "")

	if points == 1 then
		count:SetTextColor(0, 1, 0)
	elseif points == 2 then
		count:SetTextColor(.5, 1, 0)
	elseif points == 3 then
		count:SetTextColor(1, 1, 0)
	elseif points == 4 then
		count:SetTextColor(1, .5, 0)
	elseif points == 5 then
		count:SetTextColor(1, 0, 0)
	end
end

combo:RegisterEvent("PLAYER_TARGET_CHANGED")
combo:RegisterEvent("UNIT_POWER")
combo:RegisterEvent("UNIT_EXITED_VEHICLE")
combo:SetScript("OnEvent", function(self, event, unit)
	if event == "PLAYER_TARGET_CHANGED" then
		UpdatePoints()
	elseif event == "UNIT_POWER" then
		if unit == "player" or unit == "vehicle" then
			UpdatePoints()
		end
	elseif event == "UNIT_EXITED_VEHICLE" then
		if unit == "player" then
			UpdatePoints()
		end
	end
end)

ComboFrame:UnregisterAllEvents()
