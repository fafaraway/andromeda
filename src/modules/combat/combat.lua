local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')

local playedLowHealth = false
local playedLowMana = false

local spellsList = {
    [2825] = true, -- Bloodlust (Horde Shaman)
    [32182] = true, -- Heroism (Alliance Shaman)
    [80353] = true, -- Time Warp (Mage)
    [272678] = true, -- Primal Rage (Hunter, cast by command pet)
    [264667] = true, -- Primal Rage (Hunter, cast from pet spellbook)
    [146555] = true, -- Drums of Rage (MoP)
    [178207] = true, -- Drums of Fury (WoD)
    [230935] = true, -- Drums of the Mountain (Legion)
    [256740] = true, -- Drums of the Maelstrom (BfA)
    [292686] = true, -- Mallet of Thunderous Skins (BfA)
    [309658] = true, -- Drums of Deathly Ferocity (SL)
}

function COMBAT:COMBAT_LOG_EVENT_UNFILTERED()
    local _, eventType, _, srcGUID, srcName, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()

    if eventType == 'SPELL_CAST_SUCCESS' and spellsList[spellID] and C.DB.Combat.HeroismAlert then
        if (UnitPlayerOrPetInParty(srcName) or UnitPlayerOrPetInRaid(srcName)) and IsInGroup() and IsInInstance() then
            local faction = UnitFactionGroup(srcName) or 'None'
            if faction == 'Alliance' then
                print(faction, spellID)
                PlaySoundFile(C.Assets.Sound.ForTheAlliance, 'Master')
            elseif faction == 'Horde' then
                print(faction, spellID)
                PlaySoundFile(C.Assets.Sound.ForTheHorde, 'Master')
            end
        end
    end

    if not (srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet')) then
        return
    end

    if eventType == 'SPELL_INTERRUPT' and C.DB.Combat.Interrupt then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            PlaySoundFile(C.Assets.Sound.Interrupt, 'Master')
        end
    elseif eventType == 'SPELL_DISPEL' and C.DB.Combat.Dispel then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            PlaySoundFile(C.Assets.Sound.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_STOLEN' and C.DB.Combat.SpellSteal then
        if srcGUID == UnitGUID('player') then
            PlaySoundFile(C.Assets.Sound.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_MISSED' and C.DB.Combat.SpellMiss then
        local missType, _, _ = select(15, CombatLogGetCurrentEventInfo())
        if missType == 'REFLECT' and destGUID == UnitGUID('player') then
            PlaySoundFile(C.Assets.Sound.Missed, 'Master')
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
    local sound = C.Assets.Sound.SekiroLowHealth

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
    local sound = C.Assets.Sound.LowMana

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
