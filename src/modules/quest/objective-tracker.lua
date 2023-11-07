local F, C, L = unpack(select(2, ...))
local EOT = F:RegisterModule('EnhancedObjectiveTracker')

local progressColors = {
    start = { r = 1.000, g = 0.647, b = 0.008 },
    complete = { r = 0.180, g = 0.835, b = 0.451 },
}

local function SetTextColorHook(text)
    if not text.Hooked then
        local SetTextColorOld = text.SetTextColor
        text.SetTextColor = function(self, r, g, b, a)
            if r == _G.OBJECTIVE_TRACKER_COLOR['Header'].r and g == _G.OBJECTIVE_TRACKER_COLOR['Header'].g and b == _G.OBJECTIVE_TRACKER_COLOR['Header'].b then
                r = 216 / 255
                g = 197 / 255
                b = 136 / 255
            elseif r == _G.OBJECTIVE_TRACKER_COLOR['HeaderHighlight'].r and g == _G.OBJECTIVE_TRACKER_COLOR['HeaderHighlight'].g and b == _G.OBJECTIVE_TRACKER_COLOR['HeaderHighlight'].b then
                r = 216 / 255
                g = 181 / 255
                b = 136 / 255
            end
            SetTextColorOld(self, r, g, b, a)
        end
        text:SetTextColor(_G.OBJECTIVE_TRACKER_COLOR['Header'].r, _G.OBJECTIVE_TRACKER_COLOR['Header'].g, _G.OBJECTIVE_TRACKER_COLOR['Header'].b, 1)
        text.Hooked = true
    end
end

local function GetProgressColor(progress)
    local r = (progressColors.complete.r - progressColors.start.r) * progress + progressColors.start.r
    local g = (progressColors.complete.g - progressColors.start.g) * progress + progressColors.start.g
    local b = (progressColors.complete.r - progressColors.start.b) * progress + progressColors.start.b

    local addition = 0.35
    r = min(r + abs(0.5 - progress) * addition, r)
    g = min(g + abs(0.5 - progress) * addition, g)
    b = min(b + abs(0.5 - progress) * addition, b)

    return { r = r, g = g, b = b }
end

function EOT:HandleHeaderText()
    local frame = _G.ObjectiveTrackerFrame.MODULES
    if not frame then
        return
    end

    local outline = _G.ANDROMEDA_ADB.FontOutline
    for i = 1, #frame do
        local modules = frame[i]
        if modules and modules.Header and modules.Header.Text then
            F.SetFS(modules.Header.Text, C.Assets.Fonts.Header, 15, outline or nil, nil, 'CLASS', outline and 'NONE' or 'THICK')
        end
    end
end

function EOT:HandleTitleText(text)
    local font = C.Assets.Fonts.Bold
    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.SetFS(text, font, 14, outline or nil, nil, 'YELLOW', outline and 'NONE' or 'THICK')

    local height = text:GetStringHeight() + 2
    if height ~= text:GetHeight() then
        text:SetHeight(height)
    end

    SetTextColorHook(text)
end

function EOT:HandleInfoText(text)
    self:ColorfulProgression(text)

    local font = C.Assets.Fonts.Regular
    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.SetFS(text, font, 13, outline or nil, nil, nil, outline and 'NONE' or 'THICK')
    text:SetHeight(text:GetStringHeight())

    local line = text:GetParent()
    local dash = line.Dash or line.Icon

    dash:Hide()
    text:ClearAllPoints()
    text:SetPoint('TOPLEFT', dash, 'TOPLEFT', 0, 0)
end

function EOT:ScenarioObjectiveBlock_UpdateCriteria()
    if _G.ScenarioObjectiveBlock then
        local childs = { _G.ScenarioObjectiveBlock:GetChildren() }
        for _, child in pairs(childs) do
            if child.Text then
                EOT:HandleInfoText(child.Text)
            end
        end
    end
end

function EOT:ColorfulProgression(text)
    if not text then
        return
    end

    local info = text:GetText()
    if not info then
        return
    end

    local current, required, details = strmatch(info, '^(%d-)/(%d-) (.+)')

    if not (current and required and details) then
        details, current, required = strmatch(info, '(.+): (%d-)/(%d-)$')
    end

    if not (current and required and details) then
        return
    end

    local progress = tonumber(current) / tonumber(required)

    info = F:CreateColorString(current .. '/' .. required, GetProgressColor(progress))
    info = info .. ' ' .. details

    text:SetText(info)
end

do
    local dash = _G.OBJECTIVE_TRACKER_DASH_WIDTH
    function EOT:UpdateTextWidth()
        _G.OBJECTIVE_TRACKER_DASH_WIDTH = dash
    end
end

function EOT:RestyleObjectiveTrackerText()
    self:UpdateTextWidth()

    local trackerModules = {
        _G.UI_WIDGET_TRACKER_MODULE,
        _G.BONUS_OBJECTIVE_TRACKER_MODULE,
        _G.WORLD_QUEST_TRACKER_MODULE,
        _G.CAMPAIGN_QUEST_TRACKER_MODULE,
        _G.QUEST_TRACKER_MODULE,
        _G.ACHIEVEMENT_TRACKER_MODULE,
        _G.MONTHLY_ACTIVITIES_TRACKER_MODULE,
    }

    for _, module in pairs(trackerModules) do
        hooksecurefunc(module, 'AddObjective', function(_, block)
            if not block then
                return
            end

            if block.HeaderText then
                EOT:HandleTitleText(block.HeaderText)
            end

            if block.currentLine then
                if block.currentLine.objectiveKey == 0 then -- 世界任务标题
                    EOT:HandleTitleText(block.currentLine.Text)
                else
                    EOT:HandleInfoText(block.currentLine.Text)
                end
            end
        end)
    end

    hooksecurefunc('ObjectiveTracker_Update', EOT.HandleHeaderText)
    hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, 'UpdateCriteria', EOT.ScenarioObjectiveBlock_UpdateCriteria)

    F.Delay(1, function()
        for _, child in pairs({ _G.ObjectiveTrackerBlocksFrame:GetChildren() }) do
            if child and child.HeaderText then
                SetTextColorHook(child.HeaderText)
            end
        end
    end)

    ObjectiveTracker_Update()
end

local headers = {
    _G.SCENARIO_CONTENT_TRACKER_MODULE,
    _G.BONUS_OBJECTIVE_TRACKER_MODULE,
    _G.UI_WIDGET_TRACKER_MODULE,
    _G.CAMPAIGN_QUEST_TRACKER_MODULE,
    _G.QUEST_TRACKER_MODULE,
    _G.ACHIEVEMENT_TRACKER_MODULE,
    _G.WORLD_QUEST_TRACKER_MODULE,
    _G.MONTHLY_ACTIVITIES_TRACKER_MODULE,
}

function EOT:AutoCollapse()
    F:Delay(1, function()
        local inInstance, instanceType = IsInInstance()
        if inInstance then
            if instanceType == 'party' or instanceType == 'scenario' then
                for i = 3, #headers do
                    local button = headers[i].Header.MinimizeButton
                    if button and not headers[i].collapsed then
                        button:Click()
                    end
                end
            else
                ObjectiveTracker_Collapse()
            end
        else
            if not InCombatLockdown() then
                for i = 3, #headers do
                    local button = headers[i].Header.MinimizeButton
                    if button and headers[i].collapsed then
                        button:Click()
                    end
                end
                if _G.ObjectiveTrackerFrame.collapsed then
                    ObjectiveTracker_Expand()
                end
            end
        end
    end)
end

function EOT:ObjectiveTrackerMover()
    local frame = CreateFrame('Frame', 'ObjectiveTrackerMover', _G.UIParent)
    frame:SetSize(240, 50)

    F.Mover(frame, L['ObjectiveTracker'], 'ObjectiveTracker', { 'TOPRIGHT', _G.UIParent, 'TOPRIGHT', -C.UI_GAP, -60 })

    local tracker = _G.ObjectiveTrackerFrame
    tracker:ClearAllPoints()
    tracker:SetPoint('TOPRIGHT', frame)
    tracker:SetHeight(C.SCREEN_HEIGHT / 1.5 * C.MULT)
    tracker:SetScale(1)
    tracker:SetClampedToScreen(false)
    tracker:SetMovable(true)

    if tracker:IsMovable() then
        tracker:SetUserPlaced(true)
    end

    F:DisableEditMode(tracker)

    hooksecurefunc(tracker, 'SetPoint', function(self, _, parent)
        if parent ~= frame then
            self:ClearAllPoints()
            self:SetPoint('TOPRIGHT', frame)
        end
    end)
end

function EOT:OnLogin()
    EOT:ObjectiveTrackerMover()
    EOT:RestyleObjectiveTrackerText()

    -- Kill reward animation when finished dungeon or bonus objectives
    _G.ObjectiveTrackerScenarioRewardsFrame.Show = nop

    -- hooksecurefunc('BonusObjectiveTracker_AnimateReward', function()
    --     _G.ObjectiveTrackerBonusRewardsFrame:ClearAllPoints()
    --     _G.ObjectiveTrackerBonusRewardsFrame:SetPoint('BOTTOM', _G.UIParent, 'TOP', 0, 90)
    -- end)

    -- Auto collapse Objective Tracker
    if C.DB.Quest.AutoCollapseTracker then
        F:RegisterEvent('PLAYER_ENTERING_WORLD', EOT.AutoCollapse)
    end
end
