local F, C = unpack(select(2, ...))

C.Themes['Blizzard_Contribution'] = function()
    local frame = _G.ContributionCollectionFrame
    F.SetBD(frame)
    F.ReskinClose(frame.CloseButton)
    frame.CloseButton.CloseButtonBackground:Hide()
    frame.Background:Hide()

    hooksecurefunc(_G.ContributionMixin, 'Update', function(self)
        if not self.styled then
            self.Header.Text:SetTextColor(1, 0.8, 0)
            F.ReskinButton(self.ContributeButton)
            F.ReplaceIconString(self.ContributeButton)
            hooksecurefunc(self.ContributeButton, 'SetText', F.ReplaceIconString)

            F.StripTextures(self.Status)
            F.CreateBDFrame(self.Status, 0.25)

            self.styled = true
        end
    end)

    hooksecurefunc(_G.ContributionRewardMixin, 'Setup', function(self)
        if not self.styled then
            self.RewardName:SetTextColor(1, 1, 1)
            self.Border:Hide()
            self:GetRegions():Hide()
            F.ReskinIcon(self.Icon)

            self.styled = true
        end
    end)
end
