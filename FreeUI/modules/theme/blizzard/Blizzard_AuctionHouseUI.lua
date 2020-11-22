local F, C = unpack(select(2, ...))

local function reskinAuctionButton(button)
	F.Reskin(button)
	button:SetSize(22, 22)
end

local function reskinSellPanel(frame)
	F.StripTextures(frame)

	local itemDisplay = frame.ItemDisplay
	F.StripTextures(itemDisplay)
	F.CreateBDFrame(itemDisplay, .25)

	local itemButton = itemDisplay.ItemButton
	if itemButton.IconMask then itemButton.IconMask:Hide() end
	itemButton.EmptyBackground:Hide()
	itemButton:SetPushedTexture("")
	itemButton.Highlight:SetColorTexture(1, 1, 1, .25)
	itemButton.Highlight:SetAllPoints(itemButton.Icon)
	itemButton.bg = F.ReskinIcon(itemButton.Icon)
	F.ReskinIconBorder(itemButton.IconBorder)

	F.ReskinInput(frame.QuantityInput.InputBox)
	F.Reskin(frame.QuantityInput.MaxButton)
	F.ReskinInput(frame.PriceInput.MoneyInputFrame.GoldBox)
	F.ReskinInput(frame.PriceInput.MoneyInputFrame.SilverBox)
	if frame.SecondaryPriceInput then
		F.ReskinInput(frame.SecondaryPriceInput.MoneyInputFrame.GoldBox)
		F.ReskinInput(frame.SecondaryPriceInput.MoneyInputFrame.SilverBox)
	end
	F.ReskinDropDown(frame.DurationDropDown.DropDown)
	F.Reskin(frame.PostButton)
	if frame.BuyoutModeCheckButton then
		F.ReskinCheck(frame.BuyoutModeCheckButton)
		frame.BuyoutModeCheckButton:SetSize(28, 28)
	end
end

local function MoveMoneyDisplay(frame, relF, parent, relT, x, y, reset)
	if reset then return end
	if not relF then
		relF, parent, relT, x, y = frame:GetPoint()
	end
	frame:SetPoint(relF, parent, relT, 18, 0, true)
end

local function reskinListIcon(frame)
	if not frame.tableBuilder then return end

	for i = 1, 22 do
		local row = frame.tableBuilder.rows[i]
		if row then
			for j = 1, 4 do
				local cell = row.cells and row.cells[j]
				if cell and cell.Icon then
					if not cell.styled then
						cell.Icon.bg = F.ReskinIcon(cell.Icon)
						if cell.IconBorder then cell.IconBorder:Hide() end
						cell.styled = true
					end
					cell.Icon.bg:SetShown(cell.Icon:IsShown())
				end

				local moneyDisplay = cell.MoneyDisplay
				if moneyDisplay and not moneyDisplay.hooked then
					MoveMoneyDisplay(cell.MoneyDisplay)
					hooksecurefunc(cell.MoneyDisplay, "SetPoint", MoveMoneyDisplay)
					moneyDisplay.hooked = true
				end
			end
		end
	end
end

local function reskinSummaryIcon(frame)
	for i = 1, 23 do
		local child = select(i, frame.ScrollFrame.scrollChild:GetChildren())
		if child and child.Icon then
			if not child.styled then
				child.Icon.bg = F.ReskinIcon(child.Icon)
				if child.IconBorder then child.IconBorder:SetAlpha(0) end
				child.styled = true
			end
			child.Icon.bg:SetShown(child.Icon:IsShown())
		end
	end
end

local function reskinListHeader(frame)
	local maxHeaders = frame.HeaderContainer:GetNumChildren()
	for i = 1, maxHeaders do
		local header = select(i, frame.HeaderContainer:GetChildren())
		if header and not header.styled then
			header:DisableDrawLayer("BACKGROUND")
			header.bg = F.CreateBDFrame(header)
			local hl = header:GetHighlightTexture()
			hl:SetColorTexture(1, 1, 1, .1)
			hl:SetAllPoints(header.bg)

			header.styled = true
		end

		if header.bg then
			header.bg:SetPoint("BOTTOMRIGHT", i < maxHeaders and -5 or 0, -2)
		end
	end

	reskinListIcon(frame)
end

local function reskinSellList(frame, hasHeader)
	F.StripTextures(frame)
	if frame.RefreshFrame then
		reskinAuctionButton(frame.RefreshFrame.RefreshButton)
	end
	F.ReskinScroll(frame.ScrollFrame.scrollBar)
	if hasHeader then
		F.CreateBDFrame(frame.ScrollFrame, .25)
		hooksecurefunc(frame, "RefreshScrollFrame", reskinListHeader)
	else
		hooksecurefunc(frame, "RefreshListDisplay", reskinSummaryIcon)
	end
end

local function reskinItemDisplay(itemDisplay)
	F.StripTextures(itemDisplay)
	local bg = F.CreateBDFrame(itemDisplay, .25)
	bg:SetPoint("TOPLEFT", 3, -3)
	bg:SetPoint("BOTTOMRIGHT", -3, 0)
	local itemButton = itemDisplay.ItemButton
	if itemButton.CircleMask then itemButton.CircleMask:Hide() end
	itemButton.bg = F.ReskinIcon(itemButton.Icon)
	F.ReskinIconBorder(itemButton.IconBorder)
end

local function reskinItemList(frame, hasHeader)
	F.StripTextures(frame)
	F.CreateBDFrame(frame.ScrollFrame, .25)
	F.ReskinScroll(frame.ScrollFrame.scrollBar)
	if frame.RefreshFrame then
		reskinAuctionButton(frame.RefreshFrame.RefreshButton)
	end
	if hasHeader then
		hooksecurefunc(frame, "RefreshScrollFrame", reskinListHeader)
	end
end

C.Themes["Blizzard_AuctionHouseUI"] = function()
	F.ReskinPortraitFrame(AuctionHouseFrame)
	F.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
	F.CreateBDFrame(AuctionHouseFrame.MoneyFrameBorder, .25)
	F.StripTextures(AuctionHouseFrame.MoneyFrameInset)
	F.ReskinTab(AuctionHouseFrameBuyTab)
	AuctionHouseFrameBuyTab:SetPoint("BOTTOMLEFT", 20, -31)
	F.ReskinTab(AuctionHouseFrameSellTab)
	AuctionHouseFrameSellTab:ClearAllPoints()
	AuctionHouseFrameSellTab:SetPoint('LEFT', AuctionHouseFrameBuyTab, 'RIGHT')
	F.ReskinTab(AuctionHouseFrameAuctionsTab)
	AuctionHouseFrameAuctionsTab:ClearAllPoints()
	AuctionHouseFrameAuctionsTab:SetPoint('LEFT', AuctionHouseFrameSellTab, 'RIGHT')

	local searchBar = AuctionHouseFrame.SearchBar
	reskinAuctionButton(searchBar.FavoritesSearchButton)
	F.ReskinInput(searchBar.SearchBox)
	F.ReskinFilterButton(searchBar.FilterButton)
	F.Reskin(searchBar.SearchButton)
	F.ReskinInput(searchBar.FilterButton.LevelRangeFrame.MinLevel)
	F.ReskinInput(searchBar.FilterButton.LevelRangeFrame.MaxLevel)

	F.StripTextures(AuctionHouseFrame.CategoriesList)
	F.ReskinScroll(AuctionHouseFrame.CategoriesList.ScrollFrame.ScrollBar)
	reskinItemList(AuctionHouseFrame.BrowseResultsFrame.ItemList, true)

	hooksecurefunc("FilterButton_SetUp", function(button)
		button.NormalTexture:SetAlpha(0)
		button.SelectedTexture:SetColorTexture(0, .6, 1, .3)
		button.HighlightTexture:SetColorTexture(1, 1, 1, .1)
	end)

	local itemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	F.Reskin(itemBuyFrame.BackButton)
	F.Reskin(itemBuyFrame.BidFrame.BidButton)
	F.Reskin(itemBuyFrame.BuyoutFrame.BuyoutButton)
	F.ReskinInput(AuctionHouseFrameGold)
	F.ReskinInput(AuctionHouseFrameSilver)
	reskinItemDisplay(itemBuyFrame.ItemDisplay)
	reskinItemList(itemBuyFrame.ItemList, true)

	local commBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	F.Reskin(commBuyFrame.BackButton)
	local buyDisplay = commBuyFrame.BuyDisplay
	F.StripTextures(buyDisplay)
	F.ReskinInput(buyDisplay.QuantityInput.InputBox)
	F.Reskin(buyDisplay.BuyButton)
	reskinItemDisplay(buyDisplay.ItemDisplay)
	reskinItemList(commBuyFrame.ItemList)

	local wowTokenResults = AuctionHouseFrame.WoWTokenResults
	F.StripTextures(wowTokenResults)
	F.StripTextures(wowTokenResults.TokenDisplay)
	F.CreateBDFrame(wowTokenResults.TokenDisplay, .25)
	F.Reskin(wowTokenResults.Buyout)
	F.ReskinScroll(wowTokenResults.DummyScrollBar)

	local gameTimeTutorial = wowTokenResults.GameTimeTutorial
	F.ReskinPortraitFrame(gameTimeTutorial)
	F.Reskin(gameTimeTutorial.RightDisplay.StoreButton)
	gameTimeTutorial.LeftDisplay.Label:SetTextColor(1, 1, 1)
	gameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, .8, 0)
	gameTimeTutorial.RightDisplay.Label:SetTextColor(1, 1, 1)
	gameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, .8, 0)

	local woWTokenSellFrame = AuctionHouseFrame.WoWTokenSellFrame
	F.StripTextures(woWTokenSellFrame)
	F.Reskin(woWTokenSellFrame.PostButton)
	F.StripTextures(woWTokenSellFrame.DummyItemList)
	F.CreateBDFrame(woWTokenSellFrame.DummyItemList, .25)
	F.ReskinScroll(woWTokenSellFrame.DummyItemList.DummyScrollBar)
	reskinAuctionButton(woWTokenSellFrame.DummyRefreshButton)
	reskinItemDisplay(woWTokenSellFrame.ItemDisplay)

	reskinSellPanel(AuctionHouseFrame.ItemSellFrame)
	reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
	reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
	reskinSellList(AuctionHouseFrame.ItemSellList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	reskinSellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.ItemList, true)
	reskinItemDisplay(AuctionHouseFrameAuctionsFrame.ItemDisplay)

	F.ReskinTab(AuctionHouseFrameAuctionsFrameAuctionsTab)
	F.ReskinTab(AuctionHouseFrameAuctionsFrameBidsTab)
	F.ReskinInput(AuctionHouseFrameAuctionsFrameGold)
	F.ReskinInput(AuctionHouseFrameAuctionsFrameSilver)
	F.Reskin(AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
	F.Reskin(AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
	F.Reskin(AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)

	local buyDialog = AuctionHouseFrame.BuyDialog
	F.StripTextures(buyDialog)
	F.SetBD(buyDialog)
	F.Reskin(buyDialog.BuyNowButton)
	F.Reskin(buyDialog.CancelButton)

	local multisellFrame = AuctionHouseMultisellProgressFrame
	F.StripTextures(multisellFrame)
	F.SetBD(multisellFrame)
	local progressBar = multisellFrame.ProgressBar
	F.StripTextures(progressBar)
	F.ReskinIcon(progressBar.Icon)
	progressBar:SetStatusBarTexture(C.Assets.norm_tex)
	F.CreateBDFrame(progressBar, .25)
	local close = multisellFrame.CancelButton
	F.ReskinClose(close)
	close:ClearAllPoints()
	close:SetPoint("LEFT", progressBar, "RIGHT", 3, 0)
end
