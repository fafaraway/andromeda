local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.AlertFrames()
    local r, g, b, a
    local function fixBG(f)
        if f:GetObjectType() == "AnimationGroup" then
            f = f:GetParent()
        end
        f._auroraBG:SetBackdropColor(r, g, b, a)
    end

    local OnShow = {}
    _G.hooksecurefunc(_G.AlertFrame, "AddAlertFrame", function(self, frame)
        local frameName = frame:GetName()
        if frameName then
            local alertName = frameName:match("(%w+)AlertFrame")
            private.debug("alertName", alertName)
            if OnShow[alertName] then OnShow[alertName](frame) end
        else
            -- QueueAlertFrames are created dynamicly and do not have names
            if frame.Unlocked then
                if frame.Unlocked:GetText() == _G.ACHIEVEMENT_PROGRESSED then
                    OnShow.Criteria(frame)
                else
                    OnShow.Achievement(frame)
                end
            end
        end
    end)

    do --[[ Achievement / Criteria ]]
        OnShow.Achievement = function(self)
            if not self._auroraBG then
                self.Background:Hide()
                local bg = F.CreateBDFrame(self)
                bg:SetPoint("BOTTOMRIGHT", -7, 15)
                self._auroraBG = bg

                local guildBG = self:CreateTexture(nil, "BACKGROUND")
                guildBG:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
                guildBG:SetTexCoord(0, 0.6640625, 0, 0.25)
                guildBG:SetVertexColor(0, 0, 0)
                guildBG:SetPoint("BOTTOM", self, "TOP", 0, -30)
                guildBG:SetSize(340, 64)
                self._auroraGuildBG = guildBG

                r, g, b, a = bg:GetBackdropColor()
                self:HookScript("OnEnter", fixBG)
                self:HookScript("OnShow", fixBG)
                self.animIn:HookScript("OnFinished", fixBG)

                self.Unlocked:SetTextColor(1, 1, 1)
                self.shine:SetHeight(58)

                F.ReskinIcon(self.Icon.Texture)
                self.Icon.Overlay:Hide()
            end

            if self.guildDisplay then
                self._auroraBG:SetPoint("TOPLEFT", 6, -29)
                self._auroraGuildBG:Show()

                self.Icon:SetPoint("TOPLEFT", -26, 0)
                self.shine:SetTexCoord(0.75195313, 0.91601563, 0.25, 0.3359375)
            else
                self._auroraBG:SetPoint("TOPLEFT", 6, -13)
                self._auroraGuildBG:Hide()

                self.shine:SetTexCoord(0.78125, 0.912109375, 0.06640625, 0.23046875)
                self.shine:SetPoint("BOTTOMLEFT", 0, 16)

                if self.oldCheevo then
                    self.OldAchievement:Hide()
                end
            end
        end
        OnShow.Criteria = function(self)
            if not self._auroraBG then
                self.Background:Hide()
                local bg = F.CreateBDFrame(self)
                bg:SetPoint("TOPLEFT", -12, 3)
                bg:SetPoint("BOTTOMRIGHT", 16, 3)
                self._auroraBG = bg

                r, g, b, a = bg:GetBackdropColor()
                self:HookScript("OnEnter", fixBG)
                self:HookScript("OnShow", fixBG)
                self.animIn:HookScript("OnFinished", fixBG)

                self.Unlocked:SetTextColor(1, 1, 1)
                self.shine:SetTexCoord(0.78125, 0.912109375, 0.06640625, 0.23046875)
                self.shine:SetPoint("TOPLEFT", 18, 2)
                self.shine:SetHeight(50)

                F.ReskinIcon(self.Icon.Texture)
                self.Icon.Overlay:Hide()
            end
        end
    end

    --[=[ Broken in 7.1
    --[[ Dungeon completion rewards ]]
    local DungeonCompletionAlertFrame = _G.DungeonCompletionAlertFrame
    local bg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame)
    bg:SetPoint("TOPLEFT", 6, -14)
    bg:SetPoint("BOTTOMRIGHT", -6, 6)
    bg:SetFrameLevel(DungeonCompletionAlertFrame:GetFrameLevel()-1)
    F.CreateBD(bg)

    DungeonCompletionAlertFrame.dungeonTexture:SetDrawLayer("ARTWORK")
    DungeonCompletionAlertFrame.dungeonTexture:SetTexCoord(.02, .98, .02, .98)
    DungeonCompletionAlertFrame.dungeonTexture:SetPoint("BOTTOMLEFT", DungeonCompletionAlertFrame, "BOTTOMLEFT", 13, 13)
    DungeonCompletionAlertFrame.dungeonTexture.SetPoint = F.dummy
    F.CreateBG(DungeonCompletionAlertFrame.dungeonTexture)

    DungeonCompletionAlertFrame.raidArt:SetAlpha(0)
    DungeonCompletionAlertFrame.dungeonArt1:SetAlpha(0)
    DungeonCompletionAlertFrame.dungeonArt2:SetAlpha(0)
    DungeonCompletionAlertFrame.dungeonArt3:SetAlpha(0)
    DungeonCompletionAlertFrame.dungeonArt4:SetAlpha(0)

    DungeonCompletionAlertFrame.shine:Hide()
    DungeonCompletionAlertFrame.shine.Show = F.dummy
    DungeonCompletionAlertFrame.glowFrame:Hide()
    DungeonCompletionAlertFrame.glowFrame.Show = F.dummy

    OnShow.DungeonCompletion = function(self)
        local bu = _G.DungeonCompletionAlertFrameReward1
        local index = 1

        while bu do
            if not bu.isSkinned then
                _G["DungeonCompletionAlertFrameReward"..index.."Border"]:Hide()

                bu.texture:SetTexCoord(.08, .92, .08, .92)
                F.CreateBG(bu.texture)

                bu.isSkinned = true
            end

            index = index + 1
            bu = _G["DungeonCompletionAlertFrameReward"..index]
        end
    end

    --[[ Guild challenges ]]
    local challenge = CreateFrame("Frame", nil, _G.GuildChallengeAlertFrame)
    challenge:SetPoint("TOPLEFT", 8, -12)
    challenge:SetPoint("BOTTOMRIGHT", -8, 13)
    challenge:SetFrameLevel(_G.GuildChallengeAlertFrame:GetFrameLevel()-1)
    F.CreateBD(challenge)
    F.CreateBG(_G.GuildChallengeAlertFrameEmblemBackground)
    _G.select(2, _G.GuildChallengeAlertFrame:GetRegions()):Hide()

    _G.GuildChallengeAlertFrameGlow:SetTexture("")
    _G.GuildChallengeAlertFrameShine:SetTexture("")
    _G.GuildChallengeAlertFrameEmblemBorder:SetTexture("")
    ]=]

    --[[ Pre-Legion  BROKEN
    -- Achievement alert
    local function fixBg(f)
        if f:GetObjectType() == "AnimationGroup" then
            f = f:GetParent()
        end
        f.bg:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
    end

    hooksecurefunc("AlertFrame_FixAnchors", function()
        for i = 1, MAX_ACHIEVEMENT_ALERTS do
            local frame = _G["AchievementAlertFrame"..i]

            if frame then
                frame:SetAlpha(1)
                frame.SetAlpha = F.dummy

                local ic = _G["AchievementAlertFrame"..i.."Icon"]
                local texture = _G["AchievementAlertFrame"..i.."IconTexture"]
                local guildName = _G["AchievementAlertFrame"..i.."GuildName"]

                ic:ClearAllPoints()
                ic:SetPoint("LEFT", frame, "LEFT", -26, 0)

                if not frame.bg then
                    frame.bg = CreateFrame("Frame", nil, frame)
                    frame.bg:SetPoint("TOPLEFT", texture, -10, 12)
                    frame.bg:SetPoint("BOTTOMRIGHT", texture, "BOTTOMRIGHT", 240, -12)
                    frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
                    F.CreateBD(frame.bg)

                    frame:HookScript("OnEnter", fixBg)
                    frame:HookScript("OnShow", fixBg)
                    frame.animIn:HookScript("OnFinished", fixBg)
                    F.CreateBD(frame.bg)

                    F.CreateBG(texture)

                    _G["AchievementAlertFrame"..i.."Background"]:Hide()
                    _G["AchievementAlertFrame"..i.."IconOverlay"]:Hide()
                    _G["AchievementAlertFrame"..i.."GuildBanner"]:SetTexture("")
                    _G["AchievementAlertFrame"..i.."GuildBorder"]:SetTexture("")
                    _G["AchievementAlertFrame"..i.."OldAchievement"]:SetTexture("")

                    guildName:ClearAllPoints()
                    guildName:SetPoint("TOPLEFT", 50, -14)
                    guildName:SetPoint("TOPRIGHT", -50, -14)

                    _G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
                    _G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(1, -1)
                end

                frame.glow:Hide()
                frame.shine:Hide()
                frame.glow.Show = F.dummy
                frame.shine.Show = F.dummy

                texture:SetTexCoord(.08, .92, .08, .92)

                if guildName:IsShown() then
                    _G["AchievementAlertFrame"..i.."Shield"]:SetPoint("TOPRIGHT", -10, -22)
                end
            end
        end
    end)

    -- Challenge popup

    hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function()
        local frame = ChallengeModeAlertFrame1

        if frame then
            frame:SetAlpha(1)
            frame.SetAlpha = F.dummy

            if not frame.bg then
                frame.bg = CreateFrame("Frame", nil, frame)
                frame.bg:SetPoint("TOPLEFT", ChallengeModeAlertFrame1DungeonTexture, -12, 12)
                frame.bg:SetPoint("BOTTOMRIGHT", ChallengeModeAlertFrame1DungeonTexture, 243, -12)
                frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
                F.CreateBD(frame.bg)

                frame:HookScript("OnEnter", fixBg)
                frame:HookScript("OnShow", fixBg)
                frame.animIn:HookScript("OnFinished", fixBg)

                F.CreateBG(ChallengeModeAlertFrame1DungeonTexture)
            end

            frame:GetRegions():Hide()

            ChallengeModeAlertFrame1Shine:Hide()
            ChallengeModeAlertFrame1Shine.Show = F.dummy
            ChallengeModeAlertFrame1GlowFrame:Hide()
            ChallengeModeAlertFrame1GlowFrame.Show = F.dummy
            ChallengeModeAlertFrame1Border:Hide()
            ChallengeModeAlertFrame1Border.Show = F.dummy

            ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
        end
    end)

    -- Scenario alert

    hooksecurefunc("AlertFrame_SetScenarioAnchors", function()
        local frame = ScenarioAlertFrame1

        if frame then
            frame:SetAlpha(1)
            frame.SetAlpha = F.dummy

            if not frame.bg then
                frame.bg = CreateFrame("Frame", nil, frame)
                frame.bg:SetPoint("TOPLEFT", ScenarioAlertFrame1DungeonTexture, -12, 12)
                frame.bg:SetPoint("BOTTOMRIGHT", ScenarioAlertFrame1DungeonTexture, 244, -12)
                frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
                F.CreateBD(frame.bg)

                frame:HookScript("OnEnter", fixBg)
                frame:HookScript("OnShow", fixBg)
                frame.animIn:HookScript("OnFinished", fixBg)

                F.CreateBG(ScenarioAlertFrame1DungeonTexture)
                ScenarioAlertFrame1DungeonTexture:SetDrawLayer("OVERLAY")
            end

            frame:GetRegions():Hide()
            select(3, frame:GetRegions()):Hide()

            ScenarioAlertFrame1Shine:Hide()
            ScenarioAlertFrame1Shine.Show = F.dummy
            ScenarioAlertFrame1GlowFrame:Hide()
            ScenarioAlertFrame1GlowFrame.Show = F.dummy

            ScenarioAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
        end
    end)

    hooksecurefunc("ScenarioAlertFrame_ShowAlert", function()
        local bu = ScenarioAlertFrame1Reward1
        local index = 1

        while bu do
            if not bu.styled then
                _G["ScenarioAlertFrame1Reward"..index.."Border"]:Hide()

                bu.texture:SetTexCoord(.08, .92, .08, .92)
                F.CreateBG(bu.texture)

                bu.styled = true
            end

            index = index + 1
            bu = _G["ScenarioAlertFrame1Reward"..index]
        end
    end)

    -- Loot won alert

    -- I still don't know why I can't parent bg to frame
    local function showHideBg(self)
        self.bg:SetShown(self:IsShown())
    end

    local function onUpdate(self)
        self.bg:SetAlpha(self:GetAlpha())
    end

    hooksecurefunc("LootWonAlertFrame_SetUp", function(frame)
        if not frame.bg then
            frame.bg = CreateFrame("Frame", nil, UIParent)
            frame.bg:SetPoint("TOPLEFT", frame, 10, -10)
            frame.bg:SetPoint("BOTTOMRIGHT", frame, -10, 10)
            frame.bg:SetFrameStrata("DIALOG")
            frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
            frame.bg:SetShown(frame:IsShown())
            F.CreateBD(frame.bg)

            frame:HookScript("OnShow", showHideBg)
            frame:HookScript("OnHide", showHideBg)
            frame:HookScript("OnUpdate", onUpdate)

            frame.shine:SetTexture("")
            frame.SpecRing:SetTexture("")

            frame.Icon:SetTexCoord(.08, .92, .08, .92)
            F.CreateBG(frame.Icon)

            frame.SpecIcon:SetTexCoord(.08, .92, .08, .92)
            frame.SpecIcon.bg = F.CreateBG(frame.SpecIcon)
            frame.SpecIcon.bg:SetDrawLayer("BORDER", 2)
        end

        frame.Background:Hide()
        frame.IconBorder:Hide()
        frame.glow:SetTexture("")
        frame.PvPBackground:Hide()
        frame.BGAtlas:Hide()

        frame.Icon:SetDrawLayer("BORDER")
        frame.SpecIcon.bg:SetShown(frame.SpecIcon:IsShown() and frame.SpecIcon:GetTexture() ~= nil) -- sometimes appears when it shouldn't
    end)

    -- Money won alert

    hooksecurefunc("MoneyWonAlertFrame_SetUp", function(frame)
        if not frame.bg then
            frame.bg = CreateFrame("Frame", nil, UIParent)
            frame.bg:SetPoint("TOPLEFT", frame, 10, -10)
            frame.bg:SetPoint("BOTTOMRIGHT", frame, -10, 10)
            frame.bg:SetFrameStrata("DIALOG")
            frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
            frame.bg:SetShown(frame:IsShown())
            F.CreateBD(frame.bg)

            frame:HookScript("OnShow", showHideBg)
            frame:HookScript("OnHide", showHideBg)
            frame:HookScript("OnUpdate", onUpdate)

            frame.Background:Hide()
            frame.IconBorder:Hide()

            frame.Icon:SetTexCoord(.08, .92, .08, .92)
            F.CreateBG(frame.Icon)
        end
    end)

    -- Criteria alert

    hooksecurefunc("CriteriaAlertFrame_ShowAlert", function()
        for i = 1, MAX_ACHIEVEMENT_ALERTS do
            local frame = _G["CriteriaAlertFrame"..i]
            if frame and not frame.bg then
                local icon = _G["CriteriaAlertFrame"..i.."IconTexture"]

                frame.bg = CreateFrame("Frame", nil, UIParent)
                frame.bg:SetPoint("TOPLEFT", icon, -6, 5)
                frame.bg:SetPoint("BOTTOMRIGHT", icon, 236, -5)
                frame.bg:SetFrameStrata("DIALOG")
                frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
                frame.bg:SetShown(frame:IsShown())
                F.CreateBD(frame.bg)

                frame:SetScript("OnShow", showHideBg)
                frame:SetScript("OnHide", showHideBg)
                frame:HookScript("OnUpdate", onUpdate)

                _G["CriteriaAlertFrame"..i.."Background"]:Hide()
                _G["CriteriaAlertFrame"..i.."IconOverlay"]:Hide()
                frame.glow:Hide()
                frame.glow.Show = F.dummy
                frame.shine:Hide()
                frame.shine.Show = F.dummy

                _G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(.9, .9, .9)

                icon:SetTexCoord(.08, .92, .08, .92)
                F.CreateBG(icon)
            end
        end
    end)

    -- Digsite completion alert

    do
        local frame = DigsiteCompleteToastFrame
        local icon = frame.DigsiteTypeTexture

        F.CreateBD(frame)

        frame:GetRegions():Hide()

        frame.glow:Hide()
        frame.glow.Show = F.dummy
        frame.shine:Hide()
        frame.shine.Show = F.dummy
    end

    -- Garrison building alert

    do
        local frame = GarrisonBuildingAlertFrame
        local icon = frame.Icon

        frame:GetRegions():Hide()
        frame.glow:SetTexture("")
        frame.shine:SetTexture("")

        local bg = CreateFrame("Frame", nil, frame)
        bg:SetPoint("TOPLEFT", 8, -8)
        bg:SetPoint("BOTTOMRIGHT", -8, 10)
        bg:SetFrameLevel(frame:GetFrameLevel()-1)
        F.CreateBD(bg)

        icon:SetTexCoord(.08, .92, .08, .92)
        icon:SetDrawLayer("ARTWORK")
        F.CreateBG(icon)
    end

    -- Garrison mission alert

    do
        local frame = GarrisonMissionAlertFrame

        frame.Background:Hide()
        frame.IconBG:Hide()
        frame.glow:SetTexture("")
        frame.shine:SetTexture("")

        local bg = CreateFrame("Frame", nil, frame)
        bg:SetPoint("TOPLEFT", 8, -8)
        bg:SetPoint("BOTTOMRIGHT", -8, 10)
        bg:SetFrameLevel(frame:GetFrameLevel()-1)
        F.CreateBD(bg)
    end

    -- Garrison shipyard mission alert

    do
        local frame = GarrisonShipMissionAlertFrame

        frame.Background:Hide()
        frame.glow:SetTexture("")
        frame.shine:SetTexture("")

        local bg = CreateFrame("Frame", nil, frame)
        bg:SetPoint("TOPLEFT", 8, -8)
        bg:SetPoint("BOTTOMRIGHT", -8, 10)
        bg:SetFrameLevel(frame:GetFrameLevel()-1)
        F.CreateBD(bg)
    end

    -- Garrison follower alert

    do
        local frame = GarrisonFollowerAlertFrame

        frame:GetRegions():Hide()
        frame.FollowerBG:SetAlpha(0)
        frame.glow:SetTexture("")
        frame.shine:SetTexture("")

        local bg = CreateFrame("Frame", nil, frame)
        bg:SetPoint("TOPLEFT", 16, -3)
        bg:SetPoint("BOTTOMRIGHT", -16, 16)
        bg:SetFrameLevel(frame:GetFrameLevel()-1)
        F.CreateBD(bg)

        F.ReskinGarrisonPortrait(frame.PortraitFrame)
    end

    hooksecurefunc("GarrisonFollowerAlertFrame_ShowAlert", function(_, _, _, _, quality)
        local color = BAG_ITEM_QUALITY_COLORS[quality]
        if color then
            GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
        else
            GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(0, 0, 0)
        end
    end)

    -- Loot upgrade alert

    hooksecurefunc("LootUpgradeFrame_SetUp", function(frame)
        if not frame.bg then
            local bg = CreateFrame("Frame", nil, frame)
            bg:SetPoint("TOPLEFT", 10, -10)
            bg:SetPoint("BOTTOMRIGHT", -10, 10)
            bg:SetFrameLevel(frame:GetFrameLevel()-1)
            F.CreateBD(bg)
            frame.bg = bg

            frame.Background:Hide()

            F.ReskinIcon(frame.Icon)
            frame.Icon:SetDrawLayer("BORDER", 5)
            frame.Icon:ClearAllPoints()
            frame.Icon:SetPoint("CENTER", frame.BaseQualityBorder)
        end

        frame.BaseQualityBorder:SetTexture(C.media.backdrop)
        frame.UpgradeQualityBorder:SetTexture(C.media.backdrop)
        frame.BaseQualityBorder:SetSize(52, 52)
        frame.UpgradeQualityBorder:SetSize(52, 52)
        frame.BaseQualityBorder:SetVertexColor(frame.BaseQualityItemName:GetTextColor())
        frame.UpgradeQualityBorder:SetVertexColor(frame.UpgradeQualityItemName:GetTextColor())
    end)]]
end
