local F, C, L = unpack(select(2, ...))
local module = F:GetModule('chat')

function module:ChatStrings()
	CHAT_FLAG_AFK = '|cff808080[AFK]|r\32'
	CHAT_FLAG_DND = '|cff808080[DND]|r\32'
	CHAT_FLAG_GM = '|cffff0000[GM]|r\32'

	CHAT_WHISPER_GET = 'From. %s:\32'
	CHAT_WHISPER_INFORM_GET = 'To. %s:\32'
	CHAT_BN_WHISPER_GET = 'From. %s:\32'
	CHAT_BN_WHISPER_INFORM_GET = 'To. %s:\32'

	CHAT_GUILD_GET = '|Hchannel:Guild|hG.|h %s:\32'
	CHAT_OFFICER_GET = '|Hchannel:o|hO.|h %s:\32'

	CHAT_PARTY_GET = '|Hchannel:party|hP.|h %s:\32'
	CHAT_PARTY_LEADER_GET = '|Hchannel:party|h|cffffff00!|r P.|h %s:\32'
	CHAT_PARTY_GUIDE_GET = '|Hchannel:party|hP.|h %s:\32'

	CHAT_RAID_GET = '|Hchannel:raid|hR.|h %s:\32'
	CHAT_RAID_WARNING_GET = '[RW] %s:\32'
	CHAT_RAID_LEADER_GET = '|Hchannel:raid|h|cffffff00!|r R.|h %s:\32'

	CHAT_INSTANCE_CHAT_GET = '|Hchannel:INSTANCE_CHAT|hI.|h %s:\32'
	CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:INSTANCE_CHAT|h|cffffff00!|r I.|h %s:\32'

	CHAT_BATTLEGROUND_GET = '|Hchannel:Battleground|hB.|h %s:\32'
	CHAT_BATTLEGROUND_LEADER_GET = '|Hchannel:Battleground|h|cffffff00!|r B.|h %s:\32'

	CHAT_YELL_GET = '|Hchannel:Yell|h%s:\32'
	CHAT_SAY_GET = '|Hchannel:Say|h%s:\32'

	CHAT_CHANNEL_GET = '%s:\32'

	CHAT_MONSTER_PARTY_GET = '|Hchannel:PARTY|hP.|h %s:\32'
	CHAT_MONSTER_SAY_GET = '%s:\32';
	CHAT_MONSTER_WHISPER_GET = '%s:\32'
	CHAT_MONSTER_YELL_GET = '%s:\32'


	CHAT_YOU_CHANGED_NOTICE = '>|Hchannel:%d|h[%s]|h'
	CHAT_YOU_CHANGED_NOTICE_BN = '>|Hchannel:CHANNEL:%d|h[%s]|h'
	CHAT_YOU_JOINED_NOTICE = '+|Hchannel:%d|h[%s]|h'
	CHAT_YOU_JOINED_NOTICE_BN = '+|Hchannel:CHANNEL:%d|h[%s]|h'
	CHAT_YOU_LEFT_NOTICE = '-|Hchannel:%d|h[%s]|h'
	CHAT_YOU_LEFT_NOTICE_BN = '-|Hchannel:CHANNEL:%d|h[%s]|h'

	CURRENCY_GAINED = '+ %s'
	CURRENCY_GAINED_MULTIPLE = '+ %sx%d'
	CURRENCY_GAINED_MULTIPLE_BONUS = '+ %sx%d (Bonus)'
	CURRENCY_LOST_FROM_DEATH = '- %sx%d'

	LOOT_CURRENCY_REFUND = '+ %sx%d'
	LOOT_DISENCHANT_CREDIT = '- %s : %s (Disenchant)'

	LOOT_ITEM = '+ %s : %s'

	LOOT_ITEM_BONUS_ROLL = '+ %s : %s (Bonus)'
	LOOT_ITEM_BONUS_ROLL_MULTIPLE = '+ %s : %sx%d (Bonus)'
	LOOT_ITEM_BONUS_ROLL_SELF = '+ %s (Bonus)'
	LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = '+ %sx%d (Bonus)'

	LOOT_ITEM_CREATED_SELF = '+ %s (Craft)'
	LOOT_ITEM_CREATED_SELF_MULTIPLE = '+ %sx%d (Craft)'
	LOOT_ITEM_CREATED = '+ %s : %s (Craft)'
	LOOT_ITEM_CREATED_MULTIPLE = '+ %s : %sx%d (Craft)'

	LOOT_ITEM_MULTIPLE = '+ %s : %sx%d'
	LOOT_ITEM_PUSHED = '+ %s : %s'
	LOOT_ITEM_PUSHED_MULTIPLE = '+ %s : %sx%d'
	LOOT_ITEM_PUSHED_SELF = '+ %s'
	LOOT_ITEM_PUSHED_SELF_MULTIPLE = '+ %sx%d'
	LOOT_ITEM_REFUND = '+ %s'
	LOOT_ITEM_REFUND_MULTIPLE = '+ %sx%d'
	LOOT_ITEM_SELF = '+ %s'
	LOOT_ITEM_SELF_MULTIPLE = '+ %sx%d'
	LOOT_ITEM_WHILE_PLAYER_INELIGIBLE = '+ %s : %s'

	LOOT_MONEY = '|cff00a956+|r |cffffffff%s'
	YOU_LOOT_MONEY = '|cff00a956+|r |cffffffff%s'
	LOOT_MONEY_SPLIT = '|cff00a956+|r |cffffffff%s'
	YOU_LOOT_MONEY_GUILD = '|cff00a956+|r |cffffffff%s (%s Guild)'

	COPPER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0\124t'
	SILVER_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0\124t'
	GOLD_AMOUNT = '%d\124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t'

	GUILD_NEWS_FORMAT4 = '+ %s : %s (Craft)'
	GUILD_NEWS_FORMAT8 = '+ %s : %s'

	CREATED_ITEM = '+ %s : %s (Craft)'
	CREATED_ITEM_MULTIPLE = '+ %s : %sx%d (Craft)'

	TRADESKILL_LOG_FIRSTPERSON = '+ %s : %s (Craft)'
	TRADESKILL_LOG_THIRDPERSON = '+ %s : %s (Craft)'

	ERR_SKILL_UP_SI = '|cffffffff%s|r |cff00adf0%d|r'


	if C.Client == 'zhCN' then
		BN_INLINE_TOAST_FRIEND_OFFLINE = '|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t%s |cffff0000离线|r'
		BN_INLINE_TOAST_FRIEND_ONLINE = '|TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61|t%s |cff00ff00上线|r'

		ERR_FRIEND_OFFLINE_S = '%s |cffff0000下线|r'
		ERR_FRIEND_ONLINE_SS = '|Hplayer:%s|h[%s]|h |cff00ff00上线|r'

		ERR_AUCTION_SOLD_S = '|cff1eff00%s|r |cffffffff售出|r'
	end
end