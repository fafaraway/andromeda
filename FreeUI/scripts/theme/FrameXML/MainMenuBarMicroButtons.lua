local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local microButtons = {
		CharacterMicroButtonAlert,
		TalentMicroButtonAlert,
		CollectionsMicroButtonAlert,
		LFDMicroButtonAlert,
		EJMicroButtonAlert,
		StoreMicroButtonAlert,
		ZoneAbilityButtonAlert,
	}

	for _, alert in pairs(microButtons) do
		F.ReskinClose(alert.CloseButton)
	end
end)