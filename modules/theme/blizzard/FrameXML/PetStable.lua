local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    local class = select(2, UnitClass('player'))
    if class ~= 'HUNTER' then
        return
    end

    _G.PetStableBottomInset:Hide()
    _G.PetStableLeftInset:Hide()
    _G.PetStableModelShadow:Hide()
    _G.PetStableModelRotateLeftButton:Hide()
    _G.PetStableModelRotateRightButton:Hide()
    _G.PetStableFrameModelBg:Hide()
    _G.PetStablePrevPageButtonIcon:SetTexture('')
    _G.PetStableNextPageButtonIcon:SetTexture('')

    F.ReskinPortraitFrame(_G.PetStableFrame)
    F.ReskinArrow(_G.PetStablePrevPageButton, 'left')
    F.ReskinArrow(_G.PetStableNextPageButton, 'right')
    F.ReskinIcon(_G.PetStableSelectedPetIcon)

    for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
        local bu = _G['PetStableActivePet' .. i]
        bu.Background:Hide()
        bu.Border:Hide()
        bu:SetNormalTexture('')
        bu:SetPushedTexture('')
        bu.Checked:SetTexture(C.Assets.Button.Checked)
        bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

        _G['PetStableActivePet' .. i .. 'IconTexture']:SetTexCoord(unpack(C.TEX_COORD))
        F.CreateBDFrame(bu, 0.25)
    end

    for i = 1, _G.NUM_PET_STABLE_SLOTS do
        local bu = _G['PetStableStabledPet' .. i]
        bu:SetNormalTexture('')
        bu:SetPushedTexture('')
        bu.Checked:SetTexture(C.Assets.Button.Checked)
        bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        bu:DisableDrawLayer('BACKGROUND')

        _G['PetStableStabledPet' .. i .. 'IconTexture']:SetTexCoord(unpack(C.TEX_COORD))
        F.CreateBDFrame(bu, 0.25)
    end
end)
