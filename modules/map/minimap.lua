local F, C = unpack(select(2, ...))
local MAP = F:GetModule('Map')


-- Cleanup Cluster

function MAP:RemoveBlizzStuff()
    _G.MinimapCluster:EnableMouse(false)
    _G.Minimap:SetArchBlobRingScalar(0)
    _G.Minimap:SetQuestBlobRingScalar(0)

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
        'MiniMapChallengeMode',
    }

    for _, v in pairs(frames) do
        F.HideObject(_G[v])
    end
end

-- Rectangular Minimap

function MAP:RestyleMinimap()
    local texturePath = C.Assets.Texture.MinimapMask
    local diff = 256 - 190
    local halfDiff = math.ceil(diff / 2)

    local holder = CreateFrame('Frame', 'FreeUIMinimapHolder', _G.UIParent)
    holder:SetSize(258, 192)
    holder:SetPoint('CENTER', _G.UIParent)
    holder:SetFrameStrata('BACKGROUND')
    holder:SetScale(C.DB.Map.MinimapScale)
    holder.bg = F.SetBD(holder, 1)
    holder.bg:SetBackdropColor(0, 0, 0, 1)
    -- holder.bg:SetBackdropBorderColor(1, 0, 0, 1)
    _G.Minimap.holder = holder

    local pos = {'BOTTOMRIGHT', _G.UIParent, 'BOTTOMRIGHT', -C.UI_GAP, C.UI_GAP}
    local mover = F.Mover(holder, _G.MINIMAP_LABEL, 'Minimap', pos)
    _G.Minimap.mover = mover

    _G.Minimap:SetClampedToScreen(true)
    _G.Minimap:SetMaskTexture(texturePath)
    _G.Minimap:SetSize(256, 256)
    _G.Minimap:SetHitRectInsets(0, 0, halfDiff * C.MULT, halfDiff * C.MULT)
    _G.Minimap:SetClampRectInsets(0, 0, 0, 0)
    _G.Minimap:ClearAllPoints()
    _G.Minimap:SetPoint('CENTER', holder)

    _G.Minimap.diff = diff
    _G.Minimap.halfDiff = halfDiff
end

-- Hybrid Minimap (Torghast)

function MAP:RestyleHybridMinimap()
    local mapCanvas = _G.HybridMinimap.MapCanvas
    local rectangleMask = _G.HybridMinimap:CreateMaskTexture()

    rectangleMask:SetTexture(C.Assets.Texture.MinimapMask)
    rectangleMask:SetAllPoints(_G.HybridMinimap)

    _G.HybridMinimap.RectangleMask = rectangleMask
    mapCanvas:SetMaskTexture(rectangleMask)
    mapCanvas:SetUseMaskTexture(true)

    _G.HybridMinimap.CircleMask:SetTexture('')
end

-- Scale

function MAP:UpdateMinimapScale()
    local scale = C.DB.Map.MinimapScale

    _G.Minimap.holder:SetScale(scale)
    _G.Minimap:SetScale(scale)
    if _G.Minimap.mover then
        _G.Minimap.mover:SetScale(scale)
    end
end

-- Mail

function MAP:CreateMailButton()
    local mail = _G.MiniMapMailFrame
    local icon = _G.MiniMapMailIcon

    mail:ClearAllPoints()
    mail:SetPoint('BOTTOM', _G.Minimap, 0, _G.Minimap.halfDiff)
    icon:SetTexture(C.Assets.Texture.Mail)
    icon:SetSize(21, 21)
    icon:SetVertexColor(1, .8, 0)
end

-- Calendar

function MAP:CreateCalendar()
    local timeFrame = _G.GameTimeFrame

    if not timeFrame.styled then
        timeFrame:SetNormalTexture(nil)
        timeFrame:SetPushedTexture(nil)
        timeFrame:SetHighlightTexture(nil)
        timeFrame:SetSize(24, 12)
        timeFrame:SetParent(_G.Minimap)
        timeFrame:ClearAllPoints()
        timeFrame:SetPoint('TOPRIGHT', _G.Minimap, -4, -10 - _G.Minimap.halfDiff)
        timeFrame:SetHitRectInsets(0, 0, 0, 0)

        for i = 1, timeFrame:GetNumRegions() do
            local region = select(i, timeFrame:GetRegions())
            if region.SetTextColor then
                region:SetTextColor(147 / 255, 211 / 255, 231 / 255)
                region:SetJustifyH('RIGHT')
                F:SetFS(region, C.Assets.Font.Bold, 12, 'OUTLINE')
                break
            end
        end

        timeFrame.styled = true
    end
    timeFrame:Show()
    timeFrame:SetFrameStrata('MEDIUM')

    -- Calendar invites
    _G.GameTimeCalendarInvitesTexture:ClearAllPoints()
    _G.GameTimeCalendarInvitesTexture:SetParent('Minimap')
    _G.GameTimeCalendarInvitesTexture:SetPoint('TOPRIGHT')

    local invt = CreateFrame('Button', nil, _G.UIParent)
    invt:SetPoint('TOPRIGHT', _G.Minimap, 'TOPLEFT', -6, -6)
    invt:SetSize(300, 80)
    invt:Hide()
    F.SetBD(invt)
    F.CreateFS(invt, C.Assets.Font.Regular, 14, 'OUTLINE', _G.GAMETIME_TOOLTIP_CALENDAR_INVITES, 'BLUE')

    local function updateInviteVisibility()
        invt:SetShown(C_Calendar.GetNumPendingInvites() > 0)
    end
    F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
    F:RegisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)

    invt:SetScript('OnClick', function(_, btn)
        invt:Hide()
        if btn == 'LeftButton' then
            _G.ToggleCalendar()
        end
        F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
        F:UnregisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)
    end)
end

-- Difficulty Flag

function MAP:UpdateDifficultyFlag()
    local diffText = _G.Minimap.DiffText
    local inInstance, instanceType = IsInInstance()
    local difficulty = select(3, GetInstanceInfo())
    local numplayers = select(9, GetInstanceInfo())
    local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or ''

    local norm = string.format('|cff1eff00%s|r', 'N')
    local hero = string.format('|cff0070dd%s|r', 'H')
    local myth = string.format('|cffa335ee%s|r', 'M')
    local lfr = string.format('|cffff8000%s|r', 'LFR')
    local mp = string.format('|cffff0000%s|r', 'M+')
    local pvp = string.format('|cffff0007%s|r', 'PvP')

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
            diffText:SetText(mplusdiff .. mp)
        elseif difficulty == 9 then -- 40 Player
            -- elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
            --     diffText:SetText(string.format('%s %s', hero, 'Scen'))
            -- elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
            --     diffText:SetText(string.format('%s %s', norm, 'Scen'))
            -- elseif difficulty == 40 then -- Mythic Scenario
            --     diffText:SetText(string.format('%s %s', myth, 'Scen'))
            diffText:SetText('40')
        elseif difficulty == 14 then -- Normal Raid
            diffText:SetText(numplayers .. norm)
        elseif difficulty == 15 then -- Heroic Raid
            diffText:SetText(numplayers .. hero)
        elseif difficulty == 16 then -- Mythic Raid
            diffText:SetText(numplayers .. myth)
        elseif difficulty == 17 then -- LFR
            -- elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
            --     diffText:SetText('EScen')
            diffText:SetText(numplayers .. lfr)
        elseif difficulty == 23 then -- Mythic Party
            diffText:SetText('5' .. myth)
        elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
            diffText:SetText('TW')
        elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
            -- elseif difficulty == 29 then -- PvEvP Scenario
            --     diffText:SetText('PvEvP')
            diffText:SetText(pvp)
        elseif difficulty == 147 then -- Normal Scenario (Warfronts)
            diffText:SetText('WF')
        elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
            diffText:SetText(string.format('WF'))
        end
    elseif instanceType == 'pvp' or instanceType == 'arena' then
        diffText:SetText(pvp)
    else
        diffText:SetText('')
    end

    if not inInstance then
        _G.Minimap.DiffFlag:SetAlpha(0)
    else
        _G.Minimap.DiffFlag:SetAlpha(1)
    end
end

function MAP:CreateDifficultyFlag()
    local diffFlag = CreateFrame('Frame', nil, _G.Minimap)
    diffFlag:SetSize(80, 40)
    diffFlag:SetPoint('TOPLEFT', _G.Minimap, 6, -_G.Minimap.halfDiff - 10)
    diffFlag:SetFrameLevel(_G.Minimap:GetFrameLevel() + 2)
    diffFlag.text = F.CreateFS(diffFlag, C.Assets.Font.Bold, 12, true, '', nil, true, 'TOPLEFT', 0, 0)

    _G.Minimap.DiffFlag = diffFlag
    _G.Minimap.DiffText = diffFlag.text

    _G.Minimap.DiffFlag:RegisterEvent('PLAYER_ENTERING_WORLD')
    _G.Minimap.DiffFlag:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
    _G.Minimap.DiffFlag:RegisterEvent('INSTANCE_GROUP_SIZE_CHANGED')
    _G.Minimap.DiffFlag:RegisterEvent('ZONE_CHANGED_NEW_AREA')
    _G.Minimap.DiffFlag:RegisterEvent('CHALLENGE_MODE_START')
    _G.Minimap.DiffFlag:RegisterEvent('CHALLENGE_MODE_COMPLETED')
    _G.Minimap.DiffFlag:RegisterEvent('CHALLENGE_MODE_RESET')
    _G.Minimap.DiffFlag:SetScript('OnEvent', MAP.UpdateDifficultyFlag)
end

-- Garrision

function MAP:CreateGarrisonButton()
    _G.GarrisonLandingPageMinimapButton:SetScale(.5)
    hooksecurefunc('GarrisonLandingPageMinimapButton_UpdateIcon', function(self)
        self:ClearAllPoints()
        self:SetPoint('BOTTOMLEFT', _G.Minimap, 0, _G.Minimap.halfDiff + 30)
    end)
end

-- Zone Text

local function UpdateZoneText()
    if GetSubZoneText() == '' then
        _G.Minimap.ZoneText:SetText(GetZoneText())
    else
        _G.Minimap.ZoneText:SetText(GetSubZoneText())
    end
    _G.Minimap.ZoneText:SetTextColor(_G.ZoneTextString:GetTextColor())
end

function MAP:CreateZoneText()
    _G.ZoneTextString:ClearAllPoints()
    _G.ZoneTextString:SetPoint('TOP', _G.Minimap, 0, -_G.Minimap.halfDiff - 10)
    _G.ZoneTextString:SetFont(C.Assets.Font.Header, 22)
    _G.SubZoneTextString:SetFont(C.Assets.Font.Header, 22)
    _G.PVPInfoTextString:SetFont(C.Assets.Font.Header, 22)
    _G.PVPArenaTextString:SetFont(C.Assets.Font.Header, 22)

    local zoneText = F.CreateFS(_G.Minimap, C.Assets.Font.Header, 16, nil, '', nil, 'THICK')
    zoneText:SetPoint('TOP', _G.Minimap, 0, -_G.Minimap.halfDiff - 10)
    zoneText:SetSize(_G.Minimap:GetWidth(), 30)
    zoneText:SetJustifyH('CENTER')
    zoneText:Hide()

    _G.Minimap.ZoneText = zoneText

    _G.Minimap:HookScript('OnUpdate', function()
        UpdateZoneText()
    end)

    _G.Minimap:HookScript('OnEnter', function()
        _G.Minimap.ZoneText:Show()
    end)

    _G.Minimap:HookScript('OnLeave', function()
        _G.Minimap.ZoneText:Hide()
    end)
end

-- Queue Status

function MAP:CreateQueueStatusButton()
    _G.QueueStatusMinimapButton:ClearAllPoints()
    _G.QueueStatusMinimapButton:SetPoint('BOTTOMRIGHT', _G.Minimap, 0, _G.Minimap.halfDiff)
    _G.QueueStatusMinimapButtonBorder:Hide()
    _G.QueueStatusMinimapButtonIconTexture:SetTexture(nil)
    _G.QueueStatusFrame:ClearAllPoints()
    _G.QueueStatusFrame:SetPoint('BOTTOMRIGHT', _G.Minimap, 'BOTTOMLEFT', -4, _G.Minimap.halfDiff)

    local queueIcon = _G.Minimap:CreateTexture(nil, 'ARTWORK')
    queueIcon:SetPoint('CENTER', _G.QueueStatusMinimapButton)
    queueIcon:SetSize(50, 50)
    queueIcon:SetTexture('Interface\\Minimap\\Raid_Icon')
    local anim = queueIcon:CreateAnimationGroup()
    anim:SetLooping('REPEAT')
    anim.rota = anim:CreateAnimation('Rotation')
    anim.rota:SetDuration(2)
    anim.rota:SetDegrees(360)
    hooksecurefunc('QueueStatusFrame_Update', function()
        queueIcon:SetShown(_G.QueueStatusMinimapButton:IsShown())
    end)
    hooksecurefunc('EyeTemplate_StartAnimating', function()
        anim:Play()
    end)
    hooksecurefunc('EyeTemplate_StopAnimating', function()
        anim:Stop()
    end)
end

-- Ping

function MAP:WhoPings()
    if not C.DB.Map.WhoPings then
        return
    end

    local f = CreateFrame('Frame', nil, _G.Minimap)
    f:SetAllPoints()
    f.text = F.CreateFS(f, C.Assets.Font.Bold, 14, 'OUTLINE', '', nil, true, 'TOP', 0, -4)

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

        local r, g, b = F:ClassColor(C.CLASS)
        local name = GetUnitName(unit)

        anim:Stop()
        f.text:SetText(name)
        f.text:SetTextColor(r, g, b)
        anim:Play()
    end)
end

function MAP:SetupMinimap()
    if not C.DB.Map.Minimap then
        return
    end

    MAP:RemoveBlizzStuff()
    MAP:RestyleMinimap()
    MAP:UpdateMinimapScale()
    MAP:CreateGarrisonButton()
    MAP:CreateCalendar()
    MAP:CreateZoneText()
    MAP:CreateMailButton()
    MAP:CreateDifficultyFlag()
    MAP:CreateQueueStatusButton()
    MAP:WhoPings()
    MAP:MouseFunc()
    MAP:UpdateMinimapFader()
    MAP:CreateProgressBar()

    F:HookAddOn('Blizzard_HybridMinimap', function(self)
        MAP:RestyleHybridMinimap()
    end)

    _G.DropDownList1:SetClampedToScreen(true)

    function _G.GetMinimapShape() -- LibDBIcon
        if not MAP.initialized then
            MAP:UpdateMinimapScale()
            MAP.initialized = true
        end
        return 'SQUARE'
    end
end
