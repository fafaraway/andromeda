local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

Minimap:ClearAllPoints()
Minimap:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 50)
Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8X8")
F.CreateBG(Minimap)

Minimap:EnableMouseWheel(true)
MinimapCluster:EnableMouse(false)
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
mt:SetPoint("BOTTOM", Minimap, 0, 6)

MiniMapMailFrame:SetAlpha(0)
MiniMapMailFrame:SetSize(22, 10)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("CENTER", mt)

ZoneTextFrame:SetFrameStrata("MEDIUM")
SubZoneTextFrame:SetFrameStrata("MEDIUM")

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
MinimapZoneText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
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
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -1, -1)
GameTimeFrame:SetSize(16, 16)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:SetNormalTexture("")
GameTimeFrame:SetPushedTexture("")
GameTimeFrame:SetHighlightTexture("")

local _, _, _, _, dateText = GameTimeFrame:GetRegions()
dateText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
dateText:SetTextColor(1, 1, 1)
dateText:SetShadowOffset(0, 0)
dateText:SetPoint("CENTER")

QueueStatusMinimapButtonBorder:SetAlpha(0)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap)
QueueStatusMinimapButton:SetHighlightTexture("")
QueueStatusMinimapButton.Eye.texture:SetTexture("")

QueueStatusFrame:ClearAllPoints()
QueueStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -4, -1)

local dots = {}
for i = 1, 8 do
	dots[i] = F.CreateFS(QueueStatusMinimapButton, 16)
	dots[i]:SetText(".")
end
dots[1]:SetPoint("TOP", 2, 3)
dots[2]:SetPoint("TOPRIGHT", -6, 0)
dots[3]:SetPoint("RIGHT", -3, 3)
dots[4]:SetPoint("BOTTOMRIGHT", -6, 5)
dots[5]:SetPoint("BOTTOM", 2, 2)
dots[6]:SetPoint("BOTTOMLEFT", 9, 5)
dots[7]:SetPoint("LEFT", 6, 3)
dots[8]:SetPoint("TOPLEFT", 9, 0)

local counter = 0
local last = 0
local interval = .06
local diff = .014

local function onUpdate(self, elapsed)
	last = last + elapsed
	if last >= interval then
		counter = counter + 1

		dots[counter]:SetShown(not dots[counter]:IsShown())

		if counter == 8 then
			counter = 0
			diff = diff * -1
		end

		interval = interval + diff
		last = 0
	end
end

hooksecurefunc("EyeTemplate_StartAnimating", function(eye)
	eye:SetScript("OnUpdate", onUpdate)
end)

hooksecurefunc("EyeTemplate_StopAnimating", function(eye)
	for i = 1, 8 do
		dots[i]:Show()
	end
	counter = 0
	last = 0
	interval = .06
	diff = .014
end)

QueueStatusMinimapButton:HookScript("OnEnter", function()
	for i = 1, 8 do
		dots[i]:SetTextColor(r, g, b)
	end
end)

QueueStatusMinimapButton:HookScript("OnLeave", function()
	for i = 1, 8 do
		dots[i]:SetTextColor(1, 1, 1)
	end
end)

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -49, 0)

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5, -5)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")

local rdt = F.CreateFS(rd, 8, "LEFT")
rdt:SetPoint("TOPLEFT")

rd:SetScript("OnEvent", function()
	local _, _, difficulty, _, maxPlayers = GetInstanceInfo()

	if difficulty == 0 then
		rdt:SetText("")
	elseif maxPlayers == 3 then
		rdt:SetText("3")
	elseif difficulty == 1 then
		rdt:SetText("5")
	elseif difficulty == 2 then
		rdt:SetText("5H")
	elseif difficulty == 3 then
		rdt:SetText("10")
	elseif difficulty == 4 then
		rdt:SetText("25")
	elseif difficulty == 5 then
		rdt:SetText("10H")
	elseif difficulty == 6 then
		rdt:SetText("25H")
	elseif difficulty == 7 then
		rdt:SetText("LFR")
	elseif difficulty == 8 then
		rdt:SetText("5CM")
	elseif difficulty == 9 then
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
HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", 0, 7)

HelpOpenTicketButtonTutorial:Hide()
HelpOpenTicketButtonTutorial.Show = F.dummy

HelpOpenTicketButton:SetNormalTexture("")
HelpOpenTicketButton:SetHighlightTexture("")
HelpOpenTicketButton:SetPushedTexture("")

local gmtext = F.CreateFS(HelpOpenTicketButton, 8)
gmtext:SetPoint("CENTER")
gmtext:SetText(gsub(CHAT_FLAG_GM, "[<>]", "")) -- magic!