local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('MAP')


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
				F.SetFS(region, C.Assets.Fonts.Bold, 12, 'OUTLINE')
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
	--[[ local flags = {'MiniMapInstanceDifficulty', 'GuildInstanceDifficulty', 'MiniMapChallengeMode'}
	for _, v in pairs(flags) do
		local flag = _G[v]
		flag:ClearAllPoints()
		flag:SetPoint('TOPLEFT', Minimap, 0, -offset - 10)
		flag:SetScale(.9)
	end ]]
	local diffFlag = CreateFrame('Frame', nil, Minimap)
	diffFlag:SetSize(40, 40)
	diffFlag:SetPoint('TOPLEFT', Minimap, 0, -offset)
	diffFlag:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	diffFlag.texture = diffFlag:CreateTexture(nil, 'OVERLAY')
	diffFlag.texture:SetAllPoints(diffFlag)
	diffFlag.texture:SetTexture(C.Assets.diff_tex)
	diffFlag.texture:SetVertexColor(C.r, C.g, C.b)
	diffFlag.text = F.CreateFS(diffFlag, C.Assets.Fonts.Bold, 12, nil, '', nil, true, 'CENTER', 0, 0)
	Minimap.DiffFlag = diffFlag
	Minimap.DiffText = diffFlag.text
end

function MAP:UpdateDifficultyFlag()
	local diffText = Minimap.DiffText
	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	local num = select(9, GetInstanceInfo())
	local mplus = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or ''

	if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
		if difficulty == 1 then
			diffText:SetText('5N')
		elseif difficulty == 2 then
			diffText:SetText('5H')
		elseif difficulty == 3 then
			diffText:SetText('10N')
		elseif difficulty == 4 then
			-- 5 普通十人 153 十人海島
			diffText:SetText('25N')
		elseif difficulty == 5 then
			diffText:SetText('10H')
		elseif difficulty == 6 then
			-- Old LFR (before SOO)
			diffText:SetText('25H')
		elseif difficulty == 7 then
			-- Challenge Mode and Mythic+
			diffText:SetText('LFR')
		elseif difficulty == 8 then
			diffText:SetText('M' .. mplus)
		elseif difficulty == 9 then
			-- 11 MOP英雄事件 39 BFA英雄海嶼
			diffText:SetText('40R')
		elseif difficulty == 11 or difficulty == 39 then
			-- 12 MOP普通事件 38 BFA普通海嶼
			diffText:SetText('3H')
		elseif difficulty == 12 and difficulty == 38 then
			-- 40 BFA傳奇海嶼
			diffText:SetText('3N')
		elseif difficulty == 40 then
			-- Flex normal raid
			diffText:SetText('3M')
		elseif difficulty == 14 then
			-- Flex heroic raid
			diffText:SetText(num .. 'N')
		elseif difficulty == 15 then
			-- Mythic raid since WOD
			diffText:SetText(num .. 'H')
		elseif difficulty == 16 then
			-- LFR
			diffText:SetText('M')
		elseif difficulty == 17 then
			-- 18 Event 19 Event 20 Event Scenario(劇情事件) 30 Event 152 幻象
			diffText:SetText(num .. 'L')
		elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then
			diffText:SetText('E')
		elseif difficulty == 23 then
			-- 24 Timewalking(地城時光) 33 Timewalking(團隊時光) 151 隨機團隊時光
			diffText:SetText('5M')
		elseif difficulty == 24 or difficulty == 33 then
			-- 25 World PvP Scenario 32 World PvP Scenario 34 PVP 45 PVP
			diffText:SetText('T')
		elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then
			-- 29 pvevp事件(這什麼玩意?)
			diffText:SetText('PVP')
		elseif difficulty == 29 then
			-- 147 普通戰爭前線
			diffText:SetText('PvEvP')
		elseif difficulty == 147 then
			-- 147 英雄戰爭前線
			diffText:SetText('WF')
		elseif difficulty == 149 then
			diffText:SetText('HWF')
		end
	elseif instanceType == 'pvp' or instanceType == 'arena' then
		diffText:SetText('PVP')
	else
		-- just notice you are in dungeon
		diffText:SetText('D')
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
			local r, g, b = F.ClassColor(class)
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
		EasyMenu(MAP.MenuList, F.EasyMenu, self, 0, 0, 'MENU', 3)
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
	F.SetBD(backdrop)
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
		'MiniMapTracking'
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
