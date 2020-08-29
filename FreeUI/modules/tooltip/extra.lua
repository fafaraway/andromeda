local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('TOOLTIP')


local strmatch, format, tonumber, select = string.match, string.format, tonumber, select
local UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink = UnitAura, GetItemCount, GetItemInfo, GetUnitName, GetCurrencyListLink
local UnitBattlePetType, UnitBattlePetSpeciesID = UnitBattlePetType, UnitBattlePetSpeciesID
local C_TradeSkillUI_GetRecipeReagentItemLink = C_TradeSkillUI.GetRecipeReagentItemLink
local BAGSLOT, BANK = BAGSLOT, BANK

local mountCache = {}

F:RegisterEvent('PLAYER_LOGIN', function()
	for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
		mountCache[select(2, C_MountJournal.GetMountInfoByID(mountID))] = mountID
	end
end)

local types = {
	spell = L['TOOLTIP_ID_SPELL'],
	item = L['TOOLTIP_ID_ITEM'],
	quest = L['TOOLTIP_ID_QUEST'],
	talent = L['TOOLTIP_ID_TALENT'],
	achievement = L['TOOLTIP_ID_ACHIEVEMENT'],
	currency = L['TOOLTIP_ID_CURRENCY'],
	azerite = L['TOOLTIP_ID_AZERITE_TRAIT'],
	companion = L['TOOLTIP_ID_COMPANION'],
	visual = L['TOOLTIP_ID_VISUAL'],
	source = L['TOOLTIP_ID_SOURCE'],
}

function TOOLTIP:AddLineForID(id, linkType, noadd)
	if not IsAltKeyDown() then return end

	--[[ for i = 1, self:NumLines() do
		local line = _G[self:GetName()..'TextLeft'..i]
		if not line then break end
		local text = line:GetText()
		if text and text == linkType then return end
	end

	if not noadd then self:AddLine(' ') end

	self:AddDoubleLine(linkType, format(C.InfoColor..'%s|r', id))
	self:Show() ]]



	if not id or id == '' then return end
	if type(id) == 'table' and #id == 1 then id = id[1] end

	-- Check if we already added to this tooltip. Happens on the talent frame
	local frame, text
	for i = 1,15 do
		frame = _G[self:GetName() .. 'TextLeft' .. i]
		if frame then text = frame:GetText() end
		if text and string.find(text, linkType .. ':') then return end
	end

	if not noadd then self:AddLine(' ') end

	local left, right
	-- if type(id) == 'table' then
	-- 	left = NORMAL_FONT_COLOR_CODE .. linkType .. 'ID:' .. FONT_COLOR_CODE_CLOSE
	-- 	right = HIGHLIGHT_FONT_COLOR_CODE .. table.concat(id, ', ') .. FONT_COLOR_CODE_CLOSE
	-- else
		left = NORMAL_FONT_COLOR_CODE .. linkType .. FONT_COLOR_CODE_CLOSE
		right = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
	--end

	self:AddDoubleLine(left, right)
	self:Show()
end

function TOOLTIP:ItemPrice()
	if not IsAltKeyDown() then return end

	local _, link = self:GetItem()
	local itemSellPrice = select(11, GetItemInfo(link))

	if itemSellPrice and itemSellPrice~= 0 then TOOLTIP.AddLineForID(self, GetMoneyString(itemSellPrice), L['TOOLTIP_SELL_PRICE'], true) end
end

function TOOLTIP:ItemCount()
	if not IsAltKeyDown() then return end

	local _, link = self:GetItem()
	local bagCount = GetItemCount(link)
	local bankCount = GetItemCount(link, true) - GetItemCount(link)
	local itemStackCount = select(8, GetItemInfo(link))

	if bankCount > 0 then
		self:AddDoubleLine(L['TOOLTIP_BAG']..'/'..L['TOOLTIP_BANK']..':', '|cffffffff'..bagCount..'/'..bankCount)
	elseif bagCount > 0 then
		self:AddDoubleLine(L['TOOLTIP_BAG']..':', '|cffffffff'..bagCount)
	end

	if itemStackCount and itemStackCount > 1 then TOOLTIP.AddLineForID(self, itemStackCount, L['TOOLTIP_STACK_CAP'], true) end
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
	elseif linkType == 'companion' then
		TOOLTIP.AddLineForID(self, id, types.companion)
	elseif linkType == 'visual' then
		TOOLTIP.AddLineForID(self, id, types.visual)
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

function TOOLTIP:AuraSource(...)
	local unitCaster = select(7, UnitAura(...))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F.HexRGB(F.UnitColor(unitCaster))

		if name then TOOLTIP.AddLineForID(self, hexColor..name, L['TOOLTIP_AURA_FROM'], true) end
		self:Show()
	end
end

function TOOLTIP:MountSource(...)
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
			self:AddDoubleLine(text, sourceText, r, g, b, 1, 1, 1)
			self:AddLine(' ')
			self:Show()
		end
	end
end

function TOOLTIP:Companion()
	if not IsAltKeyDown() then return end

	local _, unit = self:GetUnit()
	if not unit then return end
	if not UnitIsBattlePet(unit) then return end

	local id = UnitBattlePetSpeciesID(unit)

	if id then TOOLTIP.AddLineForID(self, id, types.companion) end
end


function TOOLTIP:ExtraInfo()
	if FreeDB.tooltip.various_ids then
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

		-- Companion
		GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.Companion)
	end

	if FreeDB.tooltip.item_count then
		GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.ItemCount)
	end

	if FreeDB.tooltip.item_price then
		GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.ItemPrice)
	end

	if FreeDB.tooltip.aura_source then
		hooksecurefunc(GameTooltip, 'SetUnitAura', TOOLTIP.AuraSource)
	end

	if FreeDB.tooltip.mount_source then
		hooksecurefunc(GameTooltip, 'SetUnitAura', TOOLTIP.MountSource)
	end
end


local function contains(table, element)
	for _, value in pairs(table) do
		if value == element then return true end
	end

	return false
end

local f = CreateFrame('frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(_, _, what)
	if what == 'Blizzard_Collections' then
		hooksecurefunc('WardrobeCollectionFrame_SetAppearanceTooltip', function(self, sources)
			local visualIDs = {}
			local sourceIDs = {}
			local itemIDs = {}

			for i = 1, #sources do
				if sources[i].visualID and not contains(visualIDs, sources[i].visualID) then table.insert(visualIDs, sources[i].visualID) end
				if sources[i].sourceID and not contains(visualIDs, sources[i].sourceID) then table.insert(sourceIDs, sources[i].sourceID) end
				if sources[i].itemID and not contains(visualIDs, sources[i].itemID) then table.insert(itemIDs, sources[i].itemID) end
			end

			if not IsAltKeyDown() then return end
			if #visualIDs ~= 0 then TOOLTIP.AddLineForID(GameTooltip, visualIDs, types.visual) end
			if #sourceIDs ~= 0 then TOOLTIP.AddLineForID(GameTooltip, sourceIDs, types.source, true) end
			if #itemIDs ~= 0 then TOOLTIP.AddLineForID(GameTooltip, itemIDs, types.item, true) end
		end)
	end
end)
