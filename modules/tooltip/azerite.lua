local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('TOOLTIP')


local _G = getfenv(0)
local format, tinsert, ipairs, select = string.format, table.insert, ipairs, select
local GetSpellInfo = GetSpellInfo
local C_AzeriteEmpoweredItem_GetPowerInfo = C_AzeriteEmpoweredItem.GetPowerInfo
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_AzeriteEmpoweredItem_GetAllTierInfoByItemID = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID
local tipList, powerList, powerCache, tierCache = {}, {}, {}, {}

local iconString = '|T%s:18:22:0:0:64:64:5:59:5:59'
local function getIconString(icon, known)
	if known then
		return format(iconString..':255:255:255|t', icon)
	else
		return format(iconString..':90:90:90|t', icon)
	end
end

function TOOLTIP:Azerite_ScanTooltip()
	wipe(tipList)
	wipe(powerList)

	for i = 9, self:NumLines() do
		local line = _G[self:GetName()..'TextLeft'..i]
		local text = line:GetText()
		local powerName = text and strmatch(text, '%- (.+)')
		if powerName then
			tinsert(tipList, i)
			powerList[i] = powerName
		end
	end
end

function TOOLTIP:Azerite_PowerToSpell(id)
	local spellID = powerCache[id]
	if not spellID then
		local powerInfo = C_AzeriteEmpoweredItem_GetPowerInfo(id)
		if powerInfo and powerInfo.spellID then
			spellID = powerInfo.spellID
			powerCache[id] = spellID
		end
	end
	return spellID
end

function TOOLTIP:Azerite_UpdateTier(link)
	if not C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(link) then return end
	local allTierInfo = tierCache[link]
	if not allTierInfo then
		allTierInfo = C_AzeriteEmpoweredItem_GetAllTierInfoByItemID(link)
		tierCache[link] = allTierInfo
	end

	return allTierInfo
end

function TOOLTIP:Azerite_UpdateItem()
	local link = select(2, self:GetItem())
	if not link then return end

	local allTierInfo = TOOLTIP:Azerite_UpdateTier(link)
	if not allTierInfo then return end

	TOOLTIP.Azerite_ScanTooltip(self)
	if #tipList == 0 then return end

	local index = 1
	for i = 1, #allTierInfo do
		local powerIDs = allTierInfo[i].azeritePowerIDs
		if powerIDs[1] == 13 then break end

		local lineIndex = tipList[index]
		if not lineIndex then break end

		local tooltipText = ""
		for _, id in ipairs(powerIDs) do
			local spellID = TOOLTIP:Azerite_PowerToSpell(id)
			if not spellID then break end

			local name, _, icon = GetSpellInfo(spellID)
			local found = name == powerList[lineIndex]
			if found then
				tooltipText = tooltipText.." "..getIconString(icon, true)
			else
				tooltipText = tooltipText.." "..getIconString(icon)
			end
		end

		if tooltipText ~= "" then
			local line = _G[self:GetName().."TextLeft"..lineIndex]
			line:SetText(tooltipText)
			_G[self:GetName().."TextLeft"..lineIndex+1]:SetText("")
		end

		index = index + 1
	end
end

function TOOLTIP:AzeriteArmor()
	if not C.DB.tooltip.azerite_armor then return end
	if IsAddOnLoaded('AzeriteTooltip') then return end

	GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Azerite_UpdateItem)
	ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Azerite_UpdateItem)
	ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.Azerite_UpdateItem)
	EmbeddedItemTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Azerite_UpdateItem)
	GameTooltipTooltip:HookScript('OnTooltipSetItem', TOOLTIP.Azerite_UpdateItem)
end
