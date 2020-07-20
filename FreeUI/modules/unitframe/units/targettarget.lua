local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function CreateTargetTargetStyle(self)
	self.unitStyle = 'targettarget'
	self:SetSize(cfg.target_target_width, cfg.target_target_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFader(self)
end

function UNITFRAME:SpawnTargetTarget()
	F.oUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)
	F.oUF:SetActiveStyle('TargetTarget')

	local isHealer = FreeUIConfig['unitframe']['layout'] == "HEALER"
	local targettarget = F.oUF:Spawn('targettarget', 'oUF_TargetTarget')

	F.Mover(targettarget, L['MOVER_UNITFRAME_TARGETTARGET'], 'TargetTargetFrame', (isHealer and {'BOTTOM', UIParent, 'BOTTOM', 0, 300}) or {'LEFT', 'oUF_Target', 'RIGHT', 6, 0}, targettarget:GetWidth(), targettarget:GetHeight())
end