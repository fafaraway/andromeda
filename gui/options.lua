local _G = _G
local unpack = unpack
local select = select
local SetCVar = SetCVar

local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local ACTIONBAR = F:GetModule('ActionBar')
local INVENTORY = F:GetModule('Inventory')
local CHAT = F:GetModule('Chat')
local VIGNETTING = F:GetModule('Vignetting')
local BLIZZARD = F:GetModule('Blizzard')
local CAMERA = F:GetModule('Camera')
local INFOBAR = F:GetModule('InfoBar')

-- Aura
local function SetupAuraSize()
    GUI:SetupAuraSize(GUI.Page[5])
end

-- Inventory
local function UpdateInventoryStatus()
    INVENTORY:UpdateAllBags()
end

local function UpdateInventoryAnchor()
    INVENTORY:UpdateAllAnchors()
end

local function SetupInventoryFilter()
    GUI:SetupInventoryFilter(GUI.Page[9])
end

local function SetupInventorySize()
    GUI:SetupInventorySize(GUI.Page[9])
end

local function UpdateInventorySortOrder()
    SetSortBagsRightToLeft(C.DB.Inventory.SortMode == 1)
end

local function SetupMinItemLevelToShow()
    GUI:SetupMinItemLevelToShow(GUI.Page[9])
end

-- Actionbar
local function ToggleActionBarFader()
    ACTIONBAR:UpdateActionBarFade()
end

local function SetupActionbarFade()
    GUI:SetupActionbarFade(GUI.Page[6])
end

local function SetupAdditionalbar()
    GUI:SetupAdditionalbar(GUI.Page[6])
end

local function UpdateHotkeys()
    for _, button in pairs(ACTIONBAR.buttons) do
        if button.UpdateHotkeys then
            button:UpdateHotkeys(button.buttonType)
        end
    end
end

local function UpdateEquipColor()
    for _, button in pairs(ACTIONBAR.buttons) do
        if button.Border and button.Update then
            ACTIONBAR.UpdateEquipItemColor(button)
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
local function SetupMapScale()
    GUI:SetupMapScale(GUI.Page[10])
end

-- Nameplate
local function SetupNameplateSize()
    GUI:SetupNameplateSize(GUI.Page[14])
end

local function SetupNameplateCastbarSize()
    GUI:SetupNameplateCastbarSize(GUI.Page[14])
end

local function SetupNPRaidTargetIndicator()
    GUI:SetupRaidTargetIndicator(GUI.Page[14])
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

local function RefreshAllPlates()
    NAMEPLATE:RefreshAllPlates()
end

-- Unitframe
local function SetupUnitFrameSize()
    GUI:SetupUnitFrameSize(GUI.Page[12])
end

local function SetupBossFrameSize()
    GUI:SetupBossFrameSize(GUI.Page[12])
end

local function SetupArenaFrameSize()
    GUI:SetupArenaFrameSize(GUI.Page[12])
end

local function SetupUnitFrameFader()
    GUI:SetupUnitFrameFader(GUI.Page[12])
end

local function SetupCastbarSize()
    GUI:SetupCastbarSize(GUI.Page[12])
end

local function SetupCastbarColor()
    GUI:SetupCastbarColor(GUI.Page[12])
end

local function SetupClassPowerSize()
    GUI:SetupClassPowerSize(GUI.Page[12])
end

local function SetupUnitFrameRangeCheck()
    GUI:SetupUnitFrameRangeCheck(GUI.Page[12])
end

local function SetupRaidTargetIndicator()
    GUI:SetupRaidTargetIndicator(GUI.Page[12])
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
local function UpdateVignettingVisibility()
    VIGNETTING:UpdateVisibility()
end
local function SetupVignettingVisibility()
    GUI:SetupVignettingVisibility(GUI.Page[1])
end

local function SetupAutoScreenshot()
    GUI:SetupAutoScreenshot(GUI.Page[1])
end

local function SetupCustomClassColor()
    GUI:SetupCustomClassColor(GUI.Page[1])
end

local function UpdateActionCamera()
    CAMERA:UpdateActionCamera()
end

local function UpdateBossBanner()
    BLIZZARD:UpdateBossBanner()
end

local function UpdateBossEmote()
    BLIZZARD:UpdateBossEmote()
end

local function UpdateMawBuffsFrameVisibility()
    BLIZZARD:UpdateMawBuffsFrameVisibility()
end

-- Infobar
local function UpdateCombatPulse()
    INFOBAR:UpdateCombatPulse()
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

local function SetupSoundAlert()
    GUI:SetupSoundAlert(GUI.Page[7])
end

-- Announcement
local function SetupAnnounceableSpells()
    GUI:SetupAnnounceableSpells(GUI.Page[8])
end

-- Options
GUI.OptionsList = {
    [1] = { -- general
        {1, 'General', 'CursorTrail', L['Cursor trail']},
        {1, 'General', 'Vignetting', L['Vignetting'], nil, SetupVignettingVisibility, UpdateVignettingVisibility, L['Add shadowed overlay to screen corner.']},

        {3, 'ACCOUNT', 'UIScale', L['UI Scale'], true, {.5, 2, .01}, nil, L['Adjust UI scale for whole interface.|nIt is recommended to set 1080p to 1, 1440p to 1.2, and 2160p to 2.']},

        {1, 'ACCOUNT', 'UseCustomClassColor', L['Custom Class Color'], nil, SetupCustomClassColor, nil, L['Use custom class colors.']},
        {1, 'ACCOUNT', 'FontOutline', L['Font Outline'], nil, nil, nil, L['Add font outline globally, if you run the game with a low resolution, this option may improve the clarity of the interface text.']},
        {1, 'General', 'HideTalkingHead', L['Hide Talking Head'], nil, nil, nil, L['Dismisses NPC Talking Head popups automatically before they appear.']},

        {4, 'ACCOUNT', 'NumberFormat', L['Number Format'], true, {L['Standard: b/m/k'], L['Asian: y/w'], L['Full digitals']}},


        {1, 'General', 'HideBossBanner', L['Hide Boss Banner'], nil, nil, UpdateBossBanner, L['Hide the banner and loot list after the boss is killed.']},
        {1, 'General', 'HideBossEmote', L['Hide Boss Emote'], true, nil, UpdateBossEmote, L['Hide the emote and whisper from boss during battle.']},
        {1, 'General', 'HideMawBuffsFrame', L['Hide Anima Buffs Frame'], nil, nil, UpdateMawBuffsFrameVisibility, L['Hide the anima buffs frame from Mythic+ Dungeon and Tarragrue.']},

        {},
        {1, 'Quest', 'QuickQuest', L['Quick Quest'], nil, nil, nil, L['Automatically accept and deliver quests.|nHold ALT key to STOP automation.']},
        {1, 'Quest', 'CompletedSound', L['Quest Complete Sound'], true, nil, nil, L['When a quest is completed, a prompt sound effect will be played, including common quest and world quest.']},
        {1, 'Quest', 'WowheadLink', L['Wowhead Link'], nil, nil, nil, L['Right-click the quest or achievement in the objective tracker to get the corresponding Wowhead link.']},
        {1, 'Quest', 'AutoCollapseTracker', L['Auto Collapse Objective Tracker'], true, nil, nil, L['Collapse objective tracker automatically when you enter the instance, and restore it when you leave the instance.']},
        {},

        {1, 'General', 'EnhancedMailBox', L['Enhanced Mailbox'], nil, nil, nil, L['Enhance the default Mailbox UI, and provide some additional convenience functions.']},
        {1, 'General', 'EnhancedLFGList', L['Enhanced LFGList'], true, nil, nil, L['Enhance the default LFGList UI, including double-click to sign up, display the mythic plus score of the leader and applicants, etc.']},

        {1, 'General', 'SimplifyErrors', L['Filter Error Messages'], nil, nil, nil, L['Filter error messages during battle, such as ability not ready yet, out of rage/mana/energy, etc.']},
        {1, 'General', 'FasterMovieSkip', L['Faster Movie Skip'], true, nil, nil, L['Allow space bar, escape key and enter key to cancel cinematic without confirmation.']},
        {1, 'General', 'FasterZooming', L['Smooth Camera Zooming'], nil, nil, nil, L['Faster and smoother camera zooming.']},
        {1, 'General', 'ActionCamera', L['ActionCam Mode'], true, nil, UpdateActionCamera, L['Enable hidden ActionCam mode.']},
        {1, 'General', 'ScreenSaver', L['AFK Mode'], nil, nil, nil, L['Enable screen saver during AFK.']},
        {1, 'General', 'AutoScreenshot', L['Auto Screenshot'], true, SetupAutoScreenshot, nil, L['Take screenshots automatically based on specific events.']},

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
        {1, 'Infobar', 'AnchorTop', L['Anchor To Top'], nil, nil, nil, L['If disabled, infobar will be anchored to the bottom of the screen.']},
        {1, 'Infobar', 'Mouseover', L['Blocks Fade Out'], true, nil, nil, L['The blocks are hidden by default, and fade in by mouseover.']},
        {1, 'Infobar', 'CombatPulse', L['Combat Flashing'], nil, nil, UpdateCombatPulse, L['When entering the combat, the edge will turn red and flash.']},
        {},
        {1, 'Infobar', 'Stats', L['System Stats'], nil, nil, nil, L['Show time latency and FPS, and also track the resource usage of addons.']},
        {1, 'Infobar', 'Report', L['Daily/Weekly'], true, nil, nil, L['Track instance/raid lockouts and some daily/weekly stuffs.']},
        {1, 'Infobar', 'Friends', L['Friends']},
        {1, 'Infobar', 'Guild', L['Guild'], true},
        {1, 'Infobar', 'Durability', L['Durability']},
        {1, 'Infobar', 'Spec', L['Specialization'], true},
        {1, 'Infobar', 'Gold', L['Finances']},
        {1, 'Infobar', 'Currencies', L['Currencies'], true},
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
        {1, 'Chat', 'WhisperSound', L['Whisper sound'], true, nil, nil, L['Play sound when the new whisper message is more than 60 seconds from previous one.']},
        {1, 'Chat', 'SmartChatBubble', L['Smart bubble'], nil, nil, nil, L['|nOnly show chat bubbles in raid.']},
        {1, 'Chat', 'ExtendLink', L['Extend link'], true},
        {1, 'Chat', 'HideInCombat', L['Hide chat frame in combat']},
        {1, 'Chat', 'DisableProfanityFilter', L['Disable profanity filter'], true},
        {},
        {1, 'Chat', 'SpamFilter', L['Spam filter']},
        {1, 'Chat', 'BlockAddonSpam', L['Block addon spam']},
        {2, 'ACCOUNT', 'ChatFilterWhiteList', L['White List Mode'], true, nil, UpdateFilterWhiteList, L['|nOnly show messages that match the words below. Disabled if empty. Use key SPACE between multi words.']},
        {1, 'Chat', 'BlockSpammer', L['Block spammer message'], nil, nil, nil, L["If enanbled, repeat messages spammer will be blocked, you won't receive any messages from it any more."]},
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
        {3, 'Actionbar', 'Scale', L['Actionbar Scale'], true, {.5, 2, .1}},
        {1, 'Actionbar', 'CountNumber', L['Show charge count']},

        {1, 'Actionbar', 'EquipColor', L['Equipped item border'], nil, nil, UpdateEquipColor},
        {1, 'Actionbar', 'ClassColor', L['Background colored by class'], true},
        {1, 'Actionbar', 'Fader', L['Conditional fader'], nil, SetupActionbarFade, ToggleActionBarFader},
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
        {1, 'Combat', 'SoundAlert', L['Sound alert'], true, SetupSoundAlert},
        {1, 'Combat', 'SmartTab', L['Smart TAB target'], nil, nil, nil, L['|nChange TAB binding to only target enemy players automatically when in PvP zones.']},
        {1, 'Combat', 'PvPSound', L['PvP sound'], true, nil, nil, L['|nPlay DotA-like sounds on PvP killing blows.']},
        {1, 'Combat', 'SimpleFloatingCombatText', L['Simple floating combat text'], nil, SetupSimpleFloatingCombatText, nil, L['|nProvides necessary combat infomation, including damage healing and events (dodge, parry, absorb etc...).']},
        {1, 'Combat', 'EasyFocusOnUnitframe', L['Easy focus on unitframes'], true},
        {4, 'Combat', 'EasyFocusKey', L['Easy Focus'], nil, {'CTRL', 'ALT', 'SHIFT', _G.DISABLE}},
        {4, 'Combat', 'EasyMarkKey', L['Easy Mark'], true, {'CTRL', 'ALT', 'SHIFT', _G.DISABLE}},
    },
    [8] = { -- announcement
        {1, 'Announcement', 'Enable', L['Enable Announcement']},
        {1, 'Announcement', 'Spells', L['Major spells'], nil, SetupAnnounceableSpells},
        {4, 'Announcement', 'Channel', _G.CHANNEL, true, {_G.CHAT_MSG_PARTY .. '/' .. _G.CHAT_MSG_RAID, _G.YELL, _G.EMOTE, _G.SAY}},
        {1, 'Announcement', 'Interrupt', L['Interrupt']},
        {1, 'Announcement', 'Dispel', L['Dispel'], true},
        {1, 'Announcement', 'Stolen', L['Steal']},
        {1, 'Announcement', 'Reflect', L['Reflect'], true},
        {},
        {1, 'Announcement', 'Quest', L['Quest progress']},
        {1, 'Announcement', 'Reset', L['Instance reset'], true},
    },
    [9] = { -- inventory
        {1, 'Inventory', 'Enable', L['Enable Inventory'], nil, SetupInventorySize},
        {1, 'Inventory', 'CombineFreeSlots', L['Compact Mode'], nil, nil, UpdateInventoryStatus, L['Combine spare slots to save screen space.']},
        {4, 'Inventory', 'SortMode', L['Sort Mode'], true, {L['Forward'], L['Backward'], _G.DISABLE}, UpdateInventorySortOrder, L['If you have empty slots after sort, please disable inventory module, and turn off all bags filter in default ui containers.']},
        {1, 'Inventory', 'ItemFilter', L['Item Filter'], nil, SetupInventoryFilter, UpdateInventoryStatus, L['The items are stored separately according to the type of items.']},

        {1, 'Inventory', 'SpecialBagsColor', L['Colorized Special Bags'], true, nil, UpdateInventoryStatus, L['Show color for special bags, such as Herb bag, Mining bag, Gem bag, Enchanted mageweave pouch, etc.']},
        {1, 'Inventory', 'ItemLevel', L['Show Item Level'], nil, SetupMinItemLevelToShow, UpdateInventoryStatus, L['Show item level on inventory slots.|nOnly show iLvl info if higher than threshold.']},

        {1, 'Inventory', 'NewItemFlash', L['Show New Item Flash'], true, nil, nil, L['Newly obtained items will flash slightly, and stop flashing after hovering the cursor.']},

        {1, 'Inventory', 'BindType', L['Show BoE/BoA Indicator'], nil, nil, UpdateInventoryStatus, L['Show corresponding marks for BoE and BoA items.']},
    },
    [10] = { -- map
        {1, 'Map', 'Enable', L['Enable Map'], nil, SetupMapScale},
        {1, 'Map', 'RemoveFog', L['Remove map fog']},
        {1, 'Map', 'Coords', L['Show coords'], true},
        {1, 'Map', 'WhoPings', L['Show who pings']},
        {1, 'Map', 'ExpBar', L['Progress bar'], true},
        {1, 'Map', 'HideMinimapInCombat', L['Hide minimap in combat']},
    },
    [11] = { -- tooltip
        {1, 'Tooltip', 'Enable', L['Enable Tooltip']},
        {1, 'Tooltip', 'FollowCursor', L['Follow Cursor']},
        {1, 'Tooltip', 'HideInCombat', L['Hide in Combat'], true},
        {},
        {1, 'Tooltip', 'IDs', L['Show Spell&Item IDs']},
        {1, 'Tooltip', 'IDsByAlt', L['Show Spell&Item IDs by ALT'], true},
        {1, 'Tooltip', 'ItemInfo', L['Show Extra Item Info']},
        {1, 'Tooltip', 'ItemInfoByAlt', L['Show Extra Item Info by ALT'], true},
        {},
        {1, 'Tooltip', 'SpecIlvl', L['Show Spec&iLvl']},
        {1, 'Tooltip', 'MythicPlusScore', L['Show Mythic Plus Score'], true},
        {1, 'Tooltip', 'Covenant', L['Show Covenant']},
        {1, 'Tooltip', 'PlayerInfoByAlt', L['Show Spec&iLvl&Coven by ALT'], true},
        {1, 'Tooltip', 'HideRealm', L['Hide Realm']},
        {1, 'Tooltip', 'HideTitle', L['Hide Title'], true},
        {1, 'Tooltip', 'HideGuildRank', L['Hide Guild Rank']},
        {},
        {1, 'Tooltip', 'Icon', L['Show icon']},
        {1, 'Tooltip', 'BorderColor', L['Show Border Color'], true},
        {1, 'Tooltip', 'HealthValue', L['Show Health Value']},
        {1, 'Tooltip', 'TargetedBy', L['Show Unit Targeted By'], true},
        {1, 'Tooltip', 'DomiRank', L['Show Rank of Domination Shards']},
    },
    [12] = { -- unitframe
        {1, 'Unitframe', 'Enable', L['Enable Unitframes'], nil, SetupUnitFrameSize},
        {1, 'Unitframe', 'InvertedColorMode', L['Inverted Mode'], nil, nil, nil, L['The healthbar color and the background color are inverted.']},
        {4, 'Unitframe', 'TextureStyle', L['Texture Style'], true, {}},

        {1, 'Unitframe', 'RangeCheck', L['Range Check'], nil, SetupUnitFrameRangeCheck, nil, L["Fade out unit frame based on whether the unit is in the player's range"]},
        {1, 'Unitframe', 'Smooth', L['Smooth'], nil, nil, nil, L['Smoothly animate unit frame bars.']},
        {4, 'Unitframe', 'ColorStyle', L['Health Bar Color'], true, {L['Default White'], L['Class Color'], L['Percentage Gradient']}},
        {1, 'Unitframe', 'Portrait', L['Portrait'], nil, nil, nil, L['Show dynamic portrait on unit frame.']},

        {1, 'Unitframe', 'Fader', L['Conditional fader'], nil, SetupUnitFrameFader},
        {1, 'Unitframe', 'OnlyShowPlayer', L['Shows only debuffs created by player'], true},
        {1, 'Unitframe', 'RaidTargetIndicator', L['Raid Target Icon'], nil, SetupRaidTargetIndicator, nil, L['Show raid target icon on unit frame.']},
        {1, 'Unitframe', 'GCDIndicator', L['Global Cooldown Ticker'], true, nil, nil, L['Show global cooldown ticker above the player frame.']},
        {},
        {1, 'Unitframe', 'ClassPower', L['Class Power'], nil, SetupClassPowerSize, nil, L['Show special resources of the class, such as Combo Points, Holy Power, Chi, Runes, etc.']},
        {1, 'Unitframe', 'RunesTimer', L['Runes Timer'], true, nil, nil, L['Show timer for DK Runes.']},
        {},
        {1, 'Unitframe', 'Castbar', L['Enable Castbar'], nil, SetupCastbarColor, nil, L['Uncheck this if you want to use other castbar addon.']},
        {1, 'Unitframe', 'SeparateCastbar', L['Separate Castbar'], true, SetupCastbarSize, nil, L['If disabled, the castbar will be overlapped on the healthbar.|nNote that the spell name and time are only available with separate castbar.']},
        {},
        {1, 'Unitframe', 'Boss', L['Enable boss frames'], nil, SetupBossFrameSize, nil, L['Uncheck this if you want to use other BossFrame addon.']},
        {1, 'Unitframe', 'Arena', L['Enable arena frames'], true, SetupArenaFrameSize, nil, L['Uncheck this if you want to use other ArenaFrame addon.']},
    },
    [13] = { -- groupframe
        {1, 'Unitframe', 'Group', L['Enable Groupframes'], nil, SetupGroupFrameSize},
        {1, 'Unitframe', 'SmartRaid', L['Smart layout'], nil, nil, UpdateAllHeaders, L['|nOnly show raid frames if there are more than 5 members in your group.|nIf disabled, show raid frames when in raid, show party frames when in party.']},
        {3, 'Unitframe', 'GroupFilter', L['Group filter'], true, {4, 8, 1}},
        {1, 'Unitframe', 'GroupShowName', L['Show names']},
        {1, 'Unitframe', 'ClickToCast', L['Enable click to cast'], nil, nil, nil, L['|nOpen your spell book to configure click to cast.']},
        {1, 'Unitframe', 'PositionBySpec', L['Save postion by spec'], true},
        {1, 'Unitframe', 'InstanceAuras', L['Show raid debuffs'], nil, SetupRaidDebuffs, nil, L['|nShow custom major debuffs in raid and dungeons.']},
        {1, 'Unitframe', 'DispellableOnly', L['Show dispellable debuffs only'], true},
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
        {1, 'Nameplate', 'NameOnly', L['Name Only Mode'], nil, nil, nil, L['For friendly units, nameplate healthbar will be hidden and the name will be enlarged.']},
        {4, 'Nameplate', 'TextureStyle', L['Texture Style'], true, {}},
        {1, 'Nameplate', 'RaidTargetIndicator', L['Raid Target Indicator'], nil, SetupNPRaidTargetIndicator, nil, L['Show raid target icon on nameplate.']},

        {1, 'Nameplate', 'QuestIndicator', L['Quest indicator']},
        {1, 'Nameplate', 'ClassifyIndicator', L['Classify indicator'], true},
        {1, 'Nameplate', 'TargetIndicator', L['Target indicator']},
        {1, 'Nameplate', 'ThreatIndicator', L['Threat indicator'], true},
        {1, 'Nameplate', 'TotemIcon', L['Totmes icon']},

        {1, 'Nameplate', 'ShowAura', L['Show Nameplate Auras'], nil, SetupAuraFilter, RefreshAllPlates},
        {4, 'Nameplate', 'AuraFilterMode', L['Aura filter mode'], true, {L['BlackNWhite'], L['PlayerOnly'], L['IncludeCrowdControl']}},


        --{3, 'Nameplate', 'ExecuteRatio', L['Excute ratio'], nil, {1, 90, 1}, nil, L['If unit health percentage lower than the execute cap you set, its name text color turns into red.|nThe execute indicator would be disabled on 0.']},






        {},
        {1, 'Nameplate', 'ExplosiveIndicator', L['Explosive indicator']},
        {1, 'Nameplate', 'SpitefulIndicator', L['Spiteful indicator'], true},
        {},
        {1, 'Nameplate', 'Castbar', L['Enable Castbar']},
        {1, 'Nameplate', 'SeparateCastbar', L['Separate Castbar'], true, SetupNameplateCastbarSize, nil, L['If disabled, the castbar will be overlapped on the healthbar.|nNote that the spell name and time are only available with separate castbar.']},
        {1, 'Nameplate', 'CastTarget', L['Show Spell Target'], nil, nil, nil, L['Show target of casting spell on nameplate.']},
        {1, 'Nameplate', 'MajorSpellsGlow', L['Major Spells Glow'], true, SetupMajorSpells, nil, L['If unit is casting a major spell, highlight its castbar icon.|nClick the GEAR ICON to customize your list.']},
        {},
        {1, 'Nameplate', 'FriendlyClassColor', L['Friendly unit colored by class']},
        {1, 'Nameplate', 'HostileClassColor', L['Hostile unit colored by class'], true},
        {1, 'Nameplate', 'ColoredTarget', L['Target unit colored']},
        {5, 'Nameplate', 'TargetColor', L['Target color'], 2},
        {1, 'Nameplate', 'ColoredFocus', L['Focus unit colored']},
        {5, 'Nameplate', 'FocusColor', L['Focus color'], 2},
        {1, 'Nameplate', 'TankMode', L['Tank mode']},
        {1, 'Nameplate', 'RevertThreat', L['Revert threat'], true},
        {5, 'Nameplate', 'SecureColor', L['Secure']},
        {5, 'Nameplate', 'TransColor', L['Transition'], 1},
        {5, 'Nameplate', 'InsecureColor', L['Insecure'], 2},
        {5, 'Nameplate', 'OffTankColor', L['Off-Tank'], 3},
        {1, 'Nameplate', 'CustomUnitColor', L['Custom unit colored'], nil, nil, UpdateCustomUnitList},
        {5, 'Nameplate', 'CustomColor', L['Custom color']},
        {2, 'Nameplate', 'CustomUnitList', L['Custom unit list'], true, nil, UpdateCustomUnitList},


    },
    [15] = { -- theme
        {1, 'ACCOUNT', 'ShadowOutline', L['Shadow outline']},
        {1, 'ACCOUNT', 'GradientStyle', L['Button gradient style'], true},
        {1, 'ACCOUNT', 'ReskinBlizz', L['Restyle blizzard frames']},
        {1, 'ACCOUNT', 'ReskinAddons', L['Restyle other addons'], true, nil, nil, L['|nCurrently supports DBM, BigWigs, WeakAuras, Immersion, PremadeGroupsFilter, ActionBarProfiles, ExtendedVendor, FriendGroups, REHack, etc.']},
        {5, 'ACCOUNT', 'BackdropColor', L['Backdrop color']},
        {5, 'ACCOUNT', 'BorderColor', L['Border color'], 1},
        {5, 'ACCOUNT', 'ButtonBackdropColor', L['Button backdrop color'], 2},
        {3, 'ACCOUNT', 'BackdropAlpha', L['Backdrop Alpha'], nil, {0, 1, .01}, UpdateBackdropAlpha},
        {3, 'ACCOUNT', 'ButtonBackdropAlpha', L['Button Backdrop Alpha'], true, {0, 1, .01}},
    },
    [16] = {},
    [17] = {},
}
