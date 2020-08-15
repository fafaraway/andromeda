local F, C, L = unpack(select(2, ...))
local QUEST = F:GetModule('Quest')


local LE_QUEST_FREQUENCY_DAILY = LE_QUEST_FREQUENCY_DAILY or 2
local C_QuestLog_IsQuestReplayable = C_QuestLog.IsQuestReplayable


function QUEST:QuestTrackerMover()
	local frame = CreateFrame('Frame', 'FreeUIQuestMover', UIParent)
	frame:SetSize(240, 50)
	F.Mover(frame, L['MOVER_QUEST_TRACKER'], 'QuestTracker', {'TOPRIGHT', UIParent, 'TOPRIGHT', -FreeUIConfigsGlobal['ui_gap'], -140})

	local tracker = ObjectiveTrackerFrame
	tracker:ClearAllPoints()
	tracker:SetPoint('TOPRIGHT', frame)
	tracker:SetHeight(C.ScreenHeight/1.7*C.Mult)
	tracker:SetClampedToScreen(false)
	tracker:SetMovable(true)
	if tracker:IsMovable() then tracker:SetUserPlaced(true) end
end

function QUEST:QuestLevel()
	if not FreeUIConfigs['quest']['show_level'] then return end

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

function QUEST:QuestRewardHighlight()
	if not FreeUIConfigs['quest']['auto_select_reward'] then return end

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('QUEST_COMPLETE')
	frame:SetScript('OnEvent', function(self, event, ...)
		local num = GetNumQuestChoices()
		if num == nil or num < 2 then
			return
		end

		local maxSellPrice = -1
		local mostExpensiveItemIndex = -1
		local mostExpensiveItemLink = nil
		for x = 1, num do
			local link = GetQuestItemLink('choice', x)
			if link == nil then
				return
			end

			local _, _, _, _, _, _, _, _, _, _, sellPriceInCopper = GetItemInfo(link)
			if sellPriceInCopper ~= nil and sellPriceInCopper > maxSellPrice then
				maxSellPrice = sellPriceInCopper
				mostExpensiveItemIndex = x
				mostExpensiveItemLink = link
			end
		end

		if mostExpensiveItemIndex < 1 then
			return
		end

		local rewardButton = _G['QuestInfoRewardsFrameQuestInfoItem'..mostExpensiveItemIndex]
		if rewardButton == nil or rewardButton.type ~= 'choice' then
			return
		end

		QuestInfoItemHighlight:SetPoint('TOPLEFT', rewardButton, 'TOPLEFT', -8, 7)
		QuestInfoItemHighlight:Show()
		QuestInfoFrame.itemChoice = rewardButton:GetID()
	end)
end


function QUEST:OnLogin()
	self:QuestTrackerMover()

	if not FreeUIConfigs['quest']['enable_quest'] then return end

	self:QuestLevel()
	self:QuestRewardHighlight()
	self:QuestNotifier()
end
