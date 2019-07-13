local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module, cfg = F:GetModule('Unitframe'), C.unitframe
local oUF = ns.oUF


function module:AddStatusIndicator(self)
	local statusIndicator = CreateFrame('Frame')
	local statusText = F.CreateFS(self.Health, 'pixel', '', nil, nil, true)
	statusText:SetPoint('LEFT', self.HealthValue, 'RIGHT', 10, 0)

	local function updateStatus()
		if UnitAffectingCombat('player') then
			statusText:SetText('!')
			statusText:SetTextColor(1, 0, 0)
		elseif IsResting() then
			statusText:SetText('Zzz')
			statusText:SetTextColor(44/255, 141/255, 81/255)
		else
			statusText:SetText('')
		end
	end

	local function checkEvents()
		statusText:Show()
		statusIndicator:RegisterEvent('PLAYER_ENTERING_WORLD', true)
		statusIndicator:RegisterEvent('PLAYER_UPDATE_RESTING', true)
		statusIndicator:RegisterEvent('PLAYER_REGEN_ENABLED', true)
		statusIndicator:RegisterEvent('PLAYER_REGEN_DISABLED', true)

		updateStatus()
	end
	checkEvents()
	statusIndicator:SetScript('OnEvent', updateStatus)
end

function module:AddPvPIndicator(self)
	local PvPIndicator = F.CreateFS(self, 'pixel', '', nil, nil, true)
	PvPIndicator:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', -50, 3)
	PvPIndicator:SetText('P')

	local UpdatePvPIndicator = function(self, event, unit)
		if(unit ~= self.unit) then return end

		local PvPIndicator = self.PvPIndicator
		local factionGroup = UnitFactionGroup(unit)

		if(UnitIsPVPFreeForAll(unit) or (factionGroup and factionGroup ~= 'Neutral' and UnitIsPVP(unit))) then
			if factionGroup == 'Alliance' then
				PvPIndicator:SetTextColor(.2, .6, 1)
			else
				PvPIndicator:SetTextColor(1, 0, 0)
			end

			PvPIndicator:Show()
		else
			PvPIndicator:Hide()
		end
	end

	self.PvPIndicator = PvPIndicator
	PvPIndicator.Override = UpdatePvPIndicator
end

function module:AddQuestIndicator(self)
	local questIndicator = F.CreateFS(self, 'pixel', '!', nil, 'yellow', true)
	questIndicator:SetPoint('BOTTOMLEFT', self.Classification, 'BOTTOMRIGHT', 3, 0)

	self.QuestIndicator = questIndicator
end

function module:AddRaidTargetIndicator(self)
	local raidTargetIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	raidTargetIndicator:SetTexture(C.AssetsPath..'UI-RaidTargetingIcons')
	raidTargetIndicator:SetAlpha(.5)
	raidTargetIndicator:SetSize(16, 16)
	raidTargetIndicator:SetPoint('CENTER', self)

	self.RaidTargetIndicator = raidTargetIndicator
end

function module:AddLeaderIndicator(self)
	local leaderIndicator = F.CreateFS(self.Health, 'pixel', 'L', 'LEFT', nil, true)
	leaderIndicator:SetPoint('TOPLEFT', self.Health, 2, -2)
	self.LeaderIndicator = leaderIndicator
end

function module:AddResurrectIndicator(self)
	local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	resurrectIndicator:SetSize(16, 16)
	resurrectIndicator:SetPoint('CENTER')
	self.ResurrectIndicator = resurrectIndicator
end

function module:AddReadyCheckIndicator(self)
	local readyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	readyCheckIndicator:SetPoint('CENTER', self.Health)
	readyCheckIndicator:SetSize(16, 16)
	self.ReadyCheckIndicator = readyCheckIndicator
end

function module:AddGroupRoleIndicator(self)
	local UpdateLFD = function(self, event)
		local lfdrole = self.GroupRoleIndicator
		local role = UnitGroupRolesAssigned(self.unit)

		if role == 'DAMAGER' then
			lfdrole:SetTextColor(1, .1, .1, 1)
			lfdrole:SetText('.')
		elseif role == 'TANK' then
			lfdrole:SetTextColor(.3, .4, 1, 1)
			lfdrole:SetText('x')
		elseif role == 'HEALER' then
			lfdrole:SetTextColor(0, 1, 0, 1)
			lfdrole:SetText('+')
		else
			lfdrole:SetTextColor(0, 0, 0, 0)
		end
	end

	local groupRoleIndicator = F.CreateFS(self.Health, 'pixel', '', 'CENTER', nil, true)
	groupRoleIndicator:SetPoint('BOTTOM', self.Health, 1, 1)
	groupRoleIndicator.Override = UpdateLFD
	self.GroupRoleIndicator = groupRoleIndicator
end

function module:AddPhaseIndicator(self)
	local phaseIndicator = F.CreateFS(self.Health, 'pixel', '?', 'RIGHT', nil, true)
	phaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -2)
	self.PhaseIndicator = phaseIndicator
end

function module:AddSummonIndicator(self)
	local summonIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	summonIndicator:SetSize(36, 36)
	summonIndicator:SetPoint('CENTER')

	self.SummonIndicator = summonIndicator
end

local function UpdateThreat(self, event, unit)
	if not self.Glow or self.unit ~= unit then return end

	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		local r, g, b = GetThreatStatusColor(status)
		self.Glow:SetBackdropBorderColor(r, g, b, .6)
	else
		self.Glow:SetBackdropBorderColor(0, 0, 0, .35)
	end
end

function module:AddThreatIndicator(self)
	self.ThreatIndicator = {
		IsObjectType = function() end,
		Override = UpdateThreat,
	}
end