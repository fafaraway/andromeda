local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('MAP')

local strmatch, strfind, strupper = string.match, string.find, string.upper
local select, pairs, ipairs, unpack = select, pairs, ipairs, unpack
local offset = 256 / 8

local menuList = {
	{
		text = _G.CHARACTER_BUTTON,
		func = function()
			ToggleCharacter('PaperDollFrame')
		end
	},
	{
		text = _G.SPELLBOOK_ABILITIES_BUTTON,
		func = function()
			if not _G.SpellBookFrame:IsShown() then
				ShowUIPanel(_G.SpellBookFrame)
			else
				HideUIPanel(_G.SpellBookFrame)
			end
		end
	},
	{
		text = _G.TALENTS_BUTTON,
		func = function()
			if not _G.PlayerTalentFrame then
				_G.TalentFrame_LoadUI()
			end

			local PlayerTalentFrame = _G.PlayerTalentFrame
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		end
	},
	{
		text = _G.COLLECTIONS,
		func = ToggleCollectionsJournal
	},
	{
		text = _G.CHAT_CHANNELS,
		func = _G.ToggleChannelFrame
	},
	{
		text = _G.TIMEMANAGER_TITLE,
		func = function()
			ToggleFrame(_G.TimeManagerFrame)
		end
	},
	{
		text = _G.ACHIEVEMENT_BUTTON,
		func = ToggleAchievementFrame
	},
	{
		text = _G.SOCIAL_BUTTON,
		func = ToggleFriendsFrame
	},
	{
		text = L['MAP_CALENDAR'],
		func = function()
			_G.GameTimeFrame:Click()
		end
	},
	{
		text = _G.GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
		func = function()
			GarrisonLandingPageMinimapButton_OnClick(_G.GarrisonLandingPageMinimapButton)
		end
	},
	{
		text = _G.ACHIEVEMENTS_GUILD_TAB,
		func = ToggleGuildFrame
	},
	{
		text = _G.LFG_TITLE,
		func = ToggleLFDParentFrame
	},
	{
		text = _G.ENCOUNTER_JOURNAL,
		func = function()
			if not IsAddOnLoaded('Blizzard_EncounterJournal') then
				_G.EncounterJournal_LoadUI()
			end

			ToggleFrame(_G.EncounterJournal)
		end
	},
	{
		text = _G.MAINMENU_BUTTON,
		func = function()
			if not _G.GameMenuFrame:IsShown() then
				if _G.VideoOptionsFrame:IsShown() then
					_G.VideoOptionsFrameCancel:Click()
				elseif _G.AudioOptionsFrame:IsShown() then
					_G.AudioOptionsFrameCancel:Click()
				elseif _G.InterfaceOptionsFrame:IsShown() then
					_G.InterfaceOptionsFrameCancel:Click()
				end

				CloseMenus()
				CloseAllWindows()
				PlaySound(850) --IG_MAINMENU_OPEN
				ShowUIPanel(_G.GameMenuFrame)
			else
				PlaySound(854) --IG_MAINMENU_QUIT
				HideUIPanel(_G.GameMenuFrame)
				MainMenuMicroButton_SetNormal()
			end
		end
	}
}

tinsert(
	menuList,
	{
		text = _G.BLIZZARD_STORE,
		func = function()
			_G.StoreMicroButton:Click()
		end
	}
)
tinsert(menuList, {text = _G.HELP_BUTTON, func = ToggleHelpFrame})

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
	local flags = {'MiniMapInstanceDifficulty', 'GuildInstanceDifficulty', 'MiniMapChallengeMode'}
	for _, v in pairs(flags) do
		local flag = _G[v]
		flag:ClearAllPoints()
		flag:SetPoint('TOPLEFT', Minimap, 0, -offset - 10)
		flag:SetScale(.9)
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
		EasyMenu(menuList, F.EasyMenu, self, 0, 0, 'MENU', 3)
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
	local size = Minimap:GetWidth()
	local scale = C.DB.map.minimap_scale
	Minimap:SetScale(scale)
	Minimap.mover:SetSize(size * scale, size * scale)
end

function MAP:Minimap()
	-- Shape and Position
	Minimap:SetMaskTexture(C.Assets.mask_tex)
	Minimap:SetSize(256, 256)
	Minimap:SetHitRectInsets(0, 0, Minimap:GetHeight() / 8, Minimap:GetHeight() / 8)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	Minimap:SetFrameLevel(Minimap:GetFrameLevel() + 2)
	MinimapBackdrop:ClearAllPoints()
	MinimapBackdrop:SetAllPoints(Minimap)

	DropDownList1:SetClampedToScreen(true)

	local mover = F.Mover(Minimap, L['MAP_MOVER_MINIMAP'], 'Minimap', {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -C.UIGap, 0})
	Minimap:ClearAllPoints()
	Minimap:SetPoint('CENTER', mover)
	Minimap.mover = mover

	Minimap.backdrop = F.SetBD(Minimap, 1, 0, -(Minimap:GetHeight() / 8), 0, Minimap:GetHeight() / 8)
	Minimap.backdrop:SetBackdropColor(0, 0, 0, 1)
	Minimap.backdrop:SetFrameLevel(99)
	Minimap.backdrop:SetFrameStrata('BACKGROUND')

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

	F:RegisterEvent('ADDON_LOADED', MAP.HybridMinimapOnLoad)
end
