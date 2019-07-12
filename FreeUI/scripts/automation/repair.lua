local F, C, L = unpack(select(2, ...))

if not C.automation.autoRepair then return end

local isShown, isBankEmpty, autoRepair, repairAllCost, canRepair

local function delayFunc()
	if isBankEmpty then
		autoRepair(true)
	else
		print(format(C.RedColor..'%s:|r %s', L['AUTOMATION_GUILD_REPAIR_COST'], GetMoneyString(repairAllCost)))

		if (C.notification.enableBanner and C.notification.autoRepairCost) then
			F.Notification(L['NOTIFICATION_REPAIR'], format(C.RedColor..'%s:|r %s', L['AUTOMATION_GUILD_REPAIR_COST'], GetMoneyString(repairAllCost)), 'Interface\\Icons\\INV_Hammer_20')
		end
	end
end

function autoRepair(override)
	if isShown and not override then return end
	isShown = true
	isBankEmpty = false

	local myMoney = GetMoney()
	repairAllCost, canRepair = GetRepairAllCost()

	if canRepair and repairAllCost > 0 then
		if (not override) and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
			RepairAllItems(true)
		else
			if myMoney > repairAllCost then
				RepairAllItems()
				print(format(C.RedColor..'%s:|r'..' %s', L['AUTOMATION_REPAIR_COST'], GetMoneyString(repairAllCost)))

				if (C.notification.enableBanner and C.notification.autoRepairCost) then
					F.Notification(L['NOTIFICATION_REPAIR'], format(C.RedColor..'%s:|r'..' %s', L['AUTOMATION_REPAIR_COST'], GetMoneyString(repairAllCost)), 'Interface\\Icons\\INV_Hammer_20')
				end
				return
			else
				print(C.InfoColor..L['AUTOMATION_REPAIR_FAILED'])

				if (C.notification.enableBanner and C.notification.autoRepairCost) then
					F.Notification(L['NOTIFICATION_REPAIR'], C.InfoColor..L['AUTOMATION_REPAIR_FAILED'], 'Interface\\Icons\\INV_Hammer_20')
				end
				return
			end
		end

		C_Timer.After(.5, delayFunc)
	end
end

local function checkBankFund(_, msgType)
	if msgType == LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
		isBankEmpty = true
	end
end

local function merchantClose()
	isShown = false
	F:UnregisterEvent('UI_ERROR_MESSAGE', checkBankFund)
	F:UnregisterEvent('MERCHANT_CLOSED', merchantClose)
end

local function merchantShow()
	if IsModifierKeyDown() or not CanMerchantRepair() then return end
	autoRepair()
	F:RegisterEvent('UI_ERROR_MESSAGE', checkBankFund)
	F:RegisterEvent('MERCHANT_CLOSED', merchantClose)
end
F:RegisterEvent('MERCHANT_SHOW', merchantShow)
