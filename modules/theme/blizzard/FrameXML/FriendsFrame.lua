local F, C = unpack(select(2, ...))

local atlasToTex = {
    ['friendslist-invitebutton-horde-normal'] = 'Interface\\FriendsFrame\\PlusManz-Horde',
    ['friendslist-invitebutton-alliance-normal'] = 'Interface\\FriendsFrame\\PlusManz-Alliance',
    ['friendslist-invitebutton-default-normal'] = 'Interface\\FriendsFrame\\PlusManz-PlusManz',
}

local function replaceInviteTex(self, atlas)
    local tex = atlasToTex[atlas]
    if tex then
        self:SetTexture(tex)
    end
end

tinsert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    local loadInit
    FriendsFrame:HookScript('OnShow', function()
        if loadInit then
            return
        end
        for i = 1, 4 do
            local tab = _G['FriendsFrameTab' .. i]
            if tab then
                F.ReskinTab(tab)
                F.ResetTabAnchor(tab)
            end
        end
        loadInit = true
    end)

    _G.FriendsFrameIcon:Hide()
    F.StripTextures(_G.IgnoreListFrame)

    for i = 1, FRIENDS_TO_DISPLAY do
        local bu = _G['FriendsListFrameScrollFrameButton' .. i]
        local ic = bu.gameIcon

        bu.background:Hide()
        bu:SetHighlightTexture(C.Assets.Texture.Backdrop)
        bu:GetHighlightTexture():SetVertexColor(0.24, 0.56, 1, 0.2)
        ic:SetSize(22, 22)
        ic:SetTexCoord(0.17, 0.83, 0.17, 0.83)

        bu.bg = CreateFrame('Frame', nil, bu)
        bu.bg:SetAllPoints(ic)
        F.CreateBDFrame(bu.bg, 0)

        local travelPass = bu.travelPassButton
        travelPass:SetSize(22, 22)
        travelPass:SetPushedTexture(nil)
        travelPass:SetDisabledTexture(nil)
        travelPass:SetPoint('TOPRIGHT', -3, -6)
        F.CreateBDFrame(travelPass, 1)
        local nt = travelPass:GetNormalTexture()
        nt:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        hooksecurefunc(nt, 'SetAtlas', replaceInviteTex)
        local hl = travelPass:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, 0.25)
        hl:SetAllPoints()
    end

    local function UpdateScroll()
        for i = 1, FRIENDS_TO_DISPLAY do
            local bu = _G['FriendsListFrameScrollFrameButton' .. i]
            if bu.gameIcon:IsShown() then
                bu.bg:Show()
                bu.gameIcon:SetPoint('TOPRIGHT', bu.travelPassButton, 'TOPLEFT', -4, 0)
            else
                bu.bg:Hide()
            end
        end
    end
    hooksecurefunc('FriendsFrame_UpdateFriends', UpdateScroll)
    hooksecurefunc(_G.FriendsListFrameScrollFrame, 'update', UpdateScroll)

    local header = _G.FriendsListFrameScrollFrame.PendingInvitesHeaderButton
    for i = 1, 11 do
        select(i, header:GetRegions()):Hide()
    end
    local headerBg = F.CreateBDFrame(header, 0.25)
    headerBg:SetPoint('TOPLEFT', 2, -2)
    headerBg:SetPoint('BOTTOMRIGHT', -2, 2)

    local function reskinInvites(self)
        for invite in self:EnumerateActive() do
            if not invite.styled then
                F.Reskin(invite.AcceptButton)
                F.Reskin(invite.DeclineButton)

                invite.styled = true
            end
        end
    end

    hooksecurefunc(_G.FriendsListFrameScrollFrame.invitePool, 'Acquire', reskinInvites)

    local INVITE_RESTRICTION_NONE = 9
    hooksecurefunc('FriendsFrame_UpdateFriendButton', function(button)
        if button.buttonType == FRIENDS_BUTTON_TYPE_INVITE then
            reskinInvites(_G.FriendsListFrameScrollFrame.invitePool)
        elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
            local nt = button.travelPassButton:GetNormalTexture()
            if FriendsFrame_GetInviteRestriction(button.id) == INVITE_RESTRICTION_NONE then
                nt:SetVertexColor(1, 1, 1)
            else
                nt:SetVertexColor(0.3, 0.3, 0.3)
            end
        end
    end)

    _G.FriendsFrameStatusDropDown:ClearAllPoints()
    _G.FriendsFrameStatusDropDown:SetPoint('TOPLEFT', FriendsFrame, 'TOPLEFT', 10, -28)

    for _, button in pairs({ _G.FriendsTabHeaderSoRButton, _G.FriendsTabHeaderRecruitAFriendButton }) do
        button:SetPushedTexture('')
        button:GetRegions():SetTexCoord(unpack(C.TEX_COORD))
        F.CreateBDFrame(button)
    end

    -- FriendsFrameBattlenetFrame

    _G.FriendsFrameBattlenetFrame:GetRegions():Hide()
    local bg = F.CreateBDFrame(_G.FriendsFrameBattlenetFrame, 0.25)
    bg:SetPoint('TOPLEFT', 0, -2)
    bg:SetPoint('BOTTOMRIGHT', -2, 2)
    bg:SetBackdropColor(0, 0.6, 1, 0.25)

    local broadcastButton = _G.FriendsFrameBattlenetFrame.BroadcastButton
    broadcastButton:SetSize(20, 20)
    F.Reskin(broadcastButton)
    local newIcon = broadcastButton:CreateTexture(nil, 'ARTWORK')
    newIcon:SetAllPoints()
    newIcon:SetTexture('Interface\\FriendsFrame\\BroadcastIcon')

    local broadcastFrame = _G.FriendsFrameBattlenetFrame.BroadcastFrame
    F.StripTextures(broadcastFrame)
    F.SetBD(broadcastFrame, nil, 10, -10, -10, 10)
    broadcastFrame.EditBox:DisableDrawLayer('BACKGROUND')

    local bcfbg = F.CreateBDFrame(broadcastFrame.EditBox, 0, true)
    bcfbg:SetPoint('TOPLEFT', -2, -2)
    bcfbg:SetPoint('BOTTOMRIGHT', 2, 2)

    F.Reskin(broadcastFrame.UpdateButton)
    F.Reskin(broadcastFrame.CancelButton)
    broadcastFrame:ClearAllPoints()
    broadcastFrame:SetPoint('TOPLEFT', FriendsFrame, 'TOPRIGHT', 3, 0)

    local function BroadcastButton_SetTexture(self)
        self.BroadcastButton:SetNormalTexture('')
        self.BroadcastButton:SetPushedTexture('')
    end
    hooksecurefunc(broadcastFrame, 'ShowFrame', BroadcastButton_SetTexture)
    hooksecurefunc(broadcastFrame, 'HideFrame', BroadcastButton_SetTexture)

    local unavailableFrame = _G.FriendsFrameBattlenetFrame.UnavailableInfoFrame
    F.StripTextures(unavailableFrame)
    F.SetBD(unavailableFrame)
    unavailableFrame:SetPoint('TOPLEFT', FriendsFrame, 'TOPRIGHT', 3, -18)

    F.ReskinPortraitFrame(FriendsFrame)
    F.Reskin(_G.FriendsFrameAddFriendButton)
    F.Reskin(_G.FriendsFrameSendMessageButton)
    F.Reskin(_G.FriendsFrameIgnorePlayerButton)
    F.Reskin(_G.FriendsFrameUnsquelchButton)
    F.ReskinScroll(_G.FriendsListFrameScrollFrame.scrollBar)
    F.ReskinScroll(_G.IgnoreListFrameScrollFrame.scrollBar)
    F.ReskinScroll(_G.WhoListScrollFrame.scrollBar)
    F.ReskinDropDown(_G.FriendsFrameStatusDropDown)
    F.ReskinDropDown(_G.WhoFrameDropDown)
    F.ReskinDropDown(_G.FriendsFriendsFrameDropDown)
    F.Reskin(_G.FriendsListFrameContinueButton)
    F.ReskinInput(_G.AddFriendNameEditBox)
    F.StripTextures(AddFriendFrame)
    F.SetBD(AddFriendFrame)
    F.StripTextures(FriendsFriendsFrame)
    F.SetBD(FriendsFriendsFrame)
    F.Reskin(FriendsFriendsFrame.SendRequestButton)
    F.Reskin(FriendsFriendsFrame.CloseButton)
    F.ReskinScroll(_G.FriendsFriendsScrollFrame.scrollBar)
    F.Reskin(_G.WhoFrameWhoButton)
    F.Reskin(_G.WhoFrameAddFriendButton)
    F.Reskin(_G.WhoFrameGroupInviteButton)
    F.Reskin(_G.AddFriendEntryFrameAcceptButton)
    F.Reskin(_G.AddFriendEntryFrameCancelButton)
    F.Reskin(_G.AddFriendInfoFrameContinueButton)

    for i = 1, 4 do
        F.StripTextures(_G['WhoFrameColumnHeader' .. i])
    end

    F.StripTextures(_G.WhoFrameListInset)
    _G.WhoFrameEditBoxInset:Hide()
    local whoBg = F.CreateBDFrame(_G.WhoFrameEditBox, 0, true)
    whoBg:SetPoint('TOPLEFT', _G.WhoFrameEditBoxInset)
    whoBg:SetPoint('BOTTOMRIGHT', _G.WhoFrameEditBoxInset, -1, 1)

    for i = 1, 3 do
        F.StripTextures(_G['FriendsTabHeaderTab' .. i])
    end

    _G.WhoFrameWhoButton:SetPoint('RIGHT', _G.WhoFrameAddFriendButton, 'LEFT', -1, 0)
    _G.WhoFrameAddFriendButton:SetPoint('RIGHT', _G.WhoFrameGroupInviteButton, 'LEFT', -1, 0)
    _G.FriendsFrameTitleText:SetPoint('TOP', FriendsFrame, 'TOP', 0, -8)
end)
