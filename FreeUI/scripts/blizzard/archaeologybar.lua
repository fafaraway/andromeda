local F, C, L = unpack(select(2, ...))

local frame, xpBar
local customPosition = false

local function setPosition()
	frame:SetPoint("BOTTOM", oUF_FreePlayer, "TOP", 0, 50)
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

	if C.client == 'zhCN' or C.client == 'zhTW' then
		frame.BarTitle:SetFont(C.font.normal, 12, "OUTLINE")
	else
		F.SetFS(frame.BarTitle)
	end

	frame.BarTitle:SetPoint("CENTER", 0, 13)

	local width = C.unitframes.player_width
	bar:SetWidth(width)
	frame.Flash:SetWidth(width + 22)

	bar:SetStatusBarTexture(C.media.texture)
	bar:SetStatusBarColor(221/255, 197/255, 162/255)

	F.CreateBDFrame(bar)
	F.CreateSD(bar)

	--xpBar = FreeUIExpBar:GetParent()

	frame:HookScript("OnShow", setPosition)
	--xpBar:HookScript("OnShow", setPosition)
	--xpBar:HookScript("OnHide", setPosition)

	hooksecurefunc(frame, "SetPoint", function()
		if not customPosition then
			customPosition = true
			setPosition()
			customPosition = false
		end
	end)
end)