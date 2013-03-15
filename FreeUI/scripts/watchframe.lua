local F, C, L = unpack(select(2, ...))

local wf = WatchFrame

local function moveTracker()
	if MultiBarLeft:IsShown() then
		wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -105, -160)
	elseif MultiBarRight:IsShown() then
		wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -75, -160)
	else
		wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -37, -160)
	end
	wf:SetPoint("BOTTOM", Minimap, "TOP", 0, 10)
end

hooksecurefunc(wf, "SetPoint", function(_, _, _, point)
	if point == "BOTTOMRIGHT" then
		moveTracker()
	end
end)

F.ReskinExpandOrCollapse(WatchFrameCollapseExpandButton)
WatchFrameCollapseExpandButton:SetSize(15, 15)
WatchFrameCollapseExpandButton:SetPoint("TOPRIGHT", -12, -3)
WatchFrameCollapseExpandButton.plus:Hide()

hooksecurefunc("WatchFrame_Collapse", function()
	WatchFrameCollapseExpandButton.plus:Show()
end)
hooksecurefunc("WatchFrame_Expand", function()
	WatchFrameCollapseExpandButton.plus:Hide()
end)

WatchFrameTitle:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
WatchFrameTitle:SetShadowColor(0, 0, 0, 0)

local index = 1

hooksecurefunc("WatchFrame_Update", function()
	local line = _G["WatchFrameLine"..index]
	while line do
		line.text:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
		line.dash:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
		line.text:SetShadowColor(0, 0, 0, 0)
		line.dash:SetShadowColor(0, 0, 0, 0)
		line.text:SetSpacing(2)

		index = index + 1
		line = _G["WatchFrameLine"..index]
	end

	for i = 1, WATCHFRAME_MAXQUESTS do
		local bu = _G["WatchFrameItem"..i]
		if bu and not bu.reskinned then
			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			F.CreateBG(bu)

			_G["WatchFrameItem"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
		end
	end
end)