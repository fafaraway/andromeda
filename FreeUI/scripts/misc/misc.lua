local F, C, L = unpack(select(2, ...))
local MISC = F:RegisterModule('Misc')


local _G = getfenv(0)
local tostring, tonumber, pairs, select, random, strsplit, strmatch = tostring, tonumber, pairs, select, math.random, string.split, string.match


function MISC:OnLogin()
	self:ItemLevel()
	self:Durability()
	self:FullStats()


	self:CommandBar()



	self:AlertFrame()
	self:ErrorFrame()
	self:BuffFrame()
	self:UIWidgetFrame()
	self:ColorPicker()

	self:FasterLoot()
	self:FasterDelete()

	self:Whistle()
	self:ReadyCheck()
	self:Marker()
	self:Focuser()

	self:GetNaked()

	self:ColletMail()

	self:GuildBest()
	
	self:CombatText()


	self:PetFilter()


	self:PVPMessage()
	self:PVPSound()
	
	self:Reputation()
	self:TradeTargetInfo()
	self:TicketStatusFrame()
	self:VehicleIndicator()
	self:HideBossBanner()

	self:HideNewTalentAlert()
	self:SkipAzeriteAnimation()

	self:QuickJoin()
	self:Cooldown()

	CharacterMicroButtonAlert:EnableMouse(false)
	F.HideOption(CharacterMicroButtonAlert)
end


-- Enhance PVP message
function MISC:PVPMessage(_, msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'pvp' or instanceType == 'arena' then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo['RAID_BOSS_EMOTE']);
	end
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
function MISC:Whistle()
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
function MISC:ReadyCheck()
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



-- Get Naked
function MISC:GetNaked()
	if not C.general.getNaked then return end

	local nakedButton = CreateFrame('Button', nil, CharacterFrameInsetRight)
	nakedButton:SetSize(31, 33)
	nakedButton:SetPoint('RIGHT', PaperDollSidebarTab1, 'LEFT', -4, -2)
	F.PixelIcon(nakedButton, 'Interface\\ICONS\\UI_Calendar_FreeTShirtDay', true)
	F.AddTooltip(nakedButton, 'ANCHOR_RIGHT', L['MISC_GET_NAKED'])

	local function UnequipItemInSlot(i)
		local action = EquipmentManager_UnequipItemInSlot(i)
		EquipmentManager_RunAction(action)
	end

	nakedButton:SetScript('OnDoubleClick', function()
		for i = 1, 17 do
			local texture = GetInventoryItemTexture('player', i)
			if texture then
				UnequipItemInSlot(i)
			end
		end
	end)

	local undressButton = CreateFrame('Button', 'DressUpFrameUndressButton', DressUpFrame, 'UIPanelButtonTemplate')
	undressButton:SetSize(80, 22)
	undressButton:SetPoint('RIGHT', DressUpFrameResetButton, 'LEFT', -1, 0)
	undressButton:SetText(L['NAKE_BUTTON'])
	undressButton:SetScript('OnClick', function()
		DressUpModel:Undress()
	end)

	local sideUndressButton = CreateFrame('Button', 'SideDressUpModelUndressButton', SideDressUpModel, 'UIPanelButtonTemplate')
	sideUndressButton:SetSize(80, 22)
	sideUndressButton:SetPoint('TOP', SideDressUpModelResetButton, 'BOTTOM', 0, -5)
	sideUndressButton:SetText(L['NAKE_BUTTON'])
	sideUndressButton:SetScript('OnClick', function()
		SideDressUpModel:Undress()
	end)

	F.Reskin(undressButton)
	F.Reskin(sideUndressButton)
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
		if BNGetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) then
			text = '|cffffff00'..FRIEND
		elseif IsGuildMember(guid) then
			text = '|cff00ff00'..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc('TradeFrame_Update', updateColor)
end



-- Restyle orderhall command bar
function MISC:CommandBar()
	if not C.general.vignette then return end

	local f = CreateFrame('Frame')
	f:SetScript('OnEvent', function(self, event, arg1)
		if event == 'ADDON_LOADED' and arg1 == 'Blizzard_OrderHallUI' then
			f:RegisterEvent('DISPLAY_SIZE_CHANGED')
			f:RegisterEvent('UI_SCALE_CHANGED')
			f:RegisterEvent('GARRISON_FOLLOWER_CATEGORIES_UPDATED')
			f:RegisterEvent('GARRISON_FOLLOWER_ADDED')
			f:RegisterEvent('GARRISON_FOLLOWER_REMOVED')

			local bar = OrderHallCommandBar

			bar:HookScript('OnShow', function()
				if not bar.styled then
					bar:EnableMouse(false)
					bar.Background:SetAtlas(nil)

					bar.ClassIcon:ClearAllPoints()
					bar.ClassIcon:SetPoint('TOPLEFT', 30, -30)
					bar.ClassIcon:SetSize(40,20)
					bar.ClassIcon:SetAlpha(1)
					local bg = F.CreateBDFrame(bar.ClassIcon)
					F.CreateSD(bg)

					bar.AreaName:ClearAllPoints()
					bar.AreaName:SetPoint('LEFT', bar.ClassIcon, 'RIGHT', 5, 0)
					bar.AreaName:SetFont(C.font.normal, 14, 'OUTLINE')
					bar.AreaName:SetTextColor(1, 1, 1)
					bar.AreaName:SetShadowOffset(0, 0)

					bar.CurrencyIcon:ClearAllPoints()
					bar.CurrencyIcon:SetPoint('LEFT', bar.AreaName, 'RIGHT', 5, 0)
					bar.Currency:ClearAllPoints()
					bar.Currency:SetPoint('LEFT', bar.CurrencyIcon, 'RIGHT', 5, 0)
					bar.Currency:SetFont(C.font.normal, 14, 'OUTLINE')
					bar.Currency:SetTextColor(1, 1, 1)
					bar.Currency:SetShadowOffset(0, 0)

					bar.WorldMapButton:Hide()

					bar.styled = true
				end
			end)
		elseif event ~= 'ADDON_LOADED' then
			local index = 1
			C_Timer.After(0.1, function()
				for i, child in ipairs({bar:GetChildren()}) do
					if child.Icon and child.Count and child.TroopPortraitCover then
						child:SetPoint('TOPLEFT', bar.ClassIcon, 'BOTTOMLEFT', -5, -index*25+20)
						child.TroopPortraitCover:Hide()

						child.Icon:SetSize(40,20)
						local bg = F.CreateBDFrame(child.Icon)
						F.CreateSD(bg)

						child.Count:SetFont(C.font.normal, 14, 'OUTLINE')
						child.Count:SetTextColor(1, 1, 1)
						child.Count:SetShadowOffset(0, 0)

						index = index + 1
					end
				end
			end)
		end
	end)

	f:RegisterEvent('ADDON_LOADED')
end

-- Reanchor vehicle indicator
function MISC:VehicleIndicator()
	local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', UIParent)
	frame:SetSize(125, 125)
	F.Mover(frame, L['MOVER_VEHICLE_INDICATOR'], 'VehicleIndicator', {'BOTTOMRIGHT', Minimap, 'TOPRIGHT', 0, 0})

	hooksecurefunc(VehicleSeatIndicator, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOPLEFT', frame)
			self:SetScale(.7)
		end
	end)
end

-- Reanchor TicketStatusFrame
function MISC:TicketStatusFrame()
	hooksecurefunc(TicketStatusFrame, 'SetPoint', function(self, relF)
		if relF == 'TOPRIGHT' then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 'TOP', 0, -100)
		end
	end)
end

-- Remove Boss Banner
function MISC:HideBossBanner()
	if C.general.hideBossBanner then
		BossBanner:UnregisterAllEvents()
	end
end

-- Reanchor UIWidgetBelowMinimapContainerFrame
function MISC:UIWidgetFrame()
	UIWidgetTopCenterContainerFrame:ClearAllPoints()
	UIWidgetTopCenterContainerFrame:SetPoint('TOP', 0, -30)

	hooksecurefunc(UIWidgetBelowMinimapContainerFrame, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 0, -120)
		end
	end)
end


function MISC:SkipAzeriteAnimation()
	if not (IsAddOnLoaded('Blizzard_AzeriteUI')) then
		UIParentLoadAddOn('Blizzard_AzeriteUI')
	end
	hooksecurefunc(AzeriteEmpoweredItemUI,'OnItemSet',function(self)
		local itemLocation = self.azeriteItemDataSource:GetItemLocation()
		if self:IsAnyTierRevealing() then
			C_Timer.After(0.7,function() 
				OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
			end)
		end
	end)
end


function MISC:HideNewTalentAlert()
	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end
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
		hasItemFrame = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = true,
		preferredIndex = 5,
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

-- Temporary taint fix
do
	InterfaceOptionsFrameCancel:SetScript('OnClick', function()
		InterfaceOptionsFrameOkay:Click()
	end)

	-- https://www.townlong-yak.com/bugs/Kjq4hm-DisplayModeCommunitiesTaint
	if (UIDROPDOWNMENU_OPEN_PATCH_VERSION or 0) < 1 then
		UIDROPDOWNMENU_OPEN_PATCH_VERSION = 1
		hooksecurefunc('UIDropDownMenu_InitializeHelper', function(frame)
			if UIDROPDOWNMENU_OPEN_PATCH_VERSION ~= 1 then return end

			if UIDROPDOWNMENU_OPEN_MENU and UIDROPDOWNMENU_OPEN_MENU ~= frame and not issecurevariable(UIDROPDOWNMENU_OPEN_MENU, 'displayMode') then
				UIDROPDOWNMENU_OPEN_MENU = nil
				local t, f, prefix, i = _G, issecurevariable, ' \0', 1
				repeat
					i, t[prefix .. i] = i+1
				until f('UIDROPDOWNMENU_OPEN_MENU')
			end
		end)
	end

	-- https://www.townlong-yak.com/bugs/YhgQma-SetValueRefreshTaint
	if (COMMUNITY_UIDD_REFRESH_PATCH_VERSION or 0) < 1 then
		COMMUNITY_UIDD_REFRESH_PATCH_VERSION = 1
		local function CleanDropdowns()
			if COMMUNITY_UIDD_REFRESH_PATCH_VERSION ~= 1 then
				return
			end
			local f, f2 = FriendsFrame, FriendsTabHeader
			local s = f:IsShown()
			f:Hide()
			f:Show()
			if not f2:IsShown() then
				f2:Show()
				f2:Hide()
			end
			if not s then
				f:Hide()
			end
		end
		hooksecurefunc('Communities_LoadUI', CleanDropdowns)
		hooksecurefunc('SetCVar', function(n)
			if n == 'lastSelectedClubId' then
				CleanDropdowns()
			end
		end)
	end
end

-- Fix Drag Collections taint
do
	local done
	local function fixBlizz(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_Collections' then
			CollectionsJournal:HookScript('OnShow', function()
				if not done then
					if InCombatLockdown() then
						F:RegisterEvent('PLAYER_REGEN_ENABLED', fixBlizz)
					else
						F.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			F:UnregisterEvent(event, fixBlizz)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			F.CreateMF(CollectionsJournal)
			F:UnregisterEvent(event, fixBlizz)
		end
	end

	F:RegisterEvent('ADDON_LOADED', fixBlizz)
end

-- Fix trade skill search
hooksecurefunc('ChatEdit_InsertLink', function(text) -- shift-clicked
	-- change from SearchBox:HasFocus to :IsShown again
	if text and TradeSkillFrame and TradeSkillFrame:IsShown() then
		local spellId = strmatch(text, 'enchant:(%d+)')
		local spell = GetSpellInfo(spellId)
		local item = GetItemInfo(strmatch(text, 'item:(%d+)') or 0)
		local search = spell or item
		if not search then return end

		-- search needs to be lowercase for .SetRecipeItemNameFilter
		TradeSkillFrame.SearchBox:SetText(search)

		-- jump to the recipe
		if spell then -- can only select recipes on the learned tab
			if PanelTemplates_GetSelectedTab(TradeSkillFrame.RecipeList) == 1 then
				TradeSkillFrame:SelectRecipe(tonumber(spellId))
			end
		elseif item then
			C_Timer.After(.1, function() -- wait a bit or we cant select the recipe yet
				for _, v in pairs(TradeSkillFrame.RecipeList.dataList) do
					if v.name == item then
						--TradeSkillFrame.RecipeList:RefreshDisplay() -- didnt seem to help
						TradeSkillFrame:SelectRecipe(v.recipeID)
						return
					end
				end
			end)
		end
	end
end)

-- make it only split stacks with shift-rightclick if the TradeSkillFrame is open
-- shift-leftclick should be reserved for the search box
local function hideSplitFrame(_, button)
	if TradeSkillFrame and TradeSkillFrame:IsShown() then
		if button == 'LeftButton' then
			StackSplitFrame:Hide()
		end
	end
end
hooksecurefunc('ContainerFrameItemButton_OnModifiedClick', hideSplitFrame)
hooksecurefunc('MerchantItemButton_OnModifiedClick', hideSplitFrame)

-- Fix blizz guild news hyperlink
do
	local function fixGuildNews(event, addon)
		if addon ~= 'Blizzard_GuildUI' then return end

		local _GuildNewsButton_OnEnter = GuildNewsButton_OnEnter
		function GuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_GuildNewsButton_OnEnter(self)
		end

		F:UnregisterEvent(event, fixGuildNews)
	end

	local function fixCommunitiesNews(event, addon)
		if addon ~= 'Blizzard_Communities' then return end

		local _CommunitiesGuildNewsButton_OnEnter = CommunitiesGuildNewsButton_OnEnter
		function CommunitiesGuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_CommunitiesGuildNewsButton_OnEnter(self)
		end

		F:UnregisterEvent(event, fixCommunitiesNews)
	end

	F:RegisterEvent('ADDON_LOADED', fixGuildNews)
	F:RegisterEvent('ADDON_LOADED', fixCommunitiesNews)
end