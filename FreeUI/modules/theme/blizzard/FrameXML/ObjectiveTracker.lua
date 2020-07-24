local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	local r, g, b = C.r, C.g, C.b

	local function reskinQuestIcon(_, block)
		local itemButton = block.itemButton
		if itemButton and not itemButton.styled then
			itemButton:SetNormalTexture("")
			itemButton:SetPushedTexture("")
			itemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			itemButton.icon:SetTexCoord(unpack(C.TexCoord))
			F.CreateBD(itemButton)
			F.CreateSD(itemButton)

			itemButton.styled = true
		end

		local rightButton = block.rightButton
		if rightButton and not rightButton.styled then
			rightButton:SetNormalTexture("")
			rightButton:SetPushedTexture("")
			rightButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			rightButton:SetSize(25, 25)
			rightButton.Icon:SetInside()
			F.CreateBD(rightButton)
			F.CreateSD(rightButton)

			rightButton.styled = true
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", reskinQuestIcon)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", reskinQuestIcon)

	-- Reskin Headers
	local function reskinHeader(header)
		header.Text:SetTextColor(r, g, b)
		header.Background:Hide()
		local bg = header:CreateTexture(nil, "ARTWORK")
		bg:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
		bg:SetTexCoord(0, .66, 0, .31)
		bg:SetVertexColor(r, g, b, .8)
		bg:SetPoint("BOTTOMLEFT", 0, -4)
		bg:SetSize(250, 30)
	end

	local headers = {
		ObjectiveTrackerBlocksFrame.QuestHeader,
		ObjectiveTrackerBlocksFrame.AchievementHeader,
		ObjectiveTrackerBlocksFrame.ScenarioHeader,
		BONUS_OBJECTIVE_TRACKER_MODULE.Header,
		WORLD_QUEST_TRACKER_MODULE.Header,
		ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader
	}
	for _, header in pairs(headers) do reskinHeader(header) end

	-- Reskin Progressbars
	local function reskinBarTemplate(bar)
		F.StripTextures(bar)
		bar:SetStatusBarTexture(C.Assets.norm_tex)
		bar:SetStatusBarColor(r, g, b)
		bar.bg = F.SetBD(bar)
		F:SmoothBar(bar)
	end

	local function reskinProgressbar(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar
		local icon = bar.Icon

		if not bar.bg then
			bar:SetPoint("LEFT", 22, 0)
			reskinBarTemplate(bar)
			BonusObjectiveTrackerProgressBar_PlayFlareAnim = F.Dummy

			icon:SetMask(nil)
			icon.bg = F.ReskinIcon(icon, true)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", bar, "TOPRIGHT", 5, 0)
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 25, 0)
		end

		if icon.bg then
			icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
		end
	end
	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)

	hooksecurefunc(QUEST_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar

		if not bar.bg then
			bar:ClearAllPoints()
			bar:SetPoint("LEFT")
			reskinBarTemplate(bar)
		end
	end)

	local function reskinTimerBar(_, _, line)
		local timerBar = line.TimerBar
		local bar = timerBar.Bar

		if not bar.bg then
			reskinBarTemplate(bar)
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "AddTimerBar", reskinTimerBar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddTimerBar", reskinTimerBar)
	hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", reskinTimerBar)

	-- Reskin Blocks
	hooksecurefunc("ScenarioStage_CustomizeBlock", function(block)
		block.NormalBG:SetTexture("")
		if not block.bg then
			block.bg = F.SetBD(block.GlowTexture, 4, -2, -4, 2)
		end
	end)

	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", function()
		local widgetContainer = ScenarioStageBlock.WidgetContainer
		if not widgetContainer then return end
		local widgetFrame = widgetContainer:GetChildren()
		if widgetFrame and widgetFrame.Frame then
			widgetFrame.Frame:SetAlpha(0)
			for _, bu in next, {widgetFrame.CurrencyContainer:GetChildren()} do
				if bu and not bu.styled then
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
			block.bg = F.SetBD(block, 4, -2, -4, 0)
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", F.AffixesSetup)

	-- Minimize Button
	local minimize = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	F.ReskinExpandOrCollapse(minimize)
	minimize:GetNormalTexture():SetAlpha(0)
	minimize.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
	hooksecurefunc("ObjectiveTracker_Collapse", function() minimize.expTex:SetTexCoord(0, .4375, 0, .4375) end)
	hooksecurefunc("ObjectiveTracker_Expand", function() minimize.expTex:SetTexCoord(.5625, 1, 0, .4375) end)


	-- Fonts
	local tracker = ObjectiveTrackerFrame
	local BlocksFrame = tracker.BlocksFrame

	tracker.HeaderMenu.Title:SetFont(C.Assets.Fonts.Header, 16)

	for _, headerName in pairs({'QuestHeader', 'AchievementHeader', 'ScenarioHeader'}) do
		local header = BlocksFrame[headerName]
		header.Text:SetFont(C.Assets.Fonts.Header, 16)
	end

	do
		local header = BONUS_OBJECTIVE_TRACKER_MODULE.Header
		header.Text:SetFont(C.Assets.Fonts.Header, 16)
	end

	do
		local header = WORLD_QUEST_TRACKER_MODULE.Header
		header.Text:SetFont(C.Assets.Fonts.Header, 16)
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, 'SetBlockHeader', function(_, block)
		if not block.headerStyled then
			block.HeaderText:SetFont(C.Assets.Fonts.Normal, 15)
			block.HeaderText:SetShadowColor(0, 0, 0, 1)
			block.HeaderText:SetShadowOffset(2, -2)
			block.headerStyled = true
		end
	end)

	hooksecurefunc(QUEST_TRACKER_MODULE, 'SetBlockHeader', function(_, block)
		if not block.headerStyled then
			block.HeaderText:SetFont(C.Assets.Fonts.Normal, 15)
			block.HeaderText:SetShadowColor(0, 0, 0, 1)
			block.HeaderText:SetShadowOffset(2, -2)
			block.headerStyled = true
		end
	end)

	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, 'AddObjective', function(_, block)
		local line = block.currentLine

		local p1, a, p2, x, y = line:GetPoint()
		line:SetPoint(p1, a, p2, x, y - 4)
	end)

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, 'AddObjective', function(self, block)
		if block.module == QUEST_TRACKER_MODULE or block.module == ACHIEVEMENT_TRACKER_MODULE then
			local line = block.currentLine

			local p1, a, p2, x, y = line:GetPoint()
			line:SetPoint(p1, a, p2, x, y - 4)
		end
	end)

	local function fixBlockHeight(block)
		if block.shouldFix then
			local height = block:GetHeight()

			if block.lines then
				for _, line in pairs(block.lines) do
					if line:IsShown() then
						height = height + 4
					end
				end
			end

			block.shouldFix = false
			block:SetHeight(height + 4)
			block.shouldFix = true
		end
	end

	hooksecurefunc('ObjectiveTracker_AddBlock', function(block)
		if block.lines then
			for _, line in pairs(block.lines) do
				if not line.styled then
					line.Text:SetFont(C.Assets.Fonts.Normal, 14)
					line.Text:SetShadowColor(0, 0, 0, 1)
					line.Text:SetShadowOffset(2, -2)
					line.Text:SetSpacing(2)

					if line.Dash then
						line.Text:SetFont(C.Assets.Fonts.Normal, 14)
						line.Text:SetShadowColor(0, 0, 0, 1)
						line.Text:SetShadowOffset(2, -2)
					end

					line:SetHeight(line.Text:GetHeight())

					line.styled = true
				end
			end
		end

		if not block.styled then
			block.shouldFix = true
			hooksecurefunc(block, 'SetHeight', fixBlockHeight)
			block.styled = true
		end
	end)
end)