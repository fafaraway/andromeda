local F, C, L = unpack(select(2, ...))

local _G = _G

local function skin()
	--print("Map:Skin")

	if not _G.WorldMapFrame.skinned then
		_G.WorldMapFrame:SetUserPlaced(true)
		local trackingBtn = _G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton

		--Buttons
		trackingBtn:ClearAllPoints()
		trackingBtn:SetPoint("TOPRIGHT", _G.WorldMapFrame.UIElementsFrame, 3, 3)

		_G.WorldMapFrame.skinned = true
	end
end

-- Size Adjust --
local function SetLargeWorldMap()
	--print("SetLargeWorldMap")
	if _G.InCombatLockdown() then return end

	-- reparent
	_G.WorldMapFrame:SetParent(_G.UIParent)
	_G.WorldMapFrame:SetScale(1)
	_G.WorldMapFrame:EnableMouse(true)
	_G.WorldMapFrame:SetFrameStrata("HIGH")
	_G.WorldMapTooltip:SetFrameStrata("TOOLTIP");
	_G.WorldMapCompareTooltip1:SetFrameStrata("TOOLTIP");
	_G.WorldMapCompareTooltip2:SetFrameStrata("TOOLTIP");

	--reposition
	if WorldMapFrame:GetAttribute('UIPanelLayout-area') ~= 'center' then
		SetUIPanelAttribute(WorldMapFrame, "area", "center");
	end

	if WorldMapFrame:GetAttribute('UIPanelLayout-allowOtherPanels') ~= true then
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
	end

	-- WorldMapFrameSizeUpButton:Hide()
	-- WorldMapFrameSizeDownButton:Show()

	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	WorldMapFrame:SetSize(1002, 668)
end

local function SetQuestWorldMap()
	if _G.InCombatLockdown() or not _G.IsAddOnLoaded("Aurora") then return end
	
	-- WorldMapFrameSizeUpButton:Show()
	-- WorldMapFrameSizeDownButton:Hide()

	_G.WorldMapFrameNavBar:SetPoint("TOPLEFT", _G.WorldMapFrame.BorderFrame, 3, -33)
	_G.WorldMapFrameNavBar:SetWidth(700)
end

if _G.InCombatLockdown() then return end

_G.BlackoutWorld:SetTexture(nil)

_G.QuestMapFrame_Hide()
if _G.GetCVar("questLogOpen") == 1 then
	_G.QuestMapFrame_Show()
end

_G.hooksecurefunc("WorldMap_ToggleSizeUp", SetLargeWorldMap)
_G.hooksecurefunc("WorldMap_ToggleSizeDown", SetQuestWorldMap)

if _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_FULLMAP_SIZE then
	_G.WorldMap_ToggleSizeUp()
elseif _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_WINDOWED_SIZE then
	_G.WorldMap_ToggleSizeDown()
end

_G.DropDownList1:HookScript("OnShow", function(self)
	if _G.DropDownList1:GetScale() ~= _G.UIParent:GetScale() then
		_G.DropDownList1:SetScale(_G.UIParent:GetScale())
	end
end)

-- coordinates
local UIFrame = WorldMapFrame.UIElementsFrame

local coords = F.CreateFS(UIFrame, C.FONT_SIZE_NORMAL, "LEFT")
coords:SetPoint("BOTTOMLEFT", UIFrame, 5, 5)
local cursorcoords = F.CreateFS(UIFrame, C.FONT_SIZE_NORMAL, "LEFT")
cursorcoords:SetPoint("BOTTOMLEFT", coords, "BOTTOMRIGHT", 5, 0)

local freq = C.performance.mapcoords
local last = 0

WorldMapDetailFrame:HookScript("OnUpdate", function(self, elapsed)
	last = last + elapsed
	if last >= freq then
		local x, y = GetPlayerMapPosition("player")
		if (x and x > 0) and (y and y > 0) then
			x = math.floor(100 * x)
			y = math.floor(100 * y)

			coords:SetText("PLAYER"..": "..x..", "..y)
			cursorcoords:SetPoint("BOTTOMLEFT", coords, "BOTTOMRIGHT", 5, 0)
		else
			coords:SetText("")
			cursorcoords:SetPoint("BOTTOMLEFT", UIFrame, 5, 5)
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
			cursorcoords:SetText("CURSOR"..": "..adjustedX..", "..adjustedY)
		else
			cursorcoords:SetText(" ")
		end

		last = 0
	end
end)


