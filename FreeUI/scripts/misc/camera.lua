local F, C = unpack(select(2, ...))

if IsAddOnLoaded('DynamicCam') then return end
if not C.general.camera then return end

-- based on FasterCamera by Ketho

local oldZoomIn = CameraZoomIn
local oldZoomOut = CameraZoomOut

function CameraZoomIn(distance)
	oldZoomIn(C.general.cameraZoomSpeed)
end

function CameraZoomOut(distance)
	oldZoomOut(C.general.cameraZoomSpeed)
end


local oldVehicleZoomIn = VehicleCameraZoomIn
local oldVehicleZoomOut = VehicleCameraZoomOut

function VehicleCameraZoomIn(distance)
	oldVehicleZoomIn(C.general.cameraZoomSpeed)
end

function VehicleCameraZoomOut(distance)
	oldVehicleZoomOut(C.general.cameraZoomSpeed)
end



local f = CreateFrame('Frame')

function f:OnEvent(event, addon)
	self:SetScript('OnUpdate', f.OnUpdate)
	self:UnregisterEvent(event)
end

f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', f.OnEvent)

if tonumber(GetCVar('cameraDistanceMaxZoomFactor')) ~= 2.6 then
	SetCVar('cameraDistanceMaxZoomFactor', 2.6)
end
