local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not C.Theme.reskin_blizz then return end

	local iconsize = 32
	local width = 140
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

		frame.bg = F.CreateBDFrame(frame, nil, true)
		F.CreateTex(frame.bg)

		local iconFrame = CreateFrame('Frame', nil, frame)
		iconFrame:SetHeight(iconsize)
		iconFrame:SetWidth(iconsize)
		iconFrame:SetFrameStrata('HIGH')
		iconFrame:SetFrameLevel(20)
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

		local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
		icon:SetTexCoord(unpack(C.TexCoord))
		icon:SetPoint('TOPLEFT', C.Mult, -C.Mult)
		icon:SetPoint('BOTTOMRIGHT', -C.Mult, C.Mult)
		F.CreateBDFrame(icon, nil, true)
		frame.icon = icon

		local count = F.CreateFS(iconFrame, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, true, 'TOP', 1, -2)
		frame.count = count

		local name = F.CreateFS(frame, C.Assets.Fonts.Normal, 12, true)
		name:SetPoint('RIGHT', frame)
		name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
		name:SetJustifyH('LEFT')
		name:SetNonSpaceWrap(true)
		frame.name = name

		return frame
	end

	local anchorSlots = function(self)
		local shownSlots = 0
		for i=1, #self.slots do
			local frame = self.slots[i]
			if(frame:IsShown()) then
				shownSlots = shownSlots + 1

				frame:SetPoint('TOP', loot, 4, (-8 + iconsize) - (shownSlots * (iconsize+4)))
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
						slot.bg:SetBackdropColor(.5, .5, 0)
						slot.name:SetTextColor(1, 1, 0)
					elseif questId or isQuestItem then
						slot.bg:SetBackdropColor(.5, .5, 0)
						slot.name:SetTextColor(color.r, color.g, color.b)
					else
						slot.bg:SetBackdropColor(0, 0, 0)
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

	

	--[[ LootFramePortraitOverlay:Hide()

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		local ic = _G["LootButton"..index.."IconTexture"]
		if not ic then return end

		if not ic.bg then
			local bu = _G["LootButton"..index]

			_G["LootButton"..index.."IconQuestTexture"]:SetAlpha(0)
			_G["LootButton"..index.."NameFrame"]:Hide()

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			bu.IconBorder:SetAlpha(0)

			local bd = F.CreateBDFrame(bu, .25)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT", 114, 0)

			ic.bg = F.ReskinIcon(ic)
		end

		if select(7, GetLootSlotInfo(index)) then
			ic.bg:SetBackdropBorderColor(1, 1, 0)
		else
			ic.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	LootFrameDownButton:ClearAllPoints()
	LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
	LootFramePrev:ClearAllPoints()
	LootFramePrev:SetPoint("LEFT", LootFrameUpButton, "RIGHT", 4, 0)
	LootFrameNext:ClearAllPoints()
	LootFrameNext:SetPoint("RIGHT", LootFrameDownButton, "LEFT", -4, 0)

	F.ReskinPortraitFrame(LootFrame)
	F.ReskinArrow(LootFrameUpButton, "up")
	F.ReskinArrow(LootFrameDownButton, "down") ]]

	-- Bonus roll

	--[[ do
		local frame = BonusRollFrame

		frame.Background:SetAlpha(0)
		frame.IconBorder:Hide()
		frame.BlackBackgroundHoist.Background:Hide()
		frame.SpecRing:SetAlpha(0)
		frame.SpecIcon:SetPoint("TOPLEFT", 5, -5)
		local bg = F.ReskinIcon(frame.SpecIcon)
		hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
			bg:SetShown(frame.SpecIcon:IsShown())
		end)

		F.ReskinIcon(frame.PromptFrame.Icon)
		frame.PromptFrame.Timer.Bar:SetTexture(C.Assets.norm_tex)
		F.SetBD(frame)
		F.CreateBDFrame(frame.PromptFrame.Timer, .25)

		local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
		BONUS_ROLL_COST = BONUS_ROLL_COST:gsub(from, to)
		BONUS_ROLL_CURRENT_COUNT = BONUS_ROLL_CURRENT_COUNT:gsub(from, to)
	end ]]

	-- Loot Roll Frame

	--[[ hooksecurefunc("GroupLootFrame_OpenNewFrame", function()
		for i = 1, NUM_GROUP_LOOT_FRAMES do
			local frame = _G["GroupLootFrame"..i]
			if not frame.styled then
				frame.Border:SetAlpha(0)
				frame.Background:SetAlpha(0)
				frame.bg = F.CreateBDFrame(frame, nil, true)

				frame.Timer.Bar:SetTexture(C.Assets.bd_tex)
				frame.Timer.Bar:SetVertexColor(1, .8, 0)
				frame.Timer.Background:SetAlpha(0)
				F.CreateBDFrame(frame.Timer, .25)

				frame.IconFrame.Border:SetAlpha(0)
				F.ReskinIcon(frame.IconFrame.Icon)

				local bg = F.CreateBDFrame(frame, .25)
				bg:SetPoint("TOPLEFT", frame.IconFrame.Icon, "TOPRIGHT", 0, 1)
				bg:SetPoint("BOTTOMRIGHT", frame.IconFrame.Icon, "BOTTOMRIGHT", 150, -1)

				frame.styled = true
			end

			if frame:IsShown() then
				local _, _, _, quality = GetLootRollItemInfo(frame.rollID)
				local color = C.QualityColors[quality]
				frame.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end) ]]
end)