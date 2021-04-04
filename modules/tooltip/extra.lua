local F, C, L = unpack(select(2, ...))
local TOOLTIP = F.TOOLTIP

local strmatch, format, tonumber, select = string.match, string.format, tonumber, select
local UnitAura, GetItemCount, GetItemInfo, GetUnitName = UnitAura, GetItemCount, GetItemInfo, GetUnitName
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local C_TradeSkillUI_GetRecipeReagentItemLink = C_TradeSkillUI.GetRecipeReagentItemLink
local C_CurrencyInfo_GetCurrencyListLink = C_CurrencyInfo.GetCurrencyListLink
local BAGSLOT, BANK = BAGSLOT, BANK

local types = {
	spell = 'SpellID',
	item = 'ItemID',
	quest = 'QuestID',
	talent = 'TalentID',
	achievement = 'AchievementID',
	unit = 'NPCID',

}

function TOOLTIP:AddLineForID(id, linkType, noadd)
	if not id or id == '' then
		return
	end

	if type(id) == 'table' and #id == 1 then
		id = id[1]
	end

	if not IsAltKeyDown() then
		return
	end

	for i = 1, self:NumLines() do
		local line = _G[self:GetName() .. 'TextLeft' .. i]
		if not line then
			break
		end
		local text = line:GetText()
		if text and text == linkType then
			return
		end
	end


	local left, right
	if type(id) == 'table' then
		left = NORMAL_FONT_COLOR_CODE .. linkType .. 's:' .. FONT_COLOR_CODE_CLOSE
		right = C.BlueColor .. table.concat(id, ', ') .. FONT_COLOR_CODE_CLOSE
	else
		left = NORMAL_FONT_COLOR_CODE .. linkType .. ':' .. FONT_COLOR_CODE_CLOSE
		right = C.BlueColor .. id .. FONT_COLOR_CODE_CLOSE
	end

	if not noadd then
		self:AddLine(' ')
	end

	if linkType == types.item then
		local bagCount = GetItemCount(id)
		local bankCount = GetItemCount(id, true) - bagCount
		local itemStackCount = select(8, GetItemInfo(id))
		--local itemSellPrice = select(11, GetItemInfo(id))

		if bankCount > 0 then
			self:AddDoubleLine(BAGSLOT .. '/' .. BANK .. ':', C.BlueColor .. bagCount .. '/' .. bankCount)
		elseif bagCount > 1 then
			self:AddDoubleLine(BAGSLOT .. ':', C.BlueColor .. bagCount)
		end
		if itemStackCount and itemStackCount > 1 then
			self:AddDoubleLine(L['TOOLTIP_STACK_CAP'] .. ':', C.BlueColor .. itemStackCount)
		end

		-- if itemSellPrice and itemSellPrice ~= 0 then
		-- 	self:AddDoubleLine(L['TOOLTIP_SELL_PRICE'] .. ':', C.WhiteColor .. GetMoneyString(itemSellPrice))
		-- end
	end

	--self:AddDoubleLine(linkType, format('%s', C.WhiteColor .. id))
	self:AddDoubleLine(left, right)
	self:Show()
end

function TOOLTIP:SetHyperLinkID(link)
	local linkType, id = strmatch(link, '^(%a+):(%d+)')
	if not linkType or not id then
		return
	end

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
	end
end

function TOOLTIP:SetItemID()
	local link = select(2, self:GetItem())
	if link then
		local id = GetItemInfoFromHyperlink(link)
		local keystone = strmatch(link, '|Hkeystone:([0-9]+):')
		if keystone then
			id = tonumber(keystone)
		end
		if id then
			TOOLTIP.AddLineForID(self, id, types.item)
		end
	end
end

function TOOLTIP:UpdateSpellCaster(...)
	local unitCaster = select(7, UnitAura(...))
	if unitCaster then
		local name = GetUnitName(unitCaster, true)
		local hexColor = F:RGBToHex(F:UnitColor(unitCaster))
		self:AddDoubleLine(L['TOOLTIP_AURA_FROM'] .. ':', hexColor .. name)
		self:Show()
	end
end

function TOOLTIP:RemoveMoneyLine() -- #TODO
	if not self.shownMoneyFrames then
		return
	end

	GameTooltip_ClearMoney(self)
end

function TOOLTIP:ExtraInfo()
	if not C.DB.tooltip.extra_info then
		return
	end

	-- Update all
	hooksecurefunc(GameTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)
	hooksecurefunc(ItemRefTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)

	-- Spells
	hooksecurefunc(
		GameTooltip,
		'SetUnitAura',
		function(self, ...)
			local id = select(10, UnitAura(...))
			if id then
				TOOLTIP.AddLineForID(self, id, types.spell)
			end
		end
	)

	GameTooltip:HookScript(
		'OnTooltipSetSpell',
		function(self)
			local id = select(2, self:GetSpell())
			if id then
				TOOLTIP.AddLineForID(self, id, types.spell)
			end
		end
	)

	hooksecurefunc(
		'SetItemRef',
		function(link)
			local id = tonumber(strmatch(link, 'spell:(%d+)'))
			if id then
				TOOLTIP.AddLineForID(ItemRefTooltip, id, types.spell)
			end
		end
	)

	-- Items
	GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
	ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)

	--GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.RemoveMoneyLine)

	hooksecurefunc(
		GameTooltip,
		'SetToyByItemID',
		function(self, id)
			if id then
				TOOLTIP.AddLineForID(self, id, types.item)
			end
		end
	)

	hooksecurefunc(
		GameTooltip,
		'SetRecipeReagentItem',
		function(self, recipeID, reagentIndex)
			local link = C_TradeSkillUI_GetRecipeReagentItemLink(recipeID, reagentIndex)
			local id = link and strmatch(link, 'item:(%d+):')
			if id then
				TOOLTIP.AddLineForID(self, id, types.item)
			end
		end
	)

	-- NPCs
	GameTooltip:HookScript(
		'OnTooltipSetUnit',
		function(self)
			if C_PetBattles.IsInBattle() then
				return
			end

			local unit = select(2, self:GetUnit())
			if unit then
				local guid = UnitGUID(unit) or ''
				local id = tonumber(guid:match('-(%d+)-%x+$'), 10)
				if id and guid:match('%a+') ~= 'Player' then
					TOOLTIP.AddLineForID(self, id, types.unit)
				end
			end
		end
	)

	-- Quests
	hooksecurefunc(
		'QuestMapLogTitleButton_OnEnter',
		function(self)
			if self.questID then
				TOOLTIP.AddLineForID(GameTooltip, self.questID, types.quest)
			end
		end
	)

	-- Spell caster
	hooksecurefunc(GameTooltip, 'SetUnitAura', TOOLTIP.UpdateSpellCaster)
end


