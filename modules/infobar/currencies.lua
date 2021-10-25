local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local currPvE = {
    ['Reservoir Anima'] = 1813,
    ['Grateful Offering'] = 1885,
    ['Infused Ruby'] = 1820,
    ['Stygia'] = 1767,
    ['Stygian Ember'] = 1977,
    ['Cataloged Research'] = 1931,
    ['Valor'] = 1191,
    ['Tower Knowledge'] = 1904,
    ['Soul Ash'] = 1828,
    ['Soul Cinders'] = 1906
}

local currPvP = {
    ['Honor'] = 1792,
    ['Conquest'] = 1602
}

local function AddIcon(texture)
    texture = texture and '|T' .. texture .. ':12:16:0:0:50:50:4:46:4:46|t ' or ''
    return texture
end

local title
local function AddTitle(text)
    if not title then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(text, .6, .8, 1)
        title = true
    end
end

local function Button_OnEvent(self)
    local info = C_CurrencyInfo.GetCurrencyInfo(1828)
    self.Text:SetText(string.format('%s: |cffdf5ed9%s|r', info.name, BreakUpLargeNumbers(info.quantity)))
end

local function Button_OnMouseUp(self, btn)
    if btn == 'LeftButton' then
        securecall(_G.ToggleCharacter, 'TokenFrame')
    end
end

local function Button_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.CURRENCY, .9, .8, .6)

    title = false
    for _, id in pairs(currPvE) do
        AddTitle('PvE')
        local info = C_CurrencyInfo.GetCurrencyInfo(id)
        local amount
        if info.maxQuantity > 0 then
            amount = string.format('|cff20ff20%s|r |cff7f7f7f/|r |cffff2020%s|r', BreakUpLargeNumbers(info.quantity), BreakUpLargeNumbers(info.maxQuantity))
        else
            amount = string.format('|cff20ff20%s|r', BreakUpLargeNumbers(info.quantity))
        end
        _G.GameTooltip:AddDoubleLine(AddIcon(info.iconFileID) .. info.name, amount, 1, 1, 1)
    end

    title = false
    for _, id in pairs(currPvP) do
        AddTitle('PvP')
        local info = C_CurrencyInfo.GetCurrencyInfo(id)
        local amount
        if info.maxQuantity > 0 then
            amount = string.format('|cff20ff20%s|r |cff7f7f7f/|r |cffff2020%s|r', BreakUpLargeNumbers(info.quantity), BreakUpLargeNumbers(info.maxQuantity))
        else
            amount = string.format('|cff20ff20%s|r', BreakUpLargeNumbers(info.quantity))
        end
        _G.GameTooltip:AddDoubleLine(AddIcon(info.iconFileID) .. info.name, amount, 1, 1, 1)
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Toggle Currency Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateCurrenciesBlock()
    if not C.DB.Infobar.Currencies then
        return
    end

    local bu = INFOBAR:AddBlock('', 'LEFT', 150)
    bu:HookScript('OnEvent', Button_OnEvent)
    bu:HookScript('OnMouseUp', Button_OnMouseUp)
    bu:HookScript('OnEnter', Button_OnEnter)
    bu:HookScript('OnLeave', Button_OnLeave)

    bu:RegisterEvent('PLAYER_ENTERING_WORLD')
    bu:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
end
