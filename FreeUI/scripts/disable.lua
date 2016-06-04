local F, C = unpack(select(2, ...))

-- disable Blizzard UF options
if C.unitframes.enable then
	InterfaceOptionsFrameCategoriesButton10:SetParent(FreeUIHider)
	InterfaceOptionsFrameCategoriesButton11:SetParent(FreeUIHider)
	InterfaceOptionsFrameCategoriesButton12:SetPoint("TOPLEFT", InterfaceOptionsFrameCategoriesButton9, "BOTTOMLEFT")
end

-- disable store button
GameMenuFrame:HookScript("OnShow", function(self)
	GameMenuButtonStore:Hide()
	GameMenuButtonWhatsNew:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -1)
end)
