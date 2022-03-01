-- https://bbs.nga.cn/read.php?tid=27432996
-- oyg123

local F = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local function _FriendsFrame_ShouldShowSummonButton(self)
    local parent = self:GetParent()
    local id = parent.id
    if not id then
        return false, false
    end

    -- local enable = false
    -- local bType = parent.buttonType

    if parent.buttonType == _G.FRIENDS_BUTTON_TYPE_WOW then
        local info = C_FriendList.GetFriendInfoByIndex(id)
        if not info or info.mobile or not info.connected or info.rafLinkType == Enum.RafLinkType.None then
            return false, false
        end
        return true, CanSummonFriend(info.guid)
    elseif (parent.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET) then
        -- Get the information by BNet friends list index.
        local accountInfo = C_BattleNet.GetFriendAccountInfo(id)
        local restriction = _G.FriendsFrame_GetInviteRestriction(id)
        if restriction ~= 9 or accountInfo.rafLinkType == Enum.RafLinkType.None then
            return false, false
        else
            return true, accountInfo.gameAccountInfo.canSummon
        end
    else
        return false, false
    end
end

local function _UnitPopup_IsInGroupWithPlayer(dropdownMenu)
    local accountInfo = dropdownMenu.accountInfo
    local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo
    if gameAccountInfo and gameAccountInfo.characterName then
        return UnitInParty(gameAccountInfo.characterName) or UnitInRaid(gameAccountInfo.characterName)
    elseif dropdownMenu.guid then
        return IsGUIDInGroup(dropdownMenu.guid)
    end
end

local function _UnitPopup_IsEnabled(dropdownFrame, unitPopupButton)
    if unitPopupButton.isUninteractable then
        return false
    end
    if unitPopupButton.dist and not CheckInteractDistance(dropdownFrame.unit, unitPopupButton.dist) then
        return false
    end
    if unitPopupButton.disabledInKioskMode and _G.Kiosk.IsEnabled() then
        return false
    end
    return true
end

local function _CanGroupWithAccount(bnetIDAccount)
    if not bnetIDAccount then
        return false
    end
    local index = BNGetFriendIndex(bnetIDAccount)
    if not index then
        return false
    end
    local restriction = _G.FriendsFrame_GetInviteRestriction(index)
    return restriction == 11 or restriction == 9
end

local function _ShowRichPresenceOnly(client, wowProjectID, faction, realmID)
    if (client ~= _G.BNET_CLIENT_WOW) or (wowProjectID ~= _G.WOW_PROJECT_ID) then
        return true
    elseif (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC) and ((faction ~= _G.playerFactionGroup) or (realmID ~= _G.playerRealmID)) then
        return true
    else
        return false
    end
end

local function FriendTipOnEnter(self)
    if self.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET then
        local accountInfo = C_BattleNet.GetFriendAccountInfo(self.id)
        local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo
        if gameAccountInfo and gameAccountInfo.gameAccountID and not gameAccountInfo.isInCurrentRegion and
            not _ShowRichPresenceOnly(gameAccountInfo.clientProgram, gameAccountInfo.wowProjectID, gameAccountInfo.factionName, gameAccountInfo.realmID) then
            local areaName = gameAccountInfo.isWowMobile and _G.LOCATION_MOBILE_APP or gameAccountInfo.areaName or _G.UNKNOWN
            local realmName = gameAccountInfo.realmDisplayName or _G.UNKNOWN
            _G.FriendsFrameTooltip_SetLine(_G.FriendsTooltipGameAccount1Info, nil, _G.BNET_FRIEND_TOOLTIP_ZONE_AND_REALM:format(areaName, realmName), -4)
        end
    end
end

local function travelPassButton_OnEnter(self)
    local parent = self:GetParent()
    local restriction = _G.FriendsFrame_GetInviteRestriction(parent.id)
    if restriction == 11 then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        local guid = _G.FriendsFrame_GetPlayerGUIDFromIndex(parent.id)
        local inviteType = _G.GetDisplayedInviteType(guid)
        if inviteType == 'INVITE' then
            _G.GameTooltip:SetText(_G.TRAVEL_PASS_INVITE, _G.HIGHLIGHT_FONT_COLOR.r, _G.HIGHLIGHT_FONT_COLOR.g, _G.HIGHLIGHT_FONT_COLOR.b)
        elseif inviteType == 'SUGGEST_INVITE' then
            _G.GameTooltip:SetText(_G.SUGGEST_INVITE, _G.HIGHLIGHT_FONT_COLOR.r, _G.HIGHLIGHT_FONT_COLOR.g, _G.HIGHLIGHT_FONT_COLOR.b)
        else -- inviteType == "REQUEST_INVITE"
            _G.GameTooltip:SetText(_G.REQUEST_INVITE, _G.HIGHLIGHT_FONT_COLOR.r, _G.HIGHLIGHT_FONT_COLOR.g, _G.HIGHLIGHT_FONT_COLOR.b)
            -- For REQUEST_INVITE, we'll display other members in the group if there are any.
            local group = C_SocialQueue.GetGroupForPlayer(guid)
            local members = C_SocialQueue.GetGroupMembers(group)
            local numDisplayed = 0
            for i = 1, #members do
                if members[i].guid ~= guid then
                    if numDisplayed == 0 then
                        _G.GameTooltip:AddLine(_G.SOCIAL_QUEUE_ALSO_IN_GROUP)
                    elseif numDisplayed >= 7 then
                        _G.GameTooltip:AddLine(_G.SOCIAL_QUEUE_AND_MORE, _G.GRAY_FONT_COLOR.r, _G.GRAY_FONT_COLOR.g, _G.GRAY_FONT_COLOR.b, 1)
                        break
                    end
                    local name, color = _G.SocialQueueUtil_GetRelationshipInfo(members[i].guid, nil, members[i].clubId)
                    _G.GameTooltip:AddLine(color .. name .. _G.FONT_COLOR_CODE_CLOSE)
                    numDisplayed = numDisplayed + 1
                end
            end
        end
        _G.GameTooltip:Show()
    end
end

function CHAT:CNLanguageFilterFix()
    hooksecurefunc('UnitPopup_OnUpdate', function()
        if not _G.DropDownList1:IsShown() then
            return
        end
        local count, tempCount
        local isOk = false
        local currentDropDown = _G.UIDROPDOWNMENU_OPEN_MENU
        local isInGroupWithPlayer = _UnitPopup_IsInGroupWithPlayer(currentDropDown)
        for level, dropdownFrame in pairs(_G.OPEN_DROPDOWNMENUS) do
            if dropdownFrame then
                count = 0
                for index, value in ipairs(_G.UnitPopupMenus[dropdownFrame.which]) do
                    if (_G.UnitPopupShown[level][index] == 1) then
                        count = count + 1
                        local enable = _UnitPopup_IsEnabled(dropdownFrame, _G.UnitPopupButtons[value])
                        if (value == 'BN_INVITE' or value == 'BN_SUGGEST_INVITE' or value == 'BN_REQUEST_INVITE') then
                            if not currentDropDown.bnetIDAccount or not _CanGroupWithAccount(currentDropDown.bnetIDAccount) or isInGroupWithPlayer then
                                enable = false
                            end
                            isOk = true
                        end
                        local diff = level > 1 and 0 or 1
                        if (_G.UnitPopupButtons[value].isSubsectionTitle) then
                            tempCount = count + diff
                            count = count + 1
                        else
                            tempCount = count + diff
                        end
                        if isOk then
                            if enable then
                                _G.UIDropDownMenu_EnableButton(level, tempCount)
                            end
                            return
                        end
                    end
                end
            end
        end
    end)

    hooksecurefunc('FriendsFrame_SummonButton_Update', function(self)
        local shouldShow, enable = _FriendsFrame_ShouldShowSummonButton(self)
        self:SetShown(shouldShow)
        local start, duration = GetSummonFriendCooldown()
        if duration > 0 then
            self.duration = duration
            self.start = start
        else
            self.duration = nil
            self.start = nil
        end
        local normalTexture = self:GetNormalTexture()
        local pushedTexture = self:GetPushedTexture()
        self.enabled = enable
        if enable then
            normalTexture:SetVertexColor(1, 1, 1)
            pushedTexture:SetVertexColor(1, 1, 1)
        else
            normalTexture:SetVertexColor(.4, .4, .4)
            pushedTexture:SetVertexColor(.4, .4, .4)
        end
        _G.CooldownFrame_Set(_G[self:GetName() .. 'Cooldown'], start, duration, (enable and 0 or 1))
    end)

    hooksecurefunc('FriendsFrame_UpdateFriendButton', function(button)
        if button.id and button.buttonType == _G.FRIENDS_BUTTON_TYPE_BNET then
            local accountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
            local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo
            if gameAccountInfo and gameAccountInfo.isOnline then
                local restriction = _G.FriendsFrame_GetInviteRestriction(button.id)
                if restriction == 11 then
                    restriction = 9
                end
                local shouldShowSummonButton
                if restriction ~= 9 or accountInfo.rafLinkType == Enum.RafLinkType.None then
                    shouldShowSummonButton = false
                else
                    shouldShowSummonButton = true
                end
                button.gameIcon:SetShown(not shouldShowSummonButton)
                if restriction == 9 then
                    button.travelPassButton:Enable()
                end
            end
        end
    end)

    if _G.FriendsListFrameScrollFrame.buttons then
        for i = 1, #_G.FriendsListFrameScrollFrame.buttons do
            _G.FriendsListFrameScrollFrame.buttons[i]:HookScript('OnEnter', FriendTipOnEnter)
            _G.FriendsListFrameScrollFrame.buttons[i].travelPassButton:HookScript('OnEnter', travelPassButton_OnEnter)
        end

        _G.FriendsTooltip:HookScript('OnUpdate', function(self)
            if self.hasBroadcast and self.button then
                FriendTipOnEnter(self.button)
            end
        end)
    end
end
