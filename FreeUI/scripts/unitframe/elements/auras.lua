local _, ns = ...
local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Unitframe')

local cfg = C.unitframe
local oUF = ns.oUF
local myClass = C.Class
local format, min, max, floor, mod, pairs = string.format, math.min, math.max, math.floor, mod, pairs


local importantDebuffs = {
	[  6788] = myClass == 'PRIEST',		-- Weakened Soul
	[ 25771] = myClass == 'PALADIN',	-- Forbearance

	-- Mythic Dungeon
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[226512] = true,	-- 血池
	[240447] = true,	-- 践踏
	[288388] = true,	-- 夺魂

	-- Siege of Boralus
	[288694] = true,	-- 暗影碎击
	[257169] = true,	-- 恐惧咆哮
	[257168] = true,	-- 诅咒挥砍
	[272588] = true,	-- 腐烂伤口
	[272571] = true,	-- 窒息之水
	[274991] = true,	-- 腐败之水
	[275835] = true,	-- 钉刺之毒覆膜
	[273930] = true,	-- 妨害切割
	[257292] = true,	-- 沉重挥砍
	[261428] = true,	-- 刽子手的套索
	[256897] = true,	-- 咬合之颚
	[272874] = true,	-- 践踏
	[273470] = true,	-- 一枪毙命
	[272834] = true,	-- 粘稠的口水
	[272713] = true,	-- 碾压重击

	-- The Underrot
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[278961] = true,	-- 衰弱意志
	[265468] = true,	-- 枯萎诅咒
	[259714] = true,	-- 腐烂孢子
	[272180] = true,	-- 湮灭之球
	[272609] = true,	-- 疯狂凝视
	[269301] = true,	-- 腐败之血
	[265533] = true,	-- 鲜血之喉
	[265019] = true,	-- 狂野顺劈斩
	[265377] = true,	-- 抓钩诱捕
	[265625] = true,	-- 黑暗预兆
	[260685] = true,	-- 戈霍恩之蚀
	[266107] = true,	-- 嗜血成性
	[260455] = true,	-- 锯齿利牙

	-- Temple of Sethraliss
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[269686] = true,	-- 瘟疫
	[268013] = true,	-- 烈焰震击
	[268008] = true,	-- 毒蛇诱惑
	[273563] = true,	-- 神经毒素
	[272657] = true,	-- 毒性吐息
	[267027] = true,	-- 细胞毒素
	[272699] = true,	-- 毒性喷吐
	[263371] = true,	-- 导电
	[272655] = true,	-- 黄沙冲刷
	[263914] = true,	-- 盲目之沙
	[263958] = true,	-- 缠绕的蛇群
	[266923] = true,	-- 充电
	[268007] = true,	-- 心脏打击

	-- Tol Dagor
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[260067] = true,	-- 恶毒槌击
	[258128] = true,	-- 衰弱怒吼
	[265889] = true,	-- 火把攻击
	[257791] = true,	-- 恐惧咆哮
	[258864] = true,	-- 火力压制
	[257028] = true,	-- 点火器
	[258917] = true,	-- 正义烈焰
	[257777] = true,	-- 断筋剃刀
	[258079] = true,	-- 巨口噬咬
	[258058] = true,	-- 挤压
	[260016] = true,	-- 瘙痒叮咬
	[257119] = true,	-- 流沙陷阱
	[258313] = true,	-- 手铐
	[259711] = true,	-- 全面紧闭
	[256201] = true,	-- 爆炎弹
	[256101] = true,	-- 爆炸
	[256044] = true,	-- 致命狙击
	[256474] = true,	-- 竭心毒剂

	-- The MOTHERLODE!!
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[263074] = true,	-- 溃烂撕咬
	[280605] = true,	-- 脑部冻结
	[257337] = true,	-- 电击之爪
	[270882] = true,	-- 炽然的艾泽里特
	[268797] = true,	-- 转化：敌人变粘液
	[259856] = true,	-- 化学灼烧
	[269302] = true,	-- 淬毒之刃
	[280604] = true,	-- 冰镇汽水
	[257371] = true,	-- 催泪毒气
	[257544] = true,	-- 锯齿切割
	[268846] = true,	-- 回声之刃
	[262794] = true,	-- 能量鞭笞
	[262513] = true,	-- 艾泽里特觅心者
	[260829] = true,	-- 自控导弹
	[260838] = true,	-- 自控导弹
	[263637] = true,	-- 晾衣绳

	-- Waycrest Manor
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[260741] = true,	-- 锯齿荨麻
	[260703] = true,	-- 不稳定的符文印记
	[263905] = true,	-- 符文劈斩
	[265880] = true,	-- 恐惧印记
	[265882] = true,	-- 萦绕恐惧
	[264105] = true,	-- 符文印记
	[264050] = true,	-- 被感染的荆棘
	[261440] = true,	-- 恶性病原体
	[263891] = true,	-- 缠绕荆棘
	[264378] = true,	-- 碎裂灵魂
	[266035] = true,	-- 碎骨片
	[266036] = true,	-- 吸取精华
	[260907] = true,	-- 灵魂操控
	[264556] = true,	-- 刺裂打击
	[265760] = true,	-- 荆棘弹幕
	[260551] = true,	-- 灵魂荆棘
	[263943] = true,	-- 蚀刻
	[265881] = true,	-- 腐烂之触
	[261438] = true,	-- 污秽攻击
	[268202] = true,	-- 死亡棱镜
	[268086] = true,	-- 恐怖光环

	-- Freehold
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[258875] = true,	-- 眩晕酒桶
	[274389] = true,	-- 捕鼠陷阱
	[258323] = true,	-- 感染之伤
	[257775] = true,	-- 瘟疫步
	[257908] = true,	-- 浸油之刃
	[257436] = true,	-- 毒性打击
	[274555] = true,	-- 污染之咬
	[256363] = true,	-- 裂伤拳
	[281357] = true,	-- 水鼠啤酒
	[278467] = true,	-- 腐蚀酒

	-- Kings' Rest
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[265773] = true,	-- 吐金
	[271640] = true,	-- 黑暗启示
	[270492] = true,	-- 妖术
	[267763] = true,	-- 恶疾排放
	[276031] = true,	-- 深渊绝望
	[270920] = true,	-- 诱惑
	[270865] = true,	-- 隐秘刀刃
	[271564] = true,	-- 防腐液
	[270507] = true,	-- 毒幕
	[267273] = true,	-- 毒性新星
	[270003] = true,	-- 压制猛击
	[270084] = true,	-- 飞斧弹幕
	[267618] = true,	-- 排干体液
	[267626] = true,	-- 干枯
	[270487] = true,	-- 切裂之刃
	[266238] = true,	-- 粉碎防御
	[266231] = true,	-- 斩首之斧
	[266191] = true,	-- 回旋飞斧
	[272388] = true,	-- 暗影弹幕
	[268796] = true,	-- 穿刺长矛
	[270289] = true,	-- 净化光线

	-- Atal'Dazar
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[252781] = true,	-- 不稳定的妖术
	[250096] = true,	-- 毁灭痛苦
	[253562] = true,	-- 野火
	[255582] = true,	-- 熔化的黄金
	[255041] = true,	-- 惊骇尖啸
	[255371] = true,	-- 恐惧之面
	[252687] = true,	-- 毒牙攻击
	[254959] = true,	-- 灵魂燃烧
	[255814] = true,	-- 撕裂重殴
	[255421] = true,	-- 吞噬
	[255434] = true,	-- 锯齿
	[256577] = true,	-- 灵魂盛宴
	[255558] = true,	-- 污血

	-- Shrine of the Storm
	[209858] = true,	-- 死疽
	[240559] = true,	-- 重伤
	[240443] = true,	-- 爆裂
	[288388] = true,	-- 夺魂
	[288694] = true,	-- 暗影碎击
	[264560] = true,	-- 窒息海潮
	[268233] = true,	-- 电化震击
	[268322] = true,	-- 溺毙者之触
	[268896] = true,	-- 心灵撕裂
	[267034] = true,	-- 力量的低语
	[276268] = true,	-- 沉重打击
	[264166] = true,	-- 逆流
	[264526] = true,	-- 深海之握
	[274633] = true,	-- 碎甲重击
	[268214] = true,	-- 割肉
	[267818] = true,	-- 切割冲击
	[268309] = true,	-- 无尽黑暗
	[268317] = true,	-- 撕裂大脑
	[268391] = true,	-- 心智突袭
	[274720] = true,	-- 深渊打击
	[267037] = true,	-- 力量的低语

	-- Raid
	-- Battle of Dazar'alor
	[283573] = true,	-- 圣洁之刃，圣光勇士
	[285671] = true,	-- 碾碎，丛林之王格洛恩
	[285998] = true,	-- 凶狠咆哮
	[285875] = true,	-- 撕裂噬咬
	[283069] = true,	-- 原子烈焰
	[286434] = true,	-- 死疽之核
	[289406] = true,	-- 蛮兽压掷
	[286988] = true,	-- 炽热余烬，玉火大师
	[284374] = true,	-- 熔岩陷阱
	[282037] = true,	-- 升腾之焰
	[286379] = true,	-- 炎爆术
	[285632] = true,	-- 追踪
	[288151] = true,	-- 考验后遗症
	[284089] = true,	-- 成功防御
	[287424] = true,	-- 窃贼的报应，丰灵
	[284527] = true,	-- 坚毅宝石
	[284556] = true,	-- 暗影触痕
	[284573] = true,	-- 顺风之力
	[284664] = true,	-- 炽热
	[284798] = true,	-- 极度炽热
	[284802] = true,	-- 闪耀光环
	[284817] = true,	-- 地之根系
	[284881] = true,	-- 怒意释放
	[283507] = true,	-- 爆裂充能
	[287648] = true,	-- 爆裂充能
	[287072] = true,	-- 液态黄金
	[284424] = true,	-- 灼烧之地
	[285014] = true,	-- 金币雨
	[285479] = true,	-- 烈焰喷射
	[283947] = true,	-- 烈焰喷射
	[284470] = true,	-- 昏睡妖术
	[282444] = true,	-- 裂爪猛击，神选者教团
	[286838] = true,	-- 静电之球
	[285879] = true,	-- 记忆清除
	[282135] = true,	-- 恶意妖术
	[282209] = true,	-- 掠食印记
	[286821] = true,	-- 阿昆达的愤怒
	[284831] = true,	-- 炽焰引爆，拉斯塔哈大王
	[284662] = true,	-- 净化之印
	[290450] = true,	-- 净化之印
	[289858] = true,	-- 碾压
	[284740] = true,	-- 重斧掷击
	[284781] = true,	-- 重斧掷击
	[285195] = true,	-- 寂灭凋零
	[288449] = true,	-- 死亡之门
	[284376] = true,	-- 死亡的存在
	[285349] = true,	-- 赤焰瘟疫
	[287147] = true,	-- 恐惧收割
	[284168] = true,	-- 缩小，大工匠梅卡托克
	[282182] = true,	-- 毁灭加农炮
	[286516] = true,	-- 反干涉震击
	[286480] = true,	-- 反干涉震击
	[287167] = true,	-- 基因解组
	[286105] = true,	-- 干涉
	[286646] = true,	-- 千兆伏特充能
	[285075] = true,	-- 冰封潮汐池，风暴之墙阻击战
	[284121] = true,	-- 雷霆轰鸣
	[285000] = true,	-- 海藻缠裹
	[285350] = true,	-- 风暴哀嚎
	[285426] = true,	-- 风暴哀嚎
	[287490] = true,	-- 冻结，吉安娜
	[287993] = true,	-- 寒冰之触
	[285253] = true,	-- 寒冰碎片
	[288394] = true,	-- 热量
	[288212] = true,	-- 舷侧攻击
	[288374] = true,	-- 破城者炮击
}

local importantBuffs = {
	-- Defensive buffs
	-- Warrior
	[199038] = true, 	-- 扶危助困
	[   871] = true, 	-- 盾墙
	[213871] = true, 	-- 护卫
	[223658] = true, 	-- 捍卫
	[184364] = true, 	-- 狂怒回复
	[ 12975] = true, 	-- 破腹沉舟

	-- Death Knight
	[ 48707] = true, 	-- 反魔法护罩
	[123981] = true, 	-- 永劫不复	
	[145629] = true, 	-- 反魔法领域
	[ 48792] = true, 	-- 冰封之韧
	[ 48265] = true, 	-- 死亡脚步
	[212552] = true, 	-- 幻影步
	[ 81256] = true, 	-- 符文刃舞
	[194844] = true, 	-- 白骨风暴

	-- Paladin
	[228050] = true, 	-- 被遗忘的女王护卫
	[   642] = true, 	-- 圣盾术
	[199448] = true, 	-- 无尽牺牲
	[  1022] = true, 	-- 保护祝福
	[204018] = true, 	-- 破咒祝福
	[210256] = true, 	-- 庇护祝福
	[  6940] = true, 	-- 牺牲祝福		
	[ 86659] = true, 	-- 远古列王守卫	
	[ 31850] = true, 	-- 炽热防御者
	[204150] = true, 	-- 圣光护盾		
	[ 31821] = true, 	-- 光环掌握
	[   498] = true, 	-- 圣佑术	
	[205191] = true, 	-- 以眼还眼	
	[184662] = true, 	-- 复仇之盾
	[  1044] = true, 	-- 自由祝福
	[199545] = true, 	-- 荣耀战马

	-- Shaman
	[  8178] = true, 	-- 根基图腾
	[210918] = true, 	-- 灵体形态
	[207498] = true, 	-- 先祖护佑图腾
	[ 98007] = true, 	-- 灵魂链接图腾
	[204293] = true, 	-- 灵魂链接
	[108271] = true, 	-- 星界转移
    [201633] = true, 	-- 大地之墙图腾
    [260881] = true, 	-- 大地之墙图腾

    -- Hunter
    [186265] = true, 	-- 灵龟守护
	[202748] = true, 	-- 生存战术
	[248519] = true, 	-- 干涉
	[ 53480] = true, 	-- 牺牲咆哮
	[264735] = true, 	-- 优胜略汰
	[281195] = true, 	-- 优胜略汰孤狼技能
	[212704] = true, 	-- 野兽之心	
	[ 54216] = true, 	-- 主人的召唤

	-- Demon Hunter
	[196555] = true, 	-- 虚空行走
	[188499] = true, 	-- 刃舞
	[187827] = true, 	-- 恶魔变形 复仇
	[209426] = true, 	-- 幻影打击
	[212800] = true, 	-- 疾影
	[207771] = true, 	-- 烈火烙印
	[205629] = true, 	-- 恶魔践踏
	[208796] = true, 	-- 锯齿尖刺
	[162264] = true, 	-- 恶魔变形 浩劫
	[206649] = true, 	-- 莱欧瑟拉斯之眼

	-- Druid
	[209753] = true, 	-- 旋风
	[ 61336] = true, 	-- 生存本能
	[102342] = true, 	-- 铁木树皮
	[ 22812] = true, 	-- 树皮术
	[201940] = true, 	-- 盟友守护
	[236696] = true, 	-- 荆棘
	[200947] = true, 	-- 侵蚀藤曼
	[201664] = true, 	-- 挫志咆哮
	[234084] = true, 	-- 明月繁星

	-- Rogue
	[ 11327] = true, 	-- 消失
	[199754] = true, 	-- 还击
	[  1966] = true, 	-- 佯攻
	[197003] = true, 	-- 动若脱兔

	-- Monk
	[122470] = true, 	-- 业报之触（敌方）
	[125174] = true, 	-- 业报之触（自己）	
	[116849] = true, 	-- 作茧缚命
	[115176] = true, 	-- 禅悟冥想
	[122278] = true, 	-- 躯不坏
	[122783] = true, 	-- 散魔功
	[120954] = true, 	-- 壮胆酒 酒仙
	[201318] = true, 	-- 壮胆酒 风行
	[243435] = true, 	-- 壮胆酒 织物
	[202162] = true, 	-- 斗转星移

	-- Mage
	[45438] = true, 	-- 寒冰屏障
	[198111] = true, 	-- 时光护盾
	[113862] = true, 	-- 强化隐形术
	[198065] = true, 	-- 陵彩屏障
	[198158] = true, 	-- 群体隐形

	-- Priest
	[213602] = true, 	-- 强化渐隐术
	[ 47585] = true, 	-- 消散
	[ 33206] = true, 	-- 痛苦压制
	[ 81782] = true, 	-- 真言术障
	[ 47788] = true, 	-- 守护之魂
	[232707] = true, 	-- 希望之光 
	[199412] = true, 	-- 狂乱边缘

	-- Warlock
	[212295] = true, 	-- 虚空守卫
	[104773] = true, 	-- 不灭决心
	[108416] = true, 	-- 黑暗契约
	[111400] = true, 	-- 爆燃冲刺	
}

local classBuffs = {
	['PRIEST'] = {
		[194384] = true,	-- 救赎
		[214206] = true,	-- 救赎(PvP)
		[ 41635] = true,	-- 愈合导言
		[193065] = true,	-- 忍辱负重
		[   139] = true,	-- 恢复
		[    17] = true,	-- 真言术盾
		[ 47788] = true,	-- 守护之魂
		[ 33206] = true,	-- 痛苦压制
	},
	['DRUID'] = {
		[   774] = true,	-- 回春
		[155777] = true,	-- 萌芽
		[  8936] = true,	-- 愈合
		[ 33763] = true,	-- 生命绽放
		[ 48438] = true,	-- 野性成长
		[207386] = true,	-- 春暖花开
		[102351] = true,	-- 结界
		[102352] = true,	-- 结界(HoT)
		[200389] = true,	-- 栽培
	},
	['PALADIN'] = {
		[ 53563] = true,	-- 道标
		[156910] = true,	-- 信仰道标
		[200025] = true,	-- 美德道标
		[  1022] = true,	-- 保护
		[  1044] = true,	-- 自由
		[  6940] = true,	-- 牺牲
		[223306] = true,	-- 赋予信仰
	},
	['SHAMAN'] = {
		[ 61295] = true,	-- 激流
		[   974] = true,	-- 大地之盾
		[207400] = true,	-- 先祖活力
	},
	['MONK'] = {
		[119611] = true,	-- 复苏之雾
		[116849] = true,	-- 作茧缚命
		[124682] = true,	-- 氤氲之雾
		[191840] = true,	-- 精华之泉
	},
	['ROGUE'] = {
		[ 57934] = true,	-- 嫁祸
	},
	['WARRIOR'] = {
		[114030] = true,	-- 警戒
	},
	['HUNTER'] = {
		[ 34477] = true,	-- 误导
		[ 90361] = true,	-- 灵魂治愈
	},
	['WARLOCK'] = {
		[ 20707] = true,	-- 灵魂石
	},
	['DEMONHUNTER'] = {},
	['MAGE'] = {},
	['DEATHKNIGHT'] = {},
}






local function FormatAuraTime(s)
	local day, hour, minute = 86400, 3600, 60

	if s >= day then
		return format('%d', F.Round(s/day))
	elseif s >= hour then
		return format('%d', F.Round(s/hour))
	elseif s >= minute then
		return format('%d', F.Round(s/minute))
	end
	return format('%d', mod(s, minute))
end


local function UpdateAuraTime(self, elapsed)
	if(self.expiration) then
		self.expiration = math.max(self.expiration - elapsed, 0)

		if(self.expiration > 0 and self.expiration < 30) then
			self.timer:SetText(FormatAuraTime(self.expiration))
			self.timer:SetTextColor(1, 0, 0)
		elseif(self.expiration > 30 and self.expiration < 60) then
			self.timer:SetText(FormatAuraTime(self.expiration))
			self.timer:SetTextColor(1, 1, 0)
		elseif(self.expiration > 60 and self.expiration < 300) then
			self.timer:SetText(FormatAuraTime(self.expiration))
			self.timer:SetTextColor(1, 1, 1)
		else
			self.timer:SetText()
		end
	end
end

local function AuraOnEnter(self)
	if not self:IsVisible() then return end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
	self:UpdateTooltip()
end

local function AuraOnLeave()
	GameTooltip:Hide()
end

local function UpdateAuraTooltip(aura)
	GameTooltip:SetUnitAura(aura:GetParent().__owner.unit, aura:GetID(), aura.filter)
end

local function PostCreateIcon(element, button)
	button.bg = F.CreateBG(button)
	button.glow = F.CreateSD(button.bg)
	
	element.disableCooldown = true
	button:SetFrameLevel(element:GetFrameLevel() + 4)

	button.overlay:SetTexture(nil)
	button.stealable:SetTexture(nil)
	button.cd:SetReverse(true)
	button.icon:SetDrawLayer('ARTWORK')
	button.icon:SetTexCoord(.08, .92, .25, .85)

	button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
	button.HL:SetColorTexture(1, 1, 1, .25)
	button.HL:SetAllPoints()

	button.count = button:CreateFontString(nil, 'OVERLAY')
	button.count:ClearAllPoints()
	button.count:SetPoint('TOPRIGHT', button, 2, 4)
	F.SetFS(button.count)

	button.timer = button:CreateFontString(nil, 'OVERLAY')
	button.timer:ClearAllPoints()
	button.timer:SetPoint('BOTTOMLEFT', button, 2, -4)
	F.SetFS(button.timer)

	button:HookScript('OnUpdate', UpdateAuraTime)

	button.UpdateTooltip = UpdateAuraTooltip
	button:SetScript('OnEnter', AuraOnEnter)
	button:SetScript('OnLeave', AuraOnLeave)
	button:SetScript('OnClick', function(self, button)
		if not InCombatLockdown() and button == 'RightButton' then
			CancelUnitBuff('player', self:GetID(), self.filter)
		end
	end)
end

local function PostUpdateIcon(element, unit, button, index, _, duration, _, debuffType)
	local style = element.__owner.unitStyle
	local _, _, _, _, duration, expiration, owner, canStealOrPurge = UnitAura(unit, index, button.filter)

	if not (style == 'party' and button.isDebuff) then
		button:SetSize(element.size, element.size*.75)
	end

	if(duration and duration > 0) then
		button.expiration = expiration - GetTime()
	else
		button.expiration = math.huge
	end

	if (style == 'party' and not button.isDebuff) or style == 'raid' or style == 'pet' then
		button.timer:Hide()
	end

	if canStealOrPurge and (style ~= 'party' or style ~= 'raid') then
		button.bg:SetVertexColor(1, 1, 1)

		if button.glow then
			button.glow:SetBackdropBorderColor(1, 1, 1, .65)
		end
	elseif button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.bg:SetVertexColor(color[1], color[2], color[3])

		if button.glow then
			button.glow:SetBackdropBorderColor(color[1], color[2], color[3], .65)
		end
	elseif (style == 'party' or style == 'raid') and not button.isDebuff then
		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, 0)
		end
	else
		button.bg:SetVertexColor(0, 0, 0)

		if button.glow then
			button.glow:SetBackdropBorderColor(0, 0, 0, .65)
		end
	end

	if duration then
		button.bg:Show()

		if button.glow then
			button.glow:Show()
		end
	end
end

local function BolsterPreUpdate(element)
	element.bolster = 0
	element.bolsterIndex = nil
end

local function BolsterPostUpdate(element)
	if not element.bolsterIndex then return end
	for _, button in pairs(element) do
		if button == element.bolsterIndex then
			button.count:SetText(element.bolster)
			return
		end
	end
end

local function CustomFilter(element, unit, button, name, _, _, _, _, _, caster, isStealable, _, spellID)
	local style = element.__owner.unitStyle

	if name and spellID == 209859 then
		element.bolster = element.bolster + 1
		if not element.bolsterIndex then
			element.bolsterIndex = button
			return true
		end
	elseif style == 'target' then
		if (cfg.debuffbyPlayer and button.isDebuff and not button.isPlayer) then
			return false
		else
			return true
		end
	elseif style == 'boss' then
		if (button.isDebuff and not button.isPlayer) then
			return false
		else
			return true
		end
	elseif style == 'party' or style == 'raid' then
		if (button.isDebuff and importantDebuffs[spellID]) then
			return true
		elseif (button.isPlayer and classBuffs[myClass][spellID]) or (importantBuffs[spellID]) then
			return true
		else
			return false
		end
	elseif style == 'focus' then
		if (button.isDebuff and button.isPlayer) then
			return true
		else
			return false
		end
	elseif style == 'arena' then
		return true
	elseif style == 'pet' then
		return true
	end
end
module.CustomFilter = CustomFilter

local function PostUpdateGapIcon(self, unit, icon, visibleBuffs)
	icon:Hide()
end

local function AuraIconSize(w, n, s)
	return (w-(n-1)*s)/n
end

function module:AddAuras(self)
	local num, perrow = 0, 0
	local Auras = CreateFrame('Frame', nil, self)

	if self.unitStyle == 'target' then
		Auras.initialAnchor = 'BOTTOMLEFT'
		Auras:SetPoint('BOTTOM', self, 'TOP', 0, 24)
		Auras['growth-y'] = 'UP'
		Auras['spacing-x'] = 5
		num = cfg.target_auraTotal
		perrow = cfg.target_auraPerRow
	elseif self.unitStyle == 'pet' or self.unitStyle == 'focus' or self.unitStyle == 'boss' or self.unitStyle == 'arena' then
		Auras.initialAnchor = 'TOPLEFT'
		Auras:SetPoint('TOP', self, 'BOTTOM', 0, -6)
		Auras['growth-y'] = 'DOWN'
		Auras['spacing-x'] = 5
	elseif self.unitStyle == 'pet' then
		num = cfg.pet_auraTotal
		perrow = cfg.pet_auraPerRow
	elseif self.unitStyle == 'focus' then
		num = cfg.focus_auraTotal
		perrow = cfg.focus_auraPerRow
	elseif self.unitStyle == 'boss' then
		num = cfg.boss_auraTotal
		perrow = cfg.boss_auraPerRow
	elseif self.unitStyle == 'arena' then
		num = cfg.arena_auraTotal
		perrow = cfg.arena_auraPerRow
	end

	Auras.numTotal = num
	Auras.iconsPerRow = perrow

	Auras.gap = true
	Auras.showDebuffType = true
	Auras.showStealableBuffs = true

	Auras.size = AuraIconSize(self:GetWidth(), Auras.iconsPerRow, 5)
	Auras:SetWidth(self:GetWidth())
	Auras:SetHeight((Auras.size) * F.Round(Auras.numTotal/Auras.iconsPerRow))

	Auras.CustomFilter = CustomFilter
	Auras.PostCreateIcon = PostCreateIcon
	Auras.PostUpdateIcon = PostUpdateIcon
	Auras.PostUpdateGapIcon = PostUpdateGapIcon
	Auras.PreUpdate = BolsterPreUpdate
	Auras.PostUpdate = BolsterPostUpdate

	self.Auras = Auras
end

function module:AddBuffs(self)
	local buffs = CreateFrame('Frame', nil, self)
	buffs.initialAnchor = 'CENTER'
	buffs:SetPoint('TOP', 0, -2)
	buffs['growth-x'] = 'RIGHT'
	buffs.spacing = 3
	buffs.num = 3
	
	if self.unitStyle == 'party' then
		buffs.size = 18
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				buffs:SetPoint('TOP', -20, -2)
			elseif icons.visibleBuffs == 2 then
				buffs:SetPoint('TOP', -10, -2)
			else
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	else
		buffs.size = 12
		buffs.PostUpdate = function(icons)
			if icons.visibleBuffs == 3 then
				buffs:SetPoint('TOP', -14, -2)
			elseif icons.visibleBuffs == 2 then
				buffs:SetPoint('TOP', -7, -2)
			else
				buffs:SetPoint('TOP', 0, -2)
			end
		end
	end

	buffs:SetSize((buffs.size*buffs.num)+(buffs.num-1)*buffs.spacing, buffs.size)

	buffs.disableCooldown = true
	buffs.disableMouse = true
	buffs.PostCreateIcon = PostCreateIcon
	buffs.PostUpdateIcon = PostUpdateIcon
	buffs.CustomFilter = CustomFilter

	self.Buffs = buffs
end

function module:AddDebuffs(self)
	local debuffs = CreateFrame('Frame', nil, self)
	
	if self.unitStyle == 'party' and not cfg.healer_layout then
		debuffs.initialAnchor = 'LEFT'
		debuffs['growth-x'] = 'RIGHT'
		debuffs:SetPoint('LEFT', self, 'RIGHT', 6, 0)
		debuffs.size = 24
		debuffs.num = 4
		debuffs.disableCooldown = false
		debuffs.disableMouse = false
	else
		debuffs.initialAnchor = 'CENTER'
		debuffs['growth-x'] = 'RIGHT'
		debuffs:SetPoint('BOTTOM', 0, cfg.power_height - 1)
		debuffs.size = 16
		debuffs.num = 2
		debuffs.disableCooldown = true
		debuffs.disableMouse = true

		debuffs.PostUpdate = function(icons)
			if icons.visibleDebuffs == 2 then
				debuffs:SetPoint('BOTTOM', -9, 0)
			else
				debuffs:SetPoint('BOTTOM')
			end
		end
	end

	debuffs.spacing = 5
	debuffs:SetSize((debuffs.size*debuffs.num)+(debuffs.num-1)*debuffs.spacing, debuffs.size)
	debuffs.showDebuffType = true
	debuffs.PostCreateIcon = PostCreateIcon
	debuffs.PostUpdateIcon = PostUpdateIcon
	debuffs.CustomFilter = CustomFilter

	self.Debuffs = debuffs
end