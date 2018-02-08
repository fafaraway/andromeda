---------------------------------
-- 物品信息庫 Author: M
---------------------------------
local REVISION = 2
if (type(LibItemLevel) == "table" and REVISION <= LibItemLevel.REVISION) then return end

LibItemLevel = LibItemLevel or {}
local LIL = LibItemLevel
LIL.REVISION = REVISION
LIL.ItemTip = LIL.ItemTip or CreateFrame("GameTooltip", "LibItemLevelItemTip", nil, "GameTooltipTemplate")
LIL.UnitTip = LIL.UnitTip or CreateFrame("GameTooltip", "LibItemLevelUnitTip", nil, "GameTooltipTemplate")
LIL.ItemTip:SetOwner(UIParent,"ANCHOR_NONE")
LIL.UnitTip:SetOwner(UIParent,"ANCHOR_NONE")
LIL.ItemDB = LIL.ItemDB or {}

local PVP_ITEM_PATTERN
local locale = GetLocale()
if (locale == "zhCN") then
	PVP_ITEM_PATTERN = "第%d赛季"
elseif (locale == "zhTW") then
	PVP_ITEM_PATTERN = "第%d季"
else
	PVP_ITEM_PATTERN = "Season %d"
end

local function hasLocally(itemID)
	if (not itemID or itemID == "" or itemID == "0") then return true end
	return select(10, GetItemInfo(tonumber(itemID)))
end

--物品是否本地化
function LIL:ItemLocally(itemLink)
	local id, gem1, gem2, gem3 = string.match(itemLink, "item:(%d+):[^:]*:(%d-):(%d-):(%d-):")
	if (hasLocally(id) and hasLocally(gem1) and hasLocally(gem2) and hasLocally(gem3)) then return true end
end

--获取物品实际信息
function LIL:GetActualItemInfo(itemLink)
	if (not itemLink or itemLink == "") then return end

	if (LIL.ItemDB[itemLink]) then
		return LIL.ItemDB[itemLink].Level, 0, LIL.ItemDB[itemLink].Rarity, LIL.ItemDB[itemLink].Slot, LIL.ItemDB[itemLink].PVP
	end

	if (not LIL:ItemLocally(itemLink)) then return 0, 1 end

	if (not LIL.LVLPattern) then LIL.LVLPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)") end
	if (not LIL.PVPPattern) then LIL.PVPPattern = gsub(PVP_ITEM_PATTERN, "%%d", "(%%d+)") end

	LIL.ItemTip:ClearLines()
	LIL.ItemTip:SetHyperlink(itemLink)

	local _, _, itemRarity, itemLevel, _, _, _, _, itemSlot = GetItemInfo(itemLink)
	local text, LVL, PVP

	for i = 2, 5 do
		text = _G["LibItemLevelItemTipTextLeft"..i]:GetText()
		if (not text) then break end
		if (i == 2) then PVP = strmatch(text, LIL.PVPPattern) end
		LVL = tonumber(strmatch(text, LIL.LVLPattern))
		if (LVL) then break end
	end

	if (LVL and itemRarity ~= 7) then
		LIL.ItemDB[itemLink] = {
			Level = LVL,
			Rarity = itemRarity,
			Slot = itemSlot,
			PVP = PVP,
		}
	end

	return LVL or itemLevel or 0, 0, itemRarity, itemSlot, PVP
end

--获取UNIT物品实际信息
function LIL:GetUnitItemInfo(unit, index)
	LIL.UnitTip:ClearLines()
	LIL.UnitTip:SetInventoryItem(unit, index)

	local itemLink = select(2, LIL.UnitTip:GetItem())

	if (not itemLink or itemLink == "") then return end

	if (LIL.ItemDB[itemLink]) then
		return LIL.ItemDB[itemLink].Level, 0, LIL.ItemDB[itemLink].Rarity, LIL.ItemDB[itemLink].Slot, LIL.ItemDB[itemLink].PVP
	end

	if (not LIL:ItemLocally(itemLink)) then return 0, 1 end

	if (not LIL.LVLPattern) then LIL.LVLPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)") end
	if (not LIL.PVPPattern) then LIL.PVPPattern = gsub(PVP_ITEM_PATTERN, "%%d", "(%%d+)") end

	local _, _, itemRarity, itemLevel, _, _, _, _, itemSlot = GetItemInfo(itemLink)
	local text, LVL, PVP

	for i = 2, 5 do
		text = _G["LibItemLevelUnitTipTextLeft"..i]:GetText()
		if (not text) then break end
		if (i == 2) then PVP = strmatch(text, LIL.PVPPattern) end
		LVL = tonumber(strmatch(text, LIL.LVLPattern))
		if (LVL) then break end
	end

	if (LVL and itemRarity ~= 7) then
		LIL.ItemDB[itemLink] = {
			Level = LVL,
			Rarity = itemRarity,
			Slot = itemSlot,
			PVP = PVP,
		}
	end

	return LVL or itemLevel or 0, 0, itemRarity, itemSlot, PVP
end

--获取UNIT的装备等级
function LIL:GetUnitItemLevel(unit)
	local level, count, quality, slot, isPVP
	local avg, total, unknown, boa, pvp = 0, 0, 0, 0, 0
	local weapon, weapons, twohand, mainhand = {0, 0}, 0, 0

	for i = 1, 17 do
		if (i ~= 4) then
			level, count, quality, slot, isPVP = LIL:GetUnitItemInfo(unit, i)

			if (level) then
				if (quality == 7) then boa = boa + 1 end
				if (isPVP) then pvp = pvp + 1 end
				unknown = unknown + count

				if (i < 16) then
					total = total + level
				elseif (i == 16) then
					weapon[1] = level
					weapons = weapons + 1
					if (quality == 6) then
						twohand = 2
					elseif (slot == "INVTYPE_2HWEAPON" or slot == "INVTYPE_RANGED" or slot == "INVTYPE_RANGEDRIGHT") then
						mainhand = true
						twohand = twohand + 1
					end
				else
					weapon[2] = level
					weapons = weapons + 1
					if (quality == 6) then
						twohand = 2
					elseif (slot == "INVTYPE_2HWEAPON") then
						twohand = twohand + 1
					end
				end
			end
		end
	end

	if (twohand == 2) then
		total = total + max(weapon[1], weapon[2]) * 2
	elseif (twohand == 1 and weapons == 1) then
		if (mainhand) then
			total = total + weapon[1] * 2
		else
			total = total + weapon[2] * 2
		end
	elseif (twohand == 1 and weapons == 2) then
		if (mainhand) then
			if (weapon[1] >= weapon[2]) then
				total = total + weapon[1] * 2
			else
				total = total + weapon[1] + weapon[2]
			end
		else
			if (weapon[2] >= weapon[1]) then
				total = total + weapon[2] * 2
			else
				total = total + weapon[1] + weapon[2]
			end
		end
	else
		total = total + weapon[1] + weapon[2]
	end

	avg = total / (16 - unknown)
	return avg, unknown, boa, pvp
end