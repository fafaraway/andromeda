local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local TIER = 10
local INSTANCE = 1200 -- 化身巨龙牢窟

local BOSS

function UNITFRAME:RegisterIncarnatesSpells()
    BOSS = 2480 -- 艾拉诺格
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2500 -- 泰洛斯
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2486 -- 原始议会
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2482 -- 瑟娜尔丝，冰冷之息
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2502 -- 晋升者达瑟雅
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2491 -- 库洛格·恐怖图腾
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2493 -- 巢穴守护者迪乌尔娜
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心

    BOSS = 2499 -- 莱萨杰丝，噬雷之龙
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心
end
