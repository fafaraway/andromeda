local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

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

function NOTIFICATION:RareAlert_Update(id)
	if id and not cache[id] then
		local instType = select(2, GetInstanceInfo())
		local info = C_VignetteInfo_GetVignetteInfo(id)
		if not info then return end
		local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
		if not filename then return end

		local atlasWidth = width/(txRight-txLeft)
		local atlasHeight = height/(txBottom-txTop)
		local tex = format('|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t', filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
		local currrentTime = C.GreyColor..'['..date('%H:%M:%S')..'] |r'

		UIErrorsFrame:AddMessage(currrentTime..C.InfoColor..L['NOTIFICATION_RARE']..tex..(C.RedColor..info.name or ''))
		print(currrentTime..C.InfoColor..L['NOTIFICATION_RARE']..tex..C.RedColor..(info.name or ''))

		if C.notification.rareSound or instType == 'none' then
			PlaySound(23404, 'master')
		end

		cache[id] = true
	end

	if #cache > 666 then wipe(cache) end
end

function NOTIFICATION:RareAlert_CheckInstance()
	local _, instanceType, _, _, maxPlayers, _, _, instID = GetInstanceInfo()
	if (instID and isIgnored[instID]) or (instanceType == 'scenario' and maxPlayers == 3) then
		F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', NOTIFICATION.RareAlert_Update)
	else
		F:RegisterEvent('VIGNETTE_MINIMAP_UPDATED', NOTIFICATION.RareAlert_Update)
	end
end

function NOTIFICATION:Rare()
	if C.notification.rare then
		self:RareAlert_CheckInstance()
		F:RegisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
	else
		wipe(cache)
		F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', self.RareAlert_Update)
		F:UnregisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
	end
end


