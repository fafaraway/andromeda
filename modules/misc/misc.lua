local F, C, L = unpack(select(2, ...))
local MISC = F:RegisterModule('General')

local MISC_LIST = {}

function MISC:RegisterMisc(name, func)
    if not MISC_LIST[name] then
        MISC_LIST[name] = func
    end
end

function MISC:OnLogin()
    for name, func in next, MISC_LIST do
        if name and type(func) == 'function' then
            func()
        end
    end

    MISC:ForceWarning()
    MISC:FasterLoot()
    MISC:MawWidgetFrame()
    MISC:JerryWay()
end

-- Force warning
local function ForceWarning_OnEvent(_, event)
    if event == 'UPDATE_BATTLEFIELD_STATUS' then
        for i = 1, GetMaxBattlefieldID() do
            local status = GetBattlefieldStatus(i)
            if status == 'confirm' then
                PlaySound(_G.SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
                break
            end
            i = i + 1
        end
    elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
        PlaySound(_G.SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
    elseif event == 'LFG_PROPOSAL_SHOW' then
        PlaySound(_G.SOUNDKIT.READY_CHECK, 'Master')
    elseif event == 'RESURRECT_REQUEST' then
        PlaySound(37, 'Master')
    end
end

local function ReadyCheckHook(_, initiator)
    if initiator ~= 'player' then
        PlaySound(_G.SOUNDKIT.READY_CHECK, 'Master')
    end
end

function MISC:ForceWarning()
    F:RegisterEvent('UPDATE_BATTLEFIELD_STATUS', ForceWarning_OnEvent)
    F:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH', ForceWarning_OnEvent)
    F:RegisterEvent('LFG_PROPOSAL_SHOW', ForceWarning_OnEvent)
    F:RegisterEvent('RESURRECT_REQUEST', ForceWarning_OnEvent)

    hooksecurefunc('ShowReadyCheck', ReadyCheckHook)
end

-- Faster loot
local lootDelay = 0
local function fasterLootOnEvent()
    local thisTime = GetTime()
    if thisTime - lootDelay >= .3 then
        lootDelay = thisTime
        if GetCVarBool('autoLootDefault') ~= IsModifiedClick('AUTOLOOTTOGGLE') then
            for i = GetNumLootItems(), 1, -1 do
                LootSlot(i)
            end
            lootDelay = thisTime
        end
    end
end

function MISC:FasterLoot()
    if C.DB.General.FasterLoot then
        F:RegisterEvent('LOOT_READY', fasterLootOnEvent)
    else
        F:UnregisterEvent('LOOT_READY', fasterLootOnEvent)
    end
end

-- Maw threat bar
local maxValue = 1000
local function GetMawBarValue()
    local widgetInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(2885)
    if widgetInfo and widgetInfo.shownState == 1 then
        local value = widgetInfo.progressVal
        return math.floor(value / maxValue), value % maxValue
    end
end

local MawRankColor = {
    [0] = {.6, .8, 1},
    [1] = {0, 1, 0},
    [2] = {0, .7, .3},
    [3] = {1, .8, 0},
    [4] = {1, .5, 0},
    [5] = {1, 0, 0}
}

function MISC:UpdateMawBarLayout()
    local bar = MISC.MawBar
    local rank, value = GetMawBarValue()
    if rank then
        bar:SetStatusBarColor(unpack(MawRankColor[rank]))
        if rank == 5 then
            bar.text:SetText('Lv' .. rank)
            bar:SetValue(maxValue)
        else
            bar.text:SetText('Lv' .. rank .. ' - ' .. value .. '/' .. maxValue)
            bar:SetValue(value)
        end
        bar:Show()
        _G.UIWidgetTopCenterContainerFrame:Hide()
    else
        bar:Hide()
        _G.UIWidgetTopCenterContainerFrame:Show()
    end
end

function MISC:MawWidgetFrame()
    if not C.DB.General.MawThreatBar then
        return
    end

    if MISC.MawBar then
        return
    end

    local bar = CreateFrame('StatusBar', nil, _G.UIParent)
    bar:SetSize(200, 16)
    bar:SetMinMaxValues(0, maxValue)
    bar.text = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, nil, nil, true)
    F.CreateSB(bar)
    F:SmoothBar(bar)
    MISC.MawBar = bar

    F.Mover(bar, L['Maw Threat Bar'], 'MawThreatBar', {'TOP', _G.UIParent, 0, -80})

    bar:SetScript(
        'OnEnter',
        function(self)
            local rank = GetMawBarValue()
            local widgetInfo = rank and C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo(2873 + rank)
            if widgetInfo and widgetInfo.shownState == 1 then
                _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -10)
                local header, nonHeader = _G.SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
                if header then
                    _G.GameTooltip:AddLine(header, nil, nil, nil, 1)
                end
                if nonHeader then
                    _G.GameTooltip:AddLine(nonHeader, nil, nil, nil, 1)
                end
                _G.GameTooltip:Show()
            end
        end
    )
    bar:SetScript('OnLeave', F.HideTooltip)

    MISC:UpdateMawBarLayout()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', MISC.UpdateMawBarLayout)
    F:RegisterEvent('UPDATE_UI_WIDGET', MISC.UpdateMawBarLayout)
end

-- Support cmd /way if TomTom disabled

local pointString = C.InfoColor .. '|Hworldmap:%d+:%d+:%d+|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a%s (%s, %s)%s]|h|r'

local function GetCorrectCoord(x)
    x = tonumber(x)
    if x then
        if x > 100 then
            return 100
        elseif x < 0 then
            return 0
        end
        return x
    end
end

function MISC:JerryWay()
    if IsAddOnLoaded('TomTom') then
        return
    end

    _G.SlashCmdList['FREEUI_JERRY_WAY'] = function(msg)
        msg = string.gsub(msg, '(%d)[%.,] (%d)', '%1 %2')
        local x, y, z = string.match(msg, '(%S+)%s(%S+)(.*)')
        if x and y then
            local mapID = C_Map.GetBestMapForUnit('player')
            if mapID then
                local mapInfo = C_Map.GetMapInfo(mapID)
                local mapName = mapInfo and mapInfo.name
                if mapName then
                    x = GetCorrectCoord(x)
                    y = GetCorrectCoord(y)

                    if x and y then
                        print(string.format(pointString, mapID, x * 100, y * 100, mapName, x, y, z or ''))
                    end
                end
            end
        end
    end
    _G.SLASH_FREEUI_JERRY_WAY1 = '/way'
end

-- Auto select current event boss from LFD tool
do
    local firstLFD
    local function LFD_OnShow()
        if not firstLFD then
            firstLFD = 1
            for i = 1, GetNumRandomDungeons() do
                local id = GetLFGRandomDungeonInfo(i)
                local isHoliday = select(15, GetLFGDungeonInfo(id))
                if isHoliday and not GetLFGDungeonRewards(id) then
                    _G.LFDQueueFrame_SetType(id)
                end
            end
        end
    end

    _G.LFDParentFrame:HookScript('OnShow', LFD_OnShow)
end

-- Auto collapse TradeSkillFrame RecipeList
do
    local f = CreateFrame('Frame')
    f:RegisterEvent('ADDON_LOADED')
    f:SetScript(
        'OnEvent',
        function(self, _, addon)
            if addon ~= 'Blizzard_TradeSkillUI' then
                return
            end

            hooksecurefunc(
                _G.TradeSkillFrame.RecipeList,
                'OnDataSourceChanged',
                function(self)
                    self.tradeSkillChanged = nil
                    self.collapsedCategories = {}

                    for _, categoryID in ipairs({_G.C_TradeSkillUI.GetCategories()}) do
                        self.collapsedCategories[categoryID] = true
                    end

                    self:Refresh()
                end
            )

            self:UnregisterAllEvents()
        end
    )
end
