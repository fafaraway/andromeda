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
