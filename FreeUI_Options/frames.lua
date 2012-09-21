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
options.Okay:SetPoint("BOTTOMRIGHT", -6, 6)
options.Okay:SetSize(128, 25)
options.Okay:SetText(OKAY)
options.Okay:SetScript("OnClick", function()
	options:Hide()
end)
tinsert(ns.buttons, options.Okay)

options.Profile = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
options.Profile:SetPoint("BOTTOMLEFT", 6, 6)
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
tinsert(ns.buttons, resetFrame.Okay)

resetFrame.Cancel = CreateFrame("Button", nil, resetFrame, "UIPanelButtonTemplate")
resetFrame.Cancel:SetSize(128, 25)
resetFrame.Cancel:SetPoint("BOTTOMRIGHT", -16, 16)
resetFrame.Cancel:SetText(CANCEL)
resetFrame.Cancel:SetScript("OnClick", function()
	resetFrame:Hide()
end)
tinsert(ns.buttons, resetFrame.Cancel)

local install = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
install:SetSize(128, 25)
install:SetPoint("TOPLEFT", 16, -510)
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
tinsert(ns.buttons, install)

options.Install = install

local reload = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
reload:SetSize(128, 25)
reload:SetPoint("TOP", install, "BOTTOM", 0, -8)
reload:SetText(ns.localization.reload)
reload:SetScript("OnClick", ReloadUI)
tinsert(ns.buttons, reload)

options.Reload = reload

local reset = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
reset:SetSize(128, 25)
reset:SetPoint("TOP", reload, "BOTTOM", 0, -8)
reset:SetText(RESET)
reset:SetScript("OnClick", function()
	resetFrame:Show()
end)
tinsert(ns.buttons, reset)

options.Reset = reset

local line = options:CreateTexture()
line:SetSize(1, 544)
line:SetPoint("LEFT", 205, 0)
line:SetTexture(1, 1, 1, .2)

local menuButton = CreateFrame("Button", "GameMenuButtonFreeUI", GameMenuFrame, "GameMenuButtonTemplate")
menuButton:SetSize(144, 21)
menuButton:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0, -1)
menuButton:SetText("FreeUI")
tinsert(ns.buttons, menuButton)

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
tooltipCursor:SetPoint("TOPLEFT", threatMeter, "BOTTOMLEFT", 0, -66)

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
autoRepair.children = {autoRepairGuild}

local autoRoll = ns.CreateCheckBox(automation, "autoRoll")
autoRoll:SetPoint("TOPLEFT", autoRepair, "BOTTOMLEFT", 0, -42)

local autoRollMaxLevel = ns.CreateCheckBox(automation, "autoRoll_maxLevel")
autoRollMaxLevel:SetPoint("TOPLEFT", autoRoll, "BOTTOMLEFT", 16, -8)
autoRoll.children = {autoRollMaxLevel}

local autoSell = ns.CreateCheckBox(automation, "autoSell")
autoSell:SetPoint("TOPLEFT", autoRoll, "BOTTOMLEFT", 0, -42)

-- [[ Action bars ]]

local actionbars = FreeUIOptionsPanel.actionbars

local enable = ns.CreateCheckBox(actionbars, "enable", true)
enable:SetPoint("TOPLEFT", actionbars.subText, "BOTTOMLEFT", 0, -8)

local enableStyle = ns.CreateCheckBox(actionbars, "enableStyle", true)
enableStyle:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

local rightBarsMouseover = ns.CreateCheckBox(actionbars, "rightbars_mouseover")
rightBarsMouseover:SetPoint("TOPLEFT", enableStyle, "BOTTOMLEFT", 0, -8)

enable.children = {rightBarsMouseover}

local reloadText = actionbars:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", rightBarsMouseover, "BOTTOMLEFT", 0, -18)
reloadText:SetText(ns.localization.needReload)

local line = actionbars:CreateTexture(nil, "ARTWORK")
line:SetSize(450, 1)
line:SetPoint("TOPLEFT", reloadText, "BOTTOMLEFT", 0, -18)
line:SetTexture(1, 1, 1, .2)

local hotKey = ns.CreateCheckBox(actionbars, "hotkey")
hotKey:SetPoint("TOPLEFT", rightBarsMouseover, "BOTTOMLEFT", 0, -66)

enableStyle.children = {hotKey}

-- [[ Unit frames ]]

local unitframes = FreeUIOptionsPanel.unitframes

local enable = ns.CreateCheckBox(unitframes, "enable", true)
enable:SetPoint("TOPLEFT", unitframes.subText, "BOTTOMLEFT", 0, -8)

local enableGroup = ns.CreateCheckBox(unitframes, "enableGroup", true)
enableGroup:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

local limitRaidSize = ns.CreateCheckBox(unitframes, "limitRaidSize", true)
limitRaidSize:SetPoint("TOPLEFT", enableGroup, "BOTTOMLEFT", 16, -8)

local healerClasscolours = ns.CreateCheckBox(unitframes, "healerClasscolours", true)
healerClasscolours:SetPoint("TOPLEFT", limitRaidSize, "BOTTOMLEFT", 0, -8)

local partyNameAlways = ns.CreateCheckBox(unitframes, "partyNameAlways", true)
partyNameAlways:SetPoint("TOPLEFT", healerClasscolours, "BOTTOMLEFT", 0, -8)

enableGroup.children = {limitRaidSize, healerClasscolours, partyNameAlways}

local targettarget = ns.CreateCheckBox(unitframes, "targettarget", true)
targettarget:SetPoint("LEFT", enableGroup, "RIGHT", 240, 0)

local pvp = ns.CreateCheckBox(unitframes, "pvp", true)
pvp:SetPoint("TOPLEFT", targettarget, "BOTTOMLEFT", 0, -8)

local castbarSeparate = ns.CreateCheckBox(unitframes, "castbarSeparate", true)
castbarSeparate:SetPoint("TOPLEFT", pvp, "BOTTOMLEFT", 0, -8)

local castbarSeparateOnlyCasters = ns.CreateCheckBox(unitframes, "castbarSeparateOnlyCasters", true)
castbarSeparateOnlyCasters:SetPoint("TOPLEFT", castbarSeparate, "BOTTOMLEFT", 16, -8)

castbarSeparate.children = {castbarSeparateOnlyCasters}

local reloadText = unitframes:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", enableGroup, "BOTTOMLEFT", 0, -128)
reloadText:SetText(ns.localization.needReload)

local line = unitframes:CreateTexture(nil, "ARTWORK")
line:SetSize(450, 1)
line:SetPoint("TOPLEFT", reloadText, "BOTTOMLEFT", 0, -18)
line:SetTexture(1, 1, 1, .2)

unitframes.Layout = CreateFrame("Button", nil, unitframes, "UIPanelButtonTemplate")
unitframes.Layout:SetPoint("TOP", 0, -340)
unitframes.Layout:SetSize(128, 25)
tinsert(ns.buttons, unitframes.Layout)

local function toggleUFOptions(self)
	local shown = enable:GetChecked() == 1
	enableGroup:SetShown(shown)
	limitRaidSize:SetShown(shown)
	healerClasscolours:SetShown(shown)
	partyNameAlways:SetShown(shown)
	targettarget:SetShown(shown)
	pvp:SetShown(shown)
	castbarSeparate:SetShown(shown)
	reloadText:SetShown(shown)
	castbarSeparateOnlyCasters:SetShown(shown)
	line:SetShown(shown)
	unitframes.Layout:SetShown(shown)
end

enable:HookScript("OnClick", toggleUFOptions)
unitframes:HookScript("OnShow", toggleUFOptions)

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

local reloadText = classmod:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("TOPLEFT", warlock, "BOTTOMLEFT", 0, -18)
reloadText:SetText(ns.localization.needReload)

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
author:SetPoint("TOP", 0, -64)
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

local others = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
others:SetPoint("TOP", zorkSubText, "BOTTOM", 0, -30)
others:SetText(ns.localization.others)

local othersSubText = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
othersSubText:SetPoint("TOP", others, "BOTTOM", 0, -8)
othersSubText:SetText("Allez, AlleyKat, Caellian, p3lim, Shantalya, tekkub, Tuller, Wildbreath")