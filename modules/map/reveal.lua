local F, C = unpack(select(2, ...))
local MAP = F:GetModule('Map')

local shownMapCache, exploredCache, fileDataIDs = {}, {}, {}

local function GetStringFromInfo(info)
    return string.format('W%dH%dX%dY%d', info.textureWidth, info.textureHeight, info.offsetX, info.offsetY)
end

local function GetShapesFromString(str)
    local w, h, x, y = string.match(str, 'W(%d*)H(%d*)X(%d*)Y(%d*)')
    return tonumber(w), tonumber(h), tonumber(x), tonumber(y)
end

local function RefreshFileIDsByString(str)
    table.wipe(fileDataIDs)

    for fileID in string.gmatch(str, '%d+') do
        table.insert(fileDataIDs, fileID)
    end
end

function MAP:MapData_RefreshOverlays(fullUpdate)
    table.wipe(shownMapCache)
    table.wipe(exploredCache)

    local mapID = _G.WorldMapFrame.mapID
    if not mapID then
        return
    end

    local mapArtID = C_Map.GetMapArtID(mapID)
    local mapData = mapArtID and MAP.RawMapData[mapArtID]
    if not mapData then
        return
    end

    local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
    if exploredMapTextures then
        for _, exploredTextureInfo in pairs(exploredMapTextures) do
            exploredCache[GetStringFromInfo(exploredTextureInfo)] = true
        end
    end

    if not self.layerIndex then
        self.layerIndex = _G.WorldMapFrame.ScrollContainer:GetCurrentLayerIndex()
    end
    local layers = C_Map.GetMapArtLayers(mapID)
    local layerInfo = layers and layers[self.layerIndex]
    if not layerInfo then
        return
    end

    local TILE_SIZE_WIDTH = layerInfo.tileWidth
    local TILE_SIZE_HEIGHT = layerInfo.tileHeight

    -- Blizzard_SharedMapDataProviders\MapExplorationDataProvider: MapExplorationPinMixin:RefreshOverlays
    for i, exploredInfoString in pairs(mapData) do
        if not exploredCache[i] then
            local width, height, offsetX, offsetY = GetShapesFromString(i)
            RefreshFileIDsByString(exploredInfoString)
            local numTexturesWide = math.ceil(width / TILE_SIZE_WIDTH)
            local numTexturesTall = math.ceil(height / TILE_SIZE_HEIGHT)
            local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight

            for j = 1, numTexturesTall do
                if j < numTexturesTall then
                    texturePixelHeight = TILE_SIZE_HEIGHT
                    textureFileHeight = TILE_SIZE_HEIGHT
                else
                    texturePixelHeight = math.fmod(height, TILE_SIZE_HEIGHT)
                    if texturePixelHeight == 0 then
                        texturePixelHeight = TILE_SIZE_HEIGHT
                    end
                    textureFileHeight = 16
                    while textureFileHeight < texturePixelHeight do
                        textureFileHeight = textureFileHeight * 2
                    end
                end
                for k = 1, numTexturesWide do
                    local texture = self.overlayTexturePool:Acquire()
                    if k < numTexturesWide then
                        texturePixelWidth = TILE_SIZE_WIDTH
                        textureFileWidth = TILE_SIZE_WIDTH
                    else
                        texturePixelWidth = width % TILE_SIZE_WIDTH
                        if texturePixelWidth == 0 then
                            texturePixelWidth = TILE_SIZE_WIDTH
                        end
                        textureFileWidth = 16
                        while textureFileWidth < texturePixelWidth do
                            textureFileWidth = textureFileWidth * 2
                        end
                    end
                    texture:SetWidth(texturePixelWidth)
                    texture:SetHeight(texturePixelHeight)
                    texture:SetTexCoord(0, texturePixelWidth / textureFileWidth, 0, texturePixelHeight / textureFileHeight)
                    texture:SetPoint('TOPLEFT', offsetX + (TILE_SIZE_WIDTH * (k - 1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
                    texture:SetTexture(fileDataIDs[((j - 1) * numTexturesWide) + k], nil, nil, 'TRILINEAR')

                    if C.DB.Map.MapReveal then
                        if C.DB.Map.MapRevealGlow then
                            texture:SetVertexColor(.6, .6, .6)
                        else
                            texture:SetVertexColor(1, 1, 1)
                        end
                        texture:SetDrawLayer('ARTWORK', -1)
                        texture:Show()
                        if fullUpdate then
                            self.textureLoadGroup:AddTexture(texture)
                        end
                    else
                        texture:Hide()
                    end
                    table.insert(shownMapCache, texture)
                end
            end
        end
    end
end

function MAP:MapData_ResetTexturePool(texture)
    texture:SetVertexColor(1, 1, 1)
    texture:SetAlpha(1)
    return TexturePool_HideAndClearAnchors(self, texture)
end

function MAP:WorldMapReveal()
    for pin in _G.WorldMapFrame:EnumeratePinsByTemplate('MapExplorationPinTemplate') do
        hooksecurefunc(pin, 'RefreshOverlays', MAP.MapData_RefreshOverlays)
        pin.overlayTexturePool.resetterFunc = MAP.MapData_ResetTexturePool
    end
end

function MAP:UpdateWorldMapReveal()
    for i = 1, #shownMapCache do
        shownMapCache[i]:SetShown(C.DB.Map.MapReveal)
    end
end
