local F, C, L = unpack(select(2, ...))
local INVENTORY, cfg = F:GetModule('Inventory'), C.Inventory


local format, wipe = string.format, table.wipe
local GetContainerNumSlots, GetContainerItemLink, GetItemInfo, GetContainerItemInfo, UseContainerItem = GetContainerNumSlots, GetContainerItemLink, GetItemInfo, GetContainerItemInfo, UseContainerItem
local C_Timer_After, IsControlKeyDown = C_Timer.After, IsControlKeyDown

local sellCount, stop, cache = 0, true, {}
local errorText = _G.ERR_VENDOR_DOESNT_BUY

local function stopSelling(tell)
	stop = true
	if sellCount > 0 and tell then
		F.Print(C.BlueColor..L["INVENTORY_SELL_JUNK_EARN"]..'|r ', GetMoneyString(sellCount))
		F:CreateNotification(L['INVENTORY_NOTIFICATION_HEADER'], C.BlueColor..L['INVENTORY_SELL_JUNK_EARN']..'|r: '..(GetMoneyString(sellCount)), nil, 'Interface\\ICONS\\INV_Misc_Coin_01')
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
				if (quality == 0 or FreeUIGlobalConfig["customJunkList"][itemID]) and price > 0 and not cache["b"..bag.."s"..slot] then
					sellCount = sellCount + price*count
					cache["b"..bag.."s"..slot] = true
					UseContainerItem(bag, slot)
					C_Timer_After(.2, startSelling)
					return
				end
			end
		end
	end
end

local function updateSelling(event, ...)
	if not FreeUIConfig['inventory']['autoSellJunk'] then return end

	local _, arg = ...
	if event == "MERCHANT_SHOW" then
		if IsControlKeyDown() then return end
		stop = false
		wipe(cache)
		startSelling()
		F:RegisterEvent("UI_ERROR_MESSAGE", updateSelling)
	elseif event == "UI_ERROR_MESSAGE" and arg == errorText then
		stopSelling(false)
	elseif event == "MERCHANT_CLOSED" then
		stopSelling(true)
	end
end
F:RegisterEvent("MERCHANT_SHOW", updateSelling)
F:RegisterEvent("MERCHANT_CLOSED", updateSelling)