local F, C, L = unpack(select(2, ...))
if not C.chat.enable then return end
local module = F:GetModule('chat')

local strmatch, strfind, format, gsub = string.match, string.find, string.format, string.gsub
local pairs, ipairs, tonumber = pairs, ipairs, tonumber
local min, max, tremove = math.min, math.max, table.remove
local IsGuildMember, C_FriendList_IsFriend, IsGUIDInGroup = IsGuildMember, C_FriendList.IsFriend, IsGUIDInGroup
local Ambiguate, UnitIsUnit, BNGetGameAccountInfoByGUID, GetTime = Ambiguate, UnitIsUnit, BNGetGameAccountInfoByGUID, GetTime

local filterList, chatLines, badBoys, prevLineID = {}, {}, {}, 0
local msgSymbols = {'`', '～', '＠', '＃', '^', '＊', '！', '？', '。', '|', ' ', '—', '——', '￥', '’', '‘', '“', '”', '【', '】', '『', '』', '《', '》', '〈', '〉', '（', '）', '〔', '〕', '、', '，', '：', ',', '_', '/', '~', '%-', '%.'}

function F:GenFilterList()
	F.SplitList(filterList, C.chat.filterList, true)
end

local last, this = {}, {}
local function strDiff(sA, sB) -- arrays of bytes
	local len_a, len_b = #sA, #sB
	for j = 0, len_b do
		last[j+1] = j
	end
	for i = 1, len_a do
		this[1] = i
		for j = 1, len_b do
			this[j+1] = (sA[i] == sB[j]) and last[j] or (min(last[j+1], this[j], last[j]) + 1)
		end
		for j = 0, len_b do
			last[j+1] = this[j+1]
		end
	end
	return this[len_b+1] / max(len_a, len_b)
end

local function genChatFilter(_, event, msg, author, _, _, _, flag, _, _, _, _, lineID, guid)
	if lineID ~= 0 and lineID == prevLineID then return end
	prevLineID = lineID

	local name = Ambiguate(author, 'none')
	if badBoys[name] and badBoys[name] > 5 then return true end

	if UnitIsUnit(name, 'player') or (event == 'CHAT_MSG_WHISPER' and flag == 'GM') or flag == 'DEV' then
		return
	elseif guid and (IsGuildMember(guid) or BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or IsGUIDInGroup(guid)) then
		return
	end

	local filterMsg = gsub(msg, '|H.-|h(.-)|h', '%1')
	filterMsg = gsub(filterMsg, '|c%x%x%x%x%x%x%x%x', '')
	filterMsg = gsub(filterMsg, '|r', '')

	-- filter trash
	for _, symbol in ipairs(msgSymbols) do
		filterMsg = gsub(filterMsg, symbol, '')
	end

	local matches = 0
	for keyword in pairs(filterList) do
		if keyword ~= '' then
			local _, count = gsub(filterMsg, keyword, '')
			if count > 0 then
				matches = matches + 1
			end
		end
	end

	if matches >= 1 then
		return true
	end

	-- filter repeat spam
	local msgTable = {name, {}, GetTime()}
	if filterMsg == '' then filterMsg = msg end
	for i = 1, #filterMsg do
		msgTable[2][i] = filterMsg:byte(i)
	end
	local chatLinesSize = #chatLines
	chatLines[chatLinesSize+1] = msgTable
	for i = 1, chatLinesSize do
		local line = chatLines[i]
		if line[1] == msgTable[1] and ((msgTable[3] - line[3] < .6) or strDiff(line[2], msgTable[2]) <= .1) then
			tremove(chatLines, i)
			badBoys[name] = (badBoys[name] or 0) + 1
			return true
		end
	end
	if chatLinesSize >= 30 then tremove(chatLines, 1) end
end

local cvar
local function toggleCVar(value)
	value = tonumber(value) or 1
	SetCVar(cvar, value)
end

local function toggleBubble(party)
	cvar = 'chatBubbles'..(party and 'Party' or '')
	if not GetCVarBool(cvar) then return end
	toggleCVar(0)
	C_Timer.After(.01, toggleCVar)
end

-- filter spam from addons
local function genAddonBlock(_, event, msg, author)
	local name = Ambiguate(author, 'none')
	if UnitIsUnit(name, 'player') then return end

	for _, word in ipairs(C.chat.addonBlockList) do
		if strfind(msg, word) then
			if event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' then
				toggleBubble()
			elseif event == 'CHAT_MSG_PARTY' or event == 'CHAT_MSG_PARTY_LEADER' then
				toggleBubble(true)
			end

			return true
		end
	end
end

-- filter azerite info while islands-ing
local azerite = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub('%%d/%%d ', '')
local function filterAzeriteGain(_, _, msg)
	if strfind(msg, azerite) then
		return true
	end
end

local function isPlayerOnIslands()
	local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
	if instanceType == 'scenario' and maxPlayers == 3 then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
	else
		ChatFrame_RemoveMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
	end
end




function module:ChatFilter()
	if C.chat.useFilter then
		F:GenFilterList()
		ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', genChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', genChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', genChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', genChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', genChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_TEXT_EMOTE', genChatFilter)
	end

	if C.chat.blockAddonAlert then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', genAddonBlock)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', genAddonBlock)
	end

	F:RegisterEvent('PLAYER_ENTERING_WORLD', isPlayerOnIslands)
end