local F, C = unpack(select(2, ...))

if not C.general.interrupt then return end

local playerName = UnitName("player")

local interrupt = CreateFrame("Frame")
interrupt:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
interrupt:SetScript("OnEvent", function(_, _, _, subevent, _, _, sourceName, _, _, _, destName, _, _, _, _, _, spellID)
	if subevent == "SPELL_INTERRUPT" then
		if sourceName == playerName and GetNumGroupMembers() > 5 and GetCurrentMapAreaID() ~= 708 then
			local _, instanceType = IsInInstance()
			if instanceType ~= "pvp" then
				SendChatMessage("Interrupted: "..destName.. "'s " ..GetSpellLink(spellID).. ".", "INSTANCE_CHAT")
			end
		end
	end
end)