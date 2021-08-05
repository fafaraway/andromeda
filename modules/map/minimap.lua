local _G = _G
local unpack = unpack
local select = select
local format = format
local CreateFrame = CreateFrame
local ToggleCalendar = ToggleCalendar
local InCombatLockdown = InCombatLockdown
local C_Calendar_GetNumPendingInvites = C_Calendar.GetNumPendingInvites
local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local IsInInstance = IsInInstance
local GetInstanceInfo = GetInstanceInfo
local hooksecurefunc = hooksecurefunc
local GetSubZoneText = GetSubZoneText
local GetZoneText = GetZoneText
local GetUnitName = GetUnitName
local Minimap_ZoomIn = Minimap_ZoomIn
local Minimap_ZoomOut = Minimap_ZoomOut
local Minimap_OnClick = Minimap_OnClick
local EasyMenu = EasyMenu
local ToggleDropDownMenu = ToggleDropDownMenu
local LoadAddOn = LoadAddOn
local securecall = securecall
local ShowUIPanel = ShowUIPanel
local HideUIPanel = HideUIPanel
local IsInGuild = IsInGuild
local ToggleCommunitiesFrame = ToggleCommunitiesFrame
local ToggleChannelFrame = ToggleChannelFrame
local Calendar_Toggle = Calendar_Toggle
local ReloadUI = ReloadUI

local F, C, L = unpack(select(2, ...))
local MM = F:RegisterModule('Minimap')

local map = _G.Minimap
local offset = 256 / 8

function MM:ReskinMinimap()
    local backdrop = CreateFrame('Frame', nil, _G.UIParent)
    backdrop:SetSize(256, 190)
    backdrop:SetFrameStrata('BACKGROUND')
    backdrop.bg = F.SetBD(backdrop)
    backdrop.bg:SetBackdropColor(0, 0, 0, 1)
    backdrop.bg:SetBackdropBorderColor(0, 0, 0, 1)
    map.backdrop = backdrop

    map:SetMaskTexture(C.Assets.mask_tex)
    map:SetSize(256, 256)
    map:SetHitRectInsets(0, 0, map:GetHeight() / 8, map:GetHeight() / 8)
    map:SetClampRectInsets(0, 0, 0, 0)
    map:SetFrameLevel(map:GetFrameLevel() + 2)
    map:ClearAllPoints()
    map:SetPoint('CENTER', backdrop)
    map:SetParent(map.backdrop)

    local pos = {'BOTTOMRIGHT', _G.UIParent, 'BOTTOMRIGHT', -C.UIGap, C.UIGap}
    local mover = F.Mover(backdrop, _G.MINIMAP_LABEL, 'Minimap', pos)
    map.mover = mover

    function _G.GetMinimapShape()
        return 'SQUARE'
    end

    _G.MinimapCluster:EnableMouse(false)
    map:SetArchBlobRingScalar(0)
    map:SetQuestBlobRingScalar(0)

    _G.DropDownList1:SetClampedToScreen(true)

    -- ClockFrame
    LoadAddOn('Blizzard_TimeManager')
    local region = _G.TimeManagerClockButton:GetRegions()
    region:Hide()
    _G.TimeManagerClockButton:Hide()

    -- Hide BlizzArt
    local frames = {
        'MinimapBorderTop',
        'MinimapNorthTag',
        'MinimapBorder',
        'MinimapZoneTextButton',
        'MinimapZoomOut',
        'MinimapZoomIn',
        'MiniMapWorldMapButton',
        'MiniMapMailBorder',
        'MiniMapTracking',
        'MiniMapInstanceDifficulty',
        'GuildInstanceDifficulty',
        'MiniMapChallengeMode'
    }

    for _, v in pairs(frames) do
        F.HideObject(_G[v])
    end
end

function MM:CreateMailButton()
    local mail = _G.MiniMapMailFrame
    local icon = _G.MiniMapMailIcon

    mail:ClearAllPoints()
    mail:SetPoint('BOTTOM', map, 0, offset - 4)
    icon:SetTexture(C.Assets.mail_tex)
    icon:SetSize(21, 21)
    icon:SetVertexColor(1, .8, 0)
end

function MM:CreateCalendar()
    local timeFrame = _G.GameTimeFrame

    if not timeFrame.styled then
        timeFrame:SetNormalTexture(nil)
        timeFrame:SetPushedTexture(nil)
        timeFrame:SetHighlightTexture(nil)
        timeFrame:SetSize(24, 12)
        timeFrame:SetParent(map)
        timeFrame:ClearAllPoints()
        timeFrame:SetPoint('TOPRIGHT', map, -4, -offset - 10)
        timeFrame:SetHitRectInsets(0, 0, 0, 0)

        for i = 1, timeFrame:GetNumRegions() do
            local region = select(i, timeFrame:GetRegions())
            if region.SetTextColor then
                region:SetTextColor(147 / 255, 211 / 255, 231 / 255)
                region:SetJustifyH('RIGHT')
                F:SetFS(region, C.Assets.Fonts.Bold, 12, 'OUTLINE')
                break
            end
        end

        timeFrame.styled = true
    end
    timeFrame:Show()

    -- Calendar invites
    _G.GameTimeCalendarInvitesTexture:ClearAllPoints()
    _G.GameTimeCalendarInvitesTexture:SetParent('Minimap')
    _G.GameTimeCalendarInvitesTexture:SetPoint('TOPRIGHT')

    local Invt = CreateFrame('Button', nil, _G.UIParent)
    Invt:SetPoint('TOPRIGHT', map, 'TOPLEFT', -6, -6)
    Invt:SetSize(300, 80)
    Invt:Hide()
    F.SetBD(Invt)
    F.CreateFS(Invt, C.Assets.Fonts.Regular, 14, 'OUTLINE', _G.GAMETIME_TOOLTIP_CALENDAR_INVITES, 'BLUE')

    local function updateInviteVisibility()
        Invt:SetShown(C_Calendar_GetNumPendingInvites() > 0)
    end
    F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
    F:RegisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)

    Invt:SetScript(
        'OnClick',
        function(_, btn)
            Invt:Hide()
            if btn == 'LeftButton' then
                ToggleCalendar()
            end
            F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
            F:UnregisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)
        end
    )
end

function MM:UpdateDifficultyFlag()
    local diffText = map.DiffText
    local inInstance, instanceType = IsInInstance()
    local difficulty = select(3, GetInstanceInfo())
    local numplayers = select(9, GetInstanceInfo())
    local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ''

    local norm = format('|cff1eff00%s|r', 'N')
    local hero = format('|cff0070dd%s|r', 'H')
    local myth = format('|cffa335ee%s|r', 'M')
    local lfr = format('|cffff8000s|r', 'LFR')

    if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
        if (difficulty == 1) then -- Normal
            diffText:SetText('5' .. norm)
        elseif difficulty == 2 then -- Heroic
            diffText:SetText('5' .. hero)
        elseif difficulty == 3 then -- 10 Player
            diffText:SetText('10' .. norm)
        elseif difficulty == 4 then -- 25 Player
            diffText:SetText('25' .. norm)
        elseif difficulty == 5 then -- 10 Player (Heroic)
            diffText:SetText('10' .. hero)
        elseif difficulty == 6 then -- 25 Player (Heroic)
            diffText:SetText('25' .. hero)
        elseif difficulty == 7 then -- LFR (Legacy)
            diffText:SetText(lfr)
        elseif difficulty == 8 then -- Mythic Keystone
            diffText:SetText(format('|cffff0000%s|r', 'M+') .. mplusdiff)
        elseif difficulty == 9 then -- 40 Player
            diffText:SetText('40')
        elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
            diffText:SetText(format('%s %s', hero, 'Scen'))
        elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
            diffText:SetText(format('%s %s', norm, 'Scen'))
        elseif difficulty == 40 then -- Mythic Scenario
            diffText:SetText(format('%s %s', myth, 'Scen'))
        elseif difficulty == 14 then -- Normal Raid
            diffText:SetText(numplayers .. norm)
        elseif difficulty == 15 then -- Heroic Raid
            diffText:SetText(numplayers .. hero)
        elseif difficulty == 16 then -- Mythic Raid
            diffText:SetText(numplayers .. myth)
        elseif difficulty == 17 then -- LFR
            diffText:SetText(numplayers .. lfr)
        elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
            diffText:SetText('EScen')
        elseif difficulty == 23 then -- Mythic Party
            diffText:SetText('5' .. myth)
        elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
            diffText:SetText('TW')
        elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
            diffText:SetText(format('|cffFFFF00%s |r', 'PvP'))
        elseif difficulty == 29 then -- PvEvP Scenario
            diffText:SetText('PvEvP')
        elseif difficulty == 147 then -- Normal Scenario (Warfronts)
            diffText:SetText('WF')
        elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
            diffText:SetText(format('|cffff7d0aH|r%s', 'WF'))
        end
    elseif instanceType == 'pvp' or instanceType == 'arena' then
        diffText:SetText(format('|cffff0007%s|r', 'PvP'))
    else
        diffText:SetText('')
    end

    if not inInstance then
        map.DiffFlag:SetAlpha(0)
    else
        map.DiffFlag:SetAlpha(1)
    end
end

function MM:CreateDifficultyFlag()
    local diffFlag = CreateFrame('Frame', nil, map)
    diffFlag:SetSize(80, 40)
    diffFlag:SetPoint('TOPLEFT', map, 0, -offset - 6)
    diffFlag:SetFrameLevel(map:GetFrameLevel() + 2)
    diffFlag.texture = diffFlag:CreateTexture(nil, 'OVERLAY')
    diffFlag.texture:SetAllPoints(diffFlag)
    diffFlag.texture:SetTexture(C.Assets.diff_tex)
    diffFlag.texture:SetVertexColor(0, 0, 0)
    diffFlag.text = F.CreateFS(diffFlag, C.Assets.Fonts.Bold, 10, nil, '', nil, 'THICK', 'CENTER', 0, 0)
    diffFlag.text:SetJustifyH('CENTER')
    map.DiffFlag = diffFlag
    map.DiffText = diffFlag.text

    map.DiffFlag:RegisterEvent('PLAYER_ENTERING_WORLD')
    map.DiffFlag:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
    map.DiffFlag:RegisterEvent('INSTANCE_GROUP_SIZE_CHANGED')
    map.DiffFlag:RegisterEvent('ZONE_CHANGED_NEW_AREA')
    map.DiffFlag:RegisterEvent('CHALLENGE_MODE_START')
    map.DiffFlag:RegisterEvent('CHALLENGE_MODE_COMPLETED')
    map.DiffFlag:RegisterEvent('CHALLENGE_MODE_RESET')
    map.DiffFlag:SetScript('OnEvent', MM.UpdateDifficultyFlag)
end

function MM:CreateGarrisonButton()
    _G.GarrisonLandingPageMinimapButton:SetScale(.5)
    hooksecurefunc(
        'GarrisonLandingPageMinimapButton_UpdateIcon',
        function(self)
            self:ClearAllPoints()
            self:SetPoint('BOTTOMLEFT', map, 0, offset + 30)
        end
    )
end

local function UpdateZoneText()
    if GetSubZoneText() == '' then
        map.ZoneText:SetText(GetZoneText())
    else
        map.ZoneText:SetText(GetSubZoneText())
    end
    map.ZoneText:SetTextColor(_G.ZoneTextString:GetTextColor())
end

function MM:CreateZoneText()
    _G.ZoneTextString:ClearAllPoints()
    _G.ZoneTextString:SetPoint('TOP', map, 0, -offset - 10)
    _G.ZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
    _G.SubZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
    _G.PVPInfoTextString:SetFont(C.Assets.Fonts.Header, 22)
    _G.PVPArenaTextString:SetFont(C.Assets.Fonts.Header, 22)

    local zoneText = F.CreateFS(map, C.Assets.Fonts.Header, 16, nil, '', nil, 'THICK')
    zoneText:SetPoint('TOP', map, 0, -offset - 10)
    zoneText:SetSize(map:GetWidth(), 30)
    zoneText:SetJustifyH('CENTER')
    zoneText:Hide()

    map.ZoneText = zoneText

    map:HookScript(
        'OnUpdate',
        function()
            UpdateZoneText()
        end
    )

    map:HookScript(
        'OnEnter',
        function()
            map.ZoneText:Show()
        end
    )

    map:HookScript(
        'OnLeave',
        function()
            map.ZoneText:Hide()
        end
    )
end

function MM:CreateQueueStatusButton()
    _G.QueueStatusMinimapButton:ClearAllPoints()
    _G.QueueStatusMinimapButton:SetPoint('BOTTOMRIGHT', map, 0, offset)
    _G.QueueStatusMinimapButtonBorder:Hide()
    _G.QueueStatusMinimapButtonIconTexture:SetTexture(nil)
    _G.QueueStatusFrame:ClearAllPoints()
    _G.QueueStatusFrame:SetPoint('BOTTOMRIGHT', map, 'BOTTOMLEFT', -4, offset)

    local queueIcon = map:CreateTexture(nil, 'ARTWORK')
    queueIcon:SetPoint('CENTER', _G.QueueStatusMinimapButton)
    queueIcon:SetSize(50, 50)
    queueIcon:SetTexture('Interface\\Minimap\\Raid_Icon')
    local anim = queueIcon:CreateAnimationGroup()
    anim:SetLooping('REPEAT')
    anim.rota = anim:CreateAnimation('Rotation')
    anim.rota:SetDuration(2)
    anim.rota:SetDegrees(360)
    hooksecurefunc(
        'QueueStatusFrame_Update',
        function()
            queueIcon:SetShown(_G.QueueStatusMinimapButton:IsShown())
        end
    )
    hooksecurefunc(
        'EyeTemplate_StartAnimating',
        function()
            anim:Play()
        end
    )
    hooksecurefunc(
        'EyeTemplate_StopAnimating',
        function()
            anim:Stop()
        end
    )
end

function MM:WhoPings()
    if not C.DB.Map.WhoPings then
        return
    end

    local f = CreateFrame('Frame', nil, map)
    f:SetAllPoints()
    f.text = F.CreateFS(f, C.Assets.Fonts.Regular, 14, 'OUTLINE', '', 'CLASS', false, 'TOP', 0, -4)

    local anim = f:CreateAnimationGroup()
    anim:SetScript(
        'OnPlay',
        function()
            f:SetAlpha(1)
        end
    )
    anim:SetScript(
        'OnFinished',
        function()
            f:SetAlpha(0)
        end
    )
    anim.fader = anim:CreateAnimation('Alpha')
    anim.fader:SetFromAlpha(1)
    anim.fader:SetToAlpha(0)
    anim.fader:SetDuration(3)
    anim.fader:SetSmoothing('OUT')
    anim.fader:SetStartDelay(3)

    F:RegisterEvent(
        'MINIMAP_PING',
        function(_, unit)
            if unit == 'player' then
                return
            end

            local r, g, b = F:ClassColor(C.MyClass)
            local name = GetUnitName(unit)

            anim:Stop()
            f.text:SetText(name)
            f.text:SetTextColor(r, g, b)
            anim:Play()
        end
    )
end

MM.MenuList = {
    {
        text = _G.MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true
    },
    {
        text = _G.CHARACTER_BUTTON,
        icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleCharacter, 'PaperDollFrame')
        end,
        notCheckable = true
    },
    {
        text = _G.SPELLBOOK_ABILITIES_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Class',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            if not _G.SpellBookFrame:IsShown() then
                ShowUIPanel(_G.SpellBookFrame)
            else
                HideUIPanel(_G.SpellBookFrame)
            end
        end,
        notCheckable = true
    },
    {
        text = _G.TALENTS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            if not _G.PlayerTalentFrame then
                LoadAddOn('Blizzard_TalentUI')
            end
            if not _G.GlyphFrame then
                LoadAddOn('Blizzard_GlyphUI')
            end
            securecall(_G.ToggleFrame, _G.PlayerTalentFrame)
        end,
        notCheckable = true
    },
    {
        text = _G.ACHIEVEMENT_BUTTON,
        icon = 'Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Shield',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleAchievementFrame)
        end,
        notCheckable = true
    },
    {
        text = _G.MAP_AND_QUEST_LOG, -- OLD: QUESTLOG_BUTTON
        icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
        func = function()
            securecall(_G.ToggleFrame, _G.WorldMapFrame)
        end,
        notCheckable = true
    },
    {
        text = _G.COMMUNITIES_FRAME_TITLE, -- OLD: COMMUNITIES
        icon = 'Interface\\FriendsFrame\\UI-Toast-ChatInviteIcon',
        arg1 = IsInGuild('player'),
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            ToggleCommunitiesFrame()
        end,
        notCheckable = true
    },
    {
        text = _G.SOCIAL_BUTTON,
        icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleFriendsFrame, 1)
        end,
        notCheckable = true
    },
    {
        text = _G.GROUP_FINDER, -- DUNGEONS_BUTTON
        icon = 'Interface\\LFGFRAME\\BattleNetWorking0',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleLFDParentFrame) --OR securecall(PVEFrame_ToggleFrame, "GroupFinderFrame")
        end,
        notCheckable = true
    },
    {
        text = _G.COLLECTIONS, -- OLD: MOUNTS_AND_PETS
        icon = 'Interface\\MINIMAP\\TRACKING\\Reagents',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffffff00' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleCollectionsJournal, 1)
        end,
        notCheckable = true
    },
    {
        text = _G.ADVENTURE_JOURNAL, -- OLD: ENCOUNTER_JOURNAL
        icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleEncounterJournal)
        end,
        notCheckable = true
    },
    {
        text = _G.BLIZZARD_STORE,
        icon = 'Interface\\MINIMAP\\TRACKING\\Auctioneer',
        func = function()
            if not _G.StoreFrame then
                LoadAddOn('Blizzard_StoreUI')
            end
            securecall(_G.ToggleStoreUI)
        end,
        notCheckable = true
    },
    {
        text = '',
        isTitle = true,
        notCheckable = true
    },
    {
        text = _G.OTHER,
        isTitle = true,
        notCheckable = true
    },
    {
        text = _G.BACKPACK_TOOLTIP,
        icon = 'Interface\\MINIMAP\\TRACKING\\Banker',
        func = function()
            securecall(_G.ToggleAllBags)
        end,
        notCheckable = true
    },
    --[[ {
        text = GARRISON_LANDING_PAGE_TITLE,
        icon = 'Interface\\HELPFRAME\\OpenTicketIcon',
        func = function()
            if InCombatLockdown() then
                UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(ShowGarrisonLandingPage, 2)
        end,
        notCheckable = true
    },
    {
        text = ORDER_HALL_LANDING_PAGE_TITLE,
        icon = 'Interface\\GossipFrame\\WorkOrderGossipIcon',
        func = function()
            if InCombatLockdown() then
                UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(ShowGarrisonLandingPage, 3)
        end,
        notCheckable = true
    }, ]]
    {
        text = _G.PLAYER_V_PLAYER,
        icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.TogglePVPUI, 1)
        end,
        notCheckable = true
    },
    {
        text = _G.RAID,
        icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleFriendsFrame, 3)
        end,
        notCheckable = true
    },
    {
        text = _G.GM_EMAIL_NAME,
        icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            securecall(_G.ToggleHelpFrame)
        end,
        notCheckable = true
    },
    {
        text = _G.CHANNEL,
        icon = 'Interface\\CHATFRAME\\UI-ChatIcon-ArmoryChat-AwayMobile',
        func = function()
            ToggleChannelFrame()
        end,
        notCheckable = true
    },
    {
        text = L['Calendar'],
        func = function()
            if InCombatLockdown() then
                _G.UIErrorsFrame:AddMessage('|cffff0000' .. _G.ERR_NOT_IN_COMBAT .. '|r')
                return
            end
            if not _G.CalendarFrame then
                LoadAddOn('Blizzard_Calendar')
            end
            Calendar_Toggle()
        end,
        notCheckable = true
    },
    {
        text = _G.BATTLEFIELD_MINIMAP,
        colorCode = '|cff999999',
        func = function()
            if not _G.BattlefieldMapFrame then
                LoadAddOn('Blizzard_BattlefieldMap')
            end
            _G.BattlefieldMapFrame:Toggle()
        end,
        notCheckable = true
    },
    {
        text = '',
        isTitle = true,
        notCheckable = true
    },
    {
        text = _G.ADDONS,
        isTitle = true,
        notCheckable = true
    },
    {
        text = _G.RELOADUI,
        colorCode = '|cff999999',
        func = function()
            ReloadUI()
        end,
        notCheckable = true
    }
}

function MM:Minimap_OnMouseWheel(zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

function MM:Minimap_OnMouseUp(btn)
    if btn == 'MiddleButton' then
        if InCombatLockdown() then
            _G.UIErrorsFrame:AddMessage(C.InfoColor .. _G.ERR_NOT_IN_COMBAT)
            return
        end
        EasyMenu(MM.MenuList, F.EasyMenu, 'cursor', 0, 0, 'MENU', 3)
    elseif btn == 'RightButton' then
        ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
    else
        Minimap_OnClick(self)
    end
end

function MM:MouseFunc()
    map:EnableMouseWheel(true)
    map:SetScript('OnMouseWheel', MM.Minimap_OnMouseWheel)
    map:SetScript('OnMouseUp', MM.Minimap_OnMouseUp)
end

function MM:HybridMinimapOnLoad(addon)
    if addon == 'Blizzard_HybridMinimap' then
        MM:SetupHybridMinimap()
        F:UnregisterEvent(self, MM.HybridMinimapOnLoad)
    end
end

function MM:SetupHybridMinimap()
    local mapCanvas = _G.HybridMinimap.MapCanvas
    local rectangleMask = _G.HybridMinimap:CreateMaskTexture()

    rectangleMask:SetTexture(C.Assets.mask_tex)
    rectangleMask:SetAllPoints(_G.HybridMinimap)

    _G.HybridMinimap.RectangleMask = rectangleMask
    mapCanvas:SetMaskTexture(rectangleMask)
    mapCanvas:SetUseMaskTexture(true)

    _G.HybridMinimap.CircleMask:SetTexture('')
end

function MM:UpdateMinimapScale()
    local scale = C.DB.Map.MinimapScale
    map:SetScale(scale)
    map.backdrop:SetSize(256 * scale, 190 * scale)
    map.mover:SetSize(256 * scale, 190 * scale)
end

function MM:HideInCombat()
    if not C.DB.Map.HideMinimapInCombat then
        return
    end

    _G.Minimap.backdrop:RegisterEvent('PLAYER_REGEN_ENABLED')
    _G.Minimap.backdrop:RegisterEvent('PLAYER_REGEN_DISABLED')
    _G.Minimap.backdrop:HookScript(
        'OnEvent',
        function(self, event)
            if event == 'PLAYER_REGEN_ENABLED' then
                F:UIFrameFadeIn(self, .1, self:GetAlpha(), 1)
                F:UIFrameFadeIn(_G.Minimap, .1, self:GetAlpha(), 1)
                print('show')
            elseif event == 'PLAYER_REGEN_DISABLED' then
                F:UIFrameFadeOut(self, .1, self:GetAlpha(), 0)
                F:UIFrameFadeOut(_G.Minimap, .1, self:GetAlpha(), 0)
                print('hide')
            end
        end
    )
end

function MM:OnLogin()
    F:RegisterEvent('ADDON_LOADED', MM.HybridMinimapOnLoad)

    MM:ReskinMinimap()
    MM:UpdateMinimapScale()
    MM:CreateGarrisonButton()
    MM:CreateCalendar()
    MM:CreateZoneText()
    MM:CreateMailButton()
    MM:CreateDifficultyFlag()
    MM:CreateQueueStatusButton()
    MM:WhoPings()
    MM:MouseFunc()
    MM:ProgressBar()
    MM:HideInCombat()
end
