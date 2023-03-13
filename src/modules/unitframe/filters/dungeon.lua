local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local tier = 10
local inst

function UNITFRAME:RegisterDungeonSpells()
    inst = 1196 -- 蕨皮山谷
    UNITFRAME:RegisterSeasonSpell(tier, inst)

    inst = 1204 -- 注能大厅
    UNITFRAME:RegisterSeasonSpell(tier, inst)

    inst = 1199 -- 奈萨鲁斯
    UNITFRAME:RegisterSeasonSpell(tier, inst)

    inst = 1197 -- 奥达曼：提尔的遗产
    UNITFRAME:RegisterSeasonSpell(tier, inst)

    -- S1
    inst = 1201 -- 艾杰斯亚学院
    UNITFRAME:RegisterSeasonSpell(tier, inst)
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 389033) -- 鞭笞者毒素
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 391977) -- 涌动超载
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386201) -- 腐化法力
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 389011) -- 势不可挡
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 387932) -- 星界旋风
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 396716) -- 皲皮
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388866) -- 法力虚空
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386181) -- 法力炸弹
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388912) -- 断体猛击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 377344) -- 啄击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376997) -- 狂野啄击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388984) -- 邪恶伏击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388544) -- 裂树击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 377008) -- 震耳尖啸

    inst = 1202 -- 红玉新生法池
    UNITFRAME:RegisterSeasonSpell(tier, inst)
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 392406) -- 雷霆一击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 372820) -- 焦灼之土
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 384823) -- 地狱烈火
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 381862) -- 地狱火之核
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 372860) -- 灼热伤口
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 373869) -- 燃烧之触
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 385536) -- 烈焰之舞
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 381518) -- 变迁之风
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 372858) -- 灼热打击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 373589) -- 原始酷寒
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 373693) -- 活动炸弹
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 392924) -- 震爆
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 381515) -- 风暴猛击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 396411) -- 原始过载
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 384773) -- 烈焰余烬
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 392451) -- 闪火
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 372697) -- 锯齿土地
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 372047) -- 钢铁弹幕
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 372963) -- 霜风

    inst = 1203 -- 碧蓝魔馆
    UNITFRAME:RegisterSeasonSpell(tier, inst)
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 387151, 6) -- 寒冰灭绝者
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388777) -- 压制瘴气
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386881) -- 冰霜炸弹
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 387150) -- 冰霜之地
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 387564) -- 秘法蒸汽
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 385267) -- 爆裂旋涡
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386640) -- 撕扯血肉
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 374567) -- 爆裂法印
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 374523) -- 刺痛树液
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 375596) -- 古怪生长
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 375602) -- 古怪生长
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 370764) -- 穿刺碎片
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 384978) -- 巨龙打击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 375649) -- 注能之地
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 377488) -- 寒冰束缚
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 374789) -- 注能打击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 371007) -- 裂生碎片
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 375591) -- 树脂爆发
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 385409) -- 噢，噢，噢！
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386549) -- 清醒的克星

    inst = 1198 -- 诺库德阻击战
    UNITFRAME:RegisterSeasonSpell(tier, inst)
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 382628) -- 能量湍流
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386025) -- 风暴
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 381692) -- 迅捷刺击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 387615) -- 亡者之握
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 387629) -- 腐烂之风
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 386912) -- 风暴喷涌之云
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 395669) -- 余震
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 384134) -- 穿刺
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388451) -- 风暴召唤者之怒
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 395035) -- 粉碎灵魂
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376899) -- 鸣裂之云
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 384492) -- 猎人印记
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376730) -- 暴风
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376894) -- 鸣裂颠覆
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 388801) -- 致死打击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376827) -- 传导打击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376864) -- 静电之矛
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 375937) -- 撕裂猛击
    UNITFRAME:RegisterInstanceSpell(tier, inst, 0, 376634) -- 钢铁之矛

    inst = 313 -- 青龙寺
    UNITFRAME:RegisterSeasonSpell(5, inst)
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 396150) -- 优越感
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 397878) -- 腐化涟漪
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 106113) -- 虚无之触
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 397914) -- 污染迷雾
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 397904) -- 残阳西沉踢
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 397911) -- 毁灭之触
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 395859) -- 游荡尖啸
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 374037) -- 怒不可挡
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 396093) -- 野蛮飞跃
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 106823) -- 翔龙猛袭
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 396152) -- 自卑感
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 110125) -- 粉碎决心
    UNITFRAME:RegisterInstanceSpell(5, inst, 0, 397797) -- 腐蚀漩涡

    inst = 537 -- 影月墓地
    UNITFRAME:RegisterSeasonSpell(6, inst)
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 156776) -- 虚空撕裂
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 153692) -- 死疽淤青
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 153524) -- 瘟疫喷吐
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 154469) -- 仪式枯骨
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 162652) -- 纯净之月
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 164907) -- 虚空挥砍
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 152979) -- 灵魂撕裂
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 158061) -- 被祝福的净水
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 154442) -- 怨毒
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 153501) -- 虚空冲击
    UNITFRAME:RegisterInstanceSpell(6, inst, 0, 152819, 6) -- 暗言术：虚
end
