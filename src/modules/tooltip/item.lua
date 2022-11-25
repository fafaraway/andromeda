local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local function RemoveLines()
    _G.ITEM_CREATED_BY = '' -- Remove creator name
    _G.PVP_ENABLED = '' -- Remove PvP text
    _G.GameTooltip_OnTooltipAddMoney = nop -- Remove sell price
end

local function AddLines(self)
    if not C.DB.Tooltip.ItemInfo then
        return
    end
    if C.DB.Tooltip.ItemInfoByAlt and not IsAltKeyDown() then
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

    if bankCount > 0 then
        self:AddDoubleLine(_G.BAGSLOT .. '/' .. _G.BANK .. ':', bagCount .. '/' .. bankCount, 0.5, 0.8, 1, 1, 1, 1)
    elseif bagCount > 1 then
        self:AddDoubleLine(_G.BAGSLOT .. ':', bagCount, 0.5, 0.8, 1, 1, 1, 1)
    end

    if itemStackCount and itemStackCount > 1 then
        self:AddDoubleLine(L['Stack Cap'] .. ':', itemStackCount, 0.5, 0.8, 1, 1, 1, 1)
    end

    if itemSellPrice and itemSellPrice > 0 then
        self:AddDoubleLine(_G.AUCTION_PRICE .. ':', GetMoneyString(itemSellPrice, true), 0.5, 0.8, 1, 1, 1, 1)
    end
end

function TOOLTIP:ItemInfo()
    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, RemoveLines)
    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, AddLines)
end
