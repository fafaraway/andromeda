local F, C, L = unpack(select(2, ...))
local module = F:GetModule("chat")


local gsub = string.gsub
local match = string.match
local format = string.format

local shorthands = {
	INSTANCE_CHAT = 'i',
	OFFICER = 'o',
	GUILD = 'g',
	PARTY = 'p',
	RAID = 'r'
}

local function GetColor(className, isLocal)
	if isLocal then
		local found
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == className then className = k found = true break end
		end
		if not found then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == className then className = k break end
			end
		end
	end
	local tbl = C.classcolours[className]
	local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

local function FormatBNPlayer(misc, id, moreMisc, fakeName, tag, colon)
		local gameAccount = select(6, BNGetFriendInfoByID(id))
		if gameAccount then
			local _, charName, _, _, _, _, _, englishClass = BNGetGameAccountInfo(gameAccount)
			if englishClass and englishClass ~= "" then
				fakeName = "|cFF"..GetColor(englishClass, true)..fakeName.."|r"
			end
	end
	return misc..id..moreMisc..fakeName..tag..(colon == ":" and ":" or colon)
end

local function AbbreviateChannel(channel, name)
	local flag = ''
	if(match(name, LEADER)) then
		flag = '|cffffff00!|r '
	end

	return format('|Hchannel:%s|h%s|h %s', channel, shorthands[channel] or gsub(channel, 'channel:', ''), flag)
end

local function FormatPlayer(info, name)
	return format('|Hplayer:%s|h%s|h', info, gsub(name, '%-[^|]+', ''))
end


local hooks = {}
local function AddMessage(self, message, ...)
	message = gsub(message, "%[(%d+)%. 大脚世界频道%]", "世界")
	message = gsub(message, "%[(%d+)%. 大腳世界頻道%]", "世界")
	message = gsub(message, "%[(%d+)%. BigfootWorldChannel%]", "world")

	message = gsub(message, '|Hplayer:(.-)|h%[(.-)%]|h', FormatPlayer)
	--message = gsub(message, '|HBNplayer:(.-)|h%[(.-)%]|h', FormatBNPlayer)
	message = gsub(message, '(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)', FormatBNPlayer)
	message = gsub(message, '|Hchannel:(.-)|h%[(.-)%]|h ', AbbreviateChannel)

	--message = gsub(message, '^%w- (|H)', '|cffa1a1a1@|r%1')
	--message = gsub(message, '^(.-|h) %w-:', '%1:')
	message = gsub(message, '^%[' .. RAID_WARNING .. '%]', 'rw')

	message = gsub(message, '([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')

	return hooks[self](self, message, ...)
end

for index = 1, 5 do
	if(index ~= 2) then
		local ChatFrame = _G['ChatFrame' .. index]
		hooks[ChatFrame] = ChatFrame.AddMessage
		ChatFrame.AddMessage = AddMessage
	end
end



-- string format
CHAT_FLAG_AFK = "AFK. "
CHAT_FLAG_DND = "DND. "
CHAT_FLAG_GM = "GM. "

CHAT_YELL_GET = "|Hchannel:Yell|h%s: "
CHAT_SAY_GET = "|Hchannel:Say|h%s: "

CHAT_WHISPER_GET = "from %s: "
CHAT_WHISPER_INFORM_GET = "to %s: "
CHAT_BN_WHISPER_GET = "from %s: "
CHAT_BN_WHISPER_INFORM_GET = "to %s: "

ACHIEVEMENT_BROADCAST = "%s achieved %s!"

BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has gone |cffff0000offline|r."
BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has come |cff00ff00online|r."

CHAT_YOU_CHANGED_NOTICE = "|Hchannel:%d|h[%s]|h"
ERR_FRIEND_OFFLINE_S = "%s has gone |cffff0000offline|r."
ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h has come |cff00ff00online|r."

ERR_SKILL_UP_SI = "|cffffffff%s|r |cff00adf0%d|r"
ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffffsold.|r"

FACTION_STANDING_DECREASED = "%s -%d"
FACTION_STANDING_INCREASED = "%s +%d"
FACTION_STANDING_INCREASED_ACH_BONUS = "%s +%d (+%.1f)"
FACTION_STANDING_INCREASED_ACH_PART = "(+%.1f)"
FACTION_STANDING_INCREASED_BONUS = "%s + %d (+%.1f RAF)"
FACTION_STANDING_INCREASED_DOUBLE_BONUS = "%s +%d (+%.1f RAF) (+%.1f)"
FACTION_STANDING_INCREASED_REFER_PART = "(+%.1f RAF)"
FACTION_STANDING_INCREASED_REST_PART = "(+%.1f Rested)"

CURRENCY_GAINED = "+ %s";
CURRENCY_GAINED_MULTIPLE = "+ %sx%d";
CURRENCY_GAINED_MULTIPLE_BONUS = "+ %sx%d (Bonus)";
CURRENCY_LOST_FROM_DEATH = "- %sx%d";

LOOT_CURRENCY_REFUND = "+ %sx%d";
LOOT_DISENCHANT_CREDIT = "- %s : %s (Disenchant)";

LOOT_ITEM = "+ %s : %s";

LOOT_ITEM_BONUS_ROLL = "+ %s : %s (Bonus)";
LOOT_ITEM_BONUS_ROLL_MULTIPLE = "+ %s : %sx%d (Bonus)";
LOOT_ITEM_BONUS_ROLL_SELF = "+ %s (Bonus)";
LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "+ %sx%d (Bonus)";

LOOT_ITEM_CREATED_SELF = "+ %s (Craft)";
LOOT_ITEM_CREATED_SELF_MULTIPLE = "+ %sx%d (Craft)";
LOOT_ITEM_CREATED = "+ %s : %s (Craft)";
LOOT_ITEM_CREATED_MULTIPLE = "+ %s : %sx%d (Craft)";

LOOT_ITEM_MULTIPLE = "+ %s : %sx%d";
LOOT_ITEM_PUSHED = "+ %s : %s";
LOOT_ITEM_PUSHED_MULTIPLE = "+ %s : %sx%d";
LOOT_ITEM_PUSHED_SELF = "+ %s";
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %sx%d";
LOOT_ITEM_REFUND = "+ %s";
LOOT_ITEM_REFUND_MULTIPLE = "+ %sx%d";
LOOT_ITEM_SELF = "+ %s";
LOOT_ITEM_SELF_MULTIPLE = "+ %sx%d";
LOOT_ITEM_WHILE_PLAYER_INELIGIBLE = "+ %s : %s";

GUILD_NEWS_FORMAT4 = "+ %s : %s (Craft)";
GUILD_NEWS_FORMAT8 = "+ %s : %s";

CREATED_ITEM = "+ %s : %s (Craft)";
CREATED_ITEM_MULTIPLE = "+ %s : %sx%d (Craft)";

YOU_LOOT_MONEY = "+ %s";
YOU_LOOT_MONEY_GUILD = "+ %s (%s Guild)";

TRADESKILL_LOG_FIRSTPERSON = "+ %s : %s (Craft)";
TRADESKILL_LOG_THIRDPERSON = "+ %s : %s (Craft)";

COPPER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t"
SILVER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t"
GOLD_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t"