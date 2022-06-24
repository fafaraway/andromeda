local F, C, L = unpack(select(2, ...))
local INSTALL = F:RegisterModule('Installation')

local function SetupCVars()
    SetCVar('deselectOnClick', 1)
    SetCVar('useuiscale', '1')
    SetCVar('uiscale', '1')
    SetCVar('missingTransmogSourceInItemTooltips', 1)
    SetCVar('movieSubtitle', 1)
    SetCVar('scriptErrors', C.IS_DEVELOPER and 0 or 1)
    SetCVar('predictedHealth', 1)

    -- map
    SetCVar('rotateMinimap', 0)
    SetCVar('mapFade', 1)

    -- display
    SetCVar('Outline', 3)
    SetCVar('findYourselfMode', 2)

    -- control
    SetCVar('autoDismountFlying', 0)
    SetCVar('autoDismount', 1)
    SetCVar('autoClearAFK', 1)
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
    SetCVar('showToastBroadcast', 1)
    SetCVar('showToastFriendRequest', 1)
    SetCVar('showToastWindow', 1)

    -- names
    SetCVar('UnitNameOwn', 0)
    SetCVar('UnitNameNonCombatCreatureName', 0)
    -- SetCVar('UnitNameNPC', 1)
    SetCVar('UnitNameFriendlyPlayerName', 1)
    SetCVar('UnitNameFriendlyPetName', 0)
    SetCVar('UnitNameFriendlyGuardianName', 0)
    SetCVar('UnitNameFriendlyTotemName', 0)
    SetCVar('UnitNameEnemyPlayerName', 1)
    SetCVar('UnitNameEnemyPetName', 0)
    SetCVar('UnitNameEnemyGuardianName', 0)
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
    SetCVar('predictedHealth', 1)

    -- combat text
    SetCVar('enableFloatingCombatText', 0)

    -- nameplates
    SetCVar('nameplateShowAll', 1)
    SetCVar('nameplateShowEnemies', 1)
    SetCVar('nameplateShowEnemyGuardians', 1)
    SetCVar('nameplateShowEnemyMinions', 1)
    SetCVar('nameplateShowEnemyPets', 1)
    SetCVar('nameplateShowEnemyTotems', 1)
    SetCVar('nameplateShowEnemyMinus', 1)
    SetCVar('nameplateMotion', 1)
    SetCVar('nameplateMotionSpeed', 0.2)

    -- quest
    SetCVar('autoQuestWatch', 1)
    SetCVar('autoQuestProgress', 1)
    SetCVar('showQuestTrackingTooltips', 0) -- this is annoying

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
    SetCVar('cameraPivot', 0)

    -- screenshot
    SetCVar('screenshotQuality', 10)
    SetCVar('screenshotFormat', 'jpg')

    -- mouse
    SetCVar('rawMouseEnable', 1)

    -- actionbar
    SetCVar('countdownForCooldowns', 0)
    SetCVar('ActionButtonUseKeyDown', 1)
    SetCVar('secureAbilityToggle', 1)
    SetCVar('lockActionBars', 1)
    SetCVar('alwaysShowActionBars', 1)

    if C.IS_DEVELOPER then
        SetCVar('AutoPushSpellToActionBar', 0)
        SetCVar('cursorsizepreferred', 2)
        SetCVar('worldPreloadNonCritical', 0)
    end
end

local function UpdateUIScale()
    if C.SCREEN_HEIGHT > 1440 then
        _G.FREE_ADB.UIScale = 2
    elseif C.SCREEN_HEIGHT > 1080 and C.SCREEN_HEIGHT < 1440 then
        _G.FREE_ADB.UIScale = 1.4
    else
        _G.FREE_ADB.UIScale = 1
    end
end

local function SetupActionbars() end

local function SetupChatFrame()
    F:GetModule('Chat'):UpdateChatSize()

    for i = 1, _G.NUM_CHAT_WINDOWS do
        local cf = _G['ChatFrame' .. i]
        _G.ChatFrame_RemoveMessageGroup(cf, 'CHANNEL')
    end
    _G.FCF_SavePositionAndDimensions(_G.ChatFrame1)

    C.DB.Chat.LockPosition = true
end

local function SetupDBM()
    -- if not DBM_AllSavedOptions then return end
    -- _G.DBM_AllSavedOptions['Default']['BlockVersionUpdateNotice'] = true
    -- _G.DBM_AllSavedOptions['Default']['EventSoundVictory'] = 'None'
    -- if not _G.DBT_AllPersistentOptions then return end
    -- _G.DBT_AllPersistentOptions['HugeBarsEnabled'] = false
    -- _G.DBT_AllPersistentOptions['Default']['DBM'].BarYOffset = 20
    -- _G.DBT_AllPersistentOptions['Default']['DBM'].HugeBarYOffset = 20
    -- _G.DBT_AllPersistentOptions['Default']['DBM'].ExpandUpwards = true
    -- _G.DBT_AllPersistentOptions['Default']['DBM'].InlineIcons = false
    -- _G.DBT_AllPersistentOptions['Default']['DBM'].Width = 160
    -- _G.DBT_AllPersistentOptions['Default']['DBM'].FlashBar = true
    -- _G.DBM_MinimapIcon['hide'] = true
    -- if IsAddOnLoaded('DBM-VPYike') then
    -- 	_G.DBM_AllSavedOptions['Default']['CountdownVoice'] = 'VP:Yike'
    -- 	_G.DBM_AllSavedOptions['Default']['ChosenVoicePack'] = 'Yike'
    -- end
end

local function SetupAddons() end

function INSTALL:HelloWorld()
    local f = CreateFrame('Frame', C.ADDON_TITLE .. 'InstallFrame', _G.UIParent, 'BackdropTemplate')
    f:SetSize(400, 400)
    f:SetPoint('CENTER')
    f:SetFrameStrata('HIGH')
    F.SetBD(f)

    f.logo = F.CreateFS(f, C.ASSET_PATH .. 'fonts\\header.ttf', 22, nil, C.COLORFUL_ADDON_TITLE, nil, true, 'TOP', 0, -4)
    f.desc = F.CreateFS(f, C.Assets.Font.Regular, 10, nil, 'installation', { 0.7, 0.7, 0.7 }, true, 'TOP', 0, -30)

    local lineLeft = F.SetGradient(f, 'H', 0.7, 0.7, 0.7, 0, 0.7, 120, C.MULT)
    lineLeft:SetPoint('TOP', -60, -26)

    local lineRight = F.SetGradient(f, 'H', 0.7, 0.7, 0.7, 0.7, 0, 120, C.MULT)
    lineRight:SetPoint('TOP', 60, -26)

    f.body = CreateFrame('Frame', nil, f, 'BackdropTemplate')
    f.body:SetSize(380, 304)
    f.body:SetPoint('TOPLEFT', 10, -50)
    f.body.__bg = F.CreateBDFrame(f.body)
    f.body.__bg:SetBackdropColor(0.04, 0.04, 0.04, 0.25)

    local headerText = F.CreateFS(f.body, C.Assets.Font.Regular, 18, nil, nil, 'YELLOW', true, 'TOPLEFT', 10, -20)
    headerText:SetWidth(360)

    local bodyText = F.CreateFS(f.body, C.Assets.Font.Regular, 14, nil, nil, 'GREY', true, 'TOPLEFT', 10, -50)
    bodyText:SetJustifyH('LEFT')
    bodyText:SetWordWrap(true)
    bodyText:SetWidth(360)

    local progressBar = CreateFrame('StatusBar', nil, f.body)
    progressBar:SetPoint('BOTTOM', f.body, 'BOTTOM', 0, 10)
    progressBar:SetSize(320, 20)
    progressBar:SetStatusBarTexture(C.Assets.Statusbar.Normal)
    progressBar:Hide()
    F:SmoothBar(progressBar)

    F.CreateBDFrame(progressBar, 0.3)
    progressBar.shadow = F.CreateSD(progressBar)
    if progressBar.shadow then
        progressBar.shadow:SetBackdropBorderColor(C.r, C.g, C.b)
    end

    local progressBarText = F.CreateFS(progressBar, C.Assets.Font.Regular, 11, nil, '', nil, 'THICK', 'CENTER', 0, 0)

    local leftButton = CreateFrame('Button', '', f, 'UIPanelButtonTemplate')
    leftButton:SetPoint('BOTTOM', -52, 10)
    leftButton:SetSize(100, 26)
    F.Reskin(leftButton)

    local rightButton = CreateFrame('Button', '', f, 'UIPanelButtonTemplate')
    rightButton:SetPoint('BOTTOM', 52, 10)
    rightButton:SetSize(100, 26)
    F.Reskin(rightButton)

    local closeButton = CreateFrame('Button', '', f, 'UIPanelCloseButton')
    closeButton:SetPoint('TOPRIGHT', f, 'TOPRIGHT')
    closeButton:SetScript('OnClick', function()
        f:Hide()
    end)
    F.ReskinClose(closeButton)

    local step6 = function()
        progressBar:SetValue(600)
        PlaySoundFile('Sound\\Spells\\LevelUp.wav')
        headerText:SetText(L['Success!'])
        bodyText:SetText(
            F:StyleAddonName(
                L['The installation has completed successfully.|n|nPlease click the Finish button below to reload the interface.|n|nKeep in mind, you can enter |cffe9c55d/free|r to get detailed help or directly enter |cffe9c55d/free config|r to open the config panel and change various settings.']
            )
        )
        progressBarText:SetText('6/6')
        leftButton:Hide()
        rightButton:SetText(L['Finish'])

        rightButton:SetScript('OnClick', function()
            C.DB.InstallationComplete = true
            _G.ReloadUI()
        end)
    end

    local step5 = function()
        progressBar:SetValue(500)
        headerText:SetText(_G.ADDONS)
        bodyText:SetText(
            F:StyleAddonName(
                L['This step will adjust the settings of some addons to match the interface style and layout of %AddonName%.']
            )
        )
        progressBarText:SetText('5/6')

        leftButton:SetScript('OnClick', step6)
        rightButton:SetScript('OnClick', function()
            SetupDBM()
            SetupAddons()
            step6()
        end)
    end

    local step4 = function()
        progressBar:SetValue(400)
        headerText:SetText(L['Actionbar'])
        bodyText:SetText(F:StyleAddonName(L['This step will adjust settings related to actionbars.']))
        progressBarText:SetText('4/6')

        leftButton:SetScript('OnClick', step5)
        rightButton:SetScript('OnClick', function()
            SetupActionbars()
            step5()
        end)
    end

    local step3 = function()
        progressBar:SetValue(300)
        headerText:SetText(L['Chat'])
        bodyText:SetText(F:StyleAddonName(L['This step will adjust settings related to the chat.']))
        progressBarText:SetText('3/6')

        leftButton:SetScript('OnClick', step4)
        rightButton:SetScript('OnClick', function()
            SetupChatFrame()
            step4()
        end)
    end

    local step2 = function()
        progressBar:SetValue(200)
        headerText:SetText(L['UI Scale'])
        bodyText:SetText(F:StyleAddonName(L['This step will set the appropriate scale for the interface.']))
        progressBarText:SetText('2/6')

        leftButton:SetScript('OnClick', step3)
        rightButton:SetScript('OnClick', function()
            UpdateUIScale()
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
        headerText:SetText(L['Basic Settings'])
        bodyText:SetText(
            F:StyleAddonName(
                L['These installation steps will adjust various suitable settings for %AddonName%.|n|nThe first step will adjust some |cffe9c55dCVars|r settings.|n|nClick the continue button below to apply the settings, or click the skip button to skip these settings.']
            )
        )
        progressBarText:SetText('1/6')

        leftButton:Show()
        leftButton:SetText(L['Skip'])
        rightButton:SetText(L['Continue'])

        leftButton:SetScript('OnClick', step2)
        rightButton:SetScript('OnClick', function()
            SetupCVars()
            step2()
        end)
    end

    headerText:SetText(L['Hello'])
    bodyText:SetText(
        F:StyleAddonName(
            L['Welcome to %ADDONNAME%!|n|nSome settings need to be adjust before you start using it.|n|nClick the install button to enter the installation step.']
        )
    )

    leftButton:SetText(L['Cancel'])
    rightButton:SetText(L['Install'])

    leftButton:SetScript('OnClick', function()
        f:Hide()
    end)
    rightButton:SetScript('OnClick', step1)
end

function INSTALL:OnLogin()
    if not C.DB.InstallationComplete then
        self:HelloWorld()
    end
end
