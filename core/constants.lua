
local F, C = unpack(select(2, ...))


C.IsRetail = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE
C.IsNewPatch = C.IsRetail and select(4, GetBuildInfo()) >= 90200 -- 9.2.0
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
    ['norm_tex'] = C.AssetsPath .. 'textures\\norm_tex',
    ['grad_tex'] = C.AssetsPath .. 'textures\\grad_tex',
    ['flat_tex'] = C.AssetsPath .. 'textures\\flat_tex',
    ['statusbar_tex'] = C.AssetsPath .. 'textures\\norm_tex',
    ['bd_tex'] = 'Interface\\ChatFrame\\ChatFrameBackground',
    ['bg_tex'] = C.AssetsPath .. 'textures\\bg_tex',
    ['shadow_tex'] = C.AssetsPath .. 'textures\\shadow_tex',
    ['glow_tex'] = C.AssetsPath .. 'textures\\glow_tex',
    ['blank_tex'] = C.AssetsPath .. 'textures\\blank_tex',
    ['tick_tex'] = C.AssetsPath .. 'textures\\tick_tex',
    ['stripe_tex'] = C.AssetsPath .. 'textures\\stripe_tex',
    ['close_tex'] = C.AssetsPath .. 'textures\\close_tex',
    ['arrow_tex'] = C.AssetsPath .. 'textures\\arrow_tex',
    ['shield_tex'] = C.AssetsPath .. 'textures\\shield_tex',
    ['sword_tex'] = C.AssetsPath .. 'textures\\sword_tex',
    ['button_normal'] = C.AssetsPath .. 'button\\normal',
    ['button_flash'] = C.AssetsPath .. 'button\\flash',
    ['button_pushed'] = C.AssetsPath .. 'button\\pushed',
    ['button_checked'] = C.AssetsPath .. 'button\\checked',
    ['mask_tex'] = C.AssetsPath .. 'textures\\minimap_mask',
    ['diff_tex'] = C.AssetsPath .. 'textures\\minimap_diff',
    ['roles_icon'] = C.AssetsPath .. 'textures\\roles_icon',
    ['target_icon'] = C.AssetsPath .. 'textures\\UI-RaidTargetingIcons',
    ['vig_tex'] = C.AssetsPath .. 'textures\\vignetting',
    ['spark_tex'] = 'Interface\\CastingBar\\UI-CastingBar-Spark',
    ['gear_tex'] = C.AssetsPath .. 'textures\\gear_tex',
    ['classify_tex'] = C.AssetsPath .. 'textures\\state_icons',
    ['mail_tex'] = C.AssetsPath .. 'textures\\mail_tex',
    ['logo'] = C.AssetsPath .. 'textures\\logo_tex',
    ['mouse_left'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t ',
    ['mouse_right'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t ',
    ['mouse_middle'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t ',

    Textures = { -- #TODO
        Tank = C.AssetsPath .. 'textures\\roles_tank',
        Healer = C.AssetsPath .. 'textures\\roles_healer',
        Damager = C.AssetsPath .. 'textures\\roles_dps',
        Class = C.AssetsPath .. 'textures\\UI-CLASSES-CIRCLES',
        Leader = C.AssetsPath .. 'textures\\leader',
        Role = C.AssetsPath .. 'textures\\role',
        Shield = C.AssetsPath .. 'textures\\uninterrupted-shield',
        Norm = C.AssetsPath .. 'textures\\statusbar\\norm',
        Grad = C.AssetsPath .. 'textures\\statusbar\\grad',
        Flat = C.AssetsPath .. 'textures\\statusbar\\flat',



        Covenant = {
            Kyrian = C.AssetsPath .. 'textures\\covenants\\kyrian',
            Necrolord = C.AssetsPath .. 'textures\\covenants\\necrolord',
            NightFae = C.AssetsPath .. 'textures\\covenants\\nightfae',
            Venthyr = C.AssetsPath .. 'textures\\covenants\\venthyr',
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
        Header = C.AssetsPath .. 'fonts\\header.ttf',
        Combat = C.AssetsPath .. 'fonts\\combat.ttf',
        Pixel = C.AssetsPath .. 'fonts\\pixel.ttf',
        Square = C.AssetsPath .. 'fonts\\square.ttf',
        Roadway = C.AssetsPath .. 'fonts\\roadway.ttf',
    },
}

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
    C.AddonName = 'Free' .. C.MyColor ..'UI|r'
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
