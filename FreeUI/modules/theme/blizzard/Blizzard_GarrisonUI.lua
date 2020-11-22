local F, C = unpack(select(2, ...))

local function ReskinMissionPage(self)
	F.StripTextures(self)
	local bg = F.CreateBDFrame(self, .25)
	bg:SetPoint("TOPLEFT", 3, 2)
	bg:SetPoint("BOTTOMRIGHT", -3, -10)

	self.Stage.Header:SetAlpha(0)
	if self.StartMissionFrame then F.StripTextures(self.StartMissionFrame) end
	self.StartMissionButton.Flash:SetTexture("")
	F.Reskin(self.StartMissionButton)
	F.ReskinClose(self.CloseButton)
	self.CloseButton:ClearAllPoints()
	self.CloseButton:SetPoint("TOPRIGHT", -10, -5)

	if self.Followers then
		for i = 1, 3 do
			local follower = self.Followers[i]
			follower:GetRegions():Hide()
			F.CreateBDFrame(follower, .25)
			F.ReskinGarrisonPortrait(follower.PortraitFrame)
			follower.PortraitFrame:ClearAllPoints()
			follower.PortraitFrame:SetPoint("TOPLEFT", 0, -3)
		end
	end

	if self.RewardsFrame then
		for i = 1, 10 do
			select(i, self.RewardsFrame:GetRegions()):Hide()
		end
		F.CreateBDFrame(self.RewardsFrame, .25)

		local overmaxItem = self.RewardsFrame.OvermaxItem
		overmaxItem.IconBorder:SetAlpha(0)
		F.ReskinIcon(overmaxItem.Icon)
	end

	local env = self.Stage.MissionEnvIcon
	env.bg = F.ReskinIcon(env.Texture)

	if self.CostFrame then
		self.CostFrame.CostIcon:SetTexCoord(unpack(C.TexCoord))
	end
end

local function ReskinMissionTabs(self)
	for i = 1, 2 do
		local tab = _G[self:GetName().."Tab"..i]
		if tab then
			F.StripTextures(tab)
			tab.bg = F.CreateBDFrame(tab, .25)
			if i == 1 then
				tab.bg:SetBackdropColor(C.r, C.g, C.b, .2)
			end
		end
	end
end

local function ReskinXPBar(self)
	local xpBar = self.XPBar
	if xpBar then
		xpBar:GetRegions():Hide()
		xpBar.XPLeft:Hide()
		xpBar.XPRight:Hide()
		select(4, xpBar:GetRegions()):Hide()
		xpBar:SetStatusBarTexture(C.Assets.bd_tex)
		F.CreateBDFrame(xpBar, .25)
	end
end

local function ReskinGarrMaterial(self)
	local frame = self.MaterialFrame
	frame.BG:Hide()
	if frame.LeftFiligree then frame.LeftFiligree:Hide() end
	if frame.RightFiligree then frame.RightFiligree:Hide() end

	F.ReskinIcon(frame.Icon)
	local bg = F.CreateBDFrame(frame, .25)
	bg:SetPoint("TOPLEFT", 5, -5)
	bg:SetPoint("BOTTOMRIGHT", -5, 6)
end

local function ReskinMissionList(self)
	local buttons = self.listScroll.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if not button.styled then
			local rareOverlay = button.RareOverlay
			local rareText = button.RareText

			button.LocBG:SetDrawLayer("BACKGROUND")
			F.StripTextures(button)
			F.CreateBDFrame(button, .25, true)
			button.Highlight:SetColorTexture(.6, .8, 1, .15)
			button.Highlight:SetAllPoints()

			if button.CompleteCheck then
				button.CompleteCheck:SetAtlas("Adventures-Checkmark")
			end
			if rareText then
				rareText:ClearAllPoints()
				rareText:SetPoint("BOTTOMLEFT", button, 20, 10)
			end
			if rareOverlay then
				rareOverlay:SetDrawLayer("BACKGROUND")
				rareOverlay:SetTexture(C.Assets.bd_tex)
				rareOverlay:SetAllPoints()
				rareOverlay:SetVertexColor(.098, .537, .969, .2)
			end
			if button.Overlay and button.Overlay.Overlay then
				button.Overlay.Overlay:SetAllPoints()
			end

			button.styled = true
		end
	end
end

local function ReskinMissionComplete(self)
	local missionComplete = self.MissionComplete
	local bonusRewards = missionComplete.BonusRewards
	if bonusRewards then
		select(11, bonusRewards:GetRegions()):SetTextColor(1, .8, 0)
		F.StripTextures(bonusRewards.Saturated)
		for i = 1, 9 do
			select(i, bonusRewards:GetRegions()):SetAlpha(0)
		end
		F.CreateBDFrame(bonusRewards)
	end
	if missionComplete.NextMissionButton then
		F.Reskin(missionComplete.NextMissionButton)
	end
	if missionComplete.CompleteFrame then
		F.StripTextures(missionComplete)
		local bg = F.CreateBDFrame(missionComplete, .25)
		bg:SetPoint("TOPLEFT", 3, 2)
		bg:SetPoint("BOTTOMRIGHT", -3, -10)

		F.StripTextures(missionComplete.CompleteFrame)
		F.Reskin(missionComplete.CompleteFrame.ContinueButton)
		F.Reskin(missionComplete.CompleteFrame.SpeedButton)
		F.Reskin(missionComplete.RewardsScreen.FinalRewardsPanel.ContinueButton)
	end
	if missionComplete.MissionInfo then
		F.StripTextures(missionComplete.MissionInfo)
	end
end

local function ReskinFollowerTab(self)
	for i = 1, 2 do
		local trait = self.Traits[i]
		trait.Border:Hide()
		F.ReskinIcon(trait.Portrait)

		local equipment = self.EquipmentFrame.Equipment[i]
		equipment.BG:Hide()
		equipment.Border:Hide()
		F.ReskinIcon(equipment.Icon)
	end
end

local function UpdateFollowerQuality(self, followerInfo)
	if followerInfo then
		local color = C.QualityColors[followerInfo.quality or 1]
		self.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

local function UpdateFollowerList(self)
	local followerFrame = self:GetParent()
	local scrollFrame = followerFrame.FollowerList.listScroll
	local buttons = scrollFrame.buttons

	for i = 1, #buttons do
		local button = buttons[i].Follower
		local portrait = button.PortraitFrame

		if not button.restyled then
			button.BG:Hide()
			button.Selection:SetTexture("")
			button.AbilitiesBG:SetTexture("")
			button.bg = F.CreateBDFrame(button, .25)

			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(C.r, C.g, C.b, .1)
			hl:ClearAllPoints()
			hl:SetInside(button.bg)

			if portrait then
				F.ReskinGarrisonPortrait(portrait)
				portrait:ClearAllPoints()
				portrait:SetPoint("TOPLEFT", 4, -1)
				hooksecurefunc(portrait, "SetupPortrait", UpdateFollowerQuality)
			end

			if button.BusyFrame then
				button.BusyFrame:SetInside(button.bg)
			end

			button.restyled = true
		end

		if button.Counters then
			for i = 1, #button.Counters do
				local counter = button.Counters[i]
				if counter and not counter.bg then
					counter.bg = F.ReskinIcon(counter.Icon)
				end
			end
		end

		if button.Selection:IsShown() then
			button.bg:SetBackdropColor(C.r, C.g, C.b, .2)
		else
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end
end

local function UpdateSpellAbilities(self, followerInfo)
	local autoSpellInfo = followerInfo.autoSpellAbilities
	for _ in ipairs(autoSpellInfo) do
		local abilityFrame = self.autoSpellPool:Acquire()
		if not abilityFrame.styled then
			F.ReskinIcon(abilityFrame.Icon)
			if abilityFrame.SpellBorder then
				abilityFrame.SpellBorder:Hide()
			end

			abilityFrame.styled = true
		end
	end
end

local function UpdateFollowerAbilities(followerList)
	local followerTab = followerList.followerTab
	local abilitiesFrame = followerTab.AbilitiesFrame
	if not abilitiesFrame then return end

	local abilities = abilitiesFrame.Abilities
	if abilities then
		for i = 1, #abilities do
			local iconButton = abilities[i].IconButton
			local icon = iconButton and iconButton.Icon
			if icon and not icon.bg then
				iconButton.Border:SetAlpha(0)
				icon.bg = F.ReskinIcon(icon)
			end
		end
	end

	local equipment = abilitiesFrame.Equipment
	if equipment then
		for i = 1, #equipment do
			local equip = equipment[i]
			if equip and not equip.bg then
				equip.Border:SetAlpha(0)
				equip.BG:SetAlpha(0)
				equip.bg = F.ReskinIcon(equip.Icon)
				equip.bg:SetBackdropColor(1, 1, 1, .15)
			end
		end
	end

	local combatAllySpell = abilitiesFrame.CombatAllySpell
	if combatAllySpell then
		for i = 1, #combatAllySpell do
			local icon = combatAllySpell[i].iconTexture
			if icon and not icon.bg then
				icon.bg = F.ReskinIcon(icon)
			end
		end
	end
end

local function ReskinMissionFrame(self)
	F.StripTextures(self)
	F.SetBD(self)
	F.StripTextures(self.CloseButton)
	F.ReskinClose(self.CloseButton)
	self.GarrCorners:Hide()
	if self.OverlayElements then self.OverlayElements:SetAlpha(0) end
	if self.ClassHallIcon then self.ClassHallIcon:Hide() end
	if self.TitleScroll then
		F.StripTextures(self.TitleScroll)
		select(4, self.TitleScroll:GetRegions()):SetTextColor(1, .8, 0)
	end
	for i = 1, 3 do
		local tab = _G[self:GetName().."Tab"..i]
		if tab then F.ReskinTab(tab) end
	end
	if self.MapTab then self.MapTab.ScrollContainer.Child.TiledBackground:Hide() end

	ReskinMissionComplete(self)
	ReskinMissionPage(self.MissionTab.MissionPage)
	F.StripTextures(self.FollowerTab)
	ReskinXPBar(self.FollowerTab)
	hooksecurefunc(self.FollowerTab, "UpdateCombatantStats", UpdateSpellAbilities)

	for _, item in pairs({self.FollowerTab.ItemWeapon, self.FollowerTab.ItemArmor}) do
		if item then
			local icon = item.Icon
			item.Border:Hide()
			F.ReskinIcon(icon)

			local bg = F.CreateBDFrame(item, .25)
			bg:SetPoint("TOPLEFT", 41, -1)
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
		end
	end

	local missionList = self.MissionTab.MissionList
	F.StripTextures(missionList)
	F.ReskinScroll(missionList.listScroll.scrollBar)
	ReskinGarrMaterial(missionList)
	ReskinMissionTabs(missionList)
	F.Reskin(missionList.CompleteDialog.BorderFrame.ViewButton)
	hooksecurefunc(missionList, "Update", ReskinMissionList)

	local FollowerList = self.FollowerList
	F.StripTextures(FollowerList)
	if FollowerList.SearchBox then F.ReskinInput(FollowerList.SearchBox) end
	F.ReskinScroll(FollowerList.listScroll.scrollBar)
	ReskinGarrMaterial(FollowerList)
	hooksecurefunc(FollowerList, "UpdateData", UpdateFollowerList)
	hooksecurefunc(FollowerList, "ShowFollower", UpdateFollowerAbilities)
end

-- Missions board in 9.0
local function reskinAbilityIcon(self, anchor, yOffset)
	self:ClearAllPoints()
	self:SetPoint(anchor, self:GetParent().squareBG, "LEFT", -3, yOffset)
	self.Border:SetAlpha(0)
	self.CircleMask:Hide()
	F.ReskinIcon(self.Icon)
end

local function updateFollowerColorOnBoard(self, _, info)
	if self.squareBG then
		local color = C.QualityColors[info.quality or 1]
		self.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end

local function resetFollowerColorOnBoard(self)
	if self.squareBG then
		self.squareBG:SetBackdropBorderColor(0, 0, 0)
	end
end

local function reskinFollowerBoard(self, group)
	for socketTexture in self[group.."SocketFramePool"]:EnumerateActive() do
		socketTexture:DisableDrawLayer("BACKGROUND") -- we need the bufficons
	end
	for frame in self[group.."FramePool"]:EnumerateActive() do
		if not frame.styled then
			F.ReskinGarrisonPortrait(frame)
			frame.PuckShadow:SetAlpha(0)
			reskinAbilityIcon(frame.AbilityOne, "BOTTOMRIGHT", 1)
			reskinAbilityIcon(frame.AbilityTwo, "TOPRIGHT", -1)
			if frame.SetFollowerGUID then
				hooksecurefunc(frame, "SetFollowerGUID", updateFollowerColorOnBoard)
			end
			if frame.SetEmpty then
				hooksecurefunc(frame, "SetEmpty", resetFollowerColorOnBoard)
			end

			frame.styled = true
		end
	end
end

local function ReskinMissionBoards(self)
	reskinFollowerBoard(self, "enemy")
	reskinFollowerBoard(self, "follower")
end

C.Themes["Blizzard_GarrisonUI"] = function()
	local r, g, b = C.r, C.g, C.b

	-- Tooltips
	F.ReskinGarrisonTooltip(GarrisonFollowerAbilityWithoutCountersTooltip)
	F.ReskinGarrisonTooltip(GarrisonFollowerMissionAbilityWithoutCountersTooltip)

	-- Building frame
	local GarrisonBuildingFrame = GarrisonBuildingFrame
	F.StripTextures(GarrisonBuildingFrame)
	F.SetBD(GarrisonBuildingFrame)
	F.ReskinClose(GarrisonBuildingFrame.CloseButton)
	GarrisonBuildingFrame.GarrCorners:Hide()

	-- Tutorial button
	local mainHelpButton = GarrisonBuildingFrame.MainHelpButton
	mainHelpButton.Ring:Hide()
	mainHelpButton:SetPoint("TOPLEFT", GarrisonBuildingFrame, "TOPLEFT", -12, 12)

	-- Building list
	local buildingList = GarrisonBuildingFrame.BuildingList
	buildingList:DisableDrawLayer("BORDER")
	ReskinGarrMaterial(buildingList)

	for i = 1, GARRISON_NUM_BUILDING_SIZES do
		local tab = buildingList["Tab"..i]
		tab:GetNormalTexture():SetAlpha(0)

		local bg = F.CreateBDFrame(tab, .25)
		bg:SetPoint("TOPLEFT", 6, -7)
		bg:SetPoint("BOTTOMRIGHT", -6, 7)
		tab.bg = bg

		local hl = tab:GetHighlightTexture()
		hl:SetColorTexture(r, g, b, .1)
		hl:ClearAllPoints()
		hl:SetInside(bg)
	end

	hooksecurefunc("GarrisonBuildingList_SelectTab", function(tab)
		local list = GarrisonBuildingFrame.BuildingList

		for i = 1, GARRISON_NUM_BUILDING_SIZES do
			local otherTab = list["Tab"..i]
			if i ~= tab:GetID() then
				otherTab.bg:SetBackdropColor(0, 0, 0, .25)
			end
		end
		tab.bg:SetBackdropColor(r, g, b, .2)

		for _, button in pairs(list.Buttons) do
			if not button.styled then
				button.BG:Hide()
				F.ReskinIcon(button.Icon)

				local bg = F.CreateBDFrame(button, .25)
				bg:SetPoint("TOPLEFT", 44, -5)
				bg:SetPoint("BOTTOMRIGHT", 0, 6)

				button.SelectedBG:SetColorTexture(r, g, b, .2)
				button.SelectedBG:ClearAllPoints()
				button.SelectedBG:SetInside(bg)

				local hl = button:GetHighlightTexture()
				hl:SetColorTexture(r, g, b, .1)
				hl:SetAllPoints(button.SelectedBG)

				button.styled = true
			end
		end
	end)

	-- Follower list
	local followerList = GarrisonBuildingFrame.FollowerList
	followerList:ClearAllPoints()
	followerList:SetPoint("BOTTOMLEFT", 24, 34)
	followerList:DisableDrawLayer("BACKGROUND")
	followerList:DisableDrawLayer("BORDER")
	F.ReskinScroll(followerList.listScroll.scrollBar)
	hooksecurefunc(followerList, "UpdateData", UpdateFollowerList)
	hooksecurefunc(followerList, "ShowFollower", UpdateFollowerAbilities)

	-- Info box
	local infoBox = GarrisonBuildingFrame.InfoBox
	local townHallBox = GarrisonBuildingFrame.TownHallBox
	F.StripTextures(infoBox)
	F.CreateBDFrame(infoBox, .25)
	F.StripTextures(townHallBox)
	F.CreateBDFrame(townHallBox, .25)
	F.Reskin(infoBox.UpgradeButton)
	F.Reskin(townHallBox.UpgradeButton)
	GarrisonBuildingFrame.MapFrame.TownHall.TownHallName:SetTextColor(1, .8, 0)

	local followerPortrait = infoBox.FollowerPortrait
	F.ReskinGarrisonPortrait(followerPortrait)
	followerPortrait:SetPoint("BOTTOMLEFT", 230, 10)
	followerPortrait.RemoveFollowerButton:ClearAllPoints()
	followerPortrait.RemoveFollowerButton:SetPoint("TOPRIGHT", 4, 4)

	hooksecurefunc("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(_, _, infoBox)
		local portrait = infoBox.FollowerPortrait
		if portrait:IsShown() then
			portrait.squareBG:SetBackdropBorderColor(portrait.PortraitRing:GetVertexColor())
		end
	end)

	-- Confirmation popup
	local confirmation = GarrisonBuildingFrame.Confirmation
	confirmation:GetRegions():Hide()
	F.CreateBDFrame(confirmation)
	F.Reskin(confirmation.CancelButton)
	F.Reskin(confirmation.BuildButton)
	F.Reskin(confirmation.UpgradeButton)
	F.Reskin(confirmation.UpgradeGarrisonButton)
	F.Reskin(confirmation.ReplaceButton)
	F.Reskin(confirmation.SwitchButton)

	-- Capacitive display frame
	local GarrisonCapacitiveDisplayFrame = GarrisonCapacitiveDisplayFrame
	GarrisonCapacitiveDisplayFrameLeft:Hide()
	GarrisonCapacitiveDisplayFrameMiddle:Hide()
	GarrisonCapacitiveDisplayFrameRight:Hide()
	F.CreateBDFrame(GarrisonCapacitiveDisplayFrame.Count, .25)
	GarrisonCapacitiveDisplayFrame.Count:SetWidth(38)
	GarrisonCapacitiveDisplayFrame.Count:SetTextInsets(3, 0, 0, 0)

	F.ReskinPortraitFrame(GarrisonCapacitiveDisplayFrame)
	F.Reskin(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, true)
	F.Reskin(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton, true)
	F.ReskinArrow(GarrisonCapacitiveDisplayFrame.DecrementButton, "left")
	F.ReskinArrow(GarrisonCapacitiveDisplayFrame.IncrementButton, "right")

	-- Capacitive display
	local capacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	capacitiveDisplay.IconBG:SetAlpha(0)
	F.ReskinIcon(capacitiveDisplay.ShipmentIconFrame.Icon)
	F.ReskinGarrisonPortrait(capacitiveDisplay.ShipmentIconFrame.Follower)

	local reagentIndex = 1
	hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function()
		local reagents = capacitiveDisplay.Reagents

		local reagent = reagents[reagentIndex]
		while reagent do
			reagent.NameFrame:SetAlpha(0)
			F.ReskinIcon(reagent.Icon)

			local bg = F.CreateBDFrame(reagent, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 2)

			reagentIndex = reagentIndex + 1
			reagent = reagents[reagentIndex]
		end
	end)

	-- Landing page
	local GarrisonLandingPage = GarrisonLandingPage
	F.StripTextures(GarrisonLandingPage)
	F.SetBD(GarrisonLandingPage)
	F.ReskinClose(GarrisonLandingPage.CloseButton)
	F.ReskinTab(GarrisonLandingPageTab1)
	F.ReskinTab(GarrisonLandingPageTab2)
	F.ReskinTab(GarrisonLandingPageTab3)

	GarrisonLandingPageTab1:ClearAllPoints()
	GarrisonLandingPageTab1:SetPoint("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)

	-- Report
	local report = GarrisonLandingPage.Report
	F.StripTextures(report)
	F.StripTextures(report.List)

	local scrollFrame = report.List.listScroll
	F.ReskinScroll(scrollFrame.scrollBar)

	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.BG:Hide()
		local bg = F.CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)

		for _, reward in pairs(button.Rewards) do
			reward:GetRegions():Hide()
			reward.bg = F.ReskinIcon(reward.Icon)
			F.ReskinIconBorder(reward.IconBorder)
			reward:ClearAllPoints()
			reward:SetPoint("TOPRIGHT", -4, -4)
		end
	end

	for _, tab in pairs({report.InProgress, report.Available}) do
		tab:SetHighlightTexture("")
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")

		local bg = F.CreateBDFrame(tab, 0, true)

		local selectedTex = bg:CreateTexture(nil, "BACKGROUND")
		selectedTex:SetAllPoints()
		selectedTex:SetColorTexture(r, g, b, .2)
		selectedTex:Hide()
		tab.selectedTex = selectedTex

		if tab == report.InProgress then
			bg:SetPoint("TOPLEFT", 5, 0)
			bg:SetPoint("BOTTOMRIGHT")
		else
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", -7, 0)
		end
	end

	hooksecurefunc("GarrisonLandingPageReport_SetTab", function(self)
		local unselectedTab = report.unselectedTab
		unselectedTab:SetHeight(36)
		unselectedTab:SetNormalTexture("")
		unselectedTab.selectedTex:Hide()
		self:SetNormalTexture("")
		self.selectedTex:Show()
	end)

	-- Follower list
	local followerList = GarrisonLandingPage.FollowerList
	F.StripTextures(followerList)
	F.ReskinInput(followerList.SearchBox)
	F.ReskinScroll(followerList.listScroll.scrollBar)
	hooksecurefunc(GarrisonLandingPageFollowerList, "UpdateData", UpdateFollowerList)
	hooksecurefunc(GarrisonLandingPageFollowerList, "ShowFollower", UpdateFollowerAbilities)

	-- Ship follower list
	local shipFollowerList = GarrisonLandingPage.ShipFollowerList
	F.StripTextures(shipFollowerList)
	F.ReskinInput(shipFollowerList.SearchBox)
	F.ReskinScroll(shipFollowerList.listScroll.scrollBar)

	-- Follower tab
	local followerTab = GarrisonLandingPage.FollowerTab
	ReskinXPBar(followerTab)
	hooksecurefunc(followerTab, "UpdateCombatantStats", UpdateSpellAbilities)

	-- Ship follower tab
	local followerTab = GarrisonLandingPage.ShipFollowerTab
	ReskinXPBar(followerTab)
	ReskinFollowerTab(followerTab)

	-- Mission UI
	local GarrisonMissionFrame = GarrisonMissionFrame
	ReskinMissionFrame(GarrisonMissionFrame)

	hooksecurefunc("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
		if isSelected then
			tab.bg:SetBackdropColor(r, g, b, .2)
		else
			tab.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local ability = self.Abilities[index]

		if not ability.styled then
			local icon = ability.Icon
			icon:SetSize(19, 19)
			F.ReskinIcon(icon)

			ability.styled = true
		end
	end)

	hooksecurefunc("GarrisonFollowerButton_SetCounterButton", function(button, _, index)
		local counter = button.Counters[index]
		if counter and not counter.styled then
			F.ReskinIcon(counter.Icon)
			counter.styled = true
		end
	end)

	hooksecurefunc("GarrisonMissionButton_SetReward", function(frame)
		if not frame.bg then
			frame:GetRegions():Hide()
			frame.bg = F.ReskinIcon(frame.Icon)
			F.ReskinIconBorder(frame.IconBorder, true)
		end
	end)

	hooksecurefunc("GarrisonMissionPortrait_SetFollowerPortrait", function(portraitFrame, followerInfo)
		if not portraitFrame.styled then
			F.ReskinGarrisonPortrait(portraitFrame)
			portraitFrame.styled = true
		end

		local color = C.QualityColors[followerInfo.quality]
		portraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
		portraitFrame.squareBG:Show()
	end)

	hooksecurefunc("GarrisonMissionPage_SetReward", function(frame)
		if not frame.bg then
			F.ReskinIcon(frame.Icon)
			frame.BG:SetAlpha(0)
			frame.bg = F.CreateBDFrame(frame.BG, .25)
			frame.IconBorder:SetScale(.0001)
		end
	end)

	hooksecurefunc(GarrisonMission, "UpdateMissionParty", function(_, followers)
		for followerIndex = 1, #followers do
			local followerFrame = followers[followerIndex]
			if followerFrame.info then
				for i = 1, #followerFrame.Counters do
					local counter = followerFrame.Counters[i]
					if not counter.styled then
						F.ReskinIcon(counter.Icon)
						counter.styled = true
					end
				end
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "RemoveFollowerFromMission", function(_, frame)
		if frame.PortraitFrame and frame.PortraitFrame.squareBG then
			frame.PortraitFrame.squareBG:Hide()
		end
	end)

	hooksecurefunc(GarrisonMission, "SetEnemies", function(_, missionPage, enemies)
		for i = 1, #enemies do
			local frame = missionPage.Enemies[i]
			if frame:IsShown() and not frame.styled then
				for j = 1, #frame.Mechanics do
					local mechanic = frame.Mechanics[j]
					F.ReskinIcon(mechanic.Icon)
				end
				frame.styled = true
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "UpdateMissionData", function(_, missionPage)
		local buffsFrame = missionPage.BuffsFrame
		if buffsFrame and buffsFrame:IsShown() then
			for i = 1, #buffsFrame.Buffs do
				local buff = buffsFrame.Buffs[i]
				if not buff.styled then
					F.ReskinIcon(buff.Icon)
					buff.styled = true
				end
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "MissionCompleteInitialize", function(self, missionList, index)
		local mission = missionList[index]
		if not mission then return end

		for i = 1, #mission.followers do
			local frame = self.MissionComplete.Stage.FollowersFrame.Followers[i]
			if frame.PortraitFrame then
				if not frame.bg then
					frame.PortraitFrame:ClearAllPoints()
					frame.PortraitFrame:SetPoint("TOPLEFT", 0, -10)
					F.ReskinGarrisonPortrait(frame.PortraitFrame)

					local oldBg = frame:GetRegions()
					oldBg:Hide()
					frame.bg = F.CreateBDFrame(oldBg)
					frame.bg:SetPoint("TOPLEFT", frame.PortraitFrame, -1, 1)
					frame.bg:SetPoint("BOTTOMRIGHT", -10, 8)
				end

				local quality = select(4, C_Garrison.GetFollowerMissionCompleteInfo(mission.followers[i]))
				if quality then
					local color = C.QualityColors[quality]
					frame.PortraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
					frame.PortraitFrame.squareBG:Show()
				end
			end
		end
	end)

	hooksecurefunc(GarrisonMission, "ShowMission", function(self)
		local envIcon = self:GetMissionPage().Stage.MissionEnvIcon
		if envIcon.bg then
			envIcon.bg:SetShown(envIcon.Texture:GetTexture())
		end
	end)

	-- Recruiter frame
	local GarrisonRecruiterFrame = GarrisonRecruiterFrame
	F.ReskinPortraitFrame(GarrisonRecruiterFrame)

	-- Pick
	local Pick = GarrisonRecruiterFrame.Pick
	F.Reskin(Pick.ChooseRecruits)
	F.ReskinDropDown(Pick.ThreatDropDown)
	F.ReskinRadio(Pick.Radio1)
	F.ReskinRadio(Pick.Radio2)

	-- Unavailable frame
	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame
	F.Reskin(UnavailableFrame:GetChildren())

	-- Recruiter select frame
	local GarrisonRecruitSelectFrame = GarrisonRecruitSelectFrame
	F.StripTextures(GarrisonRecruitSelectFrame)
	GarrisonRecruitSelectFrame.TitleText:Show()
	GarrisonRecruitSelectFrame.GarrCorners:Hide()
	F.CreateBDFrame(GarrisonRecruitSelectFrame)
	F.ReskinClose(GarrisonRecruitSelectFrame.CloseButton)

	-- Follower list
	local followerList = GarrisonRecruitSelectFrame.FollowerList
	followerList:DisableDrawLayer("BORDER")
	F.ReskinScroll(followerList.listScroll.scrollBar)
	F.ReskinInput(followerList.SearchBox)
	hooksecurefunc(followerList, "UpdateData", UpdateFollowerList)
	hooksecurefunc(followerList, "ShowFollower", UpdateFollowerAbilities)

	-- Follower selection
	local FollowerSelection = GarrisonRecruitSelectFrame.FollowerSelection
	FollowerSelection:DisableDrawLayer("BORDER")
	for i = 1, 3 do
		local recruit = FollowerSelection["Recruit"..i]
		F.ReskinGarrisonPortrait(recruit.PortraitFrame)
		F.Reskin(recruit.HireRecruits)
	end

	hooksecurefunc("GarrisonRecruitSelectFrame_UpdateRecruits", function(waiting)
		if waiting then return end

		for i = 1, 3 do
			local frame = FollowerSelection["Recruit"..i]
			local portrait = frame.PortraitFrame
			portrait.squareBG:SetBackdropBorderColor(portrait.LevelBorder:GetVertexColor())

			if frame:IsShown() then
				local traits = frame.Traits.Entries
				if traits then
					for index = 1, #traits do
						local trait = traits[index]
						if not trait.bg then
							trait.bg = F.ReskinIcon(trait.Icon)
						end
					end
				end
				local abilities = frame.Abilities.Entries
				if abilities then
					for index = 1, #abilities do
						local ability = abilities[index]
						if not ability.bg then
							ability.bg = F.ReskinIcon(ability.Icon)
						end
					end
				end
			end
		end
	end)

	-- Monuments
	local GarrisonMonumentFrame = GarrisonMonumentFrame
	GarrisonMonumentFrame.Background:Hide()
	F.SetBD(GarrisonMonumentFrame, nil, 6, -10, -6, 4)

	for _, name in pairs({"Left", "Right"}) do
		local button = GarrisonMonumentFrame[name.."Btn"]
		button.Texture:Hide()
		F.ReskinArrow(button, strlower(name))
		button:SetSize(35, 35)
		button.__texture:SetSize(16, 16)
	end

	-- Shipyard
	local GarrisonShipyardFrame = GarrisonShipyardFrame
	F.StripTextures(GarrisonShipyardFrame)
	GarrisonShipyardFrame.BorderFrame.GarrCorners:Hide()
	GarrisonShipyardFrame.BackgroundTile:Hide()
	F.SetBD(GarrisonShipyardFrame)
	F.ReskinInput(GarrisonShipyardFrameFollowers.SearchBox)
	F.ReskinScroll(GarrisonShipyardFrameFollowersListScrollFrameScrollBar)
	F.StripTextures(GarrisonShipyardFrameFollowers)
	ReskinGarrMaterial(GarrisonShipyardFrameFollowers)

	local shipyardTab = GarrisonShipyardFrame.FollowerTab
	shipyardTab:DisableDrawLayer("BORDER")
	ReskinXPBar(shipyardTab)
	ReskinFollowerTab(shipyardTab)

	F.ReskinClose(GarrisonShipyardFrame.BorderFrame.CloseButton2)
	F.ReskinTab(GarrisonShipyardFrameTab1)
	F.ReskinTab(GarrisonShipyardFrameTab2)

	local shipyardMission = GarrisonShipyardFrame.MissionTab.MissionPage
	F.StripTextures(shipyardMission)
	F.ReskinClose(shipyardMission.CloseButton)
	F.Reskin(shipyardMission.StartMissionButton)
	local smbg = F.CreateBDFrame(shipyardMission.Stage)
	smbg:SetPoint("TOPLEFT", 4, 1)
	smbg:SetPoint("BOTTOMRIGHT", -4, -1)

	F.StripTextures(shipyardMission.RewardsFrame)
	F.CreateBDFrame(shipyardMission.RewardsFrame, .25)

	GarrisonShipyardFrame.MissionCompleteBackground:GetRegions():Hide()
	GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog:GetRegions():Hide()
	F.Reskin(GarrisonShipyardFrame.MissionTab.MissionList.CompleteDialog.BorderFrame.ViewButton)
	select(11, GarrisonShipyardFrame.MissionComplete.BonusRewards:GetRegions()):SetTextColor(1, .8, 0)
	F.Reskin(GarrisonShipyardFrame.MissionComplete.NextMissionButton)

	-- Orderhall UI
	local OrderHallMissionFrame = OrderHallMissionFrame
	ReskinMissionFrame(OrderHallMissionFrame)

	-- allies
	local combatAlly = OrderHallMissionFrameMissions.CombatAllyUI
	F.Reskin(combatAlly.InProgress.Unassign)
	combatAlly:GetRegions():Hide()
	F.CreateBDFrame(combatAlly, .25)
	F.ReskinIcon(combatAlly.InProgress.CombatAllySpell.iconTexture)

	local allyPortrait = combatAlly.InProgress.PortraitFrame
	F.ReskinGarrisonPortrait(allyPortrait)
	OrderHallMissionFrame:HookScript("OnShow", function()
		if allyPortrait:IsShown() then
			local color = C.QualityColors[allyPortrait.quality or 1]
			allyPortrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
		end
		combatAlly.Available.AddFollowerButton.EmptyPortrait:SetAlpha(0)
		combatAlly.Available.AddFollowerButton.PortraitHighlight:SetAlpha(0)
	end)

	hooksecurefunc(OrderHallCombatAllyMixin, "UnassignAlly", function(self)
		if self.InProgress.PortraitFrame.squareBG then
			self.InProgress.PortraitFrame.squareBG:Hide()
		end
	end)

	-- Zone support
	local ZoneSupportMissionPage = OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage
	F.StripTextures(ZoneSupportMissionPage)
	F.CreateBDFrame(ZoneSupportMissionPage, .25)
	F.ReskinClose(ZoneSupportMissionPage.CloseButton)
	F.Reskin(ZoneSupportMissionPage.StartMissionButton)
	F.ReskinIcon(ZoneSupportMissionPage.CombatAllySpell.iconTexture)
	ZoneSupportMissionPage.Follower1:GetRegions():Hide()
	F.CreateBDFrame(ZoneSupportMissionPage.Follower1, .25)
	F.ReskinGarrisonPortrait(ZoneSupportMissionPage.Follower1.PortraitFrame)

	-- BFA Mission UI
	local BFAMissionFrame = BFAMissionFrame
	ReskinMissionFrame(BFAMissionFrame)

	-- Covenant Mission UI
	local CovenantMissionFrame = CovenantMissionFrame
	ReskinMissionFrame(CovenantMissionFrame)
	CovenantMissionFrame.RaisedBorder:SetAlpha(0)
	CovenantMissionFrameMissions.RaisedFrameEdges:SetAlpha(0)

	CombatLog:DisableDrawLayer("BACKGROUND")
	CombatLog.ElevatedFrame:SetAlpha(0)
	F.StripTextures(CombatLog.CombatLogMessageFrame)
	F.CreateBDFrame(CombatLog.CombatLogMessageFrame, .25)
	F.ReskinScroll(CombatLog.CombatLogMessageFrame.ScrollBar)

	F.Reskin(HealFollowerButtonTemplate)
	local bg = F.CreateBDFrame(CovenantMissionFrame.FollowerTab, .25)
	bg:SetPoint("TOPLEFT", 3, 2)
	bg:SetPoint("BOTTOMRIGHT", -3, -10)
	CovenantMissionFrame.FollowerTab.RaisedFrameEdges:SetAlpha(0)
	CovenantMissionFrame.FollowerTab.HealFollowerFrame.ButtonFrame:SetAlpha(0)
	CovenantMissionFrameFollowers.ElevatedFrame:SetAlpha(0)
	F.Reskin(CovenantMissionFrameFollowers.HealAllButton)
	CovenantMissionFrame.MapTab:SetAlpha(0) -- not sure what does this for, need reviewed
	F.ReskinIcon(CovenantMissionFrame.FollowerTab.HealFollowerFrame.CostFrame.CostIcon)

	CovenantMissionFrame.MissionTab.MissionPage.Board:HookScript("OnShow", ReskinMissionBoards)
	CovenantMissionFrame.MissionComplete.Board:HookScript("OnShow", ReskinMissionBoards)

	-- Addon supports

	local function buttonOnUpdate(MissionList)
		local buttons = MissionList.listScroll.buttons
		for i = 1, #buttons do
			local bu = select(3, buttons[i]:GetChildren())
			if bu and bu:IsObjectType("Button") and not bu.styled then
				F.Reskin(bu)
				bu:SetSize(60, 45)
				bu.styled = true
			end
		end
	end

	local function buttonOnShow(MissionPage)
		for i = 18, 27 do
			local bu = select(i, MissionPage:GetChildren())
			if bu and bu:IsObjectType("Button") and not bu.styled then
				F.Reskin(bu)
				bu:SetSize(50, 45)
				bu.styled = true
			end
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(_, event, addon)
		if addon == "GarrisonMissionManager" then
			for _, frame in next, {GarrisonMissionFrame, OrderHallMissionFrame, BFAMissionFrame, CovenantMissionFrame} do
				if frame then
					hooksecurefunc(frame.MissionTab.MissionList, "Update", buttonOnUpdate)
					frame.MissionTab.MissionPage:HookScript("OnShow", buttonOnShow)
				end
			end

			f:UnregisterEvent(event)
		end
	end)

	-- WarPlan
	if IsAddOnLoaded("WarPlan") then
		local function reskinWarPlanFont(font, r, g, b)
			if not font then return end
			font:SetTextColor(r, g, b)
		end

		local function reskinWarPlanMissions(self)
			local missions = self.TaskBoard.Missions
			for i = 1, #missions do
				local button = missions[i]
				if not button.styled then
					reskinWarPlanFont(button.XPReward, 1, 1, 1)
					reskinWarPlanFont(button.Description, .8, .8, .8)
					reskinWarPlanFont(button.CDTDisplay, 1, 1, 1)

					local groups = button.Groups
					if groups then
						for j = 1, #groups do
							local group = groups[j]
							F.Reskin(group)
							reskinWarPlanFont(group.Features, 1, .8, 0)
						end
					end

					button.styled = true
				end
			end
		end

		C_Timer.After(.1, function()
			local WarPlanFrame = _G.WarPlanFrame
			if not WarPlanFrame then return end

			F.StripTextures(WarPlanFrame)
			F.SetBD(WarPlanFrame)
			F.StripTextures(WarPlanFrame.ArtFrame)
			F.ReskinClose(WarPlanFrame.ArtFrame.CloseButton)
			reskinWarPlanFont(WarPlanFrame.ArtFrame.TitleText, 1, .8, 0)

			reskinWarPlanMissions(WarPlanFrame)
			WarPlanFrame:HookScript("OnShow", reskinWarPlanMissions)
			F.Reskin(WarPlanFrame.TaskBoard.AllPurposeButton)

			local entries = WarPlanFrame.HistoryFrame.Entries
			for i = 1, #entries do
				local entry = entries[i]
				entry:DisableDrawLayer("BACKGROUND")
				F.ReskinIcon(entry.Icon)
				entry.Name:SetFontObject("Number12Font")
				entry.Detail:SetFontObject("Number12Font")
			end
		end)
	end
end

C.Themes["Blizzard_OrderHallUI"] = function()
	-- Talent Frame
	local OrderHallTalentFrame = OrderHallTalentFrame

	F.ReskinPortraitFrame(OrderHallTalentFrame)
	F.Reskin(OrderHallTalentFrame.BackButton)
	F.ReskinIcon(OrderHallTalentFrame.Currency.Icon)
	OrderHallTalentFrame.OverlayElements:SetAlpha(0)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function(self)
		if self.CloseButton.Border then self.CloseButton.Border:SetAlpha(0) end
		if self.CurrencyBG then self.CurrencyBG:SetAlpha(0) end
		F.StripTextures(self)

		for i = 1, self:GetNumChildren() do
			local bu = select(i, self:GetChildren())
			if bu and bu.talent then
				bu.Border:SetAlpha(0)
				if not bu.bg then
					bu.Highlight:SetColorTexture(1, 1, 1, .25)
					bu.bg = F.ReskinIcon(bu.Icon)
				end

				if bu.talent.selected then
					bu.bg:SetBackdropBorderColor(1, 1, 0)
				else
					bu.bg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
end
