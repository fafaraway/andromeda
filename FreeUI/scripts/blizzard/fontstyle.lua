local F, C, L = unpack(select(2, ...))
local module = F:GetModule("blizzard")

_G.STANDARD_TEXT_FONT = C.font.normal
_G.UNIT_NAME_FONT = C.font.header
_G.DAMAGE_TEXT_FONT = C.font.damage

function module:FontStyle()
	if not C.appearance.fontStyle then return end

	local function SetFont(fontObj, fontPath, fontSize, fontStyle, fontColor, shadowColor, shadowX, shadowY)
		if type(fontObj) == "string" then fontObj = _G[fontObj] end
		if not fontObj then return end
		fontObj:SetFont(fontPath, fontSize, fontStyle)
		if shadowColor then fontObj:SetShadowColor(shadowColor[1], shadowColor[2], shadowColor[3], shadowColor[4]) end
		if shadowX and shadowY then fontObj:SetShadowOffset(shadowX, shadowY) end
		if type(fontColor) == "table" then fontObj:SetTextColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4])
		elseif fontColor then fontObj:SetAlpha(fontColor) end
	end


	-- SharedFonts     
	SetFont("SystemFont_Tiny2",                C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Tiny",                 C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Small",         C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Small",                C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Small2",               C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Small2",        C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med1_Outline",  C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med1",          C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Med2",                 C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Med3",                 C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med3",          C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Large",                 C.font.header, 15, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Huge",                  C.font.header, 18, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Large",                C.font.normal, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Large_Outline", C.font.normal, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Med2",          C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Large",         C.font.normal, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Large2",        C.font.normal, 18, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Huge1",         C.font.normal, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Huge2",                C.font.normal, 24, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Huge2",         C.font.normal, 24, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Huge3",         C.font.normal, 25, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Outline_Huge3", C.font.normal, 25, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_World",                C.font.normal, 64, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_World_ThickOutline",   C.font.normal, 64, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Shadow_Outline_Huge2", C.font.normal, 22, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Med1",                 C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_WTF2",                 C.font.normal, 36, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Outline_WTF2",         C.font.normal, 36, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GameTooltipHeader",               C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("System_IME",                      C.font.normal, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Shadow_Tiny",          C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Shadow_Small",         C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Shadow_Med", C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Tooltip_Med",       C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Tooltip_Small", C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)


	-- Fonts
	SetFont("SystemFont_Outline_Small",       C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Outline",             C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_InverseShadow_Small", C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Huge1",               C.font.normal, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Huge1_Outline",       C.font.normal, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_OutlineThick_Huge2",  C.font.normal, 22, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_OutlineThick_Huge4",  C.font.normal, 26, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_OutlineThick_WTF",    C.font.normal, 32, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("NumberFont_GameNormal",            C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_OutlineThick_Mono_Small", C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Small",                   C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Normal_Med",              C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Outline_Med",             C.font.chat, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Outline_Large",           C.font.chat, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("NumberFont_Outline_Huge",            C.font.header, 30, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("Fancy22Font",                  C.font.header, 22, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Shadow_Huge",        C.font.normal, 18, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Outline_Huge",       C.font.header, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Super_Huge",         C.font.header, 24, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("QuestFont_Super_Huge_Outline", C.font.header, 24, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SplashHeaderFont",             C.font.header, 24, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("Game11Font", C.font.normal, 11, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game12Font", C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game13Font", C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game13FontShadow", C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game15Font", C.font.normal, 15, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game16Font", C.font.normal, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game18Font", C.font.normal, 18, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game20Font", C.font.normal, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game24Font", C.font.normal, 24, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game27Font", C.font.normal, 27, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game30Font", C.font.normal, 30, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game32Font", C.font.normal, 32, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game36Font", C.font.normal, 36, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game46Font", C.font.normal, 46, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game48Font", C.font.normal, 48, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game48FontShadow", C.font.normal, 48, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game60Font", C.font.normal, 60, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game72Font", C.font.normal, 72, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Game120Font", C.font.normal, 120, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("Game11Font_o1", C.font.normal, 11, "OUTLINE")
	SetFont("Game12Font_o1", C.font.normal, 12, "OUTLINE")
	SetFont("Game13Font_o1", C.font.normal, 13, "OUTLINE")
	SetFont("Game15Font_o1", C.font.normal, 15, "OUTLINE")

	SetFont("QuestFont_Enormous",     C.font.header, 30, nil, yellow)
	SetFont("DestinyFontMed",         C.font.header, 14, nil, grayDark)
	SetFont("DestinyFontLarge",       C.font.header, 18, nil, grayDark)
	SetFont("CoreAbilityFont",        C.font.header, 32, nil, grayDark)
	SetFont("DestinyFontHuge",        C.font.header, 32, nil, grayDark)
	SetFont("QuestFont_Shadow_Small", C.font.header, 14, nil, nil, black, 1, -1)

	SetFont("MailFont_Large",    C.font.header, 15, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SpellFont_Small",   C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("InvoiceFont_Med",   C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("InvoiceFont_Small", C.font.normal, 10, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("AchievementFont_Small", C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("ReputationDetailFont",  C.font.normal, 12, nil, white, black, 1, -1)
	SetFont("FriendsFont_Normal",    C.font.normal, 13, nil, nil, black, 1, -1)
	SetFont("FriendsFont_Small",     C.font.normal, 11, nil, nil, black, 1, -1)
	SetFont("FriendsFont_Large",     C.font.normal, 14, nil, nil, black, 1, -1)
	SetFont("FriendsFont_UserText",  C.font.normal, 12, nil, nil, black, 1, -1)
	SetFont("GameFont_Gigantic",     C.font.normal, 32, nil, yellow, black, 1, -1)

	SetFont("ChatBubbleFont", C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy12Font",    C.font.header, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy14Font",    C.font.header, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy16Font",    C.font.header, 16, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy18Font",    C.font.header, 18, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy20Font",    C.font.header, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy24Font",    C.font.header, 24, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy27Font",    C.font.header, 27, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy30Font",    C.font.header, 30, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy32Font",    C.font.header, 32, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("Fancy48Font",    C.font.header, 48, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("SystemFont_NamePlateFixed",      C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_LargeNamePlateFixed", C.font.normal, 20, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_NamePlate",           C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_LargeNamePlate",      C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_NamePlateCastBar", C.font.normal, 12, nil, nil, {0, 0, 0}, 1, -1)

	--
	SetFont("AchievementFont_Small", C.font.normal, 12)
	SetFont("AchievementPointsFont", C.font.normal, 12)

	SetFont("ZoneTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SubZoneTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("WorldMapTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)

	-- Text color
	GameFontBlackMedium:SetTextColor(1, 1, 1)
	CoreAbilityFont:SetTextColor(1, 1, 1)


	local function ReskinFont(font, size, white)
		font:SetFont(C.font.normal, size, white and "" or nil)
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
		"FocusFontSmall",
	}
	for k, v in next, coloredFonts do
		_G[v]:SetTextColor(247/255, 225/255, 171/255)
	end
end






