local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local r, g, b = C.r, C.g, C.b
	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.NameFrame:Hide()

		bu.Icon:SetDrawLayer("BACKGROUND", 1)
		F.ReskinIcon(bu.Icon)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", bu, 1, 1)

		if isMapQuestInfo then
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 0)
			bu.Icon:SetSize(29, 29)
		else
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 1)
		end

		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)

		bu.bg = bg
	end

	local function restyleSpellButton(bu)
		local name = bu:GetName()
		local icon = bu.Icon

		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		icon:SetPoint("TOPLEFT", 3, -2)
		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(icon)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 14)
		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)
	end
	local function colourObjectivesText()
		if not QuestInfoFrame.questLog then return end

		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, GetNumQuestLeaderBoards() do
			local _, objectiveType, isCompleted = GetQuestLogLeaderBoard(i)

			if (objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if isCompleted then
					objective:SetTextColor(.9, .9, .9)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end

	restyleSpellButton(QuestInfoSpellObjectiveFrame)
	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
	hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material, mapView)
		local rewardsFrame = QuestInfoFrame.rewardsFrame
		local isQuestLog = QuestInfoFrame.questLog ~= nil
		local isMapQuest = rewardsFrame == MapQuestInfoRewardsFrame

		colourObjectivesText()

		if ( template.canHaveSealMaterial ) then
			local questFrame = parentFrame:GetParent():GetParent()
			questFrame.SealMaterialBG:Hide()
		end

		local numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()
		if numSpellRewards > 0 then
			-- Spell Headers
			for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
				spellHeader:SetVertexColor(1, 1, 1)
			end
			-- Follower Rewards
			for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
				if not followerReward.isSkinned then
					followerReward.PortraitFrame:SetScale(1)
					followerReward.PortraitFrame:ClearAllPoints()
					followerReward.PortraitFrame:SetPoint("TOPLEFT")
					if isMapQuest then
						followerReward.PortraitFrame.Portrait:SetSize(29, 29)
					end
					F.ReskinGarrisonPortrait(followerReward.PortraitFrame)

					followerReward.BG:Hide()
					followerReward.BG:SetPoint("TOPLEFT", followerReward.PortraitFrame, "TOPRIGHT")
					followerReward.BG:SetPoint("BOTTOMRIGHT")
					F.CreateBD(followerReward, .25)
					followerReward:SetHeight(followerReward.PortraitFrame:GetHeight())

					if not isMapQuest then
						followerReward.Class:SetWidth(45)
					end

					followerReward.isSkinned = true
				end
				followerReward.PortraitFrame:SetBackdropBorderColor(followerReward.PortraitFrame.PortraitRingQuality:GetVertexColor())
			end
			-- Spell Rewards
			for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
				if not spellReward.isSkinned then
					restyleRewardButton(spellReward, isMapQuest)
					local border = select(4, spellReward:GetRegions())
					border:Hide()
					if not isMapQuest then
						spellReward.Icon:SetPoint("TOPLEFT", 0, 0)
						spellReward:SetHitRectInsets(0,0,0,0)
						spellReward:SetSize(147, 41)
					end
					spellReward.isSkinned = true
				end
			end
		end
	end)

	--QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	--QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy


	--[[ QuestInfoRewardsFrame ]]
	local QuestInfoRewardsFrame = QuestInfoRewardsFrame
	QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.Header.SetTextColor = F.dummy
	QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemChooseText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = F.dummy

	for i, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
		restyleRewardButton(QuestInfoRewardsFrame[name])
	end
	QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = F.dummy

	local function clearHighlight()
		for _, button in next, QuestInfoRewardsFrame.RewardButtons do
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end
	local function setHighlight(self)
		clearHighlight()

		local _, point = self:GetPoint()
		if point then
			point.bg:SetBackdropColor(r, g, b, .2)
		end
	end

	local ItemHighlight = QuestInfoRewardsFrame.ItemHighlight
	ItemHighlight:GetRegions():Hide()

	hooksecurefunc(ItemHighlight, "SetPoint", setHighlight)
	ItemHighlight:HookScript("OnShow", setHighlight)
	ItemHighlight:HookScript("OnHide", clearHighlight)


	--[[ MapQuestInfoRewardsFrame ]]
	for i, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame"} do
		restyleRewardButton(MapQuestInfoRewardsFrame[name], true)
	end
	MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)


	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.restyled then
			restyleRewardButton(bu, rewardsFrame == MapQuestInfoRewardsFrame)

			bu.restyled = true
		end
	end)

	--[[ QuestInfoFrame ]]
	QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	QuestInfoTitleHeader.SetTextColor = F.dummy
	QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	QuestInfoObjectivesText.SetTextColor = F.dummy

	QuestInfoRewardText:SetTextColor(1, 1, 1)
	QuestInfoRewardText.SetTextColor = F.dummy

	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, red, green, blue)
		if red == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif red == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	QuestInfoGroupSize:SetTextColor(1, 1, 1)
	QuestInfoGroupSize.SetTextColor = F.dummy

	QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	QuestInfoDescriptionHeader.SetTextColor = F.dummy
	QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	QuestInfoObjectivesHeader.SetTextColor = F.dummy
	QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	QuestInfoDescriptionText.SetTextColor = F.dummy

	--[[ QuestInfoSealFrame ]]
	QuestInfoSealFrame.Text:SetShadowColor(0.2, 0.2, 0.2)
	QuestInfoSealFrame.Text:SetShadowOffset(0.6, -0.6)
end)
