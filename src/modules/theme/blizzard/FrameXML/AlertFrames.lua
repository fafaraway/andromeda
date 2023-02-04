local F, C = unpack(select(2, ...))

-- Fix Alertframe bg
local function fixBg(frame)
    local color = _G.ANDROMEDA_ADB.BackdropColor
    local alpha = _G.ANDROMEDA_ADB.BackdropAlpha
    if frame:IsObjectType('AnimationGroup') then
        frame = frame:GetParent()
    end
    if frame.bg then
        frame.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
        if frame.bg.__shadow then
            frame.bg.__shadow:SetBackdropBorderColor(0, 0, 0, 0.25)
        end
    end
end

local function fixParentbg(anim)
    local color = _G.ANDROMEDA_ADB.BackdropColor
    local alpha = _G.ANDROMEDA_ADB.BackdropAlpha
    local frame = anim.__owner
    if frame.bg then
        frame.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
        if frame.bg.__shadow then
            frame.bg.__shadow:SetBackdropBorderColor(0, 0, 0, 0.25)
        end
    end
end

local function fixAnim(frame)
    if frame.hooked then
        return
    end

    frame:HookScript('OnEnter', fixBg)
    frame:HookScript('OnShow', fixBg)
    frame.animIn:HookScript('OnFinished', fixBg)
    if frame.animArrows then
        frame.animArrows:HookScript('OnPlay', fixBg)
        frame.animArrows:HookScript('OnFinished', fixBg)
    end
    if frame.Arrows and frame.Arrows.ArrowsAnim then
        frame.Arrows.ArrowsAnim.__owner = frame
        frame.Arrows.ArrowsAnim:HookScript('OnPlay', fixParentbg)
        frame.Arrows.ArrowsAnim:HookScript('OnFinished', fixParentbg)
    end

    frame.hookded = true
end

tinsert(C.BlizzThemes, function()
    -- AlertFrames
    hooksecurefunc('AlertFrame_PauseOutAnimation', fixBg)

    local AlertTemplateFunc = {
        [_G.AchievementAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.Unlocked:SetTextColor(1, 0.8, 0)
                frame.Unlocked:SetFontObject(_G.NumberFont_GameNormal)
                frame.GuildName:ClearAllPoints()
                frame.GuildName:SetPoint('TOPLEFT', 50, -14)
                frame.GuildName:SetPoint('TOPRIGHT', -50, -14)
                F.ReskinIcon(frame.Icon.Texture)

                frame.GuildBanner:SetTexture('')
                frame.GuildBorder:SetTexture('')
                frame.Icon.Bling:SetTexture('')
            end
            frame.glow:SetTexture('')
            frame.Background:SetTexture('')
            frame.Icon.Overlay:SetTexture('')
            if frame.GuildBanner:IsShown() then
                frame.bg:SetPoint('TOPLEFT', 2, -29)
                frame.bg:SetPoint('BOTTOMRIGHT', -2, 4)
            else
                frame.bg:SetPoint('TOPLEFT', frame, -2, -17)
                frame.bg:SetPoint('BOTTOMRIGHT', 2, 12)
            end
        end,

        [_G.CriteriaAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', frame, 5, -7)
                frame.bg:SetPoint('BOTTOMRIGHT', frame, 18, 10)

                frame.Unlocked:SetTextColor(1, 0.8, 0)
                frame.Unlocked:SetFontObject(_G.NumberFont_GameNormal)
                F.ReskinIcon(frame.Icon.Texture)
                frame.Background:SetTexture('')
                frame.Icon.Bling:SetTexture('')
                frame.Icon.Overlay:SetTexture('')
                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.LootAlertSystem] = function(frame)
            local lootItem = frame.lootItem
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', frame, 13, -15)
                frame.bg:SetPoint('BOTTOMRIGHT', frame, -13, 13)

                F.ReskinIcon(lootItem.Icon)
                lootItem.Icon:SetInside()
                lootItem.IconOverlay:SetInside()
                lootItem.IconOverlay2:SetInside()
                lootItem.SpecRing:SetTexture('')
                lootItem.SpecIcon:SetPoint('TOPLEFT', lootItem.Icon, -5, 5)
                lootItem.SpecIcon.bg = F.ReskinIcon(lootItem.SpecIcon)
            end
            frame.glow:SetTexture('')
            frame.shine:SetTexture('')
            frame.Background:SetTexture('')
            frame.PvPBackground:SetTexture('')
            frame.BGAtlas:SetTexture('')
            lootItem.IconBorder:SetTexture('')
            lootItem.SpecIcon.bg:SetShown(lootItem.SpecIcon:IsShown() and lootItem.SpecIcon:GetTexture() ~= nil)
        end,

        [_G.LootUpgradeAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 10, -14)
                frame.bg:SetPoint('BOTTOMRIGHT', -10, 12)

                F.ReskinIcon(frame.Icon)
                frame.Icon:ClearAllPoints()
                frame.Icon:SetPoint('CENTER', frame.BaseQualityBorder)

                frame.BaseQualityBorder:SetSize(52, 52)
                frame.BaseQualityBorder:SetTexture(C.Assets.Textures.Backdrop)
                frame.UpgradeQualityBorder:SetTexture(C.Assets.Textures.Backdrop)
                frame.UpgradeQualityBorder:SetSize(52, 52)
                frame.Background:SetTexture('')
                frame.Sheen:SetTexture('')
                frame.BorderGlow:SetTexture('')
            end
            frame.BaseQualityBorder:SetTexture('')
            frame.UpgradeQualityBorder:SetTexture('')
        end,

        [_G.MoneyWonAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetInside(frame, 7, 7)

                F.ReskinIcon(frame.Icon)
                frame.Background:SetTexture('')
                frame.IconBorder:SetTexture('')
            end
        end,

        [_G.NewRecipeLearnedAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 10, -5)
                frame.bg:SetPoint('BOTTOMRIGHT', -10, 5)

                frame:GetRegions():SetTexture('')
                F.CreateBDFrame(frame.Icon)
                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
            frame.Icon:SetMask('')
            frame.Icon:SetTexCoord(unpack(C.TEX_COORD))
        end,

        [_G.WorldQuestCompleteAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 4, -7)
                frame.bg:SetPoint('BOTTOMRIGHT', -4, 8)

                F.ReskinIcon(frame.QuestTexture)
                frame.shine:SetTexture('')
                frame:DisableDrawLayer('BORDER')
                frame.ToastText:SetFontObject(_G.NumberFont_GameNormal)
            end
        end,

        [_G.GarrisonTalentAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 10, -10)
                frame.bg:SetPoint('BOTTOMRIGHT', -10, 13)

                F.ReskinIcon(frame.Icon)
                frame:GetRegions():Hide()
                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.GarrisonFollowerAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 16, -3)
                frame.bg:SetPoint('BOTTOMRIGHT', -16, 16)

                frame:GetRegions():Hide()
                select(5, frame:GetRegions()):Hide()
                F.ReskinGarrisonPortrait(frame.PortraitFrame)
                frame.PortraitFrame:ClearAllPoints()
                frame.PortraitFrame:SetPoint('TOPLEFT', 22, -8)

                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
            frame.FollowerBG:SetTexture('')
        end,

        [_G.GarrisonMissionAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 8, -8)
                frame.bg:SetPoint('BOTTOMRIGHT', -8, 10)

                if frame.Blank then
                    frame.Blank:Hide()
                end
                if frame.IconBG then
                    frame.IconBG:Hide()
                end
                frame.Background:Hide()
                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end

            -- Anchor fix in 8.2
            if frame.Level then
                local showItemLevel = frame.ItemLevel:IsShown()
                local isRareMission = frame.Rare:IsShown()

                if showItemLevel and isRareMission then
                    frame.Level:SetPoint('TOP', frame, 'TOP', -115, -14)
                    frame.ItemLevel:SetPoint('TOP', frame, 'TOP', -115, -37)
                    frame.Rare:SetPoint('TOP', frame, 'TOP', -115, -48)
                elseif isRareMission then
                    frame.Level:SetPoint('TOP', frame, 'TOP', -115, -19)
                    frame.Rare:SetPoint('TOP', frame, 'TOP', -115, -45)
                elseif showItemLevel then
                    frame.Level:SetPoint('TOP', frame, 'TOP', -115, -19)
                    frame.ItemLevel:SetPoint('TOP', frame, 'TOP', -115, -45)
                else
                    frame.Level:SetPoint('TOP', frame, 'TOP', -115, -28)
                end
            end
        end,

        [_G.DigsiteCompleteAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetInside(frame, 8, 8)

                frame:GetRegions():Hide()
                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.GuildChallengeAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 8, -13)
                frame.bg:SetPoint('BOTTOMRIGHT', -8, 13)

                select(2, frame:GetRegions()):SetTexture('')
                frame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.DungeonCompletionAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 3, -8)
                frame.bg:SetPoint('BOTTOMRIGHT', -3, 8)

                F.ReskinIcon(frame.dungeonTexture)
                frame:DisableDrawLayer('Border')
                frame.heroicIcon:SetTexture('')
                frame.glowFrame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.ScenarioAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetInside(frame, 5, 5)

                F.ReskinIcon(frame.dungeonTexture)
                frame:GetRegions():Hide()
                select(3, frame:GetRegions()):Hide()
                frame.glowFrame.glow:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.LegendaryItemAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 25, -22)
                frame.bg:SetPoint('BOTTOMRIGHT', -25, 24)
                frame:HookScript('OnUpdate', fixBg)

                F.ReskinIcon(frame.Icon)
                frame.Icon:ClearAllPoints()
                frame.Icon:SetPoint('TOPLEFT', frame.bg, 10, -10)

                frame.Background:SetTexture('')
                frame.Background2:SetTexture('')
                frame.Background3:SetTexture('')
                frame.glow:SetTexture('')
            end
        end,

        [_G.NewPetAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 12, -13)
                frame.bg:SetPoint('BOTTOMRIGHT', -12, 10)

                F.ReskinIcon(frame.Icon)
                frame.IconBorder:Hide()
                frame.Background:SetTexture('')
                frame.shine:SetTexture('')
            end
        end,

        [_G.InvasionAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetInside(frame, 5, 5)

                local bg, icon = frame:GetRegions()
                bg:Hide()
                F.ReskinIcon(icon)
            end
        end,

        [_G.EntitlementDeliveredAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetInside(frame, 12, 12)

                F.ReskinIcon(frame.Icon)
                frame.Title:SetTextColor(0, 0.6, 1)
                frame.Background:Hide()
            end
        end,

        [_G.RafRewardDeliveredAlertSystem] = function(frame)
            if not frame.bg then
                frame.bg = F.SetBD(frame)
                frame.bg:SetPoint('TOPLEFT', 24, -14)
                frame.bg:SetPoint('BOTTOMRIGHT', -24, 8)

                F.ReskinIcon(frame.Icon)
                frame.StandardBackground:SetTexture('')
            end
        end,
    }

    AlertTemplateFunc[_G.HonorAwardedAlertSystem] = AlertTemplateFunc[_G.MoneyWonAlertSystem]
    AlertTemplateFunc[_G.MonthlyActivityAlertSystem] = AlertTemplateFunc[_G.CriteriaAlertSystem]
    AlertTemplateFunc[_G.GarrisonBuildingAlertSystem] = AlertTemplateFunc[_G.GarrisonTalentAlertSystem]
    AlertTemplateFunc[_G.SkillLineSpecsUnlockedAlertSystem] = AlertTemplateFunc[_G.NewRecipeLearnedAlertSystem]

    AlertTemplateFunc[_G.GarrisonShipMissionAlertSystem] = AlertTemplateFunc[_G.GarrisonMissionAlertSystem]
    AlertTemplateFunc[_G.GarrisonShipFollowerAlertSystem] = AlertTemplateFunc[_G.GarrisonMissionAlertSystem]
    AlertTemplateFunc[_G.GarrisonRandomMissionAlertSystem] = AlertTemplateFunc[_G.GarrisonMissionAlertSystem]

    AlertTemplateFunc[_G.NewToyAlertSystem] = AlertTemplateFunc[_G.NewPetAlertSystem]
    AlertTemplateFunc[_G.NewMountAlertSystem] = AlertTemplateFunc[_G.NewPetAlertSystem]
    AlertTemplateFunc[_G.NewRuneforgePowerAlertSystem] = AlertTemplateFunc[_G.NewPetAlertSystem]
    AlertTemplateFunc[_G.NewCosmeticAlertFrameSystem] = AlertTemplateFunc[_G.NewPetAlertSystem]

    hooksecurefunc(_G.AlertFrame, 'AddAlertFrame', function(_, frame)
        local func = AlertTemplateFunc[frame.queue]
        if func then
            func(frame)
            fixAnim(frame)
        end
    end)

    -- Reward Icons
    hooksecurefunc('StandardRewardAlertFrame_AdjustRewardAnchors', function(frame)
        if frame.RewardFrames then
            for i = 1, frame.numUsedRewardFrames do
                local reward = frame.RewardFrames[i]
                if not reward.bg then
                    select(2, reward:GetRegions()):SetTexture('')
                    reward.texture:ClearAllPoints()
                    reward.texture:SetInside(reward, 6, 6)
                    reward.bg = F.ReskinIcon(reward.texture)
                end
            end
        end
    end)

    -- BonusRollLootWonFrame
    hooksecurefunc('LootWonAlertFrame_SetUp', function(frame)
        local lootItem = frame.lootItem
        if not frame.bg then
            frame.bg = F.SetBD(frame)
            frame.bg:SetInside(frame, 10, 10)
            fixAnim(frame)

            frame.shine:SetTexture('')
            F.ReskinIcon(lootItem.Icon)

            lootItem.SpecRing:SetTexture('')
            lootItem.SpecIcon:SetPoint('TOPLEFT', lootItem.Icon, -5, 5)
            lootItem.SpecIcon.bg = F.ReskinIcon(lootItem.SpecIcon)
        end

        frame.glow:SetTexture('')
        frame.Background:SetTexture('')
        frame.PvPBackground:SetTexture('')
        frame.BGAtlas:SetAlpha(0)
        lootItem.IconBorder:SetTexture('')
        lootItem.SpecIcon.bg:SetShown(lootItem.SpecIcon:IsShown() and lootItem.SpecIcon:GetTexture() ~= nil)
    end)

    -- BonusRollMoneyWonFrame
    hooksecurefunc('MoneyWonAlertFrame_SetUp', function(frame)
        if not frame.bg then
            frame.bg = F.SetBD(frame)
            frame.bg:SetInside(frame, 5, 5)
            fixAnim(frame)

            frame.Background:SetTexture('')
            F.ReskinIcon(frame.Icon)
            frame.IconBorder:SetTexture('')
        end
    end)

    -- Event toast
    hooksecurefunc(_G.EventToastManagerFrame, 'DisplayToast', function(self)
        local toast = self.currentDisplayingToast
        local border = toast and toast.IconBorder
        if border and not toast.bg then
            toast.bg = F.ReskinIcon(toast.Icon)
            border:SetTexture('')
            F.ReskinIconBorder(border, true)
        end
    end)
end)
