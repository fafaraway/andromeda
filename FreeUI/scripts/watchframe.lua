local F, C, L = unpack(select(2, ...))

local wf = WatchFrame

local function moveTracker()
	if MultiBarLeft:IsShown() then
		wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -100, -160)
	elseif MultiBarRight:IsShown() then
		wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -70, -160)
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

WatchFrameCollapseExpandButton:SetSize(15, 15)

local text = F.CreateFS(WatchFrameCollapseExpandButton, 8)
text:SetText("x")
text:SetPoint("CENTER", 1, 1)

hooksecurefunc("WatchFrame_Collapse", function()
	text:SetPoint("CENTER", 2, 1)
	text:SetText("+")
end)
hooksecurefunc("WatchFrame_Expand", function()
	text:SetPoint("CENTER", 1, 1)
	text:SetText("x")
end)

local nextLine = 1

WatchFrameTitle:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
WatchFrameTitle:SetShadowColor(0, 0, 0, 0)

hooksecurefunc("WatchFrame_Update", function()
	for i = nextLine, 50 do
		line = _G["WatchFrameLine"..i]
		if line then
			line.text:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			line.dash:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			line.text:SetShadowColor(0, 0, 0, 0)
			line.dash:SetShadowColor(0, 0, 0, 0)
			line.text:SetSpacing(2)
		else
			nextLine = i
			break
		end
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