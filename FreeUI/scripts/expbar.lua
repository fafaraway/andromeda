local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

-- Utility

local FactionInfo = {
	[1] = {170/255, 70/255, 70/255, "Hated", "FFaa4646"},
	[2] = {170/255, 70/255, 70/255, "Hostile", "FFaa4646"},
	[3] = {170/255, 70/255, 70/255, "Unfriendly", "FFaa4646"},
	[4] = {200/255, 180/255, 100/255, "Neutral", "FFc8b464"},
	[5] = {75/255, 175/255, 75/255, "Friendly", "FF4baf4b"},
	[6] = {75/255, 175/255, 75/255, "Honored", "FF4baf4b"},
	[7] = {75/255, 175/255, 75/255, "Revered", "FF4baf4b"},
	[8] = {155/255, 255/255, 155/255, "Exalted","FF9bff9b"},
}

-- Create frames

local backdrop = CreateFrame("Frame", nil, Minimap)
backdrop:SetHeight(6)
backdrop:SetPoint("BOTTOM", Minimap, "TOP")
backdrop:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", -1, 0)
backdrop:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 1, 0)
F.CreateBD(backdrop, .6)

local xpBar = CreateFrame("StatusBar", nil, backdrop)
xpBar:SetHeight(GetWatchedFactionInfo() and 2 or 5)
xpBar:SetPoint("TOP", backdrop, "TOP", 0, -1)
xpBar:SetPoint("LEFT", backdrop, 1, 0)
xpBar:SetPoint("RIGHT", backdrop, -1, 0)
xpBar:SetStatusBarTexture(C.media.texture)
xpBar:SetStatusBarColor(.5, 0, .75)

local restedxpBar = CreateFrame("StatusBar", nil, backdrop)
restedxpBar:SetHeight(GetWatchedFactionInfo() and 2 or 5)
restedxpBar:SetPoint("TOP", backdrop, "TOP", 0, -1)
restedxpBar:SetPoint("LEFT", backdrop, 1, 0)
restedxpBar:SetPoint("RIGHT", backdrop, -1, 0)
restedxpBar:SetStatusBarTexture(C.media.texture)
restedxpBar:SetStatusBarColor(0, .4, .8)

local repBar = CreateFrame("StatusBar", nil, backdrop)
repBar:SetHeight(1)
repBar:SetPoint("BOTTOM", backdrop, "BOTTOM", 0, 1)
repBar:SetPoint("LEFT", backdrop, 1, 0)
repBar:SetPoint("RIGHT", backdrop, -1, 0)
repBar:SetStatusBarTexture(C.media.texture)

local sep = backdrop:CreateTexture(nil, "BORDER")
sep:SetWidth(126)
sep:SetHeight(1)
sep:SetPoint("TOP", xpBar, "BOTTOM")
sep:SetTexture(C.media.backdrop)
sep:SetVertexColor(0, 0, 0)

local mouseFrame = CreateFrame("Frame", "FreeUIExpBar", backdrop)
mouseFrame:SetAllPoints(backdrop)
mouseFrame:EnableMouse(true)

backdrop:SetFrameLevel(0)
restedxpBar:SetFrameLevel(1)
repBar:SetFrameLevel(2)
xpBar:SetFrameLevel(2)
mouseFrame:SetFrameLevel(3)

-- Update function

local function updateStatus()
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()

	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		xpBar:Hide()
		restedxpBar:Hide()
		sep:Hide()
		repBar:SetHeight(4)
		if not GetWatchedFactionInfo() then
			backdrop:Hide()
		else
			backdrop:Show()
		end
	else
		xpBar:SetMinMaxValues(min(0, XP), maxXP)
		xpBar:SetValue(XP)

		if restXP then
			restedxpBar:Show()
			restedxpBar:SetMinMaxValues(min(0, XP), maxXP)
			restedxpBar:SetValue(XP+restXP)
		else
			restedxpBar:Hide()
		end

		if GetWatchedFactionInfo() then
			xpBar:SetHeight(2)
			restedxpBar:SetHeight(2)
			repBar:SetHeight(1)
			repBar:Show()
			sep:Show()
		else
			xpBar:SetHeight(4)
			restedxpBar:SetHeight(4)
			repBar:Hide()
			sep:Hide()
		end
	end

	if GetWatchedFactionInfo() then
		local name, rank, minRep, maxRep, value = GetWatchedFactionInfo()
		repBar:SetMinMaxValues(minRep, maxRep)
		repBar:SetValue(value)
		repBar:SetStatusBarColor(FactionInfo[rank][1], FactionInfo[rank][2], FactionInfo[rank][3])
	end
end

F.RegisterEvent("PLAYER_LEVEL_UP", updateStatus)
F.RegisterEvent("PLAYER_XP_UPDATE", updateStatus)
F.RegisterEvent("UPDATE_EXHAUSTION", updateStatus)
F.RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", updateStatus)
F.RegisterEvent("UPDATE_FACTION", updateStatus)
F.RegisterEvent("PLAYER_ENTERING_WORLD", updateStatus)

-- Mouse events

mouseFrame:SetScript("OnEnter", function()
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()

	GameTooltip:SetOwner(mouseFrame, "ANCHOR_BOTTOMLEFT", 0, 7)
	GameTooltip:ClearLines()
	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
		GameTooltip:AddLine("Experience:", r, g, b)
		GameTooltip:AddDoubleLine("Current: ", string.format('%s/%s (%d%%)', BreakUpLargeNumbers(XP), BreakUpLargeNumbers(maxXP), (XP/maxXP)*100), r, g, b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Remaining: ", string.format('%s', BreakUpLargeNumbers(maxXP-XP)), r, g, b, 1, 1, 1)
		if restXP then
			GameTooltip:AddDoubleLine("Rested: ", string.format('|cffb3e1ff%s (%d%%)', BreakUpLargeNumbers(restXP), restXP/maxXP*100), r, g, b)
		end
	end
	if GetWatchedFactionInfo() then
		local name, rank, start, cap, value = GetWatchedFactionInfo()
		if UnitLevel("player") ~= MAX_PLAYER_LEVEL then GameTooltip:AddLine(" ") end
		GameTooltip:AddDoubleLine("Reputation:", name, r, g, b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Standing:", string.format('|c'..FactionInfo[rank][5]..'%s|r', FactionInfo[rank][4]), r, g, b)
		GameTooltip:AddDoubleLine("Rep:", string.format('%s/%s (%d%%)', BreakUpLargeNumbers(value-start), BreakUpLargeNumbers(cap-start), (value-start)/(cap-start)*100), r, g, b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Remaining:", string.format('%s', BreakUpLargeNumbers(cap-value)), r, g, b, 1, 1, 1)
	end
	GameTooltip:Show()
end)

mouseFrame:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)