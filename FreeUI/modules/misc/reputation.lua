local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('MISC')

-- #TODO
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local NUM_FACTIONS_DISPLAYED = NUM_FACTIONS_DISPLAYED
local REPUTATION_PROGRESS_FORMAT = REPUTATION_PROGRESS_FORMAT
local SR_REP_MSG = '%s (%d/%d): %+d '..L['MISC_REPUTATION']
local SR_REP_MSG2 = C.GreenColor..'%s (%d/10000): %+d '..L['MISC_PARAGON_REPUTATION']..'|r'
local SR_REP_MSG3 = C.RedColor..'%s (%d/10000): %+d '..L['MISC_PARAGON_REPUTATION']..' ('..L['MISC_PARAGON_NOTIFY']..')|r'
local rep = {}
local extraRep = {}


local function CreateMessage(msg)
	local info = ChatTypeInfo['COMBAT_FACTION_CHANGE'];
	for j = 1, 4, 1 do
		local chatfrm = getglobal('ChatFrame'..j);
		for k,v in pairs(chatfrm.messageTypeList) do
			if v == 'COMBAT_FACTION_CHANGE' then
				chatfrm:AddMessage(msg, info.r, info.g, info.b, info.id);
				break;
			end
		end
	end
end

local function InitExtraRep(factionID, name)
	local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID);
	if not extraRep[name] then
		extraRep[name] = currentValue % threshold
		if hasRewardPending then
			extraRep[name] = extraRep[name] + threshold
		end
	end
	if extraRep[name] > threshold and (not hasRewardPending) then
		extraRep[name] = extraRep[name] - threshold
	end
end

local function RepUpdate()
	local numFactions = GetNumFactions(self);
	for i = 1, numFactions, 1 do
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i);
		local value = 0;
		if barValue >= 42000 then
			local hasParagon = C_Reputation_IsFactionParagon(factionID)
			if hasParagon then
				InitExtraRep(factionID,name)
				local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
				value = currentValue % threshold
				if hasRewardPending then
					value = value + threshold
				end
				local extraChange = value - extraRep[name];
				if extraChange > 0 and value < 10000 then
					extraRep[name] = value
					local extra_msg = string.format(SR_REP_MSG2, name, value, extraChange)
					CreateMessage(extra_msg);
				end
				if extraChange ~= 0 and value > 10000 then
					extraRep[name] = value
					local extra_msg2 = string.format(SR_REP_MSG3, name, value, extraChange)
					CreateMessage(extra_msg2);
				end
			end
		elseif name and (not isHeader) or (hasRep) then
			if not rep[name] then
				rep[name] = barValue;
			end
			local change = barValue - rep[name];
			if (change > 0) then
				rep[name] = barValue
				local msg = string.format(SR_REP_MSG, name, barValue - barMin, barMax - barMin, change)
				CreateMessage(msg)
			end
		end
	end
end

local function HookParagonRep()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G['ReputationBar'..i]
		local factionBar = _G['ReputationBar'..i..'ReputationBar']
		local factionStanding = _G['ReputationBar'..i..'ReputationBarFactionStanding']

		if factionIndex <= numFactions then
			local factionID = select(14, GetFactionInfo(factionIndex))
			if factionID and C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)

				if currentValue then
					local barValue = mod(currentValue, threshold)
					local factionStandingtext = L['MISC_PARAGON']..' ('..floor(currentValue/threshold)..')'

					factionBar:SetMinMaxValues(0, threshold)
					factionBar:SetValue(barValue)
					factionStanding:SetText(factionStandingtext)
					factionRow.standingText = factionStandingtext
					factionRow.rolloverText = C.InfoColor..format(REPUTATION_PROGRESS_FORMAT, barValue, threshold)
				end
			end
		end
	end
end


function MISC:Reputation()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_FACTION')
	f:SetScript('OnEvent', RepUpdate)

	ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', function()
		return true
	end)

	hooksecurefunc('ReputationFrame_Update', HookParagonRep)
end

MISC:RegisterMisc('Reputation', MISC.Reputation)
