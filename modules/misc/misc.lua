local _G = _G
local unpack = unpack
local select = select
local next = next
local floor = floor
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local PlaySound = PlaySound
local GetMaxBattlefieldID = GetMaxBattlefieldID
local GetBattlefieldStatus = GetBattlefieldStatus
local GetTime = GetTime
local GetCVarBool = GetCVarBool
local GetNumLootItems = GetNumLootItems
local IsModifiedClick = IsModifiedClick
local LootSlot = LootSlot
local C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo
local C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo = C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo
local UIWidgetTopCenterContainerFrame = UIWidgetTopCenterContainerFrame
local SplitTextIntoHeaderAndNonHeader = SplitTextIntoHeaderAndNonHeader
local GetNumRandomDungeons = GetNumRandomDungeons
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local LFDQueueFrame_SetType = LFDQueueFrame_SetType
local SOUNDKIT_PVP_THROUGH_QUEUE = SOUNDKIT.PVP_THROUGH_QUEUE
local SOUNDKIT_READY_CHECK = SOUNDKIT.READY_CHECK

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
    MISC:LFDFix()

    MISC:MawWidgetFrame()
end

-- Force warning
local function ForceWarning_OnEvent(_, event)
    if event == 'UPDATE_BATTLEFIELD_STATUS' then
        for i = 1, GetMaxBattlefieldID() do
            local status = GetBattlefieldStatus(i)
            if status == 'confirm' then
                PlaySound(SOUNDKIT_PVP_THROUGH_QUEUE, 'Master')
                break
            end
            i = i + 1
        end
    elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
        PlaySound(SOUNDKIT_PVP_THROUGH_QUEUE, 'Master')
    elseif event == 'LFG_PROPOSAL_SHOW' then
        PlaySound(SOUNDKIT_READY_CHECK, 'Master')
    elseif event == 'RESURRECT_REQUEST' then
        PlaySound(37, 'Master')
    end
end

local function ReadyCheckHook(_, initiator)
    if initiator ~= 'player' then
        PlaySound(SOUNDKIT_READY_CHECK, 'Master')
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
    local widgetInfo = C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo(2885)
    if widgetInfo and widgetInfo.shownState == 1 then
        local value = widgetInfo.progressVal
        return floor(value / maxValue), value % maxValue
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
        UIWidgetTopCenterContainerFrame:Hide()
    else
        bar:Hide()
        UIWidgetTopCenterContainerFrame:Show()
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
            local widgetInfo = rank and C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo(2873 + rank)
            if widgetInfo and widgetInfo.shownState == 1 then
                _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -10)
                local header, nonHeader = SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
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

-- Auto select current event boss from LFD tool
local firstLFD
local function LFDOnShow()
    if not firstLFD then
        firstLFD = 1
        for i = 1, GetNumRandomDungeons() do
            local id = GetLFGRandomDungeonInfo(i)
            local isHoliday = select(15, GetLFGDungeonInfo(id))
            if isHoliday and not GetLFGDungeonRewards(id) then
                LFDQueueFrame_SetType(id)
            end
        end
    end
end

function MISC:LFDFix()
    _G.LFDParentFrame:HookScript('OnShow', LFDOnShow)
end


