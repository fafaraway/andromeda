local F, C = unpack(select(2, ...))
local M = F:RegisterModule('LFGList')

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

local colors = {}

for i = 1, 5 do
    local r, g, b = GetItemQualityColor(i)
    colors[i] = {r * 255, g * 255, b * 255}
end

colors[6] = {230, 25, 25}

local function gradient(perc, col1, col2)
    local r = col1[1] + perc * (col2[1] - col1[1])
    local g = col1[2] + perc * (col2[2] - col1[2])
    local b = col1[3] + perc * (col2[3] - col1[3])
    return string.format('|cff%02x%02x%02x', r, g, b)
end

local function scoreToColor(score)
    local perc = score / 4500
    if perc > 1 then
        perc = 1
    end

    local brackets = 1 / (table.getn(colors) - 1)
    local currentBracket = math.ceil(perc / brackets)
    local relativePerc = perc / brackets - (currentBracket - 1)
    return gradient(relativePerc, colors[currentBracket], colors[currentBracket + 1])
end

local function scale(x)
    local e = 0.1123091
    local d = 0.7474169 * x
    local c = 0.00002814465 * x * x
    local b = 3.144654e-9 * x * x * x
    local a = 2.578616e-11 * x * x * x * x
    return math.floor(a + b + c + d + e)
end

local function shortenScore(score)
    if not C.DB.General.ShortenScore then
        return score
    end

    score = math.floor((score + 50) / 100)
    return score / 10.0 .. 'k'
end

local escapes = {
    ['|c%x%x%x%x%x%x%x%x'] = '', -- color start
    ['|r'] = '', -- color end
    ['|H.-|h(.-)|h'] = '%1', -- links
    ['|T.-|t'] = '', -- textures
    ['{.-}'] = '' -- raid target icons
}

local function unescape(str)
    for k, v in pairs(escapes) do
        str = string.gsub(str, k, v)
    end
    return str
end

local function getDisplayScore(score)
    return score
end

local UpdateApplicantMember = function(member)
    local score = tonumber(unescape(member.DungeonScore:GetText()))
    if score == 0 then
        return
    end

    local scaled = scale(score)
    local displayScore = getDisplayScore(score)
    local replacementString = string.format('%s%s\124r', scoreToColor(scaled), shortenScore(displayScore))
    member.DungeonScore:SetText(replacementString)
end

local SearchEntry_Update = function(group)
    local result = C_LFGList.GetSearchResultInfo(group.resultID)
    local categoryID = select(3, C_LFGList.GetActivityInfo(result.activityID))

    if categoryID ~= 2 then
        return
    end

    local score = result.leaderOverallDungeonScore
    if score == nil or score <= 0 then
        return
    end

    local scaled = scale(result.leaderOverallDungeonScore)
    local displayScore = getDisplayScore(score)
    local newGrpText = string.format('%s(%s)\124r %s', scoreToColor(scaled), shortenScore(displayScore), group.Name:GetText())
    group.Name:SetText(newGrpText)
end

local function HidePvEFrame()
    if _G.PVEFrame:IsShown() then
        _G.HideUIPanel(_G.PVEFrame)
    end
end

function M:OnLogin()
    if not C.DB.General.EnhancedLFGList then
        return
    end

    for i = 1, 10 do
        local bu = _G['LFGListSearchPanelScrollFrameButton' .. i]
        if bu then
            bu:HookScript('OnDoubleClick', M.HookApplicationClick)
        end
    end

    hooksecurefunc('LFGListInviteDialog_Accept', HidePvEFrame)

    hooksecurefunc('StaticPopup_Show', M.HookDialogOnShow)
    hooksecurefunc('LFGListInviteDialog_Show', M.HookDialogOnShow)
    hooksecurefunc('LFGListGroupDataDisplayEnumerate_Update', M.ReplaceGroupRoles)

    -- hooksecurefunc('LFGListApplicationViewer_UpdateApplicantMember', UpdateApplicantMember)
    hooksecurefunc('LFGListSearchEntry_Update', SearchEntry_Update)
end
