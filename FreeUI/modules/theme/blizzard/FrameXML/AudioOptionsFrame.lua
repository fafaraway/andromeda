local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FreeUIConfigs['theme']['reskin_blizz'] then return end

	F.StripTextures(AudioOptionsFrame.Header)
	AudioOptionsFrame.Header:ClearAllPoints()
	AudioOptionsFrame.Header:SetPoint("TOP", AudioOptionsFrame, 0, 0)
	F.SetBD(AudioOptionsFrame)
	F.Reskin(AudioOptionsFrameOkay)
	F.Reskin(AudioOptionsFrameCancel)
	F.Reskin(AudioOptionsFrameDefaults)
end)
