local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

-- PlayerBuffTimers by Rainrider


local _, ns = ...
local oUF = ns.oUF

local function UpdateTooltip(timer)
	GameTooltip:SetOwner(timer, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:SetText(timer.name, 1, 1, 1)
	GameTooltip:AddLine(timer.tooltip, nil, nil, nil, true)
	GameTooltip:Show()
end

local function OnEnter(timer)
	if(not timer:IsVisible()) then return end

	if(timer.Time) then
		timer.Time:Show()
	end

	timer:UpdateTooltip()
end

local function OnLeave(timer)
	if(timer.Time) then
		timer.Time:Hide()
	end
	GameTooltip:Hide()
end

local function OnUpdate(timer)
	local timeLeft = timer.expiration - GetTime()

	if(timeLeft > 0) then
		timer:SetValue(timeLeft)

		if(timer.Time and timer.Time:IsVisible()) then
			if(timer.CustomTime) then
				timer:CustomTime(timeLeft)
			else
				timer.Time:SetFormattedText('%d / %d', timeLeft, timer.duration)
			end
		end
	else
		timer:Hide()
	end
end

local function UpdateTimer(timer, duration, expiration, barID, auraID)
	timer:SetMinMaxValues(0, duration)
end

local function Update(self, event)
	local element = self.PlayerBuffTimers

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	for i = 1, #element do
		local timer = element[i]
		if(not timer) then
			break
		end

		local duration, expiration, barID, auraID = UnitPowerBarTimerInfo('player', i)

		if(barID) then
			timer.duration = duration
			timer.expiration = expiration
			timer.auraID = auraID
			timer.name, timer.tooltip = select(11, GetAlternatePowerInfoByID(barID))

			timer:UpdateTimer(duration, expiration, barID, auraID)
			timer:Show()
		else
			timer:Hide()
		end
	end

	if(element.PostUpdate) then
		element:PostUpdate()
	end
end

local function Path(self, ...)
	return (self.PlayerBuffTimers.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', 'player')
end

local function Enable(self, unit)
	local element = self.PlayerBuffTimers
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		for i = 1, #element do
			local timer = element[i]

			if(timer:IsObjectType('StatusBar')) then
				timer.UpdateTimer = timer.UpdateTimer or UpdateTimer

				if(not timer:GetStatusBarTexture()) then
					timer:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
				end

				if(not timer:GetScript('OnUpdate')) then
					timer:SetScript('OnUpdate', OnUpdate)
				end
			end

			if(timer:IsMouseEnabled()) then
				timer.UpdateTooltip = timer.UpdateTooltip or UpdateTooltip

				if(not timer:GetScript('OnEnter')) then
					timer:SetScript('OnEnter', OnEnter)
				end

				if(not timer:GetScript('OnLeave')) then
					timer:SetScript('OnLeave', OnLeave)
				end
			end
		end

		self:RegisterEvent('UNIT_POWER_BAR_TIMER_UPDATE', Path)

		PlayerBuffTimerManager:UnregisterEvent('UNIT_POWER_BAR_TIMER_UPDATE')
		PlayerBuffTimerManager:UnregisterEvent('PLAYER_ENTERING_WORLD')

		return true
	end
end

local function Disable(self)
	local element = self.PlayerBuffTimers
	if(element) then
		self:UnregisterEvent('UNIT_POWER_BAR_TIMER_UPDATE', Path)

		for i = 1, #element do
			element[i]:Hide()
		end

		PlayerBuffTimerManager:RegisterEvent('UNIT_POWER_BAR_TIMER_UPDATE')
		PlayerBuffTimerManager:RegisterEvent('PLAYER_ENTERING_WORLD')
	end
end

oUF:AddElement('PlayerBuffTimers', Path, Enable, Disable)