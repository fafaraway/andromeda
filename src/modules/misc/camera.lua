-- Increases camera zoom speed
-- Based on FasterCamera by Ketho
-- https://www.wowinterface.com/downloads/info20483-FasterCamera.html

local F, C = unpack(select(2, ...))
local CAMERA = F:GetModule('Camera')

local datas = {
    increment = 4,
    speed = 20,
    distance = 2.6,
    nearDistance = 5,
    nearIncrement = 1,
}

local function SetupZooming(func, increment)
    -- anything not 1 could be a custom zoom increment from another addon
    if increment ~= 1 then
        func(increment)
    else
        local isCloseUp = GetCameraZoom() < datas.nearDistance and datas.increment > 1
        func(isCloseUp and datas.nearIncrement or datas.increment)
    end
end

local function UpdateZooming()
    local oldZoomIn = _G.CameraZoomIn
    local oldZoomOut = _G.CameraZoomOut

    function _G.CameraZoomIn(v)
        SetupZooming(oldZoomIn, v)
    end

    function _G.CameraZoomOut(v)
        SetupZooming(oldZoomOut, v)
    end
end

local function CameraZoom_OnEvent()
    F:Delay(1, function()
        -- not actually necessary to override from savedvars
        -- but better to do this if other addons also set it
        SetCVar('cameraDistanceMaxZoomFactor', datas.distance)
        SetCVar('cameraZoomSpeed', datas.speed)
    end)

    F:UnregisterEvent('ADDON_LOADED', CameraZoom_OnEvent)
end

-- Camera action mode
local function Exec(cmd)
    ConsoleExec('ActionCam ' .. cmd)
end

function CAMERA:UpdateActionCamera()
    if C.DB.General.ActionCamera then
        Exec('basic')
    else
        Exec('off')
    end
end

function CAMERA:ActionCamera()
    _G.UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')

    CAMERA:UpdateActionCamera()
end

function CAMERA:OnLogin()
    if C.DB.General.FasterZooming then
        UpdateZooming()
        F:RegisterEvent('ADDON_LOADED', CameraZoom_OnEvent)
    else
        F:UnregisterEvent('ADDON_LOADED', CameraZoom_OnEvent)
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', CAMERA.ActionCamera)
end
