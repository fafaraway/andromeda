local F, C, L = unpack(select(2, ...))
--if not C.isChinses then return end


--[[ Misc ]]

do
	L['MISC_STRANGER'] = '陌生人'

	L['MISC_UNDRESS'] = '脱衣'
	L['MISC_KEYSTONES'] = '账号角色钥石信息'
	L['MISC_RESET_KEYSTONES'] = '重置钥石信息'
	L['MISC_REPUTATION'] = '声望'
	L['MISC_PARAGON'] = '巅峰'
	L['MISC_PARAGON_REPUTATION'] = '巅峰声望'
	L['MISC_PARAGON_NOTIFY'] = '巅峰声望已满注意兑换'
	L['MISC_ORDERHALL_TIP'] = '按住Shift显示详细信息'
	L['MISC_GOLD'] = '金币'
	L['MISC_ITEM'] = '物品'

	L['MISC_DISBAND_GROUP'] = '解散队伍'
	L['MISC_DISBAND_GROUP_CHECK'] = '你确定要解散队伍?'
	L['MISC_NUMBER_CAP_1'] = '万'
	L['MISC_NUMBER_CAP_2'] = '亿'
	L['MISC_NUMBER_CAP_3'] = '兆'


	L['MISC_DECLINE_INVITE'] = '自动拒绝了 %s 的组队邀请'
	L['MISC_ACCEPT_INVITE'] = '自动接受了 %s 的组队邀请'

	L['AUTOMATION_GET_NAKED'] = '双击脱光装备'
	L['AUTOMATION_BUY_STACK'] = '是否购买|cffff0000一组|r下列物品？'
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
end


--[[ Themes ]]

do
	L['THEME'] = '外观'
	L['THEME_CONFLICTION_WARNING'] = 'FreeUI includes an efficient built-in module of theme.\n\nIt\'s highly recommended that you disable any version of Aurora or Skinner.'
	L['THEME_CURSOR_TRAIL'] = '鼠标轨迹'
	L['THEME_VIGNETTING'] = '暗角效果'
	L['THEME_VIGNETTING_ALPHA'] = '暗角透明度'
	L['THEME_RESKIN_BLIZZ'] = '美化游戏默认界面'
	L['THEME_SHADOW_BORDER'] = '添加阴影'
	L['THEME_UI_SCALE'] = '界面缩放'
end


--[[ Notification ]]

do
	L['NOTIFICATION'] = '提醒'
	L['NOTIFICATION_NEW_MAIL'] = '收到新邮件！'
	L['NOTIFICATION_BAG_FULL'] = '背包满了！'
	L['NOTIFICATION_MAIL'] = '邮件'
	L['NOTIFICATION_BAG'] = '背包'
	L['NOTIFICATION_REPAIR'] = '修理'
	L['NOTIFICATION_SELL'] = '售卖'
	L['NOTIFICATION_RARE'] = '发现稀有'
	L['NOTIFICATION_VERSION_CHECK_HEADER'] = '版本检查'
	L['NOTIFICATION_VERSION_CHECK_DESC'] = '插件版本已过期，请注意及时更新！'
	L['VERSION_OUTDATED'] = 'Your version of FreeUI is out of date, the latest version is |cffff2020%s|r.'
end


--[[ Announcement ]]

do
	L['ANNOUNCEMENT_INTERRUPT'] = '打断了 %s 的 %s！'
	L['ANNOUNCEMENT_DISPEL'] = '驱散了 %s 的 %s！'
	L['ANNOUNCEMENT_STOLEN'] = '偷取了 %s 的 %s！'
	L['ANNOUNCEMENT_BATTLE_REZ'] = '%s 使用了 %s！'
	L['ANNOUNCEMENT_BATTLE_REZ_TARGET'] = '%s 使用了 %s 在 %s！'
	L['ANNOUNCEMENT_CASTED'] = '%s 施放了 %s！'
	L['ANNOUNCEMENT_FEAST'] = '%s 摆出了 %s！'
	L['ANNOUNCEMENT_ITEM'] = '%s 放置了 %s！'
	L['ANNOUNCEMENT_PORTAL'] = '%s 开启了 %s！'
	L['ANNOUNCEMENT_SAPPED'] = '我被闷棍！'
end


--[[ Infobar ]]

do
	L['INFOBAR'] = '信息条'
	L['INFOBAR_CURRENCY'] = '金币统计'
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


	L['INFOBAR_OPEN_GUILD_PANEL'] = '打开公会面板'
	L['INFOBAR_OPEN_SPEC_PANEL'] = '打开天赋面板'
	L['INFOBAR_CHANGE_SPEC'] = '切换专精'
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
	L['INFOBAR_OPEN_CHARACTER_PANEL'] = '打开角色面板'
	L['INFOBAR_INFO'] = '信息'
end


--[[ Chat ]]

do
	L['CHAT_TOGGLE_PANEL'] = '隐藏/显示聊天框'
	L['CHAT_TOGGLE_WC'] = '加入/离开世界频道'
	L['CHAT_COPY'] = '复制聊天框内容'
	L['CHAT_WHISPER_TELL'] = '告诉'
	L['CHAT_WHISPER_FROM'] = '来自'
end


--[[ Aura ]]

do
	L['AURA_MOVER_BUFFS'] = '增益光环'
	L['AURA_MOVER_DEBUFFS'] = '减益光环'
end


--[[ Actionbar ]]

do
	L['ACTIONBAR'] = '动作条'
	L['ACTIONBAR_LEAVE_VEHICLE'] = '离开载具按钮'
	L['ACTIONBAR_KEY_UNBOUND'] = '未绑定按键'
	L['ACTIONBAR_KEY_INDEX'] = '序号'
	L['ACTIONBAR_KEY_BINDING'] = '按键'
	L['ACTIONBAR_KEY_BOUND_TO'] = ' 绑定按键'
	L['ACTIONBAR_SAVE_KEYBINDS'] = '按键设置已保存'
	L['ACTIONBAR_DISCARD_KEYBINDS'] = '按键设置已撤销'
	L['ACTIONBAR_CLEAR_BINDS'] = '%s |cff20ff20清除已绑定按键'
end


--[[ Combat ]]

do
	L['COMBAT_ENTER'] = '进入战斗'
	L['COMBAT_LEAVE'] = '离开战斗'
end


--[[ Inventory ]]

do
	L['INVENTORY'] = '背包'
	L['INVENTORY_NOTIFICATION_HEADER'] = '背包'
	L['INVENTORY_RESET_GOLD_COUNT'] = '重置金币统计数据'
	L['INVENTORY_SORT'] = '整理物品'
	L['INVENTORY_RESET'] = '重置窗口位置'
	L['INVENTORY_BAGS'] = '打开背包栏位'
	L['INVENTORY_FREE_SLOTS'] = '剩余背包空间'
	L['INVENTORY_AZERITEARMOR'] = '艾泽里特护甲'
	L['INVENTORY_EQUIPEMENTSET'] = '装备配置方案'
	L['INVENTORY_QUICK_DELETE_ENABLED'] = '\n快速摧毁功能已启用。\n你可以按住 CTRL+ALT 键，直接点击摧毁背包中低于蓝色精良品质的物品。'
	L['INVENTORY_QUICK_DELETE'] = '快速摧毁'
	L['INVENTORY_PICK_FAVOURITE_ENABLED'] = '\n偏好选择功能已启用。\n你现在可以点击标记物品。\n若启用了物品分类存放，还可以将其添加到偏好选择分类中。\n此操作对垃圾物品无效。'
	L['INVENTORY_PICK_FAVOURITE'] = '偏好选择'
	L['INVENTORY_AUTO_REPAIR'] = '自动修理'
	L['INVENTORY_AUTO_REPAIR_ENABLED'] = '\n自动修理功能已启用。\n每次与商人对话都会自动修理你的装备。'
	L['INVENTORY_SELL_JUNK'] = '自动出售垃圾'
	L['INVENTORY_SELL_JUNK_ENABLED'] = '\n自动出售垃圾功能已启用。\n每次与商人对话都会自动出售垃圾物品。'
	L['INVENTORY_SELL_JUNK_EARN'] = '自动出售垃圾获得'
	L['INVENTORY_SEARCH'] = '搜索'
	L['INVENTORY_SEARCH_ENABLED'] = '输入物品名进行搜索'
	L['INVENTORY_REPAIR_ERROR'] = '没有足够的钱完成修理！'
	L['INVENTORY_REPAIR_COST'] = '自动修理花费'
	L['INVENTORY_MARK_JUNK'] = '垃圾分类'
	L['INVENTORY_MARK_JUNK_ENABLED'] = '\n点击将可售出的物品归类为垃圾。\n当你开启自动出售垃圾时，这些物品也将被一同售出。\n这个列表是账号共享的。'
	L['INVENTORY_QUICK_SPLIT'] = '快速拆分'
	L['INVENTORY_SPLIT_COUNT'] = '拆分个数'
	L['INVENTORY_SPLIT_MODE_ENABLED'] = '|n点击拆分背包的堆叠物品，可在左侧输入框调整每次点击的拆分个数。'
	L['INVENTORY_GOLD_COUNT'] = '金币统计'
	L['INVENTORY_EARNED'] = '获得'
	L['INVENTORY_SPENT'] = '花费'
	L['INVENTORY_DEFICIT'] = '亏损'
	L['INVENTORY_PROFIT'] = '盈利'
	L['INVENTORY_SESSION'] = '本次登录'
	L['INVENTORY_CHARACTER'] = '服务器角色'
	L['INVENTORY_GOLD_TOTAL'] = '总共'
end


--[[ Map ]]

do
	L['MAP'] = '地图'
	L['MAP_CURSOR'] = '鼠标'
	L['MAP_REVEAL'] = '清除地图迷雾'
	L['MAP_PARAGON'] = 'Paragon'
	L['MAP_NEW_MAIL'] = '<新邮件>'
end


--[[ Quest ]]

do
	L['QUEST'] = '任务'
	L['QUEST_ACCEPT_QUEST'] = '接受任务：'
	L['QUEST_AUTOMATION'] = '自动交接任务'
end


-- Tooltip
do
	L['TOOLTIP'] = '鼠标提示'
	L['TOOLTIP_RARE'] = '稀有'
	L['TOOLTIP_AURA_FROM'] = '来自'
	L['TOOLTIP_SELL_PRICE'] = '售价'
	L['TOOLTIP_STACK_CAP'] = '堆叠上限'
	L['TOOLTIP_ID_AZERITE_TRAIT'] = '艾泽里特特质'
	L['TOOLTIP_BAG'] = '背包'
	L['TOOLTIP_BANK'] = '银行'
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
	L['UNITFRAME'] = '单位框体'
	L['UNITFRAME_SPELL_BINDER'] = '点击施法绑定'
	L['UNITFRAME_DEAD'] = '死亡'
	L['UNITFRAME_GHOST'] = '灵魂'
	L['UNITFRAME_OFFLINE'] = '离线'
end


--[[ Mover ]]

do
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
	L['MOVER_UNITFRAME_FOCUS_CASTBAR'] = '焦点施法条'
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
	L['MOVER_ACTIONBAR_BAR1'] = '动作条第一栏'
	L['MOVER_ACTIONBAR_BAR2'] = '动作条第二栏'
	L['MOVER_ACTIONBAR_BAR3'] = '动作条第三栏'
	L['MOVER_ACTIONBAR_BAR4'] = '动作条第四栏'
	L['MOVER_ACTIONBAR_BAR5'] = '动作条第五栏'
	L['MOVER_ACTIONBAR_PET'] = '宠物动作条'
	L['MOVER_ACTIONBAR_STANCE'] = 'actionbar_stance'
	L['MOVER_ACTIONBAR_EXTRA'] = '动作条额外按钮'
	L['MOVER_ACTIONBAR_VEHICLE'] = 'actionbar_vehicle'
	L['MOVER_COOLDOWN_PULSE'] = '冷却图标'
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
	L['GUI_TIPS'] = '提示'
	L['GUI_RELOAD_WARNING'] = '|cffff2020是否重载界面来完成设置？|r'
	L['GUI_RESET_WARNING'] = '|cffff2020是否移除所有已保存的选项并重置为默认值？|r'
	L['GUI_PROFILE_WARNING'] = '|cffff2020是否转换选项配置为角色单独/账号通用？|r'


	L['GUI_AURA'] = '光环'
	L['GUI_AURA_DESC'] = '这些选项控制大部分和光环相关的设置'
	L['GUI_AURA_SUB_BASIC'] = '基础设定'
	L['GUI_AURA_ENABLE_AURA'] = '启用'
	L['GUI_AURA_MARGIN'] = '图标间隔'
	L['GUI_AURA_OFFSET'] = '增益/减益栏间隔'
	L['GUI_AURA_BUFF_REMINDER'] = '缺失增益提醒'
	L['GUI_AURA_BUFF_REMINDER_TIP'] = '\n提醒你缺失的自身增益光环\n比如法师智力牧师耐力潜行者毒药战士攻强之类'
	L['GUI_AURA_BUFF_SIZE'] = '增益图标大小'
	L['GUI_AURA_BUFFS_PER_ROW'] = '增益图标每行数量'
	L['GUI_AURA_REVERSE_BUFFS'] = '反向排列增益光环'
	L['GUI_AURA_DEBUFF_SIZE'] = '减益图标大小'
	L['GUI_AURA_DEBUFFS_PER_ROW'] = '减益图标每行数量'
	L['GUI_AURA_REVERSE_DEBUFFS'] = '反向排列减益光环'
	L['GUI_AURA_AURA_SOURCE'] = '光环来源'
	L['GUI_AURA_SUB_ADJUSTMENT'] = '调整'

	L['GUI_MISC_INVITE_KEYWORD'] = '密语邀请关键字'
	L['GUI_MISC_INVITE_KEYWORD_TIP'] = '输入完成后按下回车'

	L['GUI_APPEARANCE'] = '外观'
	L['GUI_APPEARANCE_DESC'] = '这些选项控制大部分和外观相关的设置'
	L['GUI_APPEARANCE_SUB_BASIC'] = '基础设定'

	L['GUI_UNITFRAME_TEXTURE_STYLE'] = '材质风格'
	L['GUI_UNITFRAME_TEXTURE_NORM'] = '默认'
	L['GUI_UNITFRAME_TEXTURE_GRAD'] = '渐变'
	L['GUI_UNITFRAME_TEXTURE_FLAT'] = '扁平'

	L['GUI_IMPORT_DATA_ERROR'] = '数据异常，导入失败！'
	L['GUI_IMPORT_DATA_WARNING'] = '|cffff2020是否导入数据？|r'
	L['GUI_DATA_INFO'] = '数据信息'
	L['GUI_DATA_VERSION'] = '版本'
	L['GUI_DATA_CHARACTER'] = '角色'
	L['GUI_DATA_EXCEPTION'] = '数据异常'
	L['GUI_DATA_IMPORT'] = '导入'
	L['GUI_DATA_EXPORT'] = '导出'
	L['GUI_DATA_IMPORT_HEADER'] = '导入字符串'
	L['GUI_DATA_EXPORT_HEADER'] = '导出字符串'
	L['GUI_DATA_RESET'] = '重置'
	L['GUI_DATA_RESET_TIP'] = '清除 |cffe9c55dFreeUI|r 已保存的数据，将所有选项重置为 |cffe9c55dFreeUI|r 默认值。'
	L['GUI_DATA_IMPORT_TIP'] = '导入 |cffe9c55dFreeUI|r 的配置字符串。'
	L['GUI_DATA_EXPORT_TIP'] = '将当前的 |cffe9c55dFreeUI|r 配置导出为字符串。'
end





-- Slash commands
L['COMMANDS_LIST_HINT'] = '可用命令：'
L['COMMANDS_LIST'] = {
	'/free install - 打开安装面板。',
	'/free config - 打开控制台。',
	'/free unlock - 解锁界面元素，解锁后可以自由移动界面元素。',
	'/free reset - 重置所有保存的选项恢复到默认值。',

	'/free dps - 使用默认头像布局。',
	'/free healer - 使用对治疗职业更友好的对称型布局。',
	'/free minimal - 使用简洁模式，此模式下头像和动作条默认隐藏。',

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














