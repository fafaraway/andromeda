local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

--[[ CVars ]]
function NAMEPLATE:PlateInsideView()
    if C.DB.Nameplate.InsideView then
        SetCVar('nameplateOtherTopInset', 0.05)
        SetCVar('nameplateOtherBottomInset', 0.08)
    elseif GetCVar('nameplateOtherTopInset') == '0.05' and GetCVar('nameplateOtherBottomInset') == '0.08' then
        SetCVar('nameplateOtherTopInset', -1)
        SetCVar('nameplateOtherBottomInset', -1)
    end
end

function NAMEPLATE:UpdatePlateScale()
    SetCVar('namePlateMinScale', C.DB.Nameplate.MinScale)
    SetCVar('namePlateMaxScale', C.DB.Nameplate.MinScale)
end

function NAMEPLATE:UpdatePlateTargetScale()
    SetCVar('nameplateLargerScale', C.DB.Nameplate.TargetScale)
    SetCVar('nameplateSelectedScale', C.DB.Nameplate.TargetScale)
end

function NAMEPLATE:UpdatePlateAlpha()
    SetCVar('nameplateMinAlpha', C.DB.Nameplate.MinAlpha)
    SetCVar('nameplateMaxAlpha', C.DB.Nameplate.MinAlpha)
    SetCVar('nameplateSelectedAlpha', 1)
end

function NAMEPLATE:UpdatePlateOccludedAlpha()
    SetCVar('nameplateOccludedAlphaMult', C.DB.Nameplate.OccludedAlpha)
end

function NAMEPLATE:UpdatePlateVerticalSpacing()
    SetCVar('nameplateOverlapV', C.DB.Nameplate.VerticalSpacing)
end

function NAMEPLATE:UpdatePlateHorizontalSpacing()
    SetCVar('nameplateOverlapH', C.DB.Nameplate.HorizontalSpacing)
end

function NAMEPLATE:UpdatePlateClickThrough()
    if InCombatLockdown() then
        return
    end

    C_NamePlate.SetNamePlateEnemyClickThrough(C.DB.Nameplate.EnemyClickThrough)
    C_NamePlate.SetNamePlateFriendlyClickThrough(C.DB.Nameplate.FriendlyClickThrough)
end

function NAMEPLATE:UpdateNameOnlyMode()
    SetCVar('nameplateShowFriends', 1)
    SetCVar('nameplateShowFriendlyNPCs', 1)
    SetCVar('nameplateShowFriendlyPets', 1)
    SetCVar('nameplateShowFriendlyMinions', 1)
    SetCVar('nameplateShowFriendlyGuardians', 1)
    SetCVar('nameplateShowOnlyNames', C.DB.Nameplate.NameOnlyMode)
    SetCVar('nameplateShowDebuffsOnFriendly', not C.DB.Nameplate.NameOnlyMode)
end

function NAMEPLATE:UpdateNameplateCVars()
    if not C.DB.Nameplate.ForceCVars then
        return
    end

    NAMEPLATE:PlateInsideView()

    NAMEPLATE:UpdatePlateVerticalSpacing()
    NAMEPLATE:UpdatePlateHorizontalSpacing()

    NAMEPLATE:UpdatePlateAlpha()
    NAMEPLATE:UpdatePlateOccludedAlpha()

    NAMEPLATE:UpdatePlateScale()
    NAMEPLATE:UpdatePlateTargetScale()

    NAMEPLATE:UpdateClickableSize()
    hooksecurefunc(_G.NamePlateDriverFrame, 'UpdateNamePlateOptions', NAMEPLATE.UpdateClickableSize)
    NAMEPLATE:UpdatePlateClickThrough()

    NAMEPLATE:UpdateNameOnlyMode()

    if C.IS_DEVELOPER then
        SetCVar('nameplateShowSelf', 0)
        SetCVar('NameplatePersonalShowAlways', 0)
        SetCVar('nameplateSelfAlpha', 0)
        SetCVar('nameplateResourceOnTarget', 0)
    end
end

--[[ AddOn ]]
function NAMEPLATE:BlockAddons()
    if not _G.DBM or not _G.DBM.Nameplate then
        return
    end

    function _G.DBM.Nameplate:SupportedNPMod()
        return true
    end

    local function showAurasForDBM(_, _, _, spellID)
        if not tonumber(spellID) then
            return
        end
        if not C.NameplateAuraWhiteList[spellID] then
            C.NameplateAuraWhiteList[spellID] = true
        end
    end
    hooksecurefunc(_G.DBM.Nameplate, 'Show', showAurasForDBM)
end

--[[ Elements ]]

NAMEPLATE.SpecialUnitsList = {}
NAMEPLATE.PowerUnitsList = {}

local function CheckUnitsList(value)
    for npcID in pairs(C[value]) do
        if C.DB['Nameplate'][value][npcID] then
            C.DB['Nameplate'][value][npcID] = nil
        end
    end

    for npcID, val in pairs(C.DB['Nameplate'][value]) do
        if val == false and C[value][npcID] == nil then
            C.DB['Nameplate'][value][npcID] = nil
        end
    end
end

function NAMEPLATE:CheckUnitsList()
    CheckUnitsList('SpecialUnitsList')
    CheckUnitsList('PowerUnitsList')
end

local function RefreshNameplateUnits(list, enable)
    wipe(NAMEPLATE[list])

    if not C.DB['Nameplate'][enable] then
        return
    end

    for npcID in pairs(C[list]) do
        if C.DB['Nameplate'][list][npcID] == nil then
            NAMEPLATE[list][npcID] = true
        end
    end

    for npcID, value in pairs(C.DB['Nameplate'][list]) do
        if value then
            NAMEPLATE[list][npcID] = true
        end
    end
end

function NAMEPLATE:RefreshSpecialUnitsList()
    RefreshNameplateUnits('SpecialUnitsList', 'ShowSpecialUnits')
end

function NAMEPLATE:RefreshPowerUnitsList()
    RefreshNameplateUnits('PowerUnitsList', 'ShowPowerUnits')
end

function NAMEPLATE:UpdateUnitPower()
    local unitName = self.unitName
    local npcID = self.npcID
    local shouldShowPower = NAMEPLATE.PowerUnitsList[unitName] or NAMEPLATE.PowerUnitsList[npcID]

    self.powerText:SetShown(shouldShowPower)
end

-- Off-tank threat color
local groupRoles, isInGroup = {}
local function refreshGroupRoles()
    local isInRaid = IsInRaid()
    isInGroup = isInRaid or IsInGroup()
    wipe(groupRoles)

    if isInGroup then
        local numPlayers = (isInRaid and GetNumGroupMembers()) or GetNumSubgroupMembers()
        local unit = (isInRaid and 'raid') or 'party'
        for i = 1, numPlayers do
            local index = unit .. i
            if UnitExists(index) then
                groupRoles[UnitName(index)] = UnitGroupRolesAssigned(index)
            end
        end
    end
end

local function resetGroupRoles()
    isInGroup = IsInRaid() or IsInGroup()
    wipe(groupRoles)
end

function NAMEPLATE:UpdateGroupRoles()
    refreshGroupRoles()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', refreshGroupRoles)
    F:RegisterEvent('GROUP_LEFT', resetGroupRoles)
end

function NAMEPLATE:CheckThreatStatus(unit)
    if not UnitExists(unit) then
        return
    end

    local unitTarget = unit .. 'target'
    local unitRole = isInGroup
            and UnitExists(unitTarget)
            and not UnitIsUnit(unitTarget, 'player')
            and groupRoles[UnitName(unitTarget)]
        or 'NONE'

    if C.MyRole == 'Tank' and unitRole == 'TANK' then
        return true, UnitThreatSituation(unitTarget, unit)
    else
        return false, UnitThreatSituation('player', unit)
    end
end

-- Update unit color
function NAMEPLATE:UpdateColor(_, unit)
    if not unit or self.unit ~= unit then
        return
    end

    local element = self.Health
    local name = self.unitName
    local npcID = self.npcID
    local isSpecialUnit = NAMEPLATE.SpecialUnitsList[name] or NAMEPLATE.SpecialUnitsList[npcID]
    local isPlayer = self.isPlayer
    local isFriendly = self.isFriendly
    local isOffTank, status = NAMEPLATE:CheckThreatStatus(unit)
    local showSpecialUnit = C.DB.Nameplate.ShowSpecialUnits
    local specialColor = C.DB.Nameplate.SpecialUnitColor
    local secureColor = C.DB.Nameplate.SecureColor
    local transColor = C.DB.Nameplate.TransColor
    local insecureColor = C.DB.Nameplate.InsecureColor
    local revertThreat = C.DB.Nameplate.RevertThreat
    local offTankColor = C.DB.Nameplate.OffTankColor
    local targetColor = C.DB.Nameplate.TargetColor
    local coloredTarget = C.DB.Nameplate.ColoredTarget
    local focusColor = C.DB.Nameplate.FocusColor
    local coloredFocus = C.DB.Nameplate.ColoredFocus
    local hostileClassColor = C.DB.Nameplate.HostileClassColor
    local friendlyClassColor = C.DB.Nameplate.FriendlyClassColor
    local tankMode = C.DB.Nameplate.TankMode
    local debuffColor = C.DB.Nameplate.DotColor
    local r, g, b

    if not UnitIsConnected(unit) then
        r, g, b = unpack(oUF.colors.disconnected)
    else
        if coloredTarget and UnitIsUnit(unit, 'target') then
            r, g, b = targetColor.r, targetColor.g, targetColor.b
        elseif coloredFocus and UnitIsUnit(unit, 'focus') then
            r, g, b = focusColor.r, focusColor.g, focusColor.b
        elseif showSpecialUnit and isSpecialUnit then
            r, g, b = specialColor.r, specialColor.g, specialColor.b
        elseif self.Auras.hasCustomDebuff then
            r, g, b = debuffColor.r, debuffColor.g, debuffColor.b
        elseif isPlayer and isFriendly then
            if friendlyClassColor then
                r, g, b = F:UnitColor(unit)
            else
                r, g, b = 0.3, 0.3, 1
            end
        elseif isPlayer and not isFriendly and hostileClassColor then
            r, g, b = F:UnitColor(unit)
        elseif UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) or C.TrashUnitsList[npcID] then
            r, g, b = unpack(oUF.colors.tapped)
        else
            r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, 'player') or 5])
            if status and (tankMode or C.MyRole == 'Tank') then
                if status == 3 then
                    if C.MyRole ~= 'Tank' and revertThreat then
                        r, g, b = insecureColor.r, insecureColor.g, insecureColor.b
                    else
                        if isOffTank then
                            r, g, b = offTankColor.r, offTankColor.g, offTankColor.b
                        else
                            r, g, b = secureColor.r, secureColor.g, secureColor.b
                        end
                    end
                elseif status == 2 or status == 1 then
                    r, g, b = transColor.r, transColor.g, transColor.b
                elseif status == 0 then
                    if C.MyRole ~= 'Tank' and revertThreat then
                        r, g, b = secureColor.r, secureColor.g, secureColor.b
                    else
                        r, g, b = insecureColor.r, insecureColor.g, insecureColor.b
                    end
                end
            end
        end
    end

    if r or g or b then
        element:SetStatusBarColor(r, g, b)
        NAMEPLATE:UpdateSelectedIndicatorColor(self, r, g, b)
    end

    NAMEPLATE:UpdateOverlayVisibility(self, unit)
    NAMEPLATE:UpdateExecuteIndicator(self, unit)

    self.ThreatIndicator:Hide()
    if status and (isSpecialUnit or (not tankMode and C.MyRole ~= 'Tank')) then
        if status == 3 then
            self.ThreatIndicator:SetVertexColor(1, 0, 0)
            self.ThreatIndicator:Show()
        elseif status == 2 or status == 1 then
            self.ThreatIndicator:SetVertexColor(1, 1, 0)
            self.ThreatIndicator:Show()
        end
    end
end

function NAMEPLATE:UpdateExecuteIndicator(self, unit)
    local executeIndicator = C.DB.Nameplate.ExecuteIndicator
    local executeRatio = C.DB.Nameplate.ExecuteRatio
    local healthPerc = UnitHealth(unit) / (UnitHealthMax(unit) + 0.0001) * 100

    if executeIndicator and executeRatio > 0 and healthPerc <= executeRatio then
        self.NameTag:SetTextColor(1, 0, 0)
    else
        self.NameTag:SetTextColor(1, 1, 1)
    end
end

function NAMEPLATE:UpdateThreatColor(_, unit)
    if unit ~= self.unit then
        return
    end

    NAMEPLATE.UpdateColor(self, _, unit)
end

function NAMEPLATE:CreateThreatIndicator(self)
    if not C.DB.Nameplate.ThreatIndicator then
        return
    end

    local frame = CreateFrame('Frame', nil, self)
    frame:SetAllPoints()
    frame:SetFrameLevel(self:GetFrameLevel() - 1)

    local threat = frame:CreateTexture(nil, 'BACKGROUND')
    threat:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT')
    threat:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT')
    threat:SetHeight(6)
    threat:SetTexture(C.Assets.Texture.Glow)
    threat:Hide()

    self.ThreatIndicator = threat
    self.ThreatIndicator.Override = NAMEPLATE.UpdateThreatColor
end

function NAMEPLATE:UpdateFocusColor()
    local unit = self.unit
    if C.DB.Nameplate.ColoredFocus then
        NAMEPLATE.UpdateThreatColor(self, _, unit)
    end
end

-- Scale plates for explosives
local hasExplosives
local explosiveID = 120651
function NAMEPLATE:UpdateExplosives(event, unit)
    if not hasExplosives or unit ~= self.unit then
        return
    end

    local scale = _G.UIParent:GetScale()
    local npcID = self.npcID
    if event == 'NAME_PLATE_UNIT_ADDED' and npcID == explosiveID then
        self:SetScale(scale * 2)
    elseif event == 'NAME_PLATE_UNIT_REMOVED' then
        self:SetScale(scale)
    end
end

local function CheckAffixes()
    local _, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    if affixes[3] and affixes[3] == 13 then
        hasExplosives = true
    else
        hasExplosives = false
    end
end

function NAMEPLATE:CheckExplosives()
    if not C.DB.Nameplate.ExplosiveIndicator then
        return
    end

    CheckAffixes()
    F:RegisterEvent('ZONE_CHANGED_NEW_AREA', CheckAffixes)
    F:RegisterEvent('CHALLENGE_MODE_START', CheckAffixes)
end

-- Major spells glow
NAMEPLATE.MajorSpellsList = {}
function NAMEPLATE:RefreshMajorSpellsFilter()
    wipe(NAMEPLATE.MajorSpellsList)

    for spellID in pairs(C.MajorSpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modValue = _G.ANDROMEDA_ADB['MajorSpellsList'][spellID]
            if modValue == nil then
                NAMEPLATE.MajorSpellsList[spellID] = true
            end
        end
    end

    for spellID, value in pairs(_G.ANDROMEDA_ADB['MajorSpellsList']) do
        if value then
            NAMEPLATE.MajorSpellsList[spellID] = true
        end
    end
end

function NAMEPLATE:CheckMajorSpellsFilter()
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

-- Spiteful indicator
function NAMEPLATE:CreateSpitefulIndicator(self)
    local font = C.Assets.Font.Condensed
    local outline = _G.ANDROMEDA_ADB.FontOutline

    local tarName = F.CreateFS(self, font, 12, outline, nil, nil, outline or 'THICK')
    tarName:ClearAllPoints()
    tarName:SetPoint('TOP', self, 'BOTTOM', 0, -10)
    tarName:Hide()

    self:Tag(tarName, '[andromeda:tarname]')
    self.tarName = tarName
end

function NAMEPLATE:UpdateSpitefulIndicator()
    if not C.DB.Nameplate.SpitefulIndicator then
        return
    end

    self.tarName:SetShown(C.NameplateShowTargetNPCsList[self.npcID])
end

-- Overlay
function NAMEPLATE:UpdateOverlayVisibility(self, unit)
    local name = self.unitName
    local npcID = self.npcID
    local isCustomUnit = NAMEPLATE.SpecialUnitsList[name] or NAMEPLATE.SpecialUnitsList[npcID]
    if isCustomUnit or UnitIsUnit(unit, 'focus') then
        self.Overlay:Show()
    else
        self.Overlay:Hide()
    end
end

function NAMEPLATE:CreateOverlayTexture(self)
    local overlay = self.Health:CreateTexture(nil, 'OVERLAY')
    overlay:SetAllPoints()
    overlay:SetTexture(C.Assets.Texture.StatusbarStripesThick)
    overlay:SetVertexColor(0, 0, 0, 0.4)
    overlay:Hide()

    self.Overlay = overlay
end

-- Health
function NAMEPLATE:CreateHealthBar(self)
    local health = CreateFrame('StatusBar', nil, self)
    health:SetAllPoints()
    health:SetStatusBarTexture(NAMEPLATE.StatusBarTex)
    health.backdrop = F.SetBD(health)
    health.backdrop:SetBackdropColor(0, 0, 0, 0.6)
    health.backdrop:SetBackdropBorderColor(0, 0, 0, 1)

    health.Smooth = C.DB.Unitframe.Smooth

    self.Health = health
    self.Health.UpdateColor = NAMEPLATE.UpdateColor
end

--[[ Create plate ]]
local platesList = {}
function NAMEPLATE:CreateNameplateStyle()
    self.unitStyle = 'nameplate'

    self:SetSize(C.DB.Nameplate.Width, C.DB.Nameplate.Height)
    self:SetPoint('CENTER')
    self:SetScale(_G.UIParent:GetScale())

    NAMEPLATE:CreateHealthBar(self)
    NAMEPLATE:CreateNameTag(self)
    NAMEPLATE:CreateHealthTag(self)
    UNITFRAME:CreateHealPrediction(self)
    NAMEPLATE:CreateOverlayTexture(self)
    NAMEPLATE:CreateSelectedIndicator(self)
    NAMEPLATE:CreateMouseoverIndicator(self)
    NAMEPLATE:CreateThreatIndicator(self)
    NAMEPLATE:CreateQuestIndicator(self)
    NAMEPLATE:CreateCastBar(self)
    NAMEPLATE:CreateRaidTargetIndicator(self)
    NAMEPLATE:CreateAuras(self)
    NAMEPLATE:CreateSpitefulIndicator(self)

    self:RegisterEvent('PLAYER_FOCUS_CHANGED', NAMEPLATE.UpdateFocusColor, true)

    platesList[self] = self:GetName()
end

function NAMEPLATE:UpdateClickableSize()
    if InCombatLockdown() then
        return
    end

    local scale = _G.ANDROMEDA_ADB.UIScale
    local harmWidth, harmHeight = C.DB.Nameplate.ClickableWidth, C.DB.Nameplate.ClickableHeight
    local helpWidth, helpHeight = C.DB.Nameplate.FriendlyClickableWidth, C.DB.Nameplate.FriendlyClickableHeight

    C_NamePlate.SetNamePlateEnemySize(harmWidth * scale, harmHeight * scale)
    C_NamePlate.SetNamePlateFriendlySize(helpWidth * scale, helpHeight * scale)
end

function NAMEPLATE:ToggleNameplateAuras()
    if C.DB.Nameplate.ShowAura then
        if not self:IsElementEnabled('Auras') then
            self:EnableElement('Auras')
        end
    else
        if self:IsElementEnabled('Auras') then
            self:DisableElement('Auras')
        end
    end
end

local function GetIconSize(width, num, size)
    return (width - (num - 1) * size) / num
end

function NAMEPLATE:UpdateAuraContainer(parent, element, maxAuras)
    local width = parent:GetWidth()
    local iconsPerRow = element.iconsPerRow
    local maxLines = iconsPerRow and F:Round(maxAuras / iconsPerRow) or 2

    element.size = iconsPerRow and GetIconSize(width, iconsPerRow, element.spacing) or element.size
    element:SetWidth(width)
    element:SetHeight((element.size + element.spacing) * maxLines)
end

function NAMEPLATE:ConfigureAuras(element)
    element.iconsPerRow = C.DB['Nameplate']['AuraPerRow']

    element.numTotal = C.DB.Nameplate.AuraNumTotal
    element.showDebuffType = C.DB.Nameplate.DebuffTypeColor
    element.showStealableBuffs = C.DB.Nameplate.DispellMode == 1
    element.alwaysShowStealable = C.DB.Nameplate.DispellMode == 2
    element.desaturateDebuff = C.DB.Nameplate.DesaturateIcon
    element.disableMouse = C.DB.Nameplate.DisableMouse
end

function NAMEPLATE:RefreshAuras(frame)
    if not (frame and frame.Auras) then
        return
    end
    local element = frame.Auras

    NAMEPLATE:ConfigureAuras(element)
    NAMEPLATE:UpdateAuraContainer(frame, element, element.numTotal)

    if element.iconsPerRow > 0 then
        if not frame:IsElementEnabled('Auras') then
            frame:EnableElement('Auras')
        end
    else
        if frame:IsElementEnabled('Auras') then
            frame:DisableElement('Auras')
        end
    end

    element:ForceUpdate()
end

function NAMEPLATE:UpdateNameplateAuras()
    NAMEPLATE.ToggleNameplateAuras(self)

    if not C.DB.Nameplate.ShowAura then
        return
    end

    local element = self.Auras
    element:SetPoint('BOTTOM', self, 'TOP', 0, 16)

    element:SetWidth(self:GetWidth())
    element:SetHeight((element.size + element.spacing) * 2)
    element:ForceUpdate()

    NAMEPLATE:RefreshAuras(self)
end

function NAMEPLATE:UpdateNameplateSize()
    local isFriendly = C.DB.Nameplate.FriendlyPlate and not C.DB.Nameplate.NameOnlyMode and self.isFriendly
    local width = isFriendly and C.DB.Nameplate.FriendlyWidth or C.DB.Nameplate.Width
    local height = isFriendly and C.DB.Nameplate.FriendlyHeight or C.DB.Nameplate.Height

    self:SetSize(width, height)
end

function NAMEPLATE:RefreshNameplats()
    for nameplate in pairs(platesList) do
        NAMEPLATE.UpdateNameplateSize(nameplate)
        NAMEPLATE.UpdateNameplateAuras(nameplate)
        NAMEPLATE.UpdateSelectedIndicatorVisibility(nameplate)
        NAMEPLATE.UpdateSelectedChange(nameplate)
    end
    NAMEPLATE:UpdateClickableSize()
end

function NAMEPLATE:RefreshAllPlates()
    NAMEPLATE:RefreshNameplats()
end

local disabledElements = {
    'Health',
    'Castbar',
    'HealPredictionAndAbsorb',
    'PvPClassificationIndicator',
    'ThreatIndicator',
}

function NAMEPLATE:UpdatePlateByType()
    local questIcon = self.questIcon
    if questIcon then
        questIcon:SetShown(not self.plateType == 'NameOnly')
    end

    if self.plateType == 'NameOnly' then
        for _, element in pairs(disabledElements) do
            if self:IsElementEnabled(element) then
                self:DisableElement(element)
            end
        end

        if self.widgetContainer then
            self.widgetContainer:ClearAllPoints()
            self.widgetContainer:SetPoint('TOP', self.NameTag, 'BOTTOM', 0, -5)
        end
    else
        for _, element in pairs(disabledElements) do
            if not self:IsElementEnabled(element) then
                self:EnableElement(element)
            end
        end

        if self.widgetContainer then
            self.widgetContainer:ClearAllPoints()
            self.widgetContainer:SetPoint('TOP', self.Castbar, 'BOTTOM', 0, -5)
        end

        NAMEPLATE.UpdateNameplateSize(self)
    end

    NAMEPLATE.ConfigureNameTag(self)
    NAMEPLATE.ConfigureRaidTargetIndicator(self)
    NAMEPLATE.UpdateSelectedIndicatorVisibility(self)
    NAMEPLATE.ToggleNameplateAuras(self)
end

function NAMEPLATE:RefreshPlateType(unit)
    self.reaction = UnitReaction(unit, 'player')
    self.isFriendly = self.reaction and self.reaction >= 4 and not UnitCanAttack('player', unit)

    if C.DB.Nameplate.NameOnlyMode and self.isFriendly or self.widgetsOnly then
        self.plateType = 'NameOnly'
    elseif C.DB.Nameplate.FriendlyPlate and self.isFriendly then
        self.plateType = 'FriendlyPlate'
    else
        self.plateType = 'None'
    end

    if self.previousType == nil or self.previousType ~= self.plateType then
        NAMEPLATE.UpdatePlateByType(self)
        self.previousType = self.plateType
    end
end

function NAMEPLATE:OnUnitFactionChanged(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure())
    local unitFrame = nameplate and nameplate.unitFrame
    if unitFrame and unitFrame.unitName then
        NAMEPLATE.RefreshPlateType(unitFrame, unit)
    end
end

function NAMEPLATE:RefreshPlateOnFactionChanged()
    F:RegisterEvent('UNIT_FACTION', NAMEPLATE.OnUnitFactionChanged)
end

function NAMEPLATE:PostUpdatePlates(event, unit)
    if not self then
        return
    end

    if event == 'NAME_PLATE_UNIT_ADDED' then
        self.unitName = UnitName(unit)
        self.unitGUID = UnitGUID(unit)
        self.isPlayer = UnitIsPlayer(unit)
        self.npcID = F:GetNpcId(self.unitGUID)
        self.widgetsOnly = UnitNameplateShowsWidgetsOnly(unit)

        local blizzPlate = self:GetParent().UnitFrame
        self.widgetContainer = blizzPlate and blizzPlate.WidgetContainer
        if self.widgetContainer then
            self.widgetContainer:SetParent(self)
            -- self.widgetContainer:SetScale(_G.ANDROMEDA_ADB.UIScale)
        end

        NAMEPLATE.RefreshPlateType(self, unit)
    elseif event == 'NAME_PLATE_UNIT_REMOVED' then
        self.npcID = nil
    end

    if event ~= 'NAME_PLATE_UNIT_REMOVED' then
        NAMEPLATE.UpdateSelectedChange(self)
        NAMEPLATE.UpdateQuestUnit(self, event, unit)
        NAMEPLATE.UpdateSpitefulIndicator(self)
    end

    NAMEPLATE.UpdateExplosives(self, event, unit)
    NAMEPLATE.UpdateTotemIcon(self, event, unit)
end

local function CheckNameplateAuraFilter(index)
    local value = (index == 1 and C.NameplateAuraWhiteList) or (index == 2 and C.NameplateAuraBlackList)
    if value then
        for spellID in pairs(value) do
            local name = GetSpellInfo(spellID)
            if name then
                if _G.ANDROMEDA_ADB['NameplateAuraFilterList'][index][spellID] then
                    _G.ANDROMEDA_ADB['NameplateAuraFilterList'][index][spellID] = nil
                end
            else
                if C.IS_DEVELOPER then
                    F:Print('Invalid nameplate filter ID: ' .. spellID)
                end
            end
        end

        for spellID, val in pairs(_G.ANDROMEDA_ADB['NameplateAuraFilterList'][index]) do
            if val == false and value[spellID] == nil then
                _G.ANDROMEDA_ADB['NameplateAuraFilterList'][index][spellID] = nil
            end
        end
    end
end

function NAMEPLATE:CheckNameplateAuraFilters()
    CheckNameplateAuraFilter(1)
    CheckNameplateAuraFilter(2)
end

local function RefreshNameplateAuraFilter(index)
    wipe(NAMEPLATE.AuraFilterList[index])

    local VALUE = (index == 1 and C.NameplateAuraWhiteList) or (index == 2 and C.NameplateAuraBlackList)
    if VALUE then
        for spellID in pairs(VALUE) do
            local name = GetSpellInfo(spellID)
            if name then
                if _G.ANDROMEDA_ADB['NameplateAuraFilterList'][index][spellID] == nil then
                    NAMEPLATE.AuraFilterList[index][spellID] = true
                end
            end
        end
    end

    for spellID, value in pairs(_G.ANDROMEDA_ADB['NameplateAuraFilterList'][index]) do
        if value then
            NAMEPLATE.AuraFilterList[index][spellID] = true
        end
    end
end

function NAMEPLATE:RefreshNameplateAuraFilters()
    RefreshNameplateAuraFilter(1)
    RefreshNameplateAuraFilter(2)
end

function NAMEPLATE:OnLogin()
    if not C.DB.Nameplate.Enable then
        return
    end

    NAMEPLATE:UpdateClickableSize()
    hooksecurefunc(_G.NamePlateDriverFrame, 'UpdateNamePlateOptions', NAMEPLATE.UpdateClickableSize)

    NAMEPLATE:UpdateNameplateCVars()
    NAMEPLATE:BlockAddons()
    NAMEPLATE:CheckExplosives()
    NAMEPLATE:UpdateGroupRoles()
    NAMEPLATE:RefreshPlateOnFactionChanged()
    NAMEPLATE:CheckMajorSpellsFilter()
    NAMEPLATE:RefreshMajorSpellsFilter()
    NAMEPLATE:CheckNameplateAuraFilters()
    NAMEPLATE:RefreshNameplateAuraFilters()
    NAMEPLATE:CheckUnitsList()
    NAMEPLATE:RefreshSpecialUnitsList()
    NAMEPLATE:RefreshPowerUnitsList()

    oUF:RegisterStyle('Nameplate', NAMEPLATE.CreateNameplateStyle)
    oUF:SetActiveStyle('Nameplate')
    oUF:SpawnNamePlates('oUF_Nameplate', NAMEPLATE.PostUpdatePlates)
end
