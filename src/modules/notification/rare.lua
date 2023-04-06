local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local rareStr = '|Hworldmap:%d+:%d+:%d+|h%s (%.1f, %.1f)%s|h|r'
local cache = {}
local isIgnoredZone = {
    [1153] = true, -- 部落要塞
    [1159] = true, -- 联盟要塞
    [1803] = true, -- 涌泉海滩
    [1876] = true, -- 部落激流堡
    [1943] = true, -- 联盟激流堡
    [2111] = true, -- 黑海岸前线
}

local isIgnoredIDs = {
    [5485] = true, -- 海象人工具盒
}

local function isUsefulAtlas(info)
    local atlas = info.atlasName
    if atlas then
        return strfind(atlas, '[Vv]ignette') or (atlas == 'nazjatar-nagaevent')
    end
end

local function onEvent(id)
    if id and not cache[id] then
        local info = C_VignetteInfo.GetVignetteInfo(id)
        if not info or not isUsefulAtlas(info) or isIgnoredIDs[info.vignetteID] then
            return
        end

        local atlasInfo = C_Texture.GetAtlasInfo(info.atlasName)
        if not atlasInfo then
            return
        end

        local tex = F:GetTextureStrByAtlas(atlasInfo)
        if not tex then
            return
        end

        F:CreateNotification(_G.GARRISON_MISSION_RARE, tex .. (info.name or ''), 'Interface\\ICONS\\INV_Misc_Map_01')

        local nameStr
        local mapID = C_Map.GetBestMapForUnit('player')
        local position = mapID and C_VignetteInfo.GetVignettePosition(info.vignetteGUID, mapID)
        if position then
            local x, y = position:GetXY()
            nameStr = format(rareStr, mapID, x * 10000, y * 10000, info.name, x * 100, y * 100, '')
        end
        F:Print(tex .. C.INFO_COLOR .. (nameStr or info.name or ''))

        cache[id] = true
    end

    if #cache > 666 then
        wipe(cache)
    end
end

local function checkInstanceType()
    local _, instanceType, _, _, maxPlayers, _, _, instID = GetInstanceInfo()
    if (instID and isIgnoredZone[instID]) or (instanceType == 'scenario' and (maxPlayers == 3 or maxPlayers == 6)) then
        F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', onEvent)
    else
        F:RegisterEvent('VIGNETTE_MINIMAP_UPDATED', onEvent)
    end

    NOTIFICATION.RareInstType = instanceType
end

function NOTIFICATION:RareNotify()
    if C.DB.Notification.RareFound then
        checkInstanceType()
        F:RegisterEvent('PLAYER_ENTERING_WORLD', checkInstanceType)
    else
        wipe(cache)
        F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', onEvent)
        F:UnregisterEvent('PLAYER_ENTERING_WORLD', checkInstanceType)
    end
end
