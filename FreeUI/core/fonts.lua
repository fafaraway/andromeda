local F, C = unpack(select(2, ...))


if C.isDeveloper then
	C.Assets.Fonts.Regular = 'Fonts\\FreeUI\\regular.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\FreeUI\\condensed.otf'
	C.Assets.Fonts.Bold = 'Fonts\\FreeUI\\bold.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\FreeUI\\sarasa-ui-cl-bold.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\FreeUI\\combat.ttf'
elseif C.Client == 'zhCN' then
	C.Assets.Fonts.Regular = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\ARKai_C.ttf'
elseif C.Client == 'zhTW' then
	C.Assets.Fonts.Regular = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\bKAI00M.ttf'
elseif C.Client == 'koKR' then
	C.Assets.Fonts.Regular = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\2002B.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\K_Damage.ttf'
elseif C.Client == 'ruRU' then
	C.Assets.Fonts.Regular = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\FRIZQT___CYR.ttf'
end

local NORMAL = C.Assets.Fonts.Regular
local HEADER = C.Assets.Fonts.Bold
local CHAT = C.Assets.Fonts.Chat
local COMBAT = C.Assets.Fonts.Combat

local function SetFont(obj, size, font, flag, shadow)
	local _, oldSize, _ = obj:GetFont()

	font = font or NORMAL
	size = size or oldSize
	flag = flag and 'OUTLINE' or nil

	obj:SetFont(font, size, flag)

	if type(shadow) == 'string' and shadow == 'THICK' then
		obj:SetShadowColor(0, 0, 0, 1)
		obj:SetShadowOffset(2, -2)
	elseif type(shadow) == 'table' then
		obj:SetShadowColor(shadow[1], shadow[2], shadow[3], shadow[4])
		obj:SetShadowOffset(shadow[5], shadow[6])
	elseif flag == 'OUTLINE' or flag == 'THINOUTLINE' then
		obj:SetShadowColor(0, 0, 0, 0)
	else
		obj:SetShadowColor(0, 0, 0, 1)
	end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, addon)
	if addon ~= 'FreeUI' then return end

	_G.STANDARD_TEXT_FONT = C.Assets.Fonts.Regular
	_G.UNIT_NAME_FONT     = C.Assets.Fonts.Bold
	_G.DAMAGE_TEXT_FONT   = C.Assets.Fonts.Combat

	SetFont(_G.RaidWarningFrame.slot1, 20, NORMAL, nil, 'THICK')
	SetFont(_G.RaidWarningFrame.slot2, 20, NORMAL, nil, 'THICK')
	SetFont(_G.RaidBossEmoteFrame.slot1, 20, NORMAL, nil, 'THICK')
	SetFont(_G.RaidBossEmoteFrame.slot2, 20, NORMAL, nil, 'THICK')
	SetFont(_G.AchievementFont_Small, 11)
	SetFont(_G.AchievementCriteriaFont)
	SetFont(_G.AchievementDescriptionFont)
	SetFont(_G.CoreAbilityFont)
	SetFont(_G.DestinyFontMed)
	SetFont(_G.DestinyFontHuge, 30, HEADER, nil, 'THICK')
	SetFont(_G.DestinyFontLarge)
	SetFont(_G.FriendsFont_Normal)
	SetFont(_G.FriendsFont_Small)
	SetFont(_G.FriendsFont_Large)
	SetFont(_G.FriendsFont_UserText)
	SetFont(_G.FriendsFont_11)
	SetFont(_G.GameFont_Gigantic, 30, HEADER, nil, 'THICK')
	SetFont(_G.InvoiceFont_Small)
	SetFont(_G.InvoiceFont_Med)
	SetFont(_G.MailFont_Large)

	SetFont(_G.NumberFont_Small, 11, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_GameNormal, 11, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_Normal_Med, 12, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_Shadow_Tiny, 10, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_OutlineThick_Mono_Small, 11, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_Outline_Med, 12, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_Outline_Large, 14, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_Shadow_Med, 12, NORMAL, 'OUTLINE')
	SetFont(_G.NumberFont_Shadow_Small, 11, NORMAL, 'OUTLINE')
	SetFont(_G.Number12Font, 12, NORMAL, 'OUTLINE')
	SetFont(_G.Number13FontYellow, 13, NORMAL, 'OUTLINE')
	SetFont(_G.Number13FontWhite, 13, NORMAL, 'OUTLINE')
	SetFont(_G.Number13FontGray, 13, NORMAL, 'OUTLINE')
	SetFont(_G.Number14FontWhite, 14, NORMAL, 'OUTLINE')
	SetFont(_G.Number15FontWhite, 15, NORMAL, 'OUTLINE')
	SetFont(_G.Number18FontWhite, 18, NORMAL, 'OUTLINE')

	SetFont(_G.QuestFont_Shadow_Small)
	SetFont(_G.QuestFont_Large)
	SetFont(_G.QuestFont_Shadow_Huge)
	SetFont(_G.QuestFont_Huge)
	SetFont(_G.QuestFont_Super_Huge)
	SetFont(_G.QuestFont_Enormous)
	SetFont(_G.ReputationDetailFont)
	SetFont(_G.SpellFont_Small)
	SetFont(_G.SystemFont_InverseShadow_Small)
	SetFont(_G.SystemFont_Large)
	SetFont(_G.SystemFont_Huge1)
	SetFont(_G.SystemFont_Huge2)
	SetFont(_G.SystemFont_Med1)
	SetFont(_G.SystemFont_Med2)
	SetFont(_G.SystemFont_Med3)
	SetFont(_G.SystemFont_OutlineThick_WTF)
	SetFont(_G.SystemFont_OutlineThick_Huge2)
	SetFont(_G.SystemFont_OutlineThick_Huge4)
	SetFont(_G.SystemFont_Outline_Small)
	SetFont(_G.SystemFont_Outline)
	SetFont(_G.SystemFont_Shadow_Large)
	SetFont(_G.SystemFont_Shadow_Large_Outline)
	SetFont(_G.SystemFont_Shadow_Large2)
	SetFont(_G.SystemFont_Shadow_Med1, 12)
	SetFont(_G.SystemFont_Shadow_Med1_Outline, 12)
	SetFont(_G.SystemFont_Shadow_Med2)
	SetFont(_G.SystemFont_Shadow_Med3)

	SetFont(_G.SystemFont_Shadow_Huge1)
	SetFont(_G.SystemFont_Shadow_Huge2)
	SetFont(_G.SystemFont_Shadow_Huge3)
	SetFont(_G.SystemFont_Shadow_Small, 12)
	SetFont(_G.SystemFont_Shadow_Small2)
	SetFont(_G.SystemFont_Small, 12)
	SetFont(_G.SystemFont_Small2)
	SetFont(_G.SystemFont_Tiny)
	SetFont(_G.SystemFont_Tiny2)
	SetFont(_G.SystemFont_NamePlate, 12)
	SetFont(_G.SystemFont_LargeNamePlate, 12)
	SetFont(_G.SystemFont_NamePlateFixed, 12)
	SetFont(_G.SystemFont_LargeNamePlateFixed, 12)
	SetFont(_G.SystemFont_World, 64, HEADER)
	SetFont(_G.SystemFont_World_ThickOutline, 64, HEADER)
	SetFont(_G.SystemFont_WTF2, 64, HEADER)
	SetFont(_G.HelpFrameKnowledgebaseNavBarHomeButtonText)
	SetFont(_G.Game11Font)
	SetFont(_G.Game12Font)
	SetFont(_G.Game13Font)
	SetFont(_G.Game13FontShadow)
	SetFont(_G.Game15Font)
	SetFont(_G.Game16Font)
	SetFont(_G.Game18Font)
	SetFont(_G.Game20Font)
	SetFont(_G.Game24Font)
	SetFont(_G.Game27Font)
	SetFont(_G.Game30Font)
	SetFont(_G.Game32Font)
	SetFont(_G.Game36Font)
	SetFont(_G.Game42Font)
	SetFont(_G.Game46Font)
	SetFont(_G.Game48Font)
	SetFont(_G.Game48FontShadow)
	SetFont(_G.Game60Font)
	SetFont(_G.Game72Font)
	SetFont(_G.Game120Font)
	SetFont(_G.System_IME)
	SetFont(_G.Fancy12Font)
	SetFont(_G.Fancy14Font)
	SetFont(_G.Fancy16Font)
	SetFont(_G.Fancy18Font)
	SetFont(_G.Fancy20Font)
	SetFont(_G.Fancy22Font)
	SetFont(_G.Fancy24Font)
	SetFont(_G.Fancy27Font)
	SetFont(_G.Fancy30Font)
	SetFont(_G.Fancy32Font)
	SetFont(_G.Fancy48Font)
	SetFont(_G.SplashHeaderFont)
	SetFont(_G.ChatBubbleFont, 15, CHAT, nil, true)
	SetFont(_G.GameFontNormalHuge2)
	SetFont(_G.PriceFont)
	SetFont(_G.PriceFontWhite)
	SetFont(_G.PriceFontGray)
	SetFont(_G.PriceFontGreen)
	SetFont(_G.PriceFontRed)

	SetFont(_G.ZoneTextFont, 40, HEADER, nil, 'THICK')
	SetFont(_G.SubZoneTextFont, 40, HEADER, nil, 'THICK')
	SetFont(_G.WorldMapTextFont, 40, HEADER, nil, 'THICK')
	SetFont(_G.PVPInfoTextFont, 40, HEADER, nil, 'THICK')

	SetFont(_G.ErrorFont, 14, NORMAL, nil, 'THICK')
	SetFont(_G.CombatTextFont, 150, COMBAT, 'THINOUTLINE')


	-- _G.GameFontBlackMedium:SetTextColor(1, 1, 1)
	-- _G.CoreAbilityFont:SetTextColor(1, 1, 1)

	-- _G.NORMAL_QUEST_DISPLAY = gsub(NORMAL_QUEST_DISPLAY, '000000', 'ffffff')
	-- _G.TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, '000000', 'ffffff')
	-- _G.IGNORED_QUEST_DISPLAY = gsub(IGNORED_QUEST_DISPLAY, '000000', 'ffffff')

	self:SetScript('OnEvent', nil)
	self:UnregisterAllEvents()
end)
