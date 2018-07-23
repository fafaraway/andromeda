local F, C, L = unpack(select(2, ...))



local FilterList = {}
local FilterMatches = 1
local FilterSymbols = {"`", "～", "＠", "＃", "^", "＊", "！", "？", "。", "|", " ", "—", "——", "￥", "’", "‘", "“", "”", "【", "】", "『", "』", "《", "》", "〈", "〉", "（", "）", "〔", "〕", "、", "，", "：", ",", "_", "/", "~", "-"}
local addonBlockList = {
	"任务进度提示%s?[:：]",
	"%[接受任务%]",
	"%(任务完成%)",
	"<大脚组队提示>",
	"<大脚团队提示>",
	"【网%.易%.有%.爱】",
	"EUI:",
	"EUI_RaidCD",
	"打断:.+|Hspell",
	"PS 死亡: .+>",
	"%*%*.+%*%*",
	"<iLvl>",
	("%-"):rep(30)}

local function genFilterList()
	local keywords = {string.split(" " or "")}
	for _, value in pairs(keywords) do
		if value ~= "" then
			if not FilterList[value] then
				FilterList[value] = true
			end
		end
	end
end

local function genChatFilter(_, event, msg, author, _, _, _, flag)

	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") then
		return
	elseif F.UnitInGuild(author) or UnitInRaid(author) or UnitInParty(author) then
		return
	elseif event == "CHAT_MSG_WHISPER" and flag == "GM" then
		return
	else
		for i = 1, GetNumFriends() do
			if author == GetFriendInfo(i) then return end
		end
		for i = 1, BNGetNumFriends() do
			local _, _, battleTag, _, charName, _, client = BNGetFriendInfo(i)
			if author == BNet_GetValidatedCharacterName(charName, battleTag, client) then return end
		end
	end

	for _, symbol in ipairs(FilterSymbols) do
		msg = gsub(msg, symbol, "")
	end

	local match = 0
	for keyword, _ in pairs(FilterList) do
		local _, count = gsub(msg, keyword, "")
		if count > 0 then
			match = match + 1
		end
	end

	if match >= FilterMatches then
		return true
	end
end

local function genAddonBlock(_, _, msg, author)
	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") then return end

	for _, word in ipairs(addonBlockList) do
		if msg:find(word) then
			return true
		end
	end
end


function ChatFilter()
	
	genFilterList()

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", genChatFilter)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", genAddonBlock)

end