local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local tier
local instance

local seasonSpells = {
    [209858] = 2, -- 死疽
    [240443] = 2, -- 爆裂
    [240559] = 1, -- 重伤
    [342494] = 2, -- 狂妄吹嘘，S1
    [355732] = 2, -- 融化灵魂，S2
    [356666] = 2, -- 刺骨之寒，S2
    [356667] = 2, -- 刺骨之寒，S2
    [356925] = 2, -- 屠戮，S2
    [358777] = 2, -- 痛苦之链，S2
    [366288] = 2, -- 猛力砸击，S3
    [366297] = 2, -- 解构，S3
}

function UNITFRAME:RegisterSeasonSpells(tier, instance)
    for spellID, priority in pairs(seasonSpells) do
        UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, spellID, priority)
    end
end

function UNITFRAME:RegisterDungeonSpells()
    tier = 9
    instance = 1194 -- 塔扎维什，帷纱集市

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 356011) -- 光线切分者
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 347949, 6) -- 审讯
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 345770) -- 扣押违禁品
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 355915) -- 约束雕文
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 346962) -- 现金汇款
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 349627) -- 暴食
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 347481) -- 奥能手里波
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 350804) -- 坍缩能量
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 350885) -- 超光速震荡
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 351101) -- 能量碎片
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 350013) -- 暴食盛宴
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 355641) -- 闪烁
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 355451) -- 逆流
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 351956) -- 高价值目标
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 346297) -- 动荡爆炸
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 347728) -- 群殴
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 356408) -- 大地践踏
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 347744) -- 迅斩
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 350134) -- 永恒吐息
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 355465) -- 投掷巨石
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 354334, 6) -- 被钩住

    instance = 1187 -- 伤逝剧场

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333299) -- 荒芜诅咒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333301) -- 荒芜诅咒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 319539) -- 无魂者
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326892) -- 锁定
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 321768) -- 上钩了
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323825) -- 攫取裂隙
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333231) -- 灼热之陨
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330532) -- 锯齿箭
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 342675) -- 骨矛
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323831) -- 死亡之攫
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330608) -- 邪恶爆发
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330868) -- 通灵箭雨
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323750) -- 邪恶毒气
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323406) -- 锯齿创口
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330700) -- 腐烂凋零
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 319626) -- 幻影寄生
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 324449) -- 死亡具象
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 341949) -- 枯萎凋零

    instance = 1183 -- 凋魂之殇

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 336258) -- 落单狩猎
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331818) -- 暗影伏击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333353) -- 暗影伏击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 329110) -- 软泥注射
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325552) -- 毒性裂击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 336301) -- 裹体之网
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322358) -- 燃灼菌株
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322410) -- 凋零污秽
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328180) -- 攫握感染
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320542) -- 荒芜凋零
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 340355) -- 急速感染
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328395) -- 剧毒打击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320512) -- 侵蚀爪击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333406) -- 伏击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 332397) -- 覆体缠网
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330069) -- 凝结魔药
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331399) -- 感染毒雨

    instance = 1184 -- 塞兹仙林的迷雾

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325027) -- 荆棘爆发
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323043) -- 放血
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322557) -- 灵魂分裂
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331172) -- 心灵连接
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322563) -- 被标记的猎物
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 341198) -- 易燃爆炸
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325418) -- 不稳定的酸液
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326092) -- 衰弱毒药
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325021) -- 纱雾撕裂
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325224) -- 心能注入
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322486) -- 过度生长
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322487) -- 过度生长
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323137) -- 迷乱花粉
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328756) -- 憎恨之容
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 321828) -- 肉饼蛋糕
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 340191) -- 再生辐光
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 321891) -- 鬼抓人锁定

    instance = 1188 -- 彼界

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320786) -- 势不可挡
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 334913) -- 死亡之主
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325725) -- 寰宇操控
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328987) -- 狂热
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 334496) -- 催眠光粉
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 334505, 6) -- 光尘之梦
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 339978) -- 安抚迷雾
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333250) -- 放血之击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322746) -- 堕落之血
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330434) -- 电锯
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320144) -- 电锯
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331847) -- W-00F
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 327649) -- 粉碎灵魂
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331379) -- 润滑剂
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 332678) -- 龟裂创伤
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323687) -- 奥数闪电
    -- UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323692) -- 奥术易伤
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 334535) -- 啄裂

    instance = 1186 -- 晋升高塔

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 338729) -- 充能践踏
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 327481) -- 黑暗长枪
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322818) -- 失去信心
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322817) -- 疑云密布
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 324154) -- 暗影迅步
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 335805) -- 执政官的壁垒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 317661) -- 险恶毒液
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328331) -- 严刑逼供
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323195) -- 净化冲击波
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328453) -- 压迫
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331997) -- 心能澎湃
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 324205) -- 炫目闪光
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331251) -- 深度联结
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 341215) -- 动荡心能
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323792) -- 心能力场
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 330683) -- 原始心能
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328434) -- 胁迫
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 27638) -- 斜掠

    instance = 1185 -- 赎罪大厅

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 335338) -- 哀伤仪式
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326891) -- 痛楚
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 329321) -- 锯齿横扫
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 344993) -- 锯齿横扫
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 319603) -- 羁石诅咒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 319611) -- 变成石头
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325876) -- 湮灭诅咒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326632) -- 石化血脉
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323650) -- 萦绕锁定
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326874) -- 脚踝撕咬
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 340446) -- 嫉妒之印
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323437) -- 傲慢罪印

    instance = 1189 -- 赤红深渊
    UNITFRAME:RegisterSeasonSpells(tier, instance)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326827) -- 恐惧之缚
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 326836) -- 镇压诅咒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322554) -- 严惩
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 321038) -- 烦扰之魂
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328593) -- 苦痛刑罚
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 325254) -- 钢铁尖刺
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 335306) -- 尖刺镣铐
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 327814) -- 邪恶创口
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 331415) -- 邪恶创口
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328737) -- 光辉残片
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 324092) -- 闪耀光辉
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322429) -- 撕裂切割
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 334653) -- 饱餐

    instance = 1182 -- 通灵战潮

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 321821) -- 作呕喷吐
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323365) -- 黑暗纠缠
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 338353) -- 瘀液喷撒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333485) -- 疾病之云
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 338357) -- 暴锤
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 328181) -- 冷冽之寒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320170) -- 通灵箭
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323464) -- 黑暗脓液
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323198) -- 黑暗放逐
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 327401) -- 共受苦难
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 327397) -- 严酷命运
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 322681) -- 肉钩
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333492) -- 通灵粘液
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 321807) -- 白骨剥离
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 323347) -- 黑暗纠缠
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320788) -- 冻结之缚
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320839) -- 衰弱
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 343556) -- 病态凝视
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 338606) -- 病态凝视
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 343504) -- 黑暗之握
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 324381) -- 霜寒之镰
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320573) -- 暗影之井
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 334748) -- 排干体液
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 333489) -- 通灵吐息
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 320717) -- 鲜血饥渴

    tier = 8
    instance = 1178 -- 麦卡贡

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 298259, 6) -- 束缚粘液
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 297257) -- 电荷充能
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 303885) -- 爆裂喷发
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 291928) -- 超荷电磁炮
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 292267) -- 超荷电磁炮
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 305699) -- 锁定
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 285443) -- 烈焰火炮
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 301712) -- 突袭
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 302274) -- 爆裂冲击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 298669) -- 跳电
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 294929) -- 烈焰撕咬

    tier = 7
    instance = 860 -- 重返卡拉赞

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227325)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227985)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227789)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227508)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227404)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227493)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227832)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227742)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227628)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227615)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228261, 6)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227779)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227592)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227523)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227502)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 229083)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 229159, 6)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 227977)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228796, 6)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228526)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228576)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228280)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228829)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 228993, 6) -- 腐蚀之池

    tier = 6
    instance = 536 -- 恐轨车站

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 162057) -- 蚀骨之矛
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 156357) -- 黑石榴弹
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 160702) -- 黑石迫击炮弹
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 160681) -- 火力压制
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 166570) -- 熔渣冲击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 164218) -- 双重猛击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 162491) -- 正在获取目标1
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 162507) -- 正在获取目标2
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 161588) -- 散射能量
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 162065) -- 冰冻诱捕

    instance = 558 -- 钢铁码头

    UNITFRAME:RegisterSeasonSpells(tier, instance)

    UNITFRAME:RegisterSeasonSpells(tier, instance)
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 163276) -- 筋腱撕裂
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 162415, 6) -- 进食时间
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 168398) -- 急速射击瞄准
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 373570, 6) -- 催眠
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 373607) -- 暗影屏障
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 172889) -- 冲击猛击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 374295) -- 恢复 6%
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 374300) -- 恢复 20%
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 172631) -- 被击倒
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 158341) -- 龟裂创伤
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 167240) -- 牵制射击
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 373509) -- 暗影利爪
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 173105) -- 锁链旋风
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 173324) -- 锯齿蒺藜
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 172771) -- 燃烧弹
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 173307) -- 倒钩长矛
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 169341) -- 挫志怒吼
    UNITFRAME:RegisterInstanceDebuff(tier, instance, 0, 172963, 6) -- 破门斩斧

    --[[ tier = 10
    instance

    instance = 1201 -- 艾杰斯亚学院
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1196 -- 蕨皮山谷
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1204 -- 注能大厅
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1199 -- 奈萨鲁斯
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1202 -- 红玉新生法池
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1203 -- 碧蓝魔馆
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1198 -- 诺库德阻击战
    UNITFRAME:RegisterInstanceDebuff(tier, instance)

    instance = 1197 -- 奥达曼：提尔的遗产
    UNITFRAME:RegisterInstanceDebuff(tier, instance) --]]
end
