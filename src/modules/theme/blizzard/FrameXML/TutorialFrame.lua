local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    F.SetBD(_G.TutorialFrame)

    _G.TutorialFrameBackground:Hide()
    _G.TutorialFrameBackground.Show = nop
    _G.TutorialFrame:DisableDrawLayer('BORDER')

    F.Reskin(_G.TutorialFrameOkayButton, true)
    F.ReskinClose(_G.TutorialFrameCloseButton)
    F.ReskinArrow(_G.TutorialFramePrevButton, 'left')
    F.ReskinArrow(_G.TutorialFrameNextButton, 'right')

    _G.TutorialFrameOkayButton:ClearAllPoints()
    _G.TutorialFrameOkayButton:SetPoint('BOTTOMLEFT', _G.TutorialFrameNextButton, 'BOTTOMRIGHT', 10, 0)

    _G.TutorialFramePrevButton:SetScript('OnEnter', nil)
    _G.TutorialFrameNextButton:SetScript('OnEnter', nil)
    _G.TutorialFrameOkayButton.__bg:SetBackdropColor(0, 0, 0, 0.25)
    _G.TutorialFramePrevButton.__bg:SetBackdropColor(0, 0, 0, 0.25)
    _G.TutorialFrameNextButton.__bg:SetBackdropColor(0, 0, 0, 0.25)
end)
