local _G = _G
local unpack = unpack
local select = select
local max = max
local min = min
local InCombatLockdown = InCombatLockdown
local GetPhysicalScreenSize = GetPhysicalScreenSize

local F, C = unpack(select(2, ...))

local function GetBestScale()
    local scale = max(.4, min(1.15, 768 / C.ScreenHeight))
    return F:Round(scale, 2)
end

function F:SetupUIScale(init)
    local scale = GetBestScale() * _G.FREE_ADB.UIScale

    if init then
        local pixel = 1
        local ratio = 768 / C.ScreenHeight
        C.Mult = (pixel / scale) - ((pixel - ratio) / scale)
    elseif not InCombatLockdown() then
        _G.UIParent:SetScale(scale)
    end
end

local isScaling = false
local function UpdatePixelScale(event)
    if isScaling then
        return
    end

    isScaling = true

    if event == 'UI_SCALE_CHANGED' then
        C.ScreenWidth, C.ScreenHeight = GetPhysicalScreenSize()
    end

    F:SetupUIScale(true)
    F:SetupUIScale()

    isScaling = false
end

local Trunc = function(s)
    return s >= 0 and s - s % 01 or s - s % -1
end
local Round = function(s)
    return s >= 0 and s - s % -1 or s - s % 01
end
function F:Scale(n)
    local m = C.Mult
    return (m == 1 or n == 0) and n or ((m < 1 and Trunc(n / m) or Round(n / m)) * m)
end

F:RegisterEvent('PLAYER_LOGIN', function()
    if C.DB.InstallationComplete then
        F:SetupUIScale()
        F:RegisterEvent('UI_SCALE_CHANGED', UpdatePixelScale)

        _G.Display_UseUIScale:Kill()
        _G.Display_UIScaleSlider:Kill()
    else
        F:SetupUIScale(true)
    end
end)
