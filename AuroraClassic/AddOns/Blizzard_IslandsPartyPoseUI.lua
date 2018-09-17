local F, C = unpack(select(2, ...))

C.themes["Blizzard_IslandsPartyPoseUI"] = function()
	F.StripTextures(IslandsPartyPoseFrame)
	F.SetBD(IslandsPartyPoseFrame)
	F.Reskin(IslandsPartyPoseFrame.LeaveButton)
	F.StripTextures(IslandsPartyPoseFrame.ModelScene)
	--F.CreateBDFrame(IslandsPartyPoseFrame.ModelScene, .25)

	IslandsPartyPoseFrame.ModelScene:SetAlpha(.8)

	IslandsPartyPoseFrame.Topper:Hide()
	IslandsPartyPoseFrame.Background:Hide()

	IslandsPartyPoseFrame.RightBorder:Hide()
	IslandsPartyPoseFrame.LeftBorder:Hide()
	IslandsPartyPoseFrame.TopRightCorner:Hide()
	IslandsPartyPoseFrame.TopLeftCorner:Hide()
	IslandsPartyPoseFrame.BotRightCorner:Hide()
	IslandsPartyPoseFrame.BotLeftCorner:Hide()
	IslandsPartyPoseFrame.TitleBg:Hide()
	IslandsPartyPoseFrame.TopBorder:Hide()
	IslandsPartyPoseFrame.BottomBorder:Hide()


	local rewardFrame = IslandsPartyPoseFrame.RewardAnimations.RewardFrame
	local bg = F.CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)
	F.CreateSD(bg)
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(rewardFrame.Icon)
end