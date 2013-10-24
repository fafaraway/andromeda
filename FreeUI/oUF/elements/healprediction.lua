local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

local _, ns = ...
local oUF = ns.oUF

local function UpdateFillBar(frame, previousTexture, bar, amount)
	if amount == 0 then
		bar:Hide()
		return previousTexture
	end

	bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT", 0, 0)
	bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT", 0, 0)

	local totalWidth, totalHeight = frame.Health:GetSize()
	local _, totalMax = frame.Health:GetMinMaxValues()

	local barSize = (amount / totalMax) * totalWidth
	bar:SetWidth(barSize)
	bar:Show()

	return bar
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	local hp = self.HealPrediction
	if(hp.PreUpdate) then hp:PreUpdate(unit) end

	local myIncomingHeal = UnitGetIncomingHeals(unit, 'player') or 0
	local allIncomingHeal = UnitGetIncomingHeals(unit) or 0
	local totalAbsorb

	local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)

	if(health + allIncomingHeal > maxHealth * hp.maxOverflow) then
		allIncomingHeal = maxHealth * hp.maxOverflow - health
	end

	if(allIncomingHeal < myIncomingHeal) then
		myIncomingHeal = allIncomingHeal
		allIncomingHeal = 0
	else
		allIncomingHeal = allIncomingHeal - myIncomingHeal
	end

	if hp.absorbBar then
		totalAbsorb = UnitGetTotalAbsorbs(unit) or 0

		local overAbsorb = false
		if health + myIncomingHeal + allIncomingHeal + totalAbsorb >= maxHealth then
			if totalAbsorb > 0 then
				overAbsorb = true
			end
			totalAbsorb = max(0, maxHealth - (health + myIncomingHeal + allIncomingHeal))
		end
		if overAbsorb then
			hp.overAbsorbGlow:Show()
		else
			hp.overAbsorbGlow:Hide()
		end
	end

	local previousTexture = self.Health:GetStatusBarTexture()

	previousTexture = UpdateFillBar(self, previousTexture, hp.myBar, myIncomingHeal)
	previousTexture = UpdateFillBar(self, previousTexture, hp.otherBar, allIncomingHeal)
	if hp.absorbBar then UpdateFillBar(self, previousTexture, hp.absorbBar, totalAbsorb) end

	if(hp.PostUpdate) then
		return hp:PostUpdate(unit)
	end
end

local function Path(self, ...)
	return (self.HealPrediction.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local hp = self.HealPrediction
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_HEAL_PREDICTION', Path)
		if hp.absorbBar then
			self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
			self:RegisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)
		end
		self:RegisterEvent('UNIT_MAXHEALTH', Path)
		if(hp.frequentUpdates) then
			self:RegisterEvent('UNIT_HEALTH_FREQUENT', Path)
		else
			self:RegisterEvent('UNIT_HEALTH', Path)
		end

		if(hp.overAbsorbGlow and hp.overAbsorbGlow:IsObjectType'Texture' and not hp.overAbsorbGlow:GetTexture()) then
			hp.overAbsorbGlow:SetTexture([[Interface\RaidFrame\Shield-Overshield]])
		end

		return true
	end
end

local function Disable(self)
	local hp = self.HealPrediction
	if(hp) then
		self:UnregisterEvent('UNIT_HEAL_PREDICTION', Path)
		self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", Path)
		self:UnregisterEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', Path)
		self:UnregisterEvent('UNIT_MAXHEALTH', Path)
		self:UnregisterEvent('UNIT_HEALTH', Path)
		self:UnregisterEvent('UNIT_HEALTH_FREQUENT', Path)
	end
end

oUF:AddElement('HealPrediction', Path, Enable, Disable)