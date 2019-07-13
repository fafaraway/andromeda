local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Map')


local function ReskinRegions()
	GarrisonLandingPageMinimapButton:SetSize(1, 1)
	GarrisonLandingPageMinimapButton:SetAlpha(0)
	GarrisonLandingPageMinimapButton:EnableMouse(false)

	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint('TOPRIGHT', Minimap, 'TOPRIGHT', -5, -(C.map.miniMapSize/8*C.Mult)-6)
	GameTimeFrame:SetSize(16, 8)
	GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
	GameTimeFrame:SetNormalTexture('')
	GameTimeFrame:SetPushedTexture('')
	GameTimeFrame:SetHighlightTexture('')

	local _, _, _, _, dateText = GameTimeFrame:GetRegions()
	F.SetFS(dateText)
	dateText:SetTextColor(147/255, 211/255, 231/255)
	dateText:SetShadowOffset(0, 0)
	dateText:SetPoint('CENTER')

	local difftext = {}
	local rd = CreateFrame('Frame', nil, Minimap)
	rd:SetSize(24, 8)
	rd:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 5, -(C.map.miniMapSize/8*C.Mult)-6)
	rd:RegisterEvent('PLAYER_ENTERING_WORLD')
	rd:RegisterEvent('CHALLENGE_MODE_START')
	rd:RegisterEvent('CHALLENGE_MODE_COMPLETED')
	rd:RegisterEvent('CHALLENGE_MODE_RESET')
	rd:RegisterEvent('PLAYER_DIFFICULTY_CHANGED')
	rd:RegisterEvent('GUILD_PARTY_STATE_UPDATED')
	rd:RegisterEvent('ZONE_CHANGED_NEW_AREA')

	local rdt = F.CreateFS(rd, 'pixel', '', nil, nil, true, 'TOPLEFT', 0, 0)

	rd:SetScript('OnEvent', function()
		local _, instanceType = IsInInstance()
		local difficulty = select(3, GetInstanceInfo())
		local numplayers = select(9, GetInstanceInfo())
		local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or '';

		if instanceType == 'party' or instanceType == 'raid' or instanceType == 'scenario' then
			if (difficulty == 1) then
				rdt:SetText('5N')
			elseif difficulty == 2 then
				rdt:SetText('5H')
			elseif difficulty == 3 then
				rdt:SetText('10N')
			elseif difficulty == 4 then
				rdt:SetText('25N')
			elseif difficulty == 5 then
				rdt:SetText('10H')
			elseif difficulty == 6 then
				rdt:SetText('25H')
			elseif difficulty == 7 then
				rdt:SetText('LFR')
			elseif difficulty == 8 then
				rdt:SetText('M+'..mplusdiff)
			elseif difficulty == 9 then
				rdt:SetText('40R')
			elseif difficulty == 11 or difficulty == 39 then
				rdt:SetText('HScen')
			elseif difficulty == 12 or difficulty == 38 then
				rdt:SetText('Scen')
			elseif difficulty == 40 then 
				rdt:SetText('MScen')
			elseif difficulty == 14 then
				rdt:SetText('N:'..numplayers)
			elseif difficulty == 15 then
				rdt:SetText('H:'..numplayers)
			elseif difficulty == 16 then
				rdt:SetText('M')
			elseif difficulty == 17 then
				rdt:SetText('LFR:'..numplayers)
			elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then
				rdt:SetText('EScen')
			elseif difficulty == 23 then
				rdt:SetText('5M')
			elseif difficulty == 24 or difficulty == 33 then
				rdt:SetText('TW')
			elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then
				rdt:SetText('PVP')
			elseif difficulty == 29 then
				rdt:SetText('PvEvP')
			elseif difficulty == 147 then
				rdt:SetText('WF')
			end
		elseif instanceType == 'pvp' or instanceType == 'arena' then
			rdt:SetText('PVP')
		else
			rdt:SetText('')
		end

		if not IsInInstance() then
			rdt:Hide()
		else
			rdt:Show()
		end
	end)

	-- mail
	local mail = CreateFrame('Frame', 'FreeUIMailFrame', Minimap)
	mail:Hide()
	mail:RegisterEvent('UPDATE_PENDING_MAIL')
	mail:SetScript('OnEvent', function(self)
		if HasNewMail() then
			self:Show()
		else
			self:Hide()
		end
	end)

	MiniMapMailFrame:HookScript('OnMouseUp', function(self)
		self:Hide()
		mail:Hide()
	end)

	local mt = F.CreateFS(mail, 'pixel', '<New Mail>', nil, 'yellow', true)
	mt:SetPoint('BOTTOM', Minimap, 0, (C.map.miniMapSize/8*C.Mult)+6)

	MiniMapMailFrame:SetAlpha(0)
	MiniMapMailFrame:SetSize(22, 10)
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('CENTER', mt)

	-- Invites Icon
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent('Minimap')
	GameTimeCalendarInvitesTexture:SetPoint('TOPRIGHT')
	local Invt = CreateFrame('Button', 'FreeUIInvt', UIParent)
	Invt:SetPoint('TOPRIGHT', Minimap, 'BOTTOMLEFT', -20, -20)
	Invt:SetSize(300, 80)
	F.CreateBD(Invt)

	Invt.text = F.CreateFS(Invt, {C.font.normal, 14}, C.InfoColor..GAMETIME_TOOLTIP_CALENDAR_INVITES, nil, nil, true)

	local function updateInviteVisibility()
		if C_Calendar.GetNumPendingInvites() > 0 then
			Invt:Show()
		else
			Invt:Hide()
		end
	end
	F:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
	F:RegisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)

	Invt:SetScript('OnClick', function(_, btn)
		Invt:Hide()
		if btn == 'LeftButton' and not InCombatLockdown() then
			ToggleCalendar()
		end
		F:UnregisterEvent('CALENDAR_UPDATE_PENDING_INVITES', updateInviteVisibility)
		F:UnregisterEvent('PLAYER_ENTERING_WORLD', updateInviteVisibility)
	end)

	if TicketStatusFrame then
		TicketStatusFrame:ClearAllPoints()
		TicketStatusFrame:SetPoint('TOPLEFT', UIParent, 100, -100)
		TicketStatusFrame.SetPoint = F.Dummy
	end
end

local function ZoneText()
	ZoneTextFrame:SetFrameStrata('MEDIUM')
	SubZoneTextFrame:SetFrameStrata('MEDIUM')

	ZoneTextString:ClearAllPoints()
	ZoneTextString:SetPoint('CENTER', Minimap)
	ZoneTextString:SetWidth(230)
	SubZoneTextString:SetWidth(230)
	PVPInfoTextString:SetWidth(230)
	PVPArenaTextString:SetWidth(230)

	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint('TOP', Minimap, 0, -(C.map.miniMapSize/8+10))
	MinimapZoneTextButton:SetFrameStrata('HIGH')
	MinimapZoneTextButton:EnableMouse(false)
	MinimapZoneTextButton:SetAlpha(0)
	MinimapZoneText:SetPoint('CENTER', MinimapZoneTextButton)

	MinimapZoneText:SetShadowColor(0, 0, 0, 0)
	MinimapZoneText:SetJustifyH('CENTER')

	ZoneTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	SubZoneTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	PVPInfoTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	PVPArenaTextString:SetFont(C.font.normal, 16, 'OUTLINE')
	MinimapZoneText:SetFont(C.font.normal, 16, 'OUTLINE')

	Minimap:HookScript('OnEnter', function()
		MinimapZoneTextButton:SetAlpha(1)
	end)

	Minimap:HookScript('OnLeave', function()
		MinimapZoneTextButton:SetAlpha(0)
	end)
end

local function QueueStatus()
	QueueStatusMinimapButtonBorder:SetAlpha(0)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint('BOTTOMRIGHT', Minimap, 0, (C.map.miniMapSize/8*C.Mult)+6)
	QueueStatusMinimapButton:SetHighlightTexture('')
	QueueStatusMinimapButton.Eye.texture:SetTexture('')

	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -4, (C.map.miniMapSize/8*C.Mult)+6)

	local dots = {}
	for i = 1, 8 do
		dots[i] = F.CreateFS(QueueStatusMinimapButton, 'pixelbig', '.', nil, nil, true)
		dots[i]:SetText('.')
	end
	dots[1]:SetPoint('TOP', 2, 2)
	dots[2]:SetPoint('TOPRIGHT', -6, -1)
	dots[3]:SetPoint('RIGHT', -3, 2)
	dots[4]:SetPoint('BOTTOMRIGHT', -6, 5)
	dots[5]:SetPoint('BOTTOM', 2, 2)
	dots[6]:SetPoint('BOTTOMLEFT', 9, 5)
	dots[7]:SetPoint('LEFT', 6, 2)
	dots[8]:SetPoint('TOPLEFT', 9, -1)

	local counter = 0
	local last = 0
	local interval = .06
	local diff = .014

	local function onUpdate(self, elapsed)
		last = last + elapsed
		if last >= interval then
			counter = counter + 1

			dots[counter]:SetShown(not dots[counter]:IsShown())

			if counter == 8 then
				counter = 0
				diff = diff * -1
			end

			interval = interval + diff
			last = 0
		end
	end

	hooksecurefunc('EyeTemplate_StartAnimating', function(eye)
		eye:SetScript('OnUpdate', onUpdate)
	end)

	hooksecurefunc('EyeTemplate_StopAnimating', function(eye)
		for i = 1, 8 do
			dots[i]:Show()
		end
		counter = 0
		last = 0
		interval = .06
		diff = .014
	end)

	QueueStatusMinimapButton:HookScript('OnEnter', function()
		for i = 1, 8 do
			dots[i]:SetTextColor(C.r, C.g, C.b)
		end
	end)

	QueueStatusMinimapButton:HookScript('OnLeave', function()
		for i = 1, 8 do
			dots[i]:SetTextColor(1, 1, 1)
		end
	end)
end

local function WhoPingsMyMap()
	if not C.map.whoPings then return end

	local f = CreateFrame('Frame', nil, Minimap)
	f:SetAllPoints()
	f.text = F.CreateFS(f, {C.font.normal, 14, 'OUTLINE'}, '', nil, 'class', true, 'TOP', 0, -4)

	local anim = f:CreateAnimationGroup()
	anim:SetScript('OnPlay', function() f:SetAlpha(1) end)
	anim:SetScript('OnFinished', function() f:SetAlpha(0) end)
	anim.fader = anim:CreateAnimation('Alpha')
	anim.fader:SetFromAlpha(1)
	anim.fader:SetToAlpha(0)
	anim.fader:SetDuration(3)
	anim.fader:SetSmoothing('OUT')
	anim.fader:SetStartDelay(3)

	F:RegisterEvent('MINIMAP_PING', function(_, unit)
		local class = select(2, UnitClass(unit))
		local r, g, b = F.ClassColor(class)
		local name = GetUnitName(unit)

		anim:Stop()
		f.text:SetText(name)
		f.text:SetTextColor(r, g, b)
		anim:Play()
	end)
end

local function WorldMarker()
	if not IsAddOnLoaded('Blizzard_CompactRaidFrames') then return end

	local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton

	wm:SetParent('UIParent')
	wm:ClearAllPoints()
	wm:SetPoint('BOTTOMLEFT', Minimap, 'BOTTOMLEFT', 4, (C.map.miniMapSize/8*C.Mult)+6)
	wm:SetSize(16, 16)
	wm:Hide()

	wm.TopLeft:Hide()
	wm.TopRight:Hide()
	wm.BottomLeft:Hide()
	wm.BottomRight:Hide()
	wm.TopMiddle:Hide()
	wm.MiddleLeft:Hide()
	wm.MiddleRight:Hide()
	wm.BottomMiddle:Hide()
	wm.MiddleMiddle:Hide()
	wm:SetNormalTexture('')
	wm:SetHighlightTexture('')

	local marker = F.CreateFS(wm, 'pixelbig', '+', nil, nil, true, 'CENTER', 1, 0)

	wm:HookScript('OnEnter', function()
		marker:SetTextColor(C.r, C.g, C.b)
	end)

	wm:HookScript('OnLeave', function()
		marker:SetTextColor(1, 1, 1)
	end)

	wm:RegisterEvent('PLAYER_ENTERING_WORLD')
	wm:RegisterEvent('GROUP_ROSTER_UPDATE')
	wm:HookScript('OnEvent', function(self)
		local inRaid = IsInRaid()
		if (inRaid and (UnitIsGroupLeader('player') or UnitIsGroupAssistant('player'))) or (not inRaid and IsInGroup()) then
			self:Show()
		else
			self:Hide()
		end
	end)
end

function module:SetupMinimap()
	if not C.map.miniMap then return end

	local size = C.map.miniMapSize
	local pos = C.map.miniMapPosition
	function GetMinimapShape() return 'SQUARE' end
	
	MinimapCluster:EnableMouse(false)
	Minimap:SetSize(size*C.Mult, size*C.Mult)
	Minimap:SetScale(1)
	Minimap:SetMaskTexture(C.AssetsPath..'rectangle')
	Minimap:SetHitRectInsets(0, 0, (size/8)*C.Mult, (size/8)*C.Mult)
	Minimap:SetClampRectInsets(0, 0, 0, 0)
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetQuestBlobRingScalar(0)
	--Minimap:EnableMouse(true)
	Minimap:SetClampedToScreen(true)
	Minimap:ClearAllPoints()

	local mover = F.Mover(Minimap, L['MOVER_MINIMAP'], 'Minimap', {pos[1], pos[2], pos[3], pos[4], pos[5]-(size/8*C.Mult)}, Minimap:GetWidth(), Minimap:GetHeight())
	Minimap:SetPoint('TOPRIGHT', mover)

	BorderFrame = CreateFrame('Frame', nil, Minimap)
	BorderFrame:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 0, -(size/8*C.Mult))
	BorderFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMRIGHT', 0, (size/8*C.Mult))
	BorderFrame:SetFrameLevel(Minimap:GetFrameLevel() - 1)
	local bg = F.CreateBDFrame(BorderFrame)
	F.CreateSD(bg, .5, 4, 4)

	DropDownList1:SetClampedToScreen(true)

	-- ClockFrame
	LoadAddOn('Blizzard_TimeManager')
	local region = TimeManagerClockButton:GetRegions()
	region:Hide()
	TimeManagerClockButton:Hide()

	-- Mousewheel Zoom
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript('OnMouseWheel', function(_, zoom)
		if zoom > 0 then
			Minimap_ZoomIn()
		else
			Minimap_ZoomOut()
		end
	end)

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
		'MiniMapInstanceDifficulty',
		'GuildInstanceDifficulty',
		'MiniMapChallengeMode',
	}

	for _, v in pairs(frames) do
		F.HideObject(_G[v])
	end

	ReskinRegions()
	ZoneText()
	QueueStatus()
	WhoPingsMyMap()
	WorldMarker()
end