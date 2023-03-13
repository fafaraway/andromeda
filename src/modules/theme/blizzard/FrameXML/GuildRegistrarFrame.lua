local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    _G.GuildRegistrarFrameEditBox:SetHeight(20)
    _G.AvailableServicesText:SetTextColor(1, 1, 1)
    _G.AvailableServicesText:SetShadowColor(0, 0, 0)

    F.ReskinPortraitFrame(_G.GuildRegistrarFrame)
    _G.GuildRegistrarFrameEditBox:DisableDrawLayer('BACKGROUND')
    F.CreateBDFrame(_G.GuildRegistrarFrameEditBox, 0.25)
    F.ReskinButton(_G.GuildRegistrarFrameGoodbyeButton)
    F.ReskinButton(_G.GuildRegistrarFramePurchaseButton)
    F.ReskinButton(_G.GuildRegistrarFrameCancelButton)
end)
