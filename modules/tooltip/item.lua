local F, _, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local function RemoveLines()
    _G.ITEM_CREATED_BY = '' -- Remove creator name
    _G.PVP_ENABLED = '' -- Remove PvP text
    _G.GameTooltip:SetScript('OnTooltipAddMoney', F.Dummy) -- Remove sell price
end

local function AddLines(self)
    if not IsAltKeyDown() then
        return
    end

    local _, link = self:GetItem()

    if not link then
        return
    end

    local bagCount = GetItemCount(link)
    local bankCount = GetItemCount(link, true) - bagCount
    local itemStackCount = select(8, GetItemInfo(link))
    local itemSellPrice = select(11, GetItemInfo(link))

    self:AddLine(' ')

    if bankCount > 0 then
        self:AddDoubleLine(_G.BAGSLOT .. '/' .. _G.BANK .. ':', bagCount .. '/' .. bankCount, .5, .8, 1, 1, 1, 1)
    elseif bagCount > 1 then
        self:AddDoubleLine(_G.BAGSLOT .. ':', bagCount, .5, .8, 1, 1, 1, 1)
    end

    if itemStackCount and itemStackCount > 1 then
        self:AddDoubleLine(L['Stack'] .. ':', itemStackCount, .5, .8, 1, 1, 1, 1)
    end

    if itemSellPrice and itemSellPrice > 0 then
        self:AddDoubleLine(L['Price'] .. ':', GetMoneyString(itemSellPrice, true), .5, .8, 1, 1, 1, 1)
    end
end

function TOOLTIP:ItemInfo()
    _G.GameTooltip:HookScript('OnTooltipSetItem', RemoveLines)
    _G.GameTooltip:HookScript('OnTooltipSetItem', AddLines)
end
