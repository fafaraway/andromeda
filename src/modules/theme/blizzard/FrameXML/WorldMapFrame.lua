local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local WorldMapFrame = _G.WorldMapFrame
    local BorderFrame = WorldMapFrame.BorderFrame

    F.ReskinPortraitFrame(WorldMapFrame)
    BorderFrame.NineSlice:Hide()
    BorderFrame.Tutorial.Ring:Hide()
    F.ReskinMinMax(BorderFrame.MaximizeMinimizeFrame)

    local overlayFrames = WorldMapFrame.overlayFrames
    F.ReskinDropdown(overlayFrames[1])
    F.StripTextures(overlayFrames[2], 3)
    F.StripTextures(overlayFrames[3], 3)
    overlayFrames[3].ActiveTexture:SetTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Toggle')

    local sideToggle = WorldMapFrame.SidePanelToggle
    sideToggle:SetFrameLevel(3)
    sideToggle.OpenButton:GetRegions():Hide()
    F.ReskinArrow(sideToggle.OpenButton, 'right')
    sideToggle.CloseButton:GetRegions():Hide()
    F.ReskinArrow(sideToggle.CloseButton, 'left')

    F.ReskinNavBar(WorldMapFrame.NavBar)

    for i = 1, #overlayFrames do
        local frame = overlayFrames[i]
        if frame.BountyDropdownButton then
            F.ReskinArrow(frame.BountyDropdownButton, 'right')
            break
        end
    end
end)
