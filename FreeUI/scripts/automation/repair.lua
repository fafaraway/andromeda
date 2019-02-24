local F, C, L = unpack(select(2, ...))

if not C.automation.autoRepair then return end

local isShown, isBankEmpty, autoRepair, repairAllCost, canRepair

local function delayFunc()
	if isBankEmpty then
		autoRepair(true)
	else
		UIErrorsFrame:AddMessage(format(C.RedColor..'%s:|r %s', L['guildRepair'], GetMoneyString(repairAllCost)))
		print(format(C.RedColor..'%s:|r %s', L['guildRepair'], GetMoneyString(repairAllCost)))
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
				F.Notification("Repairs", format(C.RedColor..'%s:|r'..' %s', L['repairCost'], GetMoneyString(repairAllCost)), "Interface\\Icons\\INV_Hammer_20")
				--UIErrorsFrame:AddMessage(format(C.RedColor..'%s:|r'..' %s', L['repairCost'], GetMoneyString(repairAllCost)))
				print(format(C.RedColor..'%s:|r'..' %s', L['repairCost'], GetMoneyString(repairAllCost)))
				return
			else
				UIErrorsFrame:AddMessage(C.InfoColor..L['repairError'])
				print(C.InfoColor..L['repairError'])
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
