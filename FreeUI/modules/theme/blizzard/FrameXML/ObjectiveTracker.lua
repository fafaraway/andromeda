local F, C = unpack(select(2, ...))


local function reskinQuestIcon(button)
	if not button then return end

	if not button.styled then
		button:SetSize(24, 24)
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		local icon = button.icon or button.Icon
		if icon then
			button.bg = F.ReskinIcon(icon, true)
			icon:SetInside()
		end

		button.styled = true
	end

	if button.bg then
		button.bg:SetFrameLevel(0)
	end
end

local function reskinQuestIcons(_, block)
	reskinQuestIcon(block.itemButton)
	reskinQuestIcon(block.rightButton)
end

local function reskinHeader()
	local frame = ObjectiveTrackerFrame.MODULES

	if frame then
		for i = 1, #frame do
			local modules = frame[i]
			if modules then
				local header = modules.Header

				local background = modules.Header.Background
				background:SetAtlas(nil)

				if not modules.IsSkinned then
					local headerPanel = _G.CreateFrame('Frame', nil, header)
					headerPanel:SetFrameLevel(header:GetFrameLevel() - 1)
					headerPanel:SetFrameStrata('BACKGROUND')
					headerPanel:SetPoint('TOPLEFT', 1, 1)
					headerPanel:SetPoint('BOTTOMRIGHT', 1, 1)

					local headerBar = headerPanel:CreateTexture(nil, 'ARTWORK')
					headerBar:SetTexture('Interface\\LFGFrame\\UI-LFG-SEPARATOR')
					headerBar:SetTexCoord(0, 0.6640625, 0, 0.3125)
					headerBar:SetVertexColor(C.r, C.g, C.b, .6)
					headerBar:SetPoint('CENTER', headerPanel, -20, -4)
					headerBar:SetSize(232, 30)

					modules.IsSkinned = true
				end
			end
		end
	end
end

local function reskinBarTemplate(bar)
	if bar.bg then return end

	F.StripTextures(bar)
	bar:SetStatusBarTexture(C.Assets.norm_tex)
	bar:SetStatusBarColor(C.r, C.g, C.b)
	bar.bg = F.SetBD(bar)
	F:SmoothBar(bar)
end

local function reskinProgressbar(_, _, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local label = bar.Label

	if not bar.bg then
		bar:ClearAllPoints()
		bar:SetPoint("LEFT")

		label:ClearAllPoints()
		label:SetPoint('CENTER', bar)
		label:SetFont(C.Assets.Fonts.Regular, 11, true)
		label:SetShadowColor(0, 0, 0, 1)
		label:SetShadowOffset(1, -1)

		reskinBarTemplate(bar)
	end
end

local function reskinProgressbarWithIcon(_, _, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon
	local label = bar.Label

	if not bar.bg then
		bar:SetPoint("LEFT", 22, 0)
		reskinBarTemplate(bar)
		BonusObjectiveTrackerProgressBar_PlayFlareAnim = F.Dummy

		icon:SetMask(nil)
		icon.bg = F.ReskinIcon(icon, true)
		icon:ClearAllPoints()
		icon:SetSize(20, 20)
		icon:SetPoint('LEFT', bar, 'RIGHT', 5, 0)

		label:ClearAllPoints()
		label:SetPoint('CENTER', bar)
		label:SetFont(C.Assets.Fonts.Regular, 11, true)
		label:SetShadowColor(0, 0, 0, 1)
		label:SetShadowOffset(1, -1)
	end

	if icon.bg then
		icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
	end
end

local function reskinTimerBar(_, _, line)
	local timerBar = line.TimerBar
	local bar = timerBar.Bar

	if not bar.bg then
		reskinBarTemplate(bar)
	end
end

local function updateMinimizeButton(button, collapsed)
	button.__texture:DoCollapse(collapsed)
end

local function reskinMinimizeButton(button)
	F.ReskinCollapse(button)
	button:GetNormalTexture():SetAlpha(0)
	button:GetPushedTexture():SetAlpha(0)
	button.__texture:DoCollapse(false)
	hooksecurefunc(button, "SetCollapsed", updateMinimizeButton)
end

local atlasToQuality = {
	["jailerstower-animapowerlist-powerborder-white"] = LE_ITEM_QUALITY_COMMON,
	["jailerstower-animapowerlist-powerborder-green"] = LE_ITEM_QUALITY_UNCOMMON,
	["jailerstower-animapowerlist-powerborder-blue"] = LE_ITEM_QUALITY_RARE,
	["jailerstower-animapowerlist-powerborder-purple"] = LE_ITEM_QUALITY_EPIC,
}

local function updateMawBuffQuality(button, spellID)
	if not spellID then return end

	local atlas = C_Spell.GetMawPowerBorderAtlasBySpellID(spellID)
	local quality = atlasToQuality[atlas]
	local color = C.QualityColors[quality or 1]
	if button.bg then
		button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

local function updateMawBuffInfo(button, buffInfo)
	updateMawBuffQuality(button, buffInfo.spellID)
end


tinsert(C.BlizzThemes, function()
	local r, g, b = C.r, C.g, C.b

	hooksecurefunc('ObjectiveTracker_Update', reskinHeader)

	-- QuestIcons
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", reskinQuestIcons)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", reskinQuestIcons)
	hooksecurefunc(CAMPAIGN_QUEST_TRACKER_MODULE, "AddObjective", reskinQuestIcons)

	-- Reskin Progressbars
	hooksecurefunc(QUEST_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
	hooksecurefunc(CAMPAIGN_QUEST_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)

	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", reskinProgressbarWithIcon)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", reskinProgressbarWithIcon)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", reskinProgressbarWithIcon)

	hooksecurefunc(QUEST_TRACKER_MODULE, "AddTimerBar", reskinTimerBar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddTimerBar", reskinTimerBar)
	hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", reskinTimerBar)

	-- Reskin Blocks
	hooksecurefunc("ScenarioStage_CustomizeBlock", function(block)
		block.NormalBG:SetTexture("")
		if not block.bg then
			block.bg = F.SetBD(block.GlowTexture, nil, 4, -2, -4, 2)
		end
	end)

	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", function()
		local widgetContainer = ScenarioStageBlock.WidgetContainer
		if not widgetContainer then return end

		local widgetFrame = widgetContainer:GetChildren()
		if widgetFrame and widgetFrame.Frame then
			widgetFrame.Frame:SetAlpha(0)

			for i = 1, widgetFrame.CurrencyContainer:GetNumChildren() do
				local bu = select(i, widgetFrame.CurrencyContainer:GetChildren())
				if bu and bu.Icon and not bu.styled then
					F.ReskinIcon(bu.Icon)
					bu.styled = true
				end
			end
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_ShowBlock", function()
		local block = ScenarioChallengeModeBlock
		if not block.bg then
			block.TimerBG:Hide()
			block.TimerBGBack:Hide()
			block.timerbg = F.CreateBDFrame(block.TimerBGBack, .3)
			block.timerbg:SetPoint("TOPLEFT", block.TimerBGBack, 6, -2)
			block.timerbg:SetPoint("BOTTOMRIGHT", block.TimerBGBack, -6, -5)

			block.StatusBar:SetStatusBarTexture(C.Assets.norm_tex)
			block.StatusBar:SetStatusBarColor(r, g, b)
			block.StatusBar:SetHeight(10)

			select(3, block:GetRegions()):Hide()
			block.bg = F.SetBD(block, nil, 4, -2, -4, 0)
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", F.AffixesSetup)

	-- Block in jail tower
	local mawBuffsBlock = ScenarioBlocksFrame.MawBuffsBlock
	local bg = F.SetBD(mawBuffsBlock, nil, 20, -10, -20, 10)
	bg:SetBackdropColor(0, .5, .5, .25)

	local blockContainer = mawBuffsBlock.Container
	F.StripTextures(blockContainer)
	blockContainer:GetPushedTexture():SetAlpha(0)
	blockContainer:GetHighlightTexture():SetAlpha(0)

	local blockList = blockContainer.List
	blockList.__bg = bg
	blockList:HookScript("OnShow", function(self)
		self.__bg:SetBackdropBorderColor(1, .8, 0, .5)

		for mawBuff in self.buffPool:EnumerateActive() do
			if mawBuff:IsShown() and not mawBuff.bg then
				mawBuff.Border:SetAlpha(0)
				mawBuff.CircleMask:Hide()
				mawBuff.CountRing:SetAlpha(0)
				mawBuff.HighlightBorder:SetColorTexture(1, 1, 1, .25)
				mawBuff.bg = F.ReskinIcon(mawBuff.Icon)

				updateMawBuffQuality(mawBuff, mawBuff.spellID)
				hooksecurefunc(mawBuff, "SetBuffInfo", updateMawBuffInfo)
			end
		end
	end)
	blockList:HookScript("OnHide", function(self)
		self.__bg:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	F.StripTextures(blockList)
	F.SetBD(blockList)


	local headers = {
		ObjectiveTrackerBlocksFrame.QuestHeader,
		ObjectiveTrackerBlocksFrame.AchievementHeader,
		ObjectiveTrackerBlocksFrame.ScenarioHeader,
		ObjectiveTrackerBlocksFrame.CampaignQuestHeader,
		BONUS_OBJECTIVE_TRACKER_MODULE.Header,
		WORLD_QUEST_TRACKER_MODULE.Header,
		ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader
	}


	-- Minimize Button
	local mainMinimize = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	reskinMinimizeButton(mainMinimize)
	mainMinimize.bg:SetBackdropBorderColor(1, .8, 0, .5)

	for _, header in pairs(headers) do
		local minimize = header.MinimizeButton
		if minimize then
			reskinMinimizeButton(minimize)
		end
	end

	F.SetFS(ObjectiveTrackerFrame.HeaderMenu.Title, C.Assets.Fonts.Header, 15, nil, nil, nil, 'THICK')
end)


