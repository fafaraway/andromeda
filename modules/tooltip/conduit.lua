local _G = _G
local unpack = unpack
local select = select
local pairs = pairs
local GetItemInfo = GetItemInfo
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local C_Soulbinds_GetConduitCollection = C_Soulbinds.GetConduitCollection
local C_Soulbinds_IsItemConduitByItemInfo = C_Soulbinds.IsItemConduitByItemInfo

local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local COLLECTED_STRING = ' |cffff0000(' .. _G.COLLECTED .. ')|r'
TOOLTIP.ConduitData = {}

function TOOLTIP:Conduit_UpdateCollection()
    for i = 0, 2 do
        local collectionData = C_Soulbinds_GetConduitCollection(i)
        for _, value in pairs(collectionData) do
            TOOLTIP.ConduitData[value.conduitItemID] = value.conduitItemLevel
        end
    end
end

function TOOLTIP:Conduit_CheckStatus()
    local _, link = self:GetItem()
    if not link then
        return
    end
    if not C_Soulbinds_IsItemConduitByItemInfo(link) then
        return
    end

    local itemID = GetItemInfoFromHyperlink(link)
    local level = select(4, GetItemInfo(link))
    local knownLevel = itemID and TOOLTIP.ConduitData[itemID]

    if knownLevel and level and knownLevel >= level then
        local textLine = _G[self:GetName() .. 'TextLeft1']
        local text = textLine and textLine:GetText()
        if text and text ~= '' then
            textLine:SetText(text .. COLLECTED_STRING)
        end
    end
end

function TOOLTIP:ConduitCollectionData()
    TOOLTIP.Conduit_UpdateCollection()
    if not next(TOOLTIP.ConduitData) then
        F:Delay(10, TOOLTIP.Conduit_UpdateCollection) -- might be empty on fist load
    end
    F:RegisterEvent('SOULBIND_CONDUIT_COLLECTION_UPDATED', TOOLTIP.Conduit_UpdateCollection)

    if not C.DB.tooltip.conduit_info then
        return
    end

    _G.GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
    _G.ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
    _G.ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
    _G.GameTooltipTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
    _G.EmbeddedItemTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
end
