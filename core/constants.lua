
local F, C = unpack(select(2, ...))

C.AddonName = 'FreeUI'
C.IsRetail = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE
C.IsNewPatch = C.IsRetail and select(4, GetBuildInfo()) >= 90205 -- 9.2.5
C.MaxLevel = GetMaxLevelForPlayerExpansion()
C.MyClass = select(2, UnitClass('player'))
C.MyName = UnitName('player')
C.MyLevel = UnitLevel('player')
C.MyFaction = select(2, UnitFactionGroup('player'))
C.MyGUID = UnitGUID('player')
C.MyRace = select(2, UnitRace('player'))
C.MyRealm = GetRealmName()
C.MyFullName = C.MyName .. '-' .. C.MyRealm

local playerGUID = UnitGUID('player')
local _, serverID = string.split('-', playerGUID)
C.ServerID = tonumber(serverID)
C.MyGuid = playerGUID

C.ScreenWidth, C.ScreenHeight = GetPhysicalScreenSize()
C.IsLowRes =C.ScreenHeight < 1080
C.IsMedRes = C.ScreenHeight > 1080 and C.ScreenHeight < 1440
C.IsHighRes = C.ScreenHeight > 1440

C.AssetsPath = 'Interface\\AddOns\\FreeUI\\assets\\'
C.TexCoord = {.08, .92, .08, .92}
C.UIGap = 33


C.Assets = {
    Textures = { -- #TODO
        RoleTank = C.AssetsPath .. 'textures\\roles\\tank',
        RoleHealer = C.AssetsPath .. 'textures\\roles\\healer',
        RoleDamager = C.AssetsPath .. 'textures\\roles\\damager',
        ClassesCircles = C.AssetsPath .. 'textures\\UI-CLASSES-CIRCLES',
        LfgRoles = C.AssetsPath .. 'textures\\UI-LFG-ICON-ROLES',
        StateIcons = C.AssetsPath .. 'textures\\state_icons',
        UILogo = C.AssetsPath .. 'textures\\logo_tex',
        MinimapMail = C.AssetsPath .. 'textures\\mail_tex',
        MinimapMask = C.AssetsPath .. 'textures\\minimap_mask',
        RaidTargetIcons = C.AssetsPath .. 'textures\\UI-RaidTargetingIcons',
        Vignetting = C.AssetsPath .. 'textures\\vignetting',
        CastingSpark = 'Interface\\CastingBar\\UI-CastingBar-Spark',
        CastingShield = C.AssetsPath .. 'textures\\uninterrupted-shield',
        Gear = C.AssetsPath .. 'textures\\gear_tex',
        Close = C.AssetsPath .. 'textures\\close_tex',
        Arrow = C.AssetsPath .. 'textures\\arrow_tex',
        Tick = C.AssetsPath .. 'textures\\tick_tex',

        CombatShield = C.AssetsPath .. 'textures\\shield_tex',
        CombatSword = C.AssetsPath .. 'textures\\sword_tex',

        Backdrop = 'Interface\\ChatFrame\\ChatFrameBackground',
        Shadow = C.AssetsPath .. 'textures\\shadow_tex',
        Glow = C.AssetsPath .. 'textures\\glow_tex',

        SBNormal = C.AssetsPath .. 'textures\\statusbar\\norm',
        SBGradient = C.AssetsPath .. 'textures\\statusbar\\grad',
        SBFlat = C.AssetsPath .. 'textures\\statusbar\\flat',
        SBStripe = C.AssetsPath .. 'textures\\statusbar\\stripe',
        SBOverlay = C.AssetsPath .. 'textures\\statusbar\\overlay',

        MouseLeftBtn = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t ',
        MouseRightBtn = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t ',
        MouseMiddleBtn = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t ',

        Button = {
            Normal = C.AssetsPath .. 'textures\\button\\normal',
            Flash = C.AssetsPath .. 'textures\\button\\flash',
            Pushed = C.AssetsPath .. 'textures\\button\\pushed',
            Checked = C.AssetsPath .. 'textures\\button\\checked',
        },

        Inventory = {
            Restore = C.AssetsPath .. 'textures\\inventory\\restore',
            Toggle = C.AssetsPath .. 'textures\\inventory\\toggle',
            Sort = C.AssetsPath .. 'textures\\inventory\\sort',
            Reagen = C.AssetsPath .. 'textures\\inventory\\reagen',
            Deposit = C.AssetsPath .. 'textures\\inventory\\deposit',
            Delete = C.AssetsPath .. 'textures\\inventory\\delete',
            Favourite = C.AssetsPath .. 'textures\\inventory\\favourite',
            Split = C.AssetsPath .. 'textures\\inventory\\split',
            Repair = C.AssetsPath .. 'textures\\inventory\\repair',
            Sell = C.AssetsPath .. 'textures\\inventory\\sell',
            Search = C.AssetsPath .. 'textures\\inventory\\search',
            Junk = C.AssetsPath .. 'textures\\inventory\\junk'
        },

    },

    Sounds = {
        Intro = C.AssetsPath .. 'sounds\\intro.ogg',
        Whisper = C.AssetsPath .. 'sounds\\whisper_normal.ogg',
        WhisperBattleNet = C.AssetsPath .. 'sounds\\whisper_battlenet.ogg',
        Notification = C.AssetsPath .. 'sounds\\notification.ogg',
        LowHealth = C.AssetsPath .. 'sounds\\lowhealth.ogg',
        LowMana = C.AssetsPath .. 'sounds\\lowmana.ogg',
        Interrupt = C.AssetsPath .. 'sounds\\interrupt.ogg',
        Dispel = C.AssetsPath .. 'sounds\\dispel.ogg',
        Missed = C.AssetsPath .. 'sounds\\missed.ogg',
        Proc = C.AssetsPath .. 'sounds\\proc.ogg',
        Exec = C.AssetsPath .. 'sounds\\exec.ogg',
        Pulse = C.AssetsPath .. 'sounds\\pulse.ogg',
        Error = C.AssetsPath .. 'sounds\\error.ogg',
        Warning = C.AssetsPath .. 'sounds\\warning.ogg',
        ForTheHorde = C.AssetsPath .. 'sounds\\forthehorde.ogg',
        Mario = C.AssetsPath .. 'sounds\\mario.ogg',
        Alarm = C.AssetsPath .. 'sounds\\alarm.ogg',
        Ding = C.AssetsPath .. 'sounds\\ding.ogg',
        Dang = C.AssetsPath .. 'sounds\\dang.ogg',
    },

    Fonts = {
        Regular = C.AssetsPath .. 'fonts\\regular.ttf',
        Condensed = C.AssetsPath .. 'fonts\\condensed.ttf',
        Bold = C.AssetsPath .. 'fonts\\bold.ttf',
        Combat = C.AssetsPath .. 'fonts\\combat.ttf',
        Header = C.AssetsPath .. 'fonts\\header.ttf',
        Pixel = C.AssetsPath .. 'fonts\\pixel.ttf',
        Square = C.AssetsPath .. 'fonts\\square.ttf',
        Roadway = C.AssetsPath .. 'fonts\\roadway.ttf',
    },
}

do
    if C.IsDeveloper then
        C.Assets.Fonts.Regular = 'Fonts\\FreeUI\\regular.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\FreeUI\\condensed.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\FreeUI\\bold.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\FreeUI\\combat.ttf'
        C.Assets.Fonts.Header = 'Fonts\\FreeUI\\header.ttf'
    elseif GetLocale() == 'zhCN' then
        C.Assets.Fonts.Regular = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\ARHei.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\ARHei.ttf'
        C.Assets.Fonts.Header = 'Fonts\\ARKai_T.ttf'
    elseif GetLocale() == 'zhTW' then
        C.Assets.Fonts.Regular = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Header = 'Fonts\\blei00d.ttf'
    elseif GetLocale() == 'koKR' then
        C.Assets.Fonts.Regular = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\2002B.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\2002B.ttf'
        C.Assets.Fonts.Header = 'Fonts\\2002.ttf'
    elseif GetLocale() == 'ruRU' then
        C.Assets.Fonts.Regular = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Header = 'Fonts\\FRIZQT___CYR.ttf'
    end
end

C.ClassList = {}
for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
    C.ClassList[v] = k
end

C.ClassColors = {}
function F.UpdateCustomClassColors()
    local colors = _G.FREE_ADB.UseCustomClassColor and _G.FREE_ADB.CustomClassColors or _G.RAID_CLASS_COLORS
    for class, value in pairs(colors) do
        C.ClassColors[class] = {}
        C.ClassColors[class].r = value.r
        C.ClassColors[class].g = value.g
        C.ClassColors[class].b = value.b
        C.ClassColors[class].colorStr = value.colorStr
    end

    C.r = C.ClassColors[C.MyClass].r
    C.g = C.ClassColors[C.MyClass].g
    C.b = C.ClassColors[C.MyClass].b

    C.MyColor = string.format('|cff%02x%02x%02x', C.r * 255, C.g * 255, C.b * 255)
    C.ColoredAddonName = F:TextGradient(C.AddonName, C.r, C.g, C.b, 1, 1, 1, 1)
end
F:RegisterEvent('ADDON_LOADED', F.UpdateCustomClassColors)

C.InfoColor = '|cffe9c55d' -- .9, .8, .4
C.YellowColor = '|cffffff00'
C.GreyColor = '|cff7f7f7f'
C.WhiteColor = '|cffffffff'
C.RedColor = '|cffff2020'
C.GreenColor = '|cff20ff20'
C.BlueColor = '|cff82c5ff' -- .5, .8, 1
C.OrangeColor = '|cffff7f3f' -- 1, .5, .3
C.PurpleColor = '|cffa571df'
C.LineString = C.GreyColor .. '---------------'

-- Deprecated
_G.LE_ITEM_QUALITY_POOR = _G.Enum.ItemQuality.Poor
_G.LE_ITEM_QUALITY_COMMON = _G.Enum.ItemQuality.Common
_G.LE_ITEM_QUALITY_UNCOMMON = _G.Enum.ItemQuality.Uncommon
_G.LE_ITEM_QUALITY_RARE = _G.Enum.ItemQuality.Rare
_G.LE_ITEM_QUALITY_EPIC = _G.Enum.ItemQuality.Epic
_G.LE_ITEM_QUALITY_LEGENDARY = _G.Enum.ItemQuality.Legendary
_G.LE_ITEM_QUALITY_ARTIFACT = _G.Enum.ItemQuality.Artifact
_G.LE_ITEM_QUALITY_HEIRLOOM = _G.Enum.ItemQuality.Heirloom

C.QualityColors = {}
local qualityColors = _G.BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
    C.QualityColors[index] = {r = value.r, g = value.g, b = value.b}
end
C.QualityColors[-1] = {r = 0, g = 0, b = 0}
C.QualityColors[_G.LE_ITEM_QUALITY_POOR] = {r = .61, g = .61, b = .61}
C.QualityColors[_G.LE_ITEM_QUALITY_COMMON] = {r = 0, g = 0, b = 0}
C.QualityColors[99] = {r = 1, g = 0, b = 0}

_G.GOLD_AMOUNT_SYMBOL = string.format('|cffffd700%s|r', _G.GOLD_AMOUNT_SYMBOL)
_G.SILVER_AMOUNT_SYMBOL = string.format('|cffd0d0d0%s|r', _G.SILVER_AMOUNT_SYMBOL)
_G.COPPER_AMOUNT_SYMBOL = string.format('|cffc77050%s|r', _G.COPPER_AMOUNT_SYMBOL)
_G.COPPER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t'
_G.SILVER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t'
_G.GOLD_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t'

-- Update my role
local function CheckMyRole()
    local tree = GetSpecialization()
    if not tree then
        return
    end
    local _, _, _, _, role, primaryStat = GetSpecializationInfo(tree)
    if role == 'TANK' then
        C.MyRole = 'Tank'
    elseif role == 'HEALER' then
        C.MyRole = 'Healer'
    elseif role == 'DAMAGER' then
        if primaryStat == 4 then -- 1 - Strength, 2 - Agility, 4 - Intellect
            C.MyRole = 'Caster'
        else
            C.MyRole = 'Melee'
        end
    end
end
F:RegisterEvent('ADDON_LOADED', CheckMyRole)
F:RegisterEvent('PLAYER_TALENT_UPDATE', CheckMyRole)

-- Flags
function C:IsMyPet(flags)
    return _G.bit.band(flags, _G.COMBATLOG_OBJECT_AFFILIATION_MINE) > 0
end
C.PartyPetFlags = _G.bit.bor(_G.COMBATLOG_OBJECT_AFFILIATION_PARTY, _G.COMBATLOG_OBJECT_REACTION_FRIENDLY, _G.COMBATLOG_OBJECT_CONTROL_PLAYER, _G.COMBATLOG_OBJECT_TYPE_PET)
C.RaidPetFlags = _G.bit.bor(_G.COMBATLOG_OBJECT_AFFILIATION_RAID, _G.COMBATLOG_OBJECT_REACTION_FRIENDLY, _G.COMBATLOG_OBJECT_CONTROL_PLAYER, _G.COMBATLOG_OBJECT_TYPE_PET)

function C:IsInMyGroup(flags)
    local inParty = IsInGroup() and _G.bit.band(flags, _G.COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0
    local inRaid = IsInRaid() and _G.bit.band(flags, _G.COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0

    return inRaid or inParty
end

