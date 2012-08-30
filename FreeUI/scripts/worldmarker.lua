local F, C = unpack(FreeUI)

local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

wm:SetParent("UIParent")
wm:ClearAllPoints()
wm:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 5, 5)
wm:SetSize(16, 16)
wm:Hide()
wm:SetNormalTexture("")
wm:SetHighlightTexture("")

local plus = F.CreateFS(wm, 16)
plus:SetPoint("CENTER", 1, 0)
plus:SetText("+")

wm:HookScript("OnEnter", function()
	plus:SetTextColor(unpack(C.class))
end)

wm:HookScript("OnLeave", function()
	plus:SetTextColor(1, 1, 1)
end)

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