local F, C = unpack(select(2, ...))

local function ReskinReagentButton(reagent)
	reagent.bg = F.ReskinIcon(reagent.Icon)
	reagent.NameFrame:Hide()
	local bg = F.CreateBDFrame(reagent.NameFrame, .2)
	bg:SetPoint("TOPLEFT", reagent.Icon, "TOPRIGHT", 2, C.Mult)
	bg:SetPoint("BOTTOMRIGHT", -4, C.Mult)
	if reagent.SelectedTexture then
		reagent.SelectedTexture:SetColorTexture(1, 1, 1, .25)
		reagent.SelectedTexture:SetInside(reagent.bg)
	end
end

local function ResetBordeAlpha(self)
	self.IconBorder:SetAlpha(0)
end

C.Themes["Blizzard_TradeSkillUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(TradeSkillFrame)
	TradeSkillFrameTitleText:Show()
	TradeSkillFramePortrait:SetAlpha(0)
	TradeSkillFrame.DetailsInset:Hide()

	local rankFrame = TradeSkillFrame.RankFrame
	rankFrame:SetStatusBarTexture(C.Assets.bd_tex)
	rankFrame.SetStatusBarColor = F.Dummy
	rankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
	rankFrame.BorderMid:Hide()
	rankFrame.BorderLeft:Hide()
	rankFrame.BorderRight:Hide()
	F.CreateBDFrame(rankFrame, .25)

	F.ReskinInput(TradeSkillFrame.SearchBox)
	TradeSkillFrame.SearchBox:SetWidth(200)
	F.ReskinFilterButton(TradeSkillFrame.FilterButton)
	F.ReskinArrow(TradeSkillFrame.LinkToButton, "right")

	-- Recipe List

	local recipe = TradeSkillFrame.RecipeList
	TradeSkillFrame.RecipeInset:Hide()
	F.ReskinScroll(recipe.scrollBar)

	for i = 1, #recipe.Tabs do
		local tab = recipe.Tabs[i]
		for i = 1, 6 do
			select(i, tab:GetRegions()):SetAlpha(0)
		end
		tab:SetHighlightTexture("")
		tab.bg = F.CreateBDFrame(tab, .25)
		tab.bg:SetPoint("TOPLEFT", 3, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", -3, 0)
	end
	hooksecurefunc(recipe, "OnLearnedTabClicked", function()
		recipe.Tabs[1].bg:SetBackdropColor(r, g, b, .2)
		recipe.Tabs[2].bg:SetBackdropColor(0, 0, 0, .2)
	end)
	hooksecurefunc(recipe, "OnUnlearnedTabClicked", function()
		recipe.Tabs[1].bg:SetBackdropColor(0, 0, 0, .2)
		recipe.Tabs[2].bg:SetBackdropColor(r, g, b, .2)
	end)

	hooksecurefunc(recipe, "RefreshDisplay", function(self)
		for i = 1, #self.buttons do
			local button = self.buttons[i]
			if not button.styled then
				F.ReskinCollapse(button)
				if button.SubSkillRankBar then
					local bar = button.SubSkillRankBar
					F.StripTextures(bar)
					bar:SetStatusBarTexture(C.Assets.bd_tex)
					bar:SetPoint("RIGHT", -6, 0)
					F.CreateBDFrame(bar, .25)
				end

				button.styled = true
			end
			button:SetHighlightTexture("")
		end
	end)

	-- Recipe Details

	local detailsFrame = TradeSkillFrame.DetailsFrame
	detailsFrame.Background:Hide()
	F.ReskinScroll(detailsFrame.ScrollBar)
	F.Reskin(detailsFrame.CreateAllButton)
	F.Reskin(detailsFrame.CreateButton)
	F.Reskin(detailsFrame.ExitButton)
	detailsFrame.CreateMultipleInputBox:DisableDrawLayer("BACKGROUND")
	F.ReskinInput(detailsFrame.CreateMultipleInputBox)
	F.ReskinArrow(detailsFrame.CreateMultipleInputBox.DecrementButton, "left")
	F.ReskinArrow(detailsFrame.CreateMultipleInputBox.IncrementButton, "right")

	local contents = detailsFrame.Contents
	hooksecurefunc(contents.ResultIcon, "SetNormalTexture", function(self)
		if not self.styled then
			F.ReskinIcon(self:GetNormalTexture())
			self.IconBorder:SetAlpha(0)
			self.ResultBorder:Hide()
			self.styled = true
		end
	end)
	for i = 1, #contents.Reagents do
		ReskinReagentButton(contents.Reagents[i])
	end
	F.Reskin(detailsFrame.ViewGuildCraftersButton)

	for i = 1, #contents.OptionalReagents do
		ReskinReagentButton(contents.OptionalReagents[i])
	end

	local levelBar = contents.RecipeLevel
	F.StripTextures(levelBar)
	levelBar:SetStatusBarTexture(C.Assets.bd_tex)
	F.CreateBDFrame(levelBar, .25)
	F.ReskinFilterButton(contents.RecipeLevelSelector)

	-- Guild Recipe

	TradeSkillFrame.TabardBorder:SetAlpha(0)
	TradeSkillFrame.TabardBackground:SetAlpha(0)

	local guildFrame = detailsFrame.GuildFrame
	F.ReskinClose(guildFrame.CloseButton)
	F.StripTextures(guildFrame)
	F.SetBD(guildFrame)
	guildFrame:ClearAllPoints()
	guildFrame:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 0)
	F.StripTextures(guildFrame.Container)
	F.CreateBDFrame(guildFrame.Container, .25)
	F.ReskinScroll(guildFrame.Container.ScrollFrame.scrollBar)

	-- Optional reagents
	local reagentList = TradeSkillFrame.OptionalReagentList
	F.StripTextures(reagentList)
	F.SetBD(reagentList)
	reagentList:ClearAllPoints()
	reagentList:SetPoint("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 40, 0)

	reagentList.HideUnownedButton:SetSize(24, 24)
	F.ReskinCheck(reagentList.HideUnownedButton)
	F.Reskin(reagentList.CloseButton)

	local scrollList = reagentList.ScrollList
	F.StripTextures(scrollList)
	local bg = F.CreateBDFrame(scrollList, .25)
	bg:SetPoint("TOPLEFT", 1, -2)
	bg:SetPoint("BOTTOMRIGHT", -25, 5)
	F.ReskinScroll(scrollList.ScrollFrame.scrollBar)

	reagentList:HookScript("OnShow", function()
		for i = 1, #scrollList.ScrollFrame.buttons do
			local button = scrollList.ScrollFrame.buttons[i]
			if not button.bg then
				button:DisableDrawLayer("ARTWORK")
				button.Icon:SetSize(32, 32)
				button.Icon:ClearAllPoints()
				button.Icon:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3)
				button.bg = F.ReskinIcon(button.Icon)
				button.IconBorder:SetAlpha(0)
				hooksecurefunc(button, "SetState", ResetBordeAlpha)

				button.NameFrame:Hide()
				local bg = F.CreateBDFrame(button.NameFrame, .2)
				bg:SetPoint("TOPLEFT", button.Icon, "TOPRIGHT", 2, C.Mult)
				bg:SetPoint("BOTTOMRIGHT", -4, 5)
			end
		end
	end)
end
