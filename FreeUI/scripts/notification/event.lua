local F, C = unpack(select(2, ...))

if not C.notification.enableNotification then return end

local numInvites = 0 -- store amount of invites to compare later, and only show banner when invites differ; events fire multiple times
local hasMail = false -- same with mail

-- [[ Functions ]]

-- Bags

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

-- Mail

local function alertMail()
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			F.Notification(L['NOTIFICATION_MAIL'], L['NOTIFICATION_NEW_MAIL'], nil, 'Interface\\Icons\\inv_letter_15', .08, .92, .08, .92)
		end
	end
end



-- [[ Handle events ]]

local f = CreateFrame('Frame', nil, frame)
f:RegisterEvent('PLAYER_ENTERING_WORLD')

if C.notification.checkBagsFull then
	f:RegisterEvent('BAG_UPDATE')
end

if C.notification.checkMail then
	f:RegisterEvent('UPDATE_PENDING_MAIL')
end

F.AddOptionsCallback('notifications', 'checkBagsFull', function()
	if C.notification.checkBagsFull then
		f:RegisterEvent('BAG_UPDATE')
		alertBagsFull(f)
	else
		f:UnregisterEvent('BAG_UPDATE')
	end
end)



F.AddOptionsCallback('notifications', 'checkMail', function()
	if C.notification.checkMail then
		f:RegisterEvent('UPDATE_PENDING_MAIL')

		alertMail()
	else
		hasMail = false
		f:UnregisterEvent('UPDATE_PENDING_MAIL')
	end
end)

f:SetScript('OnEvent', function(self, event)
	if event == 'BAG_UPDATE' then
		alertBagsFull(self)
	elseif event == 'UPDATE_PENDING_MAIL' then
		alertMail()

	end
end)