local F, C, L = unpack(select(2, ...))
local QUEST = F.QUEST


local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY or 2
local C_QuestLog_IsQuestReplayable = C_QuestLog.IsQuestReplayable


function QUEST:UpdateTrackerScale()
	local tracker = ObjectiveTrackerFrame
	local scale = FreeDB.quest.tracker_scale
	tracker:SetScale(scale)
end

function QUEST:ObjectiveTrackerMover()
	local frame = CreateFrame('Frame', 'FreeUIQuestMover', UIParent)
	frame:SetSize(240, 50)
	F.Mover(frame, L['QUEST_MOVER_TRACKER'], 'QuestTracker', {'TOPRIGHT', UIParent, 'TOPRIGHT', -C.UIGap, -60})

	local tracker = ObjectiveTrackerFrame
	tracker:ClearAllPoints()
	tracker:SetPoint('TOPRIGHT', frame)
	tracker:SetHeight(C.ScreenHeight / 2 * C.Mult)
	tracker:SetClampedToScreen(false)
	tracker:SetMovable(true)
	if tracker:IsMovable() then tracker:SetUserPlaced(true) end
end


-- Show quest level
local function QuestLogQuests_GetTitle(displayState, info)
	local title = info.title;

	if displayState.displayQuestID then
		title = info.questID..' - '..title;
	end

	if displayState.showReadyToRecord then
		if info.readyForTranslation ~= nil then
			if info.readyForTranslation == false then
				title = '<Not Ready for Translation> ' .. title;
			end
		end
	end

	title = '['..info.difficultyLevel..'] '..title;

	-- If not a header see if any nearby group mates are on this quest
	local partyMembersOnQuest = QuestUtils_GetNumPartyMembersOnQuest(info.questID);

	if partyMembersOnQuest > 0 then
		title = '['..partyMembersOnQuest..'] '..title;
	end

	return title;
end

local function QuestLogQuests_ShouldShowQuestButton(info)
	-- If it's not a quest, then it shouldn't show as a quest button
	if info.isHeader then
		return false;
	end

	-- If it is a quest, but its header is collapsed, then it shouldn't show
	if info.header and info.header.isCollapsed then
		return false;
	end

	-- Normal rules about quest visibility.
	-- NOTE: IsComplete checks should be cached if possible...coming soon...
	return not info.isTask and not info.isHidden and (not info.isBounty or C_QuestLog.IsComplete(info.questID));
end

local function QuestLogQuests_BuildSingleQuestInfo(questLogIndex, questInfoContainer, lastHeader)
	local info = C_QuestLog.GetInfo(questLogIndex);
	if not info then return end

	questInfoContainer[questLogIndex] = info;

	-- Precompute whether or not the headers should display so that it's easier to add them later.
	-- We don't care about collapsed states, we only care about the fact that there are any quests
	-- to display under the header.
	-- Caveat: Campaign headers will always display, otherwise they wouldn't be added to the quest log!
	if info.isHeader then
		lastHeader = info;

		local isCampaign = info.campaignID ~= nil;
		info.shouldDisplay = isCampaign; -- Always display campaign headers, the rest start as hidden
	else
		info.isCalling = C_QuestLog.IsQuestCalling(info.questID);  -- TOOD: Do this in QuestLog? Either way, cached for later use

		if lastHeader and not lastHeader.shouldDisplay then
			lastHeader.shouldDisplay = info.isCalling or QuestLogQuests_ShouldShowQuestButton(info);
		end

		-- Make it easy for a quest to look up its header
		info.header = lastHeader;

		-- Might as well just keep this in Lua
		if info.isCalling and info.header then
			info.header.isCalling = true;
		end
	end

	return lastHeader;
end

local function QuestLogQuests_BuildQuestInfoContainer()
	local questInfoContainer = {};
	local numEntries = C_QuestLog.GetNumQuestLogEntries();
	local lastHeader;

	for questLogIndex = 1, numEntries do
		lastHeader = QuestLogQuests_BuildSingleQuestInfo(questLogIndex, questInfoContainer, lastHeader);
	end

	return questInfoContainer;
end

local function QuestLogQuests_BuildInitialDisplayState(poiTable, questInfoContainer)
	return {
		questInfoContainer = questInfoContainer,
		poiTable = poiTable,
		displayQuestID = GetCVarBool('displayQuestID'),
		showReadyToRecord = GetCVarBool('showReadyToRecord'),
		questPOI = GetCVarBool('questPOI'),
	};
end


-- Highlight high value reward
local function CreateHighlight(reward)
	if not QUEST.rewardHighlightFrame then
		QUEST.rewardHighlightFrame = CreateFrame('Frame', 'QuesterRewardHighlight', QuestInfoRewardsFrame, 'AutoCastShineTemplate')
		QUEST.rewardHighlightFrame:SetScript('OnHide', function(frame) AutoCastShine_AutoCastStop(frame) end)
	end

	QUEST.rewardHighlightFrame:ClearAllPoints()
	QUEST.rewardHighlightFrame:SetAllPoints(reward)
	QUEST.rewardHighlightFrame:Show()

	AutoCastShine_AutoCastStart(QUEST.rewardHighlightFrame)
end

local function UpdateHighlight()
	if QUEST.rewardHighlightFrame then
		QUEST.rewardHighlightFrame:Hide()
	end

	local bestprice, bestitem = 0, 0
	for i = 1, GetNumQuestChoices() do
		local link, _, _, qty = GetQuestItemLink('choice', i), GetQuestItemInfo('choice', i)
		local price = link and select(11, GetItemInfo(link))
		if not price then return end

		price = price * (qty or 1)

		if price > bestprice then
			bestprice = price
			bestitem = i
		end
	end

	local rewardButton = _G['QuestInfoRewardsFrameQuestInfoItem'..bestitem]

	if bestitem > 0 then
		CreateHighlight(_G[('QuestInfoRewardsFrameQuestInfoItem%dIconTexture'):format(bestitem)])

		_G.QuestInfoFrame.itemChoice = rewardButton:GetID()
	end
end

function QUEST:QuestRewardHighlight()
	if FreeDB.quest.reward_highlight then
		F:RegisterEvent('QUEST_COMPLETE', UpdateHighlight)
	else
		F:UnregisterEvent('QUEST_COMPLETE', UpdateHighlight)
	end
end


function QUEST:OnLogin()
	self:ObjectiveTrackerMover()
	self:UpdateTrackerScale()
	self:QuestRewardHighlight()
	self:QuestNotification()

	hooksecurefunc('QuestLogQuests_Update', function(poiTable)
		local questInfoContainer = QuestLogQuests_BuildQuestInfoContainer()
		local displayState = QuestLogQuests_BuildInitialDisplayState(poiTable, questInfoContainer)

		for button in QuestScrollFrame.titleFramePool:EnumerateActive() do
			local t = QuestLogQuests_GetTitle(displayState, button.info)
			button.Text:SetText(QuestUtils_DecorateQuestText(button.questID, t, false, false, true))
		end
	end)
end
