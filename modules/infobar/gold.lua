local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local function FormatMoney(money)
    return string.format('%s: %s', L['Gold'], GetMoneyString(money))
end

local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
    crossRealms = { [1] = C.MY_REALM }
end

StaticPopupDialogs.FREEUI_RESET_ALL_GOLD_STATISTICS = {
    text = C.RED_COLOR .. L['Reset All Gold Statistics?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        for _, realm in pairs(crossRealms) do
            if _G.FREE_ADB['GoldStatistic'][realm] then
                table.wipe(_G.FREE_ADB['GoldStatistic'][realm])
            end
        end

        _G.FREE_ADB['GoldStatistic'][C.MY_REALM][C.MY_NAME] = { GetMoney(), C.MY_CLASS }
    end,
    timeout = 0,
    whileDead = 1,
}

local menuList = {
    {
        text = F:RgbToHex(1, 0.8, 0) .. _G.REMOVE_WORLD_MARKERS .. '!!!',
        notCheckable = true,
        func = function()
            StaticPopup_Show('FREEUI_RESET_ALL_GOLD_STATISTICS')
        end,
    },
}

local function GetClassIcon(class)
    local c1, c2, c3, c4 = unpack(_G.CLASS_ICON_TCOORDS[class])
    c1, c2, c3, c4 = (c1 + 0.03) * 50, (c2 - 0.03) * 50, (c3 + 0.03) * 50, (c4 - 0.03) * 50
    local prefix = '|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:13:15:0:-1:50:50:'
    local classStr = prefix .. c1 .. ':' .. c2 .. ':' .. c3 .. ':' .. c4 .. '|t '
    return classStr or ''
end

local RebuildCharList

local function clearCharGold(_, realm, name)
    _G.FREE_ADB['GoldStatistic'][realm][name] = nil
    _G.DropDownList1:Hide()
    RebuildCharList()
end

function RebuildCharList()
    for i = 2, #menuList do
        if menuList[i] then
            wipe(menuList[i])
        end
    end

    local index = 1
    for _, realm in pairs(crossRealms) do
        if _G.FREE_ADB['GoldStatistic'][C.MY_REALM] then
            for name, value in pairs(_G.FREE_ADB['GoldStatistic'][C.MY_REALM]) do
                if not (realm == C.MY_REALM and name == C.MY_REALM) then
                    index = index + 1
                    if not menuList[index] then
                        menuList[index] = {}
                    end
                    menuList[index].text = F:RgbToHex(F:ClassColor(value[2])) .. Ambiguate(name .. '-' .. realm, 'none')
                    menuList[index].notCheckable = true
                    menuList[index].arg1 = realm
                    menuList[index].arg2 = name
                    menuList[index].func = clearCharGold
                end
            end
        end
    end
end

local profit, spent, oldMoney = 0, 0, 0

local function Button_OnEvent(self, event)
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

    self.text:SetText(FormatMoney(newMoney))

    if not _G.FREE_ADB['GoldStatistic'][C.MY_REALM] then
        _G.FREE_ADB['GoldStatistic'][C.MY_REALM] = {}
    end
    if not _G.FREE_ADB['GoldStatistic'][C.MY_REALM][C.MY_NAME] then
        _G.FREE_ADB['GoldStatistic'][C.MY_REALM][C.MY_NAME] = {}
    end
    _G.FREE_ADB['GoldStatistic'][C.MY_REALM][C.MY_NAME][1] = GetMoney()
    _G.FREE_ADB['GoldStatistic'][C.MY_REALM][C.MY_NAME][2] = C.MY_CLASS

    oldMoney = newMoney
end

local function Button_OnMouseUp(self, btn)
    if btn == 'LeftButton' then
        if not _G.StoreFrame then
            LoadAddOn('Blizzard_StoreUI')
        end
        securecall(_G.ToggleStoreUI)
    elseif btn == 'RightButton' then
        if not menuList[1].created then
            RebuildCharList()
            menuList[1].created = true
        end
        EasyMenu(menuList, F.EasyMenu, self, -80, 100, 'MENU', 1)
    end
end

local function Button_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.WORLD_QUEST_REWARD_FILTERS_GOLD, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddLine(' ')

    _G.GameTooltip:AddLine(L['Session'], 0.6, 0.8, 1)
    _G.GameTooltip:AddDoubleLine(L['Earned'], GetMoneyString(profit, true), 1, 1, 1, 1, 1, 1)
    _G.GameTooltip:AddDoubleLine(L['Spent'], GetMoneyString(spent, true), 1, 1, 1, 1, 1, 1)
    if profit < spent then
        _G.GameTooltip:AddDoubleLine(L['Deficit'], GetMoneyString(spent - profit, true), 1, 0, 0, 1, 1, 1)
    elseif profit > spent then
        _G.GameTooltip:AddDoubleLine(L['Profit'], GetMoneyString(profit - spent, true), 0, 1, 0, 1, 1, 1)
    end
    _G.GameTooltip:AddLine(' ')

    local totalGold = 0
    _G.GameTooltip:AddLine(_G.CHARACTER, 0.6, 0.8, 1)

    for _, realm in pairs(crossRealms) do
        local thisRealmList = _G.FREE_ADB['GoldStatistic'][realm]
        if thisRealmList then
            for k, v in pairs(thisRealmList) do
                local name = Ambiguate(k .. '-' .. realm, 'none')
                local gold, class = unpack(v)
                local r, g, b = F:ClassColor(class)
                _G.GameTooltip:AddDoubleLine(GetClassIcon(class) .. name, GetMoneyString(gold, true), r, g, b, 1, 1, 1)
                totalGold = totalGold + gold
            end
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(_G.HONOR_LIFETIME, GetMoneyString(totalGold, true), 0.6, 0.8, 1, 1, 1, 1)

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddLine(_G.ITEM_QUALITY8_DESC, 0.6, 0.8, 1)

    local tokenPrice = C_WowTokenPublic.GetCurrentMarketPrice() or 0
    _G.GameTooltip:AddDoubleLine(_G.AUCTION_HOUSE_BROWSE_HEADER_PRICE, GetMoneyString(tokenPrice, true), 1, 1, 1, 1, 1, 1)

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Toggle Store Panel'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_RIGHT_BUTTON .. L['Reset Gold Statistics'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateGoldBlock()
    if not C.DB.Infobar.Gold then
        return
    end

    local gold = INFOBAR:RegisterNewBlock('gold', 'LEFT', 200)
    gold:HookScript('OnEvent', Button_OnEvent)
    gold:HookScript('OnMouseUp', Button_OnMouseUp)
    gold:HookScript('OnEnter', Button_OnEnter)
    gold:HookScript('OnLeave', Button_OnLeave)

    gold:RegisterEvent('PLAYER_ENTERING_WORLD')
    gold:RegisterEvent('PLAYER_MONEY')
    gold:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
    gold:RegisterEvent('SEND_MAIL_COD_CHANGED')
    gold:RegisterEvent('PLAYER_TRADE_MONEY')
    gold:RegisterEvent('TRADE_MONEY_CHANGED')
    gold:RegisterEvent('TOKEN_MARKET_PRICE_UPDATED')
end
