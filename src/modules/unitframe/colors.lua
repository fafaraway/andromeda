local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local colors = F.Libs.oUF.colors

function UNITFRAME:UpdateHealthDefaultColor()
    local color = C.DB.Unitframe.HealthColor
    colors.health = { color.r, color.g, color.b }
end

function UNITFRAME:UpdateClassColor()
    local classColors = C.ClassColors
    for class, value in pairs(classColors) do
        colors.class[class] = { value.r, value.g, value.b }
    end
end

local function ReplacePowerColor(name, index, color)
    colors.power[name] = color
    colors.power[index] = colors.power[name]
end

ReplacePowerColor('MANA', 0, { 0.06, 0.56, 0.89 })
ReplacePowerColor('RAGE', 1, { 0.94, 0.19, 0.18 })
ReplacePowerColor('FOCUS', 2, { 0.84, 0.51, 0.37 })
ReplacePowerColor('ENERGY', 3, { 0.94, 0.19, 0.18 })
ReplacePowerColor('COMBO_POINTS', 4, { 1, 0.77, 0.08 })
ReplacePowerColor('RUNES', 5, { 0.22, 0.95, 0.97 })
ReplacePowerColor('RUNIC_POWER', 6, { 0.22, 0.95, 0.97 })
ReplacePowerColor('SOUL_SHARDS', 7, { 0.65, 0.45, 1 })
ReplacePowerColor('LUNAR_POWER', 8, { 0.65, 0.45, 1 })
ReplacePowerColor('HOLY_POWER', 9, { 1, 0.77, 0.08 })
ReplacePowerColor('MAELSTROM', 11, { 0.94, 0.19, 0.18 })
ReplacePowerColor('CHI', 12, { 0.18, 0.85, 0.59 })
ReplacePowerColor('INSANITY', 13, { 0.65, 0.45, 1 })
ReplacePowerColor('ARCANE_CHARGES', 16, { 0.22, 0.95, 0.97 })
ReplacePowerColor('FURY', 17, { 0.94, 0.19, 0.18 })
ReplacePowerColor('PAIN', 18, { 0.94, 0.19, 0.18 })

colors.power.max = {
    COMBO_POINTS = { 161 / 255, 92 / 255, 255 / 255 },
    SOUL_SHARDS = { 255 / 255, 26 / 255, 48 / 255 },
    LUNAR_POWER = { 161 / 255, 92 / 255, 255 / 255 },
    HOLY_POWER = { 255 / 255, 26 / 255, 48 / 255 },
    CHI = { 0 / 255, 143 / 255, 247 / 255 },
    ARCANE_CHARGES = { 5 / 255, 96 / 255, 250 / 255 },
}

colors.runes = {
    [1] = { 0.91, 0.23, 0.21 }, -- Blood
    [2] = { 0.23, 0.67, 0.97 }, -- Frost
    [3] = { 0.41, 0.97, 0.21 }, -- Unholy
}

colors.debuff = {
    Curse = { 0.6, 0.2, 1.0 },
    Disease = { 0.6, 0.4, 0.0 },
    Magic = { 0.2, 0.5, 1.0 },
    Poison = { 0.2, 0.8, 0.2 },
    none = { 1.0, 0.1, 0.2 }, -- Physical, etc.
}

colors.reaction = {
    [1] = { 223 / 255, 54 / 255, 15 / 255 }, -- Hated / Enemy
    [2] = { 223 / 255, 54 / 255, 15 / 255 },
    [3] = { 223 / 255, 54 / 255, 15 / 255 },
    [4] = { 232 / 255, 190 / 255, 54 / 255 },
    [5] = { 74 / 255, 209 / 255, 68 / 255 },
    [6] = { 74 / 255, 209 / 255, 68 / 255 },
    [7] = { 74 / 255, 209 / 255, 68 / 255 },
    [8] = { 74 / 255, 209 / 255, 68 / 255 },
    [9] = { 69 / 255, 209 / 255, 155 / 255 }, -- Paragon (Reputation)
}

colors.smooth = { 1, 0, 0, 1, 1, 0, 0, 1, 0 }
colors.disconnected = { 0.5, 0.5, 0.5 }
