local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Aura')

module.BuffsList = {
	MAGE = {
		{	spells = {	-- 奥术魔宠
				[210126] = true,
			},
			depend = 205022,
			spec = 1,
			combat = true,
			instance = false,
			pvp = true,
		},
		{	spells = {	-- 奥术智慧
				[1459] = true,
			},
			depend = 1459,
			instance = false,
		},
	},
	PRIEST = {
		{	spells = {	-- 真言术耐
				[21562] = true,
			},
			depend = 21562,
			instance = false,
		},
	},
	WARRIOR = {
		{	spells = {	-- 战斗怒吼
				[6673] = true,
			},
			depend = 6673,
			instance = false,
		},
	},
	SHAMAN = {
		{	spells = {	-- 闪电之盾
				[192106] = true,
			},
			depend = 192106,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	ROGUE = {
		{	spells = {	-- 伤害类毒药
				[2823] = true,		-- 致命药膏
				[8679] = true,		-- 致伤药膏
			},
			spec = 1,
			combat = true,
			instance = false,
			pvp = true,
		},
		{	spells = {	-- 效果类毒药
				[3408] = true,		-- 减速药膏
			},
			spec = 1,
			pvp = true,
		},
	},
}

local groups = module.BuffsList[C.Class]
local iconSize = 48
local frames, parentFrame = {}
local pairs, tinsert = pairs, table.insert

local function UpdateMissingBuffs(cfg)
	local frame = cfg.frame
	local depend = cfg.depend
	local spec = cfg.spec
	local combat = cfg.combat
	local instance = cfg.instance
	local pvp = cfg.pvp
	local isPlayerSpell, isRightSpec, isInCombat, isInInst, isInPVP = true, true
	local inInst, instType = IsInInstance()

	if depend and not IsPlayerSpell(depend) then isPlayerSpell = false end
	if spec and spec ~= GetSpecialization() then isRightSpec = false end
	if combat and InCombatLockdown() then isInCombat = true end
	if instance and inInst and (instType == 'scenario' or instType == 'party' or instType == 'raid') then isInInst = true end
	if pvp and (instType == 'arena' or instType == 'pvp' or GetZonePVPInfo() == 'combat') then isInPVP = true end
	if not combat and not instance and not pvp then isInCombat, isInInst, isInPVP = true, true, true end

	frame:Hide()
	if isPlayerSpell and isRightSpec and (isInCombat or isInInst or isInPVP) and not UnitInVehicle('player') then
		for i = 1, 32 do
			local name, _, _, _, _, _, _, _, _, spellID = UnitBuff('player', i)
			if not name then break end
			if name and cfg.spells[spellID] then
				frame:Hide()
				return
			end
		end
		frame:Show()
	end
end

local function AddMissingBuffs(cfg)
	local frame = CreateFrame('Frame', nil, parentFrame)
	frame:SetSize(iconSize, iconSize)
	F.PixelIcon(frame)
	frame.glow = F.CreateSD(frame, .5, 3, 3)
	if frame.glow then
		frame.glow:SetBackdropBorderColor(1, 1, 1)
	end
	for spell in pairs(cfg.spells) do
		frame.Icon:SetTexture(GetSpellTexture(spell))
		break
	end
	frame.text = F.CreateFS(frame, {C.font.normal, 12}, L['MISSING_BUFF'], nil, nil, true, 'TOP', 1, 15)
	frame:Hide()
	cfg.frame = frame

	tinsert(frames, frame)
end

local function UpdateAnchor()
	local index = 0
	local offset = iconSize + 5
	for _, frame in next, frames do
		if frame:IsShown() then
			frame:SetPoint('LEFT', offset * index, 0)
			index = index + 1
		end
	end
	parentFrame:SetWidth(offset * index)
end

local function UpdateEvent()
	for _, cfg in pairs(groups) do
		if not cfg.frame then AddMissingBuffs(cfg) end
		UpdateMissingBuffs(cfg)
	end
	UpdateAnchor()
end

function module:MissingBuff()
	if not groups then return end
	if not C.general.missingBuffs then return end

	parentFrame = CreateFrame('Frame', nil, UIParent)
	parentFrame:SetPoint('TOP', 0, -100)
	parentFrame:SetSize(iconSize, iconSize)

	F:RegisterEvent('UNIT_AURA', UpdateEvent, 'player')
	F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateEvent)
	F:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateEvent)
	F:RegisterEvent('PLAYER_REGEN_DISABLED', UpdateEvent)
	F:RegisterEvent('ZONE_CHANGED_NEW_AREA', UpdateEvent)
	F:RegisterEvent('UNIT_ENTERED_VEHICLE', UpdateEvent)
	F:RegisterEvent('UNIT_EXITED_VEHICLE', UpdateEvent)
end