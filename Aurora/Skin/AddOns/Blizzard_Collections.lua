local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_Collections()
    local r, g, b = C.r, C.g, C.b

    --[[ AddOns\Blizzard_Collections\Blizzard_PetCollection ]]
    if not private.disabled.tooltips then
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetJournalPrimaryAbilityTooltip)
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.PetJournalSecondaryAbilityTooltip)
    end

    -- [[ General ]]

    for i = 1, 14 do
        if i ~= 8 then
            select(i, _G.CollectionsJournal:GetRegions()):Hide()
        end
    end

    F.CreateBD(_G.CollectionsJournal)
    F.CreateSD(_G.CollectionsJournal)
    F.ReskinTab(_G.CollectionsJournalTab1)
    F.ReskinTab(_G.CollectionsJournalTab2)
    F.ReskinTab(_G.CollectionsJournalTab3)
    F.ReskinTab(_G.CollectionsJournalTab4)
    F.ReskinTab(_G.CollectionsJournalTab5)
    F.ReskinClose(_G.CollectionsJournalCloseButton)

    _G.CollectionsJournalTab2:SetPoint("LEFT", _G.CollectionsJournalTab1, "RIGHT", -15, 0)
    _G.CollectionsJournalTab3:SetPoint("LEFT", _G.CollectionsJournalTab2, "RIGHT", -15, 0)
    _G.CollectionsJournalTab4:SetPoint("LEFT", _G.CollectionsJournalTab3, "RIGHT", -15, 0)
    _G.CollectionsJournalTab5:SetPoint("LEFT", _G.CollectionsJournalTab4, "RIGHT", -15, 0)

    -- [[ Mounts and pets ]]

    local PetJournal = _G.PetJournal
    local MountJournal = _G.MountJournal

    for i = 1, 9 do
        select(i, MountJournal.MountCount:GetRegions()):Hide()
        select(i, PetJournal.PetCount:GetRegions()):Hide()
    end

    MountJournal.LeftInset:Hide()
    MountJournal.RightInset:Hide()
    PetJournal.LeftInset:Hide()
    PetJournal.RightInset:Hide()
    PetJournal.PetCardInset:Hide()
    PetJournal.loadoutBorder:Hide()
    MountJournal.MountDisplay.YesMountsTex:SetAlpha(0)
    MountJournal.MountDisplay.NoMountsTex:SetAlpha(0)
    MountJournal.MountDisplay.ShadowOverlay:Hide()
    _G.PetJournalTutorialButton.Ring:Hide()

    F.CreateBD(MountJournal.MountCount, .25)
    F.CreateBD(PetJournal.PetCount, .25)
    F.CreateBD(MountJournal.MountDisplay.ModelScene, .25)

    F.Reskin(_G.MountJournalMountButton)
    F.Reskin(_G.PetJournalSummonButton)
    F.Reskin(_G.PetJournalFindBattle)
    F.ReskinScroll(_G.MountJournalListScrollFrameScrollBar)
    F.ReskinScroll(_G.PetJournalListScrollFrameScrollBar)
    F.ReskinInput(_G.MountJournalSearchBox)
    F.ReskinInput(_G.PetJournalSearchBox)
    F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateLeftButton, "Left")
    F.ReskinArrow(MountJournal.MountDisplay.ModelScene.RotateRightButton, "Right")
    F.ReskinFilterButton(_G.PetJournalFilterButton)
    F.ReskinFilterButton(_G.MountJournalFilterButton)

    _G.MountJournalFilterButton:SetPoint("TOPRIGHT", MountJournal.LeftInset, -5, -8)
    _G.PetJournalFilterButton:SetPoint("TOPRIGHT", _G.PetJournalLeftInset, -5, -8)

    _G.PetJournalTutorialButton:SetPoint("TOPLEFT", PetJournal, "TOPLEFT", -14, 14)

    local scrollFrames = {MountJournal.ListScrollFrame.buttons, PetJournal.listScroll.buttons}
    for _, scrollFrame in pairs(scrollFrames) do
        for i = 1, #scrollFrame do
            local button = scrollFrame[i]

            button:GetRegions():Hide()
            local bg = CreateFrame("Frame", nil, button)
            bg:SetPoint("TOPLEFT", 0, -1)
            bg:SetPoint("BOTTOMRIGHT", 0, 1)
            bg:SetFrameLevel(button:GetFrameLevel()-1)
            F.CreateBD(bg, .25)
            button.bg = bg

            button.icon.bg = F.ReskinIcon(button.icon)

            button.iconBorder:SetTexture("")
            button.selectedTexture:SetTexture("")
            button:SetHighlightTexture(C.media.backdrop)
            button:GetHighlightTexture():SetVertexColor(r, g, b, .25)

            if button.DragButton then
                button.DragButton.ActiveTexture:SetTexture(C.media.checked)
            else
                button.dragButton.ActiveTexture:SetTexture(C.media.checked)
                button.dragButton.levelBG:SetAlpha(0)
                button.dragButton.level:SetFontObject(_G.GameFontNormal)
                button.dragButton.level:SetTextColor(1, 1, 1)
            end
        end
    end

    local function updateMountScroll()
        local buttons = MountJournal.ListScrollFrame.buttons
        for i = 1, #buttons do
            local button = buttons[i]
            if button.index ~= nil then
                button.bg:Show()
                button.icon:Show()
                button.icon.bg:Show()

                if button.selectedTexture:IsShown() then
                    button.bg:SetBackdropBorderColor(1, 1, 1, 0.7)
                else
                    button.bg:SetBackdropBorderColor(0, 0, 0)
                end
            else
                button.bg:Hide()
                button.icon:Hide()
                button.icon.bg:Hide()
            end
        end
    end

    hooksecurefunc("MountJournal_UpdateMountList", updateMountScroll)
    hooksecurefunc(_G.MountJournalListScrollFrame, "update", updateMountScroll)

    local function updatePetScroll()
        local petButtons = PetJournal.listScroll.buttons
        if petButtons then
            for i = 1, #petButtons do
                local button = petButtons[i]

                local index = button.index
                if index then
                    local petID, _, isOwned = _G.C_PetJournal.GetPetInfoByIndex(index)

                    if petID and isOwned then
                        local _, _, _, _, rarity = _G.C_PetJournal.GetPetStats(petID)

                        if rarity then
                            local color = _G.ITEM_QUALITY_COLORS[rarity-1]
                            button.name:SetTextColor(color.r, color.g, color.b)
                        else
                            button.name:SetTextColor(1, 1, 1)
                        end
                    else
                        button.name:SetTextColor(.5, .5, .5)
                    end

                    if button.selectedTexture:IsShown() then
                        button.bg:SetBackdropBorderColor(1, 1, 1, 0.7)
                    else
                        button.bg:SetBackdropBorderColor(0, 0, 0)
                    end
                end
            end
        end
    end

    hooksecurefunc("PetJournal_UpdatePetList", updatePetScroll)
    hooksecurefunc(_G.PetJournalListScrollFrame, "update", updatePetScroll)

    _G.PetJournalHealPetButtonBorder:Hide()
    _G.PetJournalHealPetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
    PetJournal.HealPetButton:SetPushedTexture("")
    F.CreateBG(PetJournal.HealPetButton)

    do
        local ic = MountJournal.MountDisplay.InfoButton.Icon
        ic:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(ic)
    end

    _G.PetJournalLoadoutBorderSlotHeaderText:SetParent(PetJournal)
    _G.PetJournalLoadoutBorderSlotHeaderText:SetPoint("CENTER", _G.PetJournalLoadoutBorderTop, "TOP", 0, 4)

    _G.PetJournalSummonRandomFavoritePetButtonBorder:Hide()
    _G.PetJournalSummonRandomFavoritePetButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
    _G.PetJournalSummonRandomFavoritePetButton:SetPushedTexture("")
    F.CreateBG(_G.PetJournalSummonRandomFavoritePetButton)

    -- Favourite mount button

    _G.MountJournalSummonRandomFavoriteButtonBorder:Hide()
    _G.MountJournalSummonRandomFavoriteButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
    _G.MountJournalSummonRandomFavoriteButton:SetPushedTexture("")
    F.CreateBG(_G.MountJournalSummonRandomFavoriteButton)

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

    card.PetInfo.icon:SetTexCoord(.08, .92, .08, .92)
    card.PetInfo.icon.bg = F.CreateBG(card.PetInfo.icon)

    F.CreateBD(card, .25)

    for i = 2, 12 do
        select(i, card.xpBar:GetRegions()):Hide()
    end

    card.xpBar:SetStatusBarTexture(C.media.backdrop)
    F.CreateBDFrame(card.xpBar, .25)

    _G.PetJournalPetCardHealthFramehealthStatusBarLeft:Hide()
    _G.PetJournalPetCardHealthFramehealthStatusBarRight:Hide()
    _G.PetJournalPetCardHealthFramehealthStatusBarMiddle:Hide()
    _G.PetJournalPetCardHealthFramehealthStatusBarBGMiddle:Hide()

    card.HealthFrame.healthBar:SetStatusBarTexture(C.media.backdrop)
    F.CreateBDFrame(card.HealthFrame.healthBar, .25)

    for i = 1, 6 do
        local bu = card["spell"..i]

        bu.icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(bu.icon)
    end

    hooksecurefunc("PetJournal_UpdatePetCard", function(self)
        local petInfo = self.PetInfo
        local red, green, blue

        if petInfo.qualityBorder:IsShown() then
            red, green, blue = petInfo.qualityBorder:GetVertexColor()
        else
            red, green, blue = 0, 0, 0
        end

        petInfo.icon.bg:SetVertexColor(red, green, blue)
    end)

    -- Pet loadout

    for i = 1, 3 do
        local bu = PetJournal.Loadout["Pet"..i]

        _G["PetJournalLoadoutPet"..i.."BG"]:Hide()

        bu.iconBorder:SetAlpha(0)
        bu.qualityBorder:SetTexture("")
        bu.levelBG:SetAlpha(0)
        bu.helpFrame:GetRegions():Hide()

        bu.level:SetFontObject(_G.GameFontNormal)
        bu.level:SetTextColor(1, 1, 1)

        bu.icon:SetTexCoord(.08, .92, .08, .92)
        bu.icon.bg = F.CreateBDFrame(bu.icon, .25)

        bu.setButton:GetRegions():SetPoint("TOPLEFT", bu.icon, -5, 5)
        bu.setButton:GetRegions():SetPoint("BOTTOMRIGHT", bu.icon, 5, -5)

        F.CreateBD(bu, .25)

        for j = 2, 12 do
            select(j, bu.xpBar:GetRegions()):Hide()
        end

        bu.xpBar:SetStatusBarTexture(C.media.backdrop)
        F.CreateBDFrame(bu.xpBar, .25)

        _G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarLeft"]:Hide()
        _G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarRight"]:Hide()
        _G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarMiddle"]:Hide()
        _G["PetJournalLoadoutPet"..i.."HealthFramehealthStatusBarBGMiddle"]:Hide()

        bu.healthFrame.healthBar:SetStatusBarTexture(C.media.backdrop)
        F.CreateBDFrame(bu.healthFrame.healthBar, .25)

        for j = 1, 3 do
            local spell = bu["spell"..j]

            spell:SetPushedTexture("")

            spell.selected:SetTexture(C.media.checked)

            spell:GetRegions():Hide()

            spell.FlyoutArrow:SetTexture(C.media.arrowDown)
            spell.FlyoutArrow:SetSize(8, 8)
            spell.FlyoutArrow:SetTexCoord(0, 1, 0, 1)

            spell.icon:SetTexCoord(.08, .92, .08, .92)
            F.CreateBG(spell.icon)
        end
    end

    hooksecurefunc("PetJournal_UpdatePetLoadOut", function()
        for i = 1, 3 do
            local bu = PetJournal.Loadout["Pet"..i]

            bu.icon.bg:SetShown(not bu.helpFrame:IsShown())
            bu.icon.bg:SetBackdropBorderColor(bu.qualityBorder:GetVertexColor())

            bu.dragButton:SetEnabled(not bu.helpFrame:IsShown())
        end
    end)

    PetJournal.SpellSelect.BgEnd:Hide()
    PetJournal.SpellSelect.BgTiled:Hide()

    for i = 1, 2 do
        local bu = PetJournal.SpellSelect["Spell"..i]

        bu:SetCheckedTexture(C.media.checked)
        bu:SetPushedTexture("")

        bu.icon:SetDrawLayer("ARTWORK")
        bu.icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(bu.icon)
    end

    -- [[ Toy box ]]

    local ToyBox = _G.ToyBox

    local toyIcons = ToyBox.iconsFrame
    toyIcons.Bg:Hide()
    toyIcons.BackgroundTile:Hide()
    toyIcons:DisableDrawLayer("BORDER")
    toyIcons:DisableDrawLayer("ARTWORK")
    toyIcons:DisableDrawLayer("OVERLAY")

    F.ReskinInput(ToyBox.searchBox)
    F.ReskinFilterButton(_G.ToyBoxFilterButton)
    F.ReskinArrow(ToyBox.PagingFrame.PrevPageButton, "Left")
    F.ReskinArrow(ToyBox.PagingFrame.NextPageButton, "Right")

    -- Progress bar

    local toyProgress = ToyBox.progressBar
    toyProgress.border:Hide()
    toyProgress:DisableDrawLayer("BACKGROUND")

    toyProgress.text:SetPoint("CENTER", 0, 1)
    toyProgress:SetStatusBarTexture(C.media.backdrop)

    F.CreateBDFrame(toyProgress, .25)

    -- Toys!

    local shouldChangeTextColor = true
    local function changeTextColor(toyString)
        if shouldChangeTextColor then
            shouldChangeTextColor = false

            local self = toyString:GetParent()

            if _G.PlayerHasToy(self.itemID) then
                local _, _, quality = _G.GetItemInfo(self.itemID)
                if quality then
                    toyString:SetTextColor(_G.GetItemQualityColor(quality))
                else
                    toyString:SetTextColor(1, 1, 1)
                end
            else
                toyString:SetTextColor(.5, .5, .5)
            end

            shouldChangeTextColor = true
        end
    end

    local iconsFrame = ToyBox.iconsFrame
    for i = 1, 18 do
        local button = iconsFrame["spellButton"..i]
        button:SetPushedTexture("")
        button:SetHighlightTexture("")

        button.bg = F.CreateBG(button)
        button.bg:SetPoint("TOPLEFT", button, 3, -2)
        button.bg:SetPoint("BOTTOMRIGHT", button, -3, 4)

        button.iconTexture:SetTexCoord(.08, .92, .08, .92)

        button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
        button.iconTextureUncollected:SetPoint("CENTER", 0, 1)
        button.iconTextureUncollected:SetHeight(42)

        button.slotFrameCollected:SetTexture("")
        button.slotFrameUncollected:SetTexture("")

        --button.cooldown:SetAllPoints(icon)

        hooksecurefunc(button.name, "SetTextColor", changeTextColor)
    end

    -- [[ Heirlooms ]]

    local HeirloomsJournal = _G.HeirloomsJournal

    local heirloomIcons = HeirloomsJournal.iconsFrame
    heirloomIcons.Bg:Hide()
    heirloomIcons.BackgroundTile:Hide()
    heirloomIcons:DisableDrawLayer("BORDER")
    heirloomIcons:DisableDrawLayer("ARTWORK")
    heirloomIcons:DisableDrawLayer("OVERLAY")

    F.ReskinInput(_G.HeirloomsJournalSearchBox)
    F.ReskinDropDown(_G.HeirloomsJournalClassDropDown)
    F.ReskinFilterButton(_G.HeirloomsJournalFilterButton)
    F.ReskinArrow(HeirloomsJournal.PagingFrame.PrevPageButton, "Left")
    F.ReskinArrow(HeirloomsJournal.PagingFrame.NextPageButton, "Right")

    -- Progress bar

    local heirloomProgress = HeirloomsJournal.progressBar
    heirloomProgress.border:Hide()
    heirloomProgress:DisableDrawLayer("BACKGROUND")

    heirloomProgress.text:SetPoint("CENTER", 0, 1)
    heirloomProgress:SetStatusBarTexture(C.media.backdrop)

    F.CreateBDFrame(heirloomProgress, .25)

    -- Buttons

    local heirloomColor = _G.BAG_ITEM_QUALITY_COLORS[_G.LE_ITEM_QUALITY_HEIRLOOM]
    hooksecurefunc(HeirloomsJournal, "UpdateButton", function(self, button)
        if not button.styled then
            button:SetPushedTexture("")
            button:SetHighlightTexture("")

            button.bg = F.CreateBG(button)
            button.bg:SetPoint("TOPLEFT", button, 3, -2)
            button.bg:SetPoint("BOTTOMRIGHT", button, -3, 4)

            button.iconTexture:SetTexCoord(.08, .92, .08, .92)

            button.iconTextureUncollected:SetTexCoord(.08, .92, .08, .92)
            button.iconTextureUncollected:SetPoint("CENTER", 0, 1)
            button.iconTextureUncollected:SetHeight(42)

            button.slotFrameCollected:SetTexture("")
            button.slotFrameUncollected:SetTexture("")

            button.levelBackground:SetAlpha(0)

            button.level:ClearAllPoints()
            button.level:SetPoint("BOTTOM", 0, 1)

            local auroraLevelBG = button:CreateTexture(nil, "OVERLAY")
            auroraLevelBG:SetColorTexture(0, 0, 0, .5)
            auroraLevelBG:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 5)
            auroraLevelBG:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -4, 5)
            auroraLevelBG:SetHeight(11)
            button.auroraLevelBG = auroraLevelBG

            button.styled = true
        end

        if button.iconTexture:IsShown() then
            button.name:SetTextColor(1, 1, 1)
            button.bg:SetVertexColor(heirloomColor.r, heirloomColor.g, heirloomColor.b)
            button.auroraLevelBG:Show()
            if button.levelBackground:GetAtlas() == "collections-levelplate-gold" then
                button.auroraLevelBG:SetColorTexture(1, 1, 1, .5)
            else
                button.auroraLevelBG:SetColorTexture(0, 0, 0, .5)
            end
        else
            button.name:SetTextColor(.5, .5, .5)
            button.bg:SetVertexColor(0, 0, 0)
            button.auroraLevelBG:Hide()
        end
    end)

    -- hooksecurefunc(HeirloomsJournal, "LayoutCurrentPage", function(self)
    --     for i = 1, #self.heirloomHeaderFrames do
    --         local header = self.heirloomHeaderFrames[i]
    --         if not header.styled then
    --             header.text:SetTextColor(1, 1, 1)
    --             header.text:SetFont(C.media.font, 16)

    --             header.styled = true
    --         end
    --     end
    -- end)

    -- [[ WardrobeCollection ]]

    local WardrobeCollectionFrame = _G.WardrobeCollectionFrame
    F.ReskinTab("WardrobeCollectionFrameTab", 2)

    _G.WardrobeCollectionFrameBg:Hide()
    F.ReskinInput(WardrobeCollectionFrame.searchBox)
    F.ReskinFilterButton(WardrobeCollectionFrame.FilterButton)

    -- Progress bar
    local progressBar = WardrobeCollectionFrame.progressBar
    progressBar.border:Hide()
    progressBar:DisableDrawLayer("BACKGROUND")

    progressBar.text:SetPoint("CENTER", 0, 1)
    progressBar:SetStatusBarTexture(C.media.backdrop)

    F.CreateBDFrame(progressBar, .25)

    -- Items
    local ItemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame
    ItemsCollectionFrame:DisableDrawLayer("BACKGROUND")
    ItemsCollectionFrame:DisableDrawLayer("BORDER")
    ItemsCollectionFrame:DisableDrawLayer("ARTWORK")
    ItemsCollectionFrame:DisableDrawLayer("OVERLAY")

    F.ReskinDropDown(ItemsCollectionFrame.WeaponDropDown)
    F.ReskinArrow(ItemsCollectionFrame.PagingFrame.PrevPageButton, "Left")
    F.ReskinArrow(ItemsCollectionFrame.PagingFrame.NextPageButton, "Right")

    local Models = ItemsCollectionFrame.Models
    for i = 1, #Models do
        local model = Models[i]
        local bg, _, _, _, _, highlight = model:GetRegions()
        bg:Hide()
        model.Border:Hide()
        model.bg = F.CreateBDFrame(model)
        model.bg:SetPoint("BOTTOMRIGHT", 2, -2)
        highlight:SetTexCoord(.03, .97, .03, .97)
        highlight:SetPoint("TOPLEFT", 0, 0)
        highlight:SetPoint("BOTTOMRIGHT", 1, -1)
    end

    local lightValues = {
        enabled=true, omni=false,
        dirX=-1, dirY=1, dirZ=-1,
        ambIntensity=1.05, ambR=1, ambG=1, ambB=1,
        dirIntensity=0, dirR=1, dirG=1, dirB=1
    }
    local notCollected = {
        ambIntensity=1, ambR=0.4, ambG=0.4, ambB=0.4,
        dirIntensity=0.5, dirR=0.5, dirG=0.5, dirB=0.5
    }
    local notUsable = {
        ambIntensity=1, ambR=0.8, ambG=0.4, ambB=0.4,
        dirIntensity=0.5, dirR=1, dirG=0, dirB=0
    }
    local function UpdateItems(self)
        for i = 1, self.PAGE_SIZE do
            local model = self.Models[i]
            local visualInfo = model.visualInfo
            if visualInfo then
                local borderColor
                if model.TransmogStateTexture:IsShown() then
                    local xmogState = model.TransmogStateTexture:GetAtlas()
                    if xmogState:find("transmogged") then
                        borderColor = {1, 0.5, 1}
                    elseif xmogState:find("current") then
                        borderColor = {1, 1, 0}
                    elseif xmogState:find("selected") then
                        borderColor = {1, 0.5, 1}
                    end
                    model.TransmogStateTexture:Hide()

                    self.PendingTransmogFrame:SetPoint("TOPLEFT", model, 2, -3)
                    self.PendingTransmogFrame:SetPoint("BOTTOMRIGHT", model, -1, 2)
                    self.PendingTransmogFrame.TransmogSelectedAnim2:Stop()
                end

                if borderColor then
                    model.bg:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3])
                else
                    model.bg:SetBackdropBorderColor(0, 0, 0)
                end

                if ( not visualInfo.isCollected ) then
                    model:SetLight(lightValues.enabled, lightValues.omni,
                        lightValues.dirX, lightValues.dirY, lightValues.dirZ,
                        notCollected.ambIntensity, notCollected.ambR, notCollected.ambG, notCollected.ambB,
                        notCollected.dirIntensity, notCollected.dirR, notCollected.dirG, notCollected.dirB)
                elseif ( not visualInfo.isUsable ) then
                    model:SetLight(lightValues.enabled, lightValues.omni,
                        lightValues.dirX, lightValues.dirY, lightValues.dirZ,
                        notUsable.ambIntensity, notUsable.ambR, notUsable.ambG, notUsable.ambB,
                        notUsable.dirIntensity, notUsable.dirR, notUsable.dirG, notUsable.dirB)
                else
                    model:SetLight(lightValues.enabled, lightValues.omni,
                        lightValues.dirX, lightValues.dirY, lightValues.dirZ,
                        lightValues.ambIntensity, lightValues.ambR, lightValues.ambG, lightValues.ambB,
                        lightValues.dirIntensity, lightValues.dirR, lightValues.dirG, lightValues.dirB)
                end
            end
        end
    end
    hooksecurefunc(ItemsCollectionFrame, "UpdateItems", UpdateItems)

    -- Sets
    local SetsCollectionFrame = WardrobeCollectionFrame.SetsCollectionFrame
    SetsCollectionFrame.LeftInset:DisableDrawLayer("BACKGROUND")
    SetsCollectionFrame.LeftInset:DisableDrawLayer("BORDER")
    SetsCollectionFrame.RightInset:DisableDrawLayer("BACKGROUND")
    SetsCollectionFrame.RightInset:DisableDrawLayer("BORDER")
    SetsCollectionFrame.RightInset:DisableDrawLayer("ARTWORK")
    SetsCollectionFrame.RightInset:DisableDrawLayer("OVERLAY")

    local ScrollFrame = SetsCollectionFrame.ScrollFrame
    F.ReskinScroll(ScrollFrame.scrollBar)
    for i = 1, #ScrollFrame.buttons do
        local button = ScrollFrame.buttons[i]

        button.Background:Hide()
        local bg = CreateFrame("Frame", nil, button)
        bg:SetPoint("TOPLEFT", 0, -1)
        bg:SetPoint("BOTTOMRIGHT", 0, 1)
        bg:SetFrameLevel(button:GetFrameLevel()-1)
        F.CreateBD(bg, .25)
        button.bg = bg

        button.Icon.bg = F.ReskinIcon(button.Icon)

        button.SelectedTexture:SetTexture("")
        button.HighlightTexture:SetTexture(C.media.backdrop)
        button.HighlightTexture:SetVertexColor(r, g, b, .25)
    end

    hooksecurefunc(ScrollFrame, "Update", function(self)
        local buttons = self.buttons

        for i = 1, #buttons do
            local button = buttons[i]
            if button.SelectedTexture:IsShown() then
                button.bg:SetBackdropBorderColor(1, 1, 1, 0.7)
            else
                button.bg:SetBackdropBorderColor(0, 0, 0)
            end

            if button.IconCover:IsShown() then
                button.Icon.bg:SetBackdropBorderColor(0, 0, 0, 0.7)
            else
                button.Icon.bg:SetBackdropBorderColor(1, 1, 1)
            end
        end
    end)

    local DetailsFrame = SetsCollectionFrame.DetailsFrame
    DetailsFrame.ModelFadeTexture:Hide()
    DetailsFrame.IconRowBackground:Hide()
    F.ReskinFilterButton(DetailsFrame.VariantSetsButton, "Down")

    hooksecurefunc(SetsCollectionFrame, "SetItemFrameQuality", function(self, itemFrame)
        if not itemFrame.skinned then
            itemFrame._auroraIconBorder = F.ReskinIcon(itemFrame.Icon)
            itemFrame.skinned = true
        end

        local quality
        if itemFrame.collected then
            quality = _G.C_TransmogCollection.GetSourceInfo(itemFrame.sourceID).quality
        end
        _G.SetItemButtonQuality(itemFrame, quality, itemFrame.sourceID)
    end)

    -- [[ Wardrobe ]]

    local WardrobeFrame = _G.WardrobeFrame
    local WardrobeTransmogFrame = _G.WardrobeTransmogFrame

    _G.WardrobeTransmogFrameBg:Hide()
    WardrobeTransmogFrame.Inset.BG:Hide()
    WardrobeTransmogFrame.Inset:DisableDrawLayer("BORDER")
    WardrobeTransmogFrame.MoneyLeft:Hide()
    WardrobeTransmogFrame.MoneyMiddle:Hide()
    WardrobeTransmogFrame.MoneyRight:Hide()
    WardrobeTransmogFrame.SpecButton.Icon:Hide()

    for i = 1, 9 do
        select(i, WardrobeTransmogFrame.SpecButton:GetRegions()):Hide()
    end

    F.ReskinPortraitFrame(WardrobeFrame)
    F.Reskin(WardrobeTransmogFrame.ApplyButton)
    F.Reskin(_G.WardrobeOutfitDropDown.SaveButton)
    F.ReskinArrow(_G.WardrobeTransmogFrame.SpecButton, "Down")
    F.ReskinDropDown(_G.WardrobeOutfitDropDown)

    _G.WardrobeOutfitDropDown:SetHeight(32)
    _G.WardrobeOutfitDropDown.SaveButton:SetPoint("LEFT", _G.WardrobeOutfitDropDown, "RIGHT", -13, 2)
    WardrobeTransmogFrame.SpecButton:SetPoint("RIGHT", WardrobeTransmogFrame.ApplyButton, "LEFT", -3, 0)

    local slots = {
        "Head",
        "Shoulder",
        "Chest",
        "Waist",
        "Legs",
        "Feet",
        "Wrist",
        "Hands",
        "Back",
        "Shirt",
        "Tabard",
        "MainHand",
        "SecondaryHand"
    }

    for i = 1, #slots do
        local slot = WardrobeTransmogFrame.Model[slots[i].."Button"]
        if slot then
            slot.Border:Hide()
            slot.Icon:SetDrawLayer("BACKGROUND", 1)
            F.ReskinIcon(slot.Icon)
        end
    end
end
