local F, C = unpack(select(2, ...))

C.Themes['Blizzard_AchievementUI'] = function()
    local r, g, b = C.r, C.g, C.b

    F.StripTextures(_G.AchievementFrame, true)
    F.SetBD(_G.AchievementFrame)
    _G.AchievementFrameCategories:HideBackdrop()
    _G.AchievementFrameSummaryBackground:Hide()
    _G.AchievementFrameSummary:GetChildren():Hide()
    _G.AchievementFrameCategoriesContainerScrollBarBG:SetAlpha(0)

    for i = 1, 4 do
        select(i, _G.AchievementFrameHeader:GetRegions()):Hide()
    end
    _G.AchievementFrameHeaderRightDDLInset:SetAlpha(0)
    _G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0)

    select(2, _G.AchievementFrameAchievements:GetChildren()):Hide()
    _G.AchievementFrameAchievementsBackground:Hide()
    select(3, _G.AchievementFrameAchievements:GetRegions()):Hide()

    _G.AchievementFrameStatsBG:Hide()
    _G.AchievementFrameSummaryAchievementsHeaderHeader:Hide()
    _G.AchievementFrameSummaryCategoriesHeaderTexture:Hide()
    select(3, _G.AchievementFrameStats:GetChildren()):Hide()
    select(5, _G.AchievementFrameComparison:GetChildren()):Hide()
    _G.AchievementFrameComparisonHeaderBG:Hide()
    _G.AchievementFrameComparisonHeaderPortrait:Hide()
    _G.AchievementFrameComparisonHeaderPortraitBg:Hide()
    _G.AchievementFrameComparisonBackground:Hide()
    _G.AchievementFrameComparisonDark:SetAlpha(0)
    _G.AchievementFrameComparisonSummaryPlayerBackground:Hide()
    _G.AchievementFrameComparisonSummaryFriendBackground:Hide()

    local function SetupButtonHighlight(button, bg)
        button:SetHighlightTexture(C.Assets.Texture.Backdrop)
        local hl = button:GetHighlightTexture()
        hl:SetVertexColor(r, g, b, 0.25)
        hl:SetInside(bg)
    end

    hooksecurefunc('AchievementFrameCategories_DisplayButton', function(bu)
        if bu.styled then
            return
        end

        bu.background:Hide()
        local bg = F.CreateBDFrame(bu, 0.25)
        bg:SetPoint('TOPLEFT', 0, -1)
        bg:SetPoint('BOTTOMRIGHT')
        SetupButtonHighlight(bu, bg)

        bu.styled = true
    end)

    _G.AchievementFrameHeaderPoints:SetPoint('TOP', _G.AchievementFrame, 'TOP', 0, -6)
    _G.AchievementFrameFilterDropDown:ClearAllPoints()
    _G.AchievementFrameFilterDropDown:SetPoint('TOPRIGHT', -120, 0)
    _G.AchievementFrameFilterDropDownText:ClearAllPoints()
    _G.AchievementFrameFilterDropDownText:SetPoint('CENTER', -10, 1)

    F.StripTextures(_G.AchievementFrameSummaryCategoriesStatusBar)
    _G.AchievementFrameSummaryCategoriesStatusBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    _G.AchievementFrameSummaryCategoriesStatusBar:GetStatusBarTexture():SetGradient('VERTICAL', 0, 0.4, 0, 0, 0.6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
    _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint(
        'LEFT',
        _G.AchievementFrameSummaryCategoriesStatusBar,
        'LEFT',
        6,
        0
    )
    _G.AchievementFrameSummaryCategoriesStatusBarText:SetPoint(
        'RIGHT',
        _G.AchievementFrameSummaryCategoriesStatusBar,
        'RIGHT',
        -5,
        0
    )
    F.CreateBDFrame(_G.AchievementFrameSummaryCategoriesStatusBar, 0.25)

    for i = 1, 3 do
        local tab = _G['AchievementFrameTab' .. i]
        if tab then
            F.ReskinTab(tab)
        end
    end

    _G.AchievementFrameTab1:ClearAllPoints()
    _G.AchievementFrameTab1:SetPoint('TOPLEFT', _G.AchievementFrame, 'BOTTOMLEFT', 10, 1)

    for i = 1, 7 do
        local bu = _G['AchievementFrameAchievementsContainerButton' .. i]
        F.StripTextures(bu, true)
        bu.highlight:SetAlpha(0)
        bu.icon.frame:Hide()

        local bg = F.CreateBDFrame(bu, 0.25)
        bg:SetPoint('TOPLEFT', 1, -1)
        bg:SetPoint('BOTTOMRIGHT', 0, 2)
        F.ReskinIcon(bu.icon.texture)

        -- can't get a backdrop frame to appear behind the checked texture for some reason
        local ch = bu.tracked
        ch:SetNormalTexture('')
        ch:SetPushedTexture('')
        ch:SetHighlightTexture(C.Assets.Texture.Backdrop)

        local check = ch:GetCheckedTexture()
        check:SetDesaturated(true)
        check:SetVertexColor(r, g, b)

        local bg = F.CreateBDFrame(ch, 0, true)
        bg:SetPoint('TOPLEFT', 2, -2)
        bg:SetPoint('BOTTOMRIGHT', -2, 2)

        local hl = ch:GetHighlightTexture()
        hl:SetInside(bg)
        hl:SetVertexColor(r, g, b, 0.25)
    end

    _G.AchievementFrameAchievementsContainerButton1.background:SetPoint(
        'TOPLEFT',
        _G.AchievementFrameAchievementsContainerButton1,
        'TOPLEFT',
        2,
        -3
    )

    hooksecurefunc('AchievementButton_DisplayAchievement', function(button, category, achievement)
        local _, _, _, completed = GetAchievementInfo(category, achievement)
        if completed then
            if button.accountWide then
                button.label:SetTextColor(0, 0.6, 1)
            else
                button.label:SetTextColor(0.9, 0.9, 0.9)
            end
        else
            if button.accountWide then
                button.label:SetTextColor(0, 0.3, 0.5)
            else
                button.label:SetTextColor(0.65, 0.65, 0.65)
            end
        end
        button.description:SetTextColor(0.9, 0.9, 0.9)
    end)

    hooksecurefunc('AchievementObjectives_DisplayCriteria', function(_, id)
        for i = 1, GetAchievementNumCriteria(id) do
            local name = _G['AchievementFrameCriteria' .. i .. 'Name']
            if name and select(2, name:GetTextColor()) == 0 then
                name:SetTextColor(1, 1, 1)
            end

            local bu = _G['AchievementFrameMeta' .. i]
            if bu and select(2, bu.label:GetTextColor()) == 0 then
                bu.label:SetTextColor(1, 1, 1)
            end
        end
    end)

    hooksecurefunc('AchievementButton_GetProgressBar', function(index)
        local bar = _G['AchievementFrameProgressBar' .. index]
        if not bar.styled then
            F.StripTextures(bar)
            bar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
            F.CreateBDFrame(bar, 0.25)

            bar.styled = true
        end
    end)

    -- this is hidden behind other stuff in default UI
    _G.AchievementFrameSummaryAchievementsEmptyText:SetText('')

    hooksecurefunc('AchievementFrameSummary_UpdateAchievements', function()
        for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
            local bu = _G['AchievementFrameSummaryAchievement' .. i]
            if bu.accountWide then
                bu.label:SetTextColor(0, 0.6, 1)
            else
                bu.label:SetTextColor(0.9, 0.9, 0.9)
            end

            if not bu.styled then
                bu:DisableDrawLayer('BORDER')
                bu:HideBackdrop()

                local bd = bu.background
                bd:SetTexture(C.Assets.Texture.Backdrop)
                bd:SetVertexColor(0, 0, 0, 0.25)

                bu.titleBar:Hide()
                bu.glow:Hide()
                bu.highlight:SetAlpha(0)
                bu.icon.frame:Hide()
                F.ReskinIcon(bu.icon.texture)

                local bg = F.CreateBDFrame(bu, 0)
                bg:SetPoint('TOPLEFT', 2, -2)
                bg:SetPoint('BOTTOMRIGHT', -2, 2)

                bu.styled = true
            end

            bu.description:SetTextColor(0.9, 0.9, 0.9)
        end
    end)

    for i = 1, 12 do
        local bu = _G['AchievementFrameSummaryCategoriesCategory' .. i]
        F.StripTextures(bu)
        bu:SetStatusBarTexture(C.Assets.Texture.Backdrop)
        bu:GetStatusBarTexture():SetGradient('VERTICAL', 0, 0.4, 0, 0, 0.6, 0)
        F.CreateBDFrame(bu, 0.25)

        bu.label:SetTextColor(1, 1, 1)
        bu.label:SetPoint('LEFT', bu, 'LEFT', 6, 0)
        bu.text:SetPoint('RIGHT', bu, 'RIGHT', -5, 0)
        _G[bu:GetName() .. 'ButtonHighlight']:SetAlpha(0)
    end

    for i = 1, 20 do
        local bu = _G['AchievementFrameStatsContainerButton' .. i]
        F.StripTextures(bu)
        local bg = F.CreateBDFrame(bu, 0.25)
        bg:SetPoint('TOPLEFT', 2, -C.MULT)
        bg:SetPoint('BOTTOMRIGHT', 4, C.MULT)
        SetupButtonHighlight(bu, bg)
    end

    _G.AchievementFrameComparisonHeader:SetPoint('BOTTOMRIGHT', _G.AchievementFrameComparison, 'TOPRIGHT', 39, 26)
    local headerbg = F.SetBD(_G.AchievementFrameComparisonHeader)
    headerbg:SetPoint('TOPLEFT', 20, -20)
    headerbg:SetPoint('BOTTOMRIGHT', -28, -5)

    local summaries = { _G.AchievementFrameComparisonSummaryPlayer, _G.AchievementFrameComparisonSummaryFriend }
    for _, frame in pairs(summaries) do
        frame:HideBackdrop()
        local bg = F.CreateBDFrame(frame, 0.25)
        bg:SetPoint('TOPLEFT', 2, -2)
        bg:SetPoint('BOTTOMRIGHT', -2, 0)
    end

    local bars = {
        _G.AchievementFrameComparisonSummaryPlayerStatusBar,
        _G.AchievementFrameComparisonSummaryFriendStatusBar,
    }
    for _, bar in pairs(bars) do
        F.StripTextures(bar)
        bar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
        bar:GetStatusBarTexture():SetGradient('VERTICAL', 0, 0.4, 0, 0, 0.6, 0)
        bar.title:SetTextColor(1, 1, 1)
        bar.title:SetPoint('LEFT', bar, 'LEFT', 6, 0)
        bar.text:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)
        F.CreateBDFrame(bar, 0.25)
    end

    for _, name in pairs({ 'Player', 'Friend' }) do
        for i = 1, 9 do
            local button = _G['AchievementFrameComparisonContainerButton' .. i .. name]
            button:DisableDrawLayer('BORDER')
            button:HideBackdrop()
            button.background:Hide()
            local bg = F.CreateBDFrame(button, 0.25)
            bg:SetPoint('TOPLEFT', 2, -1)
            bg:SetPoint('BOTTOMRIGHT', -2, 2)

            button.titleBar:Hide()
            button.glow:Hide()
            button.icon.frame:Hide()
            F.ReskinIcon(button.icon.texture)
        end
    end

    hooksecurefunc('AchievementFrameComparison_DisplayAchievement', function(button)
        button.player.description:SetTextColor(0.9, 0.9, 0.9)
    end)

    F.ReskinClose(_G.AchievementFrameCloseButton)
    F.ReskinScroll(_G.AchievementFrameAchievementsContainerScrollBar)
    F.ReskinScroll(_G.AchievementFrameStatsContainerScrollBar)
    F.ReskinScroll(_G.AchievementFrameCategoriesContainerScrollBar)
    F.ReskinScroll(_G.AchievementFrameComparisonContainerScrollBar)
    F.ReskinDropDown(_G.AchievementFrameFilterDropDown)
    F.ReskinInput(_G.AchievementFrame.searchBox)
    _G.AchievementFrame.searchBox:ClearAllPoints()
    _G.AchievementFrame.searchBox:SetPoint('TOPRIGHT', _G.AchievementFrame, 'TOPRIGHT', -25, -5)
    _G.AchievementFrame.searchBox:SetPoint('BOTTOMLEFT', _G.AchievementFrame, 'TOPRIGHT', -130, -25)

    local showAllSearchResults = _G.AchievementFrame.searchPreviewContainer.showAllSearchResults

    F.StripTextures(_G.AchievementFrame.searchPreviewContainer)
    _G.AchievementFrame.searchPreviewContainer:ClearAllPoints()
    _G.AchievementFrame.searchPreviewContainer:SetPoint('TOPLEFT', _G.AchievementFrame, 'TOPRIGHT', 7, -2)
    local bg = F.SetBD(_G.AchievementFrame.searchPreviewContainer)
    bg:SetPoint('TOPLEFT', -3, 3)
    bg:SetPoint('BOTTOMRIGHT', showAllSearchResults, 3, -3)

    for i = 1, 5 do
        F.StyleSearchButton(_G.AchievementFrame.searchPreviewContainer['searchPreview' .. i])
    end
    F.StyleSearchButton(showAllSearchResults)

    do
        local result = _G.AchievementFrame.searchResults
        result:SetPoint('BOTTOMLEFT', _G.AchievementFrame, 'BOTTOMRIGHT', 15, -1)
        F.StripTextures(result)
        local bg = F.SetBD(result)
        bg:SetPoint('TOPLEFT', -10, 0)
        bg:SetPoint('BOTTOMRIGHT')

        F.ReskinClose(result.closeButton)
        F.ReskinScroll(_G.AchievementFrameScrollFrameScrollBar)
        for i = 1, 8 do
            local bu = _G['AchievementFrameScrollFrameButton' .. i]
            F.StripTextures(bu)
            F.ReskinIcon(bu.icon)
            local bg = F.CreateBDFrame(bu, 0.25)
            bg:SetInside()
            SetupButtonHighlight(bu, bg)
        end
    end

    for i = 1, 20 do
        local bu = _G['AchievementFrameComparisonStatsContainerButton' .. i]
        F.StripTextures(bu)
        local bg = F.CreateBDFrame(bu, 0.25)
        bg:SetPoint('TOPLEFT', 2, -C.MULT)
        bg:SetPoint('BOTTOMRIGHT', 4, C.MULT)
        SetupButtonHighlight(bu, bg)
    end
    F.ReskinScroll(_G.AchievementFrameComparisonStatsContainerScrollBar)
    _G.AchievementFrameComparisonWatermark:SetAlpha(0)

    -- Font width fix
    local fixedIndex = 1
    hooksecurefunc('AchievementObjectives_DisplayProgressiveAchievement', function()
        local mini = _G['AchievementFrameMiniAchievement' .. fixedIndex]
        while mini do
            mini.points:SetWidth(22)
            mini.points:ClearAllPoints()
            mini.points:SetPoint('BOTTOMRIGHT', 2, 2)

            fixedIndex = fixedIndex + 1
            mini = _G['AchievementFrameMiniAchievement' .. fixedIndex]
        end
    end)
end
