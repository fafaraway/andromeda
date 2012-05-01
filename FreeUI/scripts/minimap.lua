local F, C, L = unpack(select(2, ...))

local Scale = 0.9

Minimap:ClearAllPoints()
Minimap:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50 / Scale, 50 / Scale)
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
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "Minimap", -34, -79)
	else
		Minimap_OnClick(self)
	end
end)

MinimapCluster:SetScale(Scale)
MinimapCluster:EnableMouse(false)

local f = Minimap:CreateTexture(nil, "BACKGROUND")
f:SetPoint("TOPLEFT", Minimap, -1 / Scale, 1 / Scale)
f:SetPoint("BOTTOMRIGHT", Minimap, 1 / Scale, -1 / Scale)
f:SetTexture(0, 0, 0)

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

local mt = F.CreateFS(mail, 8 / Scale)
mt:SetPoint("BOTTOM", Minimap, 0, 6 / Scale)
mt:SetText("Mail")

MiniMapMailFrame:SetAlpha(0)
MiniMapMailFrame:SetSize(22, 10)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("CENTER", mt)

ZoneTextString:ClearAllPoints()
ZoneTextString:SetPoint("CENTER", Minimap)
ZoneTextString:SetWidth(140)
ZoneTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
SubZoneTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
PVPInfoTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
PVPArenaTextString:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("CENTER", Minimap)
MinimapZoneTextButton:SetFrameStrata("HIGH")
MinimapZoneTextButton:EnableMouse(false)
MinimapZoneTextButton:SetAlpha(0)
MinimapZoneText:SetFont(C.media.font, 8 / Scale, "OUTLINEMONOCHROME")
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
		"MiniMapBattlefieldBorder",
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

GuildInstanceDifficulty:SetAlpha(0)
TimeManagerClockButton:Hide()

GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -1 / Scale, -1 / Scale)
GameTimeFrame:SetSize(16, 16)
GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
GameTimeFrame:SetNormalTexture("")
GameTimeFrame:SetPushedTexture("")
GameTimeFrame:SetHighlightTexture("")

local _, _, _, _, date = GameTimeFrame:GetRegions()
date:SetTextColor(1, 1, 1)
date:SetFont(C.media.font, 8 / Scale, "OUTLINEMONOCHROME")
date:SetPoint("CENTER")

MiniMapBattlefieldFrame:SetSize(22, 22)
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6 / Scale, 1 / Scale)
MiniMapBattlefieldIcon:Hide()

local bgtext = F.CreateFS(MiniMapBattlefieldFrame, 8 / Scale)
bgtext:SetPoint("CENTER")
bgtext:SetText(PVP)

MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap)

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -49, 0)

LFGSearchStatus:ClearAllPoints()
LFGSearchStatus:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -4.5, -1.5)

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 5 / Scale, -5 / Scale)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")

local rdt = F.CreateFS(rd, 8 / Scale, "LEFT")
rdt:SetPoint("TOPLEFT")

rd:SetScript("OnEvent", function()
	local inInstance, instanceType = IsInInstance()
	local _, _, difficultyIndex, _, _, dynamicDifficulty, isDynamic = GetInstanceInfo()

	if inInstance and instanceType == "raid" then
		if (isDynamic and difficultyIndex == 1 and dynamicDifficulty == 0) or (not isDynamic and difficultyIndex == 1) then
			rdt:SetText("10")
		elseif (isDynamic and (difficultyIndex == 3 and dynamicDifficulty == 0) or (difficultyIndex == 1 and dynamicDifficulty == 1)) or (not isDynamic and difficultyIndex == 3) then
			rdt:SetText("10H")
		elseif (isDynamic and difficultyIndex == 2 and dynamicDifficulty == 0) or (not isDynamic and difficultyIndex == 2) then
			rdt:SetText("25")
		elseif (isDynamic and (difficultyIndex == 2 and dynamicDifficulty == 1) or (difficultyIndex == 4)) or (not isDynamic and difficultyIndex == 4) then
			rdt:SetText("25H")
		end
	elseif inInstance and instanceType == "party" then
		if difficultyIndex == 1 then
			rdt:SetText("5")
		elseif difficultyIndex == 2 then
			rdt:SetText("5H")
		end
	else
		rdt:SetText("")
	end

	if GuildInstanceDifficulty:IsShown() then
		rdt:SetTextColor(0, .9, 0)
	else
		rdt:SetTextColor(1, 1, 1)
	end
end)

HelpOpenTicketButton:SetParent(Minimap)
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetPoint("TOP", Minimap, "TOP", 0, 7 / Scale)

HelpOpenTicketButtonTutorial:Hide()
HelpOpenTicketButtonTutorial.Show = F.dummy

HelpOpenTicketButton:SetNormalTexture("")
HelpOpenTicketButton:SetHighlightTexture("")
HelpOpenTicketButton:SetPushedTexture("")

local gmtext = F.CreateFS(HelpOpenTicketButton, 8 / Scale)
gmtext:SetPoint("CENTER")
gmtext:SetText(gsub(CHAT_FLAG_GM, "[<>]", "")) -- magic!