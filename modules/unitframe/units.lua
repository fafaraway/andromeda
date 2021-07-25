local _G = _G
local unpack = unpack
local select = select
local format = format
local tinsert = tinsert
local RegisterStateDriver = RegisterStateDriver

local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local OUF = F.Libs.oUF

local unitsPos = {
    player = {'CENTER', _G.UIParent, 'CENTER', 0, -180},
    pet = {'RIGHT', 'oUF_Player', 'LEFT', -6, 0},
    target = {'LEFT', _G.UIParent, 'CENTER', 120, -140},
    tot = {'LEFT', 'oUF_Target', 'RIGHT', 6, 0},
    focus = {'BOTTOM', _G.UIParent, 'BOTTOM', -240, 220},
    tof = {'TOPLEFT', 'oUF_Focus', 'TOPRIGHT', 6, 0},
    boss = {'LEFT', 'oUF_Target', 'RIGHT', 120, 120},
    arena = {'LEFT', 'oUF_Target', 'RIGHT', 120, 120},
    party = {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60},
    raid = {'TOPRIGHT', 'Minimap', 'TOPLEFT', -6, -44},
}

local function Player_OnEnter(self)
    self.HealthValue:Show()
    self.PowerValue:Show()
    self:UpdateTags()
end

local function Player_OnLeave(self)
    self.HealthValue:Hide()
    self.PowerValue:Hide()
end

local function CreatePlayerStyle(self)
    self.unitStyle = 'player'
    self:SetSize(C.DB.Unitframe.PlayerWidth, C.DB.Unitframe.PlayerHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthPrediction(self)
    UNITFRAME:CreateHealthValueText(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePowerValueText(self)
    UNITFRAME:CreateAlternativePowerBar(self)
    UNITFRAME:CreateAlternativePowerValueText(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateCombatIndicator(self)
    UNITFRAME:CreateRestingIndicator(self)
    UNITFRAME:CreateEmergencyIndicator(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateGCDIndicator(self)
    UNITFRAME:CreateFader(self)
    UNITFRAME:CreateClassPowerBar(self)
    UNITFRAME:CreateStagger(self)
    UNITFRAME:CreateTotemsBar(self)
end

function UNITFRAME:SpawnPlayer()
    OUF:RegisterStyle('Player', CreatePlayerStyle)
    OUF:SetActiveStyle 'Player'

    local player = OUF:Spawn('player', 'oUF_Player')
    if C.DB.Unitframe.HidePlayerTags then
        player.HealthValue:Hide()
        player.PowerValue:Hide()
        player:HookScript('OnEnter', Player_OnEnter)
        player:HookScript('OnLeave', Player_OnLeave)
    end
    F.Mover(player, L['Player Frame'], 'PlayerFrame', unitsPos.player, player:GetWidth(), player:GetHeight())
end

local function CreatePetStyle(self)
    self.unitStyle = 'pet'
    self:SetSize(C.DB.Unitframe.PetWidth, C.DB.Unitframe.PetHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
end

function UNITFRAME:SpawnPet()
    OUF:RegisterStyle('Pet', CreatePetStyle)
    OUF:SetActiveStyle 'Pet'

    local pet = OUF:Spawn('pet', 'oUF_Pet')
    F.Mover(pet, L['Pet Frame'], 'PetFrame', unitsPos.pet, pet:GetWidth(), pet:GetHeight())
end

local function CreateTargetStyle(self)
    self.unitStyle = 'target'
    self:SetSize(C.DB.Unitframe.TargetWidth, C.DB.Unitframe.TargetHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateHealthValueText(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnTarget()
    OUF:RegisterStyle('Target', CreateTargetStyle)
    OUF:SetActiveStyle 'Target'

    local target = OUF:Spawn('target', 'oUF_Target')
    F.Mover(target, L['Target Frame'], 'TargetFrame', unitsPos.target, target:GetWidth(), target:GetHeight())
end

local function CreateTargetTargetStyle(self)
    self.unitStyle = 'targettarget'
    self:SetSize(C.DB.Unitframe.ToTWidth, C.DB.Unitframe.ToTHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnTargetTarget()
    OUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)
    OUF:SetActiveStyle 'TargetTarget'

    local targettarget = OUF:Spawn('targettarget', 'oUF_TargetTarget')
    F.Mover(targettarget, L['Target of Target Frame'], 'TargetTargetFrame', unitsPos.tot, targettarget:GetWidth(), targettarget:GetHeight())
end

local function CreateFocusStyle(self)
    self.unitStyle = 'focus'
    self:SetSize(C.DB.Unitframe.FocusWidth, C.DB.Unitframe.FocusHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnFocus()
    OUF:RegisterStyle('Focus', CreateFocusStyle)
    OUF:SetActiveStyle 'Focus'

    local focus = OUF:Spawn('focus', 'oUF_Focus')
    F.Mover(focus, L['Focus Frame'], 'FocusFrame', unitsPos.focus, focus:GetWidth(), focus:GetHeight())
end

local function CreateFocusTargetStyle(self)
    self.unitStyle = 'focustarget'
    self:SetSize(C.DB.Unitframe.ToFWidth, C.DB.Unitframe.ToFHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnFocusTarget()
    OUF:RegisterStyle('FocusTarget', CreateFocusTargetStyle)
    OUF:SetActiveStyle 'FocusTarget'

    local focustarget = OUF:Spawn('focustarget', 'oUF_FocusTarget')
    F.Mover(focustarget, L['Target of Focus Frame'], 'FocusTargetFrame', unitsPos.tof, focustarget:GetWidth(), focustarget:GetHeight())
end

local function CreateBossStyle(self)
    self.unitStyle = 'boss'
    self:SetSize(C.DB.Unitframe.BossWidth, C.DB.Unitframe.BossHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthValueText(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateAlternativePowerBar(self)
    UNITFRAME:CreateAlternativePowerValueText(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
end

function UNITFRAME:SpawnBoss()
    OUF:RegisterStyle('Boss', CreateBossStyle)
    OUF:SetActiveStyle 'Boss'

    local boss = {}
    for i = 1, _G.MAX_BOSS_FRAMES do
        boss[i] = OUF:Spawn('boss' .. i, 'oUF_Boss' .. i)
        if i == 1 then
            boss[i].mover = F.Mover(boss[i], L['Boss Frame'], 'BossFrame', unitsPos.boss, C.DB.Unitframe.boss_width, C.DB.Unitframe.boss_height)
        else
            boss[i]:SetPoint('BOTTOM', boss[i - 1], 'TOP', 0, C.DB.Unitframe.BossGap)
        end
    end
end

local function CreateArenaStyle(self)
    self.unitStyle = 'arena'
    self:SetSize(C.DB.Unitframe.ArenaWidth, C.DB.Unitframe.ArenaHeight)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateHealthValueText(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateSelectedBorder(self)
end

function UNITFRAME:SpawnArena()
    OUF:RegisterStyle('Arena', CreateArenaStyle)
    OUF:SetActiveStyle 'Arena'

    local arena = {}
    for i = 1, 5 do
        arena[i] = OUF:Spawn('arena' .. i, 'oUF_Arena' .. i)
        if i == 1 then
            arena[i].mover = F.Mover(arena[i], L['Arena Frame'], 'ArenaFrame', unitsPos.arena, C.DB.Unitframe.ArenaWidth, C.DB.Unitframe.ArenaHeight)
        else
            arena[i]:SetPoint('BOTTOM', arena[i - 1], 'TOP', 0, C.DB.Unitframe.ArenaGap)
        end
    end
end

local function GetPartyVisibility()
    local visibility = '[group:party,nogroup:raid] show;hide'

    if C.DB.Unitframe.SmartRaid then
        visibility = '[@raid6,noexists,group] show;hide'
    end

    if C.DB.Unitframe.ShowSolo then
        visibility = '[nogroup] show;'..visibility
    end

    return visibility
end

local function GetRaidVisibility()
    local visibility

    if C.DB.Unitframe.SmartRaid then
        visibility = '[@raid6,exists] show;hide'
    else
        visibility = '[group:raid] show;hide'
    end

    return visibility
end

UNITFRAME.headers = {}
function UNITFRAME:UpdateAllHeaders()
    if not UNITFRAME.headers then return end

    for _, header in pairs(UNITFRAME.headers) do
        if header.groupType == 'party' then
            RegisterStateDriver(header, 'visibility', GetPartyVisibility())
        elseif header.groupType == 'raid' then
            RegisterStateDriver(header, 'visibility', GetRaidVisibility())
        end
    end
end

local function CreatePartyStyle(self)
    self.unitStyle = 'party'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateGroupNameText(self)
    UNITFRAME:CreateLeaderIndicator(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateResurrectIndicator(self)
    UNITFRAME:CreateReadyCheckIndicator(self)
    UNITFRAME:CreateGroupRoleIndicator(self)
    UNITFRAME:CreatePhaseIndicator(self)
    UNITFRAME:CreateSummonIndicator(self)
    UNITFRAME:CreateThreatIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateBuffs(self)
    UNITFRAME:CreateDebuffs(self)
    UNITFRAME:RefreshAurasByCombat(self)
    UNITFRAME:CreateCornerIndicator(self)
    UNITFRAME:CreateRaidDebuff(self)
    UNITFRAME:CreateDebuffHighlight(self)
    UNITFRAME:CreatePartyWatcher(self)
end

function UNITFRAME:SpawnParty()
    UNITFRAME:SyncWithZenTracker()
    UNITFRAME:UpdatePartyWatcherSpells()
    UNITFRAME:UpdateCornerSpells()

    OUF:RegisterStyle('Party', CreatePartyStyle)
    OUF:SetActiveStyle 'Party'

    local partyWidth, partyHeight = C.DB.Unitframe.PartyWidth, C.DB.Unitframe.PartyHeight
    local partyHorizon = C.DB.Unitframe.PartyHorizon
    local partyReverse = C.DB.Unitframe.PartyReverse
    local partyGap = C.DB.Unitframe.PartyGap
    local groupingOrder = partyHorizon and 'TANK,HEALER,DAMAGER,NONE' or 'TANK,HEALER,DAMAGER,NONE'
    local moverWidth = partyHorizon and partyWidth * 5 + partyGap * 4 or partyWidth
    local moverHeight = partyHorizon and partyHeight or partyHeight * 5 + partyGap * 4
    local partyMover
    local party = OUF:SpawnHeader('oUF_Party', nil, nil,
        'showPlayer', true,
        'showSolo', true,
        'showParty', true,
        'showRaid', true,
        'xoffset', partyGap,
        'yoffset', partyGap,
        'point', partyHorizon and 'LEFT' or 'BOTTOM',
        'groupingOrder', groupingOrder,
        'groupBy', 'ASSIGNEDROLE',
        'sortMethod', 'NAME',
        'oUF-initialConfigFunction', format('self:SetWidth(%d); self:SetHeight(%d);', partyWidth, partyHeight))

    party.groupType = 'party'
    tinsert(UNITFRAME.headers, party)
    RegisterStateDriver(party, 'visibility', GetPartyVisibility())

    partyMover = F.Mover(party, L['Party Frame'], 'PartyFrame', unitsPos.party, moverWidth, moverHeight)
    party:ClearAllPoints()
    party:SetPoint('BOTTOMLEFT', partyMover)
    UNITFRAME.PartyMover = partyMover
end

local function CreateRaidStyle(self)
    self.unitStyle = 'raid'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateGroupNameText(self)
    UNITFRAME:CreateLeaderIndicator(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateResurrectIndicator(self)
    UNITFRAME:CreateReadyCheckIndicator(self)
    UNITFRAME:CreateGroupRoleIndicator(self)
    UNITFRAME:CreatePhaseIndicator(self)
    UNITFRAME:CreateSummonIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateCornerIndicator(self)
    UNITFRAME:CreateRaidDebuff(self)
    UNITFRAME:CreateBuffs(self)
    UNITFRAME:CreateDebuffs(self)
    UNITFRAME:RefreshAurasByCombat(self)
    UNITFRAME:CreateDebuffHighlight(self)
end

function UNITFRAME:SpawnRaid()
    UNITFRAME:UpdateCornerSpells()

    OUF:RegisterStyle('Raid', CreateRaidStyle)
    OUF:SetActiveStyle 'Raid'

    local raidWidth = C.DB.Unitframe.RaidWidth
    local raidHeight = C.DB.Unitframe.RaidHeight
    local raidHorizon = C.DB.Unitframe.RaidHorizon
    local raidReverse = C.DB.Unitframe.RaidReverse
    local raidGap = C.DB.Unitframe.RaidGap
    local numGroups = C.DB.Unitframe.GroupFilter
    local raidMover

    local function CreateRaid(name, i)
        local raid = OUF:SpawnHeader(name, nil, nil,
            'showPlayer', true,
            'showSolo', true,
            'showParty', true,
            'showRaid', true,
            'xoffset', raidGap,
            'yOffset', -raidGap,
            'groupFilter', tostring(i),
            'groupingOrder', '1,2,3,4,5,6,7,8',
            'groupBy', 'GROUP',
            'sortMethod', 'INDEX',
            'maxColumns', 1,
            'unitsPerColumn', 5,
            'columnSpacing', raidGap,
            'point', raidHorizon and 'LEFT' or 'TOP',
            'columnAnchorPoint', 'LEFT',
            'oUF-initialConfigFunction', format('self:SetWidth(%d); self:SetHeight(%d);', raidWidth, raidHeight))

        return raid
    end

    local groupFilter
    if numGroups == 4 then
        groupFilter = '1,2,3,4'
    elseif numGroups == 5 then
        groupFilter = '1,2,3,4,5'
    elseif numGroups == 6 then
        groupFilter = '1,2,3,4,5,6'
    elseif numGroups == 7 then
        groupFilter = '1,2,3,4,5,6,7'
    elseif numGroups == 8 then
        groupFilter = '1,2,3,4,5,6,7,8'
    end

    local groups = {}
    for i = 1, numGroups do
        groups[i] = CreateRaid('oUF_Raid' .. i, i)
        groups[i].groupType = 'raid'
        tinsert(UNITFRAME.headers, groups[i])
        RegisterStateDriver(groups[i], 'visibility', GetRaidVisibility())

        if i == 1 then
            if raidHorizon then
                raidMover = F.Mover(groups[i], L['Raid Frame'], 'RaidFrame', unitsPos.raid, (raidWidth + raidGap) * 5 - raidGap, (raidHeight + raidGap) * numGroups - raidGap)
                if raidReverse then
                    groups[i]:ClearAllPoints()
                    groups[i]:SetPoint('BOTTOMLEFT', raidMover)
                end
            else
                raidMover = F.Mover(groups[i], L['Raid Frame'], 'RaidFrame', unitsPos.raid, (raidWidth + raidGap) * numGroups - raidGap, (raidHeight + raidGap) * 5 - raidGap)
                if raidReverse then
                    groups[i]:ClearAllPoints()
                    groups[i]:SetPoint('TOPRIGHT', raidMover)
                end
            end
        else
            if raidHorizon then
                if raidReverse then
                    groups[i]:SetPoint('BOTTOMLEFT', groups[i - 1], 'TOPLEFT', 0, raidGap)
                else
                    groups[i]:SetPoint('TOPLEFT', groups[i - 1], 'BOTTOMLEFT', 0, -raidGap)
                end
            else
                if raidReverse then
                    groups[i]:SetPoint('TOPRIGHT', groups[i - 1], 'TOPLEFT', -raidGap, 0)
                else
                    groups[i]:SetPoint('TOPLEFT', groups[i - 1], 'TOPRIGHT', raidGap, 0)
                end
            end
        end
    end

    UNITFRAME.RaidMover = raidMover
end
