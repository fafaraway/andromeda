local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local format = format
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local IsEveryoneAssistant = IsEveryoneAssistant
local bit_band = bit.band
local GetSpellLink = GetSpellLink
local UnitGUID = UnitGUID
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local IsInInstance = IsInInstance
local InCombatLockdown = InCombatLockdown
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellInfo = GetSpellInfo

local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F:RegisterModule('Announcement')

function ANNOUNCEMENT:IsInMyGroup(flag)
    local inParty = IsInGroup() and bit_band(flag, _G.COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0
    local inRaid = IsInRaid() and bit_band(flag, _G.COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0

    return inRaid or inParty
end

function ANNOUNCEMENT:GetChannel(warning)
    if C.DB.Announcement.Channel == 1 then
        if IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
            return 'INSTANCE_CHAT'
        elseif IsInRaid(_G.LE_PARTY_CATEGORY_HOME) then
            if warning and (UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') or IsEveryoneAssistant()) then
                return 'RAID_WARNING'
            else
                return 'RAID'
            end
        elseif IsInGroup(_G.LE_PARTY_CATEGORY_HOME) then
            return 'PARTY'
        end
    elseif C.DB.Announcement.Channel == 2 then
        return 'YELL'
    elseif C.DB.Announcement.Channel == 3 then
        return 'EMOTE'
    elseif C.DB.Announcement.Channel == 4 then
        return 'SAY'
    end
end

function ANNOUNCEMENT:Announce(msg, channel)
    SendChatMessage(msg, channel)
end

local feastsList = {
    [308458] = true, -- Surprisingly Palatable Feast
    [308462] = true -- Feast of Gluttonous Hedonism
}

local cauldronList = {
    [307157] = true -- Eternal Cauldron
}

local botsList = {
    [22700] = true, -- Field Repair Bot 74A
    [44389] = true, -- Field Repair Bot 110G
    [54711] = true, -- Scrapbot
    [67826] = true, -- Jeeves
    [126459] = true, -- Blingtron 4000
    [161414] = true, -- Blingtron 5000
    [298926] = true, -- Blingtron 7000
    [199109] = true -- Auto-Hammer
}

local codexList = {
    [324029] = true -- Codex of the Still Mind
}

local toysList = {
    [61031] = true, -- Toy Train Set
    [49844] = true -- Direbrew's Remote
}

local portalsList = {
    -- Alliance
    [10059] = true, -- Stormwind
    [11416] = true, -- Ironforge
    [11419] = true, -- Darnassus
    [32266] = true, -- Exodar
    [49360] = true, -- Theramore
    [33691] = true, -- Shattrath
    [88345] = true, -- Tol Barad
    [132620] = true, -- Vale of Eternal Blossoms
    [176246] = true, -- Stormshield
    [281400] = true, -- Boralus
    -- Horde
    [11417] = true, -- Orgrimmar
    [11420] = true, -- Thunder Bluff
    [11418] = true, -- Undercity
    [32267] = true, -- Silvermoon
    [49361] = true, -- Stonard
    [35717] = true, -- Shattrath
    [88346] = true, -- Tol Barad
    [132626] = true, -- Vale of Eternal Blossoms
    [176244] = true, -- Warspear
    [281402] = true, -- Dazar'alor
    -- Alliance/Horde
    [53142] = true, -- Dalaran
    [120146] = true, -- Ancient Dalaran
    [224871] = true, -- Dalaran, Broken Isles
    [344597] = true -- Oribos
}

local rezList = {
    [61999] = true, -- Raise Ally
    [20484] = true, -- Rebirth
    [20707] = true, -- Soulstone
    [345130] = true -- Disposable Spectrophasic Reanimator
}

function ANNOUNCEMENT:InitSpells()
    for spellID in pairs(C.AnnounceSpells) do
        local name = GetSpellInfo(spellID)
        if name then
            if _G.FREE_ADB['AnnounceSpells'][spellID] then
                _G.FREE_ADB['AnnounceSpells'][spellID] = nil
            end
        else
            if C.IsDeveloper then
                F:Debug('Invalid announce spell ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['AnnounceSpells']) do
        if value == false and C.AnnounceSpells[spellID] == nil then
            _G.FREE_ADB['AnnounceSpells'][spellID] = nil
        end
    end
end

ANNOUNCEMENT.AnnounceSpellsList = {}
function ANNOUNCEMENT:RefreshSpells()
    wipe(ANNOUNCEMENT.AnnounceSpellsList)

    for spellID in pairs(C.AnnounceSpells) do
        local name = GetSpellInfo(spellID)
        if name then
            local modValue = _G.FREE_ADB['AnnounceSpells'][spellID]
            if modValue == nil then
                ANNOUNCEMENT.AnnounceSpellsList[spellID] = true
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['AnnounceSpells']) do
        if value then
            ANNOUNCEMENT.AnnounceSpellsList[spellID] = true
        end
    end
end

function ANNOUNCEMENT:OnEvent()
    if not (IsInInstance() and IsInGroup() and GetNumGroupMembers() > 1) then
        return true
    end

    local _, eventType, _, srcGUID, srcName, srcFlags, _, destGUID, destName, _, _, spellID, _, _, extraSpellID = CombatLogGetCurrentEventInfo()

    if srcName then
        srcName = srcName:gsub('%-[^|]+', '')
    end

    if destName then
        destName = destName:gsub('%-[^|]+', '')
    end

    if eventType == 'SPELL_INTERRUPT' and C.DB.Announcement.Interrupt then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            ANNOUNCEMENT:Announce(format(L['Interrupt %s → %s'], GetSpellLink(extraSpellID), destName), 'SAY')
        end
    elseif eventType == 'SPELL_DISPEL' and C.DB.Announcement.Dispel then
        if srcGUID == UnitGUID('player') or srcGUID == UnitGUID('pet') then
            ANNOUNCEMENT:Announce(format(L['Dispelled %s → %s'], GetSpellLink(extraSpellID), destName), 'SAY')
        end
    elseif eventType == 'SPELL_STOLEN' and C.DB.Announcement.Stolen then
        if srcGUID == UnitGUID('player') then
            ANNOUNCEMENT:Announce(format(L['Stolen %s → %s'], GetSpellLink(extraSpellID), destName), 'SAY')
        end
    elseif eventType == 'SPELL_MISSED' and C.DB.Announcement.Reflect then
        local missType, _, _ = select(15, CombatLogGetCurrentEventInfo())
        if missType == 'REFLECT' and destGUID == UnitGUID('player') then
            ANNOUNCEMENT:Announce(format(L['Reflected %s → %s'], GetSpellLink(spellID), srcName), 'SAY')
        end
    end

    if eventType == 'SPELL_CAST_SUCCESS' then
        if not (srcGUID == UnitGUID('player') and srcName == C.MyName) then
            if not srcName then
                return
            end

            if C.DB.Announcement.BattleRez and rezList[spellID] then
                if destName == nil then
                    ANNOUNCEMENT:Announce(format(L['%s has casted %s'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel())
                else
                    ANNOUNCEMENT:Announce(format(L['%s has casted %s → %s'], srcName, GetSpellLink(spellID), destName), ANNOUNCEMENT:GetChannel())
                end
            end
        else
            if not (srcGUID == UnitGUID('player') and srcName == C.MyName) then
                return
            end

            if (rezList[spellID] and C.DB.Announcement.BattleRez) or ANNOUNCEMENT.AnnounceSpellsList[spellID] then
                if destName == nil then
                    ANNOUNCEMENT:Announce(format(L['%s has casted %s'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel())
                else
                    ANNOUNCEMENT:Announce(format(L['%s → %s'], GetSpellLink(spellID), destName), ANNOUNCEMENT:GetChannel())
                end
            end
        end
    end

    if InCombatLockdown() then
        return
    end

    if not eventType or not spellID or not srcName then
        return
    end

    if not ANNOUNCEMENT:IsInMyGroup(srcFlags) then
        return
    end

    if eventType == 'SPELL_CAST_SUCCESS' then
        -- Feasts and Cauldron
        if (C.DB.Announcement.Feast and feastsList[spellID]) or (C.DB.Announcement.Cauldron and cauldronList[spellID]) then
            SendChatMessage(format(L['%s has prepared %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        -- Refreshment Table
        elseif C.DB.Announcement.RefreshmentTable and spellID == 43987 then
            SendChatMessage(format(L['%s has prepared %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        -- Ritual of Summoning
        elseif C.DB.Announcement.RitualofSummoning and spellID == 698 then
            SendChatMessage(format(L['%s is casting %s. Click!'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        -- Piccolo of the Flaming Fire
        elseif C.DB.Announcement.Toy and spellID == 182346 then
            SendChatMessage(format(L['%s used %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        end
    elseif eventType == 'SPELL_SUMMON' then
        -- Repair Bots and Codex
        if (C.DB.Announcement.Bot and botsList[spellID]) or (C.DB.Announcement.Codex and codexList[spellID]) then
            SendChatMessage(format(L['%s has put down %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        end
    elseif eventType == 'SPELL_CREATE' then
        -- 29893 Soulwell 54710 MOLL-E 261602 Katy's Stampwhistle
        if C.DB.Announcement.Mailbox and (spellID == 29893 or spellID == 54710 or spellID == 261602) then
            SendChatMessage(format(L['%s has put down %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        elseif C.DB.Announcement.Toy and toysList[spellID] then -- Toys
            SendChatMessage(format(L['%s has put down %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        elseif C.DB.Announcement.Portal and portalsList[spellID] then -- Portals
            SendChatMessage(format(L['%s is casting %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        end
    elseif eventType == 'SPELL_AURA_APPLIED' then
        -- Turkey Feathers and Party G.R.E.N.A.D.E.
        if C.DB.Announcement.Toy and (spellID == 61781 or ((spellID == 51508 or spellID == 51510) and destName == C.MyName)) then
            SendChatMessage(format(L['%s used %s.'], srcName, GetSpellLink(spellID)), ANNOUNCEMENT:GetChannel(true))
        end
    end
end

function ANNOUNCEMENT:AnnounceSpells()
    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.OnEvent)
end

function ANNOUNCEMENT:OnLogin()
    if not C.DB.Announcement.Enable then
        return
    end

    ANNOUNCEMENT:InitSpells()
    ANNOUNCEMENT:RefreshSpells()

    ANNOUNCEMENT:AnnounceSpells()
    ANNOUNCEMENT:AnnounceReset()
    ANNOUNCEMENT:AnnounceQuest()
end
