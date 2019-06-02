local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local pairs = pairs
local r, g, b =  C.r, C.g, C.b
local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
local ot = ObjectiveTrackerFrame
local BlocksFrame = ot.BlocksFrame
local minimize = ot.HeaderMenu.MinimizeButton

local otFontHeader = {C.font.header,16,nil}
local otFont = {C.font.normal,12,nil}


function BLIZZARD:QuestTracker()
	if not C.general.questTracker then return end

	-- Move Tracker Frame
	local mover = CreateFrame('Frame', 'ObjectiveTrackerFrameMover', ot)
	mover:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -50, -300)
	mover:SetSize(50, 50)
	F.CreateMF(minimize, mover)
	minimize:SetFrameStrata('HIGH')
	minimize:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOP')
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L['TOGGLE'], 1, .8, 0)
		GameTooltip:Show()
	end)
	minimize:HookScript('OnLeave', F.HideTooltip)

	hooksecurefunc(ot, 'SetPoint', function(_, _, parent)
		if parent ~= mover then
			ot:ClearAllPoints()
			ot:SetPoint('TOPRIGHT', mover)
			ot:SetHeight(pysHeight/2)
			--ot:SetWidth(240)
		end
	end)

	--[[local otMover = F.Mover(ot, L['MOVER_MINIMAP'], 'ObjectiveTrackerFrame', {'TOPRIGHT', UIParent, 'TOPRIGHT', -50, -340}, 240, 240)
	hooksecurefunc(ot, 'SetPoint', function(_, _, parent)
		if parent ~= otMover then
			ot:ClearAllPoints()
			ot:SetPoint('TOPRIGHT', otMover)
			ot:SetHeight(800)
			ot:SetWidth(240)
		end
	end)]]

	RegisterStateDriver(ot, 'visibility', '[petbattle] hide; show')
	
	-- Questblock click enhant
	local function QuestHook(id)
		local questLogIndex = GetQuestLogIndexByID(id)
		if IsControlKeyDown() and CanAbandonQuest(id) then -- ctrl+click to abandon quest
			QuestMapQuestOptions_AbandonQuest(id)
		elseif IsAltKeyDown() and GetQuestLogPushable(questLogIndex) then -- alt+click to share quest
			QuestMapQuestOptions_ShareQuest(id)
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, 'OnBlockHeaderClick', function(self, block) QuestHook(block.id) end)
	hooksecurefunc('QuestMapLogTitleButton_OnClick', function(self) QuestHook(self.questID) end)


	-- Show quest color and level
	local function Showlevel(_, _, _, title, level, _, isHeader, _, isComplete, frequency, questID)
		if ENABLE_COLORBLIND_MODE == '1' then return end

		for button in pairs(QuestScrollFrame.titleFramePool.activeObjects) do
			if title and not isHeader and button.questID == questID then
				local title = '['..level..'] '..title
				if isComplete then
					title = '|cffff78ff'..title
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


	-- Headers background
	local function reskinHeader(header)
		-- header.Text:SetTextColor(r, g, b)
		header.Background:Hide()
		local bg = header:CreateTexture(nil, 'ARTWORK')
		bg:SetTexture('Interface\\LFGFrame\\UI-LFG-SEPARATOR')
		bg:SetTexCoord(0, .66, 0, .31)
		bg:SetVertexColor(r, g, b, .8)
		bg:SetPoint('BOTTOMLEFT', -30, -4)
		bg:SetSize(210, 30)
	end

	local headers = {
		ObjectiveTrackerBlocksFrame.QuestHeader,
		ObjectiveTrackerBlocksFrame.AchievementHeader,
		ObjectiveTrackerBlocksFrame.ScenarioHeader,
		BONUS_OBJECTIVE_TRACKER_MODULE.Header,
		WORLD_QUEST_TRACKER_MODULE.Header,
	}
	for _, header in pairs(headers) do reskinHeader(header) end


	-- Icons
	local function reskinQuestIcon(_, block)
		local itemButton = block.itemButton
		if itemButton and not itemButton.styled then
			itemButton:SetNormalTexture('')
			itemButton:SetPushedTexture('')
			itemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			itemButton.icon:SetTexCoord(unpack(C.TexCoord))
			local bg = F.CreateBDFrame(itemButton.icon)
			F.CreateSD(bg)

			itemButton.Count:ClearAllPoints()
			itemButton.Count:SetPoint('TOP', itemButton, 2, -1)
			itemButton.Count:SetJustifyH('CENTER')
			F.SetFS(itemButton.Count)

			itemButton.styled = true
		end

		local rightButton = block.rightButton
		if rightButton and not rightButton.styled then
			rightButton:SetNormalTexture('')
			rightButton:SetPushedTexture('')
			rightButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			local bg = F.CreateBDFrame(rightButton)
			F.CreateSD(bg)
			rightButton:SetSize(18, 18)
			rightButton.Icon:SetParent(bg)
			rightButton.Icon:SetSize(16, 16)
			rightButton.Icon:SetPoint('CENTER', rightButton, 'CENTER')

			rightButton.styled = true
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, 'SetBlockHeader', reskinQuestIcon)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, 'AddObjective', reskinQuestIcon)


	-- Progressbars
	local function reskinBarTemplate(bar)
		F.StripTextures(bar)
		bar:SetStatusBarTexture(C.media.backdrop)
		bar:GetStatusBarTexture():SetGradient('VERTICAL', r*.9, g*.9, b*.9, r*.4, g*.4, b*.4)
		bar.bg = F.CreateBDFrame(bar)
		F.CreateSD(bar.bg)
	end

	local function reskinProgressbar(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar
		local icon = bar.Icon
		local label = bar.Label

		if not bar.bg then
			reskinBarTemplate(bar)
			BonusObjectiveTrackerProgressBar_PlayFlareAnim = F.dummy

			label:ClearAllPoints()
			label:SetPoint('CENTER')
			F.SetFS(label)

			icon:SetMask(nil)
			icon:SetTexCoord(unpack(C.TexCoord))
			icon:ClearAllPoints()
			icon:SetPoint('TOPLEFT', bar, 'TOPRIGHT', 5, 0)
			icon:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', 25, 0)

			icon.bg = F.CreateBDFrame(icon)
			icon.glow = F.CreateSD(icon.bg)
		end

		if icon.bg then
			icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
		end
	end
	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, 'AddProgressBar', reskinProgressbar)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, 'AddProgressBar', reskinProgressbar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, 'AddProgressBar', reskinProgressbar)

	hooksecurefunc(QUEST_TRACKER_MODULE, 'AddProgressBar', function(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar

		if not bar.bg then
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
	hooksecurefunc(QUEST_TRACKER_MODULE, 'AddTimerBar', reskinTimerBar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, 'AddTimerBar', reskinTimerBar)
	hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, 'AddTimerBar', reskinTimerBar)


	-- Blocks
	hooksecurefunc('ScenarioStage_CustomizeBlock', function(block)
		block.NormalBG:SetTexture('')
		if not block.bg then
			block.bg = F.CreateBDFrame(block.GlowTexture)
			block.bg:SetPoint('TOPLEFT', block.GlowTexture, 4, -2)
			block.bg:SetPoint('BOTTOMRIGHT', block.GlowTexture, -4, 0)
			F.CreateSD(block.bg)
		end
	end)

	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, 'Update', function()
		local widgetContainer = ScenarioStageBlock.WidgetContainer
		if not widgetContainer then return end
		local widgetFrame = widgetContainer:GetChildren()
		if widgetFrame and widgetFrame.Frame then
			widgetFrame.Frame:SetAlpha(0)
			for _, bu in next, {widgetFrame.CurrencyContainer:GetChildren()} do
				if bu and not bu.styled then
					bu.Icon:SetTexCoord(unpack(C.TexCoord))
					local bg = F.CreateBDFrame(bu.Icon)
					bu.styled = true
				end
			end
		end
	end)

	hooksecurefunc('Scenario_ChallengeMode_ShowBlock', function()
		local block = ScenarioChallengeModeBlock
		if not block.bg then
			block.TimerBG:Hide()
			block.TimerBGBack:Hide()
			block.timerbg = F.CreateBDFrame(block.TimerBGBack)
			block.timerbg:SetPoint('TOPLEFT', block.TimerBGBack, 6, -2)
			block.timerbg:SetPoint('BOTTOMRIGHT', block.TimerBGBack, -6, -5)
			F.CreateBD(block.timerbg)

			block.StatusBar:SetStatusBarTexture(C.media.sbTex)
			block.StatusBar:GetStatusBarTexture():SetGradient('VERTICAL', r*.9, g*.9, b*.9, r*.4, g*.4, b*.4)
			block.StatusBar:SetHeight(10)

			select(3, block:GetRegions()):Hide()
			block.bg = F.CreateBDFrame(block)
			block.bg:SetPoint('TOPLEFT', 4, -2)
			block.bg:SetPoint('BOTTOMRIGHT', -4, 0)
			F.CreateBD(block.bg)
			F.CreateSD(block.bg)
		end
	end)

	hooksecurefunc('Scenario_ChallengeMode_SetUpAffixes', F.AffixesSetup)

	-- Minimize button
	F.ReskinExpandOrCollapse(minimize)
	minimize:GetNormalTexture():SetAlpha(0)
	minimize.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
	hooksecurefunc('ObjectiveTracker_Collapse', function() minimize.expTex:SetTexCoord(0, 0.4375, 0, 0.4375) end)
	hooksecurefunc('ObjectiveTracker_Expand', function() minimize.expTex:SetTexCoord(0.5625, 1, 0, 0.4375) end)



	-- Fonts
	ot.HeaderMenu.Title:SetFont(unpack(otFontHeader))

	for _, headerName in pairs({'QuestHeader', 'AchievementHeader', 'ScenarioHeader'}) do
		local header = BlocksFrame[headerName]
		header.Text:SetFont(unpack(otFontHeader))
		header.Text:SetTextColor(229/255, 209/255, 159/255, 1)
		header.Text:SetShadowColor(0, 0, 0, 1)
		header.Text:SetShadowOffset(2, -2)
	end

	do
		local header = BONUS_OBJECTIVE_TRACKER_MODULE.Header
		header.Text:SetFont(unpack(otFontHeader))
		header.Text:SetShadowColor(0, 0, 0, 1)
		header.Text:SetShadowOffset(2, -2)
	end

	do
		local header = WORLD_QUEST_TRACKER_MODULE.Header
		header.Text:SetFont(unpack(otFontHeader))
		header.Text:SetTextColor(229/255, 209/255, 159/255, 1)
		header.Text:SetShadowColor(0, 0, 0, 1)
		header.Text:SetShadowOffset(2, -2)
	end

	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, 'SetBlockHeader', function(_, block)
		if not block.headerStyled then
			block.HeaderText:SetFont(otFont[1],otFont[2]+2,otFont[3])
			block.HeaderText:SetShadowColor(0, 0, 0, 1)
			block.HeaderText:SetShadowOffset(2, -2)
			block.headerStyled = true
		end
	end)

	hooksecurefunc(QUEST_TRACKER_MODULE, 'SetBlockHeader', function(_, block)
		if not block.headerStyled then
			block.HeaderText:SetFont(otFont[1],otFont[2]+2,otFont[3])
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
					line.Text:SetFont(otFont[1],otFont[2]+2,otFont[3])
					line.Text:SetShadowColor(0, 0, 0, 1)
					line.Text:SetShadowOffset(2, -2)
					line.Text:SetSpacing(2)

					if line.Dash then
						F.SetFS(line.Dash)
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
end






