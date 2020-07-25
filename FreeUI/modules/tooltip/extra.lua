local F, C, L = unpack(select(2, ...))
local TOOLTIP, cfg = F:GetModule('Tooltip'), C.Tooltip


local strmatch, format, tonumber, select = string.match, string.format, tonumber, select
local UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink = UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink
local C_TradeSkillUI_GetRecipeReagentItemLink = C_TradeSkillUI.GetRecipeReagentItemLink
local BAGSLOT, BANK = BAGSLOT, BANK


local types = {
	spell = SPELLS..L['TOOLTIP_ID'],
	item = ITEMS..L['TOOLTIP_ID'],
	quest = QUESTS_LABEL..L['TOOLTIP_ID'],
	talent = TALENT..L['TOOLTIP_ID'],
	achievement = ACHIEVEMENTS..L['TOOLTIP_ID'],
	currency = CURRENCY..L['TOOLTIP_ID'],
	azerite = L['TOOLTIP_AZERITE_TRAIT']..L['TOOLTIP_ID'],
}

local mountCache = {}
for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
	mountCache[select(2, C_MountJournal.GetMountInfoByID(mountID))] = mountID
end

function TOOLTIP:AddLineForID(id, linkType, noadd)
	if not IsAltKeyDown() then return end

	for i = 1, self:NumLines() do
		local line = _G[self:GetName()..'TextLeft'..i]
		if not line then break end
		local text = line:GetText()
		if text and text == linkType then return end
	end

	if not noadd then self:AddLine(' ') end

	self:AddDoubleLine(linkType, format(C.InfoColor.."%s|r", id))
	self:Show()
end

function TOOLTIP:ItemPrice()
	if not IsAltKeyDown() then return end

	local _, link = self:GetItem()
	local itemSellPrice = select(11, GetItemInfo(link))

	if itemSellPrice and itemSellPrice ~= 0 then
		self:AddDoubleLine(L['TOOLTIP_SELL_PRICE']..':', '|cffffffff'..GetMoneyString(itemSellPrice)..'|r')
	end
end

function TOOLTIP:ItemCount()
	if not IsAltKeyDown() then return end

	local _, link = self:GetItem()
	local bagCount = GetItemCount(link)
	local bankCount = GetItemCount(link, true) - GetItemCount(link)
	local itemStackCount = select(8, GetItemInfo(link))

	if bankCount > 0 then
		self:AddDoubleLine(BAGSLOT..'/'..BANK..':', C.InfoColor..bagCount..'/'..bankCount)
	elseif bagCount > 0 then
		self:AddDoubleLine(BAGSLOT..':', C.InfoColor..bagCount)
	end

	if itemStackCount and itemStackCount > 1 then
		self:AddDoubleLine(L['TOOLTIP_STACK_CAP']..':', C.InfoColor..itemStackCount)
	end
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

function TOOLTIP:UpdateAuraSource(...)
	local unitCaster = select(7, UnitAura(...))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F.HexRGB(F.UnitColor(unitCaster))

		self:AddDoubleLine(L['TOOLTIP_AURA_FROM']..':', hexColor..name)
		self:Show()
	end
end


function TOOLTIP:ExtraInfo()
	if cfg.extra_info then
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

		-- Azerite traits
		hooksecurefunc(GameTooltip, 'SetAzeritePower', function(self, _, _, id)
			if id then TOOLTIP.AddLineForID(self, id, types.azerite, true) end
		end)


		GameTooltip:HookScript("OnTooltipSetItem", TOOLTIP.ItemCount)
		GameTooltip:HookScript("OnTooltipSetItem", TOOLTIP.ItemPrice)
	end

	-- Aura source
	if cfg.aura_source then
		hooksecurefunc(GameTooltip, 'SetUnitAura', TOOLTIP.UpdateAuraSource)
	end

	-- Mount source
	if cfg.mount_source then
		hooksecurefunc(GameTooltip, 'SetUnitAura', function(self, ...)
			local id = select(10, UnitAura(...))
		
			if id and mountCache[id] then
				local text = NOT_COLLECTED
				local r, g, b = 1, 0, 0
				local collected = select(11, C_MountJournal.GetMountInfoByID(mountCache[id]))
		
				if collected then
					text = COLLECTED
					r, g, b = 0, 1, 0
				end
		
				local sourceText = select(3, C_MountJournal.GetMountInfoExtraByID(mountCache[id]))

				if IsAltKeyDown() then
					self:AddLine(' ')
					self:AddDoubleLine(text, sourceText, r,g,b,1,1,1)
					self:AddLine(' ')
					self:Show()
				end
			end
		end)
	end
end