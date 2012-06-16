local F, C, L = unpack(select(2, ...))

local wf = WatchFrame

wf:SetClampedToScreen(false)
wf:SetMovable(true);
wf:ClearAllPoints()
wf:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -37, -170)
wf:SetWidth(250)
wf:SetHeight(700)
wf:SetUserPlaced(true)
wf.SetPoint = function() end

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

-- Top half of code below is by Seerah

local nextline = 1

WatchFrameTitle:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
WatchFrameTitle:SetShadowColor(0, 0, 0, 0)

hooksecurefunc("WatchFrame_Update", function()
	for i = nextline, 50 do
		line = _G["WatchFrameLine"..i]
		if line then
			line.text:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			line.dash:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			line.text:SetShadowColor(0, 0, 0, 0)
			line.dash:SetShadowColor(0, 0, 0, 0)
			line.text:SetSpacing(2)
		else
			nextline = i
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