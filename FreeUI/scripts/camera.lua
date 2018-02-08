local F, C, L = unpack(select(2, ...))

-- Author: Ketho (EU-Boulderfist)
-- License: Public Domain

local db

db = {
	["speed"] = C.camera.speed,
	["increment"] = C.camera.increment,
	["distance"] = C.camera.distance,
}

	----------------
	--- Prehooks ---
	----------------

local oldZoomIn = CameraZoomIn
local oldZoomOut = CameraZoomOut

function CameraZoomIn(distance)
	oldZoomIn(db.increment)
end

function CameraZoomOut(distance)
	oldZoomOut(db.increment)
end

-- tried this out in the SotA demolishers
-- the normal camera zoom functions seemed to be used instead
-- I suppose both can be used interchangeably
local oldVehicleZoomIn = VehicleCameraZoomIn
local oldVehicleZoomOut = VehicleCameraZoomOut

function VehicleCameraZoomIn(distance)
	oldVehicleZoomIn(db.increment)
end

function VehicleCameraZoomOut(distance)
	oldVehicleZoomOut(db.increment)
end

	---------------
	--- Options ---
	---------------

local cvar = {
	"cameraDistanceMoveSpeed",
	"cameraDistanceMaxZoomFactor",
}

	----------------------
	--- Initialization ---
	----------------------

-- delay setting/overriding the CVars because it's either
-- not yet ready or is being reverted/overridden by something else
-- not sure if there is any event to wait for instead
C_Timer.After(1, function()
	-- not actually necessary to override from savedvars
	-- but better to do this if other addons also set it
	SetCVar("cameraDistanceMaxZoomFactor", db.distance)
	--SetCVar("cameraDistanceMoveSpeed", db.speed)
end)

local f = CreateFrame("Frame")

function f:OnEvent(event, addon)
	self:SetScript("OnUpdate", f.OnUpdate)
	self:UnregisterEvent(event)
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)