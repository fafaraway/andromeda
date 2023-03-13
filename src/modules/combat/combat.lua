local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')

local lowHealth = false
local lowMana = false

local powerTypes = {
    ['MANA'] = 0,
    ['RAGE'] = 1,
    ['FOCUS'] = 2,
    ['ENERGY'] = 3,
    ['RUNIC_POWER'] = 6,
    ['LUNAR_POWER'] = 8,
    ['MAELSTROM'] = 11,
    ['FURY'] = 17,
    ['PAIN'] = 18,
}

local allowedPowerTypes = {
    ['MANA'] = true,
    ['RAGE'] = false,
    ['FOCUS'] = false,
    ['ENERGY'] = false,
    ['RUNIC_POWER'] = false,
    ['LUNAR_POWER'] = false,
    ['MAELSTROM'] = false,
    ['FURY'] = false,
    ['PAIN'] = false,
}

local function lowHealthAlert(_, unit)
    if unit ~= 'player' then
        return
    end

    local threshold = C.DB.Combat.LowHealthThreshold
    local sound = C.Assets.Sounds.SekiroLowHealth

    if (UnitHealth('player') / UnitHealthMax('player')) <= threshold then
        if not lowHealth then
            PlaySoundFile(sound, 'Master')
            lowHealth = true
        end
    else
        lowHealth = false
    end
end

local function lowManaAlert(_, unit, powerType)
    if unit ~= 'player' or powerTypes[powerType] then
        return
    end

    local threshold = C.DB.Combat.LowManaThreshold
    local sound = C.Assets.Sounds.LowMana
    local cur = UnitPower('player', powerTypes[powerType])
    local max = UnitPowerMax('player', powerTypes[powerType])

    if (cur / max) <= threshold and not UnitIsDeadOrGhost('player') then
        if not lowMana then
            PlaySoundFile(sound, 'Master')
            lowMana = true
        end
    else
        lowMana = false
    end
end

function COMBAT:LowHealthAlert()
    if C.DB.Combat.LowHealth then
        F:RegisterEvent('UNIT_HEALTH', lowHealthAlert)
    else
        F:UnregisterEvent('UNIT_HEALTH', lowHealthAlert)
    end
end

function COMBAT:LowManaAlert()
    if C.DB.Combat.LowMana then
        F:RegisterEvent('UNIT_POWER_UPDATE', lowManaAlert)
    else
        F:UnregisterEvent('UNIT_POWER_UPDATE', lowManaAlert)
    end
end

local function spellAlert()
    local _, eventType, _, srcGUID, _, _, _, destGUID = CombatLogGetCurrentEventInfo()

    if not (srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet')) then
        return
    end

    if eventType == 'SPELL_INTERRUPT' and C.DB.Combat.Interrupt then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            PlaySoundFile(C.Assets.Sounds.Interrupt, 'Master')
        end
    elseif eventType == 'SPELL_DISPEL' and C.DB.Combat.Dispel then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            PlaySoundFile(C.Assets.Sounds.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_STOLEN' and C.DB.Combat.Steal then
        if srcGUID == UnitGUID('player') then
            PlaySoundFile(C.Assets.Sounds.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_MISSED' and C.DB.Combat.Miss then
        local missType, _, _ = select(15, CombatLogGetCurrentEventInfo())
        if missType == 'REFLECT' and destGUID == UnitGUID('player') then
            PlaySoundFile(C.Assets.Sounds.Missed, 'Master')
        end
    end
end

function COMBAT:SpellAlert()
    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', spellAlert)
end

function COMBAT:OnLogin()
    if not C.DB.Combat.Enable then
        return
    end

    COMBAT:LowHealthAlert()
    COMBAT:LowManaAlert()
    COMBAT:SpellAlert()
    COMBAT:CombatAlert()
    COMBAT:FloatingCombatText()
    COMBAT:KillingBlow()
    COMBAT:SmartTab()
    COMBAT:EasyFocus()
    COMBAT:EasyMark()
end
