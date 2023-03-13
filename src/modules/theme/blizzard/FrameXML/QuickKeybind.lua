local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local frame = _G.QuickKeybindFrame
    F.StripTextures(frame)
    F.StripTextures(frame.Header)
    F.SetBD(frame)
    F.ReskinCheckbox(frame.UseCharacterBindingsButton)
    frame.UseCharacterBindingsButton:SetSize(24, 24)
    F.ReskinButton(frame.OkayButton)
    F.ReskinButton(frame.DefaultsButton)
    F.ReskinButton(frame.CancelButton)
end)
