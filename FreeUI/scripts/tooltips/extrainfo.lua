local F, C, L = unpack(select(2, ...))
local module = F:GetModule("tooltip")

--  Spell/Item IDs(idTip by Silverwind)

function module:extraInfo()
	if not C.tooltip.extraInfo then return end

	local types = {
		spell = SPELLS.."ID:",
		item = ITEMS.."ID:",
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
			local itemSellPrice = select(11, GetItemInfo(id))
			if itemSellPrice and itemSellPrice ~= 0 and IsShiftKeyDown() then
				self:AddDoubleLine(L["SellPrice"]..":", "|cffffffff"..GetMoneyString(itemSellPrice).."|r")
			end
			if bankCount > 0 and IsShiftKeyDown() then
				self:AddDoubleLine(BAGSLOT.."/"..BANK..":", C.InfoColor..bagCount.."/"..bankCount)
			elseif bagCount > 1 and IsShiftKeyDown() then
				self:AddDoubleLine(BAGSLOT..":", C.InfoColor..bagCount)
			end
			if itemStackCount and itemStackCount > 1 and IsShiftKeyDown() then
				self:AddDoubleLine(L["StackCap"]..":", C.InfoColor..itemStackCount)
			end
		end
		
		self:AddDoubleLine(type, format(C.InfoColor.."%s|r", id))
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


	-- took from idTip by silverwind
	local hooksecurefunc, select, tonumber, strfind = hooksecurefunc, select, tonumber, strfind

	local kinds = {
		item = "ItemID",
		unit = "NPCID",
		visual = "VisualID",
		source = "SourceID",
	}

	local function contains(table, element)
		for _, value in pairs(table) do
			if value == element then return true end
		end
		return false
	end

	local function addLine(tooltip, id, kind)
		if not id or id == "" then return end
		if type(id) == "table" and #id == 1 then id = id[1] end

		local frame, text
		for i = 1,15 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end
			if text and string.find(text, kind .. ":") then return end
		end

		local left, right
		if type(id) == "table" then
			left = NORMAL_FONT_COLOR_CODE .. kind .. "s:" .. FONT_COLOR_CODE_CLOSE
			right = HIGHLIGHT_FONT_COLOR_CODE .. table.concat(id, ", ") .. FONT_COLOR_CODE_CLOSE
		else
			left = NORMAL_FONT_COLOR_CODE .. kind .. ":" .. FONT_COLOR_CODE_CLOSE
			right = HIGHLIGHT_FONT_COLOR_CODE .. id .. FONT_COLOR_CODE_CLOSE
		end

		tooltip:AddDoubleLine(left, right)
		tooltip:Show()
	end

	local function addLineByKind(self, id, kind)
		if not kind or not id then return end
		if kind == "visual" then
			addLine(self, id, kinds.visual)
		end
	end

	-- NPCs
	GameTooltip:HookScript("OnTooltipSetUnit", function(self)
		if C_PetBattles.IsInBattle() then return end
		local unit = select(2, self:GetUnit())
		if unit then
			local guid = UnitGUID(unit) or ""
			local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
			if id and guid:match("%a+") ~= "Player" then
				if IsShiftKeyDown() then addLine(GameTooltip, id, kinds.unit) end
			end
		end
	end)

	-- item ids on wardrobe, so we can easily enjoy LucidMorph :)
	local f = CreateFrame("frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(_, _, what)
		if what == "Blizzard_Collections" then
			hooksecurefunc("WardrobeCollectionFrame_SetAppearanceTooltip", function(self, sources)
				local visualIDs = {}
				local sourceIDs = {}
				local itemIDs = {}

				for i = 1, #sources do
					if sources[i].visualID and not contains(visualIDs, sources[i].visualID) then table.insert(visualIDs, sources[i].visualID) end
					if sources[i].sourceID and not contains(visualIDs, sources[i].sourceID) then table.insert(sourceIDs, sources[i].sourceID) end
					if sources[i].itemID and not contains(visualIDs, sources[i].itemID) then table.insert(itemIDs, sources[i].itemID) end
				end

				if #visualIDs ~= 0 then addLine(GameTooltip, visualIDs, kinds.visual) end
				if #sourceIDs ~= 0 then addLine(GameTooltip, sourceIDs, kinds.source) end
				if #itemIDs ~= 0 then addLine(GameTooltip, itemIDs, kinds.item) end
			end)
		end
	end)

end





