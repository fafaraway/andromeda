local F, C, L = unpack(select(2, ...))
local INSTALL = F:GetModule('Install')


local function setupCVars()
	SetCVar('autoLootDefault', 1)
	SetCVar('lootUnderMouse', 1)
	SetCVar('alwaysCompareItems', 0)
	SetCVar('autoSelfCast', 1)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	SetCVar('nameplateShowSelf', 0)
	SetCVar('nameplateShowEnemies', 1)
	SetCVar('nameplateMotion', 1)
	SetCVar('nameplateSelectedScale', 1)
	SetCVar('nameplateLargerScale', 1)
	SetCVar('nameplateMinScale', 0.8)
	SetCVar('autoQuestWatch', 1)
	SetCVar('overrideArchive', 0)
	SetCVar('chatClassColorOverride', '0')
	SetCVar('screenshotQuality', 10)
	SetCVar('showTutorials', 0)
	SetCVar('cameraYawMoveSpeed', 120)
	SetCVar('rawMouseEnable', 1)
end

local function setupUIScale()
	if C.ScreenHeight >= 2000 then
		FreeUIConfigsGlobal['ui_scale'] = 2
	elseif C.ScreenHeight >= 1500 then
		FreeUIConfigsGlobal['ui_scale'] = 1.4
	else
		FreeUIConfigsGlobal['ui_scale'] = 1
	end
end

local function setupActionbars()
	SetCVar('lockActionBars', 1)
	SetCVar('ActionButtonUseKeyDown', 1)
	SetCVar('alwaysShowActionBars', 1)

	SetActionBarToggles(1, 1, 1, 1, 1)

	MultiActionBar_Update()

	MultiBarBottomLeft:SetShown(true)
	MultiBarRight:SetShown(true)
	MultiBarLeft:SetShown(true)
	MultiBarBottomRight:SetShown(true)
end

local function setupChatFrame()
	F:GetModule("Chat"):UpdateChatSize()

	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		ChatFrame_RemoveMessageGroup(cf, "CHANNEL")
	end
	FCF_SavePositionAndDimensions(ChatFrame1)

	C.Chat.lock_position = true
end

local function setupSkada()
	if not IsAddOnLoaded("Skada") then return end
	if SkadaDB then wipe(SkadaDB) end

	SkadaDB = {
		["hasUpgraded"] = true,
		["profiles"] = {
			["Default"] = {
				["showtotals"] = true,
				["showself"] = true,
				["icon"] = {
					["hide"] = true,
				},
				["windows"] = {
					{
						["barheight"] = 18,
						["classicons"] = false,
						["barfont"] = "!Free_normal",
						["barfontflags"] = "OUTLINE",
						["barfontsize"] = 12,
						["barbgcolor"] = {
							["a"] = 0,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["barcolor"] = {
							["a"] = 0.5400000214576721,
							["b"] = 0.4117647058823529,
							["g"] = 0.4117647058823529,
							["r"] = 0.4117647058823529,
						},
						["background"] = {
							["color"] = {
								["a"] = 0,
							},
							["bordertexture"] = "None",
							["texture"] = "None",
						},
						["point"] = "CENTER",
						["smoothing"] = true,
						["bartexture"] = "!Free_statusbar",
						["title"] = {
							["textcolor"] = {
								["b"] = 0.7098039215686275,
								["g"] = 0.7098039215686275,
								["r"] = 0.7098039215686275,
							},
							["color"] = {
								["a"] = 0,
								["b"] = 0,
								["g"] = 0,
								["r"] = 0,
							},
							["font"] = "!Free_normal",
							["fontsize"] = 12,
							["fontflags"] = "OUTLINE",
							["texture"] = "Solid",
						},
					},
				},
				["tooltiprows"] = 10,
				["setformat"] = 8,
			},
		},
	}
end

local function setupAddons()
end

function INSTALL:HelloWorld()
	local installFrame = CreateFrame('Frame', 'FreeUI_InstallFrame', UIParent)
	installFrame:SetSize(400, 400)
	installFrame:SetPoint('CENTER')
	installFrame:SetFrameStrata('HIGH')
	F.CreateBD(installFrame)
	F.CreateSD(installFrame)
	F.CreateTex(installFrame)

	local logo = installFrame:CreateTexture()
	logo:SetSize(512, 128)
	logo:SetPoint('TOP')
	logo:SetTexture(C.Assets.logo_small)
	logo:SetScale(.3)
	logo:SetGradientAlpha('Vertical', C.r, C.g, C.b, 1, 1, 1, 1, 1)

	local desc = F.CreateFS(installFrame, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', 'installation', {.5,.5,.5}, true, 'TOP', 0, -36)

	local lineLeft = CreateFrame('Frame', nil, installFrame)
	lineLeft:SetPoint('TOP', -60, -30)
	F.CreateGF(lineLeft, 120, 1, 'Horizontal', .7, .7, .7, 0, .7)
	lineLeft:SetFrameStrata('HIGH')

	local lineRight = CreateFrame('Frame', nil, installFrame)
	lineRight:SetPoint('TOP', 60, -30)
	F.CreateGF(lineRight, 120, 1, 'Horizontal', .7, .7, .7, .7, 0)
	lineRight:SetFrameStrata('HIGH')





	local headerText = F.CreateFS(installFrame, C.Assets.Fonts.Chat, 16, true, nil, 'YELLOW', nil, 'TOPLEFT', 20, -70)
	local bodyText = F.CreateFS(installFrame, C.Assets.Fonts.Normal, 12, true, nil, nil, nil, 'TOPLEFT', 20, -100)
	bodyText:SetJustifyH('LEFT')
	bodyText:SetWordWrap(true)
	bodyText:SetWidth(installFrame:GetWidth()-40)

	local sb = CreateFrame('StatusBar', nil, installFrame)
	sb:SetPoint('BOTTOM', installFrame, 'BOTTOM', 0, 60)
	sb:SetSize(320, 20)
	sb:SetStatusBarTexture(C.Assets.norm_tex)
	sb:Hide()
	F:SmoothBar(sb)
	sb.bg = F.CreateBDFrame(sb)
	sb.glow = F.CreateSD(sb.bg)
	sb.glow:SetBackdropBorderColor(C.r, C.g, C.b, 1)

	local sbt = F.CreateFS(sb, C.Assets.Fonts.Number, 11, 'OUTLINE', '', nil, true, 'CENTER', 0, 0)

	local leftButton = CreateFrame('Button', 'FreeUI_Install_LeftButton', installFrame, 'UIPanelButtonTemplate')
	leftButton:SetPoint('BOTTOMLEFT', installFrame, 'BOTTOMLEFT', 40, 20)
	leftButton:SetSize(120, 26)
	F.Reskin(leftButton)

	local rightButton = CreateFrame('Button', 'FreeUI_Install_RightButton', installFrame, 'UIPanelButtonTemplate')
	rightButton:SetPoint('BOTTOMRIGHT', installFrame, 'BOTTOMRIGHT', -40, 20)
	rightButton:SetSize(120, 26)
	F.Reskin(rightButton)

	local closeButton = CreateFrame('Button', 'FreeUI_Install_CloseButton', installFrame, 'UIPanelCloseButton')
	closeButton:SetPoint('TOPRIGHT', installFrame, 'TOPRIGHT')
	closeButton:SetScript('OnClick', function()
		UIFrameFade(installFrame,{
			mode = 'OUT',
			timeToFade = 0.5,
			finishedFunc = function(installFrame) installFrame:SetAlpha(1); installFrame:Hide() end,
			finishedArg1 = installFrame,
		})
	end)
	F.ReskinClose(closeButton)


	local step6 = function()
		sb:SetValue(600)
		PlaySoundFile('Sound\\Spells\\LevelUp.wav')
		--headerText:SetText(L['INSTALL_HEADER_FIFTH'])
		--bodyText:SetText(L['INSTALL_BODY_FIFTH'])
		sbt:SetText('6/6')
		leftButton:Hide()
		rightButton:SetText(L['INSTALL_BUTTON_FINISH'])

		rightButton:SetScript('OnClick', function()
			FreeUIConfigs['installation_complete'] = true
			ReloadUI()
		end)
	end

	local step5 = function()
		sb:SetValue(500)
		--headerText:SetText(L['INSTALL_HEADER_FIFTH'])
		--bodyText:SetText(L['INSTALL_BODY_FIFTH'])
		sbt:SetText('5/6')

		leftButton:SetScript('OnClick', step6)
		rightButton:SetScript('OnClick', function()
			setupSkada()
			setupAddons()
			step6()
		end)
	end

	local step4 = function()
		sb:SetValue(400)
		--headerText:SetText(L['INSTALL_HEADER_FOURTH'])
		--bodyText:SetText(L['INSTALL_BODY_FOURTH'])
		sbt:SetText('4/6')

		leftButton:SetScript('OnClick', step5)
		rightButton:SetScript('OnClick', function()
			setupActionbars()
			step5()
		end)
	end

	local step3 = function()
		sb:SetValue(300)
		--headerText:SetText(L['INSTALL_HEADER_THIRD'])
		--bodyText:SetText(L['INSTALL_BODY_THIRD'])
		sbt:SetText('3/6')

		leftButton:SetScript('OnClick', step4)
		rightButton:SetScript('OnClick', function()
			setupChatFrame()
			step4()
		end)
	end

	local step2 = function()
		sb:SetValue(200)
		--headerText:SetText(L['INSTALL_HEADER_SECOND'])
		--bodyText:SetText(L['INSTALL_BODY_SECOND'])
		sbt:SetText('2/6')

		leftButton:SetScript('OnClick', step3)
		rightButton:SetScript('OnClick', function()
			setupUIScale()
			F.SetupUIScale(true)
			F.SetupUIScale()
			step3()
		end)
	end

	local step1 = function()
		sb:SetMinMaxValues(0, 600)
		sb:Show()
		sb:SetValue(0)
		sb:SetValue(100)
		sb:SetStatusBarColor(C.r, C.g, C.b)
		--headerText:SetText(L['INSTALL_HEADER_FIRST'])
		--bodyText:SetText(L['INSTALL_BODY_FIRST'])
		sbt:SetText('1/6')

		leftButton:Show()
		leftButton:SetText(L['INSTALL_BUTTON_SKIP'])
		rightButton:SetText(L['INSTALL_BUTTON_CONTINUE'])

		leftButton:SetScript('OnClick', step2)
		rightButton:SetScript('OnClick', function()
			setupCVars()
			step2()
		end)
	end


	local tut4 = function()
		sb:SetValue(400)
		headerText:SetText('4. Finished')
		bodyText:SetText('WIP')

		sbt:SetText('4/4')

		leftButton:Show()

		leftButton:SetText('Close')
		rightButton:SetText('Install')

		leftButton:SetScript('OnClick', function()
			UIFrameFade(installFrame,{
				mode = 'OUT',
				timeToFade = 0.5,
				finishedFunc = function(installFrame) installFrame:Hide() end,
				finishedArg1 = installFrame,
			})
		end)
		rightButton:SetScript('OnClick', step1)
	end

	local tut3 = function()
		sb:SetValue(300)
		headerText:SetText('3. Features')
		bodyText:SetText('WIP')

		sbt:SetText('3/4')

		rightButton:SetScript('OnClick', tut4)
	end

	local tut2 = function()
		sb:SetValue(200)
		headerText:SetText('2. Unit frames')
		bodyText:SetText('WIP')

		sbt:SetText('2/4')

		rightButton:SetScript('OnClick', tut3)
	end

	local tut1 = function()
		sb:SetMinMaxValues(0, 400)
		sb:Show()
		sb:SetValue(100)
		sb:GetStatusBarTexture():SetGradient('VERTICAL', C.r, C.g, C.b, C.r, C.g, C.b)
		headerText:SetText('1. Essentials')
		bodyText:SetText('WIP')

		sbt:SetText('1/4')

		leftButton:Hide()

		rightButton:SetText('Next')

		rightButton:SetScript('OnClick', tut2)
	end


	headerText:SetText(L['INSTALL_HEADER_HELLO'])
	bodyText:SetText(L['INSTALL_BODY_WELCOME'])

	leftButton:SetText(L['INSTALL_BUTTON_CANCEL'])
	rightButton:SetText(L['INSTALL_BUTTON_INSTALL'])

	leftButton:SetScript('OnClick', function()
		UIFrameFade(installFrame,{
			mode = 'OUT',
			timeToFade = 0.5,
			finishedFunc = function(installFrame) installFrame:Hide() end,
			finishedArg1 = installFrame,
		})
	end)
	rightButton:SetScript('OnClick', step1)
end


function INSTALL:OnLogin()
	if not FreeUIConfigs['installation_complete'] then
		self:HelloWorld()
	end
end

