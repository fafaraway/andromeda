local _G = _G
local unpack = unpack
local select = select
local PlaySoundFile = PlaySoundFile
local UnitGUID = UnitGUID
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')

local function SpellSound_OnEvent()
    local _, eventType, _, sourceGUID = CombatLogGetCurrentEventInfo()

    if sourceGUID ~= UnitGUID('player') and sourceGUID ~= UnitGUID('pet') then
        return
    end

    if eventType == 'SPELL_INTERRUPT' then
        PlaySoundFile(C.Assets.Sounds.interrupt, 'Master')
    end

    if eventType == 'SPELL_DISPEL' then
        PlaySoundFile(C.Assets.Sounds.dispel, 'Master')
    end

    if eventType == 'SPELL_STOLEN' then
        PlaySoundFile(C.Assets.Sounds.dispel, 'Master')
    end
end

function COMBAT:SpellSound()
    if not C.DB.Combat.SpellSound then
        return
    end

    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', SpellSound_OnEvent)
end
