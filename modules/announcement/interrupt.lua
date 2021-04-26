local _G = _G
local unpack = unpack
local select = select
local gsub = gsub
local GetSpellLink = GetSpellLink
local UnitGUID = UnitGUID

local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT

local function FormatMessage(message, sourceName, destName, spellId, extraSpellId)
    sourceName = gsub(sourceName, '%-[^|]+', '')
    message = gsub(message, '%%player%%', sourceName)
    message = gsub(message, '%%target%%', destName)
    message = gsub(message, '%%player_spell%%', GetSpellLink(spellId))
    message = gsub(message, '%%target_spell%%', GetSpellLink(extraSpellId))
    return message
end

function ANNOUNCEMENT:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId)
    if not C.DB.Announcement.Interrupt then
        return
    end

    if not (spellId and extraSpellId) then
        return
    end

    if not (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')) then
        return
    end

    ANNOUNCEMENT:SendMessage(FormatMessage(L['Interrupted %target%\'s %target_spell%!'], sourceName, destName, spellId, extraSpellId), ANNOUNCEMENT:GetChannel())
end

function ANNOUNCEMENT:Dispel(sourceGUID, sourceName, destName, spellId, extraSpellId)
    if not C.DB.Announcement.Dispel then
        return
    end

    if not (spellId and extraSpellId) then
        return
    end

    if not (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')) then
        return
    end

    ANNOUNCEMENT:SendMessage(FormatMessage(L['Dispelled %target%\'s %target_spell%!'], sourceName, destName, spellId, extraSpellId), ANNOUNCEMENT:GetChannel())
end

function ANNOUNCEMENT:Stolen(sourceGUID, sourceName, destName, spellId, extraSpellId)
    if not C.DB.Announcement.Dispel then
        return
    end

    if not (spellId and extraSpellId) then
        return
    end

    if not (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')) then
        return
    end

    ANNOUNCEMENT:SendMessage(FormatMessage(L['Stolen %target%\'s %target_spell%!'], sourceName, destName, spellId, extraSpellId), ANNOUNCEMENT:GetChannel())
end
