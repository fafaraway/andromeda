local F, C = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local oUF = F.oUF

local _G = _G
local GetSpellInfo = GetSpellInfo
local GetSpecialization = GetSpecialization
local EJ_GetInstanceInfo = EJ_GetInstanceInfo
local CompactRaidFrameManager_SetSetting = CompactRaidFrameManager_SetSetting
local CompactRaidFrameManager = CompactRaidFrameManager

local function ReplaceHealthColor()
    local colors = _G.FREE_ADB.health_color
    oUF.colors.health = {colors.r, colors.g, colors.b}
end

local function ReplacePowerColors(name, index, color)
    oUF.colors.power[name] = color
    oUF.colors.power[index] = oUF.colors.power[name]
end

function UNITFRAME:InitializeColors()
    ReplaceHealthColor()

    ReplacePowerColors('MANA', 0, {87 / 255, 165 / 255, 208 / 255})
    ReplacePowerColors('ENERGY', 3, {174 / 255, 34 / 255, 45 / 255})
    ReplacePowerColors('COMBO_POINTS', 4, {199 / 255, 171 / 255, 90 / 255})
    ReplacePowerColors('RUNIC_POWER', 6, {135 / 255, 214 / 255, 194 / 255})
    ReplacePowerColors('SOUL_SHARDS', 7, {151 / 255, 101 / 255, 221 / 255})
    ReplacePowerColors('HOLY_POWER', 9, {208 / 255, 178 / 255, 107 / 255})
    ReplacePowerColors('INSANITY', 13, {179 / 255, 96 / 255, 244 / 255})

    local classColors = C.ClassColors
    for class, value in pairs(classColors) do
        oUF.colors.class[class] = {value.r, value.g, value.b}
    end
end

local raidDebuffsList = {}
function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
    local instName = EJ_GetInstanceInfo(instID)
    if not instName then
        if C.isDeveloper then
            print('Invalid instance ID: ' .. instID)
        end
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

function UNITFRAME:CheckPartySpells()
    for spellID, duration in pairs(C.PartySpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modDuration = _G.FREE_ADB['PartySpellsList'][spellID]
            if modDuration and modDuration == duration then
                _G.FREE_ADB['PartySpellsList'][spellID] = nil
            end
        else
            if C.isDeveloper then
                print('Invalid partyspell ID: ' .. spellID)
            end
        end
    end
end

function UNITFRAME:CheckCornerSpells()
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
            if C.isDeveloper then
                print('Invalid cornerspell ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['CornerSpellsList'][C.MyClass]) do
        if not next(value) and C.CornerSpellsList[C.MyClass][spellID] == nil or
            C.BloodlustList[spellID] then
            _G.FREE_ADB['CornerSpellsList'][C.MyClass][spellID] = nil
        end
    end
end

function UNITFRAME:CheckMajorSpells()
    for spellID in pairs(C.NPMajorSpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            if _G.FREE_ADB['NPMajorSpells'][spellID] then
                _G.FREE_ADB['NPMajorSpells'][spellID] = nil
            end
        else
            if C.isDeveloper then
                print('Invalid nameplate major spell ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['NPMajorSpells']) do
        if value == false and C.NPMajorSpellsList[spellID] == nil then
            _G.FREE_ADB['NPMajorSpells'][spellID] = nil
        end
    end
end

function UNITFRAME:InitializeAuras()
    for instName, value in pairs(raidDebuffsList) do
        for spell, priority in pairs(value) do
            if _G.FREE_ADB['RaidDebuffsList'][instName] and
                _G.FREE_ADB['RaidDebuffsList'][instName][spell] and
                _G.FREE_ADB['RaidDebuffs'][instName][spell] == priority then
                _G.FREE_ADB['RaidDebuffsList'][instName][spell] = nil
            end
        end
    end
    for instName, value in pairs(_G.FREE_ADB['RaidDebuffsList']) do
        if not next(value) then
            _G.FREE_ADB['RaidDebuffsList'][instName] = nil
        end
    end

    C.RaidDebuffsList = raidDebuffsList

    UNITFRAME:CheckPartySpells()
    UNITFRAME:CheckCornerSpells()
    UNITFRAME:CheckMajorSpells()
end

function UNITFRAME:OnLogin()
    F:SetSmoothingAmount(.3)

    UNITFRAME:InitializeColors()
    UNITFRAME:InitializeAuras()

    if not C.DB.unitframe.enable then
        return
    end

    if C.DB.unitframe.enable_player then
        self:SpawnPlayer()
    end

    if C.DB.unitframe.enable_pet then
        self:SpawnPet()
    end

    if C.DB.unitframe.enable_target then
        self:SpawnTarget()
        self:SpawnTargetTarget()
    end

    if C.DB.unitframe.enable_focus then
        self:SpawnFocus()
        self:SpawnFocusTarget()
    end

    if C.DB.unitframe.enable_boss then
        self:SpawnBoss()
    end

    if C.DB.unitframe.enable_arena then
        self:SpawnArena()
    end

    if not C.DB.unitframe.enable_group then
        return
    end

    if CompactRaidFrameManager_SetSetting then -- get rid of blizz raid frame
        CompactRaidFrameManager_SetSetting('IsShown', '0')
        _G.UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
        CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager:SetParent(F.HiddenFrame)
    end

    self:SpawnParty()
    self:SpawnRaid()
    self:ClickCast()

    if C.DB.unitframe.spec_position then
        local function UpdateSpecPos(event, ...)
            local unit, _, spellID = ...
            if (event == 'UNIT_SPELLCAST_SUCCEEDED' and unit == 'player' and spellID == 200749) or
                event == 'ON_LOGIN' then
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end

                if not C.DB['ui_anchor']['raid_position' .. specIndex] then
                    C.DB['ui_anchor']['raid_position' .. specIndex] =
                        {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -10}
                end

                UNITFRAME.RaidMover:ClearAllPoints()
                UNITFRAME.RaidMover:SetPoint(unpack(C.DB['ui_anchor']['raid_position' .. specIndex]))

                if UNITFRAME.RaidMover then
                    UNITFRAME.RaidMover:ClearAllPoints()
                    UNITFRAME.RaidMover:SetPoint(unpack(
                                                     C.DB['ui_anchor']['raid_position' .. specIndex]))
                end

                if not C.DB['ui_anchor']['party_position' .. specIndex] then
                    C.DB['ui_anchor']['party_position' .. specIndex] =
                        {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60}
                end
                if UNITFRAME.PartyMover then
                    UNITFRAME.PartyMover:ClearAllPoints()
                    UNITFRAME.PartyMover:SetPoint(unpack(
                                                      C.DB['ui_anchor']['party_position' ..
                                                          specIndex]))
                end
            end
        end
        UpdateSpecPos('ON_LOGIN')
        F:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', UpdateSpecPos)

        if UNITFRAME.RaidMover then
            UNITFRAME.RaidMover:HookScript('OnDragStop', function()
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end
                C.DB['ui_anchor']['raid_position' .. specIndex] = C.DB['ui_anchor']['RaidFrame']
            end)
        end

        if UNITFRAME.PartyMover then
            UNITFRAME.PartyMover:HookScript('OnDragStop', function()
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end
                C.DB['ui_anchor']['party_position' .. specIndex] = C.DB['ui_anchor']['PartyFrame']
            end)
        end
    end
end
