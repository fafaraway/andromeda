local F, C, L = unpack(select(2, ...))
local GUI = F.Modules.GUI
local UNITFRAME = F:GetModule('Unitframe')
local NAMEPLATE = F:GetModule('Nameplate')


-- Inventory
function GUI:UpdateInventoryStatus()
    F.INVENTORY:UpdateAllBags()
end

local function SetupInventoryFilter()
    GUI:SetupInventoryFilter(GUI.Page[9])
end

-- Actionbar
local function SetupActionbarFade()
    GUI:SetupActionbarFade(GUI.Page[6])
end

local function SetupAdditionalbar()
    GUI:SetupAdditionalbar(GUI.Page[6])
end

local function UpdateHotkeys()
    local Bar = F.ACTIONBAR
    for _, button in pairs(Bar.buttons) do
        if button.UpdateHotkeys then
            button:UpdateHotkeys(button.buttonType)
        end
    end
end

-- Chat
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

local function UpdateMinimapScale()
    F.MAP:UpdateMinimapScale()
end

-- Nameplate

local function SetupNameplateCVars()
    GUI:SetupNameplateCVars(GUI.Page[14])
end

local function setupNamePlate()
    GUI:SetupNamePlate(GUI.Page[14])
end

local function setupAuraFilter()
    GUI:SetupNPAuraFilter(GUI.Page[14])
end

local function setupMajorSpellsGlow()
    GUI:SetupMajorSpellsGlow(GUI.Page[14])
end

local function setupNPExecuteRatio()
    GUI:SetupNPExecuteRatio(GUI.Page[14])
end

local function setupNPExplosiveScale()
    GUI:SetupNPExplosiveScale(GUI.Page[14])
end

local function setupNPRaidTargetIndicator()
    GUI:SetupNPRaidTargetIndicator(GUI.Page[14])
end

local function UpdateCustomUnitList()
    NAMEPLATE:CreateUnitTable()
end

-- Unitframe
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

local function UpdateRaidDebuffSize()
    UNITFRAME:UpdateRaidDebuffSize()
end

local function UpdateRaidAuras()
    UNITFRAME:UpdateRaidAuras()
end

local function SetupPartyWatcher()
    GUI:SetupPartyWatcher(GUI.Page[13])
end

local function SetupRaidDebuffs()
    GUI:SetupRaidDebuffs(GUI.Page[13])
end

local function UpdateAllHeaders()
    UNITFRAME:UpdateAllHeaders()
end



-- General
local function SetupAutoTakeScreenshot()
    GUI:SetupAutoTakeScreenshot(GUI.Page[1])
end

local function SetupCustomClassColor()
    GUI:SetupCustomClassColor(GUI.Page[1])
end

-- Theme
local function UpdateBackdropAlpha()
    for _, frame in pairs(C.Frames) do
        frame:SetBackdropColor(0, 0, 0, _G.FREE_ADB.BackdropAlpha)
    end
end


-- Options
GUI.OptionsList = {
    [1] = {
        {1, 'General', 'CursorTrail', L['Cursor trail'], nil, nil, nil, L.GUI.GENERAL.CURSOR_TRAIL_TIP},
        {1, 'General', 'Vignette', L['Vignette'], nil, nil, nil, L.GUI.GENERAL.VIGNETTING_TIP},

        {3, 'General', 'VignetteAlpha', L.GUI.GENERAL.VIGNETTING_ALPHA, true, {0, 1, .1}},




        {1, 'ACCOUNT', 'UseCustomClassColor', L.GUI.GENERAL.USE_CUSTOM_CLASS_COLOR, nil, SetupCustomClassColor, nil, L.GUI.GENERAL.USE_CUSTOM_CLASS_COLOR_TIP},
        {1, 'ACCOUNT', 'FontOutline', L.GUI.GENERAL.FONT_OUTLINE, nil, nil, nil, L.GUI.GENERAL.FONT_OUTLINE_TIP},

        {3, 'ACCOUNT', 'UIScale', L.GUI.GENERAL.UI_SCALE, true, {.5, 2, .01}, nil, L.GUI.GENERAL.UI_SCALE_TIP},

        {1, 'General', 'HideTalkingHead', L.GUI.GENERAL.HIDE_TALKINGHEAD},
        {1, 'General', 'HideBossBanner', L.GUI.GENERAL.HIDE_BOSS_BANNER, nil},



        {1, 'General', 'HideBossEmote', L.GUI.GENERAL.HIDE_BOSS_EMOTE},
        {1, 'General', 'SimplifyErrors', L.GUI.GENERAL.SIMPLIFY_ERRORS, nil, nil, nil, L.GUI.GENERAL.SIMPLIFY_ERRORS_TIP},



        {1, 'General', 'FasterLoot', L.GUI.GENERAL.FASTER_LOOT},
        {1, 'General', 'FasterMovieSkip', L.GUI.GENERAL.FASTER_MOVIE_SKIP, true, nil, nil, L.GUI.GENERAL.FASTER_MOVIE_SKIP_TIP},
        {1, 'General', 'SmoothZooming', L.GUI.GENERAL.SMOOTH_ZOOMING, nil, nil, nil, L.GUI.GENERAL.SMOOTH_ZOOMING_TIP},
        {1, 'General', 'ActionMode', L.GUI.GENERAL.ACTION_MODE, true, nil, nil, L.GUI.GENERAL.ACTION_MODE_TIP},

        {1, 'General', 'ScreenSaver', L.GUI.GENERAL.SCREEN_SAVER},
        {1, 'General', 'AutoTakeScreenshot', L.GUI.GENERAL.AUTO_TAKE_SCREENSHOT, true, SetupAutoTakeScreenshot},

        {4, 'ACCOUNT', 'NumberFormat', L.GUI.GENERAL.NUMBER_FORMAT, nil, {L.GUI.GENERAL.NUMBER_TYPE1, L.GUI.GENERAL.NUMBER_TYPE2, L.GUI.GENERAL.NUMBER_TYPE3}},
        {4, 'ACCOUNT', 'TextureStyle', L.GUI.GENERAL.TEXTURE_STYLE, true, {}},




    },
    [2] = {
        {1, 'Notification', 'Enable', L.GUI.NOTIFICATION.ENABLE},
        {1, 'Notification', 'BagFull', L.GUI.NOTIFICATION.BAG_FULL},
        {1, 'Notification', 'NewMail', L.GUI.NOTIFICATION.NEW_MAIL, true},
        {1, 'Notification', 'RareFound', L.GUI.NOTIFICATION.RARE_FOUND},
        {1, 'Notification', 'LowDurability', L.GUI.NOTIFICATION.LOW_DURABILITY, true},
        {1, 'Notification', 'Paragon', L.GUI.NOTIFICATION.PARAGON},
        {1, 'ACCOUNT', 'VersionCheck', L.GUI.NOTIFICATION.VERSION_CHECK, true},
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
        {1, 'infobar', 'report', L.GUI.INFOBAR.REPORT, true},
        {1, 'infobar', 'currency', L.GUI.INFOBAR.CURRENCY},
    },
    [4] = {
        -- chat
        {1, 'chat', 'enable', L.GUI.CHAT.ENABLE},
        {1, 'chat', 'lock_position', L.GUI.CHAT.LOCK_POSITION, nil, nil, nil, L.GUI.CHAT.LOCK_POSITION_TIP},
        {1, 'chat', 'channel_bar', L.GUI.CHAT.CHANNEL_BAR, true},
        {1, 'chat', 'fade_out', L.GUI.CHAT.FADE_OUT, nil, nil, nil, L.GUI.CHAT.FADE_OUT_TIP},
        {1, 'chat', 'abbr_channel_names', L.GUI.CHAT.ABBR_CHANNEL_NAMES, true},
        {1, 'chat', 'voice_button', L.GUI.CHAT.VOICE_BUTTON},
        {1, 'chat', 'tab_cycle', L.GUI.CHAT.TAB_CYCLE, true, nil, nil, L.GUI.CHAT.TAB_CYCLE_TIP},
        {1, 'chat', 'smart_bubble', L.GUI.CHAT.SMART_BUBBLE, nil, nil, nil, L.GUI.CHAT.SMART_BUBBLE_TIP},
        {1, 'chat', 'whisper_sticky', L.GUI.CHAT.WHISPER_STICKY, true, nil, UpdateWhisperSticky},
        {1, 'chat', 'whisper_sound', L.GUI.CHAT.WHISPER_SOUND},
        {1, 'chat', 'item_links', L.GUI.CHAT.ITEM_LINKS, true},
        {},
        {1, 'chat', 'use_filter', L.GUI.CHAT.USE_FILTER},
        {1, 'chat', 'block_addon_spam', L.GUI.CHAT.BLOCK_ADDON_SPAM},
        {2, 'ACCOUNT', 'ChatFilterWhiteList', L.GUI.CHAT.WHITE_LIST, true, nil, UpdateFilterWhiteList, L.GUI.CHAT.WHITE_LIST_TIP},
        {1, 'chat', 'allow_friends_spam', L.GUI.CHAT.ALLOW_FRIENDS_SPAM, nil, nil, nil, L.GUI.CHAT.ALLOW_FRIENDS_SPAM_TIP},
        {1, 'chat', 'block_stranger_whisper', L.GUI.CHAT.BLOCK_STRANGER_WHISPER},
        {2, 'ACCOUNT', 'ChatFilterBlackList', L.GUI.CHAT.BLACK_LIST, true, nil, UpdateFilterList, L.GUI.CHAT.BLACK_LIST_TIP},
        {1, 'chat', 'damage_meter_filter', L.GUI.CHAT.DAMAGE_METER_FILTER},

        {1, 'chat', 'group_loot_filter', L.GUI.CHAT.GROUP_LOOT_FILTER},
        {
            4,
            'chat',
            'group_loot_threshold',
            L.GUI.CHAT.GROUP_LOOT_THRESHOLD,
            true,
            {L.GUI.CHAT.GROUP_LOOT_COMMON, L.GUI.CHAT.GROUP_LOOT_UNCOMMON, L.GUI.CHAT.GROUP_LOOT_RARE, L.GUI.CHAT.GROUP_LOOT_EPIC, L.GUI.CHAT.GROUP_LOOT_LEGENDARY, L.GUI.CHAT.GROUP_LOOT_ARTIFACT, L.GUI.CHAT.GROUP_LOOT_HEIRLOOM, L.GUI.CHAT.GROUP_LOOT_ALL},
        },
        {3, 'chat', 'matche_number', L.GUI.CHAT.MATCHE_NUMBER, nil, {1, 3, 1}},
        {},
        {1, 'chat', 'whisper_invite', L.GUI.CHAT.WHISPER_INVITE},
        {1, 'chat', 'guild_only', L.GUI.CHAT.GUILD_ONLY},
        {2, 'chat', 'invite_keyword', L.GUI.CHAT.INVITE_KEYWORD, true, nil, UpdateWhisperList},
    },
    [5] = {
        -- aura
        {1, 'aura', 'enable', L.GUI.AURA.ENABLE, nil, nil, nil, L.GUI.AURA.ENABLE_TIP},
        {1, 'aura', 'reverse_buffs', L.GUI.AURA.REVERSE_BUFFS},
        {1, 'aura', 'reverse_debuffs', L.GUI.AURA.REVERSE_DEBUFFS, true},
        {1, 'aura', 'reminder', L.GUI.AURA.REMINDER, nil, nil, nil, L.GUI.AURA.REMINDER_TIP},
        {},
        {3, 'aura', 'margin', L.GUI.AURA.MARGIN, nil, {3, 10, 1}},
        {3, 'aura', 'offset', L.GUI.AURA.OFFSET, true, {3, 10, 1}},
        {3, 'aura', 'buff_size', L.GUI.AURA.BUFF_SIZE, nil, {20, 50, 1}},
        {3, 'aura', 'debuff_size', L.GUI.AURA.DEBUFF_SIZE, true, {20, 50, 1}},
        {3, 'aura', 'buffs_per_row', L.GUI.AURA.BUFFS_PER_ROW, nil, {6, 12, 1}},
        {3, 'aura', 'debuffs_per_row', L.GUI.AURA.DEBUFFS_PER_ROW, true, {6, 12, 1}},
    },
    [6] = {
        {1, 'Actionbar', 'Enable', L.GUI.ACTIONBAR.ENABLE},
        {1, 'Actionbar', 'Hotkey', L.GUI.ACTIONBAR.HOTKEY, nil, nil, UpdateHotkeys},
        {4, 'Actionbar', 'Layout', L.GUI.ACTIONBAR.LAYOUT, true, {L.GUI.ACTIONBAR.LAYOUT_1, L.GUI.ACTIONBAR.LAYOUT_2, L.GUI.ACTIONBAR.LAYOUT_3, L.GUI.ACTIONBAR.LAYOUT_4}},
        {1, 'Actionbar', 'MacroName', L.GUI.ACTIONBAR.MACRO_NAME},
        {1, 'Actionbar', 'CountNumber', L.GUI.ACTIONBAR.COUNT_NUMBER},
        {3, 'Actionbar', 'Scale', L.GUI.ACTIONBAR.SCALE, true, {.5, 2, .1}},
        {1, 'Actionbar', 'ClassColor', L.GUI.ACTIONBAR.CLASS_COLOR},
        {1, 'Actionbar', 'DynamicFade', L.GUI.ACTIONBAR.DYNAMIC_FADE, nil, SetupActionbarFade, nil, L.GUI.ACTIONBAR.DYNAMIC_FADE_TIP},
        {},
        {1, 'Actionbar', 'Bar4', L.GUI.ACTIONBAR.BAR4},
        {1, 'Actionbar', 'Bar5', L.GUI.ACTIONBAR.BAR5, true},
        {1, 'Actionbar', 'PetBar', L.GUI.ACTIONBAR.PET_BAR},
        {1, 'Actionbar', 'StanceBar', L.GUI.ACTIONBAR.STANCE_BAR, true},
        {1, 'Actionbar', 'VehicleBar', L.GUI.ACTIONBAR.LEAVE_VEHICLE_BAR},
        {1, 'Actionbar', 'CustomBar', L.GUI.ACTIONBAR.CUSTOM_BAR, true, SetupAdditionalbar, nil, L.GUI.ACTIONBAR.CUSTOM_BAR_TIP},
        {},
        {1, 'Actionbar', 'CooldownCount', L.GUI.ACTIONBAR.COOLDOWN_COUNT},
        {1, 'Actionbar', 'DecimalCD', L.GUI.ACTIONBAR.DECIMAL_CD},
        {1, 'Actionbar', 'OverrideWA', L.GUI.ACTIONBAR.OVERRIDE_WA, true},
        {1, 'Actionbar', 'CDNotify', L.GUI.ACTIONBAR.CD_NOTIFY, nil, nil, nil, L.GUI.ACTIONBAR.CD_NOTIFY_TIP},
        {1, 'Actionbar', 'CDFlash', L.GUI.ACTIONBAR.CD_FLASH, true, nil, nil, L.GUI.ACTIONBAR.CD_FLASH_TIP},
        {1, 'Actionbar', 'DesaturatedIcon', L.GUI.ACTIONBAR.DESATURATED_ICON, nil, nil, nil, L.GUI.ACTIONBAR.DESATURATED_ICON_TIP},
    },
    [7] = {
        -- combat
        {1, 'combat', 'enable', L.GUI.COMBAT.ENABLE},
        {1, 'combat', 'combat_alert', L.GUI.COMBAT.COMBAT_ALERT, nil, nil, nil, L.GUI.COMBAT.COMBAT_ALERT_TIP},
        {1, 'combat', 'spell_sound', L.GUI.COMBAT.SPELL_SOUND, true, nil, nil, L.GUI.COMBAT.SPELL_SOUND_TIP},

        {1, 'combat', 'EasyFocusOnUnitframe', L.GUI.COMBAT.EASY_FOCUS_ON_UNITFRAME, nil, nil, nil, L.GUI.COMBAT.EASY_FOCUS_ON_UNITFRAME_TIP},

        {4, 'combat', 'EasyFocusKey', L.GUI.COMBAT.EASY_FOCUS, nil, {'CTRL', 'ALT', 'SHIFT', DISABLE}, nil, L.GUI.COMBAT.EASY_FOCUS_TIP},

        {4, 'combat', 'EasyMarkKey', L.GUI.COMBAT.EASY_MARK, true, {'CTRL', 'ALT', 'SHIFT', DISABLE}, nil, L.GUI.COMBAT.EASY_MARK_TIP},

        {1, 'combat', 'easy_tab', L.GUI.COMBAT.EASY_TAB, nil, nil, nil, L.GUI.COMBAT.EASY_TAB_TIP},
        {1, 'combat', 'pvp_sound', L.GUI.COMBAT.PVP_SOUND, nil, nil, nil, L.GUI.COMBAT.PVP_SOUND_TIP},
        {},
        {1, 'combat', 'fct', L.GUI.COMBAT.FCT, nil, nil, nil, L.GUI.COMBAT.FCT_TIP},
        {1, 'combat', 'fct_in', L.GUI.COMBAT.FCT_IN},
        {1, 'combat', 'fct_out', L.GUI.COMBAT.FCT_OUT, true},
        {1, 'combat', 'fct_pet', L.GUI.COMBAT.FCT_PET},
        {1, 'combat', 'fct_periodic', L.GUI.COMBAT.FCT_PERIODIC, true},
        {1, 'combat', 'fct_merge', L.GUI.COMBAT.FCT_MERGE},
    },
    [8] = {
        -- announcement
        {1, 'Announcement', 'Enable', L.GUI.ANNOUNCEMENT.ENABLE, nil, nil, nil, L.GUI.ANNOUNCEMENT.ENABLE_TIP},
        {1, 'Announcement', 'Interrupt', L.GUI.ANNOUNCEMENT.INTERRUPT, nil, nil, nil, L.GUI.ANNOUNCEMENT.INTERRUPT_TIP},
        {1, 'Announcement', 'Dispel', L.GUI.ANNOUNCEMENT.DISPEL, true, nil, nil, L.GUI.ANNOUNCEMENT.DISPEL_TIP},
        {1, 'Announcement', 'BattleRez', L.GUI.ANNOUNCEMENT.BATTLEREZ, nil, nil, nil, L.GUI.ANNOUNCEMENT.BATTLEREZ_TIP},
        {1, 'Announcement', 'Utility', L.GUI.ANNOUNCEMENT.UTILITY, true, nil, nil, L.GUI.ANNOUNCEMENT.UTILITY_TIP},
        {1, 'Announcement', 'Reset', L.GUI.ANNOUNCEMENT.RESET, nil, nil, nil, L.GUI.ANNOUNCEMENT.RESET_TIP},
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
        {4, 'inventory', 'sort_mode', L.GUI.INVENTORY.SORT_MODE, nil, {L.GUI.INVENTORY.SORT_TO_TOP, L.GUI.INVENTORY.SORT_TO_BOTTOM, DISABLE}, nil, L.GUI.INVENTORY.SORT_TIP},
    },
    [10] = {
        -- map
        {1, 'map', 'enable', L.GUI.MAP.ENABLE, nil, nil, nil, L.GUI.MAP.ENABLE_TIP},
        {1, 'map', 'remove_fog', L.GUI.MAP.REMOVE_FOG},
        {1, 'map', 'coords', L.GUI.MAP.COORDS, true},
        {1, 'map', 'who_pings', L.GUI.MAP.WHO_PINGS},
        {1, 'map', 'progress_bar', L.GUI.MAP.PROGRESS_BAR, true, nil, nil, L.GUI.MAP.PROGRESS_BAR_TIP},
        {},
        {3, 'map', 'worldmap_scale', L.GUI.MAP.WORLDMAP_SCALE, nil, {.5, 2, .1}},
        {3, 'map', 'max_worldmap_scale', L.GUI.MAP.MAX_WORLDMAP_SCALE, true, {.5, 1, .1}},
        {3, 'map', 'minimap_scale', L.GUI.MAP.MINIMAP_SCALE, nil, {.5, 1, .1}, UpdateMinimapScale},
    },
    [11] = {
        -- tooltip
        {1, 'tooltip', 'enable', L.GUI.TOOLTIP.ENABLE, nil, nil, nil, L.GUI.TOOLTIP.ENABLE_TIP},
        {1, 'tooltip', 'follow_cursor', L.GUI.TOOLTIP.FOLLOW_CURSOR, nil, nil, nil, L.GUI.TOOLTIP.FOLLOW_CURSOR_TIP},
        {1, 'tooltip', 'hide_in_combat', L.GUI.TOOLTIP.HIDE_IN_COMBAT, true},
        {1, 'tooltip', 'disable_fading', L.GUI.TOOLTIP.DISABLE_FADING},
        {1, 'tooltip', 'tip_icon', L.GUI.TOOLTIP.TIP_ICON, true},
        {1, 'tooltip', 'target_by', L.GUI.TOOLTIP.TARGET_BY},
        {1, 'tooltip', 'extra_info', L.GUI.TOOLTIP.EXTRA_INFO, true, nil, nil, L.GUI.TOOLTIP.EXTRA_INFO_TIP},
        {1, 'tooltip', 'azerite_armor', L.GUI.TOOLTIP.AZERITE_ARMOR},
        {1, 'tooltip', 'conduit_info', L.GUI.TOOLTIP.CONDUIT_INFO, true},
        {1, 'tooltip', 'spec_ilvl', L.GUI.TOOLTIP.SPEC_ILVL, nil, nil, nil, L.GUI.TOOLTIP.SPEC_ILVL_TIP},
        {1, 'tooltip', 'hide_realm', L.GUI.TOOLTIP.HIDE_REALM, true},
        {1, 'tooltip', 'hide_title', L.GUI.TOOLTIP.HIDE_TITLE},
        {1, 'tooltip', 'hide_rank', L.GUI.TOOLTIP.HIDE_RANK, true},
        {1, 'tooltip', 'border_color', L.GUI.TOOLTIP.BORDER_COLOR},
        {1, 'tooltip', 'health_value', L.GUI.TOOLTIP.HEALTH_VALUE, true},
    },
    [12] = { -- unitframe
        {1, 'Unitframe', 'Enable', L['Enable unitframes'], nil, SetupUnitFrameSize},
        {1, 'Unitframe', 'Transparent', L['Transparent mode']},
        {4, 'Unitframe', 'ColorStyle', L['Health bar style'], true, {L['Default white'], L['Class colored'], L['Percentage gradient']}},
        {1, 'Unitframe', 'Portrait', L['Portrait']},
        {1, 'Unitframe', 'RangeCheck', L['Range check']},
        {3, 'Unitframe', 'RangeCheckAlpha', L['Ouf of range alpha'], true, {.2, 1, .1}},
        {1, 'Unitframe', 'AbbreviatedName', L['Abbreviated name']},
        {1, 'Unitframe', 'Fader', L['Conditional fader'], nil, SetupUnitFrameFader},
        {1, 'Unitframe', 'OnlyShowPlayer', L['Shows only debuffs created by player'], true},
        {1, 'Unitframe', 'CombatIndicator', L['Combat indicator']},
        {1, 'Unitframe', 'RestingIndicator', L['Resting indicator'], true},
        {1, 'Unitframe', 'RaidTargetIndicator', L['Raid target indicator']},
        {1, 'Unitframe', 'GCDIndicator', L['GCD indicator'], true},
        {1, 'Unitframe', 'ClassPowerBar', L['Class power bar']},

        {1, 'Unitframe', 'TotemsBar', L['Shaman totems bar']},
        {3, 'Unitframe', 'ClassPowerBarHeight', L['Class Power Bar Height'], true, {1, 10, 1}},
        {1, 'Unitframe', 'RunesTimer', L['DK runes timer']},
        {1, 'Unitframe', 'StaggerBar', L['Monk stagger bar']},
        {},
        {1, 'Unitframe', 'Castbar', L['Enable castbar'], nil, SetupCastbar},
        {1, 'Unitframe', 'CompactCastbar', L['Compact style'], true},
        {1, 'Unitframe', 'SpellName', L['Spell name']},
        {1, 'Unitframe', 'SpellTime', L['Spell timer'], true},
        {5, 'Unitframe', 'CastingColor', L['Normal']},
        {5, 'Unitframe', 'CompleteColor', L['Complete'], 1},
        {5, 'Unitframe', 'FailColor', L['Fail'], 2},
        {5, 'Unitframe', 'UninterruptibleColor', L['Uninterruptible'], 3},
        {},
        {1, 'Unitframe', 'Boss', L['Enable boss frames']},
        {1, 'Unitframe', 'Arena', L['Enable arena frames'], true},
    },
    [13] = { -- groupframe
        {1, 'Unitframe', 'Group', L['Enable group frames'], nil, SetupGroupFrameSize},
        {1, 'Unitframe', 'SmartRaid', L['Smart layout'], nil, nil, UpdateAllHeaders, L['|nOnly show raid frames if there are more than 5 members in your group.|nIf disabled, show raid frames when in raid, show party frames when in party.']},
        {1, 'Unitframe', 'GroupShowName', L['Show names']},
        {4, 'Unitframe', 'GroupColorStyle', L['Health bar style'], true, {L['Default white'], L['Class colored'], L['Percentage gradient']}},
        {1, 'Unitframe', 'ClickToCast', L['Enable click to cast'], nil, nil, nil, L['|nOpen your spell book to configure click to cast.']},
        {1, 'Unitframe', 'PositionBySpec', L['Save postion by spec']},
        {3, 'Unitframe', 'GroupFilter', L['Group filter'], true, {1, 8, 1}},
        {1, 'Unitframe', 'DebuffHighlight', L['Dispellable debuff highlight']},
        {1, 'Unitframe', 'InstanceAuras', L['Show raid debuffs'], nil, SetupRaidDebuffs, nil, L['|nShow custom major debuffs in raid and dungeons.']},
        {1, 'Unitframe', 'DispellableOnly', L['Show dispellable debuffs only'], true},
        {1, 'Unitframe', 'ShowRaidDebuff', L['Show debuffs'] , nil, nil, UpdateRaidAuras, L['|nShow debuffs on group frame by blizzard default logic, up to 3 icons.']},
        {1, 'Unitframe', 'ShowRaidBuff', L['Show buffs'], true, nil, UpdateRaidAuras, L['|nShow buffs on group frame by blizzard default logic, up to 3 icons.|nBetter not to use this with Corner Indicator.']},
        {1, 'Unitframe', 'AurasClickThrough', L['Disable auras tooltip']},
        {1, 'Unitframe', 'CornerIndicator', L['Enable corner indicator']},
        {1, 'Unitframe', 'ThreatIndicator', L['Threat indicator'], true},
        {1, 'Unitframe', 'PartyWatcher', L['Enable party watcher'], nil, SetupPartyWatcher},
        {1, 'Unitframe', 'PartyWatcherSync', L['Sync party watcher'], true, nil, nil, L['|nIf enabled, the cooldown status would sync with players who using party watcher or ZenTracker(WA).|nThis might decrease your performance.']},
        {1, 'Unitframe', 'PartyHorizon', L['Horizontal party frames']},
        {1, 'Unitframe', 'PartyReverse', L['Party frames reverse grow'], true},
        {1, 'Unitframe', 'RaidHorizon', L['Horizontal raid frames']},
        {1, 'Unitframe', 'RaidReverse', L['Raid frames reverse grow'], true},
    },
    [14] = { -- nameplate
        {1, 'Nameplate', 'Enable', L['Enable nameplate'], nil, setupNamePlate},
        {1, 'Nameplate', 'NameOnly', L['Name only style'], nil, nil, nil, L.GUI.NAMEPLATE.NAME_ONLY_TIP},
        {4, 'Nameplate', 'AuraFilterMode', L['Aura filter mode'], true, {L['BlackNWhite'], L['PlayerOnly'], L['IncludeCrowdControl']}, nil, L.GUI.NAMEPLATE.AURA_FILTER_MODE_TIP},
        {1, 'Nameplate', 'ControlCVars', L['Control CVars'], nil, SetupNameplateCVars},
        {1, 'Nameplate', 'TargetIndicator', L['Target indicator'], nil, nil, nil, L.GUI.NAMEPLATE.TARGET_INDICATOR_TIP},

        {1, 'Nameplate', 'QuestIndicator', L['Quest indicator'], nil, nil, nil, L.GUI.NAMEPLATE.QUEST_INDICATOR_TIP},

        {3, 'Nameplate', 'ExecuteRatio', L['Excute ratio'], true, {1, 90, 1}},

        {1, 'Nameplate', 'ClassifyIndicator', L['Classify indicator'], nil, nil, nil, L.GUI.NAMEPLATE.CLASSIFY_INDICATOR_TIP},

        {1, 'Nameplate', 'RaidTargetIndicator', L['Raid target indicator'], nil, setupNPRaidTargetIndicator},
        {1, 'Nameplate', 'ThreatIndicator', L['Threat indicator'], true, nil, nil, L.GUI.NAMEPLATE.THREAT_INDICATOR_TIP},
        {1, 'Nameplate', 'TotemIcon', L['Totmes icon'], nil, nil, nil, L.GUI.NAMEPLATE.TOTEM_ICON_TIP},


        {1, 'Nameplate', 'ExplosiveIndicator', L['Explosive indicator'], nil, setupNPExplosiveScale, nil, L.GUI.NAMEPLATE.EXPLOSIVE_INDICATOR_TIP},
        {1, 'Nameplate', 'SpitefulIndicator', L['Spiteful indicator'], true, nil, nil, L.GUI.NAMEPLATE.SPITEFUL_INDICATOR_TIP},
        {},
        {1, 'Nameplate', 'CastbarCompact', L['Compact style']},
        {1, 'Nameplate', 'MajorSpellsGlow', L['Major spell glow'], true, setupMajorSpellsGlow, nil, L.GUI.NAMEPLATE.MAJOR_SPELLS_GLOW_TIP},
        {1, 'Nameplate', 'CastbarSpellName', L['Spell name']},
        {1, 'Nameplate', 'CastbarSpellTime', L['Spell timer'], true},
        {1, 'Nameplate', 'SpellTarget', L['Spell target'], nil, nil, nil, L.GUI.NAMEPLATE.SPELL_TARGET_TIP},
        {},
        {1, 'Nameplate', 'FriendlyClassColor', L['Friendly unit colored by class']},
        {1, 'Nameplate', 'HostileClassColor', L['Hostile unit colored by class'], true},
        {1, 'Nameplate', 'ColoredTarget', L['Target unit colored'], nil, nil, nil, L.GUI.NAMEPLATE.COLORED_TARGET_TIP},
        {5, 'Nameplate', 'TargetColor', L['Target color'], 2},
        {1, 'Nameplate', 'ColoredFocus', L['Focus unit colored'], nil, nil, nil, L.GUI.NAMEPLATE.COLORED_FOCUS_TIP},
        {5, 'Nameplate', 'FocusColor', L['Focus color'], 2},
        {1, 'Nameplate', 'TankMode', L['Tank mode'], nil, nil, nil, L.GUI.NAMEPLATE.TANK_MODE_TIP},
        {1, 'Nameplate', 'RevertThreat', L['Revert threat'], true, nil, nil, L.GUI.NAMEPLATE.REVERT_THREAT_TIP},
        {5, 'Nameplate', 'SecureColor', L['Secure']},
        {5, 'Nameplate', 'TransColor', L['Transition'], 1},
        {5, 'Nameplate', 'InsecureColor', L['Insecure'], 2},
        {5, 'Nameplate', 'OffTankColor', L['Off-Tank'], 3},
        {1, 'Nameplate', 'CustomUnitColor', L['Custom unit colored'], nil, nil, UpdateCustomUnitList, L.GUI.NAMEPLATE.COLORED_CUSTOM_UNIT_TIP},
        {5, 'Nameplate', 'CustomColor', L['Custom color']},
        {2, 'Nameplate', 'CustomUnitList', L['Custom unit list'], true, nil, UpdateCustomUnitList, L.GUI.NAMEPLATE.CUSTOM_UNIT_LIST_TIP},

    },
    [15] = { -- theme
        {1, 'ACCOUNT', 'ShadowOutline', L.GUI.APPEARANCE.SHADOW_OUTLINE, nil, nil, nil, L.GUI.APPEARANCE.SHADOW_OUTLINE_TIP},
        {1, 'ACCOUNT', 'GradientStyle', L.GUI.APPEARANCE.GRADIENT_STYLE, true, nil, nil, L.GUI.APPEARANCE.GRADIENT_STYLE_TIP},
        {1, 'ACCOUNT', 'ReskinBlizz', L.GUI.APPEARANCE.RESKIN_BLIZZ, nil, nil, nil, L.GUI.APPEARANCE.RESKIN_BLIZZ_TIP},
        {5, 'ACCOUNT', 'BackdropColor', L.GUI.APPEARANCE.BACKDROP_COLOR},
        {5, 'ACCOUNT', 'BorderColor', L.GUI.APPEARANCE.BORDER_COLOR, 1},
        {5, 'ACCOUNT', 'ButtonBackdropColor', L.GUI.APPEARANCE.BUTTON_BACKDROP_COLOR, 2},
        {3, 'ACCOUNT', 'BackdropAlpha', L.GUI.APPEARANCE.BACKDROP_ALPHA, nil, {0, 1, .01}, UpdateBackdropAlpha, L.GUI.APPEARANCE.BACKDROP_ALPHA_TIP},
        {3, 'ACCOUNT', 'ButtonBackdropAlhpa', L.GUI.APPEARANCE.BUTTON_BACKDROP_ALHPA, true, {0, 1, .01}, nil, L.GUI.APPEARANCE.BUTTON_BACKDROP_ALHPA_TIP},
        {},
        {1, 'ACCOUNT', 'ReskinDBM', L.GUI.APPEARANCE.RESKIN_DBM, nil, nil, nil, L.GUI.APPEARANCE.RESKIN_DBM_TIP},
        {1, 'ACCOUNT', 'ReskinBigWigs', L.GUI.APPEARANCE.RESKIN_BW, true, nil, nil, L.GUI.APPEARANCE.RESKIN_BW_TIP},
        {1, 'ACCOUNT', 'ReskinWeakAura', L.GUI.APPEARANCE.RESKIN_WA, nil, nil, nil, L.GUI.APPEARANCE.RESKIN_WA_TIP},
        {1, 'ACCOUNT', 'ReskinPremadeGroupsFilter', L.GUI.APPEARANCE.RESKIN_PGF, true, nil, nil, L.GUI.APPEARANCE.RESKIN_PGF_TIP},
        {1, 'ACCOUNT', 'ReskinImmersion', L.GUI.APPEARANCE.RESKIN_IMMERSION, nil, nil, nil, L.GUI.APPEARANCE.RESKIN_IMMERSION_TIP},
        {1, 'ACCOUNT', 'ReskinActionBarProfiles', L.GUI.APPEARANCE.RESKIN_ABP, true, nil, nil, L.GUI.APPEARANCE.RESKIN_ABP_TIP},
        {1, 'ACCOUNT', 'ReskinREHack', L.GUI.APPEARANCE.RESKIN_REHACK, nil, nil, nil, L.GUI.APPEARANCE.RESKIN_REHACK_TIP},
    },
    [16] = {},
    [17] = {},
}
