local F, C, L = unpack(select(2, ...))



--[[ Misc ]]

do
	L['MISC_NUMBER_CAP'] = {'万', '亿', '兆'}


	L['MISC_REPUTATION'] = 'Reputation'
	L['MISC_PARAGON'] = 'Paragon'
	L['MISC_PARAGON_REPUTATION'] = 'Paragon Reputation'
	L['MISC_PARAGON_NOTIFY'] = 'Paragon Full, go redeem!'
	L['MISC_ORDERHALL_TIP'] = 'Hold Shift to display detailed information'


	L['MISC_DISBAND_GROUP'] = 'Disband Group'
	L['MISC_DISBAND_GROUP_CHECK'] = 'Are you sure you want to disband the group?'



	L['MISC_DECLINE_INVITE'] = 'Automatically declined group invitation from %s'
	L['MISC_ACCEPT_INVITE'] = 'Automatically accepted group invitation from %s'

	L['AUTOMATION_GET_NAKED'] = '双击脱光装备'
	L['AUTOMATION_BUY_STACK'] = 'Buy a stack of |cfff0000the following items?|r'
end


--[[ Blizzard ]]
do
	L['BLIZZARD_MOVER_ALERT'] = 'Alert frame'
	L['BLIZZARD_MOVER_VEHICLE'] = 'Vehicle indicator'
	L['BLIZZARD_MOVER_UIWIDGET'] = 'UIWidget frame'
	L['BLIZZARD_UNDRESS'] = 'Undress'
	L['BLIZZARD_STRANGER'] = 'Stranger'
	L['BLIZZARD_KEYSTONES'] = 'Keystone Information'
	L['BLIZZARD_KEYSTONES_RESET'] = 'Reset keystone information'
	L['BLIZZARD_GET_NAKED'] = '双击脱光装备'
	L['BLIZZARD_ORDERHALL_TIP'] = 'Hold <Shift> to display detailed information'
end


--[[ Themes ]]

do
	L['APPEARANCE_SUB_BASIC'] = 'Basic'

	L['APPEARANCE_NAME'] = 'Appearance'
	L['APPEARANCE_DESC'] = 'Controls FreeUI\'s appearance.'
end


--[[ Notification ]]

do
	L['NOTIFICATION_SUB_BASIC'] = 'Basic'

	L['NOTIFICATION_NAME'] = 'Notification'
	L['NOTIFICATION_DESC'] = 'Notifies some specific events.'

	L['NOTIFICATION_NEW_MAIL'] = 'You have new mail!'
	L['NOTIFICATION_BAG_FULL'] = 'Your bag is full!'
	L['NOTIFICATION_MAIL'] = 'Mail'
	L['NOTIFICATION_BAG'] = 'Bag'
	L['NOTIFICATION_RARE'] = 'Found rare!'
	L['NOTIFICATION_VERSION'] = 'Version Check'
	L['NOTIFICATION_VERSION_OUTDATE'] = 'FreeUI has been out of date, the latest release is |cff82c5ff%s|r'
end


--[[ Announcement ]]

do
	L['ANNOUNCEMENT_SUB_BASIC'] = 'Basic'

	L['ANNOUNCEMENT_NAME'] = 'Announcement'
	L['ANNOUNCEMENT_DESC'] = 'Announces some specific situation.'

	L['ANNOUNCEMENT_INTERRUPT'] = 'Interrupted %s of %s!'
	L['ANNOUNCEMENT_DISPEL'] = 'Dispelled %s of %s!'
	L['ANNOUNCEMENT_STOLEN'] = 'Stole %s of %s!'
	L['ANNOUNCEMENT_BATTLE_REZ'] = '%s used %s!'
	L['ANNOUNCEMENT_BATTLE_REZ_TARGET'] = '%s used %s in %s!'
	L['ANNOUNCEMENT_CASTED'] = '%s casted %s!'
	L['ANNOUNCEMENT_FEAST'] = '%s placed %s！'
	L['ANNOUNCEMENT_ITEM'] = '%s placed %s!'
	L['ANNOUNCEMENT_PORTAL'] = '%s opened %s!'
	L['ANNOUNCEMENT_SAPPED'] = 'Sapped!'
end


--[[ Infobar ]]

do
	L['INFOBAR_SUB_BASIC'] = 'Basic'

	L['INFOBAR_NAME'] = 'Infobar'
	L['INFOBAR_DESC'] = 'Provides many helpful information.'

	L['INFOBAR_DURABILITY'] = 'Durability'
	L['INFOBAR_OPEN_CHARACTER_PANEL'] = 'Open the character panel'

	L['INFOBAR_FRIENDS'] = 'Friends'
	L['INFOBAR_OPEN_FRIENDS_PANEL'] = 'Open the friends panel'
	L['INFOBAR_ADD_FRIEND'] = 'Add friend'

	L['INFOBAR_GUILD'] = 'Guild'
	L['INFOBAR_GUILD_NONE'] = 'No Guild'
	L['INFOBAR_OPEN_GUILD_PANEL'] = 'Open the guild panel'

	L['INFOBAR_REPORT'] = 'Report'
	L['INFOBAR_DAILY_WEEKLY_INFO'] = 'Daily/weekly information'
	L['INFOBAR_BLINGTRON'] = 'Blingtron Daily'
	L['INFOBAR_MEAN_ONE'] = 'Winter Veil Daily'
	L['INFOBAR_TIMEWARPED'] = 'Timewalking Badge Reward'
	L['INFOBAR_INVASION_LEG'] = 'Legion invasions'
	L['INFOBAR_INVASION_BFA'] = 'BFA invasions'
	L['INFOBAR_INVASION_CURRENT'] = 'Current: '
	L['INFOBAR_INVASION_NEXT'] = 'Next: '
	L['INFOBAR_LESSER_VISION'] = 'Lesser Vision of N\'zoth'
	L['INFOBAR_ISLAND'] = 'Island Expedition'
	L['INFOBAR_OPEN_BFA_REPORT'] = 'Open report(BFA)'
	L['INFOBAR_OPEN_LEG_REPORT'] = 'Open report(LEG)'
	L['INFOBAR_OPEN_WOD_REPORT'] = 'Open report(WOD)'

	L['INFOBAR_SPEC'] = 'Spec'
	L['INFOBAR_LOOT'] = 'Loot'
	L['INFOBAR_OPEN_SPEC_PANEL'] = 'Open the specialization panel'
	L['INFOBAR_CHANGE_SPEC'] = 'Change specialization'

	L['INFOBAR_LOCAL_TIME'] = 'Local Time'
	L['INFOBAR_REALM_TIME'] = 'Realm Time'
	L['INFOBAR_OPEN_ADDON_PANEL'] = 'Open addon panel'
	L['INFOBAR_OPEN_TIMER_TRACKER'] = 'Open the timer'
end


--[[ Chat ]]

do
	L['CHAT_SUB_BASIC'] = 'Basic'

	L['CHAT_NAME'] = 'Chat'
	L['CHAT_DESC'] = 'Controls most of chat related settings.'

	L['CHAT_TOGGLE_PANEL'] = 'Hide/Show chat box'
	L['CHAT_TOGGLE_WC'] = 'Join/Leave Channel'
	L['CHAT_COPY'] = 'Copy chat text'
	L['CHAT_WHISPER_TELL'] = 'To'
	L['CHAT_WHISPER_FROM'] = 'From'
end


--[[ Aura ]]

do
	L['AURA_SUB_BASIC'] = 'Basic'

	L['AURA_NAME'] = 'Aura'
	L['AURA_DESC'] = 'Controls most of aura related settings.'

	L['AURA_MOVER_BUFFS'] = 'Buffs'
	L['AURA_MOVER_DEBUFFS'] = 'Debuffs'
end


--[[ Actionbar ]]

do
	L['ACTIONBAR_SUB_BASIC'] = 'Basic'

	L['ACTIONBAR_NAME'] = 'Actionbar'
	L['ACTIONBAR_DESC'] = 'Controls actionbar\'s appearance and behavior.'

	L['ACTIONBAR_MOVER_BAR1'] = 'bar 1'
	L['ACTIONBAR_MOVER_BAR2'] = 'bar 2'
	L['ACTIONBAR_MOVER_BAR3'] = 'bar 3'
	L['ACTIONBAR_MOVER_BAR4'] = 'bar 4'
	L['ACTIONBAR_MOVER_BAR5'] = 'bar 5'
	L['ACTIONBAR_MOVER_PET'] = 'pet bar'
	L['ACTIONBAR_MOVER_STANCE'] = 'stance bar'
	L['ACTIONBAR_MOVER_EXTRA'] = 'extra bar'
	L['ACTIONBAR_MOVER_VEHICLE'] = 'vehicle bar'
	L['ACTIONBAR_MOVER_COOLDOWN'] = 'Cooldown'
	L['ACTIONBAR_KEY_UNBOUND'] = 'Unbound Button'
	L['ACTIONBAR_KEY_INDEX'] = 'Index'
	L['ACTIONBAR_KEY_BINDING'] = 'Key Binding'
	L['ACTIONBAR_KEY_BOUND_TO'] = ' Bound button'
	L['ACTIONBAR_SAVE_KEYBINDS'] = 'Keybinds saved'
	L['ACTIONBAR_DISCARD_KEYBINDS'] = 'Discard keybinds?'
	L['ACTIONBAR_CLEAR_BINDS'] = '%s |cff20ff20 Clear keybinds |r'
end


--[[ Combat ]]

do
	L['COMBAT_SUB_BASIC'] = 'Basic'

	L['COMBAT_NAME'] = 'Combat'
	L['COMBAT_DESC'] = 'Controls combat related settings.'

	L['COMBAT_ENTER'] = '++ COMBAT ++'
	L['COMBAT_LEAVE'] = '-- COMBAT --'
end


--[[ Inventory ]]

do
	L['INVENTORY_SUB_BASIC'] = 'Basic'

	L['INVENTORY_NAME'] = 'Inventory'
	L['INVENTORY_DESC'] = 'Controls inventory\'s appearance and behavior.'

	L['INVENTORY_NOTIFICATION_HEADER'] = 'Backpack'
	L['INVENTORY_SORT'] = 'Sort bags'
	L['INVENTORY_ANCHOR_RESET'] = 'Reset window position'
	L['INVENTORY_BAGS'] = 'Show bags'
	L['INVENTORY_FREE_SLOTS'] = 'Remaining bag space'
	L['INVENTORY_AZERITEARMOR'] = 'Azerite Armor'
	L['INVENTORY_EQUIPEMENTSET'] = 'Equipment Set'
	L['INVENTORY_QUICK_DELETE_ENABLED'] = '|nQuick destroy is enabled.|nYou can hold CTRL+ALT while clicking to destroy items in bags lower quality than blue.'
	L['INVENTORY_QUICK_DELETE'] = 'Quick Delete'
	L['INVENTORY_PICK_FAVOURITE_ENABLED'] = '|nFavorites enabled.|nYou can now click to mark items.|nIf classified storage of items is enabled, you can also add it to the favorites category.|nThis operation is invalid for junk items.'
	L['INVENTORY_PICK_FAVOURITE'] = 'Choose favorite'
	L['INVENTORY_AUTO_REPAIR'] = 'Auto Repair'
	L['INVENTORY_AUTO_REPAIR_ENABLED'] = '|nAuto repair is enabled.|nYour equipment will be repaired automatically every time you talk to the merchant.'
	L['INVENTORY_REPAIR_ERROR'] = 'Not enough money to repair!'
	L['INVENTORY_REPAIR_COST'] = 'Automatic repair cost'
	L['INVENTORY_SELL_JUNK'] = 'Auto sell junk'
	L['INVENTORY_SELL_JUNK_ENABLED'] = '|nThe automatic sale of junk has been enabled.|nEvery time you talk to a merchant, you will automatically sell junk items.'
	L['INVENTORY_SELL_JUNK_EARN'] = 'Automatically sell junk'
	L['INVENTORY_SEARCH'] = 'Search'
	L['INVENTORY_SEARCH_ENABLED'] = 'Enter item name to search'
	L['INVENTORY_MARK_JUNK'] = 'Mark junk'
	L['INVENTORY_MARK_JUNK_ENABLED'] = '|nClick to categorize sellable items as junk.|nWhen you turn on automatic junk selling, these items will also be sold together.|nThis list is shared by accounts.'
	L['INVENTORY_QUICK_SPLIT'] = 'Quick split'
	L['INVENTORY_SPLIT_COUNT'] = 'Split count'
	L['INVENTORY_SPLIT_MODE_ENABLED'] = '|nClick to split the stacked items, number of splits per click can be adjusted in left input box.'
	L['INVENTORY_GOLD_COUNT'] = 'Gold Count'
	L['INVENTORY_EARNED'] = 'Earned'
	L['INVENTORY_SPENT'] = 'Spent'
	L['INVENTORY_DEFICIT'] = 'Loss'
	L['INVENTORY_PROFIT'] = 'Profit'
	L['INVENTORY_SESSION'] = 'This session'
	L['INVENTORY_CHARACTER'] = 'Character'
	L['INVENTORY_GOLD_TOTAL'] = 'Total'
end


--[[ Map ]]

do
	L['MAP_SUB_BASIC'] = 'Basic'

	L['MAP_NAME'] = 'Map'
	L['MAP_DESC'] = 'Controls map related settings.'

	L['MAP_MOVER_MINIMAP'] = 'Minimap'
	L['MAP_CURSOR'] = 'Cursor'
	L['MAP_REVEAL'] = 'Remove map fog'
	L['MAP_PARAGON'] = 'Paragon'
	L['MAP_NEW_MAIL'] = '<New Mail>'
end


--[[ Quest ]]

do
	L['QUEST_SUB_BASIC'] = 'Basic'

	L['QUEST_NAME'] = 'Quest'
	L['QUEST_DESC'] = 'Controls quest related settings.'

	L['QUEST_MOVER_TRACKER'] = 'Quest tracker'
	L['QUEST_ACCEPT'] = 'Accept quest'
	L['QUEST_AUTOMATION'] = 'Auto turn-in'
end


-- Tooltip
do
	L['TOOLTIP_SUB_BASIC'] = 'Basic'

	L['TOOLTIP_NAME'] = 'Tooltip'
	L['TOOLTIP_DESC'] = 'Controls tooltip\'s appearance and behavior.'

	L['TOOLTIP_MOVER'] = 'Tooltip'
	L['TOOLTIP_RARE'] = 'Rare'
	L['TOOLTIP_AURA_FROM'] = 'From'
	L['TOOLTIP_SELL_PRICE'] = 'Sell Price'
	L['TOOLTIP_STACK_CAP'] = 'Stack Limit'
	L['TOOLTIP_ID_AZERITE_TRAIT'] = 'Azerite Traits'
	L['TOOLTIP_BAG'] = 'Bag'
	L['TOOLTIP_ID_SPELL'] = 'Spell ID'
	L['TOOLTIP_ID_ITEM'] = 'Item ID'
	L['TOOLTIP_ID_COMPANION'] = 'Pet ID'
	L['TOOLTIP_ID_QUEST'] = 'Quest ID'
	L['TOOLTIP_ID_TALENT'] = 'Talent ID'
	L['TOOLTIP_ID_ACHIEVEMENT'] = 'Achievement ID'
	L['TOOLTIP_ID_CURRENCY'] = 'Currency ID'
	L['TOOLTIP_ID_VISUAL'] = 'Visual'
	L['TOOLTIP_ID_SOURCE'] = 'Source'
	L['TOOLTIP_SECTION'] = '段落'
	L['TOOLTIP_TARGETED'] = 'Target'
	L['TOOLTIP_ILVL'] = 'iLvl'
end


--[[ Unitframe ]]

do
	L['UNITFRAME_SUB_BASIC'] = 'Basic'

	L['UNITFRAME_NAME'] = 'Unitframe'
	L['UNITFRAME_DESC'] = 'Controls unitframe related settings.'

	L['UNITFRAME_MOVER_INCOMING'] = 'Incoming damage and healing'
	L['UNITFRAME_MOVER_OUTGOING'] = 'Outgoing damage and healing'
	L['UNITFRAME_MOVER_CASTBAR'] = 'Castbar'
	L['UNITFRAME_MOVER_PLAYER'] = 'Player frame'
	L['UNITFRAME_MOVER_PET'] = 'Pet frame'
	L['UNITFRAME_MOVER_TARGET'] = 'Target frame'
	L['UNITFRAME_MOVER_TARGETTARGET'] = 'Target of Target frame'
	L['UNITFRAME_MOVER_FOCUS'] = 'Focus frame'
	L['UNITFRAME_MOVER_FOCUSTARGET'] = 'Focus target frame'
	L['UNITFRAME_MOVER_BOSS'] = 'Boss Frame'
	L['UNITFRAME_MOVER_ARENA'] = 'Arena frame'
	L['UNITFRAME_MOVER_PARTY'] = 'Party frame'
	L['UNITFRAME_MOVER_RAID'] = 'Raid frame'
	L['UNITFRAME_CLICK_CAST_BINDING'] = 'Click-cast binding'
	L['UNITFRAME_CLICK_CAST_TIP'] = 'Prompt'
	L['UNITFRAME_CLICK_CAST_DESC'] = 'Ctrl/Alt/Shift + any mouse click on the skill you want to bind.|nUse the bound shortcut key on the group frame to cast the skill.'
	L['UNITFRAME_GHOST'] = 'Ghost'
	L['UNITFRAME_OFFLINE'] = 'Offline'
end


--[[ Nameplate ]]
do
	L['NAMEPLATE_SUB_BASIC'] = 'Basic'

	L['NAMEPLATE_NAME'] = 'Nameplate'
	L['NAMEPLATE_DESC'] = 'Controls nameplate\'s appearance and behavior.'
	L['NAMEPLATE_ENABLE_NAMEPLATE'] = 'Enable'
	L['NAMEPLATE_ENABLE_NAMEPLATE_TIP'] = 'Uncheck this if you perfer other nameplate addon.'
	L['NAMEPLATE_PLATE_WIDTH'] = 'Nameplate width'
	L['NAMEPLATE_PLATE_HEIGHT'] = 'Nameplate height'
	L['NAMEPLATE_FRIENDLY_CLASS_COLOR'] = 'Friendly class colored'
	L['NAMEPLATE_FRIENDLY_COLOR'] = 'Friendly default color'
	L['NAMEPLATE_HOSTILE_CLASS_COLOR'] = 'Hostile class colored'

	L['NAMEPLATE_TANK_MODE'] = 'Force tank mode'
	L["NAMEPLATE_TANK_MODE_TIP"] = "Plate colored by its threat status to you"
	L['NAMEPLATE_DPS_REVERT_THREAT'] = 'Revert threat color'
	L["NAMEPLATE_DPS_REVERT_THREAT_TIP"] = "Revert threat color for dps role"
	L['NAMEPLATE_SECURE_COLOR'] = 'Secure color'
	L['NAMEPLATE_TRANS_COLOR'] = 'Transition color'
	L['NAMEPLATE_INSECURE_COLOR'] = 'Insecure color'
	L['NAMEPLATE_OFF_TANK_COLOR'] = 'Off tank'

	L['NAMEPLATE_CUSTOM_UNIT_COLOR'] = 'Custom color'
	L['NAMEPLATE_CUSTOM_UNIT_COLOR_TIP'] = 'Use custom color for specific units'
	L['NAMEPLATE_CUSTOM_COLOR'] = 'Custom color'
	L['NAMEPLATE_CUSTOM_UNIT_LIST'] = 'Specific units list'
	L['NAMEPLATE_CUSTOM_UNIT_LIST_TIP'] = 'Specific units list'
end


--[[ Data ]]
do
	L['DATA_NAME'] = 'Data'
	L['DATA_DESC'] = 'Controls addon\'s data.'
end


--[[ Install ]]

do
	L['INSTALL_HEADER_HELLO'] = 'Hello'
	L['INSTALL_BODY_WELCOME'] = 'Welcome to |cffe9c55dFreeUI|r!|n|nYou need to adjust some settings before you start using it to better work with |cffe9c55dFreeUI|r.|n|nClick the install button to enter the installation step.'
	L['INSTALL_HEADER_BASIC'] = 'Basic Settings'
	L['INSTALL_BODY_BASIC'] = 'These installation steps will adjust various suitable settings for |cffe9c55dFreeUI|r.|n|nThe first step will adjust some |cffe9c55dCVars|r settings.|n|nClick the continue button below to apply the settings, or click the skip button t o skip these settings.'
	L['INSTALL_HEADER_UISCALE'] = 'UIScale'
	L['INSTALL_BODY_UISCALE'] = 'This step will set the appropriate scale for the interface.'
	L['INSTALL_HEADER_CHAT'] = 'Chat'
	L['INSTALL_BODY_CHAT'] = 'This step will adjust settings related to the chat'
	L['INSTALL_HEADER_ACTIONBAR'] = 'Actionbars'
	L['INSTALL_BODY_ACTIONBAR'] = 'This step will adjust settings related to actionbars.'
	L['INSTALL_HEADER_ADDON'] = 'Addons'
	L['INSTALL_BODY_ADDON'] = 'This step will adjust the settings of |cffe9c55dDBM|r and |cffe9c55dSkada|r to match the interface style and layout of |cffe9c55dFreeUI|r.'
	L['INSTALL_HEADER_COMPLETE'] = 'Success!'
	L['INSTALL_BODY_COMPLETE'] = 'The installation has completed successfully.|n|nPlease click the Finish button below to reload the interface.|n|nRemember in the game you can enter |cffe9c55d/free|r to get detailed help or directly enter |cffe9c55d/free config|r to open the control panel and change various settings.'
	L['INSTALL_BUTTON_INSTALL'] = 'Install'
	L['INSTALL_BUTTON_SKIP'] = 'Skip'
	L['INSTALL_BUTTON_CONTINUE'] = 'Continue'
	L['INSTALL_BUTTON_FINISH'] = 'Finish'
	L['INSTALL_BUTTON_CANCEL'] = 'Cancel'
end




--[[ GUI ]]

do
	L['GUI_TIP'] = 'Hint'
	L['GUI_RELOAD_WARNING'] = '|cffff2020Reload UI to apply settings?|r'
	L['GUI_RESET_WARNING'] = '|cffff2020Remove all saved options and reset to default values?|r'
	L['GUI_PROFILE_WARNING'] = '|cffff2020Profile warning.|r'

	L['GUI_THEME_CONFLICTION_WARNING'] = 'FreeUI includes an efficient built-in module of theme.|n|nIt\'s highly recommended that you disable any version of Aurora or Skinner.'
	L['GUI_RESET_GOLD_COUNT'] = '|cffff2020Reset gold stats?|r'


	L['GUI_AURA'] = 'Auras'
	L['GUI_AURA_DESC'] = 'These options control settings related to auras'
	L['GUI_AURA_SUB_BASIC'] = 'Basic setting'
	L['GUI_AURA_ENABLE_AURA'] = 'Enable'
	L['GUI_AURA_MARGIN'] = 'Margin'
	L['GUI_AURA_OFFSET'] = 'Offset'
	L['GUI_AURA_BUFF_REMINDER'] = 'Missing buff reminder'
	L['GUI_AURA_BUFF_REMINDER_TIP'] = '|nReminds you of the missing self-buff aura|nFor Example, Mage Intelligence, Priest Stamina, Rogue Poison, etc.'
	L['GUI_AURA_BUFF_SIZE'] = 'Buff icon size'
	L['GUI_AURA_BUFFS_PER_ROW'] = 'Buffs per row'
	L['GUI_AURA_REVERSE_BUFFS'] = 'Reverse buffs'
	L['GUI_AURA_DEBUFF_SIZE'] = 'Debuff icon size'
	L['GUI_AURA_DEBUFFS_PER_ROW'] = 'Debuffs per row'
	L['GUI_AURA_REVERSE_DEBUFFS'] = 'Reverse debuffs'
	L['GUI_AURA_AURA_SOURCE'] = 'Aura source'
	L['GUI_AURA_SUB_ADJUSTMENT'] = 'Adjustment'

	L['GUI_MISC_INVITE_KEYWORD'] = 'Keyword invitation'
	L['GUI_MISC_INVITE_KEYWORD_TIP'] = 'After typing, press enter'

	L['GUI_APPEARANCE'] = 'Appearance'
	L['GUI_APPEARANCE_DESC'] = 'These options control most appearance-related settings.'
	L['GUI_APPEARANCE_SUB_BASIC'] = 'Basic setting'

	L['GUI_UNITFRAME_TEXTURE_STYLE'] = 'Texture style'
	L['GUI_UNITFRAME_TEXTURE_NORM'] = 'Default'
	L['GUI_UNITFRAME_TEXTURE_GRAD'] = 'Gradient'
	L['GUI_UNITFRAME_TEXTURE_FLAT'] = 'Flat'





	L['GUI_NUMBER_FORMAT'] = 'Number format'
	L['GUI_NUMBER_FORMAT_EN'] = 'k/b/m'
	L['GUI_NUMBER_FORMAT_CN'] = '万/亿/兆'

	L['GUI_IMPORT_DATA_ERROR'] = 'Data is abnormal, import failed!'
	L['GUI_IMPORT_DATA_WARNING'] = '|cffff2020Import data?|r'
	L['GUI_DATA_INFO'] = 'Data information'
	L['GUI_DATA_VERSION'] = 'Version'
	L['GUI_DATA_CHARACTER'] = 'Character'
	L['GUI_DATA_EXCEPTION'] = 'Abnormal data'
	L['GUI_DATA_IMPORT'] = 'Import'
	L['GUI_DATA_EXPORT'] = 'Export'
	L['GUI_DATA_IMPORT_HEADER'] = 'Import string'
	L['GUI_DATA_EXPORT_HEADER'] = 'Export string'
	L['GUI_DATA_RESET'] = 'Reset data'
	L['GUI_DATA_RESET_TIP'] = 'Clear the saved data of |cffe9c55dFreeUI|r and reset all options to the default values of |cffe9c55dFreeUI|r.'
	L['GUI_DATA_IMPORT_TIP'] = 'Import config string of |cffe9c55dFreeUI|r.'
	L['GUI_DATA_EXPORT_TIP'] = 'Export config string of |cffe9c55dFreeUI|r.'


	L['GUI_MOVER_PANEL'] = 'Frame adjustment'
	L['GUI_MOVER_GRID'] = 'Grid'
	L['GUI_MOVER_RESET_ANCHOR'] = 'Reset frame position'
	L['GUI_MOVER_HIDE_ELEMENT'] = 'Hide frame'
	L['GUI_MOVER_TIPS'] = 'Prompt'
	L['GUI_MOVER_RESET_WARNING'] = 'Do you want to reset all interface elements to their default positions?'
	L['GUI_MOVER_CANCEL_WARNING'] = 'Do you want to cancel this operation?'
end





-- Slash commands
L['COMMANDS_LIST_HINT'] = 'Available commands:'
L['COMMANDS_LIST'] = {
	'/free install - Open installation panel',
	'/free config - Open configuration panel',
	'/free unlock - Unlock interface',
	'/free reset - Reset all saved options to default values.',

	'/rl - Reload UI',
	'/ss - Screenshots',
	'/clear - Clear the chat window',
	'/rc - Ready Check',
	'/rp - Roll poll',
	'/gc - Party/Raid convert',
	'/lg - Leave group',
	'/rs - Reset instance',
	'/tt - Tell target',
	'/spec - Switch spec',
	'/bind - Bind keys',
	'/gm - Opens the help panel',
}














