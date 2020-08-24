local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UNITFRAME')


function UNITFRAME:OnLogin()
	if not FreeUIConfigs.unitframe.enable_unitframe then return end

	F:SetSmoothingAmount(.3)

	self:SpawnPlayer()
	self:SpawnTarget()
	self:SpawnTargetTarget()

	if FreeUIConfigs.unitframe.enable_pet then
		self:SpawnPet()
	end

	if FreeUIConfigs.unitframe.enable_focus then
		self:SpawnFocus()
		self:SpawnFocusTarget()
	end

	if FreeUIConfigs.unitframe.enable_boss then
		self:SpawnBoss()
	end

	if FreeUIConfigs.unitframe.enable_arena then
		self:SpawnArena()
	end


	if not FreeUIConfigs.unitframe.enable_group then return end

	if CompactRaidFrameManager_SetSetting then
		CompactRaidFrameManager_SetSetting('IsShown', '0')
		UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:SetParent(F.HiddenFrame)
	end

	self:SpawnParty()
	self:SpawnRaid()
	self:ClickCast()
end
