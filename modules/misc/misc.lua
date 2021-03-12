local _G = _G
local unpack = unpack
local select = select
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
local SOUNDKIT_PVP_THROUGH_QUEUE = SOUNDKIT.PVP_THROUGH_QUEUE
local SOUNDKIT_READY_CHECK = SOUNDKIT.READY_CHECK
local YES = YES
local NO = NO

local F, C, L = unpack(select(2, ...))
local MISC = F.MISC

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
    MISC:FasterCamera()
    MISC:AutoScreenshot()
    MISC:UpdateFasterLoot()
    MISC:FasterMovieSkip()
    MISC:BuyStack()
    MISC:SetRole()
    MISC:MawWidgetFrame()
end

function MISC:ForceWarning()
    local f = CreateFrame('Frame')
    f:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
    f:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH')
    f:RegisterEvent('LFG_PROPOSAL_SHOW')
    f:RegisterEvent('RESURRECT_REQUEST')
    f:SetScript('OnEvent', function(_, event)
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
    end)
end

local ShowReadyCheckHook = function(_, initiator)
    if initiator ~= 'player' then
        PlaySound(SOUNDKIT_READY_CHECK, 'Master')
    end
end
hooksecurefunc('ShowReadyCheck', ShowReadyCheckHook)

function MISC:FasterCamera()
    if not C.DB.misc.faster_camera then
        return
    end

    local oldZoomIn = CameraZoomIn
    local oldZoomOut = CameraZoomOut
    local oldVehicleZoomIn = VehicleCameraZoomIn
    local oldVehicleZoomOut = VehicleCameraZoomOut
    local newZoomSpeed = 4

    function CameraZoomIn(distance)
        oldZoomIn(newZoomSpeed)
    end

    function CameraZoomOut(distance)
        oldZoomOut(newZoomSpeed)
    end

    function VehicleCameraZoomIn(distance)
        oldVehicleZoomIn(newZoomSpeed)
    end

    function VehicleCameraZoomOut(distance)
        oldVehicleZoomOut(newZoomSpeed)
    end
end

-- Faster Looting
local lootDelay = 0
function MISC:DoFasterLoot()
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

function MISC:UpdateFasterLoot()
    if C.DB.misc.FasterLoot then
        F:RegisterEvent('LOOT_READY', MISC.DoFasterLoot)
    else
        F:UnregisterEvent('LOOT_READY', MISC.DoFasterLoot)
    end
end

-- Faster movie skip
function MISC:FasterMovieSkip()
    if not C.DB.misc.FasterMovieSkip then
        return
    end

    -- Allow space bar, escape key and enter key to cancel cinematic without confirmation
    _G.CinematicFrame:HookScript('OnKeyDown', function(self, key)
        if key == 'ESCAPE' then
            if _G.CinematicFrame:IsShown() and _G.CinematicFrame.closeDialog and _G.CinematicFrameCloseDialogConfirmButton then
                _G.CinematicFrameCloseDialog:Hide()
            end
        end
    end)
    _G.CinematicFrame:HookScript('OnKeyUp', function(self, key)
        if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
            if _G.CinematicFrame:IsShown() and _G.CinematicFrame.closeDialog and _G.CinematicFrameCloseDialogConfirmButton then
                _G.CinematicFrameCloseDialogConfirmButton:Click()
            end
        end
    end)
    _G.MovieFrame:HookScript('OnKeyUp', function(self, key)
        if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
            if _G.MovieFrame:IsShown() and _G.MovieFrame.CloseDialog and _G.MovieFrame.CloseDialog.ConfirmButton then
                _G.MovieFrame.CloseDialog.ConfirmButton:Click()
            end
        end
    end)
end

-- Achievement screenshot
do
    local function AchievementEarned(...)
        if not C.DB.misc.auto_screenshot_achievement then
            return
        end

        local _, _, alreadyEarned = ...

        if alreadyEarned then
            return
        end

        F:Delay(1, _G.Screenshot)
    end

    local function ChallengeModeCompleted()
        if not C.DB.misc.auto_screenshot_challenge then
            return
        end

        F:Delay(2, _G.Screenshot)
    end

    function MISC:AutoScreenshot()
        if not C.DB.misc.auto_screenshot then
            return
        end

        F:RegisterEvent('ACHIEVEMENT_EARNED', AchievementEarned)
        F:RegisterEvent('CHALLENGE_MODE_COMPLETED', ChallengeModeCompleted)
    end
end

-- Buy stack
function MISC:BuyStack()
    local cache = {}
    local itemLink, id

    _G.StaticPopupDialogs['FREEUI_BUY_STACK'] = {
        text = L['MISC_BUY_STACK'],
        button1 = YES,
        button2 = NO,
        OnAccept = function()
            if not itemLink then
                return
            end
            BuyMerchantItem(id, GetMerchantItemMaxStack(id))
            cache[itemLink] = true
            itemLink = nil
        end,
        hideOnEscape = 1,
        hasItemFrame = 1,
    }

    local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
    function MerchantItemButton_OnModifiedClick(self, ...)
        if IsAltKeyDown() then
            id = self:GetID()
            itemLink = GetMerchantItemLink(id)
            if not itemLink then
                return
            end
            local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
            if maxStack and maxStack > 1 then
                if not cache[itemLink] then
                    local r, g, b = GetItemQualityColor(quality or 1)
                    StaticPopup_Show('FREEUI_BUY_STACK', ' ', ' ', {['texture'] = texture, ['name'] = name, ['color'] = {r, g, b, 1}, ['link'] = itemLink, ['index'] = id, ['count'] = maxStack})
                else
                    BuyMerchantItem(id, GetMerchantItemMaxStack(id))
                end
            end
        end

        _MerchantItemButton_OnModifiedClick(self, ...)
    end
end

-- Set role
do
    local prev = 0
    local function SetRole()
        if C.MyLevel >= 10 and not InCombatLockdown() and IsInGroup() and not IsPartyLFG() then
            local spec = GetSpecialization()
            if spec then
                local role = GetSpecializationRole(spec)
                if UnitGroupRolesAssigned('player') ~= role then
                    local t = GetTime()
                    if t - prev > 2 then
                        prev = t
                        UnitSetRole('player', role)
                    end
                end
            else
                UnitSetRole('player', 'No Role')
            end
        end
    end

    function MISC:SetRole()
        F:RegisterEvent('PLAYER_TALENT_UPDATE', SetRole)
        F:RegisterEvent('GROUP_ROSTER_UPDATE', SetRole)

        _G.RolePollPopup:UnregisterEvent('ROLE_POLL_BEGIN')
    end
end

-- Maw threat bar
do
    local maxValue = 1000
    local function GetMawBarValue()
        local widgetInfo = C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo(2885)
        if widgetInfo and widgetInfo.shownState == 1 then
            local value = widgetInfo.progressVal
            return floor(value / maxValue), value % maxValue
        end
    end

    local MawRankColor = {[0] = {.6, .8, 1}, [1] = {0, 1, 0}, [2] = {0, .7, .3}, [3] = {1, .8, 0}, [4] = {1, .5, 0}, [5] = {1, 0, 0}}
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
        if not C.DB.blizzard.maw_threat_bar then
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

        F.Mover(bar, L.GUI.MOVER.MAW_THREAT_BAR, 'MawThreatBar', {'TOP', _G.UIParent, 0, -80})

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
end

-- Auto select current event boss from LFD tool
do
    local firstLFD
    _G.LFDParentFrame:HookScript('OnShow', function()
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
    end)
end
