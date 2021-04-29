--[[
    优化系统自带的预创建功能
    修复简中语系的一个报错
    双击搜索结果，快速申请
    自动隐藏部分窗口
    Credit NDui
]]

local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local sort = sort
local hooksecurefunc = hooksecurefunc
local HideUIPanel = HideUIPanel
local StaticPopup_Hide = StaticPopup_Hide
local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
local C_Timer_After = C_Timer.After
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local LFG_LIST_GROUP_DATA_ATLASES = LFG_LIST_GROUP_DATA_ATLASES
local UnitClass = UnitClass
local UnitGroupRolesAssigned = UnitGroupRolesAssigned

local F = unpack(select(2, ...))
local QJ = F:RegisterModule('QuickJoin')

function QJ:HookApplicationClick()
    if _G.LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
        _G.LFGListFrame.SearchPanel.SignUpButton:Click()
    end

    if _G.LFGListApplicationDialog:IsShown() and _G.LFGListApplicationDialog.SignUpButton:IsEnabled() then
        _G.LFGListApplicationDialog.SignUpButton:Click()
    end
end

local pendingFrame
function QJ:DialogHideInSecond()
    if not pendingFrame then
        return
    end

    if pendingFrame.informational then
        StaticPopupSpecial_Hide(pendingFrame)
    elseif pendingFrame == 'LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS' then
        StaticPopup_Hide(pendingFrame)
    end

    pendingFrame = nil
end

function QJ:HookDialogOnShow()
    pendingFrame = self
    C_Timer_After(1, QJ.DialogHideInSecond)
end

local roleCache = {}
local roleOrder = {['TANK'] = 1, ['HEALER'] = 2, ['DAMAGER'] = 3}
local roleAtlas = {[1] = 'groupfinder-icon-role-large-tank', [2] = 'groupfinder-icon-role-large-heal', [3] = 'groupfinder-icon-role-large-dps'}

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
        return C_LFGList_GetSearchResultMemberInfo(frame.resultID, i)
    elseif frame == _G.ApplicationViewerFrame then
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
        local role, class = GetCorrectRoleInfo(self.__owner, i)
        local roleIndex = role and roleOrder[role]
        if roleIndex then
            count = count + 1
            if not roleCache[count] then
                roleCache[count] = {}
            end
            roleCache[count][1] = roleIndex
            roleCache[count][2] = class
        end
    end

    sort(roleCache, SortRoleOrder)
end

function QJ:ReplaceGroupRoles(numPlayers, _, disabled)
    UpdateGroupRoles(self)

    for i = 1, 5 do
        local icon = self.Icons[i]
        if not icon.role then
            if i == 1 then
                icon:SetPoint('RIGHT', -5, -2)
            else
                icon:ClearAllPoints()
                icon:SetPoint('RIGHT', self.Icons[i - 1], 'LEFT', 2, 0)
            end
            icon:SetSize(26, 26)

            icon.role = self:CreateTexture(nil, 'OVERLAY')
            icon.role:SetSize(17, 17)
            icon.role:SetPoint('TOPLEFT', icon, -4, 5)
        end

        if i > numPlayers then
            icon.role:Hide()
        else
            icon.role:Show()
            icon.role:SetDesaturated(disabled)
            icon.role:SetAlpha(disabled and .5 or 1)
        end
    end

    local iconIndex = numPlayers
    for i = 1, #roleCache do
        local roleInfo = roleCache[i]
        if roleInfo then
            local icon = self.Icons[iconIndex]
            icon:SetAtlas(LFG_LIST_GROUP_DATA_ATLASES[roleInfo[2]])
            icon.role:SetAtlas(roleAtlas[roleInfo[1]])
            iconIndex = iconIndex - 1
        end
    end

    for i = 1, iconIndex do
        self.Icons[i].role:SetAtlas(nil)
    end
end

function QJ:OnLogin()
    for i = 1, 10 do
        local bu = _G['LFGListSearchPanelScrollFrameButton' .. i]
        if bu then
            bu:HookScript('OnDoubleClick', QJ.HookApplicationClick)
        end
    end

    hooksecurefunc('LFGListInviteDialog_Accept', function()
        if _G.PVEFrame:IsShown() then
            HideUIPanel(_G.PVEFrame)
        end
    end)

    hooksecurefunc('StaticPopup_Show', QJ.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', QJ.HookDialogOnShow)
    hooksecurefunc('LFGListGroupDataDisplayEnumerate_Update', QJ.ReplaceGroupRoles)
end
