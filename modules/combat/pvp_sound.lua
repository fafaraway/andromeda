local _G = _G
local unpack = unpack
local select = select
local bit_bor = bit.bor
local PlaySoundFile = PlaySoundFile
local UnitName = UnitName
local UnitGUID = UnitGUID
local COMBATLOG_OBJECT_TYPE_PET = COMBATLOG_OBJECT_TYPE_PET
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN
local COMBATLOG_OBJECT_AFFILIATION_MASK = COMBATLOG_OBJECT_AFFILIATION_MASK
local COMBATLOG_OBJECT_REACTION_MASK = COMBATLOG_OBJECT_REACTION_MASK
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local COMBATLOG_OBJECT_CONTROL_NPC = COMBATLOG_OBJECT_CONTROL_NPC
local COMBATLOG_OBJECT_TYPE_OBJECT = COMBATLOG_OBJECT_TYPE_OBJECT
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_TYPE_NPC = COMBATLOG_OBJECT_TYPE_NPC
local COMBATLOG_OBJECT_NONE = COMBATLOG_OBJECT_NONE
local CombatLog_Object_IsA = CombatLog_Object_IsA
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')

local FILTER_MY_PETS = bit_bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY,
                               COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_OBJECT,
                               COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_TYPE_PET)
local FILTER_ENEMY_PLAYERS = bit_bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK,
                                     COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER)
local FILTER_ENEMY_NPC = bit_bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK,
                                 COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER,
                                 COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)

local playerName, playerGUID = UnitName('player'), UnitGUID('player')
local lastKill, killCount, streakCount = nil, 0, 0
local deathsTable, killsTable = {}, {}
local debugMode = false

local soundsList = {
    ['firstblood'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\firstblood.ogg',
    ['killingspree'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\killingspree.ogg',
    ['rampage'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\rampage.ogg',
    ['dominating'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\dominating.ogg',
    ['unstoppable'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\unstoppable.ogg',
    ['godlike'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\godlike.ogg',
    ['wickedsick'] = C.AssetsPath .. 'sounds\\killingblows\\kill\\wickedsick.ogg',

    ['doublekill'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\doublekill.ogg',
    ['multikill'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\multikill.ogg',
    ['megakill'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\megakill.ogg',
    ['ultrakill'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\ultrakill.ogg',
    ['monsterkill'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\monsterkill.ogg',
    ['ludicrouskill'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\ludicrouskill.ogg',
    ['holyshit'] = C.AssetsPath .. 'sounds\\killingblows\\multikill\\holyshit.ogg',

    ['denied'] = C.AssetsPath .. 'sounds\\killingblows\\revenge\\denied.ogg',
    ['retribution'] = C.AssetsPath .. 'sounds\\killingblows\\revenge\\retribution.ogg',
}

local function PlaySound(file)
    PlaySoundFile(file, 'Master')
end

local function PrtMsg(str)
    if not debugMode then
        return
    end

    F:Print(str)
end

local function OnEvent(self, event)
    if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
        local timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, _,
            swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo()

        local toEnemy, fromEnemy, fromMyPets

        if destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) then
            toEnemy = CombatLog_Object_IsA(destFlags, debugMode and FILTER_ENEMY_NPC or FILTER_ENEMY_PLAYERS)
        end

        if sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) then
            fromMyPets = CombatLog_Object_IsA(sourceFlags, FILTER_MY_PETS)
            fromEnemy = CombatLog_Object_IsA(sourceFlags, FILTER_ENEMY_PLAYERS)
        end

        if (type == 'PARTY_KILL' and sourceGUID == playerGUID and toEnemy) or
            (type == 'SWING_DAMAGE' and destGUID ~= playerGUID and fromMyPets and toEnemy and swingOverkill >= 0) or
            ((type == 'RANGE_DAMAGE' or type == 'SPELL_DAMAGE' or type == 'SPELL_PERIODIC_DAMAGE') and destGUID ~=
                playerGUID and fromMyPets and toEnemy and spellOverkill >= 0) then

            if (killsTable[destName] and (timestamp - killsTable[destName]) < 5) then
                return
            else
                killsTable[destName] = timestamp
            end

            if lastKill and (timestamp - lastKill < 17) then
                streakCount = streakCount + 1
            else
                streakCount = 1
                killCount = killCount + 1
            end

            if streakCount == 2 then
                PlaySound(soundsList.doublekill)
                PrtMsg('Double Kill')
            elseif streakCount == 3 then
                PlaySound(soundsList.multikill)
                PrtMsg('Multi Kill')
            elseif streakCount == 4 then
                PlaySound(soundsList.megakill)
                PrtMsg('Mega Kill')
            elseif streakCount == 5 then
                PlaySound(soundsList.ultrakill)
                PrtMsg('Ultra Kill')
            elseif streakCount == 6 then
                PlaySound(soundsList.monsterkill)
                PrtMsg('Monster Kill')
            elseif streakCount == 7 then
                PlaySound(soundsList.ludicrouskill)
                PrtMsg('Ludicrous Kill')
            elseif streakCount >= 8 then
                PlaySound(soundsList.holyshit)
                PrtMsg('Holy Shit')

            elseif streakCount <= 1 then
                if (deathsTable[destName] and (timestamp - deathsTable[destName]) < 90) then
                    deathsTable[destName] = nil
                    PlaySound(soundsList.retribution)
                    PrtMsg('Retribution')
                elseif killCount == 1 then
                    PlaySound(soundsList.firstblood)
                    PrtMsg('First Blood')
                elseif killCount == 2 then
                    PlaySound(soundsList.killingspree)
                    PrtMsg('Killing Spree')
                elseif killCount == 3 then
                    PlaySound(soundsList.rampage)
                    PrtMsg('Rampage')
                elseif killCount == 4 then
                    PlaySound(soundsList.dominating)
                    PrtMsg('Dominating')
                elseif killCount == 5 then
                    PlaySound(soundsList.unstoppable)
                    PrtMsg('Unstoppable')
                elseif killCount == 6 then
                    PlaySound(soundsList.godlike)
                    PrtMsg('GodLike')
                elseif killCount >= 7 then
                    PlaySound(soundsList.wickedsick)
                    PrtMsg('Wicked Sick')
                end
            end

            lastKill = timestamp

        elseif (type == 'SWING_DAMAGE' and fromEnemy and destGUID == playerGUID and swingOverkill >= 0) or
            ((type == 'RANGE_DAMAGE' or type == 'SPELL_DAMAGE' or type == 'SPELL_PERIODIC_DAMAGE') and fromEnemy and
                destGUID == playerGUID and spellOverkill >= 0) then
            if sourceName ~= nil and sourceName ~= playerName then

                if (deathsTable[sourceName] and (timestamp - deathsTable[sourceName]) < 5) then
                    return
                else
                    deathsTable[sourceName] = timestamp
                end

                if killsTable[sourceName] and (timestamp - killsTable[sourceName]) < 90 then
                    killsTable[sourceName] = nil
                    PlaySound(soundsList.denied)
                    PrtMsg('Denied')
                end
            end
        end

    elseif event == 'ZONE_CHANGED_NEW_AREA' or event == 'PLAYER_DEAD' then
        lastKill = nil
        killCount = 0
        streakCount = 0
    end
end

function COMBAT:PvPSound()
    if not C.DB.Combat.PvPSound then
        return
    end

    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', OnEvent)
    F:RegisterEvent('ZONE_CHANGED_NEW_AREA', OnEvent)
    F:RegisterEvent('PLAYER_DEAD', OnEvent)
end
