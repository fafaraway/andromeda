local F, C, L = unpack(select(2, ...))
local INSTALL = F:GetModule('INSTALL')


local function SetupCVars()
	-- credit EKE

	SetCVar('deselectOnClick', 1)
	SetCVar('useUiScale', 0)
	SetCVar('WorldTextScale', 1.5)
	SetCVar('missingTransmogSourceInItemTooltips', 1)
	SetCVar('movieSubtitle', 1)
	SetCVar('scriptErrors', 0)

	-- map
	SetCVar('rotateMinimap', 0)
	SetCVar('mapFade', 1)

	-- display
	SetCVar('Outline', 3)
	SetCVar('findYourselfMode', 2)
	SetCVar('showTutorials', 0)
	SetCVar('hideAdventureJournalAlerts', 0)
	SetCVar('showNPETutorials', 0)

	-- control
	SetCVar('autoDismountFlying', 0)
	SetCVar('autoDismount', 1)
	SetCVar('autoClearAFK', 0)
	SetCVar('autoLootDefault', 1)
	SetCVar('lootUnderMouse', 1)
	SetCVar('interactOnLeftClick', 1)
	SetCVar('autoOpenLootHistory', 0)
	SetCVar('UberTooltips', 1)
	SetCVar('alwaysCompareItems', 0)

	-- social
	SetCVar('profanityFilter', 0)
	SetCVar('spamFilter', 1)
	SetCVar('guildMemberNotify', 0)
	SetCVar('BlockTrades', 0)
	SetCVar('blockChannelInvites', 0)

	-- chat
	SetCVar('chatBubbles', 1)
	SetCVar('chatBubblesParty', 1)
	SetCVar('chatStyle', 'classic')
	SetCVar('chatClassColorOverride', 0)
	SetCVar('whisperMode', 'inline')
	SetCVar('showToastOnline', 1)
	SetCVar('showToastOffline', 1)
	SetCVar('showToastBroadcast',1)
	SetCVar('showToastFriendRequest',1)
	SetCVar('showToastWindow',1)

	-- names
	SetCVar('UnitNameOwn', 0)
	SetCVar('UnitNameNonCombatCreatureName', 0)
	SetCVar('UnitNameNPC', 1)
	SetCVar('UnitNameFriendlyPlayerName', 1)
	SetCVar('UnitNameFriendlyPetName', 0)
	SetCVar('UnitNameFriendlyGuardianName', 0)
	SetCVar('UnitNameFriendlyTotemName', 0)
	SetCVar('UnitNameEnemyPlayerName', 1)
	SetCVar('UnitNameEnemyPetName', 1)
	SetCVar('UnitNameEnemyGuardianName', 1)
	SetCVar('UnitNameEnemyTotemName', 1)
	SetCVar('UnitNameGuildTitle', 0)
	SetCVar('UnitNamePlayerPVPTitle', 1)

	-- combat
	SetCVar('showTargetOfTarget', 1)
	SetCVar('doNotFlashLowHealthWarning', 0)
	SetCVar('lossOfControl', 1)
	SetCVar('spellActivationOverlayOpacity', 0)
	SetCVar('autoSelfCast', 1)
	SetCVar('stopAutoAttackOnTargetChange', 0)
	SetCVar('breakUpLargeNumbers', 1)
	SetCVar('TargetNearestUseNew', 1)
	SetCVar('advancedCombatLogging', 1)

	-- combat text
	SetCVar('enableFloatingCombatText', 0)
	SetCVar('floatingCombatTextCombatDamage', 1)
	SetCVar('floatingCombatTextCombatHealing', 1)
	SetCVar('floatingCombatTextCombatDamageDirectionalOffset', 5)
	SetCVar('floatingCombatTextCombatDamageDirectionalScale', 1) -- 0 old style 1-5 new style
	SetCVar('floatingCombatTextFloatMode', 3) -- 1 up 2 down 3 curve

	-- nameplates

	SetCVar('nameplateShowAll', 1)

	SetCVar('nameplateShowEnemies', 1)
	SetCVar('nameplateShowEnemyGuardians', 1)
	SetCVar('nameplateShowEnemyMinions', 1)
	SetCVar('nameplateShowEnemyPets', 1)
	SetCVar('nameplateShowEnemyTotems', 1)
	SetCVar('nameplateShowEnemyMinus', 1)

	SetCVar('nameplateMotion', 1)








	-- quest
	SetCVar('autoQuestWatch', 1)
	SetCVar('autoQuestProgress', 1)
	SetCVar('showQuestTrackingTooltips', 1)

	-- hardcore
	SetCVar('overrideArchive', 0)
	SetCVar('violenceLevel', 5)

	-- graphical
	SetCVar('ffxGlow', 1)
	SetCVar('ffxDeath', 1)
	SetCVar('SkyCloudLOD', 3)

	-- camera
	SetCVar('cameraSmoothStyle', 0)
	SetCVar('cameraSmoothTrackingStyle', 0)
	SetCVar('cameraYawMoveSpeed', 120)
	SetCVar('cameraDistanceMaxZoomFactor', 2.6)

	-- screenshot
	SetCVar('screenshotQuality', 10)
	SetCVar('screenshotFormat', 'png')

	-- mouse
	SetCVar('rawMouseEnable', 1)
	SetCVar('cursorsizepreferred', 1)
end

local function SetupUIScale()
	if C.ScreenHeight >= 2000 then
		FreeADB['ui_scale'] = 2
	elseif C.ScreenHeight >= 1500 then
		FreeADB['ui_scale'] = 1.4
	else
		FreeADB['ui_scale'] = 1
	end
end

local function SetupActionbars()
	SetCVar('countdownForCooldowns', 0)
	SetCVar('ActionButtonUseKeyDown', 1)
	SetCVar('secureAbilityToggle', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('alwaysShowActionBars', 1)

	SetActionBarToggles(1, 1, 1, 1, 1)

	MultiActionBar_Update()

	MultiBarBottomLeft:SetShown(true)
	MultiBarRight:SetShown(true)
	MultiBarLeft:SetShown(true)
	MultiBarBottomRight:SetShown(true)
end

local function SetupChatFrame()
	F:GetModule('CHAT'):UpdateChatSize()

	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G['ChatFrame'..i]
		ChatFrame_RemoveMessageGroup(cf, 'CHANNEL')
	end
	FCF_SavePositionAndDimensions(ChatFrame1)

	FreeDB.chat.lock_position = true
end

local function SetupSkada()
	if not SkadaDB then return end

	SkadaDB['profiles']['Default'].showtotals = true
	SkadaDB['profiles']['Default'].showself = true
	SkadaDB['profiles']['Default']['icon'].hide = true
	SkadaDB['profiles']['Default'].showtotals = true
	SkadaDB['profiles']['Default']['windows'].barfont = '!Free_normal'
	SkadaDB['profiles']['Default']['windows'].smoothing = true
	SkadaDB['profiles']['Default']['windows'].bartexture = '!Free_norm'
end

local function SetupDBM()
	if not DBM_AllSavedOptions then return end

	_G.DBM_AllSavedOptions['Default']['BlockVersionUpdateNotice'] = true
	_G.DBM_AllSavedOptions['Default']['EventSoundVictory'] = 'None'

	if not _G.DBT_AllPersistentOptions then return end

	_G.DBT_AllPersistentOptions['HugeBarsEnabled'] = false

	_G.DBT_AllPersistentOptions['Default']['DBM'].BarYOffset = 20
	_G.DBT_AllPersistentOptions['Default']['DBM'].HugeBarYOffset = 20
	_G.DBT_AllPersistentOptions['Default']['DBM'].ExpandUpwards = true
	_G.DBT_AllPersistentOptions['Default']['DBM'].InlineIcons = false
	_G.DBT_AllPersistentOptions['Default']['DBM'].Width = 160
	_G.DBT_AllPersistentOptions['Default']['DBM'].FlashBar = true

	_G.DBM_MinimapIcon['hide'] = true

	if IsAddOnLoaded('DBM-VPYike') then
		_G.DBM_AllSavedOptions['Default']['CountdownVoice'] = 'VP:Yike'
		_G.DBM_AllSavedOptions['Default']['ChosenVoicePack'] = 'Yike'
	end
end

local function SetupAddons()

end

function INSTALL:HelloWorld()
	local f = CreateFrame('Frame', 'FreeUI_InstallFrame', UIParent)
	f:SetSize(400, 400)
	f:SetPoint('CENTER')
	f:SetFrameStrata('HIGH')
	F.CreateBD(f, nil, true)
	F.CreateTex(f)

	f.logo = F.CreateFS(f, C.AssetsPath..'fonts\\header.ttf', 22, nil, C.Title, nil, 'THICK', 'TOP', 0, -4)
	f.desc = F.CreateFS(f, C.Assets.Fonts.Number, 10, nil, 'installation', {.7,.7,.7}, 'THICK', 'TOP', 0, -30)

	f.lineLeft = CreateFrame('Frame', nil, f)
	f.lineLeft:SetPoint('TOP', -60, -26)
	F.CreateGF(f.lineLeft, 120, 1, 'Horizontal', .7, .7, .7, 0, .7)
	f.lineLeft:SetFrameStrata('HIGH')

	f.lineRight = CreateFrame('Frame', nil, f)
	f.lineRight:SetPoint('TOP', 60, -26)
	F.CreateGF(f.lineRight, 120, 1, 'Horizontal', .7, .7, .7, .7, 0)
	f.lineRight:SetFrameStrata('HIGH')

	f.body = CreateFrame('Frame', nil, f)
	f.body:SetSize(380, 304)
	f.body:SetPoint('TOPLEFT', 10, -50)
	F.CreateBD(f.body, .3)

	local headerText = F.CreateFS(f.body, C.Assets.Fonts.Normal, 16, true, nil, 'YELLOW', nil, 'TOPLEFT', 10, -20)
	headerText:SetWidth(360)

	local bodyText = F.CreateFS(f.body, C.Assets.Fonts.Normal, 12, true, nil, nil, nil, 'TOPLEFT', 10, -50)
	bodyText:SetJustifyH('LEFT')
	bodyText:SetWordWrap(true)
	bodyText:SetWidth(360)

	local progressBar = CreateFrame('StatusBar', nil, f.body)
	progressBar:SetPoint('BOTTOM', f.body, 'BOTTOM', 0, 10)
	progressBar:SetSize(320, 20)
	progressBar:SetStatusBarTexture(C.Assets.norm_tex)
	progressBar:Hide()
	F:SmoothBar(progressBar)

	F.CreateBDFrame(progressBar, .3)
	progressBar.shadow = F.CreateSD(progressBar)
	if progressBar.shadow then
		progressBar.shadow:SetBackdropBorderColor(C.r, C.g, C.b)
	end

	local progressBarText = F.CreateFS(progressBar, C.Assets.Fonts.Number, 11, nil, '', nil, 'THICK', 'CENTER', 0, 0)

	local leftButton = CreateFrame('Button', 'FreeUI_Install_LeftButton', f, 'UIPanelButtonTemplate')
	leftButton:SetPoint('BOTTOM', -52, 10)
	leftButton:SetSize(100, 26)
	F.Reskin(leftButton)

	local rightButton = CreateFrame('Button', 'FreeUI_Install_RightButton', f, 'UIPanelButtonTemplate')
	rightButton:SetPoint('BOTTOM', 52, 10)
	rightButton:SetSize(100, 26)
	F.Reskin(rightButton)

	local closeButton = CreateFrame('Button', 'FreeUI_Install_CloseButton', f, 'UIPanelCloseButton')
	closeButton:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
	closeButton:SetScript('OnClick', function()
		UIFrameFade(f,{
			mode = 'OUT',
			timeToFade = 0.5,
			finishedFunc = function(f) f:SetAlpha(1); f:Hide() end,
			finishedArg1 = f,
		})
	end)
	F.ReskinClose(closeButton)


	local step6 = function()
		progressBar:SetValue(600)
		PlaySoundFile('Sound\\Spells\\LevelUp.wav')
		headerText:SetText(L['INSTALL_HEADER_COMPLETE'])
		bodyText:SetText(L['INSTALL_BODY_COMPLETE'])
		progressBarText:SetText('6/6')
		leftButton:Hide()
		rightButton:SetText(L['INSTALL_BUTTON_FINISH'])

		rightButton:SetScript('OnClick', function()
			FreeDB['installation_complete'] = true
			ReloadUI()
		end)
	end

	local step5 = function()
		progressBar:SetValue(500)
		headerText:SetText(L['INSTALL_HEADER_ADDON'])
		bodyText:SetText(L['INSTALL_BODY_ADDON'])
		progressBarText:SetText('5/6')

		leftButton:SetScript('OnClick', step6)
		rightButton:SetScript('OnClick', function()
			SetupSkada()
			SetupDBM()
			SetupAddons()
			step6()
		end)
	end

	local step4 = function()
		progressBar:SetValue(400)
		headerText:SetText(L['INSTALL_HEADER_ACTIONBAR'])
		bodyText:SetText(L['INSTALL_BODY_ACTIONBAR'])
		progressBarText:SetText('4/6')

		leftButton:SetScript('OnClick', step5)
		rightButton:SetScript('OnClick', function()
			SetupActionbars()
			step5()
		end)
	end

	local step3 = function()
		progressBar:SetValue(300)
		headerText:SetText(L['INSTALL_HEADER_CHAT'])
		bodyText:SetText(L['INSTALL_BODY_CHAT'])
		progressBarText:SetText('3/6')

		leftButton:SetScript('OnClick', step4)
		rightButton:SetScript('OnClick', function()
			SetupChatFrame()
			step4()
		end)
	end

	local step2 = function()
		progressBar:SetValue(200)
		headerText:SetText(L['INSTALL_HEADER_UISCALE'])
		bodyText:SetText(L['INSTALL_BODY_UISCALE'])
		progressBarText:SetText('2/6')

		leftButton:SetScript('OnClick', step3)
		rightButton:SetScript('OnClick', function()
			SetupUIScale()
			F.SetupUIScale(true)
			F.SetupUIScale()
			step3()
		end)
	end

	local step1 = function()
		progressBar:SetMinMaxValues(0, 600)
		progressBar:Show()
		progressBar:SetValue(0)
		progressBar:SetValue(100)
		progressBar:SetStatusBarColor(C.r, C.g, C.b)
		headerText:SetText(L['INSTALL_HEADER_BASIC'])
		bodyText:SetText(L['INSTALL_BODY_BASIC'])
		progressBarText:SetText('1/6')

		leftButton:Show()
		leftButton:SetText(L['INSTALL_BUTTON_SKIP'])
		rightButton:SetText(L['INSTALL_BUTTON_CONTINUE'])

		leftButton:SetScript('OnClick', step2)
		rightButton:SetScript('OnClick', function()
			SetupCVars()
			step2()
		end)
	end


	headerText:SetText(L['INSTALL_HEADER_HELLO'])
	bodyText:SetText(L['INSTALL_BODY_WELCOME'])

	leftButton:SetText(L['INSTALL_BUTTON_CANCEL'])
	rightButton:SetText(L['INSTALL_BUTTON_INSTALL'])

	leftButton:SetScript('OnClick', function()
		UIFrameFade(f,{
			mode = 'OUT',
			timeToFade = 0.5,
			finishedFunc = function(f) f:Hide() end,
			finishedArg1 = f,
		})
	end)
	rightButton:SetScript('OnClick', step1)
end


function INSTALL:OnLogin()
	if FreeDB['installation_complete'] then return end

	self:HelloWorld()
end

