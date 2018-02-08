local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)

function private.AddOns.Blizzard_GuildUI()
    local r, g, b = C.r, C.g, C.b

    F.ReskinPortraitFrame(_G.GuildFrame, true)
    F.CreateBD(_G.GuildFrame)
    F.CreateSD(_G.GuildFrame)
    F.CreateBD(_G.GuildMemberDetailFrame)
    F.CreateBD(_G.GuildMemberNoteBackground, .25)
    F.CreateBD(_G.GuildMemberOfficerNoteBackground, .25)
    F.CreateBD(_G.GuildLogFrame)
    F.CreateBD(_G.GuildLogContainer, .25)
    F.CreateBD(_G.GuildNewsFiltersFrame)
    F.CreateBD(_G.GuildTextEditFrame)
    F.CreateBD(_G.GuildTextEditContainer, .25)
    F.CreateBD(_G.GuildRecruitmentInterestFrame, .25)
    F.CreateBD(_G.GuildRecruitmentAvailabilityFrame, .25)
    F.CreateBD(_G.GuildRecruitmentRolesFrame, .25)
    F.CreateBD(_G.GuildRecruitmentLevelFrame, .25)
    for i = 1, 5 do
        F.ReskinTab(_G["GuildFrameTab"..i])
    end
    _G.GuildFrameTabardBackground:Hide()
    _G.GuildFrameTabardEmblem:Hide()
    _G.GuildFrameTabardBorder:Hide()
    select(5, _G.GuildInfoFrameInfo:GetRegions()):Hide()
    select(11, _G.GuildMemberDetailFrame:GetRegions()):Hide()
    _G.GuildMemberDetailCorner:Hide()
    for i = 1, 9 do
        select(i, _G.GuildLogFrame:GetRegions()):Hide()
        select(i, _G.GuildNewsFiltersFrame:GetRegions()):Hide()
        select(i, _G.GuildTextEditFrame:GetRegions()):Hide()
    end
    _G.GuildAllPerksFrame:GetRegions():Hide()
    _G.GuildNewsFrame:GetRegions():Hide()
    _G.GuildRewardsFrame:GetRegions():Hide()
    _G.GuildNewsBossModelShadowOverlay:Hide()
    _G.GuildInfoFrameInfoHeader1:SetAlpha(0)
    _G.GuildInfoFrameInfoHeader2:SetAlpha(0)
    _G.GuildInfoFrameInfoHeader3:SetAlpha(0)
    select(9, _G.GuildInfoFrameInfo:GetRegions()):Hide()
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

    _G.GuildFrameBottomInset:DisableDrawLayer("BACKGROUND")
    _G.GuildFrameBottomInset:DisableDrawLayer("BORDER")
    _G.GuildInfoFrameInfoBar1Left:SetAlpha(0)
    _G.GuildInfoFrameInfoBar2Left:SetAlpha(0)
    select(2, _G.GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
    select(4, _G.GuildInfoFrameInfo:GetRegions()):SetAlpha(0)
    _G.GuildRosterColumnButton1:DisableDrawLayer("BACKGROUND")
    _G.GuildRosterColumnButton2:DisableDrawLayer("BACKGROUND")
    _G.GuildRosterColumnButton3:DisableDrawLayer("BACKGROUND")
    _G.GuildRosterColumnButton4:DisableDrawLayer("BACKGROUND")
    _G.GuildNewsBossModel:DisableDrawLayer("BACKGROUND")
    _G.GuildNewsBossModel:DisableDrawLayer("OVERLAY")
    _G.GuildNewsBossNameText:SetDrawLayer("ARTWORK")
    _G.GuildNewsBossModelTextFrame:DisableDrawLayer("BACKGROUND")
    for i = 2, 6 do
        select(i, _G.GuildNewsBossModelTextFrame:GetRegions()):Hide()
    end

    _G.GuildMemberRankDropdown:HookScript("OnShow", function()
        _G.GuildMemberDetailRankText:Hide()
    end)
    _G.GuildMemberRankDropdown:HookScript("OnHide", function()
        _G.GuildMemberDetailRankText:Show()
    end)

    hooksecurefunc("GuildNews_Update", function()
        local buttons = _G.GuildNewsContainer.buttons
        for i = 1, #buttons do
            buttons[i].header:SetAlpha(0)
        end
    end)

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
    F.ReskinScroll(_G.GuildRecruitmentCommentInputFrameScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildInfoFrameApplicantsContainerScrollBar)
    F.ReskinDropDown(_G.GuildRosterViewDropdown)
    F.ReskinDropDown(_G.GuildMemberRankDropdown)
    F.ReskinInput(_G.GuildRecruitmentCommentInputFrame)

    _G.GuildRecruitmentCommentInputFrame:SetWidth(312)
    _G.GuildRecruitmentCommentEditBox:SetWidth(284)
    _G.GuildRecruitmentCommentFrame:ClearAllPoints()
    _G.GuildRecruitmentCommentFrame:SetPoint("TOPLEFT", _G.GuildRecruitmentLevelFrame, "BOTTOMLEFT", 0, 1)

    F.ReskinCheck(_G.GuildRosterShowOfflineButton)
    for i = 1, #_G.GuildNewsFiltersFrame.GuildNewsFilterButtons do
        F.ReskinCheck(_G.GuildNewsFiltersFrame.GuildNewsFilterButtons[i])
    end

    local a1, p, a2, x, y = _G.GuildNewsBossModel:GetPoint()
    _G.GuildNewsBossModel:ClearAllPoints()
    _G.GuildNewsBossModel:SetPoint(a1, p, a2, x+5, y)

    local f = CreateFrame("Frame", nil, _G.GuildNewsBossModel)
    f:SetPoint("TOPLEFT", 0, 1)
    f:SetPoint("BOTTOMRIGHT", 1, -52)
    f:SetFrameLevel(_G.GuildNewsBossModel:GetFrameLevel()-1)
    F.CreateBD(f)

    local line = CreateFrame("Frame", nil, _G.GuildNewsBossModel)
    line:SetPoint("BOTTOMLEFT", 0, -1)
    line:SetPoint("BOTTOMRIGHT", 0, -1)
    line:SetHeight(1)
    line:SetFrameLevel(_G.GuildNewsBossModel:GetFrameLevel()-1)
    F.CreateBD(line, 0)

    _G.GuildNewsFiltersFrame:SetWidth(224)
    _G.GuildNewsFiltersFrame:SetPoint("TOPLEFT", _G.GuildFrame, "TOPRIGHT", 1, -20)
    _G.GuildMemberDetailFrame:SetPoint("TOPLEFT", _G.GuildFrame, "TOPRIGHT", 1, -28)
    _G.GuildLogFrame:SetPoint("TOPLEFT", _G.GuildFrame, "TOPRIGHT", 1, 0)
    _G.GuildTextEditFrame:SetPoint("TOPLEFT", _G.GuildFrame, "TOPRIGHT", 1, 0)

    local GuildInfoFrameApplicantsContainer = _G.GuildInfoFrameApplicantsContainer
    local GuildApplicantButtons = GuildInfoFrameApplicantsContainer.buttons
    for _, button in pairs(GuildApplicantButtons) do
        F.CreateBD(button, .25)
        button.selectedTex:SetTexture(C.media.backdrop)
        button.selectedTex:SetVertexColor(r, g, b, .2)

        local classBG = F.CreateBG(button.class)
        classBG:SetDrawLayer("ARTWORK", -1)
        button.class:SetTexture([[Interface\GLUES\CHARACTERCREATE\UI-CharacterCreate-Classes]])
        button.ring:Hide()

        button.PointsSpentBgGold:Hide()
        local lvlBG = button:CreateTexture(nil, "ARTWORK", 3)
        lvlBG:SetColorTexture(0, 0, 0, 0.5)
        lvlBG:SetHeight(12)
        lvlBG:SetPoint("BOTTOMLEFT", button.class)
        lvlBG:SetPoint("BOTTOMRIGHT", button.class)
        button._auroraLvlBG = lvlBG

        button.level:ClearAllPoints()
        button.level:SetPoint("CENTER", lvlBG)

        button:SetHighlightTexture("")
    end
    local function GuildInfoFrameApplicants_UpdateHook()
        local scrollFrame = GuildInfoFrameApplicantsContainer
        local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)
        local button, index
        for i = 1, #GuildApplicantButtons do
            button = GuildApplicantButtons[i]
            index = offset + i
            local name, _, class = _G.GetGuildApplicantInfo(index)
            if name then
                button.class:SetTexCoord(_G.unpack(Aurora.classIcons[class]))
            end
        end
    end
    _G.hooksecurefunc("GuildInfoFrameApplicants_Update", GuildInfoFrameApplicants_UpdateHook)
    _G.hooksecurefunc(GuildInfoFrameApplicantsContainer, "update", GuildInfoFrameApplicants_UpdateHook)

    _G.GuildFactionBarProgress:SetTexture(C.media.backdrop)
    _G.GuildFactionBarLeft:Hide()
    _G.GuildFactionBarMiddle:Hide()
    _G.GuildFactionBarRight:Hide()
    _G.GuildFactionBarShadow:SetAlpha(0)
    _G.GuildFactionBarBG:Hide()
    _G.GuildFactionBarCap:SetAlpha(0)
    _G.GuildFactionBar.bg = CreateFrame("Frame", nil, _G.GuildFactionFrame)
    _G.GuildFactionBar.bg:SetPoint("TOPLEFT", _G.GuildFactionFrame, -1, -1)
    _G.GuildFactionBar.bg:SetPoint("BOTTOMRIGHT", _G.GuildFactionFrame, -3, 0)
    _G.GuildFactionBar.bg:SetFrameLevel(0)
    F.CreateBD(_G.GuildFactionBar.bg, .25)

    for _, bu in pairs(_G.GuildPerksContainer.buttons) do
        for i = 1, 4 do
            select(i, bu:GetRegions()):SetAlpha(0)
        end

        local bg = F.CreateBDFrame(bu, .25)
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT", 1, -3)
        bg:SetPoint("BOTTOMRIGHT", 0, 4)

        bu.icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(bu.icon)
    end

    _G.GuildPerksContainerButton1:SetPoint("LEFT", -1, 0)

    for _, bu in pairs(_G.GuildRewardsContainer.buttons) do
        bu:SetNormalTexture("")

        bu:SetHighlightTexture("")
        bu.disabledBG:SetTexture("")

        local bg = F.CreateBDFrame(bu, .25)
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT", 1, -1)
        bg:SetPoint("BOTTOMRIGHT", 0, 0)

        bu.icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBG(bu.icon)
    end

    local UpdateIcons = function()
        local index
        local offset = _G.HybridScrollFrame_GetOffset(_G.GuildRosterContainer)
        local totalMembers, _, onlineAndMobileMembers = _G.GetNumGuildMembers()
        local visibleMembers = onlineAndMobileMembers
        local rosterButtons = _G.GuildRosterContainer.buttons
        if _G.GetGuildRosterShowOffline() then
            visibleMembers = totalMembers
        end

        for i = 1, #rosterButtons do
            local bu = rosterButtons[i]

            if not bu.bg then
                bu:SetHighlightTexture(C.media.backdrop)
                bu:GetHighlightTexture():SetVertexColor(r, g, b, .2)

                bu.bg = F.CreateBG(bu.icon)
            end

            index = offset + i
            local name, _, _, _, _, _, _, _, _, _, class  = _G.GetGuildRosterInfo(index)
            if name and index <= visibleMembers and bu.icon:IsShown() then
                bu.icon:SetTexCoord(_G.unpack(Aurora.classIcons[class]))
                bu.bg:Show()
            else
                bu.bg:Hide()
            end
        end
    end

    hooksecurefunc("GuildRoster_Update", UpdateIcons)
    hooksecurefunc(_G.GuildRosterContainer, "update", UpdateIcons)

    F.Reskin(select(4, _G.GuildTextEditFrame:GetChildren()))
    F.Reskin(select(3, _G.GuildLogFrame:GetChildren()))

    local gbuttons = {"GuildAddMemberButton", "GuildViewLogButton", "GuildControlButton", "GuildTextEditFrameAcceptButton", "GuildMemberGroupInviteButton", "GuildMemberRemoveButton", "GuildRecruitmentInviteButton", "GuildRecruitmentMessageButton", "GuildRecruitmentDeclineButton", "GuildRecruitmentListGuildButton"}
    for i = 1, #gbuttons do
        F.Reskin(_G[gbuttons[i]])
    end

    local checkboxes = {"GuildRecruitmentQuestButton", "GuildRecruitmentDungeonButton", "GuildRecruitmentRaidButton", "GuildRecruitmentPvPButton", "GuildRecruitmentRPButton", "GuildRecruitmentWeekdaysButton", "GuildRecruitmentWeekendsButton"}
    for i = 1, #checkboxes do
        F.ReskinCheck(_G[checkboxes[i]])
    end

    F.ReskinCheck(_G.GuildRecruitmentTankButton:GetChildren())
    F.ReskinCheck(_G.GuildRecruitmentHealerButton:GetChildren())
    F.ReskinCheck(_G.GuildRecruitmentDamagerButton:GetChildren())

    F.ReskinRadio(_G.GuildRecruitmentLevelAnyButton)
    F.ReskinRadio(_G.GuildRecruitmentLevelMaxButton)

    F.ReskinTab("GuildInfoFrameTab", 3)
end
