local _G = _G
local unpack = unpack
local select = select
local UnitExists = UnitExists
local UnitIsFriend = UnitIsFriend
local UnitIsEnemy = UnitIsEnemy
local PlaySound = PlaySound
local SOUNDKIT_IG_CREATURE_AGGRO_SELECT = SOUNDKIT.IG_CREATURE_AGGRO_SELECT
local SOUNDKIT_IG_CHARACTER_NPC_SELECT = SOUNDKIT.IG_CHARACTER_NPC_SELECT
local SOUNDKIT_IG_CREATURE_NEUTRAL_SELECT = SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT
local SOUNDKIT_INTERFACE_SOUND_LOST_TARGET_UNIT = SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT
local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES

local F, C, L = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local OUF = F.Libs.oUF

local unitsPos = {
    player = {'CENTER', _G.UIParent, 'CENTER', 0, -180},
    pet = {'RIGHT', 'oUF_Player', 'LEFT', -6, 0},
    target = {'LEFT', _G.UIParent, 'CENTER', 120, -140},
    tot = {'LEFT', 'oUF_Target', 'RIGHT', 6, 0},
    focus = {'BOTTOM', _G.UIParent, 'BOTTOM', -240, 220},
    tof = {'TOPLEFT', 'oUF_Focus', 'TOPRIGHT', 6, 0},
    boss = {'LEFT', 'oUF_Target', 'RIGHT', 120, 120},
    arena = {'RIGHT', 'oUF_Player', 'LEFT', -300, 300},
    party = {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60},
    raid = {'TOPRIGHT', 'Minimap', 'TOPLEFT', -6, -44},
}

local function Player_OnEnter(self)
    self.HealthValue:Show()
    self.PowerValue:Show()
end

local function Player_OnLeave(self)
    self.HealthValue:Hide()
    self.PowerValue:Hide()
end

local function CreatePlayerStyle(self)
    self.unitStyle = 'player'
    self:SetSize(C.DB.unitframe.player_width, C.DB.unitframe.player_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthPrediction(self)
    UNITFRAME:AddHealthValueText(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddPowerValueText(self)
    UNITFRAME:AddAlternativePowerBar(self)
    UNITFRAME:AddAlternativePowerValueText(self)
    UNITFRAME:AddPortrait(self)
    UNITFRAME:AddCastBar(self)
    UNITFRAME:AddCombatIndicator(self)
    UNITFRAME:AddRestingIndicator(self)
    UNITFRAME:AddEmergencyIndicator(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddGCDIndicator(self)
    UNITFRAME:AddCombatFader(self)
    UNITFRAME:AddClassPowerBar(self)
    UNITFRAME:AddStagger(self)
    UNITFRAME:AddTotems(self)
end

function UNITFRAME:SpawnPlayer()
    OUF:RegisterStyle('Player', CreatePlayerStyle)
    OUF:SetActiveStyle 'Player'

    local player = OUF:Spawn('player', 'oUF_Player')
    if C.DB.unitframe.player_hide_tags then
        player.HealthValue:Hide()
        player.PowerValue:Hide()
        player:HookScript('OnEnter', Player_OnEnter)
        player:HookScript('OnLeave', Player_OnLeave)
    end
    F.Mover(player, L['Player Frame'], 'PlayerFrame', unitsPos.player, player:GetWidth(), player:GetHeight())
end

local function CreatePetStyle(self)
    self.unitStyle = 'pet'
    self:SetSize(C.DB.unitframe.pet_width, C.DB.unitframe.pet_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthPrediction(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddPortrait(self)
    UNITFRAME:AddCastBar(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddRaidTargetIndicator(self)
end

function UNITFRAME:SpawnPet()
    OUF:RegisterStyle('Pet', CreatePetStyle)
    OUF:SetActiveStyle 'Pet'

    local pet = OUF:Spawn('pet', 'oUF_Pet')
    F.Mover(pet, L['Pet Frame'], 'PetFrame', unitsPos.pet, pet:GetWidth(), pet:GetHeight())
end

local function Target_OnEvent(self, event)
    if event == 'PLAYER_TARGET_CHANGED' then
        if UnitExists(self.unit) then
            if UnitIsEnemy(self.unit, 'player') then
                PlaySound(SOUNDKIT_IG_CREATURE_AGGRO_SELECT)
            elseif UnitIsFriend('player', self.unit) then
                PlaySound(SOUNDKIT_IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT_IG_CREATURE_NEUTRAL_SELECT)
            end
        else
            PlaySound(SOUNDKIT_INTERFACE_SOUND_LOST_TARGET_UNIT)
        end
    end
end

local function CreateTargetStyle(self)
    self.unitStyle = 'target'
    self:SetSize(C.DB.unitframe.target_width, C.DB.unitframe.target_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthPrediction(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddPortrait(self)
    UNITFRAME:AddNameText(self)
    UNITFRAME:AddHealthValueText(self)
    UNITFRAME:AddCastBar(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddRangeCheck(self)

    self:RegisterEvent('PLAYER_TARGET_CHANGED', Target_OnEvent)
    self.Health:SetScript('OnShow', function()
        Target_OnEvent(self, 'PLAYER_TARGET_CHANGED')
    end)
end

function UNITFRAME:SpawnTarget()
    OUF:RegisterStyle('Target', CreateTargetStyle)
    OUF:SetActiveStyle 'Target'

    local target = OUF:Spawn('target', 'oUF_Target')
    F.Mover(target, L['Target Frame'], 'TargetFrame', unitsPos.target, target:GetWidth(), target:GetHeight())
end

local function CreateTargetTargetStyle(self)
    self.unitStyle = 'targettarget'
    self:SetSize(C.DB.unitframe.target_target_width, C.DB.unitframe.target_target_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddNameText(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddRangeCheck(self)
end

function UNITFRAME:SpawnTargetTarget()
    OUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)
    OUF:SetActiveStyle 'TargetTarget'

    local targettarget = OUF:Spawn('targettarget', 'oUF_TargetTarget')
    F.Mover(targettarget, L['Target of Target Frame'], 'TargetTargetFrame', unitsPos.tot, targettarget:GetWidth(), targettarget:GetHeight())
end

local function Focus_OnEvent(self, event)
    if event == 'PLAYER_FOCUS_CHANGED' then
        if UnitExists(self.unit) then
            if UnitIsEnemy(self.unit, 'player') then
                PlaySound(SOUNDKIT_IG_CREATURE_AGGRO_SELECT)
            elseif UnitIsFriend('player', self.unit) then
                PlaySound(SOUNDKIT_IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT_IG_CREATURE_NEUTRAL_SELECT)
            end
        else
            PlaySound(SOUNDKIT_INTERFACE_SOUND_LOST_TARGET_UNIT)
        end
    end
end

local function CreateFocusStyle(self)
    self.unitStyle = 'focus'
    self:SetSize(C.DB.unitframe.focus_width, C.DB.unitframe.focus_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthPrediction(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddNameText(self)
    UNITFRAME:AddCastBar(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddRangeCheck(self)

    self:RegisterEvent('PLAYER_FOCUS_CHANGED', Focus_OnEvent)
    self.Health:SetScript('OnShow', function()
        Focus_OnEvent(self, 'PLAYER_FOCUS_CHANGED')
    end)
end

function UNITFRAME:SpawnFocus()
    OUF:RegisterStyle('Focus', CreateFocusStyle)
    OUF:SetActiveStyle 'Focus'

    local focus = OUF:Spawn('focus', 'oUF_Focus')
    F.Mover(focus, L['Focus Frame'], 'FocusFrame', unitsPos.focus, focus:GetWidth(), focus:GetHeight())
end

local function CreateFocusTargetStyle(self)
    self.unitStyle = 'focustarget'
    self:SetSize(C.DB.unitframe.focus_target_width, C.DB.unitframe.focus_target_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddNameText(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddRangeCheck(self)
end

function UNITFRAME:SpawnFocusTarget()
    OUF:RegisterStyle('FocusTarget', CreateFocusTargetStyle)
    OUF:SetActiveStyle 'FocusTarget'

    local focustarget = OUF:Spawn('focustarget', 'oUF_FocusTarget')
    F.Mover(focustarget, L['Target of Focus Frame'], 'FocusTargetFrame', unitsPos.tof, focustarget:GetWidth(), focustarget:GetHeight())
end

local function CreateBossStyle(self)
    self.unitStyle = 'boss'
    self:SetSize(C.DB.unitframe.boss_width, C.DB.unitframe.boss_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthValueText(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddAlternativePowerBar(self)
    UNITFRAME:AddAlternativePowerValueText(self)
    UNITFRAME:AddPortrait(self)
    UNITFRAME:AddNameText(self)
    UNITFRAME:AddCastBar(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddRangeCheck(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddSelectedBorder(self)
end

function UNITFRAME:SpawnBoss()
    OUF:RegisterStyle('Boss', CreateBossStyle)
    OUF:SetActiveStyle 'Boss'

    local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
        boss[i] = OUF:Spawn('boss' .. i, 'oUF_Boss' .. i)
        if i == 1 then
            boss[i].mover = F.Mover(boss[i], L['Boss Frame'], 'BossFrame', unitsPos.boss, C.DB.unitframe.boss_width, C.DB.unitframe.boss_height)
        else
            boss[i]:SetPoint('BOTTOM', boss[i - 1], 'TOP', 0, C.DB.unitframe.boss_gap)
        end
    end
end

local function CreateArenaStyle(self)
    self.unitStyle = 'arena'
    self:SetSize(C.DB.unitframe.arena_width, C.DB.unitframe.arena_height)

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddNameText(self)
    UNITFRAME:AddHealthValueText(self)
    UNITFRAME:AddCastBar(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddRangeCheck(self)
    UNITFRAME:AddSelectedBorder(self)
end

function UNITFRAME:SpawnArena()
    OUF:RegisterStyle('Arena', CreateArenaStyle)
    OUF:SetActiveStyle 'Arena'

    local arena = {}
    for i = 1, 5 do
        arena[i] = OUF:Spawn('arena' .. i, 'oUF_Arena' .. i)
        if i == 1 then
            arena[i].mover = F.Mover(arena[i], L['Arena Frame'], 'ArenaFrame', unitsPos.arena, C.DB.unitframe.arena_width, C.DB.unitframe.arena_height)
        else
            arena[i]:SetPoint('BOTTOM', arena[i - 1], 'TOP', 0, C.DB.unitframe.arena_gap)
        end
    end
end

local function CreatePartyStyle(self)
    self.unitStyle = 'party'

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthPrediction(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddPortrait(self)
    UNITFRAME:AddGroupNameText(self)
    UNITFRAME:AddLeaderIndicator(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddResurrectIndicator(self)
    UNITFRAME:AddReadyCheckIndicator(self)
    UNITFRAME:AddGroupRoleIndicator(self)
    UNITFRAME:AddPhaseIndicator(self)
    UNITFRAME:AddSummonIndicator(self)
    UNITFRAME:AddThreatIndicator(self)
    UNITFRAME:AddSelectedBorder(self)
    UNITFRAME:AddRangeCheck(self)
    UNITFRAME:AddAuras(self)
    UNITFRAME:AddCornerIndicator(self)
    UNITFRAME:AddRaidDebuffs(self)
    UNITFRAME:AddDebuffHighlight(self)
    UNITFRAME:AddPartySpells(self)
end

function UNITFRAME:SpawnParty()
    UNITFRAME:SyncWithZenTracker()
    UNITFRAME:UpdatePartyWatcherSpells()
    UNITFRAME:UpdateCornerSpells()

    OUF:RegisterStyle('Party', CreatePartyStyle)
    OUF:SetActiveStyle 'Party'

    local partyWidth, partyHeight = C.DB.unitframe.party_width, C.DB.unitframe.party_height
    local partyHorizon = C.DB.unitframe.party_horizon
    local partyReverse = C.DB.unitframe.party_reverse
    local partyGap = C.DB.unitframe.party_gap
    local showSolo = C.DB.unitframe.show_solo
    local groupingOrder = partyHorizon and 'TANK,HEALER,DAMAGER,NONE' or 'TANK,HEALER,DAMAGER,NONE'
    local moverWidth = partyHorizon and partyWidth * 5 + partyGap * 4 or partyWidth
    local moverHeight = partyHorizon and partyHeight or partyHeight * 5 + partyGap * 4
    local partyMover
    local party = OUF:SpawnHeader('oUF_Party', nil, 'solo,party', 'showPlayer', true, 'showSolo', showSolo, 'showParty', true, 'showRaid', false, 'xoffset',
                                  partyGap, 'yoffset', partyGap, 'point', partyHorizon and 'LEFT' or 'BOTTOM', 'groupingOrder', groupingOrder, 'groupBy',
                                  'ASSIGNEDROLE', 'sortMethod', 'NAME', 'oUF-initialConfigFunction', ([[

            self:SetWidth(%d)
            self:SetHeight(%d)
            ]]):format(partyWidth, partyHeight))
    partyMover = F.Mover(party, L['Party Frame'], 'PartyFrame', unitsPos.party, moverWidth, moverHeight)
    party:ClearAllPoints()
    party:SetPoint('BOTTOMLEFT', partyMover)
    UNITFRAME.PartyMover = partyMover
end

local function CreateRaidStyle(self)
    self.unitStyle = 'raid'

    UNITFRAME:AddBackDrop(self)
    UNITFRAME:AddHealthBar(self)
    UNITFRAME:AddHealthPrediction(self)
    UNITFRAME:AddPowerBar(self)
    UNITFRAME:AddGroupNameText(self)
    UNITFRAME:AddLeaderIndicator(self)
    UNITFRAME:AddRaidTargetIndicator(self)
    UNITFRAME:AddResurrectIndicator(self)
    UNITFRAME:AddReadyCheckIndicator(self)
    UNITFRAME:AddGroupRoleIndicator(self)
    UNITFRAME:AddPhaseIndicator(self)
    UNITFRAME:AddSummonIndicator(self)
    UNITFRAME:AddSelectedBorder(self)
    UNITFRAME:AddRangeCheck(self)
    UNITFRAME:AddCornerIndicator(self)
    UNITFRAME:AddRaidDebuffs(self)
    UNITFRAME:AddDebuffHighlight(self)
end

function UNITFRAME:SpawnRaid()
    UNITFRAME:UpdateCornerSpells()

    OUF:RegisterStyle('Raid', CreateRaidStyle)
    OUF:SetActiveStyle 'Raid'

    local raidWidth = C.DB.unitframe.raid_width
    local raidHeight = C.DB.unitframe.raid_height
    local raidHorizon = C.DB.unitframe.raid_horizon
    local raidReverse = C.DB.unitframe.raid_reverse
    local raidGap = C.DB.unitframe.raid_gap
    local showSolo = C.DB.unitframe.show_solo
    local numGroups = C.DB.unitframe.group_filter
    local raidMover

    local function CreateRaid(name, i)
        local raid = OUF:SpawnHeader(name, nil, 'solo,raid', 'showPlayer', true, 'showSolo', showSolo, 'showParty', true, 'showRaid', true, 'xoffset', raidGap,
                                     'yOffset', -raidGap, 'groupFilter', tostring(i), 'groupingOrder', '1,2,3,4,5,6,7,8', 'groupBy', 'GROUP', 'sortMethod',
                                     'INDEX', 'maxColumns', 1, 'unitsPerColumn', 5, 'columnSpacing', raidGap, 'point', raidHorizon and 'LEFT' or 'TOP',
                                     'columnAnchorPoint', 'LEFT', 'oUF-initialConfigFunction', ([[

            self:SetWidth(%d)
            self:SetHeight(%d)
            ]]):format(raidWidth, raidHeight))
        return raid
    end

    local groups = {}
    for i = 1, numGroups do
        groups[i] = CreateRaid('oUF_Raid' .. i, i)
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
