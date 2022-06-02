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

local atlasToRole = {
    ['groupfinder-icon-role-large-tank'] = 'TANK',
    ['groupfinder-icon-role-large-heal'] = 'HEALER',
    ['groupfinder-icon-role-large-dps'] = 'DAMAGER',
}

local function ReplaceApplicantRoles(texture, atlas)
    local role = atlasToRole[atlas]
    if role then
        texture:SetTexture(C.Assets.Texture.LfgRole)
        texture:SetTexCoord(F.GetRoleTexCoord(role))
    end
end

table.insert(C.BlizzThemes, function()
    local r, g, b = C.r, C.g, C.b

    local LFGListFrame = _G.LFGListFrame
    LFGListFrame.NothingAvailable.Inset:Hide()

    -- [[ Category selection ]]

    local categorySelection = LFGListFrame.CategorySelection

    F.Reskin(categorySelection.FindGroupButton)
    F.Reskin(categorySelection.StartGroupButton)
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
            F.Reskin(cancelButton)
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

    F.Reskin(searchPanel.RefreshButton)
    F.Reskin(searchPanel.BackButton)
    F.Reskin(searchPanel.BackToGroupButton)
    F.Reskin(searchPanel.SignUpButton)
    F.Reskin(searchPanel.ScrollFrame.ScrollChild.StartGroupButton)
    F.ReskinInput(searchPanel.SearchBox)
    F.ReskinScroll(searchPanel.ScrollFrame.scrollBar)

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

            result:SetNormalTexture('')
            result:SetPushedTexture('')
            result:SetHighlightTexture('')

            local bg = F.CreateBDFrame(result, 0.5)
            local hl = result:CreateTexture(nil, 'BACKGROUND')
            hl:SetInside(bg)
            hl:SetTexture(C.Assets.Texture.Backdrop)
            hl:SetVertexColor(r, g, b, 0.25)
            hl:Hide()
            result.hl = hl

            result:HookScript('OnEnter', Highlight_OnEnter)
            result:HookScript('OnLeave', Highlight_OnLeave)

            numResults = numResults + 1
        end
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
        header.Label:SetFont(C.Assets.Font.Regular, 14, 'OUTLINE')
        header.Label:SetShadowColor(0, 0, 0, 0)
        header:SetHighlightTexture('')

        local bg = F.CreateBDFrame(header, 0.25)
        local hl = header:CreateTexture(nil, 'BACKGROUND')
        hl:SetInside(bg)
        hl:SetTexture(C.Assets.Texture.Backdrop)
        hl:SetVertexColor(r, g, b, 0.25)
        hl:Hide()
        header.hl = hl

        header:HookScript('OnEnter', Highlight_OnEnter)
        header:HookScript('OnLeave', Highlight_OnLeave)

        if prevHeader then
            header:SetPoint('LEFT', prevHeader, 'RIGHT', C.mult, 0)
        end
        prevHeader = header
    end

    F.Reskin(applicationViewer.RefreshButton)
    F.Reskin(applicationViewer.RemoveEntryButton)
    F.Reskin(applicationViewer.EditButton)
    F.Reskin(applicationViewer.BrowseGroupsButton)
    F.ReskinCheck(applicationViewer.AutoAcceptButton)
    F.ReskinScroll(_G.LFGListApplicationViewerScrollFrameScrollBar)

    applicationViewer.RefreshButton:SetSize(24, 24)
    applicationViewer.RefreshButton.Icon:SetPoint('CENTER')

    hooksecurefunc('LFGListApplicationViewer_UpdateApplicant', function(button)
        if not button.styled then
            F.Reskin(button.DeclineButton)
            F.Reskin(button.InviteButton)
            F.Reskin(button.InviteButtonSmall)

            button.styled = true
        end
    end)

    hooksecurefunc('LFGListApplicationViewer_UpdateRoleIcons', function(member)
        if not member.styled then
            for i = 1, 3 do
                local button = member['RoleIcon' .. i]
                local texture = button:GetNormalTexture()
                ReplaceApplicantRoles(texture, _G.LFG_LIST_GROUP_DATA_ATLASES[button.role])
                hooksecurefunc(texture, 'SetAtlas', ReplaceApplicantRoles)
                F.CreateBDFrame(button)
            end

            member.styled = true
        end
    end)

    -- [[ Entry creation ]]

    local entryCreation = LFGListFrame.EntryCreation
    entryCreation.Inset:Hide()
    F.StripTextures(entryCreation.Description)
    F.Reskin(entryCreation.ListGroupButton)
    F.Reskin(entryCreation.CancelButton)
    F.ReskinInput(entryCreation.Description)
    F.ReskinInput(entryCreation.Name)
    F.ReskinInput(entryCreation.ItemLevel.EditBox)
    F.ReskinInput(entryCreation.VoiceChat.EditBox)
    F.ReskinDropDown(entryCreation.GroupDropDown)
    F.ReskinDropDown(entryCreation.ActivityDropDown)
    F.ReskinDropDown(entryCreation.PlayStyleDropdown)
    F.ReskinCheck(entryCreation.MythicPlusRating.CheckButton)
    F.ReskinInput(entryCreation.MythicPlusRating.EditBox)
    F.ReskinCheck(entryCreation.PVPRating.CheckButton)
    F.ReskinInput(entryCreation.PVPRating.EditBox)
    if entryCreation.PvpItemLevel then -- I do believe blizz will rename Pvp into PvP in future build
        F.ReskinCheck(entryCreation.PvpItemLevel.CheckButton)
        F.ReskinInput(entryCreation.PvpItemLevel.EditBox)
    end
    F.ReskinCheck(entryCreation.ItemLevel.CheckButton)
    F.ReskinCheck(entryCreation.VoiceChat.CheckButton)
    F.ReskinCheck(entryCreation.PrivateGroup.CheckButton)
    F.ReskinCheck(entryCreation.CrossFactionGroup.CheckButton)


    -- [[ Role count ]]

    hooksecurefunc('LFGListGroupDataDisplayRoleCount_Update', function(self)
        if not self.styled then
            F.ReskinSmallRole(self.TankIcon, 'TANK')
            F.ReskinSmallRole(self.HealerIcon, 'HEALER')
            F.ReskinSmallRole(self.DamagerIcon, 'DPS')

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
    F.Reskin(finderDialog.SelectButton)
    F.Reskin(finderDialog.CancelButton)
    F.ReskinInput(finderDialog.EntryBox)
    F.ReskinScroll(finderDialog.ScrollFrame.scrollBar)

    -- [[ Application dialog ]]

    local LFGListApplicationDialog = _G.LFGListApplicationDialog

    F.StripTextures(LFGListApplicationDialog)
    F.SetBD(LFGListApplicationDialog)
    F.StripTextures(LFGListApplicationDialog.Description)
    F.CreateBDFrame(LFGListApplicationDialog.Description, 0.25)
    F.Reskin(LFGListApplicationDialog.SignUpButton)
    F.Reskin(LFGListApplicationDialog.CancelButton)

    -- [[ Invite dialog ]]

    local LFGListInviteDialog = _G.LFGListInviteDialog

    F.StripTextures(LFGListInviteDialog)
    F.SetBD(LFGListInviteDialog)
    F.Reskin(LFGListInviteDialog.AcceptButton)
    F.Reskin(LFGListInviteDialog.DeclineButton)
    F.Reskin(LFGListInviteDialog.AcknowledgeButton)

    local roleIcon = LFGListInviteDialog.RoleIcon
    roleIcon:SetTexture(C.Assets.Texture.LfgRole)
    F.CreateBDFrame(roleIcon)

    hooksecurefunc('LFGListInviteDialog_Show', function(self, resultID)
        local role = select(5, C_LFGList.GetApplicationInfo(resultID))
        self.RoleIcon:SetTexCoord(F.GetRoleTexCoord(role))
    end)
end)
