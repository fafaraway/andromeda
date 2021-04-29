local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local LSM = F.Libs.LSM

local function RegisterMediaAssets()
    local LOCALE_MASK
    if C.GameLocale == 'koKR' then
        LOCALE_MASK = 1
    elseif C.GameLocale == 'ruRU' then
        LOCALE_MASK = 2
    elseif C.GameLocale == 'zhCN' then
        LOCALE_MASK = 4
    elseif C.GameLocale == 'zhTW' then
        LOCALE_MASK = 8
    else
        LOCALE_MASK = 128
    end

    LSM:Register(LSM.MediaType.FONT, '!Free_Regular', C.Assets.Fonts.Regular, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Condensed', C.Assets.Fonts.Condensed, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Bold', C.Assets.Fonts.Bold, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Header', C.Assets.Fonts.Header, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Combat', C.Assets.Fonts.Combat, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Pixel', C.Assets.Fonts.Pixel, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Square', C.Assets.Fonts.Square, LOCALE_MASK)
    LSM:Register(LSM.MediaType.FONT, '!Free_Roadway', C.Assets.Fonts.Roadway, LOCALE_MASK)

    LSM:Register(LSM.MediaType.STATUSBAR, '!Free_Normal', C.Assets.norm_tex)
    LSM:Register(LSM.MediaType.STATUSBAR, '!Free_Gradient', C.Assets.grad_tex)
    LSM:Register(LSM.MediaType.STATUSBAR, '!Free_Flat', C.Assets.flat_tex)

    LSM:Register(LSM.MediaType.SOUND, '!Free_1', C.AssetsPath .. 'sounds\\ding.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_2', C.AssetsPath .. 'sounds\\proc.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_3', C.AssetsPath .. 'sounds\\warning.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_4', C.AssetsPath .. 'sounds\\execute.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_5', C.AssetsPath .. 'sounds\\health.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_6', C.AssetsPath .. 'sounds\\forthehorde.mp3')
end

F:RegisterEvent('ADDON_LOADED', RegisterMediaAssets)
