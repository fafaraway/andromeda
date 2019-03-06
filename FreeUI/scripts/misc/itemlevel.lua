local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Misc')



function module:ItemLevel()
	local SLOTIDS = {}
	for _, slot in pairs({'Head', 'Neck', 'Shoulder', 'Shirt', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist', 'Hands', 'Finger0', 'Finger1', 'Trinket0', 'Trinket1', 'Back', 'MainHand', 'SecondaryHand'}) do
		SLOTIDS[slot] = GetInventorySlotInfo(slot..'Slot')
	end

	local myString = setmetatable({}, {
		__index = function(t, i)
			local gslot = _G['Character'..i..'Slot']
			if not gslot then return end
			local fstr = F.CreateFS(gslot, 'pixel', '', nil, nil, true, 'BOTTOMRIGHT', 0, 2)
			t[i] = fstr
			return fstr
		end
	})

	local tarString = setmetatable({}, {
		__index = function(t, i)
			local gslot = _G['Inspect'..i..'Slot']
			if not gslot then return end
			local fstr = F.CreateFS(gslot, 'pixel', '', nil, nil, true, 'BOTTOMRIGHT', 0, 2)
			t[i] = fstr
			return fstr
		end
	})

	local function SetupItemLevel(unit, strType)
		if not UnitExists(unit) then return end

		for slot, index in pairs(SLOTIDS) do
			local str = strType[slot]
			if not str then return end
			str:SetText('')

			local link = GetInventoryItemLink(unit, index)
			if link and index ~= 4 then
				local _, _, quality, level = GetItemInfo(link)
				level = F.GetItemLevel(link, unit, index) or level

				if level and level > 1 and quality then
					local color = BAG_ITEM_QUALITY_COLORS[quality]
					str:SetText(level)
					str:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end

	hooksecurefunc('PaperDollItemSlotButton_OnShow', function()
		SetupItemLevel('player', myString)
	end)

	hooksecurefunc('PaperDollItemSlotButton_OnEvent', function(self, event, id)
		if event == 'PLAYER_EQUIPMENT_CHANGED' and self:GetID() == id then
			SetupItemLevel('player', myString)
		end
	end)

	F:RegisterEvent('INSPECT_READY', function(_, ...)
		local guid = ...
		if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
			SetupItemLevel(InspectFrame.unit, tarString)
		end
	end)


	-- ilvl on scrapping machine
	local function updateMachineLevel(self)
		if not self.iLvl then
			self.iLvl = F.CreateFS(self, 'pixel', '', nil, nil, true, 'BOTTOMRIGHT', 0, 2)
		end
		if not self.itemLink then self.iLvl:SetText('') return end

		local quality = 1
		if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
			quality = self.item:GetItemQuality()
		end
		local level = F.GetItemLevel(self.itemLink)
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		self.iLvl:SetText(level)
		self.iLvl:SetTextColor(color.r, color.g, color.b)
	end

	local function itemLevelOnScrapping(event, addon)
		if addon == 'Blizzard_ScrappingMachineUI' then
			for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
				hooksecurefunc(button, 'RefreshIcon', updateMachineLevel)
			end

			F:UnregisterEvent(event, itemLevelOnScrapping)
		end
	end
	F:RegisterEvent('ADDON_LOADED', itemLevelOnScrapping)


	-- ilvl on flyout buttons
	local function SetupFlyoutLevel(button, bag, slot, quality)
		if not button.iLvl then
			button.iLvl = F.CreateFS(button, 'pixel', '', nil, nil, true, 'BOTTOMRIGHT', 0, 2)
		end
		local link, level
		if bag then
			link = GetContainerItemLink(bag, slot)
			level = F.GetItemLevel(link, bag, slot)
		else
			link = GetInventoryItemLink('player', slot)
			level = F.GetItemLevel(link, 'player', slot)
		end
		local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		button.iLvl:SetText(level)
		button.iLvl:SetTextColor(color.r, color.g, color.b)
	end

	hooksecurefunc('EquipmentFlyout_DisplayButton', function(button)
		local location = button.location
		if not location or location < 0 then return end
		if location == EQUIPMENTFLYOUT_PLACEINBAGS_LOCATION then
			if button.iLvl then button.iLvl:SetText('') end
			return
		end

		local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
		if voidStorage then return end
		local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
		if bags then
			SetupFlyoutLevel(button, bag, slot, quality)
		else
			SetupFlyoutLevel(button, nil, slot, quality)
		end
	end)


	-- ilvl on merchant
	local function MerchantItemlevel()
		local numItems = GetMerchantNumItems()

		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
			if index > numItems then return end

			local button = _G['MerchantItem'..i..'ItemButton']
			if button and button:IsShown() then
				if not button.text then
					button.text = button:CreateFontString(nil, 'OVERLAY', 'SystemFont_Outline_Small')
					button.text:SetPoint('TOPLEFT', 2, -2)
					button.text:SetTextColor(1, 1, 0)
					F.SetFS(button.text)
				else
					button.text:SetText('')
				end

				local itemLink = GetMerchantItemLink(index)
				if itemLink then
					local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = GetItemInfo(itemLink)
					--local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
					if (itemlevel and itemlevel > 1) and (quality and quality > 1) and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
						button.text:SetText(itemlevel)
						--button.text:SetTextColor(color.r, color.g, color.b)
					end
				end
			end
		end
	end
	hooksecurefunc('MerchantFrame_UpdateMerchantInfo', MerchantItemlevel)
end
