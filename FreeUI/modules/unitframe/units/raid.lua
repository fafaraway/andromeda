local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


local function CreateRaidStyle(self)
	self.unitStyle = 'raid'

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddGroupNameText(self)
	UNITFRAME:AddLeaderIndicator(self)
	--UNITFRAME:AddBuffs(self)
	--UNITFRAME:AddDebuffs(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)

	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)
	UNITFRAME:AddSummonIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
	UNITFRAME:AddCornerBuff(self)
	UNITFRAME:AddRaidDebuffs(self)
	UNITFRAME:AddDebuffHighlight(self)
end

function UNITFRAME:SpawnRaid()
	oUF:RegisterStyle('Raid', CreateRaidStyle)
	oUF:SetActiveStyle('Raid')

	local mover
	local function CreateRaid(name, i)
		local raid = oUF:SpawnHeader(name, nil, 'custom [@raid6,exists] show;hide',
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", (cfg.symmetry and cfg.raidSymmetryWidth) or cfg.raidWidth,
		"initial-height", (cfg.symmetry and cfg.raidSymmetryHeight) or cfg.raidHeight,

		'showParty', true,
		'showRaid', true,

		'xoffset', (cfg.groupReverse and -cfg.raidPadding) or cfg.raidPadding,
		'yOffset', -cfg.raidPadding,

		'groupFilter', tostring(i),
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'sortMethod', 'INDEX',

		'columnAnchorPoint', cfg.groupReverse and 'RIGHT' or 'LEFT',
		'point', cfg.groupReverse and 'RIGHT' or 'LEFT')
		
		return raid
	end

	local groups = {}
	for i = 1, cfg.groupFilter do
		groups[i] = CreateRaid('oUF_Raid'..i, i)
		if i == 1 then
			if cfg.symmetry then
				mover = F.Mover(groups[i], L['MOVER_UNITFRAME_RAID'], 'RaidFrameSymmetry', cfg.raidSymmetryPos, ((cfg.raidSymmetryWidth * 5) + (cfg.raidPadding * 4)), (cfg.raidSymmetryHeight * cfg.groupFilter + (cfg.raidPadding * (cfg.groupFilter - 1))))
				groups[i]:ClearAllPoints()
				groups[i]:SetPoint((cfg.groupReverse and 'TOPRIGHT') or 'TOPLEFT', mover)
			else
				mover = F.Mover(groups[i], L['MOVER_UNITFRAME_RAID'], 'RaidFrame', cfg.raidPos, (cfg.raidWidth * 5) + (cfg.raidPadding * 4), (cfg.raidHeight * cfg.groupFilter) + cfg.raidPadding * (cfg.groupFilter - 1))
				groups[i]:ClearAllPoints()
				groups[i]:SetPoint((cfg.groupReverse and 'TOPRIGHT') or 'TOPLEFT', mover)
			end
		else
			if cfg.symmetry then
				groups[i]:SetPoint('TOPLEFT', groups[i-1], 'BOTTOMLEFT', 0, -cfg.raidPadding)
			else
				groups[i]:SetPoint((cfg.groupReverse and 'TOPRIGHT') or 'TOPLEFT', groups[i-1], (cfg.groupReverse and 'BOTTOMRIGHT') or 'BOTTOMLEFT', 0, -cfg.raidPadding)
			end
		end
	end
end