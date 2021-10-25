local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Minimap')

function M:ExpBar_Update()
    local rest = self.restBar
    if rest then
        rest:Hide()
    end

    if not IsPlayerAtEffectiveMaxLevel() then
        local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
        self:SetStatusBarColor(.29, .59, .82)
        self:SetMinMaxValues(0, mxp)
        self:SetValue(xp)
        self:Show()
        if rxp then
            rest:SetMinMaxValues(0, mxp)
            rest:SetValue(math.min(xp + rxp, mxp))
            rest:Show()
        end
        if IsXPUserDisabled() then
            self:SetStatusBarColor(.7, 0, 0)
        end
    elseif GetWatchedFactionInfo() then
        local _, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
        local friendID, friendRep, _, _, _, _, _, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
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
            if standing == _G.MAX_REPUTATION_REACTION then
                barMin, barMax, value = 0, 1, 1
            end
        end
        self:SetStatusBarColor(_G.FACTION_BAR_COLORS[standing].r, _G.FACTION_BAR_COLORS[standing].g, _G.FACTION_BAR_COLORS[standing].b, .85)
        self:SetMinMaxValues(barMin, barMax)
        self:SetValue(value)
        self:Show()
    elseif IsWatchingHonorAsXP() then
        local current, barMax = UnitHonor('player'), UnitHonorMax('player')
        self:SetStatusBarColor(1, .24, 0)
        self:SetMinMaxValues(0, barMax)
        self:SetValue(current)
        self:Show()
    else
        self:Hide()
    end
end

function M:ExpBar_UpdateTooltip()
    _G.GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddDoubleLine(C.MyName, _G.LEVEL .. ': ' .. UnitLevel('player'), C.r, C.g, C.b, 1, 1, 1)

    if not IsPlayerAtEffectiveMaxLevel() then
        _G.GameTooltip:AddLine(' ')
        local xp, mxp, rxp = UnitXP('player'), UnitXPMax('player'), GetXPExhaustion()
        _G.GameTooltip:AddDoubleLine(_G.XP .. ':', BreakUpLargeNumbers(xp) .. ' / ' .. BreakUpLargeNumbers(mxp) .. ' (' .. string.format('%.1f%%)', xp / mxp * 100), .6, .8, 1, 1, 1, 1)
        if rxp then
            _G.GameTooltip:AddDoubleLine(_G.TUTORIAL_TITLE26 .. ':', '+' .. BreakUpLargeNumbers(rxp) .. ' (' .. string.format('%.1f%%)', rxp / mxp * 100), .6, .8, 1, 1, 1, 1)
        end
        if IsXPUserDisabled() then
            _G.GameTooltip:AddLine('|cffff0000' .. _G.XP .. _G.LOCKED)
        end
    end

    if GetWatchedFactionInfo() then
        local name, standing, barMin, barMax, value, factionID = GetWatchedFactionInfo()
        local friendID, _, _, _, _, _, friendTextLevel, _, nextFriendThreshold = GetFriendshipReputation(factionID)
        local currentRank, maxRank = GetFriendshipReputationRanks(friendID)
        local colors = _G.FACTION_BAR_COLORS[standing]
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
            if standing == _G.MAX_REPUTATION_REACTION then
                barMax = barMin + 1e3
                value = barMax - 1
            end
            standingtext = GetText('FACTION_STANDING_LABEL' .. standing, UnitSex('player'))
        end
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(name, 0, .6, 1)
        _G.GameTooltip:AddDoubleLine(
            standingtext,
            value - barMin .. ' / ' .. barMax - barMin .. ' (' .. math.floor((value - barMin) / (barMax - barMin) * 100) .. '%)',
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
            _G.GameTooltip:AddDoubleLine(L['Paragon'] .. '(' .. paraCount .. ')', currentValue .. ' / ' .. threshold .. ' (' .. math.floor(currentValue / threshold * 100) .. '%)', .6, .8, 1, 1, 1, 1)
        end

        if factionID == 2465 then -- 荒猎团
            local _, rep, _, name, _, _, reaction, threshold, nextThreshold = GetFriendshipReputation(2463) -- 玛拉斯缪斯
            if nextThreshold and rep > 0 then
                local current = rep - threshold
                local currentMax = nextThreshold - threshold
                _G.GameTooltip:AddLine(' ')
                _G.GameTooltip:AddLine(name, 0, .6, 1)
                _G.GameTooltip:AddDoubleLine(reaction, current .. ' / ' .. currentMax .. ' (' .. math.floor(current / currentMax * 100) .. '%)', .6, .8, 1, 1, 1, 1)
            end
        end
    end

    if IsWatchingHonorAsXP() then
        local current, barMax, level = UnitHonor('player'), UnitHonorMax('player'), UnitHonorLevel('player')
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(_G.HONOR, 0, .6, 1)
        _G.GameTooltip:AddDoubleLine(_G.LEVEL .. ' ' .. level, current .. ' / ' .. barMax, .8, .2, 0, 1, 1, 1)
    end

    _G.GameTooltip:Show()
end

function M:SetupScript(bar)
    bar.eventList = {
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
        'HONOR_XP_UPDATE'
    }
    for _, event in pairs(bar.eventList) do
        bar:RegisterEvent(event)
    end
    bar:SetScript('OnEvent', M.ExpBar_Update)
    bar:SetScript('OnEnter', M.ExpBar_UpdateTooltip)
    bar:SetScript('OnLeave', F.HideTooltip)
    bar:SetScript(
        'OnMouseUp',
        function(_, btn)
            if not HasArtifactEquipped() or btn ~= 'LeftButton' then
                return
            end
            if not _G.ArtifactFrame or not _G.ArtifactFrame:IsShown() then
                SocketInventoryItem(16)
            else
                F:TogglePanel(_G.ArtifactFrame)
            end
        end
    )
    hooksecurefunc(
        _G.StatusTrackingBarManager,
        'UpdateBarsShown',
        function()
            M.ExpBar_Update(bar)
        end
    )
end

function M:AddExpBar()
    if not C.DB.Map.ExpBar then
        return
    end

    local bar = CreateFrame('StatusBar', 'FreeUI_MinimapExpBar', _G.Minimap)
    bar:SetPoint('TOPLEFT', 1, -(_G.Minimap:GetHeight() / 8) - 1)
    bar:SetPoint('TOPRIGHT', -1, -(_G.Minimap:GetHeight() / 8) - 1)
    bar:SetHeight(4)
    bar:SetStatusBarTexture(C.Assets.norm_tex)
    bar.bg = F.CreateBDFrame(bar)

    bar:SetFrameLevel(_G.Minimap:GetFrameLevel() + 2)
    bar:SetHitRectInsets(0, 0, 0, -10)

    local rest = CreateFrame('StatusBar', nil, bar)
    rest:SetAllPoints()
    rest:SetStatusBarTexture(C.Assets.norm_tex)
    rest:SetStatusBarColor(.34, .45, .86, .8)
    rest:SetFrameLevel(bar:GetFrameLevel() - 1)
    bar.restBar = rest

    M:SetupScript(bar)
end
