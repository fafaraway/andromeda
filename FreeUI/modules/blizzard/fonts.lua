local F, C = unpack(select(2, ...))

if C.isDeveloper and C.Client == 'zhCN' then
	C.Assets.Fonts.Regular = 'Fonts\\FreeUI\\regular.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\FreeUI\\condensed.otf'
	C.Assets.Fonts.Bold = 'Fonts\\FreeUI\\bold.ttf'
	C.Assets.Fonts.Header = 'Fonts\\FreeUI\\header.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\FreeUI\\combat.ttf'
elseif C.Client == 'zhCN' then
	C.Assets.Fonts.Regular = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\ARHei.ttf'
	C.Assets.Fonts.Header = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\ARKai_C.ttf'
elseif C.Client == 'zhTW' then
	C.Assets.Fonts.Regular = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Header = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\bKAI00M.ttf'
elseif C.Client == 'koKR' then
	C.Assets.Fonts.Regular = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\2002B.ttf'
	C.Assets.Fonts.Header = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\K_Damage.ttf'
elseif C.Client == 'ruRU' then
	C.Assets.Fonts.Regular = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Condensed = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Bold = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Header = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\FRIZQT___CYR.ttf'
end

local NORMAL = C.Assets.Fonts.Regular
local BOLD = C.Assets.Fonts.Bold
local HEADER = C.Assets.Fonts.Header
local COMBAT = C.Assets.Fonts.Combat

local function SetFont(obj, font, size, flag, shadow)
	local oldFont, oldSize, _ = obj:GetFont()

	font = font or oldFont
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
loader:SetScript(
	'OnEvent',
	function(self, _, addon)
		if addon ~= 'FreeUI' then
			return
		end

		_G.STANDARD_TEXT_FONT = C.Assets.Fonts.Regular
		_G.UNIT_NAME_FONT = C.Assets.Fonts.Header
		_G.DAMAGE_TEXT_FONT = C.Assets.Fonts.Combat

		SetFont(_G.SystemFont_Outline_Small, NORMAL, 12)
		SetFont(_G.SystemFont_Outline, NORMAL, 13)
		SetFont(_G.SystemFont_InverseShadow_Small, NORMAL, 10)
		SetFont(_G.SystemFont_Huge1, NORMAL, 20)
		SetFont(_G.SystemFont_Huge1_Outline, NORMAL, 20)
		SetFont(_G.SystemFont_OutlineThick_Huge2, HEADER, 22)
		SetFont(_G.SystemFont_OutlineThick_Huge4, HEADER, 26)
		SetFont(_G.SystemFont_OutlineThick_WTF, HEADER, 32)
		SetFont(_G.SystemFont_Tiny2, NORMAL, 8)
		SetFont(_G.SystemFont_Tiny, NORMAL, 9)
		SetFont(_G.SystemFont_Shadow_Small, NORMAL, 12)
		SetFont(_G.SystemFont_Small, NORMAL, 12)
		SetFont(_G.SystemFont_Small2, NORMAL, 13)
		SetFont(_G.SystemFont_Shadow_Small2, NORMAL, 13)
		SetFont(_G.SystemFont_Shadow_Med1_Outline, NORMAL, 12)
		SetFont(_G.SystemFont_Shadow_Med1, NORMAL, 12)
		SetFont(_G.SystemFont_Med2, NORMAL, 13)
		SetFont(_G.SystemFont_Med3, NORMAL, 14)
		SetFont(_G.SystemFont_Shadow_Med3, NORMAL, 14)
		SetFont(_G.SystemFont_Shadow_Med3_Outline, NORMAL, 14)
		SetFont(_G.SystemFont_Large, NORMAL, 14)
		SetFont(_G.SystemFont_Shadow_Large_Outline, NORMAL, 17)
		SetFont(_G.SystemFont_Shadow_Med2, NORMAL, 16)
		SetFont(_G.SystemFont_Shadow_Med2_Outline, NORMAL, 16)
		SetFont(_G.SystemFont_Shadow_Large, NORMAL, 17)
		SetFont(_G.SystemFont_Shadow_Large2, NORMAL, 19)
		SetFont(_G.SystemFont_Shadow_Huge1, NORMAL, 20)
		SetFont(_G.SystemFont_Huge2, HEADER, 24)
		SetFont(_G.SystemFont_Shadow_Huge2, HEADER, 24)
		SetFont(_G.SystemFont_Shadow_Huge2_Outline, HEADER, 24)
		SetFont(_G.SystemFont_Shadow_Huge3, HEADER, 25)
		SetFont(_G.SystemFont_Shadow_Outline_Huge3, HEADER, 25)
		SetFont(_G.SystemFont_Huge4, HEADER, 27)
		SetFont(_G.SystemFont_Shadow_Huge4, HEADER, 27)
		SetFont(_G.SystemFont_Shadow_Huge4_Outline, HEADER, 27)
		SetFont(_G.SystemFont_World, HEADER, 64)
		SetFont(_G.SystemFont_World_ThickOutline, HEADER, 64)
		SetFont(_G.SystemFont22_Outline, HEADER, 22)
		SetFont(_G.SystemFont22_Shadow_Outline, HEADER, 22)
		SetFont(_G.SystemFont_Med1, NORMAL, 13)
		SetFont(_G.SystemFont_WTF2, HEADER, 64)
		SetFont(_G.SystemFont_Outline_WTF2, HEADER, 64)
		SetFont(_G.System15Font, NORMAL, 15)

		SetFont(_G.Game11Font, NORMAL, 11)
		SetFont(_G.Game12Font, NORMAL, 12)
		SetFont(_G.Game13Font, NORMAL, 13)
		SetFont(_G.Game13FontShadow, NORMAL, 13)
		SetFont(_G.Game15Font, NORMAL, 15)
		SetFont(_G.Game16Font, NORMAL, 16)
		SetFont(_G.Game17Font_Shadow, NORMAL, 17)
		SetFont(_G.Game18Font, NORMAL, 18)
		SetFont(_G.Game20Font, NORMAL, 20)
		SetFont(_G.Game24Font, HEADER, 24)
		SetFont(_G.Game27Font, HEADER, 27)
		SetFont(_G.Game30Font, HEADER, 30)
		SetFont(_G.Game32Font, HEADER, 32)
		SetFont(_G.Game36Font, HEADER, 36)
		SetFont(_G.Game40Font, HEADER, 40)
		SetFont(_G.Game40Font_Shadow2, HEADER, 40)
		SetFont(_G.Game42Font, HEADER, 42)
		SetFont(_G.Game46Font, HEADER, 46)
		SetFont(_G.Game48Font, HEADER, 48)
		SetFont(_G.Game48FontShadow, HEADER, 48)
		SetFont(_G.Game52Font_Shadow2, HEADER, 52)
		SetFont(_G.Game58Font_Shadow2, HEADER, 58)
		SetFont(_G.Game60Font, HEADER, 60)
		SetFont(_G.Game69Font_Shadow2, HEADER, 69)
		SetFont(_G.Game72Font, HEADER, 72)
		SetFont(_G.Game72Font_Shadow, HEADER, 72)
		SetFont(_G.Game120Font, HEADER, 120)
		SetFont(_G.Game10Font_o1, NORMAL, 10)
		SetFont(_G.Game11Font_o1, NORMAL, 11)
		SetFont(_G.Game12Font_o1, NORMAL, 12)
		SetFont(_G.Game13Font_o1, NORMAL, 13)
		SetFont(_G.Game15Font_o1, NORMAL, 15)

		SetFont(_G.Fancy12Font, NORMAL, 12)
		SetFont(_G.Fancy14Font, NORMAL, 14)
		SetFont(_G.Fancy16Font, NORMAL, 16)
		SetFont(_G.Fancy18Font, NORMAL, 18)
		SetFont(_G.Fancy20Font, NORMAL, 20)
		SetFont(_G.Fancy22Font, NORMAL, 22)
		SetFont(_G.Fancy24Font, HEADER, 24)
		SetFont(_G.Fancy27Font, HEADER, 27)
		SetFont(_G.Fancy30Font, HEADER, 30)
		SetFont(_G.Fancy32Font, HEADER, 32)
		SetFont(_G.Fancy48Font, HEADER, 48)

		SetFont(_G.NumberFont_GameNormal, NORMAL, 12, 'OUTLINE')
		SetFont(_G.NumberFont_OutlineThick_Mono_Small, NORMAL, 11, 'OUTLINE')
		SetFont(_G.Number12Font_o1, NORMAL, 11, 'OUTLINE')
		SetFont(_G.NumberFont_Small, NORMAL, 11, 'OUTLINE')
		SetFont(_G.Number11Font, NORMAL, 10, 'OUTLINE')
		SetFont(_G.Number12Font, NORMAL, 11, 'OUTLINE')
		SetFont(_G.Number13Font, NORMAL, 12, 'OUTLINE')
		SetFont(_G.Number15Font, NORMAL, 14, 'OUTLINE')
		SetFont(_G.Number16Font, NORMAL, 15, 'OUTLINE')
		SetFont(_G.Number18Font, NORMAL, 17, 'OUTLINE')
		SetFont(_G.NumberFont_Normal_Med, NORMAL, 13, 'OUTLINE')
		SetFont(_G.NumberFont_Outline_Med, NORMAL, 13, 'OUTLINE')
		SetFont(_G.NumberFont_Outline_Large, NORMAL, 16, 'OUTLINE')
		SetFont(_G.NumberFont_Outline_Huge, NORMAL, 20, 'OUTLINE')
		SetFont(_G.NumberFont_Shadow_Tiny, NORMAL, 10, 'OUTLINE')
		SetFont(_G.NumberFont_Shadow_Small, NORMAL, 12, 'OUTLINE')
		SetFont(_G.NumberFont_Shadow_Med, NORMAL, 14, 'OUTLINE')
		SetFont(_G.NumberFont_Shadow_Large, NORMAL, 20, 'OUTLINE')
		SetFont(_G.PriceFont, NORMAL, 14)
		SetFont(_G.NumberFontNormalLargeRight, NORMAL, 14)

		SetFont(_G.SplashHeaderFont, HEADER, 24)

		SetFont(_G.QuestFont_Outline_Huge, NORMAL, 14)
		SetFont(_G.QuestFont_Super_Huge, HEADER, 22)
		SetFont(_G.QuestFont_Super_Huge_Outline, HEADER, 22)
		SetFont(_G.QuestFont_Large, NORMAL, 15)
		SetFont(_G.QuestFont_Huge, NORMAL, 17)
		SetFont(_G.QuestFont_30, HEADER, 29)
		SetFont(_G.QuestFont_39, HEADER, 38)
		SetFont(_G.QuestFont_Enormous, HEADER, 30)
		SetFont(_G.QuestFont_Shadow_Small, NORMAL, 12)

		--QuestFont_Shadow_Huge
		--QuestFont_Shadow_Super_Huge
		--QuestFont_Shadow_Enormous

		SetFont(_G.GameFont_Gigantic, HEADER, 28)

		SetFont(_G.DestinyFontMed, NORMAL, 14)
		SetFont(_G.DestinyFontLarge, NORMAL, 18)
		SetFont(_G.CoreAbilityFont, HEADER, 28)
		SetFont(_G.DestinyFontHuge, HEADER, 28)

		SetFont(_G.SpellFont_Small, NORMAL, 12)

		SetFont(_G.MailFont_Large, NORMAL, 15)

		SetFont(_G.InvoiceFont_Med, NORMAL, 12)
		SetFont(_G.InvoiceFont_Small, NORMAL, 10)

		SetFont(_G.AchievementFont_Small, NORMAL, 10)
		SetFont(_G.ReputationDetailFont, NORMAL, 12)

		SetFont(_G.FriendsFont_Normal, NORMAL, 13)
		SetFont(_G.FriendsFont_11, NORMAL, 12)
		SetFont(_G.FriendsFont_Small, NORMAL, 12)
		SetFont(_G.FriendsFont_Large, NORMAL, 15)
		SetFont(_G.FriendsFont_UserText, NORMAL, 11)

		SetFont(_G.ChatBubbleFont, BOLD, 16, nil, 'THICK')
		--ChatFontNormal
		--ChatFontSmall

		SetFont(_G.GameTooltipHeader, BOLD, 16)
		SetFont(_G.Tooltip_Med, NORMAL, 14)
		SetFont(_G.Tooltip_Small, NORMAL, 12)

		SetFont(_G.System_IME, BOLD, 16)

		SetFont(_G.SystemFont_NamePlateFixed, NORMAL, 14)
		SetFont(_G.SystemFont_LargeNamePlateFixed, NORMAL, 20)
		SetFont(_G.SystemFont_NamePlate, NORMAL, 9)
		SetFont(_G.SystemFont_LargeNamePlate, NORMAL, 12)
		SetFont(_G.SystemFont_NamePlateCastBar, NORMAL, 10)

		SetFont(_G.ZoneTextFont, HEADER, 40, nil, 'THICK')
		SetFont(_G.SubZoneTextFont, HEADER, 40, nil, 'THICK')
		SetFont(_G.WorldMapTextFont, HEADER, 40, nil, 'THICK')
		SetFont(_G.PVPInfoTextFont, HEADER, 40, nil, 'THICK')

		SetFont(_G.ErrorFont, BOLD, 14, nil, 'THICK')
		SetFont(_G.CombatTextFont, COMBAT, 200, 'THINOUTLINE')

		SetFont(_G.RaidWarningFrame.slot1, BOLD, 20, nil, 'THICK')
		SetFont(_G.RaidWarningFrame.slot2, BOLD, 20, nil, 'THICK')
		SetFont(_G.RaidBossEmoteFrame.slot1, BOLD, 20, nil, 'THICK')
		SetFont(_G.RaidBossEmoteFrame.slot2, BOLD, 20, nil, 'THICK')

		SetFont(_G.GameFontNormal, NORMAL, 13)
		SetFont(_G.QuestFont, NORMAL, 15)

		-- Registering fonts in LibSharedMedia
		local LSM = LibStub and LibStub:GetLibrary('LibSharedMedia-3.0', true)

		local LOCALE_MASK = 0
		if C.Client == 'koKR' then
			LOCALE_MASK = 1
		elseif C.Client == 'ruRU' then
			LOCALE_MASK = 2
		elseif C.Client == 'zhCN' then
			LOCALE_MASK = 4
		elseif C.Client == 'zhTW' then
			LOCALE_MASK = 8
		else
			LOCALE_MASK = 128
		end

		if LSM then
			LSM:Register(LSM.MediaType.FONT, '!Free_Regular', C.Assets.Fonts.Regular, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Condensed', C.Assets.Fonts.Condensed, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Bold', C.Assets.Fonts.Bold, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Header', C.Assets.Fonts.Header, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Combat', C.Assets.Fonts.Combat, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Pixel', C.Assets.Fonts.Pixel, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Cooldown', C.Assets.Fonts.Square, LOCALE_MASK)
			LSM:Register(LSM.MediaType.FONT, '!Free_Roadway', C.Assets.Fonts.Roadway, LOCALE_MASK)

			LSM:Register(LSM.MediaType.STATUSBAR, '!Free_Normal', C.Assets.norm_tex)
			LSM:Register(LSM.MediaType.STATUSBAR, '!Free_Gradient', C.Assets.grad_tex)
			LSM:Register(LSM.MediaType.STATUSBAR, '!Free_Flat', C.Assets.flat_tex)

			LSM:Register(LSM.MediaType.SOUND, '!Free_1', C.AssetsPath .. 'sounds\\ding.ogg')
			LSM:Register(LSM.MediaType.SOUND, '!Free_2', C.AssetsPath .. 'sounds\\proc.ogg')
			LSM:Register(LSM.MediaType.SOUND, '!Free_3', C.AssetsPath .. 'sounds\\warning.ogg')
			LSM:Register(LSM.MediaType.SOUND, '!Free_4', C.AssetsPath .. 'sounds\\execute.ogg')
			LSM:Register(LSM.MediaType.SOUND, '!Free_5', C.AssetsPath .. 'sounds\\health.ogg')
		end

		self:SetScript('OnEvent', nil)
		self:UnregisterAllEvents()
	end
)
