local F, C, L = unpack(select(2, ...))
local INSTALL = F:RegisterModule('Install')

local min, max, tonumber = math.min, math.max, tonumber

local function clipScale(scale)
	return tonumber(format("%.5f", scale))
end

local function GetPerfectScale()
	local _, height = GetPhysicalScreenSize()
	local scale = C.general.uiScale
	local bestScale = max(.4, min(1.15, 768 / height))
	local pixelScale = 768 / height

	if C.general.uiScaleAuto then scale = clipScale(bestScale) end

	C.Mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	return scale
end

local isScaling = false
local function SetupUIScale()
	if isScaling then return end
	isScaling = true

	local scale = GetPerfectScale()
	local parentScale = UIParent:GetScale()
	if scale ~= parentScale then
		UIParent:SetScale(scale)
	end

	C.general.uiScale = clipScale(scale)

	isScaling = false
end
SetupUIScale()
INSTALL.SetupUIScale = SetupUIScale()


local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local smoother, min, max = CreateFrame('Frame'), math.min, math.max
smoother:SetScript('OnUpdate', function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)


local function ForceDefaultSettings()
	SetCVar('autoLootDefault', 1)
	SetCVar('lootUnderMouse', 1)

	SetCVar('alwaysCompareItems', 0)

	SetCVar('autoSelfCast', 1)

	SetCVar('nameplateShowEnemies', 1)
	SetCVar('nameplateShowSelf', 0)
	SetCVar('nameplateShowAll', 1)
	SetCVar('nameplateMotion', 1)
	SetCVar('nameplateShowFriendlyNPCs', 0)
	SetCVar('nameplateOtherTopInset', 0.08)
	SetCVar('nameplateSelectedScale', 1)
	SetCVar('nameplateLargerScale', 1)
	SetCVar('nameplateMinScale', 0.8)

	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('ActionButtonUseKeyDown', 1)
	SetActionBarToggles(1, 1, 1, 1)
	SHOW_MULTI_ACTIONBAR_4 = 1
	SHOW_MULTI_ACTIONBAR_3 = 1
	SHOW_MULTI_ACTIONBAR_2 = 1
	SHOW_MULTI_ACTIONBAR_1 = 1
	MultiActionBar_Update()
	
	SetCVar('floatingCombatTextCombatDamage', 1)
	SetCVar('floatingCombatTextCombatHealing', 1)
	SetCVar('floatingCombatTextCombatDamageDirectionalScale', 1)
	SetCVar('floatingCombatTextFloatMode', 1)
	SetCVar('WorldTextScale', 1.5)
	SetCVar('cameraDistanceMaxZoomFactor', 2.6)
	SetCVar('screenshotQuality', 10)
	SetCVar('showTutorials', 0)
	SetCVar('gameTip', 0)
	SetCVar('UberTooltips', 1)
	SetCVar('profanityFilter', 0)
	SetCVar('chatStyle', 'classic')
	SetCVar('chatBubbles', 1)
	SetCVar('breakUpLargeNumbers', 1)
	SetCVar('overrideArchive', 0)
	SetCVar('cameraYawMoveSpeed', 120)
	SetCVar('rawMouseEnable', 1)
	SetCVar('autoOpenLootHistory', 0)
	SetCVar('lossOfControl', 0)
	SetCVar('nameplateShowSelf', 0)
	SetCVar('fstack_preferParentKeys', 0)
end

local function ForceChatSettings()
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint(unpack(C.chat.position))
	ChatFrame1:SetWidth(380)
	ChatFrame1:SetHeight(200)
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G['ChatFrame'..i]
		ChatFrame_RemoveMessageGroup(cf, 'CHANNEL')
	end
	FCF_SavePositionAndDimensions(ChatFrame1)

	ToggleChatColorNamesByClassGroup(true, 'SAY')
	ToggleChatColorNamesByClassGroup(true, 'EMOTE')
	ToggleChatColorNamesByClassGroup(true, 'YELL')
	ToggleChatColorNamesByClassGroup(true, 'GUILD')
	ToggleChatColorNamesByClassGroup(true, 'OFFICER')
	ToggleChatColorNamesByClassGroup(true, 'GUILD_ACHIEVEMENT')
	ToggleChatColorNamesByClassGroup(true, 'ACHIEVEMENT')
	ToggleChatColorNamesByClassGroup(true, 'WHISPER')
	ToggleChatColorNamesByClassGroup(true, 'PARTY')
	ToggleChatColorNamesByClassGroup(true, 'PARTY_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'RAID')
	ToggleChatColorNamesByClassGroup(true, 'RAID_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'RAID_WARNING')
	ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND')
	ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL1')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL2')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL3')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL4')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL5')
	ToggleChatColorNamesByClassGroup(true, 'INSTANCE_CHAT')
	ToggleChatColorNamesByClassGroup(true, 'INSTANCE_CHAT_LEADER')
end


function INSTALL:HelloWorld()
	local f = CreateFrame('Frame', 'FreeUI_InstallFrame', UIParent)
	f:SetSize(400, 500)
	f:SetPoint('CENTER')
	f:SetFrameStrata('HIGH')
	F.CreateBD(f)
	F.CreateSD(f)

	local sb = CreateFrame('StatusBar', nil, f)
	sb:SetPoint('BOTTOM', f, 'BOTTOM', 0, 60)
	sb:SetSize(320, 20)
	sb:SetStatusBarTexture(C.media.sbTex)
	sb:Hide()
	SmoothBar(sb)

	local sbd = CreateFrame('Frame', nil, sb)
	sbd:SetPoint('TOPLEFT', sb, -1, 1)
	sbd:SetPoint('BOTTOMRIGHT', sb, 1, -1)
	sbd:SetFrameLevel(sb:GetFrameLevel()-1)
	F.CreateBD(sbd, .25)

	local header = f:CreateFontString(nil, 'OVERLAY')
	header:SetFontObject(GameFontHighlightLarge)
	header:SetPoint('TOP', f, 'TOP', 0, -20)

	local body = f:CreateFontString(nil, 'OVERLAY')
	body:SetFontObject(GameFontHighlight)
	body:SetJustifyH('LEFT')
	body:SetWidth(f:GetWidth()-40)
	body:SetPoint('TOPLEFT', f, 'TOPLEFT', 20, -60)

	local credits = F.CreateFS(f, 'pixel', '', nil, nil, true, 'BOTTOM', 0, 4)
	credits:SetText('|cff808080<|rFree|cff9c84efUI|r|cff808080>|r by |cffe8155cHaleth|r and |cff37b1d6Solor|r')

	local sbt = F.CreateFS(sb, 'pixel', '', nil, nil, true, 'CENTER', 0, 0)

	local option1 = CreateFrame('Button', 'FreeUI_Install_Option1', f, 'UIPanelButtonTemplate')
	option1:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 40, 20)
	option1:SetSize(128, 25)

	local option2 = CreateFrame('Button', 'FreeUI_Install_Option2', f, 'UIPanelButtonTemplate')
	option2:SetPoint('BOTTOMRIGHT', f, 'BOTTOMRIGHT', -40, 20)
	option2:SetSize(128, 25)

	local close = CreateFrame('Button', 'FreeUI_Install_CloseButton', f, 'UIPanelCloseButton')
	close:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
	close:SetScript('OnClick', function()
		UIFrameFade(f,{
			mode = 'OUT',
			timeToFade = 0.5,
			finishedFunc = function(f) f:SetAlpha(1); f:Hide() end,
			finishedArg1 = f,
		})
	end)

	F.Reskin(option1)
	F.Reskin(option2)
	F.ReskinClose(close)



	local step4 = function()
		sb:SetValue(400)
		--PlaySoundFile('Sound\\interface\\LevelUp.wav')
		header:SetText('Success!')
		body:SetText("Installation is complete.\n\nPlease click the 'Finish' button to reload the UI.\n\nEnjoy!")
		sbt:SetText('4/4')
		option1:Hide()
		option2:SetText('Finish')

		option2:SetScript('OnClick', function()
			FreeUIConfig['installComplete'] = true
			ReloadUI()
		end)
	end

	local step3 = function()
		sb:SetValue(300)
		header:SetText('3. Chat')
		body:SetText('The third and final step applies the chat settings.\n\nThis step is recommended for any user.')
		sbt:SetText('3/4')

		option1:SetScript('OnClick', step4)
		option2:SetScript('OnClick', function()
			ForceChatSettings()
			step4()
		end)
	end

	local step2 = function()
		sb:SetValue(200)
		header:SetText('2. UI Scale')
		body:SetText('The second step applies the correct UI scale.\n\nThis step is recommended for any user.')
		sbt:SetText('2/4')

		option1:SetScript('OnClick', step3)
		option2:SetScript('OnClick', function()
			SetupUIScale()
			step3()
		end)
	end

	local step1 = function()
		sb:SetMinMaxValues(0, 400)
		sb:Show()
		sb:SetValue(0)
		sb:SetValue(100)
		sb:GetStatusBarTexture():SetGradient('VERTICAL', C.r, C.g, C.b, C.r, C.g, C.b)
		header:SetText('1. CVars')
		body:SetText("These steps will apply the correct setup for FreeUI.\n\nThe first step applies the essential settings.\n\nThis is recommended for any user, unless you want to apply only a specific part of the settings.\n\nClick 'Continue' to apply the settings, or click 'Skip' if you wish to skip this step.")
		sbt:SetText('1/4')

		option1:Show()

		option1:SetText('Skip')
		option2:SetText('Continue')

		option1:SetScript('OnClick', step2)
		option2:SetScript('OnClick', function()
			ForceDefaultSettings()
			step2()
		end)
	end




	local tut4 = function()
		sb:SetValue(600)
		header:SetText('4. Finished')
		body:SetText('WIP')

		sbt:SetText('4/4')

		option1:Show()

		option1:SetText('Close')
		option2:SetText('Install')

		option1:SetScript('OnClick', function()
			UIFrameFade(f,{
				mode = 'OUT',
				timeToFade = 0.5,
				finishedFunc = function(f) f:Hide() end,
				finishedArg1 = f,
			})
		end)
		option2:SetScript('OnClick', step1)
	end

	local tut3 = function()
		sb:SetValue(300)
		header:SetText('3. Features')
		body:SetText('WIP')

		sbt:SetText('3/4')

		option2:SetScript('OnClick', tut4)
	end

	local tut2 = function()
		sb:SetValue(200)
		header:SetText('2. Unit frames')
		body:SetText('WIP')

		sbt:SetText('2/4')

		option2:SetScript('OnClick', tut3)
	end

	local tut1 = function()
		sb:SetMinMaxValues(0, 600)
		sb:Show()
		sb:SetValue(100)
		sb:GetStatusBarTexture():SetGradient('VERTICAL', C.r, C.g, C.b, C.r, C.g, C.b)
		header:SetText('1. Essentials')
		body:SetText('WIP')

		sbt:SetText('1/4')

		option1:Hide()

		option2:SetText('Next')

		option2:SetScript('OnClick', tut2)
	end




	header:SetText('Hello')
	body:SetText("Thank you for choosing FreeUI!\n\nIn just a moment, you can get started. All that's needed is for the correct settings to be applied. Don't worry, none of your personal preferences will be changed.\n\nYou can also take a brief tutorial on some of the features of FreeUI, which is recommended if you're a new user.\n\nPress the 'Tutorial' button to do so now, or press 'Install' to go straight to the setup.")


	option1:SetText('Tutorial')
	option2:SetText('Install')

	option1:SetScript('OnClick', tut1)
	option2:SetScript('OnClick', step1)
end
	



function INSTALL:OnLogin()
	print(C.Title..' - '..C.GreyColor..C.Version)
	print(C.MyColor..L['UIHELP'])

	if FreeUIConfig['installComplete'] ~= true then
		INSTALL:HelloWorld()
	else
		if C.general.uiScaleAuto then
			F.HideOption(Advanced_UseUIScale)
			F.HideOption(Advanced_UIScaleSlider)
		end
		
		SetupUIScale()
	end

	--print('cvar_useUiScale - '.._G.GetCVar('useUiScale'))
	--print('cvar_uiScale - '.._G.GetCVar('uiscale'))
	--print('UIParent_Scale - '.._G.UIParent:GetScale())
	--print(C.general.uiScale)

	--print(C.Mult)
end


