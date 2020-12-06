local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local class = select(2, UnitClass("player"))
	if class ~= "HUNTER" then return end

	PetStableBottomInset:Hide()
	PetStableLeftInset:Hide()
	PetStableModelShadow:Hide()
	PetStableModelRotateLeftButton:Hide()
	PetStableModelRotateRightButton:Hide()
	PetStableFrameModelBg:Hide()
	PetStablePrevPageButtonIcon:SetTexture("")
	PetStableNextPageButtonIcon:SetTexture("")

	F.ReskinPortraitFrame(PetStableFrame)
	F.ReskinArrow(PetStablePrevPageButton, "left")
	F.ReskinArrow(PetStableNextPageButton, "right")
	F.ReskinIcon(PetStableSelectedPetIcon)

	for i = 1, NUM_PET_ACTIVE_SLOTS do
		local bu = _G["PetStableActivePet"..i]
		bu.Background:Hide()
		bu.Border:Hide()
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu.Checked:SetTexture(C.Assets.button_checked)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)

		_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(unpack(C.TexCoord))
		F.CreateBDFrame(bu, .25)
	end

	for i = 1, NUM_PET_STABLE_SLOTS do
		local bu = _G["PetStableStabledPet"..i]
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu.Checked:SetTexture(C.Assets.button_checked)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		bu:DisableDrawLayer("BACKGROUND")

		_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(unpack(C.TexCoord))
		F.CreateBDFrame(bu, .25)
	end
end)
