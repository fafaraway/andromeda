local _, C = unpack(select(2, ...))

if C.general.interrupt == false then return end

local interrupt = CreateFrame("Frame")
interrupt:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
interrupt:SetScript("OnEvent", function(_, _, _, subevent, _, _, sourceName, _, _, _, destName, _, _, _, _, _, spellID)
	local inParty = GetNumPartyMembers() >= 1
	local inRaid = GetNumRaidMembers() >= 1
	if subevent == "SPELL_INTERRUPT" then
		if sourceName ~= UnitName("player") then return end
		if GetCurrentMapAreaID() == 708 then return end

		local _, instanceType = IsInInstance()
		if instanceType == "pvp" or instanceType == "none" then return end

		if instanceType == "arena" then
			output = "PARTY"
		elseif inRaid then
			output = "RAID" 
		elseif inParty then
			return
		end

		if inParty or inRaid then
			SendChatMessage("Interrupted: "..destName.. "'s " ..GetSpellLink(spellID).. ".", output)
		end
	end
end)