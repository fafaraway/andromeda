--[[
    Generate player's stats information
]]

local _G = _G
local unpack = unpack
local select = select
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization
local GetAverageItemLevel = GetAverageItemLevel
local UnitHealthMax = UnitHealthMax
local C_Covenants_GetCovenantData = C_Covenants.GetCovenantData
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local C_Soulbinds_GetActiveSoulbindID = C_Soulbinds.GetActiveSoulbindID
local C_Soulbinds_GetSoulbindData = C_Soulbinds.GetSoulbindData
local UnitClass = UnitClass
local UnitStat = UnitStat
local UnitArmor = UnitArmor
local GetDodgeChance = GetDodgeChance
local GetParryChance = GetParryChance
local GetBlockChance = GetBlockChance
local GetCritChance = GetCritChance
local GetMeleeHaste = GetMeleeHaste
local GetMasteryEffect = GetMasteryEffect
local GetCombatRatingBonus = GetCombatRatingBonus
local GetVersatilityBonus = GetVersatilityBonus
local CLASS = CLASS
local CLUB_FINDER_SPEC = CLUB_FINDER_SPEC
local ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL = ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL
local PET_BATTLE_STAT_HEALTH = PET_BATTLE_STAT_HEALTH
local PRIMARY_STAT1_TOOLTIP_NAME = PRIMARY_STAT1_TOOLTIP_NAME
local PRIMARY_STAT2_TOOLTIP_NAME = PRIMARY_STAT2_TOOLTIP_NAME
local PRIMARY_STAT4_TOOLTIP_NAME = PRIMARY_STAT4_TOOLTIP_NAME
local PRIMARY_STAT3_TOOLTIP_NAME = PRIMARY_STAT3_TOOLTIP_NAME
local STAT_ARMOR = STAT_ARMOR
local STAT_DODGE = STAT_DODGE
local STAT_PARRY = STAT_PARRY
local STAT_BLOCK = STAT_BLOCK
local STAT_CRITICAL_STRIKE = STAT_CRITICAL_STRIKE
local STAT_HASTE = STAT_HASTE
local STAT_MASTERY = STAT_MASTERY
local STAT_VERSATILITY = STAT_VERSATILITY

local F, C, L = unpack(select(2, ...))
local SR = F:RegisterModule('StatsReport')

local function GetSpec()
    local Spec = GetSpecialization()
    local SpecName = Spec and select(2, GetSpecializationInfo(Spec)) or '无'

    return SpecName
end

local function GetCovenant()
    local covID = C_Covenants_GetActiveCovenantID()
    local covData = C_Covenants_GetCovenantData(covID)
    local covName = covData.name

    return covName
end

local function GetSoulBind()
    local sbID = C_Soulbinds_GetActiveSoulbindID()
    local sbData = C_Soulbinds_GetSoulbindData(sbID)
    local sbName = sbData.name

    return sbName
end

local function GenerateBasicInfo()
    local basicStats = ''
    basicStats = basicStats .. (L['Stats report'] .. '|n')
    basicStats = basicStats .. (CLASS .. ': %s '):format(UnitClass('player'))
    basicStats = basicStats .. (CLUB_FINDER_SPEC .. ': %s'):format(GetSpec())
    basicStats = basicStats .. ('|n' .. ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL .. ': %.1f / %.1f'):format(GetAverageItemLevel())

    if C_Covenants_GetActiveCovenantID() ~= 0 then
        basicStats = basicStats .. ('|n' .. L['Covenant: %s Soulbinds: %s']):format(GetCovenant(), GetSoulBind())
    end

    basicStats = basicStats .. ('|n' .. PET_BATTLE_STAT_HEALTH .. ': %s '):format(UnitHealthMax('player'))

    return basicStats
end

local dpsStats = {'', '', ''}
local specAttr = {
    WARRIOR = {1, 1, 1},
    DEATHKNIGHT = {1, 1, 1},
    ROGUE = {2, 2, 2},
    HUNTER = {2, 2, 2},
    DEMONHUNTER = {2, 2},
    MAGE = {3, 3, 3},
    WARLOCK = {3, 3, 3},
    PRIEST = {3, 3, 3},
    SHAMAN = {3, 2, 3},
    MONK = {2, 3, 2},
    DRUID = {3, 2, 2, 3},
    PALADIN = {3, 1, 1},
}

local function GenerateDpsInfo()

    local specId = GetSpecialization()
    local _, className = UnitClass('player')
    local classSpecArr = specAttr[className]

    dpsStats[1] = (PRIMARY_STAT1_TOOLTIP_NAME .. ': %s '):format(UnitStat('player', 1))
    dpsStats[2] = (PRIMARY_STAT2_TOOLTIP_NAME .. ': %s '):format(UnitStat('player', 2))
    dpsStats[3] = (PRIMARY_STAT4_TOOLTIP_NAME .. ': %s '):format(UnitStat('player', 4))

    return dpsStats[classSpecArr[specId]]
end

local function GenerateTankInfo()
    local tankStats = ''
    tankStats = tankStats .. (PRIMARY_STAT3_TOOLTIP_NAME .. ': %s '):format(UnitStat('player', 3))
    tankStats = tankStats .. (STAT_ARMOR .. ': %s '):format(select(3, UnitArmor('player')))
    tankStats = tankStats .. (STAT_DODGE .. ': %.0f%% '):format(GetDodgeChance())
    tankStats = tankStats .. (STAT_PARRY .. ': %.0f%% '):format(GetParryChance())
    tankStats = tankStats .. (STAT_BLOCK .. ': %.0f%% '):format(GetBlockChance())
    return tankStats
end

local function GenerateHealerInfo()
    local healerStats = ''
    -- healerStats = healerStats..("Spirit: %s "):format(UnitStat("player", 5))
    -- healerStats = healerStats .. ("ManaRegen: %d "):format(GetManaRegen() * 5)

    return healerStats
end

local function GenerateExtraInfo()
    local cvdd = _G.CR_VERSATILITY_DAMAGE_DONE
    local extraStats = ''

    extraStats = extraStats .. (STAT_CRITICAL_STRIKE .. ': %.0f%% '):format(GetCritChance())
    extraStats = extraStats .. (STAT_HASTE .. ': %.0f%% '):format(GetMeleeHaste())
    extraStats = extraStats .. (STAT_MASTERY .. ': %.0f%% '):format(GetMasteryEffect())
    extraStats = extraStats .. (STAT_VERSATILITY .. ': %.0f%% '):format(GetCombatRatingBonus(cvdd) + GetVersatilityBonus(cvdd))

    return extraStats
end

function SR:GenerateStatsInfo()
    if C.MyLevel < 10 then
        return GenerateBasicInfo()
    end

    local myStats = ''

    if C.MyRole == 'Healer' then
        myStats = myStats .. GenerateBasicInfo() .. GenerateDpsInfo() .. GenerateHealerInfo() .. GenerateExtraInfo()
    elseif C.MyRole == 'Tank' then
        myStats = myStats .. GenerateBasicInfo() .. GenerateDpsInfo() .. GenerateTankInfo() .. GenerateExtraInfo()
    else
        myStats = myStats .. GenerateBasicInfo() .. GenerateDpsInfo() .. GenerateExtraInfo()
    end

    return myStats
end

function SR:OnLogin()
    _G.SlashCmdList.STATSREPORT = function()
        print(SR.GenerateStatsInfo())
    end

    _G.SLASH_STATSREPORT1 = '/statsreport'
    _G.SLASH_STATSREPORT2 = '/sr'
end
