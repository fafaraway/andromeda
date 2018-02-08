local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Base, Skin = Aurora.Base, Aurora.Skin

function private.FrameXML.QuestInfo()
    local function restyleSpellButton(bu)
        local name = bu:GetName()
        local icon = bu.Icon

        _G[name.."NameFrame"]:Hide()
        _G[name.."SpellBorder"]:Hide()

        icon:SetPoint("TOPLEFT", 3, -2)
        icon:SetDrawLayer("ARTWORK")
        icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(icon)

        local bg = _G.CreateFrame("Frame", nil, bu)
        bg:SetPoint("TOPLEFT", 2, -1)
        bg:SetPoint("BOTTOMRIGHT", 0, 14)
        bg:SetFrameLevel(0)
        F.CreateBD(bg, .25)
    end
    local function colourObjectivesText()
        private.debug("colourObjectivesText")
        if not _G.QuestInfoFrame.questLog then return end

        local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives
        local numVisibleObjectives = 0

        for i = 1, _G.GetNumQuestLeaderBoards() do
            local _, objectiveType, isCompleted = _G.GetQuestLogLeaderBoard(i)

            if (objectiveType ~= "spell" and objectiveType ~= "log" and numVisibleObjectives < _G.MAX_OBJECTIVES) then
                numVisibleObjectives = numVisibleObjectives + 1
                local objective = objectivesTable[numVisibleObjectives]

                if isCompleted then
                    objective:SetTextColor(.9, .9, .9)
                else
                    objective:SetTextColor(1, 1, 1)
                end
            end
        end
    end

    local SkinQuestText do
        local function Hook_SetTextColor(self, red, green, blue)
            if self.settingFont then return end
            self.settingFont = true
            self:SetTextColor(1, 1, 1)
            self.settingFont = nil
        end

        function SkinQuestText(font, hasShadow)
            if hasShadow then
                font:SetShadowColor(0.3, 0.3, 0.3)
            end
            font:SetTextColor(1, 1, 1)
            _G.hooksecurefunc(font, "SetTextColor", Hook_SetTextColor)
        end
    end

    hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
    hooksecurefunc("QuestInfo_Display", function(template, parentFrame, acceptButton, material, mapView)
        private.debug("QuestInfo_Display")
        local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
        local isQuestLog = _G.QuestInfoFrame.questLog ~= nil
        local isMapQuest = rewardsFrame == _G.MapQuestInfoRewardsFrame

        colourObjectivesText()

        if ( template.canHaveSealMaterial ) then
            local questFrame = parentFrame:GetParent():GetParent()
            questFrame.SealMaterialBG:Hide()
        end

        local numSpellRewards = isQuestLog and _G.GetNumQuestLogRewardSpells() or _G.GetNumRewardSpells()
        if numSpellRewards > 0 then
            -- Spell Headers
            for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
                private.debug("spellHeaderPool", spellHeader:GetText())
                spellHeader:SetVertexColor(1, 1, 1)
            end
            -- Follower Rewards
            for followerReward in rewardsFrame.followerRewardPool:EnumerateActive() do
                private.debug("followerRewardPool", followerReward.Name:GetText())
                if not followerReward.isSkinned then
                    followerReward.PortraitFrame:SetScale(1)
                    followerReward.PortraitFrame:ClearAllPoints()
                    followerReward.PortraitFrame:SetPoint("TOPLEFT")
                    if isMapQuest then
                        followerReward.PortraitFrame.Portrait:SetSize(29, 29)
                    end
                    F.ReskinGarrisonPortrait(followerReward.PortraitFrame)

                    followerReward.BG:Hide()
                    followerReward.BG:SetPoint("TOPLEFT", followerReward.PortraitFrame, "TOPRIGHT")
                    followerReward.BG:SetPoint("BOTTOMRIGHT")
                    F.CreateBD(followerReward, .25)
                    followerReward:SetHeight(followerReward.PortraitFrame:GetHeight())

                    if not isMapQuest then
                        followerReward.Class:SetWidth(45)
                    end

                    followerReward.isSkinned = true
                end
                followerReward.PortraitFrame:SetBackdropBorderColor(followerReward.PortraitFrame.PortraitRingQuality:GetVertexColor())
            end
            -- Spell Rewards
            for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
                private.debug("spellRewardPool", spellReward.Name:GetText())
                if not spellReward.isSkinned then
                    if isMapQuest then
                        Skin.SmallItemButtonTemplate(spellReward)
                    else
                        Skin.LargeItemButtonTemplate(spellReward)

                        _G.select(3, spellReward:GetRegions()):Hide() --border
                        spellReward.Icon:SetPoint("TOPLEFT", 0, 0)
                        spellReward:SetHitRectInsets(0,0,0,0)
                        spellReward:SetSize(147, 41)
                    end
                    spellReward.isSkinned = true
                end
            end
        end
    end)
    hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
        local button = rewardsFrame.RewardButtons[index]

        if not button.restyled then
            if rewardsFrame == _G.MapQuestInfoRewardsFrame then
                Skin.SmallItemButtonTemplate(button)
            else
                Skin.LargeItemButtonTemplate(button)
            end
            button.restyled = true
        end
    end)


    restyleSpellButton(_G.QuestInfoSpellObjectiveFrame)
    SkinQuestText(_G.QuestInfoSpellObjectiveLearnLabel)

    --[[ QuestInfoRewardsFrame ]]
    local QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame
    SkinQuestText(QuestInfoRewardsFrame.Header, true)
    SkinQuestText(QuestInfoRewardsFrame.ItemChooseText)
    SkinQuestText(QuestInfoRewardsFrame.ItemReceiveText)
    SkinQuestText(QuestInfoRewardsFrame.PlayerTitleText)

    for i, name in next, {"HonorFrame", "SkillPointFrame", "ArtifactXPFrame"} do
        Skin.LargeItemButtonTemplate(QuestInfoRewardsFrame[name])
    end
    SkinQuestText(QuestInfoRewardsFrame.XPFrame.ReceiveText)

    local QuestInfoPlayerTitleFrame = _G.QuestInfoPlayerTitleFrame
    F.ReskinIcon(QuestInfoPlayerTitleFrame.Icon)
    QuestInfoPlayerTitleFrame.FrameLeft:Hide()
    QuestInfoPlayerTitleFrame.FrameCenter:Hide()
    QuestInfoPlayerTitleFrame.FrameRight:Hide()

    local titleBG = _G.CreateFrame("Frame", nil, QuestInfoPlayerTitleFrame)
    titleBG:SetPoint("TOPLEFT", QuestInfoPlayerTitleFrame.FrameLeft, -2, 0)
    titleBG:SetPoint("BOTTOMRIGHT", QuestInfoPlayerTitleFrame.FrameRight, 0, -1)
    F.CreateBD(titleBG, .25)

    local ItemHighlight = QuestInfoRewardsFrame.ItemHighlight
    ItemHighlight:GetRegions():Hide()

    local function clearHighlight()
        for _, button in next, QuestInfoRewardsFrame.RewardButtons do
            Base.SetBackdropColor(button._auroraNameBG, Aurora.frameColor:GetRGBA())
        end
    end
    local function setHighlight(self)
        clearHighlight()

        local _, point = self:GetPoint()
        if point then
            Base.SetBackdropColor(point._auroraNameBG, Aurora.highlightColor:GetRGBA())
        end
    end

    hooksecurefunc(ItemHighlight, "SetPoint", setHighlight)
    ItemHighlight:HookScript("OnShow", setHighlight)
    ItemHighlight:HookScript("OnHide", clearHighlight)


    --[[ MapQuestInfoRewardsFrame ]]
    for i, name in next, {"HonorFrame", "MoneyFrame", "SkillPointFrame", "XPFrame", "ArtifactXPFrame", "TitleFrame"} do
        Skin.SmallItemButtonTemplate(_G.MapQuestInfoRewardsFrame[name])
    end
    _G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)


    --[[ QuestInfoFrame ]]
    SkinQuestText(_G.QuestInfoTitleHeader, true)
    SkinQuestText(_G.QuestInfoObjectivesText)
    SkinQuestText(_G.QuestInfoRewardText)

    hooksecurefunc(_G.QuestInfoRequiredMoneyText, "SetTextColor", function(self, red, green, blue)
        if red == 0 then
            self:SetTextColor(.8, .8, .8)
        elseif red == .2 then
            self:SetTextColor(1, 1, 1)
        end
    end)

    SkinQuestText(_G.QuestInfoGroupSize)
    SkinQuestText(_G.QuestInfoDescriptionHeader, true)
    SkinQuestText(_G.QuestInfoObjectivesHeader, true)
    SkinQuestText(_G.QuestInfoDescriptionText)

    --[[ QuestInfoSealFrame ]]
    _G.QuestInfoSealFrame.Text:SetShadowColor(0.2, 0.2, 0.2)
    _G.QuestInfoSealFrame.Text:SetShadowOffset(0.6, -0.6)
end
