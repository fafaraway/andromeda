local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local strmatch, format, tonumber, select = string.match, string.format, tonumber, select
local UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink = UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink
local C_TradeSkillUI_GetRecipeReagentItemLink = C_TradeSkillUI.GetRecipeReagentItemLink
local BAGSLOT, BANK = BAGSLOT, BANK


local types = {
	spell = SPELLS..'ID:',
	item = ITEMS..'ID:',
	quest = QUESTS_LABEL..'ID:',
	talent = TALENT..'ID:',
	achievement = ACHIEVEMENTS..'ID:',
	currency = CURRENCY..'ID:',
	azerite = L['TOOLTIP_AZERITE_TRAIT']..'ID:',
}

function TOOLTIP:AddLineForID(id, linkType, noadd)
	for i = 1, self:NumLines() do
		local line = _G[self:GetName()..'TextLeft'..i]
		if not line then break end
		local text = line:GetText()
		if text and text == linkType then return end
	end
	if not noadd and IsShiftKeyDown() then self:AddLine(' ') end

	if IsShiftKeyDown() then
		self:AddDoubleLine(linkType, format(C.InfoColor..'%s|r', id))
	end

	if linkType == types.item then
		local bagCount = GetItemCount(id)
		local bankCount = GetItemCount(id, true) - GetItemCount(id)
		local itemStackCount = select(8, GetItemInfo(id))
		local itemSellPrice = select(11, GetItemInfo(id))

		if bankCount > 0 and IsShiftKeyDown() then
			self:AddDoubleLine(BAGSLOT..'/'..BANK..':', C.InfoColor..bagCount..'/'..bankCount)
		elseif bagCount > 0 and IsShiftKeyDown() then
			self:AddDoubleLine(BAGSLOT..':', C.InfoColor..bagCount)
		end
		if itemStackCount and itemStackCount > 1 and IsShiftKeyDown() then
			self:AddDoubleLine(L['TOOLTIP_STACK_CAP']..':', C.InfoColor..itemStackCount)
		end

		if itemSellPrice and itemSellPrice ~= 0 and IsShiftKeyDown() then
			self:AddDoubleLine(L['TOOLTIP_SELL_PRICE']..':', '|cffffffff'..GetMoneyString(itemSellPrice)..'|r')
		end
	end

	self:Show()
end

function TOOLTIP:SetHyperLinkID(link)
	local linkType, id = strmatch(link, '^(%a+):(%d+)')
	if not linkType or not id then return end

	if linkType == 'spell' or linkType == 'enchant' or linkType == 'trade' then
		TOOLTIP.AddLineForID(self, id, types.spell)
	elseif linkType == 'talent' then
		TOOLTIP.AddLineForID(self, id, types.talent, true)
	elseif linkType == 'quest' then
		TOOLTIP.AddLineForID(self, id, types.quest)
	elseif linkType == 'achievement' then
		TOOLTIP.AddLineForID(self, id, types.achievement)
	elseif linkType == 'item' then
		TOOLTIP.AddLineForID(self, id, types.item)
	elseif linkType == 'currency' then
		TOOLTIP.AddLineForID(self, id, types.currency)
	end
end

function TOOLTIP:SetItemID()
	local link = select(2, self:GetItem())
	if link then
		local id = strmatch(link, 'item:(%d+):')
		local keystone = strmatch(link, '|Hkeystone:([0-9]+):')
		if keystone then id = tonumber(keystone) end
		if id then TOOLTIP.AddLineForID(self, id, types.item) end
	end
end

function TOOLTIP:UpdateSpellCaster(...)
	local unitCaster = select(7, UnitAura(...))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F.HexRGB(F.UnitColor(unitCaster))
		self:AddDoubleLine(L['TOOLTIP_AURA_FROM']..':', hexColor..name)
		self:Show()
	end
end

function TOOLTIP:ExtraInfo()
	if not C.tooltip.extraInfo then return end

	-- Update all
	hooksecurefunc(GameTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)
	hooksecurefunc(ItemRefTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)

	-- Spells
	hooksecurefunc(GameTooltip, 'SetUnitAura', function(self, ...)
		local id = select(10, UnitAura(...))
		if id then TOOLTIP.AddLineForID(self, id, types.spell) end
	end)
	GameTooltip:HookScript('OnTooltipSetSpell', function(self)
		local id = select(2, self:GetSpell())
		if id then TOOLTIP.AddLineForID(self, id, types.spell) end
	end)
	hooksecurefunc('SetItemRef', function(link)
		local id = tonumber(strmatch(link, 'spell:(%d+)'))
		if id then TOOLTIP.AddLineForID(ItemRefTooltip, id, types.spell) end
	end)

	-- Items
	GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	hooksecurefunc(GameTooltip, 'SetToyByItemID', function(self, id)
		if id then TOOLTIP.AddLineForID(self, id, types.item) end
	end)
	hooksecurefunc(GameTooltip, 'SetRecipeReagentItem', function(self, recipeID, reagentIndex)
		local link = C_TradeSkillUI_GetRecipeReagentItemLink(recipeID, reagentIndex)
		local id = link and strmatch(link, 'item:(%d+):')
		if id then TOOLTIP.AddLineForID(self, id, types.item) end
	end)

	-- Currencies
	hooksecurefunc(GameTooltip, 'SetCurrencyToken', function(self, index)
		local id = tonumber(strmatch(GetCurrencyListLink(index), 'currency:(%d+)'))
		if id then TOOLTIP.AddLineForID(self, id, types.currency) end
	end)
	hooksecurefunc(GameTooltip, 'SetCurrencyByID', function(self, id)
		if id then TOOLTIP.AddLineForID(self, id, types.currency) end
	end)
	hooksecurefunc(GameTooltip, 'SetCurrencyTokenByID', function(self, id)
		if id then TOOLTIP.AddLineForID(self, id, types.currency) end
	end)

	-- Spell caster
	hooksecurefunc(GameTooltip, 'SetUnitAura', TOOLTIP.UpdateSpellCaster)

	-- Azerite traits
	hooksecurefunc(GameTooltip, 'SetAzeritePower', function(self, _, _, id)
		if id then TOOLTIP.AddLineForID(self, id, types.azerite, true) end
	end)
end