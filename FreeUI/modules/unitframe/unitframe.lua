local F, C = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local COLORS = F.COLORS


function UNITFRAME:OnLogin()
	if not C.DB.unitframe.enable_unitframe then return end

	F:SetSmoothingAmount(.3)

	if C.DB.unitframe.enable_player then
		self:SpawnPlayer()
	end

	if C.DB.unitframe.enable_pet then
		self:SpawnPet()
	end

	if C.DB.unitframe.enable_target then
		self:SpawnTarget()
		self:SpawnTargetTarget()
	end

	if C.DB.unitframe.enable_focus then
		self:SpawnFocus()
		self:SpawnFocusTarget()
	end

	if C.DB.unitframe.enable_boss then
		self:SpawnBoss()
	end

	if C.DB.unitframe.enable_arena then
		self:SpawnArena()
	end


	if not C.DB.unitframe.enable_group then return end

	if CompactRaidFrameManager_SetSetting then -- get rid of blizz raid frame
		CompactRaidFrameManager_SetSetting('IsShown', '0')
		UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:SetParent(F.HiddenFrame)
	end

	self:SpawnParty()
	self:SpawnRaid()
	self:ClickCast()
end
