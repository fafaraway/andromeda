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
	self:EasyDelete()
	self:TicketStatusMover()
	self:VehicleIndicatorMover()
	self:DurabilityFrameMover()
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

function BLIZZARD:DurabilityFrameMover()
	local frame = CreateFrame('Frame', 'FreeUIDurabilityFrameMover', UIParent)
	frame:SetSize(100, 100)
	F.Mover(frame, L['BLIZZARD_MOVER_DURABILITY'], 'DurabilityFrame', {'TOPRIGHT', ObjectiveTrackerFrame, 'TOPLEFT', -10, 0})

	hooksecurefunc(DurabilityFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
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




