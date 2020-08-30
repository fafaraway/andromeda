local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FreeADB.appearance.reskin_blizz then return end

	local StackSplitFrame = StackSplitFrame

	F.StripTextures(StackSplitFrame)
	F.SetBD(StackSplitFrame)
	F.Reskin(StackSplitFrame.OkayButton)
	F.Reskin(StackSplitFrame.CancelButton)
	F.ReskinArrow(StackSplitFrame.LeftButton, "left")
	F.ReskinArrow(StackSplitFrame.RightButton, "right")
end)
