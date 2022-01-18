local F, C = unpack(select(2, ...))

local function GetBestScale()
    local scale = math.max(.4, math.min(1.15, 768 / C.ScreenHeight))
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
function F:UpdatePixelScale(event)
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


