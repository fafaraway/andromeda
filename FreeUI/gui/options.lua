local F, C, L = unpack(select(2, ...))
local GUI = F.GUI
local oUF = F.oUF

function GUI:UpdateInventoryStatus()
	F.INVENTORY:UpdateAllBags()
end

local function SetupInventoryFilter()
	GUI:SetupInventoryFilter(GUI.Page[9])
end

local function SetupActionBarFader()
	GUI:SetupActionBarFader(GUI.Page[6])
end

local function UpdateActionBarScale()
	F.ACTIONBAR:UpdateAllScale()
end

local function UpdateCustomBar()
	F.ACTIONBAR:UpdateCustomBar()
end

local function UpdateWhisperSticky()
	F.CHAT:ChatWhisperSticky()
end

local function UpdateWhisperList()
	F.CHAT:UpdateWhisperList()
end

local function UpdateFilterList()
	F.CHAT:UpdateFilterList()
end

local function UpdateFilterWhiteList()
	F.CHAT:UpdateFilterWhiteList()
end

local function UpdateChatSize()
	F.CHAT:UpdateChatSize()
end

local function NamePlateAuraFilter()
	GUI:NamePlateAuraFilter(GUI.Page[14])
end

local function UpdateCustomUnitList()
	F.NAMEPLATE:CreateUnitTable()
end

local function RefreshNameplates()
	F.NAMEPLATE:RefreshAllPlates()
end

local function UpdatePlateSpacing()
	F.NAMEPLATE:UpdatePlateVerticalSpacing()
	F.NAMEPLATE:UpdatePlateHorizontalSpacing()
end

local function UpdatePlateAlpha()
	F.NAMEPLATE:UpdatePlateAlpha()
	F.NAMEPLATE:UpdatePlateOccludedAlpha()
end

local function UpdatePlateScale()
	F.NAMEPLATE:UpdatePlateScale()
	F.NAMEPLATE:UpdatePlateTargetScale()
end

local function SetupUnitFrameSize()
	GUI:SetupUnitFrameSize(GUI.Page[12])
end

local function SetupGroupFrameSize()
	GUI:SetupGroupFrameSize(GUI.Page[13])
end

local function SetupUnitFrameFader()
	GUI:SetupUnitFrameFader(GUI.Page[12])
end

local function SetupCastbar()
	GUI:SetupCastbar(GUI.Page[12])
end

local function SetupCustomClassColor()
	GUI:SetupCustomClassColor(GUI.Page[15])
end

local function SetupPartySpellCooldown()
	GUI:SetupPartySpellCooldown(GUI.Page[13])
end

local function SetupGroupDebuffs()
	GUI:SetupGroupDebuffs(GUI.Page[13])
end

GUI.OptionsList = {
	[1] = {
		-- appearance
		{1, 'ACCOUNT', 'cursor_trail', L.GUI.APPEARANCE.CURSOR_TRAIL},
		{1, 'ACCOUNT', 'shadow_border', L.GUI.APPEARANCE.SHADOW_BORDER},
		{3, 'ACCOUNT', 'backdrop_alpha', L.GUI.APPEARANCE.BACKDROP_ALPHA, true, {0, 1, .01}},
		{1, 'ACCOUNT', 'reskin_blizz', L.GUI.APPEARANCE.RESKIN_BLIZZ},
		{1, 'ACCOUNT', 'vignetting', L.GUI.APPEARANCE.VIGNETTING, nil},
		{3, 'ACCOUNT', 'vignetting_alpha', L.GUI.APPEARANCE.VIGNETTING_ALPHA, true, {0, 1, .01}},
		-- {5, 'ACCOUNT', 'backdrop_color', L.GUI.APPEARANCE.BACKDROP_COLOR},
		-- {5, 'ACCOUNT', 'border_color', L.GUI.APPEARANCE.BORDER_COLOR, 1},
		{},
		{1, 'ACCOUNT', 'reskin_dbm', L.GUI.APPEARANCE.RESKIN_DBM},
		{1, 'ACCOUNT', 'reskin_pgf', L.GUI.APPEARANCE.RESKIN_PGF, true},
		{},
		{3, 'ACCOUNT', 'ui_scale', L.GUI.APPEARANCE.UI_SCALE, nil, {.5, 2, .01}, nil, L.GUI.APPEARANCE.UI_SCALE_TIP}
	},
	[2] = {
		-- notification
		{1, 'notification', 'enable', L.GUI.NOTIFICATION.ENABLE},
		{1, 'notification', 'bag_full', L.GUI.NOTIFICATION.BAG_FULL},
		{1, 'notification', 'new_mail', L.GUI.NOTIFICATION.NEW_MAIL, true},
		{1, 'notification', 'rare_found', L.GUI.NOTIFICATION.RARE_FOUND, nil, nil, nil, L.GUI.NOTIFICATION.RARE_FOUND_TIP},
		{1, 'notification', 'version_check', L.GUI.NOTIFICATION.VERSION_CHECK, true}
	},
	[3] = {
		-- infobar
		{1, 'infobar', 'enable', L.GUI.INFOBAR.ENABLE},
		{1, 'infobar', 'anchor_top', L.GUI.INFOBAR.ANCHOR_TOP},
		{1, 'infobar', 'mouseover', L.GUI.INFOBAR.MOUSEOVER, true},
		{1, 'infobar', 'stats', L.GUI.INFOBAR.STATS},
		{1, 'infobar', 'spec', L.GUI.INFOBAR.SPEC, true},
		{1, 'infobar', 'durability', L.GUI.INFOBAR.DURABILITY},
		{1, 'infobar', 'guild', L.GUI.INFOBAR.GUILD, true},
		{1, 'infobar', 'friends', L.GUI.INFOBAR.FRIENDS},
		{1, 'infobar', 'report', L.GUI.INFOBAR.REPORT, true}
	},
	[4] = {
		-- chat
		{1, 'chat', 'enable', L.GUI.CHAT.ENABLE},
		{1, 'chat', 'lock_position', L.GUI.CHAT.LOCK_POSITION, nil, nil, nil, L.GUI.CHAT.LOCK_POSITION_TIP},
		{1, 'chat', 'font_outline', L.GUI.CHAT.FONT_OUTLINE, true},
		{1, 'chat', 'fade_out', L.GUI.CHAT.FADE_OUT, nil, nil, nil, L.GUI.CHAT.FADE_OUT_TIP},
		{1, 'chat', 'abbr_channel_names', L.GUI.CHAT.ABBR_CHANNEL_NAMES, true},
		{1, 'chat', 'voice_button', L.GUI.CHAT.VOICE_BUTTON},
		{1, 'chat', 'tab_cycle', L.GUI.CHAT.TAB_CYCLE, true, nil, nil, L.GUI.CHAT.TAB_CYCLE_TIP},
		{1, 'chat', 'smart_bubble', L.GUI.CHAT.SMART_BUBBLE, nil, nil, nil, L.GUI.CHAT.SMART_BUBBLE_TIP},
		{1, 'chat', 'whisper_sticky', L.GUI.CHAT.WHISPER_STICKY, true, nil, UpdateWhisperSticky},
		{1, 'chat', 'whisper_sound', L.GUI.CHAT.WHISPER_SOUND},
		{1, 'chat', 'item_links', L.GUI.CHAT.ITEM_LINKS, true},
		{1, 'chat', 'spamage_meter', L.GUI.CHAT.SPAMAGE_METER},
		{},
		{1, 'chat', 'use_filter', L.GUI.CHAT.USE_FILTER},
		{1, 'chat', 'block_addon_spam', L.GUI.CHAT.BLOCK_ADDON_SPAM, true},
		{1, 'chat', 'allow_friends_spam', L.GUI.CHAT.ALLOW_FRIENDS_SPAM, nil, nil, nil, L.GUI.CHAT.ALLOW_FRIENDS_SPAM_TIP},
		{1, 'chat', 'block_stranger_whisper', L.GUI.CHAT.BLOCK_STRANGER_WHISPER},
		{2, 'ACCOUNT', 'chat_filter_white_list', L.GUI.CHAT.WHITE_LIST, true, nil, UpdateFilterWhiteList, L.GUI.CHAT.WHITE_LIST_TIP},
		{3, 'chat', 'matche_number', L.GUI.CHAT.MATCHE_NUMBER, nil, {1, 3, 1}},
		{2, 'ACCOUNT', 'chat_filter_black_list', L.GUI.CHAT.BLACK_LIST, true, nil, UpdateFilterList, L.GUI.CHAT.BLACK_LIST_TIP},
		{},
		{1, 'chat', 'whisper_invite', L.GUI.CHAT.WHISPER_INVITE},
		{1, 'chat', 'guild_only', L.GUI.CHAT.GUILD_ONLY},
		{2, 'chat', 'invite_keyword', L.GUI.CHAT.INVITE_KEYWORD, true, nil, UpdateWhisperList}
	},
	[5] = {
		-- aura
		{1, 'aura', 'enable', L.GUI.AURA.ENABLE, nil, nil, nil, L.GUI.AURA.ENABLE_TIP},
		{1, 'aura', 'reverse_buffs', L.GUI.AURA.REVERSE_BUFFS},
		{1, 'aura', 'reverse_debuffs', L.GUI.AURA.REVERSE_DEBUFFS, true},
		{},
		{3, 'aura', 'margin', L.GUI.AURA.MARGIN, nil, {3, 10, 1}},
		{3, 'aura', 'offset', L.GUI.AURA.OFFSET, true, {3, 10, 1}},
		{3, 'aura', 'buff_size', L.GUI.AURA.BUFF_SIZE, nil, {20, 50, 1}},
		{3, 'aura', 'debuff_size', L.GUI.AURA.DEBUFF_SIZE, true, {20, 50, 1}},
		{3, 'aura', 'buffs_per_row', L.GUI.AURA.BUFFS_PER_ROW, nil, {6, 12, 1}},
		{3, 'aura', 'debuffs_per_row', L.GUI.AURA.DEBUFFS_PER_ROW, true, {6, 12, 1}},
		{},
		{1, 'aura', 'reminder', L.GUI.AURA.REMINDER, nil, nil, nil, L.GUI.AURA.REMINDER_TIP}
	},
	[6] = {
		-- actionbar
		{1, 'actionbar', 'enable', L.GUI.ACTIONBAR.ENABLE, nil, nil, nil, L.GUI.ACTIONBAR.ENABLE_TIP},
		{1, 'actionbar', 'button_hotkey', L.GUI.ACTIONBAR.BUTTON_HOTKEY},
		{1, 'actionbar', 'button_macro_name', L.GUI.ACTIONBAR.BUTTON_MACRO_NAME, true},
		{1, 'actionbar', 'button_count', L.GUI.ACTIONBAR.BUTTON_COUNT},
		{1, 'actionbar', 'button_class_color', L.GUI.ACTIONBAR.BUTTON_CLASS_COLOR, true},
		{1, 'actionbar', 'fade', L.GUI.ACTIONBAR.FADE, nil, SetupActionBarFader, nil, L.GUI.ACTIONBAR.FADE_TIP},
		{3, 'actionbar', 'scale', L.GUI.ACTIONBAR.SCALE, nil, {.5, 2, .1}, UpdateActionBarScale},
		{},
		{1, 'actionbar', 'bar1', L.GUI.ACTIONBAR.BAR1},
		{1, 'actionbar', 'bar2', L.GUI.ACTIONBAR.BAR2, true},
		{1, 'actionbar', 'bar3', L.GUI.ACTIONBAR.BAR3},
		{1, 'actionbar', 'bar3_divide', L.GUI.ACTIONBAR.BAR3_DIVIDE, true},
		{1, 'actionbar', 'bar4', L.GUI.ACTIONBAR.BAR4},
		{1, 'actionbar', 'bar5', L.GUI.ACTIONBAR.BAR5, true},
		{1, 'actionbar', 'pet_bar', L.GUI.ACTIONBAR.PET_BAR},
		{1, 'actionbar', 'stance_bar', L.GUI.ACTIONBAR.STANCE_BAR, true},
		{1, 'actionbar', 'leave_vehicle_bar', L.GUI.ACTIONBAR.LEAVE_VEHICLE_BAR},
		{},
		{1, 'actionbar', 'custom_bar', L.GUI.ACTIONBAR.CUSTOM_BAR},
		{3, 'actionbar', 'custom_bar_button_size', L.GUI.ACTIONBAR.CUSTOM_BAR_BUTTON_SIZE, nil, {10, 40, 1}, UpdateCustomBar},
		{3, 'actionbar', 'custom_bar_button_number', L.GUI.ACTIONBAR.CUSTOM_BAR_BUTTON_NUMBER, true, {1, 12, 1}, UpdateCustomBar},
		{3, 'actionbar', 'custom_bar_button_per_row', L.GUI.ACTIONBAR.CUSTOM_BAR_BUTTON_PER_ROW, nil, {1, 12, 1}, UpdateCustomBar}
	},
	[7] = {
		-- combat
		{1, 'combat', 'enable', L.GUI.COMBAT.ENABLE, nil, nil, nil, L.GUI.COMBAT.ENABLE_TIP},
		{1, 'combat', 'combat_alert', L.GUI.COMBAT.COMBAT_ALERT, nil, nil, nil, L.GUI.COMBAT.COMBAT_ALERT_TIP},
		{1, 'combat', 'spell_sound', L.GUI.COMBAT.SPELL_SOUND, true, nil, nil, L.GUI.COMBAT.SPELL_SOUND_TIP},
		{1, 'combat', 'easy_mark', L.GUI.COMBAT.EASY_MARK, nil, nil, nil, L.GUI.COMBAT.EASY_MARK_TIP},
		{1, 'combat', 'easy_focus', L.GUI.COMBAT.EASY_FOCUS, true, nil, nil, L.GUI.COMBAT.EASY_FOCUS_TIP},
		{1, 'combat', 'easy_tab', L.GUI.COMBAT.EASY_TAB, nil, nil, nil, L.GUI.COMBAT.EASY_TAB_TIP},
		{1, 'combat', 'pvp_sound', L.GUI.COMBAT.PVP_SOUND, true, nil, nil, L.GUI.COMBAT.PVP_SOUND_TIP},
		{},
		{1, 'combat', 'fct', L.GUI.COMBAT.FCT},
		{1, 'combat', 'fct_in', L.GUI.COMBAT.FCT_IN},
		{1, 'combat', 'fct_out', L.GUI.COMBAT.FCT_OUT, true},
		{1, 'combat', 'fct_pet', L.GUI.COMBAT.FCT_PET},
		{1, 'combat', 'fct_periodic', L.GUI.COMBAT.FCT_PERIODIC, true},
		{1, 'combat', 'fct_merge', L.GUI.COMBAT.FCT_MERGE}
	},
	[8] = {
		-- announcement
		{1, 'announcement', 'enable', L.GUI.ANNOUNCEMENT.ENABLE, nil, nil, nil, L.GUI.ANNOUNCEMENT.ENABLE_TIP},
		{1, 'announcement', 'interrupt', L.GUI.ANNOUNCEMENT.INTERRUPT, nil, nil, nil, L.GUI.ANNOUNCEMENT.INTERRUPT_TIP},
		{1, 'announcement', 'dispel', L.GUI.ANNOUNCEMENT.DISPEL, true, nil, nil, L.GUI.ANNOUNCEMENT.DISPEL_TIP},
		{1, 'announcement', 'combat_resurrection', L.GUI.ANNOUNCEMENT.COMBAT_RESURRECTION, nil, nil, nil, L.GUI.ANNOUNCEMENT.COMBAT_RESURRECTION_TIP},
		{1, 'announcement', 'utility', L.GUI.ANNOUNCEMENT.UTILITY, true, nil, nil, L.GUI.ANNOUNCEMENT.UTILITY_TIP}
	},
	[9] = {
		-- inventory
		{1, 'inventory', 'enable', L.GUI.INVENTORY.ENABLE, nil, nil, nil, L.GUI.INVENTORY.ENABLE_TIP},
		{1, 'inventory', 'new_item_flash', L.GUI.INVENTORY.NEW_ITEM_FLASH, nil, nil, nil, L.GUI.INVENTORY.NEW_ITEM_FLASH_TIP},
		{1, 'inventory', 'combine_free_slots', L.GUI.INVENTORY.COMBINE_FREE_SLOTS, true, nil, GUI.UpdateInventoryStatus, L.GUI.INVENTORY.COMBINE_FREE_SLOTS_TIP},
		{1, 'inventory', 'bind_type', L.GUI.INVENTORY.BIND_TYPE, nil, nil, GUI.UpdateInventoryStatus, L.GUI.INVENTORY.BIND_TYPE_TIP},
		{1, 'inventory', 'item_level', L.GUI.INVENTORY.ITEM_LEVEL, true, nil, GUI.UpdateInventoryStatus},
		{1, 'inventory', 'item_filter', L.GUI.INVENTORY.ITEM_FILTER, nil, SetupInventoryFilter, GUI.UpdateInventoryStatus, L.GUI.INVENTORY.ITEM_FILTER_TIP},
		{1, 'inventory', 'special_color', L.GUI.INVENTORY.SPECIAL_COLOR, true, nil, GUI.UpdateInventoryStatus, L.GUI.INVENTORY.SPECIAL_COLOR_TIP},
		{},
		{3, 'inventory', 'slot_size', L.GUI.INVENTORY.SLOT_SIZE, nil, {20, 60, 1}},
		{3, 'inventory', 'spacing', L.GUI.INVENTORY.SPACING, true, {3, 10, 1}},
		{3, 'inventory', 'bag_columns', L.GUI.INVENTORY.BAG_COLUMNS, nil, {8, 20, 1}},
		{3, 'inventory', 'bank_columns', L.GUI.INVENTORY.BANK_COLUMNS, true, {8, 20, 1}},
		{3, 'inventory', 'item_level_to_show', L.GUI.INVENTORY.ITEM_LEVEL_TO_SHOW, nil, {1, 200, 1}, nil, L.GUI.INVENTORY.ITEM_LEVEL_TO_SHOW_TIP},
		{},
		{4, 'inventory', 'sort_mode', L.GUI.INVENTORY.SORT_MODE, nil, {L.GUI.INVENTORY.SORT_TO_TOP, L.GUI.INVENTORY.SORT_TO_BOTTOM, DISABLE}, nil, L.GUI.INVENTORY.SORT_TIP}
	},
	[10] = {
		-- map
		{1, 'map', 'enable', L.GUI.MAP.ENABLE, nil, nil, nil, L.GUI.MAP.ENABLE_TIP},
		{1, 'map', 'remove_fog', L.GUI.MAP.REMOVE_FOG},
		{1, 'map', 'coords', L.GUI.MAP.COORDS, true},
		{3, 'map', 'worldmap_scale', L.GUI.MAP.WORLDMAP_SCALE, nil, {.5, 2, .1}},
		{3, 'map', 'max_worldmap_scale', L.GUI.MAP.MAX_WORLDMAP_SCALE, true, {.5, 1, .1}},
		{},
		{1, 'map', 'who_pings', L.GUI.MAP.WHO_PINGS},
		{1, 'map', 'micro_menu', L.GUI.MAP.MICRO_MENU, true, nil, nil, L.GUI.MAP.MICRO_MENU_TIP},
		{1, 'map', 'progress_bar', L.GUI.MAP.PROGRESS_BAR, nil, nil, nil, L.GUI.MAP.PROGRESS_BAR_TIP},
		{3, 'map', 'minimap_scale', L.GUI.MAP.MINIMAP_SCALE, nil, {.5, 1, .1}}
	},
	[11] = {
		-- tooltip
		{1, 'tooltip', 'enable', L.GUI.TOOLTIP.ENABLE, nil, nil, nil, L.GUI.TOOLTIP.ENABLE_TIP},
		{1, 'tooltip', 'follow_cursor', L.GUI.TOOLTIP.FOLLOW_CURSOR, nil, nil, nil, L.GUI.TOOLTIP.FOLLOW_CURSOR_TIP},
		{1, 'tooltip', 'hide_in_combat', L.GUI.TOOLTIP.HIDE_IN_COMBAT, true},
		{1, 'tooltip', 'border_color', L.GUI.TOOLTIP.BORDER_COLOR},
		{1, 'tooltip', 'tip_icon', L.GUI.TOOLTIP.TIP_ICON, true},
		{1, 'tooltip', 'target_by', L.GUI.TOOLTIP.TARGET_BY},
		{1, 'tooltip', 'extra_info', L.GUI.TOOLTIP.EXTRA_INFO, true, nil, nil, L.GUI.TOOLTIP.EXTRA_INFO_TIP},
		{1, 'tooltip', 'azerite_armor', L.GUI.TOOLTIP.AZERITE_ARMOR},
		{1, 'tooltip', 'conduit_info', L.GUI.TOOLTIP.CONDUIT_INFO, true},
		{1, 'tooltip', 'spec_ilvl', L.GUI.TOOLTIP.SPEC_ILVL, nil, nil, nil, L.GUI.TOOLTIP.SPEC_ILVL_TIP},
		{1, 'tooltip', 'hide_realm', L.GUI.TOOLTIP.HIDE_REALM, true},
		{1, 'tooltip', 'hide_title', L.GUI.TOOLTIP.HIDE_TITLE},
		{1, 'tooltip', 'hide_rank', L.GUI.TOOLTIP.HIDE_RANK, true}
	},
	[12] = {
		-- unitframes
		{1, 'unitframe', 'enable', L.GUI.UNITFRAME.ENABLE, nil, SetupUnitFrameSize},
		{1, 'unitframe', 'transparent_mode', L.GUI.UNITFRAME.TRANSPARENT_MODE},
		{1, 'unitframe', 'portrait', L.GUI.UNITFRAME.PORTRAIT, true},
		{1, 'unitframe', 'fade', L.GUI.UNITFRAME.FADE, nil, SetupUnitFrameFader},
		{1, 'unitframe', 'range_check', L.GUI.UNITFRAME.RANGE_CHECK, true},
		{1, 'unitframe', 'player_combat_indicator', L.GUI.UNITFRAME.PLAYER_COMBAT_INDICATOR},
		{1, 'unitframe', 'player_resting_indicator', L.GUI.UNITFRAME.PLAYER_RESTING_INDICATOR, true},
		{1, 'unitframe', 'player_hide_tags', L.GUI.UNITFRAME.PLAYER_HIDE_TAGS},
		{1, 'unitframe', 'heal_prediction', L.GUI.UNITFRAME.HEAL_PREDICTION, true},
		{1, 'unitframe', 'gcd_spark', L.GUI.UNITFRAME.GCD_SPARK},
		{1, 'unitframe', 'class_power_bar', L.GUI.UNITFRAME.CLASS_POWER_BAR, true},
		{1, 'unitframe', 'stagger_bar', L.GUI.UNITFRAME.STAGGER_BAR},
		{1, 'unitframe', 'totems_bar', L.GUI.UNITFRAME.TOTEMS_BAR, true},
		{4, 'unitframe', 'color_style', L.GUI.UNITFRAME.COLOR_STYLE, nil, {L.GUI.UNITFRAME.COLOR_STYLE_DEFAULT, L.GUI.UNITFRAME.COLOR_STYLE_CLASS, L.GUI.UNITFRAME.COLOR_STYLE_GRADIENT}},
		{},
		{1, 'unitframe', 'debuffs_by_player', L.GUI.UNITFRAME.DEBUFFS_BY_PLAYER},
		{1, 'unitframe', 'debuff_type', L.GUI.UNITFRAME.DEBUFF_TYPE, true},
		{1, 'unitframe', 'stealable_buffs', L.GUI.UNITFRAME.STEALABLE_BUFFS},
		{},
		{1, 'unitframe', 'enable_castbar', L.GUI.UNITFRAME.ENABLE_CASTBAR, nil, SetupCastbar},
		{1, 'unitframe', 'castbar_timer', L.GUI.UNITFRAME.CASTBAR_TIMER},
		{1, 'unitframe', 'castbar_focus_separate', L.GUI.UNITFRAME.CASTBAR_FOCUS_SEPARATE, true},
		{},
		{1, 'unitframe', 'enable_boss', L.GUI.UNITFRAME.ENABLE_BOSS},
		{4, 'unitframe', 'boss_color_style', L.GUI.UNITFRAME.COLOR_STYLE, nil, {L.GUI.UNITFRAME.COLOR_STYLE_DEFAULT, L.GUI.UNITFRAME.COLOR_STYLE_CLASS, L.GUI.UNITFRAME.COLOR_STYLE_GRADIENT}},
		{1, 'unitframe', 'enable_arena', L.GUI.UNITFRAME.ENABLE_ARENA},
		{},
		{3, 'unitframe', 'target_icon_indicator_alpha', L.GUI.UNITFRAME.TARGET_ICON_INDICATOR_ALPHA, nil, {.5, 1, .1}},
		{3, 'unitframe', 'target_icon_indicator_size', L.GUI.UNITFRAME.TARGET_ICON_INDICATOR_SIZE, true, {16, 32, 8}}
	},
	[13] = {
		-- groupframes
		{1, 'unitframe', 'enable_group', L.GUI.GROUPFRAME.ENABLE_GROUP, nil, SetupGroupFrameSize},
		{1, 'unitframe', 'group_names', L.GUI.GROUPFRAME.GROUP_NAMES},
		{1, 'unitframe', 'group_click_cast', L.GUI.GROUPFRAME.GROUP_CLICK_CAST, true, nil, nil, L.GUI.GROUPFRAME.GROUP_CLICK_CAST_TIP},
		{1, 'unitframe', 'spec_position', L.GUI.GROUPFRAME.SPEC_POSITION},
		{1, 'unitframe', 'group_threat_indicator', L.GUI.GROUPFRAME.GROUP_THREAT_INDICATOR, true},
		{1, 'unitframe', 'raid_debuffs', L.GUI.GROUPFRAME.RAID_DEBUFFS, nil, SetupGroupDebuffs},
		{1, 'unitframe', 'auras_click_through', L.GUI.GROUPFRAME.AURAS_CLICK_THROUGH, true},
		{1, 'unitframe', 'group_debuff_highlight', L.GUI.GROUPFRAME.GROUP_DEBUFF_HIGHLIGHT, nil, nil, nil, L.GUI.GROUPFRAME.GROUP_DEBUFF_HIGHLIGHT_TIP},
		{1, 'unitframe', 'group_corner_buffs', L.GUI.GROUPFRAME.GROUP_CORNER_BUFFS, true},
		{},
		{1, 'unitframe', 'party_horizon', L.GUI.GROUPFRAME.PARTY_HORIZON},
		{1, 'unitframe', 'party_reverse', L.GUI.GROUPFRAME.PARTY_REVERSE, true},
		{1, 'unitframe', 'party_spell_watcher', L.GUI.GROUPFRAME.PARTY_SPELL_WATCHER, nil, SetupPartySpellCooldown},
		{1, 'unitframe', 'party_spell_sync', L.GUI.GROUPFRAME.PARTY_SPELL_SYNC, true, nil, nil, L.GUI.GROUPFRAME.PARTY_SPELL_SYNC_TIP},
		{},
		{1, 'unitframe', 'raid_horizon', L.GUI.GROUPFRAME.RAID_HORIZON},
		{1, 'unitframe', 'raid_reverse', L.GUI.GROUPFRAME.RAID_REVERSE, true},
		{},
		{4, 'unitframe', 'group_color_style', L.GUI.UNITFRAME.COLOR_STYLE, nil, {L.GUI.UNITFRAME.COLOR_STYLE_DEFAULT, L.GUI.UNITFRAME.COLOR_STYLE_CLASS, L.GUI.UNITFRAME.COLOR_STYLE_GRADIENT}},
		{3, 'unitframe', 'group_filter', L.GUI.GROUPFRAME.GROUP_FILTER, true, {1, 8, 1}}
	},
	[14] = {
		-- nameplate
		{1, 'nameplate', 'enable', L.GUI.NAMEPLATE.ENABLE},
		{1, 'nameplate', 'target_indicator', L.GUI.NAMEPLATE.TARGET_INDICATOR, nil, nil, nil, L.GUI.NAMEPLATE.TARGET_INDICATOR_TIP},
		{1, 'nameplate', 'threat_indicator', L.GUI.NAMEPLATE.THREAT_INDICATOR, true, nil, nil, L.GUI.NAMEPLATE.THREAT_INDICATOR_TIP},
		{1, 'nameplate', 'classify_indicator', L.GUI.NAMEPLATE.CLASSIFY_INDICATOR, nil, nil, nil, L.GUI.NAMEPLATE.CLASSIFY_INDICATOR_TIP},
		{1, 'nameplate', 'interrupt_name', L.GUI.NAMEPLATE.INTERRUPT_NAME, true, nil, nil, L.GUI.NAMEPLATE.INTERRUPT_NAME_TIP},
		{1, 'nameplate', 'explosive_scale', L.GUI.NAMEPLATE.EXPLOSIVE_SCALE, nil, nil, nil, L.GUI.NAMEPLATE.EXPLOSIVE_SCALE_TIP},
		{1, 'nameplate', 'plate_auras', L.GUI.NAMEPLATE.PLATE_AURAS, true, NamePlateAuraFilter, nil, L.GUI.NAMEPLATE.PLATE_AURAS_TIP},
		{},
		{1, 'nameplate', 'friendly_class_color', L.GUI.NAMEPLATE.FRIENDLY_CLASS_COLOR, nil, nil, nil, L.GUI.NAMEPLATE.FRIENDLY_CLASS_COLOR_TIP},
		{1, 'nameplate', 'hostile_class_color', L.GUI.NAMEPLATE.HOSTILE_CLASS_COLOR, true, nil, nil, L.GUI.NAMEPLATE.HOSTILE_CLASS_COLOR_TIP},
		{1, 'nameplate', 'tank_mode', L.GUI.NAMEPLATE.TANK_MODE, nil, nil, nil, L.GUI.NAMEPLATE.TANK_MODE_TIP},
		{1, 'nameplate', 'dps_revert_threat', L.GUI.NAMEPLATE.DPS_REVERT_THREAT, true, nil, nil, L.GUI.NAMEPLATE.DPS_REVERT_THREAT_TIP},
		{5, 'nameplate', 'secure_color', L.GUI.NAMEPLATE.SECURE_COLOR},
		{5, 'nameplate', 'trans_color', L.GUI.NAMEPLATE.TRANS_COLOR, 1},
		{5, 'nameplate', 'insecure_color', L.GUI.NAMEPLATE.INSECURE_COLOR, 2},
		{5, 'nameplate', 'off_tank_color', L.GUI.NAMEPLATE.OFF_TANK_COLOR, 3},
		{},
		{1, 'nameplate', 'custom_unit_color', L.GUI.NAMEPLATE.CUSTOM_UNIT_COLOR, nil, nil, UpdateCustomUnitList, L.GUI.NAMEPLATE.CUSTOM_UNIT_COLOR_TIP},
		{5, 'nameplate', 'custom_color', L.GUI.NAMEPLATE.CUSTOM_COLOR},
		{2, 'nameplate', 'custom_unit_list', L.GUI.NAMEPLATE.CUSTOM_UNIT_LIST, true, nil, UpdateCustomUnitList, L.GUI.NAMEPLATE.CUSTOM_UNIT_LIST_TIP},
		{},
		{3, 'nameplate', 'plate_width', L.GUI.NAMEPLATE.PLATE_WIDTH, nil, {50, 200, 1}, RefreshNameplates},
		{3, 'nameplate', 'plate_height', L.GUI.NAMEPLATE.PLATE_HEIGHT, true, {5, 30, 1}, RefreshNameplates},
		{3, 'nameplate', 'aura_size', L.GUI.NAMEPLATE.AURA_SIZE, nil, {20, 40, 1}, RefreshNameplates},
		{3, 'nameplate', 'aura_number', L.GUI.NAMEPLATE.AURA_NUMBER, true, {3, 12, 1}, RefreshNameplates},
		{3, 'nameplate', 'min_scale', L.GUI.NAMEPLATE.MIN_SCALE, nil, {.5, 1, .1}, UpdatePlateScale},
		{3, 'nameplate', 'target_scale', L.GUI.NAMEPLATE.TARGET_SCALE, true, {.5, 2, .1}, UpdatePlateScale},
		{3, 'nameplate', 'min_alpha', L.GUI.NAMEPLATE.MIN_ALPHA, nil, {.2, 1, .1}, UpdatePlateAlpha},
		{3, 'nameplate', 'occluded_alpha', L.GUI.NAMEPLATE.OCCLUDED_ALPHA, true, {.2, 1, .1}, UpdatePlateAlpha},
		{3, 'nameplate', 'vertical_spacing', L.GUI.NAMEPLATE.VERTICAL_SPACING, nil, {.5, 2, .1}, UpdatePlateSpacing},
		{3, 'nameplate', 'horizontal_spacing', L.GUI.NAMEPLATE.HORIZONTAL_SPACING, true, {.5, 2, .1}, UpdatePlateSpacing}
	},
	[15] = {
		-- misc
		{1, 'ACCOUNT', 'custom_class_color', L.GUI.MISC.CUSTOM_CLASS_COLOR, nil, SetupCustomClassColor},
		{},
		{4, 'ACCOUNT', 'texture_style', L.GUI.MISC.TEXTURE_STYLE, false, {}},
		{4, 'ACCOUNT', 'number_format', L.GUI.MISC.NUMBER_FORMAT, true, {L.GUI.MISC.NUMBER_TYPE1, L.GUI.MISC.NUMBER_TYPE2, L.GUI.MISC.NUMBER_TYPE3}}
	},
	[16] = {},
	[17] = {}
}
