local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	ColorPickerFrameHeader:SetAlpha(0)
	ColorPickerFrameHeader:ClearAllPoints()
	ColorPickerFrameHeader:SetPoint("TOP", ColorPickerFrame, 0, 0)
	F.CreateBD(ColorPickerFrame)
	F.CreateSD(ColorPickerFrame)
	--F.Reskin(ColorPickerOkayButton)
	--F.Reskin(ColorPickerCancelButton)
	--F.ReskinSlider(OpacitySliderFrame, true)


	--_G.ColorPickerFrameHeader:Hide()
	--local header = select(3, _G.ColorPickerFrame:GetRegions())
	--header:SetPoint("TOP", _G.ColorPickerFrame, 0, -4)
	--F.CreateBD(_G.ColorPickerFrame)

	F.Reskin(_G.ColorPickerCancelButton)
	_G.ColorPickerCancelButton:SetWidth(100)

	F.Reskin(_G.ColorPickerOkayButton)
	_G.ColorPickerOkayButton:SetWidth(100)
	_G.ColorPickerOkayButton:SetPoint("RIGHT", _G.ColorPickerCancelButton, "LEFT", -10, 0)

	_G.OpacitySliderFrame:ClearAllPoints()
	_G.OpacitySliderFrame:SetPoint("TOPRIGHT", -30, -30)
	F.ReskinSlider(_G.OpacitySliderFrame, true)

	_G.ColorPickerWheel:SetPoint("TOPLEFT", 10, -30)

	local ColorValue = _G.ColorPickerFrame:GetColorValueTexture()
	ColorValue:SetPoint("LEFT", _G.ColorPickerWheel, "RIGHT", 13, 0)

	_G.ColorSwatch:SetPoint("TOPLEFT", 205, -30)

	_G.ColorPickerFrame:HookScript("OnShow", function(self)
		if self.hasOpacity then
			self:SetWidth(400)
		else
			self:SetWidth(360)
		end
	end)

	F.CreateBD(_G.OpacityFrame)
	F.ReskinSlider(_G.OpacityFrameSlider, true)
end)