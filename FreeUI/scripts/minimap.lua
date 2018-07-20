local F, C, L = unpack(select(2, ...))

--local r, g, b = unpack(C.class)
local r, g, b = C.appearance.fontColorFontRGB.r, C.appearance.fontColorFontRGB.g, C.appearance.fontColorFontRGB.b

--
local Scale = 1
local position = { a1 = "TOPRIGHT", a2 = "TOPRIGHT", af = "UIParent", x = -22, y = 0 }
local size = 256
local texture = "Interface\\Buttons\\WHITE8x8"
local backdrop = {edgeFile = C.media.texture, edgeSize = 1}
local backdropcolor = {0/255, 0/255, 0/255}
local brdcolor = {0/255, 0/255, 0/255}

MinimapCluster:SetScale(Scale)
MinimapCluster:ClearAllPoints()
MinimapCluster:SetPoint(position.a1,position.af,position.a2,position.x,position.y)
MinimapCluster:EnableMouse(false)
MinimapCluster:SetClampedToScreen(false)
MinimapCluster:SetSize(size*Scale, size*Scale)

Minimap:SetClampedToScreen(false)
Minimap:SetSize(size*Scale, size*Scale)
Minimap:SetMaskTexture[[Interface\AddOns\FreeUI\media\rectangle]]
Minimap:SetHitRectInsets(0, 0, 34*Scale, 34*Scale)
Minimap:SetFrameLevel(2)
Minimap:ClearAllPoints()
Minimap:SetAllPoints(MinimapCluster)
Minimap:SetScale(Scale)

BorderFrame = CreateFrame("Frame", nil, Minimap)
BorderFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, -(32*Scale))
BorderFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, (32*Scale))
BorderFrame:SetBackdrop(backdrop)
BorderFrame:SetBackdropBorderColor(unpack(brdcolor))
BorderFrame:SetBackdropColor(unpack(backdropcolor))
BorderFrame:SetFrameLevel(6)

F.CreateSD(BorderFrame)

-- on click mechanic
Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", -162, 190)
	elseif button == 'MiddleButton' then
		if not IsAddOnLoaded("Blizzard_Calendar") then
			LoadAddOn('Blizzard_Calendar')
		end
		Calendar_Toggle()
	else
		Minimap_OnClick(self)
	end
end)

-- scrolling zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, arg1)
	if arg1 > 0 then Minimap_ZoomIn() else Minimap_ZoomOut() end
end)

-- hide specific stuff
do
	local frames = {
		"MiniMapInstanceDifficulty",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MiniMapTracking",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MinimapBorder",
	}

	for _, v in pairs(frames) do
		_G[v]:Hide()
		_G[v].Show = F.Dummy
	end
end

LoadAddOn'Blizzard_TimeManager'
local region = TimeManagerClockButton:GetRegions()
region:Hide()
TimeManagerClockButton:Hide()

-- mail
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

MiniMapMailFrame:HookScript("OnMouseUp", function(self)
	self:Hide()
	mail:Hide()
end)

local mt = F.CreateFS(mail)
mt:SetText("Mail")
mt:SetTextColor(r, g, b)
mt:SetPoint("BOTTOM", Minimap, 0, 36)

MiniMapMailFrame:SetAlpha(0)
MiniMapMailFrame:SetSize(22, 10)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("CENTER", mt)

-- durability
--[[
DurabilityFrame:Hide()
DurabilityFrame:UnregisterAllEvents()
DurabilityFrame.Show = function() end
]]

hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, _, parent)
	if parent=='MinimapCluster' or parent==_G['MinimapCluster'] then
		self:ClearAllPoints()
		self:SetPoint('RIGHT', Minimap, 'LEFT', -50, -250)
		self:SetScale(.7)
	end
end)


-- VEHICLE SEAT INDICATOR
hooksecurefunc(VehicleSeatIndicator,'SetPoint', function(self, _, parent)
	if parent=='MinimapCluster' or parent==_G['MinimapCluster'] then
		self:ClearAllPoints()
		self:SetPoint('RIGHT', Minimap, 'LEFT', -50, -250)
		self:SetScale(.7)
	end
end)

-- move zonetextframe
ZoneTextFrame:SetFrameStrata("MEDIUM")
SubZoneTextFrame:SetFrameStrata("MEDIUM")

ZoneTextString:ClearAllPoints()
ZoneTextString:SetPoint("CENTER", Minimap)
ZoneTextString:SetWidth(230)
SubZoneTextString:SetWidth(230)
PVPInfoTextString:SetWidth(230)
PVPArenaTextString:SetWidth(230)

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("CENTER", Minimap)
MinimapZoneTextButton:SetFrameStrata("HIGH")
MinimapZoneTextButton:EnableMouse(false)
MinimapZoneTextButton:SetAlpha(0)
MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton)

MinimapZoneText:SetShadowColor(0, 0, 0, 0)
MinimapZoneText:SetJustifyH("CENTER")

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
	ZoneTextString:SetFont(C.font.normal, 14, "OUTLINE")
	SubZoneTextString:SetFont(C.font.normal, 14, "OUTLINE")
	PVPInfoTextString:SetFont(C.font.normal, 14, "OUTLINE")
	PVPArenaTextString:SetFont(C.font.normal, 14, "OUTLINE")
	MinimapZoneText:SetFont(C.font.normal, 14, "OUTLINE")
else
	F.SetFS(ZoneTextString)
	F.SetFS(SubZoneTextString)
	F.SetFS(PVPInfoTextString)
	F.SetFS(PVPArenaTextString)
	F.SetFS(MinimapZoneText)
end

Minimap:HookScript("OnEnter", function()
	MinimapZoneTextButton:SetAlpha(1)
end)
Minimap:HookScript("OnLeave", function()
	MinimapZoneTextButton:SetAlpha(0)
end)

-- MiniMapNorthTag
MinimapNorthTag:ClearAllPoints()
MinimapNorthTag:SetPoint("TOP",Minimap,0,-3)
MinimapNorthTag:SetAlpha(0)

Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)

GuildInstanceDifficulty:SetAlpha(0)
MiniMapChallengeMode:GetRegions():SetTexture("")

GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -1, -33)
GameTimeFrame:SetSize(16, 16)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:SetNormalTexture("")
GameTimeFrame:SetPushedTexture("")
GameTimeFrame:SetHighlightTexture("")

-- Queue Status
local _, _, _, _, dateText = GameTimeFrame:GetRegions()
F.SetFS(dateText)
dateText:SetTextColor(r, g, b)
dateText:SetShadowOffset(0, 0)
dateText:SetPoint("CENTER")

QueueStatusMinimapButtonBorder:SetAlpha(0)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, 0, 36)
QueueStatusMinimapButton:SetHighlightTexture("")
QueueStatusMinimapButton.Eye.texture:SetTexture("")

QueueStatusFrame:ClearAllPoints()
QueueStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -4, 33)

local dots = {}
for i = 1, 8 do
	dots[i] = F.CreateFS(QueueStatusMinimapButton, 18)
	dots[i]:SetText(".")
end
dots[1]:SetPoint("TOP", 2, 2)
dots[2]:SetPoint("TOPRIGHT", -6, -1)
dots[3]:SetPoint("RIGHT", -3, 2)
dots[4]:SetPoint("BOTTOMRIGHT", -6, 5)
dots[5]:SetPoint("BOTTOM", 2, 2)
dots[6]:SetPoint("BOTTOMLEFT", 9, 5)
dots[7]:SetPoint("LEFT", 6, 2)
dots[8]:SetPoint("TOPLEFT", 9, -1)

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

-- Instance Difficulty
local difftext = {}
local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5, -37)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("CHALLENGE_MODE_START")
rd:RegisterEvent("CHALLENGE_MODE_COMPLETED")
rd:RegisterEvent("CHALLENGE_MODE_RESET")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
rd:RegisterEvent("ZONE_CHANGED_NEW_AREA")

local rdt = F.CreateFS(rd, C.FONT_SIZE_NORMAL, "LEFT")
rdt:SetPoint("TOPLEFT")
rdt:SetTextColor(1, 1, 1)

rd:SetScript("OnEvent", function()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or "";

	if (difficulty == 1) then
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
		rdt:SetText("M+"..mplusdiff)
	elseif difficulty == 9 then
		rdt:SetText("40")
	elseif difficulty == 11 then
		rdt:SetText("HScen")
	elseif difficulty == 12 then
		rdt:SetText("Scen")
	elseif difficulty == 14 then
		rdt:SetText("N:"..numplayers)
	elseif difficulty == 15 then
		rdt:SetText("H:"..numplayers)
	elseif difficulty == 16 then
		rdt:SetText("M")
	elseif difficulty == 17 then
		rdt:SetText("LFR:"..numplayers)
	elseif difficulty == 23 then
		rdt:SetText("M+")
	elseif difficulty == 24 then
		rdt:SetText("TW")
	else
		rdt:SetText("")
	end
end)

HelpOpenTicketButtonTutorial:Hide()
HelpOpenTicketButtonTutorial.Show = F.dummy

local function positionTicketButtons()
	if HelpOpenTicketButton:IsShown() then
		if HelpOpenWebTicketButton:IsShown() then
			HelpOpenTicketButton:ClearAllPoints()
			HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", -17, -5)
			HelpOpenWebTicketButton:ClearAllPoints()
			HelpOpenWebTicketButton:SetPoint("TOP", Minimap, "TOP", 17, -5)
		else
			HelpOpenTicketButton:ClearAllPoints()
			HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", 0, -5)
		end
	elseif HelpOpenWebTicketButton:IsShown() then
		HelpOpenWebTicketButton:ClearAllPoints()
		HelpOpenWebTicketButton:SetPoint("TOP", Minimap, "TOP", 0, -5)
	end
end

for _, ticketButton in pairs({HelpOpenTicketButton, HelpOpenWebTicketButton}) do
	ticketButton:SetParent(Minimap)
	ticketButton:SetHeight(8)
	ticketButton:SetHitRectInsets(0, 0, 0, 0)
	ticketButton:ClearAllPoints()

	ticketButton:SetNormalTexture("")
	ticketButton:SetHighlightTexture("")
	ticketButton:SetPushedTexture("")

	local gmtext = F.CreateFS(ticketButton)
	gmtext:SetPoint("CENTER", 2, -33)
	gmtext:SetText(gsub(CHAT_FLAG_GM, "[<>]", "")) -- magic!

	ticketButton:HookScript("OnShow", positionTicketButtons)
	ticketButton:HookScript("OnHide", positionTicketButtons)
end

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -49, 0)

