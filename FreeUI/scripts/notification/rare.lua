local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Notification')

function module:Rare()
	if not C.notification.rare then return end

	local isIgnored = {
		[1153] = true,		-- 部落要塞
		[1159] = true,		-- 联盟要塞
		[1803] = true,		-- 涌泉海滩
		[1876] = true,		-- 部落激流堡
		[2111] = true,		-- 黑海岸前线
	}

	local cache = {}
	local function updateAlert(_, id)
		local _, instType, _, _, _, _, _, instID = GetInstanceInfo()
		if isIgnored[instID] then return end

		if id and not cache[id] then
			local info = C_VignetteInfo.GetVignetteInfo(id)
			if not info then return end
			local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
			if not filename then return end

			local atlasWidth = width/(txRight-txLeft)
			local atlasHeight = height/(txBottom-txTop)

			local tex = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
			
			if instType == "none" then
				UIErrorsFrame:AddMessage(C.InfoColor..L["NOTIFICATION_RARE"]..tex..(C.RedColor..info.name or ""))
				print(C.InfoColor..L["NOTIFICATION_RARE"]..tex..C.RedColor..(info.name or ""))
			end

			if C.notification.rareSound and instType == "none" then
				PlaySound(23404, "master")
			end

			cache[id] = true
		end
		if #cache > 666 then wipe(cache) end
	end

	F:RegisterEvent("VIGNETTE_MINIMAP_UPDATED", updateAlert)
end