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
local IsAltKeyDown = IsAltKeyDown
local LootSlot = LootSlot
local BuyMerchantItem = BuyMerchantItem
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
local GetMerchantItemLink = GetMerchantItemLink
local GetItemQualityColor = GetItemQualityColor
local StaticPopup_Show = StaticPopup_Show
local InCombatLockdown = InCombatLockdown
local GetSpecialization = GetSpecialization
local GetSpecializationRole = GetSpecializationRole
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole
local C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo
local C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo = C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo
local UIWidgetTopCenterContainerFrame = UIWidgetTopCenterContainerFrame
local SplitTextIntoHeaderAndNonHeader = SplitTextIntoHeaderAndNonHeader
local GetNumRandomDungeons = GetNumRandomDungeons
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local LFDQueueFrame_SetType = LFDQueueFrame_SetType
local GetItemInfo = GetItemInfo
local IsInGroup = IsInGroup
local IsPartyLFG = IsPartyLFG
local ConsoleExec = ConsoleExec
local SOUNDKIT_PVP_THROUGH_QUEUE = SOUNDKIT.PVP_THROUGH_QUEUE
local SOUNDKIT_READY_CHECK = SOUNDKIT.READY_CHECK
local NORMAL_FONT_COLOR_CODE = NORMAL_FONT_COLOR_CODE
local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local HIGHLIGHT_FONT_COLOR_CODE = HIGHLIGHT_FONT_COLOR_CODE
local YES = YES
local NO = NO

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

    MISC:AutoScreenshot()
    MISC:FasterLoot()
    MISC:LFDFix()

    MISC:MawWidgetFrame()
    MISC:MuteTrainSound()

    MISC:GetVisualId()
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

-- Auto screenshot
local function achievementEarned(...)
    if not C.DB.General.EarnedNewAchievement then
        return
    end

    local _, _, alreadyEarned = ...

    if alreadyEarned then
        return
    end

    F:Delay(1, _G.Screenshot)
end

local function challengeModeCompleted()
    if not C.DB.General.ChallengeModeCompleted then
        return
    end

    F:Delay(2, _G.Screenshot)
end

local function playerLevelUp()
    if not C.DB.General.PlayerLevelUp then
        return
    end

    F:Delay(1, _G.Screenshot)
end

local function playerDead()
    if not C.DB.General.PlayerDead then
        return
    end

    F:Delay(1, _G.Screenshot)
end

function MISC:AutoScreenshot()
    if not C.DB.General.AutoTakeScreenshot then
        return
    end

    F:RegisterEvent('ACHIEVEMENT_EARNED', achievementEarned)
    F:RegisterEvent('CHALLENGE_MODE_COMPLETED', challengeModeCompleted)
    F:RegisterEvent('PLAYER_LEVEL_UP', playerLevelUp)
    F:RegisterEvent('PLAYER_DEAD', playerDead)
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
    [5] = {1, 0, 0},
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

    bar:SetScript('OnEnter', function(self)
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
    end)
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

function MISC:MuteTrainSound()
    local trainSounds = {
        --[[Blood Elf]]
        '539219',
        '539203',
        '1313588',
        '1306531',
        --[[Draenei]]
        '539516',
        '539730',
        --[[Dwarf]]
        '539802',
        '539881',
        --[[Gnome]]
        '540271',
        '540275',
        --[[Goblin]]
        '541769',
        '542017',
        --[[Human]]
        '540535',
        '540734',
        --[[Night Elf]]
        '540870',
        '540947',
        '1316209',
        '1304872',
        --[[Orc]]
        '541157',
        '541239',
        --[[Pandaren]]
        '636621',
        '630296',
        '630298',
        --[[Tauren]]
        '542818',
        '542896',
        --[[Troll]]
        '543085',
        '543093',
        --[[Undead]]
        '542526',
        '542600',
        --[[Worgen]]
        '542035',
        '542206',
        '541463',
        '541601',
        --[[Dark Iron]]
        '1902030',
        '1902543',
        --[[Highmount]]
        '1730534',
        '1730908',
        --[[Kul Tiran]]
        '2531204',
        '2491898',
        --[[Lightforg]]
        '1731282',
        '1731656',
        --[[MagharOrc]]
        '1951457',
        '1951458',
        --[[Mechagnom]]
        '3107651',
        '3107182',
        --[[Nightborn]]
        '1732030',
        '1732405',
        --[[Void Elf]]
        '1732785',
        '1733163',
        --[[Vulpera]]
        '3106252',
        '3106717',
        --[[Zandalari]]
        '1903049',
        '1903522',

        -- 闷燃之心
        '2066602',
        '2066605',
    }
    for _, soundID in pairs(trainSounds) do
        MuteSoundFile(soundID)
    end
end

-- Get visual id and source id from WardrobeCollectionFrame
-- Credit silverwind
-- https://github.com/silverwind/idTip
do -- #FIXME
    local kinds = {item = 'ItemID', visual = 'VisualID', source = 'SourceID'}

    local function contains(table, element)
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    end

    local function addLine(tooltip, id, kind)
        if not id or id == '' then
            return
        end
        if type(id) == 'table' and #id == 1 then
            id = id[1]
        end

        -- Check if we already added to this tooltip. Happens on the talent frame
        local frame, text
        for i = 1, 15 do
            frame = _G[tooltip:GetName() .. 'TextLeft' .. i]
            if frame then
                text = frame:GetText()
            end
            if text and string.find(text, kind .. ':') then
                return
            end
        end

        local left, right
        if type(id) == 'table' then
            left = NORMAL_FONT_COLOR_CODE .. kind .. 's:' .. FONT_COLOR_CODE_CLOSE
            right = HIGHLIGHT_FONT_COLOR_CODE .. table.concat(id, ', ') .. FONT_COLOR_CODE_CLOSE
        else
            left = NORMAL_FONT_COLOR_CODE .. kind .. ':' .. FONT_COLOR_CODE_CLOSE
            right = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
        end

        tooltip:AddDoubleLine(left, right)
        tooltip:Show()
    end

    local function onEvent(_, _, addon)
        if addon == 'Blizzard_Collections' then
            hooksecurefunc('WardrobeCollectionFrame_SetAppearanceTooltip', function(self, sources)
                local visualIDs = {}
                local sourceIDs = {}
                local itemIDs = {}

                for i = 1, #sources do
                    if sources[i].visualID and not contains(visualIDs, sources[i].visualID) then
                        table.insert(visualIDs, sources[i].visualID)
                    end
                    if sources[i].sourceID and not contains(visualIDs, sources[i].sourceID) then
                        table.insert(sourceIDs, sources[i].sourceID)
                    end
                    if sources[i].itemID and not contains(visualIDs, sources[i].itemID) then
                        table.insert(itemIDs, sources[i].itemID)
                    end
                end

                _G.GameTooltip:AddLine(' ')

                if #visualIDs ~= 0 then
                    addLine(_G.GameTooltip, visualIDs, kinds.visual)
                end
                if #sourceIDs ~= 0 then
                    addLine(_G.GameTooltip, sourceIDs, kinds.source)
                end
                if #itemIDs ~= 0 then
                    addLine(_G.GameTooltip, itemIDs, kinds.item)
                end
            end)
        end
    end

    function MISC:GetVisualId()
        F:RegisterEvent('ADDON_LOADED', onEvent)
    end
end

