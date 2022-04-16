local F, C, L = unpack(select(2, ...))
local ECF = F:RegisterModule('EnhancedChallengeFrame')

local hasAngryKeystones
local frame
local WeeklyRunsThreshold = 10

function ECF:GuildBest_UpdateTooltip()
    local leaderInfo = self.leaderInfo
    if not leaderInfo then
        return
    end

    _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    local name = C_ChallengeMode.GetMapUIInfo(leaderInfo.mapChallengeModeID)
    _G.GameTooltip:SetText(name, 1, 1, 1)
    _G.GameTooltip:AddLine(string.format(_G.CHALLENGE_MODE_POWER_LEVEL, leaderInfo.keystoneLevel))
    for i = 1, #leaderInfo.members do
        local classColorStr = string.sub(F:RgbToHex(F:ClassColor(leaderInfo.members[i].classFileName)), 3, 10)
        _G.GameTooltip:AddLine(
            string.format(_G.CHALLENGE_MODE_GUILD_BEST_LINE, classColorStr, leaderInfo.members[i].name)
        )
    end
    _G.GameTooltip:Show()
end

function ECF:GuildBest_Create()
    frame = CreateFrame('Frame', nil, _G.ChallengesFrame, 'BackdropTemplate')
    frame:SetPoint('BOTTOMRIGHT', -8, 75)
    frame:SetSize(170, 105)
    F.CreateBD(frame, 0.3)
    F.CreateFS(frame, C.Assets.Font.Regular, 14, true, _G.GUILD, nil, nil, 'TOPLEFT', 16, -6)

    frame.entries = {}
    for i = 1, 4 do
        local entry = CreateFrame('Frame', nil, frame)
        entry:SetPoint('LEFT', 10, 0)
        entry:SetPoint('RIGHT', -10, 0)
        entry:SetHeight(18)
        entry.CharacterName = F.CreateFS(entry, C.Assets.Font.Regular, 12, true, '', nil, nil, 'LEFT', 6, 0)
        entry.CharacterName:SetPoint('RIGHT', -30, 0)
        entry.CharacterName:SetJustifyH('LEFT')
        entry.Level = F.CreateFS(entry, C.Assets.Font.Regular, 12, true)
        entry.Level:SetJustifyH('LEFT')
        entry.Level:ClearAllPoints()
        entry.Level:SetPoint('LEFT', entry, 'RIGHT', -22, 0)
        entry:SetScript('OnEnter', self.GuildBest_UpdateTooltip)
        entry:SetScript('OnLeave', F.HideTooltip)
        if i == 1 then
            entry:SetPoint('TOP', frame, 0, -26)
        else
            entry:SetPoint('TOP', frame.entries[i - 1], 'BOTTOM')
        end

        frame.entries[i] = entry
    end

    if not hasAngryKeystones then
        _G.ChallengesFrame.WeeklyInfo.Child.Description:SetPoint('CENTER', 0, 20)
    end
end

function ECF:GuildBest_SetUp(leaderInfo)
    self.leaderInfo = leaderInfo
    local str = _G.CHALLENGE_MODE_GUILD_BEST_LINE
    if leaderInfo.isYou then
        str = _G.CHALLENGE_MODE_GUILD_BEST_LINE_YOU
    end

    local classColorStr = string.sub(F:RgbToHex(F:ClassColor(leaderInfo.classFileName)), 3, 10)
    self.CharacterName:SetText(string.format(str, classColorStr, leaderInfo.name))
    self.Level:SetText(leaderInfo.keystoneLevel)
end

local resize
function ECF:GuildBest_Update()
    if not frame then
        ECF:GuildBest_Create()
    end
    if self.leadersAvailable then
        local leaders = C_ChallengeMode.GetGuildLeaders()
        if leaders and #leaders > 0 then
            for i = 1, #leaders do
                ECF.GuildBest_SetUp(frame.entries[i], leaders[i])
            end
            frame:Show()
        else
            frame:Hide()
        end
    end

    if not resize and hasAngryKeystones then
        hooksecurefunc(self.WeeklyInfo.Child.WeeklyChest, 'SetPoint', function(frame, _, x, y)
            if x == 100 and y == -30 then
                frame:SetPoint('LEFT', 105, -5)
            end
        end)
        self.WeeklyInfo.Child.ThisWeekLabel:SetPoint('TOP', -135, -25)

        local schedule = _G.AngryKeystones.Modules.Schedule
        frame:SetWidth(246)
        frame:ClearAllPoints()
        frame:SetPoint('BOTTOMLEFT', schedule.AffixFrame, 'TOPLEFT', 0, 10)

        local keystoneText = schedule.KeystoneText
        keystoneText:SetFontObject(_G.Game13Font)
        keystoneText:ClearAllPoints()
        keystoneText:SetPoint('TOP', self.WeeklyInfo.Child.DungeonScoreInfo.Score, 'BOTTOM', 0, -3)

        local affix = self.WeeklyInfo.Child.Affixes[1]
        if affix then
            affix:ClearAllPoints()
            affix:SetPoint('TOPLEFT', 20, -55)
        end

        resize = true
    end
end

function ECF.GuildBest_OnLoad(event, addon)
    if addon == 'Blizzard_ChallengesUI' then
        hooksecurefunc('ChallengesFrame_Update', ECF.GuildBest_Update)
        ECF:KeystoneInfo_Create()
        _G.ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript('OnEnter', ECF.KeystoneInfo_WeeklyRuns)

        F:UnregisterEvent(event, ECF.GuildBest_OnLoad)
    end
end

local function sortHistory(entry1, entry2)
    if entry1.level == entry2.level then
        return entry1.mapChallengeModeID < entry2.mapChallengeModeID
    else
        return entry1.level > entry2.level
    end
end

function ECF:KeystoneInfo_WeeklyRuns()
    local runHistory = C_MythicPlus.GetRunHistory(false, true)
    local numRuns = runHistory and #runHistory

    if numRuns > 0 then
        local isShiftKeyDown = IsShiftKeyDown()

        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddDoubleLine(
            isShiftKeyDown and _G.CHALLENGE_MODE_THIS_WEEK
                or string.format(_G.WEEKLY_REWARDS_MYTHIC_TOP_RUNS, WeeklyRunsThreshold),
            '(' .. numRuns .. ')',
            0.6,
            0.8,
            1
        )
        table.sort(runHistory, sortHistory)

        for i = 1, isShiftKeyDown and numRuns or WeeklyRunsThreshold do
            local runInfo = runHistory[i]
            if not runInfo then
                break
            end

            local name = C_ChallengeMode.GetMapUIInfo(runInfo.mapChallengeModeID)
            local r, g, b = 0, 1, 0
            if not runInfo.completed then
                r, g, b = 1, 0, 0
            end
            _G.GameTooltip:AddDoubleLine(name, 'Lv.' .. runInfo.level, 1, 1, 1, r, g, b)
        end

        if not isShiftKeyDown then
            _G.GameTooltip:AddLine(L['Hold Shift'], 0.6, 0.8, 1)
        end

        _G.GameTooltip:Show()
    end
end

function ECF:KeystoneInfo_Create()
    local texture = select(10, GetItemInfo(158923)) or 525134
    local iconColor = C.QualityColors[_G.LE_ITEM_QUALITY_EPIC or 4]
    local button = CreateFrame('Frame', nil, _G.ChallengesFrame.WeeklyInfo, 'BackdropTemplate')
    button:SetPoint('BOTTOMLEFT', 10, 67)
    button:SetSize(35, 35)
    F.PixelIcon(button, texture, true)
    button.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)
    button:SetScript('OnEnter', function(self)
        _G.GameTooltip:ClearLines()
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:AddLine(L['Account Keystones'])
        for name, info in pairs(_G.FREE_ADB.KeystoneInfo) do
            local name = Ambiguate(name, 'none')
            local mapID, level, class, faction = string.split(':', info)
            local color = F:RgbToHex(F:ClassColor(class))
            local factionColor = faction == 'Horde' and '|cffff5040' or '|cff00adf0'
            local dungeon = C_ChallengeMode.GetMapUIInfo(tonumber(mapID))
            _G.GameTooltip:AddDoubleLine(
                string.format(color .. '%s:|r', name),
                string.format('%s%s(%s)|r', factionColor, dungeon, level)
            )
        end
        _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
        _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. _G.GREAT_VAULT_REWARDS .. ' ', 1, 1, 1, 0.6, 0.8, 1)
        _G.GameTooltip:AddDoubleLine(
            ' ',
            C.MOUSE_MIDDLE_BUTTON .. L['Delete keystones info'] .. ' ',
            1,
            1,
            1,
            0.6,
            0.8,
            1
        )
        _G.GameTooltip:Show()
    end)
    button:SetScript('OnLeave', F.HideTooltip)
    button:SetScript('OnMouseUp', function(_, btn)
        if btn == 'LeftButton' then
            if not _G.WeeklyRewardsFrame then
                _G.WeeklyRewards_LoadUI()
            end
            F:TogglePanel(_G.WeeklyRewardsFrame)
        elseif btn == 'MiddleButton' then
            table.wipe(_G.FREE_ADB.KeystoneInfo)
            ECF:KeystoneInfo_Update() -- update own keystone info after reset
        end
    end)
end

function ECF:KeystoneInfo_UpdateBag()
    local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    if keystoneMapID then
        return keystoneMapID, C_MythicPlus.GetOwnedKeystoneLevel()
    end
end

function ECF:KeystoneInfo_Update()
    local mapID, keystoneLevel = ECF:KeystoneInfo_UpdateBag()
    if mapID then
        _G.FREE_ADB['KeystoneInfo'][C.FULL_NAME] = mapID .. ':' .. keystoneLevel .. ':' .. C.CLASS .. ':' .. C.FACTION
    else
        _G.FREE_ADB['KeystoneInfo'][C.FULL_NAME] = nil
    end
end

function ECF:OnLogin()
    hasAngryKeystones = IsAddOnLoaded('AngryKeystones')
    F:RegisterEvent('ADDON_LOADED', ECF.GuildBest_OnLoad)

    ECF:KeystoneInfo_Update()
    F:RegisterEvent('BAG_UPDATE', ECF.KeystoneInfo_Update)
end
