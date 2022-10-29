local F, C = unpack(select(2, ...))

local atlasToTex = {
    ['friendslist-invitebutton-horde-normal'] = 'Interface\\FriendsFrame\\PlusManz-Horde',
    ['friendslist-invitebutton-alliance-normal'] = 'Interface\\FriendsFrame\\PlusManz-Alliance',
    ['friendslist-invitebutton-default-normal'] = 'Interface\\FriendsFrame\\PlusManz-PlusManz',
}
local function replaceInviteTex(self, atlas)
    local tex = atlasToTex[atlas]
    if tex then
        self.ownerIcon:SetTexture(tex)
    end
end

local function reskinFriendButton(button)
    if not button.styled then
        local gameIcon = button.gameIcon
        gameIcon:SetSize(22, 22)
        gameIcon:SetTexCoord(0.17, 0.83, 0.17, 0.83)
        button.background:Hide()
        button:SetHighlightTexture(C.Assets.Textures.Backdrop)
        button:GetHighlightTexture():SetVertexColor(0.24, 0.56, 1, 0.2)
        button.bg = F.CreateBDFrame(gameIcon, 0)

        local travelPass = button.travelPassButton
        travelPass:SetSize(22, 22)
        travelPass:SetPoint('TOPRIGHT', -3, -6)
        F.CreateBDFrame(travelPass, 1)
        travelPass.NormalTexture:SetAlpha(0)
        travelPass.PushedTexture:SetAlpha(0)
        travelPass.DisabledTexture:SetAlpha(0)
        travelPass.HighlightTexture:SetColorTexture(1, 1, 1, 0.25)
        travelPass.HighlightTexture:SetAllPoints()
        gameIcon:SetPoint('TOPRIGHT', travelPass, 'TOPLEFT', -4, 0)

        local icon = travelPass:CreateTexture(nil, 'ARTWORK')
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetAllPoints()
        button.newIcon = icon
        travelPass.NormalTexture.ownerIcon = icon
        hooksecurefunc(travelPass.NormalTexture, 'SetAtlas', replaceInviteTex)

        button.styled = true
    end

    button.bg:SetShown(button.gameIcon:IsShown())
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    for i = 1, 4 do
        local tab = _G['FriendsFrameTab' .. i]
        if tab then
            F.ReskinTab(tab)
            F.ResetTabAnchor(tab)

            if C.IS_NEW_PATCH and i ~= 1 then
                tab:ClearAllPoints()
                tab:SetPoint('TOPLEFT', _G['FriendsFrameTab' .. (i - 1)], 'TOPRIGHT', -15, 0)
            end
        end
    end
    _G.FriendsFrameIcon:Hide()
    F.StripTextures(_G.IgnoreListFrame)

    if C.IS_NEW_PATCH then
        local INVITE_RESTRICTION_NONE = 9
        hooksecurefunc('FriendsFrame_UpdateFriendButton', function(button)
            if button.gameIcon then
                reskinFriendButton(button)
            end

            if button.newIcon and button.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET then
                if FriendsFrame_GetInviteRestriction(button.id) == INVITE_RESTRICTION_NONE then
                    button.newIcon:SetVertexColor(1, 1, 1)
                else
                    button.newIcon:SetVertexColor(0.5, 0.5, 0.5)
                end
            end
        end)

        hooksecurefunc('FriendsFrame_UpdateFriendInviteButton', function(button)
            if not button.styled then
                F.Reskin(button.AcceptButton)
                F.Reskin(button.DeclineButton)

                button.styled = true
            end
        end)

        hooksecurefunc('FriendsFrame_UpdateFriendInviteHeaderButton', function(button)
            if not button.styled then
                button:DisableDrawLayer('BACKGROUND')
                local bg = F.CreateBDFrame(button, 0.25)
                bg:SetInside(button, 2, 2)
                local hl = button:GetHighlightTexture()
                hl:SetColorTexture(0.24, 0.56, 1, 0.2)
                hl:SetInside(bg)

                button.styled = true
            end
        end)
    else
        local pendingHeader = _G.FriendsListFrameScrollFrame.PendingInvitesHeaderButton
        pendingHeader:DisableDrawLayer('BACKGROUND')
        local bg = F.CreateBDFrame(pendingHeader, 0.25)
        bg:SetInside(pendingHeader, 2, 2)
        local hl = pendingHeader:GetHighlightTexture()
        hl:SetColorTexture(0.24, 0.56, 1, 0.2)
        hl:SetInside(bg)

        local INVITE_RESTRICTION_NONE = 9
        hooksecurefunc('FriendsFrame_UpdateFriendButton', function(button)
            if button.gameIcon then
                reskinFriendButton(button)
            end

            if button.buttonType == _G.FRIENDS_BUTTON_TYPE_INVITE then
                for button in _G.FriendsListFrameScrollFrame.invitePool:EnumerateActive() do
                    if not button.styled then
                        F.Reskin(button.AcceptButton)
                        F.Reskin(button.DeclineButton)

                        button.styled = true
                    end
                end
            elseif button.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET then
                if FriendsFrame_GetInviteRestriction(button.id) == INVITE_RESTRICTION_NONE then
                    button.newIcon:SetVertexColor(1, 1, 1)
                else
                    button.newIcon:SetVertexColor(0.5, 0.5, 0.5)
                end
            end
        end)
    end

    _G.FriendsFrameStatusDropDown:ClearAllPoints()
    _G.FriendsFrameStatusDropDown:SetPoint('TOPLEFT', _G.FriendsFrame, 'TOPLEFT', 10, -28)

    for _, button in pairs({ _G.FriendsTabHeaderSoRButton, _G.FriendsTabHeaderRecruitAFriendButton }) do
        button:SetPushedTexture(0)
        button:GetRegions():SetTexCoord(unpack(C.TEX_COORD))
        F.CreateBDFrame(button, 0.25)
    end

    -- FriendsFrameBattlenetFrame

    _G.FriendsFrameBattlenetFrame:GetRegions():Hide()
    local bg = F.CreateBDFrame(_G.FriendsFrameBattlenetFrame, 0.25)
    bg:SetPoint('TOPLEFT', 0, -2)
    bg:SetPoint('BOTTOMRIGHT', -2, 2)
    bg:SetBackdropColor(0, 0.6, 1, 0.25)

    local broadcastButton = _G.FriendsFrameBattlenetFrame.BroadcastButton
    broadcastButton:SetSize(20, 20)
    broadcastButton:GetNormalTexture():SetAlpha(0)
    broadcastButton:GetPushedTexture():SetAlpha(0)
    F.Reskin(broadcastButton)
    local newIcon = broadcastButton:CreateTexture(nil, 'ARTWORK')
    newIcon:SetAllPoints()
    newIcon:SetTexture('Interface\\FriendsFrame\\BroadcastIcon')

    local broadcastFrame = _G.FriendsFrameBattlenetFrame.BroadcastFrame
    F.StripTextures(broadcastFrame)
    F.SetBD(broadcastFrame, nil, 10, -10, -10, 10)
    broadcastFrame.EditBox:DisableDrawLayer('BACKGROUND')

    local ebbg = F.CreateBDFrame(broadcastFrame.EditBox, 0, true)
    ebbg:SetPoint('TOPLEFT', -2, -2)
    ebbg:SetPoint('BOTTOMRIGHT', 2, 2)

    F.Reskin(broadcastFrame.UpdateButton)
    F.Reskin(broadcastFrame.CancelButton)
    broadcastFrame:ClearAllPoints()
    broadcastFrame:SetPoint('TOPLEFT', _G.FriendsFrame, 'TOPRIGHT', 3, 0)

    local unavailableFrame = _G.FriendsFrameBattlenetFrame.UnavailableInfoFrame
    F.StripTextures(unavailableFrame)
    F.SetBD(unavailableFrame)
    unavailableFrame:SetPoint('TOPLEFT', _G.FriendsFrame, 'TOPRIGHT', 3, -18)

    F.ReskinPortraitFrame(_G.FriendsFrame)
    F.Reskin(_G.FriendsFrameAddFriendButton)
    F.Reskin(_G.FriendsFrameSendMessageButton)
    F.Reskin(_G.FriendsFrameIgnorePlayerButton)
    F.Reskin(_G.FriendsFrameUnsquelchButton)
    if C.IS_NEW_PATCH then
        F.ReskinTrimScroll(_G.FriendsListFrame.ScrollBar)
        F.ReskinTrimScroll(_G.IgnoreListFrame.ScrollBar)
        F.ReskinTrimScroll(_G.WhoFrame.ScrollBar)
        F.ReskinTrimScroll(_G.FriendsFriendsFrame.ScrollBar)
    else
        F.ReskinScroll(_G.FriendsListFrameScrollFrame.scrollBar)
        F.ReskinScroll(_G.IgnoreListFrameScrollFrame.scrollBar)
        F.ReskinScroll(_G.WhoListScrollFrame.scrollBar)
        F.ReskinScroll(_G.FriendsFriendsScrollFrame.scrollBar)
    end
    F.ReskinDropDown(_G.FriendsFrameStatusDropDown)
    F.ReskinDropDown(_G.WhoFrameDropDown)
    F.ReskinDropDown(_G.FriendsFriendsFrameDropDown)
    F.Reskin(_G.FriendsListFrameContinueButton)
    F.ReskinInput(_G.AddFriendNameEditBox)
    F.StripTextures(_G.AddFriendFrame)
    F.SetBD(_G.AddFriendFrame)
    F.StripTextures(_G.FriendsFriendsFrame)
    F.SetBD(_G.FriendsFriendsFrame)
    F.Reskin(_G.FriendsFriendsFrame.SendRequestButton)
    F.Reskin(_G.FriendsFriendsFrame.CloseButton)
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
    _G.FriendsFrameTitleText:SetPoint('TOP', _G.FriendsFrame, 'TOP', 0, -8)
end)
