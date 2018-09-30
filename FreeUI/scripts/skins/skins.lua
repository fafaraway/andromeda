local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("skins")

function module:OnLogin()
	self:ReskinDBM()
	self:ReskinSkada()
end

function module:LoadWithAddOn(addonName, value, func)
	local function loadFunc(event, addon)

		if event == "PLAYER_ENTERING_WORLD" then
			F:UnregisterEvent(event, loadFunc)
			if IsAddOnLoaded(addonName) then
				func()
				F:UnregisterEvent("ADDON_LOADED", loadFunc)
			end
		elseif event == "ADDON_LOADED" and addon == addonName then
			func()
			F:UnregisterEvent(event, loadFunc)
		end
	end

	F:RegisterEvent("PLAYER_ENTERING_WORLD", loadFunc)
	F:RegisterEvent("ADDON_LOADED", loadFunc)
end