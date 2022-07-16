local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

-- Group Frames

function UNITFRAME:UpdatePartyElements()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'party' then
            if frame.PartyWatcher then
                frame.PartyWatcher:UpdateAnchor()
            end
            if frame.Auras then
                frame.Auras:UpdateAnchor()
                frame.Auras:ForceUpdate()
            end
        end
    end
end

local function GetPartyVisibility()
    local visibility = '[group:party,nogroup:raid] show;hide'

    if C.DB.Unitframe.SmartRaid then
        visibility = '[@raid6,noexists,group] show;hide'
    end

    if C.DB.Unitframe.ShowSolo then
        visibility = '[nogroup] show;' .. visibility
    end

    return visibility
end

local function GetRaidVisibility()
    local visibility

    if C.DB.Unitframe.PartyFrame then
        if C.DB.Unitframe.SmartRaid then
            visibility = '[@raid6,exists] show;hide'
        else
            visibility = '[group:raid] show;hide'
        end
    else
        if C.DB.Unitframe.ShowSolo then
            visibility = 'show'
        else
            visibility = '[group] show;hide'
        end
    end

    return visibility
end

UNITFRAME.headers = {}
function UNITFRAME:UpdateAllHeaders()
    if not UNITFRAME.headers then
        return
    end

    for _, header in pairs(UNITFRAME.headers) do
        if header.groupType == 'party' then
            RegisterStateDriver(header, 'visibility', GetPartyVisibility())
        elseif header.groupType == 'raid' then
            if header.__disabled then
                RegisterStateDriver(header, 'visibility', 'hide')
            else
                RegisterStateDriver(header, 'visibility', GetRaidVisibility())
            end
        end
    end
end

local function GetGroupFilterByIndex(numGroups)
    local groupFilter
    for i = 1, numGroups do
        if not groupFilter then
            groupFilter = i
        else
            groupFilter = groupFilter .. ',' .. i
        end
    end
    return groupFilter
end

local function ResetHeaderPoints(header)
    for i = 1, header:GetNumChildren() do
        select(i, header:GetChildren()):ClearAllPoints()
    end
end

-- Party Frames

local function CreatePartyStyle(self)
    self.unitStyle = 'party'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateGroupNameTag(self)
    UNITFRAME:CreateGroupLeaderTag(self)
    UNITFRAME:CreateResurrectIndicator(self)
    UNITFRAME:CreateReadyCheckIndicator(self)
    UNITFRAME:CreateGroupRoleTag(self)
    UNITFRAME:CreatePhaseIndicator(self)
    UNITFRAME:CreateSummonIndicator(self)
    UNITFRAME:CreateThreatIndicator(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreatePartyAuras(self)
    UNITFRAME:CreatePartyBuffs(self)
    UNITFRAME:CreatePartyDebuffs(self)
    UNITFRAME:CreateDebuffWatcher(self)
    UNITFRAME:RefreshAurasByCombat(self)
    UNITFRAME:CreateCornerIndicator(self)
    UNITFRAME:CreatePartyWatcher(self)
end

UNITFRAME.PartyDirections = {
    [1] = { name = L['DOWN'], point = 'TOP', xOffset = 0, yOffset = -5, initAnchor = 'TOPLEFT' },
    [2] = { name = L['UP'], point = 'BOTTOM', xOffset = 0, yOffset = 5, initAnchor = 'BOTTOMLEFT' },
    [3] = { name = L['RIGHT'], point = 'LEFT', xOffset = 5, yOffset = 0, initAnchor = 'TOPLEFT' },
    [4] = { name = L['LEFT'], point = 'RIGHT', xOffset = -5, yOffset = 0, initAnchor = 'TOPRIGHT' },
}

local party
local partyMover
local ascRole = 'TANK,HEALER,DAMAGER,NONE'
local descRole = 'NONE,DAMAGER,HEALER,TANK'

local function CreatePartyHeader(name, width, height)
    -- stylua: ignore start
    local group = oUF:SpawnHeader(name, nil, nil,
        'showPlayer', true,
        'showSolo', true,
        'showParty', true,
        'showRaid', true,
        'sortMethod', 'NAME',
        'columnAnchorPoint', 'LEFT',
        'oUF-initialConfigFunction',
        ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
        ]]):format(width, height)
    )
    -- stylua: ignore end

    return group
end

function UNITFRAME:CreateAndUpdatePartyHeader()
    local index = C.DB.Unitframe.PartyDirec
    local sortData = UNITFRAME.PartyDirections[index]
    local partyWidth = C.DB.Unitframe.PartyWidth
    local partyHeight = C.DB.Unitframe.PartyHealthHeight + C.DB.Unitframe.PartyPowerHeight + C.MULT

    if not party then
        party = CreatePartyHeader('oUF_Party', partyWidth, partyHeight)
        party.groupType = 'party'
        tinsert(UNITFRAME.headers, party)
        RegisterStateDriver(party, 'visibility', GetPartyVisibility())
        partyMover = F.Mover(party, L['PartyFrame'], 'PartyFrame', UNITFRAME.Positions.party)
        UNITFRAME.PartyMover = partyMover
    end

    local moverWidth = index < 3 and partyWidth or (partyWidth + 5) * 5 - 5
    local moverHeight = index < 3 and (partyHeight + 5) * 5 - 5 or partyHeight
    partyMover:SetSize(moverWidth, moverHeight)
    party:ClearAllPoints()
    party:SetPoint(sortData.initAnchor, partyMover)

    ResetHeaderPoints(party)
    party:SetAttribute('point', sortData.point)
    party:SetAttribute('xOffset', sortData.xOffset)
    party:SetAttribute('yOffset', sortData.yOffset)
    party:SetAttribute('groupingOrder', C.DB.Unitframe.DescRole and descRole or ascRole)
    party:SetAttribute('groupBy', 'ASSIGNEDROLE')
end

function UNITFRAME:SpawnParty()
    UNITFRAME:SyncWithZenTracker()
    UNITFRAME:UpdatePartyWatcherSpells()


    oUF:RegisterStyle('Party', CreatePartyStyle)
    oUF:SetActiveStyle('Party')

    UNITFRAME:CreateAndUpdatePartyHeader()
end

-- Raid Frames

UNITFRAME.RaidDirections = {
    [1] = {
        name = L['DOWN_RIGHT'],
        point = 'TOP',
        xOffset = 0,
        yOffset = -5,
        initAnchor = 'TOPLEFT',
        relAnchor = 'TOPRIGHT',
        x = 5,
        y = 0,
        columnAnchorPoint = 'LEFT',
        multX = 1,
        multY = -1,
    },
    [2] = {
        name = L['DOWN_LEFT'],
        point = 'TOP',
        xOffset = 0,
        yOffset = -5,
        initAnchor = 'TOPRIGHT',
        relAnchor = 'TOPLEFT',
        x = -5,
        y = 0,
        columnAnchorPoint = 'RIGHT',
        multX = -1,
        multY = -1,
    },
    [3] = {
        name = L['UP_RIGHT'],
        point = 'BOTTOM',
        xOffset = 0,
        yOffset = 5,
        initAnchor = 'BOTTOMLEFT',
        relAnchor = 'BOTTOMRIGHT',
        x = 5,
        y = 0,
        columnAnchorPoint = 'LEFT',
        multX = 1,
        multY = 1,
    },
    [4] = {
        name = L['UP_LEFT'],
        point = 'BOTTOM',
        xOffset = 0,
        yOffset = 5,
        initAnchor = 'BOTTOMRIGHT',
        relAnchor = 'BOTTOMLEFT',
        x = -5,
        y = 0,
        columnAnchorPoint = 'RIGHT',
        multX = -1,
        multY = 1,
    },
    [5] = {
        name = L['RIGHT_DOWN'],
        point = 'LEFT',
        xOffset = 5,
        yOffset = 0,
        initAnchor = 'TOPLEFT',
        relAnchor = 'BOTTOMLEFT',
        x = 0,
        y = -5,
        columnAnchorPoint = 'TOP',
        multX = 1,
        multY = -1,
    },
    [6] = {
        name = L['RIGHT_UP'],
        point = 'LEFT',
        xOffset = 5,
        yOffset = 0,
        initAnchor = 'BOTTOMLEFT',
        relAnchor = 'TOPLEFT',
        x = 0,
        y = 5,
        columnAnchorPoint = 'BOTTOM',
        multX = 1,
        multY = 1,
    },
    [7] = {
        name = L['LEFT_DOWN'],
        point = 'RIGHT',
        xOffset = -5,
        yOffset = 0,
        initAnchor = 'TOPRIGHT',
        relAnchor = 'BOTTOMRIGHT',
        x = 0,
        y = -5,
        columnAnchorPoint = 'TOP',
        multX = -1,
        multY = -1,
    },
    [8] = {
        name = L['LEFT_UP'],
        point = 'RIGHT',
        xOffset = -5,
        yOffset = 0,
        initAnchor = 'BOTTOMRIGHT',
        relAnchor = 'TOPRIGHT',
        x = 0,
        y = 5,
        columnAnchorPoint = 'BOTTOM',
        multX = -1,
        multY = 1,
    },
}

local function CreateSimpleRaidStyle(self)
    self.unitStyle = 'simple'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateGroupNameTag(self)
    UNITFRAME:CreateRangeCheck(self)
end

local groupByTypes = {
    [1] = { '1,2,3,4,5,6,7,8', 'GROUP', 'INDEX' },
    [2] = {
        'DEATHKNIGHT,WARRIOR,DEMONHUNTER,ROGUE,MONK,PALADIN,DRUID,SHAMAN,HUNTER,PRIEST,MAGE,WARLOCK',
        'CLASS',
        'NAME',
    },
    [3] = { 'TANK,HEALER,DAMAGER,NONE', 'ASSIGNEDROLE', 'NAME' },
}

local raidMover
local simpleRaid
function UNITFRAME:UpdateSimpleModeHeader()
    ResetHeaderPoints(simpleRaid)

    local groupByIndex = C.DB['Unitframe']['SMRGroupBy']
    local unitsPerColumn = C.DB['Unitframe']['SMRPerCol']
    local numGroups = C.DB['Unitframe']['SMRGroups']
    local scale = C.DB['Unitframe']['SMRScale'] / 10
    local maxColumns = ceil(numGroups * 5 / unitsPerColumn)

    simpleRaid:SetAttribute('groupingOrder', groupByTypes[groupByIndex][1])
    simpleRaid:SetAttribute('groupBy', groupByTypes[groupByIndex][2])
    simpleRaid:SetAttribute('sortMethod', groupByTypes[groupByIndex][3])
    simpleRaid:SetAttribute('groupFilter', GetGroupFilterByIndex(numGroups))
    simpleRaid:SetAttribute('unitsPerColumn', unitsPerColumn)
    simpleRaid:SetAttribute('maxColumns', maxColumns)

    local moverWidth = (100 * scale * maxColumns + 5 * (maxColumns - 1))
    local moverHeight = 20 * scale * unitsPerColumn + 5 * (unitsPerColumn - 1)
    raidMover:SetSize(moverWidth, moverHeight)
end

function UNITFRAME:SpawnSimpleRaid()
    oUF:RegisterStyle('Raid', CreateSimpleRaidStyle)
    oUF:SetActiveStyle('Raid')

    local scale = C.DB['Unitframe']['SMRScale'] / 10
    local sortData = UNITFRAME.RaidDirections[C.DB['Unitframe']['SMRDirec']]

    local function CreateGroup(name)
        -- stylua: ignore start
        simpleRaid = oUF:SpawnHeader(name, nil, nil,
            'showPlayer', true,
            'showSolo', true,
            'showParty', true,
            'showRaid', true,
            'point', sortData.point,
            'xOffset', sortData.xOffset,
            'yOffset', sortData.yOffset,
            'columnSpacing', 5,
            'columnAnchorPoint', sortData.columnAnchorPoint,
            'oUF-initialConfigFunction',
            ([[
                self:SetWidth(%d)
                self:SetHeight(%d)
            ]]):format(100 * scale, 20 * scale)
        )
        -- stylua: ignore end

        return simpleRaid
    end

    local group = CreateGroup('oUF_Raid')
    group.groupType = 'raid'
    tinsert(UNITFRAME.headers, group)
    RegisterStateDriver(group, 'visibility', GetRaidVisibility())
    raidMover = F.Mover(group, L['RaidFrame'], 'RaidFrame', UNITFRAME.Positions.simple)
    group:ClearAllPoints()
    group:SetPoint(sortData.initAnchor, raidMover)

    UNITFRAME:UpdateSimpleModeHeader()
end

local function CreateRaidStyle(self)
    self.unitStyle = 'raid'

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateGroupNameTag(self)
    UNITFRAME:CreateGroupLeaderTag(self)
    UNITFRAME:CreateResurrectIndicator(self)
    UNITFRAME:CreateReadyCheckIndicator(self)
    UNITFRAME:CreateGroupRoleTag(self)
    UNITFRAME:CreatePhaseIndicator(self)
    UNITFRAME:CreateSummonIndicator(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateSelectedBorder(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateCornerIndicator(self)
    UNITFRAME:CreateRaidBuffs(self)
    UNITFRAME:CreateRaidDebuffs(self)
    UNITFRAME:CreateDebuffWatcher(self)
    UNITFRAME:RefreshAurasByCombat(self)
end

local teamIndexes = {}
local teamIndexAnchor = {
    [1] = { 'BOTTOM', 'TOP', 0, 5 },
    [2] = { 'BOTTOM', 'TOP', 0, 5 },
    [3] = { 'TOP', 'BOTTOM', 0, -5 },
    [4] = { 'TOP', 'BOTTOM', 0, -5 },
    [5] = { 'RIGHT', 'LEFT', -5, 0 },
    [6] = { 'RIGHT', 'LEFT', -5, 0 },
    [7] = { 'LEFT', 'RIGHT', 5, 0 },
    [8] = { 'LEFT', 'RIGHT', 5, 0 },
}

local function UpdateTeamIndex(teamIndex, showIndex, direc)
    if not showIndex then
        teamIndex:Hide()
    else
        teamIndex:Show()
        teamIndex:ClearAllPoints()
        local anchor = teamIndexAnchor[direc]
        teamIndex:SetPoint(anchor[1], teamIndex.__owner, anchor[2], anchor[3], anchor[4])
    end
end

local function CreateTeamIndex(header)
    local showIndex = C.DB.Unitframe.TeamIndex
    local direc = C.DB.Unitframe.RaidDirec
    local parent = _G[header:GetName() .. 'UnitButton1']
    if parent and not parent.teamIndex then
        local teamIndex = F.CreateFS(parent, C.Assets.Font.Bold, 11, nil, header.index, nil, true)
        teamIndex:SetTextColor(0.6, 0.8, 1)
        teamIndex.__owner = parent
        UpdateTeamIndex(teamIndex, showIndex, direc)
        teamIndexes[header.index] = teamIndex

        parent.teamIndex = teamIndex
    end
end

function UNITFRAME:UpdateRaidTeamIndex()
    local showIndex = C.DB.Unitframe.TeamIndex
    local direc = C.DB.Unitframe.RaidDirec
    for _, teamIndex in pairs(teamIndexes) do
        UpdateTeamIndex(teamIndex, showIndex, direc)
    end
end

local function CreateRaid(name, i, width, height)
    -- stylua: ignore start
    local group = oUF:SpawnHeader(name, nil, nil,
        'showPlayer', true,
        'showSolo', true,
        'showParty', true,
        'showRaid', true,
        'groupFilter', tostring(i),
        'groupingOrder', '1,2,3,4,5,6,7,8',
        'groupBy', 'GROUP',
        'sortMethod', 'INDEX',
        'maxColumns', 1,
        'unitsPerColumn', 5,
        'columnSpacing', 5,
        'columnAnchorPoint', 'LEFT',
        'oUF-initialConfigFunction',
        ([[
            self:SetWidth(%d)
            self:SetHeight(%d)
        ]]):format(width, height)
    )
    -- stylua: ignore end

    return group
end

local groups = {}
function UNITFRAME:CreateAndUpdateRaidHeader(direction)
    local index = C.DB.Unitframe.RaidDirec
    local rows = C.DB.Unitframe.RaidRows
    local numGroups = C.DB.Unitframe.NumGroups
    local raidWidth = C.DB.Unitframe.RaidWidth
    local raidHeight = C.DB.Unitframe.RaidHealthHeight + C.DB.Unitframe.RaidPowerHeight + C.MULT
    local indexSpacing = C.DB.Unitframe.TeamIndex and 20 or 0

    local sortData = UNITFRAME.RaidDirections[index]
    for i = 1, numGroups do
        local group = groups[i]
        if not group then
            group = CreateRaid('oUF_Raid' .. i, i, raidWidth, raidHeight)
            group.index = i
            group.groupType = 'raid'
            tinsert(UNITFRAME.headers, group)
            RegisterStateDriver(group, 'visibility', 'show')
            RegisterStateDriver(group, 'visibility', GetRaidVisibility())
            CreateTeamIndex(group)

            groups[i] = group
        end

        if not raidMover and i == 1 then
            raidMover = F.Mover(groups[i], L['RaidFrame'], 'RaidFrame', UNITFRAME.Positions.raid)
            UNITFRAME.RaidMover = raidMover
        end

        local groupWidth = index < 5 and raidWidth + 5 or (raidWidth + 5) * 5
        local groupHeight = index < 5 and (raidHeight + 5) * 5 or raidHeight + 5
        local numX = ceil(numGroups / rows)
        local numY = min(rows, numGroups)
        local indexSpacings = indexSpacing * (numY - 1)
        if index < 5 then
            raidMover:SetSize(groupWidth * numX - 5, groupHeight * numY - 5 + indexSpacings)
        else
            raidMover:SetSize(groupWidth * numY - 5 + indexSpacings, groupHeight * numX - 5)
        end

        if direction then
            ResetHeaderPoints(group)
            group:SetAttribute('point', sortData.point)
            group:SetAttribute('xOffset', sortData.xOffset)
            group:SetAttribute('yOffset', sortData.yOffset)
        end

        group:ClearAllPoints()
        if i == 1 then
            group:SetPoint(sortData.initAnchor, raidMover)
        elseif (i - 1) % rows == 0 then
            group:SetPoint(sortData.initAnchor, groups[i - rows], sortData.relAnchor, sortData.x, sortData.y)
        else
            local x = floor((i - 1) / rows)
            local y = (i - 1) % rows
            if index < 5 then
                group:SetPoint(
                    sortData.initAnchor,
                    raidMover,
                    sortData.initAnchor,
                    sortData.multX * groupWidth * x,
                    sortData.multY * (groupHeight + indexSpacing) * y
                )
            else
                group:SetPoint(
                    sortData.initAnchor,
                    raidMover,
                    sortData.initAnchor,
                    sortData.multX * (groupWidth + indexSpacing) * y,
                    sortData.multY * groupHeight * x
                )
            end
        end
    end

    for i = 1, 8 do
        local group = groups[i]
        if group then
            group.__disabled = i > numGroups
        end
    end
end

function UNITFRAME:SpawnRaid()
    oUF:RegisterStyle('Raid', CreateRaidStyle)
    oUF:SetActiveStyle('Raid')

    UNITFRAME:CreateAndUpdateRaidHeader(true)
    UNITFRAME:UpdateRaidTeamIndex()
end

-- save group position by spec

local function UpdatePosBySpec(event, ...)
    local unit, _, spellID = ...
    if (event == 'UNIT_SPELLCAST_SUCCEEDED' and unit == 'player' and spellID == 200749) or event == 'ON_LOGIN' then
        local specIndex = GetSpecialization()
        if not specIndex then
            return
        end

        if not C.DB['UIAnchor']['raid_position' .. specIndex] then
            C.DB['UIAnchor']['raid_position' .. specIndex] = { 'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -10 }
        end

        UNITFRAME.RaidMover:ClearAllPoints()
        UNITFRAME.RaidMover:SetPoint(unpack(C.DB['UIAnchor']['raid_position' .. specIndex]))

        if UNITFRAME.RaidMover then
            UNITFRAME.RaidMover:ClearAllPoints()
            UNITFRAME.RaidMover:SetPoint(unpack(C.DB['UIAnchor']['raid_position' .. specIndex]))
        end

        if not C.DB['UIAnchor']['party_position' .. specIndex] then
            C.DB['UIAnchor']['party_position' .. specIndex] = { 'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60 }
        end
        if UNITFRAME.PartyMover then
            UNITFRAME.PartyMover:ClearAllPoints()
            UNITFRAME.PartyMover:SetPoint(unpack(C.DB['UIAnchor']['party_position' .. specIndex]))
        end
    end
end

function UNITFRAME:SetGroupFramePos()
    if not C.DB.Unitframe.PositionBySpec then
        return
    end

    UpdatePosBySpec('ON_LOGIN')
    F:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', UpdatePosBySpec)

    if UNITFRAME.RaidMover then
        UNITFRAME.RaidMover:HookScript('OnDragStop', function()
            local specIndex = GetSpecialization()
            if not specIndex then
                return
            end
            C.DB['UIAnchor']['raid_position' .. specIndex] = C.DB['UIAnchor']['RaidFrame']
        end)
    end

    if UNITFRAME.PartyMover then
        UNITFRAME.PartyMover:HookScript('OnDragStop', function()
            local specIndex = GetSpecialization()
            if not specIndex then
                return
            end
            C.DB['UIAnchor']['party_position' .. specIndex] = C.DB['UIAnchor']['PartyFrame']
        end)
    end
end

-- set health update frequency

function UNITFRAME:UpdateRaidHealthMethod()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'raid' then
            frame:SetHealthUpdateMethod(C.DB.Unitframe.FrequentHealth)
            frame:SetHealthUpdateSpeed(C.DB.Unitframe.HealthFrequency)
            frame.Health:ForceUpdate()
        end
    end
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
    UNITFRAME:InitDebuffWatcher()

    UNITFRAME:CheckPartyAurasFilter()
    UNITFRAME:RefreshPartyAurasFilter()



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

    if C.DB.Unitframe.RaidFrame then
        UNITFRAME:RemoveBlizzRaidFrame()

        if C.DB.Unitframe.SimpleMode then
            UNITFRAME:SpawnSimpleRaid()
        else
            UNITFRAME:SpawnRaid()
        end

        if C.DB.Unitframe.PartyFrame then
            UNITFRAME:SpawnParty()
        end

        UNITFRAME:UpdateRaidHealthMethod()
        UNITFRAME:SetGroupFramePos()
    end
end
