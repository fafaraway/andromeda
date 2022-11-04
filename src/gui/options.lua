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
local MAP = F:GetModule('Map')
local oUF = F.Libs.oUF

-- Inventory

local function UpdateInventoryStatus()
    INVENTORY:UpdateAllBags()
end

local function SetupInventoryFilter()
    GUI:SetupInventoryFilter(GUI.Page[8])
end

local function SetupInventorySize()
    GUI:SetupInventorySize(GUI.Page[8])
end

local function UpdateInventorySortOrder()
    if C.IS_BETA then
        C_Container.SetSortBagsRightToLeft(C.DB.Inventory.SortMode == 1)
    else
        SetSortBagsRightToLeft(C.DB.Inventory.SortMode == 1)
    end
end

local function SetupMinItemLevelToShow()
    GUI:SetupMinItemLevelToShow(GUI.Page[8])
end

-- Actionbar
local function SetupActionBarSize()
    GUI:SetupActionBarSize(GUI.Page[5])
end

local function SetupVehicleButtonSize()
    GUI:SetupVehicleButtonSize(GUI.Page[5])
end

local function SetupStanceBarSize()
    GUI:SetupStanceBarSize(GUI.Page[5])
end

local function SetupActionbarFader()
    GUI:SetupActionbarFader(GUI.Page[5])
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

local function SetupCooldownCount()
    GUI:SetupCooldownCount(GUI.Page[5])
end

-- Chat

local function UpdateWhisperSticky()
    CHAT:WhisperSticky()
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

local function UpdateLanguageFilter()
    CHAT:UpdateLanguageFilter()
end

local function UpdateEditBoxAnchor()
    CHAT:ToggleEditBoxAnchor()
end

local function UpdateTextFading()
    CHAT:UpdateTextFading()
end

local function SetupChatTextFading()
    GUI:SetupChatTextFading(GUI.Page[4])
end

-- Map

local function SetupMapScale()
    GUI:SetupMapScale(GUI.Page[9])
end

local function UpdateWorldMapReveal()
    MAP:UpdateWorldMapReveal()
end

local function UpdateMinimapFader()
    MAP:UpdateMinimapFader()
end

-- Nameplate

local function UpdatePlateClickThrough()
    NAMEPLATE:UpdatePlateClickThrough()
end

local function SetupNameplateSize()
    GUI:SetupNameplateSize(GUI.Page[13])
end

local function SetupNameplateFriendlySize()
    GUI:SetupNameplateFriendlySize(GUI.Page[13])
end

local function UpdateNamePlateCVars()
    NAMEPLATE:UpdateNameplateCVars()
end

local function SetupNameplateCVars()
    GUI:SetupNameplateCVars(GUI.Page[13])
end

local function SetupNameplateExecuteIndicator()
    GUI:SetupNameplateExecuteIndicator(GUI.Page[13])
end

local function SetupNameplateCastbarSize()
    GUI:SetupNameplateCastbarSize(GUI.Page[13])
end

local function SetupAuraFilter()
    GUI:SetupNameplateAuraFilter(GUI.Page[13])
end

local function SetupNameplateUnitFilter()
    GUI:SetupNameplateUnitFilter(GUI.Page[13])
end

local function SetupNameplateColorByDot()
    GUI:SetupNameplateColorByDot(GUI.Page[13])
end

local function SetupNameplateMajorSpells()
    GUI:SetupNameplateMajorSpells(GUI.Page[13])
end

local function RefreshSpecialUnitsList()
    NAMEPLATE:RefreshSpecialUnitsList()
end

local function RefreshAllPlates()
    NAMEPLATE:RefreshAllPlates()
end

local function UpdateNameplateRaidTargetIndicator()
    NAMEPLATE:UpdateRaidTargetIndicator()
end

local function UpdateNamePlateTags()
    NAMEPLATE:UpdateTags()
end

local function SetupNameplateNameLength()
    GUI:SetupNameplateNameLength(GUI.Page[13])
end

-- Unitframe

local function UpdateHealthColor()
    for _, frame in pairs(oUF.objects) do
        local style = frame.unitStyle
        if style and style ~= 'nameplate' then
            UNITFRAME:UpdateHealthColor(frame, true)
        end
    end
end

local function SetupUnitFrame()
    GUI:SetupUnitFrame(GUI.Page[11])
end

local function SetupBossFrame()
    GUI:SetupBossFrame(GUI.Page[11])
end

local function SetupArenaFrame()
    GUI:SetupArenaFrame(GUI.Page[11])
end

local function SetupUnitFrameFader()
    GUI:SetupUnitFrameFader(GUI.Page[11])
end

local function SetupCastbar()
    GUI:SetupCastbar(GUI.Page[11])
end

local function SetupCastbarColor()
    GUI:SetupCastbarColor(GUI.Page[11])
end

local function SetupClassPower()
    GUI:SetupClassPower(GUI.Page[11])
end

local function SetupUnitFrameRangeCheck()
    GUI:SetupUnitFrameRangeCheck(GUI.Page[11])
end

local function UpdateGCDTicker()
    UNITFRAME:UpdateGCDTicker()
end

local function UpdateClassPower()
    UNITFRAME:UpdateClassPower()
end

local function UpdatePortrait()
    UNITFRAME:UpdatePortrait()
end

local function UpdateFader()
    UNITFRAME:UpdateFader()
end

-- Groupframe

local function UpdatePartyHeader()
    if UNITFRAME.CreateAndUpdatePartyHeader then
        UNITFRAME:CreateAndUpdatePartyHeader()
    end
end

local function UpdateRaidHeader()
    if UNITFRAME.CreateAndUpdateRaidHeader then
        UNITFRAME:CreateAndUpdateRaidHeader()
        UNITFRAME:UpdateRaidTeamIndex()
    end
end

local function SetupPartyFrame()
    GUI:SetupPartyFrame(GUI.Page[12])
end

local function SetupRaidFrame()
    GUI:SetupRaidFrame(GUI.Page[12])
end

local function SetupSimpleRaidFrame()
    GUI:SetupSimpleRaidFrame(GUI.Page[12])
end

local function UpdatePartyElements()
    UNITFRAME:UpdatePartyElements()
end

local function SetupPartyWatcher()
    GUI:SetupPartyWatcher(GUI.Page[12])
end

local function SetupDebuffWatcher()
    GUI:SetupDebuffWatcher(GUI.Page[12])
end

local function UpdateAllHeaders()
    UNITFRAME:UpdateAllHeaders()
end

local function UpdateUnitTags()
    UNITFRAME:UpdateUnitTags()
end

local function UpdateGroupTags()
    UNITFRAME:UpdateGroupTags()
end

local function SetupNameLength()
    GUI:SetupNameLength(GUI.Page[12])
end

local function SetupPartyBuff()
    GUI:SetupPartyBuff(GUI.Page[12])
end

local function SetupPartyAura()
    GUI:SetupPartyAura(GUI.Page[12])
end

local function SetupPartyDebuff()
    GUI:SetupPartyDebuff(GUI.Page[12])
end

local function SetupRaidBuff()
    GUI:SetupRaidBuff(GUI.Page[12])
end

local function SetupRaidDebuff()
    GUI:SetupRaidDebuff(GUI.Page[12])
end

local function UpdateGroupAuras()
    UNITFRAME:UpdateGroupAuras()
end

local function UpdateRaidTargetIndicator()
    UNITFRAME:UpdateRaidTargetIndicator()
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

local function SetupAuraSize()
    GUI:SetupAuraSize(GUI.Page[1])
end

local function UpdateScreenSaver()
    F:GetModule('ScreenSaver'):UpdateScreenSaver()
end

-- Infobar

local function UpdateCombatPulse()
    INFOBAR:UpdateCombatPulse()
end

-- Theme
local function UpdateBackdropAlpha()
    for _, frame in pairs(C.Frames) do
        frame:SetBackdropColor(0, 0, 0, _G.ANDROMEDA_ADB.BackdropAlpha)
    end
end

-- Combat
local function UpdateWorldTextScale()
    SetCVar('WorldTextScale', _G.ANDROMEDA_ADB.WorldTextScale)
end

local function UpdateBlizzardFloatingCombatText()
    local enable = _G.ANDROMEDA_ADB.FloatingCombatText
    local oldStyle = _G.ANDROMEDA_ADB.FloatingCombatTextOldStyle

    SetCVar('floatingCombatTextCombatDamage', enable and 1 or 0) -- 黄色伤害数字
    SetCVar('floatingCombatTextCombatHealing', enable and 1 or 0) -- 绿色治疗数字

    SetCVar('floatingCombatTextCombatDamageDirectionalScale', oldStyle and 0 or 1) -- 0 旧式向上垂直 1-5 新式
    SetCVar('floatingCombatTextFloatMode', oldStyle and 1 or 3) -- 1 向上 2 向下 3 四散
    SetCVar('floatingCombatTextCombatDamageDirectionalOffset', 4)
end

local function SetupSimpleFloatingCombatText()
    GUI:SetupSimpleFloatingCombatText(GUI.Page[6])
end

local function SetupSoundAlert()
    GUI:SetupSoundAlert(GUI.Page[6])
end

-- Announcement
local function SetupAnnounceableSpells()
    GUI:SetupAnnounceableSpells(GUI.Page[7])
end

-- Options
GUI.OptionsList = {
    [1] = { -- general
        {
            1,
            'General',
            'CursorTrail',
            L['Cursor trail'],
        },
        {
            1,
            'General',
            'Vignetting',
            L['Vignetting'],
            nil,
            SetupVignettingVisibility,
            UpdateVignettingVisibility,
            L['Add shadowed overlay to screen corner.'],
        },
        {
            3,
            'ACCOUNT',
            'UIScale',
            L['UI Scale'],
            true,
            { 0.5, 2, 0.01 },
            nil,
            L['Adjust UI scale for whole interface.|nIt is recommended to set 1080p to 1, 1440p to 1.2, and 2160p to 2.'],
        },
        {
            1,
            'ACCOUNT',
            'UseCustomClassColor',
            L['Custom Class Color'],
            nil,
            SetupCustomClassColor,
            nil,
            L['Use custom class colors.'],
        },
        {
            1,
            'ACCOUNT',
            'FontOutline',
            L['Font Outline'],
            nil,
            nil,
            nil,
            L['Add font outline globally, if you run the game with a low resolution, this option may improve the clarity of the interface text.'],
        },
        {
            4,
            'ACCOUNT',
            'NumberFormat',
            L['Number Format'],
            true,
            {
                L['Standard: b/m/k'],
                L['Asian: y/w'],
                L['Full digitals'],
            },
        },
        {
            1,
            'General',
            'HideTalkingHead',
            L['Hide Talking Head'],
            nil,
            nil,
            nil,
            L['Dismisses NPC Talking Head popups automatically before they appear.'],
        },
        {
            1,
            'General',
            'HideBossEmote',
            L['Hide Boss Emote'],
            true,
            nil,
            UpdateBossEmote,
            L['Hide the emote and whisper from boss during battle.'],
        },
        {
            1,
            'General',
            'HideBossBanner',
            L['Hide Boss Banner'],
            nil,
            nil,
            UpdateBossBanner,
            L['Hide the banner and loot list after the boss is killed.'],
        },
        {},
        {
            1,
            'General',
            'GameMenu',
            L['Game Menu'],
            nil,
            nil,
            nil,
            L['Add a game menu bar at the bottom of the screen.'],
        },
        {
            1,
            'General',
            'GroupTool',
            L['Group Tool'],
            true,
            nil,
            nil,
            L['Add group tool at the top of the screen.'],
        },
        {},
        {
            1,
            'Aura',
            'Enable',
            L['Enhanced Aura'],
            nil,
            SetupAuraSize,
            nil,
            L['Enhance the default aura frame.'],
        },
        {
            1,
            'General',
            'EnhancedLoot',
            L['Enhanced Loot'],
            true,
            nil,
            nil,
            L['Enhance the default loot frame.'],
        },
        {
            1,
            'General',
            'EnhancedMailBox',
            L['Enhanced Mailbox'],
            nil,
            nil,
            nil,
            L['Enhance the default mailbox frame, and provide some additional convenience functions.'],
        },
        {
            1,
            'General',
            'EnhancedPremade',
            L['Enhanced Premade'],
            true,
            nil,
            nil,
            L['Enhance the premade, including quick apply by double click, hide group join notice, styled group roles, auto invite applicants, show leader overall score, abbr keystone name for Tazavesh.'],
        },
        {
            1,
            'General',
            'EnhancedMerchant',
            L['Enhanced Merchant'],
            nil,
            nil,
            nil,
            L['Enhance the default merchant frame by expanding it to twice the width.'],
        },
        {},
        {
            1,
            'General',
            'SimplifyErrors',
            L['Filter Error Messages'],
            nil,
            nil,
            nil,
            L['Filter error messages during battle, such as ability not ready yet, out of rage/mana/energy, etc.'],
        },
        {
            1,
            'General',
            'FasterMovieSkip',
            L['Faster Movie Skip'],
            true,
            nil,
            nil,
            L['Allow space bar, escape key and enter key to cancel cinematic without confirmation.'],
        },
        {
            1,
            'General',
            'FasterZooming',
            L['Smooth Camera Zooming'],
            nil,
            nil,
            nil,
            L['Faster and smoother camera zooming.'],
        },
        {
            1,
            'General',
            'ActionCamera',
            L['ActionCam Mode'],
            true,
            nil,
            UpdateActionCamera,
            L['Enable hidden ActionCam mode.'],
        },
        {
            1,
            'General',
            'ScreenSaver',
            L['AFK Mode'],
            nil,
            nil,
            UpdateScreenSaver,
            L['Enable screen saver during AFK.'],
        },
        {
            1,
            'General',
            'AutoScreenshot',
            L['Auto Screenshot'],
            true,
            SetupAutoScreenshot,
            nil,
            L['Take screenshots automatically based on specific events.'],
        },
        {},
        {
            1,
            'Quest',
            'QuickQuest',
            L['Quick Quest'],
            nil,
            nil,
            nil,
            L['Automatically accept and deliver quests.|nHold ALT key to STOP automation.'],
        },
        {
            1,
            'Quest',
            'CompletedSound',
            L['Quest Complete Sound'],
            true,
            nil,
            nil,
            L['When a quest is completed, a prompt sound effect will be played, including common quest and world quest.'],
        },
        {
            1,
            'Quest',
            'WowheadLink',
            L['Wowhead Link'],
            nil,
            nil,
            nil,
            L['Right mouse click the quest or achievement in the objective tracker to get the corresponding wowhead link.'],
        },
        {
            1,
            'Quest',
            'AutoCollapseTracker',
            L['Auto Collapse Objective Tracker'],
            true,
            nil,
            nil,
            L['Collapse objective tracker automatically when you enter the instance, and restore it when you leave the instance.'],
        },
    },
    [2] = { -- notification
        {
            1,
            'Notification',
            'Enable',
            L['Enable Notification'],
        },
        {
            1,
            'Notification',
            'BagFull',
            L['Backpack Full'],
        },
        {
            1,
            'Notification',
            'NewMail',
            L['New Mail'],
            true,
        },
        {
            1,
            'Notification',
            'RareFound',
            L['Rare Found'],
        },
        {
            1,
            'Notification',
            'LowDurability',
            L['Durability Low'],
            true,
        },
        {
            1,
            'Notification',
            'ParagonChest',
            L['Paragon Award'],
        },
        {
            1,
            'ACCOUNT',
            'VersionCheck',
            L['AddOn Outdated'],
            true,
        },
    },
    [3] = { -- infobar
        { 1, 'Infobar', 'Enable', L['Enable Infobar'] },
        {
            1,
            'Infobar',
            'AnchorTop',
            L['Anchor To Top'],
            nil,
            nil,
            nil,
            L['If disabled, infobar will be anchored to the bottom of the screen.'],
        },
        {
            1,
            'Infobar',
            'Mouseover',
            L['Blocks Fade Out'],
            true,
            nil,
            nil,
            L['The blocks are hidden by default, and fade in by mouseover.'],
        },
        {
            1,
            'Infobar',
            'CombatPulse',
            L['Combat Flashing'],
            nil,
            nil,
            UpdateCombatPulse,
            L['When entering the combat, the edge will turn red and flash.'],
        },
        {},
        {
            1,
            'Infobar',
            'Stats',
            L['System Stats'],
            nil,
            nil,
            nil,
            L['Show time latency and FPS, and also track the resource usage of addons.'],
        },
        {
            1,
            'Infobar',
            'Report',
            L['Daily/Weekly'],
            true,
            nil,
            nil,
            L['Track instance/raid lockouts and some daily/weekly stuffs.'],
        },
        { 1, 'Infobar', 'Friends', L['Friends'] },
        { 1, 'Infobar', 'Guild', L['Guild'], true },
        { 1, 'Infobar', 'Durability', L['Durability'] },
        {
            1,
            'Infobar',
            'Spec',
            L['Specialization'],
            true,
        },
        { 1, 'Infobar', 'Gold', L['Finances'] },
        {
            1,
            'Infobar',
            'Currencies',
            L['Currencies'],
            true,
        },
    },
    [4] = { -- chat
        { 1, 'Chat', 'Enable', L['Enable Chat'] },
        {
            1,
            'Chat',
            'LockPosition',
            L['Lock Position'],
            nil,
            SetupChatSize,
            nil,
            L['Lock postion and size of chat frame.|nDisable this if you want to adjust chat frame.'],
        },
        {
            1,
            'Chat',
            'TextFading',
            L['Text Fade Out'],
            true,
            SetupChatTextFading,
            UpdateTextFading,
            L['Text will fade out after a period of time without receiving new messages.'],
        },
        { 1, 'Chat', 'CopyButton', L['Copy Button'] },
        {
            1,
            'Chat',
            'VoiceButton',
            L['Voice Button'],
            true,
        },
        {
            1,
            'Chat',
            'ShortenChannelName',
            L['Shorten Channel Name'],
            nil,
            nil,
            nil,
            L['Shorten channel name.|ne.g. [1: General] to [1], [Guild] to [G].'],
        },
        {
            1,
            'Chat',
            'EasyChannelSwitch',
            L['Easy Channel Switch'],
            true,
            nil,
            nil,
            L['You can use TAB key to cycle channels after the input box is activated.'],
        },
        { 1, 'Chat', 'ChannelBar', L['Channel Bar'] },
        {
            1,
            'Chat',
            'GroupRoleIcon',
            L['Group Role Icon'],
            true,
        },
        {
            1,
            'Chat',
            'WhisperSticky',
            L['Whisper Sticky'],
            nil,
            nil,
            UpdateWhisperSticky,
        },
        {
            1,
            'Chat',
            'WhisperSound',
            L['Whisper Sound'],
            true,
            nil,
            nil,
            L['Play sound when you receive whisper.|nNo sound will be played if the interval between whisper is less than 60 seconds.'],
        },
        {
            1,
            'Chat',
            'SmartChatBubble',
            L['Smart Bubble'],
            nil,
            nil,
            nil,
            L['Only show chat bubbles in raid.'],
        },
        {
            1,
            'Chat',
            'ExtendLink',
            L['Extend Link'],
            true,
        },
        {
            1,
            'Chat',
            'BottomEditBox',
            L['EditBox On Bottom'],
            nil,
            nil,
            UpdateEditBoxAnchor,
            L['Anchor the editbox to the bottom.'],
        },
        {
            1,
            'Chat',
            'HideInCombat',
            L['Hidden in Combat'],
        },
        {
            1,
            'Chat',
            'DisableProfanityFilter',
            L['Disable Profanity Filter'],
            true,
            nil,
            UpdateLanguageFilter,
        },
        {},
        { 1, 'Chat', 'SpamFilter', L['Spam filter'] },
        {
            1,
            'Chat',
            'BlockAddonSpam',
            L['Block AddOn Spam'],
        },
        {
            2,
            'ACCOUNT',
            'ChatFilterWhiteList',
            L['White List Mode'],
            true,
            nil,
            UpdateFilterWhiteList,
            L['Only show messages that match the words below. Disabled if empty. Use key SPACE between multi words.'],
        },
        {
            1,
            'Chat',
            'BlockSpammer',
            L['Block Spammer Message'],
            nil,
            nil,
            nil,
            L['If enabled, repeated messages spammer will be blocked, you will not receive any messages from him/her any more.'],
        },
        {
            1,
            'Chat',
            'BlockStrangerWhisper',
            L['Block Stranger Whisper'],
            nil,
            nil,
            nil,
            L['Only accept whispers from group members, friends and guild members.'],
        },
        {
            2,
            'ACCOUNT',
            'ChatFilterBlackList',
            L['Filter List'],
            true,
            nil,
            UpdateFilterList,
            L['Filter messages that match the words blow. Use key SPACE between multi words.'],
        },
        {
            1,
            'Chat',
            'DamageMeterFilter',
            L['Damage Meter Filter'],
            nil,
            nil,
            nil,
            L['Clean up chat messages from damage meter addons like Details and instead provides a clickable chat link to provide the blocked statistics in a popup.'],
        },
        {
            1,
            'Chat',
            'GroupLootFilter',
            L['Group Loot Filter'],
            nil,
            nil,
            nil,
            L['Filter the loot messages of teammates based on the quality of the items.'],
        },
        {
            4,
            'Chat',
            'GroupLootThreshold',
            L['Quality Threshold'],
            true,
            {
                _G.ITEM_QUALITY1_DESC,
                _G.ITEM_QUALITY2_DESC,
                _G.ITEM_QUALITY3_DESC,
                _G.ITEM_QUALITY4_DESC,
                _G.ITEM_QUALITY5_DESC,
                _G.ITEM_QUALITY6_DESC,
                _G.ITEM_QUALITY7_DESC,
                _G.SPELL_SCHOOLALL,
            },
        },
        {},
        {
            1,
            'Chat',
            'WhisperInvite',
            L['Whisper Invite'],
            nil,
            nil,
            nil,
            L['Automatically invite whisperers based on specific keywords.'],
        },
        {
            1,
            'Chat',
            'GuildOnly',
            L['Guild Members Only'],
        },
        {
            2,
            'Chat',
            'InviteKeyword',
            L['Invite Keyword'],
            true,
            nil,
            UpdateWhisperList,
            L['Setup whisper invite keywords. If you have more than one word, press key SPACE in between.'],
        },
    },
    [5] = { -- actionbar
        {
            1,
            'Actionbar',
            'Enable',
            L['Enable Actionbar'],
            nil,
            SetupActionBarSize,
        },
        {
            1,
            'Actionbar',
            'Hotkey',
            L['Key Binding'],
            nil,
            nil,
            UpdateHotkeys,
            L['Display key binding on the actionbar buttons.'],
        },
        {
            1,
            'Actionbar',
            'MacroName',
            L['Macro Name'],
            true,
            nil,
            nil,
            L['Display macro name on the actionbar buttons.'],
        },
        {
            1,
            'Actionbar',
            'CountNumber',
            L['Count and Charge'],
            nil,
            nil,
            nil,
            L['Display item count and spell charge on the actionbar buttons.'],
        },
        {
            1,
            'Actionbar',
            'ButtonFlash',
            L['Flash Animation'],
            true,
            nil,
            nil,
            L['Add flash animation to the pressed actionbar buttons.'],
        },
        {
            1,
            'Actionbar',
            'EquipColor',
            L['Equipped Item Border'],
            nil,
            nil,
            UpdateEquipColor,
            L['Color the button border of equipped item.'],
        },
        {
            1,
            'Actionbar',
            'ClassColor',
            L['Button Class Color'],
            true,
            nil,
            nil,
            L['Color the button backdrop of actionbar by player class.'],
        },
        {
            1,
            'Actionbar',
            'Fader',
            L['Conditional Visibility'],
            nil,
            SetupActionbarFader,
            nil,
            L['The actionbar is hidden by default and shown according to specific conditions.'],
        },
        {
            1,
            'Cooldown',
            'Enable',
            L['Cooldown Count'],
            true,
            SetupCooldownCount,
            nil,
            L['Display cooldown count on the actionbar buttons.'],
        },
        {
            1,
            'Actionbar',
            'CooldownNotify',
            L['Spell Cooldown Notify'],
            nil,
            nil,
            nil,
            L['You can mouse wheel on actionbar buttons, and send its cooldown status to your group.'],
        },
        {
            1,
            'Actionbar',
            'CooldownDesaturate',
            L['Desaturate Icon'],
            true,
            nil,
            nil,
            L['Desaturate actionbar buttons when they are on cooldown.'],
        },
        {
            1,
            'Actionbar',
            'KeyFeedback',
            L['Key Feedback'],
            nil,
            nil,
            nil,
            L['Display spell you are currently pressing.'],
        },
        {},
        {
            1,
            'Actionbar',
            'EnablePetBar',
            L['Pet Bar'],
            nil,
            nil,
            nil,
            L['Enable pet actionbar.'],
        },
        {
            1,
            'Actionbar',
            'EnableStanceBar',
            L['Stance Bar'],
            true,
            SetupStanceBarSize,
            nil,
            L['Enable stance bar.'],
        },
        {
            1,
            'Actionbar',
            'EnableVehicleBar',
            L['Leave Vehicle Button'],
            nil,
            SetupVehicleButtonSize,
            nil,
            L['Enable leave vehicle button.'],
        },
    },
    [6] = { -- combat
        { 1, 'Combat', 'Enable', L['Enable Combat'] },
        {
            1,
            'ACCOUNT',
            'FloatingCombatText',
            L['Show blizzard combat text'],
            nil,
            nil,
            UpdateBlizzardFloatingCombatText,
            L['Show blizzard combat text of damage and healing.'],
        },
        {
            3,
            'ACCOUNT',
            'WorldTextScale',
            L['Combat Text Scale'],
            true,
            { 1, 3, 0.1 },
            UpdateWorldTextScale,
        },
        {
            1,
            'ACCOUNT',
            'FloatingCombatTextOldStyle',
            L['Use old style combat text'],
            nil,
            nil,
            UpdateBlizzardFloatingCombatText,
            L['Combat text vertical up over nameplate instead of arc.'],
        },
        {
            1,
            'Combat',
            'CombatAlert',
            L['Combat alert'],
            nil,
            nil,
            nil,
            L['Show an animated alert when you enter/leave combat.'],
        },
        {
            1,
            'Combat',
            'SoundAlert',
            L['Sound Alert'],
            true,
            SetupSoundAlert,
        },
        {
            1,
            'Combat',
            'SmartTab',
            L['Smart TAB target'],
            nil,
            nil,
            nil,
            L['Change TAB binding to only target enemy players automatically when in PvP zones.'],
        },
        {
            1,
            'Combat',
            'SimpleFloatingCombatText',
            L['Floating Combat Text'],
            true,
            SetupSimpleFloatingCombatText,
            nil,
            L['Display floating combat text, including damage healing and events (dodge, parry, absorb etc...).'],
        },
        {
            1,
            'Combat',
            'BuffReminder',
            L['Buff Reminder'],
            nil,
            nil,
            nil,
            L['Remind you when lack of your own class spell.|nSupport: Stamina, Poisons, Arcane Intellect, Battle Shout.'],
        },
        {
            1,
            'Combat',
            'CooldownPulse',
            L['Cooldown Pulse'],
            true,
            nil,
            nil,
            L['Track your spell cooldown using a pulse icon in the center of the screen.'],
        },
        {
            1,
            'Combat',
            'PvPSound',
            L['PvP Sound'],
            nil,
            nil,
            nil,
            L['Play DotA-like sounds on PvP killing blows.'],
        },
        {},
        {
            4,
            'Combat',
            'EasyFocusKey',
            L['Easy Focus'],
            nil,
            { 'CTRL', 'ALT', 'SHIFT', _G.DISABLE },
            nil,
            L['Use the left mouse button to click on any unit while holding down the specified modifier key to quickly set it as focus.'],
        },
        {
            4,
            'Combat',
            'EasyMarkKey',
            L['Easy Mark'],
            true,
            { 'CTRL', 'ALT', 'SHIFT', _G.DISABLE },
            nil,
            L['Use the left mouse button to click on any unit while holding down the specified modifier key to quickly mark it.'],
        },
        {
            1,
            'Combat',
            'EasyFocusOnUnitframe',
            L['Easy focus on unitframes'],
        },
    },
    [7] = { -- announcement
        {
            1,
            'Announcement',
            'Enable',
            L['Enable Announcement'],
        },
        {
            1,
            'Announcement',
            'Spells',
            L['Major Spells'],
            nil,
            SetupAnnounceableSpells,
        },
        {
            4,
            'Announcement',
            'Channel',
            _G.CHANNEL,
            true,
            {
                _G.CHAT_MSG_PARTY .. '/' .. _G.CHAT_MSG_RAID,
                _G.YELL,
                _G.EMOTE,
                _G.SAY,
            },
        },
        {
            1,
            'Announcement',
            'Interrupt',
            L['Interrupt'],
        },
        {
            1,
            'Announcement',
            'Dispel',
            L['Dispel'],
            true,
        },
        {
            1,
            'Announcement',
            'Stolen',
            L['Steal'],
        },
        {
            1,
            'Announcement',
            'Reflect',
            L['Reflect'],
            true,
        },
        {},
        {
            1,
            'Announcement',
            'Quest',
            L['Quest Progress'],
        },
        {
            1,
            'Announcement',
            'Reset',
            L['Instance Reset'],
            true,
        },
    },
    [8] = { -- inventory
        {
            1,
            'Inventory',
            'Enable',
            L['Enable Inventory'],
            nil,
            SetupInventorySize,
        },
        {
            1,
            'Inventory',
            'CombineFreeSlots',
            L['Compact Mode'],
            nil,
            nil,
            UpdateInventoryStatus,
            L['Combine spare slots to save screen space.'],
        },
        {
            4,
            'Inventory',
            'SortMode',
            L['Sort Mode'],
            true,
            { L['Forward'], L['Backward'], _G.DISABLE },
            UpdateInventorySortOrder,
            L['If you have empty slots after sort, please disable inventory module, and turn off all bags filter in default ui containers.'],
        },
        {
            1,
            'Inventory',
            'ItemFilter',
            L['Item Filter'],
            nil,
            SetupInventoryFilter,
            UpdateInventoryStatus,
            L['The items are stored separately according to the type of items.'],
        },

        {
            1,
            'Inventory',
            'SpecialBagsColor',
            L['Color Special Bags'],
            true,
            nil,
            UpdateInventoryStatus,
            L['Show color for special bags, such as Herb bag, Mining bag, Gem bag, Enchanted mageweave pouch, etc.'],
        },
        {
            1,
            'Inventory',
            'ItemLevel',
            L['Show Item Level'],
            nil,
            SetupMinItemLevelToShow,
            UpdateInventoryStatus,
            L['Show item level on inventory slots.|nOnly show iLvl info if higher than threshold.'],
        },

        {
            1,
            'Inventory',
            'NewItemFlash',
            L['Show New Item Flash'],
            true,
            nil,
            nil,
            L['Newly obtained items will flash slightly, and stop flashing after hovering the cursor.'],
        },

        {
            1,
            'Inventory',
            'BindType',
            L['Show BoE/BoA Indicator'],
            nil,
            nil,
            UpdateInventoryStatus,
            L['Show corresponding marks for BoE and BoA items.'],
        },
    },
    [9] = { -- map
        {
            1,
            'Map',
            'Enable',
            L['Enable Map'],
            nil,
            SetupMapScale,
        },
        {
            1,
            'Map',
            'MapReveal',
            L['Map Reveal'],
            nil,
            nil,
            UpdateWorldMapReveal,
            L['Display unexplored areas on the world map.'],
        },
        {
            1,
            'Map',
            'Coords',
            L['Coordinates'],
            true,
            nil,
            nil,
            L["Display the coordinates of the player's location and the mouse's current position on the world map."],
        },
        {
            1,
            'Map',
            'Collector',
            L['AddOns Icon Collector'],
            nil,
            nil,
            nil,
            L['Collect addons icon.'],
        },
        {
            1,
            'Map',
            'WhoPings',
            L['Who Pings'],
            true,
            nil,
            nil,
            L['When you are in group, display the name of the group member who is clicking on the minimap.'],
        },
        {
            1,
            'Map',
            'Menu',
            L['Game Menu'],
            nil,
            nil,
            nil,
            L['Right mouse click on minimap will show the game menu.'],
        },
        {
            1,
            'Map',
            'Volume',
            L['Game Volume'],
            true,
            nil,
            nil,
            L['Holding key ALT and mousewheel on minimap will change game sound volume.|nHold key CTRL+ALT, the volume will switch from 0 to 100 directly.'],
        },
        {
            1,
            'Map',
            'ProgressBar',
            L['Progress Bar'],
            nil,
            nil,
            nil,
            L["Track the progress of player's level, experience, reputation, honor, renown, etc."],
        },
        {
            1,
            'Map',
            'HiddenInCombat',
            L['Hidden in Combat'],
            true,
            nil,
            UpdateMinimapFader,
            L['Hide minimap automatically after enter combat and restores it after leave combat.'],
        },
    },
    [10] = { -- tooltip
        { 1, 'Tooltip', 'Enable', L['Enable Tooltip'] },
        {
            1,
            'Tooltip',
            'FollowCursor',
            L['Follow Cursor'],
        },
        {
            1,
            'Tooltip',
            'HideInCombat',
            L['Hide in Combat'],
            true,
        },
        {},
        { 1, 'Tooltip', 'ShowIDs', L['Show Spell&Item IDs'] },
        {
            1,
            'Tooltip',
            'ShowIDsByAlt',
            L['Show Spell&Item IDs by ALT'],
            true,
        },
        {
            1,
            'Tooltip',
            'ItemInfo',
            L['Show Extra Item Info'],
        },
        {
            1,
            'Tooltip',
            'ItemInfoByAlt',
            L['Show Extra Item Info by ALT'],
            true,
        },
        {},
        { 1, 'Tooltip', 'SpecIlvl', L['Show Spec&iLvl'] },
        {
            1,
            'Tooltip',
            'MythicPlusScore',
            L['Show Mythic Plus Score'],
            true,
        },
        { 1, 'Tooltip', 'Covenant', L['Show Covenant'] },
        {
            1,
            'Tooltip',
            'PlayerInfoByAlt',
            L['Show Spec&iLvl&Coven by ALT'],
            true,
        },
        { 1, 'Tooltip', 'HideRealm', L['Hide Realm'] },
        {
            1,
            'Tooltip',
            'HideTitle',
            L['Hide Title'],
            true,
        },
        {
            1,
            'Tooltip',
            'HideGuildRank',
            L['Hide Guild Rank'],
        },
        {},
        { 1, 'Tooltip', 'Icon', L['Show icon'] },
        {
            1,
            'Tooltip',
            'BorderColor',
            L['Show Border Color'],
            true,
        },
        {
            1,
            'Tooltip',
            'HealthValue',
            L['Show Health Value'],
        },
        {
            1,
            'Tooltip',
            'TargetedBy',
            L['Show Unit Targeted By'],
            true,
        },
    },
    [11] = { -- unitframe
        {
            1,
            'Unitframe',
            'Enable',
            L['Enable Unitframe'],
            nil,
            SetupUnitFrame,
        },

        {
            4,
            'ACCOUNT',
            'UnitframeTextureIndex',
            L['Texture Style'],
            nil,
            {},
        },
        {
            2,
            'ACCOUNT',
            'UnitframeCustomTexture',
            L['Custom Texture'],
            true,
            nil,
            nil,
            L["Put your texture under 'Interface' folder, and input the texture name here to replace texture style.|nIncorrect texture would present as green block, you might need to restart your game client.|nLeave the editbox empty to disable custom texture. Require UI reload."],
        },
        {
            4,
            'Unitframe',
            'ColorStyle',
            L['Health Color'],
            nil,
            {
                L['Default Black'],
                L['Class Color'],
                L['Percentage Gradient'],
                L['rainbow'],
                L['clear class color'],
                L['clear gradient'],
            },
            UpdateHealthColor,
        },
        {
            1,
            'Unitframe',
            'InvertedColorMode',
            L['Inverted Color Mode'],
            nil,
            nil,
            nil,
            L['The health bar color and the background color are inverted.|nThe unitframe module is designed based on the Inverted Color Mode, which may cause some visual problems if disabled.'],
        },
        {
            1,
            'Unitframe',
            'Smooth',
            L['Smooth'],
            true,
            nil,
            nil,
            L['Smoothly animate unit frame bars.'],
        },

        {
            1,
            'Unitframe',
            'Fader',
            L['Conditional Visibility'],
            nil,
            SetupUnitFrameFader,
            UpdateFader,
            L['The unitframe is hidden by default and shown according to specific conditions.'],
        },
        {
            1,
            'Unitframe',
            'RangeCheck',
            L['Range Check'],
            true,
            SetupUnitFrameRangeCheck,
            nil,
            L["Fade out unit frame based on whether the unit is in the player's range."],
        },
        {
            1,
            'Unitframe',
            'Portrait',
            L['Portrait'],
            nil,
            nil,
            UpdatePortrait,
            L['Show dynamic portrait on unit frame.'],
        },
        {
            1,
            'Unitframe',
            'GCDIndicator',
            L['GCD Indicator'],
            true,
            nil,
            UpdateGCDTicker,
            L['Show global cooldown ticker above the player frame.'],
        },
        {
            1,
            'Unitframe',
            'AbbrName',
            L['Abbreviate Name'],
            nil,
            nil,
            UpdateUnitTags,
        },
        {
            1,
            'Unitframe',
            'ClassPower',
            L['Class Power'],
            true,
            SetupClassPower,
            UpdateClassPower,
            L['Show special resources of the class, such as Combo Points, Holy Power, Chi, Runes, etc.'],
        },
        {
            1,
            'Unitframe',
            'HidePlayerTags',
            L['Hide Player Tags'],
            nil,
            nil,
            UpdateUnitTags,
            L['Only show player tags on mouseover.'],
        },
        {},
        {
            1,
            'Unitframe',
            'OnlyShowPlayer',
            L['Debuffs by You Only'],
            nil,
            nil,
            nil,
            L['Display debuffs cast by you only.'],
        },
        {
            1,
            'Unitframe',
            'DesaturateIcon',
            L['Desaturate Debuffs Icon'],
            true,
            nil,
            nil,
            L['Desaturate debuff icons cast by others.'],
        },
        {
            1,
            'Unitframe',
            'DebuffTypeColor',
            L['Debuffs Type Color'],
            nil,
            nil,
            nil,
            L['Color debuffs border by type.|nMagic is blue, Curse is purple, Poison is green, Disease is yellow, and others are red.'],
        },
        {
            1,
            'Unitframe',
            'StealableBuffs',
            L['Display Dispellable Buffs'],
            true,
        },
        {},
        {
            1,
            'Unitframe',
            'Castbar',
            L['Enable Castbar'],
            nil,
            SetupCastbarColor,
            nil,
            L['Uncheck this if you want to use other castbar addon.'],
        },
        {
            1,
            'Unitframe',
            'SeparateCastbar',
            L['Separate Castbar'],
            true,
            SetupCastbar,
            nil,
            L['If disabled, the castbar will be overlapped on the healthbar.|nNote that the spell name and time are only available with separate castbar.'],
        },
        {},
        {
            1,
            'Unitframe',
            'Boss',
            L['Enable boss frames'],
            nil,
            SetupBossFrame,
            nil,
            L['Uncheck this if you want to use other BossFrame addon.'],
        },
        {
            1,
            'Unitframe',
            'Arena',
            L['Enable arena frames'],
            true,
            SetupArenaFrame,
            nil,
            L['Uncheck this if you want to use other ArenaFrame addon.'],
        },
    },
    [12] = { -- groupframe
        {
            1,
            'Unitframe',
            'RaidFrame',
            L['Enable RaidFrame'],
            nil,
            SetupRaidFrame,
        },
        {
            1,
            'Unitframe',
            'SimpleMode',
            L['Simple Mode'],
            nil,
            SetupSimpleRaidFrame,
            nil,
            L['Simple mode remove most of the elements, and only show unit health status.'],
        },
        {
            1,
            'Unitframe',
            'TeamIndex',
            L['Display Team Index'],
            true,
            nil,
            UpdateRaidHeader,
        },
        {
            1,
            'Unitframe',
            'RaidBuff',
            L['Display Buffs'],
            nil,
            SetupRaidBuff,
            UpdateGroupAuras,
            L['Display buffs on RaidFrame by blizzard API logic, up to 3 icons.|nThis may overlap with the Corner Indicator and is best not enabled at the same time.'],
        },
        {
            1,
            'Unitframe',
            'RaidDebuff',
            L['Display Debuffs'],
            true,
            SetupRaidDebuff,
            UpdateGroupAuras,
            L['Display debuffs on RaidFrame by blizzard API logic, up to 3 icons.|nThis may overlap with the Corner Indicator and is best not enabled at the same time.'],
        },
        {},
        {
            1,
            'Unitframe',
            'PartyFrame',
            L['Enable PartyFrame'],
            nil,
            SetupPartyFrame,
        },
        {
            1,
            'Unitframe',
            'ShowSolo',
            L['Display PartyFrame on Solo'],
            true,
            nil,
            UpdateAllHeaders,
            L['If checked, the PartyFrame would be visible even you are solo.'],
        },
        {
            1,
            'Unitframe',
            'DescRole',
            L['Sort by Reverse Roles'],
            nil,
            nil,
            UpdatePartyHeader,
            L["If checked, sort your party order by 'Damager Healer Tank' within growth direction.|nIf unchecked, sort your party order by 'Tank Healer Damager' within growth direction."],
        },
        {
            1,
            'Unitframe',
            'PartyAura',
            L['Display Important Auras'],
            true,
            SetupPartyAura,
            nil,
            L['Display the important offensive and defensive spells, displayed by default on the right side of the PartyFrame.'],
        },
        {
            1,
            'Unitframe',
            'PartyBuff',
            L['Display Buffs'],
            nil,
            SetupPartyBuff,
            UpdateGroupAuras,
            L['Display buffs on PartyFrame by blizzard API logic, up to 3 icons, displayed by default in the inner top left of the PartyFrame.|nThis may overlap with the Corner Indicator and is best not enabled at the same time.'],
        },
        {
            1,
            'Unitframe',
            'PartyDebuff',
            L['Display Debuffs'],
            true,
            SetupPartyDebuff,
            UpdateGroupAuras,
            L['Display debuffs on PartyFrame by blizzard API logic, up to 3 icons, displayed by default in the inner bottom right of the PartyFrame.|nThis may overlap with the Corner Indicator and is best not enabled at the same time.'],
        },
        {
            1,
            'Unitframe',
            'PartyWatcher',
            L['Enable Party Watcher'],
            nil,
            SetupPartyWatcher,
            nil,
            L['Display the spell cooldowns of party members, displayed by default on the left side of the PartyFrame.'],
        },
        {
            1,
            'Unitframe',
            'PartyWatcherOnRight',
            L['Swap Icons Side'],
            nil,
            nil,
            UpdatePartyElements,
            L['Icons are displayed on the other side of the PartyFrame.'],
        },
        {
            1,
            'Unitframe',
            'PartyWatcherSync',
            L['Sync Party Watcher'],
            true,
            nil,
            nil,
            L["Sync the cooldown status with players who using 'AndromedaUI' or 'WeakAuras ZenTracker'."],
        },
        {},
        {
            1,
            'Unitframe',
            'GroupName',
            L['Display Group Member Name'],
            nil,
            SetupNameLength,
            UpdateGroupTags,
        },
        {
            1,
            'Unitframe',
            'GroupRole',
            L['Display Role Indicator'],
            true,
            nil,
            UpdateGroupTags,
            L["The indicator at the bottom of the GroupFrame represents the role of that player.|nThe blue '#' is tank, the green '+' is healer, and the red '*' is damager."],
        },
        {
            1,
            'Unitframe',
            'GroupLeader',
            L['Display Leader Indicator'],
            nil,
            nil,
            UpdateGroupTags,
            L['The indicator at the upper left corner of the GroupFrame indicates that the player is the leader.'],
        },
        {
            1,
            'Unitframe',
            'RaidTargetIndicator',
            L['Display Raid Target Indicator'],
            true,
            nil,
            UpdateRaidTargetIndicator,
            L['Display raid target indicator on GroupFrame.'],
        },
        {
            1,
            'Unitframe',
            'CornerIndicator',
            L['Display Corner Indicator'],
            nil,
            nil,
            nil,
            L["Display important auras in color blocks at the corner of the GroupFrame, such as healer's HoT Paladin's 'Forbearance' and Priest's 'Weakened Soul', etc."],
        },
        {
            1,
            'Unitframe',
            'ThreatIndicator',
            L['Display Threat Indicator'],
            true,
            nil,
            nil,
            L['The glow on the outside of the PartyFrame represents the threat status.'],
        },
        {
            1,
            'Unitframe',
            'PositionBySpec',
            L['Save Postion by Spec'],
            nil,
            nil,
            nil,
            L['Save the position of the GroupFrame separately according to the specialization.'],
        },
        {
            1,
            'Unitframe',
            'SmartRaid',
            L['Smart GroupFrame'],
            true,
            nil,
            UpdateAllHeaders,
            L['Only show RaidFrame if there are more than 5 members in your group.|nIf disabled, show RaidFrame when in raid, show PartyFrame when in party.'],
        },
        {},
        {
            1,
            'Unitframe',
            'DebuffWatcher',
            L['Enable Debuff Watcher'],
        },
        {
            1,
            'Unitframe',
            'InstanceDebuffs',
            L['Monitor Instance Debuffs'],
            true,
            SetupDebuffWatcher,
            nil,
            L['Display major debuffs in raid and dungeons.|nYou can customize which debuffs are monitored, and their priority.'],
        },
        {
            1,
            'Unitframe',
            'DispellableOnly',
            L['Display Dispellable Debuffs Only'],
            nil,
            nil,
            nil,
            L['Display only the debuffs you can dispel.'],
        },
        {
            1,
            'Unitframe',
            'DebuffClickThrough',
            L['Disable Icon Tooltip'],
            true,
            nil,
            nil,
            L['Debuff Icon ignore mouse hover and do not show tooltip.'],
        },
    },
    [13] = { -- nameplate
        {
            1,
            'Nameplate',
            'Enable',
            L['Enable Nameplate'],
            nil,
            SetupNameplateSize,
            nil,
            L['Uncheck this if you want to use another nameplate addon.'],
        },
        {
            4,
            'ACCOUNT',
            'NameplateTextureIndex',
            L['Texture Style'],
            nil,
            {},
        },
        {
            2,
            'ACCOUNT',
            'NameplateCustomTexture',
            L['Custom Texture'],
            true,
            nil,
            nil,
            L["Put your texture under 'Interface' folder, and input the texture name here to replace texture style.|nIncorrect texture would present as green block, you might need to restart your game client.|nLeave the editbox empty to disable custom texture. Require UI reload."],
        },
        {
            1,
            'Nameplate',
            'ForceCVars',
            L['Override CVars'],
            nil,
            SetupNameplateCVars,
            UpdateNamePlateCVars,
            L['Forcefully override the CVars related to the nameplate.'],
        },
        {
            1,
            'Nameplate',
            'NameOnlyMode',
            L['Name Only Mode'],
            true,
            nil,
            nil,
            L["Friendly units' nameplate only display the enlarged name and hide the health bar."],
        },
        {
            1,
            'Nameplate',
            'AbbrName',
            L['Abbreviate Name'],
            nil,
            nil,
            UpdateNamePlateTags,
            L["Abbreviat nameplate name, e.g. 'Lady Sylvanas Windrunner' convert to 'L. S. Windrunner'. |nNot valid for Chinese game client."],
        },
        {
            1,
            'Nameplate',
            'ShortenName',
            L['Shorten Name'],
            true,
            SetupNameplateNameLength,
            UpdateNamePlateTags,
            L['Limit the maximum length of the nameplate name.'],
        },
        {
            1,
            'Nameplate',
            'FriendlyPlate',
            L['Friendly Nameplate Size'],
            nil,
            SetupNameplateFriendlySize,
            RefreshAllPlates,
            L["Set size separately for friendly units' nameplate.|nIf disabled, friendly units' nameplate will use the same size setting as the hostile units' nameplate."],
        },
        {
            1,
            'Nameplate',
            'FriendlyClickThrough',
            L['Friendly Click Through'],
            true,
            nil,
            UpdatePlateClickThrough,
            L["Friendly units' nameplate ignore mouse click."],
        },
        {
            1,
            'Nameplate',
            'EnemyClickThrough',
            L['Enemy Click Through'],
            nil,
            nil,
            UpdatePlateClickThrough,
            L["Hostile units' nameplate ignore mouse clicks."],
        },
        {
            4,
            'Nameplate',
            'NameTagType',
            L['Name Tag'],
            nil,
            {
                _G.NAME,
                _G.LEVEL .. ' ' .. _G.NAME,
                L['Classification'] .. ' ' .. _G.LEVEL .. ' ' .. _G.NAME,
                L['Classification'] .. ' ' .. _G.NAME,
                _G.DISABLE,
            },
            UpdateNamePlateTags,
            L['The classification tag supports three types: Rare, Elite and Boss. |nRare is white, Elite is yellow, and Boss is red.|nWhen the unit has the same level as you, the level tag will be hidden.'],
        },
        {
            4,
            'Nameplate',
            'HealthTagType',
            L['Health Tag'],
            true,
            {
                L['Current | Percent'],
                L['Current | Max'],
                L['Current Value'],
                L['Current Percent'],
                L['Loss Value'],
                L['Loss Percent'],
                _G.DISABLE,
            },
            UpdateNamePlateTags,
            L['The percentage will be hidden when the health value is full.'],
        },

        {},

        {
            1,
            'Nameplate',
            'ShowAura',
            L['Display Auras'],
            nil,
            SetupAuraFilter,
            RefreshAllPlates,
            L['Display auras on nameplate.|nYou can use BLACKLIST and WHITELIST to filter specific auras.'],
        },
        {
            1,
            'Nameplate',
            'DesaturateIcon',
            L['Desaturate Debuffs Icon'],
            true,
            nil,
            RefreshAllPlates,
            L['Desaturate debuff icons cast by others.'],
        },
        {
            1,
            'Nameplate',
            'DebuffTypeColor',
            L['Debuffs Type Color'],
            nil,
            nil,
            RefreshAllPlates,
            L['Color debuffs border by type.|nMagic is blue, Curse is purple, Poison is green, Disease is yellow, and others are red.'],
        },
        {
            1,
            'Nameplate',
            'DisableMouse',
            L['Disable Tooltip'],
            true,
            nil,
            RefreshAllPlates,
            L['Disable tooltip on auras.'],
        },
        {
            4,
            'Nameplate',
            'DispellMode',
            L['Dispellable Buffs'],
            nil,
            { L['Filter Display'], L['Always Display'], _G.DISABLE },
            RefreshAllPlates,
            L['Filter Display: Only show dispellable Magic and Enrage buffs that you can dispell.|nAlways Display: Always show dispellable Magic and Enrage buffs, whether you can dispel them or not.'],
        },
        {
            4,
            'Nameplate',
            'AuraFilterMode',
            L['Aura Filter Mode'],
            true,
            {
                L['Black & White List'],
                L['List & Player'],
                L['List & Player & CC'],
            },
            RefreshAllPlates,
            L['Black & White List: Strictly follow Black and White list filter.|nPlayer: Spells cast by YOU. |nCC: Spells of Crowd Control.'],
        },
        {
            3,
            'Nameplate',
            'AuraPerRow',
            L['Auras Per Row'],
            nil,
            { 4, 10, 1 },
            RefreshAllPlates,
            L['The number of auras displayed in per row.'],
        },
        {},
        {
            1,
            'Nameplate',
            'ExecuteIndicator',
            L['Execute Indicator'],
            nil,
            SetupNameplateExecuteIndicator,
            nil,
            L["If the unit's health percentage falls below the threshold you set, the color of its name will change to red."],
        },
        {
            1,
            'Nameplate',
            'SelectedIndicator',
            L['Selected Indicator'],
            true,
            nil,
            nil,
            L['The currently selected unit has a white glow at the bottom of its nameplate.'],
        },
        {
            1,
            'Nameplate',
            'QuestIndicator',
            L['Quest Indicator'],
            nil,
            nil,
            nil,
            L['Display quest mark and quest progress on the right side of the nameplate.'],
        },
        {
            1,
            'Nameplate',
            'ClassifyIndicator',
            L['Classify Indicator'],
            true,
            nil,
            nil,
            L['The mob type indicator is displayed on the left side of the nameplate, and the supported types are BOSS, ELITE and RARE.'],
        },
        {
            1,
            'Nameplate',
            'RaidTargetIndicator',
            L['Raid Target Indicator'],
            nil,
            nil,
            UpdateNameplateRaidTargetIndicator,
            L['Display raid target indicator on nameplate.'],
        },
        {
            1,
            'Nameplate',
            'ThreatIndicator',
            L['Threat Indicator'],
            true,
            nil,
            nil,
            L['The color of the glow above the nameplate represents the threat status of the unit.'],
        },
        {
            1,
            'Nameplate',
            'TotemIcon',
            L['Totme Indicator'],
            nil,
            nil,
            nil,
            L["Display its icon on the totem's nameplate."],
        },
        {},
        {
            1,
            'Nameplate',
            'ExplosiveIndicator',
            L['Explosive Indicator'],
            nil,
            nil,
            nil,
            L['Magnifies the nameplate of Explosive when in a mythic plus dungeon.'],
        },
        {
            1,
            'Nameplate',
            'SpitefulIndicator',
            L['Spiteful Indicator'],
            true,
            nil,
            nil,
            L['Display the name of the target Spiteful Shade is currently tracking when in mythic plus dungeon.'],
        },
        {},
        {
            1,
            'Nameplate',
            'Castbar',
            L['Enable Castbar'],
            nil,
            nil,
            nil,
            L['Enable castbar on nameplate.'],
        },
        {
            1,
            'Nameplate',
            'SeparateCastbar',
            L['Separate Castbar'],
            true,
            SetupNameplateCastbarSize,
            nil,
            L['If disabled, the castbar will be overlapped on the healthbar.|nNote that the spell name and time are only available with separate castbar.'],
        },
        {
            1,
            'Nameplate',
            'TargetName',
            L['Spell Target'],
            nil,
            nil,
            nil,
            L['Display the name of target if unit is casting.'],
        },
        {
            1,
            'Nameplate',
            'MajorSpellsGlow',
            L['Major Spells Highlight'],
            true,
            SetupNameplateMajorSpells,
            nil,
            L['Highlight the castbar icon if unit is casting a major spell.'],
        },
        {},
        {
            1,
            'Nameplate',
            'FriendlyClassColor',
            L['Color Friendly Unit By Class'],
            nil,
            nil,
            nil,
            L["Color friendly units' nameplate by class."],
        },
        {
            1,
            'Nameplate',
            'HostileClassColor',
            L['Color Hostile Unit By Class'],
            true,
            nil,
            nil,
            L["Color hostile units' nameplate by class."],
        },
        {
            1,
            'Nameplate',
            'ColoredTarget',
            L['Color Target Unit'],
            nil,
            nil,
            nil,
            L['Color your current target, its priority is higher than special unit color and threat color.'],
        },
        {
            5,
            'Nameplate',
            'TargetColor',
            L['Target Color'],
            2,
        },
        {
            1,
            'Nameplate',
            'ColoredFocus',
            L['Color Focus Unit'],
            nil,
            nil,
            nil,
            L['Color your current focus, its priority is higher than special unit color and threat color.'],
        },

        {
            5,
            'Nameplate',
            'FocusColor',
            L['Focus Color'],
            2,
        },
        {
            1,
            'Nameplate',
            'TankMode',
            L['Force Tank Mode Color'],
            nil,
            nil,
            nil,
            L['Nameplate health color present its threat status for non-tank classes, instead of glow color.|nFor special units, the threat status remains on nameplate glow.'],
        },
        {
            1,
            'Nameplate',
            'RevertThreat',
            L['Revert Threat Color'],
            true,
            nil,
            nil,
            L["If 'Force Tank Mode Color' enabled, swap their threat status color for non-tank classes."],
        },
        {
            5,
            'Nameplate',
            'SecureColor',
            L['Secure'],
        },
        {
            5,
            'Nameplate',
            'TransColor',
            L['Transition'],
            1,
        },
        {
            5,
            'Nameplate',
            'InsecureColor',
            L['Insecure'],
            2,
        },
        {
            5,
            'Nameplate',
            'OffTankColor',
            L['Co-Tank'],
            3,
        },
        {
            1,
            'Nameplate',
            'ShowSpecialUnits',
            L['Color Special Units'],
            nil,
            SetupNameplateUnitFilter,
            RefreshSpecialUnitsList,
            L['Color special units nameplate by custom color.|nYou can customize the color and the units list to match your requirement.'],
        },
        {
            1,
            'Nameplate',
            'ColorByDot',
            L['Color Units by Debuff'],
            true,
            SetupNameplateColorByDot,
            nil,
            L['Color units nameplate that affected by your specific debuff.|nYou can customize the color and the debuff list to match your requirement.'],
        },
    },
    [14] = { -- theme
        {
            1,
            'ACCOUNT',
            'ShadowOutline',
            L['Widget Shadow Border'],
            nil,
            nil,
            nil,
            L['Enable shadow border on UI widgets.'],
        },
        {
            1,
            'ACCOUNT',
            'GradientStyle',
            L['Widget Gradient Style'],
            true,
            nil,
            nil,
            L['Enable gradient style on UI widgets.'],
        },
        {
            1,
            'ACCOUNT',
            'ButtonHoverAnimation',
            L['Button Hover Animation'],
            nil,
            nil,
            nil,
            L['Enable animation effect when mouse hover over the button-like UI widgets.'],
        },
        {
            1,
            'ACCOUNT',
            'WidgetHighlightClassColor',
            L['Widget Class Color'],
            true,
            nil,
            nil,
            L['Color UI widgets highlight effect by class.'],
        },
        {
            1,
            'ACCOUNT',
            'ReskinBlizz',
            L['Restyle Blizzard Frames'],
            nil,
            nil,
            nil,
            L['Restyle default blizzard frames.'],
        },

        {
            5,
            'ACCOUNT',
            'BackdropColor',
            L['Frame Backdrop Color'],
        },
        {
            5,
            'ACCOUNT',
            'BorderColor',
            L['Frame Border Color'],
            2,
        },
        {
            5,
            'ACCOUNT',
            'ButtonBackdropColor',
            L['Widget Backdrop Color'],
        },
        {
            5,
            'ACCOUNT',
            'WidgetHighlightColor',
            L['Widget Highlight Color'],
            2,
        },
        {
            3,
            'ACCOUNT',
            'BackdropAlpha',
            L['Frame Backdrop Alpha'],
            nil,
            { 0, 1, 0.01 },
            UpdateBackdropAlpha,
        },
        {
            3,
            'ACCOUNT',
            'ButtonBackdropAlpha',
            L['Widget Backdrop Alpha'],
            true,
            { 0, 1, 0.01 },
        },
        {},

        {
            1,
            'ACCOUNT',
            'ReskinDeadlyBossMods',
            L['Reskin Deadly Boss Mods (DBM)'],
        },
        {
            1,
            'ACCOUNT',
            'ReskinBigWigs',
            L['Reskin BigWigs & LittleWigs'],
            true,
        },
        {
            1,
            'ACCOUNT',
            'ReskinWeakAuras',
            L['Reskin WeakAuras'],
        },
        {
            1,
            'ACCOUNT',
            'ReskinMethodRaidTools',
            L['Reskin Method Raid Tools (MRT)'],
            true,
        },
        {
            1,
            'ACCOUNT',
            'ReskinDetails',
            L['Reskin Details Damage Meter'],
        },
        {
            1,
            'ACCOUNT',
            'ReskinImmersion',
            L['Reskin Immersion'],
            true,
        },
        {
            1,
            'ACCOUNT',
            'ReskinOpie',
            L['Reskin Opie'],
        },
        {
            1,
            'ACCOUNT',
            'ReskinPremadeGroupsFilter',
            L['Reskin Premade Groups Filter'],
            true,
        },
        {
            1,
            'ACCOUNT',
            'ReskinREHack',
            L['Reskin REHack'],
        },
    },
    [15] = {},
    [16] = {},
    [17] = {},
}
