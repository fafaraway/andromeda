local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    _G.GuildRegistrarFrameEditBox:SetHeight(20)
    _G.AvailableServicesText:SetTextColor(1, 1, 1)
    _G.AvailableServicesText:SetShadowColor(0, 0, 0)

    F.ReskinPortraitFrame(_G.GuildRegistrarFrame)
    _G.GuildRegistrarFrameEditBox:DisableDrawLayer('BACKGROUND')
    F.CreateBDFrame(_G.GuildRegistrarFrameEditBox, 0.25)
    F.Reskin(_G.GuildRegistrarFrameGoodbyeButton)
    F.Reskin(_G.GuildRegistrarFramePurchaseButton)
    F.Reskin(_G.GuildRegistrarFrameCancelButton)
end)
