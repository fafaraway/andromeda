local F, C = unpack(select(2, ...))

C.Themes["Blizzard_LookingForGuildUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local styled
	hooksecurefunc("LookingForGuildFrame_CreateUIElements", function()
		if styled then return end

		F.ReskinPortraitFrame(LookingForGuildFrame)
		F.CreateBDFrame(LookingForGuildInterestFrame, .25)
		LookingForGuildInterestFrameBg:Hide()
		F.CreateBDFrame(LookingForGuildAvailabilityFrame, .25)
		LookingForGuildAvailabilityFrameBg:Hide()
		F.CreateBDFrame(LookingForGuildRolesFrame, .25)
		LookingForGuildRolesFrameBg:Hide()
		F.CreateBDFrame(LookingForGuildCommentFrame, .25)
		LookingForGuildCommentFrameBg:Hide()
		F.StripTextures(LookingForGuildCommentInputFrame)
		F.CreateBDFrame(LookingForGuildCommentInputFrame, .12)
		F.SetBD(GuildFinderRequestMembershipFrame)

		for i = 1, 3 do
			F.StripTextures(_G["LookingForGuildFrameTab"..i])
		end

		LookingForGuildFrameTabardBackground:Hide()
		LookingForGuildFrameTabardEmblem:Hide()
		LookingForGuildFrameTabardBorder:Hide()

		F.Reskin(LookingForGuildBrowseButton)
		F.Reskin(GuildFinderRequestMembershipFrameAcceptButton)
		F.Reskin(GuildFinderRequestMembershipFrameCancelButton)
		F.ReskinCheck(LookingForGuildQuestButton)
		F.ReskinCheck(LookingForGuildDungeonButton)
		F.ReskinCheck(LookingForGuildRaidButton)
		F.ReskinCheck(LookingForGuildPvPButton)
		F.ReskinCheck(LookingForGuildRPButton)
		F.ReskinCheck(LookingForGuildWeekdaysButton)
		F.ReskinCheck(LookingForGuildWeekendsButton)
		F.StripTextures(GuildFinderRequestMembershipFrameInputFrame)
		F.ReskinInput(GuildFinderRequestMembershipFrameInputFrame)

		-- [[ Browse frame ]]

		F.Reskin(LookingForGuildRequestButton)
		F.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)

		for i = 1, 5 do
			local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]

			bu:SetBackdrop(nil)
			bu:SetHighlightTexture("")

			-- my client crashes if I put this in a var? :x
			bu:GetRegions():SetTexture(C.Assets.bd_tex)
			bu:GetRegions():SetVertexColor(r, g, b, .2)
			bu:GetRegions():SetInside()

			local bg = F.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
		end

		-- [[ Role buttons ]]
		F.ReskinRole(LookingForGuildTankButton, "TANK")
		F.ReskinRole(LookingForGuildHealerButton, "HEALER")
		F.ReskinRole(LookingForGuildDamagerButton, "DPS")

		styled = true
	end)
end
