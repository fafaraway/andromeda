local F, C = unpack(select(2, ...))
local CHAT = F.CHAT

local firstLines = {
	'^Recount - (.*)$', --Recount
	'^Skada: (.*) for (.*):$', -- Skada enUS
	'^Skada: (.*) por (.*):$', -- Skada esES/ptBR
	'^Skada: (.*) für (.*):$', -- Skada deDE
	'^Skada: (.*) pour (.*):$', -- Skada frFR
	'^Skada: (.*) per (.*):$', -- Skada itIT
	'^(.*) ? Skada ?? (.*):$', -- Skada koKR
	'^Отчёт Skada: (.*), с (.*):$', -- Skada ruRU
	'^Skada??(.*)?(.*):$', -- Skada zhCN
	'^Skada:(.*)??(.*):$', -- Skada zhTW
	'^(.*) Done for (.*)$', -- TinyDPS
	'^Numeration: (.*)$', -- Numeration
	'^Details!:(.*)$' -- Details!
}

local nextLines = {
	'^(%d+)%. (.*)$', --Recount, Details! and Skada
	'^(.*)   (.*)$', --Additional Skada
	'^Numeration: (.*)$', -- Numeration
	'^[+-]%d+.%d', -- Numeration Deathlog Details
	'^(%d+). (.*):(.*)(%d+)(.*)(%d+)%%(.*)%((%d+)%)$', -- TinyDPS
	'^(.+) (%d-%.%d-%w)$', -- Skada 2
	'|c%x-|H.-|h(%[.-%])|h|r (%d-%.%d-%w %(%d-%.%d-%%%))' --Skada 3
}

local meters = {}

local events = {
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_GUILD',
	'CHAT_MSG_OFFICER',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_PARTY_LEADER',
	'CHAT_MSG_RAID',
	'CHAT_MSG_RAID_LEADER',
	'CHAT_MSG_INSTANCE_CHAT',
	'CHAT_MSG_INSTANCE_CHAT_LEADER',
	'CHAT_MSG_SAY',
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_WHISPER_INFORM',
	'CHAT_MSG_YELL'
}

local function FilterLine(event, source, message, ...)
	local spam = false
	for k, v in ipairs(nextLines) do
		if message:match(v) then
			local curTime = time()
			for i, j in ipairs(meters) do
				local elapsed = curTime - j.time
				if j.source == source and j.event == event and elapsed < 1 then
					local toInsert = true
					for a, b in ipairs(j.data) do
						if b == message then
							toInsert = false
						end
					end

					if toInsert then
						tinsert(j.data, message)
					end
					return true, false, nil
				end
			end
		end
	end

	for k, v in ipairs(firstLines) do
		local newID = 0
		if message:match(v) then
			local curTime = time()

			for i, j in ipairs(meters) do
				local elapsed = curTime - j.time
				if j.source == source and j.event == event and elapsed < 1 then
					newID = i
					return true, true, format('|HMergeSpamMeter:%1$d|h|cFFFFFF00[%2$s]|r|h', newID or 0, message or 'nil')
				end
			end

			tinsert(meters, {source = source, event = event, time = curTime, data = {}, title = message})

			for i, j in ipairs(meters) do
				if j.source == source and j.event == event and j.time == curTime then
					newID = i
				end
			end

			return true, true, format('|HMergeSpamMeter:%1$d|h|cFFFFFF00[%2$s]|r|h', newID or 0, message or 'nil')
		end
	end
	return false, false, nil
end

local orig2 = SetItemRef
function SetItemRef(link, text, button, frame)
	local linkType, id = strsplit(':', link)
	if linkType == 'MergeSpamMeter' then
		local meterID = tonumber(id)
		ShowUIPanel(_G.ItemRefTooltip)
		if not _G.ItemRefTooltip:IsShown() then
			_G.ItemRefTooltip:SetOwner(UIParent, 'ANCHOR_PRESERVE')
		end
		_G.ItemRefTooltip:ClearLines()
		_G.ItemRefTooltip:AddLine(meters[meterID].title)
		_G.ItemRefTooltip:AddLine(format(_G.BY_SOURCE .. ': %s', meters[meterID].source))
		for k, v in ipairs(meters[meterID].data) do
			local left, right = v:match('^(.*)  (.*)$')
			if left and right then
				_G.ItemRefTooltip:AddDoubleLine(left, right, 1, 1, 1, 1, 1, 1)
			else
				_G.ItemRefTooltip:AddLine(v, 1, 1, 1)
			end
		end
		_G.ItemRefTooltip:Show()
	else
		return orig2(link, text, button, frame)
	end
end

local function ParseChatEvent(self, event, message, sender, ...)
	for _, value in ipairs(events) do
		if event == value then
			local isRecount, isFirstLine, newMessage = FilterLine(event, sender, message)
			if isRecount then
				if isFirstLine then
					return false, newMessage, sender, ...
				else
					return true
				end
			end
		end
	end
end

function CHAT:DamageMeterFilter()
	for _, event in pairs(events) do
		ChatFrame_AddMessageEventFilter(event, ParseChatEvent)
	end
end
