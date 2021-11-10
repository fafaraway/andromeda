local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))

do
    if C.IsDeveloper then
        C.Assets.Fonts.Regular = 'Fonts\\FreeUI\\regular.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\FreeUI\\condensed.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\FreeUI\\bold.ttf'
        C.Assets.Fonts.Header = 'Fonts\\FreeUI\\header.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\FreeUI\\combat.ttf'
    elseif GetLocale() == 'zhCN' then
        C.Assets.Fonts.Regular = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\ARHei.ttf'
        C.Assets.Fonts.Header = 'Fonts\\ARKai_T.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\ARKai_C.ttf'
    elseif GetLocale() == 'zhTW' then
        C.Assets.Fonts.Regular = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Header = 'Fonts\\blei00d.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\bKAI00M.ttf'
    elseif GetLocale() == 'koKR' then
        C.Assets.Fonts.Regular = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\2002B.ttf'
        C.Assets.Fonts.Header = 'Fonts\\2002.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\K_Damage.ttf'
    elseif GetLocale() == 'ruRU' then
        C.Assets.Fonts.Regular = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Condensed = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Bold = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Header = 'Fonts\\FRIZQT___CYR.ttf'
        C.Assets.Fonts.Combat = 'Fonts\\FRIZQT___CYR.ttf'
    end
end

local NORMAL = C.Assets.Fonts.Regular
local BOLD = C.Assets.Fonts.Bold
local HEADER = C.Assets.Fonts.Header
local COMBAT = C.Assets.Fonts.Combat

local function SetFont(obj, font, size, flag)
    if not font then
        if C.IsDeveloper then
            F:Debug('UNKNOWN FONT.')
        end
        return
    end

    local outline = _G.FREE_ADB.FontOutline

    local oldFont, oldSize, _ = obj:GetFont()

    font = font or oldFont
    size = size or oldSize
    -- flag = flag and 'OUTLINE' or nil

    if type(flag) == 'boolean' then
        obj:SetFont(font, size, 'OUTLINE')
        obj:SetShadowColor(0, 0, 0, 0)
    else
        obj:SetFont(font, size, outline and 'OUTLINE')
    end

    obj:SetShadowColor(0, 0, 0, outline and 0 or 1)
    obj:SetShadowOffset(1, -1)

    -- if type(shadow) == 'string' and shadow == 'THICK' then
    --     obj:SetShadowColor(0, 0, 0, 1)
    --     obj:SetShadowOffset(2, -2)
    -- elseif type(shadow) == 'table' then
    --     obj:SetShadowColor(shadow[1], shadow[2], shadow[3], shadow[4])
    --     obj:SetShadowOffset(shadow[5], shadow[6])
    -- elseif flag == 'OUTLINE' or flag == 'THINOUTLINE' then
    --     obj:SetShadowColor(0, 0, 0, 0)
    -- else
    --     obj:SetShadowColor(0, 0, 0, 1)
    -- end
end

local function ReskinBlizzFonts()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    _G.STANDARD_TEXT_FONT = C.Assets.Fonts.Regular
    _G.UNIT_NAME_FONT = C.Assets.Fonts.Header
    _G.DAMAGE_TEXT_FONT = C.Assets.Fonts.Combat

    SetFont(_G.SystemFont_Outline_Small, NORMAL, 12)
    SetFont(_G.SystemFont_Outline, NORMAL, 13)
    SetFont(_G.SystemFont_InverseShadow_Small, NORMAL, 10)
    SetFont(_G.SystemFont_Huge1, HEADER, 20)
    SetFont(_G.SystemFont_Huge1_Outline, HEADER, 20)
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
    SetFont(_G.SystemFont_Shadow_Huge1, HEADER, 20)
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
    SetFont(_G.Game20Font, HEADER, 20)
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
    SetFont(_G.Fancy20Font, HEADER, 20)
    SetFont(_G.Fancy22Font, HEADER, 22)
    SetFont(_G.Fancy24Font, HEADER, 24)
    SetFont(_G.Fancy27Font, HEADER, 27)
    SetFont(_G.Fancy30Font, HEADER, 30)
    SetFont(_G.Fancy32Font, HEADER, 32)
    SetFont(_G.Fancy48Font, HEADER, 48)

    SetFont(_G.NumberFont_GameNormal, NORMAL, 12, true)
    SetFont(_G.NumberFont_OutlineThick_Mono_Small, NORMAL, 11, true)
    SetFont(_G.Number12Font_o1, NORMAL, 11, true)
    SetFont(_G.NumberFont_Small, NORMAL, 11, true)
    SetFont(_G.Number11Font, NORMAL, 10, true)
    SetFont(_G.Number12Font, NORMAL, 11, true)
    SetFont(_G.Number13Font, NORMAL, 12, true)
    SetFont(_G.Number15Font, NORMAL, 14, true)
    SetFont(_G.Number16Font, NORMAL, 15, true)
    SetFont(_G.Number18Font, NORMAL, 17, true)
    SetFont(_G.NumberFont_Normal_Med, NORMAL, 13, true)
    SetFont(_G.NumberFont_Outline_Med, NORMAL, 13, true)
    SetFont(_G.NumberFont_Outline_Large, NORMAL, 16, true)
    SetFont(_G.NumberFont_Outline_Huge, HEADER, 20, true)
    SetFont(_G.NumberFont_Shadow_Tiny, NORMAL, 10, true)
    SetFont(_G.NumberFont_Shadow_Small, NORMAL, 12, true)
    SetFont(_G.NumberFont_Shadow_Med, NORMAL, 14, true)
    SetFont(_G.NumberFont_Shadow_Large, HEADER, 20, true)
    SetFont(_G.PriceFont, NORMAL, 14, true)
    SetFont(_G.NumberFontNormalLargeRight, NORMAL, 14, true)

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

    -- QuestFont_Shadow_Huge
    -- QuestFont_Shadow_Super_Huge
    -- QuestFont_Shadow_Enormous

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

    SetFont(_G.ChatBubbleFont, BOLD, 14)
    -- ChatFontNormal
    -- ChatFontSmall

    SetFont(_G.GameTooltipHeader, BOLD, 16)
    SetFont(_G.Tooltip_Med, NORMAL, 14)
    SetFont(_G.Tooltip_Small, NORMAL, 12)

    SetFont(_G.System_IME, BOLD, 16, true)

    SetFont(_G.SystemFont_NamePlateFixed, NORMAL, 14)
    SetFont(_G.SystemFont_LargeNamePlateFixed, NORMAL, 20)
    SetFont(_G.SystemFont_NamePlate, NORMAL, 9)
    SetFont(_G.SystemFont_LargeNamePlate, NORMAL, 12)
    SetFont(_G.SystemFont_NamePlateCastBar, NORMAL, 10)

    -- SetFont(_G.ZoneTextFont, HEADER, 40, nil, 'THICK')
    -- SetFont(_G.SubZoneTextFont, HEADER, 40, nil, 'THICK')
    -- SetFont(_G.WorldMapTextFont, HEADER, 40, nil, 'THICK')
    -- SetFont(_G.PVPInfoTextFont, HEADER, 40, nil, 'THICK')

    SetFont(_G.ErrorFont, BOLD, 14)
    SetFont(_G.CombatTextFont, COMBAT, 200)

    -- SetFont(_G.RaidWarningFrame.slot1, BOLD, 20, _G.FREE_ADB.FontOutline, not _G.FREE_ADB.FontOutline and 'THICK')
    -- SetFont(_G.RaidWarningFrame.slot2, BOLD, 20, _G.FREE_ADB.FontOutline, not _G.FREE_ADB.FontOutline and 'THICK')
    -- SetFont(_G.RaidBossEmoteFrame.slot1, BOLD, 20, _G.FREE_ADB.FontOutline, not _G.FREE_ADB.FontOutline and 'THICK')
    -- SetFont(_G.RaidBossEmoteFrame.slot2, BOLD, 20, _G.FREE_ADB.FontOutline, not _G.FREE_ADB.FontOutline and 'THICK')

    SetFont(_G.GameFontNormal, NORMAL, 13)
    SetFont(_G.QuestFont, NORMAL, 15)
end

F:RegisterEvent('ADDON_LOADED', ReskinBlizzFonts)

