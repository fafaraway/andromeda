local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.StripTextures(ColorPickerFrame.Header)
	ColorPickerFrame.Header:ClearAllPoints()
	ColorPickerFrame.Header:SetPoint("TOP", ColorPickerFrame, 0, 0)
	ColorPickerFrame.Border:Hide()

	F.SetBD(ColorPickerFrame)
	F.Reskin(ColorPickerOkayButton)
	F.Reskin(ColorPickerCancelButton)
	F.ReskinSlider(OpacitySliderFrame, true)
end)
