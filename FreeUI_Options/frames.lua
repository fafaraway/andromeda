local _, ns = ...

local realm = GetRealmName()
local name = UnitName('player')


local options = CreateFrame('Frame', 'FreeUIOptionsPanel', UIParent)
options:SetSize(640, 700)
options:SetPoint('CENTER')
options:SetFrameStrata('HIGH')
options:EnableMouse(true)
tinsert(UISpecialFrames, options:GetName())

options.close = CreateFrame('Button', nil, options, 'UIPanelCloseButton')

local CloseButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
CloseButton:SetPoint('BOTTOMRIGHT', -6, 6)
CloseButton:SetSize(80, 24)
CloseButton:SetText(CLOSE)
CloseButton:SetScript("OnClick", function()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	options:Hide()
end)
tinsert(ns.buttons, CloseButton)

local OkayButton = CreateFrame('Button', "FreeUIOptionsPanelOkayButton", options, 'UIPanelButtonTemplate')
OkayButton:SetPoint("RIGHT", CloseButton, "LEFT", -6, 0)
OkayButton:SetSize(80, 24)
OkayButton:SetText(OKAY)
OkayButton:SetScript('OnClick', function()
	options:Hide()
	if ns.needReload then
		StaticPopup_Show('FREEUI_RELOAD')
	end
end)
OkayButton:Disable()
tinsert(ns.buttons, OkayButton)




local reloadText = options:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
reloadText:SetPoint('BOTTOM', 0, 14)
reloadText:SetText(ns.localization.needReload)
reloadText:Hide()
options.reloadText = reloadText


local CreditsFrame = CreateFrame('Frame', 'FreeUIOptionsPanelCredits', UIParent)

local CreditsButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
CreditsButton:SetSize(120, 24)
CreditsButton:SetText(ns.localization.credits)
CreditsButton:SetScript('OnClick', function()
	CreditsFrame:Show()
	options:SetAlpha(.2)
end)
tinsert(ns.buttons, CreditsButton)
options.CreditsButton = CreditsButton


local InstallButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
InstallButton:SetSize(120, 24)
InstallButton:SetText(ns.localization.install)
tinsert(ns.buttons, InstallButton)
options.InstallButton = InstallButton


local ResetButton = CreateFrame('Button', nil, options, 'UIPanelButtonTemplate')
ResetButton:SetSize(120, 24)
ResetButton:SetText(ns.localization.reset)
tinsert(ns.buttons, ResetButton)
options.ResetButton = ResetButton


local ProfileBox = CreateFrame('CheckButton', nil, options, 'InterfaceOptionsCheckButtonTemplate')
ProfileBox:SetPoint('BOTTOMLEFT', 6, 6)
ProfileBox.Text:SetText(ns.localization.profile)
ProfileBox.tooltipText = ns.localization.profileTooltip
options.ProfileBox = ProfileBox


local line = options:CreateTexture()
line:SetSize(1, 600)
line:SetPoint('TOPLEFT', 180, -60)
line:SetColorTexture(.5, .5, .5, .1)


ns.addCategory('general')
ns.addCategory('appearance')
ns.addCategory('automation')
ns.addCategory('notification')
ns.addCategory('infobar')
ns.addCategory('actionbar')
ns.addCategory('unitFrame')
ns.addCategory('inventory')
ns.addCategory('tooltip')
ns.addCategory('chat')
ns.addCategory('map')


CreditsButton:SetPoint('BOTTOM', InstallButton, 'TOP', 0, 4)
InstallButton:SetPoint('BOTTOM', ResetButton, 'TOP', 0, 4)
ResetButton:SetPoint('TOP', FreeUIOptionsPanel.general.tab, 'BOTTOM', 0, -500)


-- [[ General ]]

do
	local general = FreeUIOptionsPanel.general
	general.tab.Icon:SetTexture('Interface\\Icons\\INV_Eng_GearspringParts')

	local basic = ns.addSubCategory(general, ns.localization.general_subCategory_basic)
	basic:SetPoint('TOPLEFT', general.subText, 'BOTTOMLEFT', 0, -8)

	local hideTalkingHead = ns.CreateCheckBox(general, 'hideTalkingHead')
	hideTalkingHead:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local hideBossBanner = ns.CreateCheckBox(general, 'hideBossBanner')
	hideBossBanner:SetPoint('LEFT', hideTalkingHead, 'RIGHT', 160, 0)

	local itemLevel = ns.CreateCheckBox(general, 'itemLevel')
	itemLevel:SetPoint('TOPLEFT', hideTalkingHead, 'BOTTOMLEFT', 0, -8)

	local durability = ns.CreateCheckBox(general, 'durability')
	durability:SetPoint('LEFT', itemLevel, 'RIGHT', 160, 0)

	local fullStats = ns.CreateCheckBox(general, 'fullStats')
	fullStats:SetPoint('TOPLEFT', itemLevel, 'BOTTOMLEFT', 0, -8)

	local clickCast = ns.CreateCheckBox(general, 'clickCast')
	clickCast:SetPoint('LEFT', fullStats, 'RIGHT', 160, 0)

	local marker = ns.CreateCheckBox(general, 'marker')
	marker:SetPoint('TOPLEFT', fullStats, 'BOTTOMLEFT', 0, -8)

	local focuser = ns.CreateCheckBox(general, 'focuser')
	focuser:SetPoint('LEFT', marker, 'RIGHT', 160, 0)

	local fasterLoot = ns.CreateCheckBox(general, 'fasterLoot')
	fasterLoot:SetPoint('TOPLEFT', marker, 'BOTTOMLEFT', 0, -8)

	local PVPSound = ns.CreateCheckBox(general, 'PVPSound')
	PVPSound:SetPoint('LEFT', fasterLoot, 'RIGHT', 160, 0)

	local actionCam = ns.CreateCheckBox(general, 'actionCam')
	actionCam:SetPoint('TOPLEFT', fasterLoot, 'BOTTOMLEFT', 0, -8)

	local actionCam_full = ns.CreateCheckBox(general, 'actionCam_full')
	actionCam_full:SetPoint('TOPLEFT', actionCam, 'BOTTOMLEFT', 16, -8)

	actionCam.children = {actionCam_full}

	local fct = ns.addSubCategory(general, ns.localization.general_subCategory_fct)
	fct:SetPoint('TOPLEFT', actionCam_full, 'BOTTOMLEFT', -16, -16)

	local combatText = ns.CreateCheckBox(general, 'combatText')
	combatText:SetPoint('TOPLEFT', fct, 'BOTTOMLEFT', 0, -8)

	local combatText_info = ns.CreateCheckBox(general, 'combatText_info')
	combatText_info:SetPoint('TOPLEFT', combatText, 'BOTTOMLEFT', 16, -8)

	local combatText_incoming = ns.CreateCheckBox(general, 'combatText_incoming')
	combatText_incoming:SetPoint('TOPLEFT', combatText_info, 'BOTTOMLEFT', 0, -8)

	local combatText_outgoing = ns.CreateCheckBox(general, 'combatText_outgoing')
	combatText_outgoing:SetPoint('TOPLEFT', combatText_incoming, 'BOTTOMLEFT', 0, -8)

	combatText.children = {combatText_info, combatText_incoming, combatText_outgoing}

	local cd = ns.addSubCategory(general, ns.localization.general_subCategory_cooldown)
	cd:SetPoint('TOPLEFT', combatText_outgoing, 'BOTTOMLEFT', -16, -16)

	local cooldown = ns.CreateCheckBox(general, 'cooldown')
	cooldown:SetPoint('TOPLEFT', cd, 'BOTTOMLEFT', 0, -8)

	local cooldown_decimal = ns.CreateCheckBox(general, 'cooldown_decimal')
	cooldown_decimal:SetPoint('TOPLEFT', cooldown, 'BOTTOMLEFT', 16, -4)

	cooldown.children = {cooldown_decimal}

	local cooldownPulse = ns.CreateCheckBox(general, 'cooldownPulse')
	cooldownPulse:SetPoint('LEFT', cooldown, 'RIGHT', 160, 0)

	local uiscalesub = ns.addSubCategory(general, ns.localization.general_subCategory_uiscale)
	uiscalesub:SetPoint('TOPLEFT', cooldown_decimal, 'BOTTOMLEFT', -16, -16)

	local uiScaleAuto = ns.CreateCheckBox(general, 'uiScaleAuto')
	uiScaleAuto:SetPoint('TOPLEFT', uiscalesub, 'BOTTOMLEFT', 0, -8)

	local uiScale = ns.CreateNumberSlider(general, 'uiScale', 0.4, 1.2, 0.4, 1.2, 0.01, true)
	uiScale:SetPoint('TOPLEFT', uiScaleAuto, 'BOTTOMLEFT', 24, -24)

	local function toggleUIScaleOptions()
		local shown = not uiScaleAuto:GetChecked()
		uiScale:SetShown(shown)
	end

	uiScaleAuto:HookScript('OnClick', toggleUIScaleOptions)
	uiScale:HookScript('OnShow', toggleUIScaleOptions)
end

-- [[ Appearance ]]

do
	local appearance = FreeUIOptionsPanel.appearance
	appearance.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Toy_07')

	local basic = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_basic)
	basic:SetPoint('TOPLEFT', appearance.subText, 'BOTTOMLEFT', 0, -8)

	local themes = ns.CreateCheckBox(appearance, 'themes')
	themes:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local backdropAlpha = ns.CreateNumberSlider(appearance, 'backdropAlpha', 0.1, 1, 0.1, 1, 0.01, true)
	backdropAlpha:SetPoint('TOPLEFT', themes, 'BOTTOMLEFT', 24, -24)

	local function toggleThemesOptions()
		local shown = themes:GetChecked()
		backdropAlpha:SetShown(shown)
	end

	themes:HookScript('OnClick', toggleThemesOptions)
	backdropAlpha:HookScript('OnShow', toggleThemesOptions)

	local vignette = ns.CreateCheckBox(appearance, 'vignette')
	vignette:SetPoint('TOPLEFT', backdropAlpha, 'BOTTOMLEFT', -24, -24)

	local vignetteAlpha = ns.CreateNumberSlider(appearance, 'vignetteAlpha', 0.1, 1, 0.1, 1, 0.01, true)
	vignetteAlpha:SetPoint('TOPLEFT', vignette, 'BOTTOMLEFT', 24, -24)

	local function toggleVignetteOptions()
		local shown = vignette:GetChecked()
		vignetteAlpha:SetShown(shown)
	end

	vignette:HookScript('OnClick', toggleVignetteOptions)
	vignetteAlpha:HookScript('OnShow', toggleVignetteOptions)

	local flashCursor = ns.CreateCheckBox(appearance, 'flashCursor')
	flashCursor:SetPoint('TOPLEFT', vignetteAlpha, 'BOTTOMLEFT', -24, -24)

	local shadow = ns.CreateCheckBox(appearance, 'shadow')
	shadow:SetPoint('LEFT', flashCursor, 'RIGHT', 160, 0)

	local misc = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_misc)
	misc:SetPoint('TOPLEFT', flashCursor, 'BOTTOMLEFT', 0, -16)

	local questTracker = ns.CreateCheckBox(appearance, 'questTracker')
	questTracker:SetPoint('TOPLEFT', misc, 'BOTTOMLEFT', 0, -8)
	local petBattle = ns.CreateCheckBox(appearance, 'petBattle')
	petBattle:SetPoint('LEFT', questTracker, 'RIGHT', 160, 0)

	local subfonts = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_font)
	subfonts:SetPoint('TOPLEFT', questTracker, 'BOTTOMLEFT', 0, -16)

	local fonts = ns.CreateCheckBox(appearance, 'fonts')
	fonts:SetPoint('TOPLEFT', subfonts, 'BOTTOMLEFT', 0, -8)

	local addons = ns.addSubCategory(appearance, ns.localization.appearance_subCategory_addons)
	addons:SetPoint('TOPLEFT', fonts, 'BOTTOMLEFT', 0, -16)

	local DBM = ns.CreateCheckBox(appearance, 'DBM')
	DBM:SetPoint('TOPLEFT', addons, 'BOTTOMLEFT', 0, -8)

	local BigWigs = ns.CreateCheckBox(appearance, 'BigWigs')
	BigWigs:SetPoint('LEFT', DBM, 'RIGHT', 160, 0)

	local WeakAuras = ns.CreateCheckBox(appearance, 'WeakAuras')
	WeakAuras:SetPoint('TOPLEFT', DBM, 'BOTTOMLEFT', 0, -8)

	local Skada = ns.CreateCheckBox(appearance, 'Skada')
	Skada:SetPoint('LEFT', WeakAuras, 'RIGHT', 160, 0)

	local PremadeGroupsFilter = ns.CreateCheckBox(appearance, 'PremadeGroupsFilter')
	PremadeGroupsFilter:SetPoint('TOPLEFT', WeakAuras, 'BOTTOMLEFT', 0, -8)
end

-- [[ Automation ]]

do
	local automation = FreeUIOptionsPanel.automation
	automation.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_EngGizmos_swissArmy')

	local line = ns.addSubCategory(automation, ns.localization.automation_subCategory_automation)
	line:SetPoint('TOPLEFT', automation.subText, 'BOTTOMLEFT', 0, -8)

	local autoScreenShot = ns.CreateCheckBox(automation, 'autoScreenShot')
	autoScreenShot:SetPoint('TOPLEFT', line, 'BOTTOMLEFT', 0, -8)

	local autoQuest = ns.CreateCheckBox(automation, 'autoQuest')
	autoQuest:SetPoint('LEFT', autoScreenShot, 'RIGHT', 160, 0)

	local autoRepair = ns.CreateCheckBox(automation, 'autoRepair')
	autoRepair:SetPoint('TOPLEFT', autoScreenShot, 'BOTTOMLEFT', 0, -8)

	local autoSellJunk = ns.CreateCheckBox(automation, 'autoSellJunk')
	autoSellJunk:SetPoint('LEFT', autoRepair, 'RIGHT', 160, 0)

	local autoInvite = ns.CreateCheckBox(automation, 'autoInvite')
	autoInvite:SetPoint('TOPLEFT', autoRepair, 'BOTTOMLEFT', 0, -8)

	local autoAcceptInvite = ns.CreateCheckBox(automation, 'autoAcceptInvite')
	autoAcceptInvite:SetPoint('LEFT', autoInvite, 'RIGHT', 160, 0)

	local autoTabBinder = ns.CreateCheckBox(automation, 'autoTabBinder')
	autoTabBinder:SetPoint('TOPLEFT', autoInvite, 'BOTTOMLEFT', 0, -8)
	
	local autoSetRole = ns.CreateCheckBox(automation, 'autoSetRole', true)
	autoSetRole:SetPoint('LEFT', autoTabBinder, 'RIGHT', 160, 0)
end

-- [[ Notifications ]]

do
	local notification = FreeUIOptionsPanel.notification
	notification.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Horn_04')

	local banner = ns.addSubCategory(notification, ns.localization.notification_subCategory_banner)
	banner:SetPoint('TOPLEFT', notification.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(notification, 'enableBanner')
	enable:SetPoint('TOPLEFT', banner, 'BOTTOMLEFT', 0, -8)

	local playSounds = ns.CreateCheckBox(notification, 'playSounds')
	playSounds:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local checkBagsFull = ns.CreateCheckBox(notification, 'checkBagsFull')
	checkBagsFull:SetPoint('LEFT', playSounds, 'RIGHT', 160, 0)

	local checkMail = ns.CreateCheckBox(notification, 'checkMail')
	checkMail:SetPoint('TOPLEFT', playSounds, 'BOTTOMLEFT', 0, -8)

	local autoRepairCost = ns.CreateCheckBox(notification, 'autoRepairCost')
	autoRepairCost:SetPoint('LEFT', checkMail, 'RIGHT', 160, 0)

	local autoSellJunk = ns.CreateCheckBox(notification, 'autoSellJunk')
	autoSellJunk:SetPoint('TOPLEFT', checkMail, 'BOTTOMLEFT', 0, -8)

	enable.children = {playSounds, checkBagsFull, checkMail, autoRepairCost, autoSellJunk}

	local alert = ns.addSubCategory(notification, ns.localization.notification_subCategory_combat)
	alert:SetPoint('TOPLEFT', autoSellJunk, 'BOTTOMLEFT', -16, -16)

	local interrupt = ns.CreateCheckBox(notification, 'interrupt')
	interrupt:SetPoint('TOPLEFT', alert, 'BOTTOMLEFT', 0, -8)

	local interruptAnnounce = ns.CreateCheckBox(notification, 'interruptAnnounce')
	interruptAnnounce:SetPoint('TOPLEFT', interrupt, 'BOTTOMLEFT', 16, -8)

	interrupt.children = {interruptAnnounce}

	local dispel = ns.CreateCheckBox(notification, 'dispel')
	dispel:SetPoint('LEFT', interrupt, 'RIGHT', 160, 0)

	local dispelAnnounce = ns.CreateCheckBox(notification, 'dispelAnnounce')
	dispelAnnounce:SetPoint('TOPLEFT', dispel, 'BOTTOMLEFT', 16, -8)

	dispel.children = {dispelAnnounce}

	local vitalSpells = ns.CreateCheckBox(notification, 'vitalSpells')
	vitalSpells:SetPoint('TOPLEFT', interruptAnnounce, 'BOTTOMLEFT', -16, -8)

	local resurrect = ns.CreateCheckBox(notification, 'resurrect')
	resurrect:SetPoint('LEFT', vitalSpells, 'RIGHT', 160, 0)

	local sapped = ns.CreateCheckBox(notification, 'sapped')
	sapped:SetPoint('TOPLEFT', vitalSpells, 'BOTTOMLEFT', 0, -8)

	local emergency = ns.CreateCheckBox(notification, 'emergency')
	emergency:SetPoint('TOPLEFT', sapped, 'BOTTOMLEFT', 0, -8)

	local lowHealth = ns.CreateNumberSlider(notification, 'lowHealth', 0.1, 1, 0.1, 1, 0.1, true)
	lowHealth:SetPoint('TOPLEFT', emergency, 'BOTTOMLEFT', 24, -24)

	local lowMana = ns.CreateNumberSlider(notification, 'lowMana', 0.1, 1, 0.1, 1, 0.1, true)
	lowMana:SetPoint('TOPLEFT', lowHealth, 'BOTTOMLEFT', 0, -32)

	local function toggleEmergencyOptions()
		local shown = emergency:GetChecked()
		lowHealth:SetShown(shown)
		lowMana:SetShown(shown)
	end

	emergency:HookScript('OnClick', toggleEmergencyOptions)
	notification:HookScript('OnShow', toggleEmergencyOptions)

	local rares = ns.addSubCategory(notification, ns.localization.notification_subCategory_rares)
	rares:SetPoint('TOPLEFT', lowMana, 'BOTTOMLEFT', -24, -32)

	local rare = ns.CreateCheckBox(notification, 'rare')
	rare:SetPoint('TOPLEFT', rares, 'BOTTOMLEFT', 0, -8)

	local rareSound = ns.CreateCheckBox(notification, 'rareSound')
	rareSound:SetPoint('TOPLEFT', rare, 'BOTTOMLEFT', 16, -8)

	rare.children = {rareSound}

	local quest = ns.addSubCategory(notification, ns.localization.notification_subCategory_quest)
	quest:SetPoint('TOPLEFT', rareSound, 'BOTTOMLEFT', -16, -16)
	
	local questNotifier = ns.CreateCheckBox(notification, 'questNotifier')
	questNotifier:SetPoint('TOPLEFT', quest, 'BOTTOMLEFT', 0, -8)

	local questProgress = ns.CreateCheckBox(notification, 'questProgress')
	questProgress:SetPoint('TOPLEFT', questNotifier, 'BOTTOMLEFT', 16, -8)

	local onlyCompleteRing = ns.CreateCheckBox(notification, 'onlyCompleteRing')
	onlyCompleteRing:SetPoint('TOPLEFT', questProgress, 'BOTTOMLEFT', 0, -8)

	questNotifier.children = {questProgress, onlyCompleteRing}
end

-- [[ Info bar ]]

do
	local infobar = FreeUIOptionsPanel.infobar
	infobar.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_NotePicture1c')

	local line = ns.addSubCategory(infobar, ns.localization.infobar_subCategory_cores)
	line:SetPoint('TOPLEFT', infobar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(infobar, 'enable')
	enable:SetPoint('TOPLEFT', line, 'BOTTOMLEFT', 0, -8)

	local mouseover = ns.CreateCheckBox(infobar, 'mouseover')
	mouseover:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local stats = ns.CreateCheckBox(infobar, 'stats')
	stats:SetPoint('LEFT', mouseover, 'RIGHT', 160, 0)

	local report = ns.CreateCheckBox(infobar, 'report')
	report:SetPoint('TOPLEFT', mouseover, 'BOTTOMLEFT', 0, -8)

	local currencies = ns.CreateCheckBox(infobar, 'currencies')
	currencies:SetPoint('LEFT', report, 'RIGHT', 160, 0)

	local friends = ns.CreateCheckBox(infobar, 'friends')
	friends:SetPoint('TOPLEFT', report, 'BOTTOMLEFT', 0, -8)

	local durability = ns.CreateCheckBox(infobar, 'durability')
	durability:SetPoint('LEFT', friends, 'RIGHT', 160, 0)

	local specTalent = ns.CreateCheckBox(infobar, 'specTalent')
	specTalent:SetPoint('TOPLEFT', friends, 'BOTTOMLEFT', 0, -8)

	local skadaHelper = ns.CreateCheckBox(infobar, 'skadaHelper')
	skadaHelper:SetPoint('LEFT', specTalent, 'RIGHT', 160, 0)


	local function toggleInfoBarOptions()
		local shown = enable:GetChecked()
		mouseover:SetShown(shown)
		stats:SetShown(shown)
		report:SetShown(shown)
		currencies:SetShown(shown)
		friends:SetShown(shown)
		durability:SetShown(shown)
		specTalent:SetShown(shown)
		skadaHelper:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInfoBarOptions)
	infobar:HookScript('OnShow', toggleInfoBarOptions)
end

-- [[ Action bars ]]

do
	local actionbar = FreeUIOptionsPanel.actionbar
	actionbar.tab.Icon:SetTexture('Interface\\Icons\\UI_WarMode')

	local main = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_layout)
	main:SetPoint('TOPLEFT', actionbar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(actionbar, 'enable')
	enable:SetPoint('TOPLEFT', main, 'BOTTOMLEFT', 0, -8)

	local layoutStyle = ns.CreateRadioButtonGroup(actionbar, 'layoutStyle', 3, false, true)
	layoutStyle.buttons[1]:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -24)

	local extra = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_extra)
	extra:SetPoint('TOPLEFT', layoutStyle.buttons[3], 'BOTTOMLEFT', -16, -16)

	local bar3 = ns.CreateCheckBox(actionbar, 'bar3')
	bar3:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local bar3Mouseover = ns.CreateCheckBox(actionbar, 'bar3Mouseover')
	bar3Mouseover:SetPoint('TOPLEFT', bar3, 'BOTTOMLEFT', 16, -8)

	bar3.children = {bar3Mouseover}

	local sideBar = ns.CreateCheckBox(actionbar, 'sideBar')
	sideBar:SetPoint('LEFT', bar3, 'RIGHT', 160, 0)

	local sideBarMouseover = ns.CreateCheckBox(actionbar, 'sideBarMouseover')
	sideBarMouseover:SetPoint('TOPLEFT', sideBar, 'BOTTOMLEFT', 16, -8)

	sideBar.children = {sideBarMouseover}

	local petBar = ns.CreateCheckBox(actionbar, 'petBar')
	petBar:SetPoint('TOPLEFT', bar3Mouseover, 'BOTTOMLEFT', -16, -8)

	local petBarMouseover = ns.CreateCheckBox(actionbar, 'petBarMouseover')
	petBarMouseover:SetPoint('TOPLEFT', petBar, 'BOTTOMLEFT', 16, -8)

	petBar.children = {petBarMouseover}

	local stanceBar = ns.CreateCheckBox(actionbar, 'stanceBar')
	stanceBar:SetPoint('LEFT', petBar, 'RIGHT', 160, 0)

	local stanceBarMouseover = ns.CreateCheckBox(actionbar, 'stanceBarMouseover')
	stanceBarMouseover:SetPoint('TOPLEFT', stanceBar, 'BOTTOMLEFT', 16, -8)

	stanceBar.children = {stanceBarMouseover}

	local feature = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_feature)
	feature:SetPoint('TOPLEFT', petBarMouseover, 'BOTTOMLEFT', -16, -16)

	local hotKey = ns.CreateCheckBox(actionbar, 'hotKey')
	hotKey:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local macroName = ns.CreateCheckBox(actionbar, 'macroName')
	macroName:SetPoint('LEFT', hotKey, 'RIGHT', 160, 0)

	local count = ns.CreateCheckBox(actionbar, 'count')
	count:SetPoint('TOPLEFT', hotKey, 'BOTTOMLEFT', 0, -8)

	local classColor = ns.CreateCheckBox(actionbar, 'classColor')
	classColor:SetPoint('LEFT', count, 'RIGHT', 160, 0)

	local bind = ns.addSubCategory(actionbar, ns.localization.actionbar_subCategory_bind)
	bind:SetPoint('TOPLEFT', count, 'BOTTOMLEFT', 0, -16)

	local hoverBind = ns.CreateCheckBox(actionbar, 'hoverBind')
	hoverBind:SetPoint('TOPLEFT', bind, 'BOTTOMLEFT', 0, -8)


	local function toggleActionBarsOptions()
		local shown = enable:GetChecked()
		layoutStyle.buttons[1]:SetShown(shown)
		layoutStyle.buttons[2]:SetShown(shown)
		layoutStyle.buttons[3]:SetShown(shown)

		feature:SetShown(shown)
		hotKey:SetShown(shown)
		macroName:SetShown(shown)
		count:SetShown(shown)
		classColor:SetShown(shown)

		bind:SetShown(shown)
		hoverBind:SetShown(shown)

		extra:SetShown(shown)
		stanceBar:SetShown(shown)
		stanceBarMouseover:SetShown(shown)
		petBar:SetShown(shown)
		petBarMouseover:SetShown(shown)
		bar3:SetShown(shown)
		bar3Mouseover:SetShown(shown)
		sideBar:SetShown(shown)
		sideBarMouseover:SetShown(shown)
		
	end

	enable:HookScript('OnClick', toggleActionBarsOptions)
	actionbar:HookScript('OnShow', toggleActionBarsOptions)
end

-- [[ Unit frames ]]

do
	local unitframe = FreeUIOptionsPanel.unitframe
	unitframe.tab.Icon:SetTexture('Interface\\Icons\\Spell_Nature_Invisibilty')

	local basic = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_basic)
	basic:SetPoint('TOPLEFT', unitframe.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(unitframe, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local healer_layout = ns.CreateCheckBox(unitframe, 'healer_layout')
	healer_layout:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local transMode = ns.CreateCheckBox(unitframe, 'transMode')
	transMode:SetPoint('LEFT', healer_layout, 'RIGHT', 160, 0)

	local colourSmooth = ns.CreateCheckBox(unitframe, 'colourSmooth')
	colourSmooth:SetPoint('TOPLEFT', healer_layout, 'BOTTOMLEFT', 0, -8)

	local portrait = ns.CreateCheckBox(unitframe, 'portrait')
	portrait:SetPoint('LEFT', colourSmooth, 'RIGHT', 160, 0)

	local frameVisibility = ns.CreateCheckBox(unitframe, 'frameVisibility')
	frameVisibility:SetPoint('TOPLEFT', colourSmooth, 'BOTTOMLEFT', 0, -8)

	local feature = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_feature)
	feature:SetPoint('TOPLEFT', frameVisibility, 'BOTTOMLEFT', -16, -16)

	local threat = ns.CreateCheckBox(unitframe, 'threat')
	threat:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local dispellable = ns.CreateCheckBox(unitframe, 'dispellable')
	dispellable:SetPoint('LEFT', threat, 'RIGHT', 160, 0)

	local healPrediction = ns.CreateCheckBox(unitframe, 'healPrediction')
	healPrediction:SetPoint('TOPLEFT', threat, 'BOTTOMLEFT', 0, -8)

	local overAbsorb = ns.CreateCheckBox(unitframe, 'overAbsorb')
	overAbsorb:SetPoint('LEFT', healPrediction, 'RIGHT', 160, 0)

	local rangeCheck = ns.CreateCheckBox(unitframe, 'rangeCheck')
	rangeCheck:SetPoint('TOPLEFT', healPrediction, 'BOTTOMLEFT', 0, -8)

	local classPower = ns.CreateCheckBox(unitframe, 'classPower')
	classPower:SetPoint('LEFT', rangeCheck, 'RIGHT', 160, 0)

	local stagger = ns.CreateCheckBox(unitframe, 'stagger')
	stagger:SetPoint('TOPLEFT', rangeCheck, 'BOTTOMLEFT', 0, -8)

	local totems = ns.CreateCheckBox(unitframe, 'totems')
	totems:SetPoint('LEFT', stagger, 'RIGHT', 160, 0)

	local quakeTimer = ns.CreateCheckBox(unitframe, 'quakeTimer')
	quakeTimer:SetPoint('TOPLEFT', stagger, 'BOTTOMLEFT', 0, -8)

	local castbar = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_castbar)
	castbar:SetPoint('TOPLEFT', quakeTimer, 'BOTTOMLEFT', 0, -16)

	local enableCastbar = ns.CreateCheckBox(unitframe, 'enableCastbar')
	enableCastbar:SetPoint('TOPLEFT', castbar, 'BOTTOMLEFT', 0, -8)

	local castbar_separatePlayer = ns.CreateCheckBox(unitframe, 'castbar_separatePlayer')
	castbar_separatePlayer:SetPoint('TOPLEFT', enableCastbar, 'BOTTOMLEFT', 16, -8)

	local castbar_separateTarget = ns.CreateCheckBox(unitframe, 'castbar_separateTarget')
	castbar_separateTarget:SetPoint('LEFT', castbar_separatePlayer, 'RIGHT', 160, 0)

	enableCastbar.children = {castbar_separatePlayer, castbar_separateTarget}

	local extra = ns.addSubCategory(unitframe, ns.localization.unitframe_subCategory_extra)
	extra:SetPoint('TOPLEFT', castbar_separatePlayer, 'BOTTOMLEFT', -16, -16)

	local enableGroup = ns.CreateCheckBox(unitframe, 'enableGroup')
	enableGroup:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local groupNames = ns.CreateCheckBox(unitframe, 'groupNames')
	groupNames:SetPoint('TOPLEFT', enableGroup, 'BOTTOMLEFT', 16, -8)

	local groupColourSmooth = ns.CreateCheckBox(unitframe, 'groupColourSmooth')
	groupColourSmooth:SetPoint('LEFT', groupNames, 'RIGHT', 160, 0)

	local groupFilter = ns.CreateNumberSlider(unitframe, 'groupFilter', 4, 8, 4, 8, 1, true)
	groupFilter:SetPoint('TOPLEFT', groupNames, 'BOTTOMLEFT', 0, -30)

	local enableBoss = ns.CreateCheckBox(unitframe, 'enableBoss')
	enableBoss:SetPoint('TOPLEFT', groupFilter, 'BOTTOMLEFT', -16, -32)

	local bossColourSmooth = ns.CreateCheckBox(unitframe, 'bossColourSmooth')
	bossColourSmooth:SetPoint('TOPLEFT', enableBoss, 'BOTTOMLEFT', 16, -8)

	enableBoss.children = {bossColourSmooth}

	local enableArena = ns.CreateCheckBox(unitframe, 'enableArena')
	enableArena:SetPoint('LEFT', enableBoss, 'RIGHT', 160, 0)

	local function toggleUFOptions()
		local shown = enable:GetChecked()
		feature:SetShown(shown)
		extra:SetShown(shown)
		castbar:SetShown(shown)

		transMode:SetShown(shown)
		portrait:SetShown(shown)
		healer_layout:SetShown(shown)
		colourSmooth:SetShown(shown)
		frameVisibility:SetShown(shown)

		enableGroup:SetShown(shown)
		groupNames:SetShown(shown)
		groupColourSmooth:SetShown(shown)
		groupFilter:SetShown(shown)

		threat:SetShown(shown)
		overAbsorb:SetShown(shown)
		healPrediction:SetShown(shown)
		dispellable:SetShown(shown)
		rangeCheck:SetShown(shown)
		
		enableCastbar:SetShown(shown)
		castbar_separatePlayer:SetShown(shown)
		castbar_separateTarget:SetShown(shown)
		
		enableBoss:SetShown(shown)
		bossColourSmooth:SetShown(shown)
		enableArena:SetShown(shown)

		classPower:SetShown(shown)
		stagger:SetShown(shown)
		totems:SetShown(shown)
		quakeTimer:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleUFOptions)
	unitframe:HookScript('OnShow', toggleUFOptions)

	local function toggleGroupOptions()
		local shown = enableGroup:GetChecked()
		groupNames:SetShown(shown)
		groupColourSmooth:SetShown(shown)
		groupFilter:SetShown(shown)
	end

	enableGroup:HookScript('OnClick', toggleGroupOptions)
	unitframe:HookScript('OnShow', toggleGroupOptions)
end

-- [[ Inventory ]]

do
	local inventory = FreeUIOptionsPanel.inventory
	inventory.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Bag_07')

	local basic = ns.addSubCategory(inventory, ns.localization.inventory_subCategory_basic)
	basic:SetPoint('TOPLEFT', inventory.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(inventory, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local itemLevel = ns.CreateCheckBox(inventory, 'itemLevel')
	itemLevel:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local newitemFlash = ns.CreateCheckBox(inventory, 'newitemFlash')
	newitemFlash:SetPoint('LEFT', itemLevel, 'RIGHT', 160, 0)

	local useCategory = ns.CreateCheckBox(inventory, 'useCategory')
	useCategory:SetPoint('TOPLEFT', itemLevel, 'BOTTOMLEFT', 0, -8)

	local gearSetFilter = ns.CreateCheckBox(inventory, 'gearSetFilter')
	gearSetFilter:SetPoint('TOPLEFT', useCategory, 'BOTTOMLEFT', 16, -8)

	local tradeGoodsFilter = ns.CreateCheckBox(inventory, 'tradeGoodsFilter')
	tradeGoodsFilter:SetPoint('TOPLEFT', gearSetFilter, 'BOTTOMLEFT', 0, -8)

	local questItemFilter = ns.CreateCheckBox(inventory, 'questItemFilter')
	questItemFilter:SetPoint('TOPLEFT', tradeGoodsFilter, 'BOTTOMLEFT', 0, -8)

	local mechagonItemFilter = ns.CreateCheckBox(inventory, 'mechagonItemFilter')
	mechagonItemFilter:SetPoint('TOPLEFT', questItemFilter, 'BOTTOMLEFT', 0, -8)

	useCategory.children = {gearSetFilter, tradeGoodsFilter, questItemFilter, mechagonItemFilter}

	local reverseSort = ns.CreateCheckBox(inventory, 'reverseSort')
	reverseSort:SetPoint('LEFT', useCategory, 'RIGHT', 160, 0)

	local size = ns.CreateNumberSlider(inventory, 'itemSlotSize', 20, 40, 20, 40, 1, true)
	size:SetPoint('TOPLEFT', mechagonItemFilter, 'BOTTOMLEFT', -16, -32)

	local bagColumns = ns.CreateNumberSlider(inventory, 'bagColumns', 8, 16, 8, 16, 1, true)
	bagColumns:SetPoint('TOPLEFT', size, 'BOTTOMLEFT', 0, -32)

	local bankColumns = ns.CreateNumberSlider(inventory, 'bankColumns', 8, 16, 8, 16, 1, true)
	bankColumns:SetPoint('TOPLEFT', bagColumns, 'BOTTOMLEFT', 0, -32)


	local function toggleInventoryOptions()
		local shown = enable:GetChecked()
		useCategory:SetShown(shown)
		gearSetFilter:SetShown(shown)
		tradeGoodsFilter:SetShown(shown)
		questItemFilter:SetShown(shown)
		mechagonItemFilter:SetShown(shown)
		reverseSort:SetShown(shown)
		itemLevel:SetShown(shown)
		newitemFlash:SetShown(shown)
		size:SetShown(shown)
		bagColumns:SetShown(shown)
		bankColumns:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInventoryOptions)
	inventory:HookScript('OnShow', toggleInventoryOptions)
end

-- [[ Tooltip ]]

do
	local tooltip = FreeUIOptionsPanel.tooltip
	tooltip.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_ScrollUnrolled02d')

	local basic = ns.addSubCategory(tooltip, ns.localization.tooltip_subCategory_basic)
	basic:SetPoint('TOPLEFT', tooltip.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(tooltip, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local cursor = ns.CreateCheckBox(tooltip, 'cursor')
	cursor:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local combatHide = ns.CreateCheckBox(tooltip, 'combatHide')
	combatHide:SetPoint('LEFT', cursor, 'RIGHT', 160, 0)

	local hideTitle = ns.CreateCheckBox(tooltip, 'hideTitle')
	hideTitle:SetPoint('TOPLEFT', cursor, 'BOTTOMLEFT', 0, -8)

	local hideRealm = ns.CreateCheckBox(tooltip, 'hideRealm')
	hideRealm:SetPoint('LEFT', hideTitle, 'RIGHT', 160, 0)

	local hideRank = ns.CreateCheckBox(tooltip, 'hideRank')
	hideRank:SetPoint('TOPLEFT', hideTitle, 'BOTTOMLEFT', 0, -8)

	local borderColor = ns.CreateCheckBox(tooltip, 'borderColor')
	borderColor:SetPoint('LEFT', hideRank, 'RIGHT', 160, 0)

	local tipIcon = ns.CreateCheckBox(tooltip, 'tipIcon')
	tipIcon:SetPoint('TOPLEFT', hideRank, 'BOTTOMLEFT', 0, -8)

	local linkHover = ns.CreateCheckBox(tooltip, 'linkHover')
	linkHover:SetPoint('LEFT', tipIcon, 'RIGHT', 160, 0)

	local azeriteTrait = ns.CreateCheckBox(tooltip, 'azeriteTrait')
	azeriteTrait:SetPoint('TOPLEFT', tipIcon, 'BOTTOMLEFT', 0, -8)

	local extraInfo = ns.CreateCheckBox(tooltip, 'extraInfo')
	extraInfo:SetPoint('TOPLEFT', azeriteTrait, 'BOTTOMLEFT', 0, -8)

	local extraInfoByShift = ns.CreateCheckBox(tooltip, 'extraInfoByShift')
	extraInfoByShift:SetPoint('TOPLEFT', extraInfo, 'BOTTOMLEFT', 16, -8)

	local ilvlSpec = ns.CreateCheckBox(tooltip, 'ilvlSpec')
	ilvlSpec:SetPoint('LEFT', extraInfo, 'RIGHT', 160, 0)

	local ilvlSpecByShift = ns.CreateCheckBox(tooltip, 'ilvlSpecByShift')
	ilvlSpecByShift:SetPoint('TOPLEFT', ilvlSpec, 'BOTTOMLEFT', 16, -8)

	local function toggleTooltipOptions()
		local shown = enable:GetChecked()
		cursor:SetShown(shown)
		hideTitle:SetShown(shown)
		hideRealm:SetShown(shown)
		hideRank:SetShown(shown)
		combatHide:SetShown(shown)
		ilvlSpec:SetShown(shown)
		azeriteTrait:SetShown(shown)
		linkHover:SetShown(shown)
		borderColor:SetShown(shown)
		tipIcon:SetShown(shown)
		extraInfo:SetShown(shown)
		ilvlSpecByShift:SetShown(shown)
		extraInfoByShift:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleTooltipOptions)
	tooltip:HookScript('OnShow', toggleTooltipOptions)
end

-- [[ Chat ]]

do
	local chat = FreeUIOptionsPanel.chat
	chat.tab.Icon:SetTexture('Interface\\Icons\\Ability_Warrior_RallyingCry')

	local enable = ns.CreateCheckBox(chat, 'enable')
	enable:SetPoint('TOPLEFT', chat.subText, 'BOTTOMLEFT', 0, -8)

	local lockPosition = ns.CreateCheckBox(chat, 'lockPosition')
	lockPosition:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local fontOutline = ns.CreateCheckBox(chat, 'fontOutline')
	fontOutline:SetPoint('LEFT', lockPosition, 'RIGHT', 160, 0)

	local whisperAlert = ns.CreateCheckBox(chat, 'whisperAlert')
	whisperAlert:SetPoint('TOPLEFT', lockPosition, 'BOTTOMLEFT', 0, -8)

	local showItemLevel = ns.CreateCheckBox(chat, 'showItemLevel')
	showItemLevel:SetPoint('TOPLEFT', whisperAlert, 'BOTTOMLEFT', 0, -8)

	local spamageMeter = ns.CreateCheckBox(chat, 'spamageMeter')
	spamageMeter:SetPoint('LEFT', showItemLevel, 'RIGHT', 160, 0)

	local chatButton = ns.CreateCheckBox(chat, 'chatButton')
	chatButton:SetPoint('TOPLEFT', showItemLevel, 'BOTTOMLEFT', 0, -8)

	local channelSticky = ns.CreateCheckBox(chat, 'channelSticky')
	channelSticky:SetPoint('LEFT', chatButton, 'RIGHT', 160, 0)

	local lineFading = ns.CreateCheckBox(chat, 'lineFading')
	lineFading:SetPoint('TOPLEFT', chatButton, 'BOTTOMLEFT', 0, -8)

	local useFilter = ns.CreateCheckBox(chat, 'useFilter')
	useFilter:SetPoint('LEFT', lineFading, 'RIGHT', 160, 0)

	local autoBubble = ns.CreateCheckBox(chat, 'autoBubble')
	autoBubble:SetPoint('TOPLEFT', lineFading, 'BOTTOMLEFT', 0, -8)


	local timeStamp = ns.CreateCheckBox(chat, 'timeStamp')
	timeStamp:SetPoint('LEFT', autoBubble, 'RIGHT', 160, 0)

	local timeStampColor = ns.CreateColourPicker(chat, "timeStampColor", true)
	timeStampColor:SetPoint("TOPLEFT", timeStamp, "BOTTOMLEFT", 4, 0)

	local function toggleChatOptions()
		local shown = enable:GetChecked()
		lockPosition:SetShown(shown)
		fontOutline:SetShown(shown)
		whisperAlert:SetShown(shown)
		timeStamp:SetShown(shown)
		showItemLevel:SetShown(shown)
		spamageMeter:SetShown(shown)
		chatButton:SetShown(shown)
		channelSticky:SetShown(shown)
		lineFading:SetShown(shown)
		useFilter:SetShown(shown)
		autoBubble:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleChatOptions)
	chat:HookScript('OnShow', toggleChatOptions)
end


-- [[ Map ]]

do
	local map = FreeUIOptionsPanel.map
	map.tab.Icon:SetTexture('Interface\\Icons\\INV_Misc_Map08')

	local worldMap = ns.addSubCategory(map, ns.localization.map_subCategory_worldMap)
	worldMap:SetPoint('TOPLEFT', map.subText, 'BOTTOMLEFT', 0, -8)

	local coords = ns.CreateCheckBox(map, 'coords')
	coords:SetPoint('TOPLEFT', worldMap, 'BOTTOMLEFT', 0, -8)

	local mapReveal = ns.CreateCheckBox(map, 'mapReveal')
	mapReveal:SetPoint('LEFT', coords, 'RIGHT', 160, 0)

	local miniMap = ns.addSubCategory(map, ns.localization.map_subCategory_miniMap)
	miniMap:SetPoint('TOPLEFT', coords, 'BOTTOMLEFT', 0, -16)

	local miniMapEnhancement = ns.CreateCheckBox(map, 'miniMap')
	miniMapEnhancement:SetPoint('TOPLEFT', miniMap, 'BOTTOMLEFT', 0, -8)

	local whoPings = ns.CreateCheckBox(map, 'whoPings')
	whoPings:SetPoint('TOPLEFT', miniMapEnhancement, 'BOTTOMLEFT', 16, -8)

	local miniMapMenu = ns.CreateCheckBox(map, 'microMenu')
	miniMapMenu:SetPoint('LEFT', whoPings, 'RIGHT', 160, 0)


	local marker = ns.CreateCheckBox(map, 'marker')
	marker:SetPoint('TOPLEFT', whoPings, 'BOTTOMLEFT', 0, -8)

	local progressBar = ns.CreateCheckBox(map, 'progressBar')
	progressBar:SetPoint('LEFT', marker, 'RIGHT', 160, 0)



	local miniMapSize = ns.CreateNumberSlider(map, 'miniMapSize', 100, 300, 100, 300, 1, true)
	miniMapSize:SetPoint('TOPLEFT', marker, 'BOTTOMLEFT', 16, -32)

	local function toggleMiniMapsOptions()
		local shown = miniMapEnhancement:GetChecked()
		whoPings:SetShown(shown)
		miniMapMenu:SetShown(shown)
		miniMapSize:SetShown(shown)
		progressBar:SetShown(shown)
		marker:SetShown(shown)
	end

	miniMapEnhancement:HookScript('OnClick', toggleMiniMapsOptions)
	map:HookScript('OnShow', toggleMiniMapsOptions)
end



-- [[ Credits ]]

do
	CreditsFrame:SetSize(500, 500)
	CreditsFrame:SetPoint('CENTER')
	CreditsFrame:SetFrameStrata('DIALOG')
	CreditsFrame:EnableMouse(true)
	CreditsFrame:Hide()
	options.CreditsFrame = CreditsFrame

	tinsert(UISpecialFrames, CreditsFrame:GetName())

	CreditsFrame.CloseButton = CreateFrame('Button', nil, CreditsFrame, 'UIPanelCloseButton')

	local closeButton = CreateFrame('Button', nil, CreditsFrame, 'UIPanelButtonTemplate')
	closeButton:SetSize(128, 25)
	closeButton:SetPoint('BOTTOM', 0, 25)
	closeButton:SetText(CLOSE)
	closeButton:SetScript('OnClick', function()
		CreditsFrame:Hide()
	end)
	tinsert(ns.buttons, closeButton)

	CreditsFrame:SetScript('OnHide', function()
		options:SetAlpha(1)
	end)
end

