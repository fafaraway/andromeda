local _G = _G
local unpack = unpack
local select = select
local rad = rad
local CreateFrame = CreateFrame
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local IsResting = IsResting
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

function UNITFRAME:UpdateGCDIndicator()
    local start, duration = GetSpellCooldown(61304)
    if start > 0 and duration > 0 then
        if self.duration ~= duration then
            self:SetMinMaxValues(0, duration)
            self.duration = duration
        end
        self:SetValue(GetTime() - start)
        self.spark:Show()
    else
        self.spark:Hide()
    end
end

function UNITFRAME:ToggleGCDIndicator()
    local frame = _G.oUF_Player
    local ticker = frame and frame.GCDIndicator
    if not ticker then
        return
    end

    ticker:SetShown(C.DB.Unitframe.GCDIndicator)
end

function UNITFRAME:CreateGCDIndicator(self)
    local ticker = CreateFrame('StatusBar', nil, self)
    ticker:SetFrameLevel(self.Health:GetFrameLevel() + 4)
    ticker:SetStatusBarTexture(C.Assets.norm_tex)
    ticker:GetStatusBarTexture():SetAlpha(0)
    ticker:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)
    ticker:SetWidth(self:GetWidth())
    ticker:SetHeight(6)

    local spark = ticker:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.spark_tex)
    spark:SetBlendMode('ADD')
    spark:SetPoint('TOPLEFT', ticker:GetStatusBarTexture(), 'TOPRIGHT', -3, 3)
    spark:SetPoint('BOTTOMRIGHT', ticker:GetStatusBarTexture(), 'BOTTOMRIGHT', 3, -3)

    ticker.spark = spark

    ticker:SetScript('OnUpdate', UNITFRAME.UpdateGCDIndicator)
    self.GCDIndicator = ticker

    UNITFRAME:ToggleGCDIndicator()
end

function UNITFRAME:AddPvPIndicator(self) -- Deprecated
    if not C.DB.Unitframe.player_pvp_indicator then
        return
    end

    local outline = _G.FREE_ADB.FontOutline
    local font = C.Assets.Fonts.Condensed

    local PvPIndicator = F.CreateFS(self, font, 11, outline, '', nil, outline or 'THICK')
    PvPIndicator:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 5, 0)

    PvPIndicator.SetTexture = F.Dummy
    PvPIndicator.SetTexCoord = F.Dummy

    self.PvPIndicator = PvPIndicator
end

local function CombatIndicatorPostUpdate(self, inCombat)
    local isResting = IsResting()
    if inCombat then
        self.__owner.RestingIndicator:Hide()
    elseif isResting then
        self.__owner.RestingIndicator:Show()
    end
end

function UNITFRAME:CreateCombatIndicator(self)
    if not C.DB.Unitframe.CombatIndicator then
        return
    end

    local combatIndicator = self:CreateTexture(nil, 'OVERLAY')
    combatIndicator:SetPoint('BOTTOMLEFT', self, 'TOPLEFT')
    combatIndicator:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT')
    combatIndicator:SetHeight(6)
    combatIndicator:SetTexture(C.Assets.glow_tex)
    combatIndicator:SetVertexColor(1, 0, 0, .25)

    self.CombatIndicator = combatIndicator
    self.CombatIndicator.PostUpdate = CombatIndicatorPostUpdate
end

function UNITFRAME:CreateRestingIndicator(self)
    if not C.DB.Unitframe.RestingIndicator then
        return
    end

    local restingIndicator = self:CreateTexture(nil, 'OVERLAY')
    restingIndicator:SetPoint('BOTTOMLEFT', self, 'TOPLEFT')
    restingIndicator:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT')
    restingIndicator:SetHeight(6)
    restingIndicator:SetTexture(C.Assets.glow_tex)
    restingIndicator:SetVertexColor(0, 1, 0, .25)

    self.RestingIndicator = restingIndicator
end

function UNITFRAME:CreateEmergencyIndicator(self)
    local emergencyIndicator = self:CreateTexture(nil, 'OVERLAY')
    emergencyIndicator:SetPoint('TOPLEFT', self, 'BOTTOMLEFT')
    emergencyIndicator:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT')
    emergencyIndicator:SetHeight(10)
    emergencyIndicator:SetTexture(C.Assets.glow_tex)
    emergencyIndicator:SetRotation(rad(180))
    emergencyIndicator:SetVertexColor(1, 0, 0, .45)
    emergencyIndicator:Hide()

    self.EmergencyIndicator = emergencyIndicator
end

function UNITFRAME:UpdateRaidTargetIndicator()
    local style = self.unitStyle
    local raidTarget = self.RaidTargetIndicator
    local nameOnlyName = self.nameOnlyName
    local title = self.npcTitle
    local isNameOnly = self.isNameOnly
    local size = C.DB.Unitframe.RaidTargetIndicatorSize
    local alpha = C.DB.Unitframe.RaidTargetIndicatorAlpha
    local npSize = C.DB.Nameplate.RaidTargetIndicatorSize
    local npAlpha = C.DB.Nameplate.RaidTargetIndicatorAlpha

    if style == 'nameplate' then
        if isNameOnly then
            raidTarget:SetParent(self)
            raidTarget:ClearAllPoints()
            raidTarget:SetPoint('TOP', title or nameOnlyName, 'BOTTOM')
        else
            raidTarget:SetParent(self.Health)
            raidTarget:ClearAllPoints()
            raidTarget:SetPoint('CENTER')
        end

        raidTarget:SetAlpha(npAlpha)
        raidTarget:SetSize(npSize, npSize)
    else
        raidTarget:SetPoint('CENTER')
        raidTarget:SetAlpha(alpha)
        raidTarget:SetSize(size, size)
    end
end

function UNITFRAME:CreateRaidTargetIndicator(self)
    local icon = self.Health:CreateTexture(nil, 'OVERLAY')
    icon:SetPoint('CENTER')
    icon:SetAlpha(1)
    icon:SetSize(24, 24)
    icon:SetTexture(C.Assets.target_icon)

    self.RaidTargetIndicator = icon

    UNITFRAME.UpdateRaidTargetIndicator(self)
end

function UNITFRAME:CreateReadyCheckIndicator(self)
    local readyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
    readyCheckIndicator:SetPoint('CENTER', self.Health)
    readyCheckIndicator:SetSize(16, 16)
    self.ReadyCheckIndicator = readyCheckIndicator
end

local function updateGroupRoleIndicator(self, event)
    local lfdrole = self.GroupRoleIndicator
    local role = UnitGroupRolesAssigned(self.unit)

    if role == 'DAMAGER' then
        lfdrole:SetTextColor(.8, .2, .1, 1)
        lfdrole:SetText('*')
    elseif role == 'TANK' then
        lfdrole:SetTextColor(.9, .8, .2, 1)
        lfdrole:SetText('#')
    elseif role == 'HEALER' then
        lfdrole:SetTextColor(0, 1, 0, 1)
        lfdrole:SetText('+')
    else
        lfdrole:SetTextColor(0, 0, 0, 0)
    end
end

function UNITFRAME:CreateGroupRoleIndicator(self)
    local font = C.Assets.Fonts.Pixel

    local groupRoleIndicator = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    groupRoleIndicator:SetPoint('BOTTOM', 1, 1)
    groupRoleIndicator.Override = updateGroupRoleIndicator
    self.GroupRoleIndicator = groupRoleIndicator
end

function UNITFRAME:CreateLeaderIndicator(self)
    local font = C.Assets.Fonts.Pixel

    local leaderIndicator = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME', '!')
    leaderIndicator:SetPoint('TOPLEFT', 2, -2)
    self.LeaderIndicator = leaderIndicator
end

function UNITFRAME:CreatePhaseIndicator(self)
    local phase = CreateFrame('Frame', nil, self)
    phase:SetSize(16, 16)
    phase:SetPoint('CENTER', self)
    phase:SetFrameLevel(5)
    phase:EnableMouse(true)
    local icon = phase:CreateTexture(nil, 'OVERLAY')
    icon:SetAllPoints()
    phase.Icon = icon
    self.PhaseIndicator = phase
end

function UNITFRAME:CreateSummonIndicator(self)
    local summonIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
    summonIndicator:SetSize(self:GetHeight() * .8, self:GetHeight() * .8)
    summonIndicator:SetPoint('CENTER')

    self.SummonIndicator = summonIndicator
end

function UNITFRAME:CreateResurrectIndicator(self)
    local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
    resurrectIndicator:SetSize(self:GetHeight() * .8, self:GetHeight() * .8)
    resurrectIndicator:SetPoint('CENTER')

    self.ResurrectIndicator = resurrectIndicator
end
