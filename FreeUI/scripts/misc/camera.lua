local F, C, L = unpack(select(2, ...))

if IsAddOnLoaded("DynamicCam") then return end

-- based on FasterCamera by Ketho

local oldZoomIn = CameraZoomIn
local oldZoomOut = CameraZoomOut

function CameraZoomIn(distance)
	oldZoomIn(C.general.cameraIncrement)
end

function CameraZoomOut(distance)
	oldZoomOut(C.general.cameraIncrement)
end


local oldVehicleZoomIn = VehicleCameraZoomIn
local oldVehicleZoomOut = VehicleCameraZoomOut

function VehicleCameraZoomIn(distance)
	oldVehicleZoomIn(C.general.cameraIncrement)
end

function VehicleCameraZoomOut(distance)
	oldVehicleZoomOut(C.general.cameraIncrement)
end




local f = CreateFrame("Frame")

function f:OnEvent(event, addon)
	self:SetScript("OnUpdate", f.OnUpdate)
	self:UnregisterEvent(event)
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

if tonumber(GetCVar("cameraDistanceMaxZoomFactor")) ~= 2.6 then
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
end
