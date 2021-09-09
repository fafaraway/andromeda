local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local oUF = F.Libs.oUF

UNITFRAME.Positions = {
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

local function CreatePlayerStyle(self)
    self.unitStyle = 'player'
    self:SetWidth(C.DB.Unitframe.PlayerWidth)
    self:SetHeight(C.DB.Unitframe.PlayerHealthHeight + C.DB.Unitframe.PlayerPowerHeight + C.Mult)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateAlternativePowerBar(self)
    UNITFRAME:CreateAlternativePowerValueText(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateGCDTicker(self)
    UNITFRAME:CreateFader(self)
    UNITFRAME:CreateClassPowerBar(self)
    UNITFRAME:CreateStagger(self)
    UNITFRAME:CreateTotemsBar(self)
    UNITFRAME:CreatePlayerTags(self)
end

function UNITFRAME:SpawnPlayer()
    oUF:RegisterStyle('Player', CreatePlayerStyle)
    oUF:SetActiveStyle 'Player'

    local player = oUF:Spawn('player', 'oUF_Player')
    F.Mover(player, L['Player Frame'], 'PlayerFrame', UNITFRAME.Positions.player, player:GetWidth(), player:GetHeight())
end

local function CreatePetStyle(self)
    self.unitStyle = 'pet'
    self:SetWidth(C.DB.Unitframe.PetWidth)
    self:SetHeight(C.DB.Unitframe.PetHealthHeight + C.DB.Unitframe.PetPowerHeight + C.Mult)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
end

function UNITFRAME:SpawnPet()
    oUF:RegisterStyle('Pet', CreatePetStyle)
    oUF:SetActiveStyle 'Pet'

    local pet = oUF:Spawn('pet', 'oUF_Pet')
    F.Mover(pet, L['Pet Frame'], 'PetFrame', UNITFRAME.Positions.pet, pet:GetWidth(), pet:GetHeight())
end

local function CreateTargetStyle(self)
    self.unitStyle = 'target'
    self:SetWidth(C.DB.Unitframe.TargetWidth)
    self:SetHeight(C.DB.Unitframe.TargetHealthHeight + C.DB.Unitframe.TargetPowerHeight + C.Mult)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
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
    oUF:RegisterStyle('Target', CreateTargetStyle)
    oUF:SetActiveStyle 'Target'

    local target = oUF:Spawn('target', 'oUF_Target')
    F.Mover(target, L['Target Frame'], 'TargetFrame', UNITFRAME.Positions.target, target:GetWidth(), target:GetHeight())
end

local function CreateTargetTargetStyle(self)
    self.unitStyle = 'targettarget'
    self:SetWidth(C.DB.Unitframe.TargetTargetWidth)
    self:SetHeight(C.DB.Unitframe.TargetTargetHealthHeight + C.DB.Unitframe.TargetTargetPowerHeight + C.Mult)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnTargetTarget()
    oUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)
    oUF:SetActiveStyle 'TargetTarget'

    local targettarget = oUF:Spawn('targettarget', 'oUF_TargetTarget')
    F.Mover(targettarget, L['Target of Target Frame'], 'TargetTargetFrame', UNITFRAME.Positions.tot, targettarget:GetWidth(), targettarget:GetHeight())
end

local function CreateFocusStyle(self)
    self.unitStyle = 'focus'
    self:SetWidth(C.DB.Unitframe.FocusWidth)
    self:SetHeight(C.DB.Unitframe.FocusHealthHeight + C.DB.Unitframe.FocusPowerHeight + C.Mult)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnFocus()
    oUF:RegisterStyle('Focus', CreateFocusStyle)
    oUF:SetActiveStyle 'Focus'

    local focus = oUF:Spawn('focus', 'oUF_Focus')
    F.Mover(focus, L['Focus Frame'], 'FocusFrame', UNITFRAME.Positions.focus, focus:GetWidth(), focus:GetHeight())
end

local function CreateFocusTargetStyle(self)
    self.unitStyle = 'focustarget'
    self:SetWidth(C.DB.Unitframe.FocusTargetWidth)
    self:SetHeight(C.DB.Unitframe.FocusTargetHealthHeight + C.DB.Unitframe.FocusTargetPowerHeight + C.Mult)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameText(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateRangeCheck(self)
end

function UNITFRAME:SpawnFocusTarget()
    oUF:RegisterStyle('FocusTarget', CreateFocusTargetStyle)
    oUF:SetActiveStyle 'FocusTarget'

    local focustarget = oUF:Spawn('focustarget', 'oUF_FocusTarget')
    F.Mover(focustarget, L['Target of Focus Frame'], 'FocusTargetFrame', UNITFRAME.Positions.tof, focustarget:GetWidth(), focustarget:GetHeight())
end

local function CreateBossStyle(self)
    self.unitStyle = 'boss'
    self:SetWidth(C.DB.Unitframe.BossWidth)
    self:SetHeight(C.DB.Unitframe.BossHealthHeight + C.DB.Unitframe.BossPowerHeight + C.Mult)

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
    oUF:RegisterStyle('Boss', CreateBossStyle)
    oUF:SetActiveStyle 'Boss'

    local boss = {}
    for i = 1, _G.MAX_BOSS_FRAMES do
        boss[i] = oUF:Spawn('boss' .. i, 'oUF_Boss' .. i)
        if i == 1 then
            boss[i].mover = F.Mover(boss[i], L['Boss Frame'], 'BossFrame', UNITFRAME.Positions.boss, C.DB.Unitframe.boss_width, C.DB.Unitframe.boss_height)
        else
            boss[i]:SetPoint('BOTTOM', boss[i - 1], 'TOP', 0, C.DB.Unitframe.BossGap)
        end
    end
end

local function CreateArenaStyle(self)
    self.unitStyle = 'arena'
    self:SetWidth(C.DB.Unitframe.ArenaWidth)
    self:SetHeight(C.DB.Unitframe.ArenaHealthHeight + C.DB.Unitframe.ArenaPowerHeight + C.Mult)

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
    oUF:RegisterStyle('Arena', CreateArenaStyle)
    oUF:SetActiveStyle 'Arena'

    local arena = {}
    for i = 1, 5 do
        arena[i] = oUF:Spawn('arena' .. i, 'oUF_Arena' .. i)
        if i == 1 then
            arena[i].mover = F.Mover(arena[i], L['Arena Frame'], 'ArenaFrame', UNITFRAME.Positions.arena, C.DB.Unitframe.ArenaWidth, C.DB.Unitframe.ArenaHeight)
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
            _G.RegisterStateDriver(header, 'visibility', GetPartyVisibility())
        elseif header.groupType == 'raid' then
            _G.RegisterStateDriver(header, 'visibility', GetRaidVisibility())
        end
    end
end

local function CreatePartyStyle(self)
    self.unitStyle = 'party'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateGroupNameTag(self)
    UNITFRAME:CreateGroupLeaderTag(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateResurrectIndicator(self)
    UNITFRAME:CreateReadyCheckIndicator(self)
    UNITFRAME:CreateGroupRoleTag(self)
    UNITFRAME:CreatePhaseIndicator(self)
    UNITFRAME:CreateSummonIndicator(self)
    UNITFRAME:CreateThreatIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateBuffs(self)
    UNITFRAME:CreateDebuffs(self)
    UNITFRAME:RefreshAurasByCombat(self)
    UNITFRAME:CreateCornerIndicator(self)
    UNITFRAME:CreatePartyWatcher(self)
end

function UNITFRAME:SpawnParty()
    UNITFRAME:SyncWithZenTracker()
    UNITFRAME:UpdatePartyWatcherSpells()

    oUF:RegisterStyle('Party', CreatePartyStyle)
    oUF:SetActiveStyle 'Party'

    local partyWidth = C.DB.Unitframe.PartyWidth
    local partyHeight = C.DB.Unitframe.PartyHealthHeight + C.DB.Unitframe.PartyPowerHeight + C.Mult
    local partyHorizon = C.DB.Unitframe.PartyHorizon
    -- local partyReverse = C.DB.Unitframe.PartyReverse
    local partyGap = C.DB.Unitframe.PartyGap
    local groupingOrder = partyHorizon and 'TANK,HEALER,DAMAGER,NONE' or 'TANK,HEALER,DAMAGER,NONE'
    local moverWidth = partyHorizon and partyWidth * 5 + partyGap * 4 or partyWidth
    local moverHeight = partyHorizon and partyHeight or partyHeight * 5 + partyGap * 4
    local partyMover
    local party = oUF:SpawnHeader('oUF_Party', nil, nil,
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
        'oUF-initialConfigFunction', string.format('self:SetWidth(%d); self:SetHeight(%d);', partyWidth, partyHeight))

    party.groupType = 'party'
    table.insert(UNITFRAME.headers, party)
    _G.RegisterStateDriver(party, 'visibility', GetPartyVisibility())

    partyMover = F.Mover(party, L['Party Frame'], 'PartyFrame', UNITFRAME.Positions.party, moverWidth, moverHeight)
    party:ClearAllPoints()
    party:SetPoint('BOTTOMLEFT', partyMover)
    UNITFRAME.PartyMover = partyMover
end

local function CreateRaidStyle(self)
    self.unitStyle = 'raid'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateGroupNameTag(self)
    UNITFRAME:CreateGroupLeaderTag(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateResurrectIndicator(self)
    UNITFRAME:CreateReadyCheckIndicator(self)
    UNITFRAME:CreateGroupRoleTag(self)
    UNITFRAME:CreatePhaseIndicator(self)
    UNITFRAME:CreateSummonIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateCornerIndicator(self)
    UNITFRAME:CreateRaidDebuff(self)
    UNITFRAME:RefreshAurasByCombat(self)
end

function UNITFRAME:SpawnRaid()
    oUF:RegisterStyle('Raid', CreateRaidStyle)
    oUF:SetActiveStyle 'Raid'

    local raidWidth = C.DB.Unitframe.RaidWidth
    local raidHeight = C.DB.Unitframe.RaidHealthHeight + C.DB.Unitframe.RaidPowerHeight + C.Mult
    local raidHorizon = C.DB.Unitframe.RaidHorizon
    local raidReverse = C.DB.Unitframe.RaidReverse
    local raidGap = C.DB.Unitframe.RaidGap
    local numGroups = C.DB.Unitframe.GroupFilter
    local raidMover

    local function CreateRaid(name, i)
        local raid = oUF:SpawnHeader(name, nil, nil,
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
            'oUF-initialConfigFunction', string.format('self:SetWidth(%d); self:SetHeight(%d);', raidWidth, raidHeight))

        return raid
    end

    local groups = {}
    for i = 1, numGroups do
        groups[i] = CreateRaid('oUF_Raid' .. i, i)
        groups[i].groupType = 'raid'
        table.insert(UNITFRAME.headers, groups[i])
        _G.RegisterStateDriver(groups[i], 'visibility', GetRaidVisibility())

        if i == 1 then
            if raidHorizon then
                raidMover = F.Mover(groups[i], L['Raid Frame'], 'RaidFrame', UNITFRAME.Positions.raid, (raidWidth + raidGap) * 5 - raidGap, (raidHeight + raidGap) * numGroups - raidGap)
                if raidReverse then
                    groups[i]:ClearAllPoints()
                    groups[i]:SetPoint('BOTTOMLEFT', raidMover)
                end
            else
                raidMover = F.Mover(groups[i], L['Raid Frame'], 'RaidFrame', UNITFRAME.Positions.raid, (raidWidth + raidGap) * numGroups - raidGap, (raidHeight + raidGap) * 5 - raidGap)
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

    UNITFRAME:UpdateRaidHealthMethod()
end

function UNITFRAME:SpawnUnits()
    if not C.DB.Unitframe.Enable then
        return
    end

    UNITFRAME:UpdateHealthColor()
    UNITFRAME:UpdateClassColor()
    UNITFRAME:CreateTargetSound()
    UNITFRAME:CheckPartySpells()
    UNITFRAME:CheckCornerSpells()
    UNITFRAME:UpdateCornerSpells()

    UNITFRAME:SpawnPlayer()
    UNITFRAME:SpawnPet()
    UNITFRAME:SpawnTarget()
    UNITFRAME:SpawnTargetTarget()
    UNITFRAME:SpawnFocus()
    UNITFRAME:SpawnFocusTarget()
    UNITFRAME:SpawnBoss()

    if C.DB.Unitframe.Arena then
        UNITFRAME:SpawnArena()
    end

    if not C.DB.Unitframe.Group then
        return
    end

    UNITFRAME:RemoveBlizzRaidFrame()

    UNITFRAME:SpawnParty()
    UNITFRAME:SpawnRaid()
    UNITFRAME:ClickCast()

    if C.DB.Unitframe.PositionBySpec then
        local function UpdateSpecPos(event, ...)
            local unit, _, spellID = ...
            if (event == 'UNIT_SPELLCAST_SUCCEEDED' and unit == 'player' and spellID == 200749) or event == 'ON_LOGIN' then
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end

                if not C.DB['UIAnchor']['raid_position' .. specIndex] then
                    C.DB['UIAnchor']['raid_position' .. specIndex] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -10}
                end

                UNITFRAME.RaidMover:ClearAllPoints()
                UNITFRAME.RaidMover:SetPoint(unpack(C.DB['UIAnchor']['raid_position' .. specIndex]))

                if UNITFRAME.RaidMover then
                    UNITFRAME.RaidMover:ClearAllPoints()
                    UNITFRAME.RaidMover:SetPoint(unpack(C.DB['UIAnchor']['raid_position' .. specIndex]))
                end

                if not C.DB['UIAnchor']['party_position' .. specIndex] then
                    C.DB['UIAnchor']['party_position' .. specIndex] = {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60}
                end
                if UNITFRAME.PartyMover then
                    UNITFRAME.PartyMover:ClearAllPoints()
                    UNITFRAME.PartyMover:SetPoint(unpack(C.DB['UIAnchor']['party_position' .. specIndex]))
                end
            end
        end
        UpdateSpecPos('ON_LOGIN')
        F:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', UpdateSpecPos)

        if UNITFRAME.RaidMover then
            UNITFRAME.RaidMover:HookScript(
                'OnDragStop',
                function()
                    local specIndex = GetSpecialization()
                    if not specIndex then
                        return
                    end
                    C.DB['UIAnchor']['raid_position' .. specIndex] = C.DB['UIAnchor']['RaidFrame']
                end
            )
        end

        if UNITFRAME.PartyMover then
            UNITFRAME.PartyMover:HookScript(
                'OnDragStop',
                function()
                    local specIndex = GetSpecialization()
                    if not specIndex then
                        return
                    end
                    C.DB['UIAnchor']['party_position' .. specIndex] = C.DB['UIAnchor']['PartyFrame']
                end
            )
        end
    end
end
