--local _, ns = ...
--local B, C, L, DB, F = unpack(ns)

local F, C, L = unpack(select(2, ...))




local useButtonGradientColour
local _, class = UnitClass("player")

local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b



C.themes = {}
C.themes["FreeUI"] = {}

-- [[ Initialize addon ]]

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(_, _, addon)
	--[[if addon == "FreeUI" then


		useButtonGradientColour = C.themeconfig.useButtonGradientColour

		if useButtonGradientColour then
			buttonR, buttonG, buttonB, buttonA = unpack(C.themeconfig.buttonGradientColour)
		else
			buttonR, buttonG, buttonB, buttonA = unpack(C.themeconfig.buttonSolidColour)
		end

		if C.themeconfig.useCustomColour then
			r, g, b = C.themeconfig.customColour.r, C.themeconfig.customColour.g, C.themeconfig.customColour.b
		end

		-- for modules
		C.r, C.g, C.b = r, g, b
	end]]

	-- [[ Load modules ]]

	-- check if the addon loaded is supported by Aurora, and if it is, execute its module
	local addonModule = C.themes[addon]
	if addonModule then
		if type(addonModule) == "function" then
			addonModule()
		else
			for _, moduleFunc in pairs(addonModule) do
				moduleFunc()
			end
		end
	end
end)




