local F, C, L = unpack(select(2, ...))
local INVENTORY = F:GetModule("Inventory")

local LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_COMMON, LE_ITEM_QUALITY_LEGENDARY = LE_ITEM_QUALITY_POOR, LE_ITEM_QUALITY_COMMON, LE_ITEM_QUALITY_LEGENDARY
local LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT, EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC = LE_ITEM_CLASS_CONSUMABLE, LE_ITEM_CLASS_ITEM_ENHANCEMENT, EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC
local LE_ITEM_CLASS_MISCELLANEOUS, LE_ITEM_MISCELLANEOUS_MOUNT, LE_ITEM_MISCELLANEOUS_COMPANION_PET = LE_ITEM_CLASS_MISCELLANEOUS, LE_ITEM_MISCELLANEOUS_MOUNT, LE_ITEM_MISCELLANEOUS_COMPANION_PET
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID

-- Custom filter
local CustomFilterList = {
	[37863] = false,	-- 酒吧传送器
	[141333] = true,	-- 宁神圣典
	[141446] = true,	-- 宁神书卷
	[153646] = true,	-- 静心圣典
	[153647] = true,	-- 静心书卷
	[161053] = true,	-- 水手咸饼干
}

local function isCustomFilter(item)
	if not C.inventory.useCategory then return end
	return CustomFilterList[item.id]
end

local MechagonFilterList = {
	--Parts
	[166846] = true,	-- Spare Parts
	[166970] = true,	-- Energy Cell
	[166971] = true,	-- Empty Energy Cell
	[167562] = true,	-- Ionized Minnow
	[168215] = true,	-- Machined Gear Assembly
	[168216] = true,	-- Tempered Plating
	[168217] = true,	-- Hardened Spring
	[168262] = true,	-- Sentry Fish
	[168327] = true,	-- Chain Ignitercoil
	[168832] = true,	-- Galvanic Oscillator
	[168946] = true,	-- Bundle of Recyclable Parts
	[169610] = true,	-- S.P.A.R.E. Crate
	-- Boxes
	[167744] = true,	-- Aspirant's Equipment Cache
	[168264] = true,	-- Recycling Requisition
	[168266] = true,	-- Strange Recycling Requisition
	[169471] = true,	-- Cogfrenzy's Construction Toolkit
	[169838] = true,	-- Azeroth Mini: Starter Pack
	[170061] = true,	-- Rustbolt Supplies
	[298140] = true,	-- Rustbolt Requisitions
	-- Blueprints
	[167042] = true,	-- Blueprint: Scrap Trap
	[167652] = true,	-- Blueprint: Hundred-Fathom Lure
	[167787] = true,	-- Blueprint: Mechanocat Laser Pointer
	[167836] = true,	-- Blueprint: Canned Minnows
	[167843] = true,	-- Blueprint: Vaultbot Key
	[167844] = true,	-- Blueprint: Emergency Repair Kit
	[167845] = true,	-- Blueprint: Emergency Powerpack
	[167846] = true,	-- Blueprint: Mechano-Treat
	[167847] = true,	-- Blueprint: Ultrasafe Transporter: Mechagon
	[167871] = true,	-- Blueprint: G99.99 Landshark
	[168062] = true,	-- Blueprint: Rustbolt Gramophone
	[168063] = true,	-- Blueprint: Rustbolt Kegerator
	[168219] = true,	-- Blueprint: Beastbot Powerpack
	[168220] = true,	-- Blueprint: Re-Procedurally Generated Punchcard
	[168248] = true,	-- Blueprint: BAWLD-371
	[168490] = true,	-- Blueprint: Protocol Transference Device
	[168491] = true,	-- Blueprint: Personal Time Displacer
	[168492] = true,	-- Blueprint: Emergency Rocket Chicken
	[168493] = true,	-- Blueprint: Battle Box
	[168494] = true,	-- Blueprint: Rustbolt Resistance Insignia
	[168495] = true,	-- Blueprint: Rustbolt Requisitions
	[168906] = true,	-- Blueprint: Holographic Digitalization Relay
	[168908] = true,	-- Blueprint: Experimental Adventurer Augment
	[169112] = true,	-- Blueprint: Advanced Adventurer Augment
	[169134] = true,	-- Blueprint: Extraodinary Adventurer Augment
	[169167] = true,	-- Blueprint: Orange Spraybot
	[169168] = true,	-- Blueprint: Green Spraybot
	[169169] = true,	-- Blueprint: Blue Spraybot
	[169170] = true,	-- Blueprint: Utility Mechanoclaw
	[169171] = true,	-- Blueprint: Microbot XD
	[169172] = true,	-- Blueprint: Perfectly Timed Differential
	[169173] = true,	-- Blueprint: Anti-Gravity Pack
	[169174] = true,	-- Blueprint: Rustbolt Pocket Turret
	[169175] = true,	-- Blueprint: Annoy-o-Tron Gang
	[169176] = true,	-- Blueprint: Encrypted Black Market Radio
	[169190] = true,	-- Blueprint: Mega-Sized Spare Parts
	-- Paint
	[167796] = true,	-- Paint Vial: Mechagon Gold
	[167790] = true,	-- Paint Vial: Fireball Red
	[167791] = true,	-- Paint Vial: Battletorn Blue
	[167792] = true,	-- Paint Vial: Fel Mint Green
	[167793] = true,	-- Paint Vial: Overload Orange
	[167794] = true,	-- Paint Vial: Lemonade Steel
	[167795] = true,	-- Paint Vial: Copper Trim
	[168001] = true,	-- Paint Vial: Big-ol Bronze
	[170146] = true,	-- Paint Bottle: Nukular Red
	[170147] = true,	-- Paint Bottle: Goblin Green
	[170148] = true,	-- Paint Bottle: Electric Blue
	-- Azeroth Mini
	[169794] = true,	-- Azeroth Mini: Izira Gearsworn
	[169795] = true,	-- Azeroth Mini: Bondo Bigblock
	[169796] = true,	-- Azeroth Mini Collection: Mechagon
	[169797] = true,	-- Azeroth Mini: Wrenchbot
	[169840] = true,	-- Azeroth Mini: Gazlowe
	[169841] = true,	-- Azeroth Mini: Erazmin
	[169842] = true,	-- Azeroth Mini: Roadtrogg
	[169843] = true,	-- Azeroth Mini: Cork Stuttguard
	[169844] = true,	-- Azeroth Mini: Overspark
	[169845] = true,	-- Azeroth Mini: HK-8
	[169846] = true,	-- Azeroth Mini: King Mechagon
	[169849] = true,	-- Azeroth Mini: Naeno Megacrash
	[169851] = true,	-- Azeroth Mini: Cogstar
	[169852] = true,	-- Azeroth Mini: Blastatron
	[169876] = true,	-- Azeroth Mini: Sapphronetta
	[169895] = true,	-- Azeroth Mini: Beastbot
	[169896] = true,	-- Azeroth Mini: Pascal-K1N6
	-- Misc
	[168497] = true,	-- Rustbolt Resistance Insignia
	[169107] = true,	-- T.A.R.G.E.T. Device
	[169688] = true,	-- Vinyl: Gnomeregan Forever
	[169689] = true,	-- Vinyl: Mimiron's Brainstorm
	[169690] = true,	-- Vinyl: Battle of Gnomeregan
	[169691] = true,	-- Vinyl: Depths of Ulduar
	[169692] = true,	-- Vinyl: Triumph of Gnomeregan
	[169470] = true,	-- Pressure Relief Valve
	[166973] = true,	-- Emergency Repair Kit
	[167075] = true,	-- Ultrasafe Transporter: Mechagon
}

local function isMechagonFilter(item)
	if not C.inventory.useCategory then return end
	return MechagonFilterList[item.id]
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
	return C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link) and not (C.inventory.gearSetFilter and item.isInSet)
end

local function isItemEquipment(item)
	if not C.inventory.useCategory then return end
	if C.inventory.gearSetFilter then
		return item.isInSet
	else
		return item.level and item.rarity > LE_ITEM_QUALITY_COMMON and (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or item.classID == LE_ITEM_CLASS_WEAPON or item.classID == LE_ITEM_CLASS_ARMOR)
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

local function isMountAndPet(item)
	if not C.inventory.useCategory then return end
	return item.classID == LE_ITEM_CLASS_MISCELLANEOUS and (item.subClassID == LE_ITEM_MISCELLANEOUS_MOUNT or item.subClassID == LE_ITEM_MISCELLANEOUS_COMPANION_PET)
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

local function isItemMechagon(item)
	if not C.inventory.useCategory then return end
	if not C.inventory.mechagonItemFilter then return end
	return isMechagonFilter(item)
end

function INVENTORY:GetFilters()
	local onlyBags = function(item) return isItemInBag(item) and not isItemEquipment(item) and not isItemConsumble(item) and not isItemTrade(item) and not isItemQuest(item) and not isAzeriteArmor(item) and not isItemJunk(item) and not isMountAndPet(item) and not isItemMechagon(item) end
	local bagAzeriteItem = function(item) return isItemInBag(item) and isAzeriteArmor(item) end
	local bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
	local bagConsumble = function(item) return isItemInBag(item) and isItemConsumble(item) and not isItemMechagon(item) end
	local bagTradeGoods = function(item) return isItemInBag(item) and isItemTrade(item) and not isItemMechagon(item) end
	local bagQuestItem = function(item) return isItemInBag(item) and isItemQuest(item) end
	local bagsJunk = function(item) return isItemInBag(item) and isItemJunk(item) end
	local onlyBank = function(item) return isItemInBank(item) and not isItemEquipment(item) and not isItemConsumble(item) and not isAzeriteArmor(item) and not isMountAndPet(item) and not isItemMechagon(item) end
	local bankAzeriteItem = function(item) return isItemInBank(item) and isAzeriteArmor(item) end
	local bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
	local bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
	local bankConsumble = function(item) return isItemInBank(item) and isItemConsumble(item) and not isItemMechagon(item) end
	local onlyReagent = function(item) return item.bagID == -3 end
	local bagMountPet = function(item) return isItemInBag(item) and isMountAndPet(item) end
	local bankMountPet = function(item) return isItemInBank(item) and isMountAndPet(item) end
	local bagMechagon = function(item) return isItemInBag(item) and isItemMechagon(item) end
	local bankMechagon = function(item) return isItemInBank(item) and isItemMechagon(item) end

	return onlyBags, bagAzeriteItem, bagEquipment, bagConsumble, bagTradeGoods, bagQuestItem, bagsJunk, onlyBank, bankAzeriteItem, bankLegendary, bankEquipment, bankConsumble, onlyReagent, bagMountPet, bankMountPet, bagMechagon, bankMechagon
end
