local _, private = ...

-- [[ Lua Globals ]]
local pairs = _G.pairs

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.LFGFrame()
    local function styleRewardButton(button)
        F.ReskinItemFrame(button)
        button._auroraNameBG:SetPoint("RIGHT", -4, 0)

        if button.shortageBorder then
            button.shortageBorder:SetAlpha(0)
        end
    end

    styleRewardButton(_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward)
    styleRewardButton(_G.ScenarioQueueFrameRandomScrollFrameChildFrame.MoneyReward)
    styleRewardButton(_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward)

    _G.LFGDungeonReadyDialogBackground:Hide()
    _G.LFGDungeonReadyDialogBottomArt:Hide()
    _G.LFGDungeonReadyDialogFiligree:Hide()

    _G.LFGDungeonReadyDialogRoleIconTexture:SetTexture(C.media.roleIcons)
    _G.LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexture(C.media.roleIcons)
    _G.LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexCoord(0, 0.296875, 0.015625, 0.2875)

    local leaderBg = F.CreateBG(_G.LFGDungeonReadyDialogRoleIconLeaderIcon)
    leaderBg:SetDrawLayer("ARTWORK", 2)
    leaderBg:SetPoint("TOPLEFT", _G.LFGDungeonReadyDialogRoleIconLeaderIcon, 2, 0)
    leaderBg:SetPoint("BOTTOMRIGHT", _G.LFGDungeonReadyDialogRoleIconLeaderIcon, -3, 4)

    hooksecurefunc("LFGDungeonReadyPopup_Update", function()
        leaderBg:SetShown(_G.LFGDungeonReadyDialogRoleIconLeaderIcon:IsShown())
    end)

    do
        local left = _G.LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", 9, -7)
        left:SetPoint("BOTTOMLEFT", 9, 10)

        local right = _G.LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", -8, -7)
        right:SetPoint("BOTTOMRIGHT", -8, 10)

        local top = _G.LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", 9, -7)
        top:SetPoint("TOPRIGHT", -8, -7)

        local bottom = _G.LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", 9, 10)
        bottom:SetPoint("BOTTOMRIGHT", -8, 10)
    end

    hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
        if not button.styled then
            local border = _G[button:GetName().."Border"]

            button.texture:SetTexCoord(.08, .92, .08, .92)

            border:SetColorTexture(0, 0, 0)
            border:SetDrawLayer("BACKGROUND")
            border:SetPoint("TOPLEFT", button.texture, -1, 1)
            border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

            button.styled = true
        end

        button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
    end)

    hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
        if not button.styled then
            local border = _G[button:GetName().."Border"]

            button.texture:SetTexCoord(.08, .92, .08, .92)

            border:SetColorTexture(0, 0, 0)
            border:SetDrawLayer("BACKGROUND")
            border:SetPoint("TOPLEFT", button.texture, -1, 1)
            border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

            button.styled = true
        end

        local texturePath, _
        if rewardType == "reward" then
            _, texturePath, _ = _G.GetLFGDungeonRewardInfo(dungeonID, rewardIndex)
        elseif rewardType == "shortage" then
            _, texturePath, _ = _G.GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex)
        end
        if texturePath then
            button.texture:SetTexture(texturePath)
        end
    end)

    F.CreateBD(_G.LFGDungeonReadyDialog)
    F.CreateSD(_G.LFGDungeonReadyDialog)
    _G.LFGDungeonReadyDialog.SetBackdrop = F.dummy
    F.CreateBD(_G.LFGInvitePopup)
    F.CreateSD(_G.LFGInvitePopup)
    F.CreateBD(_G.LFGDungeonReadyStatus)
    F.CreateSD(_G.LFGDungeonReadyStatus)

    F.Reskin(_G.LFGDungeonReadyDialogEnterDungeonButton)
    F.Reskin(_G.LFGDungeonReadyDialogLeaveQueueButton)
    F.Reskin(_G.LFGInvitePopupAcceptButton)
    F.Reskin(_G.LFGInvitePopupDeclineButton)
    F.ReskinClose(_G.LFGDungeonReadyDialogCloseButton)
    F.ReskinClose(_G.LFGDungeonReadyStatusCloseButton)

    local roleQueueButtons = {
        _G.LFDQueueFrameRoleButtonTank, _G.LFDQueueFrameRoleButtonHealer, _G.LFDQueueFrameRoleButtonDPS, _G.LFDQueueFrameRoleButtonLeader,
        _G.RaidFinderQueueFrameRoleButtonTank, _G.RaidFinderQueueFrameRoleButtonHealer, _G.RaidFinderQueueFrameRoleButtonDPS, _G.RaidFinderQueueFrameRoleButtonLeader
    }
    for _, roleButton in pairs(roleQueueButtons) do
        if roleButton.background then
            roleButton.background:SetTexture("")
        end

        roleButton.cover:SetTexture(C.media.roleIcons)
        roleButton:SetNormalTexture(C.media.roleIcons)

        roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

        for i = 1, 2 do
            local left = roleButton:CreateTexture()
            left:SetDrawLayer("OVERLAY", i)
            left:SetWidth(1)
            left:SetTexture(C.media.backdrop)
            left:SetVertexColor(0, 0, 0)
            left:SetPoint("TOPLEFT", roleButton, 6, -5)
            left:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
            roleButton["leftLine"..i] = left

            local right = roleButton:CreateTexture()
            right:SetDrawLayer("OVERLAY", i)
            right:SetWidth(1)
            right:SetTexture(C.media.backdrop)
            right:SetVertexColor(0, 0, 0)
            right:SetPoint("TOPRIGHT", roleButton, -6, -5)
            right:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
            roleButton["rightLine"..i] = right

            local top = roleButton:CreateTexture()
            top:SetDrawLayer("OVERLAY", i)
            top:SetHeight(1)
            top:SetTexture(C.media.backdrop)
            top:SetVertexColor(0, 0, 0)
            top:SetPoint("TOPLEFT", roleButton, 6, -5)
            top:SetPoint("TOPRIGHT", roleButton, -6, -5)
            roleButton["topLine"..i] = top

            local bottom = roleButton:CreateTexture()
            bottom:SetDrawLayer("OVERLAY", i)
            bottom:SetHeight(1)
            bottom:SetTexture(C.media.backdrop)
            bottom:SetVertexColor(0, 0, 0)
            bottom:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
            bottom:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
            roleButton["bottomLine"..i] = bottom
        end

        roleButton.leftLine2:Hide()
        roleButton.rightLine2:Hide()
        roleButton.topLine2:Hide()
        roleButton.bottomLine2:Hide()

        local shortageBorder = roleButton.shortageBorder
        if shortageBorder then
            local icon = roleButton.incentiveIcon

            shortageBorder:SetTexture("")

            icon.border:SetColorTexture(0, 0, 0)
            icon.border:SetDrawLayer("BACKGROUND")
            icon.border:SetPoint("TOPLEFT", icon.texture, -1, 1)
            icon.border:SetPoint("BOTTOMRIGHT", icon.texture, 1, -1)

            icon:SetPoint("BOTTOMRIGHT", 3, -3)
            icon:SetSize(14, 14)
            icon.texture:SetSize(14, 14)
            icon.texture:SetTexCoord(.12, .88, .12, .88)
        end

        F.ReskinCheck(roleButton.checkButton)
    end

    local rolePoleButtons = {
        _G.LFDRoleCheckPopupRoleButtonTank, _G.LFDRoleCheckPopupRoleButtonHealer, _G.LFDRoleCheckPopupRoleButtonDPS,
        _G.LFGInvitePopupRoleButtonTank, _G.LFGInvitePopupRoleButtonHealer, _G.LFGInvitePopupRoleButtonDPS,
        _G.LFGListApplicationDialog.TankButton, _G.LFGListApplicationDialog.HealerButton, _G.LFGListApplicationDialog.DamagerButton
    }
    for _, roleButton in pairs(rolePoleButtons) do

        roleButton.cover:SetTexture(C.media.roleIcons)
        roleButton:SetNormalTexture(C.media.roleIcons)

        local checkButton = roleButton.checkButton or roleButton.CheckButton
        checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

        local left = roleButton:CreateTexture(nil, "OVERLAY")
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", roleButton, 9, -7)
        left:SetPoint("BOTTOMLEFT", roleButton, 9, 11)

        local right = roleButton:CreateTexture(nil, "OVERLAY")
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", roleButton, -9, -7)
        right:SetPoint("BOTTOMRIGHT", roleButton, -9, 11)

        local top = roleButton:CreateTexture(nil, "OVERLAY")
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", roleButton, 9, -7)
        top:SetPoint("TOPRIGHT", roleButton, -9, -7)

        local bottom = roleButton:CreateTexture(nil, "OVERLAY")
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", roleButton, 9, 11)
        bottom:SetPoint("BOTTOMRIGHT", roleButton, -9, 11)

        F.ReskinCheck(checkButton)
    end

    local roleStatusButtons = {_G.LFGDungeonReadyStatusGroupedTank, _G.LFGDungeonReadyStatusGroupedHealer, _G.LFGDungeonReadyStatusGroupedDamager, _G.LFGDungeonReadyStatusRolelessReady}
    for i = 1, 5 do
        _G.tinsert(roleStatusButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i])
    end
    for _, roleButton in pairs(roleStatusButtons) do
        roleButton.texture:SetTexture(C.media.roleIcons)
        roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)

        local left = roleButton:CreateTexture(nil, "OVERLAY")
        left:SetWidth(1)
        left:SetTexture(C.media.backdrop)
        left:SetVertexColor(0, 0, 0)
        left:SetPoint("TOPLEFT", 7, -6)
        left:SetPoint("BOTTOMLEFT", 7, 8)

        local right = roleButton:CreateTexture(nil, "OVERLAY")
        right:SetWidth(1)
        right:SetTexture(C.media.backdrop)
        right:SetVertexColor(0, 0, 0)
        right:SetPoint("TOPRIGHT", -7, -6)
        right:SetPoint("BOTTOMRIGHT", -7, 8)

        local top = roleButton:CreateTexture(nil, "OVERLAY")
        top:SetHeight(1)
        top:SetTexture(C.media.backdrop)
        top:SetVertexColor(0, 0, 0)
        top:SetPoint("TOPLEFT", 7, -6)
        top:SetPoint("TOPRIGHT", -7, -6)

        local bottom = roleButton:CreateTexture(nil, "OVERLAY")
        bottom:SetHeight(1)
        bottom:SetTexture(C.media.backdrop)
        bottom:SetVertexColor(0, 0, 0)
        bottom:SetPoint("BOTTOMLEFT", 7, 8)
        bottom:SetPoint("BOTTOMRIGHT", -7, 8)
    end

    _G.LFGDungeonReadyStatusRolelessReady.texture:SetTexCoord(0.5234375, 0.78750, 0, 0.25875)

    hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
        if incentiveIndex then
            local tex
            if incentiveIndex == _G.LFG_ROLE_SHORTAGE_PLENTIFUL then
                tex = "Interface\\Icons\\INV_Misc_Coin_19"
            elseif incentiveIndex == _G.LFG_ROLE_SHORTAGE_UNCOMMON then
                tex = "Interface\\Icons\\INV_Misc_Coin_18"
            elseif incentiveIndex == _G.LFG_ROLE_SHORTAGE_RARE then
                tex = "Interface\\Icons\\INV_Misc_Coin_17"
            end
            roleButton.incentiveIcon.texture:SetTexture(tex)
            roleButton.leftLine2:Show()
            roleButton.rightLine2:Show()
            roleButton.topLine2:Show()
            roleButton.bottomLine2:Show()
        else
            roleButton.leftLine2:Hide()
            roleButton.rightLine2:Hide()
            roleButton.topLine2:Hide()
            roleButton.bottomLine2:Hide()
        end
    end)

    hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
        if button.shortageBorder then
            button.leftLine2:SetVertexColor(.5, .45, .03)
            button.rightLine2:SetVertexColor(.5, .45, .03)
            button.topLine2:SetVertexColor(.5, .45, .03)
            button.bottomLine2:SetVertexColor(.5, .45, .03)
        end
    end)

    hooksecurefunc("LFG_DisableRoleButton", function(button)
        if button.shortageBorder then
            button.leftLine2:SetVertexColor(.5, .45, .03)
            button.rightLine2:SetVertexColor(.5, .45, .03)
            button.topLine2:SetVertexColor(.5, .45, .03)
            button.bottomLine2:SetVertexColor(.5, .45, .03)
        end
    end)

    hooksecurefunc("LFG_EnableRoleButton", function(button)
        if button.shortageBorder then
            button.leftLine2:SetVertexColor(1, .9, .06)
            button.rightLine2:SetVertexColor(1, .9, .06)
            button.topLine2:SetVertexColor(1, .9, .06)
            button.bottomLine2:SetVertexColor(1, .9, .06)
        end
    end)

    --Reward frame functions
    hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, dungeonID, index, id, name, texture, numItems, rewardType, rewardID, shortageIndex, showTankIcon, showHealerIcon, showDamageIcon)
        local parentName = parentFrame:GetName()
        local button = _G[parentName.."Item"..index]
        if button and not button._auroraNameBG then
            styleRewardButton(button)
        end
        button.IconBorder:Hide()
        if shortageIndex then
            button._auroraIconBorder:SetBackdropBorderColor(1, .9, .06)
        elseif rewardType ~= "item" then
            button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
        end
    end)

    -- LFD/Scenario group invite stuff
    hooksecurefunc("LFGDungeonListButton_SetDungeon", function(button, dungeonID)
        if not button.expandOrCollapseButton._auroraSkinned then
            F.ReskinCheck(button.enableButton)
            F.ReskinExpandOrCollapse(button.expandOrCollapseButton)
            button.expandOrCollapseButton._auroraSkinned = true
        end
        button.enableButton:GetCheckedTexture():SetDesaturated(true)
    end)
end
