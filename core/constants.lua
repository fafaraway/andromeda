local F, C = unpack(select(2, ...))

C.ADDON_NAME = 'FreeUI'
C.NEW_PATCH = select(4, GetBuildInfo()) >= 90205 -- 9.2.5

C.REALM = GetRealmName()
C.CLASS = select(2, UnitClass('player'))
C.NAME = UnitName('player')
C.FULL_NAME = C.NAME .. '-' .. C.REALM
C.FACTION = select(2, UnitFactionGroup('player'))

C.SCREEN_WIDTH, C.SCREEN_HEIGHT = GetPhysicalScreenSize()
C.ASSET_PATH = 'Interface\\AddOns\\FreeUI\\assets\\'
C.TEX_COORD = { 0.08, 0.92, 0.08, 0.92 }
C.UI_GAP = 33

C.MOUSE_LEFT_BUTTON = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t '
C.MOUSE_RIGHT_BUTTON = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t '
C.MOUSE_MIDDLE_BUTTON = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t '
C.LINE_STRING = '|cff7f7f7f---------------|r'

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
    end

    C.r = C.ClassColors[C.CLASS].r
    C.g = C.ClassColors[C.CLASS].g
    C.b = C.ClassColors[C.CLASS].b

    C.CLASS_COLOR = string.format('|cff%02x%02x%02x', C.r * 255, C.g * 255, C.b * 255)
    C.COLORED_ADDON_NAME = F:TextGradient(C.ADDON_NAME, C.r, C.g, C.b, 1, 1, 1, 1)
end
F:RegisterEvent('ADDON_LOADED', F.UpdateCustomClassColors)

C.INFO_COLOR = '|cffe9c55d' -- .9, .8, .4
C.YELLOW_COLOR = '|cffffff00'
C.GREY_COLOR = '|cff7f7f7f'
C.WHITE_COLOR = '|cffffffff'
C.RED_COLOR = '|cffff2020'
C.GREEN_COLOR = '|cff20ff20'
C.BLUE_COLOR = '|cff82c5ff' -- .5, .8, 1

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
    C.QualityColors[index] = { r = value.r, g = value.g, b = value.b }
end
C.QualityColors[-1] = { r = 0, g = 0, b = 0 }
C.QualityColors[_G.LE_ITEM_QUALITY_POOR] = { r = 0.61, g = 0.61, b = 0.61 }
C.QualityColors[_G.LE_ITEM_QUALITY_COMMON] = { r = 0, g = 0, b = 0 }
C.QualityColors[99] = { r = 1, g = 0, b = 0 }

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
C.PartyPetFlags = _G.bit.bor(
    _G.COMBATLOG_OBJECT_AFFILIATION_PARTY,
    _G.COMBATLOG_OBJECT_REACTION_FRIENDLY,
    _G.COMBATLOG_OBJECT_CONTROL_PLAYER,
    _G.COMBATLOG_OBJECT_TYPE_PET
)
C.RaidPetFlags = _G.bit.bor(
    _G.COMBATLOG_OBJECT_AFFILIATION_RAID,
    _G.COMBATLOG_OBJECT_REACTION_FRIENDLY,
    _G.COMBATLOG_OBJECT_CONTROL_PLAYER,
    _G.COMBATLOG_OBJECT_TYPE_PET
)

function C:IsInMyGroup(flags)
    local inParty = IsInGroup() and _G.bit.band(flags, _G.COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0
    local inRaid = IsInRaid() and _G.bit.band(flags, _G.COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0

    return inRaid or inParty
end
