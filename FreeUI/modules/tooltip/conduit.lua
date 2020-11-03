local F, C, L = unpack(select(2, ...))
local TOOLTIP = F.TOOLTIP


local pairs, select = pairs, select
local GetItemInfo, GetItemInfoFromHyperlink = GetItemInfo, GetItemInfoFromHyperlink
local C_Soulbinds_GetConduitCollection = C_Soulbinds.GetConduitCollection
local C_Soulbinds_IsItemConduitByItemInfo = C_Soulbinds.IsItemConduitByItemInfo
local COLLECTED_STRING = ' |cffff0000('..COLLECTED..')|r'


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
	if not link then return end
	if not C_Soulbinds_IsItemConduitByItemInfo(link) then return end

	local itemID = GetItemInfoFromHyperlink(link)
	local level = select(4, GetItemInfo(link))
	local knownLevel = itemID and TOOLTIP.ConduitData[itemID]

	if knownLevel and level and knownLevel >= level then
		local textLine = _G[self:GetName()..'TextLeft1']
		local text = textLine and textLine:GetText()
		if text and text ~= '' then
			textLine:SetText(text..COLLECTED_STRING)
		end
	end
end

function TOOLTIP:ConduitCollectionData()
	TOOLTIP.Conduit_UpdateCollection()
	if not next(TOOLTIP.ConduitData) then
		C_Timer.After(10, TOOLTIP.Conduit_UpdateCollection) -- might be empty on fist load
	end
	F:RegisterEvent('SOULBIND_CONDUIT_COLLECTION_UPDATED', TOOLTIP.Conduit_UpdateCollection)

	if not C.DB.tooltip.conduit_info then return end

	GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
	ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
	ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
	GameTooltipTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
	EmbeddedItemTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Conduit_CheckStatus)
end
