local _G = _G
local unpack = unpack
local select = select
local format = format
local Ambiguate = Ambiguate
local GetAutoCompleteRealms = GetAutoCompleteRealms
local GetMoney = GetMoney
local GetMoneyString = GetMoneyString
local InCombatLockdown = InCombatLockdown
local securecall = securecall
local LoadAddOn = LoadAddOn
local StaticPopup_Show = StaticPopup_Show
local ToggleCharacter = ToggleCharacter
local ToggleStoreUI = ToggleStoreUI
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_CurrencyInfo_GetBackpackCurrencyInfo = C_CurrencyInfo.GetBackpackCurrencyInfo
local C_WowTokenPublic_UpdateMarketPrice = C_WowTokenPublic.UpdateMarketPrice
local C_WowTokenPublic_GetCurrentMarketPrice = C_WowTokenPublic.GetCurrentMarketPrice
local GetNumWatchedTokens = GetNumWatchedTokens

local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')

local function FormatMoney(money)
    return format('%s: ' .. C.InfoColor .. '%d', 'Gold', money * .0001)
end

local function GetClassIcon(class)
    local c1, c2, c3, c4 = unpack(_G.CLASS_ICON_TCOORDS[class])
    c1, c2, c3, c4 = (c1 + .03) * 50, (c2 - .03) * 50, (c3 + .03) * 50, (c4 - .03) * 50
    local classStr = '|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:13:15:0:-1:50:50:' .. c1 .. ':' .. c2 .. ':' .. c3 .. ':' .. c4 .. '|t '
    return classStr or ''
end

local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
    crossRealms = {[1] = C.MyRealm}
end

local profit, spent, oldMoney = 0, 0, 0

local function Button_OnEvent(self, event)
    if event == 'PLAYER_ENTERING_WORLD' then
        oldMoney = GetMoney()
        C_WowTokenPublic_UpdateMarketPrice()
        self:UnregisterEvent(event)
    end

    if event == 'TOKEN_MARKET_PRICE_UPDATED' then
        C_WowTokenPublic_UpdateMarketPrice()
        return
    end

    local newMoney = GetMoney()
    local change = newMoney - oldMoney
    if oldMoney > newMoney then
        spent = spent - change
    else
        profit = profit + change
    end

    self.Text:SetText(FormatMoney(newMoney))

    if not _G.FREE_ADB['GoldStatistic'][C.MyRealm] then
        _G.FREE_ADB['GoldStatistic'][C.MyRealm] = {}
    end
    if not _G.FREE_ADB['GoldStatistic'][C.MyRealm][C.MyName] then
        _G.FREE_ADB['GoldStatistic'][C.MyRealm][C.MyName] = {}
    end
    _G.FREE_ADB['GoldStatistic'][C.MyRealm][C.MyName][1] = GetMoney()
    _G.FREE_ADB['GoldStatistic'][C.MyRealm][C.MyName][2] = C.MyClass

    oldMoney = newMoney
end

local function Button_OnMouseUp(self, btn)
    if InCombatLockdown() then
        _G.UIErrorsFrame:AddMessage(C.InfoColor .. _G.ERR_NOT_IN_COMBAT)
        return
    end

    if btn == 'LeftButton' then
        if (not _G.StoreFrame) then
            LoadAddOn('Blizzard_StoreUI')
        end
        securecall(ToggleStoreUI)
    elseif btn == 'RightButton' then
        StaticPopup_Show('FREEUI_RESET_GOLD')
    end
end

local function Button_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.WORLD_QUEST_REWARD_FILTERS_GOLD, .9, .8, .6)
    _G.GameTooltip:AddLine(' ')

    _G.GameTooltip:AddLine(L['Session'], .6, .8, 1)
    _G.GameTooltip:AddDoubleLine(L['Earned'], GetMoneyString(profit), 1, 1, 1, 1, 1, 1)
    _G.GameTooltip:AddDoubleLine(L['Spent'], GetMoneyString(spent), 1, 1, 1, 1, 1, 1)
    if profit < spent then
        _G.GameTooltip:AddDoubleLine(L['Deficit'], GetMoneyString(spent - profit), 1, 0, 0, 1, 1, 1)
    elseif profit > spent then
        _G.GameTooltip:AddDoubleLine(L['Profit'], GetMoneyString(profit - spent), 0, 1, 0, 1, 1, 1)
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
                _G.GameTooltip:AddDoubleLine(GetClassIcon(class) .. name, GetMoneyString(gold), r, g, b, 1, 1, 1)
                totalGold = totalGold + gold
            end
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(_G.HONOR_LIFETIME, GetMoneyString(totalGold), .6, .8, 1, 1, 1, 1)

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddLine(_G.ITEM_QUALITY8_DESC, .6, .8, 1)
    local tokenPrice = C_WowTokenPublic_GetCurrentMarketPrice()
    _G.GameTooltip:AddDoubleLine(_G.AUCTION_HOUSE_BROWSE_HEADER_PRICE, GetMoneyString(tokenPrice), 1, 1, 1, 1, 1, 1)

    --[[ for i = 1, GetNumWatchedTokens() do
        local currencyInfo = C_CurrencyInfo_GetBackpackCurrencyInfo(i)
        if not currencyInfo then
            break
        end
        local name = currencyInfo.name
        local count = currencyInfo.quantity
        local icon = currencyInfo.iconFileID
        local currencyID = currencyInfo.currencyTypesID
        if name and i == 1 then
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(_G.CURRENCY .. ':', .6, .8, 1)
        end
        if name and count then
            local total = C_CurrencyInfo_GetCurrencyInfo(currencyID).maxQuantity
            local iconTexture = ' |T' .. icon .. ':13:15:0:0:50:50:4:46:4:46|t'
            if total > 0 then
                _G.GameTooltip:AddDoubleLine(name, count .. '/' .. total .. iconTexture, 1, 1, 1, 1, 1, 1)
            else
                _G.GameTooltip:AddDoubleLine(name, count .. iconTexture, 1, 1, 1, 1, 1, 1)
            end
        end
    end ]]

    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Toggle Store Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right .. L['Reset Gold Statistics'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateGoldBlock()
    if not C.DB.Infobar.Gold then
        return
    end

    local bu = INFOBAR:AddBlock('', 'LEFT', 150)
    bu:HookScript('OnEvent', Button_OnEvent)
    bu:HookScript('OnMouseUp', Button_OnMouseUp)
    bu:HookScript('OnEnter', Button_OnEnter)
    bu:HookScript('OnLeave', Button_OnLeave)

    bu:RegisterEvent('PLAYER_ENTERING_WORLD')
    bu:RegisterEvent('PLAYER_MONEY')
    bu:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
    bu:RegisterEvent('SEND_MAIL_COD_CHANGED')
    bu:RegisterEvent('PLAYER_TRADE_MONEY')
    bu:RegisterEvent('TRADE_MONEY_CHANGED')
    bu:RegisterEvent('TOKEN_MARKET_PRICE_UPDATED')
end
