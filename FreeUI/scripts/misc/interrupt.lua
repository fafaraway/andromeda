local F, C = unpack(select(2, ...))

-- always enabled in raid and arena
local playsound = C.general.interrupt_sound
local enableInParty = C.general.interrupt_party
local enableInBGs = C.general.interrupt_bgs
local enableInLFG = C.general.interrupt_lfg
local enableOutdoors = C.general.interrupt_outdoors
local interruptSound = "Interface\\AddOns\\FreeUI\\media\\sound\\Shutupfool.ogg"

local playerName = UnitName("player")
local LE_PARTY_CATEGORY_INSTANCE, LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_INSTANCE, LE_PARTY_CATEGORY_HOME

local function OnEvent(_, _, subEvent, _, sourceGUID, sourceName, _, _, _, destName, _, _, _, _, _, spellID)
	if subEvent == "SPELL_INTERRUPT" and (sourceName == playerName or sourceGUID == UnitGUID("pet")) then

		if playsound then
			PlaySoundFile(interruptSound, "Master")
		end

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
				local isRaidGroup = IsInRaid()
				local isRaidInstance = instanceType == "raid"

				if (instanceType == "party" and enableInParty) or (isRaidInstance and not isRaidGroup) then
					channel = "PARTY"
				elseif isRaidInstance then
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
			if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
				SendChatMessage("已打断: "..destName.."'s "..GetSpellLink(spellID)..".", channel)
			else
				SendChatMessage("Interrupted: "..destName.."'s "..GetSpellLink(spellID)..".", channel)
			end
		end
	end
end

if C.general.interrupt then
	F:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", OnEvent)
end

F.AddOptionsCallback("general", "interrupt", function()
	if C.general.interrupt then
		F.RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", OnEvent)
	else
		F.UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", OnEvent)
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
