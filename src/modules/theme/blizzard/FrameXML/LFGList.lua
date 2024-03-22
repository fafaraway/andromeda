local F, C = unpack(select(2, ...))

local function Highlight_OnEnter(self)
    self.hl:Show()
end

local function Highlight_OnLeave(self)
    self.hl:Hide()
end

local function HandleRoleAnchor(self, role)
    self[role .. 'Count']:SetWidth(24)
    self[role .. 'Count']:SetFontObject(_G.Game13Font)
    self[role .. 'Count']:SetPoint('RIGHT', self[role .. 'Icon'], 'LEFT', 1, 0)
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local r, g, b = C.r, C.g, C.b

    local LFGListFrame = _G.LFGListFrame
    LFGListFrame.NothingAvailable.Inset:Hide()

    -- [[ Category selection ]]

    local categorySelection = LFGListFrame.CategorySelection

    F.ReskinButton(categorySelection.FindGroupButton)
    F.ReskinButton(categorySelection.StartGroupButton)
    categorySelection.Inset:Hide()
    categorySelection.CategoryButtons[1]:SetNormalFontObject(_G.GameFontNormal)

    hooksecurefunc('LFGListCategorySelection_AddButton', function(self, btnIndex)
        local bu = self.CategoryButtons[btnIndex]
        if bu and not bu.styled then
            bu.Cover:Hide()
            bu.Icon:SetTexCoord(0.01, 0.99, 0.01, 0.99)
            F.CreateBDFrame(bu.Icon)

            bu.styled = true
        end
    end)

    hooksecurefunc('LFGListSearchEntry_Update', function(self)
        local cancelButton = self.CancelButton
        if not cancelButton.styled then
            F.ReskinButton(cancelButton)
            cancelButton.styled = true
        end
    end)

    hooksecurefunc('LFGListSearchEntry_UpdateExpiration', function(self)
        local expirationTime = self.ExpirationTime
        if not expirationTime.fontStyled then
            expirationTime:SetWidth(42)
            expirationTime.fontStyled = true
        end
    end)

    -- [[ Search panel ]]

    local searchPanel = LFGListFrame.SearchPanel

    F.ReskinButton(searchPanel.RefreshButton)
    F.ReskinButton(searchPanel.BackButton)
    F.ReskinButton(searchPanel.BackToGroupButton)
    F.ReskinButton(searchPanel.SignUpButton)
    F.ReskinEditbox(searchPanel.SearchBox)
    F.ReskinFilterButton(searchPanel.FilterButton)

    searchPanel.RefreshButton:SetSize(24, 24)
    searchPanel.RefreshButton.Icon:SetPoint('CENTER')
    searchPanel.ResultsInset:Hide()
    F.StripTextures(searchPanel.AutoCompleteFrame)

    local numResults = 1
    hooksecurefunc('LFGListSearchPanel_UpdateAutoComplete', function(self)
        local AutoCompleteFrame = self.AutoCompleteFrame

        for i = numResults, #AutoCompleteFrame.Results do
            local result = AutoCompleteFrame.Results[i]

            if numResults == 1 then
                result:SetPoint('TOPLEFT', AutoCompleteFrame.LeftBorder, 'TOPRIGHT', -8, 1)
                result:SetPoint('TOPRIGHT', AutoCompleteFrame.RightBorder, 'TOPLEFT', 5, 1)
            else
                result:SetPoint('TOPLEFT', AutoCompleteFrame.Results[i - 1], 'BOTTOMLEFT', 0, 1)
                result:SetPoint('TOPRIGHT', AutoCompleteFrame.Results[i - 1], 'BOTTOMRIGHT', 0, 1)
            end

            result:SetNormalTexture(0)
            result:SetPushedTexture(0)
            result:SetHighlightTexture(0)

            local bg = F.CreateBDFrame(result, 0.5)
            local hl = result:CreateTexture(nil, 'BACKGROUND')
            hl:SetInside(bg)
            hl:SetTexture(C.Assets.Textures.Backdrop)
            hl:SetVertexColor(r, g, b, 0.25)
            hl:Hide()
            result.hl = hl

            result:HookScript('OnEnter', Highlight_OnEnter)
            result:HookScript('OnLeave', Highlight_OnLeave)

            numResults = numResults + 1
        end
    end)

    local function skinCreateButton(button)
        local child = button:GetChildren()
        if not child.styled and child:IsObjectType('Button') then
            F.ReskinButton(child)
            child.styled = true
        end
    end

    local delayStyled -- otherwise it taints while listing
    hooksecurefunc(searchPanel.ScrollBox, 'Update', function(self)
        if not delayStyled then
            F.ReskinButton(self.StartGroupButton, true)
            F.ReskinTrimScroll(searchPanel.ScrollBar)

            delayStyled = true
        end

        self:ForEachFrame(skinCreateButton)
    end)

    -- [[ Application viewer ]]

    local applicationViewer = LFGListFrame.ApplicationViewer
    applicationViewer.InfoBackground:Hide()
    applicationViewer.Inset:Hide()

    local prevHeader
    for _, headerName in pairs({
        'NameColumnHeader',
        'RoleColumnHeader',
        'ItemLevelColumnHeader',
        'RatingColumnHeader',
    }) do
        local header = applicationViewer[headerName]

        F.StripTextures(header)
        header.Label:SetFont(C.Assets.Fonts.Regular, 14, 'OUTLINE')
        header.Label:SetShadowColor(0, 0, 0, 0)
        header:SetHighlightTexture(0)

        local bg = F.CreateBDFrame(header, 0.25)
        local hl = header:CreateTexture(nil, 'BACKGROUND')
        hl:SetInside(bg)
        hl:SetTexture(C.Assets.Textures.Backdrop)
        hl:SetVertexColor(r, g, b, 0.25)
        hl:Hide()
        header.hl = hl

        header:HookScript('OnEnter', Highlight_OnEnter)
        header:HookScript('OnLeave', Highlight_OnLeave)

        if prevHeader then
            header:SetPoint('LEFT', prevHeader, 'RIGHT', C.MULT, 0)
        end
        prevHeader = header
    end

    F.ReskinButton(applicationViewer.RefreshButton)
    F.ReskinButton(applicationViewer.RemoveEntryButton)
    F.ReskinButton(applicationViewer.EditButton)
    F.ReskinButton(applicationViewer.BrowseGroupsButton)
    F.ReskinCheckbox(applicationViewer.AutoAcceptButton)
    F.ReskinTrimScroll(applicationViewer.ScrollBar)

    applicationViewer.RefreshButton:SetSize(24, 24)
    applicationViewer.RefreshButton.Icon:SetPoint('CENTER')

    hooksecurefunc('LFGListApplicationViewer_UpdateApplicant', function(button)
        if not button.styled then
            F.ReskinButton(button.DeclineButton)
            F.ReskinButton(button.InviteButton)
            F.ReskinButton(button.InviteButtonSmall)

            button.styled = true
        end
    end)

    -- [[ Entry creation ]]

    local entryCreation = LFGListFrame.EntryCreation
    entryCreation.Inset:Hide()
    F.StripTextures(entryCreation.Description)
    F.ReskinButton(entryCreation.ListGroupButton)
    F.ReskinButton(entryCreation.CancelButton)
    F.ReskinEditbox(entryCreation.Description)
    F.ReskinEditbox(entryCreation.Name)
    F.ReskinEditbox(entryCreation.ItemLevel.EditBox)
    F.ReskinEditbox(entryCreation.VoiceChat.EditBox)
    F.ReskinDropdown(entryCreation.GroupDropDown)
    F.ReskinDropdown(entryCreation.ActivityDropDown)
    F.ReskinDropdown(entryCreation.PlayStyleDropdown)
    F.ReskinCheckbox(entryCreation.MythicPlusRating.CheckButton)
    F.ReskinEditbox(entryCreation.MythicPlusRating.EditBox)
    F.ReskinCheckbox(entryCreation.PVPRating.CheckButton)
    F.ReskinEditbox(entryCreation.PVPRating.EditBox)
    if entryCreation.PvpItemLevel then -- I do believe blizz will rename Pvp into PvP in future build
        F.ReskinCheckbox(entryCreation.PvpItemLevel.CheckButton)
        F.ReskinEditbox(entryCreation.PvpItemLevel.EditBox)
    end
    F.ReskinCheckbox(entryCreation.ItemLevel.CheckButton)
    F.ReskinCheckbox(entryCreation.VoiceChat.CheckButton)
    F.ReskinCheckbox(entryCreation.PrivateGroup.CheckButton)
    F.ReskinCheckbox(entryCreation.CrossFactionGroup.CheckButton)

    -- [[ Role count ]]

    hooksecurefunc('LFGListGroupDataDisplayRoleCount_Update', function(self)
        if not self.styled then
            F.ReskinSmallRole(self.TankIcon, 'TANK')
            F.ReskinSmallRole(self.HealerIcon, 'HEALER')
            F.ReskinSmallRole(self.DamagerIcon, 'DPS')

            self.DamagerIcon:ClearAllPoints() -- fix for PGFinder
            self.HealerIcon:SetPoint('RIGHT', self.DamagerIcon, 'LEFT', -22, 0)
            self.TankIcon:SetPoint('RIGHT', self.HealerIcon, 'LEFT', -22, 0)

            HandleRoleAnchor(self, 'Tank')
            HandleRoleAnchor(self, 'Healer')
            HandleRoleAnchor(self, 'Damager')

            self.styled = true
        end
    end)

    hooksecurefunc('LFGListGroupDataDisplayPlayerCount_Update', function(self)
        if not self.styled then
            self.Count:SetWidth(24)

            self.styled = true
        end
    end)

    -- Activity finder

    local activityFinder = entryCreation.ActivityFinder
    activityFinder.Background:SetTexture('')

    local finderDialog = activityFinder.Dialog
    F.StripTextures(finderDialog)
    F.SetBD(finderDialog)
    F.ReskinButton(finderDialog.SelectButton)
    F.ReskinButton(finderDialog.CancelButton)
    F.ReskinEditbox(finderDialog.EntryBox)
    F.ReskinTrimScroll(finderDialog.ScrollBar)

    -- [[ Application dialog ]]

    local LFGListApplicationDialog = _G.LFGListApplicationDialog

    F.StripTextures(LFGListApplicationDialog)
    F.SetBD(LFGListApplicationDialog)
    F.StripTextures(LFGListApplicationDialog.Description)
    F.CreateBDFrame(LFGListApplicationDialog.Description, 0.25)
    F.ReskinButton(LFGListApplicationDialog.SignUpButton)
    F.ReskinButton(LFGListApplicationDialog.CancelButton)

    -- [[ Invite dialog ]]

    local LFGListInviteDialog = _G.LFGListInviteDialog

    F.StripTextures(LFGListInviteDialog)
    F.SetBD(LFGListInviteDialog)
    F.ReskinButton(LFGListInviteDialog.AcceptButton)
    F.ReskinButton(LFGListInviteDialog.DeclineButton)
    F.ReskinButton(LFGListInviteDialog.AcknowledgeButton)
end)
