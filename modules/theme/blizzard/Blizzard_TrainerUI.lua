local F, C = unpack(select(2, ...))

C.Themes['Blizzard_TrainerUI'] = function()
    local r, g, b = C.r, C.g, C.b

    F.ReskinPortraitFrame(_G.ClassTrainerFrame)
    _G.ClassTrainerStatusBarSkillRank:ClearAllPoints()
    _G.ClassTrainerStatusBarSkillRank:SetPoint('CENTER', _G.ClassTrainerStatusBar, 'CENTER', 0, 0)

    local icbg = F.ReskinIcon(_G.ClassTrainerFrameSkillStepButtonIcon)
    local bg = F.CreateBDFrame(_G.ClassTrainerFrameSkillStepButton, 0.25)
    bg:SetPoint('TOPLEFT', icbg, 'TOPRIGHT', 1, 0)
    bg:SetPoint('BOTTOMRIGHT', icbg, 'BOTTOMRIGHT', 270, 0)

    _G.ClassTrainerFrameSkillStepButton:SetNormalTexture('')
    _G.ClassTrainerFrameSkillStepButton:SetHighlightTexture('')
    _G.ClassTrainerFrameSkillStepButton.disabledBG:SetTexture('')
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetAllPoints(bg)
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetColorTexture(r, g, b, 0.25)

    hooksecurefunc('ClassTrainerFrame_Update', function()
        for _, bu in next, _G.ClassTrainerFrame.scrollFrame.buttons do
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

    F.StripTextures(_G.ClassTrainerStatusBar)
    _G.ClassTrainerStatusBar:SetPoint('TOPLEFT', _G.ClassTrainerFrame, 'TOPLEFT', 64, -35)
    _G.ClassTrainerStatusBar:SetStatusBarTexture(C.Assets.Texture.Backdrop)
    _G.ClassTrainerStatusBar:GetStatusBarTexture():SetGradient('VERTICAL', 0.1, 0.3, 0.9, 0.2, 0.4, 1)
    F.CreateBDFrame(_G.ClassTrainerStatusBar, 0.25)

    F.Reskin(_G.ClassTrainerTrainButton)
    F.ReskinScroll(_G.ClassTrainerScrollFrameScrollBar)
    F.ReskinDropDown(_G.ClassTrainerFrameFilterDropDown)
end
