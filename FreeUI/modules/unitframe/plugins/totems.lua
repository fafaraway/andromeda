local parent, ns = ...
local oUF = ns.oUF


local function UpdateTooltip(totem)
	GameTooltip:SetTotem(totem:GetID())
end

local function OnEnter(totem)
	if (not totem:IsVisible()) then return end

	totem.icon:Show()
	totem.overlay:Show()
	GameTooltip:SetOwner(totem, 'ANCHOR_BOTTOMRIGHT')
	totem:UpdateTooltip()
end

local function OnLeave(totem)
	totem.icon:Hide()
	totem.overlay:Hide()
	GameTooltip:Hide()
end

local function OnUpdate(totem, elapsed)
	local timeLeft = totem.timeLeft - elapsed
	if (timeLeft > totem.duration) then
		totem:SetValue(timeLeft)
		totem.timeLeft = timeLeft
	end
end

local function UpdateTotem(self, event, slot)
	local totem = self.CustomTotems[slot]
	local _, _, start, duration, icon = GetTotemInfo(slot)

	if (duration > 0) then
		--totem.icon:SetTexture(icon)
		totem:SetMinMaxValues(-duration, 0)
		totem.timeLeft = start - GetTime()
		totem.duration = -duration
		totem:Show()
	else
		totem:Hide()
	end
end

local function Update(self, event, slot)
	if (tonumber(slot)) then
		UpdateTotem(self, event, slot)
	else
		for slot = 1, #self.CustomTotems do
			UpdateTotem(self, event, slot)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate')
end

local function Enable(self)
	local totems = self.CustomTotems
	if (not totems) then return end

	totems.__owner = self
	totems.ForceUpdate = ForceUpdate

	for slot = 1, #totems do
		local totem = totems[slot]
		totem:SetID(slot)
		totem:SetScript('OnUpdate', totems.OnUpdate or OnUpdate)
		if (totem:IsMouseEnabled()) then
			totem:SetScript('OnEnter', totems.OnEnter or OnEnter)
			totem:SetScript('OnLeave', totems.OnLeave or OnLeave)
			totem.UpdateTooltip = totems.UpdateTooltip or UpdateTooltip
		end
	end

	self:RegisterEvent('PLAYER_TOTEM_UPDATE', Update, true)

	TotemFrame:UnregisterEvent('PLAYER_ENTERING_WORLD')
	TotemFrame:UnregisterEvent('PLAYER_TALENT_UPDATE')
	TotemFrame:UnregisterEvent('PLAYER_TOTEM_UPDATE')
	TotemFrame:UnregisterEvent('UPDATE_SHAPESHIFT_FORM')

	return true
end

local function Disable(self)
	local totems = self.CustomTotems
	if (not totems) then return end

	for slot = 1, #totems do
		totems[slot]:Hide()
	end

	self:UnregisterEvent('PLAYER_TOTEM_UPDATE', Update)

	TotemFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
	TotemFrame:RegisterEvent('PLAYER_TALENT_UPDATE')
	TotemFrame:RegisterEvent('PLAYER_TOTEM_UPDATE')
	TotemFrame:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
end

oUF:AddElement('CustomTotems', Update, Enable, Disable)