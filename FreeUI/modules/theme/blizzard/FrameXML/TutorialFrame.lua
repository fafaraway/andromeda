local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.SetBD(TutorialFrame)

	TutorialFrameBackground:Hide()
	TutorialFrameBackground.Show = F.Dummy
	TutorialFrame:DisableDrawLayer("BORDER")

	F.Reskin(TutorialFrameOkayButton, true)
	F.ReskinClose(TutorialFrameCloseButton)
	F.ReskinArrow(TutorialFramePrevButton, "left")
	F.ReskinArrow(TutorialFrameNextButton, "right")

	TutorialFrameOkayButton:ClearAllPoints()
	TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)

	-- because gradient alpha and OnUpdate doesn't work for some reason...

	if select(14, TutorialFrameOkayButton:GetRegions()) then
		select(14, TutorialFrameOkayButton:GetRegions()):Hide()
		select(15, TutorialFramePrevButton:GetRegions()):Hide()
		select(15, TutorialFrameNextButton:GetRegions()):Hide()
		select(14, TutorialFrameCloseButton:GetRegions()):Hide()
	end
	TutorialFramePrevButton:SetScript("OnEnter", nil)
	TutorialFrameNextButton:SetScript("OnEnter", nil)
	TutorialFrameOkayButton.__bg:SetBackdropColor(0, 0, 0, .25)
	TutorialFramePrevButton.__bg:SetBackdropColor(0, 0, 0, .25)
	TutorialFrameNextButton.__bg:SetBackdropColor(0, 0, 0, .25)
end)
