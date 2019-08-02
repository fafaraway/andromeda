local F, C = unpack(select(2, ...))

C.themes["Blizzard_ScrappingMachineUI"] = function()
	F.ReskinPortraitFrame(ScrappingMachineFrame)
	F.Reskin(ScrappingMachineFrame.ScrapButton)

	local function refreshIcon(self)
		local quality = 1
		if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
			quality = self.item:GetItemQuality()
		end
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	local ItemSlots = ScrappingMachineFrame.ItemSlots
	F.StripTextures(ItemSlots)

	for button in pairs(ItemSlots.scrapButtons.activeObjects) do
		if not button.styled then
			button.IconBorder:SetAlpha(0)
			button.Icon:SetTexCoord(unpack(C.TexCoord))
			button.bg = F.CreateBDFrame(button.Icon, .25)
			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(1, 1, 1, .3)
			hl:SetAllPoints(button.Icon)
			hooksecurefunc(button, "RefreshIcon", refreshIcon)

			button.styled = true
		end
	end
end