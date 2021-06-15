local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local AS = F:RegisterModule('AutoScreenshot')

local function AchievementEarned(...)
    if not C.DB.General.EarnedNewAchievement then
        return
    end

    local _, _, alreadyEarned = ...

    if alreadyEarned then
        return
    end

    F:Delay(1, _G.Screenshot)
end

local function ChallengeModeCompleted()
    if not C.DB.General.ChallengeModeCompleted then
        return
    end

    F:Delay(2, _G.Screenshot)
end

local function PlayerLevelUp()
    if not C.DB.General.PlayerLevelUp then
        return
    end

    F:Delay(1, _G.Screenshot)
end

local function PlayerDead()
    if not C.DB.General.PlayerDead then
        return
    end

    F:Delay(1, _G.Screenshot)
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
