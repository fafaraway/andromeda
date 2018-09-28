local F, C, L = unpack(select(2, ...))
local module = F:GetModule("misc")
local tipModule = F:GetModule("tooltip")


local itemLevelString = _G["ITEM_LEVEL"]:gsub("%%d", "")
local ItemDB = {}
function module:GetUnitItemLevel(link, unit, index, quality)
	if ItemDB[link] and quality ~= 6 then return ItemDB[link] end

	local tip = _G["FreeUIItemLevelTooltip"] or CreateFrame("GameTooltip", "FreeUIItemLevelTooltip", nil, "GameTooltipTemplate")
	tip:SetOwner(UIParent, "ANCHOR_NONE")
 	tip:SetInventoryItem(unit, index)

	for i = 2, 5 do
		local text = _G[tip:GetName().."TextLeft"..i]:GetText() or ""
		local hasLevel = string.find(text, itemLevelString)
		if hasLevel then
			local level = string.match(text, "(%d+)%)?$")
			ItemDB[link] = tonumber(level)
			break
		end
	end
	return ItemDB[link]
end

function module:ShowItemLevel()

	local SLOTIDS = {}
	for _, slot in pairs({"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand", "SecondaryHand"}) do
		SLOTIDS[slot] = GetInventorySlotInfo(slot.."Slot")
	end

	local myString = setmetatable({}, {
		__index = function(t, i)
			local gslot = _G["Character"..i.."Slot"]
			if not gslot then return end
			local fstr = F.CreateFS(gslot, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
			fstr:SetPoint("BOTTOMRIGHT", 0, 2)
			t[i] = fstr
			return fstr
		end
	})

	local tarString = setmetatable({}, {
		__index = function(t, i)
			local gslot = _G["Inspect"..i.."Slot"]
			if not gslot then return end
			local fstr = F.CreateFS(gslot, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
			fstr:SetPoint("BOTTOMRIGHT", 0, 2)
			t[i] = fstr
			return fstr
		end
	})

	local function SetupItemLevel(unit, strType)
		if not UnitExists(unit) then return end

		for slot, index in pairs(SLOTIDS) do
			local str = strType[slot]
			if not str then return end
			str:SetText("")

			local link = GetInventoryItemLink(unit, index)
			if link and index ~= 4 then
				local _, _, quality, level = GetItemInfo(link)
				level = self:GetUnitItemLevel(link, unit, index, quality) or level

				if level and level > 1 and quality then
					local color = BAG_ITEM_QUALITY_COLORS[quality]
					str:SetText(level)
					str:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end

	hooksecurefunc("PaperDollItemSlotButton_OnShow", function()
		SetupItemLevel("player", myString)
	end)

	hooksecurefunc("PaperDollItemSlotButton_OnEvent", function(self, event, id)
		if event == "PLAYER_EQUIPMENT_CHANGED" and self:GetID() == id then
			SetupItemLevel("player", myString)
		end
	end)

	F:RegisterEvent("INSPECT_READY", function(_, ...)
		local guid = ...
		if InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == guid then
			SetupItemLevel(InspectFrame.unit, tarString)
		end
	end)

	-- 
	F.SetFS(_G.CharacterNeckSlot.RankFrame.Label)
	_G.CharacterNeckSlot.RankFrame.Label:ClearAllPoints()
	_G.CharacterNeckSlot.RankFrame.Label:SetPoint("TOPLEFT", 0, -4)


	-- ilvl on scrapping machine
	local function updateMachineLevel(self)
		if not self.iLvl then
			self.iLvl = F.CreateFS(self, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
			self.iLvl:SetPoint("BOTTOMRIGHT", 0, 2)
		end
		if not self.itemLink then self.iLvl:SetText("") return end

		local quality = 1
		if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
			quality = self.item:GetItemQuality()
		end
		local level = tipModule:GetItemLevel(self.itemLink, quality)
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		self.iLvl:SetText(level)
		self.iLvl:SetTextColor(color.r, color.g, color.b)
	end

	local function itemLevelOnScrapping(event, addon)
		if addon == "Blizzard_ScrappingMachineUI" then
			for button in pairs(ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
				hooksecurefunc(button, "RefreshIcon", updateMachineLevel)
			end

			F:UnregisterEvent(event, itemLevelOnScrapping)
		end
	end
	F:RegisterEvent("ADDON_LOADED", itemLevelOnScrapping)



	--- Character Info Sheet ---
	_G.hooksecurefunc("PaperDollFrame_SetArmor", function(_, unit)
		if (unit ~= "player") then return end

		if ( _G.UnitLevel("player") >= _G.MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY ) then

			local total, equip = GetAverageItemLevel()
			if (total > 0) then total = format("%.1f", total) end
			if (equip > 0) then equip = format("%.1f", equip) end

			local itemLevel = equip
			if (equip ~= total) then
				itemLevel = equip.." / "..total
			end

			PaperDollFrame_SetItemLevel(CharacterStatsPane.ItemLevelFrame, unit)
			-- CharacterStatsPane.ItemLevelCategory:Show()
			-- CharacterStatsPane.ItemLevelFrame:Show()
			CharacterStatsPane.ItemLevelFrame.Value:SetText(itemLevel)
			-- CharacterStatsPane.AttributesCategory:SetPoint("TOP", CharacterStatsPane.ItemLevelFrame, "BOTTOM", 0, -10)
		
		end
	end)
end
