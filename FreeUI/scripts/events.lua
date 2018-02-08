local F, C = unpack(FreeUI)

if not C.notifications.enable then return end

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
		self:SetScript("OnUpdate", nil)
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
			F.Notification("Bags", "Your bags are full.", ToggleBackpack, "Interface\\Icons\\inv_misc_bag_08")
			shouldAlertBags = false
		else
			self:SetScript("OnUpdate", delayBagCheck)
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
			F.Notification("Mail", "You have new mail.", nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
		end
	end
end

-- Calendar

local function GetGuildInvites()
	local numGuildInvites = 0
	local _, currentMonth = CalendarGetDate()

	for i = 1, CalendarGetNumGuildEvents() do
		local month, day = CalendarGetGuildEventInfo(i)
		local monthOffset = month - currentMonth
		local numDayEvents = CalendarGetNumDayEvents(monthOffset, day)

		for i = 1, numDayEvents do
			local _, _, _, _, _, _, _, _, inviteStatus = CalendarGetDayEvent(monthOffset, day, i)
			if inviteStatus == 8 then
				numGuildInvites = numGuildInvites + 1
			end
		end
	end

	return numGuildInvites
end

local function toggleCalendar()
	if not CalendarFrame then LoadAddOn("Blizzard_Calendar") end
	Calendar_Toggle()
end

local function alertEvents()
	if CalendarFrame and CalendarFrame:IsShown() then return end
	local num = CalendarGetNumPendingInvites()
	if num ~= numInvites then
		if num > 1 then
			F.Notification("Calendar", format("You have %s pending calendar invites.", num), toggleCalendar)
		elseif num > 0 then
			F.Notification("Calendar", "You have 1 pending calendar invite.", toggleCalendar)
		end
		numInvites = num
	end
end

local function alertGuildEvents()
	if CalendarFrame and CalendarFrame:IsShown() then return end
	local num = GetGuildInvites()
	if num > 1 then
		F.Notification("Calendar", format("You have %s pending guild events.", num), toggleCalendar)
	elseif num > 0 then
		F.Notification("Calendar", "You have 1 pending guild event.", toggleCalendar)
	end
end

-- [[ Handle events ]]

local f = CreateFrame("Frame", nil, frame)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

if C.notifications.checkBagsFull then
	f:RegisterEvent("BAG_UPDATE")
end

if C.notifications.checkGuildEvents then
	f:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
end
if C.notifications.checkMail then
	f:RegisterEvent("UPDATE_PENDING_MAIL")
end

F.AddOptionsCallback("notifications", "checkBagsFull", function()
	if C.notifications.checkBagsFull then
		f:RegisterEvent("BAG_UPDATE")
		alertBagsFull(f)
	else
		f:UnregisterEvent("BAG_UPDATE")
	end
end)

F.AddOptionsCallback("notifications", "checkEvents", function()
	if C.notifications.checkEvents or C.notifications.checkGuildEvents then
		f:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
		alertEvents()
	else
		f:UnregisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	end

	if not C.notifications.checkEvents then
		numInvites = 0
	end
end)

F.AddOptionsCallback("notifications", "checkGuildEvents", function()

	if C.notifications.checkGuildEvents then
		f:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
		alertGuildEvents()
	else
		f:UnregisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	end
end)

F.AddOptionsCallback("notifications", "checkMail", function()
	if C.notifications.checkMail then
		f:RegisterEvent("UPDATE_PENDING_MAIL")

		alertMail()
	else
		hasMail = false
		f:UnregisterEvent("UPDATE_PENDING_MAIL")
	end
end)

f:SetScript("OnEvent", function(self, event)
	if event == "BAG_UPDATE" then
		alertBagsFull(self)
	elseif event == "UPDATE_PENDING_MAIL" then
		alertMail()
	elseif event == "CALENDAR_UPDATE_PENDING_INVITES" then
		if C.notifications.checkEvents then
			alertEvents()
		end
		if C.notifications.checkGuildEvents then
			alertGuildEvents()
		end
	elseif event == "CALENDAR_UPDATE_GUILD_EVENTS" then
		alertGuildEvents()
	else -- PLAYER_ENTERING_WORLD
		if C.notifications.checkEvents or C.notifications.checkGuildEvents then
			OpenCalendar()
			f:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
		end

		if C.notifications.checkEvents then
			alertEvents()
		end

		if C.notifications.checkGuildEvents then
			alertGuildEvents()
		end

		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)