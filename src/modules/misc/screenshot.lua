local F, C = unpack(select(2, ...))
local AS = F:RegisterModule('AutoScreenshot')

local function AchievementEarned(_, _, alreadyEarned)
    if not C.DB.General.EarnedNewAchievement then
        return
    end

    if alreadyEarned then
        return
    end

    F:Delay(1, function()
        Screenshot()
    end)
end

local function ChallengeModeCompleted()
    if not C.DB.General.ChallengeModeCompleted then
        return
    end

    _G.ChallengeModeCompleteBanner:HookScript('OnShow', function()
        F:Delay(1, function()
            Screenshot()
        end)
    end)
end

local function PlayerLevelUp()
    if not C.DB.General.PlayerLevelUp then
        return
    end

    F:Delay(1, function()
        Screenshot()
    end)
end

local function PlayerDead()
    if not C.DB.General.PlayerDead then
        return
    end

    F:Delay(1, function()
        Screenshot()
    end)
end

function AS:OnLogin()
    if not C.DB.General.AutoScreenshot then
        return
    end

    F:RegisterEvent('ACHIEVEMENT_EARNED', AchievementEarned)
    F:RegisterEvent('CHALLENGE_MODE_COMPLETED', ChallengeModeCompleted)
    F:RegisterEvent('PLAYER_LEVEL_UP', PlayerLevelUp)
    F:RegisterEvent('PLAYER_DEAD', PlayerDead)
end
