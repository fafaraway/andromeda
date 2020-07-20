local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


local function CreateBossStyle(self)
	self.unitStyle = 'boss'
	self:SetSize((cfg.symmetry and cfg.bossSymmetryWidth) or cfg.bossWidth, (cfg.symmetry and cfg.bossSymmetryHeight) or cfg.bossHeight)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPowerValueText(self)
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
	oUF:RegisterStyle('Boss', CreateBossStyle)
	oUF:SetActiveStyle('Boss')

	local boss = {}

	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn('boss'..i, 'oUF_Boss'..i)
		if i == 1 then
			if cfg.symmetry then
				boss[i].mover = F.Mover(boss[i], L['MOVER_UNITFRAME_BOSS'], 'BossFrameSymmetry', cfg.bossPos, cfg.bossSymmetryWidth, cfg.bossSymmetryHeight)
			else
				boss[i].mover = F.Mover(boss[i], L['MOVER_UNITFRAME_BOSS'], 'BossFrame', cfg.bossSymmetryPos, cfg.bossWidth, cfg.bossHeight)
			end
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, cfg.bossPadding)
		end
	end
end