local F, C = unpack(select(2, ...))

C.Themes['Blizzard_ArtifactUI'] = function()
    local ArtifactFrame = _G.ArtifactFrame

    F.StripTextures(ArtifactFrame)
    F.SetBD(ArtifactFrame)
    F.ReskinTab(_G.ArtifactFrameTab1)
    F.ReskinTab(_G.ArtifactFrameTab2)
    _G.ArtifactFrameTab1:ClearAllPoints()
    _G.ArtifactFrameTab1:SetPoint('TOPLEFT', ArtifactFrame, 'BOTTOMLEFT', 10, 0)
    F.ReskinClose(ArtifactFrame.CloseButton)
    ArtifactFrame.Background:Hide()
    ArtifactFrame.PerksTab.BackgroundBack:Hide()
    ArtifactFrame.PerksTab.Model.BackgroundBackShadow:Hide()
    ArtifactFrame.PerksTab.HeaderBackground:Hide()
    ArtifactFrame.PerksTab.TitleContainer.Background:SetAlpha(0)
    ArtifactFrame.PerksTab.Model:SetAlpha(0.5)
    ArtifactFrame.PerksTab.Model.BackgroundFront:Hide()
    ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackground:SetAlpha(0)
    ArtifactFrame.ForgeBadgeFrame.ForgeLevelBackgroundBlack:SetAlpha(0)
    ArtifactFrame.ForgeBadgeFrame.ItemIcon:Hide()
    ArtifactFrame.AppearancesTab.Background:Hide()

    -- Appearance

    for i = 1, 6 do
        local set = ArtifactFrame.AppearancesTab.appearanceSetPool:Acquire()
        set.Background:Hide()
        local bg = F.CreateBDFrame(set, 0, true)
        bg:SetPoint('TOPLEFT', 10, -5)
        bg:SetPoint('BOTTOMRIGHT', -10, 5)
        for j = 1, 4 do
            local slot = ArtifactFrame.AppearancesTab.appearanceSlotPool:Acquire()
            slot.Border:SetAlpha(0)
            F.CreateBDFrame(slot)

            slot.Background:Hide()
            slot.SwatchTexture:SetTexCoord(0.2, 0.8, 0.2, 0.8)
            slot.SwatchTexture:SetAllPoints()
            slot.HighlightTexture:SetColorTexture(1, 1, 1, 0.25)
            slot.HighlightTexture:SetAllPoints()

            slot.Selected:SetDrawLayer('BACKGROUND')
            slot.Selected:SetTexture(C.Assets.Textures.Backdrop)
            slot.Selected:SetVertexColor(1, 1, 0)
            slot.Selected:SetOutside()
        end
    end
end
