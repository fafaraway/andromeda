local F, C, L = unpack(select(2, ...))

C.themes["Blizzard_FlightMap"] = function()
	F.StripTextures(FlightMapFrame.BorderFrame)
	F.SetBD(FlightMapFrame)
	FlightMapFramePortrait:Hide()
	F.ReskinClose(FlightMapFrameCloseButton)
	FlightMapFrameBg:Hide()
	FlightMapFrame.ScrollContainer.Child.TiledBackground:Hide()
end