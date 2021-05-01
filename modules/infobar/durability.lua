local F, C, L = unpack(select(2, ...))
local INFOBAR = F.INFOBAR
local NOTIFICATION = F.NOTIFICATION

local showRepair = true
local localSlots = {
	[1] = {1, _G.INVTYPE_HEAD, 1000},
	[2] = {3, _G.INVTYPE_SHOULDER, 1000},
	[3] = {5, _G.INVTYPE_ROBE, 1000},
	[4] = {6, _G.INVTYPE_WAIST, 1000},
	[5] = {9, _G.INVTYPE_WRIST, 1000},
	[6] = {10, _G.INVTYPE_HAND, 1000},
	[7] = {7, _G.INVTYPE_LEGS, 1000},
	[8] = {8, _G.INVTYPE_FEET, 1000},
	[9] = {16, _G.INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, _G.INVTYPE_WEAPONOFFHAND, 1000},
	[11] = {18, _G.INVTYPE_RANGED, 1000}
}

local function getItemDurability()
	local numSlots = 0
	for i = 1, 11 do
		if GetInventoryItemLink('player', localSlots[i][1]) then
			local current, max = GetInventoryItemDurability(localSlots[i][1])
			if current then
				localSlots[i][3] = current / max
				numSlots = numSlots + 1
			end
		else
			localSlots[i][3] = 1000
		end
	end
	sort(
		localSlots,
		function(a, b)
			return a[3] < b[3]
		end
	)

	return numSlots
end

local function isLowDurability()
	for i = 1, 11 do
		if localSlots[i][3] < .20 then
			return true
		end
	end
end

local function gradientColor(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local seg, relperc = math.modf(perc * 2)
	local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	return format('|cff%02x%02x%02x', r * 255, g * 255, b * 255), r, g, b
end

local function ResetRepairNotify()
	showRepair = true
end

local function RepairNotify()
	if showRepair and isLowDurability() then
		showRepair = false
		F:Delay(180, ResetRepairNotify)
		F:CreateNotification(_G.MINIMAP_TRACKING_REPAIR, REPAIR_ARMOR_TOOLTIP_BREAKING, nil, 'Interface\\ICONS\\Ability_Repair')
	end
end

function NOTIFICATION:RepairNotify()
    if C.DB.Notification.LowDurability then
	    F:RegisterEvent('PLAYER_ENTERING_WORLD', RepairNotify)
	    F:RegisterEvent('PLAYER_REGEN_ENABLED', RepairNotify)
    end
end

local function onEvent(self)
	local numSlots = getItemDurability()

	if numSlots > 0 then
		self.Text:SetText(format(gsub(L['Durability'] .. ': [color]%d|r%%', '%[color%]', (gradientColor(floor(localSlots[1][3] * 100) / 100))), floor(localSlots[1][3] * 100)))
	else
		self.Text:SetText(L['Durability'] .. ': ' .. C.InfoColor .. NONE)
	end
end

local function onMouseUp(self, button)
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(C.InfoColor .. ERR_NOT_IN_COMBAT)
		return
	end

	if button == 'LeftButton' then
		print('left')
	elseif button == 'RightButton' then
		print('right')
	elseif button == 'MiddleButton' then
		print('middle')
	end
end

local function onEnter(self)
	local total, equipped = GetAverageItemLevel()
	GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -6) or 6)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(DURABILITY, .9, .8, .6)
	GameTooltip:AddLine(' ')
	for i = 1, 10 do
		if localSlots[i][3] ~= 1000 then
			local green = localSlots[i][3] * 2
			local red = 1 - green
			local slotIcon = '|T' .. GetInventoryItemTexture('player', localSlots[i][1]) .. ':13:15:0:0:50:50:4:46:4:46|t ' or ''
			GameTooltip:AddDoubleLine(slotIcon .. localSlots[i][2], floor(localSlots[i][3] * 100) .. '%', 1, 1, 1, red + 1, green, 0)
		end
	end
	GameTooltip:AddDoubleLine(' ', C.LineString)
	GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Toggle Character Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
	GameTooltip:Show()
end

local function onLeave()
	F.HideTooltip()
end

function INFOBAR:CreateDurabilityButton()
	if not C.DB.infobar.durability then
		return
	end

	INFOBAR.DurabilityButton = INFOBAR:addButton('', INFOBAR.POSITION_LEFT, 150)
	INFOBAR.DurabilityButton:HookScript('OnMouseUp', onMouseUp)

	INFOBAR.DurabilityButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	INFOBAR.DurabilityButton:RegisterEvent('UPDATE_INVENTORY_DURABILITY')

	INFOBAR.DurabilityButton:HookScript('OnEvent', onEvent)
	INFOBAR.DurabilityButton:HookScript('OnEnter', onEnter)
	INFOBAR.DurabilityButton:HookScript('OnLeave', onLeave)


end
