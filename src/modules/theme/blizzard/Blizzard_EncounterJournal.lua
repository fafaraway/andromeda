local F, C = unpack(select(2, ...))

local function onEnable(self)
    self:SetHeight(self.storedHeight) -- prevent it from resizing
    self.__bg:SetBackdropColor(0, 0, 0, 0)
end

local function onDisable(self)
    self.__bg:SetBackdropColor(C.r, C.g, C.b, 0.25)
end

local function onClick(self)
    self:GetFontString():SetTextColor(1, 1, 1)
end

local bossIndex = 1
local function reskinBossButtons()
    while true do
        local button = _G['EncounterJournalBossButton' .. bossIndex]
        if not button then
            return
        end

        F.Reskin(button, true)
        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(C.r, C.g, C.b, 0.25)
        hl:SetInside(button.__bg)

        button.text:SetTextColor(1, 1, 1)
        button.text.SetTextColor = nop
        button.creature:SetPoint('TOPLEFT', 0, -4)

        bossIndex = bossIndex + 1
    end
end

local instIndex = 1
local function reskinInstanceButton()
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

local function reskinHeader(header)
    header.flashAnim.Play = nop
    for i = 4, 18 do
        select(i, header.button:GetRegions()):SetTexture('')
    end
    F.Reskin(header.button)
    header.descriptionBG:SetAlpha(0)
    header.descriptionBGBottom:SetAlpha(0)
    header.description:SetTextColor(1, 1, 1)
    header.button.title:SetTextColor(1, 1, 1)
    header.button.title.SetTextColor = nop
    header.button.expandedIcon:SetWidth(20) -- don't wrap the text
end

local function reskinSectionHeader()
    local index = 1
    while true do
        local header = _G['EncounterJournalInfoHeader' .. index]
        if not header then
            return
        end
        if not header.styled then
            reskinHeader(header)
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

local function reskinFilterToggle(button)
    F.StripTextures(button)
    F.Reskin(button)
end

C.Themes['Blizzard_EncounterJournal'] = function()
    local EncounterJournal = _G.EncounterJournal

    -- Tabs
    if C.IS_NEW_PATCH then
        for i = 1, 4 do
            local tab = EncounterJournal.Tabs[i]
            if tab then
                F.ReskinTab(tab)
                if i ~= 1 then
                    tab:ClearAllPoints()
                    tab:SetPoint('TOPLEFT', EncounterJournal.Tabs[i - 1], 'TOPRIGHT', -15, 0)
                end
            end
        end
    else
        for _, tabName in pairs({ 'suggestTab', 'dungeonsTab', 'raidsTab', 'LootJournalTab' }) do
            local tab = EncounterJournal.instanceSelect[tabName]
            local text = tab:GetFontString()

            F.StripTextures(tab)
            tab:SetHeight(tab.storedHeight)
            tab.grayBox:GetRegions():SetAllPoints(tab)
            text:SetPoint('CENTER')
            text:SetTextColor(1, 1, 1)
            F.Reskin(tab)
            if tabName == 'suggestTab' then
                tab.__bg:SetBackdropColor(C.r, C.g, C.b, 0.25)
            end

            tab:HookScript('OnEnable', onEnable)
            tab:HookScript('OnDisable', onDisable)
            tab:HookScript('OnClick', onClick)
        end
    end

    -- Side tabs
    local tabs = { 'overviewTab', 'modelTab', 'bossTab', 'lootTab' }
    for _, name in pairs(tabs) do
        local tab = EncounterJournal.encounter.info[name]
        local bg = F.SetBD(tab)
        bg:SetInside(tab, 2, 2)

        tab:SetNormalTexture(C.Assets.Textures.Blank)
        tab:SetPushedTexture(C.Assets.Textures.Blank)
        tab:SetDisabledTexture(C.Assets.Textures.Blank)
        local hl = tab:GetHighlightTexture()
        hl:SetColorTexture(C.r, C.g, C.b, 0.2)
        hl:SetInside(bg)

        if name == 'overviewTab' then
            tab:SetPoint('TOPLEFT', _G.EncounterJournalEncounterFrameInfo, 'TOPRIGHT', 9, -35)
        end
    end

    -- Instance select
    if C.IS_NEW_PATCH then
        F.ReskinTrimScroll(EncounterJournal.instanceSelect.ScrollBar)

        hooksecurefunc(EncounterJournal.instanceSelect.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    child:SetNormalTexture(C.Assets.Textures.Blank)
                    child:SetHighlightTexture(C.Assets.Textures.Blank)
                    child:SetPushedTexture(C.Assets.Textures.Blank)

                    local bg = F.CreateBDFrame(child.bgImage)
                    bg:SetPoint('TOPLEFT', 3, -3)
                    bg:SetPoint('BOTTOMRIGHT', -4, 2)

                    child.styled = true
                end
            end
        end)
    else
        reskinInstanceButton()
        hooksecurefunc('EncounterJournal_ListInstances', reskinInstanceButton)
        F.ReskinScroll(_G.EncounterJournalInstanceSelectScrollFrame.ScrollBar)
    end
    F.ReskinDropDown(_G.EncounterJournalInstanceSelectTierDropDown)

    -- Encounter frame
    _G.EncounterJournalEncounterFrameInfo:DisableDrawLayer('BACKGROUND')
    _G.EncounterJournalInstanceSelectBG:Hide()
    _G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
    _G.EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()

    _G.EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 0.8, 0)
    if C.IS_NEW_PATCH then
        EncounterJournal.encounter.instance.LoreScrollingFont:SetTextColor(CreateColor(1, 1, 1))
        _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor('P', 1, 1, 1)
    else
        _G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(1, 1, 1)
        _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1, 1, 1)
    end
    _G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject('GameFontNormalLarge')
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
    _G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 0.8, 0)

    F.CreateBDFrame(_G.EncounterJournalEncounterFrameInfoModelFrame, 0.25)
    _G.EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint('TOPLEFT', _G.EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

    if C.IS_NEW_PATCH then
        hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    F.Reskin(child, true)
                    local hl = child:GetHighlightTexture()
                    hl:SetColorTexture(C.r, C.g, C.b, 0.25)
                    hl:SetInside(child.__bg)

                    child.text:SetTextColor(1, 1, 1)
                    child.text.SetTextColor = nop
                    child.creature:SetPoint('TOPLEFT', 0, -4)

                    child.styled = true
                end
            end
        end)
    else
        hooksecurefunc('EncounterJournal_DisplayInstance', reskinBossButtons)
    end
    hooksecurefunc('EncounterJournal_ToggleHeaders', reskinSectionHeader)

    hooksecurefunc('EncounterJournal_SetUpOverview', function(self, _, index)
        local header = self.overviews[index]
        if not header.styled then
            reskinHeader(header)
            header.styled = true
        end
    end)

    hooksecurefunc('EncounterJournal_SetBullets', function(object)
        local parent = object:GetParent()
        if parent.Bullets then
            for _, bullet in pairs(parent.Bullets) do
                if not bullet.styled then
                    if C.IS_NEW_PATCH then
                        bullet.Text:SetTextColor('P', 1, 1, 1)
                    else
                        bullet.Text:SetTextColor(1, 1, 1)
                    end
                    bullet.styled = true
                end
            end
        end
    end)

    if C.IS_NEW_PATCH then
        hooksecurefunc(EncounterJournal.encounter.info.LootContainer.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    child.boss:SetTextColor(1, 1, 1)
                    child.slot:SetTextColor(1, 1, 1)
                    child.armorType:SetTextColor(1, 1, 1)
                    child.bossTexture:SetAlpha(0)
                    child.bosslessTexture:SetAlpha(0)
                    child.IconBorder:SetAlpha(0)
                    child.icon:SetPoint('TOPLEFT', 1, -1)
                    F.ReskinIcon(child.icon)

                    local bg = F.CreateBDFrame(child, 0.25)
                    bg:SetPoint('TOPLEFT')
                    bg:SetPoint('BOTTOMRIGHT', 0, 1)

                    child.styled = true
                end
            end
        end)
    else
        local items = EncounterJournal.encounter.info.lootScroll.buttons
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

            local bg = F.CreateBDFrame(item, 0.25)
            bg:SetPoint('TOPLEFT')
            bg:SetPoint('BOTTOMRIGHT', 0, 1)
        end
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
        result:SetPoint('BOTTOMLEFT', EncounterJournal, 'BOTTOMRIGHT', 15, -1)
        F.StripTextures(result)
        local bg = F.SetBD(result)
        bg:SetPoint('TOPLEFT', -10, 0)
        bg:SetPoint('BOTTOMRIGHT')

        F.ReskinClose(_G.EncounterJournalSearchResultsCloseButton)

        if C.IS_NEW_PATCH then
            F.ReskinTrimScroll(result.ScrollBar)

            hooksecurefunc(result.ScrollBox, 'Update', function(self)
                for i = 1, self.ScrollTarget:GetNumChildren() do
                    local child = select(i, self.ScrollTarget:GetChildren())
                    if not child.styled then
                        F.StripTextures(child, 2)
                        F.ReskinIcon(child.icon)
                        local bg = F.CreateBDFrame(child, 0.25)
                        bg:SetInside()

                        child:SetHighlightTexture(C.Assets.Textures.Backdrop)
                        local hl = child:GetHighlightTexture()
                        hl:SetVertexColor(C.r, C.g, C.b, 0.25)
                        hl:SetInside(bg)

                        child.styled = true
                    end
                end
            end)
        else
            for i = 1, 9 do
                local bu = _G['EncounterJournalSearchResultsScrollFrameButton' .. i]
                F.StripTextures(bu)
                F.ReskinIcon(bu.icon)
                bu.icon.SetTexCoord = nop
                local bg = F.CreateBDFrame(bu, 0.25)
                bg:SetInside()
                bu:SetHighlightTexture(C.Assets.Textures.Backdrop)
                local hl = bu:GetHighlightTexture()
                hl:SetVertexColor(C.r, C.g, C.b, 0.25)
                hl:SetInside(bg)
            end
            F.ReskinScroll(_G.EncounterJournalSearchResultsScrollFrameScrollBar)
        end
    end

    -- Various controls
    F.ReskinPortraitFrame(EncounterJournal)
    F.Reskin(_G.EncounterJournalEncounterFrameInfoResetButton)
    F.ReskinInput(_G.EncounterJournalSearchBox)
    if C.IS_NEW_PATCH then
        F.ReskinTrimScroll(EncounterJournal.encounter.instance.LoreScrollBar)
        F.ReskinScroll(EncounterJournal.encounter.info.overviewScroll.ScrollBar)
        F.ReskinTrimScroll(EncounterJournal.encounter.info.BossesScrollBar)
        F.ReskinScroll(EncounterJournal.encounter.info.detailsScroll.ScrollBar)
        F.ReskinTrimScroll(EncounterJournal.encounter.info.LootContainer.ScrollBar)
    else
        F.ReskinScroll(_G.EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
        F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollBar)
        F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoBossesScrollFrameScrollBar)
        F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
        F.ReskinScroll(_G.EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)
    end

    local buttons = {
        _G.EncounterJournalEncounterFrameInfoDifficulty,
        _G.EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle,
        _G.EncounterJournalEncounterFrameInfoLootScrollFrameSlotFilterToggle,
        _G.EncounterJournalEncounterFrameInfoFilterToggle, -- isNewPatch
        _G.EncounterJournalEncounterFrameInfoSlotFilterToggle, -- isNewPatch
    }
    for _, button in pairs(buttons) do
        reskinFilterToggle(button)
    end

    -- Suggest frame
    local suggestFrame = EncounterJournal.suggestFrame

    -- Suggestion 1
    local suggestion = suggestFrame.Suggestion1
    suggestion.bg:Hide()
    F.CreateBDFrame(suggestion, 0.25)
    suggestion.icon:SetPoint('TOPLEFT', 135, -15)
    F.CreateBDFrame(suggestion.icon)

    local centerDisplay = suggestion.centerDisplay
    centerDisplay.title.text:SetTextColor(1, 1, 1)
    centerDisplay.description.text:SetTextColor(0.9, 0.9, 0.9)
    F.Reskin(suggestion.button)

    local reward = suggestion.reward
    reward.text:SetTextColor(0.9, 0.9, 0.9)
    reward.iconRing:Hide()
    reward.iconRingHighlight:SetTexture('')
    F.CreateBDFrame(reward.icon):SetFrameLevel(3)
    F.ReskinArrow(suggestion.prevButton, 'left')
    F.ReskinArrow(suggestion.nextButton, 'right')

    -- Suggestion 2 and 3
    for i = 2, 3 do
        local suggestion = suggestFrame['Suggestion' .. i]

        suggestion.bg:Hide()
        F.CreateBDFrame(suggestion, 0.25)
        suggestion.icon:SetPoint('TOPLEFT', 10, -10)
        F.CreateBDFrame(suggestion.icon)

        local centerDisplay = suggestion.centerDisplay

        centerDisplay:ClearAllPoints()
        centerDisplay:SetPoint('TOPLEFT', 85, -10)
        centerDisplay.title.text:SetTextColor(1, 1, 1)
        centerDisplay.description.text:SetTextColor(0.9, 0.9, 0.9)
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
                suggestion.icon:SetMask('')
                suggestion.icon:SetTexCoord(unpack(C.TEX_COORD))
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
                    suggestion.icon:SetMask('')
                    suggestion.icon:SetTexCoord(unpack(C.TEX_COORD))
                end
            end
        end
    end)

    hooksecurefunc('EJSuggestFrame_UpdateRewards', function(suggestion)
        local rewardData = suggestion.reward.data
        if rewardData then
            suggestion.reward.icon:SetMask('')
            suggestion.reward.icon:SetTexCoord(unpack(C.TEX_COORD))
        end
    end)

    -- LootJournal

    local lootJournal = EncounterJournal.LootJournal
    F.StripTextures(lootJournal)
    reskinFilterToggle(lootJournal.RuneforgePowerFilterDropDownButton)
    reskinFilterToggle(lootJournal.ClassDropDownButton)

    local iconColor = C.QualityColors[Enum.ItemQuality.Legendary or 5] -- legendary color
    if C.IS_NEW_PATCH then
        F.ReskinTrimScroll(lootJournal.ScrollBar)

        hooksecurefunc(lootJournal.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    child.Background:SetAlpha(0)
                    child.BackgroundOverlay:SetAlpha(0)
                    child.UnavailableOverlay:SetAlpha(0)
                    child.UnavailableBackground:SetAlpha(0)
                    child.CircleMask:Hide()
                    child.bg = F.ReskinIcon(child.Icon)
                    child.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)

                    local bg = F.CreateBDFrame(child, 0.25)
                    bg:SetPoint('TOPLEFT', 3, 0)
                    bg:SetPoint('BOTTOMRIGHT', -2, 1)

                    child.styled = true
                end
            end
        end)
    else
        F.ReskinScroll(lootJournal.PowersFrame.ScrollBar)

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

                    local bg = F.CreateBDFrame(button, 0.25)
                    bg:SetPoint('TOPLEFT', 3, 0)
                    bg:SetPoint('BOTTOMRIGHT', -2, 1)
                end
            end
        end)
    end

    -- ItemSetsFrame
    if EncounterJournal.LootJournalItems then
        F.StripTextures(EncounterJournal.LootJournalItems)
        F.ReskinDropDown(EncounterJournal.LootJournalViewDropDown)

        local itemSetsFrame = EncounterJournal.LootJournalItems.ItemSetsFrame
        F.ReskinScroll(itemSetsFrame.scrollBar)
        reskinFilterToggle(itemSetsFrame.ClassButton)

        hooksecurefunc(itemSetsFrame, 'UpdateList', function(self)
            local buttons = self.buttons
            for i = 1, #buttons do
                local button = buttons[i]
                if not button.styled then
                    button.ItemLevel:SetTextColor(1, 1, 1)
                    button.Background:Hide()
                    F.CreateBDFrame(button, 0.25)

                    button.styled = true
                end
            end
        end)

        hooksecurefunc(itemSetsFrame, 'ConfigureItemButton', function(_, button)
            if not button.bg then
                button.bg = F.ReskinIcon(button.Icon)
                F.ReskinIconBorder(button.Border, true, true)
            end
        end)
    end
end
