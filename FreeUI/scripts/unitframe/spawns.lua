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
	module:CreateDispellable(self, unit)
	if (C.Class == 'DEATHKNIGHT') then
		module:CreateRunesBar(self)
	else
		module:CreateClassPower(self)
	end

	if C.actionbar.enable then
		FreeUI_LeaveVehicleButton:SetPoint('LEFT', self, 'RIGHT', 5, 0)
	end
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
	--module:CreateNameColour(self)
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
	--module:CreateNameColour(self)
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
			--local width, height = boss[i]:GetWidth(), boss[i]:GetHeight()
			if i == 1 then
				boss[i].mover = F.Mover(boss[i], L["MOVER_UNITFRAME_BOSS"], "BossFrame", cfg.boss_pos, cfg.boss_width, cfg.boss_height)
			else
				--boss[i].mover = F.Mover(boss[i], L["MOVER_UNITFRAME_BOSS"]..i, "Boss"..i, {"BOTTOM", boss[i-1], "TOP", 0, 60}, width, height)
				boss[i]:SetPoint("BOTTOM", boss[i-1], "TOP", 0, cfg.boss_padding)
			end
		end
	end

	if cfg.enableArena then
		oUF:RegisterStyle("Arena", CreateArenaStyle)
		oUF:SetActiveStyle("Arena")
		local arena = {}
		for i = 1, 5 do
			arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
			arena[i]:SetAttribute('oUF-enableArenaPrep', false)
			--local width, height = arena[i]:GetWidth(), arena[i]:GetHeight()
			if i == 1 then
				arena[i].mover = F.Mover(arena[i], L["MOVER_UNITFRAME_ARENA"], "ArenaFrame", cfg.arena_pos, cfg.arena_width, cfg.arena_height)
			else
				--arena[i].mover = F.Mover(arena[i], L["MOVER_UNITFRAME_ARENA"]..i, "Arena"..i, {"BOTTOM", arena[i-1], "TOP", 0, 80}, width, height)
				arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, cfg.arena_padding)
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
			'xoffset', cfg.party_reverse and -cfg.party_padding or cfg.party_padding,
			'yoffset', cfg.party_reverse and cfg.party_padding or -cfg.party_padding,
			'maxColumns', 1,
			'unitsperColumn', 5,
			'columnSpacing', 0,
			"point", cfg.party_horizon and "RIGHT" or cfg.party_horizon and cfg.party_reverse and "LEFT" or not cfg.party_horizon and "BOTTOM" or not cfg.party_horizon and cfg.party_reverse and "TOP",
			'columnAnchorPoint', 'LEFT',
			'groupBy', 'ASSIGNEDROLE',
			'groupingOrder', 'TANK,HEALER,DAMAGER',
			--'sortDir', 'DESC',
			'oUF-initialConfigFunction', ([[
				self:SetHeight(%d)
				self:SetWidth(%d)
			]]):format(cfg.party_height, cfg.party_width)
		)

		--for i = 1, 5 do
		--	party[i] = "oUF_Party"..i


		if cfg.party_horizon then
			partyMover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], "PartyFrame", cfg.party_pos, cfg.party_width*5+cfg.party_padding*4, cfg.party_height)
			if cfg.party_reverse then
				party:ClearAllPoints()
				party:SetPoint("RIGHT", partyMover)
			else
				party:ClearAllPoints()
				party:SetPoint("LEFT", partyMover)
			end
		else
			partyMover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], "PartyFrame", cfg.party_pos, cfg.party_width, cfg.party_height*5+cfg.party_padding*4)
			if cfg.party_reverse then
				party:ClearAllPoints()
				party:SetPoint("BOTTOM", partyMover)
			else
				party:ClearAllPoints()
				party:SetPoint("TOP", partyMover)
			end
		end

		
	

		oUF:RegisterStyle("Raid", CreateRaidStyle)
		oUF:SetActiveStyle("Raid")

		local raidMover

		local function CreateRaid(name, i)
			local raid = oUF:SpawnHeader(name, nil, "raid",
			"showParty", false,
			"showRaid", true,
			"xoffset", cfg.raid_padding,
			"yOffset", cfg.raid_padding,
			"groupFilter", tostring(i),
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"sortMethod", "INDEX",
			"maxColumns", 1,
			"unitsPerColumn", 5,
			"columnSpacing", 0,
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
					raidMover = F.Mover(groups[i], L["MOVER_UNITFRAME_RAID"], "RaidFrame", cfg.raid_pos, cfg.raid_width*5+cfg.raid_padding*4, cfg.raid_height*cfg.raid_numGroups+(cfg.raid_padding*(cfg.raid_numGroups-1)))
					if cfg.raid_reverse then
						groups[i]:ClearAllPoints()
						groups[i]:SetPoint("BOTTOMLEFT", raidMover)
					end
				else
					raidMover = F.Mover(groups[i], L["MOVER_UNITFRAME_RAID"], "RaidFrame", cfg.raid_pos, cfg.raid_width*cfg.raid_numGroups+(cfg.raid_padding*(cfg.raid_numGroups-1)), cfg.raid_height*5+cfg.raid_padding*4)
					if cfg.raid_reverse then
						groups[i]:ClearAllPoints()
						groups[i]:SetPoint("TOPRIGHT", raidMover)
					end
				end
			else
				if cfg.raid_horizon then
					if cfg.raid_reverse then
						groups[i]:SetPoint("BOTTOMLEFT", groups[i-1], "TOPLEFT", 0, cfg.raid_padding)
					else
						groups[i]:SetPoint("TOPLEFT", groups[i-1], "BOTTOMLEFT", 0, -cfg.raid_padding)
					end
				else
					if cfg.raid_reverse then
						groups[i]:SetPoint("TOPRIGHT", groups[i-1], "TOPLEFT", -cfg.raid_padding, 0)
					else
						groups[i]:SetPoint("TOPLEFT", groups[i-1], "TOPRIGHT", cfg.raid_padding, 0)
					end
				end
			end
		end
	end

	self:TargetSound()
end