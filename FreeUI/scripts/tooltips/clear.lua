local _, ns = ...
local L = ns.L


local db = {
	bonusColor = { 0, 1, 0 },
	enchantColor = { 0, 0.8, 1 },
	hideAppearanceKnown = true,
	hideAppearanceUnknown = false,
	hideBlank = true,
	hideCraftingReagent = false,
	hideDurability = true,
	hideEnchantLabel = true,
	hideEquipmentSets = false,
	hideFlavorTrade = true,
	hideFlavor = true,
	hideItemLevel = false,
	hideMadeBy = true,
	hideRaidDifficulty = true,
	hideRequirements = true,
	hideRequirementsMet = true,
	hideRightClickBuy = true,
	hideRightClickSocket = true,
	hideSellValue = true,
	hideSetBonuses = false,
	hideSetBonusesLegacy = true,
	hideSetItems = false,
	hideSoulbound = false,
	hideTransmog = true,
	hideTransmogLabelOnly = true,
	hideUnique = false,
	hideUnusedStats = true,
	hideUpgradeLevel = false,
}


local format, gsub, ipairs, strfind, strmatch, unpack = format, gsub, ipairs, strfind, strmatch, unpack

local raidDifficultyLabels = {
	[PLAYER_DIFFICULTY1] = true, -- Normal
	[PLAYER_DIFFICULTY2] = true, -- Heroic
	[PLAYER_DIFFICULTY3] = true, -- Raid Finder
	[PLAYER_DIFFICULTY4] = true, -- Flexible
	[PLAYER_DIFFICULTY5] = true, -- Challenge
	[PLAYER_DIFFICULTY6] = true, -- Mythic
}

local function topattern(str)
	str = gsub(str, "%%%d?$?c", ".+")
	str = gsub(str, "%%%d?$?d", "%%d+")
	str = gsub(str, "%%%d?$?s", ".+")
	str = gsub(str, "([%(%)])", "%%%1")
	return "^" .. str
end

local APPEARANCE_KNOWN       = TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN
local APPEARANCE_KNOWN_OTHER = TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN
local APPEARANCE_UNKNOWN     = TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN
local CRAFTING_REAGENT       = PROFESSIONS_USED_IN_COOKING
local CRAFTING_REAGENT_COLOR = "|cFF66BBFF" .. PROFESSIONS_USED_IN_COOKING .. "|r"
local ITEM_SET_LEGACY        = ITEM_SET_LEGACY_INACTIVE_BONUS
local ITEM_SOCKETABLE        = ITEM_SOCKETABLE
local ITEM_SOULBOUND         = ITEM_SOULBOUND
local ITEM_UNIQUE            = ITEM_UNIQUE
local ITEM_UNIQUE_EQUIPPABLE = ITEM_UNIQUE_EQUIPPABLE
local ITEM_VENDOR_STACK_BUY  = ITEM_VENDOR_STACK_BUY
local TRANSMOGRIFIED_HEADER  = TRANSMOGRIFIED_HEADER

local S_DURABILITY           = topattern(DURABILITY_TEMPLATE)
local S_ENCHANTED            = "^" .. gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
local S_FLAVOR               = '^".+"$'
local S_ITEM_LEVEL           = topattern(ITEM_LEVEL)
local S_ITEM_SET_BONUS       = topattern(ITEM_SET_BONUS)
local S_ITEM_SET_BONUS_GRAY  = topattern(ITEM_SET_BONUS_GRAY)
local S_ITEM_SET_NAME        = topattern(ITEM_SET_NAME)
local S_MADE_BY              = topattern(ITEM_CREATED_BY)
local S_REQ_CLASS            = topattern(ITEM_CLASSES_ALLOWED)
local S_REQ_LEVEL            = topattern(ITEM_MIN_LEVEL)
local S_REQ_RACE             = topattern(ITEM_RACES_ALLOWED)
local S_REQ_REPUTATION       = topattern(ITEM_REQ_REPUTATION)
local S_REQ_SKILL            = topattern(ITEM_REQ_SKILL)
local S_UNIQUE_MULTIPLE      = topattern(ITEM_UNIQUE_MULTIPLE)
local S_UPGRADE_LEVEL        = topattern(ITEM_UPGRADE_TOOLTIP_FORMAT)

local TRADE_GOODS            = AUCTION_CATEGORY_TRADE_GOODS


local cache = setmetatable({}, { __mode = "kv" }) -- weak table to enable garbage collection
ns.cache = cache -- so it can be wiped when an option changes

local inSetList, inTransmogInfo, isLegacySet
local tooltipHeight = {}

local blanks = {
	[" "] = true,
	["|cFF 0FF 0|r"] = true, -- game bug? appears as a blank line, ex: Breastplate of Wracking Souls
}



local function ReformatLine(tooltip, line, text)
	if blanks[text] and db.hideBlank then
		if tooltip.shownMoneyFrames then
			for i = 1, tooltip.shownMoneyFrames do
				local _, left = _G[tooltip:GetName().."MoneyFrame"..i]:GetPoint("LEFT")
				if left == line then
					return
				end
			end
		end
		-- can't cache this because it breaks the money display
		line:SetText("")
	return end

	if cache[text] then
		-- can't cache blank lines so check that first
		line:SetText(cache[text])
	return end

	local enchant = strmatch(text, S_ENCHANTED)
	if enchant then
		-- no cache for colors yet
		local color = db.enchantColor
		line:SetTextColor(color[1], color[2], color[3])
		if db.hideEnchantLabel then
			line:SetText(enchant)
		end
	return end

	if inTransmogInfo then
		inTransmogInfo = nil
		if not db.hideTransmogLabelOnly then
			-- It seems safe to cache this, since we never look at
			-- line1, and item names don't (?) appear in any other
			-- context in tooltips without some kind of decoration,
			-- eg. in set item lists they're indented with a space.
			cache[text] = ""
			line:SetText("")
		end
		return
	elseif text == TRANSMOGRIFIED_HEADER and db.hideTransmog then
		inTransmogInfo = true
		-- can't cache this, or we never set `inTransmogInfo`
		line:SetText("")
		return
	end

	if inSetList then
		if strfind(text, "^ .") then -- don't match " "
			--print("Found set item:", text)
			if db.hideSetItems then
				cache[text] = ""
				line:SetText("")
			end
			return
		else
			--print("End of set list:", text)
			inSetList = nil
		end
	elseif strfind(text, S_ITEM_SET_NAME) then
		--print("Found set name:", text)
		inSetList = true
		return
	end

	if text == ITEM_SET_LEGACY then
		isLegacySet = true
		if db.hideSetBonuses then
			cache[text] = ""
			line:SetText("")
		return end
	end

	if (text == ARTIFACT_LOGGED) -- no option yet
	or (text == ITEM_SOCKETABLE and db.hideRightClickSocket)
	or (text == ITEM_SOULBOUND and db.hideSoulbound)
	or (text == ITEM_VENDOR_STACK_BUY and db.hideRightClickBuy)
	or (text == APPEARANCE_UNKNOWN and db.hideAppearanceUnknown)
	or ((text == APPEARANCE_KNOWN or text == APPEARANCE_KNOWN_OTHER) and db.hideAppearanceKnown)
	or ((text == CRAFTING_REAGENT or text == CRAFTING_REAGENT_COLOR) and db.hideCraftingReagent)
	or (db.hideRaidDifficulty and raidDifficultyLabels[text])
	or (db.hideDurability and strfind(text, S_DURABILITY))
	or (db.hideItemLevel and strfind(text, S_ITEM_LEVEL))
	or (db.hideMadeBy and strfind(text, S_MADE_BY))
	or (db.hideUpgradeLevel and strfind(text, S_UPGRADE_LEVEL))
	or (db.hideUnique and (text == ITEM_UNIQUE or text == ITEM_UNIQUE_EQUIPPABLE or strfind(text, S_UNIQUE_MULTIPLE)))
	then
		cache[text] = ""
		line:SetText("")
	return end

	if db.hideSetBonuses
	and (isLegacySet or not db.hideSetBonusesLegacy)
	and (strfind(text, S_ITEM_SET_BONUS_GRAY) or strfind(text, S_ITEM_SET_BONUS)) then
		cache[text] = ""
		line:SetText("")
	return end

	if db.hideFlavor and strfind(text, S_FLAVOR) then
		local keep
		if db.hideFlavorTrade then
			local _, item = tooltip:GetItem()
			if item then
				local _, _, q, _, _, t, tt = GetItemInfo(item) -- TODO: allow on high quality stuff, fish?
				keep = t ~= TRADE_GOODS
			end
		end
		if not keep then
			cache[text] = ""
			line:SetText("")
		end
	return end

	if db.hideRequirements and (
		strfind(text, S_REQ_CLASS)
		or strfind(text, S_REQ_RACE)
		or strfind(text, S_REQ_LEVEL)
		or strfind(text, S_REQ_REPUTATION)
		or strfind(text, S_REQ_SKILL)
		--or strfind(text, ENCHANT_REQUIRES)
		--or strfind(text, SOCKET_REQUIRES)
	) then
		if db.hideRequirementsMet then
			-- hide only if met
			local r, g, b = line:GetTextColor()
			if g > 0.9 and b > 0.9 then
				cache[text] = ""
				line:SetText("")
			end
		else
			cache[text] = ""
			line:SetText("")
		end
	return end

	if strfind(text, "^%+%d+") then
		-- no cache for colors yet
		local r, g, b = line:GetTextColor()
		if r < 0.1 and g > 0.9 and b < 0.1 then
			line:SetTextColor(unpack(db.bonusColor))
		elseif r < 0.51 and g < 0.51 and b < 0.51 and db.hideUnusedStats then
			line:SetText("")
		end
	return end
end

local function ReformatItemTooltip(tooltip)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 2, tooltip:NumLines() do
		local line = textLeft[i]
		local text = line:GetText()
		if text then
			ReformatLine(tooltip, line, text)
		end
	end
	inSetList, isLegacySet = nil, nil
	tooltip:Show()
end

local function AdjustLineAnchors(tooltip)
	local textLeft = tooltip.textLeft
	if not textLeft then return end

	local numBlanks = 0
	local hasItem = tooltip:GetItem()
	local anchor = textLeft[1]
	for i = 2, tooltip:NumLines() do
		local line = textLeft[i]
		local text = line:GetText() or ""
		local point, relativeTo, relativePoint, x, y = line:GetPoint(1)
		if hasItem and text == "" then
			relativeTo = anchor
			numBlanks = numBlanks + 1
		else
			anchor = line
		end
		line:SetPoint(point, relativeTo, relativePoint, x, y)
	end
	if numBlanks > 0 then
		local height = floor(tooltip:GetHeight() - (2 * numBlanks) + 0.5)
		tooltipHeight[tooltip] = height
		tooltip:SetHeight(height)
	else
		tooltipHeight[tooltip] = nil
	end
end



local abs = math.abs
local function FixHeight(tooltip)
	local height = tooltipHeight[tooltip]
	if height and abs(tooltip:GetHeight() - height) > 2 then
		tooltip:SetHeight(height)
	end
end


local itemTooltips = {
	"GameTooltip",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"ItemRefShoppingTooltip3",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ShoppingTooltip3",
	"WorldMapCompareTooltip1",
	"WorldMapCompareTooltip2",
	"WorldMapCompareTooltip3",
}

local Loader = CreateFrame("Frame")
Loader:RegisterEvent("ADDON_LOADED")
Loader:SetScript("OnEvent", function(self, event, arg)

	-- Hook tooltips:
	for i, tooltip in pairs(itemTooltips) do
		tooltip = _G[tooltip]
		if tooltip then
			-- Hooks for removing text:
			tooltip:HookScript("OnTooltipSetItem", ReformatItemTooltip)
			-- Hooks for fixing line spacing:
			-- hooksecurefunc(tooltip, "Show", AdjustLineAnchors)
			-- tooltip:HookScript("OnUpdate", FixHeight)
			-- Done with this tooltip.
			itemTooltips[i] = nil
		end
	end
	if not next(itemTooltips) then
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
	end
end)





local showPriceFrames = {
	"AuctionFrame",
	"MerchantFrame",
	"QuestRewardPanel",
	"QuestFrameRewardPanel",
}

local prehook = GameTooltip_OnTooltipAddMoney

function GameTooltip_OnTooltipAddMoney(...)
	if not db.hideSellValue then
		return prehook(...)
	end
	for _, name in pairs(showPriceFrames) do
		local frame = _G[name]
		if frame and frame:IsShown() then
			return prehook(...)
		end
	end
end