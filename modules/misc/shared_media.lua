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

    LSM:Register(LSM.MediaType.SOUND, '!Free_LowHealth', C.AssetsPath .. 'sounds\\lowhealth.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_LowMana', C.AssetsPath .. 'sounds\\lowmana.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Warning', C.AssetsPath .. 'sounds\\warning.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_ForTheHorde', C.AssetsPath .. 'sounds\\forthehorde.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Interrupt', C.AssetsPath .. 'sounds\\interrupt.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Dispel', C.AssetsPath .. 'sounds\\dispel.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Missed', C.AssetsPath .. 'sounds\\missed.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Proc', C.AssetsPath .. 'sounds\\proc.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Exec', C.AssetsPath .. 'sounds\\exec.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Pulse', C.AssetsPath .. 'sounds\\pulse.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Error', C.AssetsPath .. 'sounds\\error.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Mario', C.AssetsPath .. 'sounds\\mario.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Alarm', C.AssetsPath .. 'sounds\\alarm.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Ding', C.AssetsPath .. 'sounds\\ding.ogg')
    LSM:Register(LSM.MediaType.SOUND, '!Free_Dang', C.AssetsPath .. 'sounds\\dang.ogg')
end

F:RegisterEvent('ADDON_LOADED', RegisterMediaAssets)
