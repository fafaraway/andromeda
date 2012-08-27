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

local function onEvent(event)
	if event == "PLAYER_REGEN_DISABLED" then
		bottompanel:SetBackdropBorderColor(1, 0, 0)
	else
		bottompanel:SetBackdropBorderColor(0, 0, 0)
	end
end

F.RegisterEvent("PLAYER_REGEN_DISABLED", onEvent)
F.RegisterEvent("PLAYER_REGEN_ENABLED", onEvent)

local overlay = bottompanel:CreateTexture(nil, "BORDER")
overlay:SetPoint("TOPLEFT", 0, -1)
overlay:SetPoint("BOTTOMRIGHT")
overlay:SetTexture(C.media.backdrop)
overlay:SetGradientAlpha("VERTICAL", .1, .1, .1, .5, 0, 0, 0, .5)