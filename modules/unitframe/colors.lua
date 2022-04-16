local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local colors = F.Libs.oUF.colors

function UNITFRAME:UpdateHealthColor()
    local color = C.DB.Unitframe.HealthColor
    colors.health = {color.r, color.g, color.b}
end

function UNITFRAME:UpdateClassColor()
    local classColors = C.ClassColors
    for class, value in pairs(classColors) do
        colors.class[class] = {value.r, value.g, value.b}
    end
end

local function ReplacePowerColor(name, index, color)
    colors.power[name] = color
    colors.power[index] = colors.power[name]
end

ReplacePowerColor('MANA', 0, {.06, .56, .89})
ReplacePowerColor('RAGE', 1, {.94, .19, .18})
ReplacePowerColor('FOCUS', 2, {.84, .51, .37})
ReplacePowerColor('ENERGY', 3, {.94, .19, .18})
ReplacePowerColor('COMBO_POINTS', 4, {1, .77, .08})
ReplacePowerColor('RUNES', 5, {.22, .95, .97})
ReplacePowerColor('RUNIC_POWER', 6, {.22, .95, .97})
ReplacePowerColor('SOUL_SHARDS', 7, {.65, .45, 1})
ReplacePowerColor('LUNAR_POWER', 8, {.65, .45, 1})
ReplacePowerColor('HOLY_POWER', 9, {1, .77, .08})
ReplacePowerColor('MAELSTROM', 11, {.94, .19, .18})
ReplacePowerColor('CHI', 12, {.18, .85, .59})
ReplacePowerColor('INSANITY', 13, {.65, .45, 1})
ReplacePowerColor('ARCANE_CHARGES', 16, {.22, .95, .97})
ReplacePowerColor('FURY', 17, {.94, .19, .18})
ReplacePowerColor('PAIN', 18, {.94, .19, .18})

colors.power.max = {
    COMBO_POINTS = {161 / 255, 92 / 255, 255 / 255},
    SOUL_SHARDS = {255 / 255, 26 / 255, 48 / 255},
    LUNAR_POWER = {161 / 255, 92 / 255, 255 / 255},
    HOLY_POWER = {255 / 255, 26 / 255, 48 / 255},
    CHI = {0 / 255, 143 / 255, 247 / 255},
    ARCANE_CHARGES = {5 / 255, 96 / 255, 250 / 255}
}

colors.runes = {
    [1] = {.91, .23, .21}, -- Blood
    [2] = {.23, .67, .97}, -- Frost
    [3] = {.41, .97, .21} -- Unholy
}

colors.debuff = {
    Curse = {0.6, 0.2, 1.0},
    Disease = {0.6, 0.4, 0.0},
    Magic = {0.2, 0.5, 1.0},
    Poison = {0.2, 0.8, 0.2},
    none = {1.0, 0.1, 0.2} -- Physical, etc.
}

colors.reaction = {
    [1] = {223 / 255, 54 / 255, 15 / 255}, -- Hated / Enemy
    [2] = {223 / 255, 54 / 255, 15 / 255},
    [3] = {223 / 255, 54 / 255, 15 / 255},
    [4] = {232 / 255, 190 / 255, 54 / 255},
    [5] = {74 / 255, 209 / 255, 68 / 255},
    [6] = {74 / 255, 209 / 255, 68 / 255},
    [7] = {74 / 255, 209 / 255, 68 / 255},
    [8] = {74 / 255, 209 / 255, 68 / 255},
    [9] = {69 / 255, 209 / 255, 155 / 255} -- Paragon (Reputation)
}

colors.smooth = {1, 0, 0, 1, 1, 0, 0, 1, 0}
