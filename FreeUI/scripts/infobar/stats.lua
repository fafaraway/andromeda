local F, C, L = unpack(select(2, ...))
local module = F:GetModule("infobar")
if not C.infoBar.enable then return end


local _, _, home, world = GetNetStats()

local holder = CreateFrame("Frame", nil, FreeUIMenubar)
holder:SetFrameLevel(3)
holder:SetPoint("TOP")
holder:SetPoint("BOTTOM")
holder:SetWidth(200)
holder:SetPoint("CENTER")

local text = F.CreateFS(holder, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
text:SetDrawLayer("OVERLAY")
text:SetPoint("CENTER")
text:SetTextColor(C.r, C.g, C.b)

local FreeUIStatsButton = module.FreeUIStatsButton

local function formatMemory(value)
	if value > 1024 then
		return format("%.1f MB", value / 1024)
	else
		return format("%.0f KB", value)
	end
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

local memoryTable, totalMemory = {}

local function updateMemory()
	wipe(memoryTable)
	UpdateAddOnMemoryUsage()

	local total, count = 0, 0
	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			count = count + 1
			local usage = GetAddOnMemoryUsage(i)
			memoryTable[count] = {select(2, GetAddOnInfo(i)), usage}
			total = total + usage
		end
	end

	sort(memoryTable, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)

	return total
end

FreeUIStatsButton = module:addButton("", POSITION_MIDDLE, function(self, button)
	if button == "LeftButton" then
		local before = gcinfo()
		collectgarbage("collect")
		print(format("|cff66C6FF%s:|r %s", L["CollectMemory"], formatMemory(before - gcinfo())))
		updateMemory()
		self:GetScript("OnEnter")(self)
	elseif button == "RightButton" then
		local openaddonlist

		if AddonList:IsVisible() then
			openaddonlist = true
		end

		if not openaddonlist then
			ShowUIPanel(AddonList)
		else
			HideUIPanel(AddonList)

		end
	else
		TimeManagerClockButton_OnClick(TimeManagerClockButton)
	end
end)

FreeUIStatsButton:SetWidth(250)

FreeUIStatsButton:RegisterEvent("PLAYER_ENTERING_WORLD")
FreeUIStatsButton:SetScript("OnUpdate", function(self, elapsed)
	self.timer = (self.timer or 5) + elapsed
	self.lastLag = (self.lastLag or 0) + elapsed

	if self.lastLag >= 30 then
		_, _, home, world = GetNetStats()
		self.lastLag = 0
	end

	if self.timer >= 1 then
		totalMemory = updateMemory()
		text:SetText(format("|cffffffff%.1f|r ", totalMemory/1024)..F.HexRGB(memoryColor(totalMemory, 10)).."mb".."   ".."|cffffffff"..math.floor(GetFramerate()).."|r fps   |cffffffff"..(home).."|r/|cffffffff"..(world).."|r ms   |cffffffff"..GameTime_GetTime(false))
		self.timer = 0
	end
end)

FreeUIStatsButton:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(ADDONS, formatMemory(totalMemory), .9, .82, .62, .6,.8,1)
	GameTooltip:AddLine(" ")

	local maxAddOns = IsShiftKeyDown() and #memoryTable or min(C.infoBar.maxAddOns, #memoryTable)
	for i = 1, maxAddOns do
		local usage = memoryTable[i][2]
		GameTooltip:AddDoubleLine(memoryTable[i][1], formatMemory(usage), 1,1,1, memoryColor(usage, 5))
	end

	local hiddenMemory = 0
	if not IsShiftKeyDown() then
		for i = (C.infoBar.maxAddOns + 1), #memoryTable do
			hiddenMemory = hiddenMemory + memoryTable[i][2]
		end
		if #memoryTable > C.infoBar.maxAddOns then
			local numHidden = #memoryTable - C.infoBar.maxAddOns
			GameTooltip:AddDoubleLine(format("%d %s (%s)", numHidden, L["Hidden"], L["HoldShift"]), formatMemory(hiddenMemory), .6,.8,1, .6,.8,1)
		end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(L["DefaultUIMemoryUsage:"], formatMemory(gcinfo() - totalMemory), .9, .82, .62, 1,1,1)
	GameTooltip:AddDoubleLine(L["TotalMemoryUsage:"], formatMemory(collectgarbage("count")), .9, .82, .62, 1,1,1)
	GameTooltip:AddDoubleLine(" ", C.LineString)
	GameTooltip:AddDoubleLine(" ", C.LeftButton..L["CollectMemory"].." ", 1,1,1, .9, .82, .62)
	GameTooltip:AddDoubleLine(" ", C.RightButton..L["OpenAddonList"].." ", 1,1,1, .9, .82, .62)
	GameTooltip:AddDoubleLine(" ", C.MiddleButton..L["OpenTimerTracker"].." ", 1,1,1, .9, .82, .62)
	GameTooltip:Show()

	self:RegisterEvent("MODIFIER_STATE_CHANGED")
end)

FreeUIStatsButton:HookScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
end)

FreeUIStatsButton:SetScript("OnEvent", function(self, event, arg1)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if event == "MODIFIER_STATE_CHANGED" and arg1 == "LSHIFT" then
		self:GetScript("OnEnter")(self)
	end
end)