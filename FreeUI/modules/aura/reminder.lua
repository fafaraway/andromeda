local F, C, L = unpack(select(2, ...))
local AURA = F:GetModule('AURA')


local pairs, tinsert, next = pairs, table.insert, next
local GetSpecialization, GetZonePVPInfo, GetItemCooldown = GetSpecialization, GetZonePVPInfo, GetItemCooldown
local UnitIsDeadOrGhost, UnitInVehicle, InCombatLockdown = UnitIsDeadOrGhost, UnitInVehicle, InCombatLockdown
local IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture = IsInInstance, IsPlayerSpell, UnitBuff, GetSpellTexture
local GetWeaponEnchantInfo = GetWeaponEnchantInfo

local groups = C.ReminderBuffsList[C.MyClass]
local iconSize = 36
local frames, parentFrame = {}

function AURA:Reminder_Update(cfg)
	local frame = cfg.frame
	local depend = cfg.depend
	local spec = cfg.spec
	local combat = cfg.combat
	local instance = cfg.instance
	local pvp = cfg.pvp
	local cooldown = cfg.cooldown
	local isPlayerSpell, isRightSpec, isInCombat, isInInst, isInPVP = true, true
	local inInst, instType = IsInInstance()
	local weaponIndex = cfg.weaponIndex

	if cooldown and GetItemCooldown(cooldown) > 0 then -- check rune cooldown
		frame:Hide()
		return
	end

	if depend and not IsPlayerSpell(depend) then isPlayerSpell = false end
	if spec and spec ~= GetSpecialization() then isRightSpec = false end
	if combat and InCombatLockdown() then isInCombat = true end
	if instance and inInst and (instType == 'scenario' or instType == 'party' or instType == 'raid') then isInInst = true end
	if pvp and (instType == 'arena' or instType == 'pvp' or GetZonePVPInfo() == 'combat') then isInPVP = true end
	if not combat and not instance and not pvp then isInCombat, isInInst, isInPVP = true, true, true end

	frame:Hide()
	if isPlayerSpell and isRightSpec and (isInCombat or isInInst or isInPVP) and not UnitInVehicle('player') and not UnitIsDeadOrGhost('player') then
		if weaponIndex then
			local hasMainHandEnchant, _, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()
			if (hasMainHandEnchant and weaponIndex == 1) or (hasOffHandEnchant and weaponIndex == 2) then
				frame:Hide()
				return
			end
		else
			for i = 1, 32 do
				local name, _, _, _, _, _, _, _, _, spellID = UnitBuff('player', i)
				if not name then break end
				if name and cfg.spells[spellID] then
					frame:Hide()
					return
				end
			end
		end
		frame:Show()
	end
end

function AURA:Reminder_Create(cfg)
	local frame = CreateFrame('Frame', nil, parentFrame)
	frame:SetSize(iconSize, iconSize)
	F.PixelIcon(frame)
	F.CreateSD(frame)
	local texture = cfg.texture
	if frame.__shadow then
		frame.__shadow:SetBackdropBorderColor(1, 0, 0, .35)
	end
	if not texture then
		for spellID in pairs(cfg.spells) do
			texture = GetSpellTexture(spellID)
			break
		end
	end
	frame.Icon:SetTexture(texture)
	frame.text = F.CreateFS(frame, C.Assets.Fonts.Regular, 12, nil, L['AURA_LACK'], 'RED', 'THICK', 'TOP', 1, 15)
	frame:Hide()
	cfg.frame = frame

	tinsert(frames, frame)
end

function AURA:Reminder_UpdateAnchor()
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

function AURA:Reminder_OnEvent()
	for _, cfg in pairs(groups) do
		if not cfg.frame then AURA:Reminder_Create(cfg) end
		AURA:Reminder_Update(cfg)
	end
	AURA:Reminder_UpdateAnchor()
end

function AURA:Reminder_AddRune()
	if GetItemCount(174906) == 0 then return end
	if not groups then groups = {} end
	tinsert(groups, {
		spells = {
			[317065] = true,
			[270058] = true,
		},
		texture = 839983,
		cooldown = 174906,
		instance = true,
	})
end

function AURA:InitReminder()
	--AURA:Reminder_AddRune()
	if not groups then return end

	if C.DB.aura.reminder then
		if not parentFrame then
			parentFrame = CreateFrame('Frame', nil, UIParent)
			parentFrame:SetPoint('TOP', 0, -100)
			parentFrame:SetSize(iconSize, iconSize)
		end
		parentFrame:Show()

		AURA:Reminder_OnEvent()
		F:RegisterEvent('UNIT_AURA', AURA.Reminder_OnEvent, 'player')
		F:RegisterEvent('UNIT_EXITED_VEHICLE', AURA.Reminder_OnEvent)
		F:RegisterEvent('UNIT_ENTERED_VEHICLE', AURA.Reminder_OnEvent)
		F:RegisterEvent('PLAYER_REGEN_ENABLED', AURA.Reminder_OnEvent)
		F:RegisterEvent('PLAYER_REGEN_DISABLED', AURA.Reminder_OnEvent)
		F:RegisterEvent('ZONE_CHANGED_NEW_AREA', AURA.Reminder_OnEvent)
		F:RegisterEvent('PLAYER_ENTERING_WORLD', AURA.Reminder_OnEvent)
	else
		if parentFrame then
			parentFrame:Hide()
			F:UnregisterEvent('UNIT_AURA', AURA.Reminder_OnEvent)
			F:UnregisterEvent('UNIT_EXITED_VEHICLE', AURA.Reminder_OnEvent)
			F:UnregisterEvent('UNIT_ENTERED_VEHICLE', AURA.Reminder_OnEvent)
			F:UnregisterEvent('PLAYER_REGEN_ENABLED', AURA.Reminder_OnEvent)
			F:UnregisterEvent('PLAYER_REGEN_DISABLED', AURA.Reminder_OnEvent)
			F:UnregisterEvent('ZONE_CHANGED_NEW_AREA', AURA.Reminder_OnEvent)
			F:UnregisterEvent('PLAYER_ENTERING_WORLD', AURA.Reminder_OnEvent)
		end
	end
end
