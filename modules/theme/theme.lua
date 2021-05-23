local _G = _G
local select = select
local unpack = unpack
local wipe = wipe
local format = format
local IsAddOnLoaded = IsAddOnLoaded

local F, C = unpack(select(2, ...))
local THEME = F:RegisterModule('Theme')

C.Themes = {}
C.BlizzThemes = {}

function THEME:LoadDefaultSkins()
    for _, func in pairs(C.BlizzThemes) do
        func()
    end

    wipe(C.BlizzThemes)

    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    for addonName, func in pairs(C.Themes) do
        local isLoaded, isFinished = IsAddOnLoaded(addonName)
        if isLoaded and isFinished then
            func()
            C.Themes[addonName] = nil
        end
    end

    F:RegisterEvent('ADDON_LOADED', function(_, addonName)
        local func = C.Themes[addonName]
        if func then
            func()
            C.Themes[addonName] = nil
        end
    end)
end

function THEME:LoadWithAddOn(addonName, func)
    local function loadFunc(event, addon)
        if not _G.FREE_ADB.ReskinAddons then
            return
        end

        if event == 'PLAYER_ENTERING_WORLD' then
            F:UnregisterEvent(event, loadFunc)
            if IsAddOnLoaded(addonName) then
                func()
                F:UnregisterEvent('ADDON_LOADED', loadFunc)
            end
        elseif event == 'ADDON_LOADED' and addon == addonName then
            func()
            F:UnregisterEvent(event, loadFunc)
        end
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', loadFunc)
    F:RegisterEvent('ADDON_LOADED', loadFunc)
end

THEME.SkinList = {}
function THEME:RegisterSkin(name, func)
    if not THEME.SkinList[name] then
        THEME.SkinList[name] = func
    end
end

local function ReskinTimerBar(bar)
    bar:SetSize(200, 18)
    F.StripTextures(bar)

    local statusbar = _G[bar:GetName() .. 'StatusBar']
    if statusbar then
        statusbar:SetAllPoints()
        statusbar:SetStatusBarTexture(C.Assets.norm_tex)
    else
        bar:SetStatusBarTexture(C.Assets.norm_tex)
    end

    bar.bg = F.SetBD(bar)
    bar.bg:SetBackdropBorderColor(0, 0, 0)
end

local function UpdateTimerTracker()
    for _, timer in pairs(_G.TimerTracker.timerList) do
        if timer.bar and not timer.bar.styled then
            ReskinTimerBar(timer.bar)

            timer.bar.styled = true
        end
    end
end

local function ReskinMirrorBars()
    local previous
    for i = 1, 3 do
        local bar = _G['MirrorTimer' .. i]
        ReskinTimerBar(bar)

        local text = _G['MirrorTimer' .. i .. 'Text']
        text:ClearAllPoints()
        text:SetPoint('CENTER', bar)

        if previous then
            bar:SetPoint('TOP', previous, 'BOTTOM', 0, -5)
        end
        previous = bar
    end
end

function THEME:OnLogin()
    for name, func in next, THEME.SkinList do
        if name and type(func) == 'function' then
            local _, catch = pcall(func)
            F:ThrowError(catch, format('%s Skin', name))
        end
    end

    self:LoadDefaultSkins()
    self:ReskinABP()
    self:ReskinBigWigs()
    self:ReskinDBM()
    self:ReskinPGF()
    self:ReskinREHack()
    self:ReskinExtVendor()
    self:ReskinFriendGroups()

    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    ReskinMirrorBars()
    F:RegisterEvent('START_TIMER', UpdateTimerTracker)
end
