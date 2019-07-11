local F, C, L = unpack(select(2, ...))


-- Sonic Reputation

local SR_REP_MSG = '%s (%d/%d): %+d Reputation';
local rep = {};

-- 额外声望
local extraRep = {};
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local function SR_Update()
	local numFactions = GetNumFactions(self);
	for i = 1, numFactions, 1 do
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i);
		local value = 0;
		-- 7.2 额外声望
		if barValue >= 42000 then
			local hasParagon = C_Reputation_IsFactionParagon(factionID)
			if hasParagon then
				initExtraRep(factionID,name)
				local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
				value = currentValue % threshold
				if hasRewardPending then 
					value = value + threshold
				end
				local extraChange = value - extraRep[name];
				if(extraChange > 0) then 
					extraRep[name] = value
					local extra_msg = string.format(SR_REP_MSG, name, value, threshold, extraChange)
					createMessage(extra_msg);
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
				createMessage(msg)
			end
		end
	end
end
function createMessage(msg)
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

function initExtraRep(factionID, name)
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

local frame = CreateFrame('Frame');
frame:RegisterEvent('UPDATE_FACTION');
frame:SetScript('OnEvent', SR_Update);
ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', function() return true; end);