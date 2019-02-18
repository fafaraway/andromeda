local _, ns = ...

local realm = GetRealmName()
local name = UnitName("player")

-- [[ Main window ]]

local options = CreateFrame("Frame", "FreeUIOptionsPanel", UIParent)
options:SetSize(780, 800)
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
		PlaySound("851")
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
		PlaySound("850")
		options.popup:Show()
	end
end)

tinsert(ns.buttons, OkayButton)

local ProfileBox = CreateFrame("CheckButton", nil, options, "InterfaceOptionsCheckButtonTemplate")
ProfileBox:SetPoint("BOTTOMLEFT", 6, 6)
ProfileBox.Text:SetText(ns.localization.profile)
ProfileBox.tooltipText = ns.localization.profileTooltip
options.ProfileBox = ProfileBox



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

local credits = CreateFrame("Frame", "FreeUIOptionsPanelCredits", UIParent)

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
InstallButton:SetText(ns.localization.install)

tinsert(ns.buttons, InstallButton)


StaticPopupDialogs["FREEUI_RESET"] = {
	text = ns.localization.resetCheck,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FreeUIOptions = {}
		FreeUIOptionsPerChar = {}
		FreeUIOptionsGlobal[realm][name] = false
		C.options = FreeUIOptions
		ReloadUI()
	end,
	whileDead = true,
	hideOnEscape = true,
}

local ResetButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
ResetButton:SetSize(128, 25)
ResetButton:SetText(ns.localization.reset)
ResetButton:SetScript("OnClick", function()
	StaticPopup_Show("FREEUI_RESET")
	--resetFrame:Show()
end)
tinsert(ns.buttons, ResetButton)

local line = options:CreateTexture()
line:SetSize(1, 568)
line:SetPoint("TOPLEFT", 190, -58)
line:SetColorTexture(.5, .5, .5, .1)


ns.addCategory("general")
ns.addCategory("appearance")
ns.addCategory("automation")
ns.addCategory("notification")
ns.addCategory("infobar")
ns.addCategory("actionbar")
ns.addCategory("unitFrame")
ns.addCategory("inventory")
ns.addCategory("tooltip")
ns.addCategory("chat")
ns.addCategory("map")
ns.addCategory("classmod")

CreditsButton:SetPoint("BOTTOM", InstallButton, "TOP", 0, 4)
InstallButton:SetPoint("BOTTOM", ResetButton, "TOP", 0, 4)
ResetButton:SetPoint("TOP", FreeUIOptionsPanel.general.tab, "BOTTOM", 0, -600)



-- [[ General ]]

do
	local general = FreeUIOptionsPanel.general
	general.tab.Icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")

	local misc = ns.addSubCategory(general, ns.localization.generalmisc)
	misc:SetPoint("TOPLEFT", general.subText, "BOTTOMLEFT", 0, -8)

	local hideTalkingHead = ns.CreateCheckBox(general, "hideTalkingHead", true, true)
	hideTalkingHead:SetPoint("TOPLEFT", misc, "BOTTOMLEFT", 0, -8)

	local hideBossBanner = ns.CreateCheckBox(general, "hideBossBanner", true, true)
	hideBossBanner:SetPoint("LEFT", hideTalkingHead, "RIGHT", 240, 0)

	local flashCursor = ns.CreateCheckBox(general, "flashCursor", true, true)
	flashCursor:SetPoint("TOPLEFT", hideTalkingHead, "BOTTOMLEFT", 0, -8)

	local mailButton = ns.CreateCheckBox(general, "mailButton", true, true)
	mailButton:SetPoint("LEFT", flashCursor, "RIGHT", 240, 0)

	local quickMarking = ns.CreateCheckBox(general, "quickMarking", true, true)
	quickMarking:SetPoint("TOPLEFT", flashCursor, "BOTTOMLEFT", 0, -8)

	local quickFocusing = ns.CreateCheckBox(general, "quickFocusing", true, true)
	quickFocusing:SetPoint("LEFT", quickMarking, "RIGHT", 240, 0)

	local missingBuffs = ns.CreateCheckBox(general, "missingBuffs", true, true)
	missingBuffs:SetPoint("TOPLEFT", quickMarking, "BOTTOMLEFT", 0, -8)

	local missingStats = ns.CreateCheckBox(general, "missingStats", true, true)
	missingStats:SetPoint("LEFT", missingBuffs, "RIGHT", 240, 0)

	local fasterLoot = ns.CreateCheckBox(general, "fasterLoot", true, true)
	fasterLoot:SetPoint("TOPLEFT", missingBuffs, "BOTTOMLEFT", 0, -8)

	local PVPSound = ns.CreateCheckBox(general, "PVPSound", true, true)
	PVPSound:SetPoint("LEFT", fasterLoot, "RIGHT", 240, 0)

	local progressBar = ns.CreateCheckBox(general, "progressBar", true, true)
	progressBar:SetPoint("TOPLEFT", fasterLoot, "BOTTOMLEFT", 0, -8)

	local raidManager = ns.CreateCheckBox(general, "raidManager", true, true)
	raidManager:SetPoint("LEFT", progressBar, "RIGHT", 240, 0)

	local clickCast = ns.CreateCheckBox(general, "clickCast", true, true)
	clickCast:SetPoint("TOPLEFT", progressBar, "BOTTOMLEFT", 0, -8)

	local alreadyKnown = ns.CreateCheckBox(general, "alreadyKnown", true, true)
	alreadyKnown:SetPoint("LEFT", clickCast, "RIGHT", 240, 0)

	local cooldown = ns.addSubCategory(general, ns.localization.generalcooldown)
	cooldown:SetPoint("TOPLEFT", clickCast, "BOTTOMLEFT", 0, -16)

	local cooldownCount = ns.CreateCheckBox(general, "cooldownCount", true, true)
	cooldownCount:SetPoint("TOPLEFT", cooldown, "BOTTOMLEFT", 0, -8)

	local cooldownCount_decimal = ns.CreateCheckBox(general, "cooldownCount_decimal", true, true)
	cooldownCount_decimal:SetPoint("TOPLEFT", cooldownCount, "BOTTOMLEFT", 16, -4)

	cooldownCount.children = {cooldownCount_decimal}

	local cooldownPulse = ns.CreateCheckBox(general, "cooldownPulse", true, true)
	cooldownPulse:SetPoint("LEFT", cooldownCount, "RIGHT", 240, 0)

	local camera = ns.addSubCategory(general, ns.localization.generalcamera)
	camera:SetPoint("TOPLEFT", cooldownCount_decimal, "BOTTOMLEFT", -16, -12)

	local cameraIncrement = ns.CreateNumberSlider(general, "cameraIncrement", nil, nil, 1, 5, 1, true)
	cameraIncrement:SetPoint("TOPLEFT", camera, "BOTTOMLEFT", 0, -30)

	local uiscaleset = ns.addSubCategory(general, ns.localization.generaluiscaleset)
	uiscaleset:SetPoint("TOPLEFT", cameraIncrement, "BOTTOMLEFT", 0, -30)

	local uiScaleAuto = ns.CreateCheckBox(general, "uiScaleAuto", true, true)
	uiScaleAuto:SetPoint("TOPLEFT", uiscaleset, "BOTTOMLEFT", 0, -8)

	local uiScale = ns.CreateNumberSlider(general, "uiScale", nil, nil, .4, 1.1, .01, true)
	uiScale:SetPoint("TOPLEFT", uiScaleAuto, "BOTTOMLEFT", 0, -30)

	local function toggleUIScaleOptions()
		local shown = not uiScaleAuto:GetChecked()
		uiScale:SetShown(shown)

	end

	uiScaleAuto:HookScript("OnClick", toggleUIScaleOptions)
	uiScale:HookScript("OnShow", toggleUIScaleOptions)

end

-- [[ Appearance ]]

do
	local appearance = FreeUIOptionsPanel.appearance
	appearance.tab.Icon:SetTexture("Interface\\Icons\\Spell_Shadow_DeathAndDecay")

	local theme = ns.addSubCategory(appearance, ns.localization.appearancetheme)
	theme:SetPoint("TOPLEFT", appearance.subText, "BOTTOMLEFT", 0, -8)

	local enableTheme = ns.CreateCheckBox(appearance, "enableTheme", true, true)
	enableTheme:SetPoint("TOPLEFT", theme, "BOTTOMLEFT", 0, -8)

	local addShadowBorder = ns.CreateCheckBox(appearance, "addShadowBorder", true, true)
	addShadowBorder:SetPoint("TOPLEFT", enableTheme, "BOTTOMLEFT", 0, -8)

	local fontStyle = ns.CreateCheckBox(appearance, "reskinFonts", true, true)
	fontStyle:SetPoint("TOPLEFT", addShadowBorder, "BOTTOMLEFT", 0, -8)

	local vignette = ns.CreateCheckBox(appearance, "vignette", true, true)
	vignette:SetPoint("LEFT", addShadowBorder, "RIGHT", 240, 0)

	local vignetteAlpha = ns.CreateNumberSlider(appearance, "vignetteAlpha", nil, nil, .1, 1, .1, true)
	vignetteAlpha:SetPoint("TOPLEFT", vignette, "BOTTOMLEFT", 16, -20)

	local function togglevignetteOptions()
		local shown = vignette:GetChecked()
		vignetteAlpha:SetShown(shown)
	end

	vignette:HookScript("OnClick", togglevignetteOptions)
	vignetteAlpha:HookScript("OnShow", togglevignetteOptions)

	local colours = ns.addSubCategory(appearance, ns.localization.appearanceColours)
	colours:SetPoint("TOPLEFT", fontStyle, "BOTTOMLEFT", 0, -30)

	local colourScheme = ns.CreateRadioButtonGroup(appearance, "colourScheme", 2, true, true)
	colourScheme.buttons[1]:SetPoint("TOPLEFT", colours, "BOTTOMLEFT", 8, -30)

	local customColour = ns.CreateColourPicker(appearance, "customColour", true)
	customColour:SetPoint("LEFT", colourScheme.buttons[2].text, "RIGHT", 6, 0)

	local skin = ns.addSubCategory(appearance, ns.localization.appearanceskin)
	skin:SetPoint("TOPLEFT", colours, "BOTTOMLEFT", 0, -100)

	local objectiveTracker = ns.CreateCheckBox(appearance, "reskinQuestTracker", true, true)
	objectiveTracker:SetPoint("TOPLEFT", skin, "BOTTOMLEFT", 0, -8)

	local petBattle = ns.CreateCheckBox(appearance, "reskinPetBattle", true, true)
	petBattle:SetPoint("LEFT", objectiveTracker, "RIGHT", 240, 0)

	local addons = ns.addSubCategory(appearance, ns.localization.appearanceaddons)
	addons:SetPoint("TOPLEFT", objectiveTracker, "BOTTOMLEFT", 0, -20)

	local DBM = ns.CreateCheckBox(appearance, "reskinDBM", true, true)
	DBM:SetPoint("TOPLEFT", addons, "BOTTOMLEFT", 0, -8)

	local BW = ns.CreateCheckBox(appearance, "reskinBW", true, true)
	BW:SetPoint("LEFT", DBM, "RIGHT", 240, 0)

	local WA = ns.CreateCheckBox(appearance, "reskinWA", true, true)
	WA:SetPoint("TOPLEFT", DBM, "BOTTOMLEFT", 0, -8)

	local SKADA = ns.CreateCheckBox(appearance, "reskinSkada", true, true)
	SKADA:SetPoint("LEFT", WA, "RIGHT", 240, 0)

	local PGF = ns.CreateCheckBox(appearance, "reskinPGF", true, true)
	PGF:SetPoint("TOPLEFT", WA, "BOTTOMLEFT", 0, -8)
end

-- [[ Automation ]]

do
	local automation = FreeUIOptionsPanel.automation
	automation.tab.Icon:SetTexture("Interface\\Icons\\INV_Misc_EngGizmos_swissArmy")

	local autoScreenShot = ns.CreateCheckBox(automation, "autoScreenShot", true, true)
	autoScreenShot:SetPoint("TOPLEFT", automation.subText, "BOTTOMLEFT", 0, -8)

	local autoQuest = ns.CreateCheckBox(automation, "autoQuest", true, true)
	autoQuest:SetPoint("LEFT", autoScreenShot, "RIGHT", 240, 0)

	local autoRepair = ns.CreateCheckBox(automation, "autoRepair", true, true)
	autoRepair:SetPoint("TOPLEFT", autoScreenShot, "BOTTOMLEFT", 0, -8)

	local autoSellJunk = ns.CreateCheckBox(automation, "autoSellJunk", true, true)
	autoSellJunk:SetPoint("LEFT", autoRepair, "RIGHT", 240, 0)

	local autoTabBinder = ns.CreateCheckBox(automation, "autoTabBinder", true, true)
	autoTabBinder:SetPoint("TOPLEFT", autoRepair, "BOTTOMLEFT", 0, -8)

	local autoAcceptInvite = ns.CreateCheckBox(automation, "autoAcceptInvite", true, true)
	autoAcceptInvite:SetPoint("LEFT", autoTabBinder, "RIGHT", 240, 0)

	local autoActionCam = ns.CreateCheckBox(automation, "autoActionCam", true, true)
	autoActionCam:SetPoint("TOPLEFT", autoTabBinder, "BOTTOMLEFT", 0, -8)

	local autoSetRole = ns.CreateCheckBox(automation, "autoSetRole", true)
	autoSetRole:SetPoint("TOPLEFT", autoActionCam, "BOTTOMLEFT", 0, -8)

	local autoSetRoleUseSpec = ns.CreateCheckBox(automation, "autoSetRole_useSpec", true)
	autoSetRoleUseSpec:SetPoint("TOPLEFT", autoSetRole, "BOTTOMLEFT", 16, -8)

	local autoSetRoleVerbose = ns.CreateCheckBox(automation, "autoSetRole_verbose", true)
	autoSetRoleVerbose:SetPoint("TOPLEFT", autoSetRoleUseSpec, "BOTTOMLEFT", 0, -8)

	autoSetRole.children = {autoSetRoleUseSpec, autoSetRoleVerbose}
end

-- [[ Notifications ]]

do
	local notification = FreeUIOptionsPanel.notification
	notification.tab.Icon:SetTexture("Interface\\Icons\\Ability_Warrior_RallyingCry")

	local enable = ns.CreateCheckBox(notification, "enableNotification", true, true)
	enable:SetPoint("TOPLEFT", notification.subText, "BOTTOMLEFT", 0, -8)

	local playSounds = ns.CreateCheckBox(notification, "playSounds", true, true)
	playSounds:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -8)

	local checkBagsFull = ns.CreateCheckBox(notification, "checkBagsFull", true, true)
	checkBagsFull:SetPoint("TOPLEFT", playSounds, "BOTTOMLEFT", 0, -8)

	local checkMail = ns.CreateCheckBox(notification, "checkMail", true, true)
	checkMail:SetPoint("TOPLEFT", checkBagsFull, "BOTTOMLEFT", 0, -8)

	local alert = ns.addSubCategory(notification, ns.localization.notificationalert)
	alert:SetPoint("TOPLEFT", checkMail, "BOTTOMLEFT", -16, -20)

	local interrupt = ns.CreateCheckBox(notification, "interrupt", true, true)
	interrupt:SetPoint("TOPLEFT", alert, "BOTTOMLEFT", 0, -8)

	local interruptSound = ns.CreateCheckBox(notification, "interruptSound", true, true)
	interruptSound:SetPoint("TOPLEFT", interrupt, "BOTTOMLEFT", 16, -8)

	interrupt.children = {interruptSound}

	local dispel = ns.CreateCheckBox(notification, "dispel", true, true)
	dispel:SetPoint("LEFT", interrupt, "RIGHT", 240, 0)

	local dispelSound = ns.CreateCheckBox(notification, "dispelSound", true, true)
	dispelSound:SetPoint("TOPLEFT", dispel, "BOTTOMLEFT", 16, -8)

	dispel.children = {dispelSound}

	local spell = ns.CreateCheckBox(notification, "spell", true, true)
	spell:SetPoint("TOPLEFT", interruptSound, "BOTTOMLEFT", -16, -8)

	local resurrect = ns.CreateCheckBox(notification, "resurrect", true, true)
	resurrect:SetPoint("LEFT", spell, "RIGHT", 240, 0)

	local sapped = ns.CreateCheckBox(notification, "sapped", true, true)
	sapped:SetPoint("TOPLEFT", spell, "BOTTOMLEFT", 0, -8)

	local rare = ns.CreateCheckBox(notification, "rare", true, true)
	rare:SetPoint("TOPLEFT", sapped, "BOTTOMLEFT", 0, -8)

	local rareSound = ns.CreateCheckBox(notification, "rareSound", true, true)
	rareSound:SetPoint("TOPLEFT", rare, "BOTTOMLEFT", 16, -8)

	rare.children = {rareSound}
	

	local function toggleNotificationOptions()
		local shown = enable:GetChecked()
		checkBagsFull:SetShown(shown)
		checkMail:SetShown(shown)
		playSounds:SetShown(shown)

	end

	enable:HookScript("OnClick", toggleNotificationOptions)
	notification:HookScript("OnShow", toggleNotificationOptions)
end

-- [[ Info bar ]]

do
	local infobar = FreeUIOptionsPanel.infobar
	infobar.tab.Icon:SetTexture("Interface\\Icons\\INV_Misc_ScrollRolled02d")

	local enable = ns.CreateCheckBox(infobar, "enable", true, true)
	enable:SetPoint("TOPLEFT", infobar.subText, "BOTTOMLEFT", 0, -8)

	local mouseover = ns.CreateCheckBox(infobar, "mouseover", true, true)
	mouseover:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -8)

	local stats = ns.CreateCheckBox(infobar, "stats", true, true)
	stats:SetPoint("TOPLEFT", mouseover, "BOTTOMLEFT", 0, -8)

	local microMenu = ns.CreateCheckBox(infobar, "microMenu", true, true)
	microMenu:SetPoint("TOPLEFT", stats, "BOTTOMLEFT", 0, -8)

	local specTalent = ns.CreateCheckBox(infobar, "specTalent", true, true)
	specTalent:SetPoint("TOPLEFT", microMenu, "BOTTOMLEFT", 0, -8)

	local friends = ns.CreateCheckBox(infobar, "friends", true, true)
	friends:SetPoint("TOPLEFT", specTalent, "BOTTOMLEFT", 0, -8)

	local currencies = ns.CreateCheckBox(infobar, "currencies", true, true)
	currencies:SetPoint("TOPLEFT", friends, "BOTTOMLEFT", 0, -8)

	local report = ns.CreateCheckBox(infobar, "report", true, true)
	report:SetPoint("TOPLEFT", currencies, "BOTTOMLEFT", 0, -8)

	local skadaTool = ns.CreateCheckBox(infobar, "skadaTool", true, true)
	skadaTool:SetPoint("TOPLEFT", report, "BOTTOMLEFT", 0, -8)

	local function toggleInfoBarOptions()
		local shown = enable:GetChecked()
		mouseover:SetShown(shown)
		stats:SetShown(shown)
		microMenu:SetShown(shown)
		specTalent:SetShown(shown)
		friends:SetShown(shown)
		currencies:SetShown(shown)
		report:SetShown(shown)
		skadaTool:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleInfoBarOptions)
	infobar:HookScript("OnShow", toggleInfoBarOptions)
end

-- [[ Action bars ]]

do
	local actionbar = FreeUIOptionsPanel.actionbar
	for i = 1, 4 do
		local tex = actionbar.tab:CreateTexture(nil, "OVERLAY")
		tex:SetSize(11, 11)
		tex:SetTexCoord(.08, .92, .08, .92)
		if i == 1 then
			tex:SetTexture("Interface\\Icons\\Ability_Warrior_SavageBlow")
			tex:SetPoint("TOPLEFT", actionbar.tab.Icon, "TOPLEFT")
		elseif i == 2 then
			tex:SetTexture("Interface\\Icons\\Ability_Warrior_ColossusSmash")
			tex:SetPoint("TOPRIGHT", actionbar.tab.Icon, "TOPRIGHT")
		elseif i == 3 then
			tex:SetTexture("Interface\\Icons\\Ability_Warrior_Charge")
			tex:SetPoint("BOTTOMLEFT", actionbar.tab.Icon, "BOTTOMLEFT")
		else
			tex:SetTexture("Interface\\Icons\\Ability_Warrior_Safeguard")
			tex:SetPoint("BOTTOMRIGHT", actionbar.tab.Icon, "BOTTOMRIGHT")
		end
	end

	local enable = ns.CreateCheckBox(actionbar, "enable", true, true)
	enable:SetPoint("TOPLEFT", actionbar.subText, "BOTTOMLEFT", 0, -8)

	local layoutStyle = ns.CreateRadioButtonGroup(actionbar, "layoutStyle", 3, false, true)
	layoutStyle.buttons[1]:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -30)

	--local buttonSizeNormal = ns.CreateNumberSlider(actionbar, "buttonSizeNormal", nil, nil, 20, 50, 1, true)
	--buttonSizeNormal:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 0, -130)

	--local buttonSizeSmall = ns.CreateNumberSlider(actionbar, "buttonSizeSmall", nil, nil, 20, 50, 1, true)
	--buttonSizeSmall:SetPoint("LEFT", buttonSizeNormal, "RIGHT", 120, 0)

	--local buttonSizeBig = ns.CreateNumberSlider(actionbar, "buttonSizeBig", nil, nil, 20, 50, 1, true)
	--buttonSizeBig:SetPoint("TOPLEFT", buttonSizeNormal, "BOTTOMLEFT", 0, -30)

	--local buttonSizeHuge = ns.CreateNumberSlider(actionbar, "buttonSizeHuge", nil, nil, 20, 50, 1, true)
	--buttonSizeHuge:SetPoint("LEFT", buttonSizeBig, "RIGHT", 120, 0)

	local hotKey = ns.CreateCheckBox(actionbar, "hotKey", true, true)
	hotKey:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -130)

	local macroName = ns.CreateCheckBox(actionbar, "macroName", true, true)
	macroName:SetPoint("LEFT", hotKey, "RIGHT", 240, 0)

	local count = ns.CreateCheckBox(actionbar, "count", true, true)
	count:SetPoint("TOPLEFT", hotKey, "BOTTOMLEFT", 0, -8)

	local classColor = ns.CreateCheckBox(actionbar, "classColor", true, true)
	classColor:SetPoint("LEFT", count, "RIGHT", 240, 0)


	local stanceBar = ns.CreateCheckBox(actionbar, "stanceBar", true, true)
	stanceBar:SetPoint("TOPLEFT", count, "BOTTOMLEFT", 0, -16)

	local stanceBarMouseover = ns.CreateCheckBox(actionbar, "stanceBarMouseover", true, true)
	stanceBarMouseover:SetPoint("TOPLEFT", stanceBar, "BOTTOMLEFT", 16, -8)

	stanceBar.children = {stanceBarMouseover}

	local petBar = ns.CreateCheckBox(actionbar, "petBar", true, true)
	petBar:SetPoint("LEFT", stanceBar, "RIGHT", 240, 0)

	local petBarMouseover = ns.CreateCheckBox(actionbar, "petBarMouseover", true, true)
	petBarMouseover:SetPoint("TOPLEFT", petBar, "BOTTOMLEFT", 16, -8)

	petBar.children = {petBarMouseover}

	local sideBar = ns.CreateCheckBox(actionbar, "sideBar", true, true)
	sideBar:SetPoint("TOPLEFT", stanceBarMouseover, "BOTTOMLEFT", -16, -8)

	local sideBarMouseover = ns.CreateCheckBox(actionbar, "sideBarMouseover", true, true)
	sideBarMouseover:SetPoint("TOPLEFT", sideBar, "BOTTOMLEFT", 16, -8)

	sideBar.children = {sideBarMouseover}

	local hoverBind = ns.CreateCheckBox(actionbar, "hoverBind", true, true)
	hoverBind:SetPoint("TOPLEFT", sideBarMouseover, "BOTTOMLEFT", -16, -16)


	local function toggleActionBarsOptions()
		local shown = enable:GetChecked()
		hotKey:SetShown(shown)
		macroName:SetShown(shown)
		count:SetShown(shown)
		classColor:SetShown(shown)
		hoverBind:SetShown(shown)
		stanceBar:SetShown(shown)
		stanceBarMouseover:SetShown(shown)
		petBar:SetShown(shown)
		petBarMouseover:SetShown(shown)
		sideBar:SetShown(shown)
		sideBarMouseover:SetShown(shown)
		layoutStyle.buttons[1]:SetShown(shown)
		layoutStyle.buttons[2]:SetShown(shown)
		layoutStyle.buttons[3]:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleActionBarsOptions)
	actionbar:HookScript("OnShow", toggleActionBarsOptions)
end

-- [[ Unit frames ]]

do
	local unitframe = FreeUIOptionsPanel.unitframe
	unitframe.tab.Icon:SetTexture("Interface\\Icons\\Achievement_Character_Human_Female")

	local enable = ns.CreateCheckBox(unitframe, "enable", true, true)
	enable:SetPoint("TOPLEFT", unitframe.subText, "BOTTOMLEFT", 0, -8)

	local transMode = ns.CreateCheckBox(unitframe, "transMode", true, true)
	transMode:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -8)

	local gradient = ns.CreateCheckBox(unitframe, "gradient", true, true)
	gradient:SetPoint("LEFT", transMode, "RIGHT", 240, 0)

	local portrait = ns.CreateCheckBox(unitframe, "portrait", true, true)
	portrait:SetPoint("TOPLEFT", transMode, "BOTTOMLEFT", 0, -8)

	local main = ns.addSubCategory(unitframe, ns.localization.unitframemain)
	main:SetPoint("TOPLEFT", portrait, "BOTTOMLEFT", -16, -8)

	local threat = ns.CreateCheckBox(unitframe, "threat", true, true)
	threat:SetPoint("TOPLEFT", main, "BOTTOMLEFT", 16, -16)

	local prediction = ns.CreateCheckBox(unitframe, "prediction", true, true)
	prediction:SetPoint("TOPLEFT", threat, "BOTTOMLEFT", 0, -8)

	local classPower = ns.CreateCheckBox(unitframe, "classPower", true, true)
	classPower:SetPoint("TOPLEFT", prediction, "BOTTOMLEFT", 0, -8)

	local dispellable = ns.CreateCheckBox(unitframe, "dispellable", true, true)
	dispellable:SetPoint("LEFT", threat, "RIGHT", 240, 0)

	local spellRange = ns.CreateCheckBox(unitframe, "spellRange", true, true)
	spellRange:SetPoint("TOPLEFT", dispellable, "BOTTOMLEFT", 0, -8)

	local spellRangeAlpha = ns.CreateNumberSlider(unitframe, "spellRangeAlpha", nil, nil, .1, 1, .1, true)
	spellRangeAlpha:SetPoint("TOPLEFT", spellRange, "BOTTOMLEFT", 16, -20)

	local function toggleSpellRangeOptions()
		local shown = spellRange:GetChecked()
		spellRangeAlpha:SetShown(shown)
	end

	spellRange:HookScript("OnClick", toggleSpellRangeOptions)
	spellRangeAlpha:HookScript("OnShow", toggleSpellRangeOptions)

	local castbarline = ns.addSubCategory(unitframe, ns.localization.unitframecastbarline)
	castbarline:SetPoint("TOPLEFT", classPower, "BOTTOMLEFT", -16, -16)

	local castbar = ns.CreateCheckBox(unitframe, "castbar", true, true)
	castbar:SetPoint("TOPLEFT", castbarline, "BOTTOMLEFT", 16, -16)

	local cbSeparate_palyer = ns.CreateCheckBox(unitframe, "cbSeparate_palyer", true, true)
	cbSeparate_palyer:SetPoint("TOPLEFT", castbar, "BOTTOMLEFT", 16, -8)

	local cbSeparate_target = ns.CreateCheckBox(unitframe, "cbSeparate_target", true, true)
	cbSeparate_target:SetPoint("LEFT", cbSeparate_palyer, "RIGHT", 240, 0)

	local cbName = ns.CreateCheckBox(unitframe, "cbName", true, true)
	cbName:SetPoint("TOPLEFT", cbSeparate_palyer, "BOTTOMLEFT", 0, -8)

	local cbTimer = ns.CreateCheckBox(unitframe, "cbTimer", true, true)
	cbTimer:SetPoint("LEFT", cbName, "RIGHT", 240, 0)

	castbar.children = {cbSeparate_palyer, cbSeparate_target, cbName, cbTimer}

	local group = ns.addSubCategory(unitframe, ns.localization.unitframegroup)
	group:SetPoint("TOPLEFT", cbName, "BOTTOMLEFT", -32, -8)

	local enableGroup = ns.CreateCheckBox(unitframe, "enableGroup", true, true)
	enableGroup:SetPoint("TOPLEFT", group, "BOTTOMLEFT", 16, -16)

	local partyMissingHealth = ns.CreateCheckBox(unitframe, "partyMissingHealth", true, true)
	partyMissingHealth:SetPoint("TOPLEFT", enableGroup, "BOTTOMLEFT", 16, -8)

	local partyNameAlways = ns.CreateCheckBox(unitframe, "partyNameAlways", true, true)
	partyNameAlways:SetPoint("LEFT", partyMissingHealth, "RIGHT", 240, 0)

	local party_horizon = ns.CreateCheckBox(unitframe, "party_horizon", true, true)
	party_horizon:SetPoint("TOPLEFT", partyMissingHealth, "BOTTOMLEFT", 0, -8)

	local party_reverse = ns.CreateCheckBox(unitframe, "party_reverse", true, true)
	party_reverse:SetPoint("LEFT", party_horizon, "RIGHT", 240, 0)

	local raid_horizon = ns.CreateCheckBox(unitframe, "raid_horizon", true, true)
	raid_horizon:SetPoint("TOPLEFT", party_horizon, "BOTTOMLEFT", 0, -8)

	local raid_reverse = ns.CreateCheckBox(unitframe, "raid_reverse", true, true)
	raid_reverse:SetPoint("LEFT", raid_horizon, "RIGHT", 240, 0)

	enableGroup.children = {partyMissingHealth, partyNameAlways, party_horizon, party_reverse, raid_horizon, raid_reverse}

	local misc = ns.addSubCategory(unitframe, ns.localization.unitframemisc)
	misc:SetPoint("TOPLEFT", raid_horizon, "BOTTOMLEFT", -32, -8)

	local enableBoss = ns.CreateCheckBox(unitframe, "enableBoss", true, true)
	enableBoss:SetPoint("TOPLEFT", misc, "BOTTOMLEFT", 16, -16)

	local enableArena = ns.CreateCheckBox(unitframe, "enableArena", true, true)
	enableArena:SetPoint("LEFT", enableBoss, "RIGHT", 240, 0)

	local function toggleUFOptions()
		local shown = enable:GetChecked()
		transMode:SetShown(shown)
		gradient:SetShown(shown)
		main:SetShown(shown)
		portrait:SetShown(shown)

		group:SetShown(shown)
		enableGroup:SetShown(shown)
		partyNameAlways:SetShown(shown)
		partyMissingHealth:SetShown(shown)
		party_horizon:SetShown(shown)
		party_reverse:SetShown(shown)
		raid_horizon:SetShown(shown)
		raid_reverse:SetShown(shown)

		threat:SetShown(shown)
		prediction:SetShown(shown)
		classPower:SetShown(shown)
		dispellable:SetShown(shown)
		spellRange:SetShown(shown)
		spellRangeAlpha:SetShown(shown)

		castbarline:SetShown(shown)
		castbar:SetShown(shown)
		cbSeparate_palyer:SetShown(shown)
		cbSeparate_target:SetShown(shown)
		
		misc:SetShown(shown)
		enableBoss:SetShown(shown)
		enableArena:SetShown(shown)

	end

	enable:HookScript("OnClick", toggleUFOptions)
	unitframe:HookScript("OnShow", toggleUFOptions)
end

-- [[ Inventory ]]

do
	local inventory = FreeUIOptionsPanel.inventory
	inventory.tab.Icon:SetTexture("Interface\\Icons\\INV_Misc_Bag_31")

	local enable = ns.CreateCheckBox(inventory, "enable", true, true)
	enable:SetPoint("TOPLEFT", inventory.subText, "BOTTOMLEFT", 0, -8)

	local useCategory = ns.CreateCheckBox(inventory, "useCategory", true, true)
	useCategory:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -8)

	local gearSetFilter = ns.CreateCheckBox(inventory, "gearSetFilter", true, true)
	gearSetFilter:SetPoint("TOPLEFT", useCategory, "BOTTOMLEFT", 0, -8)

	useCategory.children = {gearSetFilter}

	local reverseSort = ns.CreateCheckBox(inventory, "reverseSort", true, true)
	reverseSort:SetPoint("LEFT", useCategory, "RIGHT", 240, 0)

	local itemLevel = ns.CreateCheckBox(inventory, "itemLevel", true, true)
	itemLevel:SetPoint("TOPLEFT", gearSetFilter, "BOTTOMLEFT", 0, -8)

	local newitemFlash = ns.CreateCheckBox(inventory, "newitemFlash", true, true)
	newitemFlash:SetPoint("TOPLEFT", itemLevel, "BOTTOMLEFT", 0, -8)

	local size = ns.CreateNumberSlider(inventory, "itemSlotSize", nil, nil, 20, 40, 1, true)
	size:SetPoint("TOPLEFT", newitemFlash, "BOTTOMLEFT", 0, -30)

	local bagColumns = ns.CreateNumberSlider(inventory, "bagColumns", nil, nil, 8, 16, 1, true)
	bagColumns:SetPoint("LEFT", size, "RIGHT", 120, 0)


	local function toggleInventoryOptions()
		local shown = enable:GetChecked()
		useCategory:SetShown(shown)
		gearSetFilter:SetShown(shown)
		reverseSort:SetShown(shown)
		itemLevel:SetShown(shown)
		newitemFlash:SetShown(shown)
		size:SetShown(shown)
		bagColumns:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleInventoryOptions)
	inventory:HookScript("OnShow", toggleInventoryOptions)
end

-- [[ Tooltip ]]

do
	local tooltip = FreeUIOptionsPanel.tooltip
	tooltip.tab.Icon:SetTexture("Interface\\Icons\\INV_Inscription_ScrollOfWisdom_01")

	local enable = ns.CreateCheckBox(tooltip, "enable", true, true)
	enable:SetPoint("TOPLEFT", tooltip.subText, "BOTTOMLEFT", 0, -8)

	local cursor = ns.CreateCheckBox(tooltip, "cursor", true, true)
	cursor:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -8)

	local combatHide = ns.CreateCheckBox(tooltip, "combatHide", true, true)
	combatHide:SetPoint("LEFT", cursor, "RIGHT", 240, 0)

	local hidePVP = ns.CreateCheckBox(tooltip, "hidePVP", true, true)
	hidePVP:SetPoint("TOPLEFT", cursor, "BOTTOMLEFT", 0, -8)

	local hideFaction = ns.CreateCheckBox(tooltip, "hideFaction", true, true)
	hideFaction:SetPoint("LEFT", hidePVP, "RIGHT", 240, 0)

	local hideTitle = ns.CreateCheckBox(tooltip, "hideTitle", true, true)
	hideTitle:SetPoint("TOPLEFT", hidePVP, "BOTTOMLEFT", 0, -8)

	local hideRealm = ns.CreateCheckBox(tooltip, "hideRealm", true, true)
	hideRealm:SetPoint("LEFT", hideTitle, "RIGHT", 240, 0)

	local hideRank = ns.CreateCheckBox(tooltip, "hideRank", true, true)
	hideRank:SetPoint("TOPLEFT", hideTitle, "BOTTOMLEFT", 0, -8)

	local borderColor = ns.CreateCheckBox(tooltip, "borderColor", true, true)
	borderColor:SetPoint("LEFT", hideRank, "RIGHT", 240, 0)

	local tipIcon = ns.CreateCheckBox(tooltip, "tipIcon", true, true)
	tipIcon:SetPoint("TOPLEFT", hideRank, "BOTTOMLEFT", 0, -8)

	local tipClear = ns.CreateCheckBox(tooltip, "tipClear", true, true)
	tipClear:SetPoint("LEFT", tipIcon, "RIGHT", 240, 0)

	local extraInfo = ns.CreateCheckBox(tooltip, "extraInfo", true, true)
	extraInfo:SetPoint("TOPLEFT", tipIcon, "BOTTOMLEFT", 0, -8)

	local azeriteTrait = ns.CreateCheckBox(tooltip, "azeriteTrait", true, true)
	azeriteTrait:SetPoint("LEFT", extraInfo, "RIGHT", 240, 0)

	local linkHover = ns.CreateCheckBox(tooltip, "linkHover", true, true)
	linkHover:SetPoint("TOPLEFT", extraInfo, "BOTTOMLEFT", 0, -8)

	local ilvlSpec = ns.CreateCheckBox(tooltip, "ilvlSpec", true, true)
	ilvlSpec:SetPoint("LEFT", linkHover, "RIGHT", 240, 0)

	local function toggleTooltipOptions()
		local shown = enable:GetChecked()
		cursor:SetShown(shown)
		hidePVP:SetShown(shown)
		hideFaction:SetShown(shown)
		hideTitle:SetShown(shown)
		hideRealm:SetShown(shown)
		hideRank:SetShown(shown)
		combatHide:SetShown(shown)
		ilvlSpec:SetShown(shown)
		azeriteTrait:SetShown(shown)
		linkHover:SetShown(shown)
		borderColor:SetShown(shown)
		tipIcon:SetShown(shown)
		tipClear:SetShown(shown)
		extraInfo:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleTooltipOptions)
	tooltip:HookScript("OnShow", toggleTooltipOptions)
end

-- [[ Chat ]]

do
	local chat = FreeUIOptionsPanel.chat
	chat.tab.Icon:SetTexture("Interface\\Icons\\INV_Enchanting_70_Pet_Pen")

	local enable = ns.CreateCheckBox(chat, "enable", true, true)
	enable:SetPoint("TOPLEFT", chat.subText, "BOTTOMLEFT", 0, -8)

	local lockPosition = ns.CreateCheckBox(chat, "lockPosition", true, true)
	lockPosition:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", 16, -8)

	local useOutline = ns.CreateCheckBox(chat, "useOutline", true, true)
	useOutline:SetPoint("LEFT", lockPosition, "RIGHT", 240, 0)

	local whisperSound = ns.CreateCheckBox(chat, "whisperSound", true, true)
	whisperSound:SetPoint("TOPLEFT", lockPosition, "BOTTOMLEFT", 0, -8)

	local timeStamp = ns.CreateCheckBox(chat, "timeStamp", true, true)
	timeStamp:SetPoint("LEFT", whisperSound, "RIGHT", 240, 0)

	local itemLinkLevel = ns.CreateCheckBox(chat, "itemLinkLevel", true, true)
	itemLinkLevel:SetPoint("TOPLEFT", whisperSound, "BOTTOMLEFT", 0, -8)

	local spamageMeters = ns.CreateCheckBox(chat, "spamageMeters", true, true)
	spamageMeters:SetPoint("LEFT", itemLinkLevel, "RIGHT", 240, 0)

	local minimizeButton = ns.CreateCheckBox(chat, "minimizeButton", true, true)
	minimizeButton:SetPoint("TOPLEFT", itemLinkLevel, "BOTTOMLEFT", 0, -8)

	local channelSticky = ns.CreateCheckBox(chat, "channelSticky", true, true)
	channelSticky:SetPoint("LEFT", minimizeButton, "RIGHT", 240, 0)

	local lineFading = ns.CreateCheckBox(chat, "lineFading", true, true)
	lineFading:SetPoint("TOPLEFT", minimizeButton, "BOTTOMLEFT", 0, -8)

	local useFilter = ns.CreateCheckBox(chat, "useFilter", true, true)
	useFilter:SetPoint("LEFT", lineFading, "RIGHT", 240, 0)

	local function toggleChatOptions()
		local shown = enable:GetChecked()
		lockPosition:SetShown(shown)
		useOutline:SetShown(shown)
		whisperSound:SetShown(shown)
		timeStamp:SetShown(shown)
		itemLinkLevel:SetShown(shown)
		spamageMeters:SetShown(shown)
		minimizeButton:SetShown(shown)
		channelSticky:SetShown(shown)
		lineFading:SetShown(shown)
		useFilter:SetShown(shown)
	end

	enable:HookScript("OnClick", toggleChatOptions)
	chat:HookScript("OnShow", toggleChatOptions)
end


-- [[ Map ]]

do
	local map = FreeUIOptionsPanel.map
	map.tab.Icon:SetTexture("Interface\\Icons\\Icon_TreasureMap")

	local bigmap = ns.addSubCategory(map, ns.localization.mapbigmap)
	bigmap:SetPoint("TOPLEFT", map.subText, "BOTTOMLEFT", 0, -8)

	local worldMap = ns.CreateCheckBox(map, "worldMap", true, true)
	worldMap:SetPoint("TOPLEFT", bigmap, "BOTTOMLEFT", 0, -8)

	local coords = ns.CreateCheckBox(map, "coords", true, true)
	coords:SetPoint("TOPLEFT", worldMap, "BOTTOMLEFT", 16, -8)

	local mapReveal = ns.CreateCheckBox(map, "mapReveal", true, true)
	mapReveal:SetPoint("LEFT", coords, "RIGHT", 240, 0)

	worldMap.children = {coords, mapReveal}

	local smallmap = ns.addSubCategory(map, ns.localization.mapsmallmap)
	smallmap:SetPoint("TOPLEFT", coords, "BOTTOMLEFT", -16, -16)

	local miniMap = ns.CreateCheckBox(map, "miniMap", true, true)
	miniMap:SetPoint("TOPLEFT", smallmap, "BOTTOMLEFT", 0, -8)

	local whoPings = ns.CreateCheckBox(map, "whoPings", true, true)
	whoPings:SetPoint("TOPLEFT", miniMap, "BOTTOMLEFT", 16, -8)

	miniMap.children = {whoPings}

end

-- [[ Class specific ]]

do
	local classmod = FreeUIOptionsPanel.classmod
	classmod.tab.Icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	local tcoords = CLASS_ICON_TCOORDS[select(2, UnitClass("player"))]
	classmod.tab.Icon:SetTexCoord(tcoords[1] + 0.022, tcoords[2] - 0.025, tcoords[3] + 0.022, tcoords[4] - 0.025)

	ns.classOptions = {}

	local havocFury = ns.CreateCheckBox(classmod, "havocFury", true, true)
	havocFury:SetPoint("TOPLEFT", classmod.subText, "BOTTOMLEFT", -2, -8)
	havocFury.className = "DEMONHUNTER"
	tinsert(ns.classOptions, havocFury)

end

-- [[ Credits ]]

do
	credits:SetSize(400, 540)
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

	local credits_1 = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
	credits_1:SetPoint("TOP", thankYou, "BOTTOM", 0, -30)
	credits_1:SetText(ns.localization.credits_1)

	local credits_2 = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
	credits_2:SetPoint("TOP", credits_1, "BOTTOM", 0, -30)
	credits_2:SetText(ns.localization.credits_2)

	local credits_3 = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
	credits_3:SetPoint("TOP", credits_2, "BOTTOM", 0, -30)
	credits_3:SetText(ns.localization.credits_3)

	local credits_4 = credits:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	credits_4:SetPoint("TOP", credits_3, "BOTTOM", 0, -18)
	credits_4:SetText(ns.localization.credits_4)
end




local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)

	local menuButton = CreateFrame("Button", "GameMenuFrameNDui", GameMenuFrame, "GameMenuButtonTemplate")
	menuButton:SetText(C.Title)
	menuButton:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -14)
	GameMenuFrame:HookScript("OnShow", function(self)
		GameMenuButtonLogout:SetPoint("TOP", menuButton, "BOTTOM", 0, -14)
		self:SetHeight(self:GetHeight() + menuButton:GetHeight() + 15)
	end)

	menuButton:SetScript("OnClick", function()
		options:Show()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)
	F.Reskin(menuButton)

	InstallButton:SetScript("OnClick", function()
		F:HelloWorld()
		options:Hide()
	end)
end)