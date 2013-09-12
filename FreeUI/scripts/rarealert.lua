local F, C, L = unpack(select(2, ...))

local general = C.general

local function OnEvent(event)
	if general.rareAlert_playSound then
		PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
	end

	RaidNotice_AddMessage(RaidWarningFrame, "Rare spotted!", ChatTypeInfo["RAID_WARNING"])
end

if general.rareAlert then
	F.RegisterEvent("VIGNETTE_ADDED", OnEvent)
end

F.AddOptionsCallback("general", "rareAlert", function()
	if general.rareAlert then
		F.RegisterEvent("VIGNETTE_ADDED", OnEvent)
	else
		F.UnregisterEvent("VIGNETTE_ADDED", OnEvent)
	end
end)