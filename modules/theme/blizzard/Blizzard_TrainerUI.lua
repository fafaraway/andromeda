local F, C = unpack(select(2, ...))

C.Themes['Blizzard_TrainerUI'] = function()
    local r, g, b = C.r, C.g, C.b

    F.ReskinPortraitFrame(ClassTrainerFrame)
    ClassTrainerStatusBarSkillRank:ClearAllPoints()
    ClassTrainerStatusBarSkillRank:SetPoint('CENTER', ClassTrainerStatusBar, 'CENTER', 0, 0)

    local icbg = F.ReskinIcon(ClassTrainerFrameSkillStepButtonIcon)
    local bg = F.CreateBDFrame(ClassTrainerFrameSkillStepButton, 0.25)
    bg:SetPoint('TOPLEFT', icbg, 'TOPRIGHT', 1, 0)
    bg:SetPoint('BOTTOMRIGHT', icbg, 'BOTTOMRIGHT', 270, 0)

    ClassTrainerFrameSkillStepButton:SetNormalTexture('')
    ClassTrainerFrameSkillStepButton:SetHighlightTexture('')
    ClassTrainerFrameSkillStepButton.disabledBG:SetTexture('')
    ClassTrainerFrameSkillStepButton.selectedTex:SetAllPoints(bg)
    ClassTrainerFrameSkillStepButton.selectedTex:SetColorTexture(r, g, b, 0.25)

    hooksecurefunc('ClassTrainerFrame_Update', function()
        for _, bu in next, ClassTrainerFrame.scrollFrame.buttons do
            if not bu.styled then
                local icbg = F.ReskinIcon(bu.icon)
                local bg = F.CreateBDFrame(bu, 0.25)
                bg:SetPoint('TOPLEFT', icbg, 'TOPRIGHT', 1, 0)
                bg:SetPoint('BOTTOMRIGHT', icbg, 'BOTTOMRIGHT', 253, 0)

                bu.name:SetParent(bg)
                bu.name:SetPoint('TOPLEFT', bu.icon, 'TOPRIGHT', 6, -2)
                bu.subText:SetParent(bg)
                bu.money:SetParent(bg)
                bu.money:SetPoint('TOPRIGHT', bu, 'TOPRIGHT', 5, -8)
                bu:SetNormalTexture('')
                bu:SetHighlightTexture('')
                bu.disabledBG:Hide()
                bu.disabledBG.Show = nop
                bu.selectedTex:SetAllPoints(bg)
                bu.selectedTex:SetColorTexture(r, g, b, 0.25)

                bu.styled = true
            end
        end
    end)

    F.StripTextures(ClassTrainerStatusBar)
    ClassTrainerStatusBar:SetPoint('TOPLEFT', ClassTrainerFrame, 'TOPLEFT', 64, -35)
    ClassTrainerStatusBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    ClassTrainerStatusBar:GetStatusBarTexture():SetGradient('VERTICAL', 0.1, 0.3, 0.9, 0.2, 0.4, 1)
    F.CreateBDFrame(ClassTrainerStatusBar, 0.25)

    F.Reskin(ClassTrainerTrainButton)
    F.ReskinScroll(ClassTrainerScrollFrameScrollBar)
    F.ReskinDropDown(ClassTrainerFrameFilterDropDown)
end
