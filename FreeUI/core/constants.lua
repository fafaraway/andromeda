local F, C = unpack(select(2, ...))


local bit_band, bit_bor = bit.band, bit.bor
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE or 0x00000001
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo


C.Frames = {}
C.Themes = {}
C.BlizzThemes = {}

C.MyClass = select(2, UnitClass('player'))
C.MyName = UnitName('player')
C.MyLevel = UnitLevel('player')
C.MyFaction = select(2, UnitFactionGroup('player'))
C.MyRace = select(2, UnitRace('player'))
C.MyRealm = GetRealmName()
C.Version = GetAddOnMetadata('FreeUI', 'Version')
C.Support = GetAddOnMetadata('FreeUI', 'X-Support')
C.Client = GetLocale()
C.isChinses = C.Client == 'zhCN' or C.Client == 'zhTW'
C.isCNPortal = GetCVar('portal') == 'CN'
C.ScreenWidth, C.ScreenHeight = GetPhysicalScreenSize()
C.isNewPatch = GetBuildInfo() == '8.3.0'
C.AssetsPath = 'Interface\\AddOns\\FreeUI\\assets\\'
C.isDeveloper = false


C['Assets'] = {

	['norm_tex'] = C.AssetsPath..'textures\\norm_tex',
	['grad_tex'] = C.AssetsPath..'textures\\grad_tex',
	['flat_tex'] = C.AssetsPath..'textures\\flat_tex',

	['bd_tex'] = 'Interface\\ChatFrame\\ChatFrameBackground',
	['bg_tex'] = C.AssetsPath..'textures\\bg_tex',
	['glow_tex'] = C.AssetsPath..'textures\\glow_tex',

	['tick_tex'] = C.AssetsPath..'textures\\tick_tex',
	['stripe_tex'] = C.AssetsPath..'textures\\stripe_tex',

	['close_tex'] = C.AssetsPath..'textures\\close_tex',
	['arrow_tex'] = C.AssetsPath..'textures\\arrow_tex',

	['button_normal']  = C.AssetsPath..'button\\normal',
	['button_flash']   = C.AssetsPath..'button\\flash',
	['button_pushed']  = C.AssetsPath..'button\\pushed',
	['button_checked'] = C.AssetsPath..'button\\checked',

	['mask_tex'] = C.AssetsPath..'textures\\rectangle',

	['roles_icon'] = C.AssetsPath..'textures\\roles_icon',
	['target_icon'] = C.AssetsPath..'textures\\UI-RaidTargetingIcons',
	['vig_tex'] = C.AssetsPath..'textures\\vignetting',
	['spark_tex'] = 'Interface\\CastingBar\\UI-CastingBar-Spark',
	['gear_tex'] = C.AssetsPath..'textures\\gear_tex',

	['logo'] = C.AssetsPath..'textures\\logo_grey',
	['logo_small'] = C.AssetsPath..'textures\\logo_small',



	['mouse_left'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t ',
	['mouse_right'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t ',
	['mouse_middle'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t ',

	['font_normal'] = STANDARD_TEXT_FONT,

	--[[ ['Textures'] = {
		['backdrop'] = 'Interface\\ChatFrame\\ChatFrameBackground',
		['bdstripe'] = C.AssetsPath..'textures\\bgTex',
		['statusbar'] = C.AssetsPath..'textures\\normTex',
		['sbstripe'] = C.AssetsPath..'textures\\striped',
		['shadow'] = C.AssetsPath..'textures\\glowTex',
		['tick'] = C.AssetsPath..'textures\\tickTex',
		['check'] = C.AssetsPath..'textures\\checked',
		['logo'] = C.AssetsPath..'textures\\logo_grey',
		['logo_small'] = C.AssetsPath..'textures\\logo_small',
		['targeticon'] = C.AssetsPath..'textures\\UI-RaidTargetingIcons',
		['rolesicon'] = C.AssetsPath..'textures\\RoleIcons',
		['mapmask'] = C.AssetsPath..'textures\\rectangle',
		['spark'] = 'Interface\\CastingBar\\UI-CastingBar-Spark',
		['vignetting'] = C.AssetsPath..'textures\\vignetting',
		['arrowUp'] = C.AssetsPath..'textures\\arrow-up-active',
		['arrowDown'] = C.AssetsPath..'textures\\arrow-down-active',
		['arrowLeft'] = C.AssetsPath..'textures\\arrow-left-active',
		['arrowRight'] = C.AssetsPath..'textures\\arrow-right-active',
		['mouse_left'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t ',
		['mouse_right'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t ',
		['mouse_middle'] = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t ',
	}, ]]

	--[[ ['Button'] = {
		['normal']  = C.AssetsPath..'button\\normal',
		['flash']   = C.AssetsPath..'button\\flash',
		['pushed']  = C.AssetsPath..'button\\pushed',
		['checked'] = C.AssetsPath..'button\\checked',
	},
 ]]


	['Sounds'] = {
		['whisper'] = C.AssetsPath..'sounds\\whisper_normal.ogg',
		['whisperBN'] = C.AssetsPath..'sounds\\whisper_bn.ogg',
		['notification'] = C.AssetsPath..'sounds\\notification.ogg',
		['feast'] = C.AssetsPath..'sounds\\feast.ogg',
		['health'] = C.AssetsPath..'sounds\\health.ogg',
		['mana'] = C.AssetsPath..'sounds\\mana.ogg',
		['interrupt'] = C.AssetsPath..'sounds\\interrupt.ogg',
		['dispel'] = C.AssetsPath..'sounds\\dispel.ogg',
	},

	['Fonts'] = {
		['Normal'] = STANDARD_TEXT_FONT,
		['Header'] = UNIT_NAME_FONT,
		['Chat'] = STANDARD_TEXT_FONT,
		['Number'] = STANDARD_TEXT_FONT,
		['Pixel'] = C.AssetsPath..'fonts\\pixel.ttf',
		['Cooldown'] = C.AssetsPath..'fonts\\cooldown.ttf',
		['Symbol'] = C.AssetsPath..'fonts\\symbol.ttf',
	},
}



C.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	C.ClassList[v] = k
end

C.ClassColors = {}
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
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

C.MyColor = format('|cff%02x%02x%02x', C.r*255, C.g*255, C.b*255)
C.InfoColor = '|cffe9c55d'
C.YellowColor = '|cffffd200'
C.GreyColor = '|cff808080'
C.RedColor = '|cffff2020'
C.GreenColor = '|cff20ff20'
C.BlueColor = '|cff82c5ff'
C.OrangeColor = '|cffff7f3f'
C.PurpleColor = '|cffa571df'
C.LineString = C.GreyColor..'---------------'

C.QualityColors = {}
local qualityColors = BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
	C.QualityColors[index] = {r = value.r, g = value.g, b = value.b}
end
C.QualityColors[-1] = {r = 0, g = 0, b = 0}
C.QualityColors[LE_ITEM_QUALITY_POOR] = {r = .61, g = .61, b = .61}
C.QualityColors[LE_ITEM_QUALITY_COMMON] = {r = 0, g = 0, b = 0}

C.Title = '|cffe6e6e6Free|r'..C.MyColor..'UI|r'
C.TexCoord = {.08, .92, .08, .92}


GOLD_AMOUNT_SYMBOL = format('|cffffd700%s|r', GOLD_AMOUNT_SYMBOL)
SILVER_AMOUNT_SYMBOL = format('|cffd0d0d0%s|r', SILVER_AMOUNT_SYMBOL)
COPPER_AMOUNT_SYMBOL = format('|cffc77050%s|r', COPPER_AMOUNT_SYMBOL)
COPPER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t'
SILVER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t'
GOLD_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t'

NORMAL_QUEST_DISPLAY = gsub(NORMAL_QUEST_DISPLAY, '000000', 'ffffff')
TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, '000000', 'ffffff')
IGNORED_QUEST_DISPLAY = gsub(IGNORED_QUEST_DISPLAY, '000000', 'ffffff')


-- RoleUpdater
local function CheckRole()
	local tree = GetSpecialization()
	if not tree then return end
	local _, _, _, _, role, stat = GetSpecializationInfo(tree)
	if role == 'TANK' then
		C.Role = 'Tank'
	elseif role == 'HEALER' then
		C.Role = 'Healer'
	elseif role == 'DAMAGER' then
		if stat == 4 then	--1力量，2敏捷，4智力
			C.Role = 'Caster'
		else
			C.Role = 'Melee'
		end
	end
end
F:RegisterEvent('PLAYER_LOGIN', CheckRole)
F:RegisterEvent('PLAYER_TALENT_UPDATE', CheckRole)


-- Flags
function C:IsMyPet(flags)
	return bit_band(flags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0
end
C.PartyPetFlags = bit_bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
C.RaidPetFlags = bit_bor(COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PET)
