local F, C, L = unpack(select(2, ...))

local function OnEvent(event)
	if event == "VIGNETTE_ADDED" then
		PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
		RaidNotice_AddMessage(RaidWarningFrame, "Rare spotted", ChatTypeInfo["RAID_WARNING"])
	else
		RaidNotice_AddMessage(RaidWarningFrame, "Rare hidden", ChatTypeInfo["RAID_WARNING"])
	end
end

if C.general.rareAlert then
	F.RegisterEvent("VIGNETTE_ADDED", OnEvent)
	F.RegisterEvent("VIGNETTE_REMOVED", OnEvent)
end

F.AddOptionsCallback("general", "rareAlert", function(event)
	if C.general.rareAlert then
		F.RegisterEvent("VIGNETTE_ADDED", OnEvent)
		F.RegisterEvent("VIGNETTE_REMOVED", OnEvent)
	else
		F.UnregisterEvent("VIGNETTE_ADDED", OnEvent)
		F.UnregisterEvent("VIGNETTE_REMOVED", OnEvent)
	end
end)