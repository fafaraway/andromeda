local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local frame = _G.QuickKeybindFrame
    F.StripTextures(frame)
    F.StripTextures(frame.Header)
    F.SetBD(frame)
    F.ReskinCheckButton(frame.UseCharacterBindingsButton)
    frame.UseCharacterBindingsButton:SetSize(24, 24)
    F.Reskin(frame.OkayButton)
    F.Reskin(frame.DefaultsButton)
    F.Reskin(frame.CancelButton)
end)
