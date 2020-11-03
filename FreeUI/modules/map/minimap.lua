local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('MAP')


local strmatch, strfind, strupper = string.match, string.find, string.upper
local select, pairs, ipairs, unpack = select, pairs, ipairs, unpack


local function ReskinRegions()
	GarrisonLandingPageMinimapButton:SetSize(1, 1)
	GarrisonLandingPageMinimapButton:SetAlpha(0)
	GarrisonLandingPageMinimapButton:EnableMouse(false)
end

local function NewMail()
	if not C.DB.map.new_mail then return end

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

	mail.text = F.CreateFS(mail, C.Assets.Fonts.Regular, 12, nil, L['MAP_NEW_MAIL'], 'BLUE', 'THICK')
	mail.text:SetPoint('BOTTOM', Minimap, 0, 256 / 8 + 6)

	MiniMapMailFrame:SetAlpha(0)
	MiniMapMailFrame:SetSize(22, 10)
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint('CENTER', mail.text)
end

local function Calendar()
	if not C.DB.map.calendar then return end

	if not GameTimeFrame.styled then
		GameTimeFrame:SetNormalTexture(nil)
		GameTimeFrame:SetPushedTexture(nil)
		GameTimeFrame:SetHighlightTexture(nil)
		GameTimeFrame:SetSize(24, 12)
		GameTimeFrame:SetParent(Minimap)
		GameTimeFrame:ClearAllPoints()
		GameTimeFrame:SetPoint('TOPRIGHT', Minimap, -4, -(256 / 8) - 6)
		GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)

		for i = 1, GameTimeFrame:GetNumRegions() do
			local region = select(i, GameTimeFrame:GetRegions())
			if region.SetTextColor then
				region:SetTextColor(147/255, 211/255, 231/255)
				region:SetJustifyH('RIGHT')
				F.SetFS(region, C.Assets.Fonts.Regular, 12, 'OUTLINE')
				break
			end
		end

		GameTimeFrame.styled = true
	end
	GameTimeFrame:Show()
end

local function CalendarInvites()
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent('Minimap')
	GameTimeCalendarInvitesTexture:SetPoint('TOPRIGHT')
	local Invt = CreateFrame('Button', 'FreeUIInvt', UIParent)
	Invt:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -6, -6)
	Invt:SetSize(300, 80)
	F.CreateBDFrame(Invt)
	F.CreateSD(Invt)
	Invt.text = F.CreateFS(Invt, C.Assets.Fonts.Regular, 14, 'OUTLINE', GAMETIME_TOOLTIP_CALENDAR_INVITES, 'BLUE')

	local function updateInviteVisibility()
		Invt:SetShown(C_Calendar.GetNumPendingInvites() > 0)
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
end

local function InstanceType()
	if not C.DB.map.instance_type then return end

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
	f:SetScript('OnEvent', function()
		local _, instanceType = IsInInstance()
		local difficulty = select(3, GetInstanceInfo())
		local numplayers = select(9, GetInstanceInfo())
		local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or '';

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
				f.text:SetText('M+'..mplusdiff)
			elseif difficulty == 9 then
				f.text:SetText('40R')
			elseif difficulty == 11 or difficulty == 39 then
				f.text:SetText('HScen')
			elseif difficulty == 12 or difficulty == 38 then
				f.text:SetText('Scen')
			elseif difficulty == 40 then
				f.text:SetText('MScen')
			elseif difficulty == 14 then
				f.text:SetText('N:'..numplayers)
			elseif difficulty == 15 then
				f.text:SetText('H:'..numplayers)
			elseif difficulty == 16 then
				f.text:SetText('M')
			elseif difficulty == 17 then
				f.text:SetText('LFR:'..numplayers)
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
	end)
end

local function UpdateZoneTextString()
	if GetSubZoneText() == '' then
		Minimap.zoneText:SetText(GetZoneText())
	else
		Minimap.zoneText:SetText(GetSubZoneText())
	end
	Minimap.zoneText:SetTextColor(ZoneTextString:GetTextColor())
end

local function AddZoneText()
	ZoneTextFrame:SetFrameStrata('TOOLTIP')
	SubZoneTextFrame:SetFrameStrata('TOOLTIP')
	ZoneTextString:ClearAllPoints()
	ZoneTextString:SetPoint('TOP', Minimap.bg, 0, -10)
	ZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
	SubZoneTextString:SetFont(C.Assets.Fonts.Header, 22)
	PVPInfoTextString:SetFont(C.Assets.Fonts.Header, 22)
	PVPArenaTextString:SetFont(C.Assets.Fonts.Header, 22)

	local zoneText = F.CreateFS(Minimap, C.Assets.Fonts.Header, 16, nil, '', nil, 'THICK')
	zoneText:SetPoint('TOP', Minimap.bg)
	zoneText:SetSize(Minimap:GetWidth(), 30)
	zoneText:SetJustifyH('CENTER')
	zoneText:Hide()

	Minimap.zoneText = zoneText
end

local function QueueStatus()
	QueueStatusMinimapButtonBorder:SetAlpha(0)
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:SetPoint('BOTTOMRIGHT', Minimap, 0, 256 / 8 + 6)
	QueueStatusMinimapButton:SetHighlightTexture('')
	QueueStatusMinimapButton.Eye.texture:SetTexture('')

	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:SetPoint('BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -4, 256 / 8 + 6)

	local dots = {}
	for i = 1, 8 do
		dots[i] = F.CreateFS(QueueStatusMinimapButton, C.Assets.Fonts.Pixel, 16, 'OUTLINE, MONOCHROME', '.', nil, true)
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

local function WhoPings()
	if not C.DB.map.who_pings then return end

	local f = CreateFrame('Frame', nil, Minimap)
	f:SetAllPoints()
	f.text = F.CreateFS(f, C.Assets.Fonts.Regular, 14, true, '', 'CLASS', false, 'TOP', 0, -4)

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
		if unit == 'player' then return end -- ignore player ping

		local class = select(2, UnitClass(unit))
		local r, g, b = F.ClassColor(class)
		local name = GetUnitName(unit)

		anim:Stop()
		f.text:SetText(name)
		f.text:SetTextColor(r, g, b)
		anim:Play()
	end)
end

function MAP:Minimap_OnMouseWheel(zoom)
	if zoom > 0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut()
	end
end

local FreeUIMiniMapTrackingDropDown = CreateFrame('Frame', 'FreeUIMiniMapTrackingDropDown', _G.UIParent, 'UIDropDownMenuTemplate')
FreeUIMiniMapTrackingDropDown:SetID(1)
FreeUIMiniMapTrackingDropDown:SetClampedToScreen(true)
FreeUIMiniMapTrackingDropDown:Hide()
FreeUIMiniMapTrackingDropDown.noResize = true
_G.UIDropDownMenu_Initialize(FreeUIMiniMapTrackingDropDown, _G.MiniMapTrackingDropDown_Initialize, 'MENU')

function MAP:Minimap_OnMouseUp(btn)
	if btn == 'MiddleButton' then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleCalendar()
	elseif btn == 'RightButton' then
		ToggleDropDownMenu(1, nil, FreeUIMiniMapTrackingDropDown, 'cursor')
	elseif self.mover then
		Minimap_OnClick(self)
	end
end

function MAP:SetupHybridMinimap()
	local mapCanvas = HybridMinimap.MapCanvas
	mapCanvas:SetMaskTexture('Interface\\Buttons\\WHITE8X8')
	mapCanvas:SetScript('OnMouseWheel', MAP.Minimap_OnMouseWheel)
	mapCanvas:SetScript('OnMouseUp', MAP.Minimap_OnMouseUp)
end

function MAP:HybridMinimapOnLoad(addon)
	if addon == 'Blizzard_HybridMinimap' then
		MAP:SetupHybridMinimap()
		F:UnregisterEvent(self, MAP.HybridMinimapOnLoad)
	end
end

function MAP:UpdateMinimapScale()
	local width = Minimap:GetWidth()
	local height = Minimap:GetHeight()*(190/256)
	local scale = C.DB.map.minimap_scale
	Minimap:SetScale(scale)
	Minimap.mover:SetSize(width*scale, height*scale)
	Minimap.bg:SetSize(width*scale, height*scale)
end


function MAP:Minimap()
	DropDownList1:SetClampedToScreen(true)

	local bg = CreateFrame('Frame', nil, UIParent)
	bg:SetSize(256*C.DB.map.minimap_scale, 190*C.DB.map.minimap_scale)
	F.SetBD(bg)

	Minimap:SetFrameStrata('BACKGROUND')
	Minimap:Size(256, 256)
	Minimap:SetScale(C.DB.map.minimap_scale)
	Minimap:SetMaskTexture(C.Assets.mask_tex)

	Minimap:EnableMouse(true)
	Minimap:SetClampedToScreen(false)
	Minimap:SetParent(bg)
	Minimap:ClearAllPoints()
	Minimap:SetPoint('CENTER')

	local mover = F.Mover(bg, L['MAP_MOVER_MINIMAP'], 'Minimap', {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -C.UIGap, C.UIGap})
	bg:ClearAllPoints()
	bg:SetPoint('CENTER', mover)
	Minimap.mover = mover
	Minimap.bg = bg

	self:UpdateMinimapScale()

	-- Zone text
	AddZoneText()

	Minimap:HookScript('OnUpdate', function()
		UpdateZoneTextString()
	end)

	Minimap:HookScript('OnEnter', function()
		Minimap.zoneText:Show()
	end)

	Minimap:HookScript('OnLeave', function()
		Minimap.zoneText:Hide()
	end)

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
		'MiniMapInstanceDifficulty',
		'GuildInstanceDifficulty',
		'MiniMapChallengeMode',
		'MinimapZoneTextButton',
	}

	for _, v in pairs(frames) do
		F.HideObject(_G[v])
	end

	MinimapCluster:EnableMouse(false)
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetQuestBlobRingScalar(0)

	ReskinRegions()
	Calendar()
	CalendarInvites()
	NewMail()
	InstanceType()
	QueueStatus()
	WhoPings()
	self:MicroMenu()
	self:ExpBar()

	-- HybridMinimap
	F:RegisterEvent('ADDON_LOADED', MAP.HybridMinimapOnLoad)
end
