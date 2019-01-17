local F, C = unpack(select(2, ...))

C.themes["Blizzard_ItemUpgradeUI"] = function()
	local ItemUpgradeFrame = ItemUpgradeFrame
	local ItemButton = ItemUpgradeFrame.ItemButton

	ItemUpgradeFrame:DisableDrawLayer("BACKGROUND")
	ItemUpgradeFrame:DisableDrawLayer("BORDER")
	ItemUpgradeFrameMoneyFrameLeft:Hide()
	ItemUpgradeFrameMoneyFrameMiddle:Hide()
	ItemUpgradeFrameMoneyFrameRight:Hide()
	ItemUpgradeFrame.ButtonFrame:GetRegions():Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBorder:Hide()
	ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:Hide()
	ItemButton.Frame:Hide()
	ItemButton.Grabber:Hide()
	ItemButton.TextFrame:Hide()
	ItemButton.TextGrabber:Hide()

	F.CreateBD(ItemButton, .25)
	ItemButton:SetHighlightTexture("")
	ItemButton:SetPushedTexture("")
	ItemButton.IconTexture:SetPoint("TOPLEFT", C.Mult, -C.Mult)
	ItemButton.IconTexture:SetPoint("BOTTOMRIGHT", -C.Mult, C.Mult)

	local bg = F.CreateBDFrame(ItemButton, .25)
	bg:ClearAllPoints()
	bg:SetSize(341, 50)
	bg:SetPoint("LEFT", ItemButton, "RIGHT", -1, 0)

	ItemButton:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, .56, .85)
	end)
	ItemButton:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)

	ItemButton.Cost.Icon:SetTexCoord(unpack(C.TexCoord))
	ItemButton.Cost.Icon.bg = F.CreateBG(ItemButton.Cost.Icon)

	hooksecurefunc("ItemUpgradeFrame_Update", function()
		if GetItemUpgradeItemInfo() then
			ItemButton.IconTexture:SetTexCoord(unpack(C.TexCoord))
			ItemButton.Cost.Icon.bg:Show()
		else
			ItemButton.IconTexture:SetTexture("")
			ItemButton.Cost.Icon.bg:Hide()
		end
	end)

	local currency = ItemUpgradeFrameMoneyFrame.Currency
	currency.icon:SetPoint("LEFT", currency.count, "RIGHT", 1, 0)
	currency.icon:SetTexCoord(unpack(C.TexCoord))
	F.CreateBG(currency.icon)

	F.CreateBDFrame(ItemUpgradeFrame)
	F.ReskinPortraitFrame(ItemUpgradeFrame, true)
	F.Reskin(ItemUpgradeFrameUpgradeButton)
end