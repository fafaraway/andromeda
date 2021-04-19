local F, C, L = unpack(select(2, ...))
local MAP = F.MAP

local offset = 256 / 8

function MAP:CreateMailButton()
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('BOTTOM', Minimap, 0, offset - 4)
	MiniMapMailIcon:SetTexture(C.Assets.mail_tex)
	MiniMapMailIcon:SetSize(21, 21)
	MiniMapMailIcon:SetVertexColor(1, .8, 0)
end

function MAP:CreateCalendar()
	if not GameTimeFrame.styled then
		GameTimeFrame:SetNormalTexture(nil)
		GameTimeFrame:SetPushedTexture(nil)
		GameTimeFrame:SetHighlightTexture(nil)
		GameTimeFrame:SetSize(24, 12)
		GameTimeFrame:SetParent(Minimap)
		GameTimeFrame:ClearAllPoints()
		GameTimeFrame:SetPoint('TOPRIGHT', Minimap, -4, -offset - 10)
		GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)

		for i = 1, GameTimeFrame:GetNumRegions() do
			local region = select(i, GameTimeFrame:GetRegions())
			if region.SetTextColor then
				region:SetTextColor(147 / 255, 211 / 255, 231 / 255)
				region:SetJustifyH('RIGHT')
				F:SetFS(region, C.Assets.Fonts.Bold, 12, 'OUTLINE')
				break
			end
		end

		GameTimeFrame.styled = true
	end
	GameTimeFrame:Show()

	-- Calendar invites
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent('Minimap')
	GameTimeCalendarInvitesTexture:SetPoint('TOPRIGHT')

	local Invt = CreateFrame('Button', nil, UIParent)
	Invt:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -6, -6)
	Invt:SetSize(300, 80)
	Invt:Hide()
	F.SetBD(Invt)
	F.CreateFS(Invt, C.Assets.Fonts.Regular, 14, 'OUTLINE', GAMETIME_TOOLTIP_CALENDAR_INVITES, 'BLUE')

	local function updateInviteVisibility()
		Invt:SetShown(C_Calendar.GetNumPendingInvites() > 0)
	end
	F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
	F:RegisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)

	Invt:SetScript(
		'OnClick',
		function(_, btn)
			Invt:Hide()
			if btn == 'LeftButton' and not InCombatLockdown() then
				ToggleCalendar()
			end
			F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
			F:UnregisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)
		end
	)
end

function MAP:CreateDifficultyFlag()
	local diffFlag = CreateFrame('Frame', nil, Minimap)
	diffFlag:SetSize(40, 40)
	diffFlag:SetPoint('TOPLEFT', Minimap, 0, -offset)
	diffFlag:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	-- diffFlag.texture = diffFlag:CreateTexture(nil, 'OVERLAY')
	-- diffFlag.texture:SetAllPoints(diffFlag)
	-- diffFlag.texture:SetTexture(C.Assets.diff_tex)
	-- diffFlag.texture:SetVertexColor(C.r, C.g, C.b)
	diffFlag.text = F.CreateFS(diffFlag, C.Assets.Fonts.Bold, 11, nil, '', nil, true, 'CENTER', 0, 0)
	Minimap.DiffFlag = diffFlag
	Minimap.DiffText = diffFlag.text
end

function MAP:UpdateDifficultyFlag()
	local diffText = Minimap.DiffText
	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or ''

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
		diffText:SetText(format('|cffFFFF00%s|r', 'PvP'))
	else
		diffText:SetText('')
	end

	if not inInstance then
		Minimap.DiffFlag:SetAlpha(0)
	else
		Minimap.DiffFlag:SetAlpha(1)
	end
end

function MAP:CreateGarrisonButton()
	GarrisonLandingPageMinimapButton:SetScale(.5)
	hooksecurefunc(
		'GarrisonLandingPageMinimapButton_UpdateIcon',
		function(self)
			self:ClearAllPoints()
			self:SetPoint('BOTTOMLEFT', Minimap, 0, offset + 30)
		end
	)
end

local function UpdateZoneText()
	if GetSubZoneText() == '' then
		Minimap.ZoneText:SetText(GetZoneText())
	else
		Minimap.ZoneText:SetText(GetSubZoneText())
	end
	Minimap.ZoneText:SetTextColor(ZoneTextString:GetTextColor())
end

function MAP:CreateZoneText()
	ZoneTextString:ClearAllPoints()
	ZoneTextString:SetPoint('TOP', Minimap, 0, -offset - 10)
	ZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
	SubZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
	PVPInfoTextString:SetFont(C.Assets.Fonts.Header, 22)
	PVPArenaTextString:SetFont(C.Assets.Fonts.Header, 22)

	local zoneText = F.CreateFS(Minimap, C.Assets.Fonts.Header, 16, nil, '', nil, 'THICK')
	zoneText:SetPoint('TOP', Minimap, 0, -offset - 10)
	zoneText:SetSize(Minimap:GetWidth(), 30)
	zoneText:SetJustifyH('CENTER')
	zoneText:Hide()

	Minimap.ZoneText = zoneText

	Minimap:HookScript(
		'OnUpdate',
		function()
			UpdateZoneText()
		end
	)

	Minimap:HookScript(
		'OnEnter',
		function()
			Minimap.ZoneText:Show()
		end
	)

	Minimap:HookScript(
		'OnLeave',
		function()
			Minimap.ZoneText:Hide()
		end
	)
end

function MAP:CreateQueueStatusButton()
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint('BOTTOMRIGHT', Minimap, 0, offset)
	QueueStatusMinimapButtonBorder:Hide()
	QueueStatusMinimapButtonIconTexture:SetTexture(nil)
	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -4, offset)

	local queueIcon = Minimap:CreateTexture(nil, 'ARTWORK')
	queueIcon:SetPoint('CENTER', QueueStatusMinimapButton)
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
			queueIcon:SetShown(QueueStatusMinimapButton:IsShown())
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

function MAP:WhoPings()
	if not C.DB.map.who_pings then
		return
	end

	local f = CreateFrame('Frame', nil, Minimap)
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
			end -- ignore player ping

			local class = select(2, UnitClass(unit))
			local r, g, b = F:ClassColor(class)
			local name = GetUnitName(unit)

			anim:Stop()
			f.text:SetText(name)
			f.text:SetTextColor(r, g, b)
			anim:Play()
		end
	)
end

function MAP:Minimap_OnMouseWheel(zoom)
	if zoom > 0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut()
	end
end

function MAP:Minimap_OnMouseUp(btn)
	if btn == 'MiddleButton' then
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(C.InfoColor .. ERR_NOT_IN_COMBAT)
			return
		end
		EasyMenu(MAP.MenuList, F.EasyMenu, 'cursor', 0, 0, 'MENU', 3)
	elseif btn == 'RightButton' then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	else
		Minimap_OnClick(self)
	end
end

function MAP:SetupHybridMinimap()
	local mapCanvas = HybridMinimap.MapCanvas
	local rectangleMask = HybridMinimap:CreateMaskTexture()
	rectangleMask:SetTexture(C.Assets.mask_tex)
	rectangleMask:SetAllPoints(HybridMinimap)
	HybridMinimap.RectangleMask = rectangleMask
	mapCanvas:SetMaskTexture(rectangleMask)
	mapCanvas:SetUseMaskTexture(true)

	HybridMinimap.CircleMask:SetTexture('')
end

function MAP:HybridMinimapOnLoad(addon)
	if addon == 'Blizzard_HybridMinimap' then
		MAP:SetupHybridMinimap()
		F:UnregisterEvent(self, MAP.HybridMinimapOnLoad)
	end
end

function MAP:UpdateMinimapScale()
	local scale = C.DB.map.minimap_scale
	Minimap:SetScale(scale)
	Minimap.backdrop:SetSize(256 * scale, 190 * scale)
	Minimap.mover:SetSize(256 * scale, 190 * scale)
end

function MAP:Minimap()
	DropDownList1:SetClampedToScreen(true)

	local backdrop = CreateFrame('Frame', nil, UIParent)
	backdrop:SetSize(256, 190)
	backdrop:SetFrameStrata('BACKGROUND')
	backdrop.bg = F.SetBD(backdrop)
	backdrop.bg:SetBackdropColor(0, 0, 0, 1)
    backdrop.bg:SetBackdropBorderColor(0, 0, 0, 1)
	Minimap.backdrop = backdrop

	Minimap:SetMaskTexture(C.Assets.mask_tex)
	Minimap:SetSize(256, 256)
	Minimap:SetHitRectInsets(0, 0, Minimap:GetHeight() / 8, Minimap:GetHeight() / 8)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	Minimap:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	Minimap:ClearAllPoints()
	Minimap:SetPoint('CENTER', backdrop)

	local mover = F.Mover(backdrop, L['MAP_MOVER_MINIMAP'], 'Minimap', {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -C.UIGap, C.UIGap})
	Minimap.mover = mover

	function GetMinimapShape()
		return 'SQUARE'
	end

	-- ClockFrame
	LoadAddOn('Blizzard_TimeManager')
	local region = TimeManagerClockButton:GetRegions()
	region:Hide()
	TimeManagerClockButton:Hide()

	-- Mousewheel Zoom
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript('OnMouseWheel', MAP.Minimap_OnMouseWheel)
	Minimap:SetScript('OnMouseUp', MAP.Minimap_OnMouseUp)

	-- Hide Blizz
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
	MinimapCluster:EnableMouse(false)
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetQuestBlobRingScalar(0)

	MAP:UpdateMinimapScale()
	MAP:CreateGarrisonButton()
	MAP:CreateCalendar()
	MAP:CreateZoneText()
	MAP:CreateMailButton()
	MAP:CreateDifficultyFlag()
	MAP:CreateQueueStatusButton()
	MAP:WhoPings()
	MAP:ProgressBar()

	-- Update difficulty flag
	Minimap.DiffFlag:RegisterEvent('PLAYER_ENTERING_WORLD')
	Minimap.DiffFlag:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
	Minimap.DiffFlag:RegisterEvent('INSTANCE_GROUP_SIZE_CHANGED')
	Minimap.DiffFlag:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	Minimap.DiffFlag:RegisterEvent('CHALLENGE_MODE_START')
	Minimap.DiffFlag:RegisterEvent('CHALLENGE_MODE_COMPLETED')
	Minimap.DiffFlag:RegisterEvent('CHALLENGE_MODE_RESET')
	Minimap.DiffFlag:SetScript('OnEvent', MAP.UpdateDifficultyFlag)

	F:RegisterEvent('ADDON_LOADED', MAP.HybridMinimapOnLoad)
end
