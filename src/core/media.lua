local F, C = unpack(select(2, ...))
local LSM = F.Libs.LibSharedMedia

C.Assets = {
    Textures = {
        StatusbarNormal       = C.ASSET_PATH .. 'textures\\statusbar-normal',
        StatusbarGradient     = C.ASSET_PATH .. 'textures\\statusbar-gradient',
        StatusbarFlat         = C.ASSET_PATH .. 'textures\\statusbar-flat',
        StatusbarStripesThin  = C.ASSET_PATH .. 'textures\\statusbar-stripes-thin',
        StatusbarStripesThick = C.ASSET_PATH .. 'textures\\statusbar-stripes-thick',
        RoleTank              = C.ASSET_PATH .. 'textures\\role-tank',
        RoleHealer            = C.ASSET_PATH .. 'textures\\role-healer',
        RoleDamager           = C.ASSET_PATH .. 'textures\\role-damager',
        ClassifyRare          = C.ASSET_PATH .. 'textures\\nameplate-rare',
        ClassifyElite         = C.ASSET_PATH .. 'textures\\nameplate-elite',
        ClassifyBoss          = C.ASSET_PATH .. 'textures\\nameplate-boss',
        NameplateBracket      = C.ASSET_PATH .. 'textures\\nameplate-bracket',
        MinimapMail           = C.ASSET_PATH .. 'textures\\minimap-mail',
        MinimapMask           = C.ASSET_PATH .. 'textures\\minimap-rectangle-mask',
        MinimapTray           = C.ASSET_PATH .. 'textures\\minimap-tray',
        MinimapDifficulty     = C.ASSET_PATH .. 'textures\\minimap-difficulty',
        CombatShield          = C.ASSET_PATH .. 'textures\\combat-shield',
        CombatSword           = C.ASSET_PATH .. 'textures\\combat-sword',
        Gear                  = C.ASSET_PATH .. 'textures\\ui-gear',
        Close                 = C.ASSET_PATH .. 'textures\\ui-close',
        Arrow                 = C.ASSET_PATH .. 'textures\\ui-arrow-up',
        Tick                  = C.ASSET_PATH .. 'textures\\ui-checkbox-tick',
        Blank                 = C.ASSET_PATH .. 'textures\\ui-blank',
        Backdrop              = 'Interface\\ChatFrame\\ChatFrameBackground',
        Shadow                = C.ASSET_PATH .. 'textures\\ui-shadow-outline',
        Glow                  = C.ASSET_PATH .. 'textures\\ui-glow-up',
        BackdropStripes       = C.ASSET_PATH .. 'textures\\ui-backdrop-stripes',
        Spark                 = C.ASSET_PATH .. 'textures\\casting-spark',
        CastingShield         = C.ASSET_PATH .. 'textures\\casting-shield',
        RaidTargetingIcons    = C.ASSET_PATH .. 'textures\\ui-raidtargeting-icons',
        CircleClassIcons      = C.ASSET_PATH .. 'textures\\ui-classes-icons',
        LogoSplash            = C.ASSET_PATH .. 'textures\\logo\\logo-splash',
        LogoChat              = C.ASSET_PATH .. 'textures\\logo\\logo-chat',
        Vignetting            = C.ASSET_PATH .. 'textures\\vignetting',
        ButtonNormal          = C.ASSET_PATH .. 'textures\\button\\button-normal',
        ButtonFlash           = C.ASSET_PATH .. 'textures\\button\\button-flash',
        ButtonPushed          = C.ASSET_PATH .. 'textures\\button\\button-pushed',
        ButtonChecked         = C.ASSET_PATH .. 'textures\\button\\button-checked',
        ButtonHighlight       = C.ASSET_PATH .. 'textures\\button\\button-highlight',
        ButtonCircleHighlight = C.ASSET_PATH .. 'textures\\button\\button-circle-highlight',
        ButtonCircleBorder    = C.ASSET_PATH .. 'textures\\button\\button-circle-border',
        ButtonCircleMask      = C.ASSET_PATH .. 'textures\\button\\button-circle-mask',
        MenuBarAchievement    = C.ASSET_PATH .. 'textures\\menu\\menu-achievement',
        MenuBarBag            = C.ASSET_PATH .. 'textures\\menu\\menu-bag',
        MenuBarCalendar       = C.ASSET_PATH .. 'textures\\menu\\menu-calendar',
        MenuBarCollection     = C.ASSET_PATH .. 'textures\\menu\\menu-collection',
        MenuBarEncounter      = C.ASSET_PATH .. 'textures\\menu\\menu-encounter',
        MenuBarFriend         = C.ASSET_PATH .. 'textures\\menu\\menu-friend',
        MenuBarGuild          = C.ASSET_PATH .. 'textures\\menu\\menu-guild',
        MenuBarHelp           = C.ASSET_PATH .. 'textures\\menu\\menu-help',
        MenuBarLfg            = C.ASSET_PATH .. 'textures\\menu\\menu-lfg',
        MenuBarMap            = C.ASSET_PATH .. 'textures\\menu\\menu-map',
        MenuBarPlayer         = C.ASSET_PATH .. 'textures\\menu\\menu-player',
        MenuBarQuest          = C.ASSET_PATH .. 'textures\\menu\\menu-quest',
        MenuBarSpellbook      = C.ASSET_PATH .. 'textures\\menu\\menu-spellbook',
        MenuBarStore          = C.ASSET_PATH .. 'textures\\menu\\menu-store',
        MenuBarTalent         = C.ASSET_PATH .. 'textures\\menu\\menu-talent',
        BagRestore            = C.ASSET_PATH .. 'textures\\bag\\bag-restore',
        BagToggle             = C.ASSET_PATH .. 'textures\\bag\\bag-toggle',
        BagSort               = C.ASSET_PATH .. 'textures\\bag\\bag-sort',
        BagReagen             = C.ASSET_PATH .. 'textures\\bag\\bag-reagen',
        BagDeposit            = C.ASSET_PATH .. 'textures\\bag\\bag-deposit',
        BagDelete             = C.ASSET_PATH .. 'textures\\bag\\bag-delete',
        BagFavourite          = C.ASSET_PATH .. 'textures\\bag\\bag-favourite',
        BagSplit              = C.ASSET_PATH .. 'textures\\bag\\bag-split',
        BagRepair             = C.ASSET_PATH .. 'textures\\bag\\bag-repair',
        BagSell               = C.ASSET_PATH .. 'textures\\bag\\bag-sell',
        BagSearch             = C.ASSET_PATH .. 'textures\\bag\\bag-search',
        BagJunk               = C.ASSET_PATH .. 'textures\\bag\\bag-junk',
        ClientApp             = C.ASSET_PATH .. 'textures\\client\\client-app',
        ClientMobile          = C.ASSET_PATH .. 'textures\\client\\client-mobile',
        ClientWoWR            = C.ASSET_PATH .. 'textures\\client\\client-wow-retail',
        ClientWoWC            = C.ASSET_PATH .. 'textures\\client\\client-wow-classic',
        ClientWoWTBC          = C.ASSET_PATH .. 'textures\\client\\client-wow-tbc',
        ClientD2              = C.ASSET_PATH .. 'textures\\client\\client-d2',
        ClientD3              = C.ASSET_PATH .. 'textures\\client\\client-d3',
        ClientDI              = C.ASSET_PATH .. 'textures\\client\\client-immortal',
        ClientHS              = C.ASSET_PATH .. 'textures\\client\\client-hearthstone',
        ClientSC              = C.ASSET_PATH .. 'textures\\client\\client-starcraft',
        ClientSC2             = C.ASSET_PATH .. 'textures\\client\\client-starcraft2',
        ClientHotS            = C.ASSET_PATH .. 'textures\\client\\client-heroes',
        ClientOW              = C.ASSET_PATH .. 'textures\\client\\client-overwatch',
        ClientWC3             = C.ASSET_PATH .. 'textures\\client\\client-warcraft3',
        ClientCoD             = C.ASSET_PATH .. 'textures\\client\\client-cod',
        ClientCoDCW           = C.ASSET_PATH .. 'textures\\client\\client-cod-cw',
        ClientCoDMW           = C.ASSET_PATH .. 'textures\\client\\client-cod-mw',
        ClientCoDMW2          = C.ASSET_PATH .. 'textures\\client\\client-cod-mw2',
        ClientCoDVG           = C.ASSET_PATH .. 'textures\\client\\client-cod-vg',
        ClientArclight        = C.ASSET_PATH .. 'textures\\client\\client-arclight',
        ClientCrash4          = C.ASSET_PATH .. 'textures\\client\\client-crash4',
        --ClientCLNT            = BNet_GetClientTexture(_G.BNET_CLIENT_CLNT),
        --ClientArcade          = BNet_GetClientTexture(_G.BNET_CLIENT_ARCADE),
    },
    Sounds = {
        Intro            = C.ASSET_PATH .. 'sounds\\intro.ogg',
        Whisper          = C.ASSET_PATH .. 'sounds\\whisper.ogg',
        WhisperBattleNet = C.ASSET_PATH .. 'sounds\\whisper-bn.ogg',
        Notification     = C.ASSET_PATH .. 'sounds\\notification.ogg',
        LowHealth        = C.ASSET_PATH .. 'sounds\\lowhealth.ogg',
        LowMana          = C.ASSET_PATH .. 'sounds\\lowmana.ogg',
        Interrupt        = C.ASSET_PATH .. 'sounds\\interrupt.ogg',
        Dispel           = C.ASSET_PATH .. 'sounds\\dispel.ogg',
        Missed           = C.ASSET_PATH .. 'sounds\\missed.ogg',
        Proc             = C.ASSET_PATH .. 'sounds\\proc.ogg',
        Exec             = C.ASSET_PATH .. 'sounds\\exec.ogg',
        Pulse            = C.ASSET_PATH .. 'sounds\\pulse.ogg',
        Ding             = C.ASSET_PATH .. 'sounds\\ding.ogg',
        Dang             = C.ASSET_PATH .. 'sounds\\dang.ogg',
        Laser            = C.ASSET_PATH .. 'sounds\\laser.mp3',
        AnimeMoan        = C.ASSET_PATH .. 'sounds\\animemoan.ogg',
        PhubIntro        = C.ASSET_PATH .. 'sounds\\phub-intro.ogg',
        SekiroLowHealth  = C.ASSET_PATH .. 'sounds\\sekiro-lowhealth.ogg',
    },
    Fonts = {
        Regular    = C.ASSET_PATH .. 'fonts\\firasans-regular.ttf',
        Bold       = C.ASSET_PATH .. 'fonts\\firasans-bold.ttf',
        Heavy      = C.ASSET_PATH .. 'fonts\\firasans-heavy.ttf',
        Condensed  = C.ASSET_PATH .. 'fonts\\firasans-condensed.ttf',
        Combat     = C.ASSET_PATH .. 'fonts\\carter-one.ttf',
        Header     = C.ASSET_PATH .. 'fonts\\suez-one.ttf',
        Pixel      = C.ASSET_PATH .. 'fonts\\tempesta-seven.ttf',
        HalfHeight = C.ASSET_PATH .. 'fonts\\roadway.ttf',
        Small      = C.ASSET_PATH .. 'fonts\\super-effective.ttf',
    },
}

-- Overwrite fonts
-- Force Simplified Chinese, Traditional Chinese and Korean clients to use native fonts
-- Because andromeda's built-in fonts do not include characters from the above languages
do
    if C.IS_DEVELOPER then
        local path = 'Fonts\\' .. C.ADDON_TITLE .. '\\'
        C.Assets.Fonts.Regular = path .. 'regular.ttf'
        C.Assets.Fonts.Condensed = path .. 'condensed.ttf'
        C.Assets.Fonts.Bold = path .. 'bold.ttf'
        C.Assets.Fonts.Heavy = path .. 'heavy.ttf'
        C.Assets.Fonts.Combat = path .. 'combat.ttf'
        C.Assets.Fonts.Header = path .. 'header.ttf'
    elseif GetLocale() == 'zhCN' then
        C.Assets.Fonts.Regular = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\ARHei.ttf'
        C.Assets.Fonts.Heavy = 'Fonts\\ARHei.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\ARHei.ttf'
        C.Assets.Fonts.Header = 'Fonts\\ARKai_C.ttf'
    elseif GetLocale() == 'zhTW' then
        C.Assets.Fonts.Regular = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Heavy = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\bKAI00M.ttf'
        C.Assets.Fonts.Header = 'Fonts\\blei00d.ttf'
    elseif GetLocale() == 'koKR' then
        C.Assets.Fonts.Regular = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\2002B.ttf'
        C.Assets.Fonts.Heavy = 'Fonts\\2002B.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\K_Damage.ttf'
        C.Assets.Fonts.Header = 'Fonts\\2002.ttf'
    end
end

-- Register media assets to LibSharedMedia

do
    local LOCALE_MASK
    if GetLocale() == 'koKR' then
        LOCALE_MASK = 1
    elseif GetLocale() == 'ruRU' then
        LOCALE_MASK = 2
    elseif GetLocale() == 'zhCN' then
        LOCALE_MASK = 4
    elseif GetLocale() == 'zhTW' then
        LOCALE_MASK = 8
    else
        LOCALE_MASK = 128
    end

    local function addMedia(mediaType, name, file, mask)
        local typeKey
        if mediaType == 'font' then
            typeKey = LSM.MediaType.FONT
        elseif mediaType == 'sound' then
            typeKey = LSM.MediaType.SOUND
        elseif mediaType == 'statusbar' then
            typeKey = LSM.MediaType.STATUSBAR
        elseif mediaType == 'border' then
            typeKey = LSM.MediaType.BORDER
        elseif mediaType == 'background' then
            typeKey = LSM.MediaType.BACKGROUND
        end

        local prefix = '|cffe083f1A:|r '
        local str1 = file:gsub('^.*\\', '')
        local str2 = str1:gsub('%.%w-$', '')
        local newName = (name == true and str2) or name

        LSM:Register(typeKey, prefix .. newName, file, mask)
    end

    local function registerToSharedMedia()
        for _, v in pairs(C.Assets.Fonts) do
            addMedia('font', true, v, LOCALE_MASK)
        end

        for _, v in pairs(C.Assets.Sounds) do
            addMedia('sound', true, v)
        end

        addMedia('statusbar', true, C.Assets.Textures.StatusbarNormal)
        addMedia('statusbar', true, C.Assets.Textures.StatusbarGradient)
        addMedia('statusbar', true, C.Assets.Textures.StatusbarFlat)

        F:UnregisterEvent('ADDON_LOADED', registerToSharedMedia)
    end

    F:RegisterEvent('ADDON_LOADED', registerToSharedMedia)
end

-- Preload LSM fonts

do
    local preloader = CreateFrame('Frame')
    preloader:SetPoint('TOP', _G.UIParent, 'BOTTOM', 0, -500)
    preloader:SetSize(100, 100)

    local cacheFont = function(key, data)
        local loadFont = preloader:CreateFontString()
        loadFont:SetAllPoints()

        if pcall(loadFont.SetFont, loadFont, data, 14) then
            pcall(loadFont.SetText, loadFont, 'cache')
        end
    end

    -- Lets load all the fonts in LSM to prevent fonts not being ready
    local sharedFonts = LSM:HashTable('font')
    for key, data in next, sharedFonts do
        cacheFont(key, data)
    end

    -- Now lets hook it so we can preload any other AddOns add to LSM
    hooksecurefunc(LSM, 'Register', function(_, mediaType, key, data)
        if not mediaType or type(mediaType) ~= 'string' then
            return
        end

        local mtype = mediaType:lower()
        if mtype == 'font' then
            cacheFont(key, data)
        end
    end)
end
