local F, C, L = unpack(select(2, ...))
if not C.inventory.enable then return end
local cargBags = FreeUI.cargBags
local module = F:RegisterModule('Inventory')

local ipairs, strmatch, unpack = ipairs, string.match, unpack
local BAG_ITEM_QUALITY_COLORS, LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_ARTIFACT = BAG_ITEM_QUALITY_COLORS, LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_ARTIFACT
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC
local SortBankBags, SortReagentBankBags, SortBags = SortBankBags, SortReagentBankBags, SortBags
local GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem = GetContainerNumSlots, GetContainerItemInfo, PickupContainerItem
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID, C_NewItems_IsNewItem, C_Timer_After = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID, C_NewItems.IsNewItem, C_Timer.After

local sortCache = {}
function module:ReverseSort()
	for bag = 0, 4 do
		local numSlots = GetContainerNumSlots(bag)
		for slot = 1, numSlots do
			local texture, _, locked = GetContainerItemInfo(bag, slot)
			if (slot <= numSlots/2) and texture and not locked and not sortCache['b'..bag..'s'..slot] then
				PickupContainerItem(bag, slot)
				PickupContainerItem(bag, numSlots+1 - slot)
				sortCache['b'..bag..'s'..slot] = true
				C_Timer_After(.1, module.ReverseSort)
				return
			end
		end
	end

	FreeUI_Backpack.isSorting = false
	FreeUI_Backpack:BAG_UPDATE()
end

function module:UpdateAnchors(parent, bags)
	local anchor = parent
	for _, bag in ipairs(bags) do
		if bag:GetHeight() > 45 then
			bag:Show()
		else
			bag:Hide()
		end
		if bag:IsShown() then
			bag:SetPoint('BOTTOMLEFT', anchor, 'TOPLEFT', 0, 5)
			anchor = bag
		end
	end
end

function module:SetBackground()
	F.CreateBD(self)
	F.CreateSD(self)
end

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or .3)
end

local createIconButton = function (name, parent, texture, point)
	local button = CreateFrame('Button', nil, parent)
	button:SetWidth(17)
	button:SetHeight(17)

	F.CreateBD(button)
	
	button.icon = button:CreateTexture(nil, 'ARTWORK')
	button.icon:SetPoint(point, button, point, point == 'BOTTOMLEFT' and 2 or -2, 2)
	button.icon:SetWidth(16)
	button.icon:SetHeight(16)
	button.icon:SetTexture(texture)

	return button
end

function module:CreateInfoFrame()
	local infoFrame = CreateFrame('Button', nil, self)
	infoFrame:SetPoint('TOPLEFT', 10, 2)
	infoFrame:SetSize(140, 30)

	local searchIcon = self:CreateTexture(nil, 'ARTWORK')
	searchIcon:SetTexture('Interface\\AddOns\\FreeUI\\assets\\Search')
	searchIcon:SetVertexColor(.8, .8, .8)
	searchIcon:SetPoint('TOPLEFT', self, 'TOPLEFT', 6, -2)
	searchIcon:SetSize(16, 16)

	local search = self:SpawnPlugin('SearchBar', infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint('LEFT', 0, 5)
	search:DisableDrawLayer('BACKGROUND')
	local bg = F.CreateBDFrame(search, .8)
	bg:SetPoint('TOPLEFT', -5, -5)
	bg:SetPoint('BOTTOMRIGHT', 5, 5)
	if F then F.CreateGradient(bg) end

	local tag = self:SpawnPlugin('TagDisplay', '[money]  [currencies]', infoFrame)
	F.SetFS(tag)
	tag:SetPoint('LEFT', searchIcon, 'RIGHT', 6, 0)
end

function module:CreateBagBar(settings, columns)
	local bagBar = self:SpawnPlugin('BagBar', settings.Bags)
	local width, height = bagBar:LayoutButtons('grid', columns, 5, 5, -5)
	bagBar:SetSize(width + 10, height + 10)
	bagBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -5)
	module.SetBackground(bagBar)
	bagBar.highlightFunction = highlightFunction
	bagBar.isGlobal = true
	bagBar:Hide()

	self.BagBar = bagBar
end

function module:CreateCloseButton()
	local bu = F.CreateButton(self, 16, 16, true, '')
	bu:SetPoint('TOPRIGHT', -5, -5)
	bu:SetScript('OnClick', CloseAllBags)
	F.AddTooltip(bu, 'ANCHOR_TOP', CLOSE)
	F.ReskinClose(bu)

	return bu
end

function module:CreateRestoreButton(f)
	local bu = createIconButton('Restore', self, 'Interface\\AddOns\\FreeUI\\assets\\ResetNew', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', function()
		FreeUIConfig['tempAnchor'][f.main:GetName()] = nil
		FreeUIConfig['tempAnchor'][f.bank:GetName()] = nil
		FreeUIConfig['tempAnchor'][f.reagent:GetName()] = nil
		f.main:ClearAllPoints()
		f.main:SetPoint('BOTTOMRIGHT', -50, 50)
		f.bank:ClearAllPoints()
		f.bank:SetPoint('BOTTOMRIGHT', f.main, 'BOTTOMLEFT', -10, 0)
		f.reagent:ClearAllPoints()
		f.reagent:SetPoint('BOTTOMLEFT', f.bank)
		PlaySound(SOUNDKIT.IG_MINIMAP_OPEN)
	end)
	F.AddTooltip(bu, 'ANCHOR_TOP', RESET)

	return bu
end

function module:CreateReagentButton(f)
	local bu = createIconButton('Reagent', self, 'Interface\\AddOns\\FreeUI\\assets\\Config', 'BOTTOMRIGHT')
	bu:RegisterForClicks('AnyUp')
	bu:SetScript('OnClick', function(_, btn)
		if not IsReagentBankUnlocked() then
			StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
		else
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
			ReagentBankFrame:Show()
			BankFrame.selectedTab = 2
			f.reagent:Show()
			f.bank:Hide()
			if btn == 'RightButton' then DepositReagentBank() end
		end
	end)
	F.AddTooltip(bu, 'ANCHOR_TOP', REAGENT_BANK)

	return bu
end

function module:CreateBankButton(f)
	local bu = createIconButton('Bank', self, 'Interface\\AddOns\\FreeUI\\assets\\Config', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
		ReagentBankFrame:Hide()
		BankFrame.selectedTab = 1
		f.reagent:Hide()
		f.bank:Show()
	end)
	F.AddTooltip(bu, 'ANCHOR_TOP', BANK)

	return bu
end

function module:CreateDepositButton()
	local bu = createIconButton('Deposit', self, 'Interface\\AddOns\\FreeUI\\assets\\Deposit', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', DepositReagentBank)
	F.AddTooltip(bu, 'ANCHOR_TOP', REAGENTBANK_DEPOSIT)

	return bu
end

function module:CreateBagToggle()
	local bu = createIconButton('BagToggle', self, 'Interface\\AddOns\\FreeUI\\assets\\BagToggle', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', function()
		ToggleFrame(self.BagBar)
		if self.BagBar:IsShown() then
			bu:SetBackdropBorderColor(1, 1, 1)
			PlaySound(SOUNDKIT.IG_BACKPACK_OPEN)
		else
			bu:SetBackdropBorderColor(0, 0, 0)
			PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE)
		end
	end)
	F.AddTooltip(bu, 'ANCHOR_TOP', BACKPACK_TOOLTIP)

	return bu
end

function module:CreateSortButton(name)
	local bu = createIconButton('Sort', self, 'Interface\\AddOns\\FreeUI\\assets\\Restack', 'BOTTOMRIGHT')
	bu:SetScript('OnClick', function()
		if name == 'Bank' then
			SortBankBags()
		elseif name == 'Reagent' then
			SortReagentBankBags()
		else
			if C.inventory.reverseSort then
				if InCombatLockdown() then
					UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT)
				else
					SortBags()
					wipe(sortCache)
					FreeUI_Backpack.isSorting = true
					C_Timer_After(.5, module.ReverseSort)
				end
			else
				SortBags()
			end
		end
	end)
	F.AddTooltip(bu, 'ANCHOR_TOP', L['INVENTORY_SORT'])

	return bu
end

function module:OnLogin()
	local Backpack = cargBags:NewImplementation('FreeUI_Backpack')
	Backpack:RegisterBlizzard()
	Backpack:SetScale(C.inventory.bagScale)
	Backpack:HookScript('OnShow', function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end)
	Backpack:HookScript('OnHide', function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end)

	local f = {}
	local onlyBags, bagAzeriteItem, bagEquipment, bagConsumble, bagTradeGoods, bagQuestItem, bagsJunk, onlyBank, bankAzeriteItem, bankLegendary, bankEquipment, bankConsumble, onlyReagent, bagMountPet, bankMountPet = self:GetFilters()

	function Backpack:OnInit()
		local MyContainer = self:GetContainerClass()

		f.main = MyContainer:New('Main', {Columns = C.inventory.bagColumns, Bags = 'bags'})
		f.main:SetFilter(onlyBags, true)
		f.main:SetPoint('BOTTOMRIGHT', -50, 50)

		f.junk = MyContainer:New('Junk', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.junk:SetFilter(bagsJunk, true)

		f.azeriteItem = MyContainer:New('AzeriteItem', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.azeriteItem:SetFilter(bagAzeriteItem, true)

		f.equipment = MyContainer:New('Equipment', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.equipment:SetFilter(bagEquipment, true)

		f.consumble = MyContainer:New('Consumble', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.consumble:SetFilter(bagConsumble, true)

		f.bagCompanion = MyContainer:New('BagCompanion', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.bagCompanion:SetFilter(bagMountPet, true)

		f.tradegoods = MyContainer:New('TradeGoods', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.tradegoods:SetFilter(bagTradeGoods, true)

		f.questitem = MyContainer:New('QuestItem', {Columns = C.inventory.bagColumns, Parent = f.main})
		f.questitem:SetFilter(bagQuestItem, true)

		f.bank = MyContainer:New('Bank', {Columns = C.inventory.bankColumns, Bags = 'bank'})
		f.bank:SetFilter(onlyBank, true)
		f.bank:SetPoint('BOTTOMRIGHT', f.main, 'BOTTOMLEFT', -10, 0)
		f.bank:Hide()

		f.bankAzeriteItem = MyContainer:New('BankAzeriteItem', {Columns = C.inventory.bankColumns, Parent = f.bank})
		f.bankAzeriteItem:SetFilter(bankAzeriteItem, true)

		f.bankLegendary = MyContainer:New('BankLegendary', {Columns = C.inventory.bankColumns, Parent = f.bank})
		f.bankLegendary:SetFilter(bankLegendary, true)

		f.bankEquipment = MyContainer:New('BankEquipment', {Columns = C.inventory.bankColumns, Parent = f.bank})
		f.bankEquipment:SetFilter(bankEquipment, true)

		f.bankConsumble = MyContainer:New('BankConsumble', {Columns = C.inventory.bankColumns, Parent = f.bank})
		f.bankConsumble:SetFilter(bankConsumble, true)

		f.bankCompanion = MyContainer:New('BankCompanion', {Columns = C.inventory.bankColumns, Parent = f.bank})
		f.bankCompanion:SetFilter(bankMountPet, true)

		f.reagent = MyContainer:New('Reagent', {Columns = C.inventory.bankColumns})
		f.reagent:SetFilter(onlyReagent, true)
		f.reagent:SetPoint('BOTTOMLEFT', f.bank)
		f.reagent:Hide()
	end

	function Backpack:OnBankOpened()
		BankFrame:Show()
		self:GetContainer('Bank'):Show()
	end

	function Backpack:OnBankClosed()
		BankFrame.selectedTab = 1
		BankFrame:Hide()
		self:GetContainer('Bank'):Hide()
		self:GetContainer('Reagent'):Hide()
		ReagentBankFrame:Hide()
	end

	local MyButton = Backpack:GetItemButtonClass()
	MyButton:Scaffold('Default')

	local iconSize = C.inventory.itemSlotSize
	function MyButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetPushedTexture(nil)
		self:SetHighlightTexture(C.media.backdrop)
		self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
		self:SetSize(iconSize, iconSize)

		self.Icon:SetAllPoints()
		self.Icon:SetTexCoord(unpack(C.TexCoord))
		self.Count:SetPoint('BOTTOMRIGHT', 2, 2)
		F.SetFS(self.Count)

		self.BG = F.CreateBG(self)
		self.BG:SetVertexColor(0, 0, 0, .5)

		--[[self.junkIcon = self:CreateTexture(nil, 'ARTWORK')
		self.junkIcon:SetAtlas('bags-junkcoin')
		self.junkIcon:SetSize(20, 20)
		self.junkIcon:SetPoint('TOPRIGHT', 1, 0)]]

		self.Quest = self:CreateFontString(nil, 'OVERLAY')
		F.SetFS(self.Quest)
		self.Quest:SetText('!')
		self.Quest:SetPoint('TOPLEFT', 2, -2)

		self.Azerite = self:CreateTexture(nil, 'ARTWORK')
		self.Azerite:SetAtlas('AzeriteIconFrame')
		self.Azerite:SetAllPoints()

		if C.inventory.itemLevel then
			self.iLvl = F.CreateFS(self, 'pixel', '', nil, nil, true, 'BOTTOMRIGHT', 2, 2)
		end

		local flash = self:CreateTexture(nil, 'ARTWORK')
		flash:SetTexture(C.media.flashTex)
		flash:SetPoint('TOPLEFT', -20, 20)
		flash:SetPoint('BOTTOMRIGHT', 20, -20)
		flash:SetBlendMode('ADD')
		flash:SetAlpha(0)
		local anim = flash:CreateAnimationGroup()
		anim:SetLooping('REPEAT')
		anim.rota = anim:CreateAnimation('Rotation')
		anim.rota:SetDuration(1)
		anim.rota:SetDegrees(-90)
		anim.fader = anim:CreateAnimation('Alpha')
		anim.fader:SetFromAlpha(0)
		anim.fader:SetToAlpha(.5)
		anim.fader:SetDuration(.5)
		anim.fader:SetSmoothing('OUT')
		anim.fader2 = anim:CreateAnimation('Alpha')
		anim.fader2:SetStartDelay(.5)
		anim.fader2:SetFromAlpha(.5)
		anim.fader2:SetToAlpha(0)
		anim.fader2:SetDuration(1.2)
		anim.fader2:SetSmoothing('OUT')
		self:HookScript('OnHide', function() if anim:IsPlaying() then anim:Stop() end end)
		self.anim = anim

		self.ShowNewItems = true
	end

	function MyButton:ItemOnEnter()
		if self.ShowNewItems then
			if self.anim:IsPlaying() then self.anim:Stop() end
		end
	end

	function MyButton:OnUpdate(item)
		if MerchantFrame:IsShown() then
			if item.isInSet then
				self:SetAlpha(.5)
			else
				self:SetAlpha(1)
			end
		end
		
		--[[if MerchantFrame:IsShown() and item.rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0 then
			self.junkIcon:SetAlpha(1)
		else
			self.junkIcon:SetAlpha(0)
		end]]

		if item.link and C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link) then
			self.Azerite:SetAlpha(1)
		else
			self.Azerite:SetAlpha(0)
		end

		if C.inventory.itemLevel then
			if item.link and item.level and item.rarity > 1 and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or item.classID == LE_ITEM_CLASS_WEAPON or item.classID == LE_ITEM_CLASS_ARMOR) then
				local level = F.GetItemLevel(item.link, item.bagID, item.slotID) or item.level
				local color = BAG_ITEM_QUALITY_COLORS[item.rarity]
				self.iLvl:SetText(level)
				self.iLvl:SetTextColor(color.r, color.g, color.b)
			else
				self.iLvl:SetText('')
			end
		end

		if self.ShowNewItems then
			if C_NewItems_IsNewItem(item.bagID, item.slotID) then
				self.anim:Play()
			else
				if self.anim:IsPlaying() then self.anim:Stop() end
			end
		end
	end

	function MyButton:OnUpdateQuest(item)
		--if item.questID and not item.questActive then
		if item.questID then
			self.Quest:SetAlpha(1)
			self.Quest:SetTextColor(.8, .8, 0, 1)
		else
			self.Quest:SetAlpha(0)
		end

		if item.questID or item.isQuestItem then
			self.BG:SetVertexColor(.8, .8, 0)
		elseif item.rarity and item.rarity > -1 then
			local color = BAG_ITEM_QUALITY_COLORS[item.rarity]
			self.BG:SetVertexColor(color.r, color.g, color.b, 1)
		else
			self.BG:SetVertexColor(0, 0, 0, .2)
		end
	end

	local MyContainer = Backpack:GetContainerClass()
	function MyContainer:OnContentsChanged()
		self:SortButtons('bagSlot')

		local offset = 30
		local width, height = self:LayoutButtons('grid', self.Settings.Columns, 5, 5, -offset + 5)
		self:SetSize(width + 10, height + offset)

		module:UpdateAnchors(f.main, {f.azeriteItem, f.equipment, f.consumble, f.bagCompanion, f.tradegoods, f.questitem, f.junk})
		module:UpdateAnchors(f.bank, {f.bankAzeriteItem, f.bankEquipment, f.bankLegendary, f.bankCompanion, f.bankConsumble})
	end

	function MyContainer:OnCreate(name, settings)
		self.Settings = settings
		self:SetParent(settings.Parent or Backpack)
		self:SetFrameStrata('HIGH')
		self:SetClampedToScreen(true)
		module.SetBackground(self)
		F.CreateMF(self, settings.Parent, true)

		local label
		if strmatch(name, 'AzeriteItem$') then
			label = L['INVENTORY_AZERITEARMOR']
		elseif strmatch(name, 'Equipment$') then
			if C.inventory.gearSetFilter then
				label = L['INVENTORY_EQUIPEMENTSET']
			else
				label = BAG_FILTER_EQUIPMENT
			end
		elseif name == 'BankLegendary' then
			label = LOOT_JOURNAL_LEGENDARIES
		elseif strmatch(name, 'Consumble$') then
			label = BAG_FILTER_CONSUMABLES
		elseif strmatch(name, 'TradeGoods$') then
			label = BAG_FILTER_TRADE_GOODS
		elseif strmatch(name, 'QuestItem$') then
			label = AUCTION_CATEGORY_QUEST_ITEMS
		elseif name == 'Junk' then
			label = BAG_FILTER_JUNK
		elseif strmatch(name, 'Companion') then
			label = MOUNTS_AND_PETS
		end
		if label then
			self.cat = self:CreateFontString(nil, 'OVERLAY')
			self.cat:SetFont(C.font.normal, 11, 'OUTLINE')
			self.cat:SetText(label)
			self.cat:SetPoint('TOPLEFT', 5, -4)
			return
		end

		module.CreateInfoFrame(self)

		local buttons = {}
		buttons[1] = module.CreateCloseButton(self)
		if name == 'Main' then
			module.CreateBagBar(self, settings, 4)
			buttons[2] = module.CreateRestoreButton(self, f)
			buttons[3] = module.CreateBagToggle(self)
		elseif name == 'Bank' then
			module.CreateBagBar(self, settings, 7)
			buttons[2] = module.CreateReagentButton(self, f)
			buttons[3] = module.CreateBagToggle(self)
		elseif name == 'Reagent' then
			buttons[2] = module.CreateBankButton(self, f)
			buttons[3] = module.CreateDepositButton(self)
		end
		buttons[4] = module.CreateSortButton(self, name)

		for i = 1, 4 do
			local bu = buttons[i]
			if i == 1 then
				bu:SetPoint('TOPRIGHT', -5, -2)
			else
				bu:SetPoint('RIGHT', buttons[i-1], 'LEFT', -3, 0)
			end
		end

		self:HookScript('OnShow', F.RestoreMF)
	end

	local BagButton = Backpack:GetClass('BagButton', true, 'BagButton')
	function BagButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetPushedTexture(nil)
		self:SetHighlightTexture(C.media.backdrop)
		self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)

		self:SetSize(iconSize, iconSize)

		self.BG = F.CreateBG(self)

		self.Icon:SetAllPoints()
		self.Icon:SetTexCoord(unpack(C.TexCoord))
	end

	function BagButton:OnUpdate()
		local id = GetInventoryItemID('player', (self.GetInventorySlot and self:GetInventorySlot()) or self.invID)
		local quality = id and select(3, GetItemInfo(id)) or 0
		if quality == 1 then quality = 0 end
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		if not self.hidden and not self.notBought then
			self.BG:SetVertexColor(color.r, color.g, color.b)
		else
			self.BG:SetVertexColor(0, 0, 0)
		end
	end

	-- Fixes
	ToggleAllBags()
	ToggleAllBags()
	BankFrame.GetRight = function() return f.bank:GetRight() end
	BankFrameItemButton_Update = F.Dummy

	SetSortBagsRightToLeft(not C.inventory.reverseSort)
	SetInsertItemsLeftToRight(false)
end