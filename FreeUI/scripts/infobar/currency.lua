local F, C, L = unpack(select(2, ...))
if not C.infobar.enable then return end
if not C.infobar.currencies then return end
local module = F:GetModule('Infobar')


local format = string.format
local pairs, wipe = pairs, table.wipe

local profit, spent, oldMoney = 0, 0, 0

local function formatTextMoney(money)
	return format('%s: '..C.InfoColor..'%d', 'GOLD', money * .0001)
end

local function getClassIcon(class)
	local c1, c2, c3, c4 = unpack(CLASS_ICON_TCOORDS[class])
	c1, c2, c3, c4 = (c1+.03)*50, (c2-.03)*50, (c3+.03)*50, (c4-.03)*50
	local classStr = '|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:13:15:0:-1:50:50:'..c1..':'..c2..':'..c3..':'..c4..'|t '
	return classStr or ''
end

local function getGoldString(number)
	local money = format('%.0f', number/1e4)
	return GetMoneyString(money*1e4)
end

StaticPopupDialogs['RESETGOLD'] = {
	text = 'Are you sure to reset the gold count?',
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FreeUIGlobalConfig['totalGold'] = {}
		FreeUIGlobalConfig['totalGold'][C.Realm] = {}
		FreeUIGlobalConfig['totalGold'][C.Realm][C.Name] = {GetMoney(), C.Class}
	end,
	whileDead = 1,
}



function module:Currencies()
	local FreeUIMoneyButton = module.FreeUIMoneyButton

	FreeUIMoneyButton = module:addButton('', module.POSITION_RIGHT, 120, function(self, button)
		if button == 'RightButton' then
			StaticPopup_Show('RESETGOLD')
		else
			ToggleCharacter('TokenFrame')
		end
	end)

	FreeUIMoneyButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIMoneyButton:RegisterEvent('PLAYER_MONEY')
	FreeUIMoneyButton:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
	FreeUIMoneyButton:RegisterEvent('SEND_MAIL_COD_CHANGED')
	FreeUIMoneyButton:RegisterEvent('PLAYER_TRADE_MONEY')
	FreeUIMoneyButton:RegisterEvent('TRADE_MONEY_CHANGED')
	FreeUIMoneyButton:SetScript('OnEvent', function(self, event)
		if event == 'PLAYER_ENTERING_WORLD' then
			oldMoney = GetMoney()
			self:UnregisterEvent(event)
		end

		local newMoney = GetMoney()
		local change = newMoney - oldMoney
		if oldMoney > newMoney then
			spent = spent - change
		else
			profit = profit + change
		end
		self.Text:SetText(formatTextMoney(newMoney))

		--if not FreeUIGlobalConfig['totalGold'] then FreeUIGlobalConfig['totalGold'] = {} end
		if not FreeUIGlobalConfig['totalGold'][C.Realm] then FreeUIGlobalConfig['totalGold'][C.Realm] = {} end
		FreeUIGlobalConfig['totalGold'][C.Realm][C.Name] = {GetMoney(), C.Class}

		oldMoney = newMoney
	end)

	FreeUIMoneyButton:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -15)

		GameTooltip:ClearLines()
		GameTooltip:AddLine(CURRENCY, .9, .82, .62)
		GameTooltip:AddLine(' ')

		GameTooltip:AddLine(L['Session'], .6,.8,1)
		GameTooltip:AddDoubleLine(L['Earned'], GetMoneyString(profit), 1,1,1, 1,1,1)
		GameTooltip:AddDoubleLine(L['Spent'], GetMoneyString(spent), 1,1,1, 1,1,1)
		if profit < spent then
			GameTooltip:AddDoubleLine(L['Deficit'], GetMoneyString(spent-profit), 1,0,0, 1,1,1)
		elseif profit > spent then
			GameTooltip:AddDoubleLine(L['Profit'], GetMoneyString(profit-spent), 0,1,0, 1,1,1)
		end
		GameTooltip:AddLine(' ')

		local totalGold = 0
		GameTooltip:AddLine(L['Character'], .6,.8,1)
		local thisRealmList = FreeUIGlobalConfig['totalGold'][C.Realm]
		for k, v in pairs(thisRealmList) do
			local gold, class = unpack(v)
			local r, g, b = F.ClassColor(class)
			GameTooltip:AddDoubleLine(getClassIcon(class)..k, getGoldString(gold), r,g,b, 1,1,1)
			totalGold = totalGold + gold
		end
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(TOTAL..':', getGoldString(totalGold), .6,.8,1, 1,1,1)

		for i = 1, GetNumWatchedTokens() do
			local name, count, icon, currencyID = GetBackpackCurrencyInfo(i)
			if name and i == 1 then
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(CURRENCY..':', .6,.8,1)
			end
			if name and count then
				local _, _, _, _, _, total = GetCurrencyInfo(currencyID)
				local iconTexture = ' |T'..icon..':13:15:0:0:50:50:4:46:4:46|t'
				if total > 0 then
					GameTooltip:AddDoubleLine(name, count..'/'..total..iconTexture, 1,1,1, 1,1,1)
				else
					GameTooltip:AddDoubleLine(name, count..iconTexture, 1,1,1, 1,1,1)
				end
			end
		end


		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.LeftButton..L['OpenCurrencyPanel'], 1,1,1, .9, .82, .62)
		GameTooltip:AddDoubleLine(' ', C.RightButton..L['ResetGoldData'], 1,1,1, .9, .82, .62)
		GameTooltip:Show()
	end)

	FreeUIMoneyButton:HookScript('OnLeave', function()
		GameTooltip:Hide()
	end)
end



