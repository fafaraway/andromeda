local F, C = unpack(select(2, ...))

C.Themes["Blizzard_ScrappingMachineUI"] = function()
	F.ReskinPortraitFrame(ScrappingMachineFrame)
	F.Reskin(ScrappingMachineFrame.ScrapButton)

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	F.StripTextures(ItemSlots)

	for button in pairs(ItemSlots.scrapButtons.activeObjects) do
		F.StripTextures(button)
		button.Icon:SetTexCoord(unpack(C.TexCoord))
		button.bg = F.CreateBDFrame(button.Icon, .25)
		F.ReskinIconBorder(button.IconBorder)
		local hl = button:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetAllPoints(button.Icon)
	end
end
