local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')

local playedLowHealth = false
local playedLowMana = false

function COMBAT:COMBAT_LOG_EVENT_UNFILTERED()
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
    elseif eventType == 'SPELL_STOLEN' and C.DB.Combat.SpellSteal then
        if srcGUID == UnitGUID('player') then
            PlaySoundFile(C.Assets.Sounds.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_MISSED' and C.DB.Combat.SpellMiss then
        local missType, _, _ = select(15, CombatLogGetCurrentEventInfo())
        if missType == 'REFLECT' and destGUID == UnitGUID('player') then
            PlaySoundFile(C.Assets.Sounds.Missed, 'Master')
        end
    end
end

function COMBAT:UNIT_HEALTH(unit)
    if not C.DB.Combat.LowHealth then
        return
    end

    if unit ~= 'player' then
        return
    end

    local threshold = C.DB.Combat.LowHealthThreshold
    local sound = C.Assets.Sounds.SekiroLowHealth

    if (UnitHealth('player') / UnitHealthMax('player')) <= threshold then
        if not playedLowHealth then
            PlaySoundFile(sound, 'Master')
            playedLowHealth = true
        end
    else
        playedLowHealth = false
    end
end

function COMBAT:UNIT_POWER_UPDATE(unit)
    if not C.DB.Combat.LowMana then
        return
    end

    if unit ~= 'player' then
        return
    end

    local threshold = C.DB.Combat.LowManaThreshold
    local sound = C.Assets.Sounds.LowMana

    if UnitPowerType('player') == 0 then
        local cur = UnitPower('player', 0)
        local max = UnitPowerMax('player', 0)
        local percMana = max > 0 and (cur / max * 100) or 100

        if percMana <= threshold and not UnitIsDeadOrGhost('player') then
            if not playedLowMana then
                PlaySoundFile(sound, 'Master')
                playedLowMana = true
            end
        else
            playedLowMana = false
        end
    end
end

function COMBAT:SoundAlert()
    if not C.DB.Combat.SoundAlert then
        return
    end

    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', COMBAT.COMBAT_LOG_EVENT_UNFILTERED)
    F:RegisterEvent('UNIT_HEALTH', COMBAT.UNIT_HEALTH)
    F:RegisterEvent('UNIT_POWER_UPDATE', COMBAT.UNIT_POWER_UPDATE)
end

function COMBAT:OnLogin()
    if not C.DB.Combat.Enable then
        return
    end

    COMBAT:SoundAlert()
    COMBAT:CombatAlert()
    COMBAT:FloatingCombatText()
    COMBAT:PvPSound()
    COMBAT:SmartTab()
    COMBAT:EasyFocus()
    COMBAT:EasyMark()
end
