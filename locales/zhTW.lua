
local L = _G.LibStub('AceLocale-3.0'):NewLocale('FreeUI', 'zhTW')
if not L then return end

--@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="concat")@

L['Player Frame'] = '玩家框體'
L['Pet Frame'] = '寵物框體'
L['Target Frame'] = '目標框體'
L['Target of Target Frame'] = '目標的目標框體'
L['Focus Frame'] = '焦點框體'
L['Target of Focus Frame'] = '焦點的目標框體'
L['Boss Frame'] = '首領框體'
L['Arena Frame'] = '競技場框體'
L['Party Frame'] = '小隊框體'
L['Raid Frame'] = '團隊框體'
L['CustomBar'] = '額外動作條'
L['Buff Frame'] = '增益框體'
L['Debuff Frame'] = '減益框體'
L['Combat Text Incoming'] = '浮動戰鬥信息（受到）'
L['Combat Text Outgoing'] = '浮動戰鬥信息（輸出）'
L['Main Bar'] = '動作條'
L['Pet Bar'] = '寵物動作條'
L['Stance Bar'] = '姿態條'
L['Leave Vehicle Button'] = '離開載具按鈕'
L['Extra Button'] = '額外按鈕'
L['Zone Ability Button'] = '區域技能'
L['Cooldown Icon'] = '冷卻圖標'
L['Player Castbar'] = '玩家施法條'
L['Target Castbar'] = '目標施法條'
L['Focus Castbar'] = '焦點施法條'
L['Vehicle Indicator'] = '載具指示器'
L['Durability Indicator'] = '耐久指示器'
L['Quest Item Button'] = '任務物品按鈕'
L['Maw Threat Bar'] = '噬淵威脅條'
L['Group Tool'] = '隊伍工具'
L['Objective Tracker'] = '任務追蹤欄'
L['Tooltip'] = '鼠標提示'

L['Addon'] = '插件'
L['not found'] = '沒有找到'
L['Disbanding group'] = '解散隊伍'
L['Are you sure you want to disband the group?'] = '你確定要解散隊伍？'

L['Enhanced Menu'] = '增強菜單'
L['Guild Invite'] = '邀請入會'
L['Copy Name'] = '復制名字'
L['Who'] = '查詢'
L['Armory'] = '英雄榜'

L['Stats report'] = '屬性報告:'
L['Covenant: %s Soulbinds: %s'] = '盟約: %s 靈魂羈絆: %s'

L['Interrupted %target%\'s %target_spell%!'] = '打斷 %target% 的 %target_spell%！'
L['Dispelled %target%\'s %target_spell%!'] = '驅散 %target% 的 %target_spell%！'
L['Stolen %target%\'s %target_spell%!'] = '偷取 %target% 的 %target_spell%！'
L['%player% casted %spell% on %target%!'] = '%player% 對 %target% 施放了 %spell%！'
L['%player% casted %spell%!'] = '%player% 施放了 %spell%!'
L['Quest accept:'] = '接受任務：'
L['Announcement'] = '任務通報'
L['|nLet your teammates know the progress of quests.'] = '|n組隊時向隊友通報你的任務進展。'
L['%s has been reset.'] = '%s 已經重置。'
L['Can not reset %s, there are players still inside the instance.'] = '無法重置 %s，仍有玩家在副本中。'
L['Can not reset %s, there are players in your party attempting to zone into an instance.'] = '無法重置 %s, 隊伍中有玩家正在進入副本。'
L['Can not reset %s, there are players offline in your party.'] = '無法重置 %s, 隊伍中有玩家離線。'

L['Automatic'] = '自動交接任務'
L['|nAutomatically accept and deliver quests.|nHold SHIFT key to STOP automation.'] = '|n自動接受和完成任務。|n按住 Shift 鍵與 NPC 對話可以停止自動交接。'

L['%s cooldown remaining %s.'] = '%s 冷卻剩余 %s'
L['%s is now available.'] = '%s 冷卻完畢'

L['Press the escape key or right click to unbind this action.'] = '按 ESC 或右鍵撤銷按鍵設置。'
L['Index'] = '序號'
L['Key'] = '按鍵'
L['bound to'] = '綁定按鍵'
L['Keybinds saved.'] = '按鍵綁定已保存。'
L['Keybinds discarded.'] = '按鍵綁定已撤銷。'
L['All keybinds cleared for %s.'] = '%s 綁定的所有按鍵已清除。'

L['Addon has been out of date, the latest release is |cffff0000%s|r.'] = '插件已經過期，最新正式版為 |cffff0000%s|r'
L['Incompatible AddOns:'] = '檢測到不兼容的插件:'
L['Disable Incompatible Addons'] = '禁用不兼容的插件'

L['Click to cast'] = '點擊施法'
L['|nCtrl/Alt/Shift + any mouse button to binds spells.|nCast spells on party or raid frames with binded click set.|nPay attention to avoid key conflict if you enabled \'Easy Focus\' feature.'] = '|n使用 CTRL/ALT/SHIFT + 任意鼠標按鍵綁定技能。|n對小隊/團隊框體使用綁定按鍵即可直接施放技能。|n如果啟用了快速設定焦點功能請註意避免按鍵沖突。'
L['Configure Spell Binding'] = '技能綁定'

L['lacking'] = '缺少'

L['World channel'] = '世界頻道'
L['Join world channel'] = '加入世界頻道'
L['Leave world channel'] = '離開世界頻道'
L['Show chat frame'] = '顯示聊天框'
L['Hide chat frame'] = '隱藏聊天框'
L['Copy chat content'] = '復制聊天內容'
L['Tell'] = '告訴'
L['From'] = '來自'

L['Stand in circle and spam <SpaceBar> to complete!'] = '站在圈內連續按空格鍵完成任務！'

L['Paragon'] = '典範'
L['Cursor'] = '鼠標'

L['Enter Combat'] = '進入戰鬥'
L['Leave Combat'] = '離開戰鬥'

L['Layout'] = '界面布局'
L['Grids'] = '網格'
L['Reset default anchor'] = '還原初始位置'
L['Hide the frame'] = '隱藏面板'
L['Are you sure to reset all frame\'s position?'] = '你確定要重置所有面板的位置嗎？'

L['Rare'] = '稀有'
L['CastBy'] = '來自'
L['Stack'] = '堆疊'
L['Section'] = '段落'
L['TargetedBy'] = '關註'
L['iLvl'] = '裝等'

L['Inventory Sort'] = '背包整理'
L['Inventory sort disabled!'] = '背包整理已禁用！'
L['Reset Position'] = '重置背包位置'
L['Toggle Bags'] = '開關背包欄位'
L['Free slots'] = '剩余空間'
L['Azerite armor'] = '艾澤裏特護甲'
L['|nYou can destroy item by holding CTRL + ALT.|nThe item can be heirlooms or its quality lower then rare (blue).'] = '|n按住 CTRL + ALT 點擊物品快速摧毀。|n物品品質必須低於精良（藍色）。'
L['Quick Delete'] = '快速摧毀'
L['|nYou can now star items.|nIf \'Item Filter\' enabled, the item you starred will add to Preferences filter slots.|nThis is not available to junk.'] = '|n點擊物品標記為偏好。|n如果啟用了物品分類功能，偏好物品將會加入單獨的偏好分類。|n該功能對垃圾物品無效。'
L['Mark Favourite'] = '標記偏好物品'
L['Auto Repair'] = '自動修理裝備'
L['|nRepair your equipment automatically when you visit an able vendor.'] = '|n訪問商人時自動修理裝備。'
L['Auto Sell Junk'] = '自動出售垃圾'
L['|nSell junk items automtically when you visit an able vendor.'] = '|n訪問商人時自動出售垃圾。'
L['Type item name to search'] = '輸入物品名搜索'
L['Search'] = '搜索'
L['|nClick to tag item as junk.|nIf \'Auto sell junk\' enabled, these items would be sold as well.|nThe list is saved account-wide, and won\'t be in the export data.|nYou can hold CTRL + ALT and click to wipe the custom junk list.'] = '|n點擊物品標記為垃圾。|n如果啟用了自動出售垃圾功能，這些標記為垃圾的物品將被作為垃圾自動出售。|n垃圾物品列表賬號共享，按住 CTRL + ALT 點擊按鈕可以清空列表。'
L['Mark Junk'] = '標記垃圾物品'
L['|nClick to split stacked items in your bags.|nYou can change \'split count\' for each click thru the editbox.'] = '|n點擊拆分背包的堆疊物品。|n可在左側輸入框調整每次點擊的拆分個數。'
L['Quick Split'] = '快速拆分'
L['Split Count'] = '拆分數量'
L['|nLeft click to deposit reagents, right click to switch deposit mode.|nIf the button is highlight, the reagents from your bags would auto deposit once you open the bank.'] = '|n左鍵點擊存放材料，右鍵點擊切換存放模式。|n當按鈕高亮時，每當打開銀行，將自動存放背包中的材料。'

L['Talent Manager'] = '天賦管理'
L['Too many sets here, please delete one of them and try again.'] = '天賦方案已滿，請刪除後重試。'
L['Already have a set named %s.'] = '天賦方案 %s 已存在。'
L['Not set'] = '未設定'
L['Set Name'] = '方案名稱'
L['Ignored'] = '已忽略'
L['You must enter a set name.'] = '必須輸入一個方案名稱。'
L['Talent Set'] = '天賦方案'

L['Wowhead link']= 'Wowhead 鏈接'

L['Undress'] = '卸裝'
L['%sUndress all|n%sUndress tabard'] = '%s卸下全身|n%s卸下戰袍'
L['Right click to use vellum'] = '右鍵附魔至羊皮紙'
L['Stranger'] = '陌生人'
L['Account Keystones'] = '賬號角色鑰石信息'
L['Delete keystones info'] = '刪除已保存的賬號角色鑰石信息'
L['Double click to unequip all gears'] = '雙擊卸下所有裝備'
L['Hold SHIFT for details'] = '按住 SHIFT 顯示詳細信息'
L['Are you sure to buy |cffff0000a stack|r of these?'] = '確定購買整組？'
L['Flask'] = '合劑'
L['Lack of'] = '缺少'
L['%s players'] = '%s名玩家'
L['Start/Cancel count down'] = '開始/取消倒計時'
L['Check Flask & Food'] = '食物合劑檢查'
L['All Buffs Ready!'] = '食物合劑檢查: 已齊全'
L['Raid Buff Checker:'] = '食物合劑檢查:'
L['ExRT Potion Check'] = 'ExRT藥水使用報告'
L['You can not do it without DBM or BigWigs!'] = '必須安裝DBM或者BigWigs才能使用倒計時'
L['Are you sure to |cffff0000disband|r your group?'] = '確定|cffff0000解散|r當前隊伍或者團隊？'
L['Raid Disbanding'] = '團隊解散中'

L['Durability'] = '裝備耐久'
L['Toggle Character Panel'] = '開關角色面板'
L['Friends'] = '在線好友'
L['Toggle Friends Panel'] = '開關好友列表面板'
L['Add Friend'] = '添加好友'
L['Guild'] = '公會'
L['None'] = '無'
L['Toggle Guild Panel'] = '開關公會面板'
L['Toggle Communities Panel'] = '開關社區面板'
L['Toggle Talent Panel'] = '開關天賦面板'
L['Change Specialization & Loot'] = '更改專精/拾取'
L['Daily/Weekly'] = '日常/周常'
L['Blingtron Daily Pack'] = '布林頓每日禮包'
L['Winter Veil Daily'] = '冬幕節日常'
L['Timewarped Badge Reward'] = '本周漫遊徽章獎勵'
L['Legion Invasion'] = '軍團入侵'
L['Faction Assaults'] = '陣營突襲'
L['Current'] = '當前'
L['Next'] = '下次'
L['Lesser Vision of N\'Zoth'] = '恩佐斯的幻象統計'
L['Toggle Great Vault Panel'] = '開關宏偉寶庫面板'
L['Toggle Calendar Panel'] = '開關日歷面板'
L['Local Time'] = '本地時間'
L['Realm Time'] = '服務器時間'
L['Toggle Addons Panel'] = '開關插件列表界面'
L['Toggle Timer Panel'] = '開關計時器面板'
L['Earned'] = '獲得'
L['Spent'] = '花費'
L['Deficit'] = '虧損'
L['Profit'] = '盈利'
L['Session'] = '本次登錄'
L['Toggle Currency Panel'] = '開關貨幣面板'
L['Toggle Store Panel'] = '開關商店面板'
L['Reset Gold Statistics'] = '重置金幣統計信息'