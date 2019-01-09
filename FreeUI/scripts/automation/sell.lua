local F, C, L = unpack(select(2, ...))

local format = string.format
local pairs, wipe = pairs, table.wipe

local sellCount, stop, cache = 0, true, {}
local errorText = _G.ERR_VENDOR_DOESNT_BUY

local function stopSelling(tell)
	stop = true
	if sellCount > 0 and tell then
		F.Notification("SellJunk", C.GreenColor..L['SellJunk']..'|r: '..GetMoneyString(sellCount), "Interface\\Icons\\INV_Hammer_20")
		--UIErrorsFrame:AddMessage(C.GreenColor..L['SellJunk']..'|r: '..GetMoneyString(sellCount))
		print(C.GreenColor..L['SellJunk']..'|r: '..GetMoneyString(sellCount))
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
				local _, count, _, quality = GetContainerItemInfo(bag, slot)
				if quality == 0 and price > 0 and not cache['b'..bag..'s'..slot] then
					sellCount = sellCount + price*count
					cache['b'..bag..'s'..slot] = true
					UseContainerItem(bag, slot)
					C_Timer.After(.2, startSelling)
					return
				end
			end
		end
	end
end

local function updateSelling(event, ...)
	if not C.automation.autoSellJunk then return end

	local _, arg = ...
	if event == 'MERCHANT_SHOW' then
		if IsShiftKeyDown() then return end
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
F:RegisterEvent('MERCHANT_SHOW', updateSelling)
F:RegisterEvent('MERCHANT_CLOSED', updateSelling)
