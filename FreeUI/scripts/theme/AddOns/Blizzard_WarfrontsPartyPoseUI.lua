local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarfrontsPartyPoseUI"] = function()
	F.StripTextures(WarfrontsPartyPoseFrame)
	F.SetBD(WarfrontsPartyPoseFrame)
	F.Reskin(WarfrontsPartyPoseFrame.LeaveButton)
	F.StripTextures(WarfrontsPartyPoseFrame.ModelScene)
	WarfrontsPartyPoseFrame.ModelScene:SetAlpha(.8)
	WarfrontsPartyPoseFrame.OverlayElements.Topper:Hide()
	WarfrontsPartyPoseFrame.Background:Hide()
	WarfrontsPartyPoseFrame.Border:Hide()
	
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