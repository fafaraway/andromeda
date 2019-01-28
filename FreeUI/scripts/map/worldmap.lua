local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("Map")

local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)

function module:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition("player")
	if not tempVec2D.x then return end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {}
		mapRect[1] = select(2, C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		mapRect[2] = select(2, C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y/mapRect[2].y, tempVec2D.x/mapRect[2].x
end

function module:OnLogin()
	if not C.map.worldMap then return end

	self:SetupMinimap()
	self:MapReveal()

	-- Scaling
	local function setupScale(self)
		if self.isMaximized and self:GetScale() ~= 1 then
			self:SetScale(1)
		elseif not self.isMaximized and self:GetScale() ~= C.map.worldMapScale then
			self:SetScale(C.map.worldMapScale)
		end
	end

	if C.map.worldMapScale > 1 then
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
			local s = WorldMapFrame:GetScale()
			return x/s, y/s
		end
	end

	local function updateMapAnchor(self)
		setupScale(self)
		if not self.isMaximized then F.RestoreMF(self) end
	end
	F.CreateMF(WorldMapFrame, nil, true)
	hooksecurefunc(WorldMapFrame, "SynchronizeDisplayState", updateMapAnchor)

	-- keep minimized world map centered
	--hooksecurefunc("ToggleWorldMap", function()
	--	WorldMapFrame:ClearAllPoints()
	--	WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	--end)

	-- Generate Coords
	if not C.map.coords then return end

	local player = F.CreateFSAlt(WorldMapFrame.BorderFrame, 'pixel', '', true, true, "BOTTOMLEFT", 10, 10)
	local cursor = F.CreateFSAlt(WorldMapFrame.BorderFrame, 'pixel', '', true, true, "BOTTOMLEFT", 130, 10)

	WorldMapFrame.BorderFrame.Tutorial:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -12, -12)
	F.HideObject(WorldMapFrame.BorderFrame.Tutorial)

	local mapBody = WorldMapFrame:GetCanvasContainer()
	local scale, width, height = mapBody:GetEffectiveScale(), mapBody:GetWidth(), mapBody:GetHeight()
	hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", function()
		width, height = mapBody:GetWidth(), mapBody:GetHeight()
	end)

	local mapID
	hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
		if self:GetMapID() == C_Map.GetBestMapForUnit("player") then
			mapID = self:GetMapID()
		else
			mapID = nil
		end
	end)

	local function CursorCoords()
		local left, top = mapBody:GetLeft() or 0, mapBody:GetTop() or 0
		local x, y = GetCursorPosition()
		local cx = (x/scale - left) / width
		local cy = (top - y/scale) / height
		if cx < 0 or cx > 1 or cy < 0 or cy > 1 then return end
		return cx, cy
	end

	local function CoordsFormat(owner, none)
		local text = none and ": --, --" or ": %.1f, %.1f"
		return owner..C.InfoColor..text
	end

	local function UpdateCoords(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > .1 then
			local cx, cy = CursorCoords()
			if cx and cy then
				cursor:SetFormattedText(CoordsFormat("Mouse"), 100 * cx, 100 * cy)
			else
				cursor:SetText(CoordsFormat("Mouse", true))
			end

			if not mapID then
				player:SetText(CoordsFormat(PLAYER, true))
			else
				local x, y = module:GetPlayerMapPos(mapID)
				if not x or (x == 0 and y == 0) then
					player:SetText(CoordsFormat("Player", true))
				else
					player:SetFormattedText(CoordsFormat("Player"), 100 * x, 100 * y)
				end
			end

			self.elapsed = 0
		end
	end

	local CoordsUpdater = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)
	CoordsUpdater:SetScript("OnUpdate", UpdateCoords)
end