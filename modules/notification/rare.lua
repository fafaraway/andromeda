local _G = _G
local unpack = unpack
local select = select
local format = format
local strfind = strfind
local wipe = wipe
local GetInstanceInfo = GetInstanceInfo
local C_Texture_GetAtlasInfo = C_Texture.GetAtlasInfo
local C_VignetteInfo_GetVignetteInfo = C_VignetteInfo.GetVignetteInfo
local GARRISON_MISSION_RARE = GARRISON_MISSION_RARE

local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local cache = {}

local function IsUsefulAtlas(info)
    local atlas = info.atlasName
    if atlas then
        return strfind(atlas, '[Vv]ignette') or (atlas == 'nazjatar-nagaevent')
    end
end

function NOTIFICATION:RareAlert_Update(id)
    if id and not cache[id] then
        local info = C_VignetteInfo_GetVignetteInfo(id)
        if not info or not IsUsefulAtlas(info) then
            return
        end

        local atlasInfo = C_Texture_GetAtlasInfo(info.atlasName)
        if not atlasInfo then
            return
        end

        local file = atlasInfo.file
        local width = atlasInfo.width
        local height = atlasInfo.height
        local txLeft = atlasInfo.leftTexCoord
        local txRight = atlasInfo.rightTexCoord
        local txTop = atlasInfo.topTexCoord
        local txBottom = atlasInfo.bottomTexCoord

        if not file then
            return
        end

        local atlasWidth = width / (txRight - txLeft)
        local atlasHeight = height / (txBottom - txTop)
        local tex = format('|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t', file, 0, 0, atlasWidth, atlasHeight, atlasWidth * txLeft, atlasWidth * txRight, atlasHeight * txTop, atlasHeight * txBottom)

        F:Print(C.InfoColor .. GARRISON_MISSION_RARE .. C.BlueColor .. ' (' .. tex .. (info.name or '') .. ')')
        F:CreateNotification(GARRISON_MISSION_RARE, tex .. (info.name or ''), nil, 'Interface\\ICONS\\INV_Letter_20')

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
