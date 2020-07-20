local F, C, L = unpack(select(2, ...))
local AUTOMATION, cfg = F:GetModule('Automation'), C.Automation


local AUTOMATION_LIST = {}

function AUTOMATION:RegisterAutomation(name, func)
	if not AUTOMATION_LIST[name] then
		AUTOMATION_LIST[name] = func
	end
end

function AUTOMATION:EasyDelete()
	hooksecurefunc(StaticPopupDialogs['DELETE_GOOD_ITEM'], 'OnShow', function(self)
		if cfg.easy_delete then
			self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
		end
	end)
end

local menuFrame = CreateFrame('Frame', nil, UIParent, 'UIDropDownMenuTemplate')
local menuList = {
	{text = L['AUTOMATION_MARK_CLEAR'], func = function() SetRaidTarget('target', 0) end},
	{text = L['AUTOMATION_MARK_SKULL'], func = function() SetRaidTarget('target', 8) end},
	{text = '|cffff0000'..L['AUTOMATION_MARK_CROSS'], func = function() SetRaidTarget('target', 7) end},
	{text = '|cff00ffff'..L['AUTOMATION_MARK_SQUARE'], func = function() SetRaidTarget('target', 6) end},
	{text = '|cffC7C7C7'..L['AUTOMATION_MARK_MOON'], func = function() SetRaidTarget('target', 5) end},
	{text = '|cff00ff00'..L['AUTOMATION_MARK_TRIANGLE'], func = function() SetRaidTarget('target', 4) end},
	{text = '|cff912CEE'..L['AUTOMATION_MARK_DIAMOND'], func = function() SetRaidTarget('target', 3) end},
	{text = '|cffFF8000'..L['AUTOMATION_MARK_CIRCLE'], func = function() SetRaidTarget('target', 2) end},
	{text = '|cffffff00'..L['AUTOMATION_MARK_STAR'], func = function() SetRaidTarget('target', 1) end},
}
	
function AUTOMATION:EasyMark()
	if not cfg.easy_mark then return end

	WorldFrame:HookScript('OnMouseDown', function(self, button)
		if button == 'LeftButton' and IsAltKeyDown() and UnitExists('mouseover') then
			local inRaid = IsInRaid()
			if (inRaid and (UnitIsGroupLeader('player') or UnitIsGroupAssistant('player'))) or not inRaid then
				EasyMenu(menuList, menuFrame, 'cursor', 0, 0, 'MENU', 1)
			end
		end
	end)
end

local function autoScreenshot()
	AUTOMATION.ScreenShotFrame.delay = 1
	AUTOMATION.ScreenShotFrame:Show()
end

function AUTOMATION:AutoScreenshot()
	if not AUTOMATION.ScreenShotFrame then
		AUTOMATION.ScreenShotFrame = CreateFrame('Frame')
		AUTOMATION.ScreenShotFrame:Hide()
		AUTOMATION.ScreenShotFrame:SetScript('OnUpdate', function(self, elapsed)
			self.delay = self.delay - elapsed
			if self.delay < 0 then
				Screenshot()
				self:Hide()
			end
		end)
	end

	if cfg.auto_screenshot then
		F:RegisterEvent('ACHIEVEMENT_EARNED', autoScreenshot)
		F:RegisterEvent('CHALLENGE_MODE_COMPLETED', autoScreenshot)
		-- F:RegisterEvent('UPDATE_BATTLEFIELD_STATUS', autoScreenshot)
	else
		AUTOMATION.ScreenShotFrame:Hide()
		F:UnregisterEvent('ACHIEVEMENT_EARNED', autoScreenshot)
		F:UnregisterEvent('CHALLENGE_MODE_COMPLETED', autoScreenshot)
		-- F:UnregisterEvent('UPDATE_BATTLEFIELD_STATUS', autoScreenshot)
	end
end

function AUTOMATION:EasyNaked()
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

function AUTOMATION:EasyBuyStack()
	if not cfg.easy_buy_stack then return end

	local cache = {}
	local itemLink, id

	StaticPopupDialogs['BUY_STACK'] = {
		text = L['AUTOMATION_BUY_STACK'],
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

function AUTOMATION:AutoRejectStranger()
	F:RegisterEvent('PARTY_INVITE_REQUEST', function(_, _, _, _, _, _, _, guid)
		if cfg.auto_reject_stranger and not (C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or IsGuildMember(guid)) then
			DeclineGroup()
			StaticPopup_Hide('PARTY_INVITE')
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

function AUTOMATION:InstantLoot()
	if cfg.instant_loot then
		F:RegisterEvent('LOOT_READY', instantLoot)
	else
		F:UnregisterEvent('LOOT_READY', instantLoot)
	end
end

local function updateChatBubble()
	local name, instType = GetInstanceInfo()
	if name and (instType == "raid" or instType == "party" or instType == "scenario" or instType == "pvp" or instType == "arena") then
		SetCVar("chatBubbles", 1)
	else
		SetCVar("chatBubbles", 0)
	end
end

function AUTOMATION:AutoToggleBubble()
	if cfg.auto_toggle_chat_bubble then
		F:RegisterEvent("PLAYER_ENTERING_WORLD", updateChatBubble)
	else
		F:UnregisterEvent("PLAYER_ENTERING_WORLD", updateChatBubble)
	end
end



function AUTOMATION:OnLogin()
	if not cfg.enable then return end
	
	for name, func in next, AUTOMATION_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end

	self:EasyDelete()
	self:EasyNaked()
	self:EasyBuyStack()
	self:EasyMark()
	self:AutoScreenshot()
	self:AutoRejectStranger()
	self:AutoToggleBubble()
	self:InstantLoot()
end