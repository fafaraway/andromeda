-- [[ Core ]]

local addonName, ns = ...

ns[1] = {} -- F, Functions
ns[2] = {} -- C, Constants/Config
ns[3] = {} -- L, Localisation

_G[addonName] = ns

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

-- [[ Resolution support ]]

local updateScale
updateScale = function(event)


	if C.general.uiScaleAuto then

		F.HideOption(Advanced_UseUIScale)
		F.HideOption(Advanced_UIScaleSlider)


		local pixelScale
		local floor = _G.math.floor
		local pysWidth, pysHeight = _G.GetPhysicalScreenSize()

		pixelScale = 768 / pysHeight
		local cvarScale, parentScale = _G.tonumber(_G.GetCVar("uiscale")), floor(_G.UIParent:GetScale() * 100 + 0.5) / 100


		if parentScale ~= pixelScale then
			_G.UIParent:SetScale(pixelScale)
		end


		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint(unpack(C.chat.position))

	end
end

F.RegisterEvent("VARIABLES_LOADED", updateScale)
F.RegisterEvent("UI_SCALE_CHANGED", updateScale)

F.AddOptionsCallback("general", "uiScaleAuto", function()
	if C.general.uiScaleAuto then
		F.RegisterEvent("UI_SCALE_CHANGED", updateScale)
		updateScale()
	else
		F.UnregisterEvent("UI_SCALE_CHANGED", updateScale)
	end
end)

-- [[ For secure frame hiding ]]

local hider = CreateFrame("Frame", "FreeUIHider", UIParent)
hider:Hide()
