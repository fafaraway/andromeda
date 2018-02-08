local F, C, L = unpack(select(2, ...))

if not C.quests.questObjectiveTrackerStyle then return end

local class = select(2, UnitClass("player"))
local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b

local ot = ObjectiveTrackerFrame
local BlocksFrame = ot.BlocksFrame

local otFontHeader = {
	C.font.header,
	16,
	"OUTLINE"
}
local otFont = {
	C.font.normal,
	12,
	"OUTLINE"
}

do
	local parent = CreateFrame("Frame", nil, UIParent)
	parent:SetFrameStrata("HIGH")
	RegisterStateDriver(parent, "visibility", "[petbattle] hide; show")
	local Mover = CreateFrame("Button", "ObjectiveTrackerAnchor", parent)
	Mover:SetPoint(unpack(C.quests.position))
	Mover:SetSize(22, 22)
	Mover.Icon = Mover:CreateTexture(nil, "ARTWORK")
	Mover.Icon:SetAllPoints()
	Mover.Icon:SetTexture("Interface\\WorldMap\\Gear_64")
	Mover.Icon:SetTexCoord(0, .5, 0, .5)
	Mover.Icon:SetAlpha(.2)
	Mover:SetHighlightTexture("Interface\\WorldMap\\Gear_64")
	Mover:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)
	F.CreateGT(Mover, "Drag to move", "system")
	F.CreateMF(Mover)


	hooksecurefunc(ot, "SetPoint", function(_, _, parent)
		if parent ~= Mover then
			ot:ClearAllPoints()
			ot:SetPoint("TOPRIGHT", Mover, "TOPLEFT", -5, 0)
			ot:SetHeight(GetScreenHeight() - 400)
		end
	end)
	hooksecurefunc("ObjectiveTracker_CheckAndHideHeader", function() Mover:SetShown(ot.HeaderMenu:IsShown()) end)
end

-- Questblock click enhant
local function QuestHook(id)
	local questLogIndex = GetQuestLogIndexByID(id)
	if IsControlKeyDown() and CanAbandonQuest(id) then
		QuestMapQuestOptions_AbandonQuest(id)
	elseif IsAltKeyDown() and GetQuestLogPushable(questLogIndex) then
		QuestMapQuestOptions_ShareQuest(id)
	end
end
hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderClick", function(self, block) QuestHook(block.id) end)
hooksecurefunc("QuestMapLogTitleButton_OnClick", function(self) QuestHook(self.questID) end)

-- Show quest color and level
local function Showlevel()
	if ENABLE_COLORBLIND_MODE == "1" then return end
	local numEntries = GetNumQuestLogEntries()
	local titleIndex = 1
	for i = 1, numEntries do
		local title, level, _, isHeader, _, isComplete, frequency, questID = GetQuestLogTitle(i)
		local titleButton = QuestLogQuests_GetTitleButton(titleIndex)
		if title and (not isHeader) and titleButton.questID == questID then
			titleButton.Check:SetPoint("LEFT", titleButton.Text, titleButton.Text:GetWrappedWidth() + 2, 0)
			titleIndex = titleIndex + 1
			local text = "["..level.."] "..title
			if isComplete then
				text = "|cffff78ff"..text
			elseif frequency == LE_QUEST_FREQUENCY_DAILY then
				text = "|cff3399ff"..text
			end
			titleButton.Text:SetText(text)
			titleButton.Text:SetPoint("TOPLEFT", 24, -5)
			titleButton.Text:SetWidth(216)
		end
	end
end
hooksecurefunc("QuestLogQuests_Update", Showlevel)


-- Headers
local function reskinHeader(header)
	-- header.Text:SetTextColor(r, g, b)
	header.Background:Hide()
	local bg = header:CreateTexture(nil, "ARTWORK")
	bg:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
	bg:SetTexCoord(0, .66, 0, .31)
	bg:SetVertexColor(r, g, b, .8)
	bg:SetPoint("BOTTOMLEFT", -30, -4)
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


-- QuestIcons
local function reskinQuestIcon(self, block)
	local itemButton = block.itemButton
	if itemButton and not itemButton.styled then
		itemButton:SetNormalTexture("")
		itemButton:SetPushedTexture("")
		itemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
		itemButton.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(itemButton)
		F.CreateSD(itemButton)

		itemButton.HotKey:ClearAllPoints()
		itemButton.HotKey:SetPoint("CENTER", itemButton, 1, 0)
		itemButton.HotKey:SetJustifyH("CENTER")
		F.SetFS(itemButton.HotKey)

		itemButton.Count:ClearAllPoints()
		itemButton.Count:SetPoint("TOP", itemButton, 2, -1)
		itemButton.Count:SetJustifyH("CENTER")
		F.SetFS(itemButton.Count)

		itemButton.styled = true
	end

	local rightButton = block.rightButton
	if rightButton and not rightButton.styled then
		rightButton:SetNormalTexture("")
		rightButton:SetPushedTexture("")
		rightButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
		local bg = F.CreateBDFrame(rightButton)
		-- F.CreateBD(bg)
		F.CreateSD(rightButton)
		rightButton:SetSize(22, 22)
		rightButton.Icon:SetParent(bg)
		rightButton.Icon:SetSize(18, 18)

		rightButton.styled = true
	end
end
hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", reskinQuestIcon)
hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", reskinQuestIcon)


-- Progressbars
local function reskinProgressbar(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon

	if not bar.styled then
		bar.BarFrame:Hide()
		bar.BarFrame2:Hide()
		bar.BarFrame3:Hide()
		bar.BarBG:Hide()
		bar.IconBG:SetTexture("")

		bar:SetPoint("LEFT", 22, 0)
		bar:SetStatusBarTexture(C.media.texture)
		bar:SetStatusBarColor(r, g, b)
		bar:SetHeight(14)

		local bg = F.CreateBDFrame(bar)
		F.CreateSD(bg)
		if bar.AnimIn then	-- Fix bg opacity
			bar.AnimIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		end

		icon:SetMask(nil)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetSize(24, 24)
		icon:ClearAllPoints()
		icon:SetPoint("RIGHT", 30, 0)

		bar.Label:ClearAllPoints()
		bar.Label:SetPoint("CENTER")
		F.SetFS(bar.Label)

		bar.styled = true
	end
end
hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)

hooksecurefunc(QUEST_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar

	if not bar.styled then
		bar:ClearAllPoints()
		bar:SetPoint("LEFT")
		for i = 1, 6 do
			select(i, bar:GetRegions()):Hide()
		end
		bar:SetStatusBarTexture(C.media.texture)
		bar.Label:Show()
		F.SetFS(bar.Label)
		local oldBg = select(5, bar:GetRegions())
		local bg = F.CreateBDFrame(oldBg)
		F.CreateBD(bg)
		F.CreateSD(bg)

		bar.styled = true
	end
end)


-- Blocks
hooksecurefunc("ScenarioStage_CustomizeBlock", function(block)
	block.NormalBG:SetTexture(C.media.dropback)
	if not block.bg then
		block.bg = F.CreateBDFrame(block.GlowTexture)
	end
end)

hooksecurefunc("Scenario_ChallengeMode_ShowBlock", function()
	local block = ScenarioChallengeModeBlock
	if not block.bg then
		block.TimerBG:Hide()
		block.TimerBGBack:Hide()
		block.timerbg = F.CreateBDFrame(block.TimerBGBack)
		block.timerbg:SetPoint("TOPLEFT", block.TimerBGBack, 5, -1)
		block.timerbg:SetPoint("BOTTOMRIGHT", block.TimerBGBack, -5, -6)
		F.CreateBD(block.timerbg)

		block.StatusBar:SetStatusBarTexture(C.media.texture)
		block.StatusBar:SetStatusBarColor(r, g, b)
		block.StatusBar:SetHeight(10)

		select(3, block:GetRegions()):Hide()
		block.bg = F.CreateBDFrame(block)
		block.bg:SetPoint("TOPLEFT", 2, 0)
		--F.CreateBD(block.bg, .3)
		F.CreateSD(block.bg)
	end
end)

hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", function(block)
	for i, frame in ipairs(block.Affixes) do
		frame.Border:Hide()
		frame.Portrait:SetTexture(nil)
		frame.Portrait:SetTexCoord(.08, .92, .08, .92)
		F.CreateBDFrame(frame.Portrait)

		if frame.info then
			frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		elseif frame.affixID then
			local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
			frame.Portrait:SetTexture(filedataid)
		end
	end
end)

-- Minimize button
local minimizeButton = ot.HeaderMenu.MinimizeButton

F.ReskinExpandOrCollapse(minimizeButton)
minimizeButton:SetSize(15, 15)
minimizeButton.plus:Hide()

hooksecurefunc("ObjectiveTracker_Collapse", function() minimizeButton.plus:Show() end)
hooksecurefunc("ObjectiveTracker_Expand", function() minimizeButton.plus:Hide() end)


-- font

ot.HeaderMenu.Title:SetFont(unpack(otFontHeader))

for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	local header = BlocksFrame[headerName]
	header.Text:SetFont(unpack(otFontHeader))
end

do
	local header = BONUS_OBJECTIVE_TRACKER_MODULE.Header
	header.Text:SetFont(unpack(otFontHeader))
end

do
	local header = WORLD_QUEST_TRACKER_MODULE.Header
	header.Text:SetFont(unpack(otFontHeader))

	local header_bonus = BONUS_OBJECTIVE_TRACKER_MODULE.Header
	header_bonus.Text:SetFont(unpack(otFontHeader))
end

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
		block.HeaderText:SetFont(otFont[1],otFont[2]+2,otFont[3])
		block.headerStyled = true
	end
end)

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
		block.HeaderText:SetFont(otFont[1],otFont[2]+2,otFont[3])
		block.headerStyled = true
	end
end)

hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
	local line = block.currentLine

	local p1, a, p2, x, y = line:GetPoint()
	line:SetPoint(p1, a, p2, x, y - 4)
end)

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
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
		block:SetHeight(height + 5)
		block.shouldFix = true
	end
end

hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
	if block.lines then
		for _, line in pairs(block.lines) do
			if not line.styled then
				line.Text:SetFont(otFont[1],otFont[2]+2,otFont[3])
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
		hooksecurefunc(block, "SetHeight", fixBlockHeight)
		block.styled = true
	end
end)







