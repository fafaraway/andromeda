local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')
local oUF = F.Libs.oUF

local showMoreString = '%d %s (%s)'
local usageString = '%.3f ms'
local enableString = '|cff55ff55' .. _G.VIDEO_OPTIONS_ENABLED
local disableString = '|cffff5555' .. _G.VIDEO_OPTIONS_DISABLED
local scriptProfileStatus = GetCVarBool('scriptProfile')
local ipTypes = { 'IPv4', 'IPv6' }
local entered

local function formatMemory(value)
    if value > 1024 then
        return string.format('%.1f mb', value / 1024)
    else
        return string.format('%.0f kb', value)
    end
end

local function sortByMemory(a, b)
    if a and b then
        return (a[3] == b[3] and a[2] < b[2]) or a[3] > b[3]
    end
end

local function sortByCPU(a, b)
    if a and b then
        return (a[4] == b[4] and a[2] < b[2]) or a[4] > b[4]
    end
end

local usageColor = { 0, 1, 0, 1, 1, 0, 1, 0, 0 }
local function smoothColor(cur, max)
    local r, g, b = oUF:RGBColorGradient(cur, max, unpack(usageColor))
    return r, g, b
end

local infoTable = {}
local function BuildAddonList()
    local numAddons = GetNumAddOns()
    if numAddons == #infoTable then
        return
    end

    table.wipe(infoTable)
    for i = 1, numAddons do
        local _, title, _, loadable = GetAddOnInfo(i)
        if loadable then
            table.insert(infoTable, { i, title, 0, 0 })
        end
    end
end

local function UpdateMemory()
    UpdateAddOnMemoryUsage()

    local total = 0
    for _, data in ipairs(infoTable) do
        if IsAddOnLoaded(data[1]) then
            local mem = GetAddOnMemoryUsage(data[1])
            data[3] = mem
            total = total + mem
        end
    end
    table.sort(infoTable, sortByMemory)

    return total
end

local function UpdateCPU()
    UpdateAddOnCPUUsage()

    local total = 0
    for _, data in ipairs(infoTable) do
        if IsAddOnLoaded(data[1]) then
            local addonCPU = GetAddOnCPUUsage(data[1])
            data[4] = addonCPU
            total = total + addonCPU
        end
    end
    table.sort(infoTable, sortByCPU)

    return total
end

local function SetStatsText(self)
    local time = _G.GameTime_GetTime(false)
    local _, _, latencyHome, latencyWorld = GetNetStats()
    local fps = math.floor(GetFramerate() + 0.5)
    local string = '|cffffffff%s|r fps   |cffffffff%s|r/|cffffffff%s|r ms   |cffffffff%s|r'

    self.text:SetText(string.format(string, fps, latencyHome, latencyWorld, time))
    self.text:SetTextColor(C.r, C.g, C.b)
end

local function Block_OnEnter(self)
    entered = true

    if not next(infoTable) then
        BuildAddonList()
    end
    local isShiftKeyDown = IsShiftKeyDown()
    local maxAddOns = 10
    local maxShown = isShiftKeyDown and #infoTable or math.min(maxAddOns, #infoTable)

    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()

    local today = C_DateAndTime.GetCurrentCalendarTime()
    local w, m, d, y = today.weekday, today.month, today.monthDay, today.year
    _G.GameTooltip:AddLine(
        string.format(_G.FULLDATE, _G.CALENDAR_WEEKDAY_NAMES[w], _G.CALENDAR_FULLDATE_MONTH_NAMES[m], d, y),
        0.9,
        0.82,
        0.62
    )
    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(L['Local Time'], _G.GameTime_GetLocalTime(true), 0.6, 0.8, 1, 1, 1, 1)
    _G.GameTooltip:AddDoubleLine(L['Realm Time'], _G.GameTime_GetGameTime(true), 0.6, 0.8, 1, 1, 1, 1)

    if GetCVarBool('useIPv6') then
        local ipTypeHome, ipTypeWorld = GetNetIpTypes()
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddDoubleLine(L['Home Protocol'], ipTypes[ipTypeHome or 0] or _G.UNKNOWN, 0.6, 0.8, 1, 1, 1, 1)
        _G.GameTooltip:AddDoubleLine(L['World Protocol'], ipTypes[ipTypeWorld or 0] or _G.UNKNOWN, 0.6, 0.8, 1, 1, 1, 1)
    end

    _G.GameTooltip:AddLine(' ')

    if self.showMemory or not scriptProfileStatus then
        local totalMemory = UpdateMemory()
        _G.GameTooltip:AddDoubleLine(_G.ADDONS, formatMemory(totalMemory), 0.6, 0.8, 1, 1, 1, 1)
        _G.GameTooltip:AddLine(' ')

        local numEnabled = 0
        for _, data in ipairs(infoTable) do
            if IsAddOnLoaded(data[1]) then
                numEnabled = numEnabled + 1
                if numEnabled <= maxShown then
                    local r, g, b = smoothColor(data[3], totalMemory)
                    _G.GameTooltip:AddDoubleLine(data[2], formatMemory(data[3]), 1, 1, 1, r, g, b)
                end
            end
        end

        if not isShiftKeyDown and (numEnabled > maxAddOns) then
            local hiddenMemory = 0
            for i = (maxAddOns + 1), numEnabled do
                hiddenMemory = hiddenMemory + infoTable[i][3]
            end
            _G.GameTooltip:AddDoubleLine(
                string.format(showMoreString, numEnabled - maxAddOns, L['Hidden'], L['Hold SHIFT for more details']),
                formatMemory(hiddenMemory),
                0.6,
                0.8,
                1,
                0.6,
                0.8,
                1
            )
        end
    else
        local totalCPU = UpdateCPU()
        local passedTime = math.max(1, GetTime() - INFOBAR.loginTime)

        _G.GameTooltip:AddDoubleLine(
            _G.ADDONS,
            string.format(usageString, totalCPU / passedTime),
            0.6,
            0.8,
            1,
            1,
            1,
            1
        )
        _G.GameTooltip:AddLine(' ')

        local numEnabled = 0
        for _, data in ipairs(infoTable) do
            if IsAddOnLoaded(data[1]) then
                numEnabled = numEnabled + 1
                if numEnabled <= maxShown then
                    local r, g, b = smoothColor(data[4], totalCPU)
                    _G.GameTooltip:AddDoubleLine(
                        data[2],
                        string.format(usageString, data[4] / passedTime),
                        1,
                        1,
                        1,
                        r,
                        g,
                        b
                    )
                end
            end
        end

        if not isShiftKeyDown and (numEnabled > maxAddOns) then
            local hiddenUsage = 0
            for i = (maxAddOns + 1), numEnabled do
                hiddenUsage = hiddenUsage + infoTable[i][4]
            end
            _G.GameTooltip:AddDoubleLine(
                string.format(showMoreString, numEnabled - maxAddOns, L['Hidden'], L['Hold SHIFT for more details']),
                string.format(usageString, hiddenUsage / passedTime),
                0.6,
                0.8,
                1,
                0.6,
                0.8,
                1
            )
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Collect Memory'] .. ' ', 1, 1, 1, 0.9, 0.82, 0.62)
    if scriptProfileStatus then
        _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_RIGHT_BUTTON .. L['Switch Mode'] .. ' ', 1, 1, 1, 0.6, 0.8, 1)
    end
    _G.GameTooltip:AddDoubleLine(
        ' ',
        C.MOUSE_MIDDLE_BUTTON
            .. L['CPU Usage']
            .. ': '
            .. (GetCVarBool('scriptProfile') and enableString or disableString)
            .. ' ',
        1,
        1,
        1,
        0.6,
        0.8,
        1
    )
    _G.GameTooltip:Show()
end

local function Block_OnLeave(self)
    entered = false
    _G.GameTooltip:Hide()
end

local function Block_OnUpdate(self, elapsed)
    self.timer = (self.timer or 0) + elapsed
    if self.timer > 1 then
        SetStatsText(self)
        if entered then
            Block_OnEnter(self)
        end

        self.timer = 0
    end
end

local function Block_OnMouseUp(self, btn)
    if btn == 'LeftButton' then
        if scriptProfileStatus then
            ResetCPUUsage()
            INFOBAR.loginTime = GetTime()
        end
        local before = gcinfo()
        collectgarbage('collect')
        F:Print(string.format('%s %s', L['Collect Memory'], formatMemory(before - gcinfo())))
        Block_OnEnter(self)
    elseif btn == 'RightButton' and scriptProfileStatus then
        self.showMemory = not self.showMemory
        Block_OnEnter(self)
    elseif btn == 'MiddleButton' then
        if GetCVarBool('scriptProfile') then
            SetCVar('scriptProfile', 0)
        else
            SetCVar('scriptProfile', 1)
        end

        if GetCVarBool('scriptProfile') == scriptProfileStatus then
            StaticPopup_Hide('ANDROMEDA_RELOADUI_REQUIRED')
        else
            StaticPopup_Show('ANDROMEDA_RELOADUI_REQUIRED')
        end
        Block_OnEnter(self)
    end
end

function INFOBAR:CreateSystemBlock()
    if not C.DB.Infobar.System then
        return
    end

    local sys = INFOBAR:RegisterNewBlock('system', 'CENTER', 200, true)

    sys.onUpdate = Block_OnUpdate
    sys.onEnter = Block_OnEnter
    sys.onLeave = Block_OnLeave
    sys.onMouseUp = Block_OnMouseUp
end
