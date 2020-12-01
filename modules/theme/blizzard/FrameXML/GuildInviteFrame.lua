local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.SetBD(GuildInviteFrame)
	for i = 1, 10 do
		select(i, GuildInviteFrame:GetRegions()):Hide()
	end
	F.Reskin(GuildInviteFrameJoinButton)
	F.Reskin(GuildInviteFrameDeclineButton)
end)
