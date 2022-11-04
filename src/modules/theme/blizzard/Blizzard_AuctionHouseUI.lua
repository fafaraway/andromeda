local F, C = unpack(select(2, ...))

local function reskinAuctionButton(button)
    F.Reskin(button)
    button:SetSize(22, 22)
end

local function reskinSellPanel(frame)
    F.StripTextures(frame)

    local itemDisplay = frame.ItemDisplay
    F.StripTextures(itemDisplay)
    F.CreateBDFrame(itemDisplay, 0.25)

    local itemButton = itemDisplay.ItemButton
    if itemButton.IconMask then
        itemButton.IconMask:Hide()
    end
    itemButton.EmptyBackground:Hide()
    itemButton:SetPushedTexture(0)
    itemButton.Highlight:SetColorTexture(1, 1, 1, 0.25)
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
        F.ReskinCheckbox(frame.BuyoutModeCheckButton)
        frame.BuyoutModeCheckButton:SetSize(28, 28)
    end
end

local function reskinListIcon(frame)
    if not frame.tableBuilder then
        return
    end

    for i = 1, 22 do
        local row = frame.tableBuilder.rows[i]
        if row then
            for j = 1, 4 do
                local cell = row.cells and row.cells[j]
                if cell and cell.Icon then
                    if not cell.styled then
                        cell.Icon.bg = F.ReskinIcon(cell.Icon)
                        if cell.IconBorder then
                            cell.IconBorder:Hide()
                        end
                        cell.styled = true
                    end
                    cell.Icon.bg:SetShown(cell.Icon:IsShown())
                end
            end
        end
    end
end

local function reskinSummaryButtons(self)
    for i = 1, self.ScrollTarget:GetNumChildren() do
        local child = select(i, self.ScrollTarget:GetChildren())
        if child and child.Icon then
            if not child.styled then
                child.Icon.bg = F.ReskinIcon(child.Icon)
                if child.IconBorder then
                    child.IconBorder:SetAlpha(0)
                end
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
            header:DisableDrawLayer('BACKGROUND')
            header.bg = F.CreateBDFrame(header)
            local hl = header:GetHighlightTexture()
            hl:SetColorTexture(1, 1, 1, 0.1)
            hl:SetAllPoints(header.bg)

            header.styled = true
        end

        if header.bg then
            header.bg:SetPoint('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)
        end
    end

    reskinListIcon(frame)
end

local function reskinSellList(frame, hasHeader)
    F.StripTextures(frame)
    if frame.RefreshFrame then
        reskinAuctionButton(frame.RefreshFrame.RefreshButton)
    end

    F.ReskinTrimScroll(frame.ScrollBar)

    if hasHeader then
        F.CreateBDFrame(frame.ScrollBox, 0.25)
        hooksecurefunc(frame, 'RefreshScrollFrame', reskinListHeader)
    else
        hooksecurefunc(frame.ScrollBox, 'Update', reskinSummaryButtons)
    end
end

local function reskinItemDisplay(itemDisplay, needInit)
    F.StripTextures(itemDisplay)
    local bg = F.CreateBDFrame(itemDisplay, 0.25)
    bg:SetPoint('TOPLEFT', 3, -3)
    bg:SetPoint('BOTTOMRIGHT', -3, 0)
    local itemButton = itemDisplay.ItemButton
    if itemButton.CircleMask then
        itemButton.CircleMask:Hide()
        itemButton.useCircularIconBorder = true
    end
    itemButton.bg = F.ReskinIcon(itemButton.Icon)
    F.ReskinIconBorder(itemButton.IconBorder, needInit)

    local hl = itemButton:GetHighlightTexture()
    hl:SetColorTexture(1, 1, 1, 0.25)
    hl:SetInside(itemButton.bg)
end

local function reskinItemList(frame, hasHeader)
    F.StripTextures(frame)
    F.CreateBDFrame(frame.ScrollBox, 0.25)
    F.ReskinTrimScroll(frame.ScrollBar)

    if frame.RefreshFrame then
        reskinAuctionButton(frame.RefreshFrame.RefreshButton)
    end
    if hasHeader then
        hooksecurefunc(frame, 'RefreshScrollFrame', reskinListHeader)
    end
end

C.Themes['Blizzard_AuctionHouseUI'] = function()
    local AuctionHouseFrame = _G.AuctionHouseFrame
    F.ReskinPortraitFrame(AuctionHouseFrame)
    F.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
    F.CreateBDFrame(AuctionHouseFrame.MoneyFrameBorder, 0.25)
    F.StripTextures(AuctionHouseFrame.MoneyFrameInset)
    F.ReskinTab(_G.AuctionHouseFrameBuyTab)
    _G.AuctionHouseFrameBuyTab:SetPoint('BOTTOMLEFT', 20, -32)
    F.ReskinTab(_G.AuctionHouseFrameSellTab)
    _G.AuctionHouseFrameSellTab:ClearAllPoints()
    _G.AuctionHouseFrameSellTab:SetPoint('LEFT', _G.AuctionHouseFrameBuyTab, 'RIGHT')
    F.ReskinTab(_G.AuctionHouseFrameAuctionsTab)
    _G.AuctionHouseFrameAuctionsTab:ClearAllPoints()
    _G.AuctionHouseFrameAuctionsTab:SetPoint('LEFT', _G.AuctionHouseFrameSellTab, 'RIGHT')

    local searchBar = AuctionHouseFrame.SearchBar
    reskinAuctionButton(searchBar.FavoritesSearchButton)
    F.ReskinInput(searchBar.SearchBox)
    F.Reskin(searchBar.SearchButton)

    local filterButton = searchBar.FilterButton
    F.ReskinFilterButton(filterButton)
    F.ReskinFilterReset(filterButton.ClearFiltersButton)
    F.ReskinInput(filterButton.LevelRangeFrame.MinLevel)
    F.ReskinInput(filterButton.LevelRangeFrame.MaxLevel)

    F.StripTextures(AuctionHouseFrame.CategoriesList)
    F.ReskinTrimScroll(AuctionHouseFrame.CategoriesList.ScrollBar)

    reskinItemList(AuctionHouseFrame.BrowseResultsFrame.ItemList, true)

    hooksecurefunc('AuctionHouseFilterButton_SetUp', function(button)
        button.NormalTexture:SetAlpha(0)
        button.SelectedTexture:SetColorTexture(0, 0.6, 1, 0.3)
        button.HighlightTexture:SetColorTexture(1, 1, 1, 0.1)
    end)

    local itemBuyFrame = AuctionHouseFrame.ItemBuyFrame
    F.Reskin(itemBuyFrame.BackButton)
    F.Reskin(itemBuyFrame.BidFrame.BidButton)
    F.Reskin(itemBuyFrame.BuyoutFrame.BuyoutButton)
    F.ReskinInput(_G.AuctionHouseFrameGold)
    F.ReskinInput(_G.AuctionHouseFrameSilver)
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
    F.Reskin(wowTokenResults.Buyout)
    reskinItemDisplay(wowTokenResults.TokenDisplay, true)
    F.ReskinTrimScroll(wowTokenResults.DummyScrollBar)

    local gameTimeTutorial = wowTokenResults.GameTimeTutorial
    F.ReskinPortraitFrame(gameTimeTutorial)
    F.Reskin(gameTimeTutorial.RightDisplay.StoreButton)
    gameTimeTutorial.LeftDisplay.Label:SetTextColor(1, 1, 1)
    gameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, 0.8, 0)
    gameTimeTutorial.RightDisplay.Label:SetTextColor(1, 1, 1)
    gameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, 0.8, 0)

    local woWTokenSellFrame = AuctionHouseFrame.WoWTokenSellFrame
    F.StripTextures(woWTokenSellFrame)
    F.Reskin(woWTokenSellFrame.PostButton)
    F.StripTextures(woWTokenSellFrame.DummyItemList)
    F.CreateBDFrame(woWTokenSellFrame.DummyItemList, 0.25)
    F.ReskinTrimScroll(woWTokenSellFrame.DummyItemList.DummyScrollBar)

    reskinAuctionButton(woWTokenSellFrame.DummyRefreshButton)
    reskinItemDisplay(woWTokenSellFrame.ItemDisplay)

    reskinSellPanel(AuctionHouseFrame.ItemSellFrame)
    reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
    reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
    reskinSellList(AuctionHouseFrame.ItemSellList, true)
    reskinSellList(_G.AuctionHouseFrameAuctionsFrame.SummaryList)
    reskinSellList(_G.AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
    reskinSellList(_G.AuctionHouseFrameAuctionsFrame.BidsList, true)
    reskinSellList(_G.AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
    reskinSellList(_G.AuctionHouseFrameAuctionsFrame.ItemList, true)
    reskinItemDisplay(_G.AuctionHouseFrameAuctionsFrame.ItemDisplay)

    F.ReskinTab(_G.AuctionHouseFrameAuctionsFrameAuctionsTab)
    F.ReskinTab(_G.AuctionHouseFrameAuctionsFrameBidsTab)
    F.ReskinInput(_G.AuctionHouseFrameAuctionsFrameGold)
    F.ReskinInput(_G.AuctionHouseFrameAuctionsFrameSilver)
    F.Reskin(_G.AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
    F.Reskin(_G.AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
    F.Reskin(_G.AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)

    local buyDialog = AuctionHouseFrame.BuyDialog
    F.StripTextures(buyDialog)
    F.SetBD(buyDialog)
    F.Reskin(buyDialog.BuyNowButton)
    F.Reskin(buyDialog.CancelButton)

    local multisellFrame = _G.AuctionHouseMultisellProgressFrame
    F.StripTextures(multisellFrame)
    F.SetBD(multisellFrame)
    local progressBar = multisellFrame.ProgressBar
    F.StripTextures(progressBar)
    F.ReskinIcon(progressBar.Icon)
    progressBar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    F.CreateBDFrame(progressBar, 0.25)
    local close = multisellFrame.CancelButton
    F.ReskinClose(close)
    close:ClearAllPoints()
    close:SetPoint('LEFT', progressBar, 'RIGHT', 3, 0)
end
