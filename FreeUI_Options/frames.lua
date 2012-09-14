local _, ns = ...

-- [[ Main window ]]

local options = CreateFrame("Frame", "FreeUIOptionsPanel", UIParent)
options:SetSize(858, 660)
options:SetPoint("CENTER")
options:SetFrameStrata("HIGH")

tinsert(UISpecialFrames, options:GetName())

options.CloseButton = CreateFrame("Button", nil, options, "UIPanelCloseButton")

options.Okay = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
options.Okay:SetPoint("BOTTOMRIGHT", -16, 16)
options.Okay:SetSize(128, 25)
options.Okay:SetText(OKAY)

options.Profile = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
options.Profile:SetPoint("TOPLEFT", 16, -60)
options.Profile.Text:SetText(ns.localization.profile)

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("FreeUI v."..GetAddOnMetadata("FreeUI", "Version"))

local install = CreateFrame("Button", "FreeUIOptionsPanelInstall", options, "UIPanelButtonTemplate")
install:SetSize(128, 25)
install:SetPoint("TOP", 0, -60)
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

local reset = CreateFrame("Button", "FreeUIOptionsPanelReset", options, "UIPanelButtonTemplate")
reset:SetSize(128, 25)
reset:SetPoint("BOTTOMLEFT", 16, 16)
reset:SetText("Reset")
reset:SetScript("OnClick", function()
	FreeUIGlobalConfig = {}
	FreeUIConfig = {}
	FreeUIOptions = {}
	FreeUIOptionsPerChar = {}
	FreeUIOptionsGlobal[GetCVar("realmName")][UnitName("player")] = false
	C.options = FreeUIOptions
	ReloadUI()
end)

reset:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 4, 4)
	GameTooltip:AddLine(ns.localization.reset)
	GameTooltip:Show()
end)

reset:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

local credits = options:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
credits:SetText(ns.localization.credits)
credits:SetPoint("BOTTOM", 0, 16)

local menuButton = CreateFrame("Button", "GameMenuButtonFreeUI", GameMenuFrame, "GameMenuButtonTemplate")
menuButton:SetSize(144, 21)
menuButton:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0, -1)
menuButton:SetText("FreeUI")

GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + 22)

GameMenuButtonKeybindings:ClearAllPoints()
GameMenuButtonKeybindings:SetPoint("TOP", menuButton, "BOTTOM", 0, -1)

menuButton:SetScript("OnClick", function()
	ToggleFrame(GameMenuFrame)
	options:Show()
end)

-- [[ General ]]

ns.addCategory("general", "General")
ns.activeTab = FreeUIOptionsPanelGeneral
ns.addCategory("actionbars", "ActionBars")
ns.addCategory("unitframes", "UnitFrames")
ns.addCategory("classmod", "ClassSpecific")
ns.addCategory("performance", "Performance")

local general = FreeUIOptionsPanel.general

local autoAccept = ns.CreateCheckBox(general, "AutoAccept", "auto_accept")
autoAccept:SetPoint("TOPLEFT", general.subText, "BOTTOMLEFT", -2, -8)

local autoRepair = ns.CreateCheckBox(general, "AutoRepair", "autorepair")
autoRepair:SetPoint("TOPLEFT", autoAccept, "BOTTOMLEFT", 0, -8)

local autoRepairGuild = ns.CreateCheckBox(general, "AutoRepairGuild", "autorepair_guild")
autoRepairGuild:SetPoint("TOPLEFT", autoRepair, "BOTTOMLEFT", 16, -8)

local autoRoll = ns.CreateCheckBox(general, "AutoRoll", "autoroll")
autoRoll:SetPoint("TOPLEFT", autoRepair, "BOTTOMLEFT", 0, -42)