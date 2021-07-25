local _G = _G
local unpack = unpack
local select = select
local C_ToyBox_GetToyInfo = C_ToyBox.GetToyInfo
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_Item_IsAnimaItemByID = C_Item.IsAnimaItemByID

local F, C = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')

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
    if not C.DB.Inventory.ItemFilter then
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
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterJunk then
        return
    end
    return (item.quality == _G.LE_ITEM_QUALITY_POOR or _G.FREE_ADB['CustomJunkList'][item.id]) and item.hasPrice and not INVENTORY:IsPetTrashCurrency(item.id)
end

local function isItemEquipSet(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterEquipSet then
        return
    end
    return item.isInSet
end

local function isAzeriteArmor(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterAzeriteArmor then
        return
    end
    if not item.link then
        return
    end
    return C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link)
end

local iLvlClassIDs = {
    [_G.LE_ITEM_CLASS_GEM] = _G.LE_ITEM_GEM_ARTIFACTRELIC,
    [_G.LE_ITEM_CLASS_ARMOR] = 0,
    [_G.LE_ITEM_CLASS_WEAPON] = 0
}

function INVENTORY:IsItemHasLevel(item)
    local index = iLvlClassIDs[item.classID]
    return index and (index == 0 or index == item.subClassID)
end

local function isItemEquipment(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterEquipment then
        return
    end
    return item.link and item.quality > _G.LE_ITEM_QUALITY_COMMON and INVENTORY:IsItemHasLevel(item)
end

local consumableIDs = {
    [_G.LE_ITEM_CLASS_CONSUMABLE] = true,
    [_G.LE_ITEM_CLASS_ITEM_ENHANCEMENT] = true
}

local function isItemConsumable(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterConsumable then
        return
    end
    if isCustomFilter(item) == false then
        return
    end
    return isCustomFilter(item) or consumableIDs[item.classID]
end

local function isItemLegendary(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterLegendary then
        return
    end
    return item.quality == _G.LE_ITEM_QUALITY_LEGENDARY
end

local isPetToy = {
    [174925] = true
}

local collectionIDs = {
    [_G.LE_ITEM_MISCELLANEOUS_MOUNT] = _G.LE_ITEM_CLASS_MISCELLANEOUS,
    [_G.LE_ITEM_MISCELLANEOUS_COMPANION_PET] = _G.LE_ITEM_CLASS_MISCELLANEOUS
}

local function isMountOrPet(item)
    return not isPetToy[item.id] and item.subClassID and collectionIDs[item.subClassID] == item.classID
end

local petTrashCurrenies = {
    [3300] = true,
    [3670] = true,
    [6150] = true,
    [11406] = true,
    [11944] = true,
    [25402] = true,
    [36812] = true,
    [62072] = true,
    [67410] = true
}

function INVENTORY:IsPetTrashCurrency(itemID)
    return petTrashCurrenies[itemID]
end

local function isItemCollection(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterCollection then
        return
    end
    return item.id and C_ToyBox_GetToyInfo(item.id) or isMountOrPet(item) or INVENTORY:IsPetTrashCurrency(item.id)
end

local function isItemFavourite(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterFavourite then
        return
    end
    return item.id and C.DB.Inventory.FavItemsList[item.id]
end

local function isEmptySlot(item)
    if not C.DB.Inventory.CombineFreeSlots then
        return
    end
    return INVENTORY.initComplete and not item.texture and INVENTORY.BagsType[item.bagID] == 0
end

local function isTradeGoods(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterTradeGoods then
        return
    end
    return item.classID == _G.LE_ITEM_CLASS_TRADEGOODS
end

local function isQuestItem(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterQuestItem then
        return
    end
    return item.questID or item.isQuestItem
    --return item.classID == LE_ITEM_CLASS_QUESTITEM
end

local function isAnimaItem(item)
    if not C.DB.Inventory.ItemFilter then
        return
    end
    if not C.DB.Inventory.FilterAnima then
        return
    end
    return item.id and C_Item_IsAnimaItemByID(item.id)
end

function INVENTORY:GetFilters()
    local filters = {}

    filters.onlyBags = function(item)
        return isItemInBag(item) and not isEmptySlot(item)
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
        return isItemInBank(item) and not isEmptySlot(item)
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
    filters.bagCollection = function(item)
        return isItemInBag(item) and isItemCollection(item)
    end
    filters.bankCollection = function(item)
        return isItemInBank(item) and isItemCollection(item)
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

    filters.bagAnima = function(item)
        return isItemInBag(item) and isAnimaItem(item)
    end
    filters.bankAnima = function(item)
        return isItemInBank(item) and isAnimaItem(item)
    end

    return filters
end
