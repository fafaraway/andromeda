local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local memory
local addons = {}
local n, total = 0, 0
local last = 0
local lastLag = 0

local function FormatMemory(value)
    if value > 1024 then
        return string.format('%.1f MB', value / 1024)
    else
        return string.format('%.0f KB', value)
    end
end

local function Order(a, b)
    return a.memory > b.memory
end

local function MemoryColor(value, times)
    if not times then
        times = 1
    end

    if value <= 1024 * times then
        return 0, 1, 0
    elseif value <= 2048 * times then
        return .75, 1, 0
    elseif value <= 4096 * times then
        return 1, 1, 0
    elseif value <= 8192 * times then
        return 1, .75, 0
    elseif value <= 16384 * times then
        return 1, .5, 0
    else
        return 1, .1, 0
    end
end

local function CreateHolder()
    local holder = CreateFrame('Frame', nil, INFOBAR.Bar)
    holder:SetFrameLevel(3)
    holder:SetPoint('TOP')
    holder:SetPoint('BOTTOM')
    holder:SetWidth(180)
    holder:SetPoint('CENTER')

    local text = F.CreateFS(holder, C.Assets.Fonts.Condensed, 11, nil, '', nil, true, 'CENTER', 0, 0)
    text:SetTextColor(C.r, C.g, C.b)
    text:SetDrawLayer('OVERLAY')

    INFOBAR.StatsText = text
end

local function Button_OnMouseUp(self, btn)
    if btn == 'LeftButton' then
        local openaddonlist

        if _G.AddonList:IsVisible() then
            openaddonlist = true
        end

        if not openaddonlist then
            _G.ShowUIPanel(_G.AddonList)
        else
            _G.HideUIPanel(_G.AddonList)
        end
    elseif btn == 'RightButton' then
        if not _G.TimeManagerClockButton then
            LoadAddOn('Blizzard_TimeManager')
        end
        _G.TimeManagerClockButton_OnClick(_G.TimeManagerClockButton)
    end
end

local function Button_OnUpdate(self, elapsed)
    local _, _, home, world = GetNetStats()
    local string = '|cffffffff%s|r fps   |cffffffff%s|r/|cffffffff%s|r ms   |cffffffff%s|r'

    last = last + elapsed
    lastLag = lastLag + elapsed

    if lastLag >= 30 then
        _, _, home, world = GetNetStats()
        lastLag = 0
    end

    if last >= 1 then
        INFOBAR.StatsText:SetText(string.format(string, math.floor(GetFramerate() + .5), home, world, _G.GameTime_GetTime(false)))
        last = 0
    end
end

local function Button_OnEnter(self)
    if InCombatLockdown() then
        return
    end

    collectgarbage()
    UpdateAddOnMemoryUsage()

    for i = 1, GetNumAddOns() do
        if IsAddOnLoaded(i) then
            memory = GetAddOnMemoryUsage(i)
            n = n + 1
            addons[n] = {name = GetAddOnInfo(i), memory = memory}
            total = total + memory
        end
    end
    table.sort(addons, Order)

    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()

    local today = C_DateAndTime.GetCurrentCalendarTime()
    local w, m, d, y = today.weekday, today.month, today.monthDay, today.year
    _G.GameTooltip:AddLine(string.format(_G.FULLDATE, _G.CALENDAR_WEEKDAY_NAMES[w], _G.CALENDAR_FULLDATE_MONTH_NAMES[m], d, y), .9, .82, .62)
    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(L['Local Time'], _G.GameTime_GetLocalTime(true), .6, .8, 1, 1, 1, 1)
    _G.GameTooltip:AddDoubleLine(L['Realm Time'], _G.GameTime_GetGameTime(true), .6, .8, 1, 1, 1, 1)
    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(_G.ADDONS, FormatMemory(total), .9, .82, .62, MemoryColor(total))

    for _, entry in next, addons do
        _G.GameTooltip:AddDoubleLine(entry.name, FormatMemory(entry.memory), 1, 1, 1, MemoryColor(entry.memory))
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.Textures.MouseLeftBtn .. L['Toggle Addons Panel'] .. ' ', 1, 1, 1, .9, .82, .62)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.Textures.MouseRightBtn .. L['Toggle Timer Panel'] .. ' ', 1, 1, 1, .9, .82, .62)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
    n, total = 0, 0
    table.wipe(addons)
end

function INFOBAR:CreateStatsBlock()
    if not C.DB.Infobar.Stats then
        return
    end

    CreateHolder()

    local bu = INFOBAR:AddBlock('', nil, 200)
    bu:HookScript('OnMouseUp', Button_OnMouseUp)
    bu:HookScript('OnUpdate', Button_OnUpdate)
    bu:HookScript('OnEnter', Button_OnEnter)
    bu:HookScript('OnLeave', Button_OnLeave)
end
