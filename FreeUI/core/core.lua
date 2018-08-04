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

local events = {}
local host = CreateFrame("Frame")

host:SetScript("OnEvent", function(_, event, ...)
	for func in pairs(events[event]) do
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			func(event, CombatLogGetCurrentEventInfo())
		else
			func(event, ...)
		end
	end
end)

function F:RegisterEvent(event, func, unit1, unit2)
	if not events[event] then
		events[event] = {}
		if unit1 then
			host:RegisterUnitEvent(event, unit1, unit2)
		else
			host:RegisterEvent(event)
		end
	end

	events[event][func] = true
end

function F:UnregisterEvent(event, func)
	local funcs = events[event]
	if funcs and funcs[func] then
		funcs[func] = nil

		if not next(funcs) then
			events[event] = nil
			host:UnregisterEvent(event)
		end
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

-- Modules
local modules, initQueue = {}, {}

function F:RegisterModule(name)
	if modules[name] then print("Module <"..name.."> has been registered.") return end
	local module = {}
	module.name = name
	modules[name] = module

	tinsert(initQueue, module)
	return module
end

function F:GetModule(name)
	if not modules[name] then print("Module <"..name.."> does not exist.") return end

	return modules[name]
end


-- Init

F:RegisterEvent("PLAYER_LOGIN", function()
	for _, module in pairs(initQueue) do
		if module.OnLogin then
			module:OnLogin()
		else
			print("Module <"..module.name.."> does not loaded.")
		end
	end
end)


-- Options GUI callbacks

F.AddOptionsCallback = function(category, option, func, widgetType)
	if not IsAddOnLoaded("FreeUI_Options") then return end

	if widgetType and widgetType == "radio" then
		local index = 1
		local frame = FreeUIOptionsPanel[category][option..index]
		while frame do
			frame:HookScript("OnClick", func)

			index = index + 1
			frame = FreeUIOptionsPanel[category][option..index]
		end
	else
		local frame = FreeUIOptionsPanel[category][option]

		if frame:GetObjectType() == "Slider" then
			frame:HookScript("OnValueChanged", func)
		else
			frame:HookScript("OnClick", func)
		end
	end
end


-- [[ For secure frame hiding ]]

local hider = CreateFrame("Frame", "FreeUIHider", UIParent)
hider:Hide()

