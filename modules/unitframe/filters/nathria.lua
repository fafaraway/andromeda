local F = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local TIER = 9
local INSTANCE = 1190 -- 纳斯利亚堡
local BOSS

function UNITFRAME:AddNathriaSpells()
    BOSS = 2393 -- 啸翼
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328897) -- 抽干
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 330713) -- 耳鸣之痛

    BOSS = 2429 -- 猎手阿尔迪莫
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335304) -- 寻罪箭
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334971) -- 锯齿利爪
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335111) -- 猎手印记
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335112) -- 猎手印记
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335113) -- 猎手印记
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334945) -- 深红痛击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334852) -- 石化嚎叫

    BOSS = 2428 -- 饥饿的毁灭者
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334228) -- 不稳定的喷发
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 329298) -- 暴食瘴气

    BOSS = 2422 -- 太阳之王的救赎
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 333002) -- 劣民印记
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 326078) -- 灌注者的恩赐
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 325251) -- 骄傲之罪
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 339251) -- 干涸之魂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 341475) -- 猩红乱舞
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 341473) -- 猩红乱舞
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328479) -- 锁定目标
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328889) -- 至高惩戒

    BOSS = 2418 -- 技师赛·墨克斯
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327902) -- 锁定
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 326302) -- 静滞陷阱
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 325236) -- 毁灭符文
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327414) -- 附身
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 340860) -- 枯萎之触
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328468) -- 空间撕裂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328448) -- 空间撕裂

    BOSS = 2420 -- 伊涅瓦·暗脉女勋爵
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 325936) -- 共享认知
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335396) -- 隐秘欲望
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 324982) -- 共受苦难
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 324983) -- 共受苦难
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 332664) -- 浓缩心能
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 325382) -- 扭曲欲望
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 325117) -- 心能释放

    BOSS = 2426 -- 猩红议会
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327773) -- 吸取精华
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327052) -- 吸取精华
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 346651) -- 吸取精华
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328334) -- 战术冲锋
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 330848) -- 跳错了
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 331706) -- 红字
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 331636) -- 黑暗伴舞
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 331637) -- 黑暗伴舞

    BOSS = 2394 -- 泥拳
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335470) -- 锁链猛击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 339181) -- 锁链猛击
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 331209) -- 怨恨凝视
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335293) -- 锁链联结
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335295) -- 粉碎锁链
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 342419) -- 锁起来
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 342420) -- 锁起来
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 332572) -- 碎石飞落

    BOSS = 2425 -- 石裔干将
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334498) -- 地震岩层
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 337643) -- 立足不稳
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334765) -- 石化碎裂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 333377) -- 邪恶印记
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334616) -- 石化
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334541) -- 石化诅咒
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 339690) -- 晶化
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 342655) -- 不稳定的心能灌注
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 342698) -- 不稳定的心能感染
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 343881) -- 锯齿撕裂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 333913) -- 邪恶撕裂
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334771) -- 溢血之心

    BOSS = 2424 -- 德纳修斯大帝
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 326851) -- 血债
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327796) -- 罐装心能
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327992) -- 荒芜
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 328276) -- 悔悟之行
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 326699) -- 罪孽烦扰
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 329181) -- 毁灭痛苦
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 335873) -- 积恨
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 329951) -- 穿刺
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327039) -- 喂食时间
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 327089) -- 喂食时间
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 332794) -- 致命灵巧
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 329906) -- 屠戮
    UNITFRAME:RegisterInstanceDebuff(TIER, INSTANCE, BOSS, 334016, 6) -- 落选者
end
