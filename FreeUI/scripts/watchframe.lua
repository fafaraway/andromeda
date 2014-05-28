local F, C, L = unpack(select(2, ...))

local wf = WatchFrame

local function moveTracker()
	local xCoord, yAnchor

	if MultiBarLeft:IsShown() then
		xCoord = -70
	elseif MultiBarRight:IsShown() then
		xCoord = -40
	else
		xCoord = -2
	end

	yAnchor = VehicleSeatIndicator:IsShown() and VehicleSeatIndicator or Minimap

	wf:ClearAllPoints()
	wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", xCoord, -160)
	wf:SetPoint("BOTTOM", yAnchor, "TOP", 0, 10)
end

hooksecurefunc(wf, "SetPoint", function(_, _, _, point)
	if point == "BOTTOMRIGHT" then
		moveTracker()
	end
end)

hooksecurefunc(VehicleSeatIndicator, "SetPoint", function(_, _, anchor)
	if anchor ~= Minimap then
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("BOTTOM", Minimap, "TOP", 0, 20)
	end
end)

F.ReskinExpandOrCollapse(WatchFrameCollapseExpandButton)
WatchFrameCollapseExpandButton:SetSize(15, 15)
WatchFrameCollapseExpandButton:SetPoint("TOPRIGHT", -12, 0)
WatchFrameCollapseExpandButton.plus:Hide()

hooksecurefunc("WatchFrame_Collapse", function()
	WatchFrameCollapseExpandButton.plus:Show()
end)
hooksecurefunc("WatchFrame_Expand", function()
	WatchFrameCollapseExpandButton.plus:Hide()
end)

F.SetFS(WatchFrameTitle)

local index = 1
local itemIndex = 1

hooksecurefunc("WatchFrame_Update", function()
	local line = _G["WatchFrameLine"..index]
	while line do
		F.SetFS(line.text)
		F.SetFS(line.dash)
		line.text:SetSpacing(2)

		line.text:ClearAllPoints()
		line.text:SetPoint("LEFT", line.dash, "RIGHT", -2, 3)

		index = index + 1
		line = _G["WatchFrameLine"..index]
	end

	local bu = _G["WatchFrameItem"..itemIndex]
	while bu do
		local hotkey = _G["WatchFrameItem"..itemIndex.."HotKey"]

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		F.CreateBG(bu)

		_G["WatchFrameItem"..itemIndex.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)

		hotkey:ClearAllPoints()
		hotkey:SetPoint("TOP", bu, -1, 0)
		F.SetFS(hotkey)
		hotkey:SetJustifyH("CENTER")

		itemIndex = itemIndex + 1
		bu = _G["WatchFrameItem"..itemIndex]
	end
end)

hooksecurefunc("WatchFrameScenario_GetCriteriaLine", function(index, parent)
	local line = _G["WatchFrameScenarioLine"..index]
	if not line.styled then
		F.SetFS(line.text)
		F.SetFS(line.dash)
		line.text:SetSpacing(2)

		line.styled = true
	end
end)