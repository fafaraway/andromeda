local F, C = unpack(select(2, ...))

if not C.general.interrupt then return end

-- it will always be enabled in arena and raid, mention this. Only included necessary options
local enableInParty = C.general.interrupt_party
local enableInBGs = C.general.interrupt_bgs
local enableInLFG = C.general.interrupt_lfg
local enableOutdoors = C.general.interrupt_outdoors

local playerName = UnitName("player")
local LE_PARTY_CATEGORY_INSTANCE, LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_INSTANCE, LE_PARTY_CATEGORY_HOME

F.RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", function(_, _, subEvent, _, _, sourceName, _, _, _, destName, _, _, _, _, _, spellID)
	if subEvent == "SPELL_INTERRUPT" and sourceName == playerName then
		local channel

		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			local isInstance, instanceType = IsInInstance()

			if isInstance then
				if instanceType == "pvp" then
					if enableInBGs then
						channel = "INSTANCE_CHAT"
					end
				elseif enableInLFG and (instanceType == "raid" or instanceType == "arena" or enableInParty) then -- if not raid or arena (which are always enabled), it can only be scenario or party
					channel = "INSTANCE_CHAT"
				end
			end
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			local isInstance, instanceType = IsInInstance()

			if isInstance then
				if (instanceType == "party" and enableInParty) then
					channel = "PARTY"
				elseif instanceType == "raid" then
					channel = "RAID"
				end
			elseif enableOutdoors then
				local num = GetNumGroupMembers()

				if num > 5 then
					channel = "RAID"
				elseif num > 0 and enableInParty then
					channel = "PARTY"
				end
			end
		end

		if channel then
			SendChatMessage("Interrupted: "..destName.."'s "..GetSpellLink(spellID)..".", channel)
		end
	end
end)

F.AddOptionsCallback("general", "interrupt_party", function()
	enableInParty = C.general.interrupt_party
end)

F.AddOptionsCallback("general", "interrupt_bgs", function()
	enableInBGs = C.general.interrupt_bgs
end)

F.AddOptionsCallback("general", "interrupt_lfg", function()
	enableInLFG = C.general.interrupt_lfg
end)

F.AddOptionsCallback("general", "interrupt_outdoors", function()
	enableOutdoors = C.general.interrupt_outdoors
end)