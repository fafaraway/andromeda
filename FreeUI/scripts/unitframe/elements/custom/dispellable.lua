local F, C = unpack(select(2, ...))
if (not C.unitframe.dispellable) then return end

local _, ns = ...

local oUF = ns.oUF
assert(oUF, 'oUF_Dispellable requires oUF.')

local LPS = LibStub('LibPlayerSpells-1.0')
assert(LPS, 'oUF_Dispellable requires LibPlayerSpells-1.0.')

local dispelTypeFlags = {
	Curse   = LPS.constants.CURSE,
	Disease = LPS.constants.DISEASE,
	Magic   = LPS.constants.MAGIC,
	Poison  = LPS.constants.POISON,
}

local band          = bit.band
local wipe          = table.wipe
local IsPlayerSpell = IsPlayerSpell
local IsSpellKnown  = IsSpellKnown
local UnitCanAssist = UnitCanAssist
local UnitDebuff    = UnitDebuff

local _, playerClass = UnitClass('player')
local _, playerRace = UnitRace('player')
local dispels = {}

for id, _, _, _, _, _, types in LPS:IterateSpells('HELPFUL PERSONAL', 'DISPEL ' .. playerClass) do
	dispels[id] = types
end

if (playerRace == 'Dwarf') then
	dispels[20594] = select(6, LPS:GetSpellInfo(20594)) -- Stoneform
end

if (playerRace == 'DarkIronDwarf') then
	dispels[265221] = select(6, LPS:GetSpellInfo(265221)) -- Fireblood
end

if (not next(dispels)) then return end

local canDispel = {}

local function UpdateTooltip(dispelIcon)
	GameTooltip:SetUnitAura(dispelIcon.unit, dispelIcon.id, 'HARMFUL')
end

local function OnEnter(dispelIcon)
	if (not dispelIcon:IsVisible()) then return end

	GameTooltip:SetOwner(dispelIcon, dispelIcon.tooltipAnchor)
	dispelIcon:UpdateTooltip()
end

local function OnLeave()
	GameTooltip:Hide()
end

local function UpdateColor(dispelTexture, _, r, g, b, a)
	dispelTexture:SetVertexColor(r, g, b, a)
end

local function Update(self, _, unit)
	if (self.unit ~= unit) then return end

	local element = self.Dispellable

	if (element.PreUpdate) then
		element:PreUpdate()
	end

	local dispelTexture = element.dispelTexture
	local dispelIcon = element.dispelIcon

	local texture, count, debuffType, duration, expiration, id, dispellable
	if (UnitCanAssist('player', unit)) then
		for i = 1, 40 do
			_, texture, count, debuffType, duration, expiration = UnitDebuff(unit, i)

			if (not texture or canDispel[debuffType] == true or canDispel[debuffType] == unit) then
				dispellable = debuffType
				id = i
				break
			end
		end
	end

	if (dispellable) then
		local color = self.colors.debuff[debuffType]
		local r, g, b = color[1], color[2], color[3]
		if (dispelTexture) then
			dispelTexture:UpdateColor(debuffType, r, g, b, dispelTexture.dispelAlpha)
		end

		if (dispelIcon) then
			dispelIcon.unit = unit
			dispelIcon.id = id
			if (dispelIcon.icon) then
				dispelIcon.icon:SetTexture(texture)
			end
			if (dispelIcon.overlay) then
				dispelIcon.overlay:SetVertexColor(r, g, b)
			end
			if (dispelIcon.count) then
				dispelIcon.count:SetText(count and count > 1 and count)
			end
			if (dispelIcon.cd) then
				if (duration and duration > 0) then
					dispelIcon.cd:SetCooldown(expiration - duration, duration)
					dispelIcon.cd:Show()
				else
					dispelIcon.cd:Hide()
				end
			end

			dispelIcon:Show()
		end
	else
		if (dispelTexture) then
			dispelTexture:UpdateColor(nil, 1, 1, 1, dispelTexture.noDispelAlpha)
		end
		if (dispelIcon) then
			dispelIcon:Hide()
		end
	end

	if (element.PostUpdate) then
		element:PostUpdate(dispellable, texture, count, duration, expiration)
	end
end

local function Path(self, event, unit)
	return (self.Dispellable.Override or Update)(self, event, unit)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.Dispellable
	if (not element) then return end

	element.__owner = self
	element.ForceUpdate = ForceUpdate

	local dispelTexture = element.dispelTexture
	if (dispelTexture) then
		dispelTexture.dispelAlpha = dispelTexture.dispelAlpha or 1
		dispelTexture.noDispelAlpha = dispelTexture.noDispelAlpha or 0
		dispelTexture.UpdateColor = dispelTexture.UpdateColor or UpdateColor
	end

	local dispelIcon = element.dispelIcon
	if (dispelIcon) then
		-- prevent /fstack errors
		if (dispelIcon.cd) then
			if (not dispelIcon:GetName()) then
				dispelIcon:SetName(dispelIcon:GetDebugName())
			end
			if (not dispelIcon.cd:GetName()) then
				dispelIcon.cd:SetName('$parentCooldown')
			end
		end

		if (dispelIcon:IsMouseEnabled()) then
			dispelIcon.tooltipAnchor = dispelIcon.tooltipAnchor or 'ANCHOR_BOTTOMRIGHT'
			dispelIcon.UpdateTooltip = dispelIcon.UpdateTooltip or UpdateTooltip

			if (not dispelIcon:GetScript('OnEnter')) then
				dispelIcon:SetScript('OnEnter', OnEnter)
			end
			if (not dispelIcon:GetScript('OnLeave')) then
				dispelIcon:SetScript('OnLeave', OnLeave)
			end
		end
	end

	if (not self.colors.debuff) then
		self.colors.debuff = {}
		for debuffType, color in next, DebuffTypeColor do
			self.colors.debuff[debuffType] = { color.r, color.g, color.b }
		end
	end

	self:RegisterEvent('UNIT_AURA', Path)

	return true
end

local function Disable(self)
	local element = self.Dispellable
	if (not element) then return end

	if (element.dispelIcon) then
		element.dispelIcon:Hide()
	end
	if (element.dispelTexture) then
		element.dispelTexture:UpdateColor(nil, 1, 1, 1, element.dispelTexture.noDispelAlpha)
	end

	self:UnregisterEvent('UNIT_AURA', Path)
end

oUF:AddElement('Dispellable', Path, Enable, Disable)

local function ToggleElement(enable)
	for _, object in next, oUF.objects do
		local element = object.Dispellable
		if (element) then
			if (enable) then
				object:EnableElement('Dispellable')
				element:ForceUpdate()
			else
				object:DisableElement('Dispellable')
			end
		end
	end
end

local function AreTablesEqual(a, b)
	for k, v in next, a do
		if (b[k] ~= v) then
			return false
		end
	end
	return true
end

local function UpdateDispels()
	local available = {}
	for id, types in next, dispels do
		if (IsSpellKnown(id, id == 89808) or IsPlayerSpell(id)) then
			for debuffType, flags in next, dispelTypeFlags do
				if (band(types, flags) > 0 and available[debuffType] ~= true) then
					available[debuffType] = band(LPS:GetSpellInfo(id), LPS.constants.PERSONAL) > 0 and 'player' or true
				end
			end
		end
	end

	if (next(available)) then
		local areEqual = AreTablesEqual(available, canDispel)
		areEqual = areEqual and AreTablesEqual(canDispel, available)

		if (not areEqual) then
			wipe(canDispel)
			for debuffType in next, available do
				canDispel[debuffType] = available[debuffType]
			end
			ToggleElement(true)
		end
	elseif (next(canDispel)) then
		wipe(canDispel)
		ToggleElement()
	end
end

local frame = CreateFrame('Frame')
frame:SetScript('OnEvent', UpdateDispels)
frame:RegisterEvent('SPELLS_CHANGED')
