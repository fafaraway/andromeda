local F, C = unpack(select(2, ...))

local function SetupButtonHighlight(button, bg)
    button:SetHighlightTexture(C.Assets.Textures.Backdrop)
    local hl = button:GetHighlightTexture()
    hl:SetVertexColor(C.r, C.g, C.b, 0.25)
    hl:SetInside(bg)
end

C.Themes['Blizzard_AchievementUI'] = function()
    if C.IS_NEW_PATCH then
        local AchievementFrame = _G.AchievementFrame
        local AchievementFrameFilterDropDown = _G.AchievementFrameFilterDropDown
        local AchievementFrameFilterDropDownText = _G.AchievementFrameFilterDropDownText

        F.StripTextures(AchievementFrame)
        F.SetBD(AchievementFrame)
        _G.AchievementFrameWaterMark:SetAlpha(0)
        F.StripTextures(AchievementFrame.Header)
        AchievementFrame.Header.Title:Hide()
        AchievementFrame.Header.Points:SetPoint('TOP', AchievementFrame, 0, -3)

        for i = 1, 3 do
            local tab = _G['AchievementFrameTab' .. i]
            if tab then
                F.ReskinTab(tab)

                if i ~= 1 then
                    tab:ClearAllPoints()
                    tab:SetPoint('TOPLEFT', _G['AchievementFrameTab' .. (i - 1)], 'TOPRIGHT', -15, 0)
                end
            end
        end

        F.ReskinDropDown(AchievementFrameFilterDropDown)
        AchievementFrameFilterDropDown:ClearAllPoints()
        AchievementFrameFilterDropDown:SetPoint('TOPRIGHT', -120, 0)
        AchievementFrameFilterDropDownText:ClearAllPoints()
        AchievementFrameFilterDropDownText:SetPoint('CENTER', -10, 1)
        F.ReskinClose(_G.AchievementFrameCloseButton)

        -- Search box
        F.ReskinInput(AchievementFrame.SearchBox)
        AchievementFrame.SearchBox:ClearAllPoints()
        AchievementFrame.SearchBox:SetPoint('TOPRIGHT', AchievementFrame, 'TOPRIGHT', -25, -5)
        AchievementFrame.SearchBox:SetPoint('BOTTOMLEFT', AchievementFrame, 'TOPRIGHT', -130, -25)

        local previewContainer = AchievementFrame.SearchPreviewContainer
        local showAllSearchResults = previewContainer.ShowAllSearchResults
        F.StripTextures(previewContainer)
        previewContainer:ClearAllPoints()
        previewContainer:SetPoint('TOPLEFT', AchievementFrame, 'TOPRIGHT', 7, -2)
        local bg = F.SetBD(previewContainer)
        bg:SetPoint('TOPLEFT', -3, 3)
        bg:SetPoint('BOTTOMRIGHT', showAllSearchResults, 3, -3)

        for i = 1, 5 do
            F.StyleSearchButton(previewContainer['SearchPreview' .. i])
        end
        F.StyleSearchButton(showAllSearchResults)

        local result = AchievementFrame.SearchResults
        result:SetPoint('BOTTOMLEFT', AchievementFrame, 'BOTTOMRIGHT', 15, -1)
        F.StripTextures(result)
        local rbg = F.SetBD(result)
        rbg:SetPoint('TOPLEFT', -10, 0)
        rbg:SetPoint('BOTTOMRIGHT')

        F.ReskinClose(result.CloseButton)
        F.ReskinTrimScroll(result.ScrollBar)
        hooksecurefunc(result.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    F.StripTextures(child, 2)
                    F.ReskinIcon(child.Icon)
                    local bg = F.CreateBDFrame(child, 0.25)
                    bg:SetInside()
                    SetupButtonHighlight(child, bg)

                    child.styled = true
                end
            end
        end)

        -- AchievementFrameCategories
        F.StripTextures(_G.AchievementFrameCategories)
        F.ReskinTrimScroll(_G.AchievementFrameCategories.ScrollBar)
        hooksecurefunc(_G.AchievementFrameCategories.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                local button = child.Button
                if button and not button.styled then
                    button.Background:Hide()
                    local bg = F.CreateBDFrame(button, 0.25)
                    bg:SetPoint('TOPLEFT', 0, -1)
                    bg:SetPoint('BOTTOMRIGHT')
                    SetupButtonHighlight(button, bg)

                    button.styled = true
                end
            end
        end)

        F.StripTextures(_G.AchievementFrameAchievements)
        F.ReskinTrimScroll(_G.AchievementFrameAchievements.ScrollBar)
        select(3, _G.AchievementFrameAchievements:GetChildren()):Hide()

        local function updateAccountString(button)
            if button.DateCompleted:IsShown() then
                if button.accountWide then
                    button.Label:SetTextColor(0, 0.6, 1)
                else
                    button.Label:SetTextColor(0.9, 0.9, 0.9)
                end
            else
                if button.accountWide then
                    button.Label:SetTextColor(0, 0.3, 0.5)
                else
                    button.Label:SetTextColor(0.65, 0.65, 0.65)
                end
            end
        end

        hooksecurefunc(_G.AchievementFrameAchievements.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if child and not child.styled then
                    F.StripTextures(child, true)
                    child.Background:SetAlpha(0)
                    child.Highlight:SetAlpha(0)
                    child.Icon.frame:Hide()
                    child.Description:SetTextColor(0.9, 0.9, 0.9)
                    child.Description.SetTextColor = nop

                    local bg = F.CreateBDFrame(child, 0.25)
                    bg:SetPoint('TOPLEFT', 1, -1)
                    bg:SetPoint('BOTTOMRIGHT', 0, 2)
                    F.ReskinIcon(child.Icon.texture)

                    F.ReskinCheckbox(child.Tracked)
                    child.Tracked:SetSize(20, 20)
                    child.Check:SetAlpha(0)

                    hooksecurefunc(child, 'UpdatePlusMinusTexture', updateAccountString)

                    child.styled = true
                end
            end
        end)

        F.StripTextures(_G.AchievementFrameSummary)
        _G.AchievementFrameSummary:GetChildren():Hide()
        _G.AchievementFrameSummaryAchievementsHeaderHeader:SetVertexColor(1, 1, 1, 0.25)
        _G.AchievementFrameSummaryCategoriesHeaderTexture:SetVertexColor(1, 1, 1, 0.25)

        hooksecurefunc('AchievementFrameSummary_UpdateAchievements', function()
            for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
                local bu = _G['AchievementFrameSummaryAchievement' .. i]
                if bu.accountWide then
                    bu.Label:SetTextColor(0, 0.6, 1)
                else
                    bu.Label:SetTextColor(0.9, 0.9, 0.9)
                end

                if not bu.styled then
                    bu:DisableDrawLayer('BORDER')
                    bu:HideBackdrop()

                    local bd = bu.Background
                    bd:SetTexture(C.Assets.Textures.Backdrop)
                    bd:SetVertexColor(0, 0, 0, 0.25)

                    bu.TitleBar:Hide()
                    bu.Glow:Hide()
                    bu.Highlight:SetAlpha(0)
                    bu.Icon.frame:Hide()
                    F.ReskinIcon(bu.Icon.texture)

                    local bg = F.CreateBDFrame(bu, 0)
                    bg:SetPoint('TOPLEFT', 2, -2)
                    bg:SetPoint('BOTTOMRIGHT', -2, 2)

                    bu.styled = true
                end

                bu.Description:SetTextColor(0.9, 0.9, 0.9)
            end
        end)

        for i = 1, 12 do
            local bu = _G['AchievementFrameSummaryCategoriesCategory' .. i]
            F.StripTextures(bu)
            bu:SetStatusBarTexture(C.Assets.Textures.Backdrop)
            bu:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(0, 0.4, 0, 1), CreateColor(0, 0.6, 0, 1))
            F.CreateBDFrame(bu, 0.25)

            bu.Label:SetTextColor(1, 1, 1)
            bu.Label:SetPoint('LEFT', bu, 'LEFT', 6, 0)
            bu.Text:SetPoint('RIGHT', bu, 'RIGHT', -5, 0)
            _G[bu:GetName() .. 'ButtonHighlight']:SetAlpha(0)
        end

        local bar = _G.AchievementFrameSummaryCategoriesStatusBar
        if bar then
            F.StripTextures(bar)
            bar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
            bar:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(0, 0.4, 0, 1), CreateColor(0, 0.6, 0, 1))
            F.CreateBDFrame(bar, 0.25)
            _G[bar:GetName() .. 'Title']:SetPoint('LEFT', bar, 'LEFT', 6, 0)
            _G[bar:GetName() .. 'Text']:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)
        end

        _G.AchievementFrameSummaryAchievementsEmptyText:SetText('')

        -- Summaries
        _G.AchievementFrameStatsBG:Hide()
        select(4, _G.AchievementFrameStats:GetChildren()):Hide()
        F.ReskinTrimScroll(_G.AchievementFrameStats.ScrollBar)
        hooksecurefunc(_G.AchievementFrameStats.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    F.StripTextures(child)
                    local bg = F.CreateBDFrame(child, 0.25)
                    bg:SetPoint('TOPLEFT', 2, -C.MULT)
                    bg:SetPoint('BOTTOMRIGHT', 4, C.MULT)
                    SetupButtonHighlight(child, bg)

                    child.styled = true
                end
            end
        end)

        -- Comparison

        _G.AchievementFrameComparisonHeaderBG:Hide()
        _G.AchievementFrameComparisonHeaderPortrait:Hide()
        _G.AchievementFrameComparisonHeaderPortraitBg:Hide()
        _G.AchievementFrameComparisonHeader:SetPoint('BOTTOMRIGHT', _G.AchievementFrameComparison, 'TOPRIGHT', 39, 26)
        local headerbg = F.SetBD(_G.AchievementFrameComparisonHeader)
        headerbg:SetPoint('TOPLEFT', 20, -20)
        headerbg:SetPoint('BOTTOMRIGHT', -28, -5)

        F.StripTextures(_G.AchievementFrameComparison)
        select(5, _G.AchievementFrameComparison:GetChildren()):Hide()
        F.ReskinTrimScroll(_G.AchievementFrameComparison.AchievementContainer.ScrollBar)

        local function handleCompareSummary(frame)
            F.StripTextures(frame)
            local bar = frame.StatusBar
            F.StripTextures(bar)
            bar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
            bar:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(0, 0.4, 0, 1), CreateColor(0, 0.6, 0, 1))
            bar.Title:SetTextColor(1, 1, 1)
            bar.Title:SetPoint('LEFT', bar, 'LEFT', 6, 0)
            bar.Text:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)
            F.CreateBDFrame(bar, 0.25)
        end
        handleCompareSummary(_G.AchievementFrameComparison.Summary.Player)
        handleCompareSummary(_G.AchievementFrameComparison.Summary.Friend)

        local function handleCompareCategory(button)
            button:DisableDrawLayer('BORDER')
            button:HideBackdrop()
            button.Background:Hide()
            local bg = F.CreateBDFrame(button, 0.25)
            bg:SetInside(button, 2, 2)

            button.TitleBar:Hide()
            button.Glow:Hide()
            button.Icon.frame:Hide()
            F.ReskinIcon(button.Icon.texture)
        end

        hooksecurefunc(_G.AchievementFrameComparison.AchievementContainer.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    handleCompareCategory(child.Player)
                    child.Player.Description:SetTextColor(0.9, 0.9, 0.9)
                    child.Player.Description.SetTextColor = nop
                    handleCompareCategory(child.Friend)

                    child.styled = true
                end
            end
        end)
    else
        local AchievementFrame = _G.AchievementFrame

        F.StripTextures(AchievementFrame, true)
        F.SetBD(AchievementFrame)
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

        _G.AchievementFrameHeaderPoints:SetPoint('TOP', AchievementFrame, 'TOP', 0, -6)
        _G.AchievementFrameFilterDropDown:ClearAllPoints()
        _G.AchievementFrameFilterDropDown:SetPoint('TOPRIGHT', -120, 0)
        _G.AchievementFrameFilterDropDownText:ClearAllPoints()
        _G.AchievementFrameFilterDropDownText:SetPoint('CENTER', -10, 1)

        F.StripTextures(_G.AchievementFrameSummaryCategoriesStatusBar)
        _G.AchievementFrameSummaryCategoriesStatusBar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
        _G.AchievementFrameSummaryCategoriesStatusBar:GetStatusBarTexture():SetGradient('VERTICAL', 0, 0.4, 0, 0, 0.6, 0)
        _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetTextColor(1, 1, 1)
        _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint('LEFT', _G.AchievementFrameSummaryCategoriesStatusBar, 'LEFT', 6, 0)
        _G.AchievementFrameSummaryCategoriesStatusBarText:SetPoint('RIGHT', _G.AchievementFrameSummaryCategoriesStatusBar, 'RIGHT', -5, 0)
        F.CreateBDFrame(_G.AchievementFrameSummaryCategoriesStatusBar, 0.25)

        for i = 1, 3 do
            local tab = _G['AchievementFrameTab' .. i]
            if tab then
                F.ReskinTab(tab)
            end
        end

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
            ch:SetHighlightTexture(C.Assets.Textures.Backdrop)

            local check = ch:GetCheckedTexture()
            check:SetDesaturated(true)
            check:SetVertexColor(C.r, C.g, C.b)

            local chbg = F.CreateBDFrame(ch, 0, true)
            chbg:SetPoint('TOPLEFT', 2, -2)
            chbg:SetPoint('BOTTOMRIGHT', -2, 2)

            local hl = ch:GetHighlightTexture()
            hl:SetInside(chbg)
            hl:SetVertexColor(C.r, C.g, C.b, 0.25)
        end

        _G.AchievementFrameAchievementsContainerButton1.background:SetPoint('TOPLEFT', _G.AchievementFrameAchievementsContainerButton1, 'TOPLEFT', 2, -3)

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
                bar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
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
                    bd:SetTexture(C.Assets.Textures.Backdrop)
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
            bu:SetStatusBarTexture(C.Assets.Textures.Backdrop)
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

        local summaries = {
            _G.AchievementFrameComparisonSummaryPlayer,
            _G.AchievementFrameComparisonSummaryFriend,
        }
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
            bar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
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
        F.ReskinInput(AchievementFrame.searchBox)
        AchievementFrame.searchBox:ClearAllPoints()
        AchievementFrame.searchBox:SetPoint('TOPRIGHT', AchievementFrame, 'TOPRIGHT', -25, -5)
        AchievementFrame.searchBox:SetPoint('BOTTOMLEFT', AchievementFrame, 'TOPRIGHT', -130, -25)

        local showAllSearchResults = AchievementFrame.searchPreviewContainer.showAllSearchResults

        F.StripTextures(AchievementFrame.searchPreviewContainer)
        AchievementFrame.searchPreviewContainer:ClearAllPoints()
        AchievementFrame.searchPreviewContainer:SetPoint('TOPLEFT', AchievementFrame, 'TOPRIGHT', 7, -2)
        local bg = F.SetBD(AchievementFrame.searchPreviewContainer)
        bg:SetPoint('TOPLEFT', -3, 3)
        bg:SetPoint('BOTTOMRIGHT', showAllSearchResults, 3, -3)

        for i = 1, 5 do
            F.StyleSearchButton(AchievementFrame.searchPreviewContainer['searchPreview' .. i])
        end
        F.StyleSearchButton(showAllSearchResults)

        do
            local result = AchievementFrame.searchResults
            result:SetPoint('BOTTOMLEFT', AchievementFrame, 'BOTTOMRIGHT', 15, -1)
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
end
