local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    local ModelPreviewFrame = _G.ModelPreviewFrame
    local Display = ModelPreviewFrame.Display

    Display.YesMountsTex:Hide()
    Display.ShadowOverlay:Hide()

    F.StripTextures(ModelPreviewFrame)
    F.SetBD(ModelPreviewFrame)
    F.ReskinArrow(Display.ModelScene.CarouselLeftButton, 'left')
    F.ReskinArrow(Display.ModelScene.CarouselRightButton, 'right')
    F.ReskinClose(_G.ModelPreviewFrameCloseButton)
    F.ReskinButton(ModelPreviewFrame.CloseButton)

    local bg = F.CreateBDFrame(Display.ModelScene, 0.25)
    bg:SetPoint('TOPLEFT', -1, 0)
    bg:SetPoint('BOTTOMRIGHT', 2, -2)
end)
