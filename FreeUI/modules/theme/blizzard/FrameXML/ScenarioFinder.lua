local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not C.Theme.reskin_blizz then return end

	ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
	ScenarioQueueFrame.Bg:Hide()
	ScenarioFinderFrameInset:GetRegions():Hide()
	ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

	F.Reskin(ScenarioQueueFrameFindGroupButton)
	F.Reskin(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
	F.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
	F.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)
	F.ReskinScroll(ScenarioQueueFrameSpecificScrollFrameScrollBar)
end)