local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local tier = 10
local inst = 1200 -- 化身巨龙牢窟
local boss

function UNITFRAME:RegisterIncarnatesSpells()
    boss = 2480 -- 艾拉诺格
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 370648) -- 熔岩涌流
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 390715) -- 火焰裂隙
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 370597) -- 杀戮指令

    boss = 2500 -- 泰洛斯
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 382776) -- 觉醒之土
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 381253) -- 觉醒之土
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 386352) -- 岩石冲击
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 382458) -- 共鸣余震

    boss = 2486 -- 原始议会
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 371624) -- 传导印记
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 372027) -- 劈砍烈焰
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374039) -- 流星之斧

    boss = 2482 -- 瑟娜尔丝，冰冷之息
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 371976) -- 冰冷冲击
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 372082) -- 包围之网
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374659) -- 突进
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374104) -- 困在网中
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374503) -- 困在网中
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 373048) -- 窒息之网

    boss = 2502 -- 晋升者达瑟雅
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 391686) -- 传导印记
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 378277) -- 元素均衡
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 388290) -- 旋风

    boss = 2491 -- 库洛格·恐怖图腾
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 377780) -- 骨骼碎裂
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 372514) -- 霜寒噬咬
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374554) -- 岩浆之池
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374023) -- 灼热屠戮
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 374427) -- 碎地
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 390920) -- 震撼爆裂
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 372458) -- 绝对零度

    boss = 2493 -- 巢穴守护者迪乌尔娜
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 388920) -- 冷凝笼罩
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 378782) -- 致死之伤
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 378787) -- 碎击龙爪
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 375620) -- 电离充能
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 375578) -- 烈焰哨卫

    boss = 2499 -- 莱萨杰丝，噬雷之龙
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 381615) -- 静电充能
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 399713) -- 磁力充能
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 385073) -- 球状闪电
    UNITFRAME:RegisterInstanceSpell(tier, inst, boss, 377467) -- 积雷充能
end
