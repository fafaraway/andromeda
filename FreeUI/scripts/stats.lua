local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local memory
local _, _, home, world = GetNetStats()
local addons = {}
local n, total = 0, 0

local f = CreateFrame("Button", nil, FreeUIMenubar)
f:SetPoint("CENTER")
f:SetSize(200, 10)

local text = F.CreateFS(f)
text:SetPoint("CENTER")
text:SetTextColor(r, g, b)

local last = 0
local lastLag = 0

f:SetScript("OnUpdate", function(self, elapsed)
	last = last + elapsed
	lastLag = lastLag + elapsed

	if lastLag >= 30 then
		_, _, home, world = GetNetStats()
		lastLag = 0
	end

	if last >= 1 then
		text:SetText("|cffffffff"..floor(GetFramerate() + .5).."|r fps   |cffffffff"..home.."|r/|cffffffff"..world.."|r ms   |cffffffff"..GameTime_GetTime(false))
		last = 0
	end
end)

local function order(a, b)
	return a.memory > b.memory
end

f:SetScript("OnEnter", function()
	if InCombatLockdown() then return end

	FreeUIMenubar.showBar()

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

	GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
	if C.bags.enable and BagsHolder:IsShown() then
		GameTooltip:SetPoint("BOTTOMRIGHT", BagsHolder, "BOTTOMLEFT", 0, -1)
	else
		GameTooltip:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -1, -2)
	end
	GameTooltip:AddDoubleLine("Addons", format("%.1f kb", total), r, g, b, 1, 1, 1)

	GameTooltip:AddLine(" ")

	for _, entry in next, addons do
		GameTooltip:AddDoubleLine(entry.name, format("%.1f kb", entry.memory), 1, 1, 1, 1, 1, 1)
	end

	GameTooltip:AddLine(" ")

	GameTooltip:AddLine("Click |cffffffffto show time manager.", r, g, b)

	GameTooltip:Show()
end)

f:SetScript("OnLeave", function()
	GameTooltip:Hide()
	n, total = 0, 0
	wipe(addons)
	FreeUIMenubar.hideBar()
end)

f:SetScript("OnClick", function()
	TimeManagerClockButton_OnClick(TimeManagerClockButton)
end)