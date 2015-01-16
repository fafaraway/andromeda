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

local OkayButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
OkayButton:SetPoint("BOTTOMRIGHT", -6, 6)
OkayButton:SetSize(128, 25)
OkayButton:SetText(OKAY)
OkayButton:SetScript("OnClick", function()
	options:Hide()
	if ns.needReload then
		PlaySound("igMainMenuOpen")
		options.popup:Show()
	end
end)

tinsert(ns.buttons, OkayButton)

local ProfileBox = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
ProfileBox:SetPoint("BOTTOMLEFT", 6, 6)
ProfileBox.Text:SetText(ns.localization.profile)
ProfileBox.tooltipText = ns.localization.profileTooltip
options.ProfileBox = ProfileBox

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
	options:SetAlpha(.2)
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

local credits = CreateFrame("Frame", "FreeUIOptionsPanelCredits", UIParent) -- implemented at bottom

local CreditsButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
CreditsButton:SetSize(128, 25)
CreditsButton:SetText(ns.localization.credits)
CreditsButton:SetScript("OnClick", function()
	credits:Show()
	options:SetAlpha(.2)
end)
tinsert(ns.buttons, CreditsButton)

local InstallButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
InstallButton:SetSize(128, 25)
InstallButton:SetPoint("TOP", CreditsButton, "BOTTOM", 0, -4)
InstallButton:SetText(ns.localization.install)
InstallButton:SetScript("OnClick", function()
	if IsAddOnLoaded("FreeUI_Install") then
		FreeUI_InstallFrame:Show()
	else
		EnableAddOn("FreeUI_Install")
		LoadAddOn("FreeUI_Install")
	end
	options:Hide()
end)
tinsert(ns.buttons, InstallButton)

local ResetButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
ResetButton:SetSize(128, 25)
ResetButton:SetPoint("TOP", InstallButton, "BOTTOM", 0, -4)
ResetButton:SetText(RESET)
ResetButton:SetScript("OnClick", function()
	resetFrame:Show()
end)
tinsert(ns.buttons, ResetButton)

local line = options:CreateTexture()
line:SetSize(1, 568)
line:SetPoint("TOPLEFT", 190, -58)
line:SetTexture(1, 1, 1, .2)

local menuButton = CreateFrame("Button", "GameMenuButtonFreeUI", GameMenuFrame, "GameMenuButtonTemplate")
menuButton:SetSize(144, 21)
menuButton:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0, -1)
menuButton:SetText("FreeUI")
tinsert(ns.buttons, menuButton)

GameMenuButtonKeybindings:ClearAllPoints()
GameMenuButtonKeybindings:SetPoint("TOP", menuButton, "BOTTOM", 0, -1)

menuButton:SetScript("OnClick", function()
	ToggleFrame(GameMenuFrame)
	options:Show()
end)

ns.addCategory("General")
ns.addCategory("Appearance")
ns.addCategory("Automation")
ns.addCategory("ActionBars")
ns.addCategory("Bags")
ns.addCategory("MenuBar")
ns.addCategory("Notifications")
ns.addCategory("Tooltip")
ns.addCategory("UnitFrames")
ns.addCategory("ClassMod")

CreditsButton:SetPoint("TOP", options.lastCategoryTab, "BOTTOM", 0, -136)

-- [[ General ]]

do
	local general = FreeUIOptionsPanel.general
	general.tab.Icon:SetTexture("Interface\\Icons\\inv_gizmo_02")

	local features = ns.addSubCategory(general, ns.localization.generalFeatures)
	features:SetPoint("TOPLEFT", general.subText, "BOTTOMLEFT", 0, -8)

	local buffReminder = ns.CreateCheckBox(general, "buffreminder", true, true)
	buffReminder:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -20)

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

	local undressButton = ns.CreateCheckBox(general, "undressButton", true, true)
	undressButton:SetPoint("TOPLEFT", nameplates, "BOTTOMLEFT", 0, -8)

	local misc = ns.addSubCategory(general, ns.localization.generalMisc)
	misc:SetPoint("TOPLEFT", interruptOutdoors, "BOTTOMLEFT", -16, -30)

	local uiScaleAuto = ns.CreateCheckBox(general, "uiScaleAuto", true)
	uiScaleAuto:SetPoint("TOPLEFT", misc, "BOTTOMLEFT", 0, -20)
end

-- [[ Appearance ]]

do
	local appearance = FreeUIOptionsPanel.appearance
	appearance.tab.Icon:SetTexture("Interface\\Icons\\inv_ore_arcanite_01")

	local colours = ns.addSubCategory(appearance, ns.localization.appearanceColours)
	colours:SetPoint("TOPLEFT", appearance.subText, "BOTTOMLEFT", 0, -8)

	local colourScheme = ns.CreateRadioButtonGroup(appearance, "colourScheme", 2, true, true)
	colourScheme.buttons[1]:SetPoint("TOPLEFT", colours, "BOTTOMLEFT", 0, -41)

	local customColour = ns.CreateColourPicker(appearance, "customColour", true)
	customColour:SetPoint("LEFT", colourScheme.buttons[2].text, "RIGHT", 6, 0)

	local fonts = ns.addSubCategory(appearance, ns.localization.appearanceFonts)
	fonts:SetPoint("TOPLEFT", colourScheme.buttons[2], "BOTTOMLEFT", 0, -30)

	local fontUseAlternativeFont = ns.CreateCheckBox(appearance, "fontUseAlternativeFont", true, true)
	fontUseAlternativeFont:SetPoint("TOPLEFT", fonts, "BOTTOMLEFT", 0, -20)

	local fontSizeNormal = ns.CreateNumberSlider(appearance, "fontSizeNormal", 5, 32, 5, 32, 1, true)
	fontSizeNormal:SetPoint("TOPLEFT", fontUseAlternativeFont, "BOTTOMLEFT", 16, -26)

	appearance.normalSample = appearance:CreateFontString()
	appearance.normalSample:SetPoint("TOPLEFT", fontSizeNormal, "BOTTOMLEFT", 0, -16)

	local fontSizeLarge = ns.CreateNumberSlider(appearance, "fontSizeLarge", 5, 32, 5, 32, 1, true)
	fontSizeLarge:SetPoint("TOPLEFT", appearance.normalSample, "BOTTOMLEFT", 0, -26)

	appearance.largeSample = appearance:CreateFontString()
	appearance.largeSample:SetPoint("TOPLEFT", fontSizeLarge, "BOTTOMLEFT", 0, -16)

	local fontOutline = ns.CreateCheckBox(appearance, "fontOutline", false, true)
	fontOutline:SetPoint("LEFT", fontUseAlternativeFont, "RIGHT", 240, 0)

	local fontOutlineStyle = ns.CreateRadioButtonGroup(appearance, "fontOutlineStyle", 2, true, true)
	fontOutlineStyle.buttons[1]:SetPoint("TOPLEFT", fontOutline, "BOTTOMLEFT", 17, -29)
	fontOutline.children = {fontOutlineStyle}

	local fontShadow = ns.CreateCheckBox(appearance, "fontShadow", false, true)
	fontShadow:SetPoint("TOPLEFT", fontOutline, "BOTTOMLEFT", 0, -76)
end

-- [[ Automation ]]

do
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
end

-- [[ Action bars ]]

do
	local actionbars = FreeUIOptionsPanel.actionbars
	for i = 1, 4 do
		local tex = actionbars.tab:CreateTexture(nil, "OVERLAY")
		tex:SetSize(11, 11)
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
		local shown = enable:GetChecked()
		enableStyle:SetShown(shown)
		rightBarsMouseover:SetShown(shown)
		hotKey:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleActionBarsOptions)
	actionbars:HookScript("OnShow", toggleActionBarsOptions)
end

-- [[ Bags ]]

do
	local bags = FreeUIOptionsPanel.bags
	bags.tab.Icon:SetTexture("Interface\\Icons\\inv_misc_bag_08")
	tinsert(ns.newCategories, bags)

	local general = ns.addSubCategory(bags, ns.localization.bagsGeneral)
	general:SetPoint("TOPLEFT", bags.subText, "BOTTOMLEFT", 0, -8)

	local style = ns.CreateRadioButtonGroup(bags, "style", 3, false, true)
	style.buttons[1]:SetPoint("TOPLEFT", general, "BOTTOMLEFT", 0, -41)
	tinsert(ns.newOptions, style.buttons[2])

	local styleSpecific, styleSpecificLine = ns.addSubCategory(bags, ns.localization.bagsStyleSpecific)
	styleSpecific:SetPoint("TOPLEFT", style.buttons[3], "BOTTOMLEFT", 0, -30)

	local slotsShowAlways = ns.CreateCheckBox(bags, "slotsShowAlways", true)
	slotsShowAlways:SetPoint("TOPLEFT", styleSpecific, "BOTTOMLEFT", 0, -20)

	local size = ns.CreateNumberSlider(bags, "size", SMALL, LARGE, 8, 100, 1)
	size:SetPoint("TOPLEFT", slotsShowAlways, "BOTTOMLEFT", 8, -42)

	local hideSlots = ns.CreateCheckBox(bags, "hideSlots", true)
	hideSlots:SetPoint("TOPLEFT", styleSpecific, "BOTTOMLEFT", 0, -20)
	tinsert(ns.newOptions, hideSlots)

	local function toggleBagsOptions()
		local isAllInOne = style.buttons[1]:GetChecked()

		slotsShowAlways:SetShown(isAllInOne)
		size:SetShown(isAllInOne)
		hideSlots:SetShown(not isAllInOne)
	end

	for _, button in pairs(style.buttons) do
		button:HookScript("OnClick", toggleBagsOptions)
	end

	bags:HookScript("OnShow", toggleBagsOptions)
end

-- [[ Menu bar ]]

do
	local menubar = FreeUIOptionsPanel.menubar
	menubar.tab.Icon:SetTexture("Interface\\Icons\\inv_misc_enggizmos_swissarmy")

	local enable = ns.CreateCheckBox(menubar, "enable", false, true)
	enable:SetPoint("TOPLEFT", menubar.subText, "BOTTOMLEFT", 0, -8)

	local enableButtons = ns.CreateCheckBox(menubar, "enableButtons", true, true)
	enableButtons:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

	local buttonsMouseover = ns.CreateCheckBox(menubar, "buttons_mouseover", true)
	buttonsMouseover:SetPoint("TOPLEFT", enableButtons, "BOTTOMLEFT", 16, -8)
end

-- [[ Notifications ]]

do
	local notifications = FreeUIOptionsPanel.notifications
	notifications.tab.Icon:SetTexture("Interface\\Icons\\inv_misc_enggizmos_27")

	local enable = ns.CreateCheckBox(notifications, "enable", true, true)
	enable:SetPoint("TOPLEFT", notifications.subText, "BOTTOMLEFT", 0, -8)

	local when, whenLine = ns.addSubCategory(notifications, ns.localization.notificationsWhen)
	when:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -30)

	local checkBagsFull = ns.CreateCheckBox(notifications, "checkBagsFull", true)
	checkBagsFull:SetPoint("TOPLEFT", when, "BOTTOMLEFT", 0, -20)

	local checkEvents = ns.CreateCheckBox(notifications, "checkEvents", true)
	checkEvents:SetPoint("TOPLEFT", checkBagsFull, "BOTTOMLEFT", 0, -8)

	local checkGuildEvents = ns.CreateCheckBox(notifications, "checkGuildEvents", true)
	checkGuildEvents:SetPoint("TOPLEFT", checkEvents, "BOTTOMLEFT", 0, -8)

	local checkMail = ns.CreateCheckBox(notifications, "checkMail", true)
	checkMail:SetPoint("TOPLEFT", checkGuildEvents, "BOTTOMLEFT", 0, -8)

	local how, howLine = ns.addSubCategory(notifications, ns.localization.notificationsHow)
	how:SetPoint("TOPLEFT", checkMail, "BOTTOMLEFT", 0, -30)

	local playSounds = ns.CreateCheckBox(notifications, "playSounds", true)
	playSounds:SetPoint("TOPLEFT", how, "BOTTOMLEFT", 0, -20)

	local animations = ns.CreateCheckBox(notifications, "animations", true)
	animations:SetPoint("TOPLEFT", playSounds, "BOTTOMLEFT", 0, -8)

	local timeShown = ns.CreateNumberSlider(notifications, "timeShown", "1 sec", "10 sec", 1, 10, 1)
	timeShown:SetPoint("TOPLEFT", animations, "BOTTOMLEFT", 8, -30)

	local previewButton = CreateFrame("Button", nil, notifications, "UIPanelButtonTemplate")
	previewButton:SetPoint("TOPLEFT", timeShown, "BOTTOMLEFT", -8, -40)
	previewButton:SetSize(128, 25)
	previewButton:SetText(ns.localization.notificationsPreview)
	tinsert(ns.buttons, previewButton)
	notifications.previewButton = previewButton

	local function toggleNotificationsOptions()
		local shown = enable:GetChecked()
		when:SetShown(shown)
		whenLine:SetShown(shown)
		how:SetShown(shown)
		howLine:SetShown(shown)
		checkBagsFull:SetShown(shown)
		checkMail:SetShown(shown)
		checkEvents:SetShown(shown)
		checkGuildEvents:SetShown(shown)
		playSounds:SetShown(shown)
		animations:SetShown(shown)
		timeShown:SetShown(shown)
		previewButton:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleNotificationsOptions)
	notifications:HookScript("OnShow", toggleNotificationsOptions)
end

-- [[ Unit frames ]]

do
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

	local enableArena = ns.CreateCheckBox(unitframes, "enableArena", true, true)
	enableArena:SetPoint("TOPLEFT", enableGroup, "BOTTOMLEFT", 0, -110)

	local targettarget = ns.CreateCheckBox(unitframes, "targettarget", true, true)
	targettarget:SetPoint("TOPLEFT", enableArena, "BOTTOMLEFT", 0, -8)

	local absorb = ns.CreateCheckBox(unitframes, "absorb", true, true)
	absorb:SetPoint("LEFT", autoPosition, "RIGHT", 240, 0)

	local castbarSeparate = ns.CreateCheckBox(unitframes, "castbarSeparate", true, true)
	castbarSeparate:SetPoint("TOPLEFT", absorb, "BOTTOMLEFT", 0, -8)

	local castbarSeparateOnlyCasters = ns.CreateCheckBox(unitframes, "castbarSeparateOnlyCasters", true, true)
	castbarSeparateOnlyCasters:SetPoint("TOPLEFT", castbarSeparate, "BOTTOMLEFT", 16, -8)

	castbarSeparate.children = {castbarSeparateOnlyCasters}

	local pvp = ns.CreateCheckBox(unitframes, "pvp", true, true)
	pvp:SetPoint("TOPLEFT", castbarSeparate, "BOTTOMLEFT", 0, -42)

	local statusIndicator = ns.CreateCheckBox(unitframes, "statusIndicator", true)
	statusIndicator:SetPoint("TOPLEFT", pvp, "BOTTOMLEFT", 0, -8)

	local statusIndicatorCombat = ns.CreateCheckBox(unitframes, "statusIndicatorCombat", true)
	statusIndicatorCombat:SetPoint("TOPLEFT", statusIndicator, "BOTTOMLEFT", 16, -8)

	statusIndicator.children = {statusIndicatorCombat}

	local layoutText = unitframes:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	layoutText:SetPoint("TOP", 0, -408)
	layoutText:SetText(ns.localization.layoutText)

	unitframes.Layout = CreateFrame("Button", nil, unitframes, "UIPanelButtonTemplate")
	unitframes.Layout:SetPoint("TOP", 0, -442)
	unitframes.Layout:SetSize(128, 25)
	tinsert(ns.buttons, unitframes.Layout)

	local function toggleUFOptions()
		local shown = enable:GetChecked()

		autoPosition:SetShown(shown)
		enableGroup:SetShown(shown)
		limitRaidSize:SetShown(shown)
		healerClasscolours:SetShown(shown)
		partyNameAlways:SetShown(shown)
		absorb:SetShown(shown)
		targettarget:SetShown(shown)
		pvp:SetShown(shown)
		statusIndicator:SetShown(shown)
		statusIndicatorCombat:SetShown(shown)
		castbarSeparate:SetShown(shown)
		castbarSeparateOnlyCasters:SetShown(shown)
		enableArena:SetShown(shown)
		layoutText:SetShown(shown)
		unitframes.Layout:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleUFOptions)
	unitframes:HookScript("OnShow", toggleUFOptions)
end

-- [[ Tooltip ]]

do
	local tooltip = FreeUIOptionsPanel.tooltip
	tooltip.tab.Icon:SetTexture("Interface\\Icons\\INV_Enchant_FormulaEpic_01")

	local enable = ns.CreateCheckBox(tooltip, "enable", true, true)
	enable:SetPoint("TOPLEFT", tooltip.subText, "BOTTOMLEFT", 0, -8)

	local anchorCursor = ns.CreateCheckBox(tooltip, "anchorCursor")
	anchorCursor:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -16)

	local guildrank = ns.CreateCheckBox(tooltip, "guildrank")
	guildrank:SetPoint("TOPLEFT", anchorCursor, "BOTTOMLEFT", 0, -8)

	local title = ns.CreateCheckBox(tooltip, "title")
	title:SetPoint("TOPLEFT", guildrank, "BOTTOMLEFT", 0, -8)

	local pvp = ns.CreateCheckBox(tooltip, "pvp")
	pvp:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

	local function toggleTooltipOptions()
		local shown = enable:GetChecked()

		anchorCursor:SetShown(shown)
		guildrank:SetShown(shown)
		title:SetShown(shown)
		pvp:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleTooltipOptions)
	tooltip:HookScript("OnShow", toggleTooltipOptions)
end

-- [[ Class specific ]]

do
	local classmod = FreeUIOptionsPanel.classmod
	classmod.tab.Icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	local tcoords = CLASS_ICON_TCOORDS[select(2, UnitClass("player"))]
	classmod.tab.Icon:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)

	ns.classOptions = {}

	local deathknight = ns.CreateCheckBox(classmod, "deathknight", false, true)
	deathknight:SetPoint("TOPLEFT", classmod.subText, "BOTTOMLEFT", -2, -8)
	deathknight.className = "DEATHKNIGHT"
	tinsert(ns.classOptions, deathknight)

	local druidMana = ns.CreateCheckBox(classmod, "druidMana", false, true)
	druidMana:SetPoint("TOPLEFT", deathknight, "BOTTOMLEFT", 0, -8)
	druidMana.className = "DRUID"
	tinsert(ns.classOptions, druidMana)

	local druidEclipse = ns.CreateCheckBox(classmod, "druidEclipse", false, true)
	druidEclipse:SetPoint("TOPLEFT", druidMana, "BOTTOMLEFT", 0, -8)
	druidEclipse.className = "DRUID"
	tinsert(ns.classOptions, druidEclipse)

	local mage = ns.CreateCheckBox(classmod, "mage", false, true)
	mage:SetPoint("TOPLEFT", druidEclipse, "BOTTOMLEFT", 0, -8)
	mage.className = "MAGE"
	tinsert(ns.classOptions, mage)

	local monk = ns.CreateCheckBox(classmod, "monk", false, true)
	monk:SetPoint("TOPLEFT", mage, "BOTTOMLEFT", 0, -8)
	monk.className = "MONK"
	tinsert(ns.classOptions, monk)

	local paladinHP = ns.CreateCheckBox(classmod, "paladinHP", false, true)
	paladinHP:SetPoint("TOPLEFT", monk, "BOTTOMLEFT", 0, -8)
	paladinHP.className = "PALADIN"
	tinsert(ns.classOptions, paladinHP)

	local paladinRF = ns.CreateCheckBox(classmod, "paladinRF", false, true)
	paladinRF:SetPoint("TOPLEFT", paladinHP, "BOTTOMLEFT", 0, -8)
	paladinRF.className = "PALADIN"
	tinsert(ns.classOptions, paladinRF)

	local priest = ns.CreateCheckBox(classmod, "priest", false, true)
	priest:SetPoint("TOPLEFT", paladinRF, "BOTTOMLEFT", 0, -8)
	priest.className = "PRIEST"
	tinsert(ns.classOptions, priest)

	local warlock = ns.CreateCheckBox(classmod, "warlock", false, true)
	warlock:SetPoint("TOPLEFT", priest, "BOTTOMLEFT", 0, -8)
	warlock.className = "WARLOCK"
	tinsert(ns.classOptions, warlock)
end

-- [[ Credits ]]

do
	credits:SetSize(525, 600)
	credits:SetPoint("CENTER")
	credits:SetFrameStrata("DIALOG")
	credits:EnableMouse(true)
	credits:Hide()
	options.credits = credits

	tinsert(UISpecialFrames, credits:GetName())

	credits.CloseButton = CreateFrame("Button", nil, credits, "UIPanelCloseButton")

	local closeButton = CreateFrame("Button", nil, credits, "UIPanelButtonTemplate")
	closeButton:SetSize(128, 25)
	closeButton:SetPoint("BOTTOM", 0, 25)
	closeButton:SetText(CLOSE)
	closeButton:SetScript("OnClick", function()
		credits:Hide()
	end)
	tinsert(ns.buttons, closeButton)

	credits:SetScript("OnHide", function()
		options:SetAlpha(1)
	end)

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
end