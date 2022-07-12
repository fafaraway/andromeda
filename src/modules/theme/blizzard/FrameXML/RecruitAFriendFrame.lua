local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local RecruitAFriendFrame = _G.RecruitAFriendFrame

    RecruitAFriendFrame.SplashFrame.Description:SetTextColor(1, 1, 1)
    F.Reskin(RecruitAFriendFrame.SplashFrame.OKButton)
    F.StripTextures(RecruitAFriendFrame.RewardClaiming)
    F.Reskin(RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton)
    F.Reskin(RecruitAFriendFrame.RecruitmentButton)

    local recruitList = RecruitAFriendFrame.RecruitList
    F.StripTextures(recruitList.Header)
    F.CreateBDFrame(recruitList.Header, 0.25)
    recruitList.ScrollFrameInset:Hide()
    F.ReskinScroll(recruitList.ScrollFrame.scrollBar)

    local recruitmentFrame = _G.RecruitAFriendRecruitmentFrame
    F.StripTextures(recruitmentFrame)
    F.ReskinClose(recruitmentFrame.CloseButton)
    F.SetBD(recruitmentFrame)
    F.StripTextures(recruitmentFrame.EditBox)
    local bg = F.CreateBDFrame(recruitmentFrame.EditBox, 0.25)
    bg:SetPoint('TOPLEFT', -3, -3)
    bg:SetPoint('BOTTOMRIGHT', 0, 3)
    F.Reskin(recruitmentFrame.GenerateOrCopyLinkButton)

    local rewardsFrame = _G.RecruitAFriendRewardsFrame
    F.StripTextures(rewardsFrame)
    F.ReskinClose(rewardsFrame.CloseButton)
    F.SetBD(rewardsFrame)

    rewardsFrame:HookScript('OnShow', function(self)
        for i = 1, self:GetNumChildren() do
            local child = select(i, self:GetChildren())
            local button = child and child.Button
            if button and not button.styled then
                F.ReskinIcon(button.Icon)
                button.IconBorder:Hide()
                button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)

                button.styled = true
            end
        end
    end)
end)
