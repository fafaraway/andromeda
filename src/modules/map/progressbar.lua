local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Map')
local TOOLTIP = F:GetModule('Tooltip')

local function IsAzeriteAvailable()
    local itemLocation = C_AzeriteItem.FindActiveAzeriteItem()
    return itemLocation and itemLocation:IsEquipmentSlot() and not C_AzeriteItem.IsAzeriteItemAtMaxLevel()
end

function M:InitRenownLevel()
    if not _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM] then
        _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM] = {}
    end

    if not _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM][C.MY_NAME] then
        _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM][C.MY_NAME] = {}

        for i = 1, 4 do
            _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM][C.MY_NAME][i] = 0
        end
    end
end

function M:CheckRenownLevel()
    local level = C_CovenantSanctumUI.GetRenownLevel()
    local CovenantID = C_Covenants.GetActiveCovenantID()

    _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM][C.MY_NAME][CovenantID] = level
end

function M:UpdateRenownLevel()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', function()
        F:Delay(1, function()
            M:CheckRenownLevel()
        end)
    end)
    F:RegisterEvent('COVENANT_CHOSEN', function()
        F:Delay(3, function()
            M:CheckRenownLevel()
        end)
    end)
    F:RegisterEvent('COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED', function()
        F:Delay(3, function()
            M:CheckRenownLevel()
        end)
    end)
end

local eventsList = {
    'PLAYER_XP_UPDATE',
    'PLAYER_LEVEL_UP',
    'UPDATE_EXHAUSTION',
    'PLAYER_ENTERING_WORLD',
    'UPDATE_FACTION',
    'ARTIFACT_XP_UPDATE',
    'PLAYER_EQUIPMENT_CHANGED',
    'ENABLE_XP_GAIN',
    'DISABLE_XP_GAIN',
    'AZERITE_ITEM_EXPERIENCE_CHANGED',
    'HONOR_XP_UPDATE',
}

function M:CreateBar()
    local Minimap = _G.Minimap
    local bar = CreateFrame('StatusBar', C.ADDON_TITLE .. 'MinimapProgressBar', Minimap)
    bar:SetPoint('TOPLEFT', 0, -Minimap.halfDiff)
    bar:SetPoint('TOPRIGHT', 0, -Minimap.halfDiff)
    bar:SetHeight(4)
    bar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    bar:SetFrameStrata('MEDIUM')
    bar.bg = F.CreateBDFrame(bar)
    bar.bg:SetBackdropBorderColor(0, 0, 0)

    bar:SetFrameLevel(Minimap:GetFrameLevel() + 2)
    bar:SetHitRectInsets(0, 0, 0, -10)

    local rest = CreateFrame('StatusBar', nil, bar)
    rest:SetAllPoints()
    rest:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    rest:SetStatusBarColor(0.34, 0.45, 0.86, 0.8)
    rest:SetFrameLevel(bar:GetFrameLevel() - 1)
    bar.restBar = rest

    M.Bar = bar
end

function M:Bar_Update()
    local rest = self.restBar
    if rest then
        rest:Hide()
    end

    if not IsPlayerAtEffectiveMaxLevel() then
        local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
        self:SetStatusBarColor(0.29, 0.59, 0.82)
        self:SetMinMaxValues(0, mxp)
        self:SetValue(xp)
        self:Show()

        if rxp then
            rest:SetMinMaxValues(0, mxp)
            rest:SetValue(min(xp + rxp, mxp))
            rest:Show()
        end

        if IsXPUserDisabled() then
            self:SetStatusBarColor(0.7, 0, 0)
        end
    elseif GetWatchedFactionInfo() then
        local _, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()

        if factionID and C_Reputation.IsMajorFaction(factionID) then
            local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
            value = majorFactionData.renownReputationEarned or 0
            barMin, barMax = 0, majorFactionData.renownLevelThreshold
        else
            local repInfo = C_GossipInfo.GetFriendshipReputation(factionID)
            local friendID, friendRep, friendThreshold, nextFriendThreshold = repInfo.friendshipFactionID, repInfo.standing, repInfo.reactionThreshold, repInfo.nextThreshold
            if C_Reputation.IsFactionParagon(factionID) then
                local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
                currentValue = mod(currentValue, threshold)
                barMin, barMax, value = 0, threshold, currentValue
            elseif friendID and friendID ~= 0 then
                if nextFriendThreshold then
                    barMin, barMax, value = friendThreshold, nextFriendThreshold, friendRep
                else
                    barMin, barMax, value = 0, 1, 1
                end
                standing = 5
            else
                if standing == _G.MAX_REPUTATION_REACTION then
                    barMin, barMax, value = 0, 1, 1
                end
            end
        end

        local color = _G.FACTION_BAR_COLORS[standing] or _G.FACTION_BAR_COLORS[5]
        self:SetStatusBarColor(color.r, color.g, color.b, 0.85)
        self:SetMinMaxValues(barMin, barMax)
        self:SetValue(value)
        self:Show()
    elseif IsWatchingHonorAsXP() then
        local current, barMax = UnitHonor('player'), UnitHonorMax('player')
        self:SetStatusBarColor(1, 0.24, 0)
        self:SetMinMaxValues(0, barMax)
        self:SetValue(current)
        self:Show()
    else
        self:Hide()
    end
end

function M:Bar_OnEnter()
    _G.GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddDoubleLine(C.MY_NAME, _G.LEVEL .. ': ' .. UnitLevel('player'), C.r, C.g, C.b, 1, 1, 1)

    if not IsPlayerAtEffectiveMaxLevel() then
        _G.GameTooltip:AddLine(' ')
        local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
        _G.GameTooltip:AddDoubleLine(_G.XP .. ':', BreakUpLargeNumbers(xp) .. ' / ' .. BreakUpLargeNumbers(mxp) .. ' (' .. format('%.1f%%)', xp / mxp * 100), 0.6, 0.8, 1, 1, 1, 1)
        if rxp then
            _G.GameTooltip:AddDoubleLine(_G.TUTORIAL_TITLE26 .. ':', '+' .. BreakUpLargeNumbers(rxp) .. ' (' .. format('%.1f%%)', rxp / mxp * 100), 0.6, 0.8, 1, 1, 1, 1)
        end
        if IsXPUserDisabled() then
            _G.GameTooltip:AddLine('|cffff0000' .. _G.XP .. _G.LOCKED)
        end
    end

    if GetWatchedFactionInfo() then
        local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
        local standingtext
        if factionID and C_Reputation.IsMajorFaction(factionID) then
            local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID)
            name = majorFactionData.name
            value = majorFactionData.renownReputationEarned or 0
            barMin, barMax = 0, majorFactionData.renownLevelThreshold
            standingtext = _G.RENOWN_LEVEL_LABEL .. majorFactionData.renownLevel
        else
            local repInfo = C_GossipInfo.GetFriendshipReputation(factionID)
            local friendID, friendRep, friendThreshold, nextFriendThreshold, friendTextLevel = repInfo.friendshipFactionID, repInfo.standing, repInfo.reactionThreshold, repInfo.nextThreshold, repInfo.text
            local repRankInfo = C_GossipInfo.GetFriendshipReputationRanks(factionID)
            local currentRank, maxRank = repRankInfo.currentLevel, repRankInfo.maxLevel
            if friendID and friendID ~= 0 then
                if maxRank > 0 then
                    name = name .. ' (' .. currentRank .. ' / ' .. maxRank .. ')'
                end
                if nextFriendThreshold then
                    barMin, barMax, value = friendThreshold, nextFriendThreshold, friendRep
                else
                    barMax = barMin + 1e3
                    value = barMax - 1
                end
                standingtext = friendTextLevel
            else
                if standing == _G.MAX_REPUTATION_REACTION then
                    barMax = barMin + 1e3
                    value = barMax - 1
                end
                standingtext = _G['FACTION_STANDING_LABEL' .. standing] or _G.UNKNOWN
            end
        end
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(name, 0, 0.6, 1)
        _G.GameTooltip:AddDoubleLine(standingtext, value - barMin .. ' / ' .. barMax - barMin .. ' (' .. floor((value - barMin) / (barMax - barMin) * 100) .. '%)', 0.6, 0.8, 1, 1, 1, 1)

        if C_Reputation.IsFactionParagon(factionID) then
            local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
            local paraCount = floor(currentValue / threshold)
            currentValue = mod(currentValue, threshold)
            _G.GameTooltip:AddDoubleLine(L['Paragon'] .. paraCount, currentValue .. ' / ' .. threshold .. ' (' .. floor(currentValue / threshold * 100) .. '%)', 0.6, 0.8, 1, 1, 1, 1)
        end

        if factionID == 2465 then -- 荒猎团
            local repInfo = C_GossipInfo.GetFriendshipReputation(2463) -- 玛拉斯缪斯
            local rep, name, reaction, threshold, nextThreshold = repInfo.standing, repInfo.name, repInfo.reaction, repInfo.reactionThreshold, repInfo.nextThreshold
            if nextThreshold and rep > 0 then
                local current = rep - threshold
                local currentMax = nextThreshold - threshold
                _G.GameTooltip:AddLine(' ')
                _G.GameTooltip:AddLine(name, 0, 0.6, 1)
                _G.GameTooltip:AddDoubleLine(reaction, current .. ' / ' .. currentMax .. ' (' .. floor(current / currentMax * 100) .. '%)', 0.6, 0.8, 1, 1, 1, 1)
            end
        end
    end

    if IsWatchingHonorAsXP() then
        local current, barMax, level = UnitHonor('player'), UnitHonorMax('player'), UnitHonorLevel('player')
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(_G.HONOR, 0, 0.6, 1)
        _G.GameTooltip:AddDoubleLine(_G.LEVEL .. ' ' .. level, current .. ' / ' .. barMax, 0.6, 0.8, 1, 1, 1, 1)
    end

    if IsAzeriteAvailable() then
        local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
        local azeriteItem = Item:CreateFromItemLocation(azeriteItemLocation)
        local xp, totalLevelXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
        local currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
        azeriteItem:ContinueWithCancelOnItemLoad(function()
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(azeriteItem:GetItemName() .. ' (' .. format(_G.SPELLBOOK_AVAILABLE_AT, currentLevel) .. ')', 0, 0.6, 1)
            _G.GameTooltip:AddDoubleLine(_G.ARTIFACT_POWER, BreakUpLargeNumbers(xp) .. ' / ' .. BreakUpLargeNumbers(totalLevelXP) .. ' (' .. floor(xp / totalLevelXP * 100) .. '%)', 0.6, 0.8, 1, 1, 1, 1)
        end)
    end

    if HasArtifactEquipped() then
        local _, _, name, _, totalXP, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
        local num, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, artifactTier)
        _G.GameTooltip:AddLine(' ')
        if C_ArtifactUI.IsEquippedArtifactDisabled() then
            _G.GameTooltip:AddLine(name, 0, 0.6, 1)
            _G.GameTooltip:AddLine(_G.ARTIFACT_RETIRED, 0.6, 0.8, 1, 1)
        else
            _G.GameTooltip:AddLine(name .. ' (' .. format(_G.SPELLBOOK_AVAILABLE_AT, pointsSpent) .. ')', 0, 0.6, 1)
            local numText = num > 0 and ' (' .. num .. ')' or ''
            _G.GameTooltip:AddDoubleLine(_G.ARTIFACT_POWER, BreakUpLargeNumbers(totalXP) .. numText, 0.6, 0.8, 1, 1, 1, 1)
            if xpForNextPoint ~= 0 then
                local perc = ' (' .. floor(xp / xpForNextPoint * 100) .. '%)'
                _G.GameTooltip:AddDoubleLine(L['Next Trait'], BreakUpLargeNumbers(xp) .. ' / ' .. BreakUpLargeNumbers(xpForNextPoint) .. perc, 0.6, 0.8, 1, 1, 1, 1)
            end
        end
    end

    local covenantID = C_Covenants.GetActiveCovenantID()
    if covenantID and covenantID > 0 then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(_G.LANDING_PAGE_RENOWN_LABEL, 0, 0.6, 1)

        for i = 1, 4 do
            local level = _G.ANDROMEDA_ADB['RenownLevels'][C.MY_REALM][C.MY_NAME][i]
            if level > 0 then
                _G.GameTooltip:AddDoubleLine(TOOLTIP:GetCovenantIcon(i) .. TOOLTIP:GetCovenantName(i), level)
            end
        end
    end

    _G.GameTooltip:Show()
end

function M:SetupScript()
    for _, event in pairs(eventsList) do
        M.Bar:RegisterEvent(event)
    end

    M.Bar:SetScript('OnEvent', M.Bar_Update)
    M.Bar:SetScript('OnEnter', M.Bar_OnEnter)
    M.Bar:SetScript('OnLeave', F.HideTooltip)

    hooksecurefunc(_G.StatusTrackingBarManager, 'UpdateBarsShown', function()
        M.Bar_Update(M.Bar)
    end)
end

function M:CreateProgressBar()
    if not C.DB.Map.ProgressBar then
        return
    end

    M:CreateBar()
    M:SetupScript()
    M:InitRenownLevel()
    M:UpdateRenownLevel()
end

-- #TODO
-- Paragon reputation info
function M:ParagonReputationSetup()
    hooksecurefunc('ReputationFrame_InitReputationRow', function(factionRow)
        local factionID = factionRow.factionID
        local factionContainer = factionRow.Container
        local factionBar = factionContainer.ReputationBar
        local factionStanding = factionBar.FactionStanding

        if factionContainer.Paragon:IsShown() then
            local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
            if currentValue then
                local barValue = mod(currentValue, threshold)
                local factionStandingtext = L['Paragon'] .. floor(currentValue / threshold)

                factionBar:SetMinMaxValues(0, threshold)
                factionBar:SetValue(barValue)
                factionStanding:SetText(factionStandingtext)
                factionRow.standingText = factionStandingtext
                factionRow.rolloverText = format(_G.REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(threshold))
            end
        end
    end)
end
