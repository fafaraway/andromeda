local F, C, L = unpack(select(2, ...))
local module = F:GetModule("tooltip")

--  Spell/Item IDs(idTip by Silverwind)

function module:extraInfo()
	if not C.tooltip.extraInfo then return end

	local types = {
		spell = SPELLS.."ID:",
		item = ITEMS.."ID:",
		unit = "NPCID",
	}

	local function addLine(self, id, type, noadd)
		for i = 1, self:NumLines() do
			local line = _G[self:GetName().."TextLeft"..i]
			if not line then break end
			local text = line:GetText()
			if text and text == type then return end
		end
		if not noadd then self:AddLine(" ") end

		if type == types.item then
			local bagCount = GetItemCount(id)
			local bankCount = GetItemCount(id, true) - GetItemCount(id)
			local itemStackCount = select(8, GetItemInfo(id))
			if bankCount > 0 and IsShiftKeyDown() then
				self:AddDoubleLine(BAGSLOT.."/"..BANK..":", C.infoColor..bagCount.."/"..bankCount)
			elseif bagCount > 0 and IsShiftKeyDown() then
				self:AddDoubleLine(BAGSLOT..":", C.infoColor..bagCount)
			end
			if itemStackCount and itemStackCount > 1 and IsShiftKeyDown() then
				self:AddDoubleLine(L["Stack Cap"]..":", C.infoColor..itemStackCount)
			end
		end
		
		self:AddDoubleLine(type, format(C.infoColor.."%s|r", id))
		self:Show()
	end

	-- All types, primarily for linked tooltips
	local function onSetHyperlink(self, link)
		local type, id = string.match(link, "^(%a+):(%d+)")
		if not type or not id then return end
		if type == "spell" or type == "enchant" or type == "trade" and IsShiftKeyDown() then
			addLine(self, id, types.spell)
		elseif type == "item" and IsShiftKeyDown() then
			addLine(self, id, types.item)
		end
	end
	hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
	hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

	-- Spells
	hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
		local id = select(10, UnitAura(...))
		if id and IsShiftKeyDown() then addLine(self, id, types.spell) end
	end)
	GameTooltip:HookScript("OnTooltipSetSpell", function(self)
		local id = select(2, self:GetSpell())
		if id and IsShiftKeyDown() then addLine(self, id, types.spell) end
	end)
	hooksecurefunc("SetItemRef", function(link)
		local id = tonumber(link:match("spell:(%d+)"))
		if id and IsShiftKeyDown() then addLine(ItemRefTooltip, id, types.spell) end
	end)

	-- Items
	local function attachItemTooltip(self)
		local link = select(2, self:GetItem())
		if link then
			local id = link:match("item:(%d+):")
			if link:find("keystone") then id = 138019 end
			if id and IsShiftKeyDown() then addLine(self, id, types.item) end
		end
	end
	GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
	hooksecurefunc(GameTooltip, "SetToyByItemID", function(self, id)
		if id and IsShiftKeyDown() then addLine(self, id, types.item) end
	end)
	hooksecurefunc(GameTooltip, "SetRecipeReagentItem", function(self, recipeID, reagentIndex)
		local link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex)
		if link then
			local id = link:match("item:(%d+):")
			if id then addLine(self, id, types.item) end
		end
	end)

	-- Castby
	local function SetCaster(self, unit, index, filter)
		local unitCaster = select(7, UnitAura(unit, index, filter))
		if unitCaster then
			local name = GetUnitName(unitCaster, true)
			local hexColor = F.HexRGB(F.UnitColor(unitCaster))
			self:AddDoubleLine(L["Castby"]..":", hexColor..name)
			self:Show()
		end
	end
	hooksecurefunc(GameTooltip, "SetUnitAura", SetCaster)


	-- NPCs id
	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		if C_PetBattles.IsInBattle() then return end
		local unit = select(2, self:GetUnit())
		if unit then
			local guid = UnitGUID(unit) or ""
			local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
			if id and guid:match("%a+") ~= "Player" then
				if IsShiftKeyDown() then addLine(self, id, types.unit) end
			end
		end
	end)


end





