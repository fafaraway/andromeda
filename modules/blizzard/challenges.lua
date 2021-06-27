local _G = _G
local unpack = unpack
local select = select
local pairs = pairs
local wipe = wipe
local format = format
local strsplit = strsplit
local tonumber = tonumber
local sort = sort
local Ambiguate = Ambiguate
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = IsAddOnLoaded
local GetItemInfo = GetItemInfo
local WeeklyRewards_LoadUI = WeeklyRewards_LoadUI
local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetGuildLeaders = C_ChallengeMode.GetGuildLeaders
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local CHALLENGE_MODE_POWER_LEVEL = CHALLENGE_MODE_POWER_LEVEL
local CHALLENGE_MODE_GUILD_BEST_LINE = CHALLENGE_MODE_GUILD_BEST_LINE
local CHALLENGE_MODE_GUILD_BEST_LINE_YOU = CHALLENGE_MODE_GUILD_BEST_LINE_YOU
local WEEKLY_REWARDS_MYTHIC_TOP_RUNS = WEEKLY_REWARDS_MYTHIC_TOP_RUNS
local LE_ITEM_QUALITY_EPIC = LE_ITEM_QUALITY_EPIC

local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local hasAngryKeystones
local frame
local WeeklyRunsThreshold = 10

function BLIZZARD:GuildBest_UpdateTooltip()
    local leaderInfo = self.leaderInfo
    if not leaderInfo then
        return
    end

    _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    local name = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
    _G.GameTooltip:SetText(name, 1, 1, 1)
    _G.GameTooltip:AddLine(format(CHALLENGE_MODE_POWER_LEVEL, leaderInfo.keystoneLevel))
    for i = 1, #leaderInfo.members do
        local classColorStr = string.sub(F:RGBToHex(F:ClassColor(leaderInfo.members[i].classFileName)), 3, 10)
        _G.GameTooltip:AddLine(format(CHALLENGE_MODE_GUILD_BEST_LINE, classColorStr, leaderInfo.members[i].name))
    end
    _G.GameTooltip:Show()
end

function BLIZZARD:GuildBest_Create()
    frame = CreateFrame('Frame', nil, _G.ChallengesFrame, 'BackdropTemplate')
    frame:SetPoint('BOTTOMRIGHT', -8, 75)
    frame:SetSize(170, 105)
    F.CreateBD(frame, .3)
    F.CreateFS(frame, C.Assets.Fonts.Regular, 14, true, _G.GUILD, nil, nil, 'TOPLEFT', 16, -6)

    frame.entries = {}
    for i = 1, 4 do
        local entry = CreateFrame('Frame', nil, frame)
        entry:SetPoint('LEFT', 10, 0)
        entry:SetPoint('RIGHT', -10, 0)
        entry:SetHeight(18)
        entry.CharacterName = F.CreateFS(entry, C.Assets.Fonts.Regular, 12, true, '', nil, nil, 'LEFT', 6, 0)
        entry.CharacterName:SetPoint('RIGHT', -30, 0)
        entry.CharacterName:SetJustifyH('LEFT')
        entry.Level = F.CreateFS(entry, C.Assets.Fonts.Regular, 12, true)
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

function BLIZZARD:GuildBest_SetUp(leaderInfo)
    self.leaderInfo = leaderInfo
    local str = CHALLENGE_MODE_GUILD_BEST_LINE
    if leaderInfo.isYou then
        str = CHALLENGE_MODE_GUILD_BEST_LINE_YOU
    end

    local classColorStr = string.sub(F:RGBToHex(F:ClassColor(leaderInfo.classFileName)), 3, 10)
    self.CharacterName:SetText(format(str, classColorStr, leaderInfo.name))
    self.Level:SetText(leaderInfo.keystoneLevel)
end

local resize
function BLIZZARD:GuildBest_Update()
    if not frame then
        BLIZZARD:GuildBest_Create()
    end
    if self.leadersAvailable then
        local leaders = C_ChallengeMode_GetGuildLeaders()
        if leaders and #leaders > 0 then
            for i = 1, #leaders do
                BLIZZARD.GuildBest_SetUp(frame.entries[i], leaders[i])
            end
            frame:Show()
        else
            frame:Hide()
        end
    end

    if not resize and hasAngryKeystones then
        local scheduel = select(5, self:GetChildren())
        frame:SetWidth(246)
        frame:ClearAllPoints()
        frame:SetPoint('BOTTOMLEFT', scheduel, 'TOPLEFT', 0, 10)

        self.WeeklyInfo.Child.ThisWeekLabel:SetPoint('TOP', -135, -25)
        if C.IsNewPatch then
            self.WeeklyInfo.Child.DungeonScoreInfo:SetPoint('TOP', -140, -210)
        end

        local affix = self.WeeklyInfo.Child.Affixes[1]
        if affix then
            affix:ClearAllPoints()
            affix:SetPoint('TOPLEFT', 20, -55)
        end

        resize = true
    end
end

function BLIZZARD.GuildBest_OnLoad(event, addon)
    if addon == 'Blizzard_ChallengesUI' then
        hooksecurefunc('ChallengesFrame_Update', BLIZZARD.GuildBest_Update)
        BLIZZARD:KeystoneInfo_Create()
        _G.ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript('OnEnter', BLIZZARD.KeystoneInfo_WeeklyRuns)

        F:UnregisterEvent(event, BLIZZARD.GuildBest_OnLoad)
    end
end

local function sortHistory(entry1, entry2)
    if entry1.level == entry2.level then
        return entry1.mapChallengeModeID < entry2.mapChallengeModeID
    else
        return entry1.level > entry2.level
    end
end

function BLIZZARD:KeystoneInfo_WeeklyRuns()
    local runHistory = C_MythicPlus_GetRunHistory(false, true)
    local numRuns = runHistory and #runHistory
    if numRuns > 0 then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddDoubleLine(format(WEEKLY_REWARDS_MYTHIC_TOP_RUNS, WeeklyRunsThreshold), '(' .. numRuns .. ')', .6, .8, 1)
        sort(runHistory, sortHistory)

        for i = 1, WeeklyRunsThreshold do
            local runInfo = runHistory[i]
            if not runInfo then
                break
            end

            local name = C_ChallengeMode_GetMapUIInfo(runInfo.mapChallengeModeID)
            local r, g, b = 0, 1, 0
            if not runInfo.completed then
                r, g, b = 1, 0, 0
            end
            _G.GameTooltip:AddDoubleLine(name, 'Lv.' .. runInfo.level, 1, 1, 1, r, g, b)
        end
        _G.GameTooltip:Show()
    end
end

function BLIZZARD:KeystoneInfo_Create()
    local texture = select(10, GetItemInfo(158923)) or 525134
    local iconColor = C.QualityColors[LE_ITEM_QUALITY_EPIC or 4]
    local button = CreateFrame('Frame', nil, _G.ChallengesFrame.WeeklyInfo, 'BackdropTemplate')
    button:SetPoint('BOTTOMLEFT', 10, 67)
    button:SetSize(35, 35)
    F.PixelIcon(button, texture, true)
    button.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)
    button:SetScript(
        'OnEnter',
        function(self)
            _G.GameTooltip:ClearLines()
            _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
            _G.GameTooltip:AddLine(L['Account Keystones'])
            for name, info in pairs(_G.FREE_ADB.KeystoneInfo) do
                local name = Ambiguate(name, 'none')
                local mapID, level, class, faction = strsplit(':', info)
                local color = F:RGBToHex(F:ClassColor(class))
                local factionColor = faction == 'Horde' and '|cffff5040' or '|cff00adf0'
                local dungeon = C_ChallengeMode_GetMapUIInfo(tonumber(mapID))
                _G.GameTooltip:AddDoubleLine(format(color .. '%s:|r', name), format('%s%s(%s)|r', factionColor, dungeon, level))
            end
            _G.GameTooltip:AddDoubleLine(' ', C.LineString)
            _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. _G.GREAT_VAULT_REWARDS .. ' ', 1, 1, 1, .6, .8, 1)
            _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_middle .. L['Delete keystones info'] .. ' ', 1, 1, 1, .6, .8, 1)
            _G.GameTooltip:Show()
        end
    )
    button:SetScript('OnLeave', F.HideTooltip)
    button:SetScript(
        'OnMouseUp',
        function(_, btn)
            if btn == 'LeftButton' then
                if not _G.WeeklyRewardsFrame then
                    WeeklyRewards_LoadUI()
                end
                F:TogglePanel(_G.WeeklyRewardsFrame)
            elseif btn == 'MiddleButton' then
                wipe(_G.FREE_ADB.KeystoneInfo)
            end
        end
    )
end

function BLIZZARD:KeystoneInfo_UpdateBag()
    local keystoneMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
    if keystoneMapID then
        return keystoneMapID, C_MythicPlus_GetOwnedKeystoneLevel()
    end
end

function BLIZZARD:KeystoneInfo_Update()
    local mapID, keystoneLevel = BLIZZARD:KeystoneInfo_UpdateBag()
    if mapID then
        _G.FREE_ADB['KeystoneInfo'][C.MyFullName] = mapID .. ':' .. keystoneLevel .. ':' .. C.MyClass .. ':' .. C.MyFaction
    else
        _G.FREE_ADB['KeystoneInfo'][C.MyFullName] = nil
    end
end

function BLIZZARD:GuildBest()
    hasAngryKeystones = IsAddOnLoaded('AngryKeystones')
    F:RegisterEvent('ADDON_LOADED', BLIZZARD.GuildBest_OnLoad)

    BLIZZARD:KeystoneInfo_Update()
    F:RegisterEvent('BAG_UPDATE', BLIZZARD.KeystoneInfo_Update)
end

BLIZZARD:RegisterBlizz('GuildBest', BLIZZARD.GuildBest)
