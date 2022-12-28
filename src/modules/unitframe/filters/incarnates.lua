local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:RegisterIncarnatesSpells()
    -- 艾拉诺格
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2480, 360458) -- 不稳定的核心

    -- 泰洛斯
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2500, 360458) -- 不稳定的核心

    -- 原始议会
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2486, 360458) -- 不稳定的核心

    -- 瑟娜尔丝，冰冷之息
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2482, 360458) -- 不稳定的核心

    -- 晋升者达瑟雅
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2502, 360458) -- 不稳定的核心

    -- 库洛格·恐怖图腾
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2491, 360458) -- 不稳定的核心

    -- 巢穴守护者迪乌尔娜
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2493, 360458) -- 不稳定的核心

    -- 莱萨杰丝，噬雷之龙
    UNITFRAME:RegisterInstanceSpell(10, 1200, 2499, 360458) -- 不稳定的核心
end
