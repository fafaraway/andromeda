-- Map search function by Wildbreath

local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

WORLDMAP_WINDOWED_SIZE = 0.82

local offset = 1 / WORLDMAP_WINDOWED_SIZE
local panelHeight = 26

-- fix ping

select(2, WorldMapPing.Ping:GetAnimations()):SetScale(1.62, 1.62)

WorldMapPing.Ping:SetScript("OnLoop", function(self, loopState)
	self.loopCount = self.loopCount + 1
	if self.loopCount >= 2 then
		self:Stop()
	end
end)

WorldMapPlayerUpper:EnableMouse(false)
WorldMapPlayerLower:EnableMouse(false)

-- frames

local mapbg = CreateFrame ("Frame", nil, WorldMapDetailFrame)
mapbg:SetBackdrop({
	bgFile = C.media.backdrop,
})
mapbg:SetBackdropColor(0, 0, 0)
mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, -offset, offset)
mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, offset, -offset)
mapbg:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel()-1)

local frame = CreateFrame ("Frame", nil, WorldMapButton)
frame:SetScale(offset)
frame:SetFrameStrata("HIGH")

-- bottom panel

local panelHolder = CreateFrame("ScrollFrame", nil, WorldMapButton)
panelHolder:SetFrameStrata("LOW")
panelHolder:SetScale(offset)
panelHolder:SetPoint("TOPLEFT", WorldMapDetailFrame, "BOTTOMLEFT", -1, 0)
panelHolder:SetPoint("TOPRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 1, 0)
panelHolder:SetHeight(panelHeight)

local panel = CreateFrame("Frame", nil, panelHolder)
panel:EnableMouse(true)
panel:SetWidth(panelHolder:GetWidth())
panel:SetHeight(panelHeight)
F.CreateBD(panel)

panelHolder:SetScrollChild(panel)
panelHolder:SetVerticalScroll(panelHeight)

local button = CreateFrame("Frame", nil, WorldMapButton)
button:EnableMouse(true)
button:SetSize(16, 16)
button:SetScale(offset)
button:SetPoint("BOTTOM", WorldMapDetailFrame)

local text = F.CreateFS(button)
text:SetPoint("CENTER")
text:SetText("+")

local function colourText()
	text:SetTextColor(r, g, b)
end

local function clearText()
	text:SetTextColor(1, 1, 1)
end

button:SetScript("OnEnter", colourText)
button:SetScript("OnLeave", clearText)

-- map style function

local SmallerMapSkin = function()
	local fontsize = C.appearance.fontSizeNormal / WORLDMAP_WINDOWED_SIZE

	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	WorldMapDetailFrame:ClearAllPoints()
	WorldMapDetailFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	WorldMapTitleButton:Show()

	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:SetPoint("RIGHT", panel, "RIGHT", 0, -2)
	WorldMapLevelDropDown:SetParent(panel)

	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()

	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 8, 4);
	F.SetFS(WorldMapFrameTitle)
	WorldMapFrameTitle:SetTextColor(1, 1, 1)
	WorldMapFrameTitle:SetShadowColor(0, 0, 0, 0)
	WorldMapFrameTitle:SetParent(frame)

	WorldMapTrackQuest:SetParent(frame)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT")
	WorldMapTrackQuestText:ClearAllPoints()
	WorldMapTrackQuestText:SetPoint("RIGHT", WorldMapTrackQuest, "LEFT", -2, 0)
	F.SetFS(WorldMapTrackQuestText)
	WorldMapTrackQuestText:SetTextColor(1, 1, 1)
	WorldMapTrackQuestText:SetShadowColor(0, 0, 0, 0)

	WorldMapFrameCloseButton:SetAlpha(0)
	WorldMapFrameCloseButton:EnableMouse(nil)
	WorldMapFrameSizeUpButton:SetAlpha(0)
	WorldMapFrameSizeUpButton:EnableMouse(nil)

	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint("LEFT", panel, "LEFT", 0, -2)
	WorldMapShowDropDown:SetParent(panel)

	MapBarFrame.Description:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	MapBarFrame.Description:SetShadowOffset(0, 0)
	MapBarFrame.Title:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	MapBarFrame.Title:SetShadowOffset(0, 0)

	WorldMapPing:SetSize(64 / offset, 64 / offset)
	WorldMapPing.centerRing:SetSize(32 / offset, 32 / offset)
	WorldMapPing.rotatingRing:SetSize(48 / offset, 48 / offset)
	WorldMapPing.expandingRing:SetSize(32 / offset, 32 / offset)

	WorldMapPlayerLower:SetSize(32 / offset, 32 / offset)
	WorldMapPlayerLower.icon:SetPoint("TOPLEFT", -4, 4)
	WorldMapPlayerLower.icon:SetPoint("BOTTOMRIGHT", 4, -4)

	WorldMapPlayerUpper:SetSize(32 / offset, 32 / offset)
	WorldMapPlayerUpper.icon:SetPoint("TOPLEFT", -4, 4)
	WorldMapPlayerUpper.icon:SetPoint("BOTTOMRIGHT", 4, -4)
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)

-- track quest button style

F.ReskinCheck(WorldMapTrackQuest)

-- coordinates

local coords = F.CreateFS(frame)
coords:SetPoint("LEFT", WorldMapFrameTitle, "RIGHT")
local cursorcoords = F.CreateFS(frame)
cursorcoords:SetPoint("BOTTOMLEFT", WorldMapFrameTitle, "TOPLEFT", 0, 4)

local freq = C.performance.mapcoords
local last = 0

WorldMapDetailFrame:HookScript("OnUpdate", function(self, elapsed)
	last = last + elapsed
	if last >= freq then
		local x, y = GetPlayerMapPosition("player")
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			coords:SetText("("..x..", "..y..")")
		else
			coords:SetText("")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height

		if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			cursorcoords:SetText(MOUSE_LABEL..": "..adjustedX..", "..adjustedY)
		else
			cursorcoords:SetText(" ")
		end

		last = 0
	end
end)

-- map search

local editbox = CreateFrame("EditBox", "MapSearchBox", WorldMapFrame, "SearchBoxTemplate")
editbox:SetAutoFocus(false)
editbox:SetSize(150, 20)
editbox:SetPoint("CENTER", panel)
F.SetFS(editbox)
editbox:SetShadowOffset(0, 0)
editbox:SetParent(panel)

editbox.db = {}
for i=1, select("#", GetMapContinents()), 1 do
	local zonesdb = {}
	for j=1, select("#", GetMapZones(i)), 1 do
		tinsert(zonesdb, {id=j, name=select(j, GetMapZones(i))})
	end
	tinsert(editbox.db, {id=i, name=select(i, GetMapContinents()), zones = zonesdb })
end

editbox:SetScript("OnHide", BagSearch_OnHide)

editbox:SetScript("OnTextChanged", function(self)
	local searchdata = self:GetText()
	if searchdata == "" then return end
	for i, v in pairs(self.db) do
		if v.name:lower():find(searchdata:lower()) then
			SetMapZoom(v.id)
			return
		end
		for j, k in pairs(v.zones) do
			if k.name:lower():find(searchdata:lower()) then
				SetMapZoom(v.id, k.id)
				return
			end
		end
	end
end)

-- bottom panel

local y = panelHeight
local opened = false

local open = function(self, elapsed)
	y = y - (elapsed * 100)

	if y <= 0 then
		y = 0
		panel:SetScript("OnUpdate", nil)
	end

	panelHolder:SetVerticalScroll(y)
end

local close = function(self, elapsed)
	y = y + (elapsed * 100)

	if y >= panelHeight then
		y = panelHeight
		panel:SetScript("OnUpdate", nil)
	end

	panelHolder:SetVerticalScroll(y)
end

panel.toggle = function()
	if opened then
		opened = false
		DropDownList1:Hide()
		panel:SetScript("OnUpdate", close)
	else
		opened = true
		panel:SetScript("OnUpdate", open)
	end
end

button:HookScript("OnMouseDown", panel.toggle)