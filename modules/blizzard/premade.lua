local F, C = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')
local TT = F:GetModule('Tooltip')

local applicationViewerFrame = _G.LFGListFrame.ApplicationViewer
local searchPanel = _G.LFGListFrame.SearchPanel
local categorySelection = _G.LFGListFrame.CategorySelection

local LE_PARTY_CATEGORY_HOME = _G.LE_PARTY_CATEGORY_HOME or 1
local scoreFormat = C.GREY_COLOR .. '(%s) |r%s'

function BLIZZARD:HookApplicationClick()
    if _G.LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
        _G.LFGListFrame.SearchPanel.SignUpButton:Click()
    end

    if
        (not IsAltKeyDown())
        and _G.LFGListApplicationDialog:IsShown()
        and _G.LFGListApplicationDialog.SignUpButton:IsEnabled()
    then
        _G.LFGListApplicationDialog.SignUpButton:Click()
    end
end

local pendingFrame
function BLIZZARD:DialogHideInSecond()
    if not pendingFrame then
        return
    end

    if pendingFrame.informational then
        _G.StaticPopupSpecial_Hide(pendingFrame)
    elseif pendingFrame == 'LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS' then
        _G.StaticPopup_Hide(pendingFrame)
    end

    pendingFrame = nil
end

function BLIZZARD:HookDialogOnShow()
    pendingFrame = self
    F:Delay(1, BLIZZARD.DialogHideInSecond)
end

local function HidePvEFrame()
    if _G.PVEFrame:IsShown() then
        _G.HideUIPanel(_G.PVEFrame)
    end
end

local roleCache = {}

local roleOrder = {
    ['TANK'] = 1,
    ['HEALER'] = 2,
    ['DAMAGER'] = 3,
}

local roleIcons = {
    [1] = C.Assets.Texture.Tank,
    [2] = C.Assets.Texture.Healer,
    [3] = C.Assets.Texture.Damager,
}

local function SortRoleOrder(a, b)
    if a and b then
        return a[1] < b[1]
    end
end

local function GetPartyMemberInfo(index)
    local unit = 'player'
    if index > 1 then
        unit = 'party' .. (index - 1)
    end

    local class = select(2, UnitClass(unit))
    if not class then
        return
    end
    local role = UnitGroupRolesAssigned(unit)
    if role == 'NONE' then
        role = 'DAMAGER'
    end
    return role, class
end

local function GetCorrectRoleInfo(frame, i)
    if frame.resultID then
        return C_LFGList.GetSearchResultMemberInfo(frame.resultID, i)
    elseif frame == applicationViewerFrame then
        return GetPartyMemberInfo(i)
    end
end

local function UpdateGroupRoles(self)
    table.wipe(roleCache)

    if not self.__owner then
        self.__owner = self:GetParent():GetParent()
    end

    local count = 0
    for i = 1, 5 do
        local role, class = GetCorrectRoleInfo(self.__owner, i)
        local roleIndex = role and roleOrder[role]
        if roleIndex then
            count = count + 1
            if not roleCache[count] then
                roleCache[count] = {}
            end
            roleCache[count][1] = roleIndex
            roleCache[count][2] = class
            roleCache[count][3] = i == 1
        end
    end

    table.sort(roleCache, SortRoleOrder)
end

local function SetClassIcon(button, class)
    local t = _G.CLASS_ICON_TCOORDS[class]
    if t then
        button:SetTexture(C.Assets.Texture.ClassCircle)
        button:SetTexCoord(unpack(t))
    end
end

function BLIZZARD:ReplaceGroupRoles(numPlayers, _, disabled)
    UpdateGroupRoles(self)

    for i = 1, 5 do
        local icon = self.Icons[i]

        icon:SetSize(26, 26)

        if not icon.role then
            if i == 1 then
                icon:SetPoint('RIGHT', -5, -2)
            else
                icon:ClearAllPoints()
                icon:SetPoint('RIGHT', self.Icons[i - 1], 'LEFT', -1, 0)
            end

            icon.role = self:CreateTexture(nil, 'OVERLAY', nil, 2)
            icon.role:SetSize(14, 14)
            icon.role:SetPoint('TOPLEFT', icon, -4, 2)

            icon.leader = self:CreateTexture(nil, 'OVERLAY', nil, 1)
            icon.leader:SetSize(14, 14)
            icon.leader:SetPoint('TOP', icon, 4, 8)
            icon.leader:SetTexture('Interface\\GroupFrame\\UI-Group-LeaderIcon')
            icon.leader:SetRotation(_G.rad(-15))
        end

        if i > numPlayers then
            icon.role:Hide()
        else
            icon.role:Show()
            icon.role:SetDesaturated(disabled)
            icon.role:SetAlpha(disabled and 0.5 or 1)

            icon.leader:SetDesaturated(disabled)
            icon.leader:SetAlpha(disabled and 0.5 or 1)
        end

        icon.leader:Hide()
    end

    local iconIndex = numPlayers
    for i = 1, #roleCache do
        local roleInfo = roleCache[i]
        if roleInfo then
            local icon = self.Icons[iconIndex]
            icon.role:SetTexture(roleIcons[roleInfo[1]])
            SetClassIcon(icon, roleInfo[2])
            icon:Show()
            icon.leader:SetShown(roleInfo[3])
            iconIndex = iconIndex - 1
        end
    end

    for i = 1, iconIndex do
        self.Icons[i]:Hide()
        self.Icons[i].role:SetTexture('')
    end
end

local factionStr = {
    [0] = 'Horde',
    [1] = 'Alliance',
}

function BLIZZARD:ShowLeaderOverallScore()
    local resultID = self.resultID
    local searchResultInfo = resultID and C_LFGList.GetSearchResultInfo(resultID)
    if searchResultInfo then
        local activityInfo = C_LFGList.GetActivityInfoTable(
            searchResultInfo.activityID,
            nil,
            searchResultInfo.isWarMode
        )
        if activityInfo then
            local showScore = activityInfo.isMythicPlusActivity and searchResultInfo.leaderOverallDungeonScore
                or activityInfo.isRatedPvpActivity
                    and searchResultInfo.leaderPvpRatingInfo
                    and searchResultInfo.leaderPvpRatingInfo.rating
            if showScore then
                local oldName = self.ActivityName:GetText()
                oldName = string.gsub(oldName, '.-' .. _G.HEADER_COLON, '') -- Tazavesh
                self.ActivityName:SetFormattedText(scoreFormat, TT.GetDungeonScore(showScore), oldName)

                if not self.crossFactionLogo then
                    local logo = self:CreateTexture(nil, 'OVERLAY')
                    logo:SetPoint('TOPLEFT', -6, 5)
                    logo:SetSize(24, 24)
                    self.crossFactionLogo = logo
                end
            end
        end

        if self.crossFactionLogo then
            if searchResultInfo.crossFactionListing then
                self.crossFactionLogo:Hide()
            else
                self.crossFactionLogo:SetTexture(
                    'Interface\\Timer\\' .. factionStr[searchResultInfo.leaderFactionGroup] .. '-Logo'
                )
                self.crossFactionLogo:Show()
            end
        end
    end
end

function BLIZZARD:AddAutoAcceptButton()
    local bu = F.CreateCheckbox(searchPanel, true)
    bu:SetSize(20, 20)
    bu:SetHitRectInsets(0, -130, 0, 0)
    bu:SetPoint('RIGHT', searchPanel.RefreshButton, 'LEFT', -130, 0)
    F.CreateFS(bu, C.Assets.Font.Regular, 12, nil, _G.LFG_LIST_AUTO_ACCEPT, 'YELLOW', true, 'LEFT', 24, 0)

    local lastTime = 0
    F:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED', function()
        if not bu:GetChecked() then
            return
        end
        if not UnitIsGroupLeader('player', _G.LE_PARTY_CATEGORY_HOME) then
            return
        end

        local buttons = applicationViewerFrame.ScrollFrame.buttons
        for i = 1, #buttons do
            local button = buttons[i]
            if button.applicantID and button.InviteButton:IsEnabled() then
                button.InviteButton:Click()
            end
        end

        if applicationViewerFrame:IsShown() then
            local now = GetTime()
            if now - lastTime > 1 then
                lastTime = now
                applicationViewerFrame.RefreshButton:Click()
            end
        end
    end)

    hooksecurefunc('LFGListApplicationViewer_UpdateInfo', function(self)
        bu:SetShown(UnitIsGroupLeader('player', LE_PARTY_CATEGORY_HOME) and not self.AutoAcceptButton:IsShown())
    end)
end

function BLIZZARD:ReplaceFindGroupButton()
    if not IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    categorySelection.FindGroupButton:Hide()

    local bu = CreateFrame('Button', nil, categorySelection, 'LFGListMagicButtonTemplate')
    bu:SetText(_G.LFG_LIST_FIND_A_GROUP)
    bu:SetSize(135, 22)
    bu:SetPoint('BOTTOMRIGHT', -3, 4)

    local lastCategory = 0
    bu:SetScript('OnClick', function()
        local selectedCategory = categorySelection.selectedCategory
        if not selectedCategory then
            return
        end

        if lastCategory ~= selectedCategory then
            categorySelection.FindGroupButton:Click()
        else
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            _G.LFGListSearchPanel_SetCategory(
                searchPanel,
                selectedCategory,
                categorySelection.selectedFilters,
                _G.LFGListFrame.baseFilters
            )
            _G.LFGListSearchPanel_DoSearch(searchPanel)
            _G.LFGListFrame_SetActivePanel(_G.LFGListFrame, searchPanel)
        end
        lastCategory = selectedCategory
    end)

    if _G.ANDROMEDA_ADB.ReskinBlizz then
        F.Reskin(bu)
    end
end

function BLIZZARD:AddDungeonsFilter()
    local mapData = {
        [0] = { mapID = 375, aID = 703 }, -- 仙林
        [1] = { mapID = 376, aID = 713 }, -- 通灵
        [2] = { mapID = 377, aID = 695 }, -- 彼界
        [3] = { mapID = 378, aID = 699 }, -- 赎罪
        [4] = { mapID = 379, aID = 691 }, -- 凋魂
        [5] = { mapID = 380, aID = 705 }, -- 赤红
        [6] = { mapID = 381, aID = 709 }, -- 晋升
        [7] = { mapID = 382, aID = 717 }, -- 剧场
        [8] = { mapID = 391, aID = 1016 }, -- 街道
        [9] = { mapID = 392, aID = 1017 }, -- 宏图
    }

    local function GetDungeonNameByID(mapID)
        local name = C_ChallengeMode.GetMapUIInfo(mapID)
        name = string.gsub(name, '.-' .. _G.HEADER_COLON, '') -- abbr Tazavesh
        return name
    end

    local allOn
    local filterIDs = {}

    local function toggleAll()
        allOn = not allOn
        for i = 0, 9 do
            mapData[i].isOn = allOn
            filterIDs[mapData[i].aID] = allOn
        end
        _G.UIDropDownMenu_Refresh(F.EasyMenu)
        _G.LFGListSearchPanel_DoSearch(searchPanel)
    end

    local menuList = {
        [1] = { text = _G.SPECIFIC_DUNGEONS, isTitle = true, notCheckable = true },
        [2] = { text = _G.SWITCH, notCheckable = true, keepShownOnClick = true, func = toggleAll },
    }

    local function onClick(self, index, aID)
        allOn = true
        mapData[index].isOn = not mapData[index].isOn
        filterIDs[aID] = mapData[index].isOn
        _G.LFGListSearchPanel_DoSearch(searchPanel)
    end

    local function onCheck(self)
        return mapData[self.arg1].isOn
    end

    for i = 0, 9 do
        local value = mapData[i]
        menuList[i + 3] = {
            text = GetDungeonNameByID(value.mapID),
            arg1 = i,
            arg2 = value.aID,
            func = onClick,
            checked = onCheck,
            keepShownOnClick = true,
        }
        filterIDs[value.aID] = false
    end

    searchPanel.RefreshButton:HookScript('OnMouseDown', function(self, btn)
        if btn ~= 'RightButton' then
            return
        end
        EasyMenu(menuList, F.EasyMenu, self, 25, 50, 'MENU')
    end)

    searchPanel.RefreshButton:HookScript('OnEnter', function()
        _G.GameTooltip:AddLine(C.MOUSE_RIGHT_BUTTON .. _G.SPECIFIC_DUNGEONS)
        _G.GameTooltip:Show()
    end)

    hooksecurefunc('LFGListUtil_SortSearchResults', function(results)
        if categorySelection.selectedCategory ~= 2 then
            return
        end
        if not allOn then
            return
        end

        for i = #results, 1, -1 do
            local resultID = results[i]
            local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
            local aID = searchResultInfo and searchResultInfo.activityID
            if aID and not filterIDs[aID] then
                table.remove(results, i)
            end
        end
        searchPanel.totalResults = #results

        return true
    end)
end

local function ClickSortButton(self)
    self.__owner.Sorting.SortingExpression:SetText(self.sortStr)
    self.__owner.RefreshButton:Click()
end

local function CreateSortButton(parent, texture, sortStr)
    local bu = F.CreateButton(parent, 24, 24, true, texture)
    bu.sortStr = sortStr
    bu.__owner = parent
    bu:SetScript('OnClick', ClickSortButton)
    F.AddTooltip(bu, 'ANCHOR_RIGHT', _G.CLUB_FINDER_SORT_BY)

    table.insert(parent.__sortBu, bu)
end

function BLIZZARD:AddPGFSortingExpression()
    if not IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    local PGFDialog = _G.PremadeGroupsFilterDialog
    PGFDialog.__sortBu = {}

    CreateSortButton(PGFDialog, 525134, 'mprating desc')
    CreateSortButton(PGFDialog, 1455894, 'pvprating desc')
    CreateSortButton(PGFDialog, 237538, 'age asc')

    for i = 1, #PGFDialog.__sortBu do
        local bu = PGFDialog.__sortBu[i]
        if i == 1 then
            bu:SetPoint('BOTTOMLEFT', PGFDialog, 'BOTTOMRIGHT', 3, 0)
        else
            bu:SetPoint('BOTTOM', PGFDialog.__sortBu[i - 1], 'TOP', 0, 3)
        end
    end
end

-- Fix duplicate application entry
local function Fix(self)
    if next(self.results) and next(self.applications) then
        for _, value in ipairs(self.applications) do
            tDeleteItem(self.results, value)
        end

        self.totalResults = #self.results

        _G.LFGListSearchPanel_UpdateResults(self)
    end
end

function BLIZZARD:EnhancedPremade()
    if not C.DB.General.EnhancedPremade then
        return
    end

    for i = 1, 10 do
        local bu = _G['LFGListSearchPanelScrollFrameButton' .. i]
        if bu then
            bu.Name:SetFontObject(_G.Game14Font)
            bu.ActivityName:SetFontObject(_G.Game12Font)
            bu:HookScript('OnDoubleClick', BLIZZARD.HookApplicationClick)
        end
    end

    hooksecurefunc('LFGListInviteDialog_Accept', HidePvEFrame)
    hooksecurefunc('StaticPopup_Show', BLIZZARD.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', BLIZZARD.HookDialogOnShow)
    hooksecurefunc('LFGListGroupDataDisplayEnumerate_Update', BLIZZARD.ReplaceGroupRoles)
    hooksecurefunc('LFGListSearchEntry_Update', BLIZZARD.ShowLeaderOverallScore)
    hooksecurefunc('LFGListSearchPanel_UpdateResultList', Fix)

    BLIZZARD:AddAutoAcceptButton()
    BLIZZARD:ReplaceFindGroupButton()
    BLIZZARD:AddDungeonsFilter()
    BLIZZARD:AddPGFSortingExpression()
end
