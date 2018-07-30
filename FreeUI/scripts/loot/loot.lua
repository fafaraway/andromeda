-- Butsu by Haste, heavily modified by Alza

--[[-------------------------------------------------------------------------
  Copyright (c) 2007-2008, Trond A Ekseth
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of Butsu nor the names of its contributors may
        be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

local F, C, L = unpack(select(2, ...))

local iconsize = 32
local width = 200
local sq, ss, sn, st

local lootFont = {
		C.font.normal,
		12,
		"OUTLINE"
	}

local addon = CreateFrame("Button", "Butsu", UIParent)
addon:SetFrameStrata("HIGH")
addon:SetClampedToScreen(true)
addon:SetWidth(width)
addon:SetHeight(64)

addon.slots = {}

local OnEnter = function(self)
	local slot = self:GetID()
	if GetLootSlotType(slot) == LOOT_SLOT_ITEM then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		st = self.icon:GetTexture()

		LootFrame.selectedLootButton = self:GetName();
		LootFrame.selectedSlot = ss;
		LootFrame.selectedQuality = sq;
		LootFrame.selectedItemName = sn;
		LootFrame.selectedTexture = st;

		LootSlot(ss)
	end
end

local createSlot = function(id)
	local frame = CreateFrame("Button", "ButsuSlot"..id, addon)
	frame:SetPoint("TOP", addon, 0, -((id-1)*(iconsize+1)))
	frame:SetPoint("RIGHT")
	frame:SetPoint("LEFT")
	frame:SetHeight(24)
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(20)
	frame:SetID(id)
	addon.slots[id] = frame

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	bg:SetFrameLevel(frame:GetFrameLevel()-1)
	F.CreateBD(bg)
	F.CreateSD(bg)
	frame.bg = bg

	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:SetFrameStrata("HIGH")
	iconFrame:SetFrameLevel(20)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("RIGHT", frame, "LEFT", -2, 0)

	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetTexCoord(.08, .92, .08, .92)
	icon:SetPoint("TOPLEFT", 1, -1)
	icon:SetPoint("BOTTOMRIGHT", -1, 1)
	F.CreateBG(icon)
	frame.icon = icon

	local count = F.CreateFS(iconFrame, C.FONT_SIZE_NORMAL, "CENTER")
	count:SetPoint("TOP", iconFrame, 1, -2)
	count:SetText(1)
	frame.count = count

	local name = F.CreateFS(frame, C.FONT_SIZE_NORMAL, "LEFT")
	name:SetPoint("RIGHT", frame)
	name:SetPoint("LEFT", icon, "RIGHT", 8, 0)
	name:SetNonSpaceWrap(true)

	if C.client == "zhCN" or C.client == "zhTW" then
		name:SetFont(unpack(lootFont))
	end

	frame.name = name

	return frame
end

local anchorSlots = function(self)
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint("TOP", addon, 4, (-8 + iconsize) - (shownSlots * (iconsize+1)))
		end
	end

	self:SetHeight(math.max(shownSlots * iconsize + 16, 20))
end

addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in next, self.slots do
		v:Hide()
	end
end

addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	--local items = GetNumLootItems()

	local x, y = GetCursorPosition()
	x = x / self:GetEffectiveScale()
	y = y / self:GetEffectiveScale()

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x-40, y+20)
	self:Raise()

	local maxQuality = 0
	local items = GetNumLootItems()

	if(items > 0) then
		for i = 1, items do
			local slot = addon.slots[i] or createSlot(i)
			--local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
			if lootIcon then
				local color = ITEM_QUALITY_COLORS[lootQuality]
				local r, g, b = color.r, color.g, color.b

				if GetLootSlotType(i) == LOOT_SLOT_MONEY then
					lootName = lootName:gsub("\n", ", ")
				end

				if lootQuantity and lootQuantity > 1 then
					slot.count:SetText(lootQuantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end



				--if(quantity > 1) then
				--	slot.count:SetText(quantity)
				--	slot.count:Show()
				--else
				--	slot.count:Hide()
				--end

				--slot.quality = quality

				--local color = ITEM_QUALITY_COLORS[quality]

				if questId and not isActive then
					slot.bg:SetBackdropColor(.5, .5, 0, .5)
					slot.name:SetTextColor(1, 1, 0)
				elseif questId or isQuestItem then
					slot.bg:SetBackdropColor(.5, .5, 0, .5)
					slot.name:SetTextColor(color.r, color.g, color.b)
				else
					slot.bg:SetBackdropColor(0, 0, 0, .5)
					slot.name:SetTextColor(color.r, color.g, color.b)
				end

				--slot.name:SetText(item)
				--slot.icon:SetTexture(texture)

				slot.lootQuality = lootQuality
				slot.isQuestItem = isQuestItem

				slot.name:SetText(lootName)
				slot.icon:SetTexture(lootIcon)

				maxQuality = math.max(maxQuality, lootQuality)

				slot:Enable()
				slot:Show()
			end
		end
	else
		self:Hide()
	end

	anchorSlots(self)
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end
	addon.slots[slot]:Hide()
	anchorSlots(self)
end

addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	MasterLooterFrame_UpdatePlayers()
end

addon:SetScript("OnEvent", function(self, event, arg1) self[event](self, event, arg1) end)

addon:RegisterEvent"LOOT_OPENED"
addon:RegisterEvent"LOOT_SLOT_CLEARED"
addon:RegisterEvent"LOOT_CLOSED"
addon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
addon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
addon:Hide()

LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "Butsu")