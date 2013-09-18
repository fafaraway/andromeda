local F, C, L = unpack(select(2, ...))

local general = C.general

local kukuru = "Kukuru's Treasure Cache"

if GetLocale() == "ruRU" then
	kukuru = "Клад Кукуру"
end

local function OnEvent(event, vignetteInstanceID)
	if vignetteInstanceID then
		local _, _, name = C_Vignettes.GetVignetteInfoFromInstanceID(vignetteInstanceID)

		if name and name == kukuru then
			return
		end
	end

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