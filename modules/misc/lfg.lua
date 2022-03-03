local F, C = unpack(select(2, ...))
local M = F:RegisterModule('LFGList')
local TT = F:GetModule('Tooltip')

local LE_PARTY_CATEGORY_HOME = _G.LE_PARTY_CATEGORY_HOME or 1
local scoreFormat = C.GreyColor .. '(%s) |r%s'

function M:HookApplicationClick()
    if _G.LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
        _G.LFGListFrame.SearchPanel.SignUpButton:Click()
    end

    if (not IsAltKeyDown()) and _G.LFGListApplicationDialog:IsShown() and _G.LFGListApplicationDialog.SignUpButton:IsEnabled() then
        _G.LFGListApplicationDialog.SignUpButton:Click()
    end
end

local pendingFrame
function M:DialogHideInSecond()
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

function M:HookDialogOnShow()
    pendingFrame = self
    F:Delay(1, M.DialogHideInSecond)
end

local function HidePvEFrame()
    if _G.PVEFrame:IsShown() then
        _G.HideUIPanel(_G.PVEFrame)
    end
end

local roleCache = {}

local roleOrder = {['TANK'] = 1, ['HEALER'] = 2, ['DAMAGER'] = 3}

local roleIcons = {[1] = C.Assets.Textures.RoleTank, [2] = C.Assets.Textures.RoleHealer, [3] = C.Assets.Textures.RoleDamager}

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
    elseif frame == _G.ApplicationViewerFrame then
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
        button:SetTexture(C.Assets.Textures.ClassesCircles)
        button:SetTexCoord(unpack(t))
    end
end

function M:ReplaceGroupRoles(numPlayers, _, disabled)
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

            icon.role = self:CreateTexture(nil, 'OVERLAY')
            icon.role:SetSize(14, 14)
            icon.role:SetPoint('TOPLEFT', icon, -6, 2)

            icon.leader = self:CreateTexture(nil, 'OVERLAY')
            icon.leader:SetSize(14, 14)
            icon.leader:SetPoint('TOP', icon, 0, 8)
            icon.leader:SetTexture('Interface\\GroupFrame\\UI-Group-LeaderIcon')
            -- icon.leader:SetRotation(_G.rad(-15))
        end

        if i > numPlayers then
            icon.role:Hide()
        else
            icon.role:Show()
            icon.role:SetDesaturated(disabled)
            icon.role:SetAlpha(disabled and .5 or 1)

            icon.leader:SetDesaturated(disabled)
            icon.leader:SetAlpha(disabled and .5 or 1)
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

function M:ShowLeaderOverallScore()
    local resultID = self.resultID
    local searchResultInfo = resultID and C_LFGList.GetSearchResultInfo(resultID)
    if searchResultInfo then
        local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID, nil, searchResultInfo.isWarMode)
        local leaderOverallScore = searchResultInfo.leaderOverallDungeonScore
        if activityInfo and activityInfo.isMythicPlusActivity and leaderOverallScore then
            local oldName = self.ActivityName:GetText()
            oldName = string.gsub(oldName, '.-' .. _G.HEADER_COLON, '') -- Tazavesh
            self.ActivityName:SetFormattedText(scoreFormat, TT.GetDungeonScore(leaderOverallScore), oldName)
        end
    end
end

function M:AddAutoAcceptButton()
    local bu = F.CreateCheckbox(_G.LFGListFrame.SearchPanel, true)
    bu:SetSize(20, 20)
    bu:SetHitRectInsets(0, -130, 0, 0)
    bu:SetPoint('RIGHT', _G.LFGListFrame.SearchPanel.RefreshButton, 'LEFT', -130, 0)
    F.CreateFS(bu, C.Assets.Fonts.Regular, 12, nil, _G.LFG_LIST_AUTO_ACCEPT, 'YELLOW', true, 'LEFT', 24, 0)

    local lastTime = 0
    F:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED', function()
        if not bu:GetChecked() then
            return
        end
        if not UnitIsGroupLeader('player', _G.LE_PARTY_CATEGORY_HOME) then
            return
        end

        local buttons = _G.ApplicationViewerFrame.ScrollFrame.buttons
        for i = 1, #buttons do
            local button = buttons[i]
            if button.applicantID and button.InviteButton:IsEnabled() then
                button.InviteButton:Click()
            end
        end

        if _G.ApplicationViewerFrame:IsShown() then
            local now = GetTime()
            if now - lastTime > 1 then
                lastTime = now
                _G.ApplicationViewerFrame.RefreshButton:Click()
            end
        end
    end)

    hooksecurefunc('LFGListApplicationViewer_UpdateInfo', function(self)
        bu:SetShown(UnitIsGroupLeader('player', LE_PARTY_CATEGORY_HOME) and not self.AutoAcceptButton:IsShown())
    end)
end

do -- Fix duplicate application entry
    hooksecurefunc('LFGListSearchPanel_UpdateResultList', function(self)
        if next(self.results) and next(self.applications) then
            for _, value in ipairs(self.applications) do
                tDeleteItem(self.results, value)
            end

            self.totalResults = #self.results

            _G.LFGListSearchPanel_UpdateResults(self)
        end
    end)
end

function M:OnLogin()
    if not C.DB.General.EnhancedLFGList then
        return
    end

    for i = 1, 10 do
        local bu = _G['LFGListSearchPanelScrollFrameButton' .. i]
        if bu then
            bu.Name:SetFontObject(_G.Game14Font)
            bu.ActivityName:SetFontObject(_G.Game12Font)
            bu:HookScript('OnDoubleClick', M.HookApplicationClick)
        end
    end

    hooksecurefunc('LFGListInviteDialog_Accept', HidePvEFrame)
    hooksecurefunc('StaticPopup_Show', M.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', M.HookDialogOnShow)
    hooksecurefunc('LFGListGroupDataDisplayEnumerate_Update', M.ReplaceGroupRoles)
    hooksecurefunc('LFGListSearchEntry_Update', M.ShowLeaderOverallScore)

    M:AddAutoAcceptButton()
end
