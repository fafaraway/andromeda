local F, C, L = unpack(select(2, ...))

local options = CreateFrame("Frame", "FreeUI_ConfigPanel", UIParent)
options.name = "FreeUI"
InterfaceOptions_AddCategory(options)

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("FreeUI v."..GetAddOnMetadata("FreeUI", "Version"))

local layout = CreateFrame("Button", "FreeUI_ConfigPanel_Layout", options, "UIPanelButtonTemplate")
layout:SetSize(128, 25)
layout:SetPoint("TOP", 0, -120)

local layout_desc = layout:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
layout_desc:SetPoint("TOP", layout, "BOTTOM", 0, -8)

layout:RegisterEvent("VARIABLES_LOADED")
layout:SetScript("OnEvent", function(self)
	local layoutToUse
	if FreeUIConfig.layout == 1 then
		self:SetText("Healer layout")
		layoutToUse = 2
	else
		self:SetText("Dps/Tank layout")
		layoutToUse = 1
	end

	self:SetScript("OnClick", function()
		FreeUIConfig.layout = layoutToUse
		ReloadUI()
	end)
	layout_desc:SetText("Switch to the "..( FreeUIConfig.layout==1 and "Healer" or "Dps/Tank").." unitframe layout. This will reload the UI.")
end)

local install = CreateFrame("Button", "FreeUI_ConfigPanel_Install", options, "UIPanelButtonTemplate")
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

local reset = CreateFrame("Button", "FreeUI_ConfigPanel_Reset", options, "UIPanelButtonTemplate")
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