local F, C, L = unpack(select(2, ...))
if GetLocale() ~= 'zhCN' then return end


L['rareFound'] = '发现稀有！ '

L['rare'] = '稀有'

L['interrupted'] = '打断：'
L['dispeled'] = '驱散：'
L['stolen'] = '偷取：'

L['guildRepair'] = '使用公会修理'
L['repairCost'] = '本次修理花费'
L['repairError'] = '没有足够的钱进行修理！'

L['SellJunk'] = '自动出售垃圾'

L['SellPrice'] = '售价'
L['StackCap'] = '堆叠上限'
L['Castby'] = '来自'

L['Status'] = '状态'
L['Finished'] = '已完成'


L['BotToy'] 			= '<注意>：%s 放置了 %s！'
L['Feast'] 				= '<注意>：%s 摆出了 %s！'
L['Portal'] 			= '<注意>：%s 开启了 %s！'
L['RefreshmentTable'] 	= '<注意>：%s 施放了 %s！'
L['RitualOfSummoning'] 	= '<注意>：%s 施放了 %s！'
L['SoulWell'] 			= '<注意>：%s 施放了 %s！'

L['ResNoTarget'] 		= '<注意>：%s 使用了 %s！'
L['ResTarget'] 			= '<注意>：%s 使用了 %s 在 %s！'

L['Undress'] = '脱衣'

L['WoW'] = '<魔兽世界>'
L['BN'] = '<战网好友>'
L["NoOnline"] = "当前没有好友在线"
L["HoldShift"] = "按住 <Shift> 展开详细信息"
L["ShowFriends"] = "打开好友面板"
L["OpenBag"] = "打开背包"
L["SpecPanel"] = "打开天赋面板"
L["ChangeSpec"] = "切换专精"
L["ChangeLootSpec"] = "切换拾取专精"
L["CollectMemory"] = "整理内存"
L["Hidden"] = "隐藏"
L["DefaultUIMemoryUsage:"] = "系统插件内存:"
L["TotalMemoryUsage:"] = "总内存使用:"
L["OpenAddonList"] = "打开插件列表"
L["OpenTimerTracker"] = "打开时钟"




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

L["MarkAsNew"] = "标记为新物品"
L["MarkAsKnown"] = "标记为已知物品"
L["bagCaptions"]["cBniv_NewItems"] = "新增"
