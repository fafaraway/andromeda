local F, C = unpack(FreeUI)

if not C.notifications.enable then return end

local checkEvents = C.notifications.checkEvents
local checkGuildEvents = C.notifications.checkGuildEvents

local numInvites = 0 -- store amount of invites to compare later, and only show banner when invites differ; events fire multiple times
local hasMail = false -- same with mail

local function alertMail()
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			F.Notification("Mail", "You have new mail.", nil, "Interface\\Icons\\inv_letter_15", .08, .92, .08, .92)
		end
	end
end

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

local f = CreateFrame("Frame", nil, frame)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
if C.notifications.checkMail then
	f:RegisterEvent("UPDATE_PENDING_MAIL")
end
if checkGuildEvents then
	f:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
end

F.AddOptionsCallback("notifications", "checkMail", function()
	if C.notifications.checkMail then
		f:RegisterEvent("UPDATE_PENDING_MAIL")

		alertMail()
	else
		hasMail = false
		f:UnregisterEvent("UPDATE_PENDING_MAIL")
	end
end)

F.AddOptionsCallback("notifications", "checkEvents", function()
	checkEvents = C.notifications.checkEvents

	if checkEvents or checkGuildEvents then
		f:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
		alertEvents()
	else
		f:UnregisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	end

	if not checkEvents then
		numInvites = 0
	end
end)

F.AddOptionsCallback("notifications", "checkGuildEvents", function()
	checkGuildEvents = C.notifications.checkGuildEvents

	if checkGuildEvents then
		f:RegisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
		alertGuildEvents()
	else
		f:UnregisterEvent("CALENDAR_UPDATE_GUILD_EVENTS")
	end
end)

f:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if checkEvents or checkGuildEvents then
			OpenCalendar()
			f:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
		end

		if checkEvents then
			alertEvents()
		end
		if checkGuildEvents then
			alertGuildEvents()
		end

		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "UPDATE_PENDING_MAIL" then
		alertMail()
	elseif event == "CALENDAR_UPDATE_PENDING_INVITES" then
		if checkEvents then
			alertEvents()
		end
		if checkGuildEvents then
			alertGuildEvents()
		end
	else
		alertGuildEvents()
	end
end)