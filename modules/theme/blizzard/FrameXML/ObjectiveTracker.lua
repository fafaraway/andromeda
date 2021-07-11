local F, C = unpack(select(2, ...))

local function ReskinQuestIcon(button)
    if not button then
        return
    end

    if not button.styled then
        button:SetSize(20, 20)
        button:SetNormalTexture('')
        button:SetPushedTexture('')
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
        local icon = button.icon or button.Icon
        if icon then
            button.bg = F.ReskinIcon(icon, true)
            icon:SetInside()
        end

        button.styled = true
    end

    if button.bg then
        button.bg:SetFrameLevel(0)
    end
end

local function ReskinQuestIcons(_, block)
    ReskinQuestIcon(block.itemButton)
    ReskinQuestIcon(block.groupFinderButton)
end

local function ReskinHeader(header)
    header.Text:SetTextColor(C.r, C.g, C.b)
    header.Background:SetTexture(nil)
    local bg = header:CreateTexture(nil, 'ARTWORK')
    bg:SetTexture('Interface\\LFGFrame\\UI-LFG-SEPARATOR')
    bg:SetTexCoord(0, .66, 0, .31)
    bg:SetVertexColor(C.r, C.g, C.b, .8)
    bg:SetPoint('BOTTOMLEFT', 0, -4)
    bg:SetSize(250, 30)
    header.bg = bg -- accessable for other addons
end

local function ReskinBarTemplate(bar)
    if bar.bg then
        return
    end

    if not bar.styled then
        F.StripTextures(bar)
        bar:SetStatusBarTexture(C.Assets.statusbar_tex)
        bar:SetStatusBarColor(C.r, C.g, C.b)
        bar.bg = F.SetBD(bar)
        F:SmoothBar(bar)

        bar.styled = true
    end
end

local function ReskinProgressbar(_, _, line)
    local progressBar = line.ProgressBar
    local bar = progressBar.Bar
    local label = bar.Label

    if not bar.bg then
        bar:ClearAllPoints()
        bar:SetPoint('LEFT')

        label:ClearAllPoints()
        label:SetPoint('CENTER', bar)
        label:SetFont(C.Assets.Fonts.Regular, 11, true)
        label:SetShadowColor(0, 0, 0, 1)
        label:SetShadowOffset(1, -1)

        ReskinBarTemplate(bar)
    end
end

local function ReskinProgressbarWithIcon(_, _, line)
    local progressBar = line.ProgressBar
    local bar = progressBar.Bar
    local icon = bar.Icon
    local label = bar.Label

    if not bar.bg then
        bar:SetPoint('LEFT', 22, 0)
        ReskinBarTemplate(bar)

        icon:SetMask(nil)
        icon.bg = F.ReskinIcon(icon, true)
        icon:ClearAllPoints()
        icon:SetSize(20, 20)
        icon:SetPoint('LEFT', bar, 'RIGHT', 5, 0)

        label:ClearAllPoints()
        label:SetPoint('CENTER', bar)
        label:SetFont(C.Assets.Fonts.Regular, 11, true)
        label:SetShadowColor(0, 0, 0, 1)
        label:SetShadowOffset(1, -1)
    end

    if icon.bg then
        icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
    end
end

local function ReskinTimerBar(_, _, line)
    local timerBar = line.TimerBar
    local bar = timerBar.Bar

    if not bar.bg then
        ReskinBarTemplate(bar)
    end
end

local function UpdateMinimizeButton(button, collapsed)
    button.__texture:DoCollapse(collapsed)
end

local function ReskinMinimizeButton(button)
    F.ReskinCollapse(button)
    button:GetNormalTexture():SetAlpha(0)
    button:GetPushedTexture():SetAlpha(0)
    button.__texture:DoCollapse(false)
    _G.hooksecurefunc(button, 'SetCollapsed', UpdateMinimizeButton)
end

local function GetMawBuffsAnchor(frame)
    local center = frame:GetCenter()
    if center and center < _G.GetScreenWidth() / 2 then
        return 'LEFT'
    else
        return 'RIGHT'
    end
end

local function Container_OnClick(container)
    local direc = GetMawBuffsAnchor(container)
    if not container.lastDirec or container.lastDirec ~= direc then
        container.List:ClearAllPoints()
        if direc == 'LEFT' then
            container.List:SetPoint('TOPLEFT', container, 'TOPRIGHT', 15, 1)
        else
            container.List:SetPoint('TOPRIGHT', container, 'TOPLEFT', 15, 1)
        end
        container.lastDirec = direc
    end
end

local function BlockList_Show(self)
    self.button:SetWidth(253)
    self.button:SetButtonState('NORMAL')
    self.button:SetPushedTextOffset(1.25, -1)
    self.button:SetButtonState('PUSHED', true)
    self.__bg:SetBackdropBorderColor(1, .8, 0, .7)
end

local function BlockList_Hide(self)
    self.__bg:SetBackdropBorderColor(0, 0, 0, 1)
end

local function ReskinMawBuffsContainer(container)
    F.StripTextures(container)
    container:GetPushedTexture():SetAlpha(0)
    container:GetHighlightTexture():SetAlpha(0)
    local bg = F.SetBD(container, 0, 13, -11, -3, 11)
    F.CreateGradient(bg)
    container:HookScript('OnClick', Container_OnClick)

    local blockList = container.List
    F.StripTextures(blockList)
    blockList.__bg = bg
    local bg = F.SetBD(blockList)
    bg:SetPoint('TOPLEFT', 7, -12)
    bg:SetPoint('BOTTOMRIGHT', -7, 12)

    blockList:HookScript('OnShow', BlockList_Show)
    blockList:HookScript('OnHide', BlockList_Hide)
end

_G.tinsert(
    C.BlizzThemes,
    function()
        local r, g, b = C.r, C.g, C.b

        -- QuestIcons
        _G.hooksecurefunc(_G.QUEST_TRACKER_MODULE, 'SetBlockHeader', ReskinQuestIcons)
        _G.hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, 'AddObjective', ReskinQuestIcons)
        _G.hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE, 'AddObjective', ReskinQuestIcons)
        _G.hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, 'AddObjective', ReskinQuestIcons)

        -- Reskin Progressbars
        _G.hooksecurefunc(_G.QUEST_TRACKER_MODULE, 'AddProgressBar', ReskinProgressbar)
        _G.hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE, 'AddProgressBar', ReskinProgressbar)

        _G.hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE, 'AddProgressBar', ReskinProgressbarWithIcon)
        _G.hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE, 'AddProgressBar', ReskinProgressbarWithIcon)
        _G.hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, 'AddProgressBar', ReskinProgressbarWithIcon)

        _G.hooksecurefunc(_G.QUEST_TRACKER_MODULE, 'AddTimerBar', ReskinTimerBar)
        _G.hooksecurefunc(_G.SCENARIO_TRACKER_MODULE, 'AddTimerBar', ReskinTimerBar)
        _G.hooksecurefunc(_G.ACHIEVEMENT_TRACKER_MODULE, 'AddTimerBar', ReskinTimerBar)

        -- Reskin Blocks
        _G.hooksecurefunc(
            'ScenarioStage_CustomizeBlock',
            function(block)
                block.NormalBG:SetTexture('')
                if not block.bg then
                    block.bg = F.SetBD(block.GlowTexture, nil, 4, -2, -4, 2)
                end
            end
        )

        _G.hooksecurefunc(
            _G.SCENARIO_CONTENT_TRACKER_MODULE,
            'Update',
            function()
                local widgetContainer = _G.ScenarioStageBlock.WidgetContainer
                if widgetContainer.widgetFrames then
                    for _, widgetFrame in pairs(widgetContainer.widgetFrames) do
                        if widgetFrame.Frame then
                            widgetFrame.Frame:SetAlpha(0)
                        end

                        local bar = widgetFrame.TimerBar
                        if bar and not bar.bg then
                            _G.hooksecurefunc(bar, 'SetStatusBarAtlas', F.ReplaceWidgetBarTexture)
                            bar.bg = F.CreateBDFrame(bar, .25)
                        end

                        if widgetFrame.CurrencyContainer then
                            for currencyFrame in widgetFrame.currencyPool:EnumerateActive() do
                                if not currencyFrame.bg then
                                    currencyFrame.bg = F.ReskinIcon(currencyFrame.Icon)
                                end
                            end
                        end
                    end
                end
            end
        )

        _G.hooksecurefunc(
            'Scenario_ChallengeMode_ShowBlock',
            function()
                local block = _G.ScenarioChallengeModeBlock
                if not block.bg then
                    block.TimerBG:Hide()
                    block.TimerBGBack:Hide()
                    block.timerbg = F.CreateBDFrame(block.TimerBGBack, .3)
                    block.timerbg:SetPoint('TOPLEFT', block.TimerBGBack, 6, -2)
                    block.timerbg:SetPoint('BOTTOMRIGHT', block.TimerBGBack, -6, -5)

                    block.StatusBar:SetStatusBarTexture(C.Assets.statusbar_tex)
                    block.StatusBar:SetStatusBarColor(r, g, b)
                    block.StatusBar:SetHeight(10)

                    select(3, block:GetRegions()):Hide()
                    block.bg = F.SetBD(block, nil, 4, -2, -4, 0)
                end
            end
        )

        _G.hooksecurefunc('Scenario_ChallengeMode_SetUpAffixes', F.AffixesSetup)

        -- Maw buffs container
        ReskinMawBuffsContainer(_G.ScenarioBlocksFrame.MawBuffsBlock.Container)
        ReskinMawBuffsContainer(_G.MawBuffsBelowMinimapFrame.Container)

        -- Reskin Headers
        local headers = {
            _G.ObjectiveTrackerBlocksFrame.QuestHeader,
            _G.ObjectiveTrackerBlocksFrame.AchievementHeader,
            _G.ObjectiveTrackerBlocksFrame.ScenarioHeader,
            _G.ObjectiveTrackerBlocksFrame.CampaignQuestHeader,
            _G.BONUS_OBJECTIVE_TRACKER_MODULE.Header,
            _G.WORLD_QUEST_TRACKER_MODULE.Header,
            _G.ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader
        }

        for _, header in pairs(headers) do
            ReskinHeader(header)
        end

        -- Minimize Button
        local mainMinimize = _G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
        ReskinMinimizeButton(mainMinimize)
        mainMinimize.bg:SetBackdropBorderColor(1, .8, 0, .5)

        for _, header in pairs(headers) do
            local minimize = header.MinimizeButton
            if minimize then
                ReskinMinimizeButton(minimize)
            end
        end
    end
)
