local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    local ColorPickerFrame = _G.ColorPickerFrame

    F.StripTextures(ColorPickerFrame.Header)
    ColorPickerFrame.Header:ClearAllPoints()
    ColorPickerFrame.Header:SetPoint('TOP', ColorPickerFrame, 0, 10)
    ColorPickerFrame.Border:Hide()

    F.SetBD(ColorPickerFrame)
    F.ReskinButton(_G.ColorPickerFrame.Footer.OkayButton)
    F.ReskinButton(_G.ColorPickerFrame.Footer.CancelButton)
    -- F.ReskinSlider(_G.OpacitySliderFrame, true)

    -- _G.ColorPickerFrame.Footer.CancelButton:ClearAllPoints()
    -- _G.ColorPickerFrame.Footer.CancelButton:SetPoint('BOTTOMLEFT', ColorPickerFrame, 'BOTTOM', 1, 6)
    -- _G.ColorPickerFrame.Footer.OkayButton:ClearAllPoints()
    -- _G.ColorPickerFrame.Footer.OkayButton:SetPoint('BOTTOMRIGHT', ColorPickerFrame, 'BOTTOM', -1, 6)
end)
