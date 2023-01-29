local F, C, L = unpack(select(2, ...))
local TUTORIAL = F:GetModule('Tutorial')
local GUI = F:GetModule('GUI')

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
    SetCVar('nameplateShowFriendlyNPCs', 1)
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
        _G.ANDROMEDA_ADB.UIScale = 2
    elseif C.SCREEN_HEIGHT > 1080 and C.SCREEN_HEIGHT < 1440 then
        _G.ANDROMEDA_ADB.UIScale = 1.4
    else
        _G.ANDROMEDA_ADB.UIScale = 1
    end
end

local function SetupActionbars() end

local function SetupChatFrame() end

local function SetupAddons() end

function TUTORIAL:HelloWorld()
    local f = CreateFrame('Frame', C.ADDON_TITLE .. 'InstallFrame', _G.UIParent, 'BackdropTemplate')
    f:SetSize(400, 400)
    f:SetPoint('CENTER')
    f:SetFrameStrata('HIGH')
    F.SetBD(f)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    f.logo = F.CreateFS(f, C.ASSET_PATH .. 'fonts\\suez-one.ttf', 22, outline, C.COLORFUL_ADDON_TITLE, nil, outline or 'THICK', 'TOP', 0, -4)
    f.desc = F.CreateFS(f, C.Assets.Fonts.Regular, 10, outline, 'installation', { 0.7, 0.7, 0.7 }, outline or 'THICK', 'TOP', 0, -30)

    GUI:CreateGradientLine(f, 140, -70, -26, 70, -26)

    f.body = CreateFrame('Frame', nil, f, 'BackdropTemplate')
    f.body:SetSize(380, 304)
    f.body:SetPoint('TOPLEFT', 10, -50)
    f.body.__bg = F.CreateBDFrame(f.body, 0.25)

    local headerText = F.CreateFS(f.body, C.Assets.Fonts.Bold, 18, outline, nil, { 242 / 255, 211 / 255, 104 / 255 }, outline or 'THICK', 'TOPLEFT', 20, -16)
    headerText:SetWidth(340)

    GUI:CreateGradientLine(f.body, 140, -70, -40, 70, -40)

    local bodyText = F.CreateFS(f.body, C.Assets.Fonts.Regular, 13, outline, nil, { 0.7, 0.7, 0.7 }, outline or 'THICK', 'TOPLEFT', 20, -60)
    bodyText:SetJustifyH('LEFT')
    bodyText:SetWordWrap(true)
    bodyText:SetWidth(340)

    local pBar = CreateFrame('StatusBar', nil, f.body)
    pBar:SetPoint('BOTTOM', f.body, 'BOTTOM', 0, 10)
    pBar:SetSize(340, 20)
    pBar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    pBar:Hide()
    F:SetSmoothing(pBar, true)

    F.CreateBDFrame(pBar, 0.3)
    pBar.shadow = F.CreateSD(pBar, 0.25)
    if pBar.shadow then
        pBar.shadow:SetBackdropBorderColor(C.r, C.g, C.b, 0.25)
    end

    local pBarText = F.CreateFS(pBar, C.Assets.Fonts.Regular, 11, outline, '', nil, outline or 'THICK', 'CENTER', 0, 0)

    local lBtn = CreateFrame('Button', '', f, 'UIPanelButtonTemplate')
    lBtn:SetPoint('BOTTOM', -42, 10)
    lBtn:SetSize(80, 22)
    F.Reskin(lBtn)

    local rBtn = CreateFrame('Button', '', f, 'UIPanelButtonTemplate')
    rBtn:SetPoint('BOTTOM', 42, 10)
    rBtn:SetSize(80, 22)
    F.Reskin(rBtn)

    local step6 = function()
        pBar:SetValue(600)
        PlaySoundFile('Sound\\Spells\\LevelUp.wav')
        headerText:SetText(L['Congratulations'])
        bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_COMPLETED']))
        pBarText:SetText('6/6')
        lBtn:Hide()

        rBtn:ClearAllPoints()
        rBtn:SetPoint('BOTTOM', 0, 10)
        rBtn:SetText(L['Finish'])
        rBtn:SetScript('OnClick', function()
            C.DB.InstallationComplete = true
            _G.ReloadUI()
        end)
    end

    local step5 = function()
        pBar:SetValue(500)
        headerText:SetText(L['Other AddOns'])
        bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_ADDONS']))
        pBarText:SetText('5/6')

        lBtn:SetScript('OnClick', step6)
        rBtn:SetScript('OnClick', function()
            SetupAddons()
            step6()
        end)
    end

    local step4 = function()
        pBar:SetValue(400)
        headerText:SetText(L['Actionbars'])
        bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_ACTIONBARS']))
        pBarText:SetText('4/6')

        lBtn:SetScript('OnClick', step5)
        rBtn:SetScript('OnClick', function()
            SetupActionbars()
            step5()
        end)
    end

    local step3 = function()
        pBar:SetValue(300)
        headerText:SetText(L['Chatbox'])
        bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_CHATBOX']))
        pBarText:SetText('3/6')

        lBtn:SetScript('OnClick', step4)
        rBtn:SetScript('OnClick', function()
            SetupChatFrame()
            step4()
        end)
    end

    local step2 = function()
        pBar:SetValue(200)
        headerText:SetText(L['UI Scale'])
        bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_UISCALE']))
        pBarText:SetText('2/6')

        lBtn:SetScript('OnClick', step3)
        rBtn:SetScript('OnClick', function()
            UpdateUIScale()
            F.SetupUIScale(true)
            F.SetupUIScale()
            step3()
        end)
    end

    local step1 = function()
        pBar:SetMinMaxValues(0, 600)
        pBar:Show()
        pBar:SetValue(0)
        pBar:SetValue(100)
        pBar:SetStatusBarColor(C.r, C.g, C.b)
        headerText:SetText(L['CVars'])
        bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_CVARS']))
        pBarText:SetText('1/6')

        lBtn:Show()
        lBtn:SetText(L['Skip'])
        rBtn:SetText(L['Continue'])

        lBtn:SetScript('OnClick', step2)
        rBtn:SetScript('OnClick', function()
            SetupCVars()
            step2()
        end)
    end

    headerText:SetText(L['Hello there, adventurer!'])
    bodyText:SetText(GUI:FormatTextString(L['TUTORIAL_BODY_TEXT_WELCOME']))

    lBtn:SetText(L['Cancel'])
    rBtn:SetText(L['Install'])

    lBtn:SetScript('OnClick', function()
        f:Hide()
    end)
    rBtn:SetScript('OnClick', step1)
end

function TUTORIAL:OnLogin()
    if not C.DB.InstallationComplete then
        TUTORIAL:HelloWorld()
    end
end
