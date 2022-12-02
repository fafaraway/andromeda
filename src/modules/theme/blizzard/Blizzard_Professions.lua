local F, C = unpack(select(2, ...))

local flyoutFrame

local function refreshFlyoutButtons(self)
    for i = 1, self.ScrollTarget:GetNumChildren() do
        local button = select(i, self.ScrollTarget:GetChildren())
        if button.IconBorder and not button.styled then
            button.bg = F.ReskinIcon(button.icon)
            button:SetNormalTexture(0)
            button:SetPushedTexture(0)
            button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
            F.ReskinIconBorder(button.IconBorder, true)

            button.styled = true
        end
    end
end

local function reskinProfessionsFlyout(_, parent)
    if flyoutFrame then
        return
    end

    for i = 1, parent:GetNumChildren() do
        local child = select(i, parent:GetChildren())
        if child.HideUnownedCheckBox then
            flyoutFrame = child

            F.StripTextures(flyoutFrame)
            F.SetBD(flyoutFrame):SetFrameLevel(2)
            F.ReskinCheckbox(flyoutFrame.HideUnownedCheckBox)
            flyoutFrame.HideUnownedCheckBox.bg:SetInside(nil, 6, 6)
            hooksecurefunc(flyoutFrame.ScrollBox, 'Update', refreshFlyoutButtons)

            break
        end
    end
end

local function reskinSlotButton(button)
    if button and not button.styled then
        button:SetNormalTexture(0)
        button:SetPushedTexture(0)
        button.bg = F.ReskinIcon(button.Icon)
        F.ReskinIconBorder(button.IconBorder, true)
        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, 0.25)
        hl:SetInside(button.bg)
        if button.SlotBackground then
            button.SlotBackground:Hide()
        end

        button.styled = true
    end
end

local function reskinArrowInput(box)
    box:DisableDrawLayer('BACKGROUND')
    F.ReskinEditBox(box)
    F.ReskinArrow(box.DecrementButton, 'left')
    F.ReskinArrow(box.IncrementButton, 'right')
end

local function reskinQualityContainer(container)
    local button = container.Button
    button:SetNormalTexture(0)
    button:SetPushedTexture(0)
    button:SetHighlightTexture(0)
    button.bg = F.ReskinIcon(button.Icon)
    F.ReskinIconBorder(button.IconBorder, true)
    reskinArrowInput(container.EditBox)
end

C.Themes['Blizzard_Professions'] = function()
    local frame = _G.ProfessionsFrame
    local craftingPage = _G.ProfessionsFrame.CraftingPage

    F.ReskinPortraitFrame(frame)
    craftingPage.TutorialButton.Ring:Hide()
    F.Reskin(craftingPage.CreateButton)
    F.Reskin(craftingPage.CreateAllButton)
    F.Reskin(craftingPage.ViewGuildCraftersButton)
    reskinArrowInput(craftingPage.CreateMultipleInputBox)

    local guildFrame = craftingPage.GuildFrame
    F.StripTextures(guildFrame)
    F.CreateBDFrame(guildFrame, 0.25)
    F.StripTextures(guildFrame.Container)
    F.CreateBDFrame(guildFrame.Container, 0.25)

    for i = 1, 3 do
        local tab = select(i, frame.TabSystem:GetChildren())
        if tab then
            F.ReskinTab(tab)
        end
    end

    -- Tools
    local slots = {
        'Prof0ToolSlot',
        'Prof0Gear0Slot',
        'Prof0Gear1Slot',
        'Prof1ToolSlot',
        'Prof1Gear0Slot',
        'Prof1Gear1Slot',
        'CookingToolSlot',
        'CookingGear0Slot',
        'FishingToolSlot',
        'FishingGear0Slot',
        'FishingGear1Slot',
    }
    for _, name in pairs(slots) do
        local button = craftingPage[name]
        if button then
            button.bg = F.ReskinIcon(button.icon)
            F.ReskinIconBorder(button.IconBorder) -- needs review, maybe no quality at all
            button:SetNormalTexture(0)
            button:SetPushedTexture(0)
        end
    end

    local recipeList = craftingPage.RecipeList
    F.StripTextures(recipeList)
    F.ReskinTrimScroll(recipeList.ScrollBar, true)
    if recipeList.BackgroundNineSlice then
        recipeList.BackgroundNineSlice:Hide()
    end -- in case blizz rename
    F.CreateBDFrame(recipeList, 0.25):SetInside()
    F.ReskinEditBox(recipeList.SearchBox)
    F.ReskinFilterButton(recipeList.FilterButton)

    local form = craftingPage.SchematicForm
    F.StripTextures(form)
    form.Background:SetAlpha(0)
    F.CreateBDFrame(form, 0.25):SetInside()

    local button = form.OutputIcon
    if button then
        button.CircleMask:Hide()
        button.bg = F.ReskinIcon(button.Icon)
        F.ReskinIconBorder(button.IconBorder, nil, true)
        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, 0.25)
        hl:SetInside(button.bg)
    end

    local trackBox = form.TrackRecipeCheckBox
    if trackBox then
        F.ReskinCheckbox(trackBox)
        trackBox:SetSize(24, 24)
    end

    local checkBox = form.AllocateBestQualityCheckBox
    if checkBox then
        F.ReskinCheckbox(checkBox)
        checkBox:SetSize(24, 24)
    end

    local qDialog = form.QualityDialog
    if qDialog then
        F.StripTextures(qDialog)
        F.SetBD(qDialog)
        F.ReskinClose(qDialog.ClosePanelButton)
        F.Reskin(qDialog.AcceptButton)
        F.Reskin(qDialog.CancelButton)

        reskinQualityContainer(qDialog.Container1)
        reskinQualityContainer(qDialog.Container2)
        reskinQualityContainer(qDialog.Container3)
    end

    hooksecurefunc(form, 'Init', function(self)
        for slot in self.reagentSlotPool:EnumerateActive() do
            reskinSlotButton(slot.Button)
        end

        local slot = form.salvageSlot
        if slot then
            reskinSlotButton(slot.Button)
        end

        local eslot = form.enchantSlot
        if eslot then
            reskinSlotButton(eslot.Button)
        end
        -- #TODO: salvage flyout, item flyout, recraft flyout
    end)

    local rankBar = craftingPage.RankBar
    rankBar.Border:Hide()
    rankBar.Background:Hide()
    rankBar.Rank.Text:SetFontObject(_G.Game12Font)
    F.CreateBDFrame(rankBar.Fill, 1)

    F.ReskinArrow(craftingPage.LinkButton, 'right')
    craftingPage.LinkButton:SetSize(20, 20)
    craftingPage.LinkButton:SetPoint('LEFT', rankBar.Fill, 'RIGHT', 3, 0)

    local specPage = frame.SpecPage
    F.Reskin(specPage.UnlockTabButton)
    F.Reskin(specPage.ApplyButton)
    F.StripTextures(specPage.TreeView)
    specPage.TreeView.Background:Hide()
    F.CreateBDFrame(specPage.TreeView, 0.25):SetInside()

    hooksecurefunc(specPage, 'UpdateTabs', function(self)
        for tab in self.tabsPool:EnumerateActive() do
            if not tab.styled then
                tab.styled = true
                F.ReskinTab(tab)
            end
        end
    end)

    local view = specPage.DetailedView
    F.StripTextures(view)
    F.CreateBDFrame(view, 0.25):SetInside()
    F.Reskin(view.UnlockPathButton)
    F.Reskin(view.SpendPointsButton)
    F.ReskinIcon(view.UnspentPoints.Icon)

    -- log
    local outputLog = craftingPage.CraftingOutputLog
    F.StripTextures(outputLog)
    F.SetBD(outputLog)
    F.ReskinClose(outputLog.ClosePanelButton)
    F.ReskinTrimScroll(outputLog.ScrollBar, true)

    hooksecurefunc(outputLog.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                local itemContainer = child.ItemContainer
                if itemContainer then
                    local item = itemContainer.Item
                    item:SetNormalTexture(0)
                    item:SetPushedTexture(0)
                    item:SetHighlightTexture(0)

                    local icon = item:GetRegions()
                    item.bg = F.ReskinIcon(icon)
                    F.ReskinIconBorder(item.IconBorder, true)
                    itemContainer.CritFrame:SetAlpha(0)
                    itemContainer.BorderFrame:Hide()
                    itemContainer.HighlightNameFrame:SetAlpha(0)
                    itemContainer.PushedNameFrame:SetAlpha(0)
                    itemContainer.bg = F.CreateBDFrame(itemContainer.HighlightNameFrame, 0.25)
                end

                local bonus = child.CreationBonus
                if bonus then
                    local item = bonus.Item
                    F.StripTextures(item, 1)
                    local icon = item:GetRegions()
                    F.ReskinIcon(icon)
                end

                child.styled = true
            end

            local itemContainer = child.ItemContainer
            if itemContainer then
                itemContainer.Item.IconBorder:SetAlpha(0)

                local itemBG = itemContainer.bg
                if itemBG then
                    if itemContainer.CritFrame:IsShown() then
                        itemBG:SetBackdropBorderColor(1, 0.8, 0)
                    else
                        itemBG:SetBackdropBorderColor(0, 0, 0)
                    end
                end
            end
        end
    end)

    -- Item flyout
    if _G.OpenProfessionsItemFlyout then
        hooksecurefunc('OpenProfessionsItemFlyout', reskinProfessionsFlyout)
    end

    -- Order page
    if not frame.OrdersPage then
        return
    end -- not exists in retail yet

    local browseFrame = frame.OrdersPage.BrowseFrame
    F.Reskin(browseFrame.SearchButton)
    F.Reskin(browseFrame.FavoritesSearchButton)
    browseFrame.FavoritesSearchButton:SetSize(22, 22)

    local bfRecipeList = browseFrame.RecipeList
    F.StripTextures(bfRecipeList)
    F.ReskinTrimScroll(bfRecipeList.ScrollBar, true)
    if bfRecipeList.BackgroundNineSlice then
        bfRecipeList.BackgroundNineSlice:Hide()
    end -- in case blizz rename
    F.CreateBDFrame(bfRecipeList, 0.25):SetInside()
    F.ReskinEditBox(bfRecipeList.SearchBox)
    F.ReskinFilterButton(bfRecipeList.FilterButton)

    F.ReskinTab(browseFrame.PublicOrdersButton)
    F.ReskinTab(browseFrame.GuildOrdersButton)
    F.ReskinTab(browseFrame.PersonalOrdersButton)
    F.StripTextures(browseFrame.OrdersRemainingDisplay)
    F.CreateBDFrame(browseFrame.OrdersRemainingDisplay, 0.25)

    local orderList = browseFrame.OrderList
    F.StripTextures(orderList)
    orderList.Background:SetAlpha(0)
    F.CreateBDFrame(orderList, 0.25):SetInside()
    F.ReskinTrimScroll(orderList.ScrollBar, true)

    hooksecurefunc(frame.OrdersPage, 'SetupTable', function()
        local maxHeaders = orderList.HeaderContainer:GetNumChildren()
        for i = 1, maxHeaders do
            local header = select(i, orderList.HeaderContainer:GetChildren())
            if not header.styled then
                header:DisableDrawLayer('BACKGROUND')
                header.bg = F.CreateBDFrame(header)
                local hl = header:GetHighlightTexture()
                hl:SetColorTexture(1, 1, 1, 0.1)
                hl:SetAllPoints(header.bg)
                header.bg:SetPoint('TOPLEFT', 0, -2)
                header.bg:SetPoint('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)

                header.styled = true
            end
        end
    end)
    frame.OrdersPage:SetupTable() -- init header
end
