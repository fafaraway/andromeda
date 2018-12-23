local F, C = unpack(select(2, ...))
local module = F:GetModule("unitframe")


-- [[ Aura Filters ]]

-- ignored debuffs that healers don't want to see on party/raid frames
module.ignoredDebuffs = {
	[57724] = true, 	-- Sated
	[57723] = true,  	-- Exhaustion
	[80354] = true,  	-- Temporal Displacement
	[41425] = true,  	-- Hypothermia
	[95809] = true,  	-- Insanity
	[36032] = true,  	-- Arcane Blast
	[26013] = true,  	-- Deserter
	[95223] = true,  	-- Recently Mass Resurrected
	[97821] = true,  	-- Void-Touched (death knight resurrect)
	[36893] = true,  	-- Transporter Malfunction
	[36895] = true,  	-- Transporter Malfunction
	[36897] = true,  	-- Transporter Malfunction
	[36899] = true,  	-- Transporter Malfunction
	[36900] = true,  	-- Soul Split: Evil!
	[36901] = true,  	-- Soul Split: Good
	[25163] = true,  	-- Disgusting Oozeling Aura
	[85178] = true,  	-- Shrink (Deviate Fish)
	[8064] = true,   	-- Sleepy (Deviate Fish)
	[8067] = true,   	-- Party Time! (Deviate Fish)
	[24755] = true,  	-- Tricked or Treated (Hallow's End)
	[42966] = true, 	-- Upset Tummy (Hallow's End)
	[89798] = true, 	-- Master Adventurer Award (Maloriak kill title)
	[6788] = true,   	-- Weakened Soul
	[92331] = true, 	-- Blind Spot (Jar of Ancient Remedies)
	[71041] = true, 	-- Dungeon Deserter
	[26218] = true,  	-- Mistletoe
	[117870] = true,	-- Touch of the Titans
	[173658] = true, 	-- Delvar Ironfist defeated
	[173659] = true, 	-- Talonpriest Ishaal defeated
	[173661] = true, 	-- Vivianne defeated
	[173679] = true, 	-- Leorajh defeated
	[173649] = true, 	-- Tormmok defeated
	[173660] = true, 	-- Aeda Brightdawn defeated
	[173657] = true, 	-- Defender Illona defeated
	[206151] = true, 	-- 挑战者的负担
	[260738] = true, 	-- 艾泽里特残渣
	[279737] = true,
	[264689] = true,
}

-- buffs cast by the player that healers want to see on party/raid frames
module.myBuffs = {
	[774] = true,		-- 回春
	[8936] = true,		-- 愈合
	[33763] = true,		-- 生命绽放
	[48438] = true,		-- 野性成长
	[155777] = true,	-- 萌芽
	[102352] = true,	-- 塞纳里奥结界
	[200389] = true, 	-- 栽培

	[34477] = true, 	-- 误导

	[57934] = true, 	-- 嫁祸

	[12975] = true,		-- 援护
	[114030] = true, 	-- 警戒

	[61295] = true, 	-- 激流

	[1044] = true,		-- 自由祝福
	[6940] = true,		-- 牺牲祝福
	[25771] = true,		-- 自律
	[53563] = true,		-- 圣光道标
	[156910] = true,	-- 信仰道标
	[223306] = true,	-- 赋予信仰
	[200025] = true,	-- 美德道标
	[200654] = true,	-- 提尔的拯救
	[243174] = true, 	-- 神圣黎明

	[17] = true,		-- 真言术盾
	[139] = true,		-- 恢复
	[41635] = true,		-- 愈合祷言
	[47788] = true,		-- 守护之魂
	[194384] = true,	-- 救赎
	[152118] = true,	-- 意志洞悉
	[208065] = true, 	-- 图雷之光

	[119611] = true,	-- 复苏之雾
	[116849] = true,	-- 作茧缚命
	[124682] = true,	-- 氤氲之雾
	[124081] = true,	-- 禅意波
	[191840] = true,	-- 精华之泉
	[115175] = true, 	-- 抚慰之雾
}

-- buffs cast by anyone that healers want to see on party/raid frames
module.allBuffs = {
	-- Defensive buffs
	-- Warrior
	[199038] = true, 	-- 扶危助困
	[871] = true, 		-- 盾墙
	[213871] = true, 	-- 护卫
	[223658] = true, 	-- 捍卫
	[184364] = true, 	-- 狂怒回复
	[12975] = true, 	-- 破腹沉舟

	-- Death Knight
	[48707] = true, 	-- 反魔法护罩
	[123981] = true, 	-- 永劫不复	
	[145629] = true, 	-- 反魔法领域
	[48792] = true, 	-- 冰封之韧
	[48265] = true, 	-- 死亡脚步
	[212552] = true, 	-- 幻影步
	[81256] = true, 	-- 符文刃舞
	[194844] = true, 	-- 白骨风暴

	-- Paladin
	[228050] = true, 	-- 被遗忘的女王护卫
	[642] = true, 		-- 圣盾术
	[199448] = true, 	-- 无尽牺牲
	[1022] = true, 		-- 保护祝福
	[204018] = true, 	-- 破咒祝福
	[210256] = true, 	-- 庇护祝福
	[6940] = true, 		-- 牺牲祝福		
	[86659] = true, 	-- 远古列王守卫	
	[31850] = true, 	-- 炽热防御者
	[204150] = true, 	-- 圣光护盾		
	[31821] = true, 	--光环掌握
	[498] = true, 		-- 圣佑术	
	[205191] = true, 	-- 以眼还眼	
	[184662] = true, 	-- 复仇之盾
	[1044] = true, 		-- 自由祝福
	[199545] = true, 	-- 荣耀战马

	-- Shaman
	[8178] = true, 		-- 根基图腾
	[210918] = true, 	-- 灵体形态
	[207498] = true, 	--先祖护佑图腾
	[98007] = true, 	-- 灵魂链接图腾
	[204293] = true, 	-- 灵魂链接
	[108271] = true, 	-- 星界转移
    [201633] = true, 	--大地之墙图腾
    [260881] = true, 	--大地之墙图腾

    -- Hunter
    [186265] = true, 	-- 灵龟守护
	[202748] = true, 	-- 生存战术
	[248519] = true, 	-- 干涉
	[53480] = true, 	-- 牺牲咆哮
	[264735] = true, 	-- 优胜略汰
	[281195] = true, 	-- 优胜略汰孤狼技能
	[212704] = true, 	-- 野兽之心	
	[54216] = true, 	-- 主人的召唤

	-- Demon Hunter
	[196555] = true, 	-- 虚空行走
	[221527] = true, 	-- 拘押	
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
	[61336] = true, 	-- 生存本能
	[102342] = true, 	-- 铁木树皮
	[22812] = true, 	-- 树皮术
	[201940] = true, 	-- 盟友守护
	[236696] = true, 	-- 荆棘
	[200947] = true, 	-- 侵蚀藤曼
	[201664] = true, 	-- 挫志咆哮
	[234084] = true, 	-- 明月繁星

	-- Rogue
	[11327] = true, 	-- 消失
	[199754] = true, 	-- 还击
	[1966] = true, 		-- 佯攻
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
	[47585] = true, 	-- 消散
	[33206] = true, 	-- 痛苦压制
	[81782] = true, 	-- 真言术障
	[47788] = true, 	-- 守护之魂
	[232707] = true, 	-- 希望之光 
	[199412] = true, 	-- 狂乱边缘
	[6788] = true, 		-- 虚弱灵魂

	-- Warlock
	[212295] = true, 	-- 虚空守卫
	[104773] = true, 	-- 不灭决心
	[108416] = true, 	-- 黑暗契约
	[111400] = true, 	-- 爆燃冲刺	
}
