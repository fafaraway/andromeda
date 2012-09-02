local F, C, L = unpack(select(2, ...))

Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
	if zoom > 0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut()
	end
end)

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", -162, 190)
	else
		Minimap_OnClick(self)
	end
end)

MinimapCluster:EnableMouse(false)

local bg = Minimap:CreateTexture(nil, "BACKGROUND")
bg:SetTexture(0, 0, 0)

local mail = CreateFrame("Frame", "FreeUIMailFrame", Minimap)
mail:Hide()
mail:RegisterEvent("UPDATE_PENDING_MAIL")
mail:SetScript("OnEvent", function(self)
	if HasNewMail() then
		self:Show()
	else
		self:Hide()
	end
end)

local mt = F.CreateFS(mail, 8)
mt:SetText("Mail")

MiniMapMailFrame:SetAlpha(0)
MiniMapMailFrame:SetSize(22, 10)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("CENTER", mt)

ZoneTextString:ClearAllPoints()
ZoneTextString:SetPoint("CENTER", Minimap)
ZoneTextString:SetWidth(138)
ZoneTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
SubZoneTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
SubZoneTextString:SetWidth(138)
PVPInfoTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
PVPInfoTextString:SetWidth(138)
PVPArenaTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
PVPArenaTextString:SetWidth(138)

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("CENTER", Minimap)
MinimapZoneTextButton:SetFrameStrata("HIGH")
MinimapZoneTextButton:EnableMouse(false)
MinimapZoneTextButton:SetAlpha(0)
MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton)
MinimapZoneText:SetShadowColor(0, 0, 0, 0)
MinimapZoneText:SetJustifyH("CENTER")

Minimap:HookScript("OnEnter", function()
	MinimapZoneTextButton:SetAlpha(1)
end)
Minimap:HookScript("OnLeave", function()
	MinimapZoneTextButton:SetAlpha(0)
end)

do
	local frames = {
		"MiniMapInstanceDifficulty",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MiniMapTracking",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MinimapBorder",
	}

	for i = 1, #frames do
		_G[frames[i]]:Hide()
		_G[frames[i]].Show = F.dummy
	end
end

Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)

GuildInstanceDifficulty:SetAlpha(0)

GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetSize(16, 16)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:SetNormalTexture("")
GameTimeFrame:SetPushedTexture("")
GameTimeFrame:SetHighlightTexture("")

local _, _, _, _, dateText = GameTimeFrame:GetRegions()
dateText:SetTextColor(1, 1, 1)
dateText:SetPoint("CENTER")

QueueStatusMinimapButtonBorder:SetAlpha(0)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap)

QueueStatusFrame:ClearAllPoints()
QueueStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -4.5, -1.5)

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -49, 0)

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")

local rdt = F.CreateFS(rd, 8, "LEFT")
rdt:SetPoint("TOPLEFT")

rd:SetScript("OnEvent", function()
	local difficulty = GetInstanceDifficulty()

	if difficulty == 1 then
		rdt:SetText("")
	elseif difficulty == 2 then
		rdt:SetText("5")
	elseif difficulty == 3 then
		rdt:SetText("5H")
	elseif difficulty == 4 then
		rdt:SetText("10")
	elseif difficulty == 5 then
		rdt:SetText("25")
	elseif difficulty == 6 then
		rdt:SetText("10H")
	elseif difficulty == 7 then
		rdt:SetText("25H")
	elseif difficulty == 8 then
		rdt:SetText("LFR")
	--elseif difficulty == 9 then
	elseif difficulty == 10 then
		rdt:SetText("40")
	end

	if GuildInstanceDifficulty:IsShown() then
		rdt:SetTextColor(0, .9, 0)
	else
		rdt:SetTextColor(1, 1, 1)
	end
end)

HelpOpenTicketButton:SetParent(Minimap)
HelpOpenTicketButton:ClearAllPoints()

HelpOpenTicketButtonTutorial:Hide()
HelpOpenTicketButtonTutorial.Show = F.dummy

HelpOpenTicketButton:SetNormalTexture("")
HelpOpenTicketButton:SetHighlightTexture("")
HelpOpenTicketButton:SetPushedTexture("")

local gmtext = F.CreateFS(HelpOpenTicketButton, 8)
gmtext:SetPoint("CENTER")
gmtext:SetText(gsub(CHAT_FLAG_GM, "[<>]", "")) -- magic!

F.RegisterEvent("PLAYER_LOGIN", function()
	local scale

	if C.resolution == 3 then
		scale = 1
	else
		scale = .9
	end

	local fontSize = 8 / scale

	Minimap:ClearAllPoints()
	Minimap:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50 / scale, 50 / scale)
	MinimapCluster:SetScale(scale)
	bg:SetPoint("TOPLEFT", Minimap, -1 / scale, 1 / scale)
	bg:SetPoint("BOTTOMRIGHT", Minimap, 1 / scale, -1 / scale)
	mt:SetPoint("BOTTOM", Minimap, 0, 6 / scale)
	mt:SetFont(C.media.font, fontSize, "OUTLINEMONOCHROME")
	MinimapZoneText:SetFont(C.media.font, fontSize, "OUTLINEMONOCHROME")
	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -1 / scale, -1 / scale)
	dateText:SetFont(C.media.font, fontSize, "OUTLINEMONOCHROME")
	rd:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5 / scale, -5 / scale)
	rdt:SetFont(C.media.font, fontSize, "OUTLINEMONOCHROME")
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", 0, 7 / scale)
	gmtext:SetFont(C.media.font, fontSize, "OUTLINEMONOCHROME")
end)