local _, private = ...

-- [[ Lua Globals ]]
local next, select = _G.next, _G.select

-- [[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.FriendsFrame()
    if not private.disabled.tooltips then
        Base.SetBackdrop(_G.FriendsTooltip)
    end

    F.ReskinPortraitFrame(_G.FriendsFrame, true)
    F.CreateBD(_G.FriendsFrame)
    F.CreateSD(_G.FriendsFrame)
    _G.FriendsFrameIcon:Hide()

    --F.ReskinDropDown(_G.FriendsDropDown)
    --F.ReskinDropDown(_G.TravelPassDropDown)

    for i = 1, 4 do
        local name = "FriendsFrameTab"..i
        local tab = _G[name]
        F.ReskinTab(tab)
        _G[name.."Text"]:SetPoint("CENTER", tab)
    end

    -- Friends header
    local bnetFrame = _G.FriendsFrameBattlenetFrame
    bnetFrame:GetRegions():Hide()
    F.CreateBD(bnetFrame, 0)
    local bnetColor = _G.FRIENDS_BNET_BACKGROUND_COLOR
    bnetFrame:SetBackdropColor(bnetColor.r, bnetColor.g, bnetColor.b, bnetColor.a)

    bnetFrame.Tag:SetParent(_G.FriendsListFrame)
    bnetFrame.Tag:SetPoint("TOP", _G.FriendsFrame, "TOP", 0, -4)
    _G.hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
        if _G.BNFeaturesEnabled() then
            bnetFrame.BroadcastButton:Hide()

            if _G.BNConnected() then
                bnetFrame:Hide()
                _G.FriendsFrameBroadcastInput:Show()
                _G.FriendsFrameBroadcastInput_UpdateDisplay()
            end
        end
    end)
    _G.hooksecurefunc("FriendsFrame_Update", function()
        if _G.FriendsFrame.selectedTab == 1 and _G.FriendsTabHeader.selectedTab == 1 and
                _G.FriendsFrameBattlenetFrame.Tag:IsShown() then
            _G.FriendsFrameTitleText:Hide()
        else
            _G.FriendsFrameTitleText:Show()
        end
    end)

    F.CreateBD(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame)
    _G.FriendsFrameBattlenetFrame.UnavailableInfoFrame:SetPoint("TOPLEFT", _G.FriendsFrame, "TOPRIGHT", 1, -18)

    _G.FriendsFrameStatusDropDown:SetPoint("TOPLEFT", -12, -27)
    F.ReskinDropDown(_G.FriendsFrameStatusDropDown)
    _G.FriendsFrameBroadcastInput:SetWidth(250)
    F.ReskinInput(_G.FriendsFrameBroadcastInput)
    F.ReskinTab("FriendsTabHeaderTab", 3)

    for _, key in next, {"RaFButton", "soRButton"} do
        local button = _G.FriendsTabHeader[key]
        button:SetPushedTexture("")
        button:GetRegions():SetTexCoord(.08, .92, .08, .92)
        F.CreateBDFrame(button)
    end

    -- Friends list
    _G.FriendsFrameFriendsScrollFrameTop:Hide()
    _G.FriendsFrameFriendsScrollFrameMiddle:Hide()
    _G.FriendsFrameFriendsScrollFrameBottom:Hide()
    F.Reskin(_G.FriendsFrameAddFriendButton)
    F.Reskin(_G.FriendsFrameSendMessageButton)
    local inviteHeader = _G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton
    F.ReskinStretchButton(inviteHeader)
    inviteHeader.RightArrow:SetTexture(C.media.arrowRight)
    inviteHeader.DownArrow:SetTexture(C.media.arrowDown)
    inviteHeader.DownArrow:SetSize(10, 8)
    F.ReskinScroll(_G.FriendsFrameFriendsScrollFrameScrollBar)

    for i = 1, _G.FRIENDS_TO_DISPLAY do
        local btn = _G["FriendsFrameFriendsScrollFrameButton"..i]

        --local frame = CreateFrame("frame", nil, btn)
        --frame:SetSize(60, 32)

        btn.background:Hide()
        F.Reskin(btn.travelPassButton)
        btn.travelPassButton:SetAlpha(1)
        btn.travelPassButton:EnableMouse(true)
        btn.travelPassButton:SetSize(20, 32)

        btn.bg = _G.CreateFrame("Frame", nil, btn)
        btn.bg:SetSize(24, 24)
        btn.bg:ClearAllPoints()
        btn.bg:SetPoint("TOPLEFT", btn.gameIcon, -1, 1)
        F.CreateBD(btn.bg, 0)

        btn.gameIcon:SetSize(22, 22)
        btn.gameIcon:SetTexCoord(.15, .85, .15, .85)
        btn.gameIcon:SetParent(btn.bg)
        btn.gameIcon:SetPoint("TOPRIGHT", btn.travelPassButton, "TOPLEFT", -2, -5)
        btn.gameIcon.SetPoint = function() end

        btn.inv = btn.travelPassButton:CreateTexture(nil, "OVERLAY", nil, 7)
        btn.inv:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
        btn.inv:SetPoint("TOPRIGHT", 1, -4)
        btn.inv:SetSize(22, 22)
    end

    _G.hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button)
        if button.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET then
            local isEnabled = button.travelPassButton:IsEnabled()

            if button.inv then
                button.inv:SetAlpha(isEnabled and 0.7 or 0.25)
                button.bg:SetShown(button.gameIcon:IsShown())
            end
        elseif button.buttonType == _G.FRIENDS_BUTTON_TYPE_INVITE then
            for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
                if not invite._skinned then
                    local lineOfs = 4
                    for i = 1, 2 do
                        local line = invite.DeclineButton:CreateLine()
                        line:SetColorTexture(1, 0, 0)
                        line:SetThickness(0.5)
                        if i == 1 then
                            line:SetStartPoint("TOPLEFT", lineOfs, -lineOfs)
                            line:SetEndPoint("BOTTOMRIGHT", -lineOfs, lineOfs)
                        else
                            line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
                            line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
                        end
                    end
                    invite.DeclineButton:SetSize(22, 22)
                    invite.DeclineButton.Icon:Hide()
                    F.ReskinStretchButton(invite.DeclineButton)
                    F.ReskinStretchButton(invite.AcceptButton)
                    invite._skinned = true
                end
            end
        end
    end)
    _G.hooksecurefunc(_G.FriendsFrameFriendsScrollFrame.invitePool, "Acquire", function(self, button)
        for invite in self:EnumerateActive() do
            if not invite._skinned then
                local lineOfs = 4
                for i = 1, 2 do
                    local line = invite.DeclineButton:CreateLine()
                    line:SetColorTexture(1, 0, 0)
                    line:SetThickness(0.5)
                    if i == 1 then
                        line:SetStartPoint("TOPLEFT", lineOfs, -lineOfs)
                        line:SetEndPoint("BOTTOMRIGHT", -lineOfs, lineOfs)
                    else
                        line:SetStartPoint("TOPRIGHT", -lineOfs, -lineOfs)
                        line:SetEndPoint("BOTTOMLEFT", lineOfs, lineOfs)
                    end
                end
                invite.DeclineButton:SetSize(22, 22)
                invite.DeclineButton.Icon:Hide()
                F.ReskinStretchButton(invite.DeclineButton)
                F.ReskinStretchButton(invite.AcceptButton)
                invite._skinned = true
            end
        end
    end)

    -- Ignore
    _G.IgnoreListFrameTop:Hide()
    _G.IgnoreListFrameMiddle:Hide()
    _G.IgnoreListFrameBottom:Hide()
    F.Reskin(_G.FriendsFrameIgnorePlayerButton)
    F.Reskin(_G.FriendsFrameUnsquelchButton)
    F.ReskinScroll(_G.FriendsFrameIgnoreScrollFrameScrollBar)

    -- Who
    local whoListInset = _G.WhoFrameListInset
    for i = 1, whoListInset:GetNumRegions() do
        local region = _G.select(i, whoListInset:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:Hide()
        end
    end

    for i = 1, 4 do
        _G["WhoFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
    end
    F.ReskinDropDown(_G.WhoFrameDropDown)

    F.Reskin(_G.WhoFrameWhoButton)
    F.Reskin(_G.WhoFrameAddFriendButton)
    F.Reskin(_G.WhoFrameGroupInviteButton)
    _G.WhoFrameWhoButton:SetPoint("RIGHT", _G.WhoFrameAddFriendButton, "LEFT", -1, 0)
    _G.WhoFrameAddFriendButton:SetPoint("RIGHT", _G.WhoFrameGroupInviteButton, "LEFT", -1, 0)

    local whoEditInset = _G.WhoFrameEditBoxInset
    for i = 1, whoEditInset:GetNumRegions() do
        local region = _G.select(i, whoEditInset:GetRegions())
        if region:GetObjectType() == "Texture" then
            region:Hide()
        end
    end
    F.CreateBD(_G.WhoFrameEditBoxInset, .25)

    F.ReskinScroll(_G.WhoListScrollFrameScrollBar)
    local top, bottom = _G.WhoListScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()

    -- Add Friend
    F.CreateBD(_G.AddFriendFrame)
    F.CreateSD(_G.AddFriendFrame)
    F.Reskin(_G.AddFriendInfoFrameContinueButton)

    F.ReskinInput(_G.AddFriendNameEditBox)
    F.CreateBD(_G.AddFriendNoteFrame, .25)
    F.Reskin(_G.AddFriendEntryFrameAcceptButton)
    F.Reskin(_G.AddFriendEntryFrameCancelButton)
    for i = 1, 9 do
        select(i, _G.AddFriendNoteFrame:GetRegions()):Hide()
    end

    -- Friends of friends
    F.CreateBD(_G.FriendsFriendsFrame)
    F.CreateBD(_G.FriendsFriendsList, .25)
    F.ReskinDropDown(_G.FriendsFriendsFrameDropDown)
    F.ReskinScroll(_G.FriendsFriendsScrollFrameScrollBar)
    F.Reskin(_G.FriendsFriendsSendRequestButton)
    F.Reskin(_G.FriendsFriendsCloseButton)

    -- BattleTag Invite
    F.CreateBD(_G.BattleTagInviteFrame)
    local send, cancel = _G.BattleTagInviteFrame:GetChildren()
    F.Reskin(send)
    F.Reskin(cancel)
end
