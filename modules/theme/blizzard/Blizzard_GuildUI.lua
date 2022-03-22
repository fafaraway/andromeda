local F, C = unpack(select(2, ...))

local function updateClassIcons()
    local r, g, b = C.r, C.g, C.b
    local GuildRosterContainer = _G.GuildRosterContainer
    local index
    local offset = _G.HybridScrollFrame_GetOffset(GuildRosterContainer)
    local totalMembers, _, onlineAndMobileMembers = GetNumGuildMembers()
    local visibleMembers = onlineAndMobileMembers
    local numbuttons = #GuildRosterContainer.buttons
    if GetGuildRosterShowOffline() then
        visibleMembers = totalMembers
    end

    for i = 1, numbuttons do
        local bu = GuildRosterContainer.buttons[i]

        if not bu.bg then
            bu:SetHighlightTexture(C.Assets.Textures.Backdrop)
            bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

            bu.bg = F.CreateBDFrame(bu.icon)
        end

        index = offset + i
        local name, _, _, _, _, _, _, _, _, _, classFileName = GetGuildRosterInfo(index)
        if name and index <= visibleMembers and bu.icon:IsShown() then
            F.ClassIconTexCoord(bu.icon, classFileName)
            bu.bg:Show()
        else
            bu.bg:Hide()
        end
    end
end

local function updateLevelString(view)
    local GuildRosterContainer = _G.GuildRosterContainer
    if view == 'playerStatus' or view == 'reputation' or view == 'achievement' then
        local buttons = GuildRosterContainer.buttons
        for i = 1, #buttons do
            local str = _G['GuildRosterContainerButton' .. i .. 'String1']
            str:SetWidth(32)
            str:SetJustifyH('LEFT')
        end

        if view == 'achievement' then
            for i = 1, #buttons do
                local str = _G['GuildRosterContainerButton' .. i .. 'BarLabel']
                str:SetWidth(60)
                str:SetJustifyH('LEFT')
            end
        end
    end
end

C.Themes['Blizzard_GuildUI'] = function()
    local r, g, b = C.r, C.g, C.b
    local GuildRosterContainer = _G.GuildRosterContainer

    F.ReskinPortraitFrame(_G.GuildFrame)
    F.StripTextures(_G.GuildMemberDetailFrame)
    F.SetBD(_G.GuildMemberDetailFrame)
    _G.GuildMemberNoteBackground:HideBackdrop()
    F.CreateBDFrame(_G.GuildMemberNoteBackground, .25)
    _G.GuildMemberOfficerNoteBackground:HideBackdrop()
    F.CreateBDFrame(_G.GuildMemberOfficerNoteBackground, .25)
    F.SetBD(_G.GuildLogFrame)
    F.CreateBDFrame(_G.GuildLogContainer, .25)
    F.SetBD(_G.GuildNewsFiltersFrame)
    F.SetBD(_G.GuildTextEditFrame)
    F.CreateBDFrame(_G.GuildTextEditContainer, .25)
    F.CreateBDFrame(_G.GuildRecruitmentInterestFrame, .25)
    F.CreateBDFrame(_G.GuildRecruitmentAvailabilityFrame, .25)
    F.CreateBDFrame(_G.GuildRecruitmentRolesFrame, .25)
    F.CreateBDFrame(_G.GuildRecruitmentLevelFrame, .25)
    for i = 1, 5 do
        F.ReskinTab(_G['GuildFrameTab' .. i])
    end
    if GetLocale() == 'zhTW' then
        _G.GuildFrameTab1:ClearAllPoints()
        _G.GuildFrameTab1:SetPoint('TOPLEFT', _G.GuildFrame, 'BOTTOMLEFT', -7, 2)
    end
    _G.GuildFrameTabardBackground:Hide()
    _G.GuildFrameTabardEmblem:Hide()
    _G.GuildFrameTabardBorder:Hide()
    F.StripTextures(_G.GuildInfoFrameInfo)
    _G.GuildMemberDetailCorner:Hide()
    F.StripTextures(_G.GuildLogFrame)
    F.StripTextures(_G.GuildLogContainer)
    F.StripTextures(_G.GuildNewsFiltersFrame)
    F.StripTextures(_G.GuildTextEditFrame)
    _G.GuildAllPerksFrame:GetRegions():Hide()
    _G.GuildNewsFrame:GetRegions():Hide()
    _G.GuildRewardsFrame:GetRegions():Hide()
    _G.GuildNewsBossModelShadowOverlay:Hide()

    _G.GuildRecruitmentCommentInputFrameTop:Hide()
    _G.GuildRecruitmentCommentInputFrameTopLeft:Hide()
    _G.GuildRecruitmentCommentInputFrameTopRight:Hide()
    _G.GuildRecruitmentCommentInputFrameBottom:Hide()
    _G.GuildRecruitmentCommentInputFrameBottomLeft:Hide()
    _G.GuildRecruitmentCommentInputFrameBottomRight:Hide()
    _G.GuildRecruitmentInterestFrameBg:Hide()
    _G.GuildRecruitmentAvailabilityFrameBg:Hide()
    _G.GuildRecruitmentRolesFrameBg:Hide()
    _G.GuildRecruitmentLevelFrameBg:Hide()
    _G.GuildRecruitmentCommentFrameBg:Hide()
    _G.GuildNewsFrameHeader:SetAlpha(0)

    _G.GuildFrameBottomInset:DisableDrawLayer('BACKGROUND')
    _G.GuildFrameBottomInset:DisableDrawLayer('BORDER')
    _G.GuildInfoFrameInfoBar1Left:SetAlpha(0)
    _G.GuildInfoFrameInfoBar2Left:SetAlpha(0)
    for i = 1, 4 do
        _G['GuildRosterColumnButton' .. i]:DisableDrawLayer('BACKGROUND')
    end
    _G.GuildNewsBossModel:DisableDrawLayer('BACKGROUND')
    _G.GuildNewsBossModel:DisableDrawLayer('OVERLAY')
    _G.GuildNewsBossNameText:SetDrawLayer('ARTWORK')
    F.StripTextures(_G.GuildNewsBossModelTextFrame)

    _G.GuildMemberRankDropdown:HookScript(
        'OnShow',
        function()
            _G.GuildMemberDetailRankText:Hide()
        end
    )
    _G.GuildMemberRankDropdown:HookScript(
        'OnHide',
        function()
            _G.GuildMemberDetailRankText:Show()
        end
    )

    hooksecurefunc(
        'GuildNews_Update',
        function()
            local buttons = _G.GuildNewsContainer.buttons
            for i = 1, #buttons do
                buttons[i].header:SetAlpha(0)
            end
        end
    )

    F.ReskinClose(_G.GuildNewsFiltersFrameCloseButton)
    F.ReskinClose(_G.GuildLogFrameCloseButton)
    F.ReskinClose(_G.GuildMemberDetailCloseButton)
    F.ReskinClose(_G.GuildTextEditFrameCloseButton)
    F.ReskinScroll(_G.GuildPerksContainerScrollBar)
    F.ReskinScroll(_G.GuildRosterContainerScrollBar)
    F.ReskinScroll(_G.GuildNewsContainerScrollBar)
    F.ReskinScroll(_G.GuildRewardsContainerScrollBar)
    F.ReskinScroll(_G.GuildInfoFrameInfoMOTDScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildInfoDetailsFrameScrollBar)
    F.ReskinScroll(_G.GuildLogScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildTextEditScrollFrameScrollBar)
    F.ReskinDropDown(_G.GuildRosterViewDropdown)
    F.ReskinDropDown(_G.GuildMemberRankDropdown)

    F.ReskinCheck(_G.GuildRosterShowOfflineButton)
    for i = 1, 7 do
        F.ReskinCheck(_G.GuildNewsFiltersFrame.GuildNewsFilterButtons[i])
    end

    local a1, p, a2, x, y = _G.GuildNewsBossModel:GetPoint()
    _G.GuildNewsBossModel:ClearAllPoints()
    _G.GuildNewsBossModel:SetPoint(a1, p, a2, x + 7, y)

    local f = F.SetBD(_G.GuildNewsBossModel)
    f:SetPoint('BOTTOMRIGHT', 2, -52)

    _G.GuildNewsFiltersFrame:SetWidth(224)
    _G.GuildNewsFiltersFrame:SetPoint('TOPLEFT', _G.GuildFrame, 'TOPRIGHT', 3, -20)
    _G.GuildMemberDetailFrame:SetPoint('TOPLEFT', _G.GuildFrame, 'TOPRIGHT', 3, -28)
    _G.GuildLogFrame:SetPoint('TOPLEFT', _G.GuildFrame, 'TOPRIGHT', 3, 0)
    _G.GuildTextEditFrame:SetPoint('TOPLEFT', _G.GuildFrame, 'TOPRIGHT', 3, 0)

    _G.GuildFactionBarProgress:SetTexture(C.Assets.Textures.SBNormal)
    _G.GuildFactionBarLeft:Hide()
    _G.GuildFactionBarMiddle:Hide()
    _G.GuildFactionBarRight:Hide()
    _G.GuildFactionBarShadow:SetAlpha(0)
    _G.GuildFactionBarBG:Hide()
    _G.GuildFactionBarCap:SetAlpha(0)
    local bg = F.CreateBDFrame(_G.GuildFactionFrame, .25)
    bg:SetPoint('TOPLEFT', _G.GuildFactionFrame, -1, -1)
    bg:SetPoint('BOTTOMRIGHT', _G.GuildFactionFrame, -3, 0)
    bg:SetFrameLevel(0)

    for _, button in pairs(_G.GuildPerksContainer.buttons) do
        F.ReskinIcon(button.icon)
        F.StripTextures(button)
        button.bg = F.CreateBDFrame(button, .25)
        button.bg:ClearAllPoints()
        button.bg:SetPoint('TOPLEFT', button.icon, 0, C.mult)
        button.bg:SetPoint('BOTTOMLEFT', button.icon, 0, -C.mult)
        button.bg:SetWidth(button:GetWidth())
    end
    _G.GuildPerksContainerButton1:SetPoint('LEFT', -1, 0)

    hooksecurefunc(
        'GuildRewards_Update',
        function()
            local buttons = _G.GuildRewardsContainer.buttons
            for i = 1, #buttons do
                local bu = buttons[i]
                if not bu.bg then
                    bu:SetNormalTexture('')
                    bu:SetHighlightTexture('')
                    F.ReskinIcon(bu.icon)
                    bu.disabledBG:Hide()
                    bu.disabledBG.Show = nop

                    bu.bg = F.CreateBDFrame(bu, .25)
                    bu.bg:ClearAllPoints()
                    bu.bg:SetPoint('TOPLEFT', 1, -1)
                    bu.bg:SetPoint('BOTTOMRIGHT', 0, 0)
                end
            end
        end
    )

    hooksecurefunc('GuildRoster_Update', updateClassIcons)
    hooksecurefunc(GuildRosterContainer, 'update', updateClassIcons)

    F.Reskin(select(4, _G.GuildTextEditFrame:GetChildren()))
    F.Reskin(select(3, _G.GuildLogFrame:GetChildren()))

    local gbuttons = {
        'GuildAddMemberButton',
        'GuildViewLogButton',
        'GuildControlButton',
        'GuildTextEditFrameAcceptButton',
        'GuildMemberGroupInviteButton',
        'GuildMemberRemoveButton',
        'GuildRecruitmentInviteButton',
        'GuildRecruitmentMessageButton',
        'GuildRecruitmentDeclineButton',
        'GuildRecruitmentListGuildButton'
    }
    for i = 1, #gbuttons do
        F.Reskin(_G[gbuttons[i]])
    end

    -- Tradeskill View
    hooksecurefunc(
        'GuildRoster_UpdateTradeSkills',
        function()
            local buttons = GuildRosterContainer.buttons
            for i = 1, #buttons do
                local index = _G.HybridScrollFrame_GetOffset(GuildRosterContainer) + i
                local str = _G['GuildRosterContainerButton' .. i .. 'String1']
                local header = _G['GuildRosterContainerButton' .. i .. 'HeaderButton']
                if header then
                    local _, _, _, headerName = GetGuildTradeSkillInfo(index)
                    if headerName then
                        str:Hide()
                    else
                        str:Show()
                    end

                    if not header.bg then
                        F.StripTextures(header, 5)
                        header.bg = F.CreateBDFrame(header, .25)
                        header.bg:SetAllPoints()

                        header:SetHighlightTexture(C.Assets.Textures.Backdrop)
                        local hl = header:GetHighlightTexture()
                        hl:SetVertexColor(r, g, b, .25)
                        hl:SetInside()
                    end
                end
            end
        end
    )

    -- Font width fix
    local done
    GuildRosterContainer:HookScript(
        'OnShow',
        function()
            if not done then
                updateLevelString(GetCVar('guildRosterView'))
                done = true
            end
        end
    )
    hooksecurefunc('GuildRoster_SetView', updateLevelString)
end
