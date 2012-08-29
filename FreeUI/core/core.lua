-- [[ Core ]]

local addon, core = ...

core[1] = {} -- F, Functions
core[2] = {} -- C, Constants/Config
core[3] = {} -- L, Localisation

FreeUI = core

local F, C, L = unpack(select(2, ...))

-- [[ Saved variables ]]

FreeUIGlobalConfig = {}
FreeUIConfig = {}

-- [[ Event handler ]]

local eventFrame = CreateFrame("Frame")
local events = {}

eventFrame:SetScript("OnEvent", function(_, event, ...)
	for i = #events[event], 1, -1 do
		events[event][i](event, ...)
	end
end)

F.RegisterEvent = function(event, func)
	if not events[event] then
		events[event] = {}
		eventFrame:RegisterEvent(event)
	end
	table.insert(events[event], func)
end

F.UnregisterEvent = function(event, func)
	for index, tFunc in ipairs(events[event]) do
		if tFunc == func then
			table.remove(events[event], index)
		end
	end
	if #events[event] == 0 then
		events[event] = nil
		eventFrame:UnregisterEvent(event)
	end
end

F.UnregisterAllEvents = function(func)
	for event in next, events do
		F.UnregisterEvent(event, func)
	end
end

F.debugEvents = function()
	for event in next, events do
		print(event..": "..#events[event])
	end
end

-- [[ Resolution support ]]

C.resolution = 0

local scaleRegistered = false

local updateScale
updateScale = function(event)
	if event == "VARIABLES_LOADED" then
		local width = GetScreenWidth()

		if width <= 1400 then
			C.resolution = 1
		elseif width <= 1920 then
			C.resolution = 2
		else
			C.resolution = 3
		end
	end
	if not InCombatLockdown() then
		local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
		if scale < .64 then
			UIParent:SetScale(scale)
			ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 50)
			-- unsupported UI scale, need to manually SetScale() every time WoW changes uiScale cvar
			if not scaleRegistered then
				scaleRegistered = true
				F.RegisterEvent("UI_SCALE_CHANGED", updateScale)
			end
		else
			-- UI scale supported, set scale once then leave it alone
			F.UnregisterAllEvents(updateScale)
			SetCVar("useUiScale", 1)
			SetCVar("uiScale", scale)
		end
	else
		F.RegisterEvent("PLAYER_REGEN_ENABLED", updateScale)
	end

	if event == "PLAYER_REGEN_ENABLED" then
		F.UnregisterEvent("PLAYER_REGEN_ENABLED", updateScale)
	end
end

F.RegisterEvent("VARIABLES_LOADED", updateScale)