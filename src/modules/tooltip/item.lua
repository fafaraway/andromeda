local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local expansionList = {
    [0] = _G.EXPANSION_NAME0,
    [1] = _G.EXPANSION_NAME1,
    [2] = _G.EXPANSION_NAME2,
    [3] = _G.EXPANSION_NAME3,
    [4] = _G.EXPANSION_NAME4,
    [5] = _G.EXPANSION_NAME5,
    [6] = _G.EXPANSION_NAME6,
    [7] = _G.EXPANSION_NAME7,
    [8] = _G.EXPANSION_NAME8,
    [9] = _G.EXPANSION_NAME9,
}

local function addLinesForItem(self)
    if not C.DB.Tooltip.ShowItemInfo then
        return
    end
    if C.DB.Tooltip.ShowItemInfoByAlt and not IsAltKeyDown() then
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
    local expacID = select(15, GetItemInfo(link))

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

    if expacID then
        self:AddDoubleLine(L['Expansion'] .. ':', expansionList[expacID], 0.5, 0.8, 1)
    end
end

function TOOLTIP:ItemInfo()
    _G.ITEM_CREATED_BY = '' -- Remove creator name
    -- _G.PVP_ENABLED = '' -- Remove PvP text
    _G.GameTooltip_OnTooltipAddMoney = nop -- Remove sell price

    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, addLinesForItem)
end
