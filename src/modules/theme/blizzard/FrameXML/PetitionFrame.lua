local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    F.ReskinPortraitFrame(_G.PetitionFrame)
    F.ReskinButton(_G.PetitionFrameSignButton)
    F.ReskinButton(_G.PetitionFrameRequestButton)
    F.ReskinButton(_G.PetitionFrameRenameButton)
    F.ReskinButton(_G.PetitionFrameCancelButton)

    _G.PetitionFrameCharterTitle:SetTextColor(1, 0.8, 0)
    _G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMasterTitle:SetTextColor(1, 0.8, 0)
    _G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMemberTitle:SetTextColor(1, 0.8, 0)
    _G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
end)
