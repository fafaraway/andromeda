local F, C = unpack(select(2, ...))

C.Themes['Blizzard_FlightMap'] = function()
    F.ReskinPortraitFrame(_G.FlightMapFrame)
    _G.FlightMapFrameBg:Hide()
    _G.FlightMapFrame.ScrollContainer.Child.TiledBackground:Hide()
end
