local F, C, L = unpack(select(2, ...))
local module = F:GetModule("chat")


local gsub = string.gsub
local match = string.match
local format = string.format

--[[local shorthands = {
	INSTANCE_CHAT = 'i',
	OFFICER = 'o',
	GUILD = 'g',
	PARTY = 'p',
	RAID = 'r'
}]]

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
	local tbl = C.classColors[className]
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
		flag = '|cffffffff!|r '
	end

	--return format('|Hchannel:%s|h%s|h %s', channel, shorthands[channel] or gsub(channel, 'channel:', ''), flag)
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
	message = gsub(message, '(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)', FormatBNPlayer)

	message = gsub(message, '|Hchannel:(.-)|h%[(.-)%]|h ', AbbreviateChannel)

	--message = gsub(message, '^%[' .. RAID_WARNING .. '%]', 'rw')

	--[[message = gsub(message, "%[Guild%]", "g")
	message = gsub(message, "%[Party%]", "p")
	message = gsub(message, "%[Party Leader%]", "P")
	message = gsub(message, "%[Dungeon Guide%]", "P")
	message = gsub(message, "%[Raid%]", "r")
	message = gsub(message, "%[Raid Leader%]", "RL")
	message = gsub(message, "%[Raid Warning%]", "RW")
	message = gsub(message, "%[Officer%]", "o")
	message = gsub(message, "%[Instance%]", "i")
	message = gsub(message, "%[Instance Leader%]", "I")
	message = gsub(message, "%[(%d+)%..-%]", "%1")
	message = gsub(message, "(|Hplayer.*|h) whispers", "From %1")
	message = gsub(message, "To (|Hplayer.*|h)", "To %1")
	message = gsub(message, "(|Hplayer.*|h) says:", "%1:")
	message = gsub(message, "(|Hplayer.*|h) yells", "%1")]]

	message = gsub(message, '([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')

	return hooks[self](self, message, ...)
end

for index = 1, NUM_CHAT_WINDOWS do
	if(index ~= 2) then
		local ChatFrame = _G['ChatFrame' .. index]
		hooks[ChatFrame] = ChatFrame.AddMessage
		ChatFrame.AddMessage = AddMessage
	end
end



-- string format
CHAT_FLAG_AFK = "[AFK] "
CHAT_FLAG_DND = "[DND] "
CHAT_FLAG_GM = "[GM] "

CHAT_WHISPER_GET = "[from] %s:\32"
CHAT_WHISPER_INFORM_GET = "[to] %s:\32"
CHAT_BN_WHISPER_GET = "[from] %s:\32"
CHAT_BN_WHISPER_INFORM_GET = "[to] %s:\32"

CHAT_GUILD_GET = "[|Hchannel:Guild|hG|h] %s:\32"
CHAT_OFFICER_GET = "[|Hchannel:o|hO|h] %s:\32"

CHAT_PARTY_GET = "[|Hchannel:party|hP|h] %s:\32"
CHAT_PARTY_LEADER_GET = "[|Hchannel:party|hPL|h] %s:\32"
CHAT_PARTY_GUIDE_GET = "[|Hchannel:party|hPG|h] %s:\32"

CHAT_RAID_GET = "[|Hchannel:raid|hR|h] %s:\32"
CHAT_RAID_WARNING_GET = "[RW!] %s:\32"
CHAT_RAID_LEADER_GET = "[|Hchannel:raid|hRL|h] %s:\32"

CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h[I]|h %s:\32"
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h[IL]|h %s:\32"

CHAT_BATTLEGROUND_GET = "[|Hchannel:Battleground|hBG|h] %s:\32"
CHAT_BATTLEGROUND_LEADER_GET = "[|Hchannel:Battleground|hBL|h] %s:\32"

CHAT_YELL_GET = "|Hchannel:Yell|h%s:\32"
CHAT_SAY_GET = "|Hchannel:Say|h%s:\32"

CHAT_CHANNEL_GET = "%s:\32"


CHAT_YOU_CHANGED_NOTICE = ">|Hchannel:%d|h[%s]|h"
CHAT_YOU_CHANGED_NOTICE_BN = ">|Hchannel:CHANNEL:%d|h[%s]|h"
CHAT_YOU_JOINED_NOTICE = "+|Hchannel:%d|h[%s]|h"
CHAT_YOU_JOINED_NOTICE_BN = "+|Hchannel:CHANNEL:%d|h[%s]|h"
CHAT_YOU_LEFT_NOTICE = "-|Hchannel:%d|h[%s]|h"
CHAT_YOU_LEFT_NOTICE_BN = "-|Hchannel:CHANNEL:%d|h[%s]|h"

CURRENCY_GAINED = "+ %s"
CURRENCY_GAINED_MULTIPLE = "+ %sx%d"
CURRENCY_GAINED_MULTIPLE_BONUS = "+ %sx%d (Bonus)"
CURRENCY_LOST_FROM_DEATH = "- %sx%d"

LOOT_CURRENCY_REFUND = "+ %sx%d"
LOOT_DISENCHANT_CREDIT = "- %s : %s (Disenchant)"

LOOT_ITEM = "+ %s : %s"

LOOT_ITEM_BONUS_ROLL = "+ %s : %s (Bonus)"
LOOT_ITEM_BONUS_ROLL_MULTIPLE = "+ %s : %sx%d (Bonus)"
LOOT_ITEM_BONUS_ROLL_SELF = "+ %s (Bonus)"
LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "+ %sx%d (Bonus)"

LOOT_ITEM_CREATED_SELF = "+ %s (Craft)"
LOOT_ITEM_CREATED_SELF_MULTIPLE = "+ %sx%d (Craft)"
LOOT_ITEM_CREATED = "+ %s : %s (Craft)"
LOOT_ITEM_CREATED_MULTIPLE = "+ %s : %sx%d (Craft)"

LOOT_ITEM_MULTIPLE = "+ %s : %sx%d"
LOOT_ITEM_PUSHED = "+ %s : %s"
LOOT_ITEM_PUSHED_MULTIPLE = "+ %s : %sx%d"
LOOT_ITEM_PUSHED_SELF = "+ %s"
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "+ %sx%d"
LOOT_ITEM_REFUND = "+ %s"
LOOT_ITEM_REFUND_MULTIPLE = "+ %sx%d"
LOOT_ITEM_SELF = "+ %s"
LOOT_ITEM_SELF_MULTIPLE = "+ %sx%d"
LOOT_ITEM_WHILE_PLAYER_INELIGIBLE = "+ %s : %s"

LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
YOU_LOOT_MONEY = "|cff00a956+|r |cffffffff%s"
LOOT_MONEY_SPLIT = "|cff00a956+|r |cffffffff%s"
YOU_LOOT_MONEY_GUILD = "|cff00a956+|r |cffffffff%s (%s Guild)"

COPPER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t"
SILVER_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t"
GOLD_AMOUNT = "%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t"

GUILD_NEWS_FORMAT4 = "+ %s : %s (Craft)"
GUILD_NEWS_FORMAT8 = "+ %s : %s"

CREATED_ITEM = "+ %s : %s (Craft)"
CREATED_ITEM_MULTIPLE = "+ %s : %sx%d (Craft)"

TRADESKILL_LOG_FIRSTPERSON = "+ %s : %s (Craft)"
TRADESKILL_LOG_THIRDPERSON = "+ %s : %s (Craft)"

ERR_SKILL_UP_SI = "|cffffffff%s|r |cff00adf0%d|r"


if C.client == "zhCN" then
	BN_INLINE_TOAST_FRIEND_OFFLINE = "|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t%s |cffff0000离线|r"
	BN_INLINE_TOAST_FRIEND_ONLINE = "|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t%s |cff00ff00上线|r"

	ERR_FRIEND_OFFLINE_S = "%s |cffff0000下线|r"
	ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h |cff00ff00上线|r"

	ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffff售出|r"
end

