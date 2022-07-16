local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local TIER = 9
local INSTANCE = 1195 -- 初诞者圣墓
local BOSS

function UNITFRAME:RegisterSepulcherSpells()
    BOSS = 2458 -- 警戒卫士
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360458) -- 不稳定的核心
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364881) -- 物质分解
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 366393) -- 烧灼消融
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365175) -- 防护打击[可驱散]
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 359610) -- 移除解析
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365168) -- 宇宙猛击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360403) -- 力场
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364904) -- 反物质

    BOSS = 2459 -- 道茜歌妮，堕落先知
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361751) -- Disintegration Halo
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364289) -- Staggering Barrage
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361018) -- Staggering Barrage Mythic 1
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360960) -- Staggering Barrage Mythic 2
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361225) -- Encroaching Dominion
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361966) -- Infused Strikes

    BOSS = 2470 -- 圣物匠赛·墨克斯
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362803) -- 移位雕文
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362850) -- 凌光火花新星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362849) -- 凌光火花新星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362614) -- 空间撕裂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362615) -- 空间撕裂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362837) -- 奥术易伤
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364030) -- 衰弱射线
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364604) -- 源生法环
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363413) -- 源生法环
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363114) -- 源生超新星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362882) -- 静滞陷阱

    BOSS = 2460 -- 死亡万神殿原型体
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365272) -- 挫心打击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365269) -- 挫心打击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360259) -- 幽影箭
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361067) -- 晋升堡垒的结界
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360687) -- 刻符者的死亡之触[可驱散]
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365041) -- 啸风双翼
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361608) -- 罪孽烦扰
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362383) -- 心能箭矢
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365306) -- 振奋之花

    BOSS = 2461 -- 首席建筑师利许威姆
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360159) -- 不稳定的微粒
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 368024) -- 动能共鸣
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363538) -- 原生体耀光
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 368025) -- 碎裂共鸣
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363681) -- 解构冲击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363676) -- 解构能量1
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363795) -- 解构能量2

    BOSS = 2465 -- 司垢莱克斯，无穷噬灭者
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364522) -- 吞噬之血[可驱散]
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 359976) -- Riftmaw
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 359981) -- Rend
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360098) -- Warp Sickness
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 366070) -- Volatile Residue

    BOSS = 2463 -- 回收者黑伦度斯
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361309) -- 碎光射线
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361675) -- 碎地者飞弹
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 367838) -- 幻磷裂隙
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360114) -- 幻磷裂隙
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365297) -- 挤压棱镜[可驱散]

    BOSS = 2469 -- 安度因·乌瑞恩
    -- UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361817) -- 灭愿者[常驻优先级请设定低于其他DEBUFF或者不监控]
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 366849) -- 御言术：痛
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365293) -- 亵渎屏障
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361993) -- 绝望
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365966) -- 绝望
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361992) -- 自负
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362055) -- 失落之魂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362774) -- 灵魂收割
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365024) -- 邪恶之星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365021) -- 邪恶之星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 367632) -- 强化邪恶之星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 367634) -- 强化邪恶之星
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364020) -- 诅咒进军

    BOSS = 2457 -- 恐惧双王
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360287) -- 苦痛打击[坦的常驻DEBUFF]
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 359963) -- 开裂静脉[坦的常驻DEBUFF]
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360012) -- 腐臭之云
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360008) -- 腐臭之云
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360241) -- 不安梦境
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360146) -- 恐惧战栗
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 364985) -- 啃噬伤口

    BOSS = 2467 -- 莱葛隆
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362172) -- 腐蚀伤口
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362137) -- 腐蚀伤口
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 361548) -- 黑暗之蚀
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362806) -- 黑暗之蚀
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362206) -- 事件视界
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362081) -- 宇宙喷射
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363598) -- 不稳定的反物质

    BOSS = 2464 -- 典狱长
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360281) -- 咒罚符文
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362401) -- 折磨
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363893) -- 殉难
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 363886) -- 禁锢
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 366545) -- 残害
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 362397) -- 强迫
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 369868) -- 粉碎冲击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 360425) -- 秽邪之地
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365150) -- 统御符文
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365219) -- 痛苦之链
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365222) -- 痛苦之链
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 365153) -- 统御意志
end
