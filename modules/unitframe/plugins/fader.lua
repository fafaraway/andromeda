local F, C = unpack(select(2, ...))
local oUF = F.oUF


local _, powerToken = _G.UnitPowerType('player')
local reversePowers = {
	['RAGE'] = true,
	['RUNIC_POWER'] = true,
	['POWER_TYPE_SUN_POWER'] = true,
	['LUNAR_POWER'] = true,
	['INSANITY'] = true,
	['MAELSTROM'] = true,
	['FURY'] = true,
	['PAIN'] = true,
}

local function isPowerRested(token)
	if reversePowers[token] then
		return _G.UnitPower('player') == 0
	else
		return _G.UnitPower('player') == _G.UnitPowerMax('player')
	end
end

local unitList = {
	['player'] = true,
	['pet'] = true,
	['target'] = true,
	['targettarget'] = true,
	['focus'] = true,
	['focustarget'] = true,
}

local function flush(self)
	wipe(self.Fader)
end


local function Update(self)
	local unit = self.unit
	local element = self.Fader

	if
		(element.arena and (GetZonePVPInfo() == 'arena')) or
		(element.instance and (IsInInstance() == true)) or
		(element.combat and UnitAffectingCombat(unit)) or
		(element.target and UnitExists('target')) or
		(element.casting and (UnitCastingInfo(unit) or UnitChannelInfo(unit))) or
		(element.injured and (UnitHealth(unit) < UnitHealthMax(unit)) and not UnitIsDead(unit) and not UnitIsGhost(unit)) or
		(element.mana and (powerToken == 'MANA' and (UnitPower('player') ~= UnitPowerMax('player')))) or
		(element.power and (not isPowerRested(powerToken))) or
		(element.hover and GetMouseFocus() == self)
	then
		F:UIFrameFadeIn(self, element.inDuration, self:GetAlpha(), element.maxAlpha or 1)

		if _G.oUF_Pet then
			F:UIFrameFadeIn(_G.oUF_Pet, element.inDuration, self:GetAlpha(), element.maxAlpha or 1)
		end
	else
		F:UIFrameFadeOut(self, element.outDuration, self:GetAlpha(), element.minAlpha or 0)

		if _G.oUF_Pet then
			F:UIFrameFadeOut(_G.oUF_Pet, element.outDuration, self:GetAlpha(), element.minAlpha or 0)
		end
	end
end

local function Path(self, ...)
	return (self.Fader.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.Fader
	if not element then return end

	element.__owner = self
	element.ForceUpdate = ForceUpdate

	if unitList[unit] then
		if element.hover then
			self:HookScript('OnEnter', Path)
			self:HookScript('OnLeave', Path)
		end

		if element.arena or element.instance then
			self:RegisterEvent('PLAYER_ENTERING_WORLD', Path, true)
			self:RegisterEvent('ZONE_CHANGED_NEW_AREA', Path, true)
		end

		if element.combat then
			self:RegisterEvent('PLAYER_REGEN_ENABLED', Path, true)
			self:RegisterEvent('PLAYER_REGEN_DISABLED', Path, true)
		end

		if element.target then
			self:HookScript('OnShow', Path)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', Path, true)
		end

		if element.injured then
			self:RegisterEvent('UNIT_HEALTH', Path, true)
			self:RegisterEvent('UNIT_MAXHEALTH', Path, true)
		end

		if element.mana or element.power then
			self:RegisterEvent('UNIT_POWER_UPDATE', Path, true)
		end

		if element.casting then
			self:RegisterEvent('UNIT_SPELLCAST_START', Path, true)
			self:RegisterEvent('UNIT_SPELLCAST_FAILED', Path, true)
			self:RegisterEvent('UNIT_SPELLCAST_STOP', Path, true)
			self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED', Path, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START', Path, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', Path, true)
			self:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Path, true)
		end

		Update(self)

		return true
	end
end

local function Disable(self, unit)
	local element = self.Fader

	if element then
		flush(element)

		if not unitList[unit] then return end

		if element.arena or element.instance then
			self:UnregisterEvent('PLAYER_ENTERING_WORLD', Path, true)
			self:UnregisterEvent('ZONE_CHANGED_NEW_AREA', Path, true)
		end

		if element.combat then
			self:UnregisterEvent('PLAYER_REGEN_ENABLED', Path)
			self:UnregisterEvent('PLAYER_REGEN_DISABLED', Path)
		end

		if element.target then
			self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
		end

		if element.injured then
			self:UnregisterEvent('UNIT_HEALTH', Path)
			self:UnregisterEvent('UNIT_MAXHEALTH', Path)
		end

		if element.mana or element.power then
			self:UnregisterEvent('UNIT_POWER_UPDATE', Path)
		end

		if element.casting then
			self:UnregisterEvent('UNIT_SPELLCAST_START', Path)
			self:UnregisterEvent('UNIT_SPELLCAST_FAILED', Path)
			self:UnregisterEvent('UNIT_SPELLCAST_STOP', Path)
			self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED', Path)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START', Path)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', Path)
			self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP', Path)
		end
	end
end

oUF:AddElement('Fader', Path, Enable, Disable)
