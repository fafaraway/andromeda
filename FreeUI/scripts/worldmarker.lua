local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 6, 6)
wm:SetSize(16, 16)
wm:Hide()

CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonLeft:SetAlpha(0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonMiddle:SetAlpha(0)
CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButtonRight:SetAlpha(0)

wm:RegisterEvent("GROUP_ROSTER_UPDATE")
wm:HookScript("OnEvent", function(self)
	local num = GetNumGroupMembers()
	if (num > 5 and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player"))) or (num > 0 and num <= 5) then
		self:Show()
	else
		self:Hide()
	end
end)