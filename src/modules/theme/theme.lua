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
    local function ReskinTimerBar(bar)
        bar:SetSize(200, 18)
        F.StripTextures(bar)

        local statusbar = _G[bar:GetName() .. 'StatusBar']
        if statusbar then
            statusbar:SetAllPoints()
            statusbar:SetStatusBarTexture(C.Assets.Texture.StatusbarNormal)
        else
            bar:SetStatusBarTexture(C.Assets.Texture.StatusbarNormal)
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

    function THEME:ReskinBlizzBars()
        if not _G.ANDROMEDA_ADB.ReskinBlizz then
            return
        end

        ReskinMirrorBars()
        F:RegisterEvent('START_TIMER', UpdateTimerTracker)
    end
end

function THEME:OnLogin()
    THEME:LoadAddOnSkins()

    THEME:ReskinBlizzBars()
    THEME:ReskinDBM()
    THEME:ReskinPGF()
    THEME:ReskinREHack()
    THEME:ReskinMRT()
end
