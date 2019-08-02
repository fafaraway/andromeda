local F, C, L = unpack(select(2, ...))
local MISC = F:RegisterModule('Misc')


local _G = getfenv(0)
local tostring, tonumber, pairs, select, random, strsplit = tostring, tonumber, pairs, select, math.random, string.split
local InCombatLockdown, IsModifiedClick, IsAltKeyDown = InCombatLockdown, IsModifiedClick, IsAltKeyDown
local GetNumArchaeologyRaces = GetNumArchaeologyRaces
local GetNumArtifactsByRace = GetNumArtifactsByRace
local GetArtifactInfoByRace = GetArtifactInfoByRace
local GetArchaeologyRaceInfo = GetArchaeologyRaceInfo
local GetNumAuctionItems, GetAuctionItemInfo = GetNumAuctionItems, GetAuctionItemInfo
local FauxScrollFrame_GetOffset, SetMoneyFrameColor = FauxScrollFrame_GetOffset, SetMoneyFrameColor
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemInfo = GetItemInfo
local BuyMerchantItem = BuyMerchantItem
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local GetItemQualityColor = GetItemQualityColor
local Screenshot = Screenshot
local GetTime, GetCVarBool, SetCVar = GetTime, GetCVarBool, SetCVar
local GetNumLootItems, LootSlot = GetNumLootItems, LootSlot
local GetNumSavedInstances = GetNumSavedInstances
local GetInstanceInfo = GetInstanceInfo
local GetSavedInstanceInfo = GetSavedInstanceInfo
local SetSavedInstanceExtend = SetSavedInstanceExtend
local RequestRaidInfo, RaidInfoFrame_Update = RequestRaidInfo, RaidInfoFrame_Update
local IsGuildMember, BNGetGameAccountInfoByGUID, C_FriendList_IsFriend = IsGuildMember, BNGetGameAccountInfoByGUID, C_FriendList.IsFriend


function MISC:OnLogin()
	self:ShowItemLevel()
	self:ProgressBar()
	self:FlashCursor()
	self:MissingStats()
	self:MissingBuffs()
	self:FasterLoot()
	self:UndressButton()
	self:FasterDelete()
	self:FlightMasterWhistle()
	self:ReadyCheckEnhancement()
	self:Marker()
	self:Focuser()
	self:NakedIcon()
	self:CMGuildBest()
	self:MailButton()
	self:CombatText()
	self:PetFilter()
	self:PVPMessageEnhancement()
	self:Durability()
	self:ReputationEnhancement()
	self:TradeTargetInfo()
end


-- Enhance PVP message
function MISC:PVPMessageEnhancement(_, msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'pvp' or instanceType == 'arena' then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo['RAID_BOSS_EMOTE']);
	end
end

-- Undress button
function MISC:UndressButton()
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
function MISC:FasterDelete()
	hooksecurefunc(StaticPopupDialogs['DELETE_GOOD_ITEM'], 'OnShow', function(self)
		self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
	end)
end

-- Faster looting
local lootDelay = 0
local function FasterLoot()
	if GetTime() - lootDelay >= 0.3 then
		lootDelay = GetTime()
		if GetCVarBool('autoLootDefault') ~= IsModifiedClick('AUTOLOOTTOGGLE') then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			lootDelay = GetTime()
		end
	end
end

function MISC:FasterLoot()
	if C.general.fasterLoot then
		F:RegisterEvent('LOOT_READY', FasterLoot)
	else
		F:UnregisterEvent('LOOT_READY', FasterLoot)
	end
end

-- Plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function MISC:FlightMasterWhistle()
	local whistleSound = C.AssetsPath..'sound\\whistle.ogg'
	local whistle_SpellID1 = 227334;
	-- for some reason the whistle is two spells which results in dirty events being called
	-- where spellID2 fires SUCCEEDED on spell cast start and spellID1 comes in later as the real SUCCEEDED
	local whistle_SpellID2 = 253937;

	local casting = false;

	local f = CreateFrame('frame')
	f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end);

	function f:UNIT_SPELLCAST_SUCCEEDED(unit,lineID,spellID)
		if (unit == 'player' and (spellID == whistle_SpellID1 or spellID == whistle_SpellID2)) then
			if casting then
				casting = false
				return
			end

			PlaySoundFile(whistleSound)
			casting = false
		end
	end

	function f:UNIT_SPELLCAST_START(event, castGUID, spellID)
		if spellID == whistle_SpellID1 then
			casting = true
		end
	end
	f:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
	f:RegisterEvent('UNIT_SPELLCAST_START')
end

-- Ready check in master sound
function MISC:ReadyCheckEnhancement()
	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
	f:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH')
	f:RegisterEvent('LFG_PROPOSAL_SHOW')
	f:RegisterEvent('RESURRECT_REQUEST')
	f:RegisterEvent('READY_CHECK')
	f:SetScript('OnEvent', function(self, event)
		if event == 'UPDATE_BATTLEFIELD_STATUS' then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == 'confirm' then
					PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
					break
				end
				i = i + 1
			end
		elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
			PlaySound(SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
		elseif event == 'LFG_PROPOSAL_SHOW' then
			PlaySound(SOUNDKIT.READY_CHECK, 'Master')
		elseif event == 'RESURRECT_REQUEST' then
			PlaySound(37, 'Master')
		elseif event == 'READY_CHECK' then
			PlaySound(SOUNDKIT.READY_CHECK, 'master')
		end
	end)
end

-- Flash cursor
function MISC:FlashCursor()
	if not C.general.flashCursor then return end

	local f = CreateFrame('Frame', nil, UIParent);
	f:SetFrameStrata('TOOLTIP');

	local texture = f:CreateTexture();
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
	f:SetScript('OnUpdate', OnUpdate);
end

-- Get Naked
function MISC:NakedIcon()
	local bu = CreateFrame('Button', nil, CharacterFrameInsetRight)
	bu:SetSize(31, 33)
	bu:SetPoint('RIGHT', PaperDollSidebarTab1, 'LEFT', -4, -2)
	F.PixelIcon(bu, 'Interface\\ICONS\\UI_Calendar_FreeTShirtDay', true)
	F.AddTooltip(bu, 'ANCHOR_RIGHT', L['MISC_GET_NAKED'])

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

-- TradeFrame hook
function MISC:TradeTargetInfo()
	local infoText = F.CreateFS(TradeFrame, {C.font.normal, 14}, '', nil, nil, true)
	infoText:ClearAllPoints()
	infoText:SetPoint('TOP', TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

	local function updateColor()
		local r, g, b = F.UnitColor('NPC')
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID('NPC')
		if not guid then return end
		local text = '|cffff0000'..L['MISC_STRANGER']
		if BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = '|cffffff00'..FRIEND
		elseif IsGuildMember(guid) then
			text = '|cff00ff00'..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc('TradeFrame_Update', updateColor)
end

-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G['RaidGroupButton'..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute('type', 'target')
				bu:SetAttribute('unit', bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local function setupMisc(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_RaidUI' then
			if not InCombatLockdown() then
				fixRaidGroupButton()
			else
				F:RegisterEvent('PLAYER_REGEN_ENABLED', setupMisc)
			end
			F:UnregisterEvent(event, setupMisc)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute('type') ~= 'target' then
				fixRaidGroupButton()
				F:UnregisterEvent(event, setupMisc)
			end
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end

-- ALT+RightClick to buy a stack
do
	local cache = {}
	local itemLink, id

	StaticPopupDialogs['BUY_STACK'] = {
		text = L['MISC_STACK_BUYING_CHECK'],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then return end
			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hideOnEscape = 1,
		hasItemFrame = 1,
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then return end
			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = GetItemQualityColor(quality or 1)
					StaticPopup_Show('BUY_STACK', ' ', ' ', {['texture'] = texture, ['name'] = name, ['color'] = {r, g, b, 1}, ['link'] = itemLink, ['index'] = id, ['count'] = maxStack})
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end

		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end

-- Show BID and highlight price
do
	local function setupMisc(event, addon)
		if addon == 'Blizzard_AuctionUI' then
			hooksecurefunc('AuctionFrameBrowse_Update', function()
				local numBatchAuctions = GetNumAuctionItems('list')
				local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
				local name, buyoutPrice, bidAmount, hasAllInfo
				for i = 1, NUM_BROWSE_TO_DISPLAY do
					local index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
					local shouldHide = index > (numBatchAuctions + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page))
					if not shouldHide then
						name, _, _, _, _, _, _, _, _, buyoutPrice, bidAmount, _, _, _, _, _, _, hasAllInfo = GetAuctionItemInfo('list', offset + i)
						if not hasAllInfo then shouldHide = true end
					end
					if not shouldHide then
						local alpha = .5
						local color = 'yellow'
						local buttonName = 'BrowseButton'..i
						local itemName = _G[buttonName..'Name']
						local moneyFrame = _G[buttonName..'MoneyFrame']
						local buyoutMoney = _G[buttonName..'BuyoutFrameMoney']
						if buyoutPrice >= 5*1e7 then color = 'red' end
						if bidAmount > 0 then
							name = name..' |cffffff00'..BID..'|r'
							alpha = 1.0
						end
						itemName:SetText(name)
						moneyFrame:SetAlpha(alpha)
						SetMoneyFrameColor(buyoutMoney:GetName(), color)
					end
				end
			end)

			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end

-- Archaeology counts
do
	local function CalculateArches()
		print('|cff0080ff[FreeUI]'..'|c0000FF00'..L['MISC_ARCHAEOLOGY_COUNT']..':')
		local total = 0
		for i = 1, GetNumArchaeologyRaces() do
			local numArtifacts = GetNumArtifactsByRace(i)
			local count = 0
			for j = 1, numArtifacts do
				local completionCount = select(10, GetArtifactInfoByRace(i, j))
				count = count + completionCount
			end
			local name = GetArchaeologyRaceInfo(i)
			if numArtifacts > 1 then
				print('     - |cfffed100'..name..': '..'|cff70C0F5'..count)
				total = total + count
			end
		end
		print('     - |c0000ff00'..TOTAL..': '..'|cffff0000'..total)
		print(C.GreyColor..'------------------------')
	end

	local function AddCalculateIcon()
		local bu = CreateFrame('Button', nil, ArchaeologyFrameCompletedPage)
		bu:SetPoint('TOPRIGHT', -45, -45)
		bu:SetSize(35, 35)
		F.PixelIcon(bu, 'Interface\\ICONS\\Ability_Iyyokuk_Calculate', true)
		F.AddTooltip(bu, 'ANCHOR_RIGHT', L['MISC_ARCHAEOLOGY_COUNT'], 'system')
		bu:SetScript('OnMouseUp', CalculateArches)
	end

	local function setupMisc(event, addon)
		if addon == 'Blizzard_ArchaeologyUI' then
			AddCalculateIcon()

			local frame = ArcheologyDigsiteProgressBar
			local bar = frame.FillBar

			frame.Shadow:Hide()
			frame.BarBackground:Hide()
			frame.BarBorderAndOverlay:Hide()

			F.SetFS(frame.BarTitle, C.isCNClient)

			frame.BarTitle:SetPoint('CENTER', frame)

			bar:SetSize(200, 20)
			frame.Flash:SetWidth(bar:GetWidth() + 20)

			bar:SetStatusBarTexture(C.media.sbTex)
			bar:SetStatusBarColor(221/255, 197/255, 162/255)

			bar.bg = F.CreateBDFrame(bar)
			F.CreateSD(bar.bg)

			ArcheologyDigsiteProgressBar.ignoreFramePositionManager = true
			ArcheologyDigsiteProgressBar:SetPoint('TOP', UIParent, 'TOP', 0, -50)

			F.CreateMF(ArcheologyDigsiteProgressBar)

			F:UnregisterEvent(event, setupMisc)
		end
	end

	F:RegisterEvent('ADDON_LOADED', setupMisc)
end