local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('INFOBAR')


local format, min = string.format, math.min
local sort, wipe = table.sort, table.wipe

local FreeUIStatsButton = INFOBAR.FreeUIStatsButton

local memory
local _, _, home, world = GetNetStats()
local addons = {}
local n, total = 0, 0
local last = 0
local lastLag = 0

local function formatMemory(value)
	if value > 1024 then
		return format('%.1f MB', value / 1024)
	else
		return format('%.0f KB', value)
	end
end

local function order(a, b)
	return a.memory > b.memory
end

local function memoryColor(value, times)
	if not times then times = 1 end

	if value <= 1024 * times then
		return 0, 1, 0
	elseif value <= 2048 * times then
		return .75, 1, 0
	elseif value <= 4096 * times then
		return 1, 1, 0
	elseif value <= 8192 * times then
		return 1, .75, 0
	elseif value <= 16384 * times then
		return 1, .5, 0
	else
		return 1, .1, 0
	end
end


function INFOBAR:Stats()
	if not C.DB.infobar.stats then return end

	local holder = CreateFrame('Frame', nil, FreeUI_Infobar)
	holder:SetFrameLevel(3)
	holder:SetPoint('TOP')
	holder:SetPoint('BOTTOM')
	holder:SetWidth(180)
	holder:SetPoint('CENTER')

	local text = F.CreateFS(holder, C.Assets.Fonts.Regular, 11, nil, text, nil, true, 'CENTER', 0, 0)
	text:SetTextColor(C.r, C.g, C.b)
	text:SetDrawLayer('OVERLAY')

	FreeUIStatsButton = INFOBAR:addButton('', INFOBAR.POSITION_MIDDLE, 200, function(self, button)
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end

		if button == 'LeftButton' then
			local openaddonlist

			if AddonList:IsVisible() then
				openaddonlist = true
			end

			if not openaddonlist then
				ShowUIPanel(AddonList)
			else
				HideUIPanel(AddonList)
			end
		elseif button == 'RightButton' then
			TimeManagerClockButton_OnClick(TimeManagerClockButton)
		end
	end)

	FreeUIStatsButton:SetWidth(200)

	FreeUIStatsButton:SetScript('OnUpdate', function(self, elapsed)
		last = last + elapsed
		lastLag = lastLag + elapsed

		if lastLag >= 30 then
			_, _, home, world = GetNetStats()
			lastLag = 0
		end

		if last >= 1 then
			text:SetText('|cffffffff'..floor(GetFramerate() + .5)..'|r fps   |cffffffff'..(home)..'|r/|cffffffff'..(world)..'|r ms   |cffffffff'..GameTime_GetTime(false))
			last = 0
		end
	end)

	FreeUIStatsButton:HookScript('OnEnter', function(self)
		if InCombatLockdown() then return end

		collectgarbage()
		UpdateAddOnMemoryUsage()

		for i = 1, GetNumAddOns() do
			if IsAddOnLoaded(i) then
				memory = GetAddOnMemoryUsage(i)
				n = n + 1
				addons[n] = {name = GetAddOnInfo(i), memory = memory}
				total = total + memory
			end
		end
		sort(addons, order)

		GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -15) or 15)
		GameTooltip:ClearLines()
		local today = C_DateAndTime.GetCurrentCalendarTime()
		local w, m, d, y = today.weekday, today.month, today.monthDay, today.year
		GameTooltip:AddLine(format(FULLDATE, CALENDAR_WEEKDAY_NAMES[w], CALENDAR_FULLDATE_MONTH_NAMES[m], d, y), .9, .82, .62)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(L['INFOBAR_LOCAL_TIME'], GameTime_GetLocalTime(true), .6,.8,1 ,1,1,1)
		GameTooltip:AddDoubleLine(L['INFOBAR_REALM_TIME'], GameTime_GetGameTime(true), .6,.8,1 ,1,1,1)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(ADDONS, formatMemory(total), .9, .82, .62, memoryColor(total))
		--GameTooltip:AddLine(' ')

		for _, entry in next, addons do
			GameTooltip:AddDoubleLine(entry.name, formatMemory(entry.memory), 1, 1, 1, memoryColor(entry.memory))
		end

		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left..L['INFOBAR_OPEN_ADDON_PANEL']..' ', 1,1,1, .9, .82, .62)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right..L['INFOBAR_OPEN_TIMER_TRACKER']..' ', 1,1,1, .9, .82, .62)
		GameTooltip:Show()
	end)

	FreeUIStatsButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
		n, total = 0, 0
		wipe(addons)
	end)
end
