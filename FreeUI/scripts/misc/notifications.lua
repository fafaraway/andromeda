local F, C, L = unpack(select(2, ...))
local module = F:GetModule("misc")


function module:AddAlerts()

	self:RareAlert()
	self:InterruptAlert()

end


-- rare mob/event alert
function module:RareAlert()
	if not C.misc.rareAlert then return end

	local isIgnored = {
		[1153] = true,		-- 部落要塞
		[1159] = true,		-- 联盟要塞
		[1803] = true,		-- 涌泉海滩
	}

	local cache = {}
	local function updateAlert(_, id)
		local instID = select(8, GetInstanceInfo())
		if isIgnored[instID] then return end

		if id and not cache[id] then
			local info = C_VignetteInfo.GetVignetteInfo(id)
			if not info then return end
			local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
			if not filename then return end

			local atlasWidth = width/(txRight-txLeft)
			local atlasHeight = height/(txBottom-txTop)

			local tex = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
			--UIErrorsFrame:AddMessage(C.infoColor.."Rare Found"..tex..(info.name or ""))

	
			RaidNotice_AddMessage(RaidWarningFrame, C.infoColor..L.misc.rareFound..tex..("<"..info.name..">" or ""), ChatTypeInfo["RAID_WARNING"])

			
			if C.misc.rareAlertNotify then
				print(C.infoColor..L.misc.rareFound..tex..(info.name or ""))
			end
			PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
			cache[id] = true
		end
		if #cache > 666 then wipe(cache) end
	end

	F:RegisterEvent("VIGNETTE_MINIMAP_UPDATED", updateAlert)
end


-- interrupt/stolen/dispel alert
function module:InterruptAlert()
	if not C.misc.interruptAlert then return end

	local interruptSound = "Interface\\AddOns\\FreeUI\\assets\\sound\\Shutupfool.ogg"
	local dispelSound = "Interface\\AddOns\\FreeUI\\assets\\sound\\buzz.ogg"

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		local inInstance, instanceType = IsInInstance()
		if ((sourceGUID == UnitGUID("player")) or (sourceGUID == UnitGUID("pet"))) then
			if (event == "SPELL_INTERRUPT") then
				if C.misc.interruptSound then
					PlaySoundFile(interruptSound, "Master")
				end
				if inInstance and C.misc.interruptNotify then
					SendChatMessage(L["misc"]["interrupted"]..destName.." "..GetSpellLink(spellID), say)
				end
			elseif ((event == "SPELL_STOLEN") or (event == "SPELL_DISPEL")) then
				if C.misc.dispelSound then
					PlaySoundFile(dispelSound, "Master")
				end
				if inInstance and C.misc.dispelNotify then
					SendChatMessage(L["misc"]["dispeled"]..destName.." "..GetSpellLink(spellID), say)
				end
			end
		end
	end)
end


