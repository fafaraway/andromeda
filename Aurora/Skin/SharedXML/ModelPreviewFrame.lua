local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.SharedXML.ModelPreviewFrame()
    local ModelPreviewFrame = _G.ModelPreviewFrame
    local Display = ModelPreviewFrame.Display
    local ModelScene = Display.ModelScene

    Display.YesMountsTex:Hide()
    Display.ShadowOverlay:Hide()

    F.ReskinPortraitFrame(ModelPreviewFrame, true)
    F.Reskin(ModelPreviewFrame.CloseButton)
    F.ReskinArrow(ModelScene.RotateLeftButton, "Left")
    F.ReskinArrow(ModelScene.RotateRightButton, "Right")

    local bg = F.CreateBDFrame(ModelScene, .25)
    bg:SetPoint("TOPLEFT", -1, 0)
    bg:SetPoint("BOTTOMRIGHT", 2, -2)

    ModelScene.RotateLeftButton:SetPoint("TOPRIGHT", ModelScene, "BOTTOM", -5, -10)
    ModelScene.RotateRightButton:SetPoint("TOPLEFT", ModelScene, "BOTTOM", 5, -10)
end
