local F, C = unpack(select(2, ...))
local LSM = F.Libs.LSM

C.Assets = {}

C.Assets.Texture = {
    StatusbarNormal       = C.ASSET_PATH .. 'textures\\statusbar-normal',
    StatusbarGradient     = C.ASSET_PATH .. 'textures\\statusbar-gradient',
    StatusbarFlat         = C.ASSET_PATH .. 'textures\\statusbar-flat',
    StatusbarStripesThin  = C.ASSET_PATH .. 'textures\\statusbar-stripes-thin',
    StatusbarStripesThick = C.ASSET_PATH .. 'textures\\statusbar-stripes-thick',
    Tank                  = C.ASSET_PATH .. 'textures\\role-tank',
    Healer                = C.ASSET_PATH .. 'textures\\role-healer',
    Damager               = C.ASSET_PATH .. 'textures\\role-damager',
    LfgRole               = C.ASSET_PATH .. 'textures\\role-lfg-icons',
    Rare                  = C.ASSET_PATH .. 'textures\\nameplate-rare',
    Elite                 = C.ASSET_PATH .. 'textures\\nameplate-elite',
    Boss                  = C.ASSET_PATH .. 'textures\\nameplate-boss',
    Target                = C.ASSET_PATH .. 'textures\\nameplate-bracket',
    Mail                  = C.ASSET_PATH .. 'textures\\minimap-mail',
    MinimapMask           = C.ASSET_PATH .. 'textures\\minimap-rectangle-mask',
    Collector             = C.ASSET_PATH .. 'textures\\minimap-collector',
    Diff                  = C.ASSET_PATH .. 'textures\\minimap-difficulty',
    Shield                = C.ASSET_PATH .. 'textures\\combat-shield',
    Sword                 = C.ASSET_PATH .. 'textures\\combat-sword',
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
    Uninterruptible       = C.ASSET_PATH .. 'textures\\casting-shield',
    RaidTargetingIcon     = C.ASSET_PATH .. 'textures\\ui-raidtargeting-icons',
    ClassCircle           = C.ASSET_PATH .. 'textures\\ui-classes-icons',
    LogoSplash            = C.ASSET_PATH .. 'textures\\logo-splash',
    LogoChat              = C.ASSET_PATH .. 'textures\\logo-chat',

    StateIcon = C.ASSET_PATH .. 'textures\\state_icons',

    Vignetting = C.ASSET_PATH .. 'textures\\vignetting',






    MenuBarAchievement = C.ASSET_PATH .. 'textures\\menu\\menu-achievement',
    MenuBarBag         = C.ASSET_PATH .. 'textures\\menu\\menu-bag',
    MenuBarCalendar    = C.ASSET_PATH .. 'textures\\menu\\menu-calendar',
    MenuBarCollection  = C.ASSET_PATH .. 'textures\\menu\\menu-collection',
    MenuBarEncounter   = C.ASSET_PATH .. 'textures\\menu\\menu-encounter',
    MenuBarFriend      = C.ASSET_PATH .. 'textures\\menu\\menu-friend',
    MenuBarGuild       = C.ASSET_PATH .. 'textures\\menu\\menu-guild',
    MenuBarHelp        = C.ASSET_PATH .. 'textures\\menu\\menu-help',
    MenuBarLfg         = C.ASSET_PATH .. 'textures\\menu\\menu-lfg',
    MenuBarMap         = C.ASSET_PATH .. 'textures\\menu\\menu-map',
    MenuBarPlayer      = C.ASSET_PATH .. 'textures\\menu\\menu-player',
    MenuBarQuest       = C.ASSET_PATH .. 'textures\\menu\\menu-quest',
    MenuBarSpellbook   = C.ASSET_PATH .. 'textures\\menu\\menu-spellbook',
    MenuBarStore       = C.ASSET_PATH .. 'textures\\menu\\menu-store',
    MenuBarTalent      = C.ASSET_PATH .. 'textures\\menu\\menu-talent',
    BagRestore         = C.ASSET_PATH .. 'textures\\bag\\bag-restore',
    BagToggle          = C.ASSET_PATH .. 'textures\\bag\\bag-toggle',
    BagSort            = C.ASSET_PATH .. 'textures\\bag\\bag-sort',
    BagReagen          = C.ASSET_PATH .. 'textures\\bag\\bag-reagen',
    BagDeposit         = C.ASSET_PATH .. 'textures\\bag\\bag-deposit',
    BagDelete          = C.ASSET_PATH .. 'textures\\bag\\bag-delete',
    BagFavourite       = C.ASSET_PATH .. 'textures\\bag\\bag-favourite',
    BagSplit           = C.ASSET_PATH .. 'textures\\bag\\bag-split',
    BagRepair          = C.ASSET_PATH .. 'textures\\bag\\bag-repair',
    BagSell            = C.ASSET_PATH .. 'textures\\bag\\bag-sell',
    BagSearch          = C.ASSET_PATH .. 'textures\\bag\\bag-search',
    BagJunk            = C.ASSET_PATH .. 'textures\\bag\\bag-junk',
    ClientApp          = C.ASSET_PATH .. 'textures\\client\\client-app',
    ClientMobile       = C.ASSET_PATH .. 'textures\\client\\client-mobile',
    ClientWoWR         = C.ASSET_PATH .. 'textures\\client\\client-wow-retail',
    ClientWoWC         = C.ASSET_PATH .. 'textures\\client\\client-wow-classic',
    ClientWoWTBC       = C.ASSET_PATH .. 'textures\\client\\client-wow-tbc',
    ClientD2           = C.ASSET_PATH .. 'textures\\client\\client-d2',
    ClientD3           = C.ASSET_PATH .. 'textures\\client\\client-d3',
    ClientDI           = C.ASSET_PATH .. 'textures\\client\\client-immortal',
    ClientHS           = C.ASSET_PATH .. 'textures\\client\\client-hearthstone',
    ClientSC           = C.ASSET_PATH .. 'textures\\client\\client-starcraft',
    ClientSC2          = C.ASSET_PATH .. 'textures\\client\\client-starcraft2',
    ClientHotS         = C.ASSET_PATH .. 'textures\\client\\client-heroes',
    ClientOW           = C.ASSET_PATH .. 'textures\\client\\client-overwatch',
    ClientWC3          = C.ASSET_PATH .. 'textures\\client\\client-warcraft3',
    ClientCoD          = C.ASSET_PATH .. 'textures\\client\\client-cod',
    ClientCoDCW        = C.ASSET_PATH .. 'textures\\client\\client-cod-cw',
    ClientCoDMW        = C.ASSET_PATH .. 'textures\\client\\client-cod-mw',
    ClientCoDMW2       = C.ASSET_PATH .. 'textures\\client\\client-cod-mw2',
    ClientCoDVG        = C.ASSET_PATH .. 'textures\\client\\client-cod-vg',
    ClientArclight     = C.ASSET_PATH .. 'textures\\client\\client-arclight',
    ClientCrash4       = C.ASSET_PATH .. 'textures\\client\\client-crash4',
    ClientCLNT         = BNet_GetClientTexture(_G.BNET_CLIENT_CLNT),
    ClientArcade       = BNet_GetClientTexture(_G.BNET_CLIENT_ARCADE),
}


C.Assets.Button = {
    Normal = C.ASSET_PATH .. 'textures\\button\\normal',
    Flash = C.ASSET_PATH .. 'textures\\button\\flash',
    Pushed = C.ASSET_PATH .. 'textures\\button\\pushed',
    Checked = C.ASSET_PATH .. 'textures\\button\\checked',
    Highlight = C.ASSET_PATH .. 'textures\\button\\highlight',
}



C.Assets.Sound = {
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
}

C.Assets.Font = {
    Regular   = C.ASSET_PATH .. 'fonts\\regular.ttf',
    Bold      = C.ASSET_PATH .. 'fonts\\bold.ttf',
    Heavy     = C.ASSET_PATH .. 'fonts\\heavy.ttf',
    Condensed = C.ASSET_PATH .. 'fonts\\condensed.ttf',
    Combat    = C.ASSET_PATH .. 'fonts\\combat.ttf',
    Header    = C.ASSET_PATH .. 'fonts\\header.ttf',
    Pixel     = C.ASSET_PATH .. 'fonts\\pixel.ttf',
    Square    = C.ASSET_PATH .. 'fonts\\square.ttf',
    Roadway   = C.ASSET_PATH .. 'fonts\\roadway.ttf',
    Micro     = C.ASSET_PATH .. 'fonts\\micro.ttf',
}

-- Overwrite fonts

do
    local path = 'Fonts\\' .. C.ADDON_TITLE .. '\\'
    if C.IS_DEVELOPER then
        C.Assets.Font.Regular = path .. 'regular.ttf'
        C.Assets.Font.Condensed = path .. 'condensed.ttf'
        C.Assets.Font.Bold = path .. 'bold.ttf'
        C.Assets.Font.Heavy = path .. 'heavy.ttf'
        C.Assets.Font.Combat = path .. 'combat.ttf'
        C.Assets.Font.Header = path .. 'header.ttf'
    elseif GetLocale() == 'zhCN' then
        C.Assets.Font.Regular = 'Fonts\\ARKai_T.ttf'
        C.Assets.Font.Condensed = 'Fonts\\ARKai_T.ttf'
        C.Assets.Font.Bold = 'Fonts\\ARHei.ttf'
        C.Assets.Font.Heavy = 'Fonts\\ARHei.ttf'
        C.Assets.Font.Combat = 'Fonts\\ARHei.ttf'
        C.Assets.Font.Header = 'Fonts\\ARKai_C.ttf'
    elseif GetLocale() == 'zhTW' then
        C.Assets.Font.Regular = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Condensed = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Bold = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Heavy = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Combat = 'Fonts\\bKAI00M.ttf'
        C.Assets.Font.Header = 'Fonts\\blei00d.ttf'
    elseif GetLocale() == 'koKR' then
        C.Assets.Font.Regular = 'Fonts\\2002.ttf'
        C.Assets.Font.Condensed = 'Fonts\\2002.ttf'
        C.Assets.Font.Bold = 'Fonts\\2002B.ttf'
        C.Assets.Font.Heavy = 'Fonts\\2002B.ttf'
        C.Assets.Font.Combat = 'Fonts\\K_Damage.ttf'
        C.Assets.Font.Header = 'Fonts\\2002.ttf'
    elseif GetLocale() == 'ruRU' then
        C.Assets.Font.Regular = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Condensed = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Bold = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Heavy = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Combat = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Header = 'Fonts\\FRIZQT___CYR.ttf'
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

    local function registerSharedMedia()
        local prefix = format('%s: ', C.COLORFUL_ADDON_TITLE)

        for k, v in pairs(C.Assets.Font) do
            LSM:Register(LSM.MediaType.FONT, prefix .. k, v, LOCALE_MASK)
        end

        -- for k, v in pairs(C.Assets.Statusbar) do
        --     LSM:Register(LSM.MediaType.STATUSBAR, prefix .. k, v)
        -- end

        for k, v in pairs(C.Assets.Sound) do
            LSM:Register(LSM.MediaType.SOUND, prefix .. k, v)
        end
        F:UnregisterEvent('ADDON_LOADED', registerSharedMedia)
    end

    F:RegisterEvent('ADDON_LOADED', registerSharedMedia)
end
