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
    ['Soul Cinders'] = 1906,
}

local currPvP = {
    ['Honor'] = 1792,
    ['Conquest'] = 1602,
}

local function AddIcon(texture)
    texture = texture and '|T' .. texture .. ':12:16:0:0:50:50:4:46:4:46|t ' or ''
    return texture
end

local title
local function AddTitle(text)
    if not title then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddLine(text, 0.6, 0.8, 1)
        title = true
    end
end

local function Block_OnEvent(self)
    local info = C_CurrencyInfo.GetCurrencyInfo(1828)
    self.text:SetText(string.format('%s: |cffdf5ed9%s|r', info.name, BreakUpLargeNumbers(info.quantity)))
end

local function Block_OnMouseUp(self, btn)
    if btn == 'LeftButton' then
        securecall(_G.ToggleCharacter, 'TokenFrame')
    end
end

local function Block_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.CURRENCY, 0.9, 0.8, 0.6)

    title = false
    for _, id in pairs(currPvE) do
        AddTitle('PvE')
        local info = C_CurrencyInfo.GetCurrencyInfo(id)
        local amount = string.format('|cff20ff20%s|r', BreakUpLargeNumbers(info.quantity))

        _G.GameTooltip:AddDoubleLine(AddIcon(info.iconFileID) .. info.name, amount, 1, 1, 1)
    end

    title = false
    for _, id in pairs(currPvP) do
        AddTitle('PvP')
        local info = C_CurrencyInfo.GetCurrencyInfo(id)
        local amount = string.format('|cff20ff20%s|r', BreakUpLargeNumbers(info.quantity))

        _G.GameTooltip:AddDoubleLine(AddIcon(info.iconFileID) .. info.name, amount, 1, 1, 1)
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Toggle Currency Panel'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:Show()
end

local function Block_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateCurrencyBlock()
    if not C.DB.Infobar.Currency then
        return
    end

    local cur = INFOBAR:RegisterNewBlock('currency', 'LEFT', 150)

    cur.onEvent = Block_OnEvent
    cur.onEnter = Block_OnEnter
    cur.onLeave = Block_OnLeave
    cur.onMouseUp = Block_OnMouseUp

    cur.eventList = { 'PLAYER_ENTERING_WORLD', 'CURRENCY_DISPLAY_UPDATE' }
end