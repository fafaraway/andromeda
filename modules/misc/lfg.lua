local F, C = unpack(select(2, ...))
local M = F:NewModule('LFGList')

function M:HookApplicationClick()
    if _G.LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
        _G.LFGListFrame.SearchPanel.SignUpButton:Click()
    end

    if _G.LFGListApplicationDialog:IsShown() and _G.LFGListApplicationDialog.SignUpButton:IsEnabled() then
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

local roleCache = {}

local roleOrder = {
    ['TANK'] = 1,
    ['HEALER'] = 2,
    ['DAMAGER'] = 3
}

local roleIcons = {
    [1] = C.Assets.Textures.Tank,
    [2] = C.Assets.Textures.Healer,
    [3] = C.Assets.Textures.Damager
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
        end
    end

    table.sort(roleCache, SortRoleOrder)
end

local function SetClassIcon(button, class)
    local t = _G.CLASS_ICON_TCOORDS[class]
    if t then
        button:SetTexture(C.Assets.Textures.Class)
        button:SetTexCoord(unpack(t))
    end
end

function M:ReplaceGroupRoles(numPlayers, _, disabled)
    UpdateGroupRoles(self)

    for i = 1, 5 do
        local icon = self.Icons[i]

        icon:Size(26)

        if not icon.role then
            if i == 1 then
                icon:SetPoint('RIGHT', -5, -2)
            else
                icon:ClearAllPoints()
                icon:SetPoint('RIGHT', self.Icons[i - 1], 'LEFT', -1, 0)
            end

            icon.role = self:CreateTexture(nil, 'OVERLAY')
            icon.role:SetSize(14, 14)
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
            icon.role:SetTexture(roleIcons[roleInfo[1]])
            SetClassIcon(icon, roleInfo[2])
            icon:Show()

            iconIndex = iconIndex - 1
        end
    end

    for i = 1, iconIndex do
        self.Icons[i]:Hide()
        self.Icons[i].role:SetTexture('')
    end
end

function M:OnEnable()
    for i = 1, 10 do
        local bu = _G['LFGListSearchPanelScrollFrameButton' .. i]
        if bu then
            bu:HookScript('OnDoubleClick', M.HookApplicationClick)
        end
    end

    hooksecurefunc(
        'LFGListInviteDialog_Accept',
        function()
            if _G.PVEFrame:IsShown() then
                _G.HideUIPanel(_G.PVEFrame)
            end
        end
    )

    hooksecurefunc('StaticPopup_Show', M.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', M.HookDialogOnShow)
    hooksecurefunc('LFGListGroupDataDisplayEnumerate_Update', M.ReplaceGroupRoles)
end
--F:RegisterModule(M:GetName())
