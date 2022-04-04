local F, C = unpack(select(2, ...))
local COOLDOWN = F:GetModule('Cooldown')

local fontSize = 18
local iconSize = 36
local minDuration = 2.5
local minScale = 0.5

local hideNumbers, active, hooked = {}, {}, {}

local day, hour, minute = 86400, 3600, 60
function COOLDOWN.FormattedTimer(s)
    if s >= day then
        return string.format('%d' .. C.INFO_COLOR .. 'd', s / day + .5), s % day
    elseif s > hour then
        return string.format('%d' .. C.INFO_COLOR .. 'h', s / hour + .5), s % hour
    elseif s >= minute then
        if s < C.DB.Cooldown.MmssTH then
            return string.format('%d:%.2d', s / minute, s % minute), s - math.floor(s)
        else
            return string.format('%d' .. C.INFO_COLOR .. 'm', s / minute + .5), s % minute
        end
    else
        local colorStr = (s < 3 and '|cffff0000') or (s < 10 and '|cffffff00') or '|cffcccc33'
        if s < C.DB.Cooldown.TenthTH then
            return string.format(colorStr .. '%.1f|r', s), s - string.format('%.1f', s)
        else
            return string.format(colorStr .. '%d|r', s + .5), s - math.floor(s)
        end
    end
end

function COOLDOWN:StopTimer()
    self.enabled = nil
    self:Hide()
end

function COOLDOWN:ForceUpdate()
    self.nextUpdate = 0
    self:Show()
end

function COOLDOWN:OnSizeChanged(width, height)
    local fontScale = F:Round((width + height) / 2) / iconSize
    if fontScale == self.fontScale then
        return
    end
    self.fontScale = fontScale

    local outline = _G.FREE_ADB.FontOutline
    local font = C.Assets.Font.Bold

    if fontScale < minScale then
        self:Hide()
    else

        self.text:SetFont(font, fontScale * fontSize, outline and 'OUTLINE' or nil)
        self.text:SetShadowColor(0, 0, 0, outline and 0 or 1)
        self.text:SetShadowOffset(2, -2)

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
            local getTime, nextUpdate = COOLDOWN.FormattedTimer(remain)
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
    -- scaler:SetFrameStrata('HIGH')

    local timer = CreateFrame('Frame', nil, scaler)
    timer:Hide()
    timer:SetAllPoints(scaler)
    timer:SetScript('OnUpdate', COOLDOWN.TimerOnUpdate)
    scaler.timer = timer

    local text = timer:CreateFontString(nil, 'OVERLAY')
    text:SetPoint('CENTER', 1, 0)
    text:SetJustifyH('CENTER')
    timer.text = text

    if not C.DB.Cooldown.IgnoreWA and C.IsDeveloper and string.find(frameName, 'WeakAurasCooldown') then
        text:SetPoint('CENTER', timer, 'BOTTOM')
    end

    COOLDOWN.OnSizeChanged(timer, scaler:GetSize())
    scaler:SetScript('OnSizeChanged', COOLDOWN.ScalerOnSizeChanged)

    self.timer = timer
    return timer
end

function COOLDOWN:StartTimer(start, duration)
    if self:IsForbidden() then
        return
    end
    if self.noCooldownCount or hideNumbers[self] then
        return
    end

    local frameName = self.GetName and self:GetName()
    if C.DB.Cooldown.IgnoreWA and frameName and string.find(frameName, 'WeakAuras') then
        self.noCooldownCount = true
        return
    end

    local parent = self:GetParent()
    start = tonumber(start) or 0
    duration = tonumber(duration) or 0

    if start > 0 and duration > minDuration then
        local timer = self.timer or COOLDOWN.OnCreate(self)
        timer.start = start
        timer.duration = duration
        timer.enabled = true
        timer.nextUpdate = 0

        -- wait for blizz to fix itself
        local charge = parent and parent.chargeCooldown
        local chargeTimer = charge and charge.timer
        if chargeTimer and chargeTimer ~= timer then
            COOLDOWN.StopTimer(chargeTimer)
        end

        if timer.fontScale >= minScale then
            timer:Show()
        end
    elseif self.timer then
        COOLDOWN.StopTimer(self.timer)
    end

    -- hide cooldown flash if barFader enabled
    if parent and parent.__faderParent then
        if self:GetEffectiveAlpha() > 0 then
            self:Show()
        else
            self:Hide()
        end
    end
end

function COOLDOWN:HideCooldownNumbers()
    hideNumbers[self] = true
    if self.timer then
        COOLDOWN.StopTimer(self.timer)
    end
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
    if not C.DB.Cooldown.Enable then
        return
    end

    local cooldownIndex = getmetatable(_G.ActionButton1Cooldown).__index
    hooksecurefunc(cooldownIndex, 'SetCooldown', COOLDOWN.StartTimer)

    hooksecurefunc('CooldownFrame_SetDisplayAsPercentage', COOLDOWN.HideCooldownNumbers)

    hooksecurefunc(_G.ActionBarButtonEventsFrameMixin, 'RegisterFrame', COOLDOWN.RegisterActionButton)

    if _G['ActionBarButtonEventsFrame'].frames then
        for _, frame in pairs(_G['ActionBarButtonEventsFrame'].frames) do
            COOLDOWN.RegisterActionButton(frame)
        end
    end
    hooksecurefunc(_G.ActionBarButtonEventsFrameMixin, 'RegisterFrame', COOLDOWN.RegisterActionButton)

    -- Hide Default Cooldown
    SetCVar('countdownForCooldowns', 0)
    F.HideOption(_G.InterfaceOptionsActionBarsPanelCountdownCooldowns)
end
