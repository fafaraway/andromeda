local F, C, L = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME
local oUF = F.oUF

local function tagsOnEnter(self)
	self.HealthValue:Show()
	self.PowerValue:Show()
end

local function tagsOnLeave(self)
	self.HealthValue:Hide()
	self.PowerValue:Hide()
end

local function CreatePlayerStyle(self)
	self.unitStyle = 'player'
	self:SetSize(C.DB.unitframe.player_width, C.DB.unitframe.player_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPowerValueText(self)
	UNITFRAME:AddAlternativePowerBar(self)
	UNITFRAME:AddAlternativePowerValueText(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddCombatIndicator(self)
	UNITFRAME:AddRestingIndicator(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddGCDSpark(self)
	UNITFRAME:AddCombatFader(self)
	UNITFRAME:AddClassPowerBar(self)
	UNITFRAME:AddStagger(self)
	UNITFRAME:AddTotems(self)
end

function UNITFRAME:SpawnPlayer()
	oUF:RegisterStyle('Player', CreatePlayerStyle)
	oUF:SetActiveStyle 'Player'
	local player = oUF:Spawn('player', 'oUF_Player')
	if C.DB.unitframe.player_hide_tags then
		player.HealthValue:Hide()
		player.PowerValue:Hide()
		player:HookScript('OnEnter', tagsOnEnter)
		player:HookScript('OnLeave', tagsOnLeave)
	end
	F.Mover(
		player,
		L['UNITFRAME_MOVER_PLAYER'],
		'PlayerFrame',
		{
			'BOTTOM',
			_G.UIParent,
			'BOTTOM',
			0,
			220
		},
		player:GetWidth(),
		player:GetHeight()
	)
	if C.DB.actionbar.actionbar then
		if C.DB.unitframe.fade then
			return
		end
		FreeUI_LeaveVehicleBar:SetParent(player)
		FreeUI_LeaveVehicleButton:ClearAllPoints()
		FreeUI_LeaveVehicleButton:SetPoint('LEFT', player, 'RIGHT', 4, 0)
		F.ReskinClose(FreeUI_LeaveVehicleButton)
		F.CreateSD(FreeUI_LeaveVehicleButton)
		FreeUI_LeaveVehicleButton:SetSize(player:GetHeight() + 4, player:GetHeight() + 4)
	end
end

local function CreatePetStyle(self)
	self.unitStyle = 'pet'
	self:SetSize(C.DB.unitframe.pet_width, C.DB.unitframe.pet_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
end

function UNITFRAME:SpawnPet()
	oUF:RegisterStyle('Pet', CreatePetStyle)
	oUF:SetActiveStyle 'Pet'
	local pet = oUF:Spawn('pet', 'oUF_Pet')
	F.Mover(
		pet,
		L['UNITFRAME_MOVER_PET'],
		'PetFrame',
		{
			'RIGHT',
			'oUF_Player',
			'LEFT',
			-6,
			0
		},
		pet:GetWidth(),
		pet:GetHeight()
	)
end

local function targetSound(self, event)
	if event == 'PLAYER_TARGET_CHANGED' then
		if UnitExists(self.unit) then
			if UnitIsEnemy(self.unit, 'player') then
				PlaySound(_G.SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
			elseif UnitIsFriend('player', self.unit) then
				PlaySound(_G.SOUNDKIT.IG_CHARACTER_NPC_SELECT)
			else
				PlaySound(_G.SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
			end
		else
			PlaySound(_G.SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
		end
	end
end

local function CreateTargetStyle(self)
	self.unitStyle = 'target'
	self:SetSize(C.DB.unitframe.target_width, C.DB.unitframe.target_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', targetSound)
	self.Health:SetScript(
		'OnShow',
		function()
			targetSound(self, 'PLAYER_TARGET_CHANGED')
		end
	)
end

function UNITFRAME:SpawnTarget()
	oUF:RegisterStyle('Target', CreateTargetStyle)
	oUF:SetActiveStyle 'Target'
	local target = oUF:Spawn('target', 'oUF_Target')
	F.Mover(
		target,
		L['UNITFRAME_MOVER_TARGET'],
		'TargetFrame',
		{
			'BOTTOM',
			_G.UIParent,
			'BOTTOM',
			170,
			300
		},
		target:GetWidth(),
		target:GetHeight()
	)
end

local function CreateTargetTargetStyle(self)
	self.unitStyle = 'targettarget'
	self:SetSize(C.DB.unitframe.target_target_width, C.DB.unitframe.target_target_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
end

function UNITFRAME:SpawnTargetTarget()
	oUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)
	oUF:SetActiveStyle 'TargetTarget'
	local targettarget = oUF:Spawn('targettarget', 'oUF_TargetTarget')
	F.Mover(
		targettarget,
		L['UNITFRAME_MOVER_TARGETTARGET'],
		'TargetTargetFrame',
		{
			'LEFT',
			'oUF_Target',
			'RIGHT',
			6,
			0
		},
		targettarget:GetWidth(),
		targettarget:GetHeight()
	)
end

local function focusSound(self, event)
	if event == 'PLAYER_FOCUS_CHANGED' then
		if UnitExists(self.unit) then
			if UnitIsEnemy(self.unit, 'player') then
				PlaySound(_G.SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
			elseif UnitIsFriend('player', self.unit) then
				PlaySound(_G.SOUNDKIT.IG_CHARACTER_NPC_SELECT)
			else
				PlaySound(_G.SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
			end
		else
			PlaySound(_G.SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
		end
	end
end

local function CreateFocusStyle(self)
	self.unitStyle = 'focus'
	self:SetSize(C.DB.unitframe.focus_width, C.DB.unitframe.focus_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', focusSound)
	self.Health:SetScript(
		'OnShow',
		function()
			focusSound(self, 'PLAYER_FOCUS_CHANGED')
		end
	)
end

function UNITFRAME:SpawnFocus()
	oUF:RegisterStyle('Focus', CreateFocusStyle)
	oUF:SetActiveStyle 'Focus'
	local focus = oUF:Spawn('focus', 'oUF_Focus')
	F.Mover(
		focus,
		L['UNITFRAME_MOVER_FOCUS'],
		'FocusFrame',
		{
			'BOTTOM',
			_G.UIParent,
			'BOTTOM',
			-200,
			220
		},
		focus:GetWidth(),
		focus:GetHeight()
	)
end

local function CreateFocusTargetStyle(self)
	self.unitStyle = 'focustarget'
	self:SetSize(C.DB.unitframe.focus_target_width, C.DB.unitframe.focus_target_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
end

function UNITFRAME:SpawnFocusTarget()
	oUF:RegisterStyle('FocusTarget', CreateFocusTargetStyle)
	oUF:SetActiveStyle 'FocusTarget'
	local focustarget = oUF:Spawn('focustarget', 'oUF_FocusTarget')
	F.Mover(
		focustarget,
		L['UNITFRAME_MOVER_FOCUSTARGET'],
		'FocusTargetFrame',
		{
			'TOPRIGHT',
			'oUF_Focus',
			'TOPLEFT',
			-6,
			0
		},
		focustarget:GetWidth(),
		focustarget:GetHeight()
	)
end

local function CreateBossStyle(self)
	self.unitStyle = 'boss'
	self:SetSize(C.DB.unitframe.boss_width, C.DB.unitframe.boss_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerBar(self)
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
	oUF:SetActiveStyle 'Boss'
	local boss = {}
	for i = 1, _G.MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn('boss' .. i, 'oUF_Boss' .. i)
		if i == 1 then
			boss[i].mover =
				F.Mover(
				boss[i],
				L['UNITFRAME_MOVER_BOSS'],
				'BossFrame',
				{
					'LEFT',
					'oUF_Target',
					'RIGHT',
					150,
					120
				},
				C.DB.unitframe.boss_width,
				C.DB.unitframe.boss_height
			)
		else
			boss[i]:SetPoint('BOTTOM', boss[i - 1], 'TOP', 0, C.DB.unitframe.boss_gap)
		end
	end
end

local function CreateArenaStyle(self)
	self.unitStyle = 'arena'
	self:SetSize(C.DB.unitframe.arena_width, C.DB.unitframe.arena_height)
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddCastBar(self)
	-- UNITFRAME:AddAuras(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddSelectedBorder(self)
end

function UNITFRAME:SpawnArena()
	oUF:RegisterStyle('Arena', CreateArenaStyle)
	oUF:SetActiveStyle 'Arena'
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn('arena' .. i, 'oUF_Arena' .. i)
		if i == 1 then
			arena[i].mover =
				F.Mover(
				arena[i],
				L['UNITFRAME_MOVER_ARENA'],
				'ArenaFrame',
				{
					'RIGHT',
					'oUF_Player',
					'LEFT',
					-300,
					300
				},
				C.DB.unitframe.arena_width,
				C.DB.unitframe.arena_height
			)
		else
			arena[i]:SetPoint('BOTTOM', arena[i - 1], 'TOP', 0, C.DB.unitframe.arena_gap)
		end
	end
end

local function CreatePartyStyle(self)
	self.unitStyle = 'party'
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHighlight(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddGroupNameText(self)
	UNITFRAME:AddLeaderIndicator(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)
	UNITFRAME:AddSummonIndicator(self)
	UNITFRAME:AddThreatIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddCornerBuffs(self)
	UNITFRAME:AddRaidDebuffs(self)
	UNITFRAME:AddDebuffHighlight(self)
	UNITFRAME:AddPartySpells(self)
end

function UNITFRAME:SpawnParty()
	oUF:RegisterStyle('Party', CreatePartyStyle)
	oUF:SetActiveStyle 'Party'
	local partyWidth, partyHeight = C.DB.unitframe.party_width, C.DB.unitframe.party_height
	local partyHorizon = C.DB.unitframe.party_horizon
	local partyReverse = C.DB.unitframe.party_reverse
	local partyGap = C.DB.unitframe.party_gap
	local showSolo = C.DB.unitframe.show_solo
	local groupingOrder = partyHorizon and 'TANK,HEALER,DAMAGER,NONE' or 'NONE,DAMAGER,HEALER,TANK'
	local moverWidth = partyHorizon and partyWidth * 5 + partyGap * 4 or partyWidth
	local moverHeight = partyHorizon and partyHeight or partyHeight * 5 + partyGap * 4
	local partyMover
	local party =
		oUF:SpawnHeader(
		'oUF_Party',
		nil,
		'solo,party',
		'showPlayer',
		true,
		'showSolo',
		showSolo,
		'showParty',
		true,
		'showRaid',
		false,
		'xoffset',
		partyGap,
		'yoffset',
		partyGap,
		'point',
		partyHorizon and 'LEFT' or 'BOTTOM',
		'groupingOrder',
		groupingOrder,
		'groupBy',
		'ASSIGNEDROLE',
		'sortMethod',
		'NAME',
		'oUF-initialConfigFunction',
		([[

			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(partyWidth, partyHeight)
	)
	partyMover =
		F.Mover(
		party,
		L['UNITFRAME_MOVER_PARTY'],
		'PartyFrame',
		{
			'BOTTOMRIGHT',
			'oUF_Player',
			'TOPLEFT',
			-100,
			60
		},
		moverWidth,
		moverHeight
	)
	party:ClearAllPoints()
	party:SetPoint('BOTTOMLEFT', partyMover)
end

local function CreateRaidStyle(self)
	self.unitStyle = 'raid'
	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHighlight(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddGroupNameText(self)
	UNITFRAME:AddLeaderIndicator(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)
	UNITFRAME:AddSummonIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddCornerBuffs(self)
	UNITFRAME:AddRaidDebuffs(self)
	UNITFRAME:AddDebuffHighlight(self)
end

function UNITFRAME:SpawnRaid()
	oUF:RegisterStyle('Raid', CreateRaidStyle)
	oUF:SetActiveStyle 'Raid'
	local raidWidth, raidHeight = C.DB.unitframe.raid_width, C.DB.unitframe.raid_height
	local raidHorizon = C.DB.unitframe.raid_horizon
	local raidReverse = C.DB.unitframe.raid_reverse
	local raidGap = C.DB.unitframe.raid_gap
	local showSolo = C.DB.unitframe.show_solo
	local numGroups = C.DB.unitframe.group_filter
	local raidMover

	local function CreateRaid(name, i)
		local raid =
			oUF:SpawnHeader(
			name,
			nil,
			'solo,raid',
			'showPlayer',
			true,
			'showSolo',
			showSolo,
			'showParty',
			true,
			'showRaid',
			true,
			'xoffset',
			raidGap,
			'yOffset',
			-raidGap,
			'groupFilter',
			tostring(i),
			'groupingOrder',
			'1,2,3,4,5,6,7,8',
			'groupBy',
			'GROUP',
			'sortMethod',
			'INDEX',
			'maxColumns',
			1,
			'unitsPerColumn',
			5,
			'columnSpacing',
			raidGap,
			'point',
			raidHorizon and 'LEFT' or 'TOP',
			'columnAnchorPoint',
			'LEFT',
			'oUF-initialConfigFunction',
			([[

			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(raidWidth, raidHeight)
		)
		return raid
	end

	local groups = {}
	for i = 1, numGroups do
		groups[i] = CreateRaid('oUF_Raid' .. i, i)
		if i == 1 then
			if raidHorizon then
				raidMover =
					F.Mover(
					groups[i],
					L['UNITFRAME_MOVER_RAID'],
					'RaidFrame',
					{
						'TOPLEFT',
						'oUF_Target',
						'BOTTOMLEFT',
						0,
						-10
					},
					(raidWidth + raidGap) * 5 - raidGap,
					(raidHeight + raidGap) * numGroups - raidGap
				)
				if raidReverse then
					groups[i]:ClearAllPoints()
					groups[i]:SetPoint('BOTTOMLEFT', raidMover)
				end
			else
				raidMover =
					F.Mover(
					groups[i],
					L['UNITFRAME_MOVER_RAID'],
					'RaidFrame',
					{
						'TOPLEFT',
						'oUF_Target',
						'BOTTOMLEFT',
						0,
						-10
					},
					(raidWidth + raidGap) * numGroups - raidGap,
					(raidHeight + raidGap) * 5 - raidGap
				)
				if raidReverse then
					groups[i]:ClearAllPoints()
					groups[i]:SetPoint('TOPRIGHT', raidMover)
				end
			end
		else
			if raidHorizon then
				if raidReverse then
					groups[i]:SetPoint('BOTTOMLEFT', groups[i - 1], 'TOPLEFT', 0, raidGap)
				else
					groups[i]:SetPoint('TOPLEFT', groups[i - 1], 'BOTTOMLEFT', 0, -raidGap)
				end
			else
				if raidReverse then
					groups[i]:SetPoint('TOPRIGHT', groups[i - 1], 'TOPLEFT', -raidGap, 0)
				else
					groups[i]:SetPoint('TOPLEFT', groups[i - 1], 'TOPRIGHT', raidGap, 0)
				end
			end
		end
	end
	UNITFRAME.RaidMover = raidMover
end
