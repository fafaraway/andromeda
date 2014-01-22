local _, ns = ...

-- [[ Main window ]]

local options = CreateFrame("Frame", "FreeUIOptionsPanel", UIParent)
options:SetSize(884, 680)
options:SetPoint("CENTER")
options:SetFrameStrata("HIGH")
options:EnableMouse(true)

tinsert(UISpecialFrames, options:GetName())

options.CloseButton = CreateFrame("Button", nil, options, "UIPanelCloseButton")

do
	local popup = CreateFrame("Frame", nil, UIParent)
	popup:SetPoint("CENTER")
	popup:SetSize(320, 120)
	popup:Hide()
	options.popup = popup

	local text = popup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	text:SetWidth(290)
	text:SetPoint("TOP", 0, -16)
	text:SetText(ns.localization.needReloadPopup)

	local yes = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
	yes:SetPoint("BOTTOMRIGHT", popup, "BOTTOM", -6, 16)
	yes:SetSize(128, 25)
	yes:SetText(YES)
	yes:SetScript("OnClick", ReloadUI)
	tinsert(ns.buttons, yes)

	local no = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
	no:SetPoint("BOTTOMLEFT", popup, "BOTTOM", 6, 16)
	no:SetSize(128, 25)
	no:SetText(NO)
	no:SetScript("OnClick", function()
		PlaySound("igMainMenuClose")
		popup:Hide()
	end)
	tinsert(ns.buttons, no)
end

local Okay = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
Okay:SetPoint("BOTTOMRIGHT", -6, 6)
Okay:SetSize(128, 25)
Okay:SetText(OKAY)
Okay:SetScript("OnClick", function()
	options:Hide()
	if ns.needReload then
		PlaySound("igMainMenuOpen")
		options.popup:Show()
	end
end)

options.Okay = Okay
tinsert(ns.buttons, options.Okay)

local Profile = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
Profile:SetPoint("BOTTOMLEFT", 6, 6)
Profile.Text:SetText(ns.localization.profile)
Profile.tooltipText = ns.localization.profileTooltip
options.Profile = Profile

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -26)
title:SetText("FreeUI "..GetAddOnMetadata("FreeUI", "Version"))

local reloadText = options:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
reloadText:SetPoint("BOTTOM", 0, 14)
reloadText:SetText(ns.localization.needReload)
reloadText:Hide()
options.reloadText = reloadText

local resetFrame = CreateFrame("Frame", nil, UIParent)
resetFrame:SetSize(320, 200)
resetFrame:SetPoint("CENTER")
resetFrame:SetFrameStrata("HIGH")
resetFrame:SetFrameLevel(5)
resetFrame:EnableMouse(true)
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
resetFrame.Data.tooltipText = ns.localization.resetDataTooltip

resetFrame.Options = CreateFrame("CheckButton", nil, resetFrame, "InterfaceOptionsCheckButtonTemplate")
resetFrame.Options:SetPoint("TOPLEFT", resetFrame.Data, "BOTTOMLEFT", 0, -8)
resetFrame.Options.Text:SetText(ns.localization.resetOptions)
resetFrame.Options.tooltipText = ns.localization.resetOptionsTooltip

local charBox = CreateFrame("EditBox", "FreeUIOptionsPanelResetFrameCharBox", resetFrame)
charBox:SetAutoFocus(false)
charBox:SetWidth(180)
charBox:SetHeight(20)
charBox:SetMaxLetters(12)
charBox:SetFontObject(GameFontHighlight)
charBox:SetPoint("TOPLEFT", resetFrame.Options, "BOTTOMLEFT", 6, -34)

charBox:CreateTexture("FreeUIOptionsPanelResetFrameCharBoxLeft")
charBox:CreateTexture("FreeUIOptionsPanelResetFrameCharBoxRight")
charBox:CreateTexture("FreeUIOptionsPanelResetFrameCharBoxMiddle")

charBox:SetScript("OnEscapePressed", function(self)
	self:ClearFocus()
end)

resetFrame.charBox = charBox

local charBoxLabel = charBox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
charBoxLabel:SetPoint("BOTTOMLEFT", charBox, "TOPLEFT", 0, 6)
charBoxLabel:SetText(ns.localization.resetCharBox)

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
install:SetPoint("TOPLEFT", 16, -538)
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
reload:SetPoint("TOP", install, "BOTTOM", 0, -4)
reload:SetText(ns.localization.reload)
reload:SetScript("OnClick", ReloadUI)
tinsert(ns.buttons, reload)

options.Reload = reload

local reset = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
reset:SetSize(128, 25)
reset:SetPoint("TOP", reload, "BOTTOM", 0, -4)
reset:SetText(RESET)
reset:SetScript("OnClick", function()
	resetFrame:Show()
end)
tinsert(ns.buttons, reset)

options.Reset = reset

local line = options:CreateTexture()
line:SetSize(1, 564)
line:SetPoint("LEFT", 205, 0)
line:SetTexture(1, 1, 1, .2)

local menuButton = CreateFrame("Button", "GameMenuButtonFreeUI", GameMenuFrame, "GameMenuButtonTemplate")
menuButton:SetSize(144, 21)
menuButton:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0, -1)
menuButton:SetText("FreeUI")
tinsert(ns.buttons, menuButton)

GameMenuFrame:HookScript("OnShow", function(self)
	GameMenuButtonStore:Hide()
	GameMenuButtonOptions:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -16)
end)

GameMenuButtonKeybindings:ClearAllPoints()
GameMenuButtonKeybindings:SetPoint("TOP", menuButton, "BOTTOM", 0, -1)

menuButton:SetScript("OnClick", function()
	ToggleFrame(GameMenuFrame)
	options:Show()
end)

ns.addCategory("General")
ns.addCategory("Automation")
ns.addCategory("ActionBars")
ns.addCategory("Bags")
ns.addCategory("Notifications")
ns.addCategory("UnitFrames")
ns.addCategory("Tooltip")
ns.addCategory("ClassMod")
ns.addCategory("Credits")

-- [[ General ]]

local general = FreeUIOptionsPanel.general
general.tab.Icon:SetTexture("Interface\\Icons\\inv_gizmo_02")

local buffReminder = ns.CreateCheckBox(general, "buffreminder", true, true)
buffReminder:SetPoint("TOPLEFT", general.subText, "BOTTOMLEFT", 0, -8)

local buffTracker = ns.CreateCheckBox(general, "buffTracker", true, true)
buffTracker:SetPoint("TOPLEFT", buffReminder, "BOTTOMLEFT", 0, -8)

local combatText = ns.CreateCheckBox(general, "combatText", true, true)
combatText:SetPoint("TOPLEFT", buffTracker, "BOTTOMLEFT", 0, -8)

local interrupt = ns.CreateCheckBox(general, "interrupt", true)
interrupt:SetPoint("TOPLEFT", combatText, "BOTTOMLEFT", 0, -8)

local interruptParty = ns.CreateCheckBox(general, "interrupt_party", true)
interruptParty:SetPoint("TOPLEFT", interrupt, "BOTTOMLEFT", 16, -8)

local interruptBGs = ns.CreateCheckBox(general, "interrupt_bgs", true)
interruptBGs:SetPoint("TOPLEFT", interruptParty, "BOTTOMLEFT", 0, -8)

local interruptLFG = ns.CreateCheckBox(general, "interrupt_lfg", true)
interruptLFG:SetPoint("TOPLEFT", interruptBGs, "BOTTOMLEFT", 0, -8)

local interruptOutdoors = ns.CreateCheckBox(general, "interrupt_outdoors", true)
interruptOutdoors:SetPoint("TOPLEFT", interruptLFG, "BOTTOMLEFT", 0, -8)

interrupt.children = {interruptParty, interruptBGs, interruptLFG, interruptOutdoors}

local threatMeter = ns.CreateCheckBox(general, "threatMeter", true, true)
threatMeter:SetPoint("LEFT", buffReminder, "RIGHT", 240, 0)

local helmCloak = ns.CreateCheckBox(general, "helmcloakbuttons", true, true)
helmCloak:SetPoint("TOPLEFT", threatMeter, "BOTTOMLEFT", 0, -8)

local mailButton = ns.CreateCheckBox(general, "mailButton", true, true)
mailButton:SetPoint("TOPLEFT", helmCloak, "BOTTOMLEFT", 0, -8)

local rareAlert = ns.CreateCheckBox(general, "rareAlert", true)
rareAlert:SetPoint("TOPLEFT", mailButton, "BOTTOMLEFT", 0, -8)

local rareAlertPlaySound = ns.CreateCheckBox(general, "rareAlert_playSound")
rareAlertPlaySound:SetPoint("TOPLEFT", rareAlert, "BOTTOMLEFT", 16, -8)

rareAlert.children = {rareAlertPlaySound}

local nameplates = ns.CreateCheckBox(general, "nameplates", true, true)
nameplates:SetPoint("TOPLEFT", rareAlert, "BOTTOMLEFT", 0, -42)

local tolBarad = ns.CreateCheckBox(general, "tolbarad", true, true)
tolBarad:SetPoint("TOPLEFT", nameplates, "BOTTOMLEFT", 0, -8)

local undressButton = ns.CreateCheckBox(general, "undressButton", true, true)
undressButton:SetPoint("TOPLEFT", tolBarad, "BOTTOMLEFT", 0, -8)

local line = general:CreateTexture(nil, "ARTWORK")
line:SetSize(450, 1)
line:SetPoint("TOPLEFT", interruptOutdoors, "BOTTOMLEFT", 16, -36)
line:SetTexture(1, 1, 1, .2)

local uiScaleAuto = ns.CreateCheckBox(general, "uiScaleAuto", true)
uiScaleAuto:SetPoint("TOPLEFT", interruptOutdoors, "BOTTOMLEFT", -16, -66)

-- [[ Automation ]]

local automation = FreeUIOptionsPanel.automation
automation.tab.Icon:SetTexture("Interface\\Icons\\inv_pet_lilsmoky")

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

local autoSell = ns.CreateCheckBox(automation, "autoSell", true)
autoSell:SetPoint("TOPLEFT", autoRoll, "BOTTOMLEFT", 0, -42)

local questRewardHighlight = ns.CreateCheckBox(automation, "questRewardHighlight", true)
questRewardHighlight:SetPoint("TOPLEFT", autoSell, "BOTTOMLEFT", 0, -8)

local autoSetRole = ns.CreateCheckBox(automation, "autoSetRole", true)
autoSetRole:SetPoint("TOPLEFT", questRewardHighlight, "BOTTOMLEFT", 0, -8)

local autoSetRoleUseSpec = ns.CreateCheckBox(automation, "autoSetRole_useSpec", true)
autoSetRoleUseSpec:SetPoint("TOPLEFT", autoSetRole, "BOTTOMLEFT", 16, -8)

local autoSetRoleVerbose = ns.CreateCheckBox(automation, "autoSetRole_verbose", true)
autoSetRoleVerbose:SetPoint("TOPLEFT", autoSetRoleUseSpec, "BOTTOMLEFT", 0, -8)

autoSetRole.children = {autoSetRoleUseSpec, autoSetRoleVerbose}

-- [[ Action bars ]]

local actionbars = FreeUIOptionsPanel.actionbars
for i = 1, 4 do
	local tex = actionbars.tab:CreateTexture(nil, "OVERLAY")
	tex:SetSize(15, 15)
	tex:SetTexCoord(.08, .92, .08, .92)
	if i == 1 then
		tex:SetTexture("Interface\\Icons\\Ability_Warrior_SavageBlow")
		tex:SetPoint("TOPLEFT", actionbars.tab.Icon, "TOPLEFT")
	elseif i == 2 then
		tex:SetTexture("Interface\\Icons\\Ability_Warrior_ColossusSmash")
		tex:SetPoint("TOPRIGHT", actionbars.tab.Icon, "TOPRIGHT")
	elseif i == 3 then
		tex:SetTexture("Interface\\Icons\\Ability_Warrior_Charge")
		tex:SetPoint("BOTTOMLEFT", actionbars.tab.Icon, "BOTTOMLEFT")
	else
		tex:SetTexture("Interface\\Icons\\Ability_Warrior_Safeguard")
		tex:SetPoint("BOTTOMRIGHT", actionbars.tab.Icon, "BOTTOMRIGHT")
	end
end

local enable = ns.CreateCheckBox(actionbars, "enable", true, true)
enable:SetPoint("TOPLEFT", actionbars.subText, "BOTTOMLEFT", 0, -8)

local enableStyle = ns.CreateCheckBox(actionbars, "enableStyle", true, true)
enableStyle:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

local rightBarsMouseover = ns.CreateCheckBox(actionbars, "rightbars_mouseover", false, true)
rightBarsMouseover:SetPoint("TOPLEFT", enableStyle, "BOTTOMLEFT", 0, -8)

enable.children = {rightBarsMouseover}

local hotKey = ns.CreateCheckBox(actionbars, "hotkey")
hotKey:SetPoint("TOPLEFT", rightBarsMouseover, "BOTTOMLEFT", 0, -8)

enableStyle.children = {hotKey}

local function toggleActionBarsOptions()
	local shown = enable:GetChecked() == 1
	enableStyle:SetShown(shown)
	rightBarsMouseover:SetShown(shown)
	hotKey:SetShown(shown)
end

enable:HookScript("OnClick", toggleActionBarsOptions)
actionbars:HookScript("OnShow", toggleActionBarsOptions)

-- [[ Bags ]]

local bags = FreeUIOptionsPanel.bags
bags.tab.Icon:SetTexture("Interface\\Icons\\inv_misc_bag_08")

local enable = ns.CreateCheckBox(bags, "enable", true, true)
enable:SetPoint("TOPLEFT", bags.subText, "BOTTOMLEFT", 0, -8)

local slotsShowAlways = ns.CreateCheckBox(bags, "slotsShowAlways", true)
slotsShowAlways:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

local size = ns.CreateNumberSlider(bags, "size", SMALL, LARGE, 8, 100, 1)
size:SetPoint("TOPLEFT", slotsShowAlways, "BOTTOMLEFT", 18, -42)

local function toggleBagsOptions()
	local shown = enable:GetChecked() == 1
	slotsShowAlways:SetShown(shown)
	size:SetShown(shown)
end

enable:HookScript("OnClick", toggleBagsOptions)
bags:HookScript("OnShow", toggleBagsOptions)

-- [[ Notifications ]]

local notifications = FreeUIOptionsPanel.notifications
notifications.tab.Icon:SetTexture("Interface\\Icons\\inv_misc_enggizmos_27")

local enable = ns.CreateCheckBox(notifications, "enable", true, true)
enable:SetPoint("TOPLEFT", notifications.subText, "BOTTOMLEFT", 0, -8)

local checkMail = ns.CreateCheckBox(notifications, "checkMail", true)
checkMail:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

local checkEvents = ns.CreateCheckBox(notifications, "checkEvents", true)
checkEvents:SetPoint("TOPLEFT", checkMail, "BOTTOMLEFT", 0, -8)

local checkGuildEvents = ns.CreateCheckBox(notifications, "checkGuildEvents", true)
checkGuildEvents:SetPoint("TOPLEFT", checkEvents, "BOTTOMLEFT", 0, -8)

local playSounds = ns.CreateCheckBox(notifications, "playSounds", true)
playSounds:SetPoint("LEFT", enable, "RIGHT", 240, 0)

local animations = ns.CreateCheckBox(notifications, "animations", true)
animations:SetPoint("TOPLEFT", playSounds, "BOTTOMLEFT", 0, -8)

local timeShown = ns.CreateNumberSlider(notifications, "timeShown", "1 sec", "10 sec", 1, 10, 1)
timeShown:SetPoint("TOPLEFT", animations, "BOTTOMLEFT", 18, -30)

local function toggleNotificationsOptions()
	local shown = enable:GetChecked() == 1
	checkMail:SetShown(shown)
	checkEvents:SetShown(shown)
	checkGuildEvents:SetShown(shown)
	playSounds:SetShown(shown)
	animations:SetShown(shown)
	timeShown:SetShown(shown)
end

enable:HookScript("OnClick", toggleNotificationsOptions)
notifications:HookScript("OnShow", toggleNotificationsOptions)

-- [[ Unit frames ]]

local unitframes = FreeUIOptionsPanel.unitframes
unitframes.tab.Icon:SetTexture("Interface\\Icons\\Spell_Holy_PrayerofSpirit")

local enable = ns.CreateCheckBox(unitframes, "enable", true, true)
enable:SetPoint("TOPLEFT", unitframes.subText, "BOTTOMLEFT", 0, -8)

local autoPosition = ns.CreateCheckBox(unitframes, "autoPosition", true, true)
autoPosition:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

local enableGroup = ns.CreateCheckBox(unitframes, "enableGroup", true, true)
enableGroup:SetPoint("TOPLEFT", autoPosition, "BOTTOMLEFT", 0, -8)

local limitRaidSize = ns.CreateCheckBox(unitframes, "limitRaidSize", true)
limitRaidSize:SetPoint("TOPLEFT", enableGroup, "BOTTOMLEFT", 16, -8)
tinsert(ns.protectOptions, limitRaidSize)

local healerClasscolours = ns.CreateCheckBox(unitframes, "healerClasscolours", true, true)
healerClasscolours:SetPoint("TOPLEFT", limitRaidSize, "BOTTOMLEFT", 0, -8)

local partyNameAlways = ns.CreateCheckBox(unitframes, "partyNameAlways", true, true)
partyNameAlways:SetPoint("TOPLEFT", healerClasscolours, "BOTTOMLEFT", 0, -8)

enableGroup.children = {limitRaidSize, healerClasscolours, partyNameAlways}

local absorb = ns.CreateCheckBox(unitframes, "absorb", true, true)
absorb:SetPoint("LEFT", autoPosition, "RIGHT", 240, 0)

local targettarget = ns.CreateCheckBox(unitframes, "targettarget", true, true)
targettarget:SetPoint("TOPLEFT", absorb, "BOTTOMLEFT", 0, -8)

local pvp = ns.CreateCheckBox(unitframes, "pvp", true, true)
pvp:SetPoint("TOPLEFT", targettarget, "BOTTOMLEFT", 0, -8)

local castbarSeparate = ns.CreateCheckBox(unitframes, "castbarSeparate", true, true)
castbarSeparate:SetPoint("TOPLEFT", pvp, "BOTTOMLEFT", 0, -8)

local castbarSeparateOnlyCasters = ns.CreateCheckBox(unitframes, "castbarSeparateOnlyCasters", true, true)
castbarSeparateOnlyCasters:SetPoint("TOPLEFT", castbarSeparate, "BOTTOMLEFT", 16, -8)

castbarSeparate.children = {castbarSeparateOnlyCasters}

local enableArena = ns.CreateCheckBox(unitframes, "enableArena", true, true)
enableArena:SetPoint("TOPLEFT", enableGroup, "BOTTOMLEFT", 0, -110)

local layoutText = unitframes:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
layoutText:SetPoint("TOP", 0, -374)
layoutText:SetText(ns.localization.layoutText)

unitframes.Layout = CreateFrame("Button", nil, unitframes, "UIPanelButtonTemplate")
unitframes.Layout:SetPoint("TOP", 0, -408)
unitframes.Layout:SetSize(128, 25)
tinsert(ns.buttons, unitframes.Layout)

local function toggleUFOptions()
	local shown = enable:GetChecked() == 1

	enableGroup:SetShown(shown)
	limitRaidSize:SetShown(shown)
	healerClasscolours:SetShown(shown)
	partyNameAlways:SetShown(shown)
	absorb:SetShown(shown)
	targettarget:SetShown(shown)
	pvp:SetShown(shown)
	castbarSeparate:SetShown(shown)
	castbarSeparateOnlyCasters:SetShown(shown)
	enableArena:SetShown(shown)
	layoutText:SetShown(shown)
	unitframes.Layout:SetShown(shown)
end

enable:HookScript("OnClick", toggleUFOptions)
unitframes:HookScript("OnShow", toggleUFOptions)

-- [[ Tooltip ]]

local tooltip = FreeUIOptionsPanel.tooltip
tooltip.tab.Icon:SetTexture("Interface\\Icons\\INV_Enchant_FormulaEpic_01")

local anchorCursor = ns.CreateCheckBox(tooltip, "anchorCursor")
anchorCursor:SetPoint("TOPLEFT", tooltip.subText, "BOTTOMLEFT", 0, -8)

local guildrank = ns.CreateCheckBox(tooltip, "guildrank")
guildrank:SetPoint("TOPLEFT", anchorCursor, "BOTTOMLEFT", 0, -8)

local title = ns.CreateCheckBox(tooltip, "title", true)
title:SetPoint("TOPLEFT", guildrank, "BOTTOMLEFT", 0, -8)

-- [[ Class specific ]]

local classmod = FreeUIOptionsPanel.classmod
classmod.tab.Icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
local tcoords = CLASS_ICON_TCOORDS[select(2, UnitClass("player"))]
classmod.tab.Icon:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)

ns.classOptions = {}

local deathknight = ns.CreateCheckBox(classmod, "deathknight", false, true)
deathknight:SetPoint("TOPLEFT", classmod.subText, "BOTTOMLEFT", -2, -8)
tinsert(ns.classOptions, deathknight)

local druid = ns.CreateCheckBox(classmod, "druid", false, true)
druid:SetPoint("TOPLEFT", deathknight, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, druid)

local mage = ns.CreateCheckBox(classmod, "mage", false, true)
mage:SetPoint("TOPLEFT", druid, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, mage)

local monk = ns.CreateCheckBox(classmod, "monk", false, true)
monk:SetPoint("TOPLEFT", mage, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, monk)

local paladinHP = ns.CreateCheckBox(classmod, "paladinHP", false, true)
paladinHP:SetPoint("TOPLEFT", monk, "BOTTOMLEFT", 0, -8)

local paladinRF = ns.CreateCheckBox(classmod, "paladinRF", false, true)
paladinRF:SetPoint("TOPLEFT", paladinHP, "BOTTOMLEFT", 0, -8)

local priest = ns.CreateCheckBox(classmod, "priest", false, true)
priest:SetPoint("TOPLEFT", paladinRF, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, priest)

local shaman = ns.CreateCheckBox(classmod, "shaman", false, true)
shaman:SetPoint("TOPLEFT", priest, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, shaman)

local warlock = ns.CreateCheckBox(classmod, "warlock", false, true)
warlock:SetPoint("TOPLEFT", shaman, "BOTTOMLEFT", 0, -8)
tinsert(ns.classOptions, warlock)

-- [[ Credits ]]

local credits = FreeUIOptionsPanel.credits
credits.tab.Icon:SetTexture("Interface\\Icons\\inv_valentinescard02")

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