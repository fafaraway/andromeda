local _, ns = ...

-- [[ Main window ]]

local options = CreateFrame("Frame", "FreeUIOptionsPanel", UIParent)
options.name = "FreeUI"
InterfaceOptions_AddCategory(options)

options.okay = ns.okay
options.cancel = ns.cancel
options.refresh = ns.refresh
options.default = ns.default

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("FreeUI v."..GetAddOnMetadata("FreeUI", "Version"))

local layout = CreateFrame("Button", "FreeUIOptionsPanelLayout", options, "UIPanelButtonTemplate")
layout:SetSize(128, 25)
layout:SetPoint("TOP", 0, -120)

layout.text = layout:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
layout.text:SetPoint("TOP", layout, "BOTTOM", 0, -8)

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

install.text = install:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
install.text:SetPoint("TOP", install, "BOTTOM", 0, -8)
install.text:SetText(ns.localization.install)

local reset = CreateFrame("Button", "FreeUIOptionsPanelReset", options, "UIPanelButtonTemplate")
reset:SetSize(128, 25)
reset:SetPoint("TOP", 0, -280)
reset:SetText("Reset")
reset:SetScript("OnClick", function()
	FreeUIGlobalConfig = {}
	FreeUIConfig = {}
	ReloadUI()
end)

reset.text = reset:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reset.text:SetPoint("TOP", reset, "BOTTOM", 0, -8)
reset.text:SetText(ns.localization.reset)

local credits = options:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText(ns.localization.credits)
credits:SetPoint("TOP", 0, -400)

-- [[ General ]]

local general = CreateFrame("Frame", "FreeUIOptionsPanelGeneral", options)
general.tag = "general"
general.parent = "FreeUI"
general.name = ns.localization.general
InterfaceOptions_AddCategory(general)
tinsert(ns.categories, general.tag)

local title = general:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(ns.localization.general)

local autoaccept = ns.CreateCheckBox(general, "AutoAccept", "auto_accept")
autoaccept:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -26)