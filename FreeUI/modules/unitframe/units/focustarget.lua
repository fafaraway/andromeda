local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local function CreateFocusTargetStyle(self)
	self.unitStyle = 'focustarget'
	self:SetSize(cfg.focus_target_width, cfg.focus_target_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFader(self)
end

function UNITFRAME:SpawnFocusTarget()
	F.oUF:RegisterStyle('FocusTarget', CreateFocusTargetStyle)
	F.oUF:SetActiveStyle('FocusTarget')

	local focustarget = F.oUF:Spawn('focustarget', 'oUF_FocusTarget')

	F.Mover(focustarget, L['MOVER_UNITFRAME_FOCUSTARGET'], 'FocusTargetFrame', {'TOPRIGHT', 'oUF_Focus', 'TOPLEFT', -6, 0}, focustarget:GetWidth(), focustarget:GetHeight())
end