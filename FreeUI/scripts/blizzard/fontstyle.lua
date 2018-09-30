local F, C, L = unpack(select(2, ...))
if not C.appearance.fontStyle then return end

local module = F:GetModule("blizzard")

-- Regular text: replaces FRIZQT__.TTF
local NORMAL = C.font.normal

-- Chat Font: replaces ARIALN.TTF
local CHAT   = C.font.chat

-- Crit Font: replaces skurri.ttf
local CRIT   = C.font.damage

local UNITNAME   = C.font.unitname

-- Header Font: replaces MORPHEUS.ttf
local HEADER = C.font.header



function module:FontStyle()
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

	SetFont("SystemFont_Shadow_Small",         NORMAL, 11, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SystemFont_Small",                NORMAL, 11)

	SetFont("System_IME", NORMAL, 16)

	SetFont("ZoneTextFont", HEADER, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("SubZoneTextFont", HEADER, 40, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("WorldMapTextFont", HEADER, 40, nil, nil, {0, 0, 0}, 1, -1)

	SetFont("GameFontNormal", NORMAL, 12)
	SetFont("GameFontNormalSmall", NORMAL, 12)
	SetFont("GameFontNormalLarge", NORMAL, 16)

	SetFont("FriendsFont_Normal", NORMAL, 13)
	SetFont("FriendsFont_Small", NORMAL, 12)

	SetFont("AchievementFont_Small", NORMAL, 12)
	SetFont("AchievementPointsFont", NORMAL, 12)

	SetFont("GameTooltipHeaderText", NORMAL, 14, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GameTooltipText", NORMAL, 13, nil, nil, {0, 0, 0}, 1, -1)
	SetFont("GameTooltipTextSmall", NORMAL, 13, nil, nil, {0, 0, 0}, 1, -1)

	local function ReskinFont(font, size, white)
		font:SetFont(NORMAL, size, white and "" or nil)
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






