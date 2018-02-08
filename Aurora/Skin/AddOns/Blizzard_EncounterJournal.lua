local _, private = ...

-- [[ Lua Globals ]]
local select, next, ipairs = _G.select, _G.next, _G.ipairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_EncounterJournal()
    local r, g, b = C.r, C.g, C.b

    local EncounterJournal = _G.EncounterJournal
    F.ReskinPortraitFrame(EncounterJournal)

    F.CreateBD(_G.EncounterJournal)
    F.CreateSD(_G.EncounterJournal)

    -- [[ SearchBox ]]
    local searchBox = EncounterJournal.searchBox
    F.ReskinInput(_G.EncounterJournalSearchBox)

    searchBox.searchPreviewContainer.botLeftCorner:Hide()
    searchBox.searchPreviewContainer.botRightCorner:Hide()
    searchBox.searchPreviewContainer.bottomBorder:Hide()
    searchBox.searchPreviewContainer.leftBorder:Hide()
    searchBox.searchPreviewContainer.rightBorder:Hide()

    local function resultOnEnter(self)
        self.hl:Show()
    end

    local function resultOnLeave(self)
        self.hl:Hide()
    end

    local function styleSearchButton(result, index)
        if index == 1 then
            result:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", 0, 1)
            result:SetPoint("TOPRIGHT", searchBox, "BOTTOMRIGHT", -5, 1)
        else
            result:SetPoint("TOPLEFT", searchBox.searchPreview[index-1], "BOTTOMLEFT", 0, 1)
            result:SetPoint("TOPRIGHT", searchBox.searchPreview[index-1], "BOTTOMRIGHT", 0, 1)
        end

        result:SetNormalTexture("")
        result:SetPushedTexture("")
        result:SetHighlightTexture("")

        local hl = result:CreateTexture(nil, "BACKGROUND")
        hl:SetAllPoints()
        hl:SetTexture(C.media.backdrop)
        hl:SetVertexColor(r, g, b, .2)
        hl:Hide()
        result.hl = hl

        F.CreateBD(result)
        result:SetBackdropColor(.1, .1, .1, .9)

        if result.icon then
            result:GetRegions():Hide() -- icon frame

            result.icon:SetTexCoord(.08, .92, .08, .92)

            local bg = F.CreateBG(result.icon)
            bg:SetDrawLayer("BACKGROUND", 1)
        end

        result:HookScript("OnEnter", resultOnEnter)
        result:HookScript("OnLeave", resultOnLeave)
    end

    for i = 1, #searchBox.searchPreview do
        styleSearchButton(searchBox.searchPreview[i], i)
    end
    styleSearchButton(searchBox.showAllResults, 6)


    -- [[ SearchResults ]]
    local searchResults = EncounterJournal.searchResults
    F.CreateBD(searchResults)
    searchResults:SetBackdropColor(.15, .15, .15, .9)
    for i = 3, 11 do
        select(i, searchResults:GetRegions()):Hide()
    end

    _G.EncounterJournalSearchResultsBg:Hide()
    F.ReskinClose(_G.EncounterJournalSearchResultsCloseButton)
    F.ReskinScroll(searchResults.scrollFrame.scrollBar)

    hooksecurefunc("EncounterJournal_SearchUpdate", function()
        local scrollFrame = searchResults.scrollFrame
        local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
        local results = scrollFrame.buttons
        local result, index

        local numResults = _G.EJ_GetNumSearchResults()

        for i = 1, #results do
            result = results[i]
            index = offset + i

            if index <= numResults then
                if not result.styled then
                    result:SetNormalTexture("")
                    result:SetPushedTexture("")
                    result:GetRegions():Hide()

                    result.resultType:SetTextColor(1, 1, 1)
                    result.path:SetTextColor(1, 1, 1)

                    F.CreateBG(result.icon)

                    result.styled = true
                end

                if result.icon:GetTexCoord() == 0 then
                    result.icon:SetTexCoord(.08, .92, .08, .92)
                end
            end
        end
    end)

    hooksecurefunc(searchResults.scrollFrame, "update", function(self)
        for i = 1, #self.buttons do
            local result = self.buttons[i]

            if result.icon:GetTexCoord() == 0 then
                result.icon:SetTexCoord(.08, .92, .08, .92)
            end
        end
    end)


    --[[ NavBar ]]
    EncounterJournal.navBar:SetWidth(550)
    EncounterJournal.navBar:SetPoint("TOPLEFT", 20, -22)

    --[[ Inset ]]
    EncounterJournal.inset:DisableDrawLayer("BORDER")
    EncounterJournal.inset.Bg:Hide()


    --[[ InstanceSelect ]]
    local instanceSelect = EncounterJournal.instanceSelect
    instanceSelect.bg:Hide()

    local function onEnable(self)
        self:SetHeight(self.storedHeight) -- prevent it from resizing
        self:SetBackdropColor(0, 0, 0, 0)
    end
    local function onDisable(self)
        self:SetBackdropColor(r, g, b, .2)
    end
    local function onClick(self)
        self:GetFontString():SetTextColor(1, 1, 1)
    end

    for i = 1, #instanceSelect.Tabs do
        local tab = instanceSelect.Tabs[i]
        local text = tab:GetFontString()

        tab:DisableDrawLayer("OVERLAY")

        tab.mid:Hide()
        tab.left:Hide()
        tab.right:Hide()

        tab.midHighlight:SetAlpha(0)
        tab.leftHighlight:SetAlpha(0)
        tab.rightHighlight:SetAlpha(0)

        tab:SetHeight(tab.storedHeight)
        tab.grayBox:GetRegions():SetAllPoints(tab)

        text:SetPoint("CENTER")
        text:SetTextColor(1, 1, 1)

        tab:HookScript("OnEnable", onEnable)
        tab:HookScript("OnDisable", onDisable)
        tab:HookScript("OnClick", onClick)

        F.Reskin(tab)
    end

    F.ReskinDropDown(instanceSelect.tierDropDown)
    F.ReskinScroll(instanceSelect.scroll.ScrollBar)

    local function listInstances()
        local index = 1
        while true do
            local bu = instanceSelect.scroll.child.InstanceButtons[index]
            if not bu then return end

            bu:SetNormalTexture("")
            bu:SetHighlightTexture("")
            bu:SetPushedTexture("")

            bu.bgImage:SetDrawLayer("BACKGROUND", 1)

            local bg = F.CreateBG(bu.bgImage)
            bg:SetPoint("TOPLEFT", 3, -3)
            bg:SetPoint("BOTTOMRIGHT", -4, 2)

            index = index + 1
        end
    end
    hooksecurefunc("EncounterJournal_ListInstances", listInstances)
    listInstances()


    --[[ EncounterFrame ]]
    local encounter = EncounterJournal.encounter
        local function SkinEJButton(button)
            button.UpLeft:SetAlpha(0)
            button.UpRight:SetAlpha(0)
            button.DownLeft:SetAlpha(0)
            button.DownRight:SetAlpha(0)
            select(5, button:GetRegions()):Hide()
            select(6, button:GetRegions()):Hide()
            F.Reskin(button)
        end

        --[[ InstanceFrame ]]
        _G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
        F.ReskinScroll(_G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)

        --[[ Info ]]
        local info = encounter.info
        info:DisableDrawLayer("BACKGROUND")

        info.encounterTitle:SetTextColor(1, 1, 1)

        info.overviewTab:ClearAllPoints()
        info.overviewTab:SetPoint("TOPLEFT", info, "TOPRIGHT", 9, -35)
        info.lootTab:ClearAllPoints()
        info.lootTab:SetPoint("TOP", info.overviewTab, "BOTTOM", 0, 1)
        info.bossTab:ClearAllPoints()
        info.bossTab:SetPoint("TOP", info.lootTab, "BOTTOM", 0, 1)
        for _, key in next, {"overviewTab", "lootTab", "bossTab", "modelTab"} do
            local tab = info[key]
            tab:SetScale(.75)

            tab:SetBackdrop({
                bgFile = C.media.backdrop,
                edgeFile = C.media.backdrop,
                edgeSize = 1 / .75,
            })

            tab:SetBackdropColor(0, 0, 0, .5)
            tab:SetBackdropBorderColor(0, 0, 0)

            tab:SetNormalTexture("")
            tab:SetPushedTexture("")
            tab:SetDisabledTexture("")
            tab:SetHighlightTexture("")
        end

        F.ReskinScroll(info.bossesScroll.ScrollBar)

        SkinEJButton(info.difficulty)

        F.Reskin(info.reset)

        info.detailsScroll.child.description:SetTextColor(1, 1, 1)
        F.ReskinScroll(info.detailsScroll.ScrollBar)

        info.overviewScroll.child.loreDescription:SetTextColor(1, 1, 1)
        info.overviewScroll.child.header:Hide()
        _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")
        _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
        info.overviewScroll.child.overviewDescription.Text:SetTextColor(1, 1, 1)
        F.ReskinScroll(info.overviewScroll.ScrollBar)

        SkinEJButton(info.lootScroll.filter)
        SkinEJButton(info.lootScroll.slotFilter)
        F.ReskinScroll(info.lootScroll.scrollBar)
        local encLoot = info.lootScroll.buttons
        for i = 1, #encLoot do
            local item = encLoot[i]

            item.boss:SetTextColor(1, 1, 1)
            item.slot:SetTextColor(1, 1, 1)
            item.armorType:SetTextColor(1, 1, 1)

            item.bossTexture:SetAlpha(0)
            item.bosslessTexture:SetAlpha(0)

            item.icon:SetPoint("TOPLEFT", 1, -1)

            item.icon:SetTexCoord(.08, .92, .08, .92)
            item.icon:SetDrawLayer("OVERLAY")
            F.CreateBG(item.icon)

            local bg = CreateFrame("Frame", nil, item)
            bg:SetPoint("TOPLEFT")
            bg:SetPoint("BOTTOMRIGHT", 0, 1)
            bg:SetFrameLevel(item:GetFrameLevel() - 1)
            F.CreateBD(bg, .25)
        end

        info.model.dungeonBG:Hide()
        _G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
        F.CreateBDFrame(_G.EncounterJournalEncounterFrameInfoModelFrame, .25)

        info.creatureButtons[1]:SetPoint("TOPLEFT", info.model, 0, -35)

        do
            local numBossButtons = 1
            local bossButton

            hooksecurefunc("EncounterJournal_DisplayInstance", function()
                bossButton = _G["EncounterJournalBossButton"..numBossButtons]
                while bossButton do
                    F.Reskin(bossButton, true)

                    bossButton.text:SetTextColor(1, 1, 1)
                    bossButton.text.SetTextColor = F.dummy

                    local hl = bossButton:GetHighlightTexture()
                    hl:SetColorTexture(r, g, b, .2)
                    hl:SetPoint("TOPLEFT", 2, -1)
                    hl:SetPoint("BOTTOMRIGHT", 0, 1)

                    bossButton.creature:SetPoint("TOPLEFT", 0, -4)

                    numBossButtons = numBossButtons + 1
                    bossButton = _G["EncounterJournalBossButton"..numBossButtons]
                end

                -- move last tab
                local _, point = _G.EncounterJournalEncounterFrameInfoModelTab:GetPoint()
                _G.EncounterJournalEncounterFrameInfoModelTab:SetPoint("TOP", point, "BOTTOM", 0, 1)
            end)
        end

        hooksecurefunc("EncounterJournal_ToggleHeaders", function(self)
            local index = 1
            local header = _G["EncounterJournalInfoHeader"..index]
            while header do
                if not header.styled then
                    header.flashAnim.Play = F.dummy

                    header.descriptionBG:SetAlpha(0)
                    header.descriptionBGBottom:SetAlpha(0)
                    for i = 4, 18 do
                        select(i, header.button:GetRegions()):SetTexture("")
                    end

                    header.description:SetTextColor(1, 1, 1)
                    header.button.title:SetTextColor(1, 1, 1)
                    header.button.title.SetTextColor = F.dummy
                    header.button.expandedIcon:SetTextColor(1, 1, 1)
                    header.button.expandedIcon.SetTextColor = F.dummy

                    F.Reskin(header.button)

                    header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
                    header.button.bg = F.CreateBG(header.button.abilityIcon)

                    header.styled = true
                end

                if header.button.abilityIcon:IsShown() then
                    header.button.bg:Show()
                else
                    header.button.bg:Hide()
                end

                index = index + 1
                header = _G["EncounterJournalInfoHeader"..index]
            end
        end)

        hooksecurefunc("EncounterJournal_SetUpOverview", function(self, role, index)
            local header = self.overviews[index]
            if not header.styled then
                header.flashAnim.Play = F.dummy

                header.descriptionBG:SetAlpha(0)
                header.descriptionBGBottom:SetAlpha(0)
                for i = 4, 18 do
                    select(i, header.button:GetRegions()):SetTexture("")
                end

                header.button.title:SetTextColor(1, 1, 1)
                header.button.title.SetTextColor = F.dummy
                header.button.expandedIcon:SetTextColor(1, 1, 1)
                header.button.expandedIcon.SetTextColor = F.dummy

                F.Reskin(header.button)

                header.styled = true
            end
        end)

        hooksecurefunc("EncounterJournal_SetBullets", function(object, description)
            local parent = object:GetParent()

            if parent.Bullets then
                for _, bullet in next, parent.Bullets do
                    if not bullet.styled then
                        bullet.Text:SetTextColor(1, 1, 1)
                        bullet.styled = true
                    end
                end
            end
        end)

        local items = _G.EncounterJournal.encounter.info.lootScroll.buttons

        for i = 1, #items do
            local item = items[i]

            item.boss:SetTextColor(1, 1, 1)
            item.slot:SetTextColor(1, 1, 1)
            item.armorType:SetTextColor(1, 1, 1)

            item.bossTexture:SetAlpha(0)
            item.bosslessTexture:SetAlpha(0)
            item.IconBorder:SetAlpha(0)

            item.icon:SetPoint("TOPLEFT", 1, -1)

            item.icon:SetTexCoord(.08, .92, .08, .92)
            item.icon:SetDrawLayer("OVERLAY")
            F.CreateBG(item.icon)

            local bg = CreateFrame("Frame", nil, item)
            bg:SetPoint("TOPLEFT")
            bg:SetPoint("BOTTOMRIGHT", 0, 1)
            bg:SetFrameLevel(item:GetFrameLevel() - 1)
            F.CreateBD(bg, .25)
        end


    -- [[ SuggestFrame ]]
    local suggestFrame = EncounterJournal.suggestFrame
    do
        -- Suggestion 1
        local suggestion = suggestFrame.Suggestion1

        suggestion.bg:Hide()

        F.CreateBD(suggestion, .25)

        suggestion.icon:SetPoint("TOPLEFT", 135, -15)
        F.CreateBG(suggestion.icon)

        local centerDisplay = suggestion.centerDisplay

        centerDisplay.title.text:SetTextColor(1, 1, 1)
        centerDisplay.description.text:SetTextColor(.9, .9, .9)

        F.Reskin(suggestion.button)

        local reward = suggestion.reward

        reward.text:SetTextColor(.9, .9, .9)
        reward.iconRing:Hide()
        reward.iconRingHighlight:SetTexture("")
        F.CreateBG(reward.icon)

        F.ReskinArrow(suggestion.prevButton, "Left")
        F.ReskinArrow(suggestion.nextButton, "Right")

        -- Suggestion 2 and 3

        for i = 2, 3 do
            suggestion = suggestFrame["Suggestion"..i]

            suggestion.bg:Hide()

            F.CreateBD(suggestion, .25)

            suggestion.icon:SetPoint("TOPLEFT", 10, -10)
            F.CreateBG(suggestion.icon)

            centerDisplay = suggestion.centerDisplay

            centerDisplay:ClearAllPoints()
            centerDisplay:SetPoint("TOPLEFT", 85, -10)
            centerDisplay.title.text:SetTextColor(1, 1, 1)
            centerDisplay.description.text:SetTextColor(.9, .9, .9)

            F.Reskin(centerDisplay.button)

            reward = suggestion.reward

            reward.iconRing:Hide()
            reward.iconRingHighlight:SetTexture("")
            F.CreateBG(reward.icon)
        end
    end
    hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
        local self = suggestFrame

        if #self.suggestions > 0 then
            local suggestion = self.Suggestion1
            local data = self.suggestions[1]

            suggestion.iconRing:Hide()

            if data.iconPath then
                suggestion.icon:SetMask("")
                suggestion.icon:SetTexture(data.iconPath)
                suggestion.icon:SetTexCoord(.08, .92, .08, .92)
            end
        end

        if #self.suggestions > 1 then
            for i = 2, #self.suggestions do
                local suggestion = self["Suggestion"..i]
                if not suggestion then break end

                local data = self.suggestions[i]

                suggestion.iconRing:Hide()

                if data.iconPath then
                    suggestion.icon:SetMask("")
                    suggestion.icon:SetTexture(data.iconPath)
                    suggestion.icon:SetTexCoord(.08, .92, .08, .92)
                end
            end
        end
    end)

    hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
        local rewardData = suggestion.reward.data
        if rewardData then
            suggestion.reward.icon:SetMask("")
            suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
        end
    end)


    --[[ EncounterJournalTooltip ]]
    if not private.disabled.tooltips then
        Base.SetBackdrop(_G.EncounterJournalTooltip)
        _G.EncounterJournalTooltip.Item1._auroraIconBorder = F.ReskinIcon(_G.EncounterJournalTooltip.Item1.icon)
        _G.EncounterJournalTooltip.Item2._auroraIconBorder = F.ReskinIcon(_G.EncounterJournalTooltip.Item2.icon)
    end


    -- [[ LootJournal ]]
    local function SkinLootBtn(btn)
        F.Reskin(btn)
        btn:GetFontString():SetTextColor(1, 1, 1)
        select(5, btn:GetRegions()):Hide()
        select(6, btn:GetRegions()):Hide()
        btn.UpLeft:SetAlpha(0)
        btn.UpRight:SetAlpha(0)
        btn.HighLeft:SetAlpha(0)
        btn.HighRight:SetAlpha(0)
        btn.DownLeft:SetAlpha(0)
        btn.DownRight:SetAlpha(0)
    end

    local LootJournal = EncounterJournal.LootJournal
    LootJournal:DisableDrawLayer("BACKGROUND")

    F.ReskinDropDown(LootJournal.ViewDropDown)

    local LegendariesFrame = LootJournal.LegendariesFrame
    SkinLootBtn(LegendariesFrame.ClassButton)
    SkinLootBtn(LegendariesFrame.SlotButton)

    local itemsLeftSide = LootJournal.LegendariesFrame.buttons
    local itemsRightSide = LootJournal.LegendariesFrame.rightSideButtons
    for _, items in ipairs({itemsLeftSide, itemsRightSide}) do
        for i = 1, #items do
            local item = items[i]

            item.ItemType:SetTextColor(1, 1, 1)
            item.Background:Hide()

            item.Icon:SetPoint("TOPLEFT", 1, -1)

            item.Icon:SetTexCoord(.08, .92, .08, .92)
            item.Icon:SetDrawLayer("OVERLAY")
            F.CreateBG(item.Icon)

            local bg = CreateFrame("Frame", nil, item)
            bg:SetPoint("TOPLEFT")
            bg:SetPoint("BOTTOMRIGHT", 0, 1)
            bg:SetFrameLevel(item:GetFrameLevel() - 1)
            F.CreateBD(bg, .25)
        end
    end

    local ItemSetsFrame = LootJournal.ItemSetsFrame
    SkinLootBtn(ItemSetsFrame.ClassButton)
    F.ReskinScroll(_G.EncounterJournalScrollBar, "EncounterJournal")

    hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "UpdateList", function(self)
        local buttons = self.buttons
        for i = 1, #buttons do
            local button = buttons[i]

            if not button.styled then
                button.ItemLevel:SetTextColor(1, 1, 1)
                button.Background:Hide()
                F.CreateBDFrame(button, .25)

                button.styled = true
            end
        end
    end)

    hooksecurefunc(EncounterJournal.LootJournal.ItemSetsFrame, "ConfigureItemButton", function(self, button)
        if not button.styled then
            button.Border:SetAlpha(0)
            button.Icon:SetTexCoord(.08, .92, .08, .92)
            button.bg = F.CreateBDFrame(button.Icon)

            -- local _, _, quality = GetItemInfo(button.itemID)
            -- local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
            -- button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
            button.bg:SetBackdropBorderColor(0, 0, 0)

            button.styled = true
        end
    end)

    -- hooksecurefunc(ItemSetsFrame, "UpdateList", function()
    --     local itemSets = ItemSetsFrame.buttons
    --     for i = 1, #itemSets do
    --         local itemSet = itemSets[i]

    --         itemSet.ItemLevel:SetTextColor(1, 1, 1)
    --         itemSet.Background:Hide()

    --         if not itemSet.bg then
    --             local bg = CreateFrame("Frame", nil, itemSet)
    --             bg:SetPoint("TOPLEFT")
    --             bg:SetPoint("BOTTOMRIGHT", 0, 1)
    --             bg:SetFrameLevel(itemSet:GetFrameLevel() - 1)
    --             F.CreateBD(bg, .25)
    --             itemSet.bg = bg
    --         end

    --         local items = itemSet.ItemButtons
    --         for j = 1, #items do
    --             local item = items[j]

    --             item.Border:Hide()
    --             item.Icon:SetPoint("TOPLEFT", 1, -1)

    --             item.Icon:SetTexCoord(.08, .92, .08, .92)
    --             item.Icon:SetDrawLayer("OVERLAY")
    --             F.CreateBG(item.Icon)
    --         end
    --     end
    -- end)
end
