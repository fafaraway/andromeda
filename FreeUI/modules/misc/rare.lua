local F, C, L = unpack(select(2, ...))
local MISC, cfg = F:GetModule('Misc'), C.General


local C_VignetteInfo_GetVignetteInfo = C_VignetteInfo.GetVignetteInfo
local cache = {}

local isIgnored = {
	[1153] = true,	-- 部落要塞
	[1159] = true,	-- 联盟要塞
	[1803] = true,	-- 涌泉海滩
	[1876] = true,	-- 部落激流堡
	[1943] = true,	-- 联盟激流堡
	[2111] = true,	-- 黑海岸前线
}

function MISC:RareAlert_Update(id)
	if id and not cache[id] then
		local instType = select(2, GetInstanceInfo())
		local info = C_VignetteInfo_GetVignetteInfo(id)
		if not info then return end
		local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
		if not filename then return end

		local atlasWidth = width/(txRight-txLeft)
		local atlasHeight = height/(txBottom-txTop)
		local tex = format('|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t', filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)

		UIErrorsFrame:AddMessage(C.InfoColor..L['MISC_RARE_ALERT']..C.RedColor..' ('..tex..(info.name or '')..')')
		F.Print(C.InfoColor..L['MISC_RARE_ALERT']..C.RedColor..' ('..tex..(info.name or '')..')')

		if instType == 'none' then
			PlaySound(23404, 'master')
		end

		cache[id] = true
	end

	if #cache > 666 then wipe(cache) end
end

function MISC:RareAlert_CheckInstance()
	local _, instanceType, _, _, maxPlayers, _, _, instID = GetInstanceInfo()
	if (instID and isIgnored[instID]) or (instanceType == "scenario" and (maxPlayers == 3 or maxPlayers == 6)) then
		F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', MISC.RareAlert_Update)
	else
		F:RegisterEvent('VIGNETTE_MINIMAP_UPDATED', MISC.RareAlert_Update)
	end
end

function MISC:RareAlert()
	if cfg.rare_alert then
		self:RareAlert_CheckInstance()
		F:RegisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
	else
		wipe(cache)
		F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', self.RareAlert_Update)
		F:UnregisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
	end
end


