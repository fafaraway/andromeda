local _G = _G
local unpack = unpack
local select = select
local strfind = strfind
local gsub = gsub
local min = min
local LoadAddOn = LoadAddOn
local ToggleFrame = ToggleFrame
local ToggleCalendar = ToggleCalendar
local RequestRaidInfo = RequestRaidInfo
local GetNumSavedWorldBosses = GetNumSavedWorldBosses
local GetSavedWorldBossInfo = GetSavedWorldBossInfo
local SecondsToTime = SecondsToTime
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Calendar_SetAbsMonth = C_Calendar.SetAbsMonth
local C_Calendar_OpenCalendar = C_Calendar.OpenCalendar
local C_Calendar_GetNumDayEvents = C_Calendar.GetNumDayEvents
local C_Calendar_GetDayEvent = C_Calendar.GetDayEvent
local C_AreaPoiInfo_GetAreaPOIInfo = C_AreaPoiInfo.GetAreaPOIInfo
local C_UIWidgetManager_GetTextWithStateWidgetVisualizationInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo
local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local CONQUEST_CURRENCY_ID = Constants.CurrencyConsts.CONQUEST_CURRENCY_ID
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')

-- TimeWalker
local isTimeWalker, walkerTexture
local function CheckTimeWalker(event)
    local date = C_DateAndTime_GetCurrentCalendarTime()
    C_Calendar_SetAbsMonth(date.month, date.year)
    C_Calendar_OpenCalendar()

    local today = date.monthDay
    local numEvents = C_Calendar_GetNumDayEvents(0, today)
    if numEvents <= 0 then
        return
    end

    for i = 1, numEvents do
        local info = C_Calendar_GetDayEvent(0, today, i)
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
    {name = L['Winter Veil Daily'], id = 6983},
    {name = L['Blingtron Daily Pack'], id = 34774},
    {name = L['Tormentors of Torghast'], id = 63854},
    {name = L['Timewarped Badge Reward'], id = 40168, texture = 1129674}, -- TBC
    {name = L['Timewarped Badge Reward'], id = 40173, texture = 1129686}, -- WotLK
    {name = L['Timewarped Badge Reward'], id = 40786, texture = 1304688}, -- Cata
    {name = L['Timewarped Badge Reward'], id = 45799, texture = 1530590} -- MoP
}

-- Torghast
local torgInfo
local torgWidgets = {
    {nameID = 2925, levelID = 2930}, -- Fracture Chambers
    {nameID = 2926, levelID = 2932}, -- Skoldus Hall
    {nameID = 2924, levelID = 2934}, -- Soulforges
    {nameID = 2927, levelID = 2936}, -- Coldheart Interstitia
    {nameID = 2928, levelID = 2938}, -- Mort'regar
    {nameID = 2929, levelID = 2940} -- The Upper Reaches
}

local function CleanupLevelName(text)
    return gsub(text, '|n', '')
end

local title
local function AddTitle(text)
    if not title then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(text, .6, .8, 1)
        title = true
    end
end

local function Button_OnMouseUp(self, btn)
    if btn == 'RightButton' then
        if not _G.WeeklyRewardsFrame then
            LoadAddOn('Blizzard_WeeklyRewards')
        end
        ToggleFrame(_G.WeeklyRewardsFrame)
    else
        ToggleCalendar()
    end
end

local function Button_OnEnter(self)
    RequestRaidInfo()

    local r, g, b
    local anchorTop = C.DB.Infobar.AnchorTop

    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(L['Daily/Weekly'], .9, .8, .6)

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
                r, g, b = .3, 1, .3
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
                r, g, b = .3, 1, .3
            else
                r, g, b = 1, 1, 1
            end
            _G.GameTooltip:AddDoubleLine(name .. ' - ' .. diffName, SecondsToTime(reset, true, nil, 3), 1, 1, 1, r, g, b)
        end
    end

    -- Torghast
    if not torgInfo then
        torgInfo = C_AreaPoiInfo_GetAreaPOIInfo(1543, 6640)
    end
    if torgInfo and IsQuestFlaggedCompleted(60136) then
        title = false
        for _, value in pairs(torgWidgets) do
            local nameInfo = C_UIWidgetManager_GetTextWithStateWidgetVisualizationInfo(value.nameID)
            if nameInfo and nameInfo.shownState == 1 then
                AddTitle(torgInfo.name)
                local nameText = CleanupLevelName(nameInfo.text)
                local levelInfo = C_UIWidgetManager_GetTextWithStateWidgetVisualizationInfo(value.levelID)
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

    local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(CONQUEST_CURRENCY_ID)
    local totalEarned = currencyInfo.totalEarned
    if currencyInfo and totalEarned > 0 then
        AddTitle(_G.QUESTS_LABEL)
        local maxProgress = currencyInfo.maxQuantity
        local progress = min(totalEarned, maxProgress)
        _G.GameTooltip:AddDoubleLine(currencyInfo.name, progress .. '/' .. maxProgress, 1, 1, 1, 1, 1, 1)
    end

    for _, v in pairs(questlist) do
        if v.name and IsQuestFlaggedCompleted(v.id) then
            if v.name == L['Timewarped'] and isTimeWalker and CheckTexture(v.texture) or v.name ~= L['Timewarped'] then
                AddTitle(_G.QUESTS_LABEL)
                _G.GameTooltip:AddDoubleLine(v.name, _G.QUEST_COMPLETE, 1, 1, 1, 0, 1, 0)
            end
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Toggle Calendar Panel'], 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right .. L['Toggle Great Vault Panel'], 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F.HideTooltip()
end

function INFOBAR:CreateReportBlock()
    if not C.DB.Infobar.Report then
        return
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', CheckTimeWalker)

    local bu = INFOBAR:AddBlock(L['Daily/Weekly'], 'RIGHT', 100)
    bu:HookScript('OnMouseUp', Button_OnMouseUp)
    bu:HookScript('OnEnter', Button_OnEnter)
    bu:HookScript('OnLeave', Button_OnLeave)
end
