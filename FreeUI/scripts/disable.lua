local F, C, L = unpack(select(2, ...))

InterfaceOptionsFrameCategoriesButton10:SetParent(FreeUIHider)
InterfaceOptionsFrameCategoriesButton11:SetParent(FreeUIHider)

InterfaceOptionsFrameCategoriesButton12:SetPoint("TOPLEFT", InterfaceOptionsFrameCategoriesButton9, "BOTTOMLEFT")

InterfaceOptionsBuffsPanelDispellableDebuffs:Disable()
InterfaceOptionsBuffsPanelDispellableDebuffsText:SetTextColor(.5, .5, .5)
InterfaceOptionsBuffsPanelCastableBuffs:Disable()
InterfaceOptionsBuffsPanelCastableBuffsText:SetTextColor(.5, .5, .5)
InterfaceOptionsBuffsPanelShowAllEnemyDebuffs:Disable()
InterfaceOptionsBuffsPanelShowAllEnemyDebuffsText:SetTextColor(.5, .5, .5)