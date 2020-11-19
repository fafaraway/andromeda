local F, C = unpack(select(2, ...))
local INVENTORY = F:GetModule('INVENTORY')

local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_COMMON, LE_ITEM_QUALITY_LEGENDARY =
	LE_ITEM_QUALITY_POOR,
	LE_ITEM_QUALITY_COMMON,
	LE_ITEM_QUALITY_LEGENDARY
local LE_ITEM_CLASS_GEM, LE_ITEM_GEM_ARTIFACTRELIC = LE_ITEM_CLASS_GEM, LE_ITEM_GEM_ARTIFACTRELIC
local LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT =
	LE_ITEM_CLASS_CONSUMABLE,
	LE_ITEM_CLASS_ITEM_ENHANCEMENT
local LE_ITEM_CLASS_MISCELLANEOUS, LE_ITEM_MISCELLANEOUS_MOUNT, LE_ITEM_MISCELLANEOUS_COMPANION_PET =
	LE_ITEM_CLASS_MISCELLANEOUS,
	LE_ITEM_MISCELLANEOUS_MOUNT,
	LE_ITEM_MISCELLANEOUS_COMPANION_PET
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_TRADEGOODS =
	LE_ITEM_CLASS_WEAPON,
	LE_ITEM_CLASS_ARMOR,
	LE_ITEM_CLASS_TRADEGOODS
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID

-- Custom filter
local CustomFilterList = {
	[37863] = false, -- 酒吧传送器
	[141333] = true, -- 宁神圣典
	[141446] = true, -- 宁神书卷
	[153646] = true, -- 静心圣典
	[153647] = true, -- 静心书卷
	[161053] = true -- 水手咸饼干
}

local function isCustomFilter(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
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
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_junk'] then
		return
	end
	return (item.rarity == LE_ITEM_QUALITY_POOR or FREE_ADB['custom_junk_list'][item.id]) and item.sellPrice and
		item.sellPrice > 0
end

local function isItemEquipSet(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_gear_set'] then
		return
	end
	return item.isInSet
end

local function isAzeriteArmor(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_azerite'] then
		return
	end
	if not item.link then
		return
	end
	return C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link) and not isItemEquipSet(item)
end

function INVENTORY:IsArtifactRelic(item)
	return item.classID == LE_ITEM_CLASS_GEM and item.subClassID == LE_ITEM_GEM_ARTIFACTRELIC
end

local function isItemEquipment(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_equipment'] then
		return
	end
	return item.level and item.rarity > LE_ITEM_QUALITY_COMMON and
		(INVENTORY:IsArtifactRelic(item) or item.classID == LE_ITEM_CLASS_WEAPON or item.classID == LE_ITEM_CLASS_ARMOR) and
		not isItemEquipSet(item)
end

local function isItemConsumable(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_consumable'] then
		return
	end
	if isCustomFilter(item) == false then
		return
	end
	return isCustomFilter(item) or
		(item.classID and (item.classID == LE_ITEM_CLASS_CONSUMABLE or item.classID == LE_ITEM_CLASS_ITEM_ENHANCEMENT))
end

local function isItemLegendary(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_legendary'] then
		return
	end
	return item.rarity == LE_ITEM_QUALITY_LEGENDARY
end

local isPetToy = {
	[174925] = true
}

local function isMountAndPet(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_trade'] then
		return
	end
	return (not isPetToy[item.id]) and item.classID == LE_ITEM_CLASS_MISCELLANEOUS and
		(item.subClassID == LE_ITEM_MISCELLANEOUS_MOUNT or item.subClassID == LE_ITEM_MISCELLANEOUS_COMPANION_PET)
end

local function isItemFavourite(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_favourite'] then
		return
	end
	return item.id and C.DB['inventory']['favourite_items'][item.id]
end

local function isEmptySlot(item)
	if not C.DB['inventory']['combine_free_slots'] then
		return
	end
	return INVENTORY.initComplete and not item.texture and INVENTORY.BagsType[item.bagID] == 0
end

local function isTradeGoods(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_trade'] then
		return
	end
	return item.classID == LE_ITEM_CLASS_TRADEGOODS
end

local function isQuestItem(item)
	if not C.DB['inventory']['item_filter'] then
		return
	end
	if not C.DB['inventory']['item_filter_quest'] then
		return
	end
	--return item.isQuestItem
	return item.classID == LE_ITEM_CLASS_QUESTITEM
end

function INVENTORY:GetFilters()
	local filters = {}

	filters.onlyBags = function(item)
		return isItemInBag(item) and not isItemEquipment(item) and not isItemConsumable(item) and not isAzeriteArmor(item) and
			not isItemJunk(item) and
			not isMountAndPet(item) and
			not isItemFavourite(item) and
			not isEmptySlot(item) and
			not isTradeGoods(item) and
			not isItemEquipSet(item) and
			not isQuestItem(item)
	end
	filters.bagAzeriteItem = function(item)
		return isItemInBag(item) and isAzeriteArmor(item)
	end
	filters.bagEquipment = function(item)
		return isItemInBag(item) and isItemEquipment(item)
	end
	filters.bagEquipSet = function(item)
		return isItemInBag(item) and isItemEquipSet(item)
	end
	filters.bagConsumable = function(item)
		return isItemInBag(item) and isItemConsumable(item)
	end
	filters.bagsJunk = function(item)
		return isItemInBag(item) and isItemJunk(item)
	end
	filters.onlyBank = function(item)
		return isItemInBank(item) and not isItemEquipment(item) and not isItemLegendary(item) and not isItemConsumable(item) and
			not isAzeriteArmor(item) and
			not isMountAndPet(item) and
			not isItemFavourite(item) and
			not isEmptySlot(item) and
			not isTradeGoods(item) and
			not isItemEquipSet(item) and
			not isQuestItem(item)
	end
	filters.bankAzeriteItem = function(item)
		return isItemInBank(item) and isAzeriteArmor(item)
	end
	filters.bankLegendary = function(item)
		return isItemInBank(item) and isItemLegendary(item)
	end
	filters.bankEquipment = function(item)
		return isItemInBank(item) and isItemEquipment(item)
	end
	filters.bankEquipSet = function(item)
		return isItemInBank(item) and isItemEquipSet(item)
	end
	filters.bankConsumable = function(item)
		return isItemInBank(item) and isItemConsumable(item)
	end
	filters.onlyReagent = function(item)
		return item.bagID == -3 and not isEmptySlot(item)
	end
	filters.bagMountPet = function(item)
		return isItemInBag(item) and isMountAndPet(item)
	end
	filters.bankMountPet = function(item)
		return isItemInBank(item) and isMountAndPet(item)
	end
	filters.bagFavourite = function(item)
		return isItemInBag(item) and isItemFavourite(item)
	end
	filters.bankFavourite = function(item)
		return isItemInBank(item) and isItemFavourite(item)
	end
	filters.bagGoods = function(item)
		return isItemInBag(item) and isTradeGoods(item)
	end
	filters.bankGoods = function(item)
		return isItemInBank(item) and isTradeGoods(item)
	end
	filters.bagQuest = function(item)
		return isItemInBag(item) and isQuestItem(item)
	end
	filters.bankQuest = function(item)
		return isItemInBank(item) and isQuestItem(item)
	end

	return filters
end
