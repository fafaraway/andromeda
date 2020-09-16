local F, C = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local COLORS = F.COLORS


function UNITFRAME:OnLogin()
	if not FreeDB.unitframe.enable_unitframe then return end

	F:SetSmoothingAmount(.3)

	COLORS:UpdateColors()

	self:SpawnPlayer()
	self:SpawnTarget()
	self:SpawnTargetTarget()

	if FreeDB.unitframe.enable_pet then
		self:SpawnPet()
	end

	if FreeDB.unitframe.enable_focus then
		self:SpawnFocus()
		self:SpawnFocusTarget()
	end

	if FreeDB.unitframe.enable_boss then
		self:SpawnBoss()
	end

	if FreeDB.unitframe.enable_arena then
		self:SpawnArena()
	end


	if not FreeDB.unitframe.enable_group then return end

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
