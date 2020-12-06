local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	TaxiFrame:DisableDrawLayer("BORDER")
	TaxiFrame:DisableDrawLayer("OVERLAY")
	TaxiFrame.Bg:Hide()
	TaxiFrame.TitleBg:Hide()
	TaxiFrame.TopTileStreaks:Hide()

	F.SetBD(TaxiFrame, nil, 3, -23, -5, 3)
	F.ReskinClose(TaxiFrame.CloseButton, TaxiRouteMap)
end)
