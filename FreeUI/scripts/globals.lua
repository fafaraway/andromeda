--[[ Tooltip mods by Alza mostly ]]

-- ITEM_LEVEL = "|cff00ffffilvl: %d|r"
-- ITEM_LEVEL_ALT = "|cff00ffffilvl: %d (%d)|r"

-- if GetLocale() == "enUS" or GetLocale() == "enGB" then
-- 	ITEM_BIND_ON_EQUIP = "BoE"
-- 	ITEM_BIND_ON_PICKUP = "BoP"
-- 	ITEM_BIND_ON_USE = "Bind on use"
-- 	ITEM_CLASSES_ALLOWED = "Class: %s"
-- 	ITEM_CONJURED = "Conjured"
-- 	ITEM_CREATED_BY = "" -- No creator name
-- 	ITEM_MOD_ARMOR_PENETRATION_RATING = "ARP +%s"
-- 	ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = "ARP"
-- 	ITEM_MOD_ATTACK_POWER = "AP +%s"
-- 	ITEM_MOD_BLOCK_RATING = "Block rating +%s"
-- 	ITEM_MOD_BLOCK_VALUE = "Block value +%s"
-- 	ITEM_MOD_BLOCK_VALUE_SHORT = "Block value"
-- 	ITEM_MOD_CRIT_MELEE_RATING = "Crit (melee) +%s"
-- 	ITEM_MOD_CRIT_MELEE_RATING_SHORT = "Crit (melee)"
-- 	ITEM_MOD_CRIT_RANGED_RATING = "Crit (ranged) +%s"
-- 	ITEM_MOD_CRIT_RANGED_RATING_SHORT = "Crit (ranged)"
-- 	ITEM_MOD_CRIT_RATING = "Crit +%s"
-- 	ITEM_MOD_CRIT_RATING_SHORT = "Crit"
-- 	ITEM_MOD_CRIT_SPELL_RATING = "Crit (spell) +%s"
-- 	ITEM_MOD_CRIT_SPELL_RATING_SHORT = "Crit (spell)"
-- 	ITEM_MOD_DAMAGE_PER_SECOND_SHORT = "DPS"
-- 	ITEM_MOD_DEFENSE_SKILL_RATING = "Defence +%s"
-- 	ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = "Defence"
-- 	ITEM_MOD_DODGE_RATING = "Dodge +%s"
-- 	ITEM_MOD_EXPERTISE_RATING = "Expertise +%s"
-- 	ITEM_MOD_FERAL_ATTACK_POWER = "Feral AP +%s"
-- 	ITEM_MOD_FERAL_ATTACK_POWER_SHORT = "Feral AP"
-- 	ITEM_MOD_HASTE_MELEE_RATING = "Haste (melee) +%s"
-- 	ITEM_MOD_HASTE_RANGED_RATING = "Haste (ranged) +%s"
-- 	ITEM_MOD_HASTE_RATING = "Haste +%s"
-- 	ITEM_MOD_HASTE_SPELL_RATING = "Haste (spell) +%s"
-- 	ITEM_MOD_HEALTH_REGEN = "%d Hp5"
-- 	ITEM_MOD_HEALTH_REGEN_SHORT = "Hp5"
-- 	ITEM_MOD_HEALTH_REGENERATION = "%d Hp5"
-- 	ITEM_MOD_HEALTH_REGENERATION_SHORT = "Hp5"
-- 	ITEM_MOD_HIT_MELEE_RATING = "Hit (melee) +%s"
-- 	ITEM_MOD_HIT_RANGED_RATING = "Hit (ranged) +%s"
-- 	ITEM_MOD_HIT_RATING = "Hit +%s"
-- 	ITEM_MOD_HIT_SPELL_RATING = "Hit (spell) +%s"
-- 	ITEM_MOD_HIT_TAKEN_RATING = "Avoidance +%s"
-- 	ITEM_MOD_HIT_TAKEN_RATING_SHORT = "Avoidance"
-- 	ITEM_MOD_HIT_TAKEN_SPELL_RATING = "Spell avoidance +%s"
-- 	ITEM_MOD_HIT_TAKEN_SPELL_RATING_SHORT = "Avoidance (spell)"
-- 	ITEM_MOD_HIT_TAKEN_MELEE_RATING = "Melee avoidance +%s"
-- 	ITEM_MOD_HIT_TAKEN_MELEE_RATING_SHORT = "Avoidance (melee)"
-- 	ITEM_MOD_HIT_TAKEN_RANGED_RATING = "Ranged avoidance +%s"
-- 	ITEM_MOD_HIT_TAKEN_RANGED_RATING_SHORT = "Avoidance (ranged)"
-- 	ITEM_MOD_MANA_REGENERATION = "+%d Mp5"
-- 	ITEM_MOD_MANA_REGENERATION_SHORT = "Mp5"
-- 	ITEM_MOD_MASTERY_RATING = "Mastery +%s"
-- 	ITEM_MOD_MELEE_ATTACK_POWER_SHORT = "AP (melee)"
-- 	ITEM_MOD_PARRY_RATING = "Parry +%s"
-- 	ITEM_MOD_RANGED_ATTACK_POWER = "AP (ranged) +%s"
-- 	ITEM_MOD_RANGED_ATTACK_POWER_SHORT = "AP (ranged)"
-- 	ITEM_MOD_RESILIENCE_RATING = "Resi +%s"
-- 	ITEM_MOD_RESILIENCE_RATING_SHORT = "Resi"
-- 	ITEM_MOD_SPELL_DAMAGE_DONE = "Spell damage +%s"
-- 	ITEM_MOD_SPELL_HEALING_DONE = "Healing +%s"
-- 	ITEM_MOD_SPELL_POWER = "Spell power +%s"
-- 	ITEM_MOD_SPELL_PENETRATION = "Spell Penetration +%s"
-- 	ITEM_OPENABLE = "Open!"
-- 	ITEM_RANDOM_ENCHANT = "Random enchant"
-- 	ITEM_RESIST_SINGLE = "Resist: %c%d %s"
-- 	ITEM_SIGNABLE = "Sign!"
-- 	ITEM_SOCKETABLE = "" -- No gem info line
-- 	ITEM_SOCKET_BONUS = "Bonus: %s"
-- 	ITEM_SOLD_COLON = "Sold:"
-- 	ITEM_SPELL_CHARGES = "%d charges"
-- 	ITEM_SPELL_TRIGGER_ONPROC = "Proc:"
-- 	ITEM_STARTS_QUEST = "Starts quest"
-- 	ITEM_WRONG_CLASS = "Wrong class!"
-- 	ITEM_UNSELLABLE = "Can't be sold"
-- 	SELL_PRICE = "Price"
-- end

-- ARMOR_TEMPLATE = "Armor: %s"
-- DAMAGE_TEMPLATE = "Damage: %s - %s"
-- DPS_TEMPLATE = "%s DPS"
-- DURABILITY_TEMPLATE = "Durability: %d/%d"
-- SHIELD_BLOCK_TEMPLATE = "Block: %d"

-- EMPTY_SOCKET_RED = "red"
-- EMPTY_SOCKET_YELLOW = "yellow"
-- EMPTY_SOCKET_BLUE = "blue"
-- EMPTY_SOCKET_META = "meta"
-- EMPTY_SOCKET_NO_COLOR = "prismatic"

--[[ Loot mods ]]

-- LOOT_ITEM = "%s + %s"
-- LOOT_ITEM_BONUS_ROLL = "%s + %s (bonus)"
-- LOOT_ITEM_BONUS_ROLL_MULTIPLE = "%s + %sx%d (bonus)"
-- LOOT_ITEM_BONUS_ROLL_SELF = "+ %s (bonus)"
-- LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "+ %sx%d (bonus)"
-- LOOT_ITEM_MULTIPLE = "%s + % sx%d"
-- LOOT_ITEM_PUSHED = "%s + %s"
-- LOOT_ITEM_PUSHED_MULTIPLE = "%s + %sx%d"
-- LOOT_ITEM_SELF = "+ %s"
-- LOOT_ITEM_SELF_MULTIPLE = "+ %s x%d"
-- LOOT_ITEM_PUSHED_SELF = "+ %s"
-- LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %s x%d"
-- LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
-- YOU_LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
-- LOOT_MONEY_SPLIT = "|cff00a956+|r |cffffffff%s"
-- LOOT_ROLL_ALL_PASSED = "|HlootHistory:%d|h[Loot]|h: All passed on %s"
-- LOOT_ROLL_PASSED_AUTO = "%s passed %s (auto)"
-- LOOT_ROLL_PASSED_AUTO_FEMALE = "%s passed %s (auto)"
-- LOOT_ROLL_PASSED_SELF = "|HlootHistory:%d|h[Loot]|h: passed %s"
-- LOOT_ROLL_PASSED_SELF_AUTO = "|HlootHistory:%d|h[Loot]|h: passed %s (auto)"

COPPER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t"
SILVER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t"
GOLD_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t"

-- [[ Item quality colours ]]

-- Add quality colour for Poor items
LE_ITEM_QUALITY_COMMON = -1
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_POOR] = { r = 0.61, g = 0.61, b = 0.61}
-- Change Common from grey to black
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] = { r = 0, g = 0, b = 0}
BAG_ITEM_QUALITY_COLORS[1] = { r = 0, g = 0, b = 0}
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_HEIRLOOM] = { r = 1, g = 0, b = 0}
BAG_ITEM_QUALITY_COLORS[7] = { r = 1, g = 0, b = 0}

--[[ Chat mods ]]

ACHIEVEMENT_BROADCAST = "%s achieved %s!"
BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has gone |cffff0000offline|r."
BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has come |cff00ff00online|r."
CHAT_BN_WHISPER_GET = "From %s:\32"
CHAT_BN_WHISPER_INFORM_GET = "To %s:\32"
CHAT_FLAG_AFK = "[AFK] "
CHAT_FLAG_DND = "[DND] "
CHAT_YOU_CHANGED_NOTICE = "|Hchannel:%d|h[%s]|h"
ERR_FRIEND_OFFLINE_S = "%s has gone |cffff0000offline|r."
ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h has come |cff00ff00online|r."
ERR_SKILL_UP_SI = "|cffffffff%s|r |cff00adf0%d|r"
FACTION_STANDING_DECREASED = "%s -%d"
FACTION_STANDING_INCREASED = "%s +%d"
FACTION_STANDING_INCREASED_ACH_BONUS = "%s +%d (+%.1f)"
FACTION_STANDING_INCREASED_ACH_PART = "(+%.1f)"
FACTION_STANDING_INCREASED_BONUS = "%s + %d (+%.1f RAF)"
FACTION_STANDING_INCREASED_DOUBLE_BONUS = "%s +%d (+%.1f RAF) (+%.1f)"
FACTION_STANDING_INCREASED_REFER_PART = "(+%.1f RAF)"
FACTION_STANDING_INCREASED_REST_PART = "(+%.1f Rested)"

--[[ Text colours ]]

-- NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
-- TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, "000000", "ffffff")
-- IGNORED_QUEST_DISPLAY = gsub(IGNORED_QUEST_DISPLAY, "000000", "ffffff")

-- [[ Misc ]]

ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffffsold.|r"
