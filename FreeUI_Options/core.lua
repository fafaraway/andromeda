local _, addon = ...

local F, C, L

local realm = GetCVar("realmName")
local name = UnitName("player")

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

local function updateLayoutButton()
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
end

local install = CreateFrame("Button", "FreeUIOptionsPanelInstall", options, "UIPanelButtonTemplate")
install:SetSize(128, 25)
install:SetPoint("TOP", 0, -200)
install:SetText("Installer")
install:SetScript("OnClick", function()
	InterfaceOptionsFrame_Show()
	if IsAddOnLoaded("!Install") then
		FreeUI_InstallFrame:Show()
	else
		EnableAddOn("!Install")
		LoadAddOn("!Install")
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

-- [[ Functionality ]]

local function SetValue(group,option,value)
	--Determine if we should be copying our default settings to our player settings, this only happens if we're not using player settings by default
	local mergesettings
	if FreeUIOptionsPerChar == FreeUIOptions then
		mergesettings = true
	else
		mergesettings = false
	end

	if FreeUIOptionsGlobal[realm][name] == true then
		if not FreeUIOptionsPerChar then FreeUIOptionsPerChar = {} end
		if not FreeUIOptionsPerChar[group] then FreeUIOptionsPerChar[group] = {} end
		FreeUIOptionsPerChar[group][option] = value
	else
		--Set PerChar settings to the same as our settings if theres no per char settings
		if mergesettings == true then
			if not FreeUIOptionsPerChar then FreeUIOptionsPerChar = {} end
			if not FreeUIOptionsPerChar[group] then FreeUIOptionsPerChar[group] = {} end
			FreeUIOptionsPerChar[group][option] = value
		end

		if not FreeUIOptions then FreeUIOptions = {} end
		if not FreeUIOptions[group] then FreeUIOptions[group] = {} end
		FreeUIOptions[group][option] = value
	end
end

options:RegisterEvent("PLAYER_LOGIN")
options:SetScript("OnEvent", function()
	F, C, L = unpack(FreeUI)
	
	local groups = {
		["general"] = true, 
		["actionbars"] = true,
		["unitframes"] = true,
		["classmod"] = true,
		["performance"] = true,
	}
	
	local sorted = {"general", "actionbars", "unitframes", "classmod", "performance"}
	
	for i = 1, #sorted do
		local group = sorted[i]
		local groupName = addon.localization[group]
		local offset = 80
		
		local category = CreateFrame("Frame", "FreeUIOptionsPanel"..group, UIParent)
		category.parent = "FreeUI"
		category.name = groupName
		InterfaceOptions_AddCategory(category)
		
		local sortedOptions = {}
		for option in pairs(C[group]) do
			table.insert(sortedOptions, option)
		end
		table.sort(sortedOptions)

		for _, option in pairs(sortedOptions) do
			local value = C[group][option]
			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "FreeUIOptionsPanel"..groupName..option, category, "InterfaceOptionsCheckButtonTemplate")
				button.Text:SetText(addon.localization[group..option])
				button:SetChecked(value)
				button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false)) end)
				button:SetPoint("TOPLEFT", 16, -offset)
				
				F.ReskinCheck(button)
				
				offset = offset + 24
			end
		end
	end
	
	updateLayoutButton()
	
	F.Reskin(layout)
	F.Reskin(install)
	F.Reskin(reset)
end)