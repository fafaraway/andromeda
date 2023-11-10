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

    if (not IsAltKeyDown()) and _G.LFGListApplicationDialog:IsShown() and _G.LFGListApplicationDialog.SignUpButton:IsEnabled() then
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
    [1] = C.Assets.Textures.RoleTank,
    [2] = C.Assets.Textures.RoleHealer,
    [3] = C.Assets.Textures.RoleDamager,
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

    return role, class, UnitIsGroupLeader(unit)
end

local function GetCorrectRoleInfo(frame, i)
    if frame.resultID then
        local role, class = C_LFGList.GetSearchResultMemberInfo(frame.resultID, i)
        return role, class, i == 1
    elseif frame == applicationViewerFrame then
        return GetPartyMemberInfo(i)
    end
end

local function UpdateGroupRoles(self)
    wipe(roleCache)

    if not self.__owner then
        self.__owner = self:GetParent():GetParent()
    end

    local count = 0
    for i = 1, 5 do
        local role, class, isLeader = GetCorrectRoleInfo(self.__owner, i)
        local roleIndex = role and roleOrder[role]
        if roleIndex then
            count = count + 1
            if not roleCache[count] then
                roleCache[count] = {}
            end
            roleCache[count][1] = roleIndex
            roleCache[count][2] = class
            roleCache[count][3] = isLeader
        end
    end

    sort(roleCache, SortRoleOrder)
end

local function SetClassIcon(button, class)
    local t = _G.CLASS_ICON_TCOORDS[class]
    if t then
        button:SetTexture(C.Assets.Textures.CircleClassIcons)
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
            icon.role:SetSize(22, 22)
            icon.role:SetPoint('TOPLEFT', icon, -8, 8)

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
        local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID, nil, searchResultInfo.isWarMode)
        if activityInfo then
            local showScore = activityInfo.isMythicPlusActivity and searchResultInfo.leaderOverallDungeonScore
                or activityInfo.isRatedPvpActivity and searchResultInfo.leaderPvpRatingInfo and searchResultInfo.leaderPvpRatingInfo.rating
            if showScore then
                local oldName = self.ActivityName:GetText()
                oldName = gsub(oldName, '.-' .. _G.HEADER_COLON, '') -- Tazavesh
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
                self.crossFactionLogo:SetTexture('Interface\\Timer\\' .. factionStr[searchResultInfo.leaderFactionGroup] .. '-Logo')
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

    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.CreateFS(bu, C.Assets.Fonts.Regular, 12, outline or nil, _G.LFG_LIST_AUTO_ACCEPT, 'YELLOW', outline and 'NONE' or 'THICK', 'LEFT', 24, 0)

    local lastTime = 0
    local function clickInviteButton(button)
        if button.applicantID and button.InviteButton:IsEnabled() then
            button.InviteButton:Click()
        end
    end

    F:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED', function()
        if not bu:GetChecked() then
            return
        end
        if not UnitIsGroupLeader('player', _G.LE_PARTY_CATEGORY_HOME) then
            return
        end

        _G.ApplicationViewerFrame.ScrollBox:ForEachFrame(clickInviteButton)

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
            _G.LFGListSearchPanel_SetCategory(searchPanel, selectedCategory, categorySelection.selectedFilters, _G.LFGListFrame.baseFilters)
            _G.LFGListSearchPanel_DoSearch(searchPanel)
            _G.LFGListFrame_SetActivePanel(_G.LFGListFrame, searchPanel)
        end
        lastCategory = selectedCategory
    end)

    if _G.ANDROMEDA_ADB.ReskinBlizz then
        F.ReskinButton(bu)
    end
end

function BLIZZARD:AddDungeonsFilter()
    local mapData = {
        -- S1
        [0] = { mapID = 2, aID = 1192 }, -- 青龙寺
        [1] = { mapID = 165, aID = 1193 }, -- 影月谷
        [2] = { mapID = 200, aID = 461 }, -- 英灵殿
        [3] = { mapID = 210, aID = 466 }, -- 群星庭院
        [4] = { mapID = 399, aID = 1176 }, -- 红玉新生法池
        [5] = { mapID = 400, aID = 1184 }, -- 诺库德狙击战
        [6] = { mapID = 401, aID = 1180 }, -- 碧蓝魔馆
        [7] = { mapID = 402, aID = 1160 }, -- 艾杰斯亚学院

        -- S2
        -- [4] = { mapID = 403, aID = 1188 }, -- 奥丹姆：提尔的遗产
        -- [5] = { mapID = 404, aID = 1172 }, -- 奈萨鲁斯
        -- [6] = { mapID = 405, aID = 1164 }, -- 蕨皮山谷
        -- [7] = { mapID = 406, aID = 1168 }, -- 注能大厅
    }

    local function GetDungeonNameByID(mapID)
        local name = C_ChallengeMode.GetMapUIInfo(mapID)
        name = gsub(name, '.-' .. _G.HEADER_COLON, '') -- abbr Tazavesh
        return name
    end

    local allOn
    local filterIDs = {}

    local function toggleAll()
        allOn = not allOn
        for i = 0, 7 do
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

    for i = 0, 7 do
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
                tremove(results, i)
            end
        end
        searchPanel.totalResults = #results

        return true
    end)
end

local function ClickSortButton(self)
    self.__owner.Sorting.Expression:SetText(self.sortStr)
    self.__parent.RefreshButton:Click()
end

local function CreateSortButton(parent, texture, sortStr, panel)
    local bu = F.CreateButton(parent, 24, 24, true, texture)
    bu.sortStr = sortStr
    bu.__parent = parent
    bu.__owner = panel
    bu:SetScript('OnClick', ClickSortButton)
    F.AddTooltip(bu, 'ANCHOR_RIGHT', _G.CLUB_FINDER_SORT_BY)

    tinsert(parent.__sortBu, bu)
end

function BLIZZARD:AddPGFSortingExpression()
    if not IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    local PGFDialog = _G.PremadeGroupsFilterDialog
    local ExpressionPanel = _G.PremadeGroupsFilterMiniPanel
    PGFDialog.__sortBu = {}

    CreateSortButton(PGFDialog, 525134, 'mprating desc', ExpressionPanel)
    CreateSortButton(PGFDialog, 1455894, 'pvprating desc', ExpressionPanel)
    CreateSortButton(PGFDialog, 237538, 'age asc', ExpressionPanel)

    for i = 1, #PGFDialog.__sortBu do
        local bu = PGFDialog.__sortBu[i]
        if i == 1 then
            bu:SetPoint('BOTTOMLEFT', PGFDialog, 'BOTTOMRIGHT', 3, 0)
        else
            bu:SetPoint('BOTTOM', PGFDialog.__sortBu[i - 1], 'TOP', 0, 3)
        end
    end

    if _G.PremadeGroupsFilterSettings then
        _G.PremadeGroupsFilterSettings.classBar = false
        _G.PremadeGroupsFilterSettings.classCircle = false
        _G.PremadeGroupsFilterSettings.leaderCrown = false
        _G.PremadeGroupsFilterSettings.ratingInfo = false
        _G.PremadeGroupsFilterSettings.oneClickSignUp = false
    end
end

-- Fix LFG taint
-- Credit: PremadeGroupsFilter

function BLIZZARD:FixListingTaint()
    if IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    local activityIdOfArbitraryMythicPlusDungeon = 1160 -- Algeth'ar Academy
    if not C_LFGList.IsPlayerAuthenticatedForLFG(activityIdOfArbitraryMythicPlusDungeon) then
        return
    end

    C_LFGList.GetPlaystyleString = function(playstyle, activityInfo)
        if not (activityInfo and playstyle and playstyle ~= 0 and C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown) then
            return nil
        end
        local globalStringPrefix
        if activityInfo.isMythicPlusActivity then
            globalStringPrefix = 'GROUP_FINDER_PVE_PLAYSTYLE'
        elseif activityInfo.isRatedPvpActivity then
            globalStringPrefix = 'GROUP_FINDER_PVP_PLAYSTYLE'
        elseif activityInfo.isCurrentRaidActivity then
            globalStringPrefix = 'GROUP_FINDER_PVE_RAID_PLAYSTYLE'
        elseif activityInfo.isMythicActivity then
            globalStringPrefix = 'GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE'
        end
        return globalStringPrefix and _G[globalStringPrefix .. tostring(playstyle)] or nil
    end

    -- Disable automatic group titles to prevent tainting errors
    _G.LFGListEntryCreation_SetTitleFromActivityInfo = function(_) end
end

-- Show groups created by Chinese players

function BLIZZARD:AddCNFilter()
    local filters = C_LFGList.GetAvailableLanguageSearchFilter() or {}

    for i = 1, #filters do
        if filters[i] == 'zhCN' then
            return
        end
    end

    tinsert(filters, 'zhCN')

    C_LFGList.GetAvailableLanguageSearchFilter = function()
        return filters
    end
end

function BLIZZARD:EnhancedPremade()
    if not C.DB.General.EnhancedPremade then
        return
    end

    hooksecurefunc(_G.LFGListFrame.SearchPanel.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if child.Name and not child.hooked then
                child.Name:SetFontObject(_G.Game14Font)
                child.ActivityName:SetFontObject(_G.Game12Font)
                child:HookScript('OnDoubleClick', BLIZZARD.HookApplicationClick)

                child.hooked = true
            end
        end
    end)

    hooksecurefunc('LFGListInviteDialog_Accept', HidePvEFrame)
    hooksecurefunc('StaticPopup_Show', BLIZZARD.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', BLIZZARD.HookDialogOnShow)
    hooksecurefunc('LFGListGroupDataDisplayEnumerate_Update', BLIZZARD.ReplaceGroupRoles)
    hooksecurefunc('LFGListSearchEntry_Update', BLIZZARD.ShowLeaderOverallScore)

    BLIZZARD:AddAutoAcceptButton()
    BLIZZARD:ReplaceFindGroupButton()
    BLIZZARD:AddDungeonsFilter()
    BLIZZARD:AddPGFSortingExpression()
    BLIZZARD:FixListingTaint()
    BLIZZARD:AddCNFilter()
end
