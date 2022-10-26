local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    -- ready dialog
    local PVPReadyDialog = _G.PVPReadyDialog

    F.StripTextures(PVPReadyDialog)
    _G.PVPReadyDialogBackground:Hide()
    F.SetBD(PVPReadyDialog)
    _G.PVPReadyDialogRoleIconTexture:SetTexture(C.Assets.Textures.RoleLfgIcons)
    F.CreateBDFrame(_G.PVPReadyDialogRoleIcon)

    hooksecurefunc('PVPReadyDialog_Display', function(self, _, _, _, _, _, role)
        if self.roleIcon:IsShown() then
            self.roleIcon.texture:SetTexCoord(F.GetRoleTexCoord(role))
        end
    end)

    F.Reskin(PVPReadyDialog.enterButton)
    F.Reskin(PVPReadyDialog.leaveButton)
    F.ReskinClose(_G.PVPReadyDialogCloseButton)

    local function stripBorders(self)
        F.StripTextures(self)
    end

    _G.ReadyStatus.Border:SetAlpha(0)
    F.SetBD(_G.ReadyStatus)
    F.ReskinClose(_G.ReadyStatus.CloseButton)

    -- match score
    F.SetBD(_G.PVPMatchScoreboard)
    _G.PVPMatchScoreboard:HookScript('OnShow', stripBorders)
    F.ReskinClose(_G.PVPMatchScoreboard.CloseButton)

    local content = _G.PVPMatchScoreboard.Content
    local tabContainer = content.TabContainer

    F.StripTextures(content)
    local bg = F.CreateBDFrame(content, 0.25)
    bg:SetPoint('BOTTOMRIGHT', tabContainer.InsetBorderTop, 4, -1)

    if C.IS_NEW_PATCH then
        F.ReskinTrimScroll(content.ScrollBar)
    else
        F.ReskinScroll(content.ScrollFrame.ScrollBar)
    end

    F.StripTextures(tabContainer)
    for i = 1, 3 do
        F.ReskinTab(tabContainer.TabGroup['Tab' .. i])
    end

    -- match results
    do
        local PVPMatchResults = _G.PVPMatchResults
        F.SetBD(PVPMatchResults)
        PVPMatchResults.overlay:Hide()
        PVPMatchResults:HookScript('OnShow', stripBorders)
        F.ReskinClose(PVPMatchResults.CloseButton)
        F.StripTextures(PVPMatchResults.overlay)

        local content = PVPMatchResults.content
        local tabContainer = content.tabContainer

        F.StripTextures(content)
        local bg = F.CreateBDFrame(content, 0.25)
        bg:SetPoint('BOTTOMRIGHT', tabContainer.InsetBorderTop, 4, -1)
        F.StripTextures(content.earningsArt)

        if C.IS_NEW_PATCH then
            F.ReskinTrimScroll(content.scrollBar)
        else
            F.ReskinScroll(content.scrollFrame.ScrollBar)
        end

        F.StripTextures(tabContainer)
        for i = 1, 3 do
            F.ReskinTab(tabContainer.tabGroup['tab' .. i])
        end

        local buttonContainer = PVPMatchResults.buttonContainer
        F.Reskin(buttonContainer.leaveButton)
        F.Reskin(buttonContainer.requeueButton)
    end
end)
