local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	-- Dressup Frame

	F.ReskinPortraitFrame(DressUpFrame)
	F.Reskin(DressUpFrameOutfitDropDown.SaveButton)
	F.Reskin(DressUpFrameCancelButton)
	F.Reskin(DressUpFrameResetButton)
	F.StripTextures(DressUpFrameOutfitDropDown)
	F.ReskinDropDown(DressUpFrameOutfitDropDown)
	F.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -10, 0)
	DressUpFrame.ModelBackground:Hide()
	F.CreateBDFrame(DressUpFrame.ModelBackground)

	DressUpFrameOutfitDropDown:SetHeight(32)
	DressUpFrameOutfitDropDown.SaveButton:SetPoint("LEFT", DressUpFrameOutfitDropDown, "RIGHT", -13, 2)
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -C.Mult, 0)

	F.ReskinMinMax(MaximizeMinimizeFrame)

	-- SideDressUp

	F.StripTextures(SideDressUpFrame, 0)
	select(5, SideDressUpModelCloseButton:GetRegions()):Hide()

	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", C.Mult, 0)
	end)

	F.Reskin(SideDressUpModelResetButton)
	F.ReskinClose(SideDressUpModelCloseButton)
	F.SetBD(SideDressUpModel)
end)
