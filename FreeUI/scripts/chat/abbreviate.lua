local F, C, L = unpack(select(2, ...))
local module = F:GetModule("chat")

C.ClientColors = {
	[BNET_CLIENT_WOW] = '5cc400',
	[BNET_CLIENT_D3] = 'b71709',
	[BNET_CLIENT_SC2] = '00b6ff',
	[BNET_CLIENT_WTCG] = 'd37000',
	[BNET_CLIENT_HEROES] = '6800c4',
	[BNET_CLIENT_OVERWATCH] = 'dcdcef',
}

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

local classes = {}
for token, localized in next, LOCALIZED_CLASS_NAMES_MALE do
	classes[localized] = token
end

for token, localized in next, LOCALIZED_CLASS_NAMES_FEMALE do
	classes[localized] = token
end

local function AbbreviateChannel(channel, name)
	local flag = ''
	if(match(name, LEADER)) then
		flag = '|cffffff00!|r'
	end

	return format('|Hchannel:%s|h%s|h %s', channel, shorthands[channel] or gsub(channel, 'channel:', ''), flag)
end

local function FormatPlayer(info, name)
	return format('|Hplayer:%s|h%s|h', info, gsub(name, '%-[^|]+', ''))
end

local function FormatBNPlayer(info)
	local _, _, battleTag, _, _, _, client = BNGetFriendInfoByID(match(info, '(%d+):'))
	local color = C.ClientColors[client] or '22aaff'
	return format('|HBNplayer:%s|h|cff%s%s|r|h', info, color, match(battleTag, '(%w+)#%d+'))
end

local hooks = {}
local function AddMessage(self, message, ...)
	message = gsub(message, "%[(%d+)%. 大脚世界频道%]", "世界")
	message = gsub(message, "%[(%d+)%. 大腳世界頻道%]", "世界")
	message = gsub(message, "%[(%d+)%. BigfootWorldChannel%]", "world")

	message = gsub(message, '|Hplayer:(.-)|h%[(.-)%]|h', FormatPlayer)
	message = gsub(message, '|HBNplayer:(.-)|h%[(.-)%]|h', FormatBNPlayer)
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


YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT


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


LOOT_ITEM = "%s + %s"
LOOT_ITEM_BONUS_ROLL = "%s + %s (bonus)"
LOOT_ITEM_BONUS_ROLL_MULTIPLE = "%s + %sx%d (bonus)"
LOOT_ITEM_BONUS_ROLL_SELF = "+ %s (bonus)"
LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "+ %sx%d (bonus)"
LOOT_ITEM_MULTIPLE = "%s + % sx%d"
LOOT_ITEM_PUSHED = "%s + %s"
LOOT_ITEM_PUSHED_MULTIPLE = "%s + %sx%d"
LOOT_ITEM_SELF = "+ %s"
LOOT_ITEM_SELF_MULTIPLE = "+ %s x%d"
LOOT_ITEM_PUSHED_SELF = "+ %s"
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %s x%d"
LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
YOU_LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
LOOT_MONEY_SPLIT = "|cff00a956+|r |cffffffff%s"
LOOT_ROLL_ALL_PASSED = "|HlootHistory:%d|h[Loot]|h: All passed on %s"
LOOT_ROLL_PASSED_AUTO = "%s passed %s (auto)"
LOOT_ROLL_PASSED_AUTO_FEMALE = "%s passed %s (auto)"
LOOT_ROLL_PASSED_SELF = "|HlootHistory:%d|h[Loot]|h: passed %s"
LOOT_ROLL_PASSED_SELF_AUTO = "|HlootHistory:%d|h[Loot]|h: passed %s (auto)"

COPPER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t"
SILVER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t"
GOLD_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t"