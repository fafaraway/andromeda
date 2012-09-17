local _, ns = ...

-- [[ Main window ]]

local options = CreateFrame("Frame", "FreeUIOptionsPanel", UIParent)
options:SetSize(858, 660)
options:SetPoint("CENTER")
options:SetFrameStrata("HIGH")
options:EnableMouse(true)

tinsert(UISpecialFrames, options:GetName())

options.CloseButton = CreateFrame("Button", nil, options, "UIPanelCloseButton")

options.Okay = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
options.Okay:SetPoint("BOTTOMRIGHT", -16, 16)
options.Okay:SetSize(128, 25)
options.Okay:SetText(OKAY)
options.Okay:SetScript("OnClick", function()
	options:Hide()
end)

options.Profile = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
options.Profile:SetPoint("BOTTOMLEFT", 16, 16)
options.Profile.Text:SetText(ns.localization.profile)
options.Profile.tooltipText = ns.localization.profileTooltip

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("FreeUI v."..GetAddOnMetadata("FreeUI", "Version"))

local resetFrame = CreateFrame("Frame", nil, UIParent)
resetFrame:SetSize(320, 140)
resetFrame:SetPoint("CENTER")
resetFrame:SetFrameStrata("HIGH")
resetFrame:SetFrameLevel(5)
resetFrame:Hide()

resetFrame:SetScript("OnShow", function()
	options:SetAlpha(.3)
end)

resetFrame:SetScript("OnHide", function()
	options:SetAlpha(1)
end)

options.resetFrame = resetFrame

resetFrame.Data = CreateFrame("CheckButton", nil, resetFrame, "InterfaceOptionsCheckButtonTemplate")
resetFrame.Data:SetPoint("TOPLEFT", 16, -16)
resetFrame.Data.Text:SetText(ns.localization.resetData)

resetFrame.Options = CreateFrame("CheckButton", nil, resetFrame, "InterfaceOptionsCheckButtonTemplate")
resetFrame.Options:SetPoint("TOPLEFT", resetFrame.Data, "BOTTOMLEFT", 0, -8)
resetFrame.Options.Text:SetText(ns.localization.resetOptions)

resetFrame.Okay = CreateFrame("Button", nil, resetFrame, "UIPanelButtonTemplate")
resetFrame.Okay:SetSize(128, 25)
resetFrame.Okay:SetPoint("BOTTOMLEFT", 16, 16)
resetFrame.Okay:SetText(OKAY)

resetFrame.Cancel = CreateFrame("Button", nil, resetFrame, "UIPanelButtonTemplate")
resetFrame.Cancel:SetSize(128, 25)
resetFrame.Cancel:SetPoint("BOTTOMRIGHT", -16, 16)
resetFrame.Cancel:SetText(CANCEL)
resetFrame.Cancel:SetScript("OnClick", function()
	resetFrame:Hide()
end)

local install = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
install:SetSize(128, 25)
install:SetPoint("TOPLEFT", 16, -500)
install:SetText(ns.localization.install)
install:SetScript("OnClick", function()
	if IsAddOnLoaded("FreeUI_Install") then
		FreeUI_InstallFrame:Show()
	else
		EnableAddOn("FreeUI_Install")
		LoadAddOn("FreeUI_Install")
	end
	options:Hide()
end)

options.Install = install

local reload = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
reload:SetSize(128, 25)
reload:SetPoint("TOP", install, "BOTTOM", 0, -8)
reload:SetText(ns.localization.reload)
reload:SetScript("OnClick", ReloadUI)

options.Reload = reload

local reset = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
reset:SetSize(128, 25)
reset:SetPoint("TOP", reload, "BOTTOM", 0, -8)
reset:SetText(RESET)
reset:SetScript("OnClick", function()
	resetFrame:Show()
end)

options.Reset = reset

local line = options:CreateTexture()
line:SetSize(1, 536)
line:SetPoint("LEFT", 205, 0)
line:SetTexture(1, 1, 1, .2)

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

ns.addCategory("General")
ns.addCategory("Automation")
ns.addCategory("ActionBars")
ns.addCategory("UnitFrames")
ns.addCategory("ClassMod")
ns.addCategory("Performance")
ns.addCategory("Credits")

-- [[ General ]]

local general = FreeUIOptionsPanel.general

local buffReminder = ns.CreateCheckBox(general, "buffreminder", true)
buffReminder:SetPoint("TOPLEFT", general.subText, "BOTTOMLEFT", 0, -8)

local buffTracker = ns.CreateCheckBox(general, "buffTracker", true)
buffTracker:SetPoint("TOPLEFT", buffReminder, "BOTTOMLEFT", 0, -8)

local interrupt = ns.CreateCheckBox(general, "interrupt", true)
interrupt:SetPoint("TOPLEFT", buffTracker, "BOTTOMLEFT", 0, -8)

local threatMeter = ns.CreateCheckBox(general, "threatMeter", true)
threatMeter:SetPoint("TOPLEFT", interrupt, "BOTTOMLEFT", 0, -8)

local helmCloak = ns.CreateCheckBox(general, "helmcloakbuttons", true)
helmCloak:SetPoint("LEFT", buffReminder, "RIGHT", 240, 0)

local mailButton = ns.CreateCheckBox(general, "mailButton", true)
mailButton:SetPoint("TOPLEFT", helmCloak, "BOTTOMLEFT", 0, -8)

local tolBarad = ns.CreateCheckBox(general, "tolbarad", true)
tolBarad:SetPoint("TOPLEFT", mailButton, "BOTTOMLEFT", 0, -8)

local undressButton = ns.CreateCheckBox(general, "undressButton", true)
undressButton:SetPoint("TOPLEFT", tolBarad, "BOTTOMLEFT", 0, -8)

local reloadText = general:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", threatMeter, "BOTTOMLEFT", 0, -18)
reloadText:SetText(ns.localization.needReload)

local line = general:CreateTexture(nil, "ARTWORK")
line:SetSize(450, 1)
line:SetPoint("TOPLEFT", reloadText, "BOTTOMLEFT", 0, -18)
line:SetTexture(1, 1, 1, .2)

local tooltipCursor = ns.CreateCheckBox(general, "tooltip_cursor")
tooltipCursor:SetPoint("TOPLEFT", tolBarad, "BOTTOMLEFT", 0, -80)

local tooltipGuildRanks = ns.CreateCheckBox(general, "tooltip_guildranks")
tooltipGuildRanks:SetPoint("TOPLEFT", tooltipCursor, "BOTTOMLEFT", 0, -8)

local uiScaleAuto = ns.CreateCheckBox(general, "uiScaleAuto", true)
uiScaleAuto:SetPoint("TOPLEFT", tooltipGuildRanks, "BOTTOMLEFT", 0, -8)

local bagsSize = ns.CreateNumberSlider(general, "bags_size", SMALL, LARGE, 8, 100, 1)
bagsSize:SetPoint("TOPLEFT", uiScaleAuto, "BOTTOMLEFT", 18, -42)

-- [[ Automation ]]

local automation = FreeUIOptionsPanel.automation

local autoAccept = ns.CreateCheckBox(automation, "autoAccept")
autoAccept:SetPoint("TOPLEFT", automation.subText, "BOTTOMLEFT", 0, -8)

local autoRepair = ns.CreateCheckBox(automation, "autoRepair")
autoRepair:SetPoint("TOPLEFT", autoAccept, "BOTTOMLEFT", 0, -8)

local autoRepairGuild = ns.CreateCheckBox(automation, "autoRepair_guild")
autoRepairGuild:SetPoint("TOPLEFT", autoRepair, "BOTTOMLEFT", 16, -8)
autoRepair.child = autoRepairGuild

local autoRoll = ns.CreateCheckBox(automation, "autoRoll")
autoRoll:SetPoint("TOPLEFT", autoRepair, "BOTTOMLEFT", 0, -42)

local autoRollMaxLevel = ns.CreateCheckBox(automation, "autoRoll_maxLevel")
autoRollMaxLevel:SetPoint("TOPLEFT", autoRoll, "BOTTOMLEFT", 16, -8)
autoRoll.child = autoRollMaxLevel

local autoSell = ns.CreateCheckBox(automation, "autoSell")
autoSell:SetPoint("TOPLEFT", autoRoll, "BOTTOMLEFT", 0, -42)

-- [[ Action bars ]]

local actionbars = FreeUIOptionsPanel.actionbars

local hotKey = ns.CreateCheckBox(actionbars, "hotkey")
hotKey:SetPoint("TOPLEFT", actionbars.subText, "BOTTOMLEFT", 0, -8)
actionbars.hotKey = hotKey

local rightBarsMouseover = ns.CreateCheckBox(actionbars, "rightbars_mouseover")
rightBarsMouseover:SetPoint("TOPLEFT", hotKey, "BOTTOMLEFT", 0, -8)

local stanceBar = ns.CreateCheckBox(actionbars, "stancebar")
stanceBar:SetPoint("TOPLEFT", rightBarsMouseover, "BOTTOMLEFT", 0, -8)

-- [[ Unit frames ]]

local unitframes = FreeUIOptionsPanel.unitframes

local wip = unitframes:CreateFontString(nil, nil, "GameFontNormalLarge")
wip:SetPoint("CENTER")
wip:SetText("Coming soon!")

-- [[ Class specific ]]

local classmod = FreeUIOptionsPanel.classmod

ns.classOptions = {}

local deathknight = ns.CreateCheckBox(classmod, "deathknight")
deathknight:SetPoint("TOPLEFT", classmod.subText, "BOTTOMLEFT", -2, -8)
tinsert(ns.classOptions, deathknight)

local druid = ns.CreateCheckBox(classmod, "druid")
druid:SetPoint("TOPLEFT", deathknight, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, druid)

local monk = ns.CreateCheckBox(classmod, "monk")
monk:SetPoint("TOPLEFT", druid, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, monk)

local paladin = ns.CreateCheckBox(classmod, "paladin")
paladin:SetPoint("TOPLEFT", monk, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, paladin)

local priest = ns.CreateCheckBox(classmod, "priest")
priest:SetPoint("TOPLEFT", paladin, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, priest)

local shaman = ns.CreateCheckBox(classmod, "shaman")
shaman:SetPoint("TOPLEFT", priest, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, shaman)

local warlock = ns.CreateCheckBox(classmod, "warlock")
warlock:SetPoint("TOPLEFT", shaman, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, warlock)

-- [[ Performance ]]

local performance = FreeUIOptionsPanel.performance

local mapCoords = ns.CreateNumberSlider(performance, "mapcoords", "0.025 sec", "0.5 sec", 0.025, 0.5, 0.025)
mapCoords:SetPoint("TOPLEFT", performance.subText, "BOTTOMLEFT", 18, -24)

local namePlates = ns.CreateNumberSlider(performance, "nameplates", "0.025 sec", "0.5 sec", 0.025, 0.5, 0.025)
namePlates:SetPoint("TOPLEFT", mapCoords, "BOTTOMLEFT", 0, -30)

local nameThreat = ns.CreateNumberSlider(performance, "namethreat", "0.025 sec", "0.5 sec", 0.025, 0.5, 0.025)
nameThreat:SetPoint("TOPLEFT", namePlates, "BOTTOMLEFT", 0, -30)

local tolBaradTimer = ns.CreateNumberSlider(performance, "tolbarad", "1 sec", "30 sec", 1, 30, 1)
tolBaradTimer:SetPoint("TOPLEFT", nameThreat, "BOTTOMLEFT", 0, -30)

-- [[ Credits ]]

local credits = FreeUIOptionsPanel.credits

credits.Title:SetText("")

local author = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
author:SetPoint("TOP", 0, -80)
author:SetText(ns.localization.author)

local authorSubText = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
authorSubText:SetPoint("TOP", author, "BOTTOM", 0, -8)
authorSubText:SetText(ns.localization.authorSubText)

local thankYou = credits:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
thankYou:SetPoint("TOP", authorSubText, "BOTTOM", 0, -40)
thankYou:SetText(ns.localization.thankYou)

local alza = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
alza:SetPoint("TOP", thankYou, "BOTTOM", 0, -30)
alza:SetText("Alza")

local alzaSubText = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
alzaSubText:SetPoint("TOP", alza, "BOTTOM", 0, -8)
alzaSubText:SetText(ns.localization.alza)

local haste = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
haste:SetPoint("TOP", alzaSubText, "BOTTOM", 0, -30)
haste:SetText("Haste")

local hasteSubText = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
hasteSubText:SetPoint("TOP", haste, "BOTTOM", 0, -8)
hasteSubText:SetText(ns.localization.haste)

local tukz = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
tukz:SetPoint("TOP", hasteSubText, "BOTTOM", 0, -30)
tukz:SetText("Tukz")

local tukzSubText = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
tukzSubText:SetPoint("TOP", tukz, "BOTTOM", 0, -8)
tukzSubText:SetText(ns.localization.tukz)

local zork = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
zork:SetPoint("TOP", tukzSubText, "BOTTOM", 0, -30)
zork:SetText("Zork")

local zorkSubText = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
zorkSubText:SetPoint("TOP", zork, "BOTTOM", 0, -8)
zorkSubText:SetText(ns.localization.zork)