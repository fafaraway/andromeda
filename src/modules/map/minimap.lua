local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('Map')
local oUF = F.Libs.oUF

-- Cleanup Cluster

function MAP:RemoveBlizzStuff()
    local Minimap = _G.Minimap
    local MinimapCluster = _G.MinimapCluster
    local MinimapCompassTexture = _G.MinimapCompassTexture
    local TimeManagerClockButton = _G.TimeManagerClockButton

    F:DisableEditMode(MinimapCluster)
    MinimapCluster:EnableMouse(false)
    MinimapCluster.Tracking:Hide()
    MinimapCluster.BorderTop:Hide()
    MinimapCluster.ZoneTextButton:Hide()
    Minimap:SetArchBlobRingScalar(0)
    Minimap:SetQuestBlobRingScalar(0)

    F.HideObject(Minimap.ZoomIn)
    F.HideObject(Minimap.ZoomOut)
    F.HideObject(MinimapCompassTexture)

    -- ClockFrame
    LoadAddOn('Blizzard_TimeManager')
    local region = TimeManagerClockButton:GetRegions()
    region:Hide()
    TimeManagerClockButton:Hide()

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
        'MiniMapChallengeMode',
        'GameTimeFrame',
        'MinimapCompassTexture',
        'AddonCompartmentFrame',
    }

    for _, v in pairs(frames) do
        local object = _G[v]
        if object then
            F.HideObject(object)
        end
    end
end

-- Rectangular Minimap

function MAP:RestyleMinimap()
    local Minimap = _G.Minimap
    local texturePath = C.Assets.Textures.MinimapMask
    local diff = 256 - 190
    local halfDiff = ceil(diff / 2)

    local holder = CreateFrame('Frame', C.ADDON_TITLE .. 'MinimapHolder', _G.UIParent)
    holder:SetSize(256, 190)
    holder:SetPoint('CENTER', _G.UIParent)
    holder:SetFrameStrata('BACKGROUND')
    holder:SetScale(C.DB.Map.MinimapScale)
    holder.bg = F.SetBD(holder, 1)
    holder.bg:SetBackdropColor(0, 0, 0, 1)
    holder.bg:SetBackdropBorderColor(0, 0, 0, 1)
    Minimap.Holder = holder

    local pos = { 'BOTTOMRIGHT', _G.UIParent, 'BOTTOMRIGHT', -C.UI_GAP, C.UI_GAP }
    local mover = F.Mover(holder, _G.MINIMAP_LABEL, 'Minimap', pos)

    hooksecurefunc(Minimap, 'SetPoint', function(frame, _, parent)
        if parent ~= mover then
            frame:SetPoint('TOPRIGHT', mover)
        end
    end)

    Minimap.mover = mover

    Minimap:SetClampedToScreen(true)
    Minimap:SetMaskTexture(texturePath)
    Minimap:SetSize(256, 256)
    Minimap:SetHitRectInsets(0, 0, halfDiff * C.MULT, halfDiff * C.MULT)
    Minimap:SetClampRectInsets(0, 0, 0, 0)
    Minimap:ClearAllPoints()
    Minimap:SetPoint('CENTER', mover)

    Minimap.diff = diff
    Minimap.halfDiff = halfDiff
end

-- Hybrid Minimap (Torghast)

function MAP:RestyleHybridMinimap()
    local HybridMinimap = _G.HybridMinimap
    local mapCanvas = HybridMinimap.MapCanvas
    local rectangleMask = HybridMinimap:CreateMaskTexture()

    rectangleMask:SetTexture(C.Assets.Textures.MinimapMask)
    rectangleMask:SetAllPoints(HybridMinimap)

    HybridMinimap.RectangleMask = rectangleMask
    mapCanvas:SetMaskTexture(rectangleMask)
    mapCanvas:SetUseMaskTexture(true)

    HybridMinimap.CircleMask:SetTexture('')
end

-- Scale

function MAP:UpdateMinimapScale()
    local Minimap = _G.Minimap
    local scale = C.DB.Map.MinimapScale

    Minimap:SetScale(scale)
    if Minimap.Holder then
        Minimap.Holder:SetScale(scale)
    end
    if Minimap.mover then
        Minimap.mover:SetScale(scale)
    end
end

-- LibDBIcon

function MAP:GetMinimapShape()
    return 'SQUARE'
end

function MAP:SetGetMinimapShape()
    _G.GetMinimapShape = MAP.GetMinimapShape

    _G.Minimap:SetSize(256, 256)
end

-- Mail Icon

local function updateIndicatorFrameAnchor(frame, _, _, _, _, _, force)
    if force then
        return
    end

    frame:ClearAllPoints()
    frame:SetPoint('BOTTOM', _G.Minimap, 'BOTTOM', 0, _G.Minimap.halfDiff + 10, true)
end

function MAP:CreateMailButton()
    local icon = _G.MiniMapMailIcon
    local indicatorFrame = _G.MinimapCluster.IndicatorFrame

    if indicatorFrame then
        updateIndicatorFrameAnchor(indicatorFrame)
        hooksecurefunc(indicatorFrame, 'SetPoint', updateIndicatorFrameAnchor)
        indicatorFrame:SetFrameLevel(11)
        icon:SetScale(1.2)
        icon:SetPoint('CENTER', indicatorFrame)
    end
end

-- Calendar Invite

function MAP:CreatePendingInvitation()
    local Minimap = _G.Minimap

    -- Calendar invites
    _G.GameTimeCalendarInvitesTexture:ClearAllPoints()
    _G.GameTimeCalendarInvitesTexture:SetParent(Minimap)
    _G.GameTimeCalendarInvitesTexture:SetPoint('TOPRIGHT')

    local invt = CreateFrame('Button', nil, _G.UIParent)
    invt:SetPoint('TOPRIGHT', _G.Minimap, 'TOPLEFT', -6, -6)
    invt:SetSize(300, 80)
    invt:Hide()
    F.SetBD(invt)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.CreateFS(invt, C.Assets.Fonts.Regular, 14, outline or nil, _G.GAMETIME_TOOLTIP_CALENDAR_INVITES, 'BLUE', outline and 'NONE' or 'THICK')

    local function updateInviteVisibility()
        invt:SetShown(C_Calendar.GetNumPendingInvites() > 0)
    end
    F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
    F:RegisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)

    invt:SetScript('OnClick', function(_, btn)
        invt:Hide()
        if btn == 'LeftButton' then
            ToggleCalendar()
        end
        F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
        F:UnregisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)
    end)
end

-- Difficulty Flag

local function UpdateDifficultyFlag()
    F.HideObject(_G.MinimapCluster.InstanceDifficulty)

    local frame = _G.Minimap.DiffFlag
    local text = _G.Minimap.DiffText

    local inInstance, instanceType = IsInInstance()
    local difficulty = select(3, GetInstanceInfo())
    local numplayers = select(9, GetInstanceInfo())
    local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or ''

    local norm = format('|cff74a1ff%s|r', 'N') -- 蓝色
    local hero = format('|cffff66ff%s|r', 'H') -- 紫色
    local myth = format('|cffff9900%s|r', 'M') -- 橙色
    local lfr = format('|cffcccccc%s|r', 'LFR') -- 白色

    local mp = format('|cffff9900%s|r', 'M+') -- 橙色
    local pvp = format('|cffff0000%s|r', 'PvP') -- 红色
    local wf = format('|cff00ff00%s|r', 'WF') -- 绿色
    local tw = format('|cff00ff00%s|r', 'TW') -- 绿色
    local scen = format('|cffffff00%s|r', 'SCEN') -- 黄色

    if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
        if difficulty == 1 then -- Normal
            text:SetText('5' .. norm)
        elseif difficulty == 2 then -- Heroic
            text:SetText('5' .. hero)
        elseif difficulty == 3 then -- 10 Player
            text:SetText('10' .. norm)
        elseif difficulty == 4 then -- 25 Player
            text:SetText('25' .. norm)
        elseif difficulty == 5 then -- 10 Player (Heroic)
            text:SetText('10' .. hero)
        elseif difficulty == 6 then -- 25 Player (Heroic)
            text:SetText('25' .. hero)
        elseif difficulty == 7 then -- LFR (Legacy)
            text:SetText(lfr)
        elseif difficulty == 8 then -- Mythic Keystone
            text:SetText(mplusdiff .. mp)
        elseif difficulty == 9 then -- 40 Player
            text:SetText('40')
        elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
            text:SetText(scen)
        elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
            text:SetText(scen)
        elseif difficulty == 40 then -- Mythic Scenario
            text:SetText(scen)
        elseif difficulty == 14 then -- Normal Raid
            text:SetText(numplayers .. norm)
        elseif difficulty == 15 then -- Heroic Raid
            text:SetText(numplayers .. hero)
        elseif difficulty == 16 then -- Mythic Raid
            text:SetText(numplayers .. myth)
        elseif difficulty == 17 then -- LFR
            text:SetText(numplayers .. lfr)
        elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
            text:SetText(scen)
        elseif difficulty == 23 then -- Mythic Party
            text:SetText('5' .. myth)
        elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
            text:SetText(tw)
        elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
            text:SetText(pvp)
        elseif difficulty == 29 then -- PvEvP Scenario
            text:SetText('PvEvP')
        elseif difficulty == 147 then -- Normal Scenario (Warfronts)
            text:SetText(wf)
        elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
            text:SetText(wf)
        end
    elseif instanceType == 'pvp' or instanceType == 'arena' then
        text:SetText(pvp)
    else
        text:SetText('')
    end

    if not inInstance then
        frame:SetAlpha(0)
    else
        frame:SetAlpha(1)
    end
end

function MAP:CreateDifficultyFlag()
    local Minimap = _G.Minimap
    local frame = CreateFrame('Frame', nil, Minimap)
    frame:SetSize(64, 32)
    frame:SetPoint('TOPLEFT', Minimap, 4, -Minimap.halfDiff - 4)
    frame:SetFrameLevel(Minimap:GetFrameLevel() + 2)
    local texture = frame:CreateTexture(nil, 'BACKGROUND')
    texture:SetAllPoints()
    texture:SetTexture(C.Assets.Textures.MinimapDifficulty)
    texture:SetVertexColor(0, 0, 0)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    local text = F.CreateFS(frame, C.Assets.Fonts.Bold, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    text:SetPoint('CENTER', frame)
    text:SetJustifyH('CENTER')

    Minimap.DiffFlag = frame
    Minimap.DiffText = text

    frame:RegisterEvent('PLAYER_ENTERING_WORLD')
    frame:RegisterEvent('INSTANCE_GROUP_SIZE_CHANGED')
    frame:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
    frame:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
    frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
    frame:RegisterEvent('GROUP_ROSTER_UPDATE')
    frame:RegisterEvent('CHALLENGE_MODE_START')
    frame:RegisterEvent('CHALLENGE_MODE_COMPLETED')
    frame:RegisterEvent('CHALLENGE_MODE_RESET')

    frame:SetScript('OnEvent', UpdateDifficultyFlag)
end

-- Garrision Icon

local function toggleExpansionLandingPageButton(_, ...)
    --if InCombatLockdown() then UIErrorsFrame:AddMessage(C.RED_COLOR..ERR_NOT_IN_COMBAT) return end -- fix by LibShowUIPanel

    if not C_Garrison.HasGarrison(...) then
        _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. _G.CONTRIBUTION_TOOLTIP_UNLOCKED_WHEN_ACTIVE)
        return
    end

    ShowGarrisonLandingPage(...)
end

MAP.ExpansionMenuList = {
    { text = _G.GARRISON_TYPE_9_0_LANDING_PAGE_TITLE, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_9_0, notCheckable = true },
    { text = _G.WAR_CAMPAIGN, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_8_0, notCheckable = true },
    { text = _G.ORDER_HALL_LANDING_PAGE_TITLE, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_7_0, notCheckable = true },
    { text = _G.GARRISON_LANDING_PAGE_TITLE, func = toggleExpansionLandingPageButton, arg1 = Enum.GarrisonType.Type_6_0, notCheckable = true },
}

local function updateExpansionLandingPageButton(self)
    local Minimap = _G.Minimap

    self:ClearAllPoints()
    self:SetPoint('BOTTOMLEFT', Minimap, -8, Minimap.halfDiff - 8)
    self:GetNormalTexture():SetTexture('Interface\\Store\\category-icon-enchantscroll')
    self:GetPushedTexture():SetTexture('Interface\\Store\\category-icon-enchantscroll')
    self:GetHighlightTexture():SetTexture('Interface\\Store\\category-icon-enchantscroll')
    self:SetSize(50, 50)
end

function MAP:CreateExpansionLandingPageButton()
    local elpBtn = _G.ExpansionLandingPageMinimapButton

    if not elpBtn then
        return
    end

    updateExpansionLandingPageButton(elpBtn)
    elpBtn:HookScript('OnShow', updateExpansionLandingPageButton)
    hooksecurefunc(elpBtn, 'UpdateIcon', updateExpansionLandingPageButton)

    elpBtn:HookScript('OnMouseDown', function(self, btn)
        if btn == 'RightButton' then
            if _G.GarrisonLandingPage and _G.GarrisonLandingPage:IsShown() then
                HideUIPanel(_G.GarrisonLandingPage)
            end

            if _G.ExpansionLandingPage and _G.ExpansionLandingPage:IsShown() then
                HideUIPanel(_G.ExpansionLandingPage)
            end

            EasyMenu(MAP.ExpansionMenuList, F.EasyMenu, self, -80, 0, 'MENU', 1)
        end
    end)

    elpBtn:SetScript('OnEnter', function(self)
        _G.GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
        _G.GameTooltip:SetText(self.title, 1, 1, 1)
        _G.GameTooltip:AddLine(self.description, nil, nil, nil, true)
        _G.GameTooltip:AddLine(L['Right click to switch expansion content'], nil, nil, nil, true)
        _G.GameTooltip:Show()
    end)
end

-- Queue Status

function MAP:CreateQueueStatusButton()
    local Minimap = _G.Minimap

    _G.QueueStatusButton:SetParent(Minimap)
    _G.QueueStatusButton:ClearAllPoints()
    _G.QueueStatusButton:SetPoint('BOTTOMRIGHT', Minimap, 0, Minimap.halfDiff)
    _G.QueueStatusButton:SetFrameLevel(999)
    _G.QueueStatusButton:SetSize(40, 40)
    _G.QueueStatusButtonIcon:SetAlpha(0)
    _G.QueueStatusFrame:ClearAllPoints()
    _G.QueueStatusFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -4, Minimap.halfDiff)

    hooksecurefunc(_G.QueueStatusButton, 'SetPoint', function(button, _, _, _, x)
        if x == -15 then
            button:ClearAllPoints()
            button:SetPoint('BOTTOMRIGHT', Minimap, 0, Minimap.halfDiff)
        end
    end)

    local queueIcon = Minimap:CreateTexture(nil, 'ARTWORK')
    queueIcon:SetPoint('CENTER', _G.QueueStatusButton)
    queueIcon:SetSize(60, 60)
    queueIcon:SetTexture('Interface\\Minimap\\Raid_Icon')

    local anim = queueIcon:CreateAnimationGroup()
    anim:SetLooping('REPEAT')
    anim.rota = anim:CreateAnimation('Rotation')
    anim.rota:SetDuration(2)
    anim.rota:SetDegrees(360)

    hooksecurefunc(_G.QueueStatusFrame, 'Update', function()
        queueIcon:SetShown(_G.QueueStatusButton:IsShown())
    end)

    hooksecurefunc(_G.QueueStatusButton.Eye, 'PlayAnim', function()
        anim:Play()
    end)

    hooksecurefunc(_G.QueueStatusButton.Eye, 'StartPokeAnimationInitial', function()
        anim.rota:SetDuration(0.5)
    end)

    hooksecurefunc(_G.QueueStatusButton.Eye, 'StartPokeAnimationEnd', function()
        anim.rota:SetDuration(2)
    end)
end

-- Ping

function MAP:WhoPings()
    if not C.DB.Map.WhoPings then
        return
    end

    local f = CreateFrame('Frame', nil, _G.Minimap)
    f:SetAllPoints()

    local outline = _G.ANDROMEDA_ADB.FontOutline
    f.text = F.CreateFS(f, C.Assets.Fonts.Bold, 14, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'TOP', 0, -4)

    local anim = f:CreateAnimationGroup()
    anim:SetScript('OnPlay', function()
        f:SetAlpha(1)
    end)
    anim:SetScript('OnFinished', function()
        f:SetAlpha(0)
    end)
    anim.fader = anim:CreateAnimation('Alpha')
    anim.fader:SetFromAlpha(1)
    anim.fader:SetToAlpha(0)
    anim.fader:SetDuration(3)
    anim.fader:SetSmoothing('OUT')
    anim.fader:SetStartDelay(3)

    F:RegisterEvent('MINIMAP_PING', function(_, unit)
        if UnitIsUnit(unit, 'player') then
            return
        end -- ignore player ping

        local r, g, b = F:ClassColor(C.MY_CLASS)
        local name = GetUnitName(unit)

        anim:Stop()
        f.text:SetText(name)
        f.text:SetTextColor(r, g, b)
        anim:Play()
    end)
end

-- Zone Text

local function UpdateZoneText()
    local Minimap = _G.Minimap

    if GetSubZoneText() == '' then
        Minimap.ZoneText:SetText(GetZoneText())
    else
        Minimap.ZoneText:SetText(GetSubZoneText())
    end

    Minimap.ZoneText:SetTextColor(_G.ZoneTextString:GetTextColor())
end

function MAP:CreateZoneText()
    local Minimap = _G.Minimap
    local outline = _G.ANDROMEDA_ADB.FontOutline

    _G.ZoneTextString:ClearAllPoints()
    _G.ZoneTextString:SetPoint('TOP', Minimap, 0, -Minimap.halfDiff - 10)
    _G.ZoneTextString:SetFont(C.Assets.Fonts.Header, 22, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    _G.SubZoneTextString:SetFont(C.Assets.Fonts.Header, 22, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    _G.PVPInfoTextString:SetFont(C.Assets.Fonts.Header, 22, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    _G.PVPArenaTextString:SetFont(C.Assets.Fonts.Header, 22, outline or nil, '', nil, outline and 'NONE' or 'THICK')

    local text = F.CreateFS(Minimap, C.Assets.Fonts.Header, 16, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    text:SetPoint('TOP', Minimap, 0, -Minimap.halfDiff - 10)
    text:SetSize(Minimap:GetWidth(), 30)
    text:SetJustifyH('CENTER')
    text:Hide()

    Minimap.ZoneText = text

    Minimap:HookScript('OnUpdate', function()
        UpdateZoneText()
    end)

    Minimap:HookScript('OnEnter', function()
        Minimap.ZoneText:Show()
    end)

    Minimap:HookScript('OnLeave', function()
        Minimap.ZoneText:Hide()
    end)
end

-- Sound Volume

local function GetCurrentVolume()
    return F:Round(GetCVar('Sound_MasterVolume') * 100)
end

local function GetVolumeColor(cur)
    local r, g, b = oUF:RGBColorGradient(cur, 100, 1, 1, 1, 1, 0.8, 0, 1, 0, 0)
    return r, g, b
end

function MAP:SoundVolume()
    if not C.DB.Map.Volume then
        return
    end

    local f = CreateFrame('Frame', nil, _G.Minimap)
    f:SetAllPoints()
    f:SetFrameLevel(999)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    local text = F.CreateFS(f, C.Assets.Fonts.Heavy, 48, outline or nil, '', nil, outline and 'NONE' or 'THICK')

    local anim = f:CreateAnimationGroup()
    anim:SetScript('OnPlay', function()
        f:SetAlpha(1)
    end)
    anim:SetScript('OnFinished', function()
        f:SetAlpha(0)
    end)
    anim.fader = anim:CreateAnimation('Alpha')
    anim.fader:SetFromAlpha(1)
    anim.fader:SetToAlpha(0)
    anim.fader:SetDuration(3)
    anim.fader:SetSmoothing('OUT')
    anim.fader:SetStartDelay(1)

    MAP.VolumeText = text
    MAP.VolumeAnim = anim
end

-- Mouse Func

local function OnMouseWheel(self, zoom)
    if IsAltKeyDown() and MAP.VolumeText then
        local value = GetCurrentVolume()
        local mult = IsControlKeyDown() and 100 or 5
        value = value + zoom * mult
        if value > 100 then
            value = 100
        end
        if value < 0 then
            value = 0
        end

        SetCVar('Sound_MasterVolume', tostring(value / 100))
        MAP.VolumeText:SetText(value)
        MAP.VolumeText:SetTextColor(GetVolumeColor(value))
        MAP.VolumeAnim:Stop()
        MAP.VolumeAnim:Play()
    else
        if zoom > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end
end

function MAP:BuildDropDown()
    local dropdown = CreateFrame('Frame', 'AndromedaMiniMapTrackingDropDown', _G.UIParent, 'UIDropDownMenuTemplate')
    dropdown:SetID(1)
    dropdown:SetClampedToScreen(true)
    dropdown:Hide()
    dropdown.noResize = true
    _G.UIDropDownMenu_Initialize(dropdown, _G.MiniMapTrackingDropDown_Initialize, 'MENU')

    hooksecurefunc(_G.MinimapCluster.Tracking.Button, 'Update', function()
        if _G.UIDROPDOWNMENU_OPEN_MENU == dropdown then
            UIDropDownMenu_RefreshAll(dropdown)
        end
    end)
    F:LockCVar('minimapTrackingShowAll', '1')

    MAP.MinimapTracking = dropdown
end

local function OnMouseUp(self, btn)
    if not C.DB.Map.Menu then
        return
    end

    if btn == 'MiddleButton' then
        if InCombatLockdown() then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. _G.ERR_NOT_IN_COMBAT)
            return
        end
        EasyMenu(MAP.MenuList, F.EasyMenu, 'cursor', 0, 0, 'MENU', 3)
    elseif btn == 'RightButton' then
        ToggleDropDownMenu(1, nil, MAP.MinimapTracking, self, -100, 100)
    else
        _G.Minimap:OnClick()
    end
end

function MAP:MouseFunc()
    _G.Minimap:EnableMouseWheel(true)
    _G.Minimap:SetScript('OnMouseWheel', OnMouseWheel)
    _G.Minimap:SetScript('OnMouseUp', OnMouseUp)
end

-- Help Tip

local minimapInfo = {
    text = L['Mouse scroll to zoom in or out, hold down the alt key and mouse scroll to adjust game volume, middle click to toggle game menu, right click to toggle track menu.'],
    buttonStyle = _G.HelpTip.ButtonStyle.GotIt,
    targetPoint = _G.HelpTip.Point.LeftEdgeCenter,
    onAcknowledgeCallback = F.HelpInfoAcknowledge,
    callbackArg = 'MinimapInfo',
    alignment = 3,
}

function MAP:CreateHelpTip()
    _G.Minimap:HookScript('OnEnter', function()
        if not _G.ANDROMEDA_ADB.HelpTips.MinimapInfo then
            _G.HelpTip:Show(_G.MinimapCluster, minimapInfo)
        end
    end)
end

--

function MAP:SetupMinimap()
    if not C.DB.Map.Minimap then
        return
    end

    MAP:RemoveBlizzStuff()
    MAP:RestyleMinimap()
    MAP:UpdateMinimapScale()
    MAP:CreateExpansionLandingPageButton()
    MAP:CreatePendingInvitation()
    MAP:CreateZoneText()
    MAP:CreateMailButton()
    MAP:CreateDifficultyFlag()
    MAP:CreateQueueStatusButton()
    MAP:AddOnIconCollector()
    MAP:WhoPings()
    MAP:BuildDropDown()
    MAP:SoundVolume()
    MAP:MouseFunc()
    MAP:CreateHelpTip()
    MAP:UpdateMinimapFader()
    MAP:CreateProgressBar()
    MAP:SetGetMinimapShape()

    F:HookAddOn('Blizzard_HybridMinimap', function(self)
        MAP:RestyleHybridMinimap()
    end)
end
