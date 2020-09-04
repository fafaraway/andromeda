local F, C, L = unpack(select(2, ...))
local QUEST = F:GetModule('QUEST')


local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY or 2
local C_QuestLog_IsQuestReplayable = C_QuestLog.IsQuestReplayable


function QUEST:ObjectiveTrackerMover()
	local frame = CreateFrame('Frame', 'FreeUIQuestMover', UIParent)
	frame:SetSize(240, 50)
	F.Mover(frame, L['QUEST_MOVER_TRACKER'], 'QuestTracker', {'TOPRIGHT', UIParent, 'TOPRIGHT', -FreeADB['ui_gap'], -140})

	local tracker = ObjectiveTrackerFrame
	tracker:ClearAllPoints()
	tracker:SetPoint('TOPRIGHT', frame)
	tracker:SetHeight(C.ScreenHeight/2*C.Mult)
	tracker:SetClampedToScreen(false)
	tracker:SetMovable(true)
	if tracker:IsMovable() then tracker:SetUserPlaced(true) end
end

function QUEST:QuestLevel()
	if not FreeDB.quest.quest_level then return end

	local function Showlevel(_, _, _, title, level, _, isHeader, _, isComplete, frequency, questID)
		if ENABLE_COLORBLIND_MODE == '1' then return end

		for button in pairs(QuestScrollFrame.titleFramePool.activeObjects) do
			if title and not isHeader and button.questID == questID then
				local title = '['..level..'] '..title
				if isComplete then
					title = '|cffff78ff'..title
				elseif C_QuestLog_IsQuestReplayable(questID) then
					title = '|cff00ff00'..title
				elseif frequency == LE_QUEST_FREQUENCY_DAILY then
					title = '|cff3399ff'..title
				end
				button.Text:SetText(title)
				button.Text:SetPoint('TOPLEFT', 24, -5)
				button.Text:SetWidth(205)
				button.Text:SetWordWrap(false)
				button.Check:SetPoint('LEFT', button.Text, button.Text:GetWrappedWidth(), 0)
			end
		end
	end
	hooksecurefunc('QuestLogQuests_AddQuestButton', Showlevel)
end

local function SetRewardHighlight(self, reward)
	if not self.rewardHighlightFrame then
		self.rewardHighlightFrame = CreateFrame('Frame', 'QuesterRewardHighlight', QuestInfoRewardsFrame, 'AutoCastShineTemplate')
		self.rewardHighlightFrame:SetScript('OnHide', function(frame) AutoCastShine_AutoCastStop(frame) end)
	end

	self.rewardHighlightFrame:ClearAllPoints()
	self.rewardHighlightFrame:SetAllPoints(reward)
	self.rewardHighlightFrame:Show()

	AutoCastShine_AutoCastStart(self.rewardHighlightFrame)
end

function QUEST:QUEST_COMPLETE()
	local frame = CreateFrame('Frame')
	frame:RegisterEvent('QUEST_COMPLETE')
	frame:SetScript('OnEvent', function(self, event, ...)
		if self.rewardHighlightFrame then
			self.rewardHighlightFrame:Hide()
		end

		if not FreeDB.quest.reward_highlight then return end

		local bestprice, bestitem = 0, 0
		for i = 1, GetNumQuestChoices() do
			local link, name, _, qty = GetQuestItemLink('choice', i), GetQuestItemInfo('choice', i)
			local price = link and select(11, GetItemInfo(link))
			if not price then return end
			price = price * (qty or 1)
			if price > bestprice then
				bestprice = price
				bestitem = i
			end
		end
		if bestitem > 0 then
			SetRewardHighlight(self, _G[('QuestInfoRewardsFrameQuestInfoItem%dIconTexture'):format(bestitem)])
		end
	end)
end


function QUEST:OnLogin()
	self:ObjectiveTrackerMover()
	self:QuestLevel()
	self:QuestNotifier()
	self:QUEST_COMPLETE()
end
