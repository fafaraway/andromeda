local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	RaidFinderFrameBottomInset:Hide()
	RaidFinderFrameRoleBackground:Hide()
	RaidFinderFrameRoleInset:Hide()
	RaidFinderQueueFrameBackground:Hide()

	-- this fixes right border of second reward being cut off
	RaidFinderQueueFrameScrollFrame:SetWidth(RaidFinderQueueFrameScrollFrame:GetWidth()+1)

	F.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)
	F.ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)
	F.Reskin(RaidFinderFrameFindRaidButton)
	F.Reskin(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
	F.Reskin(RaidFinderQueueFramePartyBackfillBackfillButton)
	F.Reskin(RaidFinderQueueFramePartyBackfillNoBackfillButton)
end)
