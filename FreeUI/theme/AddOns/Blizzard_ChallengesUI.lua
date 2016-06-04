local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	ChallengesFrameInset:DisableDrawLayer("BORDER")
	ChallengesFrameInsetBg:Hide()
end
