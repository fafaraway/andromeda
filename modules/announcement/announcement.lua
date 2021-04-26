local _G = _G
local unpack = unpack
local select = select
local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local GetNumGroupMembers = GetNumGroupMembers
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local IsPartyLFG = IsPartyLFG
local IsEveryoneAssistant = IsEveryoneAssistant
local SendChatMessage = SendChatMessage
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local F, C = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT

function ANNOUNCEMENT:CheckGroupAndInstance()
    if IsInInstance() and IsInGroup() and GetNumGroupMembers() > 1 and not IsInRaid() then
        return true
    end

    return false
end

function ANNOUNCEMENT:IsGroupMember(name)
    if name then
        if UnitInParty(name) then
            return 1
        elseif UnitInRaid(name) then
            return 2
        elseif name == C.MyName then
            return 3
        end
    end

    return false
end

function ANNOUNCEMENT:GetChannel()
    -- if IsPartyLFG() or IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(_G.LE_PARTY_CATEGORY_INSTANCE) then
    --     return 'INSTANCE_CHAT'
    -- elseif IsInRaid(_G.LE_PARTY_CATEGORY_HOME) then
    --     return 'RAID'
    -- elseif IsInGroup(_G.LE_PARTY_CATEGORY_HOME) then
    --     return 'PARTY'
    -- elseif C.DB.Announcement.Solo then
    --     return 'SELF'
    -- end

    return 'NONE'
end

function ANNOUNCEMENT:SendMessage(text, channel, raidWarning, whisperTarget)
    if channel == 'NONE' then
        channel = 'SAY'
    end

    if channel == 'SELF' then
        F:Print(text)
        return
    end

    if channel == 'WHISPER' then
        if whisperTarget then
            SendChatMessage(text, channel, nil, whisperTarget)
        end
        return
    end

    if channel == 'RAID' and raidWarning and IsInRaid(_G.LE_PARTY_CATEGORY_HOME) then
        if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') or IsEveryoneAssistant() then
            channel = 'RAID_WARNING'
        end
    end

    SendChatMessage(text, channel)
end

function ANNOUNCEMENT:OnEvent()
    local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellId, _, _, extraSpellId2 = CombatLogGetCurrentEventInfo()

    local checkGroupAndInstance = ANNOUNCEMENT:CheckGroupAndInstance()
    if not checkGroupAndInstance then
        return
    end

    local isGroupMember = ANNOUNCEMENT:IsGroupMember(sourceName)
    if not isGroupMember then
        return
    end

    if event == 'SPELL_CAST_SUCCESS' then
        ANNOUNCEMENT:Utility(event, sourceName, spellId)
        ANNOUNCEMENT:BattleRez(sourceName, destName, spellId)
    elseif event == 'SPELL_SUMMON' then
        ANNOUNCEMENT:Utility(event, sourceName, spellId)
    elseif event == 'SPELL_CREATE' then
        ANNOUNCEMENT:Utility(event, sourceName, spellId)
    elseif event == 'SPELL_INTERRUPT' then
        ANNOUNCEMENT:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId2)
    elseif event == 'SPELL_DISPEL' then
        ANNOUNCEMENT:Dispel(sourceGUID, sourceName, destName, spellId, extraSpellId2)
    elseif event == 'SPELL_STOLEN' then
        ANNOUNCEMENT:Stolen(sourceGUID, sourceName, destName, spellId, extraSpellId2)
    end
end

function ANNOUNCEMENT:OnLogin()
    if not C.DB.Announcement.Enable then
        return
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', ANNOUNCEMENT.CheckGroupAndInstance)
    F:RegisterEvent('ZONE_CHANGED_NEW_AREA', ANNOUNCEMENT.CheckGroupAndInstance)
    F:RegisterEvent('GROUP_JOINED', ANNOUNCEMENT.CheckGroupAndInstance)
    F:RegisterEvent('GROUP_LEFT', ANNOUNCEMENT.CheckGroupAndInstance)
    F:RegisterEvent('GROUP_ROSTER_UPDATE', ANNOUNCEMENT.CheckGroupAndInstance)

    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.OnEvent)

    ANNOUNCEMENT:InstanceReset()
    ANNOUNCEMENT:QuestNotification()
end
