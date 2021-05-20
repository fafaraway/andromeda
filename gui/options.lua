local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local UNITFRAME = F:GetModule('Unitframe')
local NAMEPLATE = F:GetModule('Nameplate')
local ACTIONBAR = F:GetModule('Actionbar')
local CHAT = F:GetModule('Chat')

-- Auta
local function SetupAuraSize()
    GUI:SetupAuraSize(GUI.Page[5])
end

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
    local Bar = ACTIONBAR
    for _, button in pairs(Bar.buttons) do
        if button.UpdateHotkeys then
            button:UpdateHotkeys(button.buttonType)
        end
    end
end

-- Chat
local function UpdateWhisperSticky()
    CHAT:ChatWhisperSticky()
end

local function UpdateWhisperList()
    CHAT:UpdateWhisperList()
end

local function UpdateFilterList()
    CHAT:UpdateFilterList()
end

local function UpdateFilterWhiteList()
    CHAT:UpdateFilterWhiteList()
end

local function SetupChatSize()
    GUI:SetupChatSize(GUI.Page[4])
end

-- Minimap
local function UpdateMinimapScale()
    F.MAP:UpdateMinimapScale()
end

-- Nameplate
local function SetupNameplateCVars()
    GUI:SetupNameplateCVars(GUI.Page[14])
end

local function SetupNameplateSize()
    GUI:SetupNameplateSize(GUI.Page[14])
end

local function SetupAuraFilter()
    GUI:SetupNPAuraFilter(GUI.Page[14])
end

local function SetupMajorSpells()
    GUI:SetupMajorSpells(GUI.Page[14])
end

local function UpdateCustomUnitList()
    NAMEPLATE:CreateUnitTable()
end

-- Unitframe
local function SetupUnitFrameSize()
    GUI:SetupUnitFrameSize(GUI.Page[12])
end

local function SetupUnitFrameFader()
    GUI:SetupUnitFrameFader(GUI.Page[12])
end

local function SetupCastbar()
    GUI:SetupCastbar(GUI.Page[12])
end

-- Groupframe
local function SetupGroupFrameSize()
    GUI:SetupGroupFrameSize(GUI.Page[13])
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

-- Combat
local function UpdateWorldTextScale()
    SetCVar('WorldTextScale', _G.FREE_ADB.WorldTextScale)
end

local function UpdateBlizzardFloatingCombatText()
    local enable = _G.FREE_ADB.FloatingCombatText
    local oldStyle = _G.FREE_ADB.FloatingCombatTextOldStyle

    SetCVar('floatingCombatTextCombatDamage', enable and 1 or 0) -- 黄色伤害数字
    SetCVar('floatingCombatTextCombatHealing', enable and 1 or 0) -- 绿色治疗数字

    SetCVar('floatingCombatTextCombatDamageDirectionalScale', oldStyle and 0 or 1) -- 0 旧式向上垂直 1-5 新式
    SetCVar('floatingCombatTextFloatMode', oldStyle and 1 or 3) -- 1 向上 2 向下 3 四散
    SetCVar('floatingCombatTextCombatDamageDirectionalOffset', 4)
end

local function SetupSimpleFloatingCombatText()
    GUI:SetupSimpleFloatingCombatText(GUI.Page[7])
end


-- Options
GUI.OptionsList = {
    [1] = { -- general
        {1, 'General', 'CursorTrail', L['Cursor trail']},
        {1, 'General', 'Vignette', L['Vignette'], nil, nil, nil, L['|nAdd shadowed overlay to screen corner.']},
        {3, 'General', 'VignetteAlpha', L['Vignette Alpha'], true, {0, 1, .1}},
        {1, 'ACCOUNT', 'UseCustomClassColor', L['Custom class color'], nil, SetupCustomClassColor},
        {1, 'ACCOUNT', 'FontOutline', L['Font outline'], nil, nil, nil, L['|nAdd font outline globally, enable this if you run game on low resolution.']},
        {3, 'ACCOUNT', 'UIScale', L['UI scale'], true, {.5, 2, .01}, nil, L['|nChange global scale for whole interface.|nRecommend 1080P set to 1, 1440P set to 1.2-1.4, 2160P set to 2.']},
        {1, 'General', 'HideTalkingHead', L['Hide talking head']},
        {1, 'General', 'HideBossBanner', L['Hide boss banner'], nil},
        {1, 'General', 'HideBossEmote', L['Hide boss emote'], true},
        {1, 'General', 'SimplifyErrors', L['Simplify Errors'], nil, nil, nil, L['|nSimplify standard error messages when you in combat. It\'s the red text in the middle of your screen that constantly annoys you with things like, \'Your too far away!\', \'Not enough mana.\', etc.']},
        {1, 'General', 'FasterLoot', L['Faster auto looting'], nil, nil, nil, L['|nLoot instantly. |nNo more waiting for the loot window to be populated.']},
        {1, 'General', 'FasterMovieSkip', L['Faster movie skip'], true, nil, nil, L['|nIf enabled, allow space bar, escape key and enter key to cancel cinematic without confirmation.']},
        {1, 'General', 'SmoothZooming', L['Camera faster zooming'], nil, nil, nil, L['|nFaster and smoother camera zooming.']},
        {1, 'General', 'ActionMode', L['Camera action mode'], true, nil, nil, L['|nEnable blizzard action camera.']},
        {1, 'General', 'ScreenSaver', L['Screen saver']},
        {1, 'General', 'AutoScreenshot', L['Auto screenshot'], true, SetupAutoTakeScreenshot, nil, L['|nTake screenshots automatically based on specific events.']},
        {4, 'ACCOUNT', 'NumberFormat', L['Number Format'], nil, {L['Standard: b/m/k'], L['Asian: y/w'], L['Full digitals']}},
        {4, 'ACCOUNT', 'TextureStyle', L['Texture Style'], true, {}},
    },
    [2] = { -- notification
        {1, 'Notification', 'Enable', L['Enable Notification']},
        {1, 'Notification', 'BagFull', L['Backpack full']},
        {1, 'Notification', 'NewMail', L['New mail'], true},
        {1, 'Notification', 'RareFound', L['Rare found']},
        {1, 'Notification', 'LowDurability', L['Durability low'], true},
        {1, 'Notification', 'ParagonChest', L['Paragon chest']},
        {1, 'ACCOUNT', 'VersionCheck', L['FreeUI outdated'], true},
    },
    [3] = { -- infobar
        {1, 'Infobar', 'Enable', L['Enable Infobar']},
        {1, 'Infobar', 'AnchorTop', L['Anchor to top'], nil, nil, nil, L['|nInfobar will be anchored to the bottom of the screen if the option is disabled.']},
        {1, 'Infobar', 'Mouseover', L['Show blocks by mouseover'], true},
        {1, 'Infobar', 'Stats', L['System stats']},
        {1, 'Infobar', 'Report', L['Daily/weekly infomation'], true},
        {1, 'Infobar', 'Friends', L['Friends']},
        {1, 'Infobar', 'Guild', L['Guild'], true},
        {1, 'Infobar', 'Durability', L['Equipment durability']},
        {1, 'Infobar', 'Currencies', L['Currencies stats'], true},
        {1, 'Infobar', 'Spec', L['Specialization']},
    },
    [4] = { -- chat
        {1, 'Chat', 'Enable', L['Enable Chat']},
        {1, 'Chat', 'LockPosition', L['Lock position and size'], nil, SetupChatSize, nil, L['|nLock postion and size of chat frame.|nDisable this if you want to adjust chat frame.']},
        {1, 'Chat', 'FadeOut', L['Message fading'], true, nil, nil, L['|nThe text will fade out after not receiving a new message for 2 minutes.']},

        {1, 'Chat', 'CopyButton', L['Copy button']},
        {1, 'Chat', 'VoiceButton', L['Voice button'], true},

        {1, 'Chat', 'ShortenChannelName', L['Shorten channel name'], nil, nil, nil, L['|nSimplify channels name.|ne.g. [1: General] to [1] [Guild] to [G]']},
        {1, 'Chat', 'EasyChannelSwitch', L['Easy channel switch'], true, nil, nil, L['|nYou can use TAB key to cycle channels after the input box is activated.']},
        {1, 'Chat', 'ChannelBar', L['Channel bar']},
        {1, 'Chat', 'GroupRoleIcon', L['Group role icon'], true},

        {1, 'Chat', 'WhisperSticky', L['Whisper sticky'], nil, nil, UpdateWhisperSticky},
        {1, 'Chat', 'WhisperSound', L['Whisper sound'], true},

        {1, 'Chat', 'SmartChatBubble', L['Smart bubble'], nil, nil, nil, L['|nOnly show chat bubbles in raid.']},
        {1, 'Chat', 'ExtendItemLink', L['Extend item link'], true, nil, nil, L['|nModifies displayed item links in chat to show the it\'s level and slot inline.']},


        {},
        {1, 'Chat', 'SpamFilter', L['Spam filter']},
        {1, 'Chat', 'BlockAddonSpam', L['Block addon spam']},
        {2, 'ACCOUNT', 'ChatFilterWhiteList', L['White List Mode'], true, nil, UpdateFilterWhiteList, L['|nOnly show messages that match the words below. Disabled if empty. Use key SPACE between multi words.']},
        {1, 'Chat', 'IgnoreFriends', L['Allow friends\' spam'], nil, nil, nil, L['|nAllow spam messages from friends, party members and guild members.']},
        {1, 'Chat', 'BlockStrangerWhisper', L['Block stranger whisper'], nil, nil, nil, L['|nOnly accept whispers from party or raid members, friends and guild members.']},
        {2, 'ACCOUNT', 'ChatFilterBlackList', L['Filter List'], true, nil, UpdateFilterList, L['|nFilter messages that match the words blow. Use key SPACE between multi words.']},
        {1, 'Chat', 'DamageMeterFilter', L['Damage meter filter'], nil, nil, nil, L['|nSimplify chat messages from damage meters like Details and instead provides a chat-link to provide the blocked damage statistics in a popup.']},

        {1, 'Chat', 'GroupLootFilter', L['Group loot filter'], nil, nil, nil, L['|nFilter the loot messages of teammates based on the quality of the items.']},
        {4, 'Chat', 'GroupLootThreshold', L['Quality Threshold'], true, {_G.ITEM_QUALITY1_DESC, _G.ITEM_QUALITY2_DESC, _G.ITEM_QUALITY3_DESC, _G.ITEM_QUALITY4_DESC, _G.ITEM_QUALITY5_DESC, _G.ITEM_QUALITY6_DESC, _G.ITEM_QUALITY7_DESC, _G.SPELL_SCHOOLALL}},

        {},
        {1, 'Chat', 'WhisperInvite', L['Whisper invite'], nil, nil, nil, L['|nAutomatically invite whisperers based on specific keywords.']},
        {1, 'Chat', 'GuildOnly', L['Only invite guild members']},
        {2, 'Chat', 'InviteKeyword', L['Invite Keyword'], true, nil, UpdateWhisperList, L['|nSetup whisper invite keywords. If you have more than one word, press key SPACE in between.']},
    },
    [5] = { -- aura
        {1, 'Aura', 'Enable', L['Enable Aura'], nil, SetupAuraSize},
        {1, 'Aura', 'BuffReverse', L['Buff reverse growth']},
        {1, 'Aura', 'DebuffReverse', L['Debuff reverse growth'], true},
        {1, 'Aura', 'Reminder', L['Buff missing reminder'], nil, nil, nil, L['|nRemind you when lack of your own class spell.|nSupport: Stamina, Poisons, Arcane Intellect, Battle Shout.']},
    },
    [6] = { -- actionbar
        {1, 'Actionbar', 'Enable', L['Enable Actionbar']},
        {1, 'Actionbar', 'Hotkey', L['Show hotkey'], nil, nil, UpdateHotkeys},
        {4, 'Actionbar', 'Layout', L['Actionbar Layout'], true, {'1 * 12', '2 * 12', '3 * 12', '2 * 18'}},
        {1, 'Actionbar', 'MacroName', L['Show macro name']},
        {1, 'Actionbar', 'CountNumber', L['Show charge count']},
        {3, 'Actionbar', 'Scale', L['Actionbar Scale'], true, {.5, 2, .1}},
        {1, 'Actionbar', 'ClassColor', L['Colored by class']},
        {1, 'Actionbar', 'DynamicFade', L['Conditional fader'], nil, SetupActionbarFade},
        {1, 'Actionbar', 'CooldownNotify', L['Cooldown notify'], true, nil, nil, L['|nYou can mouse wheel on actionbar button, and send its cooldown status to your group.']},
        {1, 'Actionbar', 'CooldownPulse', L['Cooldown pulse'], nil, nil, nil, L['|nTrack your spell cooldown using a pulse icon in the center of the screen.']},
        {1, 'Actionbar', 'CooldownDesaturate', L['Cooldown desaturate'], true, nil, nil, L['|nShow the action bar icons desaturated when they are on cooldown.']},
        {1, 'Actionbar', 'ButtonFlash', L['Button flash'], nil, nil, nil, L['|nAdd flash animation to pressed spell button.']},
        {},
        {1, 'Actionbar', 'Bar4', L['Enable sidebar 1']},
        {1, 'Actionbar', 'Bar5', L['Enable sidebar 2'], true},
        {1, 'Actionbar', 'PetBar', L['Enable pet bar']},
        {1, 'Actionbar', 'StanceBar', L['Enable stance bar'], true},
        {1, 'Actionbar', 'VehicleBar', L['Enable leave vehicle button']},
        {1, 'Actionbar', 'CustomBar', L['Enable additional bar'], true, SetupAdditionalbar, nil, L['|nAdd an additional actionbar for you to customize.']},
        {},
        {1, 'Cooldown', 'Enable', L['Enable cooldown count']},
        {1, 'Cooldown', 'Decimal', L['Decimal timer']},
        {1, 'Cooldown', 'OverrideWA', L['Override weakauras'], true},

    },
    [7] = { -- combat
        {1, 'Combat', 'Enable', L['Enable Combat']},
        {1, 'ACCOUNT', 'FloatingCombatText', L['Show blizzard combat text'], nil, nil, UpdateBlizzardFloatingCombatText, L['|nShow blizzard combat text of damage and healing.']},
        {3, 'ACCOUNT', 'WorldTextScale', L['Combat Text Scale'], true, {1, 3, .1}, UpdateWorldTextScale},
        {1, 'ACCOUNT', 'FloatingCombatTextOldStyle', L['Use old style combat text'], nil, nil, UpdateBlizzardFloatingCombatText, L['|nCombat text vertical up over nameplate instead of arc.']},
        {1, 'Combat', 'CombatAlert', L['Combat alert'], nil, nil, nil, L['|nShow an animated alert when you enter/leave combat.']},
        {1, 'Combat', 'SpellSound', L['Spell sound'], true, nil, nil, L['|nPlay a sound when you successfully interrup or dispel.']},
        {1, 'Combat', 'SmartTab', L['Smart TAB target'], nil, nil, nil, L['|nChange TAB binding to only target enemy players automatically when in PvP zones.']},
        {1, 'Combat', 'PvPSound', L['PvP sound'], true, nil, nil, L['|nPlay DotA-like sounds on PvP killing blows.']},
        {1, 'Combat', 'SimpleFloatingCombatText', L['Simple floating combat text'], nil, SetupSimpleFloatingCombatText, nil, L['|nProvides necessary combat infomation, including damage healing and events (dodge, parry, absorb etc...).']},
        {1, 'Combat', 'EasyFocusOnUnitframe', L['Easy focus on unitframes'], true},
        {4, 'Combat', 'EasyFocusKey', L['Easy Focus'], nil, {'CTRL', 'ALT', 'SHIFT', _G.DISABLE}},
        {4, 'Combat', 'EasyMarkKey', L['Easy Mark'], true, {'CTRL', 'ALT', 'SHIFT', _G.DISABLE}},
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
        {1, 'Unitframe', 'Enable', L['Enable Unitframes'], nil, SetupUnitFrameSize},
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
        {1, 'Unitframe', 'Castbar', L['Enable Castbar'], nil, SetupCastbar},
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
        {1, 'Unitframe', 'Group', L['Enable Groupframes'], nil, SetupGroupFrameSize},
        {1, 'Unitframe', 'SmartRaid', L['Smart layout'], nil, nil, UpdateAllHeaders, L['|nOnly show raid frames if there are more than 5 members in your group.|nIf disabled, show raid frames when in raid, show party frames when in party.']},
        {4, 'Unitframe', 'GroupColorStyle', L['Health bar style'], true, {L['Default white'], L['Class colored'], L['Percentage gradient']}},
        {1, 'Unitframe', 'GroupShowName', L['Show names']},
        {1, 'Unitframe', 'ClickToCast', L['Enable click to cast'], nil, nil, nil, L['|nOpen your spell book to configure click to cast.']},
        {3, 'Unitframe', 'GroupFilter', L['Group filter'], true, {4, 8, 1}},
        {1, 'Unitframe', 'PositionBySpec', L['Save postion by spec']},
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
        {1, 'Nameplate', 'Enable', L['Enable Nameplate'], nil, SetupNameplateSize},

        {1, 'Nameplate', 'ShowAura', L['Show auras'], nil, SetupAuraFilter},
        {4, 'Nameplate', 'AuraFilterMode', L['Aura filter mode'], true, {L['BlackNWhite'], L['PlayerOnly'], L['IncludeCrowdControl']}, nil, L.GUI.NAMEPLATE.AURA_FILTER_MODE_TIP},
        {1, 'Nameplate', 'ControlCVars', L['Control CVars'], nil, SetupNameplateCVars},
        {1, 'Nameplate', 'TargetIndicator', L['Target indicator'], nil, nil, nil, L.GUI.NAMEPLATE.TARGET_INDICATOR_TIP},
        {3, 'Nameplate', 'ExecuteRatio', L['Excute ratio'], true, {1, 90, 1}},
        {1, 'Nameplate', 'QuestIndicator', L['Quest indicator'], nil, nil, nil, L.GUI.NAMEPLATE.QUEST_INDICATOR_TIP},
        {1, 'Nameplate', 'ClassifyIndicator', L['Classify indicator'], nil, nil, nil, L.GUI.NAMEPLATE.CLASSIFY_INDICATOR_TIP},
        {1, 'Nameplate', 'RaidTargetIndicator', L['Raid target indicator']},
        {1, 'Nameplate', 'ThreatIndicator', L['Threat indicator'], true, nil, nil, L.GUI.NAMEPLATE.THREAT_INDICATOR_TIP},
        {1, 'Nameplate', 'TotemIcon', L['Totmes icon'], nil, nil, nil, L.GUI.NAMEPLATE.TOTEM_ICON_TIP},
        {1, 'Nameplate', 'NameOnly', L['Name only style'], nil, nil, nil, L.GUI.NAMEPLATE.NAME_ONLY_TIP},
        {1, 'Nameplate', 'ExplosiveIndicator', L['Explosive indicator'], nil, nil, nil, L.GUI.NAMEPLATE.EXPLOSIVE_INDICATOR_TIP},
        {1, 'Nameplate', 'SpitefulIndicator', L['Spiteful indicator'], true, nil, nil, L.GUI.NAMEPLATE.SPITEFUL_INDICATOR_TIP},
        {},
        {1, 'Nameplate', 'CastbarCompact', L['Compact style']},
        {1, 'Nameplate', 'MajorSpellsGlow', L['Major spell glow'], true, SetupMajorSpells, nil, L.GUI.NAMEPLATE.MAJOR_SPELLS_GLOW_TIP},
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
        {1, 'ACCOUNT', 'ShadowOutline', L['Shadow outline']},
        {1, 'ACCOUNT', 'GradientStyle', L['Button gradient style'], true},
        {1, 'ACCOUNT', 'ReskinBlizz', L['Restyle blizzard frames']},
        {1, 'ACCOUNT', 'ReskinAddons', L['Restyle other addons'], true, nil, nil, L['|nRestyle other addons, including DBM, BigWigs, WeakAuras, Immersion, PremadeGroupsFilter, etc.']},
        {5, 'ACCOUNT', 'BackdropColor', L['Backdrop color']},
        {5, 'ACCOUNT', 'BorderColor', L['Border color'], 1},
        {5, 'ACCOUNT', 'ButtonBackdropColor', L['Button backdrop color'], 2},
        {3, 'ACCOUNT', 'BackdropAlpha', L['Backdrop Alpha'], nil, {0, 1, .01}, UpdateBackdropAlpha},
        {3, 'ACCOUNT', 'ButtonBackdropAlpha', L['Button Backdrop Alpha'], true, {0, 1, .01}},
    },
    [16] = {},
    [17] = {},
}
