local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    local ColorPickerFrame = _G.ColorPickerFrame

    F.StripTextures(ColorPickerFrame.Header)
    ColorPickerFrame.Header:ClearAllPoints()
    ColorPickerFrame.Header:SetPoint('TOP', ColorPickerFrame, 0, 10)
    ColorPickerFrame.Border:Hide()

    F.SetBD(ColorPickerFrame)
    F.Reskin(_G.ColorPickerOkayButton)
    F.Reskin(_G.ColorPickerCancelButton)
    F.ReskinSlider(_G.OpacitySliderFrame, true)

    _G.ColorPickerCancelButton:ClearAllPoints()
    _G.ColorPickerCancelButton:SetPoint('BOTTOMLEFT', ColorPickerFrame, 'BOTTOM', 1, 6)
    _G.ColorPickerOkayButton:ClearAllPoints()
    _G.ColorPickerOkayButton:SetPoint('BOTTOMRIGHT', ColorPickerFrame, 'BOTTOM', -1, 6)
end)
