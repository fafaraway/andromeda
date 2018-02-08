local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.TaxiFrame()
    local TaxiFrame = _G.TaxiFrame
    TaxiFrame:DisableDrawLayer("BORDER")
    TaxiFrame:DisableDrawLayer("OVERLAY")
    TaxiFrame.Bg:Hide()
    TaxiFrame.TitleBg:Hide()
    TaxiFrame.TopTileStreaks:Hide()

    F.SetBD(TaxiFrame, 3, -private.FRAME_TITLE_HEIGHT, -5, 3)
    F.ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", _G.TaxiRouteMap, "TOPRIGHT", -6, -6)
end
