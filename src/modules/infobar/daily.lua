local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

-- TimeWalker
local isTimeWalker, walkerTexture
local function CheckTimeWalker(event)
    local date = C_DateAndTime.GetCurrentCalendarTime()
    C_Calendar.SetAbsMonth(date.month, date.year)
    C_Calendar.OpenCalendar()

    local today = date.monthDay
    local numEvents = C_Calendar.GetNumDayEvents(0, today)
    if numEvents <= 0 then
        return
    end

    for i = 1, numEvents do
        local info = C_Calendar.GetDayEvent(0, today, i)
        if info and strfind(info.title, _G.PLAYER_DIFFICULTY_TIMEWALKER) and info.sequenceType ~= 'END' then
            isTimeWalker = true
            walkerTexture = info.iconTexture
            break
        end
    end
    F:UnregisterEvent(event, CheckTimeWalker)
end

local function CheckTexture(texture)
    if not walkerTexture then
        return
    end
    if walkerTexture == texture or walkerTexture == texture - 1 then
        return true
    end
end

local questlist = {
    { name = L['Winter Veil Daily'], id = 6983 },
    { name = L['Blingtron Daily Pack'], id = 34774 },
    { name = L['Tormentors of Torghast'], id = 63854 },
    { name = L['Timewarped Badge Reward'], id = 40168, texture = 1129674 }, -- TBC
    { name = L['Timewarped Badge Reward'], id = 40173, texture = 1129686 }, -- WotLK
    { name = L['Timewarped Badge Reward'], id = 40786, texture = 1304688 }, -- Cata
    { name = L['Timewarped Badge Reward'], id = 45799, texture = 1530590 }, -- MoP
    { name = L['Timewarped Badge Reward'], id = 55499, texture = 1129683 }, -- WoD
    { name = L['Timewarped Badge Reward'], id = 64710, texture = 1467047 }, -- Legion
}

-- Torghast
local torgInfo
local torgWidgets = {
    { nameID = 2925, levelID = 2930 }, -- Fracture Chambers
    { nameID = 2926, levelID = 2932 }, -- Skoldus Hall
    { nameID = 2924, levelID = 2934 }, -- Soulforges
    { nameID = 2927, levelID = 2936 }, -- Coldheart Interstitia
    { nameID = 2928, levelID = 2938 }, -- Mort'regar
    { nameID = 2929, levelID = 2940 }, -- The Upper Reaches
}

local function CleanupLevelName(text)
    return gsub(text, '|n', '')
end

local title
local function AddTitle(text)
    if not title then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(text, 0.6, 0.8, 1)
        title = true
    end
end

local function Block_OnMouseUp(self, btn)
    if btn == 'RightButton' then
        if not _G.WeeklyRewardsFrame then
            LoadAddOn('Blizzard_WeeklyRewards')
        end
        _G.ToggleFrame(_G.WeeklyRewardsFrame)
    else
        _G.ToggleCalendar()
    end
end

local function Block_OnEnter(self)
    RequestRaidInfo()

    local r, g, b
    local anchorTop = C.DB.Infobar.AnchorTop

    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(L['Daily/Weekly'], 0.9, 0.8, 0.6)

    -- World bosses
    title = false
    for i = 1, GetNumSavedWorldBosses() do
        local name, id, reset = GetSavedWorldBossInfo(i)
        if not (id == 11 or id == 12 or id == 13) then
            AddTitle(_G.RAID_INFO_WORLD_BOSS)
            _G.GameTooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3), 1, 1, 1, 1, 1, 1)
        end
    end

    -- Mythic Dungeons
    title = false
    for i = 1, GetNumSavedInstances() do
        local name, _, reset, diff, locked, extended = GetSavedInstanceInfo(i)
        if diff == 23 and (locked or extended) then
            AddTitle(_G.DUNGEON_DIFFICULTY3 .. _G.DUNGEONS)
            if extended then
                r, g, b = 0.3, 1, 0.3
            else
                r, g, b = 1, 1, 1
            end
            _G.GameTooltip:AddDoubleLine(name, SecondsToTime(reset, true, nil, 3), 1, 1, 1, r, g, b)
        end
    end

    -- Raids
    title = false
    for i = 1, GetNumSavedInstances() do
        local name, _, reset, _, locked, extended, _, isRaid, _, diffName = GetSavedInstanceInfo(i)
        if isRaid and (locked or extended) then
            AddTitle(_G.RAID_INFO)
            if extended then
                r, g, b = 0.3, 1, 0.3
            else
                r, g, b = 1, 1, 1
            end
            _G.GameTooltip:AddDoubleLine(
                name .. ' - ' .. diffName,
                SecondsToTime(reset, true, nil, 3),
                1,
                1,
                1,
                r,
                g,
                b
            )
        end
    end

    -- Torghast
    if not torgInfo then
        torgInfo = C_AreaPoiInfo.GetAreaPOIInfo(1543, 6640)
    end
    if torgInfo and C_QuestLog.IsQuestFlaggedCompleted(60136) then
        title = false
        for _, value in pairs(torgWidgets) do
            local nameInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(value.nameID)
            if nameInfo and nameInfo.shownState == 1 then
                AddTitle(torgInfo.name)
                local nameText = CleanupLevelName(nameInfo.text)
                local levelInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(value.levelID)
                local levelText = _G.AVAILABLE
                if levelInfo and levelInfo.shownState == 1 then
                    levelText = CleanupLevelName(levelInfo.text)
                end
                _G.GameTooltip:AddDoubleLine(nameText, levelText)
            end
        end
    end

    -- Quests
    title = false

    for _, v in pairs(questlist) do
        if v.name and C_QuestLog.IsQuestFlaggedCompleted(v.id) then
            if v.name == L['Timewarped'] and isTimeWalker and CheckTexture(v.texture) or v.name ~= L['Timewarped'] then
                AddTitle(_G.QUESTS_LABEL)
                _G.GameTooltip:AddDoubleLine(v.name, _G.QUEST_COMPLETE, 1, 1, 1, 0, 1, 0)
            end
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Toggle Calendar Panel'], 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_RIGHT_BUTTON .. L['Toggle Great Vault Panel'], 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:Show()
end

local function Block_OnLeave(self)
    F.HideTooltip()
end

local function Block_OnEvent(self, event)
    if event == 'PLAYER_ENTERING_WORLD' then
        self.text:SetText(L['Daily/Weekly'])
        self:UnregisterEvent(event)
    end
end

function INFOBAR:CreateDailyBlock()
    if not C.DB.Infobar.Daily then
        return
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', CheckTimeWalker)

    local daily = INFOBAR:RegisterNewBlock('daily', 'RIGHT', 150)
    daily.onEnter = Block_OnEnter
    daily.onLeave = Block_OnLeave
    daily.onMouseUp = Block_OnMouseUp
    daily.onEvent = Block_OnEvent
    daily.eventList = { 'PLAYER_ENTERING_WORLD' }
end
