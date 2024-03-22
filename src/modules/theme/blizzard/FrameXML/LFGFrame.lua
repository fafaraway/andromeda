local F, C = unpack(select(2, ...))

local function styleRewardButton(button)
    if not button or button.styled then
        return
    end

    local buttonName = button:GetName()
    local icon = _G[buttonName .. 'IconTexture']
    local shortageBorder = _G[buttonName .. 'ShortageBorder']
    local count = _G[buttonName .. 'Count']
    local nameFrame = _G[buttonName .. 'NameFrame']
    local border = button.IconBorder

    button.bg = F.ReskinIcon(icon)
    local bg = F.CreateBDFrame(button, 0.25)
    bg:SetPoint('TOPLEFT', button.bg, 'TOPRIGHT', 1, 0)
    bg:SetPoint('BOTTOMRIGHT', button.bg, 'BOTTOMRIGHT', 105, 0)

    if shortageBorder then
        shortageBorder:SetAlpha(0)
    end
    if count then
        count:SetDrawLayer('OVERLAY')
    end
    if nameFrame then
        nameFrame:SetAlpha(0)
    end
    if border then
        F.ReskinIconBorder(border)
    end

    button.styled = true
end

local function reskinDialogReward(button)
    if button.styled then
        return
    end

    local border = _G[button:GetName() .. 'Border']
    button.texture:SetTexCoord(unpack(C.TEX_COORD))
    border:SetColorTexture(0, 0, 0)
    border:SetDrawLayer('BACKGROUND')
    border:SetOutside(button.texture)
    button.styled = true
end

local function styleRewardRole(roleIcon)
    if roleIcon and roleIcon:IsShown() then
        F.ReskinSmallRole(roleIcon.texture, roleIcon.role)
    end
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    -- LFDFrame
    hooksecurefunc('LFGDungeonListButton_SetDungeon', function(button)
        if not button.expandOrCollapseButton.styled then
            F.ReskinCheckbox(button.enableButton)
            F.ReskinCollapse(button.expandOrCollapseButton)

            button.expandOrCollapseButton.styled = true
        end

        button.enableButton:GetCheckedTexture():SetAtlas('checkmark-minimal')
        local disabledTexture = button.enableButton:GetDisabledCheckedTexture()
        disabledTexture:SetAtlas('checkmark-minimal')
        disabledTexture:SetDesaturated(true)
    end)

    F.StripTextures(_G.LFDParentFrame)
    _G.LFDQueueFrameBackground:Hide()
    F.SetBD(_G.LFDRoleCheckPopup)
    _G.LFDRoleCheckPopup.Border:Hide()
    F.ReskinButton(_G.LFDRoleCheckPopupAcceptButton)
    F.ReskinButton(_G.LFDRoleCheckPopupDeclineButton)
    F.ReskinTrimScroll(_G.LFDQueueFrameSpecific.ScrollBar)
    F.ReskinTrimScroll(_G.LFDQueueFrameRandomScrollFrame.ScrollBar)
    F.ReskinDropdown(_G.LFDQueueFrameTypeDropDown)
    F.ReskinButton(_G.LFDQueueFrameFindGroupButton)
    F.ReskinButton(_G.LFDQueueFramePartyBackfillBackfillButton)
    F.ReskinButton(_G.LFDQueueFramePartyBackfillNoBackfillButton)
    F.ReskinButton(_G.LFDQueueFrameNoLFDWhileLFRLeaveQueueButton)
    styleRewardButton(_G.LFDQueueFrameRandomScrollFrameChildFrameMoneyReward)

    -- LFGFrame
    hooksecurefunc('LFGRewardsFrame_SetItemButton', function(parentFrame, _, index)
        local parentName = parentFrame:GetName()
        styleRewardButton(parentFrame.MoneyReward)

        local button = _G[parentName .. 'Item' .. index]
        styleRewardButton(button)

        styleRewardRole(button.roleIcon1)
        styleRewardRole(button.roleIcon2)
    end)

    hooksecurefunc('LFGDungeonReadyDialogReward_SetMisc', function(button)
        reskinDialogReward(button)
        button.texture:SetTexture('Interface\\Icons\\inv_misc_coin_02')
    end)

    hooksecurefunc('LFGDungeonReadyDialogReward_SetReward', function(button, dungeonID, rewardIndex, rewardType, rewardArg)
        reskinDialogReward(button)

        local texturePath
        if rewardType == 'reward' then
            texturePath = select(2, GetLFGDungeonRewardInfo(dungeonID, rewardIndex))
        elseif rewardType == 'shortage' then
            texturePath = select(2, GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex))
        end
        if texturePath then
            button.texture:SetTexture(texturePath)
        end
    end)

    F.StripTextures(_G.LFGDungeonReadyDialog, 0)
    F.SetBD(_G.LFGDungeonReadyDialog)
    F.StripTextures(_G.LFGInvitePopup)
    F.SetBD(_G.LFGInvitePopup)
    F.StripTextures(_G.LFGDungeonReadyStatus)
    F.SetBD(_G.LFGDungeonReadyStatus)

    F.ReskinButton(_G.LFGDungeonReadyDialogEnterDungeonButton)
    F.ReskinButton(_G.LFGDungeonReadyDialogLeaveQueueButton)
    F.ReskinButton(_G.LFGInvitePopupAcceptButton)
    F.ReskinButton(_G.LFGInvitePopupDeclineButton)
    F.ReskinClose(_G.LFGDungeonReadyDialogCloseButton)
    F.ReskinClose(_G.LFGDungeonReadyStatusCloseButton)

    local roleButtons = {
        -- tank
        _G.LFDQueueFrameRoleButtonTank,
        _G.LFDRoleCheckPopupRoleButtonTank,
        _G.RaidFinderQueueFrameRoleButtonTank,
        _G.LFGInvitePopupRoleButtonTank,
        _G.LFGListApplicationDialog.TankButton,
        _G.LFGDungeonReadyStatusGroupedTank,

        -- healer
        _G.LFDQueueFrameRoleButtonHealer,
        _G.LFDRoleCheckPopupRoleButtonHealer,
        _G.RaidFinderQueueFrameRoleButtonHealer,
        _G.LFGInvitePopupRoleButtonHealer,
        _G.LFGListApplicationDialog.HealerButton,
        _G.LFGDungeonReadyStatusGroupedHealer,
     
        -- dps
        _G.LFDQueueFrameRoleButtonDPS,
        _G.LFDRoleCheckPopupRoleButtonDPS,
        _G.RaidFinderQueueFrameRoleButtonDPS,
        _G.LFGInvitePopupRoleButtonDPS,
        _G.LFGListApplicationDialog.DamagerButton,
        _G.LFGDungeonReadyStatusGroupedDamager,

        -- leader
        _G.LFDQueueFrameRoleButtonLeader,
        _G.RaidFinderQueueFrameRoleButtonLeader,
        _G.LFGDungeonReadyStatusRolelessReady,
    }

    for _, roleButton in pairs(roleButtons) do
		F.ReskinRole(roleButton)
	end

    hooksecurefunc('SetCheckButtonIsRadio', function(button)
        button:SetNormalTexture(0)
        button:SetHighlightTexture(C.Assets.Textures.Backdrop)
        button:SetCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check')
        button:GetCheckedTexture():SetTexCoord(0, 1, 0, 1)
        button:SetPushedTexture(0)
        button:SetDisabledCheckedTexture('Interface\\Buttons\\UI-CheckBox-Check-Disabled')
        button:GetDisabledCheckedTexture():SetTexCoord(0, 1, 0, 1)
    end)

    -- RaidFinder
    _G.RaidFinderFrameBottomInset:Hide()
    _G.RaidFinderFrameRoleBackground:Hide()
    _G.RaidFinderFrameRoleInset:Hide()
    _G.RaidFinderQueueFrameBackground:Hide()
    -- this fixes right border of second reward being cut off
    _G.RaidFinderQueueFrameScrollFrame:SetWidth(_G.RaidFinderQueueFrameScrollFrame:GetWidth() + 1)

    F.ReskinTrimScroll(_G.RaidFinderQueueFrameScrollFrame.ScrollBar)
    F.ReskinDropdown(_G.RaidFinderQueueFrameSelectionDropDown)
    F.ReskinButton(_G.RaidFinderFrameFindRaidButton)
    F.ReskinButton(_G.RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
    F.ReskinButton(_G.RaidFinderQueueFramePartyBackfillBackfillButton)
    F.ReskinButton(_G.RaidFinderQueueFramePartyBackfillNoBackfillButton)
    styleRewardButton(_G.RaidFinderQueueFrameScrollFrameChildFrameMoneyReward)
end)
