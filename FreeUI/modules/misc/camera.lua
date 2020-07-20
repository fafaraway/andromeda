local F, C = unpack(select(2, ...))
local MISC, cfg = F:GetModule('Misc'), C.General




function MISC:FasterCamera()
	if not cfg.fasterCam then return end

	local oldZoomIn = CameraZoomIn
	local oldZoomOut = CameraZoomOut
	local oldVehicleZoomIn = VehicleCameraZoomIn
	local oldVehicleZoomOut = VehicleCameraZoomOut
	local newZoomSpeed = 4

	function CameraZoomIn(distance)
		oldZoomIn(newZoomSpeed)
	end

	function CameraZoomOut(distance)
		oldZoomOut(newZoomSpeed)
	end

	function VehicleCameraZoomIn(distance)
		oldVehicleZoomIn(newZoomSpeed)
	end

	function VehicleCameraZoomOut(distance)
		oldVehicleZoomOut(newZoomSpeed)
	end
end

MISC:RegisterMisc("FasterCamera", MISC.FasterCamera)




local function SetCam(cmd)
	ConsoleExec('ActionCam ' .. cmd)
end

UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')

SetCam(cfg.actionCam and 'basic' or 'off')




