local F, C, L = unpack(select(2, ...))

local ot = ObjectiveTrackerFrame
local BlocksFrame = ot.BlocksFrame

-- [[ Positioning ]]

local function moveTracker()
	local xCoord, yAnchor

	if MultiBarLeft:IsShown() then
		xCoord = -84
	elseif MultiBarRight:IsShown() then
		xCoord = -57
	else
		xCoord = -30
	end

	yAnchor = VehicleSeatIndicator:IsShown() and VehicleSeatIndicator or Minimap

	ot:ClearAllPoints()
	ot:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", xCoord, -160)
	ot:SetPoint("BOTTOM", yAnchor, "TOP", 0, 220) -- bogus positioning because we can't touch ObjectiveTracker_CanFitBlock
end

hooksecurefunc(ot, "SetPoint", function(_, _, _, point)
	if point == "BOTTOMRIGHT" then
		moveTracker()
	end
end)

hooksecurefunc(VehicleSeatIndicator, "SetPoint", function(_, _, anchor)
	if anchor ~= Minimap then
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("BOTTOM", Minimap, "TOP", 0, 20)
	end
end)

-- [[ Header ]]

-- Header

F.SetFS(ot.HeaderMenu.Title)

-- Minimize button

local minimizeButton = ot.HeaderMenu.MinimizeButton

F.ReskinExpandOrCollapse(minimizeButton)
minimizeButton:SetSize(15, 15)
minimizeButton.plus:Hide()

hooksecurefunc("ObjectiveTracker_Collapse", function()
	minimizeButton.plus:Show()
end)
hooksecurefunc("ObjectiveTracker_Expand", function()
	minimizeButton.plus:Hide()
end)

-- [[ Blocks and lines ]]

for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	local header = BlocksFrame[headerName]

	header.Background:Hide()
	F.SetFS(header.Text)
end

do
	local header = BONUS_OBJECTIVE_TRACKER_MODULE.Header

	header.Background:Hide()
	F.SetFS(header.Text)
end

hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
		F.SetFS(block.HeaderText)
		block.headerStyled = true
	end
end)

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
		F.SetFS(block.HeaderText)
		block.headerStyled = true
	end

	local itemButton = block.itemButton

	if itemButton and not itemButton.styled then
		itemButton:SetNormalTexture("")
		itemButton:SetPushedTexture("")

		itemButton.HotKey:ClearAllPoints()
		itemButton.HotKey:SetPoint("CENTER", itemButton, 1, 0)
		itemButton.HotKey:SetJustifyH("CENTER")
		F.SetFS(itemButton.HotKey)
        
        itemButton.Count:ClearAllPoints()
        itemButton.Count:SetPoint("TOP", itemButton, 2, -1)
        itemButton.Count:SetJustifyH("CENTER")
        F.SetFS(itemButton.Count)

		itemButton.icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(itemButton)

		itemButton.styled = true
	end
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
				F.SetFS(line.Text)
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

-- [[ Bonus objective progress bar ]]

hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon

	if not progressBar.styled then
		local label = bar.Label

		bar.BarBG:Hide()

		icon:SetMask(nil)
		icon:SetDrawLayer("BACKGROUND", 1)
		icon:ClearAllPoints()
		icon:SetPoint("RIGHT", 35, 2)
		bar.newIconBg = F.ReskinIcon(icon)

		bar.BarFrame:Hide()

		bar:SetStatusBarTexture(C.media.backdrop)

		label:ClearAllPoints()
		label:SetPoint("CENTER")
		F.SetFS(label)

		local bg = F.CreateBDFrame(bar)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 0, -2)

		progressBar.styled = true
	end

	bar.IconBG:Hide()
	bar.newIconBg:SetShown(icon:IsShown())
end)