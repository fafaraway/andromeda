local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    F.SetBD(_G.GuildInviteFrame)
    for i = 1, 10 do
        select(i, _G.GuildInviteFrame:GetRegions()):Hide()
    end
    F.Reskin(_G.GuildInviteFrameJoinButton)
    F.Reskin(_G.GuildInviteFrameDeclineButton)
end)
