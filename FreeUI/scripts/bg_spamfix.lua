local F, C, L = unpack(select(2, ...))

-- Remove Boss Emote spam during BG
local BATTLEGROUNDS = {
	["Wintergrasp"] = true,
	["Tol Barad"] = true,
	["Isle of Conquest"] = true,
	["Strand of the Ancients"] = true,
	["Alterac Valley"] = true,
	["Warsong Gulch"] = true,
	["Twin Peaks"] = true,
	["Arathi Basin"] = true,
	["Eye of the Storm"] = true,
	["Battle for Gilneas"] = true,
	["Deepwind Gorge"] = true,
	["Silvershard Mines"] = true,
	["The Battle for Gilneas"] = true,
	["Temple of Kotmogu"] = true,
}

local Fixer = _G.CreateFrame("Frame")
local RaidBossEmoteFrame, spamDisabled = _G.RaidBossEmoteFrame
local function ToggleBossEmotes()
	if BATTLEGROUNDS[GetZoneText()] then 
		RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_EMOTE")
		spamDisabled = true
	elseif spamDisabled then
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		spamDisabled = false
	end
end

Fixer:RegisterEvent("PLAYER_ENTERING_WORLD")
Fixer:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Fixer:SetScript("OnEvent", ToggleBossEmotes)