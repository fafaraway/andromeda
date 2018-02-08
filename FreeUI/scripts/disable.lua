local F, C = unpack(select(2, ...))

-- disable Blizzard UF options
if C.unitframes.enable then
	InterfaceOptionsFrameCategoriesButton10:SetParent(FreeUIHider)
end

-- disable store button
GameMenuFrame:HookScript("OnShow", function(self)
	GameMenuButtonStore:Hide()
	GameMenuButtonWhatsNew:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -1)
end)


-- disable new talent alert
local f = CreateFrame("Frame")
function f:OnEvent(event)
	hooksecurefunc("MainMenuMicroButton_ShowAlert", function(alert)
		alert:Hide()
	end)
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LEVEL_UP")
f:SetScript("OnEvent", f.OnEvent)
