local F, C = unpack(select(2, ...))

C.Themes['Blizzard_Collections'] = function()
    local r, g, b = C.r, C.g, C.b

    -- [[ General ]]

    _G.CollectionsJournal.bg = F.ReskinPortraitFrame(_G.CollectionsJournal) -- need this for Rematch skin

    _G.CollectionsJournalTab1:ClearAllPoints()
    _G.CollectionsJournalTab1:SetPoint('TOPLEFT', _G.CollectionsJournal, 'BOTTOMLEFT', 10, 1)

    for i = 1, 5 do
        local tab = _G['CollectionsJournalTab' .. i]
        F.ReskinTab(tab)
        if i > 1 then
            tab:SetPoint('LEFT', _G['CollectionsJournalTab' .. (i - 1)], 'RIGHT', -10, 0)
        end
    end

    -- [[ Mounts and pets ]]

    local PetJournal = _G.PetJournal
    local MountJournal = _G.MountJournal

    MountJournal.LeftInset:Hide()
    MountJournal.RightInset:Hide()
    MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
    MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
    MountJournal.MountDisplay.ShadowOverlay:Hide()
    PetJournal.LeftInset:Hide()
    PetJournal.RightInset:Hide()
    PetJournal.PetCardInset:Hide()
    PetJournal.loadoutBorder:Hide()
    _G.PetJournalTutorialButton.Ring:Hide()

    F.StripTextures(MountJournal.MountCount)
    F.CreateBDFrame(MountJournal.MountCount, 0.25)
    F.StripTextures(PetJournal.PetCount)
    F.CreateBDFrame(PetJournal.PetCount, 0.25)
    PetJournal.PetCount:SetWidth(140)
    F.CreateBDFrame(MountJournal.MountDisplay.ModelScene, 0.25)
    F.ReskinIcon(MountJournal.MountDisplay.InfoButton.Icon)

    F.Reskin(_G.MountJournalMountButton)
    F.Reskin(_G.PetJournalSummonButton)
    F.Reskin(_G.PetJournalFindBattle)
    F.ReskinScroll(_G.MountJournalListScrollFrameScrollBar)
    F.ReskinScroll(_G.PetJournalListScrollFrameScrollBar)
    F.ReskinInput(_G.MountJournalSearchBox)
    F.ReskinInput(_G.PetJournalSearchBox)
    F.ReskinArrow(_G.MountJournal.MountDisplay.ModelScene.RotateLeftButton, 'left')
    F.ReskinArrow(_G.MountJournal.MountDisplay.ModelScene.RotateRightButton, 'right')
    F.ReskinFilterButton(_G.PetJournalFilterButton)
    F.ReskinFilterButton(_G.MountJournalFilterButton)

    local togglePlayer = MountJournal.MountDisplay.ModelScene.TogglePlayer
    F.ReskinCheck(togglePlayer)
    togglePlayer:SetSize(28, 28)

    F.StripTextures(MountJournal.BottomLeftInset)
    local bg = F.CreateBDFrame(MountJournal.BottomLeftInset, 0.25)
    bg:SetPoint('TOPLEFT', 3, 0)
    bg:SetPoint('BOTTOMRIGHT', -24, 2)

    _G.MountJournalFilterButton:SetPoint('TOPRIGHT', MountJournal.LeftInset, -5, -8)
    _G.PetJournalFilterButton:SetPoint('TOPRIGHT', _G.PetJournalLeftInset, -5, -8)
    _G.PetJournalTutorialButton:SetPoint('TOPLEFT', PetJournal, 'TOPLEFT', -14, 14)

    local scrollFrames = { MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons }
    for _, scrollFrame in pairs(scrollFrames) do
        for i = 1, #scrollFrame do
            local bu = scrollFrame[i]
            local icon = bu.icon

            bu:GetRegions():Hide()
            bu:SetHighlightTexture('')
            bu.iconBorder:SetTexture('')
            bu.selectedTexture:SetTexture('')

            local bg = F.CreateBDFrame(bu, 0.25)
            bg:SetPoint('TOPLEFT', 3, -1)
            bg:SetPoint('BOTTOMRIGHT', 0, 1)
            bu.bg = bg

            icon:SetSize(42, 42)
            icon.bg = F.ReskinIcon(icon)
            bu.name:SetParent(bg)

            if bu.DragButton then
                bu.DragButton.ActiveTexture:SetTexture('')
                bu.DragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                bu.DragButton:GetHighlightTexture():SetAllPoints(icon)
            else
                bu.dragButton.ActiveTexture:SetTexture('')
                bu.dragButton.levelBG:SetAlpha(0)
                bu.dragButton.level:SetFontObject(_G.GameFontNormal)
                bu.dragButton.level:SetTextColor(1, 1, 1)
                bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                bu.dragButton:GetHighlightTexture():SetAllPoints(icon)
            end
        end
    end

    local function updateMountScroll()
        local buttons = MountJournal.ListScrollFrame.buttons
        for i = 1, #buttons do
            local bu = buttons[i]
            if bu.bg then
                bu.icon:SetShown(bu.index ~= nil)

                if bu.selectedTexture:IsShown() then
                    bu.bg:SetBackdropColor(r, g, b, 0.25)
                else
                    bu.bg:SetBackdropColor(0, 0, 0, 0.25)
                end

                if bu.DragButton.ActiveTexture:IsShown() then
                    bu.icon.bg:SetBackdropBorderColor(1, 0.8, 0)
                else
                    bu.icon.bg:SetBackdropBorderColor(0, 0, 0)
                end
            end
        end
    end

    hooksecurefunc('MountJournal_UpdateMountList', updateMountScroll)
    hooksecurefunc(_G.MountJournalListScrollFrame, 'update', updateMountScroll)

    local function updatePetScroll()
        local petButtons = PetJournal.listScroll.buttons
        if petButtons then
            for i = 1, #petButtons do
                local bu = petButtons[i]

                local index = bu.index
                if index then
                    local petID, _, isOwned = C_PetJournal.GetPetInfoByIndex(index)

                    if petID and isOwned then
                        local rarity = select(5, C_PetJournal.GetPetStats(petID))
                        if rarity then
                            bu.name:SetTextColor(GetItemQualityColor(rarity - 1))
                        else
                            bu.name:SetTextColor(1, 1, 1)
                        end
                    else
                        bu.name:SetTextColor(0.5, 0.5, 0.5)
                    end

                    if bu.selectedTexture:IsShown() then
                        bu.bg:SetBackdropColor(r, g, b, 0.25)
                    else
                        bu.bg:SetBackdropColor(0, 0, 0, 0.25)
                    end

                    if bu.dragButton.ActiveTexture:IsShown() then
                        bu.icon.bg:SetBackdropBorderColor(1, 0.8, 0)
                    else
                        bu.icon.bg:SetBackdropBorderColor(0, 0, 0)
                    end
                end
            end
        end
    end

    hooksecurefunc('PetJournal_UpdatePetList', updatePetScroll)
    hooksecurefunc(_G.PetJournalListScrollFrame, 'update', updatePetScroll)

    local function reskinToolButton(button)
        local border = _G[button:GetName() .. 'Border']
        if border then
            border:Hide()
        end
        button:SetPushedTexture('')
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        F.ReskinIcon(button.texture)
    end

    reskinToolButton(_G.PetJournalHealPetButton)

    _G.PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
    _G.PetJournalLoadoutBorderSlotHeaderText:SetPoint('CENTER', _G.PetJournalLoadoutBorderTop, 'TOP', 0, 4)

    reskinToolButton(_G.PetJournalSummonRandomFavoritePetButton)

    -- Favourite mount button

    reskinToolButton(_G.MountJournalSummonRandomFavoriteButton)

    local movedButton
    MountJournal:HookScript('OnShow', function()
        if not InCombatLockdown() and not movedButton then
            _G.MountJournalSummonRandomFavoriteButton:SetPoint('TOPRIGHT', -10, -26)
            movedButton = true
        end
    end)

    -- Pet card

    local card = _G.PetJournalPetCard

    _G.PetJournalPetCardBG:Hide()
    card.PetInfo.levelBG:SetAlpha(0)
    card.PetInfo.qualityBorder:SetAlpha(0)
    card.AbilitiesBG1:SetAlpha(0)
    card.AbilitiesBG2:SetAlpha(0)
    card.AbilitiesBG3:SetAlpha(0)

    card.PetInfo.level:SetFontObject(_G.GameFontNormal)
    card.PetInfo.level:SetTextColor(1, 1, 1)

    card.PetInfo.icon.bg = F.ReskinIcon(card.PetInfo.icon)

    F.CreateBDFrame(card, 0.25)

    for i = 2, 12 do
        select(i, card.xpBar:GetRegions()):Hide()
    end

    card.xpBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    F.CreateBDFrame(card.xpBar, 0.25)

    _G.PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
    _G.PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
    _G.PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
    _G.PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

    card.HealthFrame.healthBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    F.CreateBDFrame(card.HealthFrame.healthBar, 0.25)

    for i = 1, 6 do
        local bu = card['spell' .. i]
        F.ReskinIcon(bu.icon)
    end

    hooksecurefunc('PetJournal_UpdatePetCard', function(self)
        local border = self.PetInfo.qualityBorder
        local r, g, b

        if border:IsShown() then
            r, g, b = self.PetInfo.qualityBorder:GetVertexColor()
        else
            r, g, b = 0, 0, 0
        end

        self.PetInfo.icon.bg:SetBackdropBorderColor(r, g, b)
    end)

    -- Pet loadout

    for i = 1, 3 do
        local bu = PetJournal.Loadout['Pet' .. i]

        _G['PetJournalLoadoutPet' .. i .. 'BG']:Hide()

        bu.iconBorder:SetAlpha(0)
        bu.qualityBorder:SetTexture('')
        bu.levelBG:SetAlpha(0)
        bu.helpFrame:GetRegions():Hide()
        bu.dragButton:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

        bu.level:SetFontObject(_G.GameFontNormal)
        bu.level:SetTextColor(1, 1, 1)

        bu.icon.bg = F.ReskinIcon(bu.icon)

        bu.setButton:GetRegions():SetPoint('TOPLEFT', bu.icon, -5, 5)
        bu.setButton:GetRegions():SetPoint('BOTTOMRIGHT', bu.icon, 5, -5)

        F.CreateBDFrame(bu, 0.25)

        for i = 2, 12 do
            select(i, bu.xpBar:GetRegions()):Hide()
        end

        bu.xpBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
        F.CreateBDFrame(bu.xpBar, 0.25)

        F.StripTextures(bu.healthFrame.healthBar)
        bu.healthFrame.healthBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
        F.CreateBDFrame(bu.healthFrame.healthBar, 0.25)

        for j = 1, 3 do
            local spell = bu['spell' .. j]

            spell:SetPushedTexture('')
            spell:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
            spell.selected:SetTexture(C.Assets.Button.Checked)
            spell:GetRegions():Hide()

            local flyoutArrow = spell.FlyoutArrow
            F.SetupArrow(flyoutArrow, 'down')
            flyoutArrow:SetSize(14, 14)
            flyoutArrow:SetTexCoord(0, 1, 0, 1)

            F.ReskinIcon(spell.icon)
        end
    end

    hooksecurefunc('PetJournal_UpdatePetLoadOut', function()
        for i = 1, 3 do
            local bu = PetJournal.Loadout['Pet' .. i]

            bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
            bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

            bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
        end
    end)

    PetJournal.SpellSelect.BgEnd:Hide()
    PetJournal.SpellSelect.BgTiled:Hide()

    for i = 1, 2 do
        local bu = PetJournal.SpellSelect['Spell' .. i]

        bu:SetCheckedTexture(C.Assets.Button.Checked)
        bu:SetPushedTexture('')
        bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

        F.ReskinIcon(bu.icon)
    end

    -- [[ Toy box ]]

    local ToyBox = _G.ToyBox
    local iconsFrame = ToyBox.iconsFrame

    F.StripTextures(iconsFrame)
    F.ReskinInput(ToyBox.searchBox)
    F.ReskinFilterButton(_G.ToyBoxFilterButton)
    F.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, 'left')
    F.ReskinArrow(ToyBox.PagingFrame.NextPageButton, 'right')

    -- Progress bar

    local progressBar = ToyBox.progressBar
    progressBar.border:Hide()
    progressBar:DisableDrawLayer('BACKGROUND')

    progressBar.text:SetPoint('CENTER', 0, 1)
    progressBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)

    F.CreateBDFrame(progressBar, 0.25)

    -- Toys!

    local function changeTextColor(text)
        if text.isSetting then
            return
        end
        text.isSetting = true

        local bu = text:GetParent()
        local itemID = bu.itemID

        if PlayerHasToy(itemID) then
            local quality = select(3, GetItemInfo(itemID))
            if quality then
                text:SetTextColor(GetItemQualityColor(quality))
            else
                text:SetTextColor(1, 1, 1)
            end
        else
            text:SetTextColor(0.5, 0.5, 0.5)
        end

        text.isSetting = nil
    end

    local buttons = ToyBox.iconsFrame
    for i = 1, 18 do
        local bu = buttons['spellButton' .. i]
        local ic = bu.iconTexture

        bu:SetPushedTexture('')
        bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        bu:GetHighlightTexture():SetAllPoints(ic)
        bu.cooldown:SetAllPoints(ic)
        bu.slotFrameCollected:SetTexture('')
        bu.slotFrameUncollected:SetTexture('')
        F.ReskinIcon(ic)

        hooksecurefunc(bu.name, 'SetTextColor', changeTextColor)
    end

    -- [[ Heirlooms ]]

    local HeirloomsJournal = _G.HeirloomsJournal
    local icons = HeirloomsJournal.iconsFrame

    F.StripTextures(icons)
    F.ReskinInput(_G.HeirloomsJournalSearchBox)
    F.ReskinDropDown(_G.HeirloomsJournalClassDropDown)
    F.ReskinFilterButton(HeirloomsJournal.FilterButton)
    F.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, 'left')
    F.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, 'right')

    hooksecurefunc(HeirloomsJournal, 'UpdateButton', function(_, button)
        button.level:SetFontObject('GameFontWhiteSmall')
        button.special:SetTextColor(1, 0.8, 0)
    end)

    -- Progress bar

    local progressBar = HeirloomsJournal.progressBar
    progressBar.border:Hide()
    progressBar:DisableDrawLayer('BACKGROUND')

    progressBar.text:SetPoint('CENTER', 0, 1)
    progressBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)

    F.CreateBDFrame(progressBar, 0.25)

    -- Buttons

    hooksecurefunc('HeirloomsJournal_UpdateButton', function(button)
        if not button.styled then
            local ic = button.iconTexture

            button.slotFrameCollected:SetTexture('')
            button.slotFrameUncollected:SetTexture('')
            button.levelBackground:SetAlpha(0)
            button:SetPushedTexture('')
            button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
            button:GetHighlightTexture():SetAllPoints(ic)

            button.iconTextureUncollected:SetTexCoord(unpack(C.TEX_COORD))
            button.bg = F.ReskinIcon(ic)

            button.level:ClearAllPoints()
            button.level:SetPoint('BOTTOM', 0, 1)

            local newLevelBg = button:CreateTexture(nil, 'OVERLAY')
            newLevelBg:SetColorTexture(0, 0, 0, 0.5)
            newLevelBg:SetPoint('BOTTOMLEFT', button, 'BOTTOMLEFT', 4, 5)
            newLevelBg:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -4, 5)
            newLevelBg:SetHeight(11)
            button.newLevelBg = newLevelBg

            button.styled = true
        end

        if button.iconTexture:IsShown() then
            button.name:SetTextColor(1, 1, 1)
            button.bg:SetBackdropBorderColor(0, 0.8, 1)
            button.newLevelBg:Show()
        else
            button.name:SetTextColor(0.5, 0.5, 0.5)
            button.bg:SetBackdropBorderColor(0, 0, 0)
            button.newLevelBg:Hide()
        end
    end)

    hooksecurefunc(HeirloomsJournal, 'LayoutCurrentPage', function()
        for i = 1, #HeirloomsJournal.heirloomHeaderFrames do
            local header = HeirloomsJournal.heirloomHeaderFrames[i]
            if not header.styled then
                header.text:SetTextColor(1, 1, 1)
                header.text:SetFont(C.Assets.Font.Bold, 16, 'OUTLINE')

                header.styled = true
            end
        end

        for i = 1, #HeirloomsJournal.heirloomEntryFrames do
            local button = HeirloomsJournal.heirloomEntryFrames[i]

            if button.iconTexture:IsShown() then
                button.name:SetTextColor(1, 1, 1)
                if button.bg then
                    button.bg:SetBackdropBorderColor(0, 0.8, 1)
                end
                if button.newLevelBg then
                    button.newLevelBg:Show()
                end
            else
                button.name:SetTextColor(0.5, 0.5, 0.5)
                if button.bg then
                    button.bg:SetBackdropBorderColor(0, 0, 0)
                end
                if button.newLevelBg then
                    button.newLevelBg:Hide()
                end
            end
        end
    end)

    -- [[ WardrobeCollectionFrame ]]

    local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
    local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame

    F.StripTextures(ItemsCollectionFrame)
    F.ReskinFilterButton(WardrobeCollectionFrame.FilterButton)
    F.ReskinDropDown(_G.WardrobeCollectionFrameWeaponDropDown)
    F.ReskinInput(_G.WardrobeCollectionFrameSearchBox)

    for index = 1, 2 do
        local tab = _G['WardrobeCollectionFrameTab' .. index]
        for i = 1, 6 do
            select(i, tab:GetRegions()):SetAlpha(0)
        end
        tab:SetHighlightTexture('')
        tab.bg = F.CreateBDFrame(tab, 0.25)
        tab.bg:SetPoint('TOPLEFT', 3, -3)
        tab.bg:SetPoint('BOTTOMRIGHT', -3, -1)
    end

    hooksecurefunc('WardrobeCollectionFrame_SetTab', function(tabID)
        for index = 1, 2 do
            local tab = _G['WardrobeCollectionFrameTab' .. index]
            if tabID == index then
                tab.bg:SetBackdropColor(r, g, b, 0.2)
            else
                tab.bg:SetBackdropColor(0, 0, 0, 0.2)
            end
        end
    end)

    F.ReskinArrow(ItemsCollectionFrame.PagingFrame.PrevPageButton, 'left')
    F.ReskinArrow(ItemsCollectionFrame.PagingFrame.NextPageButton, 'right')
    ItemsCollectionFrame.BGCornerTopLeft:SetAlpha(0)
    ItemsCollectionFrame.BGCornerTopRight:SetAlpha(0)

    local progressBar = WardrobeCollectionFrame.progressBar
    progressBar:DisableDrawLayer('BACKGROUND')
    select(2, progressBar:GetRegions()):Hide()
    progressBar.text:SetPoint('CENTER', 0, 1)
    progressBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    F.CreateBDFrame(progressBar, 0.25)

    -- ItemSetsCollection

    local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
    SetsCollectionFrame.LeftInset:Hide()
    SetsCollectionFrame.RightInset:Hide()
    F.CreateBDFrame(SetsCollectionFrame.Model, 0.25)

    local ScrollFrame = SetsCollectionFrame.ScrollFrame
    F.ReskinScroll(ScrollFrame.scrollBar)
    for i = 1, #ScrollFrame.buttons do
        local bu = ScrollFrame.buttons[i]
        bu.Background:Hide()
        bu.HighlightTexture:SetTexture('')
        bu.Icon:SetSize(42, 42)
        F.ReskinIcon(bu.Icon)
        bu.IconCover:SetOutside(bu.Icon)

        bu.SelectedTexture:SetDrawLayer('BACKGROUND')
        bu.SelectedTexture:SetColorTexture(r, g, b, 0.25)
        bu.SelectedTexture:ClearAllPoints()
        bu.SelectedTexture:SetPoint('TOPLEFT', 4, -2)
        bu.SelectedTexture:SetPoint('BOTTOMRIGHT', -1, 2)
        F.CreateBDFrame(bu.SelectedTexture, 0.25)
    end

    local DetailsFrame = SetsCollectionFrame.DetailsFrame
    DetailsFrame.ModelFadeTexture:Hide()
    DetailsFrame.IconRowBackground:Hide()
    F.ReskinFilterButton(DetailsFrame.VariantSetsButton, 'Down')

    hooksecurefunc(SetsCollectionFrame, 'SetItemFrameQuality', function(_, itemFrame)
        local ic = itemFrame.Icon
        if not ic.bg then
            ic.bg = F.ReskinIcon(ic)
        end
        itemFrame.IconBorder:SetTexture('')

        if itemFrame.collected then
            local quality = C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
            local color = C.QualityColors[quality or 1]
            ic.bg:SetBackdropBorderColor(color.r, color.g, color.b)
        else
            ic.bg:SetBackdropBorderColor(0, 0, 0)
        end
    end)

    local SetsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame
    F.StripTextures(SetsTransmogFrame)
    F.ReskinArrow(SetsTransmogFrame.PagingFrame.PrevPageButton, 'left')
    F.ReskinArrow(SetsTransmogFrame.PagingFrame.NextPageButton, 'right')

    -- [[ Wardrobe ]]

    local WardrobeFrame = _G.WardrobeFrame
    local WardrobeTransmogFrame = _G.WardrobeTransmogFrame

    F.StripTextures(WardrobeTransmogFrame)
    F.ReskinPortraitFrame(WardrobeFrame)
    F.Reskin(WardrobeTransmogFrame.ApplyButton)
    F.StripTextures(WardrobeTransmogFrame.SpecButton)
    F.ReskinArrow(WardrobeTransmogFrame.SpecButton, 'down')
    WardrobeTransmogFrame.SpecButton:SetPoint('RIGHT', WardrobeTransmogFrame.ApplyButton, 'LEFT', -3, 0)
    F.ReskinCheck(WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox)

    local modelScene = WardrobeTransmogFrame.ModelScene
    modelScene.ClearAllPendingButton:DisableDrawLayer('BACKGROUND')

    local slots = {
        'Head',
        'Shoulder',
        'Chest',
        'Waist',
        'Legs',
        'Feet',
        'Wrist',
        'Hands',
        'Back',
        'Shirt',
        'Tabard',
        'MainHand',
        'SecondaryHand',
    }
    for i = 1, #slots do
        local slot = modelScene[slots[i] .. 'Button']
        if slot then
            slot.Border:Hide()
            F.ReskinIcon(slot.Icon)
            slot:SetHighlightTexture(C.Assets.Texture.Backdrop)
            local hl = slot:GetHighlightTexture()
            hl:SetVertexColor(1, 1, 1, 0.25)
            hl:SetAllPoints(slot.Icon)
        end
    end

    -- Outfit Frame
    F.Reskin(_G.WardrobeOutfitDropDown.SaveButton)
    F.ReskinDropDown(_G.WardrobeOutfitDropDown)
    _G.WardrobeOutfitDropDown:SetHeight(32)
    _G.WardrobeOutfitDropDown.SaveButton:SetPoint('LEFT', _G.WardrobeOutfitDropDown, 'RIGHT', -13, 2)

    -- HPetBattleAny
    local reskinHPet
    _G.CollectionsJournal:HookScript('OnShow', function()
        if not IsAddOnLoaded('HPetBattleAny') then
            return
        end
        if not reskinHPet then
            if _G.HPetInitOpenButton then
                F.Reskin(_G.HPetInitOpenButton)
            end
            if _G.HPetAllInfoButton then
                F.StripTextures(_G.HPetAllInfoButton)
                F.Reskin(_G.HPetAllInfoButton)
            end

            if _G.PetJournalBandageButton then
                _G.PetJournalBandageButton:SetPushedTexture('')
                _G.PetJournalBandageButton:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                _G.PetJournalBandageButtonBorder:Hide()
                _G.PetJournalBandageButton:SetPoint('TOPRIGHT', _G.PetJournalHealPetButton, 'TOPLEFT', -3, 0)
                _G.PetJournalBandageButton:SetPoint('BOTTOMLEFT', _G.PetJournalHealPetButton, 'BOTTOMLEFT', -35, 0)
                F.ReskinIcon(_G.PetJournalBandageButtonIcon)
            end
            reskinHPet = true
        end
    end)
end
