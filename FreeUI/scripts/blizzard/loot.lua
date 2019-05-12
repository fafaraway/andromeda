local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')



function BLIZZARD:Loot()
	local iconsize = 32
	local width = 200
	local sq, ss, sn, st

	local loot = CreateFrame('Button', 'FreeUILoot', UIParent)
	loot:SetFrameStrata('HIGH')
	loot:SetClampedToScreen(true)
	loot:SetWidth(width)
	loot:SetHeight(64)

	loot.slots = {}

	local OnEnter = function(self)
		local slot = self:GetID()
		if GetLootSlotType(slot) == LOOT_SLOT_ITEM then
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
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
			StaticPopup_Hide'CONFIRM_LOOT_DISTRIBUTION'
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
		local frame = CreateFrame('Button', 'FreeUILootSlot'..id, loot)
		frame:SetPoint('TOP', loot, 0, -((id-1)*(iconsize+1)))
		frame:SetPoint('RIGHT')
		frame:SetPoint('LEFT')
		frame:SetHeight(24)
		frame:SetFrameStrata('HIGH')
		frame:SetFrameLevel(20)
		frame:SetID(id)
		loot.slots[id] = frame

		frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		frame:SetScript('OnEnter', OnEnter)
		frame:SetScript('OnLeave', OnLeave)
		frame:SetScript('OnClick', OnClick)
		frame:SetScript('OnUpdate', OnUpdate)

		local bg = CreateFrame('Frame', nil, frame)
		bg:SetPoint('TOPLEFT', frame, -1, 1)
		bg:SetPoint('BOTTOMRIGHT', frame, 1, -1)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg)
		F.CreateSD(bg)
		frame.bg = bg

		local iconFrame = CreateFrame('Frame', nil, frame)
		iconFrame:SetHeight(iconsize)
		iconFrame:SetWidth(iconsize)
		iconFrame:SetFrameStrata('HIGH')
		iconFrame:SetFrameLevel(20)
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

		local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
		icon:SetTexCoord(unpack(C.TexCoord))
		icon:SetPoint('TOPLEFT', 1, -1)
		icon:SetPoint('BOTTOMRIGHT', -1, 1)
		F.CreateBDFrame(icon)
		F.CreateSD(icon)
		frame.icon = icon

		local count = F.CreateFS(iconFrame, 'pixel', '', 'CENTER', nil, true, 'TOP', 1, -2)
		--count:SetJustifyH('CENTER')
		--count:SetPoint('TOP', iconFrame, 1, -2)
		--count:SetText(1)
		frame.count = count

		local name = F.CreateFS(frame, 'pixel', '', 'LEFT', nil, true)
		--name:SetJustifyH('LEFT')
		name:SetPoint('RIGHT', frame)
		name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
		name:SetNonSpaceWrap(true)

		if C.Client == 'zhCN' or C.Client == 'zhTW' then
			name:SetFont(C.font.normal, 12, 'OUTLINE')
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

				frame:SetPoint('TOP', loot, 4, (-8 + iconsize) - (shownSlots * (iconsize+1)))
			end
		end

		self:SetHeight(math.max(shownSlots * iconsize + 16, 20))
	end

	loot:SetScript('OnHide', function(self)
		StaticPopup_Hide'CONFIRM_LOOT_DISTRIBUTION'
		CloseLoot()
	end)

	loot.LOOT_CLOSED = function(self)
		StaticPopup_Hide'LOOT_BIND'
		self:Hide()

		for _, v in next, self.slots do
			v:Hide()
		end
	end

	loot.LOOT_OPENED = function(self, event, autoloot)
		self:Show()

		if(not self:IsShown()) then
			CloseLoot(not autoLoot)
		end

		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint('TOPLEFT', nil, 'BOTTOMLEFT', x-40, y+20)
		self:Raise()

		local maxQuality = 0
		local items = GetNumLootItems()

		if(items > 0) then
			for i = 1, items do
				local slot = loot.slots[i] or createSlot(i)
				local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
				if lootIcon then
					local color = ITEM_QUALITY_COLORS[lootQuality]
					local r, g, b = color.r, color.g, color.b

					if GetLootSlotType(i) == LOOT_SLOT_MONEY then
						lootName = lootName:gsub('\n', ', ')
					end

					if lootQuantity and lootQuantity > 1 then
						slot.count:SetText(lootQuantity)
						slot.count:Show()
					else
						slot.count:Hide()
					end

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

	loot.LOOT_SLOT_CLEARED = function(self, event, slot)
		if(not self:IsShown()) then return end
		loot.slots[slot]:Hide()
		anchorSlots(self)
	end

	loot.OPEN_MASTER_LOOT_LIST = function(self)
		ToggleDropDownMenu(1, nil, GroupLootDropDown, loot.slots[ss], 0, 0)
	end

	loot.UPDATE_MASTER_LOOT_LIST = function(self)
		MasterLooterFrame_UpdatePlayers()
	end

	loot:SetScript('OnEvent', function(self, event, arg1) self[event](self, event, arg1) end)

	loot:RegisterEvent'LOOT_OPENED'
	loot:RegisterEvent'LOOT_SLOT_CLEARED'
	loot:RegisterEvent'LOOT_CLOSED'
	loot:RegisterEvent'OPEN_MASTER_LOOT_LIST'
	loot:RegisterEvent'UPDATE_MASTER_LOOT_LIST'
	loot:Hide()

	LootFrame:UnregisterAllEvents()
	table.insert(UISpecialFrames, 'FreeUILoot')
end