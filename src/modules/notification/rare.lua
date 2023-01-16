local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local cache = {}
local rareString = '|Hworldmap:%d+:%d+:%d+|h%s (%.1f, %.1f)%s|h|r'
local mapID
local position

local function IsUsefulAtlas(info)
    local atlas = info.atlasName
    if atlas then
        return strfind(atlas, '[Vv]ignette') or (atlas == 'nazjatar-nagaevent')
    end
end

local function createMapPin()
    local mapPoint = UiMapPoint.CreateFromVector2D(mapID, position)
    if mapPoint then
        C_Map.SetUserWaypoint(mapPoint)
    end
end

function NOTIFICATION:RareAlert_Update(id)
    if id and not cache[id] then
        local info = C_VignetteInfo.GetVignetteInfo(id)
        if not info or not IsUsefulAtlas(info) then
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

        F:CreateNotification(
            _G.GARRISON_MISSION_RARE,
            tex .. (info.name or ''),
            createMapPin,
            'Interface\\ICONS\\INV_Misc_Map_01'
        )

        local nameString
        local mapID = C_Map.GetBestMapForUnit('player')
        local position = mapID and C_VignetteInfo.GetVignettePosition(info.vignetteGUID, mapID)
        if position then
            local x, y = position:GetXY()
            nameString = format(rareString, mapID, x * 10000, y * 10000, info.name, x * 100, y * 100, '')
        end
        F:Print(tex .. C.INFO_COLOR .. (nameString or info.name or ''))

        cache[id] = true
    end

    if #cache > 666 then
        wipe(cache)
    end
end

function NOTIFICATION:RareAlert_CheckInstance()
    local _, instanceType = GetInstanceInfo()
    if instanceType == 'none' then
        F:RegisterEvent('VIGNETTE_MINIMAP_UPDATED', NOTIFICATION.RareAlert_Update)
    else
        F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', NOTIFICATION.RareAlert_Update)
    end

    NOTIFICATION.RareInstType = instanceType
end

function NOTIFICATION:RareNotify()
    if C.DB.Notification.RareFound then
        self:RareAlert_CheckInstance()
        F:RegisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
    else
        wipe(cache)
        F:UnregisterEvent('VIGNETTE_MINIMAP_UPDATED', self.RareAlert_Update)
        F:UnregisterEvent('PLAYER_ENTERING_WORLD', self.RareAlert_CheckInstance)
    end
end
