local F, C, L = unpack(select(2, ...))
local NAMEPLATE = F.NAMEPLATE
local oUF = F.oUF


local wipe = wipe
local INTERRUPTED = INTERRUPTED


-- Elements
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
				r, g, b = .3, .3, 1
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
			self.ThreatIndicator:SetBackdropBorderColor(1, 0, 0)
			self.ThreatIndicator:Show()
		elseif status and (status == 2 or status == 1) then
			self.ThreatIndicator:SetBackdropBorderColor(1, 1, 0)
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

function NAMEPLATE:CreateThreatColor(self)
	local threatIndicator = F.CreateSD(self, nil, 3, 3, true)
	threatIndicator:SetOutside(self.Health.backdrop, 3, 3)
	threatIndicator:Hide()

	self.ThreatIndicator = threatIndicator
	self.ThreatIndicator.Override = NAMEPLATE.UpdateThreatColor
end


-- Target indicator
function NAMEPLATE:UpdateTargetChange()
	local element = self.TargetIndicator
	if not FreeDB.nameplate.target_indicator then return end

	if UnitIsUnit(self.unit, 'target') and not UnitIsUnit(self.unit, 'player') then
		element:Show()
	else
		element:Hide()
	end
end

function NAMEPLATE:AddTargetIndicator(self)
	local frameHeight = 4
	local color = FreeDB.nameplate.target_color
	local r, g, b = color.r, color.g, color.b

	local frame = CreateFrame('Frame', nil, self)
	frame:SetAllPoints()
	frame:SetFrameLevel(self:GetFrameLevel() - 1)
	frame:Hide()

	local texTop = frame:CreateTexture(nil, 'OVERLAY')
	texTop:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, 0)
	texTop:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', 0, 0)
	texTop:SetHeight(frameHeight)
	texTop:SetTexture(C.Assets.glow_top_tex)
	texTop:SetVertexColor(r, g, b, .85)

	local texBot = frame:CreateTexture(nil, 'OVERLAY')
	texBot:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, 0)
	texBot:SetPoint('TOPRIGHT', frame, 'BOTTOMRIGHT', 0, 0)
	texBot:SetHeight(frameHeight)
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

function NAMEPLATE:AddMouseoverHighlight(self)
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
	rare = {1, 1, 1, true},
	elite = {1, 1, 1},
	rareelite = {1, .1, .1},
	worldboss = {0, 1, 0},
}

function NAMEPLATE:AddCreatureIcon(self)
	local iconFrame = CreateFrame('Frame', nil, self)
	iconFrame:SetAllPoints()
	iconFrame:SetFrameLevel(self:GetFrameLevel() + 2)

	local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
	icon:SetAtlas('VignetteKill')
	icon:SetPoint('RIGHT', self, 'LEFT')
	icon:SetSize(16, 16)
	icon:Hide()

	self.ClassifyIndicator = icon
end

function NAMEPLATE:UpdateUnitClassify(unit)
	if self.ClassifyIndicator then
		local class = UnitClassification(unit)
		if class and classify[class] then
			local r, g, b, desature = unpack(classify[class])
			self.ClassifyIndicator:SetVertexColor(r, g, b)
			self.ClassifyIndicator:SetDesaturated(desature)
			self.ClassifyIndicator:Show()
		else
			self.ClassifyIndicator:Hide()
		end
	end
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
			local color = F.HexRGB(r, g, b)
			local sourceName = Ambiguate(sourceName, 'short')
			nameplate.Castbar.Text:SetText(INTERRUPTED..' > '..color..sourceName)
			nameplate.Castbar.Time:SetText('')
		end
	end
end

function NAMEPLATE:AddInterruptInfo()
	F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', self.UpdateCastbarInterrupt)
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

		--NAMEPLATE.RefreshPlateType(self, unit)
	elseif event == 'NAME_PLATE_UNIT_REMOVED' then
		if self.unitGUID then
			guidToPlate[self.unitGUID] = nil
		end
	end

	if event ~= 'NAME_PLATE_UNIT_REMOVED' then

		NAMEPLATE.UpdateTargetChange(self)

		NAMEPLATE.UpdateUnitClassify(self, unit)

	end

end


local platesList = {}
function NAMEPLATE:CreateNameplateStyle()
	self.unitStyle = 'nameplate'
	--self:SetSize(FreeDB.nameplate.nameplate_width, FreeDB.nameplate.nameplate_height)
	self:SetSize(60, 6)
	self:SetPoint('CENTER')
	self:SetScale(1)

	local health = CreateFrame('StatusBar', nil, self)
	health:SetAllPoints()
	health:SetStatusBarTexture(C.Assets.norm_tex)
	health.backdrop = F.CreateBDFrame(health, nil, true)
	F:SmoothBar(health)

	self.Health = health
	self.Health.UpdateColor = NAMEPLATE.UpdateColor


	NAMEPLATE:AddTargetIndicator(self)
	NAMEPLATE:AddMouseoverHighlight(self)
	NAMEPLATE:AddCreatureIcon(self)
	NAMEPLATE:CreateThreatColor(self)

	platesList[self] = self:GetName()
end

function NAMEPLATE:SpawnNameplate()


	oUF:RegisterStyle('Nameplate', NAMEPLATE.CreateNameplateStyle)
	oUF:SetActiveStyle('Nameplate')
	oUF:SpawnNamePlates('oUF_Nameplate', NAMEPLATE.PostUpdatePlates)

end




function NAMEPLATE:OnLogin()
	if not FreeDB.nameplate.enable_nameplate then return end

	self:SpawnNameplate()
end
