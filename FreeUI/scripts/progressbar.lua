local F, C, L = unpack(select(2, ...))

local SCALE			= 1
local WIDTH 		= 256
local HEIGHT 		= 2
local _, CLASS 		= UnitClass("player")
local COLOR			= CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[CLASS] or RAID_CLASS_COLORS[CLASS]
local POSITION		= {"TOP", Minimap, "BOTTOM", 0, 32}
local OFFSET		= -3
local TIP			= {"BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -6, 30}
local TEXTURE 		= [[Interface/AddOns/FreeUI/media/statusbar]]

f = CreateFrame("Frame", nil, UIParent)
f:SetPoint(POSITION[1], POSITION[2], POSITION[3], POSITION[4], POSITION[5])
f:SetWidth(WIDTH)
f:SetHeight(HEIGHT)
f:SetScale(SCALE)

RegisterStateDriver(f, "visibility", "[petbattle] hide; show")

-- SETUP BARS
local setBar = function(frame)
	frame:SetStatusBarTexture(TEXTURE)
	frame:SetWidth(WIDTH)
	frame:SetHeight(HEIGHT)
	frame:SetScale(SCALE)
end

local setBackdrop = function(frame) 
	frame.bg = CreateFrame("Frame", nil, frame)
	frame.bg:SetBackdrop({
		bgFile = [[Interface/Buttons/WHITE8X8]],
		tiled = false,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	frame.bg:SetPoint("TOPLEFT", frame, -1, 1)
	frame.bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	frame.bg:SetFrameLevel(1)
	frame.bg:SetBackdropColor(0, 0, 0, .35)
end

local Experience = CreateFrame("StatusBar", nil, f, 'AnimatedStatusBarTemplate')
setBar(Experience)
Experience:SetFrameLevel(4)
Experience:SetStatusBarColor(.4, .1, .6)
Experience:SetPoint(POSITION[1], POSITION[2], POSITION[3], POSITION[4], POSITION[5])
setBackdrop(Experience)

local Rest = CreateFrame("StatusBar", nil, Experience)
setBar(Rest)
Rest:SetFrameLevel(3)
Rest:EnableMouse(false)
Rest:SetStatusBarColor(.2, .4, .8)
Rest:SetAllPoints(Experience)

local Reputation = CreateFrame("StatusBar", nil, f, 'AnimatedStatusBarTemplate')
setBar(Reputation)
Reputation:SetFrameLevel(4)
setBackdrop(Reputation)

--local Artifact = CreateFrame("StatusBar", nil, f, 'AnimatedStatusBarTemplate')
--setBar(Artifact)
--Artifact:SetFrameLevel(4)
--Artifact:SetStatusBarColor(229/255, 205/255, 157/255)
--setBackdrop(Artifact)

--local Honor = CreateFrame("StatusBar", nil, f, 'AnimatedStatusBarTemplate')
--setBar(Honor)
--Honor:SetFrameLevel(4)
--Honor:SetStatusBarColor(205/255, 6/255, 0/255)
--setBackdrop(Honor)

local numberize = function(v)
	if v <= 9999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 10000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

local experience_update = function()
	if UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled() then
		local c, m = UnitXP("player"), UnitXPMax("player")
		local p, r = math.ceil(c/m*100), GetXPExhaustion()

		Experience:SetMinMaxValues(min(0, c), m)
		Experience:SetValue(c)
		Rest:SetMinMaxValues(min(0, c), m)
		Rest:SetValue(r and (c + r) or 0)
	else
		Experience:Hide() 
		Rest:Hide()
	end
end

local showExperienceTooltip = function(self)
	if UnitLevel("player") < MAX_PLAYER_LEVEL and not IsXPUserDisabled() then
		local xpc, xpm, xpr = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion("player")

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(TIP[1], TIP[2], TIP[3], TIP[4], TIP[5])

		GameTooltip:AddLine("Level "..UnitLevel("player"), COLOR.r, COLOR.g, COLOR.b)
		GameTooltip:AddLine((numberize(xpc).."/"..numberize(xpm).." ("..floor((xpc/xpm)*100) .."%)"), 1, 1, 1)
		if xpr then
			GameTooltip:AddLine(numberize(xpr).." ("..floor((xpr/xpm)*100) .."%)", .2, .4, .8)
		end

		GameTooltip:Show()
	end
end

local reputation_update = function()
	if GetWatchedFactionInfo() then
		local _, standing, min, max, value, factionID = GetWatchedFactionInfo()
		local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)

		if friendID then
			if nextFriendThreshold then
				min, max, value = friendThreshold, nextFriendThreshold, friendRep
			else
				min, max, value = 0, 1, 1
			end
			standing = 5
		elseif C_Reputation.IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
			min, max, value = 0, threshold, currentValue
		else
			if standing == MAX_REPUTATION_REACTION then
				min, max, value = 0, 1, 1
			end
		end

		Reputation:ClearAllPoints()
		Reputation:SetMinMaxValues(min, max)
		Reputation:SetValue(value)
		Reputation:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)

		local y = POSITION[5]
		if Experience:IsShown() then
			y = y + OFFSET
		end
		Reputation:SetPoint(POSITION[1], POSITION[2], POSITION[3], POSITION[4], y)
		Reputation:Show()
	else
		Reputation:Hide()
	end
end

local showReputationTooltip = function(self)
	if GetWatchedFactionInfo() then
		local name, standing, min, max, value, factionID = GetWatchedFactionInfo()
		local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
		local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
		local standingtext
		if friendID then
			if maxRank > 0 then
				name = name.." ("..currentRank.." / "..maxRank..")"
			end
			if not nextFriendThreshold then
				value = max - 1
			end
			standingtext = friendTextLevel
		else
			if standing == MAX_REPUTATION_REACTION then
				max = min + 1e3
				value = max - 1
			end
			standingtext = GetText("FACTION_STANDING_LABEL"..standing, UnitSex("player"))
		end

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(TIP[1], TIP[2], TIP[3], TIP[4], TIP[5])

		GameTooltip:AddLine(name, 0,.6,1)
		GameTooltip:AddDoubleLine(standingtext, value - min.."/"..max - min.." ("..floor((value - min)/(max - min)*100).."%)", .6,.8,1, 1,1,1)

		if C_Reputation.IsFactionParagon(factionID) then
			local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
			local paraCount = floor(currentValue/threshold)
			currentValue = mod(currentValue, threshold)
			GameTooltip:AddDoubleLine("ParagonRep"..paraCount, currentValue.."/"..threshold.." ("..floor(currentValue/threshold*100).."%)", .6,.8,1, 1,1,1)
		end

		GameTooltip:Show()
	end
end

--[[local artifact_update = function(self, event)

	if HasArtifactEquipped() then
		local _, _, name, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
		local num, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
		local percent = math.ceil(xp/xpForNextPoint*100)

		Artifact:ClearAllPoints()
		Artifact:SetMinMaxValues(0, xpForNextPoint)
		Artifact:SetValue(xp)
		-- Artifact:SetAnimatedValues(xp, 0, xpForNextPoint, num + pointsSpent)

		local y = POSITION[5]
		if Experience:IsShown() then
			y = y + OFFSET
		end
		if Reputation:IsShown() then
			y = y + OFFSET
		end
		Artifact:SetPoint(POSITION[1], POSITION[2], POSITION[3], POSITION[4], y)
		Artifact:Show()

		-- if spent == 54 then
		-- 	Artifact:Hide()
		-- end
	else
		Artifact:Hide()
	end
end

local showArtifactTooltip = function(self) 
	if HasArtifactEquipped() then
		local _, _, name, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
		local num, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
		local percent = math.ceil(xp/xpForNextPoint*100)

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(TIP[1], TIP[2], TIP[3], TIP[4], TIP[5])

		GameTooltip:AddLine(name, COLOR.r, COLOR.g, COLOR.b)
		GameTooltip:AddLine(name.." ("..format(SPELLBOOK_AVAILABLE_AT, pointsSpent)..")", 0,.6,1)
		-- if pointsSpent > 51 then
		-- 	GameTooltip:AddLine(name.." ("..format(SPELLBOOK_AVAILABLE_AT, pointsSpent)..")", 0,.6,1)
		-- else
		-- 	GameTooltip:AddLine(name.." ("..format(SPELLBOOK_AVAILABLE_AT, pointsSpent)..")", 0,.6,1)
		-- end

		GameTooltip:AddDoubleLine(ARTIFACT_POWER, F.Numb(xp).."/"..F.Numb(xpForNextPoint).." ("..floor(xp/xpForNextPoint*100).."%)".." ("..num..")", .6,.8,1, 1,1,1)

		GameTooltip:Show()
	end
end

local honor_update = function(self, event)
	local level = UnitHonorLevel("player")
	local levelmax = GetMaxPlayerHonorLevel()
	if UnitLevel("player") < MAX_PLAYER_LEVEL or level == levelmax then
		Honor:Hide()
	else
		Honor:ClearAllPoints()
		local current = UnitHonor("player")
		local max = UnitHonorMax("player")

		if (level == levelmax) then
			Honor:SetAnimatedValues(1, 0, 1, level)
		else
			Honor:SetAnimatedValues(current, 0, max, level)
		end

		-- local exhaustionStateID = GetHonorRestState()
		-- if (exhaustionStateID == 1) then
		-- 	Honor:SetStatusBarColor(1.0, 0.71, 0)
		-- 	Honor:SetAnimatedTextureColors(1.0, 0.71, 0)
		-- else
			Honor:SetStatusBarColor(1.0, 0.24, 0)
			Honor:SetAnimatedTextureColors(1.0, 0.24, 0)
		-- end

		local y = POSITION[5]
		if Experience:IsShown() then
			y = y + OFFSET
		end
		if Reputation:IsShown() then
			y = y + OFFSET
		end
		if Artifact:IsShown() then
			y = y + OFFSET
		end
		Honor:SetPoint(POSITION[1], POSITION[2], POSITION[3], POSITION[4], y)
		Honor:Show()
	end
end

local showHonorTooltip = function(self) 
	if UnitLevel("player") == MAX_PLAYER_LEVEL then
		local current, max = UnitHonor("player"), UnitHonorMax("player")
		local level, levelmax = UnitHonorLevel("player"), GetMaxPlayerHonorLevel()
		local text

		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(TIP[1], TIP[2], TIP[3], TIP[4], TIP[5])

		GameTooltip:AddLine(HONOR)

		if CanPrestige() then
			text = PVP_HONOR_PRESTIGE_AVAILABLE
		elseif level == levelmax then
			text = MAX_HONOR_LEVEL
		else
			text = current.."/"..max
		end

		if UnitPrestige("player") > 0 then
			GameTooltip:AddLine(select(2, GetPrestigeInfo(UnitPrestige("player"))), .0,.6,1)
		else
			GameTooltip:AddLine(PVP_PRESTIGE_RANK_UP_TITLE..LEVEL.."0", .0,.6,1)
		end
		GameTooltip:AddDoubleLine(HONOR_POINTS..LEVEL..level, text, .6,.8,1, 1,1,1)

		GameTooltip:Show()
	end
end]]

-- events
Experience:RegisterEvent("PLAYER_ENTERING_WORLD")
Experience:RegisterEvent("PLAYER_LEVEL_UP")
Experience:RegisterEvent("PLAYER_XP_UPDATE")
Experience:RegisterEvent("UPDATE_EXHAUSTION")
Experience:SetScript("OnEvent", experience_update)
Experience:SetScript("OnEnter", function() showExperienceTooltip(Experience) end)
Experience:SetScript("OnLeave", function() GameTooltip:Hide() end)

Reputation:RegisterEvent("PLAYER_ENTERING_WORLD")
Reputation:RegisterEvent("PLAYER_LEVEL_UP")
Reputation:RegisterEvent("UPDATE_EXHAUSTION")
Reputation:RegisterEvent("UPDATE_FACTION")
Reputation:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
Reputation:SetScript("OnEvent", reputation_update)
Reputation:SetScript("OnEnter", function() showReputationTooltip(Reputation) end)
Reputation:SetScript("OnLeave", function() GameTooltip:Hide() end)

--[[Artifact:RegisterEvent("PLAYER_ENTERING_WORLD")
Artifact:RegisterEvent("PLAYER_LEVEL_UP")
Artifact:RegisterEvent("UPDATE_EXHAUSTION")
Artifact:RegisterEvent("UPDATE_FACTION")
Artifact:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
Artifact:RegisterEvent("ARTIFACT_XP_UPDATE")
Artifact:RegisterEvent("ARTIFACT_UPDATE")
Artifact:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
Artifact:SetScript("OnEvent", artifact_update)
Artifact:SetScript("OnEnter", function() showArtifactTooltip(Artifact) end)
Artifact:SetScript("OnLeave", function() GameTooltip:Hide() end)

Honor:RegisterEvent("UPDATE_FACTION")
Honor:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
Honor:RegisterEvent("HONOR_XP_UPDATE")
Honor:RegisterEvent("HONOR_PRESTIGE_UPDATE")
Honor:RegisterEvent("PLAYER_ENTERING_WORLD")
Honor:RegisterEvent("ARTIFACT_XP_UPDATE")
Honor:RegisterEvent("ARTIFACT_UPDATE")
Honor:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
Honor:SetScript("OnEvent", honor_update)
Honor:SetScript("OnEnter", function() showHonorTooltip(Honor) end)
Honor:SetScript("OnLeave", function() GameTooltip:Hide() end)]]