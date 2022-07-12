local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    F.ReskinPortraitFrame(_G.TabardFrame)
    _G.TabardFrameMoneyInset:Hide()
    _G.TabardFrameMoneyBg:Hide()
    F.CreateBDFrame(_G.TabardFrameCostFrame, 0.25)
    F.Reskin(_G.TabardFrameAcceptButton)
    F.Reskin(_G.TabardFrameCancelButton)
    F.ReskinArrow(_G.TabardCharacterModelRotateLeftButton, 'left')
    F.ReskinArrow(_G.TabardCharacterModelRotateRightButton, 'right')
    _G.TabardCharacterModelRotateRightButton:SetPoint('TOPLEFT', _G.TabardCharacterModelRotateLeftButton, 'TOPRIGHT', 1, 0)

    _G.TabardFrameCustomizationBorder:Hide()
    for i = 1, 5 do
        F.StripTextures(_G['TabardFrameCustomization' .. i])
        F.ReskinArrow(_G['TabardFrameCustomization' .. i .. 'LeftButton'], 'left')
        F.ReskinArrow(_G['TabardFrameCustomization' .. i .. 'RightButton'], 'right')
    end
end)
