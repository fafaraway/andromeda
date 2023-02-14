-- Increases camera zoom speed
-- Based on FasterCamera by Ketho
-- https://www.wowinterface.com/downloads/info20483-FasterCamera.html

local F, C = unpack(select(2, ...))
local EC = F:RegisterModule('EnhancedCamera')

local db = {
    increment = 4,
    speed = 20,
    distance = 2.6,
    nearDistance = 5,
    nearIncrement = 1,
}

local function update(func, increment)
    -- anything not 1 could be a custom zoom increment from another addon
    if increment ~= 1 then
        func(increment)
    else
        local isCloseUp = GetCameraZoom() < db.nearDistance and db.increment > 1
        func(isCloseUp and db.nearIncrement or db.increment)
    end
end

local oldZoomIn = CameraZoomIn
local oldZoomOut = CameraZoomOut

local newZoomIn = CameraZoomIn
local newZoomOut = CameraZoomOut

function EC:UpdateCameraZooming()
    if C.DB.General.FasterZooming then
        function CameraZoomIn(v)
            update(newZoomIn, v)
        end

        function CameraZoomOut(v)
            update(newZoomOut, v)
        end
    else
        CameraZoomIn = oldZoomIn
        CameraZoomOut = oldZoomOut
    end
end

local function onEvent(_, _, addon)
    if addon == C.ADDON_NAME then
        F:Delay(1, function()
            -- not actually necessary to override from savedvars
            -- but better to do this if other addons also set it
            SetCVar('cameraDistanceMaxZoomFactor', db.distance)
            SetCVar('cameraZoomSpeed', db.speed)
        end)

        F:UnregisterEvent('ADDON_LOADED', onEvent)
    end
end

function EC:OnLogin()
    EC:UpdateCameraZooming()

    if C.DB.General.FasterZooming then
        F:RegisterEvent('ADDON_LOADED', onEvent)
    else
        F:UnregisterEvent('ADDON_LOADED', onEvent)
    end
end
