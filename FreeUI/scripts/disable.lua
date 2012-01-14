local F, C, L = unpack(select(2, ...))

InterfaceOptionsFrameCategoriesButton10:Hide()
InterfaceOptionsFrameCategoriesButton10.Show = F.dummy
InterfaceOptionsFrameCategoriesButton11:Hide()
InterfaceOptionsFrameCategoriesButton11.Show = F.dummy
InterfaceOptionsFrameCategoriesButton12:Hide()
InterfaceOptionsFrameCategoriesButton12.Show = F.dummy

InterfaceOptionsFrameCategoriesButton13:SetPoint("TOPLEFT", InterfaceOptionsFrameCategoriesButton9, "BOTTOMLEFT")

InterfaceOptionsCombatTextPanelEnableFCT:Disable()

TalentMicroButtonAlert:Hide()
TalentMicroButtonAlert.Show = F.dummy