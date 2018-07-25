local F, C, L = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local ProductChoiceFrame = ProductChoiceFrame

	ProductChoiceFrame.Inset.Bg:Hide()
	ProductChoiceFrame.Inset:DisableDrawLayer("BORDER")

	F.ReskinPortraitFrame(ProductChoiceFrame)
	F.Reskin(ProductChoiceFrame.Inset.ClaimButton)
end)