local F, C = unpack(select(2, ...))

local function reskinPartyPose(frame)
    F.StripTextures(frame)
    if frame.Border then
        frame.Border:SetAlpha(0)
    end
    if frame.OverlayElements then
        frame.OverlayElements.Topper:SetAlpha(0)
    end
    F.SetBD(frame)
    F.Reskin(frame.LeaveButton)
    F.StripTextures(frame.ModelScene)
    F.CreateBDFrame(frame.ModelScene, .25)

    local rewardFrame = frame.RewardAnimations.RewardFrame
    local bg = F.SetBD(rewardFrame)
    bg:SetPoint('TOPLEFT', -5, 5)
    bg:SetPoint('BOTTOMRIGHT', rewardFrame.NameFrame, 0, -5)
    rewardFrame.NameFrame:SetAlpha(0)
    rewardFrame.IconBorder:SetAlpha(0)
    F.ReskinIcon(rewardFrame.Icon)
end

C.Themes['Blizzard_IslandsPartyPoseUI'] = function()
    reskinPartyPose(_G.IslandsPartyPoseFrame)
end

C.Themes['Blizzard_WarfrontsPartyPoseUI'] = function()
    reskinPartyPose(_G.WarfrontsPartyPoseFrame)
end
