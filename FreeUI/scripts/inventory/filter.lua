local F, C, L = unpack(select(2, ...))
if not C.inventory.enable then return end
local cargBags = FreeUI.cargBags

local module = F:GetModule("Inventory")

-- Custom filter
local CustomFilterList = {
	[37863] = false,	-- 酒吧传送器
	[141333] = true,	-- 宁神圣典
	[141446] = true,	-- 宁神书卷
	[153646] = true,	-- 静心圣典
	[153647] = true,	-- 静心书卷
}

local function isCustomFilter(item)
	if not C.inventory.useCategory then return end
	return CustomFilterList[item.id]
end

-- Default filter
local function isItemInBag(item)
	return item.bagID >= 0 and item.bagID <= 4
end

local function isItemInBank(item)
	return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11
end

local function isItemJunk(item)
	if not C.inventory.useCategory then return end
	return item.rarity == LE_ITEM_QUALITY_POOR and item.sellPrice > 0
end

local function isAzeriteArmor(item)
	if not C.inventory.useCategory then return end
	if not item.link then return end
	return C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(item.link) and not (C.inventory.gearSetFilter and item.isInSet)
end

local function isItemEquipment(item)
	if not C.inventory.useCategory then return end
	if C.inventory.gearSetFilter then
		return item.isInSet
	else
		return item.level and item.rarity > LE_ITEM_QUALITY_COMMON and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or (item.equipLoc ~= "" and item.equipLoc ~= "INVTYPE_BAG"))
	end
end

local function isItemConsumble(item)
	if not C.inventory.useCategory then return end
	if isCustomFilter(item) == false then return end
	return isCustomFilter(item) or (item.classID and (item.classID == LE_ITEM_CLASS_CONSUMABLE or item.classID == LE_ITEM_CLASS_ITEM_ENHANCEMENT))
end

local function isItemLegendary(item)
	if not C.inventory.useCategory then return end
	return item.rarity == LE_ITEM_QUALITY_LEGENDARY
end

local function isItemTrade(item)
	if not C.inventory.useCategory then return end
	if not C.inventory.tradeGoodsFilter then return end
	return item.classID == LE_ITEM_CLASS_TRADEGOODS
end

local function isItemQuest(item)
	if not C.inventory.useCategory then return end
	if not C.inventory.questItemFilter then return end
	return item.classID == LE_ITEM_CLASS_QUESTITEM
end

function module:GetFilters()
	local onlyBags = function(item) return isItemInBag(item) and not isItemEquipment(item) and not isItemConsumble(item) and not isItemTrade(item) and not isItemQuest(item) and not isAzeriteArmor(item) and not isItemJunk(item) end
	local bagAzeriteItem = function(item) return isItemInBag(item) and isAzeriteArmor(item) end
	local bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
	local bagConsumble = function(item) return isItemInBag(item) and isItemConsumble(item) end
	local bagTradeGoods = function(item) return isItemInBag(item) and isItemTrade(item) end
	local bagQuestItem = function(item) return isItemInBag(item) and isItemQuest(item) end
	local bagsJunk = function(item) return isItemInBag(item) and isItemJunk(item) end
	local onlyBank = function(item) return isItemInBank(item) and not isItemEquipment(item) and not isItemConsumble(item) and not isAzeriteArmor(item) end
	local bankAzeriteItem = function(item) return isItemInBank(item) and isAzeriteArmor(item) end
	local bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
	local bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
	local bankConsumble = function(item) return isItemInBank(item) and isItemConsumble(item) end
	local onlyReagent = function(item) return item.bagID == -3 end

	return onlyBags, bagAzeriteItem, bagEquipment, bagConsumble, bagTradeGoods, bagQuestItem, bagsJunk, onlyBank, bankAzeriteItem, bankLegendary, bankEquipment, bankConsumble, onlyReagent
end
