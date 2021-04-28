local _G = _G
local select = select
local unpack = unpack
local wipe = wipe
local format = format
local IsAddOnLoaded = IsAddOnLoaded

local F, C = unpack(select(2, ...))
local THEME = F.THEME

C.Themes = {}
C.BlizzThemes = {}

function THEME:LoadDefaultSkins()
    for _, func in pairs(C.BlizzThemes) do func() end

    wipe(C.BlizzThemes)

    if not _G.FREE_ADB.ReskinBlizz then return end

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

function THEME:LoadWithAddOn(addonName, value, func)
    local function loadFunc(event, addon)
        -- if not _G.FREE_ADB[value] then
        --     return
        -- end

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
    if not THEME.SkinList[name] then THEME.SkinList[name] = func end
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
end
