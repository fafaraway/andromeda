local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local pairs = pairs
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

function MISC:ItemLevel_SetupLevel(unit, strType)
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

function MISC:ItemLevel_UpdateInspect(...)
	local guid = ...
	if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
		MISC:ItemLevel_SetupLevel(InspectFrame.unit, tarString)
	end
end

-- iLvl on flyout buttons
function MISC:ItemLevel_FlyoutUpdate(bag, slot, quality)
	if not self.iLvl then
		self.iLvl = F.CreateFS(self, 'pixel', '', nil, nil, true, 'BOTTOMRIGHT', 0, 2)
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
	self.iLvl:SetText(level)
	self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function MISC:ItemLevel_FlyoutSetup()
	local location = self.location
	if not location or location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
		if self.iLvl then self.iLvl:SetText('') end
		return
	end

	local _, _, bags, voidStorage, slot, bag = EquipmentManager_UnpackLocation(location)
	if voidStorage then return end
	local quality = select(13, EquipmentManager_GetItemInfoByLocation(location))
	if bags then
		MISC.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
	else
		MISC.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
	end
end

-- iLvl on scrapping machine
function MISC:ItemLevel_ScrappingUpdate()
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

function MISC.ItemLevel_ScrappingShow(event, addon)
	if addon == 'Blizzard_ScrappingMachineUI' then
		for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
			hooksecurefunc(button, 'RefreshIcon', MISC.ItemLevel_ScrappingUpdate)
		end

		F:UnregisterEvent(event, MISC.ItemLevel_ScrappingShow)
	end
end

function MISC:ShowItemLevel()
	if not C.general.itemLevel then return end

	hooksecurefunc('PaperDollItemSlotButton_OnShow', function()
		MISC:ItemLevel_SetupLevel('player', myString)
	end)

	hooksecurefunc('PaperDollItemSlotButton_OnEvent', function(self, event, id)
		if event == 'PLAYER_EQUIPMENT_CHANGED' and self:GetID() == id then
			MISC:ItemLevel_SetupLevel('player', myString)
		end
	end)

	F:RegisterEvent('INSPECT_READY', self.ItemLevel_UpdateInspect)
	hooksecurefunc('EquipmentFlyout_DisplayButton', self.ItemLevel_FlyoutSetup)
	F:RegisterEvent('ADDON_LOADED', self.ItemLevel_ScrappingShow)
end
