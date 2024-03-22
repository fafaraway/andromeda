local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

C.Themes = {}
C.BlizzThemes = {}
C.AddonThemes = {}

function THEME:RegisterSkin(addonName, func)
    C.AddonThemes[addonName] = func
end

function THEME:LoadSkins(list)
    if not next(list) then
        return
    end

    for addonName, func in pairs(list) do
        local isLoaded, isFinished = IsAddOnLoaded(addonName)
        if isLoaded and isFinished then
            func()
            list[addonName] = nil
        end
    end
end

function THEME:LoadAddOnSkins()
    for _, func in pairs(C.BlizzThemes) do
        func()
    end
    wipe(C.BlizzThemes)

    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        wipe(C.Themes)
    end

    THEME:LoadSkins(C.Themes) -- blizzard ui
    THEME:LoadSkins(C.AddonThemes) -- other addons

    F:RegisterEvent('ADDON_LOADED', function(_, addonName)
        local blizzFunc = C.Themes[addonName]
        if blizzFunc then
            blizzFunc()
            C.Themes[addonName] = nil
        end

        local addonFunc = C.AddonThemes[addonName]
        if addonFunc then
            addonFunc()
            C.AddonThemes[addonName] = nil
        end
    end)
end

do
    local function reskinTimerBar(bar)
        bar:SetSize(200, 18)
        F.StripTextures(bar)

        local statusbar = bar.StatusBar or _G[bar:GetName() .. 'StatusBar']
        if statusbar then
            statusbar:SetAllPoints()
        elseif bar.SetStatusBarTexture then
            bar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
        end

        bar.bg = F.SetBD(bar)
        bar.bg:SetBackdropBorderColor(0, 0, 0)
    end

    function THEME:ReskinMirrorBars()
        hooksecurefunc(MirrorTimerContainer, "SetupTimer", function(self, timer)
            local bar = self:GetAvailableTimer(timer)
            if not bar.styled then
                reskinTimerBar(bar)
                bar.styled = true
            end
        end)
    end

    local function updateTimerTracker()
        for _, timer in pairs(_G.TimerTracker.timerList) do
            if timer.bar and not timer.bar.styled then
                reskinTimerBar(timer.bar)

                timer.bar.styled = true
            end
        end
    end

    function THEME:ReskinTimerTrakcer()
        if not _G.ANDROMEDA_ADB.ReskinBlizz then
            return
        end

        updateTimerTracker()

        F:RegisterEvent('START_TIMER', updateTimerTracker)
    end
end

function THEME:OnLogin()
    THEME:LoadAddOnSkins()

    THEME:ReskinMirrorBars()
    THEME:ReskinTimerTrakcer()
    THEME:ReskinDBM()
    THEME:ReskinPGF()
    THEME:ReskinREHack()
    THEME:ReskinMRT()
end
