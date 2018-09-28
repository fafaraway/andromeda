local F, C, L = unpack(select(2, ...))
local module = F:GetModule("blizzard")


function module:FontStyle()
	if not C.appearance.fontStyle then return end

	local next, type = _G.next, _G.type
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

	SetFont("SystemFont_Shadow_Small", C.font.normal, 11, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Small", C.font.normal, 11)

	SetFont("System_IME", C.font.normal, 16)

	SetFont("ZoneTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SubZoneTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("WorldMapTextFont", C.font.header, 40, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("GameFontNormal", C.font.normal, 12)
	SetFont("GameFontNormalSmall", C.font.normal, 12)
	SetFont("GameFontNormalLarge", C.font.normal, 16)

	SetFont("FriendsFont_Normal", C.font.normal, 13)
	SetFont("FriendsFont_Small", C.font.normal, 12)

	SetFont("AchievementFont_Small", C.font.normal, 12)
	SetFont("AchievementPointsFont", C.font.normal, 12)

	SetFont("GameTooltipHeaderText", C.font.normal, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GameTooltipText", C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GameTooltipTextSmall", C.font.normal, 13, nil, nil, {0, 0, 0}, 1, -1)

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
	for k, yellowFont in next, coloredFonts do
		_G[yellowFont]:SetTextColor(247/255, 225/255, 171/255)
	end
end






