local F, C, L = unpack(select(2, ...))
local MISC, cfg = F:GetModule('Misc'), C.General


local _G = getfenv(0)
local pairs, tonumber, select, strmatch = pairs, tonumber, select, strmatch
local InCombatLockdown, IsModifiedClick, IsAltKeyDown = InCombatLockdown, IsModifiedClick, IsAltKeyDown
local GetNumArchaeologyRaces = GetNumArchaeologyRaces
local GetNumArtifactsByRace = GetNumArtifactsByRace
local GetArtifactInfoByRace = GetArtifactInfoByRace
local GetArchaeologyRaceInfo = GetArchaeologyRaceInfo
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
local IsGuildMember, C_BattleNet_GetGameAccountInfoByGUID, C_FriendList_IsFriend = IsGuildMember, C_BattleNet.GetGameAccountInfoByGUID, C_FriendList.IsFriend
local GetMerchantNumItems, GetMerchantItemID = GetMerchantNumItems, GetMerchantItemID
local HEADER_COLON, MERCHANT_ITEMS_PER_PAGE = HEADER_COLON, MERCHANT_ITEMS_PER_PAGE


local MISC_LIST = {}

function MISC:RegisterMisc(name, func)
	if not MISC_LIST[name] then
		MISC_LIST[name] = func
	end
end

function MISC:OnLogin()
	for name, func in next, MISC_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end


	self:TutorialBuster()
	self:Errors()


	self:EasyDelete()
	self:EasyNaked()
	self:InstantLoot()
	self:BlockStrangerInvite()


	self:UndressButton()
	self:BlowMyWhistle()

	self:TradeTargetInfo()
	self:TicketStatusFrameMover()
	self:VehicleIndicatorMover()
	self:UIWidgetFrameMover()
	

	-- Hide Bossbanner
	if cfg.hide_boss_banner then
		BossBanner:UnregisterAllEvents()
	end

	-- Unregister talent event
	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end

	-- Readycheck sound on master channel
	F:RegisterEvent('READY_CHECK', function()
		PlaySound(SOUNDKIT.READY_CHECK, 'master')
	end)

	

	-- Fix blizz bug in addon list
	local _AddonTooltip_Update = AddonTooltip_Update
	function AddonTooltip_Update(owner)
		if not owner then return end
		if owner:GetID() < 1 then return end
		_AddonTooltip_Update(owner)
	end

	

	local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
	if not LSM then return end

	local chinese, western = LSM.LOCALE_BIT_zhCN, LSM.LOCALE_BIT_western

	LSM:Register("statusbar", "!Free_statusbar", C.Assets.norm_tex)
	LSM:Register('font', '!Free_normal', C.Assets.Fonts.Normal, chinese + western)
	LSM:Register('font', '!Free_number', C.Assets.Fonts.Number, chinese + western)
	LSM:Register('font', '!Free_chat', C.Assets.Fonts.Chat, chinese + western)
end



function MISC:TutorialBuster()
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
end


-- Plays a soundbite from Whistle - Flo Rida after Flight Master's Whistle
function MISC:BlowMyWhistle()
	if not cfg.whistle then return end

	local whistleSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\whistle.ogg'
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



-- Undress button
function MISC:UndressButton()
	if not cfg.undress_button then return end

	local undressButton = CreateFrame('Button', 'DressUpFrameUndressButton', DressUpFrame, 'UIPanelButtonTemplate')
	undressButton:SetSize(80, 22)
	undressButton:SetPoint('RIGHT', DressUpFrameResetButton, 'LEFT', -1, 0)
	undressButton:SetText(L['MISC_UNDRESS'])
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

-- Colorize trade target name 
function MISC:TradeTargetInfo()
	if not cfg.trade_target_info then return end

	local infoText = F.CreateFS(TradeFrame, C.Assets.Fonts.Normal, 14, true)
	infoText:ClearAllPoints()
	infoText:SetPoint('TOP', TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

	local function updateColor()
		local r, g, b = F.UnitColor('NPC')
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID('NPC')
		if not guid then return end
		local text = C.RedColor..L['MISC_STRANGER']
		if C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = C.GreenColor..FRIEND
		elseif IsGuildMember(guid) then
			text = C.BlueColor..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc('TradeFrame_Update', updateColor)
end

-- Reanchor vehicle indicator
function MISC:VehicleIndicatorMover()
	local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', UIParent)
	frame:SetSize(100, 100)
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
function MISC:TicketStatusFrameMover()
	hooksecurefunc(TicketStatusFrame, 'SetPoint', function(self, relF)
		if relF == 'TOPRIGHT' then
			self:ClearAllPoints()
			self:SetPoint('TOP', UIParent, 'TOP', 0, -100)
		end
	end)
end

-- Reanchor UIWidgetBelowMinimapContainerFrame
function MISC:UIWidgetFrameMover()
	local frame = CreateFrame('Frame', 'NDuiUIWidgetMover', UIParent)
	frame:SetSize(200, 50)
	F.Mover(frame, L['MOVER_UIWIDGETFRAME'], 'UIWidgetFrame', {'TOP', 0, -30})

	hooksecurefunc(UIWidgetBelowMinimapContainerFrame, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint('TOP', frame)
		end
	end)
end

function MISC:Errors()
	if not cfg.tidy_errors then return end

	local holdtime = 0.52 -- hold time (seconds)
	local fadeintime = 0.08 -- fadein time (seconds)
	local fadeouttime = 0.16 -- fade out time (seconds)

	UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')

	local firstErrorFrame = CreateFrame('Frame', 'FreeUIErrors1', UIParent)
	firstErrorFrame:SetScript('OnUpdate', FadingFrame_OnUpdate)
	firstErrorFrame.fadeInTime = fadeintime
	firstErrorFrame.fadeOutTime = fadeouttime
	firstErrorFrame.holdTime = holdtime
	firstErrorFrame:Hide()
	firstErrorFrame:SetFrameStrata('TOOLTIP')
	firstErrorFrame:SetFrameLevel(30)

	local secondErrorFrame = CreateFrame('Frame', 'FreeUIErrors2', UIParent)
	secondErrorFrame:SetScript('OnUpdate', FadingFrame_OnUpdate)
	secondErrorFrame.fadeInTime = fadeintime
	secondErrorFrame.fadeOutTime = fadeouttime
	secondErrorFrame.holdTime = holdtime
	secondErrorFrame:Hide()
	secondErrorFrame:SetFrameStrata('TOOLTIP')
	secondErrorFrame:SetFrameLevel(30)

	firstErrorFrame.text = F.CreateFS(firstErrorFrame, C.Assets.Fonts.Normal, 14, nil, '', nil, 'THICK')
	firstErrorFrame.text:SetPoint('TOP', UIParent, 0, -80)
	secondErrorFrame.text = F.CreateFS(secondErrorFrame, C.Assets.Fonts.Normal, 14, nil, '', nil, 'THICK')
	secondErrorFrame.text:SetPoint('TOP', UIParent, 0, -96)

	local state = 0
	firstErrorFrame:SetScript('OnHide', function() state = 0 end)
	local Error = CreateFrame('Frame')
	Error:RegisterEvent('UI_ERROR_MESSAGE')
	Error:SetScript('OnEvent', function(_, _, code, msg)
		if state == 0 then
			firstErrorFrame.text:SetText(msg)
			FadingFrame_Show(firstErrorFrame)
			state = 1
		else
			secondErrorFrame.text:SetText(msg)
			FadingFrame_Show(secondErrorFrame)
			state = 0
		end
	end)
end

function MISC:EasyDelete()
	hooksecurefunc(StaticPopupDialogs['DELETE_GOOD_ITEM'], 'OnShow', function(self)
		if cfg.easy_delete then
			self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
		end
	end)
end

function MISC:EasyNaked()
	if not cfg.easy_naked then return end

	local bu = CreateFrame('Button', nil, CharacterFrameInsetRight)
	bu:SetSize(31, 33)
	bu:SetPoint('RIGHT', PaperDollSidebarTab1, 'LEFT', -4, -3)
	F.PixelIcon(bu, 'Interface\\ICONS\\UI_Calendar_FreeTShirtDay', true)
	F.AddTooltip(bu, 'ANCHOR_RIGHT', L['AUTOMATION_GET_NAKED'])

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

local lootDelay = 0
local function instantLoot()
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

function MISC:InstantLoot()
	if cfg.instant_loot then
		F:RegisterEvent('LOOT_READY', instantLoot)
	else
		F:UnregisterEvent('LOOT_READY', instantLoot)
	end
end

function MISC:BlockStrangerInvite()
	F:RegisterEvent('PARTY_INVITE_REQUEST', function(_, _, _, _, _, _, _, guid)
		if cfg.block_stranger_invite and not (C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or IsGuildMember(guid)) then
			DeclineGroup()
			StaticPopup_Hide('PARTY_INVITE')
		end
	end)
end


-- Fix Drag Collections taint
do
	local done
	local function setupMisc(event, addon)
		if event == 'ADDON_LOADED' and addon == 'Blizzard_Collections' then
			CollectionsJournal:HookScript('OnShow', function()
				if not done then
					if InCombatLockdown() then
						F:RegisterEvent('PLAYER_REGEN_ENABLED', setupMisc)
					else
						F.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			F:UnregisterEvent(event, setupMisc)
		elseif event == 'PLAYER_REGEN_ENABLED' then
			F.CreateMF(CollectionsJournal)
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

	-- https://www.townlong-yak.com/bugs/Mx7CWN-RefreshOverread
	if (UIDD_REFRESH_OVERREAD_PATCH_VERSION or 0) < 1 then
		UIDD_REFRESH_OVERREAD_PATCH_VERSION = 1
		local function drop(t, k)
			local c = 42
			t[k] = nil
			while not issecurevariable(t, k) do
				if t[c] == nil then
					t[c] = nil
				end
				c = c + 1
			end
		end
		hooksecurefunc('UIDropDownMenu_InitializeHelper', function()
			if UIDD_REFRESH_OVERREAD_PATCH_VERSION ~= 1 then
				return
			end
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local d = _G['DropDownList'..i]
				if d and d.numButtons then
					for j = d.numButtons+1, UIDROPDOWNMENU_MAXBUTTONS do
						local b, _ = _G['DropDownList'..i..'Button'..j]
						_ = issecurevariable(b, 'checked') or drop(b, 'checked')
						_ = issecurevariable(b, 'notCheckable') or drop(b, 'notCheckable')
					end
				end
			end
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

-- Fix blizz guild news hyperlink error
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


-- Fix Trade Skill Search
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
