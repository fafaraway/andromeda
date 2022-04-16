local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert

local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    local ModelPreviewFrame = _G.ModelPreviewFrame
    local Display = ModelPreviewFrame.Display

    Display.YesMountsTex:Hide()
    Display.ShadowOverlay:Hide()

    F.StripTextures(ModelPreviewFrame)
    F.SetBD(ModelPreviewFrame)
    F.ReskinArrow(Display.ModelScene.RotateLeftButton, 'left')
    F.ReskinArrow(Display.ModelScene.RotateRightButton, 'right')
    F.ReskinArrow(Display.ModelScene.CarouselLeftButton, 'left')
    F.ReskinArrow(Display.ModelScene.CarouselRightButton, 'right')
    F.ReskinClose(_G.ModelPreviewFrameCloseButton)
    F.Reskin(ModelPreviewFrame.CloseButton)

    local bg = F.CreateBDFrame(Display.ModelScene, 0.25)
    bg:SetPoint('TOPLEFT', -1, 0)
    bg:SetPoint('BOTTOMRIGHT', 2, -2)
end)
