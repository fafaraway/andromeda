--[[
    Spam SpaceBar to finish "We'll Make an Aspirant Out of You"
    https://www.wowhead.com/quest=59585/well-make-an-aspirant-out-of-you
    Credits P3lim
    https://github.com/p3lim-wow/BetterWorldQuests/blob/master/Helpers/Training.lua
]]

local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local strmatch = strmatch
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local C_QuestLog_IsOnQuest = C_QuestLog.IsOnQuest
local AuraUtil = AuraUtil
local ClearOverrideBindings = ClearOverrideBindings
local SetOverrideBindingClick = SetOverrideBindingClick
local InCombatLockdown = InCombatLockdown
local RaidNotice_AddMessage = RaidNotice_AddMessage

local F, C, L = unpack(select(2, ...))

local BUTTON = 'OverrideActionBarButton%d'

local actionMessages = {}
local actionResetSpells = {}
local spells = {
    [321842] = {
        [321843] = 1, -- Strike
        [321844] = 2, -- Sweep
        [321847] = 3, -- Parry
    },
    [341925] = {
        [341931] = 1, -- Slash
        [341928] = 2, -- Bash
        [341929] = 3, -- Block
    },
    [341985] = {
        [342000] = 1, -- Jab
        [342001] = 2, -- Kick
        [342002] = 3, -- Dodge
    },
}

local trainerName = 'Trainer Ikaros'
if C.GameLocale == 'deDE' then
    trainerName = 'Ausbilder Ikaros'
elseif C.GameLocale == 'esES' or C.GameLocale == 'esMX' then
    trainerName = 'Instructor Ikaros'
elseif C.GameLocale == 'frFR' then
    trainerName = 'Instructeur Ikaros'
elseif C.GameLocale == 'itIT' then
    trainerName = 'Istruttore Ikaros'
elseif C.GameLocale == 'koKR' then
    trainerName = '훈련사 이카로스'
elseif C.GameLocale == 'ptBR' then
    trainerName = 'Treinador Ikaros'
elseif C.GameLocale == 'ruRU' then
    trainerName = 'Укротитель Икар'
elseif C.GameLocale == 'zhCN' or C.GameLocale == 'zhTW' then
    trainerName = '训练师伊卡洛斯'
end

local function auraFilter(a, _, _, _, _, _, _, _, _, _, _, _, b)
    return a == b
end

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('QUEST_LOG_UPDATE')
Handler:RegisterEvent('QUEST_ACCEPTED')
Handler:SetScript('OnEvent', function(self, event, ...)
    if event == 'QUEST_LOG_UPDATE' then
        if C_QuestLog_IsOnQuest(59585) then
            self:Watch()
        else
            self:Unwatch()
        end
    elseif event == 'QUEST_ACCEPTED' then
        local questID = ...
        if questID == 59585 then
            self:Watch()
        end
    elseif (event == 'QUEST_REMOVED') then
        local questID = ...
        if questID == 59585 then
            self:Unwatch()
        end
    elseif event == 'UNIT_AURA' then
        for buff, spellSet in next, spells do
            if AuraUtil.FindAura(auraFilter, 'player', 'HELPFUL', buff) then
                self:Control(spellSet)
                return
            else
                self:Uncontrol()
            end
        end
    elseif event == 'CHAT_MSG_MONSTER_SAY' then
        local msg, sender = ...
        if sender == trainerName then -- Trainer Ikaros
            for spell, actionID in pairs(actionMessages) do
                if strmatch(msg, spell) then
                    F:Delay(0.5, function()
                        -- wait a split second to get "Perfect"
                        ClearOverrideBindings(self)
                        SetOverrideBindingClick(self, true, 'SPACE', BUTTON:format(actionID))
                    end)
                    break
                end
            end
        end
    elseif event == 'UNIT_SPELLCAST_SUCCEEDED' then
        local _, _, spellID = ...
        if actionResetSpells[spellID] then
            ClearOverrideBindings(self)

            -- bind to something useless to avoid spamming jump
            SetOverrideBindingClick(self, true, 'SPACE', BUTTON:format(12))
        end
    elseif (event == 'PLAYER_REGEN_ENABLED') then
        ClearOverrideBindings(self)
        self:UnregisterEvent(event)
    end
end)

function Handler:Watch()
    self:RegisterUnitEvent('UNIT_AURA', 'player')
    self:RegisterEvent('QUEST_REMOVED')
end

function Handler:Unwatch()
    self:UnregisterEvent('UNIT_AURA')
    self:UnregisterEvent('QUEST_REMOVED')
    self:Uncontrol()
end

function Handler:Control(spellSet)
    wipe(actionMessages)
    wipe(actionResetSpells)
    for spellID, actionIndex in next, spellSet do
        actionMessages[(GetSpellInfo(spellID))] = actionIndex
        actionResetSpells[spellID] = true

        if spellID == 321844 then
            actionMessages['低扫'] = actionIndex
        end
    end

    -- bind to something useless to avoid spamming jump
    SetOverrideBindingClick(self, true, 'SPACE', BUTTON:format(12))

    self:Message()

    self:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', 'player')
    self:RegisterEvent('CHAT_MSG_MONSTER_SAY')
end

function Handler:Uncontrol()
    self:UnregisterEvent('UNIT_SPELLCAST_SUCCEEDED')
    self:UnregisterEvent('CHAT_MSG_MONSTER_SAY')

    if InCombatLockdown() then
        self:RegisterEvent('PLAYER_REGEN_ENABLED')
    else
        ClearOverrideBindings(self)
    end
end

function Handler:Message()
    for i = 1, 2 do
        RaidNotice_AddMessage(_G.RaidWarningFrame, L['Spam <SpaceBar> to complete!'], _G.ChatTypeInfo.RAID_WARNING)
    end
end
