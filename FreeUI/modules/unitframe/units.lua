local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local oUF = FreeUI.oUF
local cfg = C.Unitframe


local function CreatePlayerStyle(self)
	self.unitStyle = 'player'
	self:SetSize(cfg.player_width, cfg.player_height)

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
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddPvPIndicator(self)
	UNITFRAME:AddCombatIndicator(self)
	UNITFRAME:AddRestingIndicator(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddGCDSpark(self)
	UNITFRAME:AddSwingSpark(self)
	UNITFRAME:AddFader(self)

	if C.MyClass == 'DEATHKNIGHT' then
		UNITFRAME:AddRunes(self)
	elseif C.MyClass == 'MONK' then
		UNITFRAME:AddStagger(self)
	elseif C.MyClass == 'SHAMAN' then
		UNITFRAME:AddTotems(self)
	else
		UNITFRAME:AddClassPower(self)
	end
end

function UNITFRAME:SpawnPlayer()
	oUF:RegisterStyle('Player', CreatePlayerStyle)
	oUF:SetActiveStyle('Player')

	local player = oUF:Spawn('player', 'oUF_Player')

	F.Mover(player, L['MOVER_UNITFRAME_PLAYER'], 'PlayerFrame', {"BOTTOM", UIParent, "BOTTOM", 0, 220}, player:GetWidth(), player:GetHeight())

	if not C.Actionbar.enable then return end
	FreeUI_LeaveVehicleBar:SetParent(player)
	FreeUI_LeaveVehicleButton:ClearAllPoints()
	FreeUI_LeaveVehicleButton:SetPoint('LEFT', player, 'RIGHT', 4, 0 )
	F.ReskinClose(FreeUI_LeaveVehicleButton)
	F.CreateSD(FreeUI_LeaveVehicleButton)
	FreeUI_LeaveVehicleButton:SetSize(player:GetHeight()+4, player:GetHeight()+4)
end

local function CreatePetStyle(self)
	self.unitStyle = 'pet'
	self:SetSize(cfg.pet_width, cfg.pet_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddFader(self)
end

function UNITFRAME:SpawnPet()
	oUF:RegisterStyle('Pet', CreatePetStyle)
	oUF:SetActiveStyle('Pet')

	local pet = oUF:Spawn('pet', 'oUF_Pet')

	F.Mover(pet, L['MOVER_UNITFRAME_PET'], 'PetFrame', {'RIGHT', 'oUF_Player', 'LEFT', -6, 0}, pet:GetWidth(), pet:GetHeight())
end

local playTargetSound = function(self, event)
    if event == "PLAYER_TARGET_CHANGED" then
        if (UnitExists(self.unit)) then
            if (UnitIsEnemy(self.unit, "player")) then
                PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
            elseif (UnitIsFriend("player", self.unit)) then
                PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
            else
                PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
            end
        else
            PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
        end
    end
end

local function CreateTargetStyle(self)
	self.unitStyle = 'target'
	self:SetSize(cfg.target_width, cfg.target_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerValueText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddQuestIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFader(self)

	self:RegisterEvent("PLAYER_TARGET_CHANGED", playTargetSound)
	self.Health:SetScript("OnShow", function()
        playTargetSound(self, "PLAYER_TARGET_CHANGED")
    end)
end

function UNITFRAME:SpawnTarget()
	oUF:RegisterStyle('Target', CreateTargetStyle)
	oUF:SetActiveStyle('Target')

	local target = oUF:Spawn('target', 'oUF_Target')

	F.Mover(target, L['MOVER_UNITFRAME_TARGET'], 'TargetFrame', {"LEFT", 'oUF_Player', "RIGHT", 60, 80}, target:GetWidth(), target:GetHeight())
end

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
	oUF:RegisterStyle('TargetTarget', CreateTargetTargetStyle)
	oUF:SetActiveStyle('TargetTarget')

	local targettarget = oUF:Spawn('targettarget', 'oUF_TargetTarget')

	F.Mover(targettarget, L['MOVER_UNITFRAME_TARGETTARGET'], 'TargetTargetFrame', {'LEFT', 'oUF_Target', 'RIGHT', 6, 0}, targettarget:GetWidth(), targettarget:GetHeight())
end

local playFocusSound = function(self, event)
	if event == "PLAYER_FOCUS_CHANGED" then
		if UnitExists(self.unit) then
			if UnitIsEnemy(self.unit, 'player') then
				PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
			elseif UnitIsFriend('player', self.unit) then
				PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
			else
				PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
			end
		else
			PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
		end
	end
end

local function CreateFocusStyle(self)
	self.unitStyle = 'focus'
	self:SetSize(cfg.focus_width, cfg.focus_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddNameText(self)
	UNITFRAME:AddCastBar(self)
	UNITFRAME:AddAuras(self)
	UNITFRAME:AddRaidTargetIndicator(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddFader(self)

	self:RegisterEvent("PLAYER_FOCUS_CHANGED", playFocusSound)
	self.Health:SetScript("OnShow", function()
        playFocusSound(self, "PLAYER_FOCUS_CHANGED")
    end)
end

function UNITFRAME:SpawnFocus()
	oUF:RegisterStyle('Focus', CreateFocusStyle)
	oUF:SetActiveStyle('Focus')

	local focus = oUF:Spawn('focus', 'oUF_Focus')

	F.Mover(focus, L['MOVER_UNITFRAME_FOCUS'], 'FocusFrame', {'TOPRIGHT', 'oUF_Player', 'TOPLEFT', -120, 0}, focus:GetWidth(), focus:GetHeight())
end

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
	oUF:RegisterStyle('FocusTarget', CreateFocusTargetStyle)
	oUF:SetActiveStyle('FocusTarget')

	local focustarget = oUF:Spawn('focustarget', 'oUF_FocusTarget')

	F.Mover(focustarget, L['MOVER_UNITFRAME_FOCUSTARGET'], 'FocusTargetFrame', {'TOPRIGHT', 'oUF_Focus', 'TOPLEFT', -6, 0}, focustarget:GetWidth(), focustarget:GetHeight())
end

local function CreateBossStyle(self)
	self.unitStyle = 'boss'
	self:SetSize(cfg.boss_width, cfg.boss_height)

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthValueText(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPowerValueText(self)
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
	oUF:SetActiveStyle('Boss')

	local boss = {}

	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn('boss'..i, 'oUF_Boss'..i)
		if i == 1 then
			boss[i].mover = F.Mover(boss[i], L['MOVER_UNITFRAME_BOSS'], 'BossFrame', {'LEFT', 'oUF_Target', 'RIGHT', 120, 160}, cfg.boss_width, cfg.boss_height)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, cfg.boss_gap)
		end
	end
end

local function CreateArenaStyle(self)
	self.unitStyle = 'arena'
	self:SetSize(cfg.arena_width, cfg.arena_height)

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
			arena[i].mover = F.Mover(arena[i], L['MOVER_UNITFRAME_ARENA'], 'ArenaFrame', {'RIGHT', 'oUF_Player', 'LEFT', -300, 300}, cfg.arena_width, cfg.arena_height)
		else
			arena[i]:SetPoint('BOTTOM', arena[i-1], 'TOP', 0, cfg.arena_gap)
		end
	end
end

local function CreatePartyStyle(self)
	self.unitStyle = 'party'

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddPortrait(self)
	UNITFRAME:AddGroupNameText(self)
	UNITFRAME:AddLeaderIndicator(self)
	UNITFRAME:AddBuffs(self)
	UNITFRAME:AddDebuffs(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)

	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)
	UNITFRAME:AddSummonIndicator(self)
	UNITFRAME:AddThreatIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
	UNITFRAME:AddCornerBuff(self)
	UNITFRAME:AddRaidDebuffs(self)
	UNITFRAME:AddDebuffHighlight(self)
end

function UNITFRAME:SpawnParty()
	oUF:RegisterStyle('Party', CreatePartyStyle)
	oUF:SetActiveStyle('Party')

	local mover
	local party = oUF:SpawnHeader('oUF_Party', nil, 'custom [@raid6,exists] hide;show',
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],

		"initial-width", cfg.party_width,
		"initial-height", cfg.party_height,

		'showParty', true,
		'showPlayer', cfg.groupShowPlayer,
		'showSolo', cfg.groupShowSolo,
		
		'xoffset', cfg.party_gap,
		'yoffset', cfg.party_gap,

		'point', 'BOTTOM',

		'groupBy', cfg.groupByRole and 'ASSIGNEDROLE',
		'groupingOrder', cfg.groupByRole and 'TANK,HEALER,DAMAGER,NONE')

	mover = F.Mover(party, L['MOVER_UNITFRAME_PARTY'], 'PartyFrame', {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60}, cfg.party_width, ((cfg.party_height * 5) + (cfg.party_gap * 4)))
	party:ClearAllPoints()
	party:SetPoint('BOTTOM', mover)
end

local function CreateRaidStyle(self)
	self.unitStyle = 'raid'

	UNITFRAME:AddBackDrop(self)
	UNITFRAME:AddHealthBar(self)
	UNITFRAME:AddHealthPrediction(self)
	UNITFRAME:AddPowerBar(self)
	UNITFRAME:AddGroupNameText(self)
	UNITFRAME:AddLeaderIndicator(self)
	--UNITFRAME:AddBuffs(self)
	--UNITFRAME:AddDebuffs(self)
	UNITFRAME:AddRangeCheck(self)
	UNITFRAME:AddRaidTargetIndicator(self)

	UNITFRAME:AddResurrectIndicator(self)
	UNITFRAME:AddReadyCheckIndicator(self)
	UNITFRAME:AddGroupRoleIndicator(self)
	UNITFRAME:AddPhaseIndicator(self)
	UNITFRAME:AddSummonIndicator(self)
	UNITFRAME:AddSelectedBorder(self)
	UNITFRAME:AddCornerBuff(self)
	UNITFRAME:AddRaidDebuffs(self)
	UNITFRAME:AddDebuffHighlight(self)
end

function UNITFRAME:SpawnRaid()
	oUF:RegisterStyle('Raid', CreateRaidStyle)
	oUF:SetActiveStyle('Raid')

	local mover
	local function CreateRaid(name, i)
		local raid = oUF:SpawnHeader(name, nil, 'custom [@raid6,exists] show;hide',
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", cfg.raid_width,
		"initial-height", cfg.raid_height,

		'showParty', true,
		'showRaid', true,

		'xoffset', (cfg.groupReverse and -cfg.raid_gap) or cfg.raid_gap,
		'yOffset', -cfg.raid_gap,

		'groupFilter', tostring(i),
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'sortMethod', 'INDEX',

		'columnAnchorPoint', cfg.groupReverse and 'RIGHT' or 'LEFT',
		'point', cfg.groupReverse and 'RIGHT' or 'LEFT')
		
		return raid
	end

	local groups = {}
	for i = 1, cfg.groupFilter do
		groups[i] = CreateRaid('oUF_Raid'..i, i)
		if i == 1 then
			mover = F.Mover(groups[i], L['MOVER_UNITFRAME_RAID'], 'RaidFrame', {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -10}, (cfg.raid_width * 5) + (cfg.raid_gap * 4), (cfg.raid_height * cfg.groupFilter) + cfg.raid_gap * (cfg.groupFilter - 1))
			groups[i]:ClearAllPoints()
			groups[i]:SetPoint((cfg.groupReverse and 'TOPRIGHT') or 'TOPLEFT', mover)
		else
			groups[i]:SetPoint((cfg.groupReverse and 'TOPRIGHT') or 'TOPLEFT', groups[i-1], (cfg.groupReverse and 'BOTTOMRIGHT') or 'BOTTOMLEFT', 0, -cfg.raid_gap)
		end
	end
end