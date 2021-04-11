local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local IsInInstance = IsInInstance
local UnitAffectingCombat = UnitAffectingCombat
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitExists = UnitExists
local hooksecurefunc = hooksecurefunc
local ActionButton1Cooldown = ActionButton1Cooldown

local F, C = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR

local barsList = {
    'FreeUI_ActionBar1',
    'FreeUI_ActionBar2',
    'FreeUI_ActionBar3',
    'FreeUI_ActionBar4',
    'FreeUI_ActionBar5',
    'FreeUI_CustomBar',
    'FreeUI_ActionBarPet',
    'FreeUI_ActionBarStance',
}

function ACTIONBAR:Bar_OnEnter()
    local parent = ACTIONBAR.fadeParent
    if not parent.mouseLock then
        F:UIFrameFadeIn(parent, ACTIONBAR.fadeInDuration, parent:GetAlpha(), ACTIONBAR.fadeInAlpha)
    end
end

function ACTIONBAR:Bar_OnLeave()
    local parent = ACTIONBAR.fadeParent
    if not parent.mouseLock then
        F:UIFrameFadeOut(parent, ACTIONBAR.fadeOutDuration, parent:GetAlpha(), ACTIONBAR.fadeOutAlpha)
    end
end

function ACTIONBAR:FadeParent_OnEvent()
    local _, instanceType = IsInInstance()
    local isCombating = UnitAffectingCombat('player') and C.DB.Actionbar.ConditionCombat
    local isTargeting = (UnitExists('target') or UnitExists('focus')) and C.DB.Actionbar.ConditionTarget
    local isInPvPArea = (instanceType == 'pvp' or instanceType == 'arena') and C.DB.Actionbar.ConditionPvP
    local isInDungeon = (instanceType == 'party' or instanceType == 'raid') and C.DB.Actionbar.ConditionDungeon
    local isInVehicle = UnitHasVehicleUI('player') and C.DB.Actionbar.ConditionVehicle

    if isCombating or isTargeting or isInPvPArea or isInDungeon or isInVehicle then
        self.mouseLock = true
        F:UIFrameFadeIn(self, ACTIONBAR.fadeInDuration, self:GetAlpha(), ACTIONBAR.fadeInAlpha)
    else
        self.mouseLock = false
        F:UIFrameFadeOut(self, ACTIONBAR.fadeOutDuration, self:GetAlpha(), ACTIONBAR.fadeOutAlpha)
    end
end

function ACTIONBAR:HookActionBar()
    for _, v in pairs(barsList) do
        local bar = _G[v]
        if bar then
            bar:SetParent(ACTIONBAR.fadeParent)
            bar:HookScript('OnEnter', ACTIONBAR.Bar_OnEnter)
            bar:HookScript('OnLeave', ACTIONBAR.Bar_OnLeave)
        end
    end

    for _, button in pairs(ACTIONBAR.buttons) do
        button:HookScript('OnEnter', ACTIONBAR.Bar_OnEnter)
        button:HookScript('OnLeave', ACTIONBAR.Bar_OnLeave)
    end
end

local function DisableCooldownBling()
    for _, v in pairs(_G) do
        if type(v) == 'table' and type(v.SetDrawBling) == 'function' then
            v:SetDrawBling(false)
        end
    end
end

function ACTIONBAR:UpdateActionBarFade()
    if not C.DB.Actionbar.DynamicFade then
        return
    end

    ACTIONBAR.fadeOutAlpha = C.DB.Actionbar.FadeOutAlpha or 0
    ACTIONBAR.fadeInAlpha = C.DB.Actionbar.FadeInAlpha or 1
    ACTIONBAR.fadeInDuration = C.DB.Actionbar.FadeInDuration or .3
    ACTIONBAR.fadeOutDuration = C.DB.Actionbar.FadeOutDuration or 1

    ACTIONBAR.fadeParent = CreateFrame('Frame', nil, _G.UIParent)
    ACTIONBAR.fadeParent:SetAlpha(ACTIONBAR.fadeOutAlpha)
    ACTIONBAR.fadeParent:SetScript('OnEvent', ACTIONBAR.FadeParent_OnEvent)

    if C.DB.Actionbar.ConditionCombat then
        ACTIONBAR.fadeParent:RegisterEvent('PLAYER_REGEN_DISABLED')
        ACTIONBAR.fadeParent:RegisterEvent('PLAYER_REGEN_ENABLED')
    end

    if C.DB.Actionbar.ConditionTarget then
        ACTIONBAR.fadeParent:RegisterEvent('PLAYER_TARGET_CHANGED')
        ACTIONBAR.fadeParent:RegisterEvent('PLAYER_FOCUS_CHANGED')
    end

    if C.DB.Actionbar.ConditionPvP or C.DB.Actionbar.ConditionDungeon then
        ACTIONBAR.fadeParent:RegisterEvent('PLAYER_ENTERING_WORLD')
        ACTIONBAR.fadeParent:RegisterEvent('ZONE_CHANGED_NEW_AREA')
    end

    if C.DB.Actionbar.ConditionVehicle then
        ACTIONBAR.fadeParent:RegisterEvent('UNIT_ENTERED_VEHICLE')
        ACTIONBAR.fadeParent:RegisterEvent('UNIT_EXITED_VEHICLE')
        ACTIONBAR.fadeParent:RegisterEvent('VEHICLE_UPDATE')
    end

    ACTIONBAR.HookActionBar()

    -- Completely remove cooldown bling
    DisableCooldownBling()
    hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, 'SetCooldown', function(self)
        self:SetDrawBling(false)
    end)
end
