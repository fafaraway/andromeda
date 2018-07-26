local F, C = unpack(select(2, ...))
local module = F:GetModule("misc")


function module:AddAlerts()

	self:RareAlert()
	self:InterruptAlert()

end


-- rare mob/event alert

function module:RareAlert()
	if not C.misc.rareAlert then return end



	local cache = {}
	local function updateAlert(_, id)
		if id and not cache[id] then
			local info = C_VignetteInfo.GetVignetteInfo(id)
			if not info then return end
			local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
			if not filename then return end

			local atlasWidth = width/(txRight-txLeft)
			local atlasHeight = height/(txBottom-txTop)

			local tex = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
			--UIErrorsFrame:AddMessage(C.infoColor.."Rare Found"..tex..(info.name or ""))



			RaidNotice_AddMessage(RaidWarningFrame, tex.." "..(info.name or "Unknown").." ".."spotted!", ChatTypeInfo["RAID_WARNING"])
			

			if C.misc.rareAlertinChat then

				--print("  -> "..C.infoColor.."Rare Found"..tex..(info.name or ""))
				print(info.name, "spotted!")

			end
			PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
			cache[id] = true
		end
		if #cache > 666 then wipe(cache) end
	end

	F:RegisterEvent("VIGNETTE_MINIMAP_UPDATED", updateAlert)
end





-- interrupt alert


function module:InterruptAlert()

	if not C.misc.interrupt then return end

	local interruptSound = "Interface\\AddOns\\FreeUI\\assets\\sound\\Shutupfool.ogg"
	local dispelSound = "Interface\\AddOns\\FreeUI\\assets\\sound\\buzz.ogg"


	local frame = CreateFrame("Frame")

	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	frame:SetScript("OnEvent", function(self)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()

		if ((sourceGUID == UnitGUID("player")) or (sourceGUID == UnitGUID("pet"))) then

			if (event == "SPELL_INTERRUPT") then

				PlaySoundFile(interruptSound, "Master")

				if IsInGroup() and C.misc.interruptinChat then
					if C.client == "zhCN" or C.client == "zhTW" then
						SendChatMessage("已打断: "..destName.."'s "..GetSpellLink(spellID)..".")
					else
						SendChatMessage("Interrupted: "..destName.."'s "..GetSpellLink(spellID)..".")
					end
				end
				
			elseif ((event == "SPELL_STOLEN") or (event == "SPELL_DISPEL")) then

				PlaySoundFile(dispelSound, "Master")

			end

		end


	end)

end


