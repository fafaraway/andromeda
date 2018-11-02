local F, C, L = unpack(select(2, ...))
local module = F:GetModule("chat")

local FilterList = {}

function F:GenFilterList()
	F.SplitList(FilterList, C.chat.filterList, true)
end

local function genChatFilter(_, event, msg, author, _, _, _, flag, _, _, _, _, _, guid)
	if not C.chat.enableFilter then return end

	local name = Ambiguate(author, "none")

	if UnitIsUnit(name, "player") or (event == "CHAT_MSG_WHISPER" and flag == "GM") or flag == "DEV" then
		return
	elseif IsGuildMember(guid) or BNGetGameAccountInfoByGUID(guid) or IsCharacterFriend(guid) or IsGUIDInGroup(guid) then
		return
	end

	-- filter symbols
	for _, symbol in ipairs(C.chat.symbols) do
		msg = gsub(msg, symbol, "")
	end

	-- filter keywords
	local match = 0
	for keyword in pairs(FilterList) do
		if keyword ~= "" then
			local _, count = gsub(msg, keyword, "")
			if count > 0 then
				match = match + 1
			end
		end
	end

	if match >= C.chat.keyWordMatch then
		return true
	end
end

local function restoreCVar(cvar)
	C_Timer.After(.01, function()
		SetCVar(cvar, 1)
	end)
end

local function toggleBubble(party)
	local cvar = "chatBubbles"..(party and "Party" or "")
	if not GetCVarBool(cvar) then return end
	SetCVar(cvar, 0)
	restoreCVar(cvar)
end

-- filter spam from addons
local function genAddonBlock(_, event, msg, author)
	if not C.chat.blockAddonAlert then return end

	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") then return end

	for _, word in ipairs(C.chat.addonBlockList) do
		if msg:find(word) then
			if event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" then
				toggleBubble()
			elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
				toggleBubble(true)
			end

			return true
		end
	end
end



-- filter auto invite from WQT
-- Credit: WorldQuestTrackerBlocker, Jordy141
local WQTUsers = {}
local inviteString = _G.ERR_INVITED_TO_GROUP_SS:gsub(".+|h", "")
local function blockInviteString(_, _, msg)
	if msg:find(inviteString) then
		local name = msg:match("%[(.+)%]")
		if WQTUsers[name] then
			return true
		end
	end
end
local function blockWhisperString(_, _, msg, author)
	local name = Ambiguate(author, "none")
	if msg:find("%[World Quest Tracker%]") or msg:find("一起做世界任务吧：") or msg:find("一起来做世界任务<") then
		if not WQTUsers[name] then
			WQTUsers[name] = true
		end
		return true
	end
end
local function hideInvitePopup(_, name)
	if WQTUsers[name] then
		StaticPopup_Hide("PARTY_INVITE")
	end
end

-- filter azerite info while islands-ing
local azerite = ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub("%%d/%%d ", "")
local function filterAzeriteGain(_, _, msg)
	if msg:find(azerite) then
		return true
	end
end

local function isPlayerOnIslands()
	local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
	if instanceType == "scenario" and maxPlayers == 3 then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterAzeriteGain)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", filterAzeriteGain)
	end
end




function module:ChatFilter()
	F:GenFilterList()

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", genChatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", genChatFilter)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", genAddonBlock)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", genAddonBlock)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", blockInviteString)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", blockWhisperString)
	F:RegisterEvent("PARTY_INVITE_REQUEST", hideInvitePopup)

	F:RegisterEvent("PLAYER_ENTERING_WORLD", isPlayerOnIslands)
end