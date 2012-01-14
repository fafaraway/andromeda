local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 6, 6)
wm:SetSize(16, 16)
wm:Hide()

CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0)

wm:RegisterEvent("PARTY_MEMBERS_CHANGED")
wm:HookScript("OnEvent", function(self)
	local raid = GetNumRaidMembers() > 0
	if (raid and (IsRaidLeader() or IsRaidOfficer())) or (GetNumPartyMembers() > 0 and not raid) then
		self:Show()
	else
		self:Hide()
	end
end)