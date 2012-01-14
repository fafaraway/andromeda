local F, C, L = unpack(select(2, ...))

local bottompanel = CreateFrame("Frame", nil, UIParent)
bottompanel:SetFrameStrata("BACKGROUND")
bottompanel:SetHeight(13)
bottompanel:SetPoint("BOTTOMLEFT", -1, -1)
bottompanel:SetPoint("BOTTOMRIGHT", 1, -1)
bottompanel:SetBackdrop({
	edgeFile = C.media.backdrop, 
	edgeSize = 1, 
})
bottompanel:SetBackdropBorderColor(0, 0, 0)

bottompanel:SetScript("OnEvent", function(self, event)
	if event=="PLAYER_REGEN_DISABLED" then
		self:SetBackdropBorderColor(1, 0, 0)
	elseif event=="PLAYER_REGEN_ENABLED" then
		self:SetBackdropBorderColor(0, 0, 0)
	end
end)

bottompanel:RegisterEvent("PLAYER_REGEN_DISABLED")
bottompanel:RegisterEvent("PLAYER_REGEN_ENABLED")

local overlay = bottompanel:CreateTexture(nil, "BORDER")
overlay:SetPoint("TOPLEFT", 0, -1)
overlay:SetPoint("BOTTOMRIGHT")
overlay:SetTexture(C.media.backdrop)
overlay:SetGradientAlpha("VERTICAL", .1, .1, .1, .5, 0, 0, 0, .5)