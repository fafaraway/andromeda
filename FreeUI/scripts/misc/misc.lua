local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule('Misc')

function module:OnLogin()
	self:ItemLevel()
	self:ProgressBar()
	self:FlashCursor()
	self:QuickJoin()
	self:MissingStats()
	self:FasterLoot()
	self:Vignette()
	self:PVPMessageEnhancement()
	self:UndressButton()
	self:FasterDelete()
	self:FlightMasterWhistle()
	self:ReadyCheckEnhancement()
	self:Marker()
	self:Focuser()
	self:NakedIcon()
	self:ExtendInstance()
	self:CMGuildBest()

	if C.general.autoBubble then
		local function UpdateBubble()
			local name, instType = GetInstanceInfo()
			if name and instType == 'raid' then
				SetCVar('chatBubbles', 1)
			else
				SetCVar('chatBubbles', 0)
			end
		end
		UpdateBubble()
		F:RegisterEvent('ZONE_CHANGED_NEW_AREA', UpdateBubble)
	end

	hooksecurefunc('ReputationFrame_Update', self.HookParagonRep)
end







-- adding a shadowed border to the UI window
function module:Vignette()
	if not C.appearance.vignette then return end

	self.f = CreateFrame('Frame', 'ShadowBackground')
	self.f:SetPoint('TOPLEFT')
	self.f:SetPoint('BOTTOMRIGHT')
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata('BACKGROUND')
	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\FreeUI\assets\vignette.tga]])
	self.f.tex:SetAllPoints(f)

	self.f:SetAlpha(C.appearance.vignetteAlpha)
end





-- enhance PVP message
function module:PVPMessageEnhancement(_, msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'pvp' or instanceType == 'arena' then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo['RAID_BOSS_EMOTE']);
	end
end


-- undress button on dress up frame
function module:UndressButton()
	local undress = CreateFrame('Button', 'DressUpFrameUndressButton', DressUpFrame, 'UIPanelButtonTemplate')
	undress:SetSize(80, 22)
	undress:SetPoint('RIGHT', DressUpFrameResetButton, 'LEFT', -1, 0)
	undress:SetText(L['NAKE_BUTTON'])
	undress:SetScript('OnClick', function()
		DressUpModel:Undress()
	end)

	local sideUndress = CreateFrame('Button', 'SideDressUpModelUndressButton', SideDressUpModel, 'UIPanelButtonTemplate')
	sideUndress:SetSize(80, 22)
	sideUndress:SetPoint('TOP', SideDressUpModelResetButton, 'BOTTOM', 0, -5)
	sideUndress:SetText(L['NAKE_BUTTON'])
	sideUndress:SetScript('OnClick', function()
		SideDressUpModel:Undress()
	end)

	F.Reskin(undress)
	F.Reskin(sideUndress)
end


-- Instant delete
function module:FasterDelete()
	hooksecurefunc(StaticPopupDialogs['DELETE_GOOD_ITEM'], 'OnShow', function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end


-- Faster Looting
function module:FasterLoot()
	if not C.general.fasterLoot then return end
	local faster = CreateFrame('Frame')
	faster:RegisterEvent('LOOT_READY')
	faster:SetScript('OnEvent',function()
		local tDelay = 0
		if GetTime() - tDelay >= 0.3 then
			tDelay = GetTime()
			if GetCVarBool('autoLootDefault') ~= IsModifiedClick('AUTOLOOTTOGGLE') then
				for i = GetNumLootItems(), 1, -1 do
					LootSlot(i)
				end
				tDelay = GetTime()
			end
		end
	end)
end


-- plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function module:FlightMasterWhistle()
	local flightMastersWhistle_SpellID1 = 227334
	local flightMastersWhistle_SpellID2 = 253937
	local whistleSound = 'Interface\\Addons\\FreeUI\\assets\\sound\\blowmywhistle.ogg'

	local f = CreateFrame('frame')
	f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end);

	function f:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
		if (unit == 'player' and (spellID == flightMastersWhistle_SpellID1 or spellID == flightMastersWhistle_SpellID2)) then
			PlaySoundFile(whistleSound)
		end
	end
	f:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
end


-- ready check in master sound
function module:ReadyCheckEnhancement()
	F:RegisterEvent('READY_CHECK', function()
		PlaySound(SOUNDKIT.READY_CHECK, 'master')
	end)
end


-- paragon reputation
function module:HookParagonRep()
	if not C.general.paragonRep then return end

	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G['ReputationBar'..i]
		local factionBar = _G['ReputationBar'..i..'ReputationBar']
		local factionStanding = _G['ReputationBar'..i..'ReputationBarFactionStanding']

		if factionIndex <= numFactions then
			local factionID = select(14, GetFactionInfo(factionIndex))
			if factionID and C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
				local barValue = mod(currentValue, threshold)
				local factionStandingtext = C.InfoColor..L['PARAGON']..' ('..floor(currentValue/threshold)..')'

				factionBar:SetMinMaxValues(0, threshold)
				factionBar:SetValue(barValue)
				factionStanding:SetText(factionStandingtext)
				factionRow.standingText = factionStandingtext
				factionRow.rolloverText = C.InfoColor..format(REPUTATION_PROGRESS_FORMAT, barValue, threshold)
			end
		end
	end
end


-- flash cursor
function module:FlashCursor()
	if not C.general.flashCursor then return end

	local frame = CreateFrame('Frame', nil, UIParent);
	frame:SetFrameStrata('TOOLTIP');

	local texture = frame:CreateTexture();
	texture:SetTexture([[Interface\Cooldown\star4]]);
	texture:SetBlendMode('ADD');
	texture:SetAlpha(0.5);

	local x = 0;
	local y = 0;
	local speed = 0;
	local function OnUpdate(_, elapsed)
		local dX = x;
		local dY = y;
		x, y = GetCursorPosition();
		dX = x - dX;
		dY = y - dY;
		local weight = 2048 ^ -elapsed;
		speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024);
		local size = speed / 6 - 16;
		if (size > 0) then
			local scale = UIParent:GetEffectiveScale();
			texture:SetHeight(size);
			texture:SetWidth(size);
			texture:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
			texture:Show();
		else
			texture:Hide();
		end
	end
	frame:SetScript('OnUpdate', OnUpdate);
end


-- Get Naked
function module:NakedIcon()
	local bu = CreateFrame('Button', nil, CharacterFrameInsetRight)
	bu:SetSize(31, 33)
	bu:SetPoint('RIGHT', PaperDollSidebarTab1, 'LEFT', -4, -2)
	F.PixelIcon(bu, 'Interface\\ICONS\\SPELL_SHADOW_TWISTEDFAITH', true)
	F.AddTooltip(bu, 'ANCHOR_RIGHT', L['GET_NAKED'])

	local function UnequipItemInSlot(i)
		local action = EquipmentManager_UnequipItemInSlot(i)
		EquipmentManager_RunAction(action)
	end

	bu:SetScript('OnDoubleClick', function()
		for i = 1, 17 do
			local texture = GetInventoryItemTexture('player', i)
			if texture then
				UnequipItemInSlot(i) 
			end
		end
	end)
end


-- Show BID and highlight price
do
	local function setupMisc(event, addon)
		if addon == 'Blizzard_AuctionUI' then
			hooksecurefunc('AuctionFrameBrowse_Update', function()
				local numBatchAuctions = GetNumAuctionItems('list')
				local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
				for i = 1, NUM_BROWSE_TO_DISPLAY do
					local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
					if index <= numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page) then
						local name, _, _, _, _, _, _, _, _, buyoutPrice, bidAmount =  GetAuctionItemInfo('list', offset + i)
						local alpha = .5
						local color = 'yellow'
						if name then
							local itemName = _G['BrowseButton'..i..'Name']
							local moneyFrame = _G['BrowseButton'..i..'MoneyFrame']
							local buyoutMoney = _G['BrowseButton'..i..'BuyoutFrameMoney']
							if buyoutPrice/10000 >= 5000 then color = 'red' end
							if bidAmount > 0 then
								name = name .. ' |cffffff00'..BID..'|r'
								alpha = 1.0
							end
							itemName:SetText(name)
							moneyFrame:SetAlpha(alpha)
							SetMoneyFrameColor(buyoutMoney:GetName(), color)
						end
					end
				end
			end)

			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end


-- Extend Instance
function module:ExtendInstance()
	local bu = CreateFrame('Button', nil, RaidInfoFrame)
	bu:SetPoint('TOPRIGHT', -35, -5)
	bu:SetSize(25, 25)
	F.PixelIcon(bu, GetSpellTexture(80353), true)
	F.AddTooltip(bu, 'ANCHOR_RIGHT', L['EXTEND_INSTANCE'], 'system')

	bu:SetScript('OnMouseUp', function(_, btn)
		for i = 1, GetNumSavedInstances() do
			local _, _, _, _, _, extended, _, isRaid = GetSavedInstanceInfo(i)
			if isRaid then
				if btn == 'LeftButton' then
					if not extended then
						SetSavedInstanceExtend(i, true)		-- extend
					end
				else
					if extended then
						SetSavedInstanceExtend(i, false)	-- cancel
					end
				end
			end
		end
		RequestRaidInfo()
		RaidInfoFrame_Update()
	end)
end


-- TradeFrame hook
do
	local IsGuildMember, BNGetGameAccountInfoByGUID, C_FriendList_IsFriend = IsGuildMember, BNGetGameAccountInfoByGUID, C_FriendList.IsFriend
	
	local infoText = F.CreateFS(TradeFrame, {C.font.normal, 14}, '', nil, nil, true)
	infoText:ClearAllPoints()
	infoText:SetPoint('TOP', TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

	local function updateColor()
		local r, g, b = F.UnitColor('NPC')
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID('NPC')
		if not guid then return end
		local text = '|cffff0000'..L['STRANGER']
		if BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = '|cffffff00'..FRIEND
		elseif IsGuildMember(guid) then
			text = '|cff00ff00'..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc('TradeFrame_Update', updateColor)
end