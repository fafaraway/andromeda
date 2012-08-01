local F, C, L = unpack(select(2, ...))

InterfaceOptionsFrameCategoriesButton10:Hide()
InterfaceOptionsFrameCategoriesButton10.Show = F.dummy
InterfaceOptionsFrameCategoriesButton11:Hide()
InterfaceOptionsFrameCategoriesButton11.Show = F.dummy

InterfaceOptionsFrameCategoriesButton12:SetPoint("TOPLEFT", InterfaceOptionsFrameCategoriesButton9, "BOTTOMLEFT")

InterfaceOptionsCombatTextPanelEnableFCT:Disable()
InterfaceOptionsCombatTextPanelEnableFCTText:SetTextColor(.5, .5, .5)

InterfaceOptionsBuffsPanelDispellableDebuffs:Disable()
InterfaceOptionsBuffsPanelDispellableDebuffsText:SetTextColor(.5, .5, .5)
InterfaceOptionsBuffsPanelCastableBuffs:Disable()
InterfaceOptionsBuffsPanelCastableBuffsText:SetTextColor(.5, .5, .5)
InterfaceOptionsBuffsPanelShowAllEnemyDebuffs:Disable()
InterfaceOptionsBuffsPanelShowAllEnemyDebuffsText:SetTextColor(.5, .5, .5)