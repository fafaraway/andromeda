local _, ns = ...
local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("Bags")
local cargBags = ns.cargBags

function module:OnLogin()



	local Backpack = cargBags:NewImplementation("FreeUI_Backpack")
	Backpack:RegisterBlizzard()

	local f = {}
	function Backpack:OnInit()
		-- Item Filter
		local function isItemInBag(item)
			return item.bagID >= 0 and item.bagID <= 4
		end

		local function isItemInBank(item)
			return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11
		end

		local function isAzeriteArmor(item)
			--if not C.bags.itemFilter then return end
			if not item.link then return end
			return C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(item.link)
		end

		local function isItemEquipment(item)
			--if not C.bags.itemFilter then return end
			--if C.bags.setFilter then
			--	return item.isInSet
			--else
				return item.level and item.rarity > 1 and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or (item.equipLoc ~= "" and item.equipLoc ~= "INVTYPE_BAG"))
			--end
		end

		local function isItemConsumble(item)
			--if not C.bags.itemFilter then return end
			return item.type == AUCTION_CATEGORY_CONSUMABLES and item.rarity > LE_ITEM_QUALITY_POOR or item.type == AUCTION_CATEGORY_ITEM_ENHANCEMENT
		end

		local function isItemLegendary(item)
			--if not C.bags.itemFilter then return end
			return item.rarity == LE_ITEM_QUALITY_LEGENDARY
		end

		local onlyBags = function(item) return isItemInBag(item) and not isItemEquipment(item) and not isItemConsumble(item) end
		local bagAzeriteItem = function(item) return isItemInBag(item) and isAzeriteArmor(item) end
		local bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
		local bagConsumble = function(item) return isItemInBag(item) and isItemConsumble(item) end
		local onlyBank = function(item) return isItemInBank(item) and not isItemEquipment(item) and not isItemConsumble(item) end
		local bankAzeriteItem = function(item) return isItemInBank(item) and isAzeriteArmor(item) end
		local bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
		local bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
		local bankConsumble = function(item) return isItemInBank(item) and isItemConsumble(item) end
		local onlyReagent = function(item) return item.bagID == -3 end

		-- Backpack Init
		local MyContainer = self:GetContainerClass()

		f.main = MyContainer:New("Main", {Columns = C.bags.bagColumns, Bags = "bags"})
		f.main:SetFilter(onlyBags, true)
		f.main:SetPoint("BOTTOMRIGHT", -100, 150)

		f.azeriteItem = MyContainer:New("AzeriteItem", {Columns = C.bags.bagColumns, Bags = "azeriteitem"})
		f.azeriteItem:SetFilter(bagAzeriteItem, true)
		f.azeriteItem:SetParent(f.main)

		f.equipment = MyContainer:New("Equipment", {Columns = C.bags.bagColumns, Bags = "equipment"})
		f.equipment:SetFilter(bagEquipment, true)
		f.equipment:SetParent(f.main)

		f.consumble = MyContainer:New("Consumble", {Columns = C.bags.bagColumns, Bags = "consumble"})
		f.consumble:SetFilter(bagConsumble, true)
		f.consumble:SetParent(f.main)

		f.bank = MyContainer:New("Bank", {Columns = C.bags.bankColumns, Bags = "bank"})
		f.bank:SetFilter(onlyBank, true)
		f.bank:SetPoint("BOTTOMRIGHT", f.main, "BOTTOMLEFT", -20, 0)
		f.bank:Hide()

		f.reagent = MyContainer:New("Reagent", {Columns = C.bags.bankColumns, Bags = "bankreagent"})
		f.reagent:SetFilter(onlyReagent, true)
		f.reagent:SetPoint("BOTTOMLEFT", f.bank)
		f.reagent:Hide()

		f.bankAzeriteItem = MyContainer:New("BankAzeriteItem", {Columns = C.bags.bankColumns, Bags = "bankazeriteitem"})
		f.bankAzeriteItem:SetFilter(bankAzeriteItem, true)
		f.bankAzeriteItem:SetParent(f.bank)

		f.bankLegendary = MyContainer:New("BankLegendary", {Columns = C.bags.bankColumns, Bags = "banklegendary"})
		f.bankLegendary:SetFilter(bankLegendary, true)
		f.bankLegendary:SetParent(f.bank)

		f.bankEquipment = MyContainer:New("BankEquipment", {Columns = C.bags.bankColumns, Bags = "bankequipment"})
		f.bankEquipment:SetFilter(bankEquipment, true)
		f.bankEquipment:SetParent(f.bank)

		f.bankConsumble = MyContainer:New("BankConsumble", {Columns = C.bags.bankColumns, Bags = "bankconsumble"})
		f.bankConsumble:SetFilter(bankConsumble, true)
		f.bankConsumble:SetParent(f.bank)
	end

	function Backpack:OnBankOpened()
		BankFrame:Show()
		self:GetContainer("Bank"):Show()
	end

	function Backpack:OnBankClosed()
		BankFrame.selectedTab = 1
		BankFrame:Hide()
		self:GetContainer("Bank"):Hide()
		self:GetContainer("Reagent"):Hide()
		ReagentBankFrame:Hide()
	end

	local MyButton = Backpack:GetItemButtonClass()
	MyButton:Scaffold("Default")

	local iconSize = C.bags.itemSlotSize
	function MyButton:OnCreate()
		self:SetNormalTexture(nil)
		self:SetPushedTexture(nil)
		self:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
		self:SetSize(iconSize, iconSize)

		self.Icon:SetAllPoints()
		self.Icon:SetTexCoord(unpack(C.texCoord))
		self.Count:SetPoint("BOTTOMRIGHT", 1, 1)
		self.Count:SetFont(C.font.pixel, 8, "OUTLINEMONOCHROME")

		self.BG = F.CreateBDFrame(self)
		--self.BG:SetBackdrop({
		--	bgFile = DB.bdTex, edgeFile = DB.bdTex, edgeSize = 1,
		--})
		self.BG:SetBackdropColor(0, 0, 0, .3)
		self.BG:SetBackdropBorderColor(0, 0, 0)

		self.Junk = self:CreateTexture(nil, "ARTWORK")
		self.Junk:SetAtlas("bags-junkcoin")
		self.Junk:SetSize(20, 20)
		self.Junk:SetPoint("TOPRIGHT", 1, 0)

		self.Quest = F.CreatePFS(self, "!", false, "LEFT", 3, 0)
		self.Quest:SetTextColor(1, .8, 0)

		self.Azerite = self:CreateTexture(nil, "ARTWORK")
		self.Azerite:SetAtlas("AzeriteIconFrame")
		self.Azerite:SetAllPoints()

		if C.bags.artifact then
			self.Artifact = self:CreateTexture(nil, "ARTWORK")
			self.Artifact:SetAtlas("collections-icon-favorites")
			self.Artifact:SetSize(35, 35)
			self.Artifact:SetPoint("TOPLEFT", -12, 10)
		end

		if C.bags.iLvl then
			self.iLvl = F.CreatePFS(self, "", false, "BOTTOMLEFT", 1, 1)
		end

		local flash = self:CreateTexture(nil, "ARTWORK")
		flash:SetTexture(C.media.newItemFlash)
		flash:SetPoint("TOPLEFT", -20, 20)
		flash:SetPoint("BOTTOMRIGHT", 20, -20)
		flash:SetBlendMode("ADD")
		flash:SetAlpha(0)
		local anim = flash:CreateAnimationGroup()
		anim:SetLooping("REPEAT")
		anim.rota = anim:CreateAnimation("Rotation")
		anim.rota:SetDuration(1)
		anim.rota:SetDegrees(-90)
		anim.fader = anim:CreateAnimation("Alpha")
		anim.fader:SetFromAlpha(0)
		anim.fader:SetToAlpha(.5)
		anim.fader:SetDuration(.5)
		anim.fader:SetSmoothing("OUT")
		anim.fader2 = anim:CreateAnimation("Alpha")
		anim.fader2:SetStartDelay(.5)
		anim.fader2:SetFromAlpha(.5)
		anim.fader2:SetToAlpha(0)
		anim.fader2:SetDuration(1.2)
		anim.fader2:SetSmoothing("OUT")
		self:HookScript("OnHide", function() if anim:IsPlaying() then anim:Stop() end end)
		self.anim = anim

		self.ShowNewItems = true
	end

	local itemLevelString = _G["ITEM_LEVEL"]:gsub("%%d", "")
	local ItemDB = {}
	local function GetBagItemLevel(link, bag, slot)
		if ItemDB[link] then return ItemDB[link] end

		local tip = _G["FreeUIBagItemTooltip"] or CreateFrame("GameTooltip", "FreeUIBagItemTooltip", nil, "GameTooltipTemplate")
		tip:SetOwner(UIParent, "ANCHOR_NONE")
		tip:SetBagItem(bag, slot)

		for i = 2, 5 do
			local text = _G[tip:GetName().."TextLeft"..i]:GetText() or ""
			local hasLevel = string.find(text, itemLevelString)
			if hasLevel then
				local level = string.match(text, "(%d+)%)?$")
				ItemDB[link] = tonumber(level)
				break
			end
		end
		return ItemDB[link]
	end

	function MyButton:OnUpdate(item)
		if MerchantFrame:IsShown() and item.rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0 then
			self.Junk:SetAlpha(1)
		else
			self.Junk:SetAlpha(0)
		end

		if item.link and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(item.link) then
			self.Azerite:SetAlpha(1)
		else
			self.Azerite:SetAlpha(0)
		end

		if C.bags.artifact then
			if item.rarity == LE_ITEM_QUALITY_ARTIFACT or item.id == 138019 then
				self.Artifact:SetAlpha(1)
			else
				self.Artifact:SetAlpha(0)
			end
		end

		if C.bags.iLvl then
			if item.link and item.level and item.rarity > 1 and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or (item.equipLoc ~= "" and item.equipLoc ~= "INVTYPE_TABARD" and item.equipLoc ~= "INVTYPE_BODY" and item.equipLoc ~= "INVTYPE_BAG")) then
				local level = GetBagItemLevel(item.link, item.bagID, item.slotID) or item.level
				local color = BAG_ITEM_QUALITY_COLORS[item.rarity]
				self.iLvl:SetText(level)
				self.iLvl:SetTextColor(color.r, color.g, color.b)
			else
				self.iLvl:SetText("")
			end
		end
	end

	function MyButton:OnUpdateQuest(item)
		if item.questID and not item.questActive then
			self.Quest:SetAlpha(1)
		else
			self.Quest:SetAlpha(0)
		end

		if item.questID or item.isQuestItem then
			self.BG:SetBackdropBorderColor(.8, .8, 0)
		elseif item.rarity and item.rarity > 1 then
			local color = BAG_ITEM_QUALITY_COLORS[item.rarity]
			self.BG:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self.BG:SetBackdropBorderColor(0, 0, 0)
		end
	end

	local BagButton = Backpack:GetClass("BagButton", true, "BagButton")
	function BagButton:OnCreate()
		self:SetNormalTexture(nil)
		self:GetHighlightTexture():SetColorTexture(1, 1, 1, .3)
		self:SetPushedTexture(nil)
		self:SetCheckedTexture(C.media.abtex.pushed)
		self:GetCheckedTexture():SetVertexColor(.3, .9, .9, .5)

		self.Icon:SetPoint("TOPLEFT", 2, -2)
		self.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		self.Icon:SetTexCoord(unpack(C.texCoord))
	end

	local MyContainer = Backpack:GetContainerClass()
	function MyContainer:OnContentsChanged()
		self:SortButtons("bagSlot")

		local offset = -32
		if self.name == "Main" or self.name == "Bank" or self.name == "Reagent" then offset = -10 end

		local width, height = self:LayoutButtons("grid", self.Settings.Columns, 5, 10, offset)
		self:SetSize(width + 20, height + 45)

		local anchor = f.main
		for _, bag in ipairs({f.azeriteItem, f.equipment, f.consumble}) do
			if bag:GetHeight() > 45 then
				bag:Show()
			else
				bag:Hide()
			end
			if bag:IsShown() then
				bag:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, 3)
				anchor = bag
			end
		end

		local bankAnchor = f.bank
		for _, bag in ipairs({f.bankAzeriteItem, f.bankEquipment, f.bankLegendary, f.bankConsumble}) do
			if bag:GetHeight() > 45 then
				bag:Show()
			else
				bag:Hide()
			end
			if bag:IsShown() then
				bag:SetPoint("BOTTOMLEFT", bankAnchor, "TOPLEFT", 0, 3)
				bankAnchor = bag
			end
		end
	end

	local function ReverseSort()
		C_Timer.After(.5, function()
			for bag = 0, 4 do
				local numSlots = GetContainerNumSlots(bag)
				for slot = 1, numSlots do
					local texture, _, locked = GetContainerItemInfo(bag, slot)
					if texture and not locked then
						PickupContainerItem(bag, slot)
						PickupContainerItem(bag, numSlots+1 - slot)
					end
				end
			end
		end)
	end

	local function highlightFunction(button, match)
		button:SetAlpha(match and 1 or .3)
	end

	function MyContainer:OnCreate(name, settings)
		self.Settings = settings
		F.CreateBD(self)
		F.CreateSD(self)
		

		self:SetParent(settings.Parent or Backpack)
		self:SetFrameStrata("HIGH")
		self:SetClampedToScreen(true)

		if name == "Main" or name == "Bank" or name == "Reagent" then
			self:SetScale(C.bags.scale)
			F.CreateMF(self)
		elseif name:match("^Bank%a+") then
			F.CreateMF(self, f.bank)
		else
			F.CreateMF(self, f.main)
		end

		local label
		if name:match("AzeriteItem$") then
			label = "Azerite Armor"
		elseif name:match("Equipment$") then
			--if C.bags.setFilter then
			--	label = "Equipement Set"
			--else
				--label = BAG_FILTER_EQUIPMENT
				label = "equipment"
			--end
		elseif name == "BankLegendary" then
			--label = LOOT_JOURNAL_LEGENDARIES
			label = "legendary"
		elseif name:match("Consumble$") then
			--label = BAG_FILTER_CONSUMABLES
			label = "consumable"
		end
		if label then F.CreatePFS(self, label, true, "TOPLEFT", 8, -8) return end

		local infoFrame = CreateFrame("Button", nil, self)
		infoFrame:SetPoint("BOTTOMRIGHT", -50, 0)
		infoFrame:SetWidth(220)
		infoFrame:SetHeight(32)

		--[[local search = self:SpawnPlugin("SearchBar", infoFrame)
		search.highlightFunction = highlightFunction
		search.isGlobal = true
		search:SetPoint("LEFT", infoFrame, "LEFT", 0, 5)
		search.Left:SetTexture(nil)
		search.Right:SetTexture(nil)
		search.Center:SetTexture(nil)
		local sbg = CreateFrame("Frame", nil, search)
		sbg:SetPoint("CENTER", search, "CENTER")
		sbg:SetSize(230, 20)
		sbg:SetFrameLevel(search:GetFrameLevel() - 1)
		F.CreateBD(sbg)

		local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
		tagDisplay:SetFont(C.font.pixel, 8, "OUTLINEMONOCHROME")
		tagDisplay:SetPoint("RIGHT", infoFrame, "RIGHT",0,0)
		F.CreatePFS(infoFrame, "SEARCH", true, "LEFT", 0, 1)]]

		local SortButton = F.CreateButton(self, 60, 20, "Sort")
		SortButton:SetPoint("BOTTOMLEFT", 5, 7)
		SortButton:SetScript("OnClick", function()
			if name == "Bank" then
				SortBankBags()
			elseif name == "Reagent" then
				SortReagentBankBags()
			else
				if C.bags.reverseSort then
					if InCombatLockdown() then
						UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT)
					else
						SortBags()
						ReverseSort()
					end
				else
					SortBags()
				end
			end
		end)

		local closebutton = F.CreateButton(self, 20, 20, "X")
		closebutton:SetPoint("BOTTOMRIGHT", -5, 7)
		closebutton:SetScript("OnClick", CloseAllBags)

		if name == "Main" or name == "Bank" then
			local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
			bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
			bagBar:SetScale(.8)
			bagBar.highlightFunction = highlightFunction
			bagBar.isGlobal = true
			bagBar:Hide()
			self.BagBar = bagBar
			bagBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 8, -12)
			local bg = CreateFrame("Frame", nil, bagBar)
			bg:SetPoint("TOPLEFT", -10, 10)
			bg:SetPoint("BOTTOMRIGHT", -115, -10)
			F.CreateBD(bg)
			--F.CreateTex(bg)

			local bagToggle = F.CreateButton(self, 60, 20, "bags")
			bagToggle:SetPoint("LEFT", SortButton, "RIGHT", 6, 0)
			bagToggle:SetScript("OnClick", function()
				ToggleFrame(self.BagBar)
			end)

			if name == "Bank" then
				bg:SetPoint("TOPLEFT", -10, 10)
				bg:SetPoint("BOTTOMRIGHT", 10, -10)

				local switch = F.CreateButton(self, 70, 20, "reagent")
				switch:SetPoint("LEFT", bagToggle, "RIGHT", 6, 0)
				switch:RegisterForClicks("AnyUp")
				switch:SetScript("OnClick", function(_, btn)
					if not IsReagentBankUnlocked() then
						StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
					else
						PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
						ReagentBankFrame:Show()
						BankFrame.selectedTab = 2
						f.reagent:Show()
						f.bank:Hide()
						if btn == "RightButton" then DepositReagentBank() end
					end
				end)
			end
		elseif name == "Reagent" then
			local deposit = F.CreateButton(self, 100, 20, "deposit")
			deposit:SetPoint("LEFT", SortButton, "RIGHT", 6, 0)
			deposit:SetScript("OnClick", DepositReagentBank)

			local switch = F.CreateButton(self, 70, 20, "bank")
			switch:SetPoint("LEFT", deposit, "RIGHT", 6, 0)
			switch:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
				ReagentBankFrame:Hide()
				BankFrame.selectedTab = 1
				f.reagent:Hide()
				f.bank:Show()
			end)
		end

		-- Add Sound
		self:HookScript("OnShow", function() PlaySound(SOUNDKIT.IG_BACKPACK_OPEN) end)
		self:HookScript("OnHide", function() PlaySound(SOUNDKIT.IG_BACKPACK_CLOSE) end)
	end

	-- Fix Containter Bug
	local function getRightFix() return f.bank:GetRight() end
	BankFrame.GetRight = getRightFix

	-- Cleanup Bags Order
	SetSortBagsRightToLeft(not C.bags.reverseSort)
	SetInsertItemsLeftToRight(false)
end