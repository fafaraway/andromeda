local _, ns = ...


ns.localization = {}
ns.localization.general = {}
ns.localization.theme = {}
ns.localization.infobar = {}
ns.localization.chat = {}
ns.localization.aura = {}
ns.localization.actionbar = {}
ns.localization.inventory = {}
ns.localization.map = {}
ns.localization.quest = {}
ns.localization.tooltip = {}
ns.localization.unitFrame = {}
ns.localization.notification = {}
ns.localization.misc = {}
ns.localization.credit = {}


local L = ns.localization


ns.localization.misc = {
	reset = "Reset",
	install = "Install",
	profile = "Character-specific settings",
	profile_tip = "Switch between a profile that applies to all characters and one that is unique to this character.",
	profile_check = "|cffff2020Are you sure you want to switch profile setting?|r",
	reload_check = "|cffff2020You need to reload the UI to apply your changes.\nWould you like to do so now?|r",
	need_reload = "|cffff2020Reload Required!|r",
	reset_check = "|cffff2020Remove all saved options, and reset them to their default values!|r",
}

ns.localization.credit = {
	credit = 'Credits',
	header = "Credits",
	body = "Haleth, siweia\nAlza, Haste, Tukz, Zork\nAllez, AlleyKat, Caellian, p3lim, Shantalya, tekkub, Tuller, Wildbreath\nShestak, aliluya555, Paojy, Rubgrsch"
}

ns.localization.general = {
	header = "General",
	desc = "These options control most of the common settings in the UI.",
	sub_basic = "Basic",
	flashCursor = 'Flash cursor',
	flashCursor_tip = 'Adds a star at the cursor, with size proportional to the cursor speed.',
	vignetting = "Vignetting",
	vignetting_tip = "Adds a shadow overlay to screen edge."
}

ns.localization.aura = {
	header = "Aura",
	desc = "These options control aura related settings.",
	sub_basic = "Basic",
	enable = "Enable",
	enable_tip = "Enable aura module.",
	reverseBuffs = "Reverse buffs growth",
	reverseDebuffs = "Reverse debuffs growth",
	reminder = "Reminder",
	reminder_tip = "Reminds you when lack of your own class spell.\nSupports stamina, poisons, intellect.",
	sub_size = "Adjustment",
	buffSize = "Buff icons size",
	debuffSize = "Debuff icons size",
	buffsPerRow = "Buffs per row",
	debuffsPerRow = "Debuffs per row",
	margin = "Aura icons margin",
	offset = "Gap",
}



L.General = "General"
L.General_subText = "These options control most of the common settings in the UI."
L.General_subCategory_basic = "Basic"
L.General_mailButton = "Mail button"
L.General_mailButton_tooltip = "Adds a button to the mail frame to collect all mail attachments with one click."
L.General_alreadyKnown = "Already known"
L.General_alreadyKnown_tooltip = "Colorizes recipes/mounts/pets/toys that is already known."
L.General_enhancedMenu = "Target menu"
L.General_enhancedMenu_tooltip = "Adds copy name and guild invite into target menu."
L.General_helmCloak = "Helm cloak button"
L.General_helmCloak_tooltip = "Adds buttons on character frame to quickly show or hide helm and cloak."
L.General_marker = "Easy mark"
L.General_marker_tooltip = "Easy marking by alt + left click."
L.General_PVPSound = "PVP sound"
L.General_PVPSound_tooltip = "Adds DOTA like sound effect for PVP killing."
L.General_subCategory_camera = "Camera"
L.General_cameraZoomSpeed = "Zoom speed"
L.General_cameraZoomSpeed_tooltip = "Adjust camera zoom speed."
L.General_subCategory_uiscale = "UI scale"
L.General_uiScaleAuto = "Force optimal UI scale"
L.General_uiScaleAuto_tooltip = "Automatically apply the best UI scale for current resolution."
L.General_uiScale = "Customize UI scale"
L.General_autoDismount = "Auto dismount"
L.General_autoDismount_tooltip = "Automatically dismount when you attack cast or use item."
L.General_quickBuy = "Quick buy"
L.General_quickBuy_tooltip = "Buy a stack by alt + left click."



L.appearance = "Appearance"
L.appearance_subText = "You can change the appearance of various aspects of the UI here."
L.appearance_subCategory_basic = "Basic"
L.appearance_themes = "Global theme"
L.appearance_themes_tooltip = "Make blizz frames clean and pretty."
L.appearance_backdropAlpha = "Theme opacity"
L.appearance_backdropAlpha_tooltip = "Adjust theme opacity."
L.appearance_vignette = "Vignette"
L.appearance_vignette_tooltip = "Adds a shadow overlay to screen edge."
L.appearance_vignetteAlpha = "Vignette opacity"
L.appearance_vignetteAlpha_tooltip = "Adjust vignette opacity"
L.appearance_addShadowBorder = "Shadow border"
L.appearance_addShadowBorder_tooltip = "Adds smooth shadow border to most of UI elements."
L.appearance_addGradient = "Gradient"
L.appearance_addGradient_tooltip = "Adds gradient on some UI elements."
L.appearance_subCategory_misc = "Misc"
L.appearance_flashCursor = "Flash cursor"
L.appearance_flashCursor_tooltip = "Adds a star at the cursor, with size proportional to the cursor speed."
L.appearance_subCategory_font = "Fonts"
L.appearance_adjustFonts = "Adjust fonts"
L.appearance_adjustFonts_tooltip = "Adjust default fonts size."
L.appearance_usePixelFont = "Use pixel font"
L.appearance_usePixelFont_tooltip = "Use pixel font on some of UI elements."
L.appearance_subCategory_addons = "AddOns"
L.appearance_BigWigs = "BigWigs"
L.appearance_BigWigs_tooltip = "Customize BigWigs time bars."
L.appearance_WeakAuras = "WeakAuras"
L.appearance_WeakAuras_tooltip = "Customize WeakAuras icons."
L.appearance_QuestLogEx = "QuestLog"
L.appearance_QuestLogEx_tooltip = "Customize quest log related addons."



L.notification = "Notification"
L.notification_subText = "These options let you choose when and how the UI should show notifications."
L.notification_subCategory_banner = "Basic"
L.notification_enableBanner = "Notify banner"
L.notification_enableBanner_tooltip = "Allow notifications to be shown, a banner will appear at the top of the UI."
L.notification_playSounds = "Play sound"
L.notification_playSounds_tooltip = "Play a sound when a notification is shown."
L.notification_checkMail = "New mail"
L.notification_checkMail_tooltip = "Show a notification when you have new mail."
L.notification_checkBagsFull = "Bags full"
L.notification_checkBagsFull_tooltip = "Show a notification when your bags are full."
L.notification_autoRepair = "Auto repair"
L.notification_autoRepair_tooltip = "Show a notification when you finished automatically repair."
L.notification_autoSellJunk = "Auto sell junk"
L.notification_autoSellJunk_tooltip = "Show a notification when you finished automatically sell junks."
L.notification_subCategory_combat = "Combat"
L.notification_combatAlert = "Combat alert"
L.notification_combatAlert_tooltip = "Adds some alerts for cambat situation."
L.notification_enterCombat = "Combat status"
L.notification_enterCombat_tooltip = "Show alert for enter or leave cambat."
L.notification_interruptSound = "Interrupt"
L.notification_interruptSound_tooltip = "Plays a sound when you successfully interrupt."
L.notification_interruptAnnounce = "Interrupt announcement"
L.notification_interruptAnnounce_tooltip = "Announces when you successfully interrupt(only inside dungeons)."
L.notification_dispelSound = "Dispel"
L.notification_dispelSound_tooltip = "Plays a sound when you successfully dispel."
L.notification_dispelAnnounce = "Dispel announcement"
L.notification_dispelAnnounce_tooltip = "Announces when you successfully dispel(only inside dungeons)."
L.notification_lowHPSound = "Low health"
L.notification_lowHPSound_tooltip = "Plays a sound when your health is low."
L.notification_lowMPSound = "Low mana"
L.notification_lowMPSound_tooltip = "Plays a sound when your mana is low."
L.notification_lowHPThreshold = "Health threshold"
L.notification_lowHPThreshold_tooltip = "Health threshold."
L.notification_lowMPThreshold = "Mana threshold"
L.notification_lowMPThreshold_tooltip = "Mana threshold."



L.infobar = "Infobar"
L.infobar_subText = "The infobar is the panel at the top of the screen. \nMoving your mouse over it reveals additional functionality and information."
L.infobar_subCategory_cores = "Basic"
L.infobar_enable = "Enable infobar"
L.infobar_enable_tooltip = "Enable infobar."
L.infobar_mouseover = "Mouseover"
L.infobar_mouseover_tooltip = "Only show the blocks when moving the cursor over the infobar."
L.infobar_stats = "Time/FPS/Latency"
L.infobar_stats_tooltip = "Show time/FPS/latency informations."
L.infobar_talent = "Talent"
L.infobar_talent_tooltip = "Show spent points on talent."
L.infobar_friends = "Friends"
L.infobar_friends_tooltip = "Show friends informations."
L.infobar_gold = "Gold"
L.infobar_gold_tooltip = "Show gold and count.\nLeft click to enable auto sell junk."
L.infobar_durability = "Durability"
L.infobar_durability_tooltip = "Show gears durability.\nLeft click to enable auto repair."
L.infobar_usePixelFont = "Pixel font"
L.infobar_usePixelFont_tooltip = "Use pixel font on infobar."



L.Actionbar = "Actionbar"
L.Actionbar_subText = "These options are specific to the action bars and their buttons."
L.Actionbar_subCategory_basic = "Basic"
L.Actionbar_enable = "Enable actionbars"
L.Actionbar_enable_tooltip = "Uncheck if you want to use another actionbars addon."
L.Actionbar_layoutStyle = "Bars layout"
L.Actionbar_layoutStyle1 = "Default (3*12)"
L.Actionbar_layoutStyle2 = "Divide bar3 on side (2*18)"
L.Actionbar_layoutStyle3 = "Minimalist (hide all actionbars)"
L.Actionbar_subCategory_extra = "Extra"
L.Actionbar_sideBar = "Side bar"
L.Actionbar_sideBar_tooltip = "Show side bar."
L.Actionbar_sideBarMouseover = "Mouseover."
L.Actionbar_petBar = "Pet bar"
L.Actionbar_petBar_tooltip = "Show pet bar"
L.Actionbar_petBarMouseover = "Mouseover"
L.Actionbar_stanceBar = "Stance bar"
L.Actionbar_stanceBar_tooltip = "Show stance bar."
L.Actionbar_stanceBarMouseover = "Mouseover"
L.Actionbar_bar3 = "Bar3"
L.Actionbar_bar3_tooltip = "Show bar3."
L.Actionbar_bar3Mouseover = "Mouseover"
L.Actionbar_subCategory_feature = "Misc"
L.Actionbar_hotKey = "Show hotkeys"
L.Actionbar_macroName = "Show macro names"
L.Actionbar_count = "Show item count"
L.Actionbar_classColor = "Colored by class"
L.Actionbar_subCategory_bind = "Bind"
L.Actionbar_hoverBind = "Easy binding"
L.Actionbar_hoverBind_tooltip = "Type /hb then bind buttons on mouseover."
L.Actionbar_subCategory_size = "Size"
L.Actionbar_buttonSizeNormal = "main bars size"
L.Actionbar_buttonSizeNormal_tooltip = "bar1/bar2/bar3 buttons size."
L.Actionbar_buttonSizeSmall = "small bars size"
L.Actionbar_buttonSizeSmall_tooltip = "Side bars and pet bar buttons size."
L.Actionbar_buttonSizeBig = "big bars size"
L.Actionbar_buttonSizeBig_tooltip = "Stance bar buttons size."


L.cooldown = "Cooldown"
L.cooldown_subText = "These options control cooldowns."
L.cooldown_subCategory_basic = "Basic"
L.cooldown_CDEnhancement = "Enable cooldown"
L.cooldown_CDEnhancement_tooltip = "Show cooldown count."
L.cooldown_CDFontSize = "Font size"
L.cooldown_CDPulse = "Cooldown pulse"
L.cooldown_CDPulse_tooltip = "Flashes the icon of the ability or item in the middle of screen whenever it finish cooldown."





ns.localization.inventory = {
	header = "Inventory",
	desc = "Choose and customize a bag style of your liking.",
	sub_basic = "Basic",
	enable = "Enable",
	enable_tip = "Enable inventory modulee.",
	newitemFlash = "New item flash",
	newitemFlash_tip = "Adds a flash effect to new items.",
	reverseSort = "Reverse sort",
	reverseSort_tip = "Sort items to bag bottom.",
	combineFreeSlots = "Combine free slots",
	combineFreeSlots_tip = "Combine free slots.",
	useCategory = "Items filter",
	useCategory_tip = "Filters items to their corresponding category.\nUncheck if you perfer ONE BIG BAG.",
	itemLevel = "Show items level",
	itemLevel_tip = "Show items level.",
	sub_size = "Adjustment",
	slotSize = 'Slot size',
	spacing = 'Slot margin',
	bagColumns = 'Bag items per row',
	bankColumns = 'Bank items per row',
}





L.quest = "Quest"
L.quest_subText = "These options control quest tracker and notifier."
L.quest_subCategory_basic = "Basic"
L.quest_logEnhancement = "Quest log"
L.quest_logEnhancement_tooltip = "Doubles quest log panel and adds quest levle."
L.quest_trackerEnhancement = "Quest tracker"
L.quest_trackerEnhancement_tooltip = "Enhances quest tracker."
L.quest_quickQuest = "Auto quest"
L.quest_quickQuest_tooltip = "Automatically accept and deliver quests."
L.quest_notifier = "Notifier"
L.quest_notifier_tooltip = "Quest notifier."
L.quest_progressNotify = "Announcement"
L.quest_progressNotify_tooltip = "Announce quest progress when you in a group."
L.quest_completeRing = "Complete ring"
L.quest_completeRing_tooltip = "Plays a sound when you have finished a quest."
L.quest_rewardHightlight = "Reward hightlight"
L.quest_rewardHightlight_tooltip = "Highlights the quest reward with highest vendor price."



L.chat = "Chat"
L.chat_subText = "Adjust the appearance and functionality of the game chat."
L.chat_subCategory_basic = "Basic"
L.chat_enable = "Enable chat"
L.chat_enable_tooltip = "Uncheck if you want to use another chat addon."
L.chat_lockPosition = "Lock position"
L.chat_lockPosition_tooltip = "Uncheck if you want to move chat frame position."
L.chat_fontOutline = "Font outline"
L.chat_fontOutline_tooltip = "Add outline for chat fonts."
L.chat_whisperAlert = "Whisper alert"
L.chat_whisperAlert_tooltip = "Play a sound when you receive whisper messages."
L.chat_timeStamp = "Time stamp"
L.chat_timeStamp_tooltip = "Add customized time stamp."
L.chat_timeStampColor = "Time stamp color"
L.chat_timeStampColor_tooltip = ""
L.chat_copyButton = "Copy button"
L.chat_copyButton_tooltip = "Add a copy button.\nLeft click to hide chat frame, right click to copy chat lines."
L.chat_fading = "Lines fading"
L.chat_fading_tooltip = "Fade chat lines."
L.chat_filters = "Chat filters"
L.chat_filters_tooltip = "Filter spam and unnecessary messages."
L.chat_hideVoiceButtons = "Hide voice button"
L.chat_hideVoiceButtons_tooltip = "Hide voice button."



L.map = "Map"
L.map_subText = "Adjust the appearance and functionality of the game maps."
L.map_subCategory_worldMap = "Worldmap"
L.map_worldMapCoords = "Show coords"
L.map_worldMapCoords_tooltip = "Show player and cursor coords on worldmap."
L.map_worldMapReveal = "Map reveal"
L.map_worldMapReveal_tooltip = "Reveals every portion of every zone of the worldmap."
L.map_subCategory_miniMap = "Minimap"
L.map_whoPings = "Who pings"
L.map_whoPings_tooltip = "Show who pings."
L.map_miniMapSize = "Minimap size"
L.map_miniMapSize_tooltip = "Adjust minimap size."
L.map_microMenu = "Micro menu"
L.map_microMenu_tooltip = "Micro menu by right click on minimap."
L.map_expRepBar = "Exp rep bar"
L.map_expRepBar_tooltip = "Add a progress bar on minimap to track your exp and rep."



L.tooltip = "Tooltip"
L.tooltip_subText = "Adjust the appearance and functionality of the game tooltip."
L.tooltip_subCategory_basic = "Basic"
L.tooltip_enable = "Enable tooltip"
L.tooltip_enable_tooltip = "Uncheck if you want to use another tooltip addon."
L.tooltip_cursor = "Follow cursor"
L.tooltip_cursor_tooltip = "Keeps the tooltip near cursor."
L.tooltip_hideTitle = "Hide title"
L.tooltip_hideTitle_tooltip = "Hide title."
L.tooltip_hideRealm = "Hide realm"
L.tooltip_hideRealm_tooltip = "Hide realm."
L.tooltip_hideRank = "Hide guild rank"
L.tooltip_hideRank_tooltip = "Hide guild rank"
L.tooltip_combatHide = "Hide tooltip in combat"
L.tooltip_combatHide_tooltip = "Hide tooltip in combat."
L.tooltip_borderColor = "Border color"
L.tooltip_borderColor_tooltip = "Border colored by item quality."
L.tooltip_tipIcon = "Show icon"
L.tooltip_tipIcon_tooltip = "Show item icon on tooltip."
L.tooltip_linkHover = "Hover link"
L.tooltip_linkHover_tooltip = "Show tooltip when mouseover item link on chat frame."
L.tooltip_extraInfo = "Extra info"
L.tooltip_extraInfo_tooltip = "Show extra informations by hold alt key(item count/price/id)."
L.tooltip_targetBy = "Targeted info"
L.tooltip_targetBy_tooltip = "Show targeted infomations."






L.unitframe = "Unitframe"
L.unitframe_subText = "These options control most of the options for the unitframes."
L.unitframe_enable = "enable unitframes"
L.unitframe_enable_tooltip = "Uncheck if you want to use another unitframe addon."

L.unitframe_subCategory_basic = "Basic"
L.unitframe_transMode = "Clear style"
L.unitframe_transMode_tooltip = "Uncheck if you perfer solid color style."
L.unitframe_colourSmooth = "smooth color"
L.unitframe_colourSmooth_tooltip = "Health colored by current health percentage."
L.unitframe_portrait = "Portrait"
L.unitframe_portrait_tooltip = "Add portrait on unitframes."
L.unitframe_healer = "Healer layout"
L.unitframe_healer_tooltip = "Symmetrical layout, more friendly for healers."
L.unitframe_frameVisibility = "Minimalist mode"
L.unitframe_frameVisibility_tooltip = "Only show unitframes when player enter combat or have a target."

L.unitframe_subCategory_feature = "Extra"
L.unitframe_rangeCheck = "Range check"
L.unitframe_rangeCheck_tooltip = "Changes the opacity of a unit frame based on whether the frame's unit is in the player's range."
L.unitframe_dispellable = "Dispelable"
L.unitframe_dispellable_tooltip = "Highlighting debuffs that are dispellable by the player."
L.unitframe_comboPoints = "Combo points"
L.unitframe_comboPoints_tooltip = "Shows combo points for rogue and druid."
L.unitframe_energyTicker = "Energy ticker"
L.unitframe_energyTicker_tooltip = "Shows energy ticker for rogue and druid."
L.unitframe_onlyShowPlayer = "Debuff filter"
L.unitframe_onlyShowPlayer_tooltip = "Shows only debuffs created by player."
L.unitframe_clickCast = "Click cast"
L.unitframe_clickCast_tooltip = "Enable click cast."
L.unitframe_adjustClassColors = "Adjust class colors"
L.unitframe_adjustClassColors_tooltip = "Adjust default class colors."


L.unitframe_subCategory_castbar = "Castbar"
L.unitframe_enableCastbar = "Enable castbar"
L.unitframe_enableCastbar_tooltip = "Uncheck if you want to use another castbar addon."
L.unitframe_castbar_separatePlayer = "Separate castbar"
L.unitframe_castbar_separatePlayer_tooltip = "Separate palyer castbar."


L.unitframe_subCategory_extra = "Extra"
L.unitframe_enableGroup = "Enable group frames"
L.unitframe_enableGroup_tooltip = "Uncheck if you want to use another group unitframes addon."
L.unitframe_groupNames = "Show names"
L.unitframe_groupNames_tooltip = "Show names on group unitframes."
L.unitframe_groupColourSmooth = "Smooth color"
L.unitframe_groupColourSmooth_tooltip = "Health colored by current health percentage."
L.unitframe_groupFilter = "Groups to show"







L.classmod = "Class specific"
L.classmodSubText = "These options allow you to toggle the class-specific modules in the UI."

local classes = UnitSex("player") == 2 and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE

for class, localized in pairs(classes) do
	L["classmod"..strlower(class)] = localized
end

L.classmodhavocFury = "|cffffffff Demon Hunter havoc fury"
L.classmodhavocFuryTooltip = "Change fury colour based on current value."


