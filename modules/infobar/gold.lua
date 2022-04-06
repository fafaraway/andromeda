local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local function FormatMoney(money)
    return string.format('%s: %s', L['Gold'], GetMoneyString(money))
end

local function GetClassIcon(class)
    local c1, c2, c3, c4 = unpack(_G.CLASS_ICON_TCOORDS[class])
    c1, c2, c3, c4 = (c1 + .03) * 50, (c2 - .03) * 50, (c3 + .03) * 50, (c4 - .03) * 50
    local classStr = '|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:13:15:0:-1:50:50:' .. c1 .. ':' .. c2 .. ':' .. c3 .. ':' .. c4 .. '|t '
    return classStr or ''
end

local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
    crossRealms = {[1] = C.REALM}
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

    if not _G.FREE_ADB['GoldStatistic'][C.REALM] then
        _G.FREE_ADB['GoldStatistic'][C.REALM] = {}
    end
    if not _G.FREE_ADB['GoldStatistic'][C.REALM][C.NAME] then
        _G.FREE_ADB['GoldStatistic'][C.REALM][C.NAME] = {}
    end
    _G.FREE_ADB['GoldStatistic'][C.REALM][C.NAME][1] = GetMoney()
    _G.FREE_ADB['GoldStatistic'][C.REALM][C.NAME][2] = C.CLASS

    oldMoney = newMoney
end

local function Button_OnMouseUp(self, btn)
    if btn == 'LeftButton' then
        if (not _G.StoreFrame) then
            LoadAddOn('Blizzard_StoreUI')
        end
        securecall(_G.ToggleStoreUI)
    elseif btn == 'RightButton' then
        _G.StaticPopup_Show('FREEUI_RESET_GOLD')
    end
end

local function Button_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.WORLD_QUEST_REWARD_FILTERS_GOLD, .9, .8, .6)
    _G.GameTooltip:AddLine(' ')

    _G.GameTooltip:AddLine(L['Session'], .6, .8, 1)
    _G.GameTooltip:AddDoubleLine(L['Earned'], GetMoneyString(profit, true), 1, 1, 1, 1, 1, 1)
    _G.GameTooltip:AddDoubleLine(L['Spent'], GetMoneyString(spent, true), 1, 1, 1, 1, 1, 1)
    if profit < spent then
        _G.GameTooltip:AddDoubleLine(L['Deficit'], GetMoneyString(spent - profit, true), 1, 0, 0, 1, 1, 1)
    elseif profit > spent then
        _G.GameTooltip:AddDoubleLine(L['Profit'], GetMoneyString(profit - spent, true), 0, 1, 0, 1, 1, 1)
    end
    _G.GameTooltip:AddLine(' ')

    local totalGold = 0
    _G.GameTooltip:AddLine(_G.CHARACTER, .6, .8, 1)

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
    _G.GameTooltip:AddDoubleLine(_G.HONOR_LIFETIME, GetMoneyString(totalGold, true), .6, .8, 1, 1, 1, 1)

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddLine(_G.ITEM_QUALITY8_DESC, .6, .8, 1)
    local tokenPrice = C_WowTokenPublic.GetCurrentMarketPrice() or 0
    _G.GameTooltip:AddDoubleLine(_G.AUCTION_HOUSE_BROWSE_HEADER_PRICE, GetMoneyString(tokenPrice, true), 1, 1, 1, 1, 1, 1)

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Toggle Store Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_RIGHT_BUTTON .. L['Reset Gold Statistics'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateGoldBlock()
    if not C.DB.Infobar.Gold then
        return
    end

    local gold = INFOBAR:RegisterNewBlock("gold", 'LEFT', 200)
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
