local F, C, L = unpack(select(2, ...))
local INVENTORY, cfg = F:GetModule('Inventory'), C.Inventory


local GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair = GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair
local IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney = IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney
local C_Timer_After, IsControlKeyDown, CanMerchantRepair = C_Timer.After, IsControlKeyDown, CanMerchantRepair
local isShown, autoRepair, repairAllCost, canRepair

local function delayFunc()
	autoRepair(true)
end

function autoRepair(override)
	if isShown and not override then return end
	isShown = true

	local myMoney = GetMoney()
	repairAllCost, canRepair = GetRepairAllCost()

	if canRepair and repairAllCost > 0 and FreeUIConfig['inventory']['autoRepair'] then
		if (not override) and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
			RepairAllItems(true)
		else
			if myMoney > repairAllCost then
				RepairAllItems()
				F.Print(format(C.BlueColor.."%s|r%s", L["INVENTORY_REPAIR_COST"]..'|r ', GetMoneyString(repairAllCost)))
				F:CreateNotification(L['INVENTORY_NOTIFICATION_HEADER'], C.BlueColor..L['INVENTORY_REPAIR_COST']..'|r: '..(GetMoneyString(repairAllCost)), nil, 'Interface\\ICONS\\Ability_Repair')
				return
			else
				F.Print(C.RedColor..L["INVENTORY_REPAIR_ERROR"])
				F:CreateNotification(L['INVENTORY_NOTIFICATION_HEADER'], C.BlueColor..L['INVENTORY_REPAIR_ERROR'], nil, 'Interface\\ICONS\\Ability_Repair')
				return
			end
		end

		C_Timer_After(.5, delayFunc)
	end
end


local function merchantClose()
	isShown = false
	F:UnregisterEvent("MERCHANT_CLOSED", merchantClose)
end

local function merchantShow()
	if IsControlKeyDown() or not FreeUIConfig['inventory']['autoRepair'] or not CanMerchantRepair() then return end
	autoRepair()
	F:RegisterEvent("MERCHANT_CLOSED", merchantClose)
end
F:RegisterEvent("MERCHANT_SHOW", merchantShow)