local _, ns = ...

ns.localization = {}

ns.localization.profile = "Character Specific settings"
ns.localization.profileTooltip = "Switch to a profile unique to this character."
ns.localization.install = "Installer"
ns.localization.needReload = "The above settings require a UI reload to apply."
ns.localization.reload = "Reload UI"
ns.localization.resetData = "Remove data"
ns.localization.resetOptions = "Remove saved options"
ns.localization.author = "FreeUI by Haleth on wowinterface.com"
ns.localization.authorSubText = "Freethinker @ Steamwheedle Cartel - EU"

ns.localization.general = "General"
ns.localization.generalSubText = "These options control most of the common settings in the UI."
ns.localization.generalbags_size = "Bag size"
ns.localization.generalbuffreminder = "Buff reminder"
ns.localization.generalbuffreminderTooltip = "While in combat, show a reminder when missing important buffs that you can cast."
ns.localization.generalbuffTracker = "Buff tracker"
ns.localization.generalbuffTrackerTooltip = "Show important buffs below the center of the screen for certain classes."
ns.localization.generalhelmcloakbuttons = "Helm/Cloak buttons"
ns.localization.generalhelmcloakbuttonsTooltip = "Allows you to toggle Helm/Cloak display from the character frame."
ns.localization.generalinterrupt = "Interrupt announcer"
ns.localization.generalinterruptTooltip = "Announce your interrupts to raid chat in a PVE situation."
ns.localization.generalmailButton = "Mail collection button"
ns.localization.generalmailButtonTooltip = "Adds a button to the mail frame to collect all mail attachments with one click."
ns.localization.generalthreatMeter = "Threat meter"
ns.localization.generalthreatMeterTooltip = "Show a bar above the target frame that displays your threat compared to the tank as a dps, or the threat and name of the second highest in threat when tanking."
ns.localization.generaltolbarad = "Tol Barad timer"
ns.localization.generaltolbaradTooltip = "Show a Tol Barad timer below the minimap."
ns.localization.generaltooltip_cursor = "Attach the tooltip to the cursor"
ns.localization.generaltooltip_guildranks = "Show guild ranks in tooltips"
ns.localization.generaluiScaleAuto = "UI scale adjusting"
ns.localization.generaluiScaleAutoTooltip = "Automatically apply the optimal UI scale for your resolution. Requires a UI reload to change."
ns.localization.generalundressButton = "Undress button"
ns.localization.generalundressButtonTooltip = "Adds an undress button to the dressup frame. Useful when trying on shirts or chest armour."

ns.localization.automation = "Automation"
ns.localization.automationSubText = "With these features, the UI can perform common tasks automatically."
ns.localization.automationautoAccept = "Automatically accept invites from friends and guildies"
ns.localization.automationautoRepair = "Automatically repair items"
ns.localization.automationautoRepair_guild = "Use guild funds"
ns.localization.automationautoRoll = "Automatically roll DE or greed on BoE uncommon items"
ns.localization.automationautoRoll_maxLevel = "Only at max level"
ns.localization.automationautoSell = "Automatically sell junk"

ns.localization.actionbars = "Action bars"
ns.localization.actionbarsSubText = "These options are specific to the action bars and their buttons."
ns.localization.actionbarshotkey = "Show key bindings on buttons"
ns.localization.actionbarsrightbars_mouseover = "Show right action bars on mouseover"
ns.localization.actionbarsstancebar = "Enable the stance/possess bar"

ns.localization.unitframes = "Unit frames"

ns.localization.classmod = "Class specific"
ns.localization.classmodSubText = "These options allow you to toggle the class-specific modules in the UI."

local classes = UnitSex("player") == 2 and LOCALIZED_CLASS_NAMES_MALE or LOCALIZED_CLASS_NAMES_FEMALE

for class, localized in pairs(classes) do
	ns.localization["classmod"..strlower(class)] = localized
end

ns.localization.classmoddeathknight = ns.localization.classmoddeathknight..":|cffffffff Rune Bar"
ns.localization.classmoddruid = ns.localization.classmoddruid..":|cffffffff Eclipse bar and shapeshift mana bar"
ns.localization.classmodmonk = ns.localization.classmodmonk..":|cffffffff Chi orb tracker"
ns.localization.classmodpaladin = ns.localization.classmodpaladin..":|cffffffff Holy Power tracker"
ns.localization.classmodpriest = ns.localization.classmodpriest..":|cffffffff Shadow orb tracker"
ns.localization.classmodshaman = ns.localization.classmodshaman..":|cffffffff Maelstrom Weapon tracker"
ns.localization.classmodwarlock = ns.localization.classmodwarlock..":|cffffffff Specialization bars"

ns.localization.performance = "Performance"
ns.localization.performanceSubText = "These options control the update intervals of various time- or scanner-based functions. Lower intervals ensure smoother updating, but require more CPU power."
ns.localization.performancemapcoords = "Map coordinates"
ns.localization.performancenameplates = "Name plate scanning"
ns.localization.performancenamethreat = "Name plate threat colour"
ns.localization.performancetolbarad = "Tol Barad timer"

ns.localization.credits = "Credits"
ns.localization.thankYou = "Thank you:"
ns.localization.alza = "For AlzaUI, which once formed the basis for FreeUI, and of which some code still exists today"
ns.localization.haste = "For the oUF framework, without which the unitframes in this UI could not exist"
ns.localization.tukz = "For allowing the use of his code, and collaboration in UI development"
ns.localization.zork = "For rActionBarStyler, rActionButtonStyler, and rBuffFrameStyler, three important parts of this UI"