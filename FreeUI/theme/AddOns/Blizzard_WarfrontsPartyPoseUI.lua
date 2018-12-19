local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarfrontsPartyPoseUI"] = function()
	F.StripTextures(WarfrontsPartyPoseFrame.Border)
	F.SetBD(WarfrontsPartyPoseFrame)
	F.Reskin(WarfrontsPartyPoseFrame.LeaveButton)
	F.StripTextures(WarfrontsPartyPoseFrame.ModelScene)
	F.CreateBDFrame(WarfrontsPartyPoseFrame.ModelScene, .25)
	WarfrontsPartyPoseFrame.OverlayElements.Topper:Hide()
	local rewardFrame = WarfrontsPartyPoseFrame.RewardAnimations.RewardFrame
	local bg = F.CreateBDFrame(rewardFrame)
	bg:SetPoint("TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", rewardFrame.NameFrame, 0, -5)
	F.CreateSD(bg)
	rewardFrame.NameFrame:SetAlpha(0)
	rewardFrame.IconBorder:SetAlpha(0)
	rewardFrame.Icon:SetTexCoord(unpack(C.TexCoord))
	F.CreateBDFrame(rewardFrame.Icon)
end