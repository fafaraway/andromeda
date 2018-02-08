local F, C, L = unpack(select(2, ...))
local _G = _G
local next, type = _G.next, _G.type
local playername, _ = UnitName('player')
local r, g, b = C.appearance.fontColorFontRGB.r, C.appearance.fontColorFontRGB.g, C.appearance.fontColorFontRGB.b
local locale = GetLocale()
local font

local function SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
	if type(fontObj) == "string" then fontObj = _G[fontObj] end
	if not fontObj then return end
	fontObj:SetFont(fontPath, fontSize, fontStyle)
	if shadowColor then fontObj:SetShadowColor(shadowColor[1], shadowColor[2], shadowColor[3], shadowColor[4]) end
	if shadowX and shadowY then fontObj:SetShadowOffset(shadowX, shadowY) end
	if type(fontColor) == "table" then fontObj:SetTextColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4])
	elseif fontColor then fontObj:SetAlpha(fontColor) end
end


-- Regular text: replaces FRIZQT__.TTF
local NORMAL = C.font.normal
--local NORMAL = font.normal

-- Chat Font: replaces ARIALN.TTF
local CHAT   = C.font.chat

-- Crit Font: replaces skurri.ttf
local CRIT   = C.font.damage

local UNITNAME   = C.font.unitname

-- Header Font: replaces MORPHEUS.ttf
local HEADER = C.font.header


_G.STANDARD_TEXT_FONT = NORMAL
_G.UNIT_NAME_FONT = UNITNAME
_G.NAMEPLATE_FONT = NORMAL
_G.DAMAGE_TEXT_FONT = CRIT

-- Base fonts, everything inhierits from these fonts.
-- FrameXML\Fonts.xml
SetFont("SystemFont_Outline_Small",       NORMAL, 10, "OUTLINE")
SetFont("SystemFont_Outline",             NORMAL, 13, "OUTLINE")
SetFont("SystemFont_InverseShadow_Small", NORMAL, 10, nil, nil, {0.4, 0.4, 0.4, 0.75}, 1, -1)
SetFont("SystemFont_Med2",                NORMAL, 13)
SetFont("SystemFont_Med3",                NORMAL, 14)
SetFont("SystemFont_Shadow_Med3",         NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Huge1",               NORMAL, 20)
SetFont("SystemFont_Huge1_Outline",       NORMAL, 20, "OUTLINE")
SetFont("SystemFont_OutlineThick_Huge2",  NORMAL, 22, "THICKOUTLINE")
SetFont("SystemFont_OutlineThick_Huge4",  NORMAL, 26, "THICKOUTLINE")
SetFont("SystemFont_OutlineThick_WTF",    NORMAL, 32, "THICKOUTLINE")

SetFont("NumberFont_GameNormal",            NORMAL, 10, nil, nil, {0, 0, 0}, 1, -1)
SetFont("NumberFont_Shadow_Small",            CHAT, 12, nil, nil, {0, 0, 0}, 1, -1)
SetFont("NumberFont_OutlineThick_Mono_Small", CHAT, 12, "THICKOUTLINE, MONOCHROME")
SetFont("NumberFont_Shadow_Med",              CHAT, 14, nil, nil, {0, 0, 0}, 1, -1)
SetFont("NumberFont_Normal_Med",              CHAT, 14)
SetFont("NumberFont_Outline_Med",             CHAT, 14, "OUTLINE")
SetFont("NumberFont_Outline_Large",           CHAT, 16, "OUTLINE")
SetFont("NumberFont_Outline_Huge",            CRIT, 30, "OUTLINE")

SetFont("Fancy22Font",                  HEADER, 22)
SetFont("QuestFont_Huge",               HEADER, 18)
SetFont("QuestFont_Outline_Huge",       HEADER, 18, "OUTLINE")
SetFont("QuestFont_Super_Huge",         HEADER, 24, nil, {r, g, b})
SetFont("QuestFont_Super_Huge_Outline", HEADER, 24, "OUTLINE", {r, g, b})
SetFont("SplashHeaderFont",             HEADER, 24, nil, {r, g, b}, {0, 0, 0}, 1, -2)

SetFont("Game11Font", NORMAL, 11)
SetFont("Game12Font", NORMAL, 12)
SetFont("Game13Font", NORMAL, 13)
SetFont("Game13FontShadow", NORMAL, 13, nil, nil, {0, 0, 0}, 1, -1)
SetFont("Game15Font", NORMAL, 15)
SetFont("Game18Font", NORMAL, 18)
SetFont("Game20Font", NORMAL, 20)
SetFont("Game24Font", NORMAL, 24)
SetFont("Game27Font", NORMAL, 27)
SetFont("Game30Font", NORMAL, 30)
SetFont("Game32Font", NORMAL, 32)
SetFont("Game36Font", NORMAL, 36)
SetFont("Game48Font", NORMAL, 48)
SetFont("Game48FontShadow", NORMAL, 48, nil, nil, {0, 0, 0}, 1, -1)
SetFont("Game60Font", NORMAL, 60)
SetFont("Game72Font", NORMAL, 72)

SetFont("Game11Font_ol", NORMAL, 11, "OUTLINE")
SetFont("Game12Font_ol", NORMAL, 12, "OUTLINE")
SetFont("Game13Font_ol", NORMAL, 13, "OUTLINE")
SetFont("Game15Font_ol", NORMAL, 15, "OUTLINE")

SetFont("QuestFont_Enormous",     HEADER, 30, nil, {r, g, b})
SetFont("DestinyFontLarge",       HEADER, 18, nil, {0.1, 0.1, 0.1})
SetFont("CoreAbilityFont",        HEADER, 32, nil, {0.1, 0.1, 0.1})
SetFont("DestinyFontHuge",        HEADER, 32, nil, {0.1, 0.1, 0.1})
SetFont("QuestFont_Shadow_Small", HEADER, 14, nil, nil, {0.49, 0.35, 0.05}, 1, -1)

SetFont("MailFont_Large",    HEADER, 15)
SetFont("SpellFont_Small",   NORMAL, 10)
SetFont("InvoiceFont_Med",   NORMAL, 12)
SetFont("InvoiceFont_Small", NORMAL, 10)
SetFont("Tooltip_Med",       NORMAL, 12)
SetFont("Tooltip_Small",     NORMAL, 10)

SetFont("AchievementFont_Small", NORMAL, 12)
SetFont("ReputationDetailFont",  NORMAL, 10, nil, {1, 1, 1}, {0, 0, 0}, 1, -1)
SetFont("FriendsFont_Normal",    NORMAL, 12, nil, nil, {0, 0, 0}, 1, -1)
SetFont("FriendsFont_Small",     NORMAL, 10, nil, nil, {0, 0, 0}, 1, -1)
SetFont("FriendsFont_Large",     NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
SetFont("FriendsFont_UserText",  NORMAL, 11, nil, nil, {0, 0, 0}, 1, -1)
SetFont("GameFont_Gigantic",     NORMAL, 32, nil, {r, g, b}, {0, 0, 0}, 1, -1)

SetFont("ChatBubbleFont", NORMAL, 13)
SetFont("Fancy16Font",    HEADER, 16)
SetFont("Fancy18Font",    HEADER, 18)
SetFont("Fancy20Font",    HEADER, 20)
SetFont("Fancy24Font",    HEADER, 24)
SetFont("Fancy27Font",    HEADER, 27)
SetFont("Fancy30Font",    HEADER, 30)
SetFont("Fancy32Font",    HEADER, 32)
SetFont("Fancy48Font",    HEADER, 48)

SetFont("SystemFont_NamePlateFixed",      NORMAL, 14)
SetFont("SystemFont_LargeNamePlateFixed", NORMAL, 20)
SetFont("SystemFont_NamePlate",           NORMAL, 9)
SetFont("SystemFont_LargeNamePlate",      NORMAL, 12)
SetFont("SystemFont_NamePlateCastBar",    NORMAL, 10)

-- SharedXML\SharedFonts.xml
SetFont("SystemFont_Tiny2",                NORMAL, 8)
SetFont("SystemFont_Tiny",                 NORMAL, 9)
SetFont("SystemFont_Shadow_Small",         NORMAL, 10, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Small",                NORMAL, 10)
SetFont("SystemFont_Small2",               NORMAL, 11)
SetFont("SystemFont_Shadow_Small2",        NORMAL, 11, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Med1_Outline",  NORMAL, 12, "OUTLINE", nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Med1",          NORMAL, 12, nil, nil, {0, 0, 0}, 1, -1)
SetFont("QuestFont_Large",                 HEADER, 15)
SetFont("SystemFont_Large",                NORMAL, 16)
SetFont("SystemFont_Shadow_Large_Outline", NORMAL, 16, "OUTLINE", nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Med2",          NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Large",         NORMAL, 16, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Large2",        NORMAL, 18, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Huge1",         NORMAL, 20, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Huge2",                NORMAL, 24)
SetFont("SystemFont_Shadow_Huge2",         NORMAL, 24, "OUTLINE", nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Huge3",         NORMAL, 25, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Outline_Huge3", NORMAL, 25, "OUTLINE", nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_World",                NORMAL, 64, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_World_ThickOutline",   NORMAL, 64, "THICKOUTLINE", nil, {0, 0, 0}, 1, -1)
SetFont("SystemFont_Shadow_Outline_Huge2", NORMAL, 22, "OUTLINE", nil, {0, 0, 0}, 2, -2)
SetFont("SystemFont_Med1",                 NORMAL, 12)
SetFont("SystemFont_WTF2",                 NORMAL, 36)
SetFont("SystemFont_Outline_WTF2",         NORMAL, 36, "OUTLINE")
SetFont("GameTooltipHeader",               NORMAL, 14)
SetFont("System_IME", NORMAL, 16)

--

SetFont("ZoneTextFont",                    HEADER, 40, nil, nil, {0, 0, 0}, 1, -1)
SetFont("SubZoneTextFont",                 HEADER, 40, nil, nil, {0, 0, 0}, 1, -1)
SetFont("WorldMapTextFont",                HEADER, 40, nil, nil, {0, 0, 0}, 1, -1)

SetFont("RaidWarningFrame.slot1",	HEADER, 28, nil, nil, {0, 0, 0}, 1, -1)
SetFont("RaidWarningFrame.slot2", 	HEADER, 28, nil, nil, {0, 0, 0}, 1, -1)
SetFont("RaidBossEmoteFrame.slot1",	HEADER, 28, nil, nil, {0, 0, 0}, 1, -1)
SetFont("RaidBossEmoteFrame.slot2",	HEADER, 28, nil, nil, {0, 0, 0}, 1, -1)

SetFont("GameFontNormalSmall",		NORMAL, 11)


if C.appearance.fontUseColorFont then
	local yellowFonts = {
		"GameFontNormal",
		"GameFontNormalSmall",
		"GameFontNormalMed3",
		"GameFontNormalLarge",
		"GameFontNormalHuge",
		"BossEmoteNormalHuge",
		"NumberFontNormalRightYellow",
		"NumberFontNormalYellow",
		"NumberFontNormalLargeRightYellow",
		"NumberFontNormalLargeYellow",
		"QuestTitleFontBlackShadow",
		"DialogButtonNormalText",
		"AchievementPointsFont",
		"AchievementPointsFontSmall",
		"AchievementDateFont",
		"FocusFontSmall"
	}
	for k, yellowFont in next, yellowFonts do
		_G[yellowFont]:SetTextColor(r, g, b)
	end
end

