local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

if select(2, UnitClass("player")) ~= "MAGE" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_RuneOfPower was unable to locate oUF install")

local Colors = { 132/255, 112/255, 255/255 }

local function UpdateRunePowerTimer(self, elapsed)
	if not self.expirationTime then return end
	self.expirationTime = self.expirationTime - elapsed

	local timeLeft = self.expirationTime
	if timeLeft > 0 then
		self:SetValue(timeLeft)
	else
		self:SetScript("OnUpdate", nil)
	end
end

local function UpdateRunePower(self, event, slot)
	local rp = self.RunePower

	if slot and (slot == 1 or slot == 2) then
		if(rp.PreUpdate) then
			rp:PreUpdate(slot)
		end

		local up, name, start, duration, icon = GetTotemInfo(slot)
		if (up) then
			local timeLeft = (start+duration) - GetTime()
			rp[slot].duration = duration
			rp[slot].expirationTime = timeLeft
			rp[slot]:SetMinMaxValues(0, duration)
			rp[slot]:SetScript('OnUpdate', UpdateRunePowerTimer)
			rp[slot].isActive = true

			rp:Show()
		else
			rp[slot]:SetValue(0)
			rp[slot]:SetScript("OnUpdate", nil)
			rp[slot].isActive = false

			rp:Hide()
		end

		if rp[1].isActive or rp[2].isActive then
			rp:Show()
		else
			rp:Hide()
		end

		if(rp.PostUpdate) then
			return rp:PostUpdate(slot, up, name, start, duration, icon)
		end
	end
end

local Path = function(self, event, ...)
	return (self.RunePower.Override or UpdateRunePower) (self, event, ...)
end

local Update = function(self, event, ...)
	for i = 1, 2 do
		Path(self, event, i)
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate')
end

local function Enable(self, unit)
	local rp = self.RunePower
	if rp and unit == "player" then
		rp.__owner = self
		rp.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_TOTEM_UPDATE", Path, true)

		for i = 1, 2 do
			local bar = rp[i]
			if not bar:GetStatusBarTexture() then
				bar:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			bar:SetStatusBarColor(unpack(Colors))
			bar:SetFrameLevel(rp:GetFrameLevel() + 1)
			bar:GetStatusBarTexture():SetHorizTile(false)
			bar:SetMinMaxValues(0, 300)
			bar:SetValue(0)

			if bar.bg then
				bar.bg:SetAlpha(0.15)
				bar.bg:SetAllPoints()
				bar.bg:SetTexture(unpack(Colors))
			end
		end

		rp:Hide()

		return true
	end
end

local function Disable(self)
	local rp = self.RunePower
	if(rp) then
		self:UnregisterEvent("PLAYER_TOTEM_UPDATE", Path)
	end
end

oUF:AddElement('RunePower', Update, Enable, Disable)