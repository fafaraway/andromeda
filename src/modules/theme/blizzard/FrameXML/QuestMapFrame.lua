local F, C = unpack(select(2, ...))

local function ReskinQuestHeader(header, isCalling)
    if header.styled then
        return
    end

    if header.Background then
        header.Background:SetAlpha(0.7)
    end
    if header.Divider then
        header.Divider:Hide()
    end
    if header.TopFiligree then
        header.TopFiligree:Hide()
    end

    local collapseButton = isCalling and header or header.CollapseButton
    if collapseButton then
        collapseButton:GetPushedTexture():SetAlpha(0)
        collapseButton:GetHighlightTexture():SetAlpha(0)
        F.ReskinCollapse(collapseButton, true)
        collapseButton.bg:SetFrameLevel(6)
    end

    header.styled = true
end

local function ReskinSessionDialog(_, dialog)
    if not dialog.styled then
        F.StripTextures(dialog)
        F.SetBD(dialog)
        F.ReskinButton(dialog.ButtonContainer.Confirm)
        F.ReskinButton(dialog.ButtonContainer.Decline)
        if dialog.MinimizeButton then
            F.ReskinArrow(dialog.MinimizeButton, 'down')
        end

        dialog.styled = true
    end
end

local function ReskinAWQHeader()
    if IsAddOnLoaded('AngrierWorldQuests') then
        local button = _G['AngrierWorldQuestsHeader']
        if button and not button.styled then
            F.ReskinCollapse(button, true)
            button:GetPushedTexture():SetAlpha(0)
            button:GetHighlightTexture():SetAlpha(0)

            button.styled = true
        end
    end
end

tinsert(C.BlizzThemes, function()
    -- Quest frame

    local QuestMapFrame = _G.QuestMapFrame
    QuestMapFrame.VerticalSeparator:SetAlpha(0)
    QuestMapFrame.Background:SetAlpha(0)

    local QuestScrollFrame = _G.QuestScrollFrame
    QuestScrollFrame.DetailFrame.TopDetail:SetAlpha(0)
    QuestScrollFrame.DetailFrame.BottomDetail:SetAlpha(0)
    QuestScrollFrame.Contents.Separator:SetAlpha(0)
    ReskinQuestHeader(QuestScrollFrame.Contents.StoryHeader)

    local campaignOverview = QuestMapFrame.CampaignOverview
    campaignOverview.BG:SetAlpha(0)
    ReskinQuestHeader(campaignOverview.Header)

    if C.IS_NEW_PATCH_10_1 then
        F.ReskinTrimScroll(QuestScrollFrame.ScrollBar)
        F.ReskinTrimScroll(campaignOverview.ScrollFrame.ScrollBar)
    else
        F.ReskinScroll(QuestScrollFrame.ScrollBar)
        F.ReskinScroll(campaignOverview.ScrollFrame.ScrollBar)
    end

    -- Quest details

    local DetailsFrame = QuestMapFrame.DetailsFrame
    local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

    F.StripTextures(DetailsFrame)
    F.StripTextures(DetailsFrame.RewardsFrame)
    F.StripTextures(DetailsFrame.ShareButton)
    DetailsFrame.Bg:SetAlpha(0)
    DetailsFrame.SealMaterialBG:SetAlpha(0)

    F.ReskinButton(DetailsFrame.BackButton)
    F.ReskinButton(DetailsFrame.AbandonButton)
    F.ReskinButton(DetailsFrame.ShareButton)
    F.ReskinButton(DetailsFrame.TrackButton)
    if C.IS_NEW_PATCH_10_1 then
        F.ReskinTrimScroll(_G.QuestMapDetailsScrollFrame.ScrollBar)
    else
        F.ReskinScroll(_G.QuestMapDetailsScrollFrame.ScrollBar)
    end

    DetailsFrame.AbandonButton:ClearAllPoints()
    DetailsFrame.AbandonButton:SetPoint('BOTTOMLEFT', DetailsFrame, -1, 0)
    DetailsFrame.AbandonButton:SetWidth(95)

    DetailsFrame.ShareButton:ClearAllPoints()
    DetailsFrame.ShareButton:SetPoint('LEFT', DetailsFrame.AbandonButton, 'RIGHT', 1, 0)
    DetailsFrame.ShareButton:SetWidth(94)

    DetailsFrame.TrackButton:ClearAllPoints()
    DetailsFrame.TrackButton:SetPoint('LEFT', DetailsFrame.ShareButton, 'RIGHT', 1, 0)
    DetailsFrame.TrackButton:SetWidth(96)

    -- Scroll frame

    hooksecurefunc('QuestLogQuests_Update', function()
        for button in QuestScrollFrame.headerFramePool:EnumerateActive() do
            if button.ButtonText then
                if not button.styled then
                    F.ReskinCollapse(button, true)
                    button:GetPushedTexture():SetAlpha(0)
                    button:GetHighlightTexture():SetAlpha(0)

                    button.styled = true
                end
            end
        end

        for button in QuestScrollFrame.titleFramePool:EnumerateActive() do
            if not button.styled then
                button.Check:SetAtlas('checkmark-minimal')
                button.styled = true
            end
        end

        for header in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
            ReskinQuestHeader(header)
        end

        for header in QuestScrollFrame.campaignHeaderMinimalFramePool:EnumerateActive() do
            ReskinQuestHeader(header)
        end

        for header in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do
            ReskinQuestHeader(header, true)
        end

        ReskinAWQHeader()
    end)

    -- Complete quest frame
    F.StripTextures(CompleteQuestFrame)
    F.StripTextures(CompleteQuestFrame.CompleteButton)
    F.ReskinButton(CompleteQuestFrame.CompleteButton)

    -- [[ Quest log popup detail frame ]]

    local QuestLogPopupDetailFrame = _G.QuestLogPopupDetailFrame

    F.ReskinPortraitFrame(QuestLogPopupDetailFrame)
    F.ReskinButton(QuestLogPopupDetailFrame.AbandonButton)
    F.ReskinButton(QuestLogPopupDetailFrame.TrackButton)
    F.ReskinButton(QuestLogPopupDetailFrame.ShareButton)
    QuestLogPopupDetailFrame.SealMaterialBG:SetAlpha(0)
    if C.IS_NEW_PATCH_10_1 then
        F.ReskinTrimScroll(_G.QuestLogPopupDetailFrameScrollFrame.ScrollBar)
    else
        F.ReskinScroll(_G.QuestLogPopupDetailFrameScrollFrameScrollBar)
    end

    -- Show map button

    local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

    ShowMapButton.Texture:SetAlpha(0)
    ShowMapButton.Highlight:SetTexture('')
    ShowMapButton.Highlight:SetTexture('')

    ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
    ShowMapButton.Text:ClearAllPoints()
    ShowMapButton.Text:SetPoint('CENTER', 1, 0)

    ShowMapButton:ClearAllPoints()
    ShowMapButton:SetPoint('TOPRIGHT', QuestLogPopupDetailFrame, -30, -25)

    F.ReskinButton(ShowMapButton)

    ShowMapButton:HookScript('OnEnter', function(self)
        self.Text:SetTextColor(1, 1, 1)
    end)

    ShowMapButton:HookScript('OnLeave', function(self)
        self.Text:SetTextColor(1, 0.8, 0)
    end)

    -- Bottom buttons

    QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
    QuestLogPopupDetailFrame.ShareButton:SetPoint('LEFT', QuestLogPopupDetailFrame.AbandonButton, 'RIGHT', 1, 0)
    QuestLogPopupDetailFrame.ShareButton:SetPoint('RIGHT', QuestLogPopupDetailFrame.TrackButton, 'LEFT', -1, 0)

    -- Party Sync button

    local sessionManagement = QuestMapFrame.QuestSessionManagement
    sessionManagement.BG:Hide()
    F.CreateBDFrame(sessionManagement, 0.25)

    hooksecurefunc(_G.QuestSessionManager, 'NotifyDialogShow', ReskinSessionDialog)

    local executeSessionCommand = sessionManagement.ExecuteSessionCommand
    F.ReskinButton(executeSessionCommand)

    local icon = executeSessionCommand:CreateTexture(nil, 'ARTWORK')
    icon:SetInside()
    executeSessionCommand.normalIcon = icon

    local sessionCommandToButtonAtlas = {
        [_G.Enum.QuestSessionCommand.Start] = 'QuestSharing-DialogIcon',
        [_G.Enum.QuestSessionCommand.Stop] = 'QuestSharing-Stop-DialogIcon',
    }

    hooksecurefunc(QuestMapFrame.QuestSessionManagement, 'UpdateExecuteCommandAtlases', function(self, command)
        self.ExecuteSessionCommand:SetNormalTexture(0)
        self.ExecuteSessionCommand:SetPushedTexture(0)
        self.ExecuteSessionCommand:SetDisabledTexture(0)

        local atlas = sessionCommandToButtonAtlas[command]
        if atlas then
            self.ExecuteSessionCommand.normalIcon:SetAtlas(atlas)
        end
    end)
end)
