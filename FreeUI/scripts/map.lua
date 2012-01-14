local F, C, L = unpack(select(2, ...))

WORLDMAP_WINDOWED_SIZE = 0.82
 
local offset = 1 / WORLDMAP_WINDOWED_SIZE
local fontsize = 8 / WORLDMAP_WINDOWED_SIZE

local mapbg = CreateFrame ("Frame", nil, WorldMapDetailFrame)
mapbg:SetBackdrop({ 
	bgFile = C.media.backdrop, 
})
mapbg:SetBackdropColor(0, 0, 0)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")

local frame = CreateFrame ("Frame", nil, WorldMapButton)
frame:SetFrameStrata("HIGH")

local SmallerMapSkin = function()
	mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, -offset, offset)
	mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, offset, -offset)
	mapbg:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel()-1)
 
	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	WorldMapDetailFrame:ClearAllPoints()
	WorldMapDetailFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	WorldMapTitleButton:Show()	
	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:SetPoint("TOP", Minimap, "TOP", 0, 40)
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 5);
	WorldMapFrameTitle:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	WorldMapFrameTitle:SetTextColor(1, 1, 1)
	WorldMapFrameTitle:SetShadowColor(0, 0, 0, 0)
	WorldMapFrameTitle:SetParent(frame)
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 0, 0)
	WorldMapQuestShowObjectives.SetPoint = F.dummy
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT")
	WorldMapQuestShowObjectivesText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	WorldMapQuestShowObjectivesText:SetTextColor(1, 1, 1)
	WorldMapQuestShowObjectivesText:SetShadowColor(0, 0, 0, 0)
	WorldMapTrackQuest:SetParent(frame)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("TOPLEFT", WorldMapDetailFrame, 9, -5)
	WorldMapTrackQuestText:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	WorldMapTrackQuestText:SetTextColor(1, 1, 1)
	WorldMapTrackQuestText:SetShadowColor(0, 0, 0, 0)
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetFrameStrata("HIGH")
	WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 18)
	WorldMapShowDigSitesText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("RIGHT", WorldMapShowDigSites, "LEFT",-4,1)
	WorldMapShowDigSitesText:SetTextColor(1, 1, 1)
	WorldMapShowDigSitesText:SetShadowColor(0, 0, 0, 0)
	WorldMapFrameCloseButton:SetAlpha(0)
	WorldMapFrameCloseButton:EnableMouse(nil)
	WorldMapFrameSizeUpButton:SetAlpha(0)
	WorldMapFrameSizeUpButton:EnableMouse(nil)
	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint("TOPRIGHT", WorldMapDetailFrame, "TOPRIGHT", 14, 0)
	WorldMapShowDropDown:SetFrameStrata("HIGH")
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)

local OnEvent = function(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		WorldMapFrameSizeDownButton:Disable() 
		WorldMapFrameSizeUpButton:Disable()
		HideUIPanel(WorldMapFrame)
		WorldMap_ToggleSizeDown()
		WatchFrame.showObjectives = nil
		WorldMapQuestShowObjectives:SetChecked(false)
		--WorldMapQuestShowObjectives:Hide()
		WorldMapTitleButton:Hide()
		WorldMapBlobFrame:Hide()
		WorldMapPOIFrame:Hide()

		--WorldMapQuestShowObjectives.Show = F.dummy
		WorldMapTitleButton.Show = F.dummy
		WorldMapBlobFrame.Show = F.dummy
		WorldMapPOIFrame.Show = F.dummy       

		WatchFrame_Update()
	elseif event == "PLAYER_REGEN_ENABLED" then
		WorldMapFrameSizeDownButton:Enable()
		WorldMapFrameSizeUpButton:Enable()
		--WorldMapQuestShowObjectives.Show = WorldMapQuestShowObjectives:Show()
		WorldMapTitleButton.Show = WorldMapTitleButton:Show()
		WorldMapBlobFrame.Show = WorldMapBlobFrame:Show()
		WorldMapPOIFrame.Show = WorldMapPOIFrame:Show()

		--WorldMapQuestShowObjectives:Show()
		WorldMapTitleButton:Show()

		WatchFrame.showObjectives = true
		WorldMapQuestShowObjectives:SetChecked(true)

		WorldMapBlobFrame:Show()
		WorldMapPOIFrame:Show()

		WatchFrame_Update()
	end
end
f:SetScript("OnEvent", OnEvent)

local coords = F.CreateFS(WorldMapDetailFrame, fontsize)
coords:SetPoint("LEFT", WorldMapFrameTitle, "RIGHT")
local cursorcoords = F.CreateFS(WorldMapDetailFrame, fontsize)
cursorcoords:SetPoint("BOTTOMLEFT", WorldMapFrameTitle, "TOPLEFT", 0, 4)

local last = 0
local freq = C.performance.mapcoords

WorldMapDetailFrame:HookScript("OnShow", function()
	WorldMapDetailFrame:SetScript("OnUpdate", function(self, elapsed)
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
end)

WorldMapDetailFrame:HookScript("OnHide", function()
	WorldMapDetailFrame:SetScript("OnUpdate", nil)
end)