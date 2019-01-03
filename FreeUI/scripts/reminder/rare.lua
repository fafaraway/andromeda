local F, C, L = unpack(select(2, ...))
local module = F:GetModule('reminder')

function module:Rare()
	if not C.reminder.rare then return end

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
			RaidNotice_AddMessage(RaidWarningFrame, C.InfoColor..L["rareFound"]..tex..("<"..info.name..">" or ""), ChatTypeInfo["RAID_WARNING"])
			print(C.InfoColor..L["rareFound"]..tex..(info.name or ""))
			--PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
			PlaySound(23404, "master")

			cache[id] = true
		end
		if #cache > 666 then wipe(cache) end
	end

	F:RegisterEvent("VIGNETTE_MINIMAP_UPDATED", updateAlert)
end