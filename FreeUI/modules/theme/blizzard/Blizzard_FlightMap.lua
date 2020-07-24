local F, C = unpack(select(2, ...))

C.Themes["Blizzard_FlightMap"] = function()
	F.ReskinPortraitFrame(FlightMapFrame)
	FlightMapFrameBg:Hide()
	FlightMapFrame.ScrollContainer.Child.TiledBackground:Hide()
end