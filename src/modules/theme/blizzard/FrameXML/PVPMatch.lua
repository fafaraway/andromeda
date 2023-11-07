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
    F.ReskinButton(PVPReadyDialog.enterButton)
    F.ReskinButton(PVPReadyDialog.leaveButton)
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

    F.ReskinTrimScroll(content.ScrollBar)
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

        F.ReskinTrimScroll(content.scrollBar)
        F.StripTextures(tabContainer)
        for i = 1, 3 do
            F.ReskinTab(tabContainer.tabGroup['tab' .. i])
        end

        local buttonContainer = PVPMatchResults.buttonContainer
        F.ReskinButton(buttonContainer.leaveButton)
        F.ReskinButton(buttonContainer.requeueButton)
    end
end)
