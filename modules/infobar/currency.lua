local F, C, L = unpack(select(2, ...))
local INFOBAR = F.INFOBAR

local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo
local profit, spent, oldMoney = 0, 0, 0

local FreeUIMoneyButton = INFOBAR.FreeUIMoneyButton

local function formatTextMoney(money)
	return format('%s: ' .. C.InfoColor .. '%d', 'Gold', money * .0001)
end

local function getClassIcon(class)
	local c1, c2, c3, c4 = unpack(CLASS_ICON_TCOORDS[class])
	c1, c2, c3, c4 = (c1 + .03) * 50, (c2 - .03) * 50, (c3 + .03) * 50, (c4 - .03) * 50
	local classStr = '|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:13:15:0:-1:50:50:' .. c1 .. ':' .. c2 .. ':' .. c3 .. ':' .. c4 .. '|t '
	return classStr or ''
end

local function getGoldString(number)
	local money = format('%.0f', number / 1e4)
	return GetMoneyString(money * 1e4)
end

local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
	crossRealms = {[1] = C.MyRealm}
end

StaticPopupDialogs['FREEUI_RESET_GOLD'] = {
	text = L.GUI.RESET_GOLD,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		for _, realm in pairs(crossRealms) do
			if FREE_GOLDCOUNT[realm] then
				wipe(FREE_GOLDCOUNT[realm])
			end
		end

		FREE_GOLDCOUNT[C.MyRealm][C.MyName] = {GetMoney(), C.MyClass}
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true
}

function INFOBAR:Currency()
	if not C.DB.infobar.currency then
		return
	end

	FreeUIMoneyButton = INFOBAR:addButton('', INFOBAR.POSITION_LEFT, 150)

	FreeUIMoneyButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIMoneyButton:RegisterEvent('PLAYER_MONEY')
	FreeUIMoneyButton:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
	FreeUIMoneyButton:RegisterEvent('SEND_MAIL_COD_CHANGED')
	FreeUIMoneyButton:RegisterEvent('PLAYER_TRADE_MONEY')
	FreeUIMoneyButton:RegisterEvent('TRADE_MONEY_CHANGED')
	FreeUIMoneyButton:RegisterEvent('TOKEN_MARKET_PRICE_UPDATED')
	FreeUIMoneyButton:SetScript(
		'OnEvent',
		function(self, event)
			if event == 'PLAYER_ENTERING_WORLD' then
				oldMoney = GetMoney()
				C_WowTokenPublic.UpdateMarketPrice()
				self:UnregisterEvent(event)
			end

			if event == 'TOKEN_MARKET_PRICE_UPDATED' then
				C_WowTokenPublic.UpdateMarketPrice()
				return
			end

			local newMoney = GetMoney()
			local change = newMoney - oldMoney
			if oldMoney > newMoney then
				spent = spent - change
			else
				profit = profit + change
			end

			self.Text:SetText(formatTextMoney(newMoney))

			if not FREE_GOLDCOUNT[C.MyRealm] then
				FREE_GOLDCOUNT[C.MyRealm] = {}
			end
			if not FREE_GOLDCOUNT[C.MyRealm][C.MyName] then
				FREE_GOLDCOUNT[C.MyRealm][C.MyName] = {}
			end
			FREE_GOLDCOUNT[C.MyRealm][C.MyName][1] = GetMoney()
			FREE_GOLDCOUNT[C.MyRealm][C.MyName][2] = C.MyClass

			oldMoney = newMoney
		end
	)

	FreeUIMoneyButton:HookScript(
		'OnMouseUp',
		function(self, btn)
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage(C.InfoColor .. ERR_NOT_IN_COMBAT)
				return
			end

			if btn == 'LeftButton' then
				securecall(ToggleCharacter, 'TokenFrame')
			elseif btn == 'RightButton' then
				if (not StoreFrame) then
					LoadAddOn('Blizzard_StoreUI')
				end
				securecall(ToggleStoreUI)
			elseif btn == 'MiddleButton' then
				StaticPopup_Show('FREEUI_RESET_GOLD')
			end
		end
	)

	FreeUIMoneyButton:HookScript(
		'OnEnter',
		function(self)
			GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -6) or 6)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(CURRENCY, .9, .8, .6)
			GameTooltip:AddLine(' ')

			GameTooltip:AddLine(L['INFOBAR_SESSION'], .6, .8, 1)
			GameTooltip:AddDoubleLine(L['INFOBAR_EARNED'], GetMoneyString(profit), 1, 1, 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(L['INFOBAR_SPENT'], GetMoneyString(spent), 1, 1, 1, 1, 1, 1)
			if profit < spent then
				GameTooltip:AddDoubleLine(L['INFOBAR_DEFICIT'], GetMoneyString(spent - profit), 1, 0, 0, 1, 1, 1)
			elseif profit > spent then
				GameTooltip:AddDoubleLine(L['INFOBAR_PROFIT'], GetMoneyString(profit - spent), 0, 1, 0, 1, 1, 1)
			end
			GameTooltip:AddLine(' ')

			local totalGold = 0
			GameTooltip:AddLine(CHARACTER, .6, .8, 1)

			for _, realm in pairs(crossRealms) do
				local thisRealmList = FREE_GOLDCOUNT[realm]
				if thisRealmList then
					for k, v in pairs(thisRealmList) do
						local name = Ambiguate(k .. '-' .. realm, 'none')
						local gold, class = unpack(v)
						local r, g, b = F.ClassColor(class)
						GameTooltip:AddDoubleLine(getClassIcon(class) .. name, GetMoneyString(gold), r, g, b, 1, 1, 1)
						totalGold = totalGold + gold
					end
				end
			end

			GameTooltip:AddLine(' ')
			GameTooltip:AddDoubleLine(HONOR_LIFETIME, GetMoneyString(totalGold), .6, .8, 1, 1, 1, 1)

			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(ITEM_QUALITY8_DESC, .6, .8, 1)
			local tokenPrice = C_WowTokenPublic.GetCurrentMarketPrice()
			GameTooltip:AddDoubleLine(AUCTION_HOUSE_BROWSE_HEADER_PRICE, GetMoneyString(tokenPrice), 1, 1, 1, 1, 1, 1)

			for i = 1, GetNumWatchedTokens() do
				local currencyInfo = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
				if not currencyInfo then
					break
				end
				local name, count, icon, currencyID = currencyInfo.name, currencyInfo.quantity, currencyInfo.iconFileID, currencyInfo.currencyTypesID
				if name and i == 1 then
					GameTooltip:AddLine(' ')
					GameTooltip:AddLine(CURRENCY .. ':', .6, .8, 1)
				end
				if name and count then
					local total = C_CurrencyInfo_GetCurrencyInfo(currencyID).maxQuantity
					local iconTexture = ' |T' .. icon .. ':13:15:0:0:50:50:4:46:4:46|t'
					if total > 0 then
						GameTooltip:AddDoubleLine(name, count .. '/' .. total .. iconTexture, 1, 1, 1, 1, 1, 1)
					else
						GameTooltip:AddDoubleLine(name, count .. iconTexture, 1, 1, 1, 1, 1, 1)
					end
				end
			end

			GameTooltip:AddDoubleLine(' ', C.LineString)
			GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left..L['INFOBAR_OPEN_CURRENCY_PANEL']..' ', 1,1,1, .9, .8, .6)
			GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right..L['INFOBAR_OPEN_STORE_PANEL']..' ', 1,1,1, .9, .8, .6)
			GameTooltip:AddDoubleLine(' ', C.Assets.mouse_middle..L['INFOBAR_RESET_GOLD_COUNT']..' ', 1,1,1, .9, .8, .6)
			GameTooltip:Show()

		end
	)

	FreeUIMoneyButton:HookScript(
		'OnLeave',
		function()
			GameTooltip:Hide()
		end
	)
end
