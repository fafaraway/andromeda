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
	{text = _G.BLIZZARD_STORE, func = function()
			_G.StoreMicroButton:Click()
		end}
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
		GameTimeFrame:SetPoint('TOPRIGHT', Minimap, -4, -offset - 6)
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
		flag:SetPoint('TOPLEFT', Minimap, 4, -offset - 10)
		flag:SetScale(.9)
	end

	--[[ if not C.DB.map.instance_type then
		return
	end

	local f = CreateFrame('Frame', nil, Minimap)
	f:SetSize(24, 12)
	f:SetPoint('TOPLEFT', Minimap, 4, -(256 / 8) - 6)
	f.text = F.CreateFS(f, C.Assets.Fonts.Regular, 12, 'OUTLINE', '', nil, false, 'TOPLEFT', 0, 0)

	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:RegisterEvent('CHALLENGE_MODE_START')
	f:RegisterEvent('CHALLENGE_MODE_COMPLETED')
	f:RegisterEvent('CHALLENGE_MODE_RESET')
	f:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
	f:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
	f:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	f:SetScript(
		'OnEvent',
		function()
			local _, instanceType = IsInInstance()
			local difficulty = select(3, GetInstanceInfo())
			local numplayers = select(9, GetInstanceInfo())
			local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or ''

			if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
				if (difficulty == 1) then
					f.text:SetText('5N')
				elseif difficulty == 2 then
					f.text:SetText('5H')
				elseif difficulty == 3 then
					f.text:SetText('10N')
				elseif difficulty == 4 then
					f.text:SetText('25N')
				elseif difficulty == 5 then
					f.text:SetText('10H')
				elseif difficulty == 6 then
					f.text:SetText('25H')
				elseif difficulty == 7 then
					f.text:SetText('LFR')
				elseif difficulty == 8 then
					f.text:SetText('M+' .. mplusdiff)
				elseif difficulty == 9 then
					f.text:SetText('40R')
				elseif difficulty == 11 or difficulty == 39 then
					f.text:SetText('HScen')
				elseif difficulty == 12 or difficulty == 38 then
					f.text:SetText('Scen')
				elseif difficulty == 40 then
					f.text:SetText('MScen')
				elseif difficulty == 14 then
					f.text:SetText('N:' .. numplayers)
				elseif difficulty == 15 then
					f.text:SetText('H:' .. numplayers)
				elseif difficulty == 16 then
					f.text:SetText('M')
				elseif difficulty == 17 then
					f.text:SetText('LFR:' .. numplayers)
				elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then
					f.text:SetText('EScen')
				elseif difficulty == 23 then
					f.text:SetText('5M')
				elseif difficulty == 24 or difficulty == 33 then
					f.text:SetText('TW')
				elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then
					f.text:SetText('PVP')
				elseif difficulty == 29 then
					f.text:SetText('PvEvP')
				elseif difficulty == 147 then
					f.text:SetText('WF')
				end
			elseif instanceType == 'pvp' or instanceType == 'arena' then
				f.text:SetText('PVP')
			else
				f.text:SetText('')
			end

			if not IsInInstance() then
				f.text:Hide()
			else
				f.text:Show()
			end
		end
	) ]]
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
	ZoneTextFrame:SetFrameStrata('TOOLTIP')
	SubZoneTextFrame:SetFrameStrata('TOOLTIP')
	ZoneTextString:ClearAllPoints()
	ZoneTextString:SetPoint('TOP', Minimap.bg, 0, -10)
	ZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
	SubZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
	PVPInfoTextString:SetFont(C.Assets.Fonts.Header, 22)
	PVPArenaTextString:SetFont(C.Assets.Fonts.Header, 22)

	local zoneText = F.CreateFS(Minimap, C.Assets.Fonts.Header, 16, nil, '', nil, 'THICK')
	zoneText:SetPoint('TOP', Minimap, 0, -offset)
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
	elseif self.mover then
		Minimap_OnClick(self)
	end
end

function MAP:SetupHybridMinimap()
	local mapCanvas = HybridMinimap.MapCanvas
	mapCanvas:SetMaskTexture(C.Assets.mask_tex)
	mapCanvas:SetUseMaskTexture(true)
	mapCanvas:SetScript('OnMouseWheel', MAP.Minimap_OnMouseWheel)
	mapCanvas:SetScript('OnMouseUp', MAP.Minimap_OnMouseUp)

	HybridMinimap.CircleMask:SetTexture('')
end

function MAP:HybridMinimapOnLoad(addon)
	if addon == 'Blizzard_HybridMinimap' then
		F.Debug('Blizzard_HybridMinimap loaded')
		MAP:SetupHybridMinimap()
		F:UnregisterEvent(self, MAP.HybridMinimapOnLoad)
	end
end

function MAP:UpdateMinimapScale()
	local width = Minimap:GetWidth()
	local height = Minimap:GetHeight() * (190 / 256)
	local scale = C.DB.map.minimap_scale
	Minimap:SetScale(scale)
	Minimap.mover:SetScale(scale)
end

function MAP:CreateRectangleMinimap()
	MinimapCluster:EnableMouse(false)
	Minimap:SetFrameStrata('LOW')
	Minimap:SetFrameLevel(2)
	Minimap:SetClampedToScreen(true)
	Minimap:SetMaskTexture(C.Assets.mask_tex)
	Minimap:SetSize(256, 256)
	Minimap:SetScale(C.DB.map.minimap_scale)
	Minimap:SetHitRectInsets(0, 0, Minimap:GetHeight() / 8, Minimap:GetHeight() / 8)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	Minimap:SetArchBlobRingAlpha(0)
	Minimap:SetQuestBlobRingAlpha(0)
	Minimap.bg = CreateFrame('Frame', nil, Minimap)
	Minimap.bg:SetSize(256, 190)
	Minimap.bg:SetPoint('CENTER')
	F.SetBD(Minimap.bg, .45)

	function GetMinimapShape()
		return 'SQUARE'
	end

	Minimap.mover = F.Mover(Minimap, L['MAP_MOVER_MINIMAP'], 'Minimap', {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -C.UIGap, 0})
	Minimap:ClearAllPoints()
	Minimap:SetPoint('BOTTOMRIGHT', Minimap.mover)

	MAP:UpdateMinimapScale()
end

function MAP:Minimap()
	DropDownList1:SetClampedToScreen(true)

	-- GarrisonLandingPageMinimapButton:SetSize(1, 1)
	-- GarrisonLandingPageMinimapButton:SetAlpha(0)
	-- GarrisonLandingPageMinimapButton:EnableMouse(false)

	--[[ local bg = CreateFrame('Frame', nil, UIParent)
	bg:SetSize(256 * C.DB.map.minimap_scale, 190 * C.DB.map.minimap_scale)
	F.SetBD(bg)

	Minimap:SetFrameStrata('LOW')
	Minimap:SetFrameLevel(2)
	Minimap:SetClampedToScreen(true)
	Minimap:SetMaskTexture(C.Assets.mask_tex)
	Minimap:SetSize(256, 256)
	Minimap:SetScale(C.DB.map.minimap_scale)
	Minimap:SetHitRectInsets(0, 0, Minimap:GetHeight() / 8, Minimap:GetHeight() / 8)
	Minimap:SetClampRectInsets(0, 0, 0, 0)

	Minimap:SetParent(bg)
	Minimap:ClearAllPoints()
	Minimap:SetPoint('CENTER', bg)

	local mover = F.Mover(bg, L['MAP_MOVER_MINIMAP'], 'Minimap', {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -C.UIGap, C.UIGap})
	bg:ClearAllPoints()
	bg:SetPoint('CENTER', mover)
	Minimap.mover = mover
	Minimap.bg = bg

	 ]]
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
		'MinimapZoomOut',
		'MinimapZoomIn',
		'MiniMapWorldMapButton',
		'MiniMapMailBorder',
		'MiniMapTracking',
		'MinimapZoneTextButton'
	}

	for _, v in pairs(frames) do
		F.HideObject(_G[v])
	end

	MAP:CreateRectangleMinimap()
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
