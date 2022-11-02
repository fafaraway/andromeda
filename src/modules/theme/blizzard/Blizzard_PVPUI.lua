local F, C = unpack(select(2, ...))

local function ReskinPvPFrame(frame)
    frame:DisableDrawLayer('BACKGROUND')
    frame:DisableDrawLayer('BORDER')
    F.ReskinRole(frame.TankIcon, 'TANK')
    F.ReskinRole(frame.HealerIcon, 'HEALER')
    F.ReskinRole(frame.DPSIcon, 'DPS')

    local bar = frame.ConquestBar
    F.StripTextures(bar)
    F.CreateBDFrame(bar, 0.25)
    bar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
    bar:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(1, 0.8, 0, 1), CreateColor(6, 0.4, 0, 1))

    local reward = bar.Reward
    reward.Ring:Hide()
    reward.CircleMask:Hide()
    F.ReskinIcon(reward.Icon)
end

local function ConquestFrameButton_OnEnter(self)
    _G.ConquestTooltip:ClearAllPoints()
    _G.ConquestTooltip:SetPoint('TOPLEFT', self, 'TOPRIGHT', 1, 0)
end

C.Themes['Blizzard_PVPUI'] = function()
    local r, g, b = C.r, C.g, C.b

    local PVPQueueFrame = _G.PVPQueueFrame
    local HonorFrame = _G.HonorFrame
    local ConquestFrame = _G.ConquestFrame

    -- Category buttons

    local iconSize = 60 - 2 * C.MULT
    for i = 1, 3 do
        local bu = PVPQueueFrame['CategoryButton' .. i]
        local icon = bu.Icon
        local cu = bu.CurrencyDisplay

        bu.Ring:Hide()
        F.Reskin(bu, true)
        bu.Background:SetInside(bu.__bg)
        bu.Background:SetColorTexture(r, g, b, 0.25)
        bu.Background:SetAlpha(1)

        icon:SetPoint('LEFT', bu, 'LEFT')
        icon:SetSize(iconSize, iconSize)
        F.ReskinIcon(icon)

        if cu then
            local ic = cu.Icon

            ic:SetSize(16, 16)
            ic:SetPoint('TOPLEFT', bu.Name, 'BOTTOMLEFT', 0, -8)
            cu.Amount:SetPoint('LEFT', ic, 'RIGHT', 4, 0)
            F.ReskinIcon(ic)
        end
    end

    PVPQueueFrame.CategoryButton1.Icon:SetTexture('Interface\\Icons\\achievement_bg_winwsg')
    PVPQueueFrame.CategoryButton2.Icon:SetTexture('Interface\\Icons\\achievement_bg_killxenemies_generalsroom')
    PVPQueueFrame.CategoryButton3.Icon:SetTexture('Interface\\Icons\\ability_warrior_offensivestance')

    hooksecurefunc('PVPQueueFrame_SelectButton', function(index)
        for i = 1, 3 do
            local bu = PVPQueueFrame['CategoryButton' .. i]
            if i == index then
                bu.Background:Show()
            else
                bu.Background:Hide()
            end
        end
    end)

    PVPQueueFrame.CategoryButton1.Background:SetAlpha(1)
    F.StripTextures(PVPQueueFrame.HonorInset)

    local popup = PVPQueueFrame.NewSeasonPopup
    F.Reskin(popup.Leave)
    popup.Leave.__bg:SetFrameLevel(popup:GetFrameLevel() + 1)
    popup.NewSeason:SetTextColor(1, 0.8, 0)
    popup.SeasonRewardText:SetTextColor(1, 0.8, 0)
    popup.SeasonDescriptionHeader:SetTextColor(1, 1, 1)
    popup:HookScript('OnShow', function(self)
        for _, description in pairs(self.SeasonDescriptions) do
            description:SetTextColor(1, 1, 1)
        end
    end)

    local SeasonRewardFrame = popup.SeasonRewardFrame
    SeasonRewardFrame.CircleMask:Hide()
    SeasonRewardFrame.Ring:Hide()
    local bg = F.ReskinIcon(SeasonRewardFrame.Icon)
    bg:SetFrameLevel(4)

    local seasonReward = PVPQueueFrame.HonorInset.RatedPanel.SeasonRewardFrame
    seasonReward.Ring:Hide()
    seasonReward.CircleMask:Hide()
    F.ReskinIcon(seasonReward.Icon)

    -- Honor frame

    HonorFrame.Inset:Hide()
    ReskinPvPFrame(HonorFrame)
    F.Reskin(HonorFrame.QueueButton)
    F.ReskinDropDown(_G.HonorFrameTypeDropDown)

    F.ReskinTrimScroll(HonorFrame.SpecificScrollBar)

    hooksecurefunc(HonorFrame.SpecificScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local button = select(i, self.ScrollTarget:GetChildren())
            if not button.styled then
                button.Bg:Hide()
                button.Border:Hide()
                button:SetNormalTexture(0)
                button:SetHighlightTexture(0)

                local bg = F.CreateBDFrame(button, 0.25)
                bg:SetPoint('TOPLEFT', 2, 0)
                bg:SetPoint('BOTTOMRIGHT', -1, 2)

                button.SelectedTexture:SetDrawLayer('BACKGROUND')
                button.SelectedTexture:SetColorTexture(r, g, b, 0.25)
                button.SelectedTexture:SetInside(bg)

                F.ReskinIcon(button.Icon)
                button.Icon:SetPoint('TOPLEFT', 5, -3)

                button.styled = true
            end
        end
    end)

    local bonusFrame = HonorFrame.BonusFrame
    bonusFrame.WorldBattlesTexture:Hide()
    bonusFrame.ShadowOverlay:Hide()

    for _, bonusButton in pairs({
        'RandomBGButton',
        'RandomEpicBGButton',
        'Arena1Button',
        'BrawlButton',
        'BrawlButton2',
    }) do
        local bu = bonusFrame[bonusButton]
        F.Reskin(bu, true)
        bu.SelectedTexture:SetDrawLayer('BACKGROUND')
        bu.SelectedTexture:SetColorTexture(r, g, b, 0.25)
        bu.SelectedTexture:SetInside(bu.__bg)

        local reward = bu.Reward
        if reward then
            reward.Border:Hide()
            reward.CircleMask:Hide()
            reward.Icon.bg = F.ReskinIcon(reward.Icon)
        end
    end

    -- Conquest Frame

    ReskinPvPFrame(ConquestFrame)
    ConquestFrame.Inset:Hide()
    ConquestFrame.RatedBGTexture:Hide()
    ConquestFrame.ShadowOverlay:Hide()

    ConquestFrame.Arena2v2:HookScript('OnEnter', ConquestFrameButton_OnEnter)
    ConquestFrame.Arena3v3:HookScript('OnEnter', ConquestFrameButton_OnEnter)
    ConquestFrame.RatedBG:HookScript('OnEnter', ConquestFrameButton_OnEnter)
    F.Reskin(ConquestFrame.JoinButton)

    local names = { 'RatedSoloShuffle', 'Arena2v2', 'Arena3v3', 'RatedBG' }
    for _, name in pairs(names) do
        local bu = ConquestFrame[name]
        if bu then
            F.Reskin(bu, true)
            local reward = bu.Reward
            if reward then
                reward.Border:Hide()
                reward.CircleMask:Hide()
                reward.Icon.bg = F.ReskinIcon(reward.Icon)
            end

            bu.SelectedTexture:SetDrawLayer('BACKGROUND')
            bu.SelectedTexture:SetColorTexture(r, g, b, 0.25)
            bu.SelectedTexture:SetInside(bu.__bg)
        end
    end

    -- Item Borders for HonorFrame & ConquestFrame

    hooksecurefunc('PVPUIFrame_ConfigureRewardFrame', function(rewardFrame, _, _, itemRewards, currencyRewards)
        local rewardTexture, rewardQuaility = nil, 1

        if currencyRewards then
            for _, reward in ipairs(currencyRewards) do
                local info = C_CurrencyInfo.GetCurrencyInfo(reward.id)
                local name, texture, quality = info.name, info.iconFileID, info.quality
                if quality == Enum.ItemQuality.Artifact then
                    _, rewardTexture, _, rewardQuaility = _G.CurrencyContainerUtil_GetCurrencyContainerInfo(reward.id, reward.quantity, name, texture, quality)
                end
            end
        end

        if not rewardTexture and itemRewards then
            local reward = itemRewards[1]
            if reward then
                _, _, rewardQuaility, _, _, _, _, _, _, rewardTexture = GetItemInfo(reward.id)
            end
        end

        if rewardTexture then
            rewardFrame.Icon:SetTexture(rewardTexture)
            local color = C.QualityColors[rewardQuaility]
            rewardFrame.Icon.bg:SetBackdropBorderColor(color.r, color.g, color.b)
        end
    end)
end
