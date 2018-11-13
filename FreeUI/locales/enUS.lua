local F, C, L = unpack(select(2, ...))

L['rareFound'] = 'Rare nearby! '

L['rare'] = 'Rare'

L['interrupted'] = 'Interrupted: '
L['dispeled'] = 'Dispeled: '
L['stolen'] = 'Stolen: '

L['guildRepair'] = 'Repair cost covered by Guild Bank'
L['repairCost'] = 'Repair cost'
L['repairError'] = 'You have insufficient funds to repair your equipment!'

L['SellJunk'] = 'Vendor trash sold'

L['SellPrice'] = 'Sell Price'
L['StackCap'] = 'Stack Caps'
L['Castby'] = 'Castby'

L['Status'] = 'Status'
L['Finished'] = 'Finished'

L['BotToy'] = '<Attention>: %s puts %s!'
L['Feast'] = '<Attention>: %s puts %s!'
L['Portal'] = '<Attention>: %s opened %s!'
L['RefreshmentTable'] = '<Attention>: %s casted %s!'
L['RitualOfSummoning'] = '<Attention>: %s is casting %s!'
L['SoulWell'] = '<Attention>: %s casted %s!'

L['ResNoTarget'] = '<Attention>: %s casted %s!'
L['ResTarget'] = '<Attention>: %s casted %s on %s!'

L['Undress'] = 'Undress'

L["WoW"] = "<World of Warcraft>"
L["BN"] = "<Battle.NET>"
L["NoOnline"] = "No friends online at the moment."
L["HoldShift"] = "Hold <Shift>"
L["ShowFriends"] = "Open friend panel"
L["OpenBag"] = "Open bag"
L["SpecPanel"] = "Open talent panel"
L["ChangeSpec"] = "Change specialization"
L["ChangeLootSpec"] = "Change loot specialization"
L["CollectMemory"] = "Collect Memory"
L["Hidden"] = "Hidden"
L["DefaultUIMemoryUsage:"] = "Default UI Memory Usage:"
L["TotalMemoryUsage:"] = "Total Memory Usage:"
L["OpenAddonList"] = "Open addon list panel"
L["OpenTimerTracker"] = "Open timer panel"


L["Search"] = SEARCH
L["Armor"] = GetItemClassInfo(4)
L["BattlePet"] = GetItemClassInfo(17)
L["Consumables"] = GetItemClassInfo(0)
L["Gem"] = GetItemClassInfo(3)
L["Quest"] = GetItemClassInfo(12)
L["Trades"] = GetItemClassInfo(7)
L["Weapon"] = GetItemClassInfo(2)
L["ArtifactPower"] = ARTIFACT_POWER
L["bagCaptions"] = {
	["cBniv_Bank"] 			= BANK,
	["cBniv_BankReagent"]	= REAGENT_BANK,
	["cBniv_BankSets"]		= LOOT_JOURNAL_ITEM_SETS,
	["cBniv_BankArmor"]		= BAG_FILTER_EQUIPMENT,
	["cBniv_BankGem"]		= AUCTION_CATEGORY_GEMS,
	["cBniv_BankQuest"]		= AUCTION_CATEGORY_QUEST_ITEMS,
	["cBniv_BankTrade"]		= BAG_FILTER_TRADE_GOODS,
	["cBniv_BankCons"]		= BAG_FILTER_CONSUMABLES,
	["cBniv_BankArtifactPower"]	= ARTIFACT_POWER,
	["cBniv_Junk"]			= BAG_FILTER_JUNK,
	["cBniv_ItemSets"]		= LOOT_JOURNAL_ITEM_SETS,
	["cBniv_Armor"]			= BAG_FILTER_EQUIPMENT,
	["cBniv_Gem"]			= AUCTION_CATEGORY_GEMS,
	["cBniv_Quest"]			= AUCTION_CATEGORY_QUEST_ITEMS,
	["cBniv_Consumables"]	= BAG_FILTER_CONSUMABLES,
	["cBniv_ArtifactPower"]	= ARTIFACT_POWER,
	["cBniv_TradeGoods"]	= BAG_FILTER_TRADE_GOODS,
	["cBniv_BattlePet"]		= AUCTION_CATEGORY_BATTLE_PETS,
	["cBniv_Bag"]			= INVENTORY_TOOLTIP,
	["cBniv_Keyring"]		= KEYRING,
}	

L["MarkAsNew"] = "Mark as new"
L["MarkAsKnown"] = "Mark as known"
L["bagCaptions"]["cBniv_NewItems"] = "New"