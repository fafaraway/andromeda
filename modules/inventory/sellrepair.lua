local F, C, L = unpack(select(2, ...))
local INVENTORY = F:GetModule('INVENTORY')


local format, wipe = string.format, table.wipe
local GetContainerNumSlots, GetContainerItemLink, GetItemInfo, GetContainerItemInfo, UseContainerItem = GetContainerNumSlots, GetContainerItemLink, GetItemInfo, GetContainerItemInfo, UseContainerItem
local GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair = GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair
local IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney = IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney
local C_Timer_After, IsControlKeyDown, CanMerchantRepair = C_Timer.After, IsControlKeyDown, CanMerchantRepair

local isShown, autoRepair, repairAllCost, canRepair
local sellCount, stop, cache = 0, true, {}
local errorText = _G.ERR_VENDOR_DOESNT_BUY

local function stopSelling(tell)
	stop = true
	if sellCount > 0 and tell then
		F.Print(format(L['INVENTORY_SELL_JUNK_EARN'], GetMoneyString(sellCount)))
		F:CreateNotification(L['INVENTORY_NOTIFICATION_HEADER'], format(L['INVENTORY_SELL_JUNK_EARN'], GetMoneyString(sellCount)), nil, 'Interface\\ICONS\\INV_Misc_Coin_01')
	end
	sellCount = 0
end

local function startSelling()
	if stop then return end
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			if stop then return end
			local link = GetContainerItemLink(bag, slot)
			if link then
				local price = select(11, GetItemInfo(link))
				local _, count, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(bag, slot)
				if (quality == 0 or FREE_ADB['custom_junk_list'][itemID]) and price > 0 and not cache['b'..bag..'s'..slot] then
					sellCount = sellCount + price*count
					cache['b'..bag..'s'..slot] = true
					UseContainerItem(bag, slot)
					C_Timer_After(.2, startSelling)
					return
				end
			end
		end
	end
end

local function updateSelling(event, ...)
	if not C.DB['inventory']['auto_sell_junk'] then return end

	local _, arg = ...
	if event == 'MERCHANT_SHOW' then
		if IsControlKeyDown() then return end
		stop = false
		wipe(cache)
		startSelling()
		F:RegisterEvent('UI_ERROR_MESSAGE', updateSelling)
	elseif event == 'UI_ERROR_MESSAGE' and arg == errorText then
		stopSelling(false)
	elseif event == 'MERCHANT_CLOSED' then
		stopSelling(true)
	end
end

local function delayFunc()
	autoRepair(true)
end

function autoRepair(override)
	if isShown and not override then return end
	isShown = true

	local myMoney = GetMoney()
	repairAllCost, canRepair = GetRepairAllCost()

	if canRepair and repairAllCost > 0 and C.DB['inventory']['auto_repair'] then
		if (not override) and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
			RepairAllItems(true)
		else
			if myMoney > repairAllCost then
				RepairAllItems()
				F.Print(format(L['INVENTORY_REPAIR_COST'], GetMoneyString(repairAllCost)))
				F:CreateNotification(L['INVENTORY_NOTIFICATION_HEADER'], format(L['INVENTORY_REPAIR_COST'], GetMoneyString(repairAllCost)), nil, 'Interface\\ICONS\\Ability_Repair')
				return
			else
				F.Print(C.RedColor..L['INVENTORY_REPAIR_ERROR'])
				F:CreateNotification(L['INVENTORY_NOTIFICATION_HEADER'], C.RedColor..L['INVENTORY_REPAIR_ERROR'], nil, 'Interface\\ICONS\\Ability_Repair')
				return
			end
		end

		C_Timer_After(.5, delayFunc)
	end
end

local function merchantClose()
	isShown = false
	F:UnregisterEvent('MERCHANT_CLOSED', merchantClose)
end

local function merchantShow()
	if IsControlKeyDown() or not C.DB['inventory']['auto_repair'] or not CanMerchantRepair() then return end
	autoRepair()
	F:RegisterEvent('MERCHANT_CLOSED', merchantClose)
end


function INVENTORY:AutoSellJunk()
	F:RegisterEvent('MERCHANT_SHOW', updateSelling)
	F:RegisterEvent('MERCHANT_CLOSED', updateSelling)
end

function INVENTORY:AutoRepair()
	F:RegisterEvent('MERCHANT_SHOW', merchantShow)
end
