local F, C = unpack(select(2, ...))

-- based on ItemTooltipCleaner by phanx

local module = F:GetModule("tooltip")

if not C.tooltip.clearTip then return end

if C.client == "zhCN" then
	ITEM_CREATED_BY = ""

	ITEM_LEVEL = "物品等级 %d"
	ITEM_LEVEL_ALT = "物品等级 %d (%d)"

	ARMOR_TEMPLATE = "护甲 %s"
	DAMAGE_TEMPLATE = "伤害 %s - %s"
	DPS_TEMPLATE = "每秒伤害 %s"
	DURABILITY_TEMPLATE = "耐久 %d/%d"
	SHIELD_BLOCK_TEMPLATE = "格挡 %d"

	ENCHANTED_TOOLTIP_LINE = "|cff78c2e1%s|r"

	ITEM_SOCKETABLE = ""
	ITEM_AZERITE_EMPOWERED_VIEWABLE = ""

	TRANSMOGRIFIED_HEADER = ""
	TRANSMOGRIFIED_ENCHANT = "%s"

	ITEM_MOD_CR_STURDINESS_SHORT = "|cffe1c69e永不磨损|r"
end


local format, gsub, ipairs, strfind, strmatch, unpack = format, gsub, ipairs, strfind, strmatch, unpack

local function topattern(str)
	str = gsub(str, "%%%d?$?c", ".+")
	str = gsub(str, "%%%d?$?d", "%%d+")
	str = gsub(str, "%%%d?$?s", ".+")
	str = gsub(str, "([%(%)])", "%%%1")
	return "^" .. str
end

local cache = setmetatable({}, { __mode = "kv" }) 
module.cache = cache 

local tooltipHeight = {}

local blanks = {
	[" "] = true,
	["|cFF 0FF 0|r"] = true,
}


local function ReformatLine(tooltip, line, text)
	if blanks[text] then
		if tooltip.shownMoneyFrames then
			for i = 1, tooltip.shownMoneyFrames do
				local _, left = _G[tooltip:GetName().."MoneyFrame"..i]:GetPoint("LEFT")
				if left == line then
					return
				end
			end
		end
		line:SetText("")
	return end

	if cache[text] then
		line:SetText(cache[text])
	return end

	if strfind(text, topattern(DURABILITY_TEMPLATE)) or (text == TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN or text == TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
		cache[text] = ""
		line:SetText("")
	return end

	if strfind(text, "^%+%d+") then
		local r, g, b = line:GetTextColor()
		if r < 0.1 and g > 0.9 and b < 0.1 then
			line:SetTextColor(125/255, 189/255, 150/255)
		elseif r < 0.51 and g < 0.51 and b < 0.51 then
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
	for i, tooltip in pairs(itemTooltips) do
		tooltip = _G[tooltip]
		if tooltip then
			tooltip:HookScript("OnTooltipSetItem", ReformatItemTooltip)
			itemTooltips[i] = nil
		end
	end
	if not next(itemTooltips) then
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
	end
end)


GameTooltip_OnTooltipAddMoney = F.dummy

--[[local showPriceFrames = {
	"AuctionFrame",
	"MerchantFrame",
	"QuestRewardPanel",
	"QuestFrameRewardPanel",
}

local prehook = GameTooltip_OnTooltipAddMoney

function GameTooltip_OnTooltipAddMoney(...)
	if IsShiftKeyDown() then
		return prehook(...)
	end
	for _, name in pairs(showPriceFrames) do
		local frame = _G[name]
		if frame and frame:IsShown() then
			return prehook(...)
		end
	end
end]]


