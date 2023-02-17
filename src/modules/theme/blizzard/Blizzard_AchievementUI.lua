local F, C = unpack(select(2, ...))

local function SetupButtonHighlight(button, bg)
    button:SetHighlightTexture(C.Assets.Textures.Backdrop)
    local hl = button:GetHighlightTexture()
    hl:SetVertexColor(C.r, C.g, C.b, 0.25)
    hl:SetInside(bg)
end

local function SetupStatusbar(bar)
    F.StripTextures(bar)
    bar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
    bar:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(0, 0.4, 0, 1), CreateColor(0, 0.6, 0, 1))
    F.CreateBDFrame(bar, 0.25)
end

C.Themes['Blizzard_AchievementUI'] = function()
    local AchievementFrame = _G.AchievementFrame

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
                tab:SetPoint('TOPLEFT', _G['AchievementFrameTab' .. (i - 1)], 'TOPRIGHT', -10, 0)
            end
        end
    end

    F.ReskinDropDown(_G.AchievementFrameFilterDropDown)
    _G.AchievementFrameFilterDropDown:ClearAllPoints()
    _G.AchievementFrameFilterDropDown:SetPoint('TOPRIGHT', -120, 0)
    _G.AchievementFrameFilterDropDownText:ClearAllPoints()
    _G.AchievementFrameFilterDropDownText:SetPoint('CENTER', -10, 1)
    F.ReskinClose(_G.AchievementFrameCloseButton)

    -- Search box
    F.ReskinEditBox(AchievementFrame.SearchBox)
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

    local function updateProgressBars(frame)
        local objectives = frame:GetObjectiveFrame()
        if objectives and objectives.progressBars then
            for _, bar in next, objectives.progressBars do
                if not bar.styled then
                    SetupStatusbar(bar)
                    bar.styled = true
                end
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

                F.ReskinCheckButton(child.Tracked)
                child.Tracked:SetSize(20, 20)
                child.Check:SetAlpha(0)

                hooksecurefunc(child, 'UpdatePlusMinusTexture', updateAccountString)
                hooksecurefunc(child, 'DisplayObjectives', updateProgressBars)

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
        SetupStatusbar(bu)
        bu.Label:SetTextColor(1, 1, 1)
        bu.Label:SetPoint('LEFT', bu, 'LEFT', 6, 0)
        bu.Text:SetPoint('RIGHT', bu, 'RIGHT', -5, 0)
        _G[bu:GetName() .. 'ButtonHighlight']:SetAlpha(0)
    end

    local bar = _G.AchievementFrameSummaryCategoriesStatusBar
    if bar then
        SetupStatusbar(bar)
        _G[bar:GetName() .. 'Title']:SetPoint('LEFT', bar, 'LEFT', 6, 0)
        _G[bar:GetName() .. 'Text']:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)
    end

    _G.AchievementFrameSummaryAchievementsEmptyText:SetText('')

    hooksecurefunc('AchievementObjectives_DisplayCriteria', function(objectivesFrame, id)
        local numCriteria = GetAchievementNumCriteria(id)
        local textStrings, metas, criteria, object = 0, 0
        for i = 1, numCriteria do
            local _, criteriaType, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
            if assetID and criteriaType == _G.CRITERIA_TYPE_ACHIEVEMENT then
                metas = metas + 1
                criteria, object = objectivesFrame:GetMeta(metas), 'Label'
            elseif criteriaType ~= 1 then
                textStrings = textStrings + 1
                criteria, object = objectivesFrame:GetCriteria(textStrings), 'Name'
            end

            local text = criteria and criteria[object]
            if text and completed and objectivesFrame.completed then
                text:SetTextColor(1, 1, 1)
            end
        end
    end)

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
        SetupStatusbar(bar)
        bar.Title:SetTextColor(1, 1, 1)
        bar.Title:SetPoint('LEFT', bar, 'LEFT', 6, 0)
        bar.Text:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)
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
end
