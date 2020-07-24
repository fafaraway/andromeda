local F, C = unpack(select(2, ...))

C.Themes["Blizzard_DeathRecap"] = function()
	local DeathRecapFrame = DeathRecapFrame

	DeathRecapFrame:DisableDrawLayer("BORDER")
	DeathRecapFrame.Background:Hide()
	DeathRecapFrame.BackgroundInnerGlow:Hide()
	DeathRecapFrame.Divider:Hide()

	F.SetBD(DeathRecapFrame)
	F.Reskin(select(8, DeathRecapFrame:GetChildren())) -- bottom close button has no parentKey
	F.ReskinClose(DeathRecapFrame.CloseXButton)

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local recap = DeathRecapFrame["Recap"..i].SpellInfo
		recap.IconBorder:Hide()
		F.ReskinIcon(recap.Icon)
	end
end