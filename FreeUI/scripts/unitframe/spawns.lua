local F, C, L = unpack(select(2, ...))

local oUF = FreeUI.oUF
local format, tostring = string.format, tostring

local module = F:GetModule('Unitframe')

local cfg = C.unitframe

local function CreatePlayerStyle(self)
	self.unitStyle = 'player'
	self:SetSize(cfg.player_width, cfg.player_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreateHealthText(self)
	module:CreatePowerBar(self)
	module:CreateHealthPrediction(self)
	module:CreatePowerText(self)
	module:CreatePortrait(self)
	module:CreateAltPower(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateSpellRange(self)
	module:CreateDispellable(self, unit)
	if (C.Class == 'DEATHKNIGHT') then
		module:CreateRunesBar(self)
	else
		module:CreateClassPower(self)
	end

	FreeUI_LeaveVehicleButton:SetPoint('LEFT', self, 'RIGHT', 5, 0)
end

local function CreatePetStyle(self)
	self.unitStyle = 'pet'
	self:SetSize(cfg.pet_width, cfg.pet_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreatePowerBar(self)
	module:CreateHealthPrediction(self)
	module:CreatePortrait(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateAuras(self, 6, 3)
	module:CreateSpellRange(self)
end

local function CreateTargetStyle(self)
	self.unitStyle = 'target'
	self:SetSize(cfg.target_width, cfg.target_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreateHealthText(self)
	module:CreatePowerBar(self)
	module:CreateHealthPrediction(self)
	module:CreatePowerText(self)
	module:ClassificationText(self)
	module:CreatePortrait(self)
	module:CreateName(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateAuras(self, 32, 8)
	module:CreateSpellRange(self)
end

local function CreateToTStyle(self)
	self.unitStyle = 'targettarget'
	self:SetSize(cfg.targettarget_width, cfg.targettarget_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreatePowerBar(self)
	module:CreateName(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateSpellRange(self)
end

local function CreateFocusStyle(self)
	self.unitStyle = 'focus'
	self:SetSize(cfg.focus_width, cfg.focus_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreatePowerBar(self)
	module:CreateHealthPrediction(self)
	module:CreateName(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateAuras(self, 8, 4)
	module:CreateSpellRange(self)
end

local function CreateFoTStyle(self)
	self.unitStyle = 'focustarget'
	self:SetSize(cfg.focustarget_width, cfg.focustarget_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreatePowerBar(self)
	module:CreateName(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateSpellRange(self)
end

local function CreatePartyStyle(self)
	self.unitStyle = 'party'

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreatePowerBar(self)
	module:CreateHealthPrediction(self)
	module:CreatePortrait(self)
	module:CreatePartyName(self)
	module:CreateIndicator(self)
	module:CreateThreatIndicator(self)
	module:CreateBuffs(self)
	module:CreateDebuffs(self)
	module:CreateNameColour(self)
	module:CreateBorderColour(self)
	module:CreateDispellable(self, unit)
	module:CreateSpellRange(self)
end

local function CreateRaidStyle(self)
	self.unitStyle = 'raid'

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreatePowerBar(self)
	module:CreateHealthPrediction(self)
	module:CreatePartyName(self)
	module:CreateIndicator(self)
	module:CreateThreatIndicator(self)
	module:CreateBuffs(self)
	module:CreateDebuffs(self)
	module:CreateNameColour(self)
	module:CreateBorderColour(self)
	module:CreateSpellRange(self)
end

local function CreateBossStyle(self)
	self.unitStyle = 'boss'
	self:SetSize(cfg.boss_width, cfg.boss_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreateHealthText(self)
	module:CreatePowerBar(self)
	module:CreatePortrait(self)
	module:CreateName(self)
	module:CreateAltPower(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateAuras(self, 15, 5)
	module:CreateBorderColour(self)
	module:CreateSpellRange(self)
end

local function CreateArenaStyle(self)
	self.unitStyle = 'arena'
	self:SetSize(cfg.arena_width, cfg.arena_height)

	module:CreateBackDrop(self)
	module:CreateHeader(self)
	module:CreateHealthBar(self)
	module:CreateHealthText(self)
	module:CreatePowerBar(self)
	module:CreateName(self)
	module:CreateIndicator(self)
	module:CreateCastBar(self)
	module:CreateAuras(self, 18, 6)
	module:CreateSpellRange(self)
end






-- Unit specific functions
--[[local UnitSpecific = {
	pet = function(self, ...)
		self.unitStyle = 'pet'
		self:SetSize(cfg.pet_width, cfg.pet_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePortrait(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 6, 3)
		spellRange(self)
	end,

	player = function(self, ...)
		self.unitStyle = 'player'
		self:SetSize(cfg.player_width, cfg.player_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePowerText(self)
		CreatePortrait(self)
		CreateAltPower(self)
		CreateIndicator(self)
		CreateCastBar(self)
		spellRange(self)
		CreateDispellable(self, unit)
		if (C.Class == 'DEATHKNIGHT') then
			CreateRunesBar(self)
		else
			CreateClassPower(self)
		end

		FreeUI_LeaveVehicleButton:SetPoint('LEFT', self, 'RIGHT', 5, 0)
	end,

	target = function(self, ...)
		self.unitStyle = 'target'
		self:SetSize(cfg.target_width, cfg.target_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePowerText(self)
		ClassificationText(self)
		CreatePortrait(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 28, 7)
		spellRange(self)
	end,

	targettarget = function(self, ...)
		self.unitStyle = 'targettarget'
		self:SetSize(cfg.targettarget_width, cfg.targettarget_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		--UpdateName(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		spellRange(self)
	end,

	focus = function(self, ...)
		self.unitStyle = 'focus'
		self:SetSize(cfg.focus_width, cfg.focus_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 8, 4)
		spellRange(self)
	end,

	focustarget = function(self, ...)
		self.unitStyle = 'focustarget'
		self:SetSize(cfg.focustarget_width, cfg.focustarget_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		--UpdateName(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		spellRange(self)
	end,


	boss = function(self, ...)
		self.unitStyle = 'boss'
		self:SetSize(cfg.boss_width, cfg.boss_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreatePortrait(self)
		CreateName(self)
		CreateAltPower(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 15, 5)
		BorderColour(self)
	end,

	arena = function(self, ...)
		if not cfg.enableArena then return end
		self.unitStyle = 'arena'
		self:SetSize(cfg.arena_width, cfg.arena_height)

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreateHealthText(self)
		CreatePowerBar(self)
		CreateName(self)
		CreateIndicator(self)
		CreateCastBar(self)
		CreateAuras(self, 18, 6)
		spellRange(self)
	end,

	party = function(self, ...)
		self.unitStyle = 'party'

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePortrait(self)
		CreatePartyName(self)
		CreateIndicator(self)
		CreateThreatIndicator(self)
		CreateBuffs(self)
		CreateDebuffs(self)
		NameColour(self)
		BorderColour(self)
		CreateDispellable(self, unit)
		spellRange(self)
	end,

	raid = function(self, ...)
		self.unitStyle = 'raid'

		CreateBackDrop(self)
		CreateHeader(self)
		CreateHealthBar(self)
		CreatePowerBar(self)
		CreateHealthPrediction(self)
		CreatePartyName(self)
		CreateIndicator(self)
		CreateThreatIndicator(self)
		CreateBuffs(self)
		CreateDebuffs(self)
		NameColour(self)
		BorderColour(self)
		spellRange(self)
	end,
}


-- Register and activate style
for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle('Free - ' .. unit:gsub('^%l', string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Free - ' .. unit:gsub('^%l', string.upper))
	elseif(UnitSpecific[unit:match('[^%d]+')]) then -- boss1 -> boss
		self:SetActiveStyle('Free - ' .. unit:match('[^%d]+'):gsub('^%l', string.upper))
	else
		self:SetActiveStyle'Free'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end]]


--oUF:Factory(function(self)
--	if FreeUIConfig.unitframeLayout == 2 then
--		player = spawnHelper(self, 'player', unpack(cfg.player_pos_healer))
--		target = spawnHelper(self, 'target', unpack(cfg.target_pos_healer))
--		focus = spawnHelper(self, 'focus', unpack(cfg.focus_pos_healer))
--	else
--		player = spawnHelper(self, 'player', unpack(cfg.player_pos))
--		target = spawnHelper(self, 'target', unpack(cfg.target_pos))
--		focus = spawnHelper(self, 'focus', unpack(cfg.focus_pos))
--	end

--	pet = spawnHelper(self, 'pet', unpack(cfg.pet_pos))
--	targettarget = spawnHelper(self, 'targettarget', unpack(cfg.targettarget_pos))
--	focustarget = spawnHelper(self, 'focustarget', unpack(cfg.focustarget_pos))

--	if cfg.enableFrameVisibility then
--		player:Disable()
--		RegisterStateDriver(player, 'visibility', cfg.player_frameVisibility)
--		pet:Disable()
--		RegisterStateDriver(pet, 'visibility', cfg.pet_frameVisibility)
--	end

--	if cfg.enableBoss then
--		for n = 1, MAX_BOSS_FRAMES do
--			spawnHelper(self, 'boss' .. n, cfg.boss_pos[1], cfg.boss_pos[2], cfg.boss_pos[3], cfg.boss_pos[4], cfg.boss_pos[5] + (80 * n))
--		end
--	end

--	if cfg.enableArena then
--		for n = 1, 5 do
--			spawnHelper(self, 'arena' .. n, cfg.arena_pos[1], cfg.arena_pos[2], cfg.arena_pos[3], cfg.arena_pos[4], cfg.arena_pos[5] + (100 * n))
--		end
--	end


--	if not cfg.enableGroup then return end

--	local party_xoffset, party_yoffset, party_point, party_columnAnchorPoint, party_height, party_width, party_pos, 
--	raid_xoffset, raid_yoffset, raid_point, raid_pos

--	if FreeUIConfig.unitframeLayout == 2 then
--		party_xoffset = cfg.party_xoffset_healer
--		party_yoffset = cfg.party_yoffset_healer
--		party_point = cfg.party_point_healer
--		party_columnAnchorPoint = cfg.party_columnAnchorPoint_healer
--		party_height = cfg.party_height_healer
--		party_width = cfg.party_width_healer
--		party_pos = cfg.party_pos_healer
--		raid_xoffset = cfg.raid_xoffset_healer
--		raid_yoffset = cfg.raid_yoffset_healer
--		raid_point = cfg.raid_point_healer
--		raid_pos = cfg.raid_pos_healer
--	else
--		party_xoffset = cfg.party_xoffset
--		party_yoffset = cfg.party_yoffset
--		party_point = cfg.party_point
--		party_columnAnchorPoint = cfg.party_columnAnchorPoint
--		party_height = cfg.party_height
--		party_width = cfg.party_width
--		party_pos = cfg.party_pos
--		raid_xoffset = cfg.raid_xoffset
--		raid_yoffset = cfg.raid_yoffset
--		raid_point = cfg.raid_point
--		raid_pos = cfg.raid_pos
--	end

--	self:SetActiveStyle'Free - Party'

--	local party = self:SpawnHeader(nil, nil, 'solo,party',
--		'showParty', true,
--		'showPlayer', true,
--		'showSolo', false,
--		'xoffset', party_xoffset,
--		'yoffset', party_yoffset,
--		'maxColumns', 1,
--		'unitsperColumn', 5,
--		'columnSpacing', 0,
--		'point', party_point,
--		'columnAnchorPoint', party_columnAnchorPoint,
--		--'groupBy', 'ASSIGNEDROLE',
--		--'groupingOrder', 'TANK,HEALER,DAMAGER',
--		--'sortDir', 'DESC',
--		'oUF-initialConfigFunction', ([[
--			self:SetHeight(%d)
--			self:SetWidth(%d)
--		]]):format(party_height, party_width)
--	):SetPoint(unpack(party_pos))


--	self:SetActiveStyle'Free - Raid'

--	local raid = self:SpawnHeader(nil, nil, 'raid',
--		'showParty', false,
--		'showRaid', true,
--		'xoffset', raid_xoffset,
--		'yOffset', raid_yoffset,
--		'point', raid_point,
--		'groupFilter', cfg.raid_groupFilter,
--		'groupingOrder', '1,2,3,4,5,6,7,8',
--		'groupBy', 'GROUP',
--		'maxColumns', 8,
--		'unitsPerColumn', 5,
--		'columnSpacing', 4,
--		'columnAnchorPoint', 'TOP',
--		'sortMethod', 'INDEX',
--		'oUF-initialConfigFunction', ([[
--			self:SetHeight(%d)
--			self:SetWidth(%d)
--		]]):format(cfg.raid_height, cfg.raid_width)
--	):SetPoint(unpack(raid_pos))
--end)

function module:OnLogin()
	if not cfg.enable then return end
	oUF:RegisterStyle("Player", CreatePlayerStyle)
	oUF:RegisterStyle("Pet", CreatePetStyle)
	oUF:RegisterStyle("Target", CreateTargetStyle)
	oUF:RegisterStyle("ToT", CreateToTStyle)
	oUF:RegisterStyle("Focus", CreateFocusStyle)
	oUF:RegisterStyle("FoT", CreateFoTStyle)

	oUF:SetActiveStyle("Player")
	local player = oUF:Spawn("player", "oUF_Player")
	F.Mover(player, L['MOVER_UNITFRAME_PLAYER'], "PlayerUF", cfg.player_pos, cfg.player_width, cfg.player_height)

	oUF:SetActiveStyle("Pet")
	local pet = oUF:Spawn("pet", "oUF_Pet")
	F.Mover(pet, L['MOVER_UNITFRAME_PET'], "PetUF", cfg.pet_pos, cfg.pet_width, cfg.pet_height)

	oUF:SetActiveStyle("Target")
	local target = oUF:Spawn("target", "oUF_Target")
	F.Mover(target, L['MOVER_UNITFRAME_TARGET'], "TargetUF", cfg.target_pos, cfg.target_width, cfg.target_height)

	oUF:SetActiveStyle("ToT")
	local targettarget = oUF:Spawn("targettarget", "oUF_TargetTarget")
	F.Mover(targettarget, L['MOVER_UNITFRAME_TARGETTARGET'], "TotUF", cfg.targettarget_pos, cfg.targettarget_width, cfg.targettarget_height)

	oUF:SetActiveStyle("Focus")
	local focus = oUF:Spawn("focus", "oUF_Focus")
	F.Mover(focus, L['MOVER_UNITFRAME_FOCUS'], "FocusUF", cfg.focus_pos, cfg.focus_width, cfg.focus_height)

	oUF:SetActiveStyle("FoT")
	local focustarget = oUF:Spawn("focustarget", "oUF_FocusTarget")
	F.Mover(focustarget, L['MOVER_UNITFRAME_FOCUSTARGET'], "FotUF", cfg.focustarget_pos, cfg.focustarget_width, cfg.focustarget_height)

	
	if cfg.enableBoss then
		oUF:RegisterStyle("Boss", CreateBossStyle)
		oUF:SetActiveStyle("Boss")
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
			local width, height = boss[i]:GetWidth(), boss[i]:GetHeight()
			if i == 1 then
				boss[i].mover = F.Mover(boss[i], L["MOVER_UNITFRAME_BOSS"]..i, "Boss1", {"LEFT", UIParent, "CENTER", 520, -140}, width, height)
			else
				boss[i].mover = F.Mover(boss[i], L["MOVER_UNITFRAME_BOSS"]..i, "Boss"..i, {"BOTTOM", boss[i-1], "TOP", 0, 60}, width, height)
			end
		end
	end

	if cfg.enableArena then
		oUF:RegisterStyle("Arena", CreateArenaStyle)
		oUF:SetActiveStyle("Arena")
		local arena = {}
		for i = 1, 5 do
			arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
			local width, height = arena[i]:GetWidth(), arena[i]:GetHeight()
			if i == 1 then
				arena[i].mover = F.Mover(arena[i], L["MOVER_UNITFRAME_ARENA"]..i, "Arena1", {"RIGHT", UIParent, "CENTER", -520, -100}, width, height)
			else
				arena[i].mover = F.Mover(arena[i], L["MOVER_UNITFRAME_ARENA"]..i, "Arena"..i, {"BOTTOM", arena[i-1], "TOP", 0, 80}, width, height)
			end
		end
	end

	if cfg.enableGroup then
		module:HideBlizzRaidFrame()

		oUF:RegisterStyle("Party", CreatePartyStyle)
		oUF:SetActiveStyle("Party")

		local partyMover

		local party = oUF:SpawnHeader(nil, nil, 'solo,party',
			'showParty', true,
			'showPlayer', true,
			'showSolo', false,
			'xoffset', 6,
			'yoffset', 6,
			'maxColumns', 1,
			'unitsperColumn', 5,
			'columnSpacing', 0,
			"point", "BOTTOM",
			'columnAnchorPoint', 'LEFT',
			'groupBy', 'ASSIGNEDROLE',
			'groupingOrder', 'TANK,HEALER,DAMAGER',
			--'sortDir', 'DESC',
			'oUF-initialConfigFunction', ([[
				self:SetHeight(%d)
				self:SetWidth(%d)
			]]):format(cfg.party_height, cfg.party_width)
		)
		partyMover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], "PartyFrame", cfg.party_pos, cfg.party_width, cfg.party_height*5+20)
		party:ClearAllPoints()
		party:SetPoint("BOTTOMLEFT", partyMover)
	

		oUF:RegisterStyle("Raid", CreateRaidStyle)
		oUF:SetActiveStyle("Raid")

		local raidMover

		local function CreateRaid(name, i)
			local raid = oUF:SpawnHeader(name, nil, "raid",
			"showParty", false,
			"showRaid", true,
			"xoffset", 4,
			"yOffset", -4,
			"groupFilter", tostring(i),
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"sortMethod", "INDEX",
			"maxColumns", 1,
			"unitsPerColumn", 5,
			"columnSpacing", 4,
			"point", cfg.raid_horizon and "LEFT" or "TOP",
			"columnAnchorPoint", "RIGHT",
			"oUF-initialConfigFunction", ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
			]]):format(cfg.raid_height, cfg.raid_width))
			return raid
		end

		local groups = {}
		for i = 1, cfg.raid_numGroups do
			groups[i] = CreateRaid("oUF_Raid"..i, i)
			if i == 1 then
				if cfg.raid_horizon then
					raidMover = F.Mover(groups[i], L["MOVER_UNITFRAME_RAID"], "RaidFrame", cfg.raid_pos, cfg.raid_width*5+16, cfg.raid_height*cfg.raid_numGroups+(4*(cfg.raid_numGroups-1)))
					if cfg.raid_reverse then
						groups[i]:ClearAllPoints()
						groups[i]:SetPoint("BOTTOMLEFT", raidMover)
					end
				else
					raidMover = F.Mover(groups[i], L["MOVER_UNITFRAME_RAID"], "RaidFrame", cfg.raid_pos, cfg.raid_width*cfg.raid_numGroups+(4*(cfg.raid_numGroups-1)), cfg.raid_height*5+16)
					if cfg.raid_reverse then
						groups[i]:ClearAllPoints()
						groups[i]:SetPoint("TOPRIGHT", raidMover)
					end
				end
			else
				if cfg.raid_horizon then
					if cfg.raid_reverse then
						groups[i]:SetPoint("BOTTOMLEFT", groups[i-1], "TOPLEFT", 0, 4)
					else
						groups[i]:SetPoint("TOPLEFT", groups[i-1], "BOTTOMLEFT", 0, -4)
					end
				else
					if cfg.raid_reverse then
						groups[i]:SetPoint("TOPRIGHT", groups[i-1], "TOPLEFT", -4, 0)
					else
						groups[i]:SetPoint("TOPLEFT", groups[i-1], "TOPRIGHT", 4, 0)
					end
				end
			end
		end
	end

	self:TargetSound()
end