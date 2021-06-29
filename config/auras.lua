local _G = getfenv(0)
local unpack = _G.unpack
local select = _G.select
local pairs = _G.pairs
local EJ_GetInstanceInfo = _G.EJ_GetInstanceInfo
local GetSpellInfo = _G.GetSpellInfo

local F, C = unpack(select(2, ...))
local AURA = F:RegisterModule('AurasTable')

-- RaidFrame spells
local RaidBuffs = {}
function AURA:AddClassSpells(list)
    for class, value in pairs(list) do
        RaidBuffs[class] = value
    end
end

-- RaidFrame debuffs
local RaidDebuffs = {}
function AURA:RegisterDebuff(_, instID, _, spellID, level)
    local instName = EJ_GetInstanceInfo(instID)
    if not instName then
        if C.IsDeveloper then
            F:Debug('Invalid Instance ID: ' .. instID)
        end
        return
    end

    if not RaidDebuffs[instName] then
        RaidDebuffs[instName] = {}
    end
    if not level then
        level = 2
    end
    if level > 6 then
        level = 6
    end

    RaidDebuffs[instName][spellID] = level
end

-- Party watcher spells
function AURA:CheckPartySpells()
    for spellID, duration in pairs(C.PartySpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modDuration = _G.FREE_ADB['PartySpellsList'][spellID]
            if modDuration and modDuration == duration then
                _G.FREE_ADB['PartySpellsList'][spellID] = nil
            end
        else
            if C.IsDeveloper then
                F:Debug('Invalid Party Spell ID: ' .. spellID)
            end
        end
    end
end

-- Corner spells
function AURA:CheckCornerSpells()
    if not _G.FREE_ADB['CornerSpellsList'][C.MyClass] then
        _G.FREE_ADB['CornerSpellsList'][C.MyClass] = {}
    end
    local data = C.CornerSpellsList[C.MyClass]
    if not data then
        return
    end

    for spellID, _ in pairs(data) do
        local name = GetSpellInfo(spellID)
        if not name then
            if C.IsDeveloper then
                F:Debug('Invalid Corner Spell ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['CornerSpellsList'][C.MyClass]) do
        if not next(value) and C.CornerBuffs[C.MyClass][spellID] == nil then
            _G.FREE_ADB['CornerSpellsList'][C.MyClass][spellID] = nil
        end
    end
end

-- Nameplate major spells
function AURA:CheckMajorSpells()
    for spellID in pairs(C.NPMajorSpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            if _G.FREE_ADB['NPMajorSpells'][spellID] then
                _G.FREE_ADB['NPMajorSpells'][spellID] = nil
            end
        else
            if C.IsDeveloper then
                F:Debug('Invalid Nameplate Major Spells ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['NPMajorSpells']) do
        if value == false and C.NPMajorSpellsList[spellID] == nil then
            _G.FREE_ADB['NPMajorSpells'][spellID] = nil
        end
    end
end

-- Announceable spells
function AURA:CheckAnnounceableSpells()
    for spellID in pairs(C.AnnounceableSpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            if _G.FREE_ADB['AnnounceableSpellsList'][spellID] then
                _G.FREE_ADB['AnnounceableSpellsList'][spellID] = nil
            end
        else
            if C.IsDeveloper then
                F:Debug('Invalid Announceable Spells ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['AnnounceableSpellsList']) do
        if value == false and C.AnnounceableSpellsList[spellID] == nil then
            _G.FREE_ADB['AnnounceableSpellsList'][spellID] = nil
        end
    end
end

function AURA:OnLogin()
    for instName, value in pairs(RaidDebuffs) do
        for spell, priority in pairs(value) do
            if _G.FREE_ADB['RaidDebuffsList'][instName] and _G.FREE_ADB['RaidDebuffsList'][instName][spell] and _G.FREE_ADB['RaidDebuffsList'][instName][spell] == priority then
                _G.FREE_ADB['RaidDebuffsList'][instName][spell] = nil
            end
        end
    end
    for instName, value in pairs(_G.FREE_ADB['RaidDebuffsList']) do
        if not next(value) then
            _G.FREE_ADB['RaidDebuffsList'][instName] = nil
        end
    end

    C.RaidBuffsList = RaidBuffs
    C.RaidDebuffsList = RaidDebuffs

    AURA:CheckPartySpells()
    AURA:CheckCornerSpells()
    AURA:CheckMajorSpells()
    AURA:CheckAnnounceableSpells()
end
