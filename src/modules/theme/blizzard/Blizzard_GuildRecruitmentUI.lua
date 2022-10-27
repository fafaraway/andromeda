local F, C = unpack(select(2, ...))

C.Themes['Blizzard_GuildRecruitmentUI'] = function()
    local r, g, b = C.r, C.g, C.b

    F.StripTextures(_G.CommunitiesGuildRecruitmentFrame)
    F.SetBD(_G.CommunitiesGuildRecruitmentFrame)
    F.StripTextures(_G.CommunitiesGuildRecruitmentFrameTab1)
    F.StripTextures(_G.CommunitiesGuildRecruitmentFrameTab2)
    F.ReskinClose(_G.CommunitiesGuildRecruitmentFrameCloseButton)
    F.Reskin(_G.CommunitiesGuildRecruitmentFrameRecruitment.ListGuildButton)
    F.StripTextures(_G.CommunitiesGuildRecruitmentFrame)
    _G.CommunitiesGuildRecruitmentFrameInset:Hide()

    for _, name in next, { 'InterestFrame', 'AvailabilityFrame', 'RolesFrame', 'LevelFrame', 'CommentFrame' } do
        local frame = _G.CommunitiesGuildRecruitmentFrameRecruitment[name]
        frame:GetRegions():Hide()
    end

    for _, name in next, { 'QuestButton', 'DungeonButton', 'RaidButton', 'PvPButton', 'RPButton' } do
        local button = _G.CommunitiesGuildRecruitmentFrameRecruitment.InterestFrame[name]
        F.ReskinCheckbox(button)
    end

    local rolesFrame = _G.CommunitiesGuildRecruitmentFrameRecruitment.RolesFrame
    F.ReskinRole(rolesFrame.TankButton, 'TANK')
    F.ReskinRole(rolesFrame.HealerButton, 'HEALER')
    F.ReskinRole(rolesFrame.DamagerButton, 'DPS')

    F.ReskinCheckbox(_G.CommunitiesGuildRecruitmentFrameRecruitment.AvailabilityFrame.WeekdaysButton)
    F.ReskinCheckbox(_G.CommunitiesGuildRecruitmentFrameRecruitment.AvailabilityFrame.WeekendsButton)
    F.ReskinRadio(_G.CommunitiesGuildRecruitmentFrameRecruitment.LevelFrame.LevelAnyButton)
    F.ReskinRadio(_G.CommunitiesGuildRecruitmentFrameRecruitment.LevelFrame.LevelMaxButton)
    F.StripTextures(_G.CommunitiesGuildRecruitmentFrameRecruitment.CommentFrame.CommentInputFrame)
    F.CreateBDFrame(_G.CommunitiesGuildRecruitmentFrameRecruitment.CommentFrame.CommentInputFrame, 0.25)
    F.ReskinScroll(_G.CommunitiesGuildRecruitmentFrameRecruitmentScrollFrameScrollBar)

    F.ReskinScroll(_G.CommunitiesGuildRecruitmentFrameApplicantsContainer.scrollBar)
    F.Reskin(_G.CommunitiesGuildRecruitmentFrameApplicants.InviteButton)
    F.Reskin(_G.CommunitiesGuildRecruitmentFrameApplicants.MessageButton)
    F.Reskin(_G.CommunitiesGuildRecruitmentFrameApplicants.DeclineButton)

    hooksecurefunc('CommunitiesGuildRecruitmentFrameApplicants_Update', function(self)
        local buttons = self.Container.buttons
        for i = 1, #buttons do
            local button = buttons[i]
            if not button.bg then
                for i = 1, 9 do
                    select(i, button:GetRegions()):Hide()
                end
                button.selectedTex:SetTexture('')
                button:SetHighlightTexture(C.Assets.Textures.Blank)
                button.bg = F.CreateBDFrame(button, 0.25)
                button.bg:SetPoint('TOPLEFT', 3, -3)
                button.bg:SetPoint('BOTTOMRIGHT', -3, 3)
            end

            if button.selectedTex:IsShown() then
                button.bg:SetBackdropColor(r, g, b, 0.25)
            else
                button.bg:SetBackdropColor(0, 0, 0, 0.25)
            end
        end
    end)
end
