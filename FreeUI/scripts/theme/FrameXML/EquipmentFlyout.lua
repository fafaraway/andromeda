local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	EquipmentFlyoutFrameHighlight:Hide()

	local border = F.CreateBDFrame(EquipmentFlyoutFrame, 0)
	border:SetBackdropBorderColor(1, 1, 1)
	border:SetPoint("TOPLEFT", 2, -2)
	border:SetPoint("BOTTOMRIGHT", -2, 2)

	local navFrame = EquipmentFlyoutFrame.NavigationFrame

	EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
	EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
	Test2:Hide() -- wat

	navFrame:SetWidth(204)
	navFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 1, 0)

	hooksecurefunc("EquipmentFlyout_CreateButton", function()
		local bu = EquipmentFlyoutFrame.buttons[#EquipmentFlyoutFrame.buttons]
		local border = bu.IconBorder

		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBG(bu)

		border:SetTexture(C.media.bdTex)
		border.SetTexture = F.Dummy
		border:SetPoint("TOPLEFT", -C.Mult, C.Mult)
		border:SetPoint("BOTTOMRIGHT", C.Mult, -C.Mult)
		border:SetDrawLayer("BACKGROUND", 1)

		bu.icon:SetTexCoord(unpack(C.TexCoord))
	end)

	hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
		local location = button.location
		local border = button.IconBorder
		if not location or not border then return end
		if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
			border:Hide()
		else
			border:Show()
		end
	end)

	F.CreateBD(EquipmentFlyoutFrame.NavigationFrame)
	F.CreateSD(EquipmentFlyoutFrame.NavigationFrame)
	F.ReskinArrow(EquipmentFlyoutFrame.NavigationFrame.PrevButton, "left")
	F.ReskinArrow(EquipmentFlyoutFrame.NavigationFrame.NextButton, "right")
end)