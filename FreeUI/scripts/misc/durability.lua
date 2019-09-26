local F, C = unpack(select(2, ...))
local MISC = F:GetModule('Misc')


local SLOTIDS = {}
for _, slot in pairs({'Head', 'Shoulder', 'Chest', 'Waist', 'Legs', 'Feet', 'Wrist', 'Hands', 'MainHand', 'SecondaryHand'}) do
	SLOTIDS[slot] = GetInventorySlotInfo(slot..'Slot')
end
local f = CreateFrame('Frame', nil, CharacterFrame)

local function RYGColorGradient(perc)
	local relperc = perc * 2 % 1
	if perc <= 0 then
		return 1, 0, 0
	elseif perc < 0.5 then
		return 1, relperc, 0
	elseif perc == 0.5 then
		return 1, 1, 0
	elseif perc < 1.0 then
		return 1 - relperc, 1, 0
	else
		return 0, 1, 0
	end
end

local fontstrings = setmetatable({}, {
	__index = function(t, i)
		local gslot = _G['Character'..i..'Slot']
		local fstr = F.CreateFS(gslot, 'pixel', '', nil, nil, true, 'TOPRIGHT', 2, -2)
		t[i] = fstr
		return fstr
	end,
})

function f:OnEvent(event)
	local min = 1
	for slot, id in pairs(SLOTIDS) do
		local v1, v2 = GetInventoryItemDurability(id)

		if v1 and v2 and v2 ~= 0 then
			min = math.min(v1 / v2, min)
			local str = fontstrings[slot]
			str:SetTextColor(RYGColorGradient(v1 / v2))
			if v1 < v2 then
				str:SetText(string.format('%d%%', v1 / v2 * 100))
			else
				str:SetText(nil)
			end
		else
			local str = rawget(fontstrings, slot)
			if str then str:SetText(nil) end
		end
	end
end


function MISC:Durability()
	if not C.general.durability then return end

	f:SetScript('OnEvent', f.OnEvent)
	f:RegisterEvent('ADDON_LOADED')
	f:RegisterEvent('UPDATE_INVENTORY_DURABILITY')

	hooksecurefunc(DurabilityFrame, 'SetPoint', function(self, _, parent)
		if parent == 'MinimapCluster' or parent == MinimapCluster then
			self:SetScale(1)
			self:ClearAllPoints()
			self:SetClampedToScreen(true)
			self:SetPoint('TOP', UIParent, 'TOP', 0, -200)
		end
	end)
end