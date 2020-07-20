local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


local function CreateArenaStyle(self)
	self.unitStyle = 'arena'
	self:SetSize((cfg.symmetry and cfg.arenaSymmetryWidth) or cfg.arenaWidth, (cfg.symmetry and cfg.arenaSymmetryHeight) or cfg.arenaHeight)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddCastBar(self)
	--UNITFRAME:AddAuras(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddSelectedBorder(self)
end

function UNITFRAME:SpawnArena()
	oUF:RegisterStyle('Arena', CreateArenaStyle)
	oUF:SetActiveStyle('Arena')

	local arena = {}

	for i = 1, 5 do
		arena[i] = oUF:Spawn('arena'..i, 'oUF_Arena'..i)
		if i == 1 then
			if cfg.symmetry then
				arena[i].mover = F.Mover(arena[i], L['MOVER_UNITFRAME_ARENA'], 'ArenaFrameSymmetry', cfg.arenaPos, cfg.arenaSymmetryWidth, cfg.arenaSymmetryHeight)
			else
				arena[i].mover = F.Mover(arena[i], L['MOVER_UNITFRAME_ARENA'], 'ArenaFrame', cfg.arenaSymmetryPos, cfg.arenaWidth, cfg.arenaHeight)
			end
		else
			arena[i]:SetPoint('BOTTOM', arena[i-1], 'TOP', 0, cfg.arenaPadding)
		end
	end
end