local F, C = unpack(select(2, ...))

C.Themes['Blizzard_ArchaeologyUI'] = function()
    F.ReskinPortraitFrame(_G.ArchaeologyFrame)
    _G.ArchaeologyFrame:DisableDrawLayer('BACKGROUND')
    F.Reskin(_G.ArchaeologyFrameArtifactPageSolveFrameSolveButton)
    F.Reskin(_G.ArchaeologyFrameArtifactPageBackButton)

    _G.ArchaeologyFrameSummaryPageTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameArtifactPageHistoryTitle:SetTextColor(1, 0.8, 0)
    _G.ArchaeologyFrameArtifactPageHistoryScrollChildText:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameHelpPageTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPage:GetRegions():SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPageTitle:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPageTitleTop:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPageTitleMid:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameCompletedPagePageText:SetTextColor(1, 1, 1)
    _G.ArchaeologyFrameSummaryPagePageText:SetTextColor(1, 1, 1)
    for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
        local bu = _G['ArchaeologyFrameSummaryPageRace' .. i]
        bu.raceName:SetTextColor(1, 1, 1)
    end

    for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
        local buttonName = 'ArchaeologyFrameCompletedPageArtifact' .. i
        local button = _G[buttonName]
        local icon = _G[buttonName .. 'Icon']
        local name = _G[buttonName .. 'ArtifactName']
        local subText = _G[buttonName .. 'ArtifactSubText']
        F.StripTextures(button)
        F.ReskinIcon(icon)
        name:SetTextColor(1, 0.8, 0)
        subText:SetTextColor(1, 1, 1)
        local bg = F.CreateBDFrame(button, 0.25)
        bg:SetPoint('TOPLEFT', -4, 4)
        bg:SetPoint('BOTTOMRIGHT', 4, -4)
    end

    _G.ArchaeologyFrameInfoButton:SetPoint('TOPLEFT', 3, -3)
    _G.ArchaeologyFrameSummarytButton:SetPoint('TOPLEFT', _G.ArchaeologyFrame, 'TOPRIGHT', 1, -50)
    _G.ArchaeologyFrameSummarytButton:SetFrameLevel(_G.ArchaeologyFrame:GetFrameLevel() - 1)
    _G.ArchaeologyFrameCompletedButton:SetPoint('TOPLEFT', _G.ArchaeologyFrame, 'TOPRIGHT', 1, -120)
    _G.ArchaeologyFrameCompletedButton:SetFrameLevel(_G.ArchaeologyFrame:GetFrameLevel() - 1)

    F.ReskinDropDown(_G.ArchaeologyFrameRaceFilter)
    F.ReskinScroll(_G.ArchaeologyFrameArtifactPageHistoryScrollScrollBar)
    F.ReskinArrow(_G.ArchaeologyFrameCompletedPagePrevPageButton, 'left')
    F.ReskinArrow(_G.ArchaeologyFrameCompletedPageNextPageButton, 'right')
    _G.ArchaeologyFrameCompletedPagePrevPageButtonIcon:Hide()
    _G.ArchaeologyFrameCompletedPageNextPageButtonIcon:Hide()
    F.ReskinArrow(_G.ArchaeologyFrameSummaryPagePrevPageButton, 'left')
    F.ReskinArrow(_G.ArchaeologyFrameSummaryPageNextPageButton, 'right')
    _G.ArchaeologyFrameSummaryPagePrevPageButtonIcon:Hide()
    _G.ArchaeologyFrameSummaryPageNextPageButtonIcon:Hide()

    F.StripTextures(_G.ArchaeologyFrameRankBar)
    _G.ArchaeologyFrameRankBarBar:SetTexture(C.Assets.Texture.Backdrop)
    _G.ArchaeologyFrameRankBarBar:SetGradient('VERTICAL', 0, 0.65, 0, 0, 0.75, 0)
    _G.ArchaeologyFrameRankBar:SetHeight(14)
    F.CreateBDFrame(_G.ArchaeologyFrameRankBar, 0.25)
    F.ReskinIcon(_G.ArchaeologyFrameArtifactPageIcon)

    F.StripTextures(_G.ArchaeologyFrameArtifactPageSolveFrameStatusBar)
    F.CreateBDFrame(_G.ArchaeologyFrameArtifactPageSolveFrameStatusBar, 0.25)
    local barTexture = _G.ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetStatusBarTexture()
    barTexture:SetTexture(C.Assets.Texture.Backdrop)
    barTexture:SetGradient('VERTICAL', 0.65, 0.25, 0, 0.75, 0.35, 0.1)

    -- ArcheologyDigsiteProgressBar
    F.StripTextures(_G.ArcheologyDigsiteProgressBar)
    F.SetBD(_G.ArcheologyDigsiteProgressBar.FillBar)
    _G.ArcheologyDigsiteProgressBar.FillBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    _G.ArcheologyDigsiteProgressBar.FillBar:SetStatusBarColor(0.7, 0.3, 0.2)

    local ticks = {}
    _G.ArcheologyDigsiteProgressBar:HookScript('OnShow', function(self)
        local bar = self.FillBar
        if not bar then
            return
        end
        F:CreateAndUpdateBarTicks(bar, ticks, bar.fillBarMax)
    end)
end
