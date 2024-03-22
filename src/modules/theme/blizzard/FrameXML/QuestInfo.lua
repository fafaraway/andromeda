local F, C = unpack(select(2, ...))

local function clearHighlight()
    for _, button in pairs(_G.QuestInfoRewardsFrame.RewardButtons) do
        button.textBg:SetBackdropColor(0, 0, 0, 0.25)
    end
end

local function setHighlight(self)
    clearHighlight()

    local _, point = self:GetPoint()
    if point then
        point.textBg:SetBackdropColor(C.r, C.g, C.b, 0.25)
    end
end

local defaultColor = GetMaterialTextColors('Default')

local function replaceTextColor(object, r)
    if r == 0 or r == defaultColor[1] then
        object:SetTextColor(1, 1, 1)
    elseif r == 0.2 then
        object:SetTextColor(0.7, 0.7, 0.7)
    end
end

local function restyleSpellButton(bu)
    local name = bu:GetName()
    local icon = bu.Icon

    _G[name .. 'NameFrame']:Hide()
    _G[name .. 'SpellBorder']:Hide()

    icon:SetPoint('TOPLEFT', 3, -2)
    F.ReskinIcon(icon)

    local bg = F.CreateBDFrame(bu, 0.25)
    bg:SetPoint('TOPLEFT', 2, -1)
    bg:SetPoint('BOTTOMRIGHT', 0, 14)
end

local function reskinRewardButton(bu)
    bu.NameFrame:Hide()
    bu.bg = F.ReskinIcon(bu.Icon)

    local bg = F.CreateBDFrame(bu, 0.25)
    bg:SetPoint('TOPLEFT', bu.bg, 'TOPRIGHT', 2, 0)
    bg:SetPoint('BOTTOMRIGHT', bu.bg, 100, 0)
    bu.textBg = bg
end

local function reskinRewardButtonWithSize(bu, isMapQuestInfo)
    reskinRewardButton(bu)

    if isMapQuestInfo then
        bu.Icon:SetSize(29, 29)
    else
        bu.Icon:SetSize(34, 34)
    end
end

local function hookTextColor_Yellow(self, r, g, b)
    if r ~= 1 or g ~= 0.8 or b ~= 0 then
        self:SetTextColor(1, 0.8, 0)
    end
end

local function setTextColor_Yellow(font)
    font:SetShadowColor(0, 0, 0, 0)
    font:SetTextColor(1, 0.8, 0)
    hooksecurefunc(font, 'SetTextColor', hookTextColor_Yellow)
end

local function hookTextColor_White(self, r, g, b)
    if r ~= 1 or g ~= 1 or b ~= 1 then
        self:SetTextColor(1, 1, 1)
    end
end

local function setTextColor_White(font)
    font:SetShadowColor(0, 0, 0)
    font:SetTextColor(1, 1, 1)
    hooksecurefunc(font, 'SetTextColor', hookTextColor_White)
end

tinsert(C.BlizzThemes, function()
    -- Item reward highlight
    _G.QuestInfoItemHighlight:GetRegions():Hide()
    hooksecurefunc(_G.QuestInfoItemHighlight, 'SetPoint', setHighlight)
    _G.QuestInfoItemHighlight:HookScript('OnShow', setHighlight)
    _G.QuestInfoItemHighlight:HookScript('OnHide', clearHighlight)

    -- Reskin rewards
    restyleSpellButton(_G.QuestInfoSpellObjectiveFrame) -- needs review

    hooksecurefunc('QuestInfo_GetRewardButton', function(rewardsFrame, index)
        local bu = rewardsFrame.RewardButtons[index]
        if not bu.styled then
            reskinRewardButtonWithSize(bu, rewardsFrame == _G.MapQuestInfoRewardsFrame)
            F.ReskinIconBorder(bu.IconBorder)

            bu.styled = true
        end
    end)

    _G.MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)
    for _, name in
        next,
        {
            'HonorFrame',
            'MoneyFrame',
            'SkillPointFrame',
            'XPFrame',
            'ArtifactXPFrame',
            'TitleFrame',
            'WarModeBonusFrame',
        }
    do
        reskinRewardButtonWithSize(_G.MapQuestInfoRewardsFrame[name], true)
    end

    for _, name in next, { 'HonorFrame', 'SkillPointFrame', 'ArtifactXPFrame', 'WarModeBonusFrame' } do
        reskinRewardButtonWithSize(_G.QuestInfoRewardsFrame[name])
    end

    -- Title Reward, needs review
    do
        local frame = _G.QuestInfoPlayerTitleFrame
        local icon = frame.Icon

        F.ReskinIcon(icon)
        for i = 2, 4 do
            select(i, frame:GetRegions()):Hide()
        end
        local bg = F.CreateBDFrame(frame, 0.25)
        bg:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 0, 2)
        bg:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 220, -1)
    end

    -- Others
    hooksecurefunc('QuestInfo_Display', function()
        local objectivesTable = _G.QuestInfoObjectivesFrame.Objectives
        for i = #objectivesTable, 1, -1 do
            local object = objectivesTable[i]
            if object.hooked then
                break
            end
            hooksecurefunc(object, 'SetTextColor', replaceTextColor)
            object:SetTextColor(1, 1, 1)

            object.hooked = true
        end

        local rewardsFrame = _G.QuestInfoFrame.rewardsFrame
        local isQuestLog = _G.QuestInfoFrame.questLog ~= nil
        local numSpellRewards

        if C.IS_NEW_PATCH_10_1 then
            local questID = isQuestLog and C_QuestLog.GetSelectedQuest() or GetQuestID()
            local spellRewards = C_QuestInfoSystem.GetQuestRewardSpells(questID) or {}
            numSpellRewards = #spellRewards
        else
            numSpellRewards = isQuestLog and GetNumQuestLogRewardSpells() or GetNumRewardSpells()
        end

        if numSpellRewards > 0 then
            -- Spell Headers
            for spellHeader in rewardsFrame.spellHeaderPool:EnumerateActive() do
                spellHeader:SetVertexColor(1, 1, 1)
            end
            -- Follower Rewards
            for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
                local portrait = reward.PortraitFrame
                if not reward.textBg then
                    F.ReskinGarrisonPortrait(portrait)
                    reward.BG:Hide()
                    reward.textBg = F.CreateBDFrame(reward, 0.25)
                end

                if isQuestLog then
                    portrait:SetPoint('TOPLEFT', 2, 0)
                    reward.textBg:SetPoint('TOPLEFT', 0, 1)
                    reward.textBg:SetPoint('BOTTOMRIGHT', 2, -3)
                else
                    portrait:SetPoint('TOPLEFT', 2, -5)
                    reward.textBg:SetPoint('TOPLEFT', 0, -3)
                    reward.textBg:SetPoint('BOTTOMRIGHT', 2, 7)
                end

                if portrait then
                    local color = C.QualityColors[portrait.quality or 1]
                    portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
                end
            end
            -- Spell Rewards
            for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
                if not spellReward.styled then
                    reskinRewardButton(spellReward)

                    spellReward.styled = true
                end
            end
        end

        -- Reputation Rewards
        for repReward in rewardsFrame.reputationRewardPool:EnumerateActive() do
            if not repReward.styled then
                reskinRewardButton(repReward)
                repReward.styled = true
            end
        end
    end)

    -- Change text colors
    hooksecurefunc(_G.QuestInfoRequiredMoneyText, 'SetTextColor', replaceTextColor)
    hooksecurefunc(_G.QuestInfoSpellObjectiveLearnLabel, 'SetTextColor', replaceTextColor)

    local yellowish = {
        _G.QuestInfoTitleHeader,
        _G.QuestInfoDescriptionHeader,
        _G.QuestInfoObjectivesHeader,
        _G.QuestInfoRewardsFrame.Header,
    }
    for _, font in pairs(yellowish) do
        setTextColor_Yellow(font)
    end

    local whitish = {
        _G.QuestInfoDescriptionText,
        _G.QuestInfoObjectivesText,
        _G.QuestInfoGroupSize,
        _G.QuestInfoRewardText,
        _G.QuestInfoTimerText,
        _G.QuestInfoRewardsFrame.ItemChooseText,
        _G.QuestInfoRewardsFrame.ItemReceiveText,
        _G.QuestInfoRewardsFrame.PlayerTitleText,
        _G.QuestInfoRewardsFrame.XPFrame.ReceiveText,
    }
    for _, font in pairs(whitish) do
        setTextColor_White(font)
    end

    -- Replace seal signature string
    local replacedSealColor = {
        ['480404'] = 'c20606',
        ['042c54'] = '1c86ee',
    }
    hooksecurefunc(_G.QuestInfoSealFrame.Text, 'SetText', function(self, text)
        if text and text ~= '' then
            local colorStr, rawText = strmatch(text, '|c[fF][fF](%x%x%x%x%x%x)(.-)|r')
            if colorStr and rawText then
                colorStr = replacedSealColor[colorStr] or '99ccff'
                self:SetFormattedText('|cff%s%s|r', colorStr, rawText)
            end
        end
    end)
end)
