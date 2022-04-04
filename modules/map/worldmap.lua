local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('WorldMap')

local mapFrame = _G.WorldMapFrame
local mapRects = {}
local tempVec2D = _G.CreateVector2D(0, 0)
local currentMapID, playerCoords, cursorCoords

function MAP:GetPlayerMapPos(mapID)
    if not mapID then
        return
    end
    tempVec2D.x, tempVec2D.y = UnitPosition('player')
    if not tempVec2D.x then
        return
    end

    local mapRect = mapRects[mapID]
    if not mapRect then
        local pos1 = select(2, C_Map.GetWorldPosFromMapPos(mapID, _G.CreateVector2D(0, 0)))
        local pos2 = select(2, C_Map.GetWorldPosFromMapPos(mapID, _G.CreateVector2D(1, 1)))
        if not pos1 or not pos2 then
            return
        end
        mapRect = {pos1, pos2}
        mapRect[2]:Subtract(mapRect[1])

        mapRects[mapID] = mapRect
    end
    tempVec2D:Subtract(mapRect[1])

    return tempVec2D.y / mapRect[2].y, tempVec2D.x / mapRect[2].x
end

function MAP:GetCursorCoords()
    if not mapFrame.ScrollContainer:IsMouseOver() then
        return
    end

    local cursorX, cursorY = mapFrame.ScrollContainer:GetNormalizedCursorPosition()
    if cursorX < 0 or cursorX > 1 or cursorY < 0 or cursorY > 1 then
        return
    end
    return cursorX, cursorY
end

local function CoordsFormat(owner, none)
    local text = none and ': --, --' or ': %.1f, %.1f'
    return owner .. C.INFO_COLOR .. text
end

function MAP:UpdateCoords(elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed > 0.1 then
        local cursorX, cursorY = MAP:GetCursorCoords()
        if cursorX and cursorY then
            cursorCoords:SetFormattedText(CoordsFormat(L['Cursor']), 100 * cursorX, 100 * cursorY)
        else
            cursorCoords:SetText(CoordsFormat(L['Cursor'], true))
        end

        if not currentMapID then
            playerCoords:SetText(CoordsFormat(_G.PLAYER, true))
        else
            local x, y = MAP:GetPlayerMapPos(currentMapID)
            if not x or (x == 0 and y == 0) then
                playerCoords:SetText(CoordsFormat(_G.PLAYER, true))
            else
                playerCoords:SetFormattedText(CoordsFormat(_G.PLAYER), 100 * x, 100 * y)
            end
        end

        self.elapsed = 0
    end
end

function MAP:UpdateMapID()
    if self:GetMapID() == C_Map.GetBestMapForUnit('player') then
        currentMapID = self:GetMapID()
    else
        currentMapID = nil
    end
end

function MAP:AddCoords()
    if not C.DB.Map.Coords then
        return
    end

    playerCoords = F.CreateFS(mapFrame.BorderFrame, C.Assets.Font.Bold, 12, nil, '', nil, 'THICK', 'BOTTOMLEFT', 10, 10)
    cursorCoords = F.CreateFS(mapFrame.BorderFrame, C.Assets.Font.Bold, 12, nil, '', nil, 'THICK', 'BOTTOMLEFT', 130, 10)

    F.HideObject(mapFrame.BorderFrame.Tutorial)

    hooksecurefunc(mapFrame, 'OnFrameSizeChanged', MAP.UpdateMapID)
    hooksecurefunc(mapFrame, 'OnMapChanged', MAP.UpdateMapID)

    local CoordsUpdater = CreateFrame('Frame', nil, mapFrame.BorderFrame)
    CoordsUpdater:SetScript('OnUpdate', MAP.UpdateCoords)
end

function MAP:UpdateMapScale()
    if self.isMaximized and self:GetScale() ~= C.DB.Map.MaxWorldMapScale then
        self:SetScale(C.DB.Map.MaxWorldMapScale)
    elseif not self.isMaximized and self:GetScale() ~= C.DB.Map.WorldMapScale then
        self:SetScale(C.DB.Map.WorldMapScale)
    end
end

function MAP:UpdateMapAnchor()
    MAP.UpdateMapScale(self)
    F.RestoreMF(self)
end

function MAP:WorldMapScale()
    mapFrame.ScrollContainer.GetCursorPosition = function(f)
        local x, y = _G.MapCanvasScrollControllerMixin.GetCursorPosition(f)
        local scale = mapFrame:GetScale()
        return x / scale, y / scale
    end

    F.CreateMF(mapFrame, nil, true)
    hooksecurefunc(mapFrame, 'SynchronizeDisplayState', self.UpdateMapAnchor)
end

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

    local mapID = mapFrame.mapID
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
        self.layerIndex = mapFrame.ScrollContainer:GetCurrentLayerIndex()
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
                            texture:SetVertexColor(.7, .7, .7)
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

function MAP:RemoveMapFog()
    for pin in mapFrame:EnumeratePinsByTemplate('MapExplorationPinTemplate') do
        hooksecurefunc(pin, 'RefreshOverlays', MAP.MapData_RefreshOverlays)
        pin.overlayTexturePool.resetterFunc = MAP.MapData_ResetTexturePool
    end

    for i = 1, #shownMapCache do
        shownMapCache[i]:SetShown(C.DB.Map.MapReveal)
    end
end

function MAP:SetupWorldMap()
    if not C.DB.Map.Enable then
        return
    end

    -- Remove from frame manager
    mapFrame:ClearAllPoints()
    mapFrame:SetPoint('CENTER') -- init anchor
    mapFrame:SetAttribute('UIPanelLayout-area', nil)
    mapFrame:SetAttribute('UIPanelLayout-enabled', false)
    mapFrame:SetAttribute('UIPanelLayout-allowOtherPanels', true)
    table.insert(_G.UISpecialFrames, 'WorldMapFrame')

    -- Hide stuff
    mapFrame.BlackoutFrame:SetAlpha(0)
    mapFrame.BlackoutFrame:EnableMouse(false)

    MAP:WorldMapScale()
    MAP:AddCoords()
    MAP:RemoveMapFog()
end

function MAP:OnLogin()
    MAP:SetupWorldMap()
end
