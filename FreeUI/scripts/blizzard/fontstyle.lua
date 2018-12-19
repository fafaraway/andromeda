local F, C, L = unpack(select(2, ...))
local module = F:GetModule("blizzard")

_G.STANDARD_TEXT_FONT = C.font.normal
_G.UNIT_NAME_FONT = C.font.header
_G.DAMAGE_TEXT_FONT = C.font.damage
_G.NAMEPLATE_FONT = C.font.normal

function module:FontStyle()
	if not C.appearance.fontStyle then return end

	local function SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
		if _G.type(fontObj) == "string" then fontObj = _G[fontObj] end
		if not fontObj then return end

		if fontPath then
			fontObj:SetFont(fontPath, fontSize, fontStyle)
		end

		if fontColor then
			fontObj:SetTextColor(fontColor.r, fontColor.g, fontColor.b)
		end

		if shadowColor then
			fontObj:SetShadowColor(shadowColor.r, shadowColor.g, shadowColor.b, 0.5)
		end

		if shadowX and shadowY then
			fontObj:SetShadowOffset(shadowX, shadowY)
		end
	end

	-- SharedFonts     
	SetFont("SystemFont_Tiny2",                C.font.normal, 8)
	SetFont("SystemFont_Tiny",                 C.font.normal, 9)
	SetFont("SystemFont_Shadow_Small",         C.font.normal, 11, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Small",                C.font.normal, 11)
	SetFont("SystemFont_Small2",               C.font.normal, 11)
	SetFont("SystemFont_Shadow_Small2",        C.font.normal, 11, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med1_Outline",  C.font.normal, 12, "OUTLINE", nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med1",          C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Med2",                 C.font.normal, 13)
	SetFont("SystemFont_Med3",                 C.font.normal, 14)
	SetFont("SystemFont_Shadow_Med3",          C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Large",                 C.font.header, 15)
	SetFont("QuestFont_Huge",                  C.font.header, 18)
	SetFont("SystemFont_Large",                C.font.normal, 16)
	SetFont("SystemFont_Shadow_Large_Outline", C.font.normal, 16, "OUTLINE", nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med2",          C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Large",         C.font.normal, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Large2",        C.font.normal, 18, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Huge1",         C.font.normal, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Huge2",                C.font.normal, 24)
	SetFont("SystemFont_Shadow_Huge2",         C.font.normal, 24, "OUTLINE", nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Huge3",         C.font.normal, 25, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Outline_Huge3", C.font.normal, 25, "OUTLINE", nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_World",                C.font.normal, 64, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_World_ThickOutline",   C.font.normal, 64, "THICKOUTLINE", nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Outline_Huge2", C.font.normal, 22, "OUTLINE", nil, {0, 0, 0}, 2, -2)
	SetFont("SystemFont_Med1",                 C.font.normal, 12)
	SetFont("SystemFont_WTF2",                 C.font.normal, 36)
	SetFont("SystemFont_Outline_WTF2",         C.font.normal, 36, "OUTLINE")
	SetFont("GameTooltipHeader",        C.font.normal, 13)
	SetFont("System_IME",                      C.font.normal, 16)
	SetFont("NumberFont_Shadow_Tiny",          C.font.chat, 10, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Shadow_Small",         C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Shadow_Med",           C.font.chat, 14, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("Tooltip_Med",       C.font.normal, 12)
	SetFont("Tooltip_Small",     C.font.normal, 12)


	-- Fonts
	SetFont("SystemFont_Outline_Small",       C.font.normal, 10, "OUTLINE")
	SetFont("SystemFont_Outline",             C.font.normal, 13, "OUTLINE")
	SetFont("SystemFont_InverseShadow_Small", C.font.normal, 10, nil, nil, {.5, .5, .5}, 1, -1)
	SetFont("SystemFont_Huge1",               C.font.normal, 20)
	SetFont("SystemFont_Huge1_Outline",       C.font.normal, 20, "OUTLINE")
	SetFont("SystemFont_OutlineThick_Huge2",  C.font.normal, 22, "THICKOUTLINE")
	SetFont("SystemFont_OutlineThick_Huge4",  C.font.normal, 26, "THICKOUTLINE")
	SetFont("SystemFont_OutlineThick_WTF",    C.font.normal, 32, "THICKOUTLINE")

	SetFont("NumberFont_GameNormal",            C.font.normal, 10, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_OutlineThick_Mono_Small", C.font.chat, 12, "THICKOUTLINE, MONOCHROME")
	SetFont("NumberFont_Small",                   C.font.chat, 12)
	SetFont("NumberFont_Normal_Med",              C.font.chat, 12)
	SetFont("NumberFont_Outline_Med",             C.font.chat, 12, "OUTLINE")
	SetFont("NumberFont_Outline_Large",           C.font.chat, 14, "OUTLINE")
	SetFont("NumberFont_Outline_Huge",            C.font.damage, 30, "OUTLINE")

	SetFont("Fancy22Font",                  C.font.header, 22)
	SetFont("QuestFont_Shadow_Huge",        nil, nil, nil, nil, {.5, .5, .5}, 1, -1)
	SetFont("QuestFont_Outline_Huge",       C.font.header, 18, "OUTLINE")
	SetFont("QuestFont_Super_Huge",         C.font.header, 24, nil, nil)
	SetFont("QuestFont_Super_Huge_Outline", C.font.header, 24, "OUTLINE", nil)
	SetFont("SplashHeaderFont",             C.font.header, 24, nil, {.8, .8, .2}, {0, 0, 0}, 1, -2)

	SetFont("Game11Font", C.font.normal, 11)
	SetFont("Game12Font", C.font.normal, 12)
	SetFont("Game13Font", C.font.normal, 13)
	SetFont("Game13FontShadow", C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game15Font", C.font.normal, 15)
	SetFont("Game16Font", C.font.normal, 16)
	SetFont("Game18Font", C.font.normal, 18)
	SetFont("Game20Font", C.font.normal, 20)
	SetFont("Game24Font", C.font.normal, 24)
	SetFont("Game27Font", C.font.normal, 27)
	SetFont("Game30Font", C.font.normal, 30)
	SetFont("Game32Font", C.font.normal, 32)
	SetFont("Game36Font", C.font.normal, 36)
	SetFont("Game46Font", C.font.normal, 46)
	SetFont("Game48Font", C.font.normal, 48)
	SetFont("Game48FontShadow", C.font.normal, 48, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game60Font", C.font.normal, 60)
	SetFont("Game72Font", C.font.normal, 72)
	SetFont("Game120Font", C.font.normal, 120)

	SetFont("Game11Font_o1", C.font.normal, 11, "OUTLINE")
	SetFont("Game12Font_o1", C.font.normal, 12, "OUTLINE")
	SetFont("Game13Font_o1", C.font.normal, 13, "OUTLINE")
	SetFont("Game15Font_o1", C.font.normal, 15, "OUTLINE")

	SetFont("QuestFont_Enormous",     C.font.header, 30, nil, {.8, .8, .2})
	SetFont("DestinyFontMed",         C.font.header, 14, nil, {.25, .25, .25})
	SetFont("DestinyFontLarge",       C.font.header, 18, nil, {.25, .25, .25})
	SetFont("CoreAbilityFont",        C.font.header, 32, nil, {.25, .25, .25})
	SetFont("DestinyFontHuge",        C.font.header, 32, nil, {.25, .25, .25})
	SetFont("QuestFont_Shadow_Small", C.font.header, 14, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("MailFont_Large",    C.font.header, 15)
	SetFont("SpellFont_Small",   C.font.normal, 10)
	SetFont("InvoiceFont_Med",   C.font.normal, 12)
	SetFont("InvoiceFont_Small", C.font.normal, 10)

	SetFont("AchievementFont_Small", C.font.normal, 12)
	SetFont("ReputationDetailFont",  C.font.normal, 10, nil, {1, 1, 1}, {0, 0, 0}, 1, -1)
	SetFont("FriendsFont_Normal",    C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("FriendsFont_Small",     C.font.normal, 10, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("FriendsFont_Large",     C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("FriendsFont_UserText",  C.font.normal, 11, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GameFont_Gigantic",     C.font.normal, 32, nil, {.8, .8, .2}, {0, 0, 0}, 1, -1)

	SetFont("ChatBubbleFont", C.font.normal, 13)
	SetFont("Fancy12Font",    C.font.header, 12)
	SetFont("Fancy14Font",    C.font.header, 14)
	SetFont("Fancy16Font",    C.font.header, 16)
	SetFont("Fancy18Font",    C.font.header, 18)
	SetFont("Fancy20Font",    C.font.header, 20)
	SetFont("Fancy24Font",    C.font.header, 24)
	SetFont("Fancy27Font",    C.font.header, 27)
	SetFont("Fancy30Font",    C.font.header, 30)
	SetFont("Fancy32Font",    C.font.header, 32)
	SetFont("Fancy48Font",    C.font.header, 48)

	SetFont("SystemFont_NamePlateFixed",      C.font.normal, 14)
	SetFont("SystemFont_LargeNamePlateFixed", C.font.normal, 20)
	SetFont("SystemFont_NamePlate",           C.font.normal, 9)
	SetFont("SystemFont_LargeNamePlate",      C.font.normal, 12)
	SetFont("SystemFont_NamePlateCastBar",    C.font.normal, 10)


	--
	SetFont("AchievementFont_Small", C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("AchievementPointsFont", C.font.normal, 11, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("ZoneTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SubZoneTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("WorldMapTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("ChatFontNormal", C.font.chat, 14, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("QuestInfoDescriptionText", C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GossipGreetingText", C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("ErrorFont", C.font.normal, 13, nil, nil, {0, 0, 0}, 2, -2)
	

	-- Text color
	_G.QuestTitleFont:SetTextColor(1, 1, 1)
	_G.QuestFont:SetTextColor(1, 1, 1)
	_G.MailTextFontNormal:SetTextColor(1, 1, 1)
	_G.InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	_G.InvoiceTextFontSmall:SetTextColor(1, 1, 1)


	local function ReskinFont(font, size, white)
		font:SetFont(C.font.normal, size, white and "" or nil)
		font:SetTextColor(247/255, 225/255, 171/255)
		font:SetShadowColor(0, 0, 0, 0)
		font:SetShadowOffset(2, -2)
	end

	-- Refont Titles Panel
	hooksecurefunc("PaperDollTitlesPane_UpdateScrollFrame", function()
		local bu = PaperDollTitlesPane.buttons
		for i = 1, #bu do
			if not bu[i].fontStyled then
				ReskinFont(bu[i].text, 12)
				bu[i].fontStyled = true
			end
		end
	end)

	-- WhoFrame LevelText
	hooksecurefunc("WhoList_Update", function()
		for i = 1, WHOS_TO_DISPLAY, 1 do
			local level = _G["WhoFrameButton"..i.."Level"]
			if level and not level.fontStyled then
				level:SetWidth(32)
				level:SetJustifyH("LEFT")
				level.fontStyled = true
			end
		end
	end)

	local coloredFonts = {
		"GameFontNormal",
		"GameFontNormalOutline",
		"GameFontNormal_NoShadow",
		"GameFontNormalHuge",
		"GameFontNormalHugeOutline",
		"GameFontNormalHugeOutline2",
		"GameFontNormalHuge2",
		"GameFontNormalHuge3",
		"GameFontNormalHuge3Outline",
		"GameFontNormalShadowHuge2",

		"GameFontNormalSmall",
		"GameFontNormalSmall2",
		"GameFontNormalTiny",
		"GameFontNormalTiny2",

		"GameFontNormalMed1",
		"GameFontNormalMed2",
		"GameFontNormalMed3",

		"GameFontNormalLarge",
		"GameFontNormalLarge2",
		"GameFontNormalLargeOutline",
		
		"GameFontNormalWTF2",
		"GameFontNormalWTF2Outline",

		"IMEHighlight",

		"GameFont_Gigantic",

		"GameNormalNumberFont",
		"NumberFontNormalRightYellow",
		"NumberFontNormalYellow",
		"NumberFontNormalLargeRightYellow",
		"NumberFontNormalLargeYellow",

		"CombatTextFont",
		"CombatTextFontOutline",
		
		"BossEmoteNormalHuge",
		
		"DialogButtonNormalText",

		"AchievementPointsFont",
		"AchievementPointsFontSmall",
		"AchievementDateFont",

		"FocusFontSmall",

		"ArtifactAppearanceSetNormalFont",
	}
	for k, v in next, coloredFonts do
		_G[v]:SetTextColor(247/255, 225/255, 171/255)
	end
end






