local F, C = unpack(select(2, ...))

function F:ReskinIconSelector()
    F.StripTextures(self)
    F.SetBD(self):SetInside()
    F.StripTextures(self.BorderBox)
    F.StripTextures(self.BorderBox.IconSelectorEditBox, 2)
    F.ReskinEditBox(self.BorderBox.IconSelectorEditBox)
    F.StripTextures(self.BorderBox.SelectedIconArea.SelectedIconButton)
    F.ReskinIcon(self.BorderBox.SelectedIconArea.SelectedIconButton.Icon)
    F.Reskin(self.BorderBox.OkayButton)
    F.Reskin(self.BorderBox.CancelButton)
    F.ReskinTrimScroll(self.IconSelector.ScrollBar)

    hooksecurefunc(self.IconSelector.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if child.Icon and not child.styled then
                child:DisableDrawLayer('BACKGROUND')
                child.SelectedTexture:SetColorTexture(1, 0.8, 0, 0.5)
                child.SelectedTexture:SetAllPoints(child.Icon)
                local hl = child:GetHighlightTexture()
                hl:SetColorTexture(1, 1, 1, 0.25)
                hl:SetAllPoints(child.Icon)
                F.ReskinIcon(child.Icon)

                child.styled = true
            end
        end
    end)
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local r, g, b = C.r, C.g, C.b

    F.ReskinPortraitFrame(_G.CharacterFrame)
    F.StripTextures(_G.CharacterFrameInsetRight)

    for i = 1, 3 do
        local tab = _G['CharacterFrameTab' .. i]
        if tab then
            F.ReskinTab(tab)
            if i ~= 1 then
                tab:ClearAllPoints()
                tab:SetPoint('TOPLEFT', _G['CharacterFrameTab' .. (i - 1)], 'TOPRIGHT', -15, 0)
            end
        end
    end

    _G.CharacterModelScene:DisableDrawLayer('BACKGROUND')
    _G.CharacterModelScene:DisableDrawLayer('BORDER')
    _G.CharacterModelScene:DisableDrawLayer('OVERLAY')

    -- [[ Item buttons ]]

    local function colourPopout(self)
        local aR, aG, aB
        local glow = self:GetParent().IconBorder

        if glow:IsShown() then
            aR, aG, aB = glow:GetVertexColor()
        else
            aR, aG, aB = r, g, b
        end

        self.arrow:SetVertexColor(aR, aG, aB)
    end

    local function clearPopout(self)
        self.arrow:SetVertexColor(1, 1, 1)
    end

    local function UpdateAzeriteItem(self)
        if not self.styled then
            self.AzeriteTexture:SetAlpha(0)
            self.RankFrame.Texture:SetTexture('')
            self.RankFrame.Label:ClearAllPoints()
            self.RankFrame.Label:SetPoint('TOPLEFT', self, 2, -1)
            self.RankFrame.Label:SetTextColor(1, 0.5, 0)

            self.styled = true
        end
    end

    local function UpdateAzeriteEmpoweredItem(self)
        self.AzeriteTexture:SetAtlas('AzeriteIconFrame')
        self.AzeriteTexture:SetInside()
        self.AzeriteTexture:SetDrawLayer('BORDER', 1)
    end

    local function UpdateHighlight(self)
        local highlight = self:GetHighlightTexture()
        highlight:SetColorTexture(1, 1, 1, 0.25)
        highlight:SetInside(self.bg)
    end

    local function UpdateCosmetic(self)
        local itemLink = GetInventoryItemLink('player', self:GetID())
        self.IconOverlay:SetShown(itemLink and IsCosmeticItem(itemLink))
    end

    local slots = {
        'Head',
        'Neck',
        'Shoulder',
        'Shirt',
        'Chest',
        'Waist',
        'Legs',
        'Feet',
        'Wrist',
        'Hands',
        'Finger0',
        'Finger1',
        'Trinket0',
        'Trinket1',
        'Back',
        'MainHand',
        'SecondaryHand',
        'Tabard',
    }

    for i = 1, #slots do
        local slot = _G['Character' .. slots[i] .. 'Slot']
        local cooldown = _G['Character' .. slots[i] .. 'SlotCooldown']

        F.StripTextures(slot)
        slot.icon:SetTexCoord(unpack(C.TEX_COORD))
        slot.icon:SetInside()
        slot.bg = F.CreateBDFrame(slot.icon, 0.25)
        slot.bg:SetFrameLevel(3)
        cooldown:SetInside()

        slot.ignoreTexture:SetTexture('Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent')
        slot.IconOverlay:SetInside()
        F.ReskinIconBorder(slot.IconBorder)

        local popout = slot.popoutButton
        popout:SetNormalTexture(0)
        popout:SetHighlightTexture(0)

        local arrow = popout:CreateTexture(nil, 'OVERLAY')
        arrow:SetSize(14, 14)
        if slot.verticalFlyout then
            F.SetupArrow(arrow, 'down')
            arrow:SetPoint('TOP', slot, 'BOTTOM', 0, 1)
        else
            F.SetupArrow(arrow, 'right')
            arrow:SetPoint('LEFT', slot, 'RIGHT', -1, 0)
        end
        popout.arrow = arrow

        popout:HookScript('OnEnter', clearPopout)
        popout:HookScript('OnLeave', colourPopout)

        hooksecurefunc(slot, 'DisplayAsAzeriteItem', UpdateAzeriteItem)
        hooksecurefunc(slot, 'DisplayAsAzeriteEmpoweredItem', UpdateAzeriteEmpoweredItem)
    end

    hooksecurefunc('PaperDollItemSlotButton_Update', function(button)
        -- also fires for bag slots, we don't want that
        if button.popoutButton then
            button.icon:SetShown(GetInventoryItemTexture('player', button:GetID()) ~= nil)
            colourPopout(button.popoutButton)
        end
        UpdateCosmetic(button)
        UpdateHighlight(button)
    end)

    -- [[ Stats pane ]]

    local pane = _G.CharacterStatsPane
    pane.ClassBackground:Hide()
    pane.ItemLevelFrame.Corruption:SetPoint('RIGHT', 22, -8)

    local categories = { pane.ItemLevelCategory, pane.AttributesCategory, pane.EnhancementsCategory }
    for _, category in pairs(categories) do
        category.Background:SetTexture('Interface\\LFGFrame\\UI-LFG-SEPARATOR')
        category.Background:SetTexCoord(0, 0.66, 0, 0.31)
        category.Background:SetVertexColor(r, g, b, 0.8)
        category.Background:SetPoint('BOTTOMLEFT', -30, -4)

        category.Title:SetTextColor(r, g, b)
    end

    -- [[ Sidebar tabs ]]

    if _G.PaperDollSidebarTabs.DecorRight then
        _G.PaperDollSidebarTabs.DecorRight:Hide()
    end

    for i = 1, #_G.PAPERDOLL_SIDEBARS do
        local tab = _G['PaperDollSidebarTab' .. i]

        if i == 1 then
            for i = 1, 4 do
                local region = select(i, tab:GetRegions())
                region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
                region.SetTexCoord = nop
            end
        end

        tab.bg = F.CreateBDFrame(tab)
        tab.bg:SetPoint('TOPLEFT', 2, -3)
        tab.bg:SetPoint('BOTTOMRIGHT', 0, -2)

        tab.Icon:SetInside(tab.bg)
        tab.Hider:SetInside(tab.bg)
        tab.Highlight:SetInside(tab.bg)
        tab.Highlight:SetColorTexture(1, 1, 1, 0.25)
        tab.Hider:SetColorTexture(0.3, 0.3, 0.3, 0.4)
        tab.TabBg:SetAlpha(0)
    end

    -- [[ Equipment manager ]]

    F.Reskin(_G.PaperDollFrameEquipSet)
    F.Reskin(_G.PaperDollFrameSaveSet)
    F.ReskinTrimScroll(_G.PaperDollFrame.EquipmentManagerPane.ScrollBar)

    hooksecurefunc(_G.PaperDollFrame.EquipmentManagerPane.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if child.icon and not child.styled then
                F.HideObject(child.Stripe)
                child.BgTop:SetTexture('')
                child.BgMiddle:SetTexture('')
                child.BgBottom:SetTexture('')
                F.ReskinIcon(child.icon)

                child.HighlightBar:SetColorTexture(1, 1, 1, 0.25)
                child.HighlightBar:SetDrawLayer('BACKGROUND')
                child.SelectedBar:SetColorTexture(r, g, b, 0.25)
                child.SelectedBar:SetDrawLayer('BACKGROUND')

                child.styled = true
            end
        end
    end)

    F.ReskinIconSelector(_G.GearManagerPopupFrame)

    -- Title Pane
    F.ReskinTrimScroll(_G.PaperDollFrame.TitleManagerPane.ScrollBar)

    hooksecurefunc(_G.PaperDollFrame.TitleManagerPane.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                child:DisableDrawLayer('BACKGROUND')
                child.styled = true
            end
        end
    end)

    -- Reputation Frame
    _G.ReputationDetailCorner:Hide()
    _G.ReputationDetailDivider:Hide()
    _G.ReputationDetailFrame:SetPoint('TOPLEFT', _G.ReputationFrame, 'TOPRIGHT', 3, -28)

    local function UpdateFactionSkins()
        for i = 1, GetNumFactions() do
            local statusbar = _G['ReputationBar' .. i .. 'ReputationBar']
            if statusbar then
                statusbar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)

                if not statusbar.reskinned then
                    F.CreateBDFrame(statusbar, 0.25)
                    statusbar.reskinned = true
                end

                _G['ReputationBar' .. i .. 'Background']:SetTexture(nil)
                _G['ReputationBar' .. i .. 'ReputationBarHighlight1']:SetTexture(nil)
                _G['ReputationBar' .. i .. 'ReputationBarHighlight2']:SetTexture(nil)
                _G['ReputationBar' .. i .. 'ReputationBarAtWarHighlight1']:SetTexture(nil)
                _G['ReputationBar' .. i .. 'ReputationBarAtWarHighlight2']:SetTexture(nil)
                _G['ReputationBar' .. i .. 'ReputationBarLeftTexture']:SetTexture(nil)
                _G['ReputationBar' .. i .. 'ReputationBarRightTexture']:SetTexture(nil)
            end
        end
    end
    _G.ReputationFrame:HookScript('OnShow', UpdateFactionSkins)
    _G.ReputationFrame:HookScript('OnEvent', UpdateFactionSkins)

    local function updateReputationBars(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            local container = child and child.Container
            if container and not container.styled then
                F.StripTextures(container)
                if container.ExpandOrCollapseButton then
                    F.ReskinCollapse(container.ExpandOrCollapseButton)
                    container.ExpandOrCollapseButton.__texture:DoCollapse(child.isCollapsed)
                end
                if container.ReputationBar then
                    F.StripTextures(container.ReputationBar)
                    container.ReputationBar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
                    F.CreateBDFrame(container.ReputationBar, 0.25)
                end

                container.styled = true
            end
        end
    end
    hooksecurefunc(_G.ReputationFrame.ScrollBox, 'Update', updateReputationBars)

    F.ReskinTrimScroll(_G.ReputationFrame.ScrollBar)
    F.StripTextures(_G.ReputationDetailFrame)
    F.SetBD(_G.ReputationDetailFrame)
    F.ReskinClose(_G.ReputationDetailCloseButton)
    F.ReskinCheckbox(_G.ReputationDetailInactiveCheckBox)
    F.ReskinCheckbox(_G.ReputationDetailMainScreenCheckBox)

    local atWarCheck = _G.ReputationDetailAtWarCheckBox
    F.ReskinCheckbox(atWarCheck)
    local atWarCheckTex = atWarCheck:GetCheckedTexture()
    atWarCheckTex:ClearAllPoints()
    atWarCheckTex:SetSize(26, 26)
    atWarCheckTex:SetPoint('CENTER')

    -- Token frame
    if _G.TokenFramePopup.CloseButton then -- needs review, blizz typo
        F.ReskinClose(_G.TokenFramePopup.CloseButton)
    end
    F.ReskinCheckbox(_G.TokenFramePopup.InactiveCheckBox)
    F.ReskinCheckbox(_G.TokenFramePopup.BackpackCheckBox)
    F.ReskinTrimScroll(_G.TokenFrame.ScrollBar)

    hooksecurefunc(_G.TokenFrame.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if child.Highlight and not child.styled then
                if not child.styled then
                    child.CategoryLeft:SetAlpha(0)
                    child.CategoryRight:SetAlpha(0)
                    child.CategoryMiddle:SetAlpha(0)

                    child.Highlight:SetInside()
                    child.Highlight.SetPoint = nop
                    child.Highlight:SetColorTexture(1, 1, 1, 0.25)
                    child.Highlight.SetTexture = nop

                    child.bg = F.ReskinIcon(child.Icon)

                    if child.ExpandIcon then
                        child.expBg = F.CreateBDFrame(child.ExpandIcon, 0, true)
                        child.expBg:SetInside(child.ExpandIcon, 3, 3)
                    end

                    if child.Check then
                        child.Check:SetAtlas('checkmark-minimal')
                    end

                    child.styled = true
                end

                child.styled = true
            end

            if child.isHeader then
                child.bg:Hide()
                child.expBg:Show()
            else
                child.bg:Show()
                child.expBg:Hide()
            end
        end
    end)

    F.StripTextures(_G.TokenFramePopup)
    F.SetBD(_G.TokenFramePopup)

    -- Quick Join
    F.ReskinTrimScroll(_G.QuickJoinFrame.ScrollBar)
    F.Reskin(_G.QuickJoinFrame.JoinQueueButton)

    F.SetBD(_G.QuickJoinRoleSelectionFrame)
    F.Reskin(_G.QuickJoinRoleSelectionFrame.AcceptButton)
    F.Reskin(_G.QuickJoinRoleSelectionFrame.CancelButton)
    F.ReskinClose(_G.QuickJoinRoleSelectionFrame.CloseButton)
    F.StripTextures(_G.QuickJoinRoleSelectionFrame)

    F.ReskinRole(_G.QuickJoinRoleSelectionFrame.RoleButtonTank, 'TANK')
    F.ReskinRole(_G.QuickJoinRoleSelectionFrame.RoleButtonHealer, 'HEALER')
    F.ReskinRole(_G.QuickJoinRoleSelectionFrame.RoleButtonDPS, 'DPS')
end)
