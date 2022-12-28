local F, C = unpack(select(2, ...))

C.Themes['Blizzard_MajorFactions'] = function()
    local frame = _G.MajorFactionRenownFrame

    F.StripTextures(frame)
    F.SetBD(frame)
    F.ReskinClose(frame.CloseButton)

    frame.NineSlice:SetAlpha(0)
    frame.Background:SetAlpha(0)
    F.Reskin(frame.LevelSkipButton)
end
