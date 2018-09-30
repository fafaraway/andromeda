local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("camera")

-- FasterCamera by Ketho
-- Increases camera zoom speed

local oldZoomIn = CameraZoomIn
local oldZoomOut = CameraZoomOut

function CameraZoomIn(distance)
	oldZoomIn(C.camera.increment)
end

function CameraZoomOut(distance)
	oldZoomOut(C.camera.increment)
end


local oldVehicleZoomIn = VehicleCameraZoomIn
local oldVehicleZoomOut = VehicleCameraZoomOut

function VehicleCameraZoomIn(distance)
	oldVehicleZoomIn(C.camera.increment)
end

function VehicleCameraZoomOut(distance)
	oldVehicleZoomOut(C.camera.increment)
end


local cvar = {
	"cameraDistanceMoveSpeed",
	"cameraDistanceMaxZoomFactor",
}


C_Timer.After(1, function()

	SetCVar("cameraDistanceMaxZoomFactor", C.camera.distance)

end)

local f = CreateFrame("Frame")

function f:OnEvent(event, addon)
	self:SetScript("OnUpdate", f.OnUpdate)
	self:UnregisterEvent(event)
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)


function module:OnLogin()

	if tonumber(GetCVar("cameraDistanceMaxZoomFactor")) ~= 2.6 then
		SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	end
end