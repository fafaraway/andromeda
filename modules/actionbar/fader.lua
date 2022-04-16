local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local barsList = {
    ['FadeBar1'] = 'FreeUI_ActionBar1',
    ['FadeBar2'] = 'FreeUI_ActionBar2',
    ['FadeBar3'] = 'FreeUI_ActionBar3',
    ['FadeBar4'] = 'FreeUI_ActionBar4',
    ['FadeBar5'] = 'FreeUI_ActionBar5',
    ['FadePetBar'] = 'FreeUI_ActionBarPet',
    ['FadeStanceBar'] = 'FreeUI_ActionBarStance',
}

local function ClearTimers(object)
    if object.delayTimer then
        F:CancelTimer(object.delayTimer)
        object.delayTimer = nil
    end
end

local function DelayFadeOut(frame, timeToFade, startAlpha, endAlpha)
    ClearTimers(frame)

    if C.DB.Actionbar.Delay > 0 then
        frame.delayTimer = F:ScheduleTimer(
            F.UIFrameFadeOut,
            C.DB.Actionbar.Delay,
            F,
            frame,
            timeToFade,
            startAlpha,
            endAlpha
        )
    else
        F:UIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
    end
end

function ACTIONBAR:FadeBlingTexture(cooldown, alpha)
    if not cooldown then
        return
    end
    cooldown:SetBlingTexture(alpha > 0.5 and [[Interface\Cooldown\star4]] or C.Assets.Texture.Blank)
end

function ACTIONBAR:FadeBlings(alpha)
    for _, button in pairs(ACTIONBAR.buttons) do
        ACTIONBAR:FadeBlingTexture(button.cooldown, alpha)
    end
end

function ACTIONBAR:Button_OnEnter()
    local parent = ACTIONBAR.fadeParent

    if not parent.mouseLock then
        ClearTimers(parent)
        F:UIFrameFadeIn(parent, C.DB.Actionbar.FadeInDuration, parent:GetAlpha(), C.DB.Actionbar.FadeInAlpha)
        ACTIONBAR:FadeBlings(C.DB.Actionbar.FadeInAlpha)
    end
end

function ACTIONBAR:Button_OnLeave()
    local parent = ACTIONBAR.fadeParent

    if not parent.mouseLock then
        DelayFadeOut(parent, C.DB.Actionbar.FadeOutDuration, parent:GetAlpha(), C.DB.Actionbar.FadeOutAlpha)
        ACTIONBAR:FadeBlings(C.DB.Actionbar.FadeOutAlpha)
    end
end

function ACTIONBAR:FadeParent_OnEvent(event)
    if
        (event == 'ACTIONBAR_SHOWGRID')
        or (C.DB.Actionbar.Instance and IsInInstance())
        or (C.DB.Actionbar.Vehicle and ((HasVehicleActionBar() and UnitVehicleSkin('player') and UnitVehicleSkin(
            'player'
        ) ~= '') or (HasOverrideActionBar() and GetOverrideBarSkin() and GetOverrideBarSkin() ~= '')))
        or (C.DB.Actionbar.Combat and UnitAffectingCombat('player'))
        or (C.DB.Actionbar.Target and (UnitExists('target') or UnitExists('focus')))
        or (C.DB.Actionbar.Casting and (UnitCastingInfo('player') or UnitChannelInfo('player')))
        or (C.DB.Actionbar.Health and (UnitHealth('player') ~= UnitHealthMax('player')))
    then
        self.mouseLock = true

        ClearTimers(ACTIONBAR.fadeParent)
        F:UIFrameFadeIn(self, C.DB.Actionbar.FadeInDuration, self:GetAlpha(), C.DB.Actionbar.FadeInAlpha)
        ACTIONBAR:FadeBlings(C.DB.Actionbar.FadeInAlpha)
    else
        self.mouseLock = false

        DelayFadeOut(self, C.DB.Actionbar.FadeOutDuration, self:GetAlpha(), C.DB.Actionbar.FadeOutAlpha)
        ACTIONBAR:FadeBlings(C.DB.Actionbar.FadeOutAlpha)
    end
end

local options = {
    Instance = {
        enable = function(self)
            self:RegisterEvent('PLAYER_ENTERING_WORLD')
            self:RegisterEvent('ZONE_CHANGED_NEW_AREA')
        end,
        events = { 'PLAYER_ENTERING_WORLD', 'ZONE_CHANGED_NEW_AREA' },
    },
    Vehicle = {
        enable = function(self)
            self:RegisterEvent('PLAYER_ENTERING_WORLD')
            self:RegisterEvent('UPDATE_BONUS_ACTIONBAR')
            self:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR')
            self:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR')
            self:RegisterEvent('ACTIONBAR_PAGE_CHANGED')
        end,
        events = {
            'PLAYER_ENTERING_WORLD',
            'UPDATE_BONUS_ACTIONBAR',
            'UPDATE_VEHICLE_ACTIONBAR',
            'UPDATE_OVERRIDE_ACTIONBAR',
            'ACTIONBAR_PAGE_CHANGED',
        },
    },
    Combat = {
        enable = function(self)
            self:RegisterEvent('PLAYER_REGEN_ENABLED')
            self:RegisterEvent('PLAYER_REGEN_DISABLED')
            self:RegisterUnitEvent('UNIT_FLAGS', 'player')
        end,
        events = { 'PLAYER_REGEN_ENABLED', 'PLAYER_REGEN_DISABLED', 'UNIT_FLAGS' },
    },
    Target = {
        enable = function(self)
            self:RegisterEvent('PLAYER_TARGET_CHANGED')
        end,
        events = { 'PLAYER_TARGET_CHANGED' },
    },
    Casting = {
        enable = function(self)
            self:RegisterUnitEvent('UNIT_SPELLCAST_START', 'player')
            self:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')
            self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', 'player')
            self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_STOP', 'player')
        end,
        events = {
            'UNIT_SPELLCAST_START',
            'UNIT_SPELLCAST_STOP',
            'UNIT_SPELLCAST_CHANNEL_START',
            'UNIT_SPELLCAST_CHANNEL_STOP',
        },
    },
    Health = {
        enable = function(self)
            self:RegisterUnitEvent('UNIT_HEALTH', 'player')
        end,
        events = { 'UNIT_HEALTH' },
    },
}

function ACTIONBAR:UpdateFaderSettings()
    for key, option in pairs(options) do
        if C.DB.Actionbar[key] then
            if option.enable then
                option.enable(ACTIONBAR.fadeParent)
            end
        else
            if option.events and next(option.events) then
                for _, event in ipairs(option.events) do
                    ACTIONBAR.fadeParent:UnregisterEvent(event)
                end
            end
        end
    end
end

local function UpdateAfterCombat(event)
    ACTIONBAR:UpdateFaderState()
    F:UnregisterEvent(event, UpdateAfterCombat)
end

function ACTIONBAR:UpdateFaderState()
    if InCombatLockdown() then
        F:RegisterEvent('PLAYER_REGEN_ENABLED', UpdateAfterCombat)
        return
    end

    for key, name in pairs(barsList) do
        local bar = _G[name]
        if bar then
            bar:SetParent(C.DB.Actionbar[key] and ACTIONBAR.fadeParent or _G.UIParent)
        end
    end

    if not ACTIONBAR.isHooked then
        for _, button in ipairs(ACTIONBAR.buttons) do
            button:HookScript('OnEnter', ACTIONBAR.Button_OnEnter)
            button:HookScript('OnLeave', ACTIONBAR.Button_OnLeave)
        end
        ACTIONBAR.isHooked = true
    end
end

local function DisableCooldownBling()
    for _, v in pairs(_G) do
        if type(v) == 'table' and type(v.SetDrawBling) == 'function' then
            v:SetDrawBling(false)
        end
    end
end

function ACTIONBAR:BarFade()
    if not C.DB.Actionbar.Fader then
        return
    end

    ACTIONBAR.fadeParent = CreateFrame('Frame', 'FreeUIActionbarFadeParent', _G.UIParent, 'SecureHandlerStateTemplate')
    RegisterStateDriver(ACTIONBAR.fadeParent, 'visibility', '[petbattle] hide; show')
    ACTIONBAR.fadeParent:SetAlpha(C.DB.Actionbar.FadeOutAlpha)
    ACTIONBAR.fadeParent:RegisterEvent('ACTIONBAR_SHOWGRID')
    ACTIONBAR.fadeParent:RegisterEvent('ACTIONBAR_HIDEGRID')
    ACTIONBAR.fadeParent:SetScript('OnEvent', ACTIONBAR.FadeParent_OnEvent)

    ACTIONBAR:UpdateFaderSettings()
    ACTIONBAR:UpdateFaderState()

    DisableCooldownBling()
end
