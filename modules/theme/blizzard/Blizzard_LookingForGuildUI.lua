local F, C = unpack(select(2, ...))

C.Themes['Blizzard_LookingForGuildUI'] = function()
    local r, g, b = C.r, C.g, C.b

    local styled
    hooksecurefunc(
        'LookingForGuildFrame_CreateUIElements',
        function()
            if styled then
                return
            end

            F.ReskinPortraitFrame(_G.LookingForGuildFrame)
            F.CreateBDFrame(_G.LookingForGuildInterestFrame, .25)
            _G.LookingForGuildInterestFrameBg:Hide()
            F.CreateBDFrame(_G.LookingForGuildAvailabilityFrame, .25)
            _G.LookingForGuildAvailabilityFrameBg:Hide()
            F.CreateBDFrame(_G.LookingForGuildRolesFrame, .25)
            _G.LookingForGuildRolesFrameBg:Hide()
            F.CreateBDFrame(_G.LookingForGuildCommentFrame, .25)
            _G.LookingForGuildCommentFrameBg:Hide()
            F.StripTextures(_G.LookingForGuildCommentInputFrame)
            F.CreateBDFrame(_G.LookingForGuildCommentInputFrame, .12)
            F.SetBD(_G.GuildFinderRequestMembershipFrame)

            for i = 1, 3 do
                F.StripTextures(_G['LookingForGuildFrameTab' .. i])
            end

            _G.LookingForGuildFrameTabardBackground:Hide()
            _G.LookingForGuildFrameTabardEmblem:Hide()
            _G.LookingForGuildFrameTabardBorder:Hide()

            F.Reskin(_G.LookingForGuildBrowseButton)
            F.Reskin(_G.GuildFinderRequestMembershipFrameAcceptButton)
            F.Reskin(_G.GuildFinderRequestMembershipFrameCancelButton)
            F.ReskinCheck(_G.LookingForGuildQuestButton)
            F.ReskinCheck(_G.LookingForGuildDungeonButton)
            F.ReskinCheck(_G.LookingForGuildRaidButton)
            F.ReskinCheck(_G.LookingForGuildPvPButton)
            F.ReskinCheck(_G.LookingForGuildRPButton)
            F.ReskinCheck(_G.LookingForGuildWeekdaysButton)
            F.ReskinCheck(_G.LookingForGuildWeekendsButton)
            F.StripTextures(_G.GuildFinderRequestMembershipFrameInputFrame)
            F.ReskinInput(_G.GuildFinderRequestMembershipFrameInputFrame)

            -- [[ Browse frame ]]

            F.Reskin(_G.LookingForGuildRequestButton)
            F.ReskinScroll(_G.LookingForGuildBrowseFrameContainerScrollBar)

            for i = 1, 5 do
                local bu = _G['LookingForGuildBrowseFrameContainerButton' .. i]

                F.HideBackdrop(bu) -- IsNewPatch
                bu:SetHighlightTexture('')

                -- my client crashes if I put this in a var? :x
                bu:GetRegions():SetTexture(C.Assets.bd_tex)
                bu:GetRegions():SetVertexColor(r, g, b, .2)
                bu:GetRegions():SetInside()

                local bg = F.CreateBDFrame(bu, .25)
                bg:SetPoint('TOPLEFT')
                bg:SetPoint('BOTTOMRIGHT', 0, 1)
            end

            -- [[ Role buttons ]]
            F.ReskinRole(_G.LookingForGuildTankButton, 'TANK')
            F.ReskinRole(_G.LookingForGuildHealerButton, 'HEALER')
            F.ReskinRole(_G.LookingForGuildDamagerButton, 'DPS')

            styled = true
        end
    )
end
