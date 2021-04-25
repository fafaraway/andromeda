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

local F, C = unpack(select(2, ...))
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
    basicStats = basicStats .. ('StatsReport: |n')
    basicStats = basicStats .. ('Class: %s|n'):format(UnitClass('player'))
    basicStats = basicStats .. ('Specialization: %s|n'):format(GetSpec())
    basicStats = basicStats .. ('ItemLevel: %.1f / %.1f|n'):format(GetAverageItemLevel())
    basicStats = basicStats .. ('Health: %s'):format(UnitHealthMax('player'))

    if C_Covenants_GetActiveCovenantID() ~= 0 then
        basicStats = basicStats .. ('|nCovenant: %s SoulBinds: %s'):format(GetCovenant(), GetSoulBind())
    end

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

    dpsStats[1] = ('strength: %s '):format(UnitStat('player', 1))
    dpsStats[2] = ('Agility: %s '):format(UnitStat('player', 2))
    dpsStats[3] = ('intellect: %s '):format(UnitStat('player', 4))

    return dpsStats[classSpecArr[specId]]
end

local function GenerateTankInfo()
    local tankStats = ''
    tankStats = tankStats .. ('stamina: %s '):format(UnitStat('player', 3))
    tankStats = tankStats .. ('Armor: %s '):format(select(3, UnitArmor('player')))
    tankStats = tankStats .. ('Dodge: %.0f%% '):format(GetDodgeChance())
    tankStats = tankStats .. ('Parry: %.0f%% '):format(GetParryChance())
    tankStats = tankStats .. ('Block: %.0f%% '):format(GetBlockChance())
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

    extraStats = extraStats .. ('Crit: %.0f%% '):format(GetCritChance())
    extraStats = extraStats .. ('Haste: %.0f%% '):format(GetMeleeHaste())
    extraStats = extraStats .. ('Mastery: %.0f%% '):format(GetMasteryEffect())
    extraStats = extraStats .. ('Versatility: %.0f%% '):format(GetCombatRatingBonus(cvdd) + GetVersatilityBonus(cvdd))

    return extraStats
end

function SR:GenerateStatsInfo()
    if C.MyLevel < 10 then
        return GenerateBasicInfo()
    end

    local myStats = ''

    if C.MyRole == 'Healer' then
        myStats = myStats .. '|n' .. GenerateBasicInfo() .. '|n' .. GenerateDpsInfo() .. '|n' .. GenerateHealerInfo() .. '|n' .. GenerateExtraInfo()
    elseif C.MyRole == 'Tank' then
        myStats = myStats .. '|n' .. GenerateBasicInfo() .. '|n' .. GenerateDpsInfo() .. '|n' .. GenerateTankInfo() .. '|n' .. GenerateExtraInfo()
    else
        myStats = myStats .. '|n' .. GenerateBasicInfo() .. '|n' .. GenerateDpsInfo() .. '|n' .. GenerateExtraInfo()
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
