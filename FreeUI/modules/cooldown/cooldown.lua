local F, C = unpack(select(2, ...))
local COOLDOWN = F:GetModule('COOLDOWN')


local FONT_SIZE = 24
local MIN_DURATION = 2.5
local MIN_SCALE = 0.5
local ICON_SIZE = 36
local hideNumbers, active, hooked = {}, {}, {}
local pairs, strfind = pairs, string.find
local GetTime, GetActionCooldown = GetTime, GetActionCooldown

function COOLDOWN:StopTimer()
	self.enabled = nil
	self:Hide()
end

function COOLDOWN:ForceUpdate()
	self.nextUpdate = 0
	self:Show()
end

function COOLDOWN:OnSizeChanged(width, height)
	local fontScale = F:Round((width+height)/2) / ICON_SIZE
	if fontScale == self.fontScale then return end
	self.fontScale = fontScale

	if fontScale < MIN_SCALE then
		self:Hide()
	else
		self.text:SetFont(C.Assets.Fonts.Square, fontScale * FONT_SIZE, 'OUTLINE')
		self.text:SetShadowColor(0, 0, 0, 1)

		if self.enabled then
			COOLDOWN.ForceUpdate(self)
		end
	end
end

function COOLDOWN:TimerOnUpdate(elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0 then
			local getTime, nextUpdate = F.FormatTime(remain)
			self.text:SetText(getTime)
			self.nextUpdate = nextUpdate
		else
			COOLDOWN.StopTimer(self)
		end
	end
end

function COOLDOWN:ScalerOnSizeChanged(...)
	COOLDOWN.OnSizeChanged(self.timer, ...)
end

function COOLDOWN:OnCreate()
	local frameName = self.GetName and self:GetName() or ''

	local scaler = CreateFrame('Frame', nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame('Frame', nil, scaler)
	timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript('OnUpdate', COOLDOWN.TimerOnUpdate)
	scaler.timer = timer

	local text = timer:CreateFontString(nil, 'BACKGROUND')
	text:SetPoint('CENTER', 1, 0)
	text:SetJustifyH('CENTER')
	timer.text = text

	if C.DB.cooldown.override_weakauras and strfind(frameName, 'WeakAurasCooldown') then
		text:SetPoint('BOTTOM', 1, -6)
	end

	COOLDOWN.OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript('OnSizeChanged', COOLDOWN.ScalerOnSizeChanged)

	self.timer = timer
	return timer
end

function COOLDOWN:StartTimer(start, duration)
	if self:IsForbidden() then return end
	if self.noCooldownCount or hideNumbers[self] then return end

	local frameName = self.GetName and self:GetName()
	if not C.DB.cooldown.override_weakauras and frameName and strfind(frameName, 'WeakAuras') then
		self.noCooldownCount = true
		return
	end

	if start > 0 and duration > MIN_DURATION then
		local timer = self.timer or COOLDOWN.OnCreate(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0

		-- wait for blizz to fix itself
		local parent = self:GetParent()
		local charge = parent and parent.chargeCooldown
		local chargeTimer = charge and charge.timer
		if chargeTimer and chargeTimer ~= timer then
			COOLDOWN.StopTimer(chargeTimer)
		end

		if timer.fontScale >= MIN_SCALE then
			timer:Show()
		end
	elseif self.timer then
		COOLDOWN.StopTimer(self.timer)
	end

	-- hide cooldown flash if barFader enabled
	if self:GetParent().__faderParent then
		if self:GetEffectiveAlpha() > 0 then
			self:Show()
		else
			self:Hide()
		end
	end
end

function COOLDOWN:HideCooldownNumbers()
	hideNumbers[self] = true
	if self.timer then COOLDOWN.StopTimer(self.timer) end
end

function COOLDOWN:CooldownOnShow()
	active[self] = true
end

function COOLDOWN:CooldownOnHide()
	active[self] = nil
end

local function shouldUpdateTimer(self, start)
	local timer = self.timer
	if not timer then
		return true
	end
	return timer.start ~= start
end

function COOLDOWN:CooldownUpdate()
	local button = self:GetParent()
	local start, duration = GetActionCooldown(button.action)

	if shouldUpdateTimer(self, start) then
		COOLDOWN.StartTimer(self, start, duration)
	end
end

function COOLDOWN:ActionbarUpateCooldown()
	for cooldown in pairs(active) do
		COOLDOWN.CooldownUpdate(cooldown)
	end
end

function COOLDOWN:RegisterActionButton()
	local cooldown = self.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript('OnShow', COOLDOWN.CooldownOnShow)
		cooldown:HookScript('OnHide', COOLDOWN.CooldownOnHide)

		hooked[cooldown] = true
	end
end

function COOLDOWN:OnLogin()
	if not C.DB.cooldown.enable_cooldown then return end

	local cooldownIndex = getmetatable(ActionButton1Cooldown).__index
	hooksecurefunc(cooldownIndex, 'SetCooldown', COOLDOWN.StartTimer)

	hooksecurefunc('CooldownFrame_SetDisplayAsPercentage', COOLDOWN.HideCooldownNumbers)

	hooksecurefunc(ActionBarButtonEventsFrameMixin, 'RegisterFrame', COOLDOWN.RegisterActionButton)

	if _G['ActionBarButtonEventsFrame'].frames then
		for _, frame in pairs(_G['ActionBarButtonEventsFrame'].frames) do
			COOLDOWN.RegisterActionButton(frame)
		end
	end
	hooksecurefunc(ActionBarButtonEventsFrameMixin, 'RegisterFrame', COOLDOWN.RegisterActionButton)

	-- Hide Default Cooldown
	SetCVar('countdownForCooldowns', 0)
	F.HideOption(InterfaceOptionsActionBarsPanelCountdownCooldowns)

	self:CooldownPulse()
end
