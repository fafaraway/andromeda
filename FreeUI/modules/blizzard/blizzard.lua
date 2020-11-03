local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('BLIZZARD')


local _G = getfenv(0)
local BLIZZARD_LIST = {}

function BLIZZARD:RegisterBlizz(name, func)
	if not BLIZZARD_LIST[name] then
		BLIZZARD_LIST[name] = func
	end
end

function BLIZZARD:OnLogin()
	for name, func in next, BLIZZARD_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end

	self:ToggleBossBanner()
	self:ToggleBossEmote()
	self:UndressButton()
	self:TradeTargetInfo()
	self:QueueTimer()
	self:EasyDelete()
	self:TicketStatusMover()
	self:VehicleIndicatorMover()
	self:UIWidgetMover()
end


function BLIZZARD:ToggleBossBanner()
	if C.DB.blizzard.hide_boss_banner then
		BossBanner:UnregisterAllEvents()
	else
		BossBanner:RegisterEvent('BOSS_KILL')
		BossBanner:RegisterEvent('ENCOUNTER_LOOT_RECEIVED')
	end
end

function BLIZZARD:ToggleBossEmote()
	if C.DB.blizzard.hide_boss_emote then
		RaidBossEmoteFrame:UnregisterAllEvents()
	else
		RaidBossEmoteFrame:RegisterEvent('RAID_BOSS_EMOTE')
		RaidBossEmoteFrame:RegisterEvent('RAID_BOSS_WHISPER')
		RaidBossEmoteFrame:RegisterEvent('CLEAR_BOSS_EMOTES')
	end
end

function BLIZZARD:UndressButton()
	if not C.DB.blizzard.undress_button then return end

	local undressButton = CreateFrame('Button', 'DressUpFrameUndressButton', DressUpFrame, 'UIPanelButtonTemplate')
	undressButton:SetSize(80, 22)
	undressButton:SetPoint('RIGHT', DressUpFrameResetButton, 'LEFT', -1, 0)
	undressButton:SetText(L['BLIZZARD_UNDRESS'])
	undressButton:RegisterForClicks('AnyUp')
	undressButton:SetScript('OnClick', function(_, button)
		local actor = DressUpFrame.ModelScene:GetPlayerActor()
		if not actor then return end
		if button == 'RightButton' then
			actor:UndressSlot(19)
		else
			actor:Undress()
		end
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	end)
	--[[ undressButton.model = DressUpFrame.ModelScene

	undressButton:RegisterEvent('AUCTION_HOUSE_SHOW')
	undressButton:RegisterEvent('AUCTION_HOUSE_CLOSED')
	undressButton:SetScript('OnEvent', function(self)
		if AuctionFrame:IsVisible() and self.model ~= SideDressUpFrame.ModelScene then
			self:SetParent(SideDressUpFrame.ModelScene)
			self:ClearAllPoints()
			self:SetPoint('BOTTOM', SideDressUpFrame.ResetButton, 'TOP', 0, 3)
			self.model = SideDressUpFrame.ModelScene
		elseif self.model ~= DressUpFrame.ModelScene then
			self:SetParent(DressUpFrame.ModelScene)
			self:ClearAllPoints()
			self:SetPoint('RIGHT', DressUpFrameResetButton, 'LEFT', -2, 0)
			self.model = DressUpFrame.ModelScene
		end
	end) ]]

	F.Reskin(undressButton)
end

function BLIZZARD:TradeTargetInfo()
	if not C.DB.blizzard.trade_target_info then return end

	local infoText = F.CreateFS(TradeFrame, C.Assets.Fonts.Regular, 14, true)
	infoText:ClearAllPoints()
	infoText:SetPoint('TOP', TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

	local function updateColor()
		local r, g, b = F.UnitColor('NPC')
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID('NPC')
		if not guid then return end
		local text = C.RedColor..L['BLIZZARD_STRANGER']
		if C_BattleNet.GetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) then
			text = C.GreenColor..FRIEND
		elseif IsGuildMember(guid) then
			text = C.BlueColor..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc('TradeFrame_Update', updateColor)
end



function BLIZZARD:EasyDelete()
	hooksecurefunc(StaticPopupDialogs['DELETE_GOOD_ITEM'], 'OnShow', function(self)
		if not C.DB.blizzard.easy_delete then return end

		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end

function BLIZZARD:VehicleIndicatorMover()
	local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', UIParent)
	frame:SetSize(100, 100)
	F.Mover(frame, L['BLIZZARD_MOVER_VEHICLE'], 'VehicleIndicator', {'BOTTOMRIGHT', Minimap, 'TOPRIGHT', 0, 0})

	hooksecurefunc(VehicleSeatIndicator, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOPLEFT', frame)
			self:SetScale(.7)
		end
	end)
end

function BLIZZARD:TicketStatusMover()
	hooksecurefunc(TicketStatusFrame, 'SetPoint', function(self, relF)
		if relF == 'TOPRIGHT' then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 'TOP', 0, -100)
		end
	end)
end

function BLIZZARD:UIWidgetMover()
	local frame = CreateFrame('Frame', 'FreeUI_UIWidgetMover', UIParent)
	frame:SetSize(200, 50)
	F.Mover(frame, L['BLIZZARD_MOVER_UIWIDGET'], 'UIWidgetFrame', {'TOP', 0, -80})

	hooksecurefunc(UIWidgetBelowMinimapContainerFrame, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOP', frame)
		end
	end)
end



do
	local LFGTimer = CreateFrame('Frame', nil, _G.LFGDungeonReadyDialog)
	local PVPTimer = CreateFrame('Frame', nil, _G.PVPReadyDialog)

	_G.LFGDungeonReadyDialog.nextUpdate = 0
	_G.PVPReadyDialog.nextUpdate = 0

	local function UpdateLFGTimer()
		if not LFGTimer.bar then
			LFGTimer:SetPoint('BOTTOMLEFT')
			LFGTimer:SetPoint('BOTTOMRIGHT')
			LFGTimer:SetHeight(3)

			LFGTimer.bar = CreateFrame('StatusBar', nil, LFGTimer)
			LFGTimer.bar:SetStatusBarTexture(C.Assets.norm_tex)
			LFGTimer.bar:SetPoint('TOPLEFT', C.Mult, -C.Mult)
			LFGTimer.bar:SetPoint('BOTTOMLEFT', -C.Mult, C.Mult)
			LFGTimer.bar:SetFrameLevel(_G.LFGDungeonReadyDialog:GetFrameLevel() + 1)
			LFGTimer.bar:SetStatusBarColor(C.r, C.g, C.b)
		end

		local obj = _G.LFGDungeonReadyDialog
		local oldTime = _G.GetTime()
		local flag = 0
		local duration = 40
		local interval = 0.1
		obj:SetScript('OnUpdate', function(self, elapsed)
			obj.nextUpdate = obj.nextUpdate + elapsed
			if obj.nextUpdate > interval then
				local newTime = _G.GetTime()
				if (newTime - oldTime) < duration then
					local width = LFGTimer:GetWidth() * (newTime - oldTime) / duration
					LFGTimer.bar:SetPoint('BOTTOMRIGHT', LFGTimer, 0 - width, 0)
					flag = flag + 1
					if flag >= 10 then
						flag = 0
					end
				else
					obj:SetScript('OnUpdate', nil)
				end
				obj.nextUpdate = 0
			end
		end)
	end

	local function UpdatePVPTimer()
		if not PVPTimer.bar then
			PVPTimer:SetPoint('BOTTOMLEFT')
			PVPTimer:SetPoint('BOTTOMRIGHT')
			PVPTimer:SetHeight(3)

			PVPTimer.bar = CreateFrame('StatusBar', nil, PVPTimer)
			PVPTimer.bar:SetStatusBarTexture(C.Assets.norm_tex)
			PVPTimer.bar:SetPoint('TOPLEFT', C.Mult, -C.Mult)
			PVPTimer.bar:SetPoint('BOTTOMLEFT', -C.Mult, C.Mult)
			PVPTimer.bar:SetFrameLevel(_G.PVPReadyDialog:GetFrameLevel() + 1)
			PVPTimer.bar:SetStatusBarColor(C.r, C.g, C.b)
		end

		local obj = _G.PVPReadyDialog
		local oldTime = _G.GetTime()
		local flag = 0
		local duration = 90
		local interval = 0.1
		obj:SetScript('OnUpdate', function(self, elapsed)
			obj.nextUpdate = obj.nextUpdate + elapsed
			if obj.nextUpdate > interval then
				local newTime = GetTime()
				if (newTime - oldTime) < duration then
					local width = PVPTimer:GetWidth() * (newTime - oldTime) / duration
					PVPTimer.bar:SetPoint('BOTTOMRIGHT', PVPTimer, 0 - width, 0)
					flag = flag + 1
					if flag >= 10 then
						flag = 0
					end
				else
					obj:SetScript('OnUpdate', nil)
				end
				obj.nextUpdate = 0
			end
		end)
	end

	function BLIZZARD:QueueTimer()
		if not C.DB.blizzard.queue_timer then return end

		LFGTimer:RegisterEvent('LFG_PROPOSAL_SHOW')
		LFGTimer:SetScript('OnEvent', function(self)
			if _G.LFGDungeonReadyDialog:IsShown() then
				UpdateLFGTimer()
			end
		end)

		PVPTimer:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
		PVPTimer:SetScript('OnEvent', function(self)
			if _G.PVPReadyDialog:IsShown() then
				UpdatePVPTimer()
			end
		end)
	end
end

--[[ do
	-- remove tutorial buttons
	if _G.IsAddOnLoaded('Blizzard_TalentUI') then
		_G.PlayerTalentFrameSpecializationTutorialButton:Kill()
		_G.PlayerTalentFrameTalentsTutorialButton:Kill()
		_G.PlayerTalentFramePetSpecializationTutorialButton:Kill()
		_G.PlayerTalentFrameTalentsPvpTalentFrame.TrinketSlot.HelpBox:Kill()
		_G.PlayerTalentFrameTalentsPvpTalentFrame.WarmodeTutorialBox:Kill()
	end

	_G.SpellBookFrameTutorialButton:Kill()
	_G.HelpOpenTicketButtonTutorial:Kill()
	_G.HelpPlate:Kill()
	_G.HelpPlateTooltip:Kill()

	_G.WorldMapFrame.BorderFrame.Tutorial:Kill()

	if _G.IsAddOnLoaded('Blizzard_Collections') then
		_G.PetJournalTutorialButton:Kill()
	end

	_G.CollectionsMicroButtonAlert:UnregisterAllEvents()
	_G.CollectionsMicroButtonAlert:SetParent(F.HiddenFrame)
	_G.CollectionsMicroButtonAlert:Hide()

	_G.EJMicroButtonAlert:UnregisterAllEvents()
	_G.EJMicroButtonAlert:SetParent(F.HiddenFrame)
	_G.EJMicroButtonAlert:Hide()

	_G.LFDMicroButtonAlert:UnregisterAllEvents()
	_G.LFDMicroButtonAlert:SetParent(F.HiddenFrame)
	_G.LFDMicroButtonAlert:Hide()

	_G.TutorialFrameAlertButton:UnregisterAllEvents()
	_G.TutorialFrameAlertButton:SetParent(F.HiddenFrame)
	_G.TutorialFrameAlertButton:Hide()

	_G.TalentMicroButtonAlert:UnregisterAllEvents()
	_G.TalentMicroButtonAlert:SetParent(F.HiddenFrame)
	_G.TalentMicroButtonAlert:Hide()

	-- remove tutorial popups
	local function OnEvent(self, event)
		SetCVar('showTutorials', 0)
		SetCVar('showNPETutorials', 0)

		for i = 1, NUM_LE_FRAME_TUTORIALS do
			C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
		end

		for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
			C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
		end
	end

	local f = CreateFrame('Frame')
	f:RegisterEvent('VARIABLES_LOADED')
	f:SetScript('OnEvent', OnEvent)
end ]]
