local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


function UNITFRAME:AddPvPIndicator(self)
	local pvpIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, 'P', 'RED', 'THICK')
	pvpIndicator:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 5, 0)

	pvpIndicator.SetTexture = F.Dummy
	pvpIndicator.SetTexCoord = F.Dummy

	self.PvPIndicator = pvpIndicator
end

function UNITFRAME:AddCombatIndicator(self)
	local combatIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, '!', 'RED', 'THICK')
	combatIndicator:SetPoint('BOTTOMLEFT', self.PvPIndicator, 'BOTTOMRIGHT', 5, 0)

	self.CombatIndicator = combatIndicator
end

function UNITFRAME:AddRestingIndicator(self)
	local restingIndicator = F.CreateFS(self, {C.Assets.Fonts.Number, 11, nil}, nil, nil, 'Zzz', 'GREEN', 'THICK')
	restingIndicator:SetPoint('BOTTOMRIGHT', self.Power, 'BOTTOMLEFT', 5, 0)

	self.RestingIndicator = restingIndicator
end

function UNITFRAME:AddQuestIndicator(self)
	local questIndicator = F.CreateFS(self, C.Assets.Fonts.Number, 11, nil, '*', 'YELLOW', 'THICK')
	questIndicator:SetPoint('BOTTOMRIGHT', self.Name, 'BOTTOMLEFT', -3, 0)

	self.QuestIndicator = questIndicator
end

function UNITFRAME:AddRaidTargetIndicator(self)
	local raidTargetIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	raidTargetIndicator:SetTexture(C.Assets.Textures.targeticon)
	raidTargetIndicator:SetAlpha(.5)
	raidTargetIndicator:SetSize(16, 16)
	raidTargetIndicator:SetPoint('CENTER', self)

	self.RaidTargetIndicator = raidTargetIndicator
end

function UNITFRAME:AddResurrectIndicator(self)
	local resurrectIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	resurrectIndicator:SetSize(16, 16)
	resurrectIndicator:SetPoint('CENTER')

	self.ResurrectIndicator = resurrectIndicator
end

function UNITFRAME:AddReadyCheckIndicator(self)
	local readyCheckIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	readyCheckIndicator:SetPoint('CENTER', self.Health)
	readyCheckIndicator:SetSize(16, 16)
	self.ReadyCheckIndicator = readyCheckIndicator
end

function UNITFRAME:AddGroupRoleIndicator(self)
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

	local groupRoleIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', '', nil, true, 'BOTTOM', 1, 1)
	groupRoleIndicator.Override = UpdateLFD
	self.GroupRoleIndicator = groupRoleIndicator
end

function UNITFRAME:AddLeaderIndicator(self)
    local leaderIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', 'L', nil, true, 'TOPLEFT', 2, -2)

    self.LeaderIndicator = leaderIndicator
end

function UNITFRAME:AddPhaseIndicator(self)
	local phaseIndicator = F.CreateFS(self.Health, C.Assets.Fonts.Number, 11, nil, '?', nil, 'THICK', 'RIGHT', nil, true)
	phaseIndicator:SetPoint('TOPRIGHT', self.Health, 0, -2)
	self.PhaseIndicator = phaseIndicator
end

function UNITFRAME:AddSummonIndicator(self)
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

function UNITFRAME:AddThreatIndicator(self)
	self.ThreatIndicator = {
		IsObjectType = function() end,
		Override = UpdateThreat,
	}
end