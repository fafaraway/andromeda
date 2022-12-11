local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local function addLinesForItem(self)
    if not C.DB.Tooltip.ItemInfo then
        return
    end
    if C.DB.Tooltip.ItemInfoByAlt and not IsAltKeyDown() then
        return
    end

    local data = self:GetTooltipData()
    local guid = data and data.guid
    local link = guid and C_Item.GetItemLinkByGUID(guid)

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
    _G.ITEM_CREATED_BY = '' -- Remove creator name
    -- _G.PVP_ENABLED = '' -- Remove PvP text
    _G.GameTooltip_OnTooltipAddMoney = nop -- Remove sell price

    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, addLinesForItem)
end
