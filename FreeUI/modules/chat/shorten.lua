local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('CHAT')


local gsub, strfind, strmatch = string.gsub, string.find, string.match
local BetterDate, time = BetterDate, time
local INTERFACE_ACTION_BLOCKED = INTERFACE_ACTION_BLOCKED


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
	local tbl = C.ClassColors[className]
	local color = ('%02x%02x%02x'):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

local function FormatBNPlayerName(misc, id, moreMisc, fakeName, tag, colon)
		local gameAccount = select(6, BNGetFriendInfoByID(id))
		if gameAccount then
			local _, charName, _, _, _, _, _, englishClass = BNGetGameAccountInfo(gameAccount)
			if englishClass and englishClass ~= '' then
				fakeName = '|cFF'..GetColor(englishClass, true)..fakeName..'|r'
			end
	end
	return misc..id..moreMisc..fakeName..tag..(colon == ':' and ':' or colon)
end

local function FormatPlayerName(info, name)
	return format('|Hplayer:%s|h%s|h', info, gsub(name, '%-[^|]+', ''))
end

local function RemoveRealmName(self, event, msg, author, ...)
	local realm = string.gsub(C.MyRealm, ' ', '')
	if msg:find('-' .. realm) then
		return false, gsub(msg, '%-'..realm, ''), author, ...
	end
end

function CHAT:UpdateChannelNames(text, ...)
	-- Make whisper color different
	local r, g, b = ...
	if strfind(text, L['CHAT_WHISPER_TELL']..' |H[BN]*player.+%]') then
		r, g, b = r*.7, g*.7, b*.7
	end

	if C.DB.chat.abbr_channel_names then
		-- Shorten world channel name
		text = gsub(text, '|h%[(%d+)%. 大脚世界频道%]|h', '|h%[世界%]|h')
		text = gsub(text, '|h%[(%d+)%. 大腳世界頻道%]|h', '|h%[世界%]|h')

		-- Shorten other channel name
		text = gsub(text, '|h%[(%d+)%. .-%]|h', '|h[%1]|h')
	end

	-- Remove brackets from player name
	text = gsub(text, '|Hplayer:(.-)|h%[(.-)%]|h', FormatPlayerName)
	--text = gsub(text, '(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)', FormatBNPlayerName)

	-- Remove brackets from item and spell links
	-- text = gsub(text, '|r|h:(.+)|cff(.+)|H(.+)|h%[(.+)%]|h|r', '|r|h:%1%4')

	return self.oldAddMsg(self, text, r, g, b)
end

function CHAT:Abbreviate()
	for i = 1, NUM_CHAT_WINDOWS do
		if i ~= 2 then
			local chatFrame = _G['ChatFrame'..i]
			chatFrame.oldAddMsg = chatFrame.AddMessage
			chatFrame.AddMessage = CHAT.UpdateChannelNames
		end
	end

	ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', RemoveRealmName)

	--online/offline info
	ERR_FRIEND_ONLINE_SS = gsub(ERR_FRIEND_ONLINE_SS, '%]%|h', ']|h|cff00c957')
	ERR_FRIEND_OFFLINE_S = gsub(ERR_FRIEND_OFFLINE_S, '%%s', '%%s|cffff7f50')

	--whisper
	CHAT_WHISPER_INFORM_GET = L['CHAT_WHISPER_TELL']..' %s '
	CHAT_WHISPER_GET = L['CHAT_WHISPER_FROM']..' %s '
	CHAT_BN_WHISPER_INFORM_GET = L['CHAT_WHISPER_TELL']..' %s '
	CHAT_BN_WHISPER_GET = L['CHAT_WHISPER_FROM']..' %s '

	--say / yell
	CHAT_SAY_GET = '%s '
	CHAT_YELL_GET = '%s '

	--guild
	CHAT_GUILD_GET = '|Hchannel:GUILD|h[G]|h %s '
	CHAT_OFFICER_GET = '|Hchannel:OFFICER|h[O]|h %s '

	--raid
	CHAT_RAID_GET = '|Hchannel:RAID|h[R]|h %s '
	CHAT_RAID_WARNING_GET = '[RW] %s '
	CHAT_RAID_LEADER_GET = '|Hchannel:RAID|h[RL]|h %s '

	--party
	CHAT_PARTY_GET = '|Hchannel:PARTY|h[P]|h %s '
	CHAT_PARTY_LEADER_GET =  '|Hchannel:PARTY|h[PL]|h %s '
	CHAT_PARTY_GUIDE_GET =  '|Hchannel:PARTY|h[PG]|h %s '

	--instance
	CHAT_INSTANCE_CHAT_GET = '|Hchannel:INSTANCE|h[I]|h %s '
	CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:INSTANCE|h[IL]|h %s '

	--flags
	CHAT_FLAG_AFK = '|cff808080[AFK]|r '
	CHAT_FLAG_DND = '|cff808080[DND]|r '
	CHAT_FLAG_GM = '|cffff0000[GM]|r '
end
