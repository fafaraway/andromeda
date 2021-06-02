local _G = _G
local unpack = unpack
local select = select
local UnitGUID = UnitGUID
local PlaySoundFile = PlaySoundFile
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local F, C = unpack(select(2, ...))
local COMBAT = F:RegisterModule('Combat')

function COMBAT:OnEvent()
    local _, eventType, _, srcGUID, _, _, _, destGUID = CombatLogGetCurrentEventInfo()

    if not (srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet')) then
        return
    end

    if eventType == 'SPELL_INTERRUPT' then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            PlaySoundFile(C.Assets.Sounds.Interrupt, 'Master')
        end
    elseif eventType == 'SPELL_DISPEL' then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then

            PlaySoundFile(C.Assets.Sounds.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_STOLEN' then
        if srcGUID == UnitGUID('player') then

            PlaySoundFile(C.Assets.Sounds.Dispel, 'Master')
        end
    elseif eventType == 'SPELL_MISSED' then
        local missType, _, _ = select(15, CombatLogGetCurrentEventInfo())
        if missType == 'REFLECT' and destGUID == UnitGUID('player') then

            PlaySoundFile(C.Assets.Sounds.Missed, 'Master')
        end
    end
end

function COMBAT:SpellSound()
    if not C.DB.Combat.SpellSound then
        return
    end

    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', COMBAT.OnEvent)
end

function COMBAT:OnLogin()
    if not C.DB.Combat.Enable then
        return
    end

    COMBAT:SpellSound()
    COMBAT:CombatAlert()
    COMBAT:FloatingCombatText()
    COMBAT:PvPSound()
    COMBAT:SmartTab()
    COMBAT:EasyFocus()
    COMBAT:EasyMark()
end
