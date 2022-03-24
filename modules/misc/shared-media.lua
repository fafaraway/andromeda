local F, C = unpack(select(2, ...))
local LSM = F.Libs.LSM

local LOCALE_MASK
if GetLocale() == 'koKR' then
    LOCALE_MASK = 1
elseif GetLocale() == 'ruRU' then
    LOCALE_MASK = 2
elseif GetLocale() == 'zhCN' then
    LOCALE_MASK = 4
elseif GetLocale() == 'zhTW' then
    LOCALE_MASK = 8
else
    LOCALE_MASK = 128
end

local function RegisterMediaAssets()
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Regular|r|r', C.Assets.Fonts.Regular, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Condensed|r|r', C.Assets.Fonts.Condensed, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Bold|r|r', C.Assets.Fonts.Bold, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Combat|r', C.Assets.Fonts.Combat, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Header|r', C.Assets.Fonts.Header, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Pixel|r', C.Assets.Fonts.Pixel, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Square|r', C.Assets.Fonts.Square, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '|cffa763ea!Free_Roadway|r', C.Assets.Fonts.Roadway, LOCALE_MASK)

    LSM:Register(LSM.MediaType.STATUSBAR, '|cffa763ea!Free_Normal|r', C.Assets.Textures.SBNormal)
    LSM:Register(LSM.MediaType.STATUSBAR, '|cffa763ea!Free_Gradient|r', C.Assets.Textures.SBGradient)
    LSM:Register(LSM.MediaType.STATUSBAR, '|cffa763ea!Free_Flat|r', C.Assets.Textures.SBFlat)
    LSM:Register(LSM.MediaType.STATUSBAR, '|cffa763ea!Free_Melli|r', C.Assets.Textures.Melli)

    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_LowHealth|r', C.AssetsPath .. 'sounds\\lowhealth.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_LowMana|r', C.AssetsPath .. 'sounds\\lowmana.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Warning|r', C.AssetsPath .. 'sounds\\warning.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_ForTheHorde|r', C.AssetsPath .. 'sounds\\forthehorde.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Interrupt|r', C.AssetsPath .. 'sounds\\interrupt.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Dispel|r', C.AssetsPath .. 'sounds\\dispel.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Missed|r', C.AssetsPath .. 'sounds\\missed.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Proc|r', C.AssetsPath .. 'sounds\\proc.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Exec|r', C.AssetsPath .. 'sounds\\exec.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Pulse|r', C.AssetsPath .. 'sounds\\pulse.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Error|r', C.AssetsPath .. 'sounds\\error.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Mario|r', C.AssetsPath .. 'sounds\\mario.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Alarm|r', C.AssetsPath .. 'sounds\\alarm.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Ding|r', C.AssetsPath .. 'sounds\\ding.ogg')
    LSM:Register(LSM.MediaType.SOUND, '|cffa763ea!Free_Dang|r', C.AssetsPath .. 'sounds\\dang.ogg')

    F:UnregisterEvent('ADDON_LOADED', RegisterMediaAssets)
end

F:RegisterEvent('ADDON_LOADED', RegisterMediaAssets)
