local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('INFOBAR')


local format, gsub, sort, floor, modf, select = string.format, string.gsub, table.sort, math.floor, math.modf, select
local GetInventoryItemLink, GetInventoryItemDurability, GetInventoryItemTexture = GetInventoryItemLink, GetInventoryItemDurability, GetInventoryItemTexture
local GetMoneyString, GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair = GetMoneyString, GetMoney, GetRepairAllCost, RepairAllItems, CanMerchantRepair
local GetAverageItemLevel, IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney = GetAverageItemLevel, IsInGuild, CanGuildBankRepair, GetGuildBankWithdrawMoney
local C_Timer_After, IsShiftKeyDown, InCombatLockdown, CanMerchantRepair = C_Timer.After, IsShiftKeyDown, InCombatLockdown, CanMerchantRepair

local FreeUIDurabilityButton = INFOBAR.FreeUIDurabilityButton

local localSlots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_CHEST, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, INVTYPE_HAND, 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, INVTYPE_FEET, 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000}
}

local function getItemDurability()
	local numSlots = 0
	for i = 1, 10 do
		if GetInventoryItemLink('player', localSlots[i][1]) then
			local current, max = GetInventoryItemDurability(localSlots[i][1])
			if current then
				localSlots[i][3] = current/max
				numSlots = numSlots + 1
			end
		else
			localSlots[i][3] = 1000
		end
	end
	sort(localSlots, function(a, b) return a[3] < b[3] end)

	return numSlots
end

local function isLowDurability()
	for i = 1, 10 do
		if localSlots[i][3] < .25 then
			return true
		end
	end
end

local function gradientColor(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = modf(perc*2)
	local r1, g1, b1, r2, g2, b2 = select(seg*3+1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1+(r2-r1)*relperc, g1+(g2-g1)*relperc, b1+(b2-b1)*relperc
	return format('|cff%02x%02x%02x', r*255, g*255, b*255), r, g, b
end


function INFOBAR:Durability()
	if not C.DB.infobar.durability then return end

	FreeUIDurabilityButton = INFOBAR:addButton('', INFOBAR.POSITION_RIGHT, 150, function(self, button)
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleCharacter('PaperDollFrame')
	end)

	FreeUIDurabilityButton:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
	FreeUIDurabilityButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIDurabilityButton:SetScript('OnEvent', function(self, event)
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		if event == 'PLAYER_REGEN_ENABLED' then
			self:UnregisterEvent(event)
			self:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
			getItemDurability()
			if isLowDurability() then inform:Show() end
		else
			local numSlots = getItemDurability()
			if numSlots > 0 then
				self.Text:SetText(format(gsub(L['INFOBAR_DURABILITY']..': [color]%d|r%%', '%[color%]', (gradientColor(floor(localSlots[1][3]*100)/100))), floor(localSlots[1][3]*100)))
			else
				self.Text:SetText(L['INFOBAR_DURABILITY']..': '..C.InfoColor..NONE)
			end
		end
	end)

	FreeUIDurabilityButton:HookScript('OnEnter', function(self)
		local total, equipped = GetAverageItemLevel()
		GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -15) or 15)
		GameTooltip:ClearLines()
		--GameTooltip:AddDoubleLine(DURABILITY, format('%s: %d/%d', STAT_AVERAGE_ITEM_LEVEL, equipped, total), .9, .8, .6, 1,1,1)
		GameTooltip:AddLine(DURABILITY, .9, .8, .6)
		GameTooltip:AddLine(' ')

		for i = 1, 10 do
			if localSlots[i][3] ~= 1000 then
				local green = localSlots[i][3]*2
				local red = 1 - green
				local slotIcon = '|T'..GetInventoryItemTexture('player', localSlots[i][1])..':13:15:0:0:50:50:4:46:4:46|t ' or ''
				GameTooltip:AddDoubleLine(slotIcon..localSlots[i][2], floor(localSlots[i][3]*100)..'%', 1,1,1, red+1,green,0)
			end
		end

		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left..L['INFOBAR_OPEN_CHARACTER_PANEL']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	FreeUIDurabilityButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end
