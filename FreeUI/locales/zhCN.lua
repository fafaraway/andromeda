local F, C, L = unpack(select(2, ...))


--[[ Binding ]]

do
	_G.BINDING_HEADER_FREEUI = 'FreeUI'
	_G.BINDING_NAME_TOGGLE_FREEUI_GUI = '开关设置面板'
	_G.BINDING_NAME_TOGGLE_QUEST_TRACKER = '开关任务追踪'
end


--[[ Misc ]]

do
	L['MISC_NUMBER_CAP'] = {'万', '亿', '兆'}


	L['MISC_REPUTATION'] = '声望'
	L['MISC_PARAGON'] = '巅峰'
	L['MISC_PARAGON_REPUTATION'] = '巅峰声望'
	L['MISC_PARAGON_NOTIFY'] = '巅峰声望已满注意兑换'
	L['MISC_ORDERHALL_TIP'] = '按住Shift显示详细信息'


	L['MISC_DISBAND_GROUP'] = '解散队伍'
	L['MISC_DISBAND_GROUP_CHECK'] = '你确定要解散队伍?'



	L['MISC_DECLINE_INVITE'] = '自动拒绝了 %s 的组队邀请'
	L['MISC_ACCEPT_INVITE'] = '自动接受了 %s 的组队邀请'

	L['AUTOMATION_GET_NAKED'] = '双击脱光装备'
	L['AUTOMATION_BUY_STACK'] = '是否购买|cffff0000一组|r下列物品？'


	L['MISC_GROUP_TOOL'] = '团队工具'
	L['MISC_FOOD'] = '食物'
	L['MISC_FLASK'] = '合剂'
	L['MISC_LACK'] = '缺少'
	L['MISC_PLAYER_COUNT'] = '%s名玩家'
	L['MISC_COUNT_DOWN'] = '开始/取消倒计时'
	L['MISC_CHECK_STATUS'] = '食物合剂检查'
	L['MISC_BUFFS_READY'] = '食物合剂检查: 已齐全'
	L['MISC_RAID_BUFF_CHECK'] = '食物合剂检查:'
	L['MISC_EXRT_POTION_CHECK'] = 'ExRT药水使用报告'
	L['MISC_ADDON_REQUIRED'] = '你没有安装DBM或者BigWigs'
	L['MISC_DISBAND_CHECK'] = '是否|cffff0000解散|r当前队伍或者团队?'
	L['MISC_DISBAND_PROCESS'] = '团队解散中'
end


--[[ Blizzard ]]
do
	L['BLIZZARD_MOVER_ALERT'] = 'Alert frame'
	L['BLIZZARD_MOVER_VEHICLE'] = 'Vehicle indicator'
	L['BLIZZARD_MOVER_UIWIDGET'] = 'UIWidget frame'
	L['BLIZZARD_UNDRESS'] = '脱衣'
	L['BLIZZARD_STRANGER'] = '陌生人'
	L['BLIZZARD_KEYSTONES'] = '钥石信息'
	L['BLIZZARD_KEYSTONES_RESET'] = '清除已保存的钥石信息'
	L['BLIZZARD_GET_NAKED'] = '双击脱光装备'
	L['BLIZZARD_ORDERHALL_TIP'] = '按住<Shift>显示详细信息'
	L['BLIZZARD_GOLD'] = '金币'
end


--[[ Appearance ]]

do
	L['APPEARANCE_NAME'] = '外观'
	L['APPEARANCE_DESC'] = '调整用户界面的外观'

	L['APPEARANCE_CURSOR_TRAIL'] = '鼠标闪光'
	L['APPEARANCE_VIGNETTING'] = '暗角效果'
	L['APPEARANCE_VIGNETTING_ALPHA'] = '暗角透明度'
	L['APPEARANCE_RESKIN_BLIZZ'] = '美化默认界面'
	L['APPEARANCE_RESKIN_BLIZZ_TIP'] = '\n美化游戏内的所有默认界面，统一为黑色透明风格。'
	L['APPEARANCE_BACKDROP_ALPHA'] = '背景透明度'
	L['APPEARANCE_BACKDROP_ALPHA_TIP'] = '\n调整窗口面板的背景透明度。'
	L['APPEARANCE_SHADOW_BORDER'] = '阴影边框'
	L['APPEARANCE_SHADOW_BORDER_TIP'] = '\n界面元素外围添加一圈阴影'

	L['APPEARANCE_UI_SCALE'] = '界面缩放'
	L['APPEARANCE_UI_SCALE_TIP'] = '\n调整界面的整体缩放\n推荐设置\n1080P = 1\n1440P = 1.4\n2160P = 2'
end


--[[ Notification ]]

do
	L['NOTIFICATION_NAME'] = '提醒'
	L['NOTIFICATION_DESC'] = '提醒一些需要注意的事件'

	L['NOTIFICATION_NEW_MAIL'] = '收到新邮件！'
	L['NOTIFICATION_BAG_FULL'] = '背包满了！'
	L['NOTIFICATION_MAIL'] = '邮件'
	L['NOTIFICATION_BAG'] = '背包'
	L['NOTIFICATION_RARE'] = '发现稀有'
	L['NOTIFICATION_VERSION'] = '版本检查'
	L['NOTIFICATION_VERSION_OUTDATE'] = '你的 FreeUI 已经过期，最新版为 %s'
end


--[[ Infobar ]]

do
	L['INFOBAR_NAME'] = '信息条'
	L['INFOBAR_DESC'] = '提供一些常用的游戏信息'

	L['INFOBAR_DURABILITY'] = '装备耐久'
	L['INFOBAR_OPEN_CHARACTER_PANEL'] = '打开角色面板'

	L['INFOBAR_FRIENDS'] = '朋友'
	L['INFOBAR_OPEN_FRIENDS_PANEL'] = '打开好友面板'
	L['INFOBAR_ADD_FRIEND'] = '添加好友'

	L['INFOBAR_GUILD'] = '公会'
	L['INFOBAR_GUILD_NONE'] = '无'
	L['INFOBAR_OPEN_GUILD_PANEL'] = '打开公会面板'

	L['INFOBAR_REPORT'] = '报告'
	L['INFOBAR_DAILY_WEEKLY_INFO'] = '日常/周常信息'
	L['INFOBAR_BLINGTRON'] = '布林顿每日礼包'
	L['INFOBAR_MEAN_ONE'] = '冬幕节日常'
	L['INFOBAR_TIMEWARPED'] = '时光漫游徽章奖励'
	L['INFOBAR_INVASION_LEG'] = '军团突袭'
	L['INFOBAR_INVASION_BFA'] = '阵营突袭'
	L['INFOBAR_INVASION_CURRENT'] = '当前: '
	L['INFOBAR_INVASION_NEXT'] = '下次: '
	L['INFOBAR_LESSER_VISION'] = '恩佐斯的小幻象'
	L['INFOBAR_ISLAND'] = '海岛探险'
	L['INFOBAR_OPEN_BFA_REPORT'] = '打开任务报告(BFA)'
	L['INFOBAR_OPEN_LEG_REPORT'] = '打开任务报告(LEG)'
	L['INFOBAR_OPEN_WOD_REPORT'] = '打开任务报告(WOD)'

	L['INFOBAR_SPEC'] = '专精'
	L['INFOBAR_LOOT'] = '拾取'
	L['INFOBAR_OPEN_SPEC_PANEL'] = '打开天赋面板'
	L['INFOBAR_CHANGE_SPEC'] = '切换专精和拾取'

	L['INFOBAR_LOCAL_TIME'] = '本地时间'
	L['INFOBAR_REALM_TIME'] = '服务器时间'
	L['INFOBAR_OPEN_ADDON_PANEL'] = '打开插件列表'
	L['INFOBAR_OPEN_TIMER_TRACKER'] = '打开计时器'
end


--[[ Chat ]]

do
	L['CHAT_NAME'] = '聊天'
	L['CHAT_DESC'] = '设置聊天相关的外观和功能'

	L['CHAT_TOGGLE_PANEL'] = '隐藏/显示聊天框'
	L['CHAT_TOGGLE_WC'] = '加入/离开世界频道'
	L['CHAT_COPY'] = '复制聊天框内容'
	L['CHAT_WHISPER_TELL'] = '告诉'
	L['CHAT_WHISPER_FROM'] = '来自'
end


--[[ Aura ]]

do
	L['AURA_NAME'] = '光环'
	L['AURA_DESC'] = '设置玩家光环相关的外观和功能'

	L['AURA_MOVER_BUFFS'] = '增益光环'
	L['AURA_MOVER_DEBUFFS'] = '减益光环'
end


--[[ Actionbar ]]

do
	L['ACTIONBAR_NAME'] = '动作条'
	L['ACTIONBAR_DESC'] = '设置动作条的外观和功能'

	L['ACTIONBAR_MOVER_BAR1'] = 'Actionbar 1'
	L['ACTIONBAR_MOVER_BAR2'] = 'Actionbar 2'
	L['ACTIONBAR_MOVER_BAR3'] = 'Actionbar 3'
	L['ACTIONBAR_MOVER_BAR4'] = 'Actionbar 4'
	L['ACTIONBAR_MOVER_BAR5'] = 'Actionbar 5'
	L['ACTIONBAR_MOVER_PET'] = 'Actionbar pet'
	L['ACTIONBAR_MOVER_STANCE'] = 'Actionbar stance'
	L['ACTIONBAR_MOVER_EXTRA'] = 'Actionbar extra'
	L['ACTIONBAR_MOVER_VEHICLE'] = 'Actionbar vehicle'
	L['ACTIONBAR_MOVER_COOLDOWN'] = '冷却图标'
	L['ACTIONBAR_KEY_UNBOUND'] = '未绑定按键'
	L['ACTIONBAR_KEY_INDEX'] = '序号'
	L['ACTIONBAR_KEY_BINDING'] = '按键'
	L['ACTIONBAR_KEY_BOUND_TO'] = ' 绑定按键'
	L['ACTIONBAR_SAVE_KEYBINDS'] = '按键设置已保存'
	L['ACTIONBAR_DISCARD_KEYBINDS'] = '按键设置已撤销'
	L['ACTIONBAR_CLEAR_BINDS'] = '%s |cff20ff20清除已绑定按键|r'

	L['ACTIONBAR_CUSTOM_BAR'] = '附加动作条'
	L["ACTIONBAR_UNBIND_TIP"] = "按ESC或右键撤销按键设置"

end


--[[ Combat ]]

do
	L['COMBAT_NAME'] = '战斗'
	L['COMBAT_DESC'] = '设置战斗相关的功能'

	L['COMBAT_ENTER'] = '进入战斗'
	L['COMBAT_LEAVE'] = '离开战斗'
	L['COMBAT_MOVER_IN'] = 'FCT Incoming'
	L['COMBAT_MOVER_OUT'] = 'FCT Outgoing'


	L['COMBAT_SUB_BASIC'] = '基础'
	L['COMBAT_SUB_PVP'] = 'PVP'

	L['COMBAT_ENABLE_COMBAT'] = '启用战斗模块'
	L['COMBAT_COMBAT_ALERT'] = '进出战斗提示'
	L['COMBAT_HEALTH_ALERT'] = '低血量提示'
	L['COMBAT_HEALTH_ALERT_THRESHOLD'] = '血量阈值'
	L['COMBAT_SPELL_ALERT'] = '特殊技能提示'
	L['COMBAT_PVP_SOUND'] = '击杀音效'
	L['COMBAT_EASY_TAB'] = '自动切换Tab逻辑'
	L['COMBAT_EASY_FOCUS'] = '快速设定焦点'
	L['COMBAT_EASY_MARK'] = '快速设定标记'
	L['COMBAT_FCT'] = '滚动战斗信息'
	L['COMBAT_FCT_IN'] = '受到的伤害和治疗'
	L['COMBAT_FCT_OUT'] = '输出的伤害和治疗'
	L['COMBAT_FCT_PET'] = '宠物伤害'
	L['COMBAT_FCT_PERIODIC'] = '周期性伤害'
	L['COMBAT_FCT_MERGE'] = '合并数据'
end


--[[ Announcement ]]

do
	L['ANNOUNCEMENT_INTERRUPT'] = '打断 %s %s'
	L['ANNOUNCEMENT_DISPEL'] = '驱散 %s %s'
	L['ANNOUNCEMENT_STOLEN'] = '偷取 %s %s'
	L['ANNOUNCEMENT_CASTED'] = '%s 使用了 %s'
	L['ANNOUNCEMENT_BATTLE_RESURRECTION'] = '%s 使用 %s 战复了自己'
	L['ANNOUNCEMENT_BATTLE_RESURRECTION_TARGET'] = '%s 使用 %s 战复了 %s'
end


--[[ Inventory ]]

do
	L['INVENTORY_NAME'] = '背包'
	L['INVENTORY_DESC'] = '设置背包的外观和功能'

	L['INVENTORY_NOTIFICATION_HEADER'] = '背包'
	L['INVENTORY_SORT'] = '整理背包'
	L['INVENTORY_ANCHOR_RESET'] = '重置窗口位置'
	L['INVENTORY_BAGS'] = '打开背包栏位'
	L['INVENTORY_FREE_SLOTS'] = '剩余背包空间'
	L['INVENTORY_SORT_DISABLED'] = '背包整理已被禁用'
	L['INVENTORY_AZERITEARMOR'] = '艾泽里特护甲'
	L['INVENTORY_EQUIPEMENTSET'] = '装备配置方案'
	L['INVENTORY_QUICK_DELETE_ENABLED'] = '\n快速摧毁功能已启用。\n你可以按住 CTRL+ALT 键，直接点击摧毁背包中低于蓝色精良品质的物品。'
	L['INVENTORY_QUICK_DELETE'] = '快速摧毁'
	L['INVENTORY_PICK_FAVOURITE_ENABLED'] = '\n偏好选择功能已启用。\n你现在可以点击标记物品。\n若启用了物品分类存放，还可以将其添加到偏好选择分类中。\n此操作对垃圾物品无效。'
	L['INVENTORY_PICK_FAVOURITE'] = '偏好选择'
	L['INVENTORY_AUTO_REPAIR'] = '自动修理'
	L['INVENTORY_AUTO_REPAIR_ENABLED'] = '\n自动修理功能已启用。\n每次与商人对话都会自动修理你的装备。'
	L['INVENTORY_REPAIR_ERROR'] = '没有足够的钱完成修理！'
	L['INVENTORY_REPAIR_COST'] = '自动修理花费'
	L['INVENTORY_SELL_JUNK'] = '自动出售垃圾'
	L['INVENTORY_SELL_JUNK_ENABLED'] = '\n自动出售垃圾功能已启用。\n每次与商人对话都会自动出售垃圾物品。'
	L['INVENTORY_SELL_JUNK_EARN'] = '自动出售垃圾获得'
	L['INVENTORY_SEARCH'] = '搜索'
	L['INVENTORY_SEARCH_ENABLED'] = '输入物品名进行搜索'
	L['INVENTORY_MARK_JUNK'] = '垃圾分类'
	L['INVENTORY_MARK_JUNK_ENABLED'] = '\n点击将可售出的物品归类为垃圾。\n当你开启自动出售垃圾时，这些物品也将被一同售出。\n这个列表是账号共享的。'
	L['INVENTORY_QUICK_SPLIT'] = '快速拆分'
	L['INVENTORY_SPLIT_COUNT'] = '拆分个数'
	L['INVENTORY_SPLIT_MODE_ENABLED'] = '|n点击拆分背包的堆叠物品，可在左侧输入框调整每次点击的拆分个数。'
	L['INVENTORY_GOLD_COUNT'] = '金币统计'
	L['INVENTORY_EARNED'] = '获得'
	L['INVENTORY_SPENT'] = '支出'
	L['INVENTORY_DEFICIT'] = '亏损'
	L['INVENTORY_PROFIT'] = '盈利'
	L['INVENTORY_SESSION'] = '本次登录'
	L['INVENTORY_CHARACTER'] = '服务器角色'
	L['INVENTORY_GOLD_TOTAL'] = '总计'
end


--[[ Map ]]

do
	L['MAP_NAME'] = '地图'
	L['MAP_DESC'] = '设置世界地图和小地图的外观和功能'

	L['MAP_MOVER_MINIMAP'] = '小地图'
	L['MAP_CURSOR'] = '鼠标'
	L['MAP_REVEAL'] = '清除地图迷雾'
	L['MAP_PARAGON'] = '巅峰'
	L['MAP_NEW_MAIL'] = '<新邮件>'
end


--[[ Quest ]]

do
	L['QUEST_NAME'] = '任务'
	L['QUEST_DESC'] = '交接任务以及任务追踪相关的选项'

	L['QUEST_MOVER_TRACKER'] = '任务追踪'
	L['QUEST_ACCEPT'] = '接受任务：'
	L['QUEST_AUTOMATION'] = '自动交接任务'
end


-- Tooltip
do
	L['TOOLTIP_NAME'] = '鼠标提示'
	L['TOOLTIP_DESC'] = '设置鼠标提示的外观和功能'

	L['TOOLTIP_MOVER'] = '鼠标提示'
	L['TOOLTIP_RARE'] = '稀有'
	L['TOOLTIP_AURA_FROM'] = '来自'
	L['TOOLTIP_SELL_PRICE'] = '售价'
	L['TOOLTIP_STACK_CAP'] = '堆叠上限'
	L['TOOLTIP_ID_AZERITE_TRAIT'] = '艾泽里特特质'
	L['TOOLTIP_BAG'] = '背包'
	L['TOOLTIP_ID_SPELL'] = '法术ID'
	L['TOOLTIP_ID_ITEM'] = '物品ID'
	L['TOOLTIP_ID_COMPANION'] = '小宠物ID'
	L['TOOLTIP_ID_QUEST'] = '任务ID'
	L['TOOLTIP_ID_TALENT'] = '天赋ID'
	L['TOOLTIP_ID_ACHIEVEMENT'] = '成就ID'
	L['TOOLTIP_ID_CURRENCY'] = '货币ID'
	L['TOOLTIP_ID_VISUAL'] = 'Visual'
	L['TOOLTIP_ID_SOURCE'] = 'Source'
	L['TOOLTIP_SECTION'] = '段落'
	L['TOOLTIP_TARGETED'] = '关注'
	L['TOOLTIP_ILVL'] = '装等'
end


--[[ Unitframe ]]

do
	L['UNITFRAME_NAME'] = '头像框体'
	L['UNITFRAME_DESC'] = '设置头像框体的外观和功能'

	L['UNITFRAME_SUB_BASIC'] = '基础'

	L['UNITFRAME_MOVER_INCOMING'] = '承受伤害和治疗'
	L['UNITFRAME_MOVER_OUTGOING'] = '输出伤害和治疗'
	L['UNITFRAME_MOVER_CASTBAR'] = '焦点施法条'
	L['UNITFRAME_MOVER_PLAYER'] = '玩家框体'
	L['UNITFRAME_MOVER_PET'] = '宠物框体'
	L['UNITFRAME_MOVER_TARGET'] = '目标框体'
	L['UNITFRAME_MOVER_TARGETTARGET'] = '目标的目标框体'
	L['UNITFRAME_MOVER_FOCUS'] = '焦点框体'
	L['UNITFRAME_MOVER_FOCUSTARGET'] = '焦点的目标框体'
	L['UNITFRAME_MOVER_BOSS'] = '首领框体'
	L['UNITFRAME_MOVER_ARENA'] = '竞技场框体'
	L['UNITFRAME_MOVER_PARTY'] = '小队框体'
	L['UNITFRAME_MOVER_RAID'] = '团队框体'
	L['UNITFRAME_CLICK_CAST_BINDING'] = '点击施法绑定'
	L['UNITFRAME_CLICK_CAST_TIP'] = '提示'
	L['UNITFRAME_CLICK_CAST_DESC'] = 'Ctrl/Alt/Shift + 任意鼠标按键点击想绑定的技能\n对小队或团队框体使用绑定的快捷键就能直接施放技能'
	L['UNITFRAME_GHOST'] = '灵魂'
	L['UNITFRAME_OFFLINE'] = '离线'
end


--[[ Nameplate ]]
do
	L['NAMEPLATE_NAME'] = '姓名板'
	L['NAMEPLATE_DESC'] = '设置姓名板的外观和功能'

	L['NAMEPLATE_SUB_BASIC'] = '基础'
	L['NAMEPLATE_SUB_COLOR'] = '颜色'
	L['NAMEPLATE_SUB_CVARS'] = 'CVars'

	L['NAMEPLATE_ENABLE_NAMEPLATE'] = '启用姓名板模块'
	L['NAMEPLATE_ENABLE_NAMEPLATE_TIP'] = '|n如果想要使用其他的姓名板插件，请先禁用该模块。'

	L['NAMEPLATE_PLATE_WIDTH'] = '宽度'
	L['NAMEPLATE_PLATE_HEIGHT'] = '高度'

	L['NAMEPLATE_FRIENDLY_CLASS_COLOR'] = '友方职业染色'
	L['NAMEPLATE_FRIENDLY_CLASS_COLOR_TIP'] = '|n友方玩家的姓名板根据职业染色。'
	L['NAMEPLATE_HOSTILE_CLASS_COLOR'] = '敌方职业染色'
	L['NAMEPLATE_HOSTILE_CLASS_COLOR_TIP'] = '|n敌方玩家的姓名板根据职业染色。'
	L['NAMEPLATE_TANK_MODE'] = '强制仇恨染色'
	L['NAMEPLATE_TANK_MODE_TIP'] = '|n非坦克专精强制使用坦克模式的染色逻辑。'
	L['NAMEPLATE_DPS_REVERT_THREAT'] = '反转仇恨染色'
	L['NAMEPLATE_DPS_REVERT_THREAT_TIP'] = '|n非坦克专精使用反转的坦克模式染色逻辑。'
	L['NAMEPLATE_SECURE_COLOR'] = '仇恨稳固'
	L['NAMEPLATE_TRANS_COLOR'] = '仇恨不稳'
	L['NAMEPLATE_INSECURE_COLOR'] = '仇恨丢失'
	L['NAMEPLATE_OFF_TANK_COLOR'] = '副坦仇恨'

	L['NAMEPLATE_CUSTOM_UNIT_COLOR'] = '自定义染色'
	L['NAMEPLATE_CUSTOM_UNIT_COLOR_TIP'] = '|n为特定的单位使用自定义染色。'
	L['NAMEPLATE_CUSTOM_COLOR'] = '自定义颜色'
	L['NAMEPLATE_CUSTOM_UNIT_LIST'] = '单位列表'
	L['NAMEPLATE_CUSTOM_UNIT_LIST_TIP'] = '|n输入名字，以空格隔开，输入完毕按下回车。'

	L['NAMEPLATE_TARGET_INDICATOR'] = '目标指示器'
	L['NAMEPLATE_TARGET_COLOR'] = '目标指示器颜色'
	L['NAMEPLATE_THREAT_INDICATOR'] = '仇恨指示器'
	L['NAMEPLATE_CLASSIFY_INDICATOR'] = '稀有指示器'
	L['NAMEPLATE_EXPLOSIVE_SCALE'] = '爆炸物智能缩放'
	L['NAMEPLATE_EXPLOSIVE_SCALE_TIP'] = '|n大秘境中爆炸物的姓名板放大。'
	L['NAMEPLATE_INTERRUPT_NAME'] = '打断信息'
	L['NAMEPLATE_INTERRUPT_NAME_TIP'] = '|n在姓名板上显示成功打断此次读条的队友名字。'

	L['NAMEPLATE_PLATE_AURAS'] = '显示光环'
	L['NAMEPLATE_PLATE_AURAS_TIP'] = '|n默认显示所有你施放的减益光环，可以通过黑/白名单来调整你想要显示或忽略的光环。'
	L['NAMEPLATE_AURA_SIZE'] = '光环大小'
	L['NAMEPLATE_AURA_NUMBER'] = '光环最大数量'
	L['NAMEPLATE_AURA_WHITE_LIST'] = '白名单'
	L['NAMEPLATE_AURA_BLACK_LIST'] = '黑名单'
	L['NAMEPLATE_AURA_WHITE_LIST_TIP'] = '|n填入想要显示的法术ID然后点击添加按钮。'
	L['NAMEPLATE_AURA_BLACK_LIST_TIP'] = '|n填入想要忽略的法术ID然后点击添加按钮。'
	L['NAMEPLATE_AURA_INCORRECT_ID'] = '你输入的法术ID不存在'
	L['NAMEPLATE_AURA_EXISTING_ID'] = '你已经添加过该法术ID'

	L['NAMEPLATE_MIN_SCALE'] = '非目标姓名板缩放'
	L['NAMEPLATE_TARGET_SCALE'] = '目标姓名板缩放'
	L['NAMEPLATE_MIN_ALPHA'] = '非目标姓名板透明度'
	L['NAMEPLATE_OCCLUDED_ALPHA'] = '遮挡的姓名板透明度'
	L['NAMEPLATE_VERTICAL_SPACING'] = '纵向间隔'
	L['NAMEPLATE_HORIZONTAL_SPACING'] = '横向间隔'
	L['NAMEPLATE_MAX_DISTANCE'] = '最大显示距离'
end



--[[ Install ]]

do
	L['INSTALL_HEADER_HELLO'] = '你好'
	L['INSTALL_BODY_WELCOME'] = '欢迎使用 |cffe9c55dFreeUI|r ！\n\n在开始使用前需要调整一些设定来更好的搭配 |cffe9c55dFreeUI|r 工作。\n\n点击安装按钮将进入安装步骤。'
	L['INSTALL_HEADER_BASIC'] = '基础设置'
	L['INSTALL_BODY_BASIC'] = '这些安装步骤将为 |cffe9c55dFreeUI|r 调整各类合适的设定。\n\n第一步将会调整一些 |cffe9c55dCVars|r 设定。\n\n点击下方的继续按钮将应用设定，或者点击跳过按钮如果你想跳过这些设定。'
	L['INSTALL_HEADER_UISCALE'] = '界面缩放'
	L['INSTALL_BODY_UISCALE'] = '这个步骤将会为游戏界面设定合适的缩放值。'
	L['INSTALL_HEADER_CHAT'] = '聊天设置'
	L['INSTALL_BODY_CHAT'] = '这个步骤将会调整聊天栏相关的设定。'
	L['INSTALL_HEADER_ACTIONBAR'] = '动作条设置'
	L['INSTALL_BODY_ACTIONBAR'] = '这个步骤将会调整动作条相关的设定。'
	L['INSTALL_HEADER_ADDON'] = '插件设置'
	L['INSTALL_BODY_ADDON'] = '这个步骤将会调整 |cffe9c55dDBM|r 和 |cffe9c55dSkada|r 的设定以使其配合 |cffe9c55dFreeUI|r 的界面风格与布局。'
	L['INSTALL_HEADER_COMPLETE'] = '安装成功！'
	L['INSTALL_BODY_COMPLETE'] = '安装已经成功完成。\n\n请点击下方完成按钮重载界面。\n\n记住在游戏中你可以通过输入 |cffe9c55d/free|r 来获取详细的帮助或是直接输入 |cffe9c55d/free config|r 来打开控制面板更改各类设定。'
	L['INSTALL_BUTTON_INSTALL'] = '安装'
	L['INSTALL_BUTTON_SKIP'] = '跳过'
	L['INSTALL_BUTTON_CONTINUE'] = '继续'
	L['INSTALL_BUTTON_FINISH'] = '完成'
	L['INSTALL_BUTTON_CANCEL'] = '取消'
end




--[[ GUI ]]

do

	L['GUI_MISC_INVITE_KEYWORD'] = '密语邀请关键字'
	L['GUI_MISC_INVITE_KEYWORD_TIP'] = '输入完成后按下回车'

	L['GUI_UNITFRAME_TEXTURE_STYLE'] = '材质风格'
	L['GUI_UNITFRAME_TEXTURE_NORM'] = '默认'
	L['GUI_UNITFRAME_TEXTURE_GRAD'] = '渐变'
	L['GUI_UNITFRAME_TEXTURE_FLAT'] = '扁平'

	L['GUI_NUMBER_FORMAT'] = '数字格式'
	L['GUI_NUMBER_FORMAT_EN'] = 'k/b/m'
	L['GUI_NUMBER_FORMAT_CN'] = '万/亿/兆'





end

L.GUI = {
	['HINT'] = '提示',
	['RELOAD'] = '|cffff2020是否重载界面来完成设置？|r',
	['RESET_OPTIONS'] = '|cffff2020是否移除所有已保存的选项并重置为默认值？|r',
	['RESET_GOLD'] = '|cffff2020是否重置金币统计数据？|r',

	['MOVER'] = {
		['TITLE'] = '界面元素位置调整',
		['GRID'] = '网格',
		['RESET_ELEMENT'] = '重置该界面元素的默认位置',
		['HIDE_ELEMENT'] = '隐藏该界面元素',
		['RESET'] = '是否重置所有界面元素为默认位置？',

		['GROUP_TOOL'] = '团队工具',

		['ZONE_ABILITY'] = 'zone ability',
		['EXTRA_BAR'] = 'extra bar',
		['MAIN_BAR'] = 'main bar',
		['PET_BAR'] = 'pet bar',
		['STANCE_BAR'] = 'stance bar',
		['LEAVE_VEHICLE_BAR'] = 'leave vehicle bar',
		['QUEST_BUTTON'] = 'quest button',
	},

	['DATA'] = {
		['TITLE'] = '',
		['IMPORT_ERROR'] = '数据异常，导入失败！',
		['IMPORT_WARNING'] = '|cffff2020是否导入数据？|r',
		['INFO'] = '数据信息',
		['VERSION'] = '版本',
		['CHARACTER'] = '角色',
		['EXCEPTION'] = '数据异常',
		['IMPORT'] = '导入',
		['EXPORT'] = '导出',
		['IMPORT_TITLE'] = '导入字符串',
		['EXPORT_TITLE'] = '导出字符串',
		['RESET'] = '重置',
		['RESET_TIP'] = '清除 |cffe9c55dFreeUI|r 已保存的数据，将所有选项重置为 |cffe9c55dFreeUI|r 默认值。',
		['IMPORT_TIP'] = '导入 |cffe9c55dFreeUI|r 的配置字符串。',
		['EXPORT_TIP'] = '将当前的 |cffe9c55dFreeUI|r 配置导出为字符串。',
	},

	['MISC'] = {
		['TITLE'] = '',
	},

	['APPEARANCE'] = {
		['TITLE'] = '',
	},

	['NOTIFICATION'] = {
		['TITLE'] = '',
	},

	['INFOBAR'] = {
		['TITLE'] = '',
	},

	['CHAT'] = {
		['TITLE'] = '',
	},

	['AURA'] = {
		['TITLE'] = '',
	},

	['ACTIONBAR'] = {
		['TITLE'] = '',
	},

	['COMBAT'] = {
		['TITLE'] = '',
	},

	['ANNOUNCEMENT'] = {
		['ENABLE'] = '副本通告',
		['INTERRUPT'] = '成功打断施法',
		['DISPEL'] = '成功驱散增益',
		['STOLEN'] = '成功偷取增益',
		['FEAST'] = '大餐',
		['CAULDRON'] = '药锅',
		['CODEX'] = '圣典',
		['REFRESHMENT'] = '法师餐桌',
		['SOULWELL'] = '术士灵魂井',
		['REPAIR'] = '修理',
		['MAIL'] = '邮件',
		['BATTLE_RESURRECTION'] = '战斗复活',
		['PORTAL'] = '法师传送门',
		['TOY'] = '特殊玩具',
	},

	['INVENTORY'] = {
		['TITLE'] = '',
	},

	['MAP'] = {
		['TITLE'] = '',
	},

	['QUEST'] = {
		['TITLE'] = '',
	},

	['TOOLTIP'] = {
		['TITLE'] = '',
	},

	['UNITFRAME'] = {
		['TITLE'] = '',
	},

	['NAMEPLATE'] = {
		['TITLE'] = '姓名板',
		['DESC'] = '设置姓名板的外观和功能',

		['SUB_BASIC'] = '基础',
		['SUB_COLOR'] = '颜色',
		['SUB_CVARS'] = 'CVars',

		['ENABLE'] = '启用姓名板模块',
		['ENABLE_TIP'] = '|n如果想要使用其他的姓名板插件，请先禁用该模块。',

		['PLATE_WIDTH'] = '宽度',
		['PLATE_HEIGHT'] = '高度',

		['FRIENDLY_CLASS_COLOR'] = '友方职业染色',
		['FRIENDLY_CLASS_COLOR_TIP'] = '|n友方玩家的姓名板根据职业染色。',
		['HOSTILE_CLASS_COLOR'] = '敌方职业染色',
		['HOSTILE_CLASS_COLOR_TIP'] = '|n敌方玩家的姓名板根据职业染色。',
		['TANK_MODE'] = '强制仇恨染色',
		['TANK_MODE_TIP'] = '|n非坦克专精强制使用坦克模式的染色逻辑。',
		['DPS_REVERT_THREAT'] = '反转仇恨染色',
		['DPS_REVERT_THREAT_TIP'] = '|n非坦克专精使用反转的坦克模式染色逻辑。',
		['SECURE_COLOR'] = '仇恨稳固',
		['TRANS_COLOR'] = '仇恨不稳',
		['INSECURE_COLOR'] = '仇恨丢失',
		['OFF_TANK_COLOR'] = '副坦仇恨',

		['CUSTOM_UNIT_COLOR'] = '自定义染色',
		['CUSTOM_UNIT_COLOR_TIP'] = '|n为特定的单位使用自定义染色。',
		['CUSTOM_COLOR'] = '自定义颜色',
		['CUSTOM_UNIT_LIST'] = '单位列表',
		['CUSTOM_UNIT_LIST_TIP'] = '|n输入名字，以空格隔开，输入完毕按下回车。',

		['TARGET_INDICATOR'] = '目标指示器',
		['TARGET_COLOR'] = '目标指示器颜色',
		['THREAT_INDICATOR'] = '仇恨指示器',
		['CLASSIFY_INDICATOR'] = '稀有指示器',
		['EXPLOSIVE_SCALE'] = '爆炸物智能缩放',
		['EXPLOSIVE_SCALE_TIP'] = '|n大秘境中爆炸物的姓名板放大。',
		['INTERRUPT_NAME'] = '打断信息',
		['INTERRUPT_NAME_TIP'] = '|n在姓名板上显示成功打断此次读条的队友名字。',

		['PLATE_AURAS'] = '显示光环',
		['PLATE_AURAS_TIP'] = '|n默认显示所有你施放的减益光环，可以通过黑/白名单来调整你想要显示或忽略的光环。',
		['AURA_SIZE'] = '光环大小',
		['AURA_NUMBER'] = '光环最大数量',
		['AURA_WHITE_LIST'] = '白名单',
		['AURA_BLACK_LIST'] = '黑名单',
		['AURA_WHITE_LIST_TIP'] = '|n填入想要显示的法术ID然后点击添加按钮。',
		['AURA_BLACK_LIST_TIP'] = '|n填入想要忽略的法术ID然后点击添加按钮。',
		['AURA_INCORRECT_ID'] = '你输入的法术ID不存在',
		['AURA_EXISTING_ID'] = '你已经添加过该法术ID',

		['MIN_SCALE'] = '非目标姓名板缩放',
		['TARGET_SCALE'] = '目标姓名板缩放',
		['MIN_ALPHA'] = '非目标姓名板透明度',
		['OCCLUDED_ALPHA'] = '遮挡的姓名板透明度',
		['VERTICAL_SPACING'] = '纵向间隔',
		['HORIZONTAL_SPACING'] = '横向间隔',
		['MAX_DISTANCE'] = '最大显示距离',
	},

	['CREDITS'] = {
		['TITLE'] = '',
	},
}



-- Slash commands
L['COMMANDS_LIST_HINT'] = '可用命令：'
L['COMMANDS_LIST'] = {
	'/free install - 打开安装面板。',
	'/free config - 打开控制台。',
	'/free unlock - 解锁界面元素，解锁后可以自由移动界面元素。',
	'/free reset - 重置所有保存的选项恢复到默认值。',

	'/rl - 重载界面',
	'/ss - 屏幕截图',
	'/clear - 清空聊天窗口',
	'/rc - 就位确认',
	'/rp - 职责确认',
	'/gc - 小队/团队转换',
	'/lg - 退出队伍',
	'/rs - 重置副本',
	'/tt - 密语当前目标',
	'/spec - 切换天赋',
	'/bind - 绑定快捷键',
	'/gm - 打开帮助面板',
}














