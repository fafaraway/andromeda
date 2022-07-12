local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local TaxiFrame = _G.TaxiFrame
    TaxiFrame:DisableDrawLayer('BORDER')
    TaxiFrame:DisableDrawLayer('OVERLAY')
    TaxiFrame.Bg:Hide()
    TaxiFrame.TitleBg:Hide()
    TaxiFrame.TopTileStreaks:Hide()

    F.SetBD(TaxiFrame, nil, 3, -23, -5, 3)
    F.ReskinClose(TaxiFrame.CloseButton, _G.TaxiRouteMap)
end)
