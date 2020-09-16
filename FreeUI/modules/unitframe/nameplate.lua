local F, C, L = unpack(select(2, ...))
local NAMEPLATE = F.NAMEPLATE
local UNITFRAME = F.UNITFRAME
local oUF = F.oUF


local C_Scenario_GetInfo, C_Scenario_GetStepInfo, C_MythicPlus_GetCurrentAffixes = C_Scenario.GetInfo, C_Scenario.GetStepInfo, C_MythicPlus.GetCurrentAffixes
local C_NamePlate_GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit


--[[ CVars ]]

function NAMEPLATE:PlateInsideView()
	if FreeDB.nameplate.inside_view then
		SetCVar('nameplateOtherTopInset', .05)
		SetCVar('nameplateOtherBottomInset', .08)
	else
		SetCVar('nameplateOtherTopInset', -1)
		SetCVar('nameplateOtherBottomInset', -1)
	end
end

function NAMEPLATE:UpdatePlateScale()
	SetCVar('namePlateMinScale', FreeDB.nameplate.min_scale)
	SetCVar('namePlateMaxScale', FreeDB.nameplate.min_scale)
end

function NAMEPLATE:UpdatePlateTargetScale()
	SetCVar('nameplateLargerScale', FreeDB.nameplate.target_scale)
	SetCVar('nameplateSelectedScale', FreeDB.nameplate.target_scale)
end

function NAMEPLATE:UpdatePlateAlpha()
	SetCVar('nameplateMinAlpha', FreeDB.nameplate.min_alpha)
	SetCVar('nameplateMaxAlpha', FreeDB.nameplate.min_alpha)
	SetCVar('nameplateSelectedAlpha', 1)
end

function NAMEPLATE:UpdatePlateOccludedAlpha()
	SetCVar('nameplateOccludedAlphaMult', FreeDB.nameplate.occluded_alpha)
end

function NAMEPLATE:UpdatePlateDistance()
	SetCVar('nameplateMaxDistance', FreeDB.nameplate.max_distance)
end

function NAMEPLATE:UpdatePlateVerticalSpacing()
	SetCVar('nameplateOverlapV', FreeDB.nameplate.vertical_spacing)
end

function NAMEPLATE:UpdatePlateHorizontalSpacing()
	SetCVar('nameplateOverlapH', FreeDB.nameplate.horizontal_spacing)
end

function NAMEPLATE:UpdateClickableSize()
	if InCombatLockdown() then return end
	C_NamePlate.SetNamePlateEnemySize(FreeDB.nameplate.plate_width * FreeADB['ui_scale'], FreeDB.nameplate.plate_height * FreeADB['ui_scale'] + 40)
	C_NamePlate.SetNamePlateFriendlySize(FreeDB.nameplate.plate_width * FreeADB['ui_scale'], FreeDB.nameplate.plate_height * FreeADB['ui_scale'] + 40)
end

function NAMEPLATE:SetupCVars()
	NAMEPLATE:PlateInsideView()

	NAMEPLATE:UpdatePlateDistance()

	NAMEPLATE:UpdatePlateVerticalSpacing()
	NAMEPLATE:UpdatePlateHorizontalSpacing()

	NAMEPLATE:UpdatePlateAlpha()
	NAMEPLATE:UpdatePlateOccludedAlpha()

	NAMEPLATE:UpdatePlateScale()
	NAMEPLATE:UpdatePlateTargetScale()

	SetCVar('nameplateShowSelf', 0)
	SetCVar('nameplateResourceOnTarget', 0)
	F.HideOption(_G.InterfaceOptionsNamesPanelUnitNameplatesPersonalResource)
	F.HideOption(_G.InterfaceOptionsNamesPanelUnitNameplatesPersonalResourceOnEnemy)

	NAMEPLATE:UpdateClickableSize()
	hooksecurefunc(NamePlateDriverFrame, 'UpdateNamePlateOptions', NAMEPLATE.UpdateClickableSize)
end

-- DBM
function NAMEPLATE:BlockAddons()
	if not DBM or not DBM.Nameplate then return end

	function DBM.Nameplate:SupportedNPMod()
		return true
	end

	local function showAurasForDBM(_, _, _, spellID)
		if not tonumber(spellID) then return end
		if not C.AuraWhiteList[spellID] then
			C.AuraWhiteList[spellID] = true
		end
	end
	hooksecurefunc(DBM.Nameplate, 'Show', showAurasForDBM)
end


--[[ Elements ]]

local customUnits = {}
function NAMEPLATE:CreateUnitTable()
	wipe(customUnits)
	if not FreeDB.nameplate.custom_unit_color then return end
	F.CopyTable(C.CustomUnits, customUnits)
	F.SplitList(customUnits, FreeDB.nameplate.custom_unit_list)
end

local showPowerList = {}
function NAMEPLATE:CreatePowerUnitTable()
	wipe(showPowerList)
	F.CopyTable(C.ShowPowerList, showPowerList)
	F.SplitList(showPowerList, FreeDB.nameplate.show_power_list)
end

function NAMEPLATE:UpdateUnitPower()
	local unitName = self.unitName
	local npcID = self.npcID
	local shouldShowPower = showPowerList[unitName] or showPowerList[npcID]
	if shouldShowPower then
		self.powerText:Show()
	else
		self.powerText:Hide()
	end
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
			local index = unit..i
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

function NAMEPLATE:CheckTankStatus(unit)
	local index = unit..'target'
	local unitRole = isInGroup and UnitExists(index) and not UnitIsUnit(index, 'player') and groupRoles[UnitName(index)] or 'NONE'
	if unitRole == 'TANK' and C.Role == 'Tank' then
		self.feedbackUnit = index
		self.isOffTank = true
	else
		self.feedbackUnit = 'player'
		self.isOffTank = false
	end
end


-- Update unit color
function NAMEPLATE:UpdateColor(_, unit)
	if not unit or self.unit ~= unit then return end

	local element = self.Health
	local name = self.unitName
	local npcID = self.npcID
	local isCustomUnit = customUnits[name] or customUnits[npcID]
	local isPlayer = self.isPlayer
	local isFriendly = self.isFriendly
	local status = self.feedbackUnit and UnitThreatSituation(self.feedbackUnit, unit) or false
	local customColor = FreeDB.nameplate.custom_color
	local secureColor = FreeDB.nameplate.secure_color
	local transColor = FreeDB.nameplate.trans_color
	local insecureColor = FreeDB.nameplate.insecure_color
	local revertThreat = FreeDB.nameplate.dps_revert_threat
	local offTankColor = FreeDB.nameplate.off_tank_color
	local friendlyColor = FreeDB.nameplate.friendly_color
	local r, g, b

	if not UnitIsConnected(unit) then
		r, g, b = unpack(oUF.colors.disconnected)
	else
		if isCustomUnit then
			r, g, b = customColor.r, customColor.g, customColor.b
		elseif isPlayer and isFriendly then
			if FreeDB.nameplate.friendly_class_color then
				r, g, b = F.UnitColor(unit)
			else
				r, g, b = friendlyColor.r, friendlyColor.g, friendlyColor.b
			end
		elseif isPlayer and (not isFriendly) and FreeDB.nameplate.hostile_class_color then
			r, g, b = F.UnitColor(unit)
		elseif UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
			r, g, b = unpack(oUF.colors.tapped)
		else
			r, g, b = unpack(oUF.colors.reaction[UnitReaction(unit, 'player') or 5])
			if status and (FreeDB.nameplate.tank_mode or C.Role == 'Tank') then
				if status == 3 then
					if C.Role ~= 'Tank' and revertThreat then
						r, g, b = insecureColor.r, insecureColor.g, insecureColor.b
					else
						if self.isOffTank then
							r, g, b = offTankColor.r, offTankColor.g, offTankColor.b
						else
							r, g, b = secureColor.r, secureColor.g, secureColor.b
						end
					end
				elseif status == 2 or status == 1 then
					r, g, b = transColor.r, transColor.g, transColor.b
				elseif status == 0 then
					if C.Role ~= 'Tank' and revertThreat then
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
	end

	if isCustomUnit or (not FreeDB.nameplate.tank_mode and C.Role ~= 'Tank') then
		if status and status == 3 then
			self.ThreatIndicator:SetVertexColor(1, 0, 0)
			self.ThreatIndicator:Show()
		elseif status and (status == 2 or status == 1) then
			self.ThreatIndicator:SetVertexColor(1, 1, 0)
			self.ThreatIndicator:Show()
		else
			self.ThreatIndicator:Hide()
		end
	else
		self.ThreatIndicator:Hide()
	end
end

function NAMEPLATE:UpdateThreatColor(_, unit)
	if unit ~= self.unit then return end

	NAMEPLATE.CheckTankStatus(self, unit)
	NAMEPLATE.UpdateColor(self, _, unit)
end

function NAMEPLATE:AddThreatIndicator(self)
	if not FreeDB.nameplate.threat_indicator then return end

	local frame = CreateFrame('Frame', nil, self)
	frame:SetAllPoints()
	frame:SetFrameLevel(self:GetFrameLevel() - 1)


	local threat = frame:CreateTexture(nil, 'OVERLAY')
	threat:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 0)
	threat:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', 0, 0)
	threat:SetHeight(4)
	threat:SetTexture(C.Assets.glow_top_tex)
	threat:Hide()

	self.ThreatIndicator = threat
	self.ThreatIndicator.Override = NAMEPLATE.UpdateThreatColor
end


-- Target indicator
function NAMEPLATE:UpdateTargetChange()
	local element = self.TargetIndicator

	if UnitIsUnit(self.unit, 'target') and not UnitIsUnit(self.unit, 'player') then
		element:Show()
	else
		element:Hide()
	end
end

function NAMEPLATE:UpdateTargetIndicator()
	local element = self.TargetIndicator

	if FreeDB.nameplate.selected_indicator then
		element:Show()
	else
		element:Hide()
	end
end

function NAMEPLATE:AddTargetIndicator(self)
	if not FreeDB.nameplate.target_indicator then return end

	local color = FreeDB.nameplate.target_color
	local r, g, b = color.r, color.g, color.b

	local frame = CreateFrame('Frame', nil, self)
	frame:SetAllPoints()
	frame:SetFrameLevel(self:GetFrameLevel() - 1)
	frame:Hide()

	local texBot = frame:CreateTexture(nil, 'OVERLAY')
	texBot:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, 0)
	texBot:SetPoint('TOPRIGHT', frame, 'BOTTOMRIGHT', 0, 0)
	texBot:SetHeight(4)
	texBot:SetTexture(C.Assets.glow_bottom_tex)
	texBot:SetVertexColor(r, g, b, .85)

	self.TargetIndicator = frame
	self:RegisterEvent('PLAYER_TARGET_CHANGED', NAMEPLATE.UpdateTargetChange, true)
end


-- Mouseover indicator
function NAMEPLATE:IsMouseoverUnit()
	if not self or not self.unit then return end

	if self:IsVisible() and UnitExists('mouseover') then
		return UnitIsUnit('mouseover', self.unit)
	end
	return false
end

function NAMEPLATE:UpdateMouseoverShown()
	if not self or not self.unit then return end

	if self:IsShown() and UnitIsUnit('mouseover', self.unit) then
		self.HighlightIndicator:Show()
		self.HighlightUpdater:Show()
	else
		self.HighlightUpdater:Hide()
	end
end

function NAMEPLATE:AddHighlight(self)
	local highlight = CreateFrame('Frame', nil, self.Health)
	highlight:SetAllPoints(self)
	highlight:Hide()
	local texture = highlight:CreateTexture(nil, 'ARTWORK')
	texture:SetAllPoints()
	texture:SetColorTexture(1, 1, 1, .25)

	self:RegisterEvent('UPDATE_MOUSEOVER_UNIT', NAMEPLATE.UpdateMouseoverShown, true)

	local f = CreateFrame('Frame', nil, self)
	f:SetScript('OnUpdate', function(_, elapsed)
		f.elapsed = (f.elapsed or 0) + elapsed
		if f.elapsed > .1 then
			if not NAMEPLATE.IsMouseoverUnit(self) then
				f:Hide()
			end
			f.elapsed = 0
		end
	end)
	f:HookScript('OnHide', function()
		highlight:Hide()
	end)

	self.HighlightIndicator = highlight
	self.HighlightUpdater = f
end


-- Unit classification
local classify = {
	rare = 'VignetteKill',
	rareelite = 'VignetteKill',
	worldboss = 'VignetteKillElite',
}

function NAMEPLATE:AddRareIndicator(self)
	if not FreeDB.nameplate.classify_indicator then return end

	local icon = self:CreateTexture(nil, 'ARTWORK')
	icon:SetPoint('LEFT', self, 'RIGHT')
	icon:SetSize(8, 8)
	icon:Hide()

	self.ClassifyIndicator = icon
end

function NAMEPLATE:UpdateUnitClassify(unit)
	if self.ClassifyIndicator then
		local class = UnitClassification(unit)
		if class and classify[class] then
			local tex = classify[class]
			self.ClassifyIndicator:SetAtlas(tex)
			self.ClassifyIndicator:Show()
		else
			self.ClassifyIndicator:Hide()
		end
	end
end


-- Scale plates for explosives
local hasExplosives
local id = 120651
function NAMEPLATE:UpdateExplosives(event, unit)
	if not hasExplosives or unit ~= self.unit then return end

	local npcID = self.npcID
	if event == 'NAME_PLATE_UNIT_ADDED' and npcID == id then
		self:SetScale(FreeADB.ui_scale * 1.25)
	elseif event == 'NAME_PLATE_UNIT_REMOVED' then
		self:SetScale(FreeADB.ui_scale)
	end
end

local function checkInstance()
	local name, _, instID = GetInstanceInfo()
	if name and instID == 8 then
		hasExplosives = true
	else
		hasExplosives = false
	end
end

local function checkAffixes(event)
	local affixes = C_MythicPlus_GetCurrentAffixes()
	if not affixes then return end
	if affixes[3] and affixes[3].id == 13 then
		checkInstance()
		F:RegisterEvent(event, checkInstance)
		F:RegisterEvent('CHALLENGE_MODE_START', checkInstance)
	end
	F:UnregisterEvent(event, checkAffixes)
end

function NAMEPLATE:CheckExplosives()
	if not FreeDB.nameplate.explosive_scale then return end

	F:RegisterEvent('PLAYER_ENTERING_WORLD', checkAffixes)
end


-- Interrupt info on castbars
local guidToPlate = {}
function NAMEPLATE:UpdateCastbarInterrupt(...)
	local _, eventType, _, sourceGUID, sourceName, _, _, destGUID = ...
	if eventType == 'SPELL_INTERRUPT' and destGUID and sourceName and sourceName ~= '' then
		local nameplate = guidToPlate[destGUID]
		if nameplate and nameplate.Castbar then
			local _, class = GetPlayerInfoByGUID(sourceGUID)
			local r, g, b = F.ClassColor(class)
			local color = F.RGBToHex(r, g, b)
			sourceName = Ambiguate(sourceName, 'short')
			nameplate.Castbar.Text:Show()
			nameplate.Castbar.Text:SetText(color..sourceName..'|r '..INTERRUPTED)
		end
	end
end

function NAMEPLATE:AddInterruptInfo()
	if not FreeDB.nameplate.interrupt_name then return end

	F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', self.UpdateCastbarInterrupt)
end


--[[ Create plate ]]

local platesList = {}
local function CreateNameplateStyle(self)
	self.unitStyle = 'nameplate'
	self:SetSize(FreeDB.nameplate.plate_width, FreeDB.nameplate.plate_height)
	self:SetPoint('CENTER', 0, -10)
	self:SetScale(1)

	local health = CreateFrame('StatusBar', nil, self)
	health:SetAllPoints()
	health:SetStatusBarTexture(C.Assets.statusbar_tex)
	health.backdrop = F.CreateBDFrame(health, nil, true)
	F:SmoothBar(health)

	self.Health = health
	self.Health.UpdateColor = NAMEPLATE.UpdateColor

	local name = F.CreateFS(self, C.Assets.Fonts.Normal, 9, nil, nil, nil, 'THICK')
	name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
	self:Tag(name, '[free:name]')
	self.Name = name

	UNITFRAME:AddHealthPrediction(self)
	NAMEPLATE:AddTargetIndicator(self)
	NAMEPLATE:AddHighlight(self)
	NAMEPLATE:AddRareIndicator(self)
	NAMEPLATE:AddThreatIndicator(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddAuras(self)

	platesList[self] = self:GetName()
end




function NAMEPLATE:UpdateNameplateAuras()
	local element = self.Auras
	element:SetPoint('BOTTOM', self, 'TOP', 0, 8)
	element.numTotal = FreeDB.nameplate.aura_number
	element.size = FreeDB.nameplate.aura_size
	element:SetWidth(self:GetWidth())
	element:SetHeight((element.size + element.spacing) * 2)
	element:ForceUpdate()
end

function NAMEPLATE:RefreshNameplats()
	for nameplate in pairs(platesList) do
		NAMEPLATE.UpdateNameplateAuras()
		NAMEPLATE.UpdateTargetIndicator(nameplate)
		NAMEPLATE.UpdateTargetChange(nameplate)
	end
	NAMEPLATE:UpdateClickableSize()
end

function NAMEPLATE:RefreshAllPlates()
	NAMEPLATE:RefreshNameplats()
end


local DisabledElements = {
	'Health',
	'Castbar',
	'HealPredictionAndAbsorb',
	'PvPClassificationIndicator',
	'ThreatIndicator',
}

function NAMEPLATE:UpdatePlateByType()
	local name = self.Name
	local raidtarget = self.RaidTargetIndicator
	local classify = self.ClassifyIndicator

	name:ClearAllPoints()
	raidtarget:ClearAllPoints()

	for _, element in pairs(DisabledElements) do
		if not self:IsElementEnabled(element) then
			self:EnableElement(element)
		end
	end

	name:SetJustifyH('CENTER')
	self:Tag(name, '[free:name]')
	name:UpdateTag()
	name:SetPoint('BOTTOM', self, 'TOP', 0, 3)

	raidtarget:SetPoint('CENTER', self)
	raidtarget:SetParent(self.Health)

	classify:Show()

	NAMEPLATE.UpdateTargetIndicator(self)
end

function NAMEPLATE:RefreshPlateType(unit)
	self.reaction = UnitReaction(unit, 'player')
	self.isFriendly = self.reaction and self.reaction >= 5

	if self.previousType == nil then
		NAMEPLATE.UpdatePlateByType(self)
	end
end


function NAMEPLATE:OnUnitFactionChanged(unit)
	local nameplate = C_NamePlate_GetNamePlateForUnit(unit, issecure())
	local unitFrame = nameplate and nameplate.unitFrame
	if unitFrame and unitFrame.unitName then
		NAMEPLATE.RefreshPlateType(unitFrame, unit)
	end
end

function NAMEPLATE:RefreshPlateOnFactionChanged()
	F:RegisterEvent('UNIT_FACTION', NAMEPLATE.OnUnitFactionChanged)
end


function NAMEPLATE:PostUpdatePlates(event, unit)
	if not self then return end

	if event == 'NAME_PLATE_UNIT_ADDED' then
		self.unitName = UnitName(unit)
		self.unitGUID = UnitGUID(unit)
		if self.unitGUID then
			guidToPlate[self.unitGUID] = self
		end
		self.npcID = F.GetNPCID(self.unitGUID)
		self.isPlayer = UnitIsPlayer(unit)

		local blizzPlate = self:GetParent().UnitFrame
		self.widget = blizzPlate.WidgetContainer

		NAMEPLATE.RefreshPlateType(self, unit)
	elseif event == 'NAME_PLATE_UNIT_REMOVED' then
		if self.unitGUID then
			guidToPlate[self.unitGUID] = nil
		end
	end

	if event ~= 'NAME_PLATE_UNIT_REMOVED' then
		NAMEPLATE.UpdateTargetChange(self)
		NAMEPLATE.UpdateUnitClassify(self, unit)
	end

	NAMEPLATE.UpdateExplosives(self, event, unit)
end



function NAMEPLATE:OnLogin()
	if not FreeDB.nameplate.enable_nameplate then return end

	self:SetupCVars()
	self:BlockAddons()
	self:CreateUnitTable()
	self:CreatePowerUnitTable()
	self:CheckExplosives()
	self:AddInterruptInfo()
	self:UpdateGroupRoles()
	self:RefreshPlateOnFactionChanged()

	oUF:RegisterStyle('Nameplate', CreateNameplateStyle)
	oUF:SetActiveStyle('Nameplate')
	oUF:SpawnNamePlates('oUF_Nameplate', NAMEPLATE.PostUpdatePlates)
end
