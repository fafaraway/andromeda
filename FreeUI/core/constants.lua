local F, C = unpack(select(2, ...))

local bit_band, bit_bor = bit.band, bit.bor
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE or 0x00000001
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo

C.MyClass = select(2, UnitClass('player'))
C.MyName = UnitName('player')
C.MyLevel = UnitLevel('player')
C.MyFaction = select(2, UnitFactionGroup('player'))
C.MyRace = select(2, UnitRace('player'))
C.MyRealm = GetRealmName()
C.MyFullName = C.MyName .. '-' .. C.MyRealm
C.AddonVersion = GetAddOnMetadata('FreeUI', 'Version')
C.Support = GetAddOnMetadata('FreeUI', 'X-Support')
C.Client = GetLocale()
C.isChinses = C.Client == 'zhCN' or C.Client == 'zhTW'
C.isCNPortal = GetCVar('portal') == 'CN'
C.ScreenWidth, C.ScreenHeight = GetPhysicalScreenSize()
C.isNewPatch = select(4, GetBuildInfo()) > 90001
C.AssetsPath = 'Interface\\AddOns\\FreeUI\\assets\\'
C.TexCoord = {.08, .92, .08, .92}
C.UIGap = 33
C.MaxLevel = GetMaxLevelForPlayerExpansion()
C.BackdropColor = {.1, .1, .1}
C.BorderColor = {.04, .04, .04}
C.GradientColor = {.04, .04, .04, .4, .08, .08, .08, .4}

C.DevsList = {
	['Farfaraway-死亡之翼'] = true,
	['Fionorolah-死亡之翼'] = true,
	['Kangrinboqe-死亡之翼'] = true,
	['Dontbeshy-死亡之翼'] = true,
	['瑪格漢之光-死亡之翼'] = true,
	['贰拾年老騎士-死亡之翼'] = true,
	['贰拾年老法師-死亡之翼'] = true,
	['贰拾年老戰士-死亡之翼'] = true,
	['贰拾年老牧師-死亡之翼'] = true,
	['Rhonesaia-白银之手'] = true
}
local function isDeveloper()
	return C.DevsList[C.MyFullName]
end
C.isDeveloper = isDeveloper()

C['Assets'] = {
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
	['mask_tex'] = C.AssetsPath .. 'textures\\rectangle',
	['roles_icon'] = C.AssetsPath .. 'textures\\roles_icon',
	['target_icon'] = C.AssetsPath .. 'textures\\UI-RaidTargetingIcons',
	['vig_tex'] = C.AssetsPath .. 'textures\\vignetting',
	['spark_tex'] = C.AssetsPath .. 'textures\\spark_tex',
	['gear_tex'] = C.AssetsPath .. 'textures\\gear_tex',
	['classify_tex'] = C.AssetsPath .. 'textures\\state_icons',
	['logo'] = C.AssetsPath .. 'textures\\logo',
	['mouse_left'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t ',
	['mouse_right'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t ',
	['mouse_middle'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t ',
	['Sounds'] = {
		['whisper'] = C.AssetsPath .. 'sounds\\whisper_normal.ogg',
		['whisperBN'] = C.AssetsPath .. 'sounds\\whisper_bn.ogg',
		['notification'] = C.AssetsPath .. 'sounds\\notification.ogg',
		['feast'] = C.AssetsPath .. 'sounds\\feast.ogg',
		['health'] = C.AssetsPath .. 'sounds\\health.ogg',
		['mana'] = C.AssetsPath .. 'sounds\\mana.ogg',
		['interrupt'] = C.AssetsPath .. 'sounds\\interrupt.ogg',
		['dispel'] = C.AssetsPath .. 'sounds\\dispel.ogg'
	},
	['Fonts'] = {
		['Regular'] = C.AssetsPath .. 'fonts\\regular.ttf',
		['Condensed'] = C.AssetsPath .. 'fonts\\condensed.ttf',
		['Bold'] = C.AssetsPath .. 'fonts\\bold.ttf',
		['Header'] = C.AssetsPath .. 'fonts\\header.ttf',
		['Combat'] = C.AssetsPath .. 'fonts\\combat.ttf',
		['Pixel'] = C.AssetsPath .. 'fonts\\pixel.ttf',
		['Square'] = C.AssetsPath .. 'fonts\\square.ttf',
		['Roadway'] = C.AssetsPath .. 'fonts\\roadway.ttf'
	}
}

C.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	C.ClassList[v] = k
end

C.ClassColors = {}
function F.UpdateCustomClassColors()
	local colors = FREE_ADB.custom_class_color and FREE_ADB.class_colors_list or RAID_CLASS_COLORS
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

	C.MyColor = format('|cff%02x%02x%02x', C.r * 255, C.g * 255, C.b * 255)
	C.AddonName = '|cffe6e6e6Free|r' .. C.MyColor .. 'UI|r'
end
F:RegisterEvent('ADDON_LOADED', F.UpdateCustomClassColors)

C.InfoColor = '|cffe9c55d'
C.YellowColor = '|cffffff00'
C.GreyColor = '|cff7f7f7f'
C.WhiteColor = '|cffffffff'
C.RedColor = '|cffff2020'
C.GreenColor = '|cff20ff20'
C.BlueColor = '|cff82c5ff'
C.OrangeColor = '|cffff7f3f'
C.PurpleColor = '|cffa571df'
C.LineString = C.GreyColor .. '---------------'

-- Deprecated
LE_ITEM_QUALITY_POOR = Enum.ItemQuality.Poor
LE_ITEM_QUALITY_COMMON = Enum.ItemQuality.Common
LE_ITEM_QUALITY_UNCOMMON = Enum.ItemQuality.Uncommon
LE_ITEM_QUALITY_RARE = Enum.ItemQuality.Rare
LE_ITEM_QUALITY_EPIC = Enum.ItemQuality.Epic
LE_ITEM_QUALITY_LEGENDARY = Enum.ItemQuality.Legendary
LE_ITEM_QUALITY_ARTIFACT = Enum.ItemQuality.Artifact
LE_ITEM_QUALITY_HEIRLOOM = Enum.ItemQuality.Heirloom

C.QualityColors = {}
local qualityColors = BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
	C.QualityColors[index] = {r = value.r, g = value.g, b = value.b}
end
C.QualityColors[-1] = {r = 0, g = 0, b = 0}
C.QualityColors[LE_ITEM_QUALITY_POOR] = {r = .61, g = .61, b = .61}
C.QualityColors[LE_ITEM_QUALITY_COMMON] = {r = 0, g = 0, b = 0}

_G.GOLD_AMOUNT_SYMBOL = format('|cffffd700%s|r', GOLD_AMOUNT_SYMBOL)
_G.SILVER_AMOUNT_SYMBOL = format('|cffd0d0d0%s|r', SILVER_AMOUNT_SYMBOL)
_G.COPPER_AMOUNT_SYMBOL = format('|cffc77050%s|r', COPPER_AMOUNT_SYMBOL)
_G.COPPER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t'
_G.SILVER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t'
_G.GOLD_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t'

-- RoleUpdater
local function CheckRole()
	local tree = GetSpecialization()
	if not tree then
		return
	end
	local _, _, _, _, role, stat = GetSpecializationInfo(tree)
	if role == 'TANK' then
		C.Role = 'Tank'
	elseif role == 'HEALER' then
		C.Role = 'Healer'
	elseif role == 'DAMAGER' then
		if stat == 4 then -- 1力量，2敏捷，4智力
			C.Role = 'Caster'
		else
			C.Role = 'Melee'
		end
	end
end
F:RegisterEvent('ADDON_LOADED', CheckRole)
F:RegisterEvent('PLAYER_TALENT_UPDATE', CheckRole)

-- Flags
function C:IsMyPet(flags)
	return bit_band(flags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0
end
C.PartyPetFlags = bit_bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
C.RaidPetFlags = bit_bor(COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
