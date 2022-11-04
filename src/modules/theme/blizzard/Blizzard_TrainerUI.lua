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

    _G.ClassTrainerFrameSkillStepButton:SetNormalTexture(0)
    _G.ClassTrainerFrameSkillStepButton:SetHighlightTexture(0)
    _G.ClassTrainerFrameSkillStepButton.disabledBG:SetTexture(0)
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetInside(bg)
    _G.ClassTrainerFrameSkillStepButton.selectedTex:SetColorTexture(r, g, b, 0.25)

    F.StripTextures(_G.ClassTrainerStatusBar)
    _G.ClassTrainerStatusBar:SetPoint('TOPLEFT', _G.ClassTrainerFrame, 'TOPLEFT', 64, -35)
    _G.ClassTrainerStatusBar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
    _G.ClassTrainerStatusBar:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(0.1, 0.3, 0.9, 1), CreateColor(0.2, 0.4, 1, 1))
    F.ReskinTrimScroll(_G.ClassTrainerFrame.ScrollBar)

    hooksecurefunc(_G.ClassTrainerFrame.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local button = select(i, self.ScrollTarget:GetChildren())
            if not button.styled then
                local icbg = F.ReskinIcon(button.icon)
                local bg = F.CreateBDFrame(button, 0.25)
                bg:SetPoint('TOPLEFT', icbg, 'TOPRIGHT', 1, 0)
                bg:SetPoint('BOTTOMRIGHT', icbg, 'BOTTOMRIGHT', 253, 0)

                button.name:SetParent(bg)
                button.name:SetPoint('TOPLEFT', button.icon, 'TOPRIGHT', 6, -2)
                button.subText:SetParent(bg)
                button.money:SetParent(bg)
                button.money:SetPoint('TOPRIGHT', button, 'TOPRIGHT', 5, -8)
                button:SetNormalTexture(0)
                button:SetHighlightTexture(0)
                button.disabledBG:SetTexture(0)
                button.selectedTex:SetInside(bg)
                button.selectedTex:SetColorTexture(r, g, b, 0.25)

                button.styled = true
            end
        end
    end)

    F.CreateBDFrame(_G.ClassTrainerStatusBar, 0.25)

    F.Reskin(_G.ClassTrainerTrainButton)
    F.ReskinDropDown(_G.ClassTrainerFrameFilterDropDown)
end
