local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Map')
local TOOLTIP = F:GetModule('Tooltip')

function M:InitRenownLevel()
    if not FREE_ADB['RenownLevels'][C.REALM] then
        FREE_ADB['RenownLevels'][C.REALM] = {}
    end

    if not FREE_ADB['RenownLevels'][C.REALM][C.NAME] then
        FREE_ADB['RenownLevels'][C.REALM][C.NAME] = {}

        for i = 1, 4 do
            FREE_ADB['RenownLevels'][C.REALM][C.NAME][i] = 0
        end
    end
end

function M:CheckRenownLevel()
    local level = C_CovenantSanctumUI.GetRenownLevel()
    local CovenantID = C_Covenants.GetActiveCovenantID()

    FREE_ADB['RenownLevels'][C.REALM][C.NAME][CovenantID] = level
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
    local bar = CreateFrame('StatusBar', 'FreeUIMinimapProgressBar', Minimap)
    bar:SetPoint('TOPLEFT', 1, -Minimap.halfDiff - 1)
    bar:SetPoint('TOPRIGHT', -1, -Minimap.halfDiff - 1)
    bar:SetHeight(4)
    bar:SetStatusBarTexture(C.Assets.Statusbar.Normal)
    bar:SetFrameStrata('MEDIUM')
    bar.bg = F.CreateBDFrame(bar)
    bar.bg:SetBackdropBorderColor(0, 0, 0)

    bar:SetFrameLevel(Minimap:GetFrameLevel() + 2)
    bar:SetHitRectInsets(0, 0, 0, -10)

    local rest = CreateFrame('StatusBar', nil, bar)
    rest:SetAllPoints()
    rest:SetStatusBarTexture(C.Assets.Statusbar.Normal)
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
            rest:SetValue(math.min(xp + rxp, mxp))
            rest:Show()
        end
        if IsXPUserDisabled() then
            self:SetStatusBarColor(0.7, 0, 0)
        end
    elseif GetWatchedFactionInfo() then
        local _, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
        local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(
            factionID
        )
        if C_Reputation.IsFactionParagon(factionID) then
            local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
            currentValue = math.fmod(currentValue, threshold)
            barMin, barMax, value = 0, threshold, currentValue
        elseif friendID then
            if nextFriendThreshold then
                barMin, barMax, value = friendThreshold, nextFriendThreshold, friendRep
            else
                barMin, barMax, value = 0, 1, 1
            end
            standing = 5
        else
            if standing == MAX_REPUTATION_REACTION then
                barMin, barMax, value = 0, 1, 1
            end
        end
        self:SetStatusBarColor(
            FACTION_BAR_COLORS[standing].r,
            FACTION_BAR_COLORS[standing].g,
            FACTION_BAR_COLORS[standing].b,
            0.85
        )
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
    GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
    GameTooltip:ClearLines()
    GameTooltip:AddDoubleLine(C.NAME, LEVEL .. ': ' .. UnitLevel('player'), C.r, C.g, C.b, 1, 1, 1)

    if not IsPlayerAtEffectiveMaxLevel() then
        GameTooltip:AddLine(' ')
        local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
        GameTooltip:AddDoubleLine(
            XP .. ':',
            BreakUpLargeNumbers(xp)
                .. ' / '
                .. BreakUpLargeNumbers(mxp)
                .. ' ('
                .. string.format('%.1f%%)', xp / mxp * 100),
            0.6,
            0.8,
            1,
            1,
            1,
            1
        )
        if rxp then
            GameTooltip:AddDoubleLine(
                TUTORIAL_TITLE26 .. ':',
                '+' .. BreakUpLargeNumbers(rxp) .. ' (' .. string.format('%.1f%%)', rxp / mxp * 100),
                0.6,
                0.8,
                1,
                1,
                1,
                1
            )
        end
        if IsXPUserDisabled() then
            GameTooltip:AddLine('|cffff0000' .. XP .. LOCKED)
        end
    end

    if GetWatchedFactionInfo() then
        local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
        local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
        local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
        local colors = FACTION_BAR_COLORS[standing]
        local standingtext
        if friendID then
            if maxRank > 0 then
                name = name .. ' (' .. currentRank .. ' / ' .. maxRank .. ')'
            end
            if not nextFriendThreshold then
                barMax = barMin + 1e3
                value = barMax - 1
            end
            standingtext = friendTextLevel
        else
            if standing == MAX_REPUTATION_REACTION then
                barMax = barMin + 1e3
                value = barMax - 1
            end
            standingtext = _G['FACTION_STANDING_LABEL' .. standing] or UNKNOWN
        end
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(name, 0, 0.6, 1)
        GameTooltip:AddDoubleLine(
            standingtext,
            value - barMin
                .. ' / '
                .. barMax - barMin
                .. ' ('
                .. math.floor((value - barMin) / (barMax - barMin) * 100)
                .. '%)',
            colors.r,
            colors.g,
            colors.b,
            1,
            1,
            1
        )

        if C_Reputation.IsFactionParagon(factionID) then
            local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
            local paraCount = math.floor(currentValue / threshold)
            currentValue = math.fmod(currentValue, threshold)
            GameTooltip:AddDoubleLine(
                L['Paragon'] .. '(' .. paraCount .. ')',
                currentValue .. ' / ' .. threshold .. ' (' .. math.floor(currentValue / threshold * 100) .. '%)',
                0.6,
                0.8,
                1,
                1,
                1,
                1
            )
        end

        if factionID == 2465 then -- 荒猎团
            local _, rep, _, repName, _, _, reaction, threshold, nextThreshold = GetFriendshipReputation(2463) -- 玛拉斯缪斯
            if nextThreshold and rep > 0 then
                local current = rep - threshold
                local currentMax = nextThreshold - threshold
                GameTooltip:AddLine(' ')
                GameTooltip:AddLine(repName, 0, 0.6, 1)
                GameTooltip:AddDoubleLine(
                    reaction,
                    current .. ' / ' .. currentMax .. ' (' .. math.floor(current / currentMax * 100) .. '%)',
                    0.6,
                    0.8,
                    1,
                    1,
                    1,
                    1
                )
            end
        end
    end

    if IsWatchingHonorAsXP() then
        local current, barMax, level = UnitHonor('player'), UnitHonorMax('player'), UnitHonorLevel('player')
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(HONOR, 0, 0.6, 1)
        GameTooltip:AddDoubleLine(LEVEL .. ' ' .. level, current .. ' / ' .. barMax, 0.8, 0.2, 0, 1, 1, 1)
    end

    local covenantID = C_Covenants.GetActiveCovenantID()
    if covenantID and covenantID > 0 then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(LANDING_PAGE_RENOWN_LABEL, 0, 0.6, 1)

        for i = 1, 4 do
            local level = FREE_ADB['RenownLevels'][C.REALM][C.NAME][i]
            if level > 0 then
                GameTooltip:AddDoubleLine(TOOLTIP:GetCovenantIcon(i) .. TOOLTIP:GetCovenantName(i), level)
            end
        end
    end

    GameTooltip:Show()
end

function M:SetupScript()
    for _, event in pairs(eventsList) do
        M.Bar:RegisterEvent(event)
    end

    M.Bar:SetScript('OnEvent', M.Bar_Update)
    M.Bar:SetScript('OnEnter', M.Bar_OnEnter)
    M.Bar:SetScript('OnLeave', F.HideTooltip)

    hooksecurefunc(StatusTrackingBarManager, 'UpdateBarsShown', function()
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