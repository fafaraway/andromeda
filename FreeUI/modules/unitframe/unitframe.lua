local F, C = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local COLORS = F.COLORS


local RaidDebuffs = {}
function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
	local instName = EJ_GetInstanceInfo(instID)
	if not instName then
		if C.isDeveloper then print("Invalid instance ID: "..instID) end
		return
	end

	if not RaidDebuffs[instName] then RaidDebuffs[instName] = {} end
	if not level then level = 2 end
	if level > 6 then level = 6 end

	RaidDebuffs[instName][spellID] = level
end


function UNITFRAME:OnLogin()
	F:SetSmoothingAmount(.3)

	UNITFRAME:UpdateColors()

	if not C.DB.unitframe.enable then
		return
	end

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

	if not C.DB.unitframe.enable_group then
		return
	end

	if CompactRaidFrameManager_SetSetting then -- get rid of blizz raid frame
		CompactRaidFrameManager_SetSetting('IsShown', '0')
		UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:SetParent(F.HiddenFrame)
	end

	C.RaidDebuffsList = RaidDebuffs

	self:SpawnParty()
	self:SpawnRaid()
	self:ClickCast()

	--UNITFRAME:UpdateRaidHealthMethod()

	if UNITFRAME.RaidMover then
		if not C.DB.unitframe.spec_position then
			return
		end

		local function UpdateSpecPos(event, ...)
			local unit, _, spellID = ...
			if
				(event == 'UNIT_SPELLCAST_SUCCEEDED' and unit == 'player' and spellID == 200749) or event == 'PLAYER_ENTERING_WORLD'
			 then
				if not GetSpecialization() then
					return
				end
				local specIndex = GetSpecialization()
				if not C.DB['ui_anchor']['raid_position' .. specIndex] then
					C.DB['ui_anchor']['raid_position' .. specIndex] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -10}
				end
				UNITFRAME.RaidMover:ClearAllPoints()
				UNITFRAME.RaidMover:SetPoint(unpack(C.DB['ui_anchor']['raid_position' .. specIndex]))
			end
		end
		F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateSpecPos)
		F:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', UpdateSpecPos)

		UNITFRAME.RaidMover:HookScript(
			'OnDragStop',
			function()
				if not GetSpecialization() then
					return
				end
				local specIndex = GetSpecialization()
				C.DB['ui_anchor']['raid_position' .. specIndex] = C.DB['ui_anchor']['RaidFrame']
			end
		)
	end
end
