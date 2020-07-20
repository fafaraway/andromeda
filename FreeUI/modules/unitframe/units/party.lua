local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


local function CreatePartyStyle(self)
	self.unitStyle = 'party'

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddGroupNameText(self)
	UNITFRAME:AddLeaderIndicator(self)
	UNITFRAME:AddBuffs(self)
	UNITFRAME:AddDebuffs(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)

	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)
	UNITFRAME:AddSummonIndicator(self)
	UNITFRAME:AddThreatIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
	UNITFRAME:AddCornerBuff(self)
	UNITFRAME:AddRaidDebuffs(self)
	UNITFRAME:AddDebuffHighlight(self)
end

function UNITFRAME:SpawnParty()
	oUF:RegisterStyle('Party', CreatePartyStyle)
	oUF:SetActiveStyle('Party')

	local mover
	local party = oUF:SpawnHeader('oUF_Party', nil, 'custom [@raid6,exists] hide;show',
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],

		"initial-width", (cfg.symmetry and cfg.partySymmetryWidth) or cfg.partyWidth,
		"initial-height", (cfg.symmetry and cfg.partySymmetryHeight) or cfg.partyHeight,

		'showParty', true,
		'showPlayer', cfg.groupShowPlayer,
		'showSolo', cfg.groupShowSolo,
		
		'xoffset', cfg.partyPadding,
		'yoffset', cfg.partyPadding,

		'point', cfg.symmetry and 'LEFT' or 'BOTTOM',

		'groupBy', cfg.groupByRole and 'ASSIGNEDROLE',
		'groupingOrder', cfg.groupByRole and 'TANK,HEALER,DAMAGER,NONE')

	if cfg.symmetry then
		mover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], 'PartyFrameSymmetry', cfg.partySymmetryPos, ((cfg.partyWidth * 5) + (cfg.partyPadding * 4)), cfg.partyHeight)
		party:ClearAllPoints()
		party:SetPoint('TOP', mover)
	else
		mover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], 'PartyFrame', cfg.partyPos, cfg.partyWidth, ((cfg.partyHeight * 5) + (cfg.partyPadding * 4)))
		party:ClearAllPoints()
		party:SetPoint('BOTTOM', mover)
	end
end