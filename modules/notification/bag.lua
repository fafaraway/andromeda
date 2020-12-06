local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('NOTIFICATION')


local alertBagsFull
local shouldAlertBags = false
local last = 0

local function delayBagCheck(self, elapsed)
	last = last + elapsed
	if last > 1 then
		self:SetScript('OnUpdate', nil)
		last = 0
		shouldAlertBags = true
		alertBagsFull(self)
	end
end

alertBagsFull = function(self)
	local totalFree, freeSlots, bagFamily = 0
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		freeSlots, bagFamily = GetContainerNumFreeSlots(i)
		if bagFamily == 0 then
			totalFree = totalFree + freeSlots
		end
	end

	if totalFree == 0 then
		if shouldAlertBags then
			F:CreateNotification(L['NOTIFICATION_BAG'], C.BlueColor..L['NOTIFICATION_BAG_FULL'], nil, 'Interface\\ICONS\\INV_Misc_Bag_08')
			shouldAlertBags = false
		else
			self:SetScript('OnUpdate', delayBagCheck)
		end
	else
		shouldAlertBags = false
	end
end


function NOTIFICATION:BagFull()
	if not C.DB.notification.bag_full then return end

	local f = CreateFrame('Frame')
	f:RegisterEvent('BAG_UPDATE')
	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:SetScript('OnEvent', function(self, event)
		if event == 'BAG_UPDATE' then
			alertBagsFull(self)
		end
	end)
end
