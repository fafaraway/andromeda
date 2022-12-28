local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:RegisterDungeonSpells()
    -- 艾杰斯亚学院
    UNITFRAME:RegisterSeasonSpell(10, 1201)

    -- 蕨皮山谷
    UNITFRAME:RegisterSeasonSpell(10, 1196)

    -- 注能大厅
    UNITFRAME:RegisterSeasonSpell(10, 1204)

    -- 奈萨鲁斯
    UNITFRAME:RegisterSeasonSpell(10, 1199)

    -- 红玉新生法池
    UNITFRAME:RegisterSeasonSpell(10, 1202)

    -- 碧蓝魔馆
    UNITFRAME:RegisterSeasonSpell(10, 1203)

    -- 诺库德阻击战
    UNITFRAME:RegisterSeasonSpell(10, 1198)

    -- 奥达曼：提尔的遗产
    UNITFRAME:RegisterSeasonSpell(10, 1197)

    -- Dragonflight S1
    -- 青龙寺
    UNITFRAME:RegisterSeasonSpell(5, 313)

    -- 影月墓地
    UNITFRAME:RegisterSeasonSpell(6, 537)
end
