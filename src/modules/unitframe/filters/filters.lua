local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')

local seasonSpells = {
    [209858] = 2, -- 死疽
    [240443] = 2, -- 爆裂
    [240559] = 1, -- 重伤
    [396364] = 2, -- 狂风标记，DF S1
    [396369] = 2, -- 闪电标记，DF S1
}

local raidDebuffsList = {}
function UNITFRAME:RegisterInstanceSpell(tierID, instID, _, spellID, level)
    local instName = EJ_GetInstanceInfo(instID)
    if not instName then
        F:Debug('Invalid instance ID: ' .. tierID .. ' / ' .. instID)
        return
    end

    if not raidDebuffsList[instName] then
        raidDebuffsList[instName] = {}
    end
    if not level then
        level = 2
    end
    if level > 6 then
        level = 6
    end

    raidDebuffsList[instName][spellID] = level
end

function UNITFRAME:RegisterSeasonSpell(tier, instance)
    for spellID, priority in pairs(seasonSpells) do
        UNITFRAME:RegisterInstanceSpell(tier, instance, 0, spellID, priority)
    end
end

function UNITFRAME:InitRaidDebuffsList()
    for instName, value in pairs(raidDebuffsList) do
        for spell, priority in pairs(value) do
            if _G.ANDROMEDA_ADB['RaidDebuffsList'][instName] and _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spell] and _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spell] == priority then
                _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spell] = nil
            end
        end
    end
    for instName, value in pairs(_G.ANDROMEDA_ADB['RaidDebuffsList']) do
        if not next(value) then
            _G.ANDROMEDA_ADB['RaidDebuffsList'][instName] = nil
        end
    end

    raidDebuffsList[0] = {} -- OTHER spells

    C.RaidDebuffsList = raidDebuffsList
end

function UNITFRAME:InitCornerSpellsList()
    if not _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS] then
        _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS] = {}
    end
    local data = C.CornerSpellsList[C.MY_CLASS]
    if not data then
        return
    end

    for spellID in pairs(data) do
        local name = GetSpellInfo(spellID)
        if not name then
            F:Debug('CheckCornerSpells: Invalid Spell ID ' .. spellID)
        end
    end

    for spellID, value in pairs(_G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS]) do
        if not next(value) and C.CornerSpellsList[C.MY_CLASS][spellID] == nil then
            _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS][spellID] = nil
        end
    end
end

function UNITFRAME:InitPartySpellsList()
    for spellID, duration in pairs(C.PartySpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modDuration = _G.ANDROMEDA_ADB['PartySpellsList'][spellID]
            if modDuration and modDuration == duration then
                _G.ANDROMEDA_ADB['PartySpellsList'][spellID] = nil
            end
        else
            F:Debug('CheckPartySpells: Invalid Spell ID ' .. spellID)
        end
    end
end

function NAMEPLATE:InitMajorSpellsList()
    for spellID in pairs(C.MajorSpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            if _G.ANDROMEDA_ADB['MajorSpellsList'][spellID] then
                _G.ANDROMEDA_ADB['MajorSpellsList'][spellID] = nil
            end
        else
            F:Debug('CheckMajorSpells: Invalid Spell ID ' .. spellID)
        end
    end

    for spellID, value in pairs(_G.ANDROMEDA_ADB['MajorSpellsList']) do
        if value == false and C.MajorSpellsList[spellID] == nil then
            _G.ANDROMEDA_ADB['MajorSpellsList'][spellID] = nil
        end
    end
end

function UNITFRAME:InitFilters()
    UNITFRAME:InitRaidDebuffsList()
    UNITFRAME:InitCornerSpellsList()
    UNITFRAME:InitPartySpellsList()
    NAMEPLATE:InitMajorSpellsList()
    UNITFRAME:RegisterDungeonSpells()
    UNITFRAME:RegisterIncarnatesSpells()
end
