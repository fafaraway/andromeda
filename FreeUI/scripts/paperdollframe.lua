if (type(LibItemLevel) ~= "table") then return end
local F, C, L = unpack(select(2, ...))

local _, _G = _, _G
local LIL = LibItemLevel

local r, g, b = C.r, C.g, C.b

local f = _G.CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

local function PaperDollItemInfo(self, unit)
	local id = self:GetID()
    if (id == 4 or id > 17) then return end
	if (not self.ilvl) then
		self.ilvl = self:CreateFontString(nil, "OVERLAY")
		F.SetFS(self.ilvl)
		self.ilvl:SetPoint("BOTTOMRIGHT", 1, 1)
	end
	self.ilvl:SetText("")
    if (unit and self.hasItem) then
		local itemLevel, Unknow, itemRarity = LIL:GetUnitItemInfo(unit, id)
		if (itemLevel and Unknow == 0 and itemLevel > 0) then
			self.ilvl:SetTextColor(_G.ITEM_QUALITY_COLORS[itemRarity].r, _G.ITEM_QUALITY_COLORS[itemRarity].g, _G.ITEM_QUALITY_COLORS[itemRarity].b)
			self.ilvl:SetText(itemLevel)
		end
	end
    if (unit == "player") then
		if (id == 2 or (id > 10 and id < 16)) then return end
		if (not self.dura) then
			self.dura = self:CreateFontString(nil, "OVERLAY")
			F.SetFS(self.dura)
			self.dura:SetPoint("TOPLEFT", 2, -1.5)
		end
		self.dura:SetText("")
		local v1, v2, dura = GetInventoryItemDurability(id)
		if v1 and v2 and v2 ~= 0 then dura = v1 / v2 end
		if (dura and dura < 0.5) then
			local relperc = dura * 2 % 1
			self.dura:SetTextColor(1, relperc, 0)
			self.dura:SetText(format("%d%%", dura * 100))
		end
	elseif (id > 15 and GetInventoryItemTexture(unit, 17)) then
		local mainhand, _, mainhandRarity = LIL:GetUnitItemInfo(unit, 16)
		local offhand, _, offhandRarity = LIL:GetUnitItemInfo(unit, 17)
		if (mainhandRarity == 6 or offhandRarity == 6) then
			self.ilvl:SetText(max(mainhand, offhand))
		end
	end
end

f:SetScript("OnEvent", function(self, event, arg1)
    if (arg1 == "Blizzard_InspectUI") then
        self:UnregisterAllEvents()
        _G.hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(self)
            PaperDollItemInfo(self, InspectFrame.unit)
        end)
    end
end)

_G.hooksecurefunc("PaperDollItemSlotButton_Update", function(self)
    PaperDollItemInfo(self, "player")
end)

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
