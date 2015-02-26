local F, C = unpack(select(2, ...))

-- disable Blizzard UF options
if C.unitframes.enable then
	InterfaceOptionsFrameCategoriesButton10:SetParent(FreeUIHider)
	InterfaceOptionsFrameCategoriesButton11:SetParent(FreeUIHider)
	InterfaceOptionsFrameCategoriesButton12:SetPoint("TOPLEFT", InterfaceOptionsFrameCategoriesButton9, "BOTTOMLEFT")
end

-- disable sorting and loot order
if C.bags.style == 1 then
	InterfaceOptionsControlsPanelReverseCleanUpBags:Disable()
	InterfaceOptionsControlsPanelReverseCleanUpBagsText:SetTextColor(.5, .5, .5)
	InterfaceOptionsControlsPanelReverseNewLoot:Disable()
	InterfaceOptionsControlsPanelReverseNewLootText:SetTextColor(.5, .5, .5)
end

-- disable buff options
InterfaceOptionsBuffsPanelDispellableDebuffs:Disable()
InterfaceOptionsBuffsPanelDispellableDebuffsText:SetTextColor(.5, .5, .5)
InterfaceOptionsBuffsPanelCastableBuffs:Disable()
InterfaceOptionsBuffsPanelCastableBuffsText:SetTextColor(.5, .5, .5)
InterfaceOptionsBuffsPanelShowAllEnemyDebuffs:Disable()
InterfaceOptionsBuffsPanelShowAllEnemyDebuffsText:SetTextColor(.5, .5, .5)

-- disable store button
GameMenuFrame:HookScript("OnShow", function(self)
	GameMenuButtonStore:Hide()
	GameMenuButtonWhatsNew:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -1)
end)