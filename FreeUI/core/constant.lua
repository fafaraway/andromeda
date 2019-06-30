local F, C, L = unpack(select(2, ...))

local format, tonumber, floor, pairs = string.format, tonumber, math.floor, pairs

local assetsPath = 'interface\\addons\\FreeUI\\assets\\'


C.media = {
	['arrowUp']    = assetsPath..'arrow-up-active',
	['arrowDown']  = assetsPath..'arrow-down-active',
	['arrowLeft']  = assetsPath..'arrow-left-active',
	['arrowRight'] = assetsPath..'arrow-right-active',
	['backdrop']   = 'Interface\\ChatFrame\\ChatFrameBackground',
	['pushed']     = assetsPath..'pushed',
	['checked']    = assetsPath..'checked',
	['glowTex']    = assetsPath..'glowTex',
	['gradient']   = assetsPath..'gradient',
	['roleIcons']  = assetsPath..'UI-LFG-ICON-ROLES',
	['sbTex']      = assetsPath..'statusbar',
	['bgTex']	   = assetsPath..'bgTex',
	['sparkTex']   = 'Interface\\CastingBar\\UI-CastingBar-Spark',
	['flashTex']   = 'Interface\\Cooldown\\star4',
	['gearTex']    = 'Interface\\WorldMap\\Gear_64'
}



local normalFont, damageFont, headerFont, chatFont
if GetLocale() == 'zhCN' then
	normalFont = 'Fonts\\ARKai_T.ttf'
	damageFont = 'Fonts\\ARKai_C.ttf'
	headerFont = 'Fonts\\ARKai_T.ttf'
	chatFont   = 'Fonts\\ARKai_T.ttf'
elseif GetLocale() == 'zhTW' then
	normalFont = 'Fonts\\blei00d.ttf'
	damageFont = 'Fonts\\bKAI00M.ttf'
	headerFont = 'Fonts\\blei00d.ttf'
	chatFont   = 'Fonts\\blei00d.ttf'
elseif GetLocale() == 'koKR' then
	normalFont = 'Fonts\\2002.ttf'
	damageFont = 'Fonts\\K_Damage.ttf'
	headerFont = 'Fonts\\2002.ttf'
	chatFont   = 'Fonts\\2002.ttf'
elseif GetLocale() == 'ruRU' then
	normalFont = 'Fonts\\FRIZQT___CYR.ttf'
	damageFont = 'Fonts\\FRIZQT___CYR.ttf'
	headerFont = 'Fonts\\FRIZQT___CYR.ttf'
	chatFont   = 'Fonts\\FRIZQT___CYR.ttf'
else
	normalFont = assetsPath..'font\\expresswaysb.ttf'
	damageFont = assetsPath..'font\\PEPSI_pl.ttf'
	headerFont = assetsPath..'font\\ExocetBlizzardMedium.ttf'
	chatFont   = assetsPath..'font\\expresswaysb.ttf'
end

C.font = {
	['normal']     = normalFont,
	['damage']     = damageFont,
	['header']     = headerFont,
	['chat']       = chatFont,
	['pixel']      = assetsPath..'font\\pixel.ttf',
	['pixelCN']    = 'Fonts\\pixfontCN.ttf',
}

if GetLocale() == 'ruRU' then
	C.font.pixel = assetsPath..'font\\iFlash705.ttf'
end




C.Class = select(2, UnitClass('player'))
C.Name = UnitName('player')
C.Realm = GetRealmName()
C.Client = GetLocale()
C.Version = GetAddOnMetadata('FreeUI', 'Version')
C.Title = GetAddOnMetadata('FreeUI', 'Title')
C.Support = GetAddOnMetadata('FreeUI', 'X-Support')
C.wowBuild = select(2, GetBuildInfo()); C.wowBuild = tonumber(C.wowBuild)

C.ClassColors = {}
C.ClassList = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	C.ClassList[v] = k
end

local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class in pairs(colors) do
	C.ClassColors[class] = {}
	C.ClassColors[class].r = colors[class].r
	C.ClassColors[class].g = colors[class].g
	C.ClassColors[class].b = colors[class].b
	C.ClassColors[class].colorStr = colors[class].colorStr
end
C.r, C.g, C.b = C.ClassColors[C.Class].r, C.ClassColors[C.Class].g, C.ClassColors[C.Class].b


C.MyColor = format('|cff%02x%02x%02x', C.r*255, C.g*255, C.b*255)
C.InfoColor = '|cffe5d19f'
C.GreyColor = '|cff808080'
C.RedColor = '|cffff2735'
C.GreenColor = '|cff3a9d36'

C.LineString = C.GreyColor..'---------------'
C.LeftButton = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t '
C.RightButton = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t '
C.MiddleButton = ' |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t '
C.CopyTex = 'Interface\\Buttons\\UI-GuildButton-PublicNote-Up'

C.TexCoord = {.08, .92, .08, .92}

C.AssetsPath = 'interface\\addons\\FreeUI\\assets\\'






local LSM = LibStub and LibStub('LibSharedMedia-3.0', true)
if not LSM then return end

local zhCN, zhTW, western = LSM.LOCALE_BIT_zhCN, LSM.LOCALE_BIT_zhTW, LSM.LOCALE_BIT_western


LSM:Register('background', 'FreeUI_BG', 			C.media.backdrop)

LSM:Register('statusbar', 'FreeUI_SB',  			C.media.sbTex)

LSM:Register('font', 'FreeUI_ExocetBlizzardLight', 	assetsPath..'font\\ExocetBlizzardLight.ttf', zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_ExocetBlizzardMedium', assetsPath..'font\\ExocetBlizzardMedium.ttf', zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_supereffective', 		assetsPath..'font\\supereffective.ttf', zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_pixel', 				assetsPath..'font\\pixel.ttf', zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_pixel_bold', 			assetsPath..'font\\pixel_bold.ttf', zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_PixfontCN', 			C.font.pixelCN, zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_Normal', 				C.font.normal, zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_Header', 				C.font.header, zhCN + zhTW + western)
LSM:Register('font', 'FreeUI_Chat', 				C.font.chat, zhCN + zhTW + western)

LSM:Register('sound', 'FreeUI_buzz', 				assetsPath..'sound\\buzz.ogg')
LSM:Register('sound', 'FreeUI_ding', 				assetsPath..'sound\\ding.ogg')
LSM:Register('sound', 'FreeUI_execute', 			assetsPath..'sound\\execute.ogg')
LSM:Register('sound', 'FreeUI_LowHealth', 			assetsPath..'sound\\LowHealth.ogg')
LSM:Register('sound', 'FreeUI_LowMana', 			assetsPath..'sound\\LowMana.ogg')
LSM:Register('sound', 'FreeUI_miss', 				assetsPath..'sound\\miss.mp3')
LSM:Register('sound', 'FreeUI_Proc', 				assetsPath..'sound\\Proc.ogg')
LSM:Register('sound', 'FreeUI_Shutupfool', 			assetsPath..'sound\\Shutupfool.ogg')
LSM:Register('sound', 'FreeUI_sound', 				assetsPath..'sound\\sound.mp3')
LSM:Register('sound', 'FreeUI_Warning', 			assetsPath..'sound\\Warning.ogg')
LSM:Register('sound', 'FreeUI_whisper', 			assetsPath..'sound\\whisper.ogg')
LSM:Register('sound', 'FreeUI_whisper1', 			assetsPath..'sound\\whisper1.ogg')
LSM:Register('sound', 'FreeUI_whisper2', 			assetsPath..'sound\\whisper2.ogg')
LSM:Register('sound', 'FreeUI_forthehorde', 		assetsPath..'sound\\forthehorde.mp3')

