local F, C, L = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	F.CreateBD(StackSplitFrame)
	F.CreateSD(StackSplitFrame)
	StackSplitFrame:GetRegions():Hide()
	F.Reskin(StackSplitOkayButton)
	F.Reskin(StackSplitCancelButton)
end)