local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local class = select(2, UnitClass('player'))
    if class ~= 'HUNTER' then
        return
    end

    local x1, x2, y1, y2 = unpack(C.TEX_COORD)

    _G.PetStableBottomInset:Hide()
    _G.PetStableLeftInset:Hide()
    _G.PetStableFrameModelBg:Hide()
    _G.PetStablePrevPageButtonIcon:SetTexture('')
    _G.PetStableNextPageButtonIcon:SetTexture('')
    _G.PetStableDietTexture:SetTexture(132165)
	_G.PetStableDietTexture:SetTexCoord(x1, x2, y1, y2)

    F.ReskinPortraitFrame(_G.PetStableFrame)
    F.ReskinArrow(_G.PetStablePrevPageButton, 'left')
    F.ReskinArrow(_G.PetStableNextPageButton, 'right')
    F.ReskinIcon(_G.PetStableSelectedPetIcon)

    for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
        local bu = _G['PetStableActivePet' .. i]
        bu.Background:Hide()
        bu.Border:Hide()
        bu:SetNormalTexture(0)
        bu:SetPushedTexture(0)
        bu.Checked:SetTexture(C.Assets.Textures.ButtonChecked)
        bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

        _G['PetStableActivePet' .. i .. 'IconTexture']:SetTexCoord(x1, x2, y1, y2)
        F.CreateBDFrame(bu, 0.25)
    end

    for i = 1, _G.NUM_PET_STABLE_SLOTS do
        local bu = _G['PetStableStabledPet' .. i]
        bu:SetNormalTexture(0)
        bu:SetPushedTexture(0)
        bu.Checked:SetTexture(C.Assets.Textures.ButtonChecked)
        bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        bu:DisableDrawLayer('BACKGROUND')

        _G['PetStableStabledPet' .. i .. 'IconTexture']:SetTexCoord(x1, x2, y1, y2)
        F.CreateBDFrame(bu, 0.25)
    end
end)
