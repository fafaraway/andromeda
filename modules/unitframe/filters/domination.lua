local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local TIER = 9
local INSTANCE = 1193 -- 统御圣所
local BOSS

function UNITFRAME:AddDominationSpells()
    BOSS = 2435 -- 塔拉格鲁
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347283) -- 捕食者之嚎
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347286) -- 不散之惧
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 346986) -- 粉碎护甲
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347269, 6) -- 永恒锁链
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 346985) -- 压制
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347274) -- 毁灭猛击

    BOSS = 2442 -- 典狱长之眼
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350606) -- 绝望倦怠
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355240) -- 轻蔑
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355245) -- 忿怒
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 349979) -- 牵引锁链
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348074) -- 痛击长枪
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351827) -- 蔓延痛苦
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350763) -- 毁灭凝视

    BOSS = 2439 -- 九武神
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350287) -- 终约之歌
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350542) -- 命运残片
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350202) -- 无尽之击
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350475) -- 灵魂穿透
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350555) -- 命运碎片
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350109) -- 布琳佳的悲恸挽歌
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350483) -- 联结精华
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350039) -- 阿尔苏拉的粉碎凝视
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350184) -- 达丝琪拉的威猛冲击
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350374) -- 愤怒之翼

    BOSS = 2444 -- 耐奥祖的残迹
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350073) -- 折磨
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 349890) -- 苦难
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350469) -- 怨毒
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 354634) -- 怨恨
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 354479) -- 怨恨
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 354534) -- 怨恨

    BOSS = 2445 -- 裂魂者多尔玛赞
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 353429) -- 饱受磨难
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 353023) -- 折磨
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351787) -- 刑罚新星
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350647) -- 折磨烙印
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350422) -- 毁灭之刃
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350851) -- 聚魂之河
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 354231) -- 灵魂镣铐
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348987) -- 好战者枷锁
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350927) -- 好战者枷锁

    BOSS = 2443 -- 痛楚工匠莱兹纳尔
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 356472) -- 萦绕烈焰
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355505) -- 影铸锁链
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355506) -- 影铸锁链
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348456) -- 烈焰套索陷阱
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 356870) -- 烈焰套索爆炸
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355568) -- 十字刃斧
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355786) -- 黑化护甲

    BOSS = 2446 -- 初诞者的卫士
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 352394) -- 光辉能量
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350496) -- 净除威胁
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347359) -- 压制力场
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355357) -- 湮灭
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350732) -- 破甲
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 352833) -- 分解

    BOSS = 2447 -- 命运撰写师罗-卡洛
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 354365) -- 恐怖征兆
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350568) -- 永恒之唤
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 353435) -- 不堪重负
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351680) -- 祈求宿命
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 353432) -- 命运重担
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 353693) -- 不稳增幅
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 350355) -- 宿命联结
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 353931) -- 扭曲命运

    BOSS = 2440 -- 克尔苏加德
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 346530) -- 冰封毁灭
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 354289) -- 险恶瘴气
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347454) -- 湮灭回响
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347518) -- 湮灭回响
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347292) -- 湮灭回响
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348978) -- 灵魂疲惫
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355389) -- 无情追击
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 357298) -- 冻结之缚
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 355137) -- 暗影之池
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348638) -- 亡者归来
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348760) -- 冰霜冲击

    BOSS = 2441 -- 希尔瓦娜斯·风行者
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 349458) -- 统御锁链
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347704) -- 黑暗帷幕
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347607) -- 女妖的印记
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 347670) -- 暗影匕首
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351117) -- 恐惧压迫
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351870) -- 索命妖魂
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351253) -- 女妖哀嚎
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351451) -- 嗜睡诅咒
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351092) -- 动荡能量
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 351091) -- 动荡能量
    UNITFRAME:RegisterDebuff(TIER, INSTANCE, BOSS, 348064) -- 哀恸箭
end
