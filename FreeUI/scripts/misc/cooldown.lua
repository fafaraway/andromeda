local F, C = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local MIN_DURATION = 2.5
local MIN_SCALE = 0.5
local ICON_SIZE = 36
local hideNumbers, active, hooked = {}, {}, {}
local pairs, floor, strfind = pairs, math.floor, string.find
local GetTime, GetActionCooldown = GetTime, GetActionCooldown

function MISC:StopTimer()
	self.enabled = nil
	self:Hide()
end

function MISC:ForceUpdate()
	self.nextUpdate = 0
	self:Show()
end

function MISC:OnSizeChanged(width)
	local fontScale = floor(width + 0.5) / ICON_SIZE
	if fontScale == self.fontScale then return end
	self.fontScale = fontScale

	if fontScale < MIN_SCALE then
		self:Hide()
	else
		self.text:SetFont(C.AssetsPath..'font\\supereffective.ttf', 16, 'OUTLINEMONOCHROME')
		self.text:SetShadowColor(0, 0, 0, 0)

		if self.enabled then
			MISC.ForceUpdate(self)
		end
	end
end

function MISC:TimerOnUpdate(elapsed)
	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
	else
		local remain = self.duration - (GetTime() - self.start)
		if remain > 0 then
			local getTime, nextUpdate = F.FormatTime(remain)
			self.text:SetText(getTime)
			self.nextUpdate = nextUpdate
		else
			MISC.StopTimer(self)
		end
	end
end

function MISC:OnCreate()
	local scaler = CreateFrame("Frame", nil, self)
	scaler:SetAllPoints(self)

	local timer = CreateFrame("Frame", nil, scaler)
	timer:Hide()
	timer:SetAllPoints(scaler)
	timer:SetScript("OnUpdate", MISC.TimerOnUpdate)

	local text = timer:CreateFontString(nil, "BACKGROUND")
	text:SetPoint("CENTER", 2, 0)
	text:SetJustifyH("CENTER")
	timer.text = text

	MISC.OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript("OnSizeChanged", function(_, ...)
		MISC.OnSizeChanged(timer, ...)
	end)

	self.timer = timer
	return timer
end

function MISC:StartTimer(start, duration)
	if self:IsForbidden() then return end
	if self.noOCC or hideNumbers[self] then return end

	local frameName = self.GetName and self:GetName() or ""
	if C.general.cooldown_overrideWA and strfind(frameName, "WeakAuras") then
		self.noOCC = true
		return
	end

	if start > 0 and duration > MIN_DURATION then
		local timer = self.timer or MISC.OnCreate(self)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		timer.nextUpdate = 0

		-- wait for blizz to fix itself
		local parent = self:GetParent()
		local charge = parent and parent.chargeCooldown
		local chargeTimer = charge and charge.timer
		if chargeTimer and chargeTimer ~= timer then
			MISC.StopTimer(chargeTimer)
		end

		if timer.fontScale >= MIN_SCALE then
			timer:Show()
		end
	elseif self.timer then
		MISC.StopTimer(self.timer)
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

function MISC:HideCooldownNumbers()
	hideNumbers[self] = true
	if self.timer then MISC.StopTimer(self.timer) end
end

function MISC:CooldownOnShow()
	active[self] = true
end

function MISC:CooldownOnHide()
	active[self] = nil
end

local function shouldUpdateTimer(self, start)
	local timer = self.timer
	if not timer then
		return true
	end
	return timer.start ~= start
end

function MISC:CooldownUpdate()
	local button = self:GetParent()
	local start, duration = GetActionCooldown(button.action)

	if shouldUpdateTimer(self, start) then
		MISC.StartTimer(self, start, duration)
	end
end

function MISC:ActionbarUpateCooldown()
	for cooldown in pairs(active) do
		MISC.CooldownUpdate(cooldown)
	end
end

function MISC:RegisterActionButton()
	local cooldown = self.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript("OnShow", MISC.CooldownOnShow)
		cooldown:HookScript("OnHide", MISC.CooldownOnHide)

		hooked[cooldown] = true
	end
end

function MISC:Cooldown()
	if not C.general.cooldown then return end

	local cooldownIndex = getmetatable(ActionButton1Cooldown).__index
	hooksecurefunc(cooldownIndex, "SetCooldown", MISC.StartTimer)

	hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", MISC.HideCooldownNumbers)

	F:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", MISC.ActionbarUpateCooldown)

	if _G["ActionBarButtonEventsFrame"].frames then
		for _, frame in pairs(_G["ActionBarButtonEventsFrame"].frames) do
			MISC.RegisterActionButton(frame)
		end
	end
	hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", MISC.RegisterActionButton)

	-- Hide Default Cooldown
	SetCVar("countdownForCooldowns", 0)
	F.HideOption(InterfaceOptionsActionBarsPanelCountdownCooldowns)
end
