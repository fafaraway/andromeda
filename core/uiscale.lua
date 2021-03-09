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
    local scale = GetBestScale() * _G.FREE_ADB.ui_scale

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

F:RegisterEvent('PLAYER_LOGIN', function()
    if C.DB.installation.complete then
        F:SetupUIScale()
        F:RegisterEvent('UI_SCALE_CHANGED', UpdatePixelScale)
    else
        F:SetupUIScale(true)
    end
end)
