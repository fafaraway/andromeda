local F, C = unpack(FreeUI)

local r, g, b = unpack(C.class)

local frame, xpBar

local function setPosition()
	if xpBar:IsShown() then
		frame:SetPoint("BOTTOM", xpBar, "TOP", 0, -8)
	else
		frame:SetPoint("BOTTOM", Minimap, "TOP", 0, -8)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "Blizzard_ArchaeologyUI" then return end
	self:UnregisterEvent("ADDON_LOADED")

	frame = ArcheologyDigsiteProgressBar
	local bar = frame.FillBar

	frame.Shadow:Hide()
	frame.BarBackground:Hide()
	frame.BarBorderAndOverlay:Hide()

	F.SetFS(frame.BarTitle)
	frame.BarTitle:SetPoint("CENTER", 0, 13)

	local width = Minimap:GetWidth()
	bar:SetWidth(width)
	frame.Flash:SetWidth(width + 22)

	bar:SetStatusBarTexture(C.media.texture)
	bar:SetStatusBarColor(r, g, b)

	F.CreateBDFrame(bar)

	xpBar = FreeUIExpBar:GetParent()

	frame:HookScript("OnShow", setPosition)
	xpBar:HookScript("OnShow", setPosition)
	xpBar:HookScript("OnHide", setPosition)
end)