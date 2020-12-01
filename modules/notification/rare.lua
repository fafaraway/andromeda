local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('NOTIFICATION')


local C_Texture_GetAtlasInfo = C_Texture.GetAtlasInfo
local C_VignetteInfo_GetVignetteInfo = C_VignetteInfo.GetVignetteInfo
local cache = {}

local isIgnoredZone = {
	[1153] = true,	-- 部落要塞
	[1159] = true,	-- 联盟要塞
	[1803] = true,	-- 涌泉海滩
	[1876] = true,	-- 部落激流堡
	[1943] = true,	-- 联盟激流堡
	[2111] = true,	-- 黑海岸前线
}

local function isUsefulAtlas(info)
	local atlas = info.atlasName
	if atlas then
		return strfind(atlas, '[Vv]ignette') or (atlas == 'nazjatar-nagaevent')
	end
end

function NOTIFICATION:RareAlert_Update(id)
	if id and not cache[id] then
		local info = C_VignetteInfo_GetVignetteInfo(id)
		if not info or not isUsefulAtlas(info) then return end

		local atlasInfo = C_Texture_GetAtlasInfo(info.atlasName)
		if not atlasInfo then return end

		local file, width, height, txLeft, txRight, txTop, txBottom = atlasInfo.file, atlasInfo.width, atlasInfo.height, atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord
		if not file then return end

		local atlasWidth = width/(txRight-txLeft)
		local atlasHeight = height/(txBottom-txTop)
		local tex = format('|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t', file, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)

		--UIErrorsFrame:AddMessage(C.InfoColor..L['NOTIFICATION_RARE']..C.RedColor..' ('..tex..(info.name or '')..')')
		F.Print(C.InfoColor..L['NOTIFICATION_RARE']..C.BlueColor..' ('..tex..(info.name or '')..')')

		F:CreateNotification(L['NOTIFICATION_RARE'], C.BlueColor..tex..(info.name or ''), nil, 'Interface\\ICONS\\INV_Letter_20')

		--[[ if NOTIFICATION.RareInstType == 'none' then
			PlaySound(23404, 'master')
		end ]]

		cache[id] = true
	end

	if #cache > 666 then wipe(cache) end
end

function NOTIFICATION:RareAlert_CheckInstance()
	local _, instanceType, _, _, maxPlayers, _, _, instID = GetInstanceInfo()
	if (instID and isIgnoredZone[instID]) or (instanceType == 'scenario' and (maxPlayers == 3 or maxPlayers == 6)) then
		F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', NOTIFICATION.RareAlert_Update)
	else
		F:RegisterEvent('VIGNETTE_MINIMAP_UPDATED', NOTIFICATION.RareAlert_Update)
	end
	NOTIFICATION.RareInstType = instanceType
end

function NOTIFICATION:RareAlert()
	if C.DB.notification.rare_found then
		self:RareAlert_CheckInstance()
		F:RegisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
	else
		wipe(cache)
		F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', self.RareAlert_Update)
		F:UnregisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
	end
end


