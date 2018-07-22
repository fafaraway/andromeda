

local F, C, L = unpack(select(2, ...))

if IsAddOnLoaded("Aurora") then
	print("FreeUI includes an efficient built-in version of Aurora.")
	print("It's highly recommended that you disable Aurora.")
	return
end




local useButtonGradientColour
local _, class = UnitClass("player")

local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b



C.themes = {}
C.themes["FreeUI"] = {}

-- [[ Initialize addon ]]

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(_, _, addon)


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




