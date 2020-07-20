local F, C, L = unpack(select(2, ...))

if (GetLocale() ~= 'zhCN' and GetLocale() ~= 'zhTW') then return end


-- Actionbar
L['ACTIONBAR_LEAVE_VEHICLE'] = '离开载具按钮'


-- Unitframe
L['UNITFRAME_SPELL_BINDER'] = '点击施法绑定'


-- Quest
L['QUEST_ACCEPT_QUEST'] = '接受任务：'
L['QUEST_QUICK_QUEST'] = '自动交接任务'


-- Misc
L['MISC_STRANGER'] = '陌生人'
L['MISC_GET_NAKED'] = '双击脱光装备'
L['MISC_UNDRESS'] = '脱衣'
L['ACCOUNT_KEYSTONES'] = '账号角色钥石信息'
L['MISC_REPUTATION'] = '声望'
L['MISC_PARAGON'] = '巅峰'
L['MISC_PARAGON_REPUTATION'] = '巅峰声望'
L['MISC_PARAGON_NOTIFY'] = '巅峰声望已满注意兑换'
L['Pull'] = '10秒后开怪！'


L['MISC_ACCEPT_INVITE'] = '接受邀请 '
L['MISC_WHISPER_INVITE_ENABLE'] = '自动邀请功能启用'
L['MISC_WHISPER_INVITE_DISABLE'] = '自动邀请功能关闭'
L['MISC_STACK_BUYING_CHECK'] = '是否购买|cffff0000一组|r下列物品？'
L['MISC_DISBAND_GROUP'] = '解散队伍'
L['MISC_DISBAND_GROUP_CHECK'] = '你确定要解散队伍?'
L['MISC_NUMBER_CAP_1'] = '万'
L['MISC_NUMBER_CAP_2'] = '亿'
L['MISC_NUMBER_CAP_3'] = '兆'
L["MISC_EXTEND_INSTANCE"] = "延长所有副本锁定"
L["MISC_EXTEND_INSTANCE_TIP"] = "%s延长 %s取消"


-- notification
L['NOTIFICATION_RARE'] = '发现稀有 '
L['NOTIFICATION_INTERRUPTED'] = '打断：'
L['NOTIFICATION_DISPELED'] = '驱散：'
L['NOTIFICATION_STOLEN'] = '偷取：'
L['NOTIFICATION_RESNOTARGET'] = '<注意>：%s 使用了 %s！'
L['NOTIFICATION_RESTARGET'] = '<注意>：%s 使用了 %s 在 %s！'
L['NOTIFICATION_BOTTOY'] = '<注意>：%s 放置了 %s！'
L['NOTIFICATION_FEAST'] = '<注意>：%s 摆出了 %s！'
L['NOTIFICATION_PORTAL'] = '<注意>：%s 开启了 %s！'
L['NOTIFICATION_REFRESHMENTTABLE'] = '<注意>：%s 施放了 %s！'
L['NOTIFICATION_RITUALOFSUMMONING'] = '<注意>：%s 正在施放 %s！'
L['NOTIFICATION_SOULWELL'] = '<注意>：%s 施放了 %s！'
L['NOTIFICATION_ACCEPT_QUEST'] = '接受任务：'
L['NOTIFICATION_NEW_MAIL'] = '收到新邮件。'
L['NOTIFICATION_BAG_FULL'] = '背包满了。'
L['NOTIFICATION_MAIL'] = '邮件'
L['NOTIFICATION_BAG'] = '背包'
L['NOTIFICATION_REPAIR'] = '修理'
L['NOTIFICATION_SELL'] = '售卖'
L['NOTIFICATION_ENTER_COMBAT'] = '进入战斗'
L['NOTIFICATION_LEAVE_COMBAT'] = '离开战斗'


-- Infobar
L['INFOBAR_CURRENCY'] = '货币'
L['INFOBAR_DURABILITY'] = '装备耐久'
L['INFOBAR_FRIENDS'] = '朋友'
L['INFOBAR_GUILD'] = '公会'
L['INFOBAR_GUILD_NONE'] = '无'
L['INFOBAR_REPORT'] = '报告'

L['INFOBAR_WOW'] = '<魔兽世界>'
L['INFOBAR_BN'] = '<战网好友>'
L['INFOBAR_NO_ONLINE'] = '当前没有好友在线'
L['INFOBAR_HOLD_SHIFT'] = '按住 <Shift> 展开详细信息'
L['INFOBAR_OPEN_FRIENDS_PANEL'] = '打开好友面板'
L['INFOBAR_ADD_FRIEND'] = '添加好友'

L['INFOBAR_EARNED'] = '获得'
L['INFOBAR_SPENT'] = '花费'
L['INFOBAR_DEFICIT'] = '亏损'
L['INFOBAR_PROFIT'] = '盈利'
L['INFOBAR_SESSION'] = '本次登录'
L['INFOBAR_CHARACTER'] = '服务器角色'
L['INFOBAR_TOKEN_PRICE'] = '时光徽章'
L['INFOBAR_OPEN_CURRENCY_PANEL'] = '打开货币面板'
L['INFOBAR_RESET_GOLD_COUNT'] = '重置金币统计数据'
L['INFOBAR_OPEN_GUILD_PANEL'] = '打开公会面板'
L['INFOBAR_OPEN_SPEC_PANEL'] = '打开天赋面板'
L['INFOBAR_CHANGE_SPEC'] = '切换专精'
L['INFOBAR_CHANGE_LOOT_SPEC'] = '切换拾取专精'
L['INFOBAR_SPEC'] = '专精'
L['INFOBAR_LOOT'] = '拾取'

L['INFOBAR_DAILY_WEEKLY_INFO'] = '日常/周常信息'
L['INFOBAR_INVASION_LEG'] = '军团突袭'
L['INFOBAR_INVASION_BFA'] = '阵营突袭'
L['INFOBAR_INVASION_CURRENT'] = '当前'
L['INFOBAR_INVASION_NEXT'] = '下次'
L['INFOBAR_OPEN_BFA_REPORT'] = '打开任务报告(BFA)'
L['INFOBAR_OPEN_LEG_REPORT'] = '打开任务报告(LEG)'
L['INFOBAR_OPEN_WOD_REPORT'] = '打开任务报告(WOD)'
L['INFOBAR_BLINGTRON'] = '布林顿每日礼包'
L['INFOBAR_MEAN_ONE'] = '冬幕节日常'
L['INFOBAR_TIMEWARPED'] = '时光漫游徽章奖励'
L['INFOBAR_ISLAND'] = '本周进度'

L['INFOBAR_LOCAL_TIME'] = '本地时间'
L['INFOBAR_REALM_TIME'] = '服务器时间'
L['INFOBAR_OPEN_ADDON_PANEL'] = '打开插件列表'
L['INFOBAR_OPEN_TIMER_TRACKER'] = '打开计时器'

L['INFOBAR_HANDS'] = '手部'
L['INFOBAR_FEET'] = '脚部'
L['INFOBAR_OPEN_CHARACTER_PANEL'] = '打开角色面板'

L['INFOBAR_INFO'] = '信息'

L['INFOBAR_AUTO_SELL_JUNK'] = '自动出售垃圾'
L['INFOBAR_AUTO_REPAIR'] = '自动修理装备'

L['INFOBAR_GUILD_REPAIR_COST'] = '使用公会修理'
L['INFOBAR_REPAIR_COST'] = '自动修理'
L['INFOBAR_REPAIR_FAILED'] = '没有足够的金钱完成装备修理！'



-- inventory
L['INVENTORY_NOTIFICATION_HEADER'] = '背包'
L['INVENTORY_RESET_GOLD_COUNT'] = '重置金币统计数据'
L['INVENTORY_SORT'] = '整理物品'
L['INVENTORY_RESET'] = '重置窗口位置'
L['INVENTORY_BAGS'] = '打开背包栏位'
L['INVENTORY_FREE_SLOTS'] = '剩余背包空间'
L['INVENTORY_AZERITEARMOR'] = '艾泽里特护甲'
L['INVENTORY_EQUIPEMENTSET'] = '装备配置方案'

L['INVENTORY_QUICK_DELETE_ENABLED_NOTIFY'] = '快速摧毁功能已启用！'
L['INVENTORY_QUICK_DELETE_DISABLED_NOTIFY'] = '快速摧毁功能已关闭！'
L['INVENTORY_QUICK_DELETE_ENABLED'] = '\n快速摧毁功能已启用。\n你可以按住 CTRL+ALT 键，直接点击摧毁背包中低于蓝色精良品质的物品。'
L['INVENTORY_QUICK_DELETE'] = '快速摧毁'

L['INVENTORY_PICK_FAVOURITE_ENABLED'] = '\n偏好选择功能已启用。\n你现在可以点击标记物品。\n若启用了物品分类存放，还可以将其添加到偏好选择分类中。\n此操作对垃圾物品无效。'
L['INVENTORY_PICK_FAVOURITE'] = '偏好选择'
L['INVENTORY_PICK_FAVOURITE_ENABLED_NOTIFY'] = '偏好选择功能已启用！'
L['INVENTORY_PICK_FAVOURITE_DISABLED_NOTIFY'] = '偏好选择功能已关闭！'

L['INVENTORY_AUTO_REPAIR'] = '自动修理'
L['INVENTORY_AUTO_REPAIR_ENABLED'] = '\n自动修理功能已启用。\n每次与商人对话都会自动修理你的装备。'
L['INVENTORY_AUTO_REPAIR_ENABLED_NOTIFY'] = '自动修理功能已启用！'
L['INVENTORY_AUTO_REPAIR_DISABLED_NOTIFY'] = '自动修理功能已关闭！'

L['INVENTORY_SELL_JUNK'] = '自动出售垃圾'
L['INVENTORY_SELL_JUNK_ENABLED'] = '\n自动出售垃圾功能已启用。\n每次与商人对话都会自动出售垃圾物品。'
L['INVENTORY_SELL_JUNK_ENABLED_NOTIFY'] = '自动出售垃圾功能已启用！'
L['INVENTORY_SELL_JUNK_DISABLED_NOTIFY'] = '自动出售垃圾功能已关闭！'
L['INVENTORY_SELL_JUNK_EARN'] = '自动出售垃圾获得'

L['INVENTORY_SEARCH'] = '搜索'
L['INVENTORY_SEARCH_ENABLED'] = '输入物品名进行搜索'

L['INVENTORY_REPAIR_ERROR'] = '没有足够的钱完成修理！'
L['INVENTORY_REPAIR_COST'] = '自动修理花费'




-- mover
L['MOVER_PANEL'] = '界面元素位置调整'
L['MOVER_GRID'] = '网格'
L['MOVER_RESET_ANCHOR'] = '重置该界面元素的默认位置'
L['MOVER_HIDE_ELEMENT'] = '隐藏该界面元素'
L['MOVER_TIPS'] = '提示'
L['MOVER_TOOLTIP'] = '鼠标提示'
L['MOVER_MINIMAP'] = '小地图'
L['MOVER_RESET_CONFIRM'] = '是否重置所有界面元素为默认位置？'
L['MOVER_CANCEL_CONFIRM'] = '是否取消本次操作？'
L['MOVER_UNITFRAME_PLAYER'] = '玩家框体'
L['MOVER_UNITFRAME_PET'] = '宠物框体'
L['MOVER_UNITFRAME_TARGET'] = '目标框体'
L['MOVER_UNITFRAME_TARGETTARGET'] = '目标的目标框体'
L['MOVER_UNITFRAME_FOCUS'] = '焦点框体'
L['MOVER_UNITFRAME_FOCUSTARGET'] = '焦点的目标框体'
L['MOVER_UNITFRAME_BOSS'] = '首领框体'
L['MOVER_UNITFRAME_ARENA'] = '竞技场框体'
L['MOVER_UNITFRAME_PARTY'] = '小队框体'
L['MOVER_UNITFRAME_RAID'] = '团队框体'
L['MOVER_UNITFRAME_PLAYER_CASTBAR'] = '玩家施法条'
L['MOVER_UNITFRAME_TARGET_CASTBAR'] = '目标施法条'
L['MOVER_COMBATTEXT_INFORMATION'] = '战斗信息（信息）'
L['MOVER_COMBATTEXT_OUTGOING'] = '战斗信息（输出）'
L['MOVER_COMBATTEXT_INCOMING'] = '战斗信息（受到）'
L['MOVER_BUFFS'] = '增益栏'
L['MOVER_DEBUFFS'] = '减益栏'
L['MOVER_QUAKE_TIMER'] = '震荡计时条'
L['MOVER_QUEST_TRACKER'] = '任务追踪栏'
L['MOVER_VEHICLE_INDICATOR'] = '载具座位控制'
L['MOVER_DURABILITY_INDICATOR'] = '耐久提示'
L['MOVER_ALERT_FRAMES'] = '成就/拾取通知框体'
L['MOVER_UIWIDGETFRAME'] = 'UIWidgetFrame'


-- Chat
L['CHAT_HIDE'] = '隐藏聊天框'
L['CHAT_SHOW'] = '显示聊天框'
L['CHAT_JOIN_WC'] = '加入世界频道'
L['CHAT_LEAVE_WC'] = '离开世界频道'
L['CHAT_COPY'] = '复制聊天内容'
L['CHAT_WHISPER_TELL'] = '告诉'
L['CHAT_WHISPER_FROM'] = '来自'


-- Tooltip
L['TOOLTIP_RARE'] = '稀有'
L['TOOLTIP_AURA_FROM'] = '来自'
L['TOOLTIP_SELL_PRICE'] = '售价'
L['TOOLTIP_STACK_CAP'] = '堆叠上限'
L['TOOLTIP_AZERITE_TRAIT'] = '艾泽里特特质'
L['TOOLTIP_SECTION'] = '段落'
L['TOOLTIP_TARGETED'] = '关注'


-- Map
L['MAP_PLAYER'] = '玩家'
L['MAP_CURSOR'] = '鼠标'
L['MAP_REVEAL'] = '清除地图迷雾'
L['MAP_PARAGON'] = 'Paragon'


-- Install
L['INSTALL_HEADER_HELLO'] = '你好'
L['INSTALL_HEADER_FIRST'] = '基础设置'
L['INSTALL_HEADER_SECOND'] = '界面缩放'
L['INSTALL_HEADER_THIRD'] = '聊天设置'
L['INSTALL_HEADER_FOURTH'] = '插件设置'
L['INSTALL_HEADER_FIFTH'] = '安装成功！'
L['INSTALL_BODY_WELCOME'] = '欢迎使用 FreeUI ！\n\n在开始使用前需要调整一些设定来更好的搭配 FreeUI 工作。\n\n如果你是 FreeUI 的新用户，你也可以点击下方的教程按钮来熟悉各项功能。\n\n点击安装按钮将直接进入安装步骤。'
L['INSTALL_BODY_FIRST'] = '这些安装步骤将为 FreeUI 调整各类合适的设定。\n\n第一步将会调整一些 CVars 设定。\n\n点击下方的继续按钮将应用设定，或者点击跳过按钮如果你想跳过这些设定。'
L['INSTALL_BODY_SECOND'] = '这个步骤将会为游戏界面设定合适的缩放值。'
L['INSTALL_BODY_THIRD'] = '这个步骤将会调整一些聊天栏相关的设定。'
L['INSTALL_BODY_FOURTH'] = '这个步骤将自动配置 Bigwigs 和 Skada 的设定并使其配合 FreeUI 的界面风格与布局。'
L['INSTALL_BODY_FIFTH'] = '安装已经成功完成。\n\n请点击下方完成按钮重载界面。'

L['INSTALL_BUTTON_TUTORIAL'] = '教程'
L['INSTALL_BUTTON_INSTALL'] = '安装'
L['INSTALL_BUTTON_SKIP'] = '跳过'
L['INSTALL_BUTTON_CONTINUE'] = '继续'
L['INSTALL_BUTTON_FINISH'] = '完成'
L['INSTALL_BUTTON_CANCEL'] = '取消'


-- Themes
L["THEME_CONFLICTION_WARNING"] = "FreeUI includes an efficient built-in module of theme.\n\nIt's highly recommended that you disable any version of Aurora or Skinner."



-- Slash commands
L['FREEUI_OPTIONS_NOT_ENABLED'] = 'FreeUI_Options 没有启用！'
L['RELOAD_CHECK'] = '|cffff2735需要重载界面来使改动生效。\n\n是否立即执行？|r'

L['UIHELP'] = '输入 /freeui 获取帮助。'

L['SLASHCMD_HELP'] = {
	'命令列表:',
	'/rl - 重载界面',
	'/rc - 就位确认',
	'/rp - 职责确认',

	'/gm - 打开帮助面板',

	'/gc - 小队/团队转换',
	'/lg - 退出队伍',

	'/rs - 重置副本',

	'/ss - 屏幕截图',

	'/clear - 清空聊天窗口',
	'/tt - 密语当前目标',

	'/spec - 切换天赋',

	'/freeui install - 打开安装面板',
	'/freeui config - 打开控制台',
	'/freeui unlock - 解锁界面元素',
	'/freeui reset  - 重置已保存的选项',
	'/freeui dps  - 使用默认头像布局（适合输出）',
	'/freeui heal  - 使用对称型布局（适合治疗）',

}