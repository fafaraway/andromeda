-- stExperienceBar by Safturento, modified.

local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local FactionInfo = {
	[1] = {{ 170/255, 70/255,  70/255 }, "Hated", "FFaa4646"},
	[2] = {{ 170/255, 70/255,  70/255 }, "Hostile", "FFaa4646"},
	[3] = {{ 170/255, 70/255,  70/255 }, "Unfriendly", "FFaa4646"},
	[4] = {{ 200/255, 180/255, 100/255 }, "Neutral", "FFc8b464"},
	[5] = {{ 75/255,  175/255, 75/255 }, "Friendly", "FF4baf4b"},
	[6] = {{ 75/255,  175/255, 75/255 }, "Honored", "FF4baf4b"},
	[7] = {{ 75/255,  175/255, 75/255 }, "Revered", "FF4baf4b"},
	[8] = {{ 155/255,  255/255, 155/255 }, "Exalted","FF9bff9b"},
}

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.0fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.0fk"):format(value / 1e3):gsub("%.?+([km])$", "%1")
	else
		return value
	end
end

local function CommaValue(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function colorize(r)
	return FactionInfo[r][3]
end

local function IsMaxLevel()
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		return true
	end
end

local aName = "FreeUI_ExpBar"
	
local backdrop = CreateFrame("Frame", aName.."Backdrop", UIParent)
backdrop:SetHeight(6)
backdrop:SetWidth(128)
backdrop:SetPoint("BOTTOM", Minimap, "TOP")
F.CreateBD(backdrop, .6)
	
local xpBar = CreateFrame("StatusBar", aName.."xpBar", backdrop)
xpBar:SetWidth(126)
xpBar:SetHeight(GetWatchedFactionInfo() and 2 or 5)
xpBar:SetPoint("TOP", backdrop,"TOP", 0, -1)
xpBar:SetStatusBarTexture(C.media.texture)
xpBar:SetStatusBarColor(.5, 0, .75)
	
local restedxpBar = CreateFrame("StatusBar", aName.."restedxpBar", backdrop)
restedxpBar:SetWidth(126)
restedxpBar:SetHeight(GetWatchedFactionInfo() and 2 or 5)
restedxpBar:SetPoint("TOP", backdrop,"TOP", 0, -1)
restedxpBar:SetStatusBarTexture(C.media.texture)
restedxpBar:SetStatusBarColor(0, .4, .8)
	
local repBar = CreateFrame("StatusBar", aName.."repBar", backdrop)
repBar:SetWidth(126)
repBar:SetHeight(1)
repBar:SetPoint("BOTTOM", backdrop, "BOTTOM", 0, 1)
repBar:SetStatusBarTexture(C.media.texture)

local sep = backdrop:CreateTexture(nil, "BORDER")
sep:SetWidth(126)
sep:SetHeight(1)
sep:SetPoint("TOP", xpBar, "BOTTOM")
sep:SetTexture(C.media.backdrop)
sep:SetVertexColor(0, 0, 0)
	
--Create frame used for mouseover
local mouseFrame = CreateFrame("Frame", aName.."mouseFrame", backdrop)
mouseFrame:SetAllPoints(backdrop)
mouseFrame:EnableMouse(true)

backdrop:SetFrameLevel(0)
restedxpBar:SetFrameLevel(1)
repBar:SetFrameLevel(2)
xpBar:SetFrameLevel(2)
mouseFrame:SetFrameLevel(3)

-- Setup bar info
local function updateStatus()
	local XP, maxXP = UnitXP("player"), UnitXPMax("player")
	local restXP = GetXPExhaustion()
	
	if IsMaxLevel() then
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
		repBar:SetStatusBarColor(unpack(FactionInfo[rank][1]))
	end
	
	mouseFrame:SetScript("OnEnter", function()
		GameTooltip:SetOwner(mouseFrame, "ANCHOR_BOTTOMLEFT", -3, 5)
		GameTooltip:ClearLines()
		if not IsMaxLevel() then
			GameTooltip:AddLine("Experience:", r, g, b)
			GameTooltip:AddDoubleLine("Current: ", string.format('%s/%s (%d%%)', CommaValue(XP), CommaValue(maxXP), (XP/maxXP)*100), r, g, b, 1, 1, 1)
			GameTooltip:AddDoubleLine("Remaining: ", string.format('%s', CommaValue(maxXP-XP)), r, g, b, 1, 1, 1)	
			if restXP then
				GameTooltip:AddDoubleLine("Rested: ", string.format('|cffb3e1ff%s (%d%%)', CommaValue(restXP), restXP/maxXP*100), r, g, b)
			end
		end
		if GetWatchedFactionInfo() then
			local name, rank, min, max, value = GetWatchedFactionInfo()
			if not IsMaxLevel() then GameTooltip:AddLine(" ") end
			GameTooltip:AddDoubleLine("Reputation:", name, r, g, b, 1, 1, 1)
			GameTooltip:AddDoubleLine("Standing:", string.format('|c'..colorize(rank)..'%s|r', FactionInfo[rank][2]), r, g, b)
			GameTooltip:AddDoubleLine("Rep:", string.format('%s/%s (%d%%)', CommaValue(value-min), CommaValue(max-min), (value-min)/(max-min)*100), r, g, b, 1, 1, 1)
			GameTooltip:AddDoubleLine("Remaining:", string.format('%s', CommaValue(max-value)), r, g, b, 1, 1, 1)
		end
		GameTooltip:Show()
	end)
	mouseFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local frame = CreateFrame("Frame", nil, UIParent)
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_XP_UPDATE")
frame:RegisterEvent("UPDATE_EXHAUSTION")
frame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
frame:RegisterEvent("UPDATE_FACTION")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", updateStatus)