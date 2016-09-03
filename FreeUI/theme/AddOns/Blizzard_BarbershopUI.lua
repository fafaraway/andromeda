local F, C = unpack(select(2, ...))

C.themes["Blizzard_BarbershopUI"] = function()
	local BarberShopFrame = BarberShopFrame
	for i = 1, BarberShopFrame:GetNumRegions() do
		local region = select(i, BarberShopFrame:GetRegions())
		region:Hide()
	end
	F.SetBD(BarberShopFrame, 44, -75, -40, 44)

	for i = 1, #BarberShopFrame.Selector do
		local prevBtn, nextBtn = BarberShopFrame.Selector[i]:GetChildren()
		F.ReskinArrow(prevBtn, "left")
		F.ReskinArrow(nextBtn, "right")
	end

	BarberShopFrameMoneyFrame:GetRegions():Hide()
	F.Reskin(BarberShopFrameOkayButton)
	F.Reskin(BarberShopFrameCancelButton)
	F.Reskin(BarberShopFrameResetButton)

	F.SetBD(BarberShopAltFormFrame, 0, 0, 2, -2)
	BarberShopAltFormFrame:ClearAllPoints()
	BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)
	BarberShopAltFormFrameBackground:Hide()
	BarberShopAltFormFrameBorder:Hide()

	-- [[ Banner frame ]]

	BarberShopBannerFrameBGTexture:Hide()

	F.SetBD(BarberShopBannerFrame, 25, -80, -20, 75)
end
