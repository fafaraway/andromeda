local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')


local numInvites = 0
local hasMail = false

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
			F.Notification(L['NOTIFICATION_BAG'], L['NOTIFICATION_BAG_FULL'], ToggleBackpack, 'Interface\\Icons\\inv_misc_bag_08')
			shouldAlertBags = false
		else
			self:SetScript('OnUpdate', delayBagCheck)
		end
	else
		shouldAlertBags = false
	end
end

local function alertMail()
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			F.Notification(L['NOTIFICATION_MAIL'], L['NOTIFICATION_NEW_MAIL'], nil, 'Interface\\Icons\\inv_letter_15', .08, .92, .08, .92)
		end
	end
end


function NOTIFICATION:Events()
	local f = CreateFrame('Frame')
	f:RegisterEvent('PLAYER_ENTERING_WORLD')

	if C.notification.checkBagsFull then
		f:RegisterEvent('BAG_UPDATE')
	end

	if C.notification.checkMail then
		f:RegisterEvent('UPDATE_PENDING_MAIL')
	end

	f:SetScript('OnEvent', function(self, event)
		if event == 'BAG_UPDATE' then
			alertBagsFull(self)
		elseif event == 'UPDATE_PENDING_MAIL' then
			alertMail()
		end
	end)
end