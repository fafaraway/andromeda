local F, C
local _, addon = ...

-- [[ Functions ]]

local categories = {}
local old = {}

local checkboxes = {}
local sliders = {}
local dropdowns = {}
local editboxes = {}

local function SaveValue(f, value)
	if not C.options[f.group] then C.options[f.group] = {} end
	if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

	C.options[f.group][f.option] = value -- these are the saved variables
	C[f.group][f.option] = value -- and this is from the lua options
end

local function toggle(f)
	SaveValue(f, f:GetChecked() == 1)
end

local function CreateCheckBox(parent, name, option)
	local f = CreateFrame("CheckButton", parent:GetName()..name, parent, "InterfaceOptionsCheckButtonTemplate")

	f.group = parent.tag
	f.option = option
	f.Text:SetText(addon.localization[parent.tag..option])

	f:SetScript("OnClick", toggle)

	tinsert(checkboxes, f)

	return f
end

-- [[ Main window ]]

local options = CreateFrame("Frame", "FreeUIOptionsPanel", UIParent)
options.name = "FreeUI"
InterfaceOptions_AddCategory(options)

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("FreeUI v."..GetAddOnMetadata("FreeUI", "Version"))

local layout = CreateFrame("Button", "FreeUIOptionsPanelLayout", options, "UIPanelButtonTemplate")
layout:SetSize(128, 25)
layout:SetPoint("TOP", 0, -120)

local layout_desc = layout:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
layout_desc:SetPoint("TOP", layout, "BOTTOM", 0, -8)

local install = CreateFrame("Button", "FreeUIOptionsPanelInstall", options, "UIPanelButtonTemplate")
install:SetSize(128, 25)
install:SetPoint("TOP", 0, -200)
install:SetText("Installer")
install:SetScript("OnClick", function()
	InterfaceOptionsFrame_Show()
	if IsAddOnLoaded("FreeUI_Install") then
		FreeUI_InstallFrame:Show()
	else
		EnableAddOn("FreeUI_Install")
		LoadAddOn("FreeUI_Install")
	end
	if GameMenuFrame:IsShown() then
		ToggleFrame(GameMenuFrame)
	end
end)

local install_desc = install:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
install_desc:SetPoint("TOP", install, "BOTTOM", 0, -8)
install_desc:SetText("Load the installer/tutorial.")

local reset = CreateFrame("Button", "FreeUIOptionsPanelReset", options, "UIPanelButtonTemplate")
reset:SetSize(128, 25)
reset:SetPoint("TOP", 0, -280)
reset:SetText("Reset")
reset:SetScript("OnClick", function()
	FreeUIGlobalConfig = {}
	FreeUIConfig = {}
	ReloadUI()
end)

local reset_desc = reset:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reset_desc:SetPoint("TOP", reset, "BOTTOM", 0, -8)
reset_desc:SetText("Remove the data saved by FreeUI.")

local credits = options:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText("FreeUI by Freethinker @ Steamwheedle Cartel - EU / Haleth on wowinterface.com")
credits:SetPoint("TOP", 0, -400)

-- [[ General ]]

local general = CreateFrame("Frame", "FreeUIOptionsPanelGeneral", options)
general.tag = "general"
general.parent = "FreeUI"
general.name = addon.localization.general
InterfaceOptions_AddCategory(general)
tinsert(categories, general.tag)

local title = general:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(addon.localization.general)

local autoaccept = CreateCheckBox(general, "AutoAccept", "auto_accept")
autoaccept:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -26)

-- [[ Callbacks ]]

options.refresh = function()
	local layoutToUse
	if FreeUIConfig.layout == 1 then
		layout:SetText("Healer layout")
		layoutToUse = 2
	else
		layout:SetText("Dps/Tank layout")
		layoutToUse = 1
	end

	layout:SetScript("OnClick", function()
		FreeUIConfig.layout = layoutToUse
		ReloadUI()
	end)
	layout_desc:SetText("Switch to the "..( FreeUIConfig.layout==1 and "Healer" or "Dps/Tank").." unitframe layout. This will reload the UI.")

	for _, box in pairs(checkboxes) do
		box:SetChecked(C[box.group][box.option])
	end
end

options.okay = function()
	-- refresh the 'old' table for the next options.cancel()
	F.CopyTable(C.options, old)
end

options.cancel = function()
	-- copy the old values to the saved vars if they exist
	F.CopyTableExisting(old, C.options)
	-- also update the table that is actually used by the scripts
	F.CopyTableExisting(old, C)
end

options.default = function()
	-- clear saved vars to reset to lua options, and set profile boolean to global
	FreeUIOptions = {}
	FreeUIOptionsPerChar = {}
	FreeUIOptionsGlobal[GetCVar("realmName")][UnitName("player")] = false
	C.options = FreeUIOptions
end

-- [[ Init ]]

local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_LOGIN")
init:SetScript("OnEvent", function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)

	-- in case we hit cancel
	for _, group in pairs(categories) do
		old[group] = {}
		F.CopyTable(C[group], old[group])
	end

	F.Reskin(layout)
	F.Reskin(install)
	F.Reskin(reset)

	for _, box in pairs(checkboxes) do
		F.ReskinCheck(box)
	end
end)