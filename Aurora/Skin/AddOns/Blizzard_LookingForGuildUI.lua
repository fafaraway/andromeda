local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_LookingForGuildUI()
    local r, g, b = C.r, C.g, C.b

    F.SetBD(_G.LookingForGuildFrame)
    F.CreateBD(_G.LookingForGuildInterestFrame, .25)
    _G.LookingForGuildInterestFrameBg:Hide()
    F.CreateBD(_G.LookingForGuildAvailabilityFrame, .25)
    _G.LookingForGuildAvailabilityFrameBg:Hide()
    F.CreateBD(_G.LookingForGuildRolesFrame, .25)
    _G.LookingForGuildRolesFrameBg:Hide()
    F.CreateBD(_G.LookingForGuildCommentFrame, .25)
    _G.LookingForGuildCommentFrameBg:Hide()
    F.CreateBD(_G.LookingForGuildCommentInputFrame, .12)
    _G.LookingForGuildFrame:DisableDrawLayer("BACKGROUND")
    _G.LookingForGuildFrame:DisableDrawLayer("BORDER")
    _G.LookingForGuildFrameInset:DisableDrawLayer("BACKGROUND")
    _G.LookingForGuildFrameInset:DisableDrawLayer("BORDER")
    F.CreateBD(_G.GuildFinderRequestMembershipFrame)
    for i = 1, 9 do
        select(i, _G.LookingForGuildCommentInputFrame:GetRegions()):Hide()
    end
    F.ReskinTab("LookingForGuildFrameTab", 3)
    for i = 1, 6 do
        select(i, _G.GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
    end
    _G.LookingForGuildFrameTabardBackground:Hide()
    _G.LookingForGuildFrameTabardEmblem:Hide()
    _G.LookingForGuildFrameTabardBorder:Hide()
    _G.LookingForGuildFramePortraitFrame:Hide()
    _G.LookingForGuildFrameTopBorder:Hide()
    _G.LookingForGuildFrameTopRightCorner:Hide()

    F.Reskin(_G.LookingForGuildBrowseButton)
    F.Reskin(_G.GuildFinderRequestMembershipFrameAcceptButton)
    F.Reskin(_G.GuildFinderRequestMembershipFrameCancelButton)
    F.ReskinClose(_G.LookingForGuildFrameCloseButton)
    F.ReskinCheck(_G.LookingForGuildQuestButton)
    F.ReskinCheck(_G.LookingForGuildDungeonButton)
    F.ReskinCheck(_G.LookingForGuildRaidButton)
    F.ReskinCheck(_G.LookingForGuildPvPButton)
    F.ReskinCheck(_G.LookingForGuildRPButton)
    F.ReskinCheck(_G.LookingForGuildWeekdaysButton)
    F.ReskinCheck(_G.LookingForGuildWeekendsButton)
    F.ReskinInput(_G.GuildFinderRequestMembershipFrameInputFrame)

    -- [[ Browse frame ]]

    F.Reskin(_G.LookingForGuildRequestButton)
    F.ReskinScroll(_G.LookingForGuildBrowseFrameContainerScrollBar)

    for i = 1, 5 do
        local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]

        bu:SetBackdrop(nil)
        bu:SetHighlightTexture("")

        -- my client crashes if I put this in a var? :x
        bu:GetRegions():SetTexture(C.media.backdrop)
        bu:GetRegions():SetVertexColor(r, g, b, .2)
        bu:GetRegions():SetPoint("TOPLEFT", 1, -1)
        bu:GetRegions():SetPoint("BOTTOMRIGHT", -1, 2)

        local bg = F.CreateBDFrame(bu, .25)
        bg:SetPoint("TOPLEFT")
        bg:SetPoint("BOTTOMRIGHT", 0, 1)
    end

    -- [[ Role buttons ]]

    for _, roleButton in pairs({_G.LookingForGuildTankButton, _G.LookingForGuildHealerButton, _G.LookingForGuildDamagerButton}) do
        roleButton.cover:SetTexture(C.media.roleIcons)
        roleButton:SetNormalTexture(C.media.roleIcons)

        roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

        local left = roleButton:CreateTexture()
        left:SetDrawLayer("OVERLAY", 1)
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", 5, -4)
        left:SetPoint("BOTTOMLEFT", 5, 6)

        local right = roleButton:CreateTexture()
        right:SetDrawLayer("OVERLAY", 1)
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", -5, -4)
        right:SetPoint("BOTTOMRIGHT", -5, 6)

        local top = roleButton:CreateTexture()
        top:SetDrawLayer("OVERLAY", 1)
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", 5, -4)
        top:SetPoint("TOPRIGHT", -5, -4)

        local bottom = roleButton:CreateTexture()
        bottom:SetDrawLayer("OVERLAY", 1)
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", 5, 6)
        bottom:SetPoint("BOTTOMRIGHT", -5, 6)

        F.ReskinCheck(roleButton.checkButton)
    end
end
