local addonName, _ = ...
local F, C, L = unpack(select(2, ...))

local format = string.format

local assetsPath = "interface\\addons\\"..addonName.."\\assets\\"


C.media = {
	['arrowUp']    = assetsPath..'arrow-up-active',
	['arrowDown']  = assetsPath..'arrow-down-active',
	['arrowLeft']  = assetsPath..'arrow-left-active',
	['arrowRight'] = assetsPath..'arrow-right-active',
	['backdrop']   = assetsPath..'blank',
	['checked']    = assetsPath..'CheckButtonHilight',
	['glowTex']    = assetsPath..'glowTex',
	['gradient']   = assetsPath..'gradient',
	['roleIcons']  = assetsPath..'UI-LFG-ICON-ROLES',
	['sbTex']      = assetsPath..'statusbar',
	['bgTex']	   = assetsPath..'bgTex',
	['sparkTex']   = 'Interface\\CastingBar\\UI-CastingBar-Spark',
	['flashTex']   = 'Interface\\Cooldown\\star4',
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

C['font'] = {
	['normal']     = normalFont,
	['damage']     = damageFont,
	['header']     = headerFont,
	['chat']       = ChatFont,
	['pixel']      = assetsPath..'font\\pixel.ttf',
}



--[[C.ClassColors = {}
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

C.MyColor = format("|cff%02x%02x%02x", C.r*255, C.g*255, C.b*255)
C.InfoColor = "|cffe5d19f"
C.GreyColor = "|cff808080"
C.RedColor = "|cffff2735"
C.GreenColor = "|cff3a9d36"

C.Class = select(2, UnitClass("player"))
C.Name = UnitName("player")
C.Realm = GetRealmName()
C.Client = GetLocale()
C.Version = GetAddOnMetadata("FreeUI", "Version")
C.Title = GetAddOnMetadata("FreeUI", "Title")
C.Support = GetAddOnMetadata("FreeUI", "X-Support")
C.TexCoord = {.08, .92, .08, .92}

C.ScreenWidth, C.ScreenHeight = GetPhysicalScreenSize()
local fixedHeight = 768 / C.ScreenHeight
local scale = tonumber(floor(fixedHeight*100 + .5)/100)

C.Mult = fixedHeight / scale

C.LineString = C.GreyColor.."---------------"
C.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
C.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
C.MiddleButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "
C.LineString = C.GreyColor.."---------------"]]