local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local split, strfind, strmatch, gmatch, gsub, sub = string.split, string.find, string.match, string.gmatch, string.gsub, string.sub
local pairs, ipairs, tonumber = pairs, ipairs, tonumber
local min, max, tremove = math.min, math.max, table.remove
local IsGuildMember, C_FriendList_IsFriend, IsGUIDInGroup, C_Timer_After = IsGuildMember, C_FriendList.IsFriend, IsGUIDInGroup, C_Timer.After
local Ambiguate, UnitIsUnit, BNGetGameAccountInfoByGUID, GetTime, SetCVar = Ambiguate, UnitIsUnit, BNGetGameAccountInfoByGUID, GetTime, SetCVar
local GetItemInfo, GetItemStats = GetItemInfo, GetItemStats
local LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR
local BN_TOAST_TYPE_CLUB_INVITATION = BN_TOAST_TYPE_CLUB_INVITATION or 6


-- Filter Chat symbols
local msgSymbols = {'`', '～', '＠', '＃', '^', '＊', '！', '？', '。', '|', ' ', '—', '——', '￥', '’', '‘', '“', '”', '【', '】', '『', '』', '《', '》', '〈', '〉', '（', '）', '〔', '〕', '、', '，', '：', ',', '_', '/', '~', '%-', '%.'}

local FilterList = {}
function CHAT:UpdateFilterList()
	F.SplitList(FilterList, C.chat.keywordsList, true)
end

-- ECF strings compare
local last, this = {}, {}
function CHAT:CompareStrDiff(sA, sB) -- arrays of bytes
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

C.BadBoys = {} -- debug
local chatLines, prevLineID, filterResult = {}, 0, false
function CHAT:GetFilterResult(event, msg, name, flag, guid)
	if name == C.Name or (event == 'CHAT_MSG_WHISPER' and flag == 'GM') or flag == 'DEV' then
		return
	elseif guid and (IsGuildMember(guid) or BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or (IsInInstance() and IsGUIDInGroup(guid))) then
		return
	end

	if C.BadBoys[name] and C.BadBoys[name] >= 5 then return true end

	local filterMsg = gsub(msg, '|H.-|h(.-)|h', '%1')
	filterMsg = gsub(filterMsg, '|c%x%x%x%x%x%x%x%x', '')
	filterMsg = gsub(filterMsg, '|r', '')

	-- Trash Filter
	for _, symbol in ipairs(msgSymbols) do
		filterMsg = gsub(filterMsg, symbol, '')
	end

	local matches = 0
	for keyword in pairs(FilterList) do
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

	-- ECF Repeat Filter
	local msgTable = {name, {}, GetTime()}
	if filterMsg == '' then filterMsg = msg end
	for i = 1, #filterMsg do
		msgTable[2][i] = filterMsg:byte(i)
	end
	local chatLinesSize = #chatLines
	chatLines[chatLinesSize+1] = msgTable
	for i = 1, chatLinesSize do
		local line = chatLines[i]
		if line[1] == msgTable[1] and ((msgTable[3] - line[3] < .6) or CHAT:CompareStrDiff(line[2], msgTable[2]) <= .1) then
			tremove(chatLines, i)
			return true
		end
	end
	if chatLinesSize >= 30 then tremove(chatLines, 1) end
end

function CHAT:UpdateChatFilter(event, msg, author, _, _, _, flag, _, _, _, _, lineID, guid)
	if lineID == 0 or lineID ~= prevLineID then
		prevLineID = lineID

		local name = Ambiguate(author, 'none')
		filterResult = CHAT:GetFilterResult(event, msg, name, flag, guid)
		if filterResult then C.BadBoys[name] = (C.BadBoys[name] or 0) + 1 end
	end

	return filterResult
end

-- Block addon msg
local addonBlockList = C.chat.addonBlockList

local cvar
local function toggleCVar(value)
	value = tonumber(value) or 1
	SetCVar(cvar, value)
end

function CHAT:ToggleChatBubble(party)
	cvar = 'chatBubbles'..(party and 'Party' or '')
	if not GetCVarBool(cvar) then return end
	toggleCVar(0)
	C_Timer_After(.01, toggleCVar)
end

function CHAT:UpdateAddOnBlocker(event, msg, author)
	local name = Ambiguate(author, 'none')
	if UnitIsUnit(name, 'player') then return end

	for _, word in ipairs(addonBlockList) do
		if strfind(msg, word) then
			if event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' then
				CHAT:ToggleChatBubble()
			elseif event == 'CHAT_MSG_PARTY' or event == 'CHAT_MSG_PARTY_LEADER' then
				CHAT:ToggleChatBubble(true)
			end
			return true
		end
	end
end

-- Block trash clubs
local trashClubs = {'站桩', '致敬我们'}
function CHAT:BlockTrashClub()
	if self.toastType == BN_TOAST_TYPE_CLUB_INVITATION then
		local text = self.DoubleLine:GetText() or ''
		for _, name in pairs(trashClubs) do
			if strfind(text, name) then
				self:Hide()
				return
			end
		end
	end
end

-- Filter azerite message on island expeditions
local azerite = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub('%%d/%%d ', '')
local function filterAzeriteGain(_, _, msg)
	if strfind(msg, azerite) then
		return true
	end
end

local function isPlayerOnIslands()
	local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
	if instanceType == 'scenario' and (maxPlayers == 3 or maxPlayers == 6) then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
	else
		ChatFrame_RemoveMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
	end
end


function CHAT:ChatFilter()
	if C.chat.filters then
		self:UpdateFilterList()
		ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_TEXT_EMOTE', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.UpdateChatFilter)
	end

	if C.chat.blockAddonAlert then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateAddOnBlocker)
	end

	hooksecurefunc(BNToastFrame, 'ShowToast', self.BlockTrashClub)

	F:RegisterEvent('PLAYER_ENTERING_WORLD', isPlayerOnIslands)
end