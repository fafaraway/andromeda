local F, C, L = unpack(select(2, ...))

if not IsAddOnLoaded("Blizzard_CompactRaidFrames") then return end

local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 5, 35)
wm:SetSize(16, 16)
wm:Hide()

wm.TopLeft:Hide()
wm.TopRight:Hide()
wm.BottomLeft:Hide()
wm.BottomRight:Hide()
wm.TopMiddle:Hide()
wm.MiddleLeft:Hide()
wm.MiddleRight:Hide()
wm.BottomMiddle:Hide()
wm.MiddleMiddle:Hide()
wm:SetNormalTexture("")
wm:SetHighlightTexture("")

F.StripTextures(wm)

local plus = F.CreateFS(wm, C.media.pixel, 16, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
plus:SetPoint("CENTER", 1, 0)
plus:SetText("+")

wm:HookScript("OnEnter", function()
	plus:SetTextColor(unpack(C.class))
end)

wm:HookScript("OnLeave", function()
	plus:SetTextColor(1, 1, 1)
end)

wm:RegisterEvent("PARTY_LEADER_CHANGED")
wm:RegisterEvent("GROUP_ROSTER_UPDATE")
wm:RegisterEvent("PLAYER_ENTERING_WORLD")
wm:HookScript("OnEvent", function(self)
	local inRaid = IsInRaid()
	if (inRaid and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) or (not inRaid and IsInGroup()) then
		self:Show()
	else
		self:Hide()
	end
end)
