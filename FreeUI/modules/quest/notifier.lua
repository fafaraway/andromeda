local F, C, L = unpack(select(2, ...))
local QUEST = F:GetModule('QUEST')


local completedQuest, initComplete = {}
local strmatch, strfind, gsub, format = string.match, string.find, string.gsub, string.format
local mod, tonumber, pairs, floor = mod, tonumber, pairs, math.floor
local soundKitID = SOUNDKIT.ALARM_CLOCK_WARNING_3
local QUEST_COMPLETE, LE_QUEST_TAG_TYPE_PROFESSION, LE_QUEST_FREQUENCY_DAILY = QUEST_COMPLETE, LE_QUEST_TAG_TYPE_PROFESSION, LE_QUEST_FREQUENCY_DAILY

local function acceptText(link, daily)
	if daily then
		return format('%s [%s]%s', L['QUEST_ACCEPT'], DAILY, link)
	else
		return format('%s %s', L['QUEST_ACCEPT'], link)
	end
end

local function completeText(link)
	if FreeDB.quest.complete_ring then
		PlaySound(soundKitID, 'Master')
	end

	return format('%s %s', link, QUEST_COMPLETE)
end

local function sendQuestMsg(msg)
	if not FreeDB.quest.quest_progress then return end

	if C.isDeveloper then
		F.Print(msg)
	elseif IsPartyLFG() then
		SendChatMessage(msg, 'INSTANCE_CHAT')
	elseif IsInRaid() then
		SendChatMessage(msg, 'RAID')
	elseif IsInGroup() and not IsInRaid() then
		SendChatMessage(msg, 'PARTY')
	end
end

local function getPattern(pattern)
	pattern = gsub(pattern, '%(', '%%%1')
	pattern = gsub(pattern, '%)', '%%%1')
	pattern = gsub(pattern, '%%%d?$?.', '(.+)')
	return format('^%s$', pattern)
end

local questMatches = {
	['Found'] = getPattern(ERR_QUEST_ADD_FOUND_SII),
	['Item'] = getPattern(ERR_QUEST_ADD_ITEM_SII),
	['Kill'] = getPattern(ERR_QUEST_ADD_KILL_SII),
	['PKill'] = getPattern(ERR_QUEST_ADD_PLAYER_KILL_SII),
	['ObjectiveComplete'] = getPattern(ERR_QUEST_OBJECTIVE_COMPLETE_S),
	['QuestComplete'] = getPattern(ERR_QUEST_COMPLETE_S),
	['QuestFailed'] = getPattern(ERR_QUEST_FAILED_S),
}

function QUEST:FindQuestProgress(_, msg)
	if not FreeDB.quest.quest_progress then return end

	for _, pattern in pairs(questMatches) do
		if strmatch(msg, pattern) then
			local _, _, _, cur, max = strfind(msg, '(.*)[:：]%s*([-%d]+)%s*/%s*([-%d]+)%s*$')
			cur, max = tonumber(cur), tonumber(max)
			if cur and max and max >= 10 then
				if mod(cur, floor(max/5)) == 0 then
					sendQuestMsg(msg)
				end
			else
				sendQuestMsg(msg)
			end
			break
		end
	end
end

function QUEST:FindQuestAccept(questLogIndex, questID)
	local link = GetQuestLink(questID)
	local frequency = select(7, GetQuestLogTitle(questLogIndex))
	if link then
		local tagID, _, worldQuestType = GetQuestTagInfo(questID)
		if tagID == 109 or worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION then return end
		sendQuestMsg(acceptText(link, frequency == LE_QUEST_FREQUENCY_DAILY))
	end
end

function QUEST:FindQuestComplete()
	for i = 1, GetNumQuestLogEntries() do
		local _, _, _, _, _, isComplete, _, questID = GetQuestLogTitle(i)
		local link = GetQuestLink(questID)
		local worldQuest = select(3, GetQuestTagInfo(questID))
		if link and isComplete and not completedQuest[questID] and not worldQuest then
			if initComplete then
				sendQuestMsg(completeText(link))
			else
				initComplete = true
			end
			completedQuest[questID] = true
		end
	end
end

function QUEST:FindWorldQuestComplete(questID)
	if QuestUtils_IsQuestWorldQuest(questID) then
		local link = GetQuestLink(questID)
		if link and not completedQuest[questID] then
			sendQuestMsg(completeText(link))
			completedQuest[questID] = true
		end
	end
end

function QUEST:QuestNotifier()
	--if FreeDB.quest.quest_progress then
		self:FindQuestComplete()
		F:RegisterEvent('QUEST_ACCEPTED', self.FindQuestAccept)
		F:RegisterEvent('QUEST_LOG_UPDATE', self.FindQuestComplete)
		F:RegisterEvent('QUEST_TURNED_IN', self.FindWorldQuestComplete)
		F:RegisterEvent('UI_INFO_MESSAGE', self.FindQuestProgress)
	-- else
	-- 	wipe(completedQuest)
	-- 	F:UnregisterEvent('QUEST_ACCEPTED', self.FindQuestAccept)
	-- 	F:UnregisterEvent('QUEST_LOG_UPDATE', self.FindQuestComplete)
	-- 	F:UnregisterEvent('QUEST_TURNED_IN', self.FindWorldQuestComplete)
	-- 	F:UnregisterEvent('UI_INFO_MESSAGE', self.FindQuestProgress)
	-- end
end
