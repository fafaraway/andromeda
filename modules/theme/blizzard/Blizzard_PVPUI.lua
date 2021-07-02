local _G = _G
local unpack = unpack
local select = select
local hooksecurefunc = hooksecurefunc
local GetItemInfo = GetItemInfo
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local CurrencyContainerUtil_GetCurrencyContainerInfo = CurrencyContainerUtil.GetCurrencyContainerInfo

local F, C = unpack(select(2, ...))

local function ReskinPvPFrame(frame)
    frame:DisableDrawLayer('BACKGROUND')
    frame:DisableDrawLayer('BORDER')
    F.ReskinRole(frame.TankIcon, 'TANK')
    F.ReskinRole(frame.HealerIcon, 'HEALER')
    F.ReskinRole(frame.DPSIcon, 'DPS')

    local bar = frame.ConquestBar
    F.StripTextures(bar)
    F.CreateBDFrame(bar, .25)
    bar:SetStatusBarTexture(C.Assets.bd_tex)
    bar:GetStatusBarTexture():SetGradient('VERTICAL', 1, .8, 0, 6, .4, 0)

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

    local iconSize = 60 - 2 * C.Mult
    for i = 1, 3 do
        local bu = PVPQueueFrame['CategoryButton' .. i]
        local icon = bu.Icon
        local cu = bu.CurrencyDisplay

        bu.Ring:Hide()
        F.Reskin(bu, true)
        bu.Background:SetInside(bu.__bg)
        bu.Background:SetColorTexture(r, g, b, .25)

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

    hooksecurefunc(
        'PVPQueueFrame_SelectButton',
        function(index)
            local self = PVPQueueFrame
            for i = 1, 3 do
                local bu = self['CategoryButton' .. i]
                if i == index then
                    bu.Background:SetAlpha(1)
                else
                    bu.Background:SetAlpha(0)
                end
            end
        end
    )

    PVPQueueFrame.CategoryButton1.Background:SetAlpha(1)
    F.StripTextures(PVPQueueFrame.HonorInset)

    local popup = PVPQueueFrame.NewSeasonPopup
    F.Reskin(popup.Leave)
    popup.Leave.__bg:SetFrameLevel(popup:GetFrameLevel() + 1)
    popup.NewSeason:SetTextColor(1, .8, 0)
    popup.SeasonRewardText:SetTextColor(1, .8, 0)
    popup.SeasonDescriptionHeader:SetTextColor(1, 1, 1)
    popup:HookScript(
        'OnShow',
        function(self)
            for _, description in pairs(self.SeasonDescriptions) do
                description:SetTextColor(1, 1, 1)
            end
        end
    )

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
    F.ReskinScroll(_G.HonorFrameSpecificFrameScrollBar)

    local bonusFrame = HonorFrame.BonusFrame
    bonusFrame.WorldBattlesTexture:Hide()
    bonusFrame.ShadowOverlay:Hide()

    for _, bonusButton in pairs({'RandomBGButton', 'RandomEpicBGButton', 'Arena1Button', 'BrawlButton', 'SpecialEventButton'}) do
        local bu = bonusFrame[bonusButton]
        F.Reskin(bu, true)
        bu.SelectedTexture:SetDrawLayer('BACKGROUND')
        bu.SelectedTexture:SetColorTexture(r, g, b, .25)
        bu.SelectedTexture:SetInside(bu.__bg)

        local reward = bu.Reward
        if reward then
            reward.Border:Hide()
            reward.CircleMask:Hide()
            reward.Icon.bg = F.ReskinIcon(reward.Icon)
        end
    end

    -- Honor frame specific

    for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
        bu.Bg:Hide()
        bu.Border:Hide()

        bu:SetNormalTexture('')
        bu:SetHighlightTexture('')

        local bg = F.CreateBDFrame(bu, 0, true)
        bg:SetPoint('TOPLEFT', 2, 0)
        bg:SetPoint('BOTTOMRIGHT', -1, 2)

        bu.SelectedTexture:SetDrawLayer('BACKGROUND')
        bu.SelectedTexture:SetColorTexture(r, g, b, .25)
        bu.SelectedTexture:SetInside(bg)

        F.ReskinIcon(bu.Icon)
        bu.Icon:SetPoint('TOPLEFT', 5, -3)
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

    for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.RatedBG}) do
        F.Reskin(bu, true)
        local reward = bu.Reward
        if reward then
            reward.Border:Hide()
            reward.CircleMask:Hide()
            reward.Icon.bg = F.ReskinIcon(reward.Icon)
        end

        bu.SelectedTexture:SetDrawLayer('BACKGROUND')
        bu.SelectedTexture:SetColorTexture(r, g, b, .25)
        bu.SelectedTexture:SetInside(bu.__bg)
    end

    -- Item Borders for HonorFrame & ConquestFrame

    hooksecurefunc(
        'PVPUIFrame_ConfigureRewardFrame',
        function(rewardFrame, _, _, itemRewards, currencyRewards)
            local rewardTexture, rewardQuaility = nil, 1

            if currencyRewards then
                for _, reward in ipairs(currencyRewards) do
                    local info = C_CurrencyInfo_GetCurrencyInfo(reward.id)
                    local name, texture, quality = info.name, info.iconFileID, info.quality
                    if quality == _G.LE_ITEM_QUALITY_ARTIFACT then
                        _, rewardTexture, _, rewardQuaility = CurrencyContainerUtil_GetCurrencyContainerInfo(reward.id, reward.quantity, name, texture, quality)
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
        end
    )
end
