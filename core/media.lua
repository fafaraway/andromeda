local F, C = unpack(select(2, ...))
local LSM = F.Libs.LSM

C.Assets = {}

C.Assets.Texture = {
    Tank = C.ASSET_PATH .. 'textures\\roles\\tank',
    Healer = C.ASSET_PATH .. 'textures\\roles\\healer',
    Damager = C.ASSET_PATH .. 'textures\\roles\\damager',
    ClassCircle = C.ASSET_PATH .. 'textures\\UI-CLASSES-CIRCLES',
    LfgRole = C.ASSET_PATH .. 'textures\\UI-LFG-ICON-ROLES',
    StateIcon = C.ASSET_PATH .. 'textures\\state_icons',
    Logo = C.ASSET_PATH .. 'textures\\logo_tex',
    Mail = C.ASSET_PATH .. 'textures\\mail_tex',
    MinimapMask = C.ASSET_PATH .. 'textures\\minimap_mask',
    RaidTargetingIcon = C.ASSET_PATH .. 'textures\\UI-RaidTargetingIcons',
    Vignetting = C.ASSET_PATH .. 'textures\\vignetting',
    Spark = 'Interface\\CastingBar\\UI-CastingBar-Spark',
    Uninterruptible = C.ASSET_PATH .. 'textures\\uninterrupted-shield',
    Gear = C.ASSET_PATH .. 'textures\\gear_tex',
    Close = C.ASSET_PATH .. 'textures\\close_tex',
    Arrow = C.ASSET_PATH .. 'textures\\arrow_tex',
    Tick = C.ASSET_PATH .. 'textures\\tick_tex',
    Blank = C.ASSET_PATH .. 'textures\\blank',
    Shield = C.ASSET_PATH .. 'textures\\shield_tex',
    Sword = C.ASSET_PATH .. 'textures\\sword_tex',
    Backdrop = 'Interface\\ChatFrame\\ChatFrameBackground',
    Shadow = C.ASSET_PATH .. 'textures\\shadow_tex',
    Glow = C.ASSET_PATH .. 'textures\\glow_tex',
}

C.Assets.Statusbar = {
    Normal = C.ASSET_PATH .. 'textures\\statusbar\\norm',
    Gradient = C.ASSET_PATH .. 'textures\\statusbar\\grad',
    Flat = C.ASSET_PATH .. 'textures\\statusbar\\flat',
    Stripe = C.ASSET_PATH .. 'textures\\statusbar\\stripe',
    Overlay = C.ASSET_PATH .. 'textures\\statusbar\\overlay',
}

C.Assets.Button = {
    Normal = C.ASSET_PATH .. 'textures\\button\\normal',
    Flash = C.ASSET_PATH .. 'textures\\button\\flash',
    Pushed = C.ASSET_PATH .. 'textures\\button\\pushed',
    Checked = C.ASSET_PATH .. 'textures\\button\\checked',
    Highlight = C.ASSET_PATH .. 'textures\\button\\highlight',
}

C.Assets.Inventory = {
    Restore = C.ASSET_PATH .. 'textures\\inventory\\restore',
    Toggle = C.ASSET_PATH .. 'textures\\inventory\\toggle',
    Sort = C.ASSET_PATH .. 'textures\\inventory\\sort',
    Reagen = C.ASSET_PATH .. 'textures\\inventory\\reagen',
    Deposit = C.ASSET_PATH .. 'textures\\inventory\\deposit',
    Delete = C.ASSET_PATH .. 'textures\\inventory\\delete',
    Favourite = C.ASSET_PATH .. 'textures\\inventory\\favourite',
    Split = C.ASSET_PATH .. 'textures\\inventory\\split',
    Repair = C.ASSET_PATH .. 'textures\\inventory\\repair',
    Sell = C.ASSET_PATH .. 'textures\\inventory\\sell',
    Search = C.ASSET_PATH .. 'textures\\inventory\\search',
    Junk = C.ASSET_PATH .. 'textures\\inventory\\junk',
}

C.Assets.Sound = {
    Intro = C.ASSET_PATH .. 'sounds\\intro.ogg',
    Whisper = C.ASSET_PATH .. 'sounds\\whisper_normal.ogg',
    WhisperBattleNet = C.ASSET_PATH .. 'sounds\\whisper_battlenet.ogg',
    Notification = C.ASSET_PATH .. 'sounds\\notification.ogg',
    LowHealth = C.ASSET_PATH .. 'sounds\\lowhealth.ogg',
    LowMana = C.ASSET_PATH .. 'sounds\\lowmana.ogg',
    Interrupt = C.ASSET_PATH .. 'sounds\\interrupt.ogg',
    Dispel = C.ASSET_PATH .. 'sounds\\dispel.ogg',
    Missed = C.ASSET_PATH .. 'sounds\\missed.ogg',
    Proc = C.ASSET_PATH .. 'sounds\\proc.ogg',
    Exec = C.ASSET_PATH .. 'sounds\\exec.ogg',
    Pulse = C.ASSET_PATH .. 'sounds\\pulse.ogg',
    Error = C.ASSET_PATH .. 'sounds\\error.ogg',
    Warning = C.ASSET_PATH .. 'sounds\\warning.ogg',
    ForTheHorde = C.ASSET_PATH .. 'sounds\\forthehorde.ogg',
    Mario = C.ASSET_PATH .. 'sounds\\mario.ogg',
    Alarm = C.ASSET_PATH .. 'sounds\\alarm.ogg',
    Ding = C.ASSET_PATH .. 'sounds\\ding.ogg',
    Dang = C.ASSET_PATH .. 'sounds\\dang.ogg',
    Laser = C.ASSET_PATH .. 'sounds\\laser.mp3',
    Moan = C.ASSET_PATH .. 'sounds\\animemoan.ogg',
    Fatality = C.ASSET_PATH .. 'sounds\\fatality.ogg',
    Fuck = C.ASSET_PATH .. 'sounds\\fuck.ogg',
    GasGasGas = C.ASSET_PATH .. 'sounds\\gasgasgas.ogg',
    Omaewamou = C.ASSET_PATH .. 'sounds\\omaewamou.ogg',
    PacmanDeath = C.ASSET_PATH .. 'sounds\\pacman-death.ogg',
    PacmanWakawaka = C.ASSET_PATH .. 'sounds\\pacman-wakawaka.ogg',
    PhubIntro = C.ASSET_PATH .. 'sounds\\phub-intro.ogg',
    SonicDeath = C.ASSET_PATH .. 'sounds\\sonic-death.ogg',
    SekiroLowHealth = C.ASSET_PATH .. 'sounds\\sekiro-lowhealth.mp3',
}

C.Assets.Font = {
    Regular = C.ASSET_PATH .. 'fonts\\regular.ttf',
    Condensed = C.ASSET_PATH .. 'fonts\\condensed.ttf',
    Bold = C.ASSET_PATH .. 'fonts\\bold.ttf',
    Combat = C.ASSET_PATH .. 'fonts\\combat.ttf',
    Header = C.ASSET_PATH .. 'fonts\\header.ttf',
    Pixel = C.ASSET_PATH .. 'fonts\\pixel.ttf',
    Square = C.ASSET_PATH .. 'fonts\\square.ttf',
    Roadway = C.ASSET_PATH .. 'fonts\\roadway.ttf',
}

-- Overwrite fonts

do
    if C.IsDeveloper then
        C.Assets.Font.Regular = 'Fonts\\FreeUI\\regular.ttf'
        C.Assets.Font.Condensed = 'Fonts\\FreeUI\\condensed.ttf'
        C.Assets.Font.Bold = 'Fonts\\FreeUI\\bold.ttf'
        C.Assets.Font.Combat = 'Fonts\\FreeUI\\combat.ttf'
        C.Assets.Font.Header = 'Fonts\\FreeUI\\header.ttf'
    elseif GetLocale() == 'zhCN' then
        C.Assets.Font.Regular = 'Fonts\\ARKai_T.ttf'
        C.Assets.Font.Condensed = 'Fonts\\ARKai_T.ttf'
        C.Assets.Font.Bold = 'Fonts\\ARHei.ttf'
        C.Assets.Font.Combat = 'Fonts\\ARHei.ttf'
        C.Assets.Font.Header = 'Fonts\\ARKai_T.ttf'
    elseif GetLocale() == 'zhTW' then
        C.Assets.Font.Regular = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Condensed = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Bold = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Combat = 'Fonts\\blei00d.ttf'
        C.Assets.Font.Header = 'Fonts\\blei00d.ttf'
    elseif GetLocale() == 'koKR' then
        C.Assets.Font.Regular = 'Fonts\\2002.ttf'
        C.Assets.Font.Condensed = 'Fonts\\2002.ttf'
        C.Assets.Font.Bold = 'Fonts\\2002B.ttf'
        C.Assets.Font.Combat = 'Fonts\\2002B.ttf'
        C.Assets.Font.Header = 'Fonts\\2002.ttf'
    elseif GetLocale() == 'ruRU' then
        C.Assets.Font.Regular = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Condensed = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Font.Bold = 'Fonts\\FRIZQT___CYR.ttf'
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

    function F:RegisterSharedMedia(type, name)
        if type == 'font' then
            LSM:Register(LSM.MediaType.FONT, '|cffa763eaFreeUI: ' .. name .. '|r', C.Assets.Font[name], LOCALE_MASK)
        elseif type == 'statusbar' then
            LSM:Register(LSM.MediaType.STATUSBAR, '|cffa763eaFreeUI: ' .. name .. '|r', C.Assets.Statusbar[name])
        elseif type == 'sound' then
            LSM:Register(LSM.MediaType.SOUND, '|cffa763eaFreeUI: ' .. name .. '|r', C.Assets.Sound[name])
        end
    end

    local function registerSharedMedia()
        for k, _ in pairs(C.Assets.Font) do
            F:RegisterSharedMedia('font', k)
        end

        for k, _ in pairs(C.Assets.Statusbar) do
            F:RegisterSharedMedia('statusbar', k)
        end

        for k, _ in pairs(C.Assets.Sound) do
            F:RegisterSharedMedia('sound', k)
        end

        F:UnregisterEvent('ADDON_LOADED', registerSharedMedia)
    end

    F:RegisterEvent('ADDON_LOADED', registerSharedMedia)
end
