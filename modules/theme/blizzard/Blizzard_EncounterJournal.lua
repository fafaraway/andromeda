local F, C = unpack(select(2, ...))

local function OnEnable(self)
    self:SetHeight(self.storedHeight) -- prevent it from resizing
    self.__bg:SetBackdropColor(0, 0, 0, 0)
end

local function OnDisable(self)
    self.__bg:SetBackdropColor(C.r, C.g, C.b, .25)
end

local function OnClick(self)
    self:GetFontString():SetTextColor(1, 1, 1)
end

local bossIndex = 1
local function ReskinBossButtons()
    while true do
        local button = _G['EncounterJournalBossButton' .. bossIndex]
        if not button then
            return
        end

        F.Reskin(button, true)
        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(C.r, C.g, C.b, .25)
        hl:SetInside(button.__bg)

        button.text:SetTextColor(1, 1, 1)
        button.text.SetTextColor = F.Dummy
        button.creature:SetPoint('TOPLEFT', 0, -4)

        bossIndex = bossIndex + 1
    end
end

local instIndex = 1
local function ReskinInstanceButton()
    while true do
        local button = _G.EncounterJournal.instanceSelect.scroll.child['instance' .. instIndex]
        if not button then
            return
        end

        button:SetNormalTexture('')
        button:SetHighlightTexture('')
        button:SetPushedTexture('')

        local bg = F.CreateBDFrame(button.bgImage)
        bg:SetPoint('TOPLEFT', 3, -3)
        bg:SetPoint('BOTTOMRIGHT', -4, 2)

        instIndex = instIndex + 1
    end
end

local function ReskinHeader(header)
    header.flashAnim.Play = F.Dummy
    for i = 4, 18 do
        select(i, header.button:GetRegions()):SetTexture('')
    end
    F.Reskin(header.button)
    header.descriptionBG:SetAlpha(0)
    header.descriptionBGBottom:SetAlpha(0)
    header.description:SetTextColor(1, 1, 1)
    header.button.title:SetTextColor(1, 1, 1)
    header.button.title.SetTextColor = F.Dummy
    header.button.expandedIcon:SetWidth(20) -- don't wrap the text
    header.button.expandedIcon.SetTextColor = F.Dummy
    header.button.expandedIcon.SetTextColor = F.Dummy
end

local function ReskinSectionHeader()
    local index = 1
    while true do
        local header = _G['EncounterJournalInfoHeader' .. index]
        if not header then
            return
        end
        if not header.styled then
            ReskinHeader(header)
            header.button.bg = F.ReskinIcon(header.button.abilityIcon)
            header.styled = true
        end

        if header.button.abilityIcon:IsShown() then
            header.button.bg:Show()
        else
            header.button.bg:Hide()
        end

        index = index + 1
    end
end

local function ReskinFilterToggle(button)
    F.StripTextures(button)
    F.Reskin(button)
end

C.Themes['Blizzard_EncounterJournal'] = function()
    local r, g, b = C.r, C.g, C.b

    -- Tabs
    for _, tabName in pairs({'suggestTab', 'dungeonsTab', 'raidsTab', 'LootJournalTab'}) do
        local tab = _G.EncounterJournal.instanceSelect[tabName]
        local text = tab:GetFontString()

        F.StripTextures(tab)
        tab:SetHeight(tab.storedHeight)
        tab.grayBox:GetRegions():SetAllPoints(tab)
        text:SetPoint('CENTER')
        text:SetTextColor(1, 1, 1)
        F.Reskin(tab)
        if tabName == 'suggestTab' then
            tab.__bg:SetBackdropColor(r, g, b, .25)
        end

        tab:HookScript('OnEnable', OnEnable)
        tab:HookScript('OnDisable', OnDisable)
        tab:HookScript('OnClick', OnClick)
    end

    -- Side tabs
    local tabs = {'overviewTab', 'modelTab', 'bossTab', 'lootTab'}
    for _, name in pairs(tabs) do
        local tab = _G.EncounterJournal.encounter.info[name]
        local bg = F.SetBD(tab)
        bg:SetInside(tab, 2, 2)

        tab:SetNormalTexture('')
        tab:SetPushedTexture('')
        tab:SetDisabledTexture('')
        local hl = tab:GetHighlightTexture()
        hl:SetColorTexture(r, g, b, .2)
        hl:SetInside(bg)

        if name == 'overviewTab' then
            tab:SetPoint('TOPLEFT', _G.EncounterJournalEncounterFrameInfo, 'TOPRIGHT', 9, -35)
        end
    end

    -- Instance select
    ReskinInstanceButton()
    hooksecurefunc('EncounterJournal_ListInstances', ReskinInstanceButton)
    F.ReskinDropDown(_G.EncounterJournalInstanceSelectTierDropDown)
    F.ReskinScroll(_G.EncounterJournalInstanceSelectScrollFrame.ScrollBar)

    -- Encounter frame
    _G.EncounterJournalEncounterFrameInfo:DisableDrawLayer('BACKGROUND')
    _G.EncounterJournalInstanceSelectBG:Hide()
    _G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
    _G.EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()

    _G.EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject('GameFontNormalLarge')
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)

    F.CreateBDFrame(_G.EncounterJournalEncounterFrameInfoModelFrame, .25)
    _G.EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint('TOPLEFT', _G.EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

    hooksecurefunc('EncounterJournal_DisplayInstance', ReskinBossButtons)
    hooksecurefunc('EncounterJournal_ToggleHeaders', ReskinSectionHeader)

    hooksecurefunc('EncounterJournal_SetUpOverview', function(self, _, index)
        local header = self.overviews[index]
        if not header.styled then
            ReskinHeader(header)
            header.styled = true
        end
    end)

    hooksecurefunc('EncounterJournal_SetBullets', function(object)
        local parent = object:GetParent()
        if parent.Bullets then
            for _, bullet in pairs(parent.Bullets) do
                if not bullet.styled then
                    bullet.Text:SetTextColor(1, 1, 1)
                    bullet.styled = true
                end
            end
        end
    end)

    local items = _G.EncounterJournal.encounter.info.lootScroll.buttons
    for i = 1, #items do
        local item = items[i].lootFrame
        item.boss:SetTextColor(1, 1, 1)
        item.slot:SetTextColor(1, 1, 1)
        item.armorType:SetTextColor(1, 1, 1)
        item.bossTexture:SetAlpha(0)
        item.bosslessTexture:SetAlpha(0)
        item.IconBorder:SetAlpha(0)
        item.icon:SetPoint('TOPLEFT', 1, -1)
        F.ReskinIcon(item.icon)

        local bg = F.CreateBDFrame(item, .25)
        bg:SetPoint('TOPLEFT')
        bg:SetPoint('BOTTOMRIGHT', 0, 1)
    end

    -- Search results
    _G.EncounterJournalSearchBox:SetFrameLevel(15)
    for i = 1, 5 do
        F.StyleSearchButton(_G.EncounterJournalSearchBox['sbutton' .. i])
    end
    F.StyleSearchButton(_G.EncounterJournalSearchBox.showAllResults)
    F.StripTextures(_G.EncounterJournalSearchBox.searchPreviewContainer)

    do
        local result = _G.EncounterJournalSearchResults
        result:SetPoint('BOTTOMLEFT', _G.EncounterJournal, 'BOTTOMRIGHT', 15, -1)
        F.StripTextures(result)
        local bg = F.SetBD(result)
        bg:SetPoint('TOPLEFT', -10, 0)
        bg:SetPoint('BOTTOMRIGHT')

        for i = 1, 9 do
            local bu = _G['EncounterJournalSearchResultsScrollFrameButton' .. i]
            F.StripTextures(bu)
            F.ReskinIcon(bu.icon)
            bu.icon.SetTexCoord = F.Dummy
            local bg = F.CreateBDFrame(bu, .25)
            bg:SetInside()
            bu:SetHighlightTexture(C.Assets.Textures.Backdrop)
            local hl = bu:GetHighlightTexture()
            hl:SetVertexColor(r, g, b, .25)
            hl:SetInside(bg)
        end
    end

    F.ReskinClose(_G.EncounterJournalSearchResultsCloseButton)
    F.ReskinScroll(_G.EncounterJournalSearchResultsScrollFrameScrollBar)

    -- Various controls
    F.ReskinPortraitFrame(_G.EncounterJournal)
    F.Reskin(_G.EncounterJournalEncounterFrameInfoResetButton)
    F.ReskinInput(_G.EncounterJournalSearchBox)
    F.ReskinScroll(_G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
    F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
    F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
    F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
    F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)

    local buttons = {
        _G.EncounterJournalEncounterFrameInfoDifficulty,
        _G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle,
        _G.EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle
    }
    for _, button in pairs(buttons) do
        ReskinFilterToggle(button)
    end

    -- Suggest frame
    local suggestFrame = _G.EncounterJournal.suggestFrame

    -- Suggestion 1
    local suggestion = suggestFrame.Suggestion1
    suggestion.bg:Hide()
    F.CreateBDFrame(suggestion, .25)
    suggestion.icon:SetPoint('TOPLEFT', 135, -15)
    F.CreateBDFrame(suggestion.icon)

    local centerDisplay = suggestion.centerDisplay
    centerDisplay.title.text:SetTextColor(1, 1, 1)
    centerDisplay.description.text:SetTextColor(.9, .9, .9)
    F.Reskin(suggestion.button)

    local reward = suggestion.reward
    reward.text:SetTextColor(.9, .9, .9)
    reward.iconRing:Hide()
    reward.iconRingHighlight:SetTexture('')
    F.CreateBDFrame(reward.icon):SetFrameLevel(3)
    F.ReskinArrow(suggestion.prevButton, 'left')
    F.ReskinArrow(suggestion.nextButton, 'right')

    -- Suggestion 2 and 3
    for i = 2, 3 do
        local suggestion = suggestFrame['Suggestion' .. i]

        suggestion.bg:Hide()
        F.CreateBDFrame(suggestion, .25)
        suggestion.icon:SetPoint('TOPLEFT', 10, -10)
        F.CreateBDFrame(suggestion.icon)

        local centerDisplay = suggestion.centerDisplay

        centerDisplay:ClearAllPoints()
        centerDisplay:SetPoint('TOPLEFT', 85, -10)
        centerDisplay.title.text:SetTextColor(1, 1, 1)
        centerDisplay.description.text:SetTextColor(.9, .9, .9)
        F.Reskin(centerDisplay.button)

        local reward = suggestion.reward
        reward.iconRing:Hide()
        reward.iconRingHighlight:SetTexture('')
        F.CreateBDFrame(reward.icon):SetFrameLevel(3)
    end

    -- Hook functions
    hooksecurefunc('EJSuggestFrame_RefreshDisplay', function()
        local self = suggestFrame

        if #self.suggestions > 0 then
            local suggestion = self.Suggestion1
            local data = self.suggestions[1]
            suggestion.iconRing:Hide()

            if data.iconPath then
                suggestion.icon:SetMask(nil)
                suggestion.icon:SetTexCoord(unpack(C.TexCoord))
            end
        end

        if #self.suggestions > 1 then
            for i = 2, #self.suggestions do
                local suggestion = self['Suggestion' .. i]
                if not suggestion then
                    break
                end

                local data = self.suggestions[i]
                suggestion.iconRing:Hide()

                if data.iconPath then
                    suggestion.icon:SetMask(nil)
                    suggestion.icon:SetTexCoord(unpack(C.TexCoord))
                end
            end
        end
    end)

    hooksecurefunc('EJSuggestFrame_UpdateRewards', function(suggestion)
        local rewardData = suggestion.reward.data
        if rewardData then
            suggestion.reward.icon:SetMask('')
            suggestion.reward.icon:SetTexCoord(unpack(C.TexCoord))
        end
    end)

    -- LootJournal

    local lootJournal = _G.EncounterJournal.LootJournal
    F.StripTextures(lootJournal)
    F.ReskinScroll(lootJournal.PowersFrame.ScrollBar)
    ReskinFilterToggle(lootJournal.RuneforgePowerFilterDropDownButton)
    ReskinFilterToggle(lootJournal.ClassDropDownButton)

    local iconColor = C.QualityColors[_G.LE_ITEM_QUALITY_LEGENDARY or 5] -- legendary color
    hooksecurefunc(lootJournal.PowersFrame, 'RefreshListDisplay', function(self)
        if not self.elements then
            return
        end

        for i = 1, self:GetNumElementFrames() do
            local button = self.elements[i]
            if button and not button.bg then
                button.Background:SetAlpha(0)
                button.BackgroundOverlay:SetAlpha(0)
                button.UnavailableOverlay:SetAlpha(0)
                button.UnavailableBackground:SetAlpha(0)
                button.CircleMask:Hide()
                button.bg = F.ReskinIcon(button.Icon)
                button.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)

                local bg = F.CreateBDFrame(button, .25)
                bg:SetPoint('TOPLEFT', 3, 0)
                bg:SetPoint('BOTTOMRIGHT', -2, 1)
            end
        end
    end)

    -- ItemSetsFrame

    if _G.EncounterJournal.LootJournalItems then
        F.StripTextures(_G.EncounterJournal.LootJournalItems)
        F.ReskinDropDown(_G.EncounterJournal.LootJournalViewDropDown)

        local itemSetsFrame = _G.EncounterJournal.LootJournalItems.ItemSetsFrame
        F.ReskinScroll(itemSetsFrame.scrollBar)
        ReskinFilterToggle(itemSetsFrame.ClassButton)

        hooksecurefunc(itemSetsFrame, 'UpdateList', function(self)
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

        hooksecurefunc(itemSetsFrame, 'ConfigureItemButton', function(_, button)
            if not button.bg then
                button.Border:SetAlpha(0)
                button.bg = F.ReskinIcon(button.Icon)
            end

            local quality = select(3, GetItemInfo(button.itemID))
            local color = C.QualityColors[quality or 1]
            button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
        end)
    end
end
