local F, C, L = unpack(select(2, ...))
if not C.chat.enable then return end
local module = F:GetModule('chat')

local strmatch, strfind = string.match, string.find
local format, gsub = string.format, string.gsub
local pairs, ipairs, tonumber = pairs, ipairs, tonumber

local FilterList = {}

function F:GenFilterList()
	F.SplitList(FilterList, C.chat.filterList, true)
end

local recent_msg = {}
local index = 1

local function genChatFilter(_, event, msg, author, _, _, _, flag, _, _, _, _, _, guid)
	if not C.chat.useFilter then return end

	local name = Ambiguate(author, 'none')

	if UnitIsUnit(name, 'player') or (event == 'CHAT_MSG_WHISPER' and flag == 'GM') or flag == 'DEV' then
		return
	elseif guid and (IsGuildMember(guid) or BNGetGameAccountInfoByGUID(guid) or IsCharacterFriend(guid) or IsGUIDInGroup(guid)) then
		return
	end

	-- filter repeat lines
	local sender = string.split('-', author)

	for i = 1, 4 do
		if recent_msg[i] and recent_msg[i]['sender'] == sender and recent_msg[i]['msg'] == msg then
			return true
		end
	end
	
	if index == 5 then
		index = 1
	end
	
	if not recent_msg[index] then
		recent_msg[index] = {}
	end
	
	recent_msg[index]['sender'] = sender
	recent_msg[index]['msg'] = msg
	
	index = index + 1

	-- filter symbols
	for _, symbol in ipairs(C.chat.symbols) do
		msg = gsub(msg, symbol, '')
	end

	-- filter keywords
	local match = 0
	for keyword in pairs(FilterList) do
		if keyword ~= '' then
			local _, count = gsub(msg, keyword, '')
			if count > 0 then
				match = match + 1
			end
		end
	end

	if match >= C.chat.keyWordMatch then
		return true
	end
end

local cvar
local function toggleCVar(value)
	value = tonumber(value) or 1
	SetCVar(cvar, value)
end

local function toggleBubble(party)
	cvar = "chatBubbles"..(party and "Party" or "")
	if not GetCVarBool(cvar) then return end
	toggleCVar(0)
	C_Timer.After(.01, toggleCVar)
end

-- filter spam from addons
local function genAddonBlock(_, event, msg, author)
	if not C.chat.blockAddonAlert then return end

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
	F:GenFilterList()

	ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', genChatFilter)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', genChatFilter)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', genChatFilter)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', genChatFilter)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", genChatFilter)

	ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', genAddonBlock)
	ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', genAddonBlock)

	F:RegisterEvent('PLAYER_ENTERING_WORLD', isPlayerOnIslands)
end