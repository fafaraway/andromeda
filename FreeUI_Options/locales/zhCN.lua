local _, ns = ...


ns.localization.misc = {
	reset = "重置",
	reset_check = "|cffff2020是否移除所有已保存的选项并重置为默认值？|r",
	install = "安装",
	install_tip = "打开安装向导。",
	profile = "角色单独配置",
	profile_tip = "为当前角色使用单独的配置，所有的选项只对当前角色生效。",
	profile_check = "|cffff2020是否转换选项配置为角色单独/账号通用？|r",
	reload_check = "|cffff2020是否重载界面来完成设置？|r",
	need_reload = "|cffff2020需要重载界面来应用改动！|r",
	credit = "致谢",
	credit_title = "Credits",
	credit_body = "Haleth, siweia\nAlza, Haste, Tukz, Zork\nGethe, Elv, Allez, Lightspark, AlleyKat, Caellian, p3lim, Shantalya, tekkub, Tuller, Wildbreath\nShestak, aliluya555, Paojy, Rubgrsch, aduth, silverwind, Nibelheim, humfras"
}

ns.localization.aura = {
	header = "光环",
	desc = "这些选项控制大部分和光环相关的设置。",
	sub_basic = '基础设定',
	sub_adjustment = '调整',
	enable = "启用",
	enable_tip = "启用光环模块。",
	reverseBuffs = "反向排列增益光环",
	reverseDebuffs = "反向排列减益光环",
	reminder = "缺失增益提醒",
	reminder_tip = "提醒你缺失的自身增益光环(法师智力牧师耐力之类)。",
	buffSize = "增益图标大小",
	debuffSize = "减益图标大小",
	buffsPerRow = "增益图标每行数量",
	debuffsPerRow = "减益图标每行数量",
	margin = "图标间隔",
	offset = "增益/减益栏间隔",
}

ns.localization.combat = {
	header = "战斗",
	desc = "这些选项控制大部分和战斗相关的设置。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用战斗模块。",
	combat_alert = "进出战斗提醒",
	combat_alert_tip = "进入/离开战斗时显示提醒。",
	spell_alert = "特殊技能提醒",
	spell_alert_tip = "成功打断/驱散时播放一个提醒音效。",
	health_alert = "低血量提醒",
	health_alert_tip = "血量低于阈值时播放一个提醒音效。",
	sub_fct = '滚动战斗信息',
	fct_incoming = "显示玩家受到的伤害和治疗",
	fct_incoming_tip = "显示玩家受到的伤害和治疗。",
	fct_outgoing = "显示玩家造成的伤害和治疗",
	fct_outgoing_tip = "显示玩家造成的伤害和治疗。",
	fct_pet = "显示宠物造成的伤害和治疗",
	fct_pet_tip = "显示玩家宠物造成的伤害和治疗。",
	fct_merge = "合并多目标伤害和治疗",
	fct_merge_tip = "尝试合并显示多目标伤害和治疗。",
	fct_periodic = "显示周期性效果",
	fct_periodic_tip = "显示周期性伤害和治疗。",
	sub_adjustment = '调整',
	health_alert_threshold = "低血量阈值",
	sub_pvp = 'PVP 相关',
	auto_tab = '自动切换 Tab 模式',
	auto_tab_tip = '在 PVP 环境中忽略宠物类单位优先选择敌方玩家。',
	pvp_sound = '击杀音效',
	pvp_sound_tip = '给 PVP 击杀和连杀添加音效。',
}

ns.localization.cooldown = {
	header = "冷却",
	desc = "技能/物品的冷却计时。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用冷却模块。",
	decimal = "精确计时",
	decimal_tip = "冷却快要结束时显示毫秒。",
	excludeWA = "忽略 WeakAuras 图标",
	excludeWA_tip = "冷却计时忽略 WeakAuras 图标，方便使用 WeakAuras 自己的冷却计时功能，避免同时出现两个计时。",
	pulse = "冷却完成提醒",
	pulse_tip = "任意技能或物品完成冷却后会在屏幕中央闪现相应的图标。",
	decimalCount = "精确计时设定",
	decimalCount_tip = "冷却剩下几秒时显示毫秒。",
	sub_adjustment = '调整',
}

ns.localization.unitframe = {
	header = "头像",
	desc = "这些选项控制大部分和头像相关的设置。",
	enable = "启用",
	enable_tip = "启用头像模块。",

}

ns.localization.inventory = {
	header = "背包",
	desc = "这些选项控制大部分和背包相关的设置。",
	sub_basic = '基础设定',
	sub_adjustment = '调整',
	enable = "启用",
	enable_tip = "启用背包模块。",
	newitemFlash = "新物品闪光",
	newitemFlash_tip = "新获得的物品闪光。",
	reverseSort = "反向整理",
	reverseSort_tip = "物品优先整理到背包底部。",
	combineFreeSlots = "整合空余格子",
	combineFreeSlots_tip = "整合空余格子以节约空间。",
	useCategory = "物品分类",
	useCategory_tip = "启用物品分类，不同种类的物品分开归纳。",
	itemLevel = "显示物品等级",
	itemLevel_tip = "显示物品等级",
	slotSize = '格子大小',
	spacing = '格子间隔',
	bagColumns = '背包每行格子数量',
	bankColumns = '银行每行格子数量',
}

ns.localization.general = {
	header = "综合",
	desc = "这些选项控制大部分的通用设置。",
	sub_basic = '基础设定',
	alreadyKnown = '已知染色',
	alreadyKnown_tip = '在商人以及拍卖面板为已经学会的配方宠物坐骑添加一层绿色的染色方便分辨。',
	blizzMover = '解锁暴雪默认面板',
	blizzMover_tip = '解锁暴雪默认面板，使之可以自由拖动。',
	hideBossBanner = '隐藏副本掉落通知横幅',
	hideBossBanner_tip = '隐藏副本掉落通知横幅。',
	hideTalkingHead = '隐藏情景对话框体',
	hideTalkingHead_tip = '隐藏情景对话框体。',
	mailButton = '邮件收取增强',
	mailButton_tip = '一键收取所有邮件并显示邮件所含金额及物品。',
	trade_tabs = '生活技能快捷标签',
	trade_tabs_tip = '在专业面板右侧添加各类商业以及生活技能的快捷标签。',
	missingStats = '属性补全',
	missingStats_tip = '人物面板显示所有被隐藏的属性。',
	petFilter = '宠物类型快捷标签',
	petFilter_tip = '在宠物面板添加切换宠物类型的快捷标签。',
	tradeTargetInfo = '交易保护',
	tradeTargetInfo_tip = '在交易面板显示当前交易目标的信息避免受骗。',
	undressButton = '试衣间增强',
	undressButton_tip = '在试衣间面板添加脱衣按钮。',
	item_level = '显示物品等级',
	item_level_tip = '在角色面板显示物品等级。',


	merchant_ilvl = '商人面板显示物品等级',
	merchant_ilvl_tip = '在商人面板显示物品等级。',
	gem_enchant = '宝石附魔信息',
	gem_enchant_tip = '在角色面板显示宝石附魔信息。',
	azerite_traits = '艾泽里特特质',
	azerite_traits_tip = '在角色面板显示艾泽里特之心的特质信息。',


	errors = '错误信息简化',
	errors_tip = '错误信息简化。',
	keystone = '账号钥石信息',
	keystone_tip = '大秘境界面保存记录账号下所有角色的钥石信息，改名或转服后可以使用鼠标中键点击来清空已保存的信息。',
	queue_timer = '队列计时',
	queue_timer_tip = '排队等候窗口添加计时条。',
	rare_alert = '稀有提醒',
	rare_alert_tip = '当身边发现稀有怪物或事件时发出提醒。',
	color_picker = '颜色选取面板增强',
	color_picker_tip = '颜色选取面板添加复制黏贴功能并且显示选中颜色的具体数值。',
	sub_camera = '镜头视角',
	actionCam = '动作模式',
	actionCam_tip = '使用动作模式的镜头视角。',
	fasterCam = '快速调整',
	fasterCam_tip = '加快视角拉近拉远的调整速度。',
	sub_uiscale = '界面缩放',
	uiScale = '全局缩放设定',
	uiScale_tip = '全局界面缩放设定，建议1080P设为1，1440P设为1.4，2160P设为2。',
}

ns.localization.notification = {
	header = "事件提醒",
	desc = "这些选项控制大部分和提醒相关的设置。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用事件提醒模块。",
	bag_full = "包裹满了",
	bag_full_tip = "当包裹满了时弹出提醒。",
	new_mail = "新邮件",
	new_mail_tip = "收到新邮件时弹出提醒。",
	version_check = "版本检查",
	version_check_tip = "检测到 FreeUI 有新版本时弹出提醒。",
}

ns.localization.automation = {
	header = "便利功能",
	desc = "一些简易快捷的自动化便利功能。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用便利功能模块。",
	easy_delete = "快速删除物品",
	easy_delete_tip = "删除物品时自动填入 Delete 字符串。",
	easy_focus = "快速设定焦点",
	easy_focus_tip = "按住 Shift 键点击任意单位可快速设为焦点，点击空白处可取消焦点。",
	easy_focus_on_ouf = "快速设定焦点（头像框体）",
	easy_focus_on_ouf_tip = "快速设定焦点功能对头像框体生效，注意该功能可能和点击施法冲突。",
	easy_mark = "快速设定标记",
	easy_mark_tip = "按住 Alt 键点击任意单位可快速设定标记。",
	easy_naked = "快速脱光装备",
	easy_naked_tip = "角色面板添加一个按钮，双击可以快速脱光装备。",
	easy_buy_stack = "整组物品购买",
	easy_buy_stack_tip = "商人窗口按住 Alt 键可以直接购买整组物品。",
	auto_screenshot = "自动截图",
	auto_screenshot_tip = "玩家获得成就或完成史诗地下城的时候自动截图。",
	auto_reject_stranger = "自动屏蔽陌生人邀请",
	auto_reject_stranger_tip = "自动屏蔽陌生人邀请。",
	auto_toggle_chat_bubble = "自动开关聊天气泡",
	auto_toggle_chat_bubble_tip = "进入副本显示聊天气泡，离开副本则关闭。",
	instant_loot = "快速拾取",
	instant_loot_tip = "跳过拾取的动画和延迟。",

}

ns.localization.announcement = {
	header = "副本通告",
	desc = "在副本中通告一些战斗/补给相关的事件。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用副本通告模块。",
	my_interrupt = "打断",
	my_interrupt_tip = "玩家成功打断时发出通告。",
	my_dispel = "驱散",
	my_dispel_tip = "玩家成功驱散时发出通告。",
	get_sapped = "闷棍",
	get_sapped_tip = "玩家被闷棍时发出通告。",
	combat_rez = "战复",
	combat_rez_tip = "队伍中有人战复时发出通告。",
	sub_combat = '战斗',
	feast_cauldron = "大餐药锅",
	feast_cauldron_tip = "队伍中有人放置大餐药锅时发出通告。",
	bot_codex = "修理相关",
	bot_codex_tip = "队伍中有人放置修理机器人或者圣典时发出通告。",
	mage_portal = "传送门",
	mage_portal_tip = "队伍中有法师开启传送门时发出通告。",
	ritual_of_summoning = "召唤仪式",
	ritual_of_summoning_tip = "队伍中有术士施放召唤仪式时发出通告。",
	create_soulwell = "灵魂之井",
	create_soulwell_tip = "队伍中有术士施放灵魂之井时发出通告。",
	mail_service = "邮件相关",
	mail_service_tip = "队伍中有人放置邮件工具时发出通告。",
	conjure_refreshment = "餐桌",
	conjure_refreshment_tip = "队伍中有法师施放餐桌时发出通告。",
	special_toy = "特殊玩具",
	special_toy_tip = "队伍中有人使用特殊玩具时发出通告。",
}

ns.localization.theme = {
	header = "外观",
	desc = "这些选项控制大部分和外观相关的设置。",
	sub_basic = '基础设定',
	cursor_trail = "鼠标闪光",
	cursor_trail_tip = "鼠标指针移动时闪光方便定位。",
	vignetting = "暗角效果",
	vignetting_tip = "在屏幕边缘添加一层暗角效果。",
	reskin_blizz = "美化默认界面",
	reskin_blizz_tip = "用统一的外观来美化游戏默认界面。",
	flat_style = "扁平风格",
	flat_style_tip = "按钮类的界面元素使用扁平风格。",
	shadow_border = "阴影边框",
	shadow_border_tip = "给各类界面元素添加阴影边框。",
	sub_adjustment = '调整',
	backdrop_color = "背景颜色",
	backdrop_color_tip = "调整外观的背景颜色。",
	backdrop_alpha = "背景透明度",
	backdrop_alpha_tip = "调整外观的背景透明度。",
	backdrop_border_color = "边框颜色",
	backdrop_border_color_tip = "调整外观的边框颜色。",
	backdrop_border_alpha = "边框透明度",
	backdrop_border_alpha_tip = "调整外观的边框透明度。",
	flat_color = "扁平风格颜色",
	flat_color_tip = "调整扁平风格的按钮颜色。",
	flat_alpha = "扁平风格透明度",
	flat_alpha_tip = "调整扁平风格的按钮透明度。",
	sub_addons = '插件适配',
	reskin_dbm = "DBM",
	reskin_dbm_tip = "美化 DBM 的计时条。",
	reskin_weakauras = "WeakAuras",
	reskin_weakauras_tip = "美化 WeakAuras 的图标。",
	reskin_pgf = "Premade Groups Filter",
	reskin_pgf_tip = "美化 Premade Groups Filter 的窗口。",
	reskin_skada = "Skada",
	reskin_skada_tip = "美化 Skada 的窗口。",
}

ns.localization.infobar = {
	header = "信息条",
	desc = "屏幕顶端的信息条，包含若干功能组件。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用信息条模块。",
	mouseover = "鼠标悬停",
	mouseover_tip = "鼠标悬停信息条显示各个分栏。",
	stats = "系统",
	stats_tip = "显示时间延迟帧数插件占用等系统信息。",
	spec = "天赋专精",
	spec_tip = "显示天赋专精的详情，右键点击切换专精和拾取。",
	guild = "公会",
	guild_tip = "显示公会在线状态。",
	friends = "好友",
	friends_tip = "显示好友在线状态。",
	report = "任务报告",
	report_tip = "显示日常/周常/入侵/要塞任务等相关信息。",
	durability = "耐久",
	durability_tip = "显示当前装备的耐久状况。",
	sub_adjustment = '调整',
	height = "信息条高度",
	height_tip = "调整信息条的高度。",
}

ns.localization.actionbar = {
	header = "动作条",
	desc = "这些选项控制大部分和动作条相关的设置。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用动作条模块。",
	button_hotkey = "显示快捷键",
	button_hotkey_tip = "在动作条上显示绑定的快捷键。",
	button_macro_name = "显示宏名",
	button_macro_name_tip = "在动作条上显示宏的名字。",
	button_count = "显示物品计数",
	button_count_tip = "在动作条上显示物品计数。",
	button_class_color = "动作条按照职业染色",
	button_class_color_tip = "在动作条上使用职业染色。",
	button_range = "按钮状态染色",
	button_range_tip = "根据技能是否能使用来染色按钮。",
	bar3_divide = "加长动作条",
	bar3_divide_tip = "拆分第三栏动作条，注意先在下面的动作条控制里启用第三栏动作条。",
	sub_extra = '动作条控制',
	bar1 = "显示第一栏动作条",
	bar1_tip = "显示第一栏动作条，游戏默认界面的主动作条。",
	bar1_fade = "第一栏动作条渐隐",
	bar1_fade_tip = "鼠标悬停时显示，鼠标移开后会渐隐消失。",
	bar2 = "显示第二栏动作条",
	bar2_tip = "显示第二栏动作条，游戏默认界面的左下角动作条。",
	bar2_fade = "第二栏动作条渐隐",
	bar2_fade_tip = "鼠标悬停时显示，鼠标移开后会渐隐消失。",
	bar3 = "显示第三栏动作条",
	bar3_tip = "显示第三栏动作条，游戏默认界面的右下角动作条。",
	bar3_fade = "第三栏动作条渐隐",
	bar3_fade_tip = "鼠标悬停时显示，鼠标移开后会渐隐消失。",
	bar4 = "显示第四栏动作条",
	bar4_tip = "显示第四栏动作条，游戏默认界面的右侧动作条。",
	bar4_fade = "第四栏动作条渐隐",
	bar4_fade_tip = "鼠标悬停时显示，鼠标移开后会渐隐消失。",
	bar5 = "显示第五栏动作条",
	bar5_tip = "显示第五栏动作条，游戏默认界面的右侧动作条。",
	bar5_fade = "第五栏动作条渐隐",
	bar5_fade_tip = "鼠标悬停时显示，鼠标移开后会渐隐消失。",
	pet_bar = "宠物动作条",
	pet_bar_tip = "显示宠物动作条。",
	pet_bar_fade = "宠物动作条渐隐",
	pet_bar_fade_tip = "鼠标悬停时显示，鼠标移开后会渐隐消失。",
	sub_adjustment = '调整',
	button_size_small = "侧边栏大小",
	button_size_small_tip = "调整右侧动作条以及宠物动作条的大小。",
	button_size_normal = "主动作条大小",
	button_size_normal_tip = "调整主动作条大小。",
	button_size_big = "姿态栏大小",
	button_size_big_tip = "调整姿态栏大小。",
}

ns.localization.quest = {
	header = "任务",
	desc = "这些选项控制大部分和任务相关的设置。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用任务模块。",
	questLevel = "任务等级",
	questLevel_tip = "在任务日志显示任务等级。",
	rewardHightlight = "自动选择高价值任务奖励",
	rewardHightlight_tip = "交任务时自动选择高价值的奖励物品。",
	completeRing = "任务完成提示",
	completeRing_tip = "任务完成时播放一个音效提示。",
	questNotifier = "任务通报",
	questNotifier_tip = "组队时自动通报任务进度。",
	extraQuestButton = "任务道具增强",
	extraQuestButton_tip = "有可以使用的任务道具时自动显示在屏幕中央。",
}

ns.localization.chat = {
	header = "聊天",
	desc = "这些选项控制大部分和聊天相关的设置。",
	sub_basic = '基础设定',
	enable = '启用',
	enable_tip = '启用聊天模块。',
	lock = '锁定',
	lock_tip = '锁定聊天框的位置。',
	fading = '渐隐',
	fading_tip = '聊天框在一段时间没有新内容后会渐隐淡化。',
	outline = '字体描边',
	outline_tip = '为聊天框字体添加描边。',
	voiceIcon = '语音按钮',
	voiceIcon_tip = '显示语音按钮。',
	sub_feature = '便利功能',
	abbreviate = '频道名简化',
	abbreviate_tip = '频道名简化。',
	whisperAlert = '密语提醒',
	whisperAlert_tip = '收到密语时播放一个提示音，普通密语和战网密语的提示音不同。',
	itemLinks = '物品详情',
	itemLinks_tip = '聊天框的物品显示详细的图标装等部位宝石等信息。',
	spamageMeter = '统计简化',
	spamageMeter_tip = '简化伤害统计类插件发出的统计信息。',
	sticky = '密语锁定',
	sticky_tip = '密语时锁定频道。',
	cycles = '快速切换频道',
	cycles_tip = '输入框激活时按下tab可以快速切换频道。',
	chatCopy = '复制按钮',
	chatCopy_tip = '鼠标中键点击聊天框左上角的按钮可以复制聊天内容，左键点击隐藏/显示聊天框，右键点击加入/离开世界频道。',
	urlCopy = '链接复制',
	urlCopy_tip = '点击聊天框的链接可以快速复制。',
	blockStranger = '屏蔽陌生人的密语',
	blockStranger_tip = '屏蔽来自陌生人的密语。',
	allowFriendsSpam = '允许好友的广告',
	allowFriendsSpam_tip = '允许来自好友队友以及公会会员的广告类内容。',
	sub_filter = '过滤',
	filters = '聊天过滤',
	filters_tip = '过滤重复性刷屏各种符号以及包含关键字的内容。',
	blockAddonSpam = '插件过滤',
	blockAddonSpam_tip = '过滤插件自动发出的各类刷屏信息。',
	profanity = '脏话过滤',
	profanity_tip = '启用脏话过滤，脏话和敏感词会显示为乱码。',
}

ns.localization.map = {
	header = "地图",
	desc = "这些选项控制大部分和地图相关的设置。",
	sub_basic = '基础设定',
	sub_adjustment = '调整',
	sub_minimap = '小地图',
	enable = "启用",
	enable_tip = "启用地图模块。",
	coords = "显示坐标",
	coords_tip = "在大地图上显示玩家和鼠标的当前坐标。",
	whoPings = "显示谁在点击小地图",
	whoPings_tip = "显示哪个队友在点击小地图。",
	expBar = "综合进度条",
	expBar_tip = "在小地图上显示一个进度条，显示经验/声望/荣誉信息。",
	microMenu = "整合菜单",
	microMenu_tip = "中键点击小地图弹出整合菜单。",
	minimapScale = "小地图缩放",
	minimapScale_tip = "调整小地图的大小。",
}

ns.localization.tooltip = {
	header = "鼠标提示",
	desc = "这些选项控制大部分和鼠标提示相关的设置。",
	sub_basic = '基础设定',
	enable = "启用",
	enable_tip = "启用鼠标提示模块。",
	follow_cursor = "跟随鼠标",
	follow_cursor_tip = "鼠标提示的位置跟随鼠标。",
	hide_title = "隐藏头衔",
	hide_title_tip = "隐藏玩家头衔。",
	hide_realm = "隐藏服务器",
	hide_realm_tip = "隐藏玩家服务器。",
	hide_rank = "隐藏公会等级",
	hide_rank_tip = "隐藏玩家公会等级。",
	hide_in_combat = "战斗中隐藏",
	hide_in_combat_tip = "战斗中隐藏鼠标提示。",
	border_color = "边框染色",
	border_color_tip = "鼠标提示的边框根据物品品质染色。",
	spec_ilvl = "天赋装等",
	spec_ilvl_tip = "按住 Alt 显示天赋装等。",
	extra_info = "物品额外信息",
	extra_info_tip = "按住 Alt 显示物品额外信息，比如堆叠售价标识等。",
	azerite_trait = "艾泽里特特质",
	azerite_trait_tip = "显示艾泽里特装备的特质。",
	link_hover = "聊天栏物品链接",
	link_hover_tip = "显示聊天栏物品链接的鼠标提示。",
	icon = "物品图标",
	icon_tip = "显示物品图标。",
	target_by = "目标选中信息",
	target_by_tip = "显示目标选中信息。",
	pet_info = "宠物信息",
	pet_info_tip = "显示宠物信息。",

	aura_source = "光环来源",
	aura_source_tip = "按住 Alt 显示光环的来源信息。",
	mount_source = "坐骑来源",
	mount_source_tip = "按住 Alt 显示坐骑的来源信息。",
}




--[[ 



L.unitframe = "单位框体"
L.unitframe_subText = "这些选项控制大部分和单位框体相关的设置。"
L.unitframe_enable = "启用单位框体"
L.unitframe_enable_tip = "禁用该项如果你想要使用其他的单位框体类插件。"

L.unitframe_subCategory_basic = "基本设定"
L.unitframe_transMode = "透明风格"
L.unitframe_transMode_tip = "禁用该项如果你喜欢实色风格。"
L.unitframe_colourSmooth = "平滑染色"
L.unitframe_colourSmooth_tip = "玩家/目标/焦点的血量根据当前血量百分比染色。"
L.unitframe_portrait = "动态肖像"
L.unitframe_portrait_tip = "添加动态肖像。"
L.unitframe_healer = "治疗布局"
L.unitframe_healer_tip = "对治疗职业更友好的对称布局，小队/团队框体集中在屏幕中下部。"
L.unitframe_frameVisibility = "极简模式"
L.unitframe_frameVisibility_tip = "默认隐藏玩家头像框体，进入战斗或者选择目标后显示。"

L.unitframe_subCategory_feature = "额外功能"
L.unitframe_rangeCheck = "距离提示"
L.unitframe_rangeCheck_tip = "超出距离的框体淡化。"
L.unitframe_dispellable = "驱散提示"
L.unitframe_dispellable_tip = "如果小队/团队成员中了你可以驱散的减益效果，该成员的框体会高亮提示，高亮颜色取决于减益效果的类型。"
L.unitframe_comboPoints = "连击点"
L.unitframe_comboPoints_tip = "显示连击点(盗贼德鲁伊)。"
L.unitframe_energyTicker = "回能提示"
L.unitframe_energyTicker_tip = "显示能量回复的提示(盗贼德鲁伊)。"
L.unitframe_onlyShowPlayer = "减益光环过滤"
L.unitframe_onlyShowPlayer_tip = "只显示玩家施放的减益光环。"
L.unitframe_clickCast = "点击施法"
L.unitframe_clickCast_tip = "启用点击施法功能。\n点击技能面板右下的图标或者使用命令行 /freeui clickcast 可以打开点击施法绑定面板。"



L.unitframe_subCategory_castbar = "施法条相关"
L.unitframe_enableCastbar = "启用施法条"
L.unitframe_enableCastbar_tip = "禁用该项如果你想要使用其他的施法条类插件。"
L.unitframe_castbar_separatePlayer = "分离玩家施法条"
L.unitframe_castbar_separateTarget = "分离目标施法条"
L.unitframe_castbar_separatePlayer_tip = "显示单独分离的玩家施法条"
L.unitframe_castbar_separateTarget_tip = "显示单独分离的目标施法条"

L.unitframe_subCategory_extra = "其他框架"
L.unitframe_enableGroup = "启用小队/团队框架"
L.unitframe_enableGroup_tip = "禁用此项如果你想要使用其他小队/团队框架类插件。"
L.unitframe_groupNames = "显示名字"
L.unitframe_groupNames_tip = "在小队/团队框体上显示名字。"
L.unitframe_groupColourSmooth = "平滑染色"
L.unitframe_groupColourSmooth_tip = "小队/团队的血量根据当前血量百分比染色。"
L.unitframe_groupFilter = "显示队伍数量"



L.classmod = "职业特定"
L.classmodSubText = "设置加载职业特定的组件"

local classes = UnitSex("player") == 2 and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE

for class, localized in pairs(classes) do
	L["classmod"..strlower(class)] = localized
end

L.classmodhavocFury = "|cffffffff 恶魔猎手"
L.classmodhavocFuryTooltip = "根据浩劫怒气值改变怒气条颜色" ]]



