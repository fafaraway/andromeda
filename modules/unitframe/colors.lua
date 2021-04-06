local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F.UNITFRAME

local colors = F.OUF.colors

function UNITFRAME:UpdateHealthColor()
    local color = _G.FREE_ADB.HealthColor
    colors.health = {color.r, color.g, color.b}
end

function UNITFRAME:UpdateClassColor()
    local classColors = C.ClassColors
    for class, value in pairs(classColors) do
        colors.class[class] = {value.r, value.g, value.b}
    end
end

local function ReplacePowerColors(name, index, color)
    colors.power[name] = color
    colors.power[index] = colors.power[name]
end

ReplacePowerColors('MANA', 0, {87 / 255, 165 / 255, 208 / 255})
ReplacePowerColors('RAGE', 1, {255 / 255, 26 / 255, 48 / 255})
ReplacePowerColors('FOCUS', 2, {255 / 255, 128 / 255, 64 / 255})
ReplacePowerColors('ENERGY', 3, {174 / 255, 34 / 255, 45 / 255})
ReplacePowerColors('COMBO_POINTS', 4, {199 / 255, 171 / 255, 90 / 255})
ReplacePowerColors('RUNES', 5, {0 / 255, 200 / 255, 255 / 255})
ReplacePowerColors('RUNIC_POWER', 6, {135 / 255, 214 / 255, 194 / 255})
ReplacePowerColors('SOUL_SHARDS', 7, {151 / 255, 101 / 255, 221 / 255})
ReplacePowerColors('LUNAR_POWER', 8, {144 / 255, 112 / 255, 254 / 255})
ReplacePowerColors('HOLY_POWER', 9, {208 / 255, 178 / 255, 107 / 255})
ReplacePowerColors('MAELSTROM', 11, {0 / 255, 200 / 255, 255 / 255})
ReplacePowerColors('CHI', 12, {0, 204 / 255, 153 / 255})
ReplacePowerColors('INSANITY', 13, {179 / 255, 96 / 255, 244 / 255})
ReplacePowerColors('ARCANE_CHARGES', 16, {125 / 255, 75 / 255, 250 / 255})
ReplacePowerColors('FURY', 17, {255 / 255, 50 / 255, 50 / 255})
ReplacePowerColors('PAIN', 18, {255 / 255, 156 / 255, 0 / 255})

colors.power.max = {
    COMBO_POINTS = {161 / 255, 92 / 255, 255 / 255},
    SOUL_SHARDS = {255 / 255, 26 / 255, 48 / 255},
    LUNAR_POWER = {161 / 255, 92 / 255, 255 / 255},
    HOLY_POWER = {255 / 255, 26 / 255, 48 / 255},
    CHI = {0 / 255, 143 / 255, 247 / 255},
    ARCANE_CHARGES = {5 / 255, 96 / 255, 250 / 255},
}

colors.runes = {
    [1] = {177 / 255, 40 / 255, 45 / 255}, -- Blood
    [2] = {42 / 255, 138 / 255, 186 / 255}, -- Frost
    [3] = {101 / 255, 186 / 255, 112 / 255}, -- Unholy
}

colors.debuff.Curse = {0.6, 0.2, 1.0}
colors.debuff.Disease = {0.6, 0.4, 0.0}
colors.debuff.Magic = {0.2, 0.5, 1.0}
colors.debuff.Poison = {0.2, 0.8, 0.2}
colors.debuff.none = {1.0, 0.1, 0.2} -- Physical, etc.

colors.reaction = {
    [1] = {182 / 255, 34 / 255, 32 / 255}, -- Hated / Enemy
    [2] = {182 / 255, 34 / 255, 32 / 255},
    [3] = {182 / 255, 92 / 255, 32 / 255},
    [4] = {220 / 225, 180 / 255, 52 / 255},
    [5] = {132 / 255, 181 / 255, 26 / 255},
    [6] = {132 / 255, 181 / 255, 26 / 255},
    [7] = {132 / 255, 181 / 255, 26 / 255},
    [8] = {132 / 255, 181 / 255, 26 / 255},
    [9] = {0 / 255, 110 / 255, 255 / 255}, -- Paragon (Reputation)
}

colors.smooth = {1, 0, 0, 1, 1, 0, 0, 1, 0}