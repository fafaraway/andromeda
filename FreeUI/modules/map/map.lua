local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('MAP')


local select = select
local WorldMapFrame = WorldMapFrame
local CreateVector2D = CreateVector2D
local UnitPosition = UnitPosition
local C_Map_GetWorldPosFromMapPos = C_Map.GetWorldPosFromMapPos
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)
local currentMapID, playerCoords, cursorCoords

function MAP:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition('player')
	if not tempVec2D.x then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		local pos1 = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		local pos2 = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		if not pos1 or not pos2 then return end
		mapRect = {pos1, pos2}
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y/mapRect[2].y, tempVec2D.x/mapRect[2].x
end

function MAP:GetCursorCoords()
	if not WorldMapFrame.ScrollContainer:IsMouseOver() then return end

	local cursorX, cursorY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
	if cursorX < 0 or cursorX > 1 or cursorY < 0 or cursorY > 1 then return end
	return cursorX, cursorY
end

local function CoordsFormat(owner, none)
	local text = none and ': --, --' or ': %.1f, %.1f'
	return owner..C.InfoColor..text
end

function MAP:UpdateCoords(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.1 then
		local cursorX, cursorY = MAP:GetCursorCoords()
		if cursorX and cursorY then
			cursorCoords:SetFormattedText(CoordsFormat(L['MAP_CURSOR']), 100 * cursorX, 100 * cursorY)
		else
			cursorCoords:SetText(CoordsFormat(L['MAP_CURSOR'], true))
		end

		if not currentMapID then
			playerCoords:SetText(CoordsFormat(PLAYER, true))
		else
			local x, y = MAP:GetPlayerMapPos(currentMapID)
			if not x or (x == 0 and y == 0) then
				playerCoords:SetText(CoordsFormat(PLAYER, true))
			else
				playerCoords:SetFormattedText(CoordsFormat(PLAYER), 100 * x, 100 * y)
			end
		end

		self.elapsed = 0
	end
end

function MAP:UpdateMapID()
	if self:GetMapID() == C_Map_GetBestMapForUnit('player') then
		currentMapID = self:GetMapID()
	else
		currentMapID = nil
	end
end

function MAP:AddCoords()
	if not C.DB.map.coords then return end

	playerCoords = F.CreateFS(WorldMapFrame.BorderFrame, C.Assets.Fonts.Regular, 11, nil, '', nil, 'THICK', 'BOTTOMLEFT', 10, 10)
	cursorCoords = F.CreateFS(WorldMapFrame.BorderFrame, C.Assets.Fonts.Regular, 11, nil, '', nil, 'THICK', 'BOTTOMLEFT', 130, 10)

	F.HideObject(WorldMapFrame.BorderFrame.Tutorial)

	hooksecurefunc(WorldMapFrame, 'OnFrameSizeChanged', MAP.UpdateMapID)
	hooksecurefunc(WorldMapFrame, 'OnMapChanged', MAP.UpdateMapID)

	local CoordsUpdater = CreateFrame('Frame', nil, WorldMapFrame.BorderFrame)
	CoordsUpdater:SetScript('OnUpdate', MAP.UpdateCoords)
end

function MAP:UpdateMapScale()
	if self.isMaximized and self:GetScale() ~= C.DB.map.max_worldmap_scale then
		self:SetScale(C.DB.map.max_worldmap_scale)
	elseif not self.isMaximized and self:GetScale() ~= C.DB.map.worldmap_scale then
		self:SetScale(C.DB.map.worldmap_scale)
	end
end

function MAP:UpdateMapAnchor()
	MAP.UpdateMapScale(self)
	F.RestoreMF(self)
end

function MAP:WorldMapScale()
	WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
		local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
		local scale = WorldMapFrame:GetScale()
		return x / scale, y / scale
	end

	F.CreateMF(WorldMapFrame, nil, true)
	hooksecurefunc(WorldMapFrame, 'SynchronizeDisplayState', self.UpdateMapAnchor)
end


function MAP:OnLogin()
	if not C.DB.map.enable then return end

	-- Remove from frame manager
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint('CENTER') -- init anchor
	WorldMapFrame:SetAttribute('UIPanelLayout-area', nil)
	WorldMapFrame:SetAttribute('UIPanelLayout-enabled', false)
	WorldMapFrame:SetAttribute('UIPanelLayout-allowOtherPanels', true)
	tinsert(_G.UISpecialFrames, 'WorldMapFrame')

	-- Hide stuff
	WorldMapFrame.BlackoutFrame:SetAlpha(0)
	WorldMapFrame.BlackoutFrame:EnableMouse(false)
	QuestMapFrame:SetScript("OnHide", nil) -- fix map toggle taint

	self:WorldMapScale()
	self:AddCoords()
	self:MapReveal()
	self:Minimap()
end
